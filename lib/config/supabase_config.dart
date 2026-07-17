/// Project wiring. Real values are injected at build time with --dart-define,
/// never committed. See README.
class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://YOUR_PROJECT_REF.supabase.co',
  );

  /// Publishable (anon) key. Safe for clients, still not committed.
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'YOUR_PUBLISHABLE_KEY',
  );

  /// Mirrors the JWT expiry configured on the project. Kept here because the
  /// refresh scheduler needs it and we do not want a round trip just to learn it.
  static const Duration accessTokenLifetime = Duration(seconds: 3600);

  /// How far ahead of expiry we try to refresh.
  static const Duration refreshLead = Duration(seconds: 60);

  static String get tokenEndpoint => '$url/auth/v1/token?grant_type=refresh_token';
}
