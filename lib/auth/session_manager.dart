import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/supabase_config.dart';
import 'auth_events.dart';
import 'session_store.dart';

/// Talks to the token endpoint directly rather than going through
/// GoTrueClient.refreshSession(). We moved to this when we needed the refresh
/// to survive a client rebuild during the tab rewrite.
class SessionManager {
  SessionManager(this._store, this._events, {http.Client? client})
      : _http = client ?? http.Client();

  final SessionStore _store;
  final AuthEvents _events;
  final http.Client _http;

  /// Every caller that gets here posts. Two screens waking up together produce
  /// two posts with the same refresh token.
  Future<bool> refresh() async {
    final token = _store.refreshToken;
    if (token == null) return false;

    late final http.Response response;
    try {
      response = await _http.post(
        Uri.parse(SupabaseConfig.tokenEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'apikey': SupabaseConfig.publishableKey,
        },
        body: jsonEncode({'refresh_token': token}),
      );
    } catch (_) {
      // Offline, or the flap caught us mid-post. Keep the session, the next
      // request will come back through here.
      _events.emit(AuthEvent.refreshFailed);
      return false;
    }

    if (response.statusCode != 200) {
      // 400 here is the interesting one. It covers an already-rotated token,
      // which is what a second post with the same token gets once rotation and
      // reuse detection are both on.
      await _store.clear();
      _events.emit(AuthEvent.cleared);
      return false;
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final expiresIn = body['expires_in'] as int? ??
        SupabaseConfig.accessTokenLifetime.inSeconds;

    await _store.save(
      accessToken: body['access_token'] as String,
      refreshToken: body['refresh_token'] as String,
      expiresAt: DateTime.now().toUtc().add(Duration(seconds: expiresIn)),
    );
    _events.emit(AuthEvent.refreshed);
    return true;
  }
}
