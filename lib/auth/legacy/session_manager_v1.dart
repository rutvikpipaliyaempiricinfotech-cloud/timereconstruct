import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/supabase_config.dart';
import '../session_store.dart';

/// The original manager, from before the tab rewrite.
///
/// Retained for the migration path in tools/migrate_session.dart. Not wired
/// into the running app, see main.dart for what is actually constructed.
@Deprecated('Superseded by SessionManager. Kept for the migration tool.')
class SessionManagerV1 {
  SessionManagerV1(this._store, {http.Client? client})
      : _http = client ?? http.Client();

  final SessionStore _store;
  final http.Client _http;

  /// One in-flight refresh at a time. Callers that arrive while a refresh is
  /// running wait on the same future rather than posting again, which keeps us
  /// from burning a rotated refresh token.
  Completer<bool>? _inFlight;

  Future<bool> refresh() {
    final existing = _inFlight;
    if (existing != null) return existing.future;

    final completer = Completer<bool>();
    _inFlight = completer;

    _doRefresh().then((ok) {
      _inFlight = null;
      completer.complete(ok);
    }).catchError((Object error) {
      _inFlight = null;
      completer.complete(false);
    });

    return completer.future;
  }

  Future<bool> _doRefresh() async {
    final token = _store.refreshToken;
    if (token == null) return false;

    final response = await _http.post(
      Uri.parse(SupabaseConfig.tokenEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'apikey': SupabaseConfig.publishableKey,
      },
      body: jsonEncode({'refresh_token': token}),
    );

    if (response.statusCode != 200) {
      await _store.clear();
      return false;
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    await _store.save(
      accessToken: body['access_token'] as String,
      refreshToken: body['refresh_token'] as String,
      expiresAt: DateTime.now()
          .toUtc()
          .add(Duration(seconds: body['expires_in'] as int)),
    );
    return true;
  }
}
