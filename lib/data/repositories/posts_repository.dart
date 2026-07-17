import '../supabase_gateway.dart';

/// Backs the Feed. Rows in `posts` are owned, the policy matches on user_id.
class PostsRepository {
  PostsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> timeline({int limit = 40}) =>
      _gateway.select('posts', columns: 'id,user_id,body,created_at', limit: limit);
}
