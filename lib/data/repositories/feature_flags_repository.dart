import '../supabase_gateway.dart';

/// Backs the debug flags screen. Flags are not secret, the table is open.
class FeatureFlagsRepository {
  FeatureFlagsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> all() =>
      _gateway.select('feature_flags', columns: 'key,enabled,rollout');
}
