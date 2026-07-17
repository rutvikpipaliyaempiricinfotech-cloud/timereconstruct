import '../supabase_gateway.dart';

/// Backs Explore. `public_posts` is the curated feed and is meant to be
/// readable without an account, so its policy does not look at the caller.
class PublicPostsRepository {
  PublicPostsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> trending({int limit = 25}) => _gateway
      .select('public_posts', columns: 'id,title,body,author_handle,created_at', limit: limit);
}
