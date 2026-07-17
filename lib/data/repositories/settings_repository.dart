import '../../models/user_settings.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs Settings.
class SettingsRepository {
  SettingsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<UserSettings>>> forUser() async {
    try {
      final rows = await _gateway.select(
        'settings',
        columns: 'user_id,locale,push_enabled,theme',
        limit: 1,
        cached: false,
      );
      return Ok(rows.map(UserSettings.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
