import '../../models/profile.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs Profile. profiles is keyed by the auth user id itself.
class ProfilesRepository {
  ProfilesRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<Profile>>> me() async {
    try {
      final rows = await _gateway.select(
        'profiles',
        columns: 'id,handle,display_name,avatar_url',
        limit: 1,
        cached: false,
      );
      return Ok(rows.map(Profile.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
