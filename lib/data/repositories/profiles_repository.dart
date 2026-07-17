import '../supabase_gateway.dart';

/// Backs Profile. `profiles` is keyed by the auth user id itself.
class ProfilesRepository {
  ProfilesRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> me() =>
      _gateway.select('profiles', columns: 'id,handle,display_name,avatar_url', limit: 1);
}
