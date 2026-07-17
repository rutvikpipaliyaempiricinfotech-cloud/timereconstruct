import '../../models/feature_flag.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs the debug flags screen. Flags are not secret, the table is open.
class FeatureFlagsRepository {
  FeatureFlagsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<FeatureFlag>>> all() async {
    try {
      final rows = await _gateway.select(
        'feature_flags',
        columns: 'key,enabled,rollout',
        
        cached: false,
      );
      return Ok(rows.map(FeatureFlag.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
