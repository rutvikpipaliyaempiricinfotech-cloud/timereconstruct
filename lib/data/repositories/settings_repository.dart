import '../supabase_gateway.dart';

class SettingsRepository {
  SettingsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> forUser() =>
      _gateway.select('settings', columns: 'user_id,locale,push_enabled,theme', limit: 1);
}
