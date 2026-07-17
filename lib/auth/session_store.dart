import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Cached copy of the session. We keep our own rather than reading through
/// GoTrue every time, because the profile screen hammers this on scroll.
class SessionStore {
  SessionStore(this._prefs);

  static const _key = 'tr.session.v2';

  final SharedPreferences _prefs;

  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiresAt;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  DateTime? get expiresAt => _expiresAt;

  bool get hasSession => _accessToken != null && _refreshToken != null;

  /// True once the access token is past its expiry. No grace, no skew.
  bool get isExpired {
    final expiry = _expiresAt;
    if (expiry == null) return true;
    return !DateTime.now().toUtc().isBefore(expiry);
  }

  Future<void> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    _accessToken = map['access_token'] as String?;
    _refreshToken = map['refresh_token'] as String?;
    final exp = map['expires_at'] as int?;
    _expiresAt = exp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(exp, isUtc: true);
  }

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expiresAt = expiresAt;
    await _prefs.setString(
      _key,
      jsonEncode({
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_at': expiresAt.millisecondsSinceEpoch,
      }),
    );
  }

  /// Drops everything. Nothing is broadcast from here, callers decide.
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _expiresAt = null;
    await _prefs.remove(_key);
  }
}
