import '../supabase_gateway.dart';

/// Backs the comment thread. The policy lets a caller through either as the
/// author or because the parent post is one of the public ones, so what comes
/// back depends on which of those still holds.
class CommentsRepository {
  CommentsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> forThread({int limit = 100}) => _gateway
      .select('comments', columns: 'id,post_id,author_id,body,created_at', limit: limit);
}
