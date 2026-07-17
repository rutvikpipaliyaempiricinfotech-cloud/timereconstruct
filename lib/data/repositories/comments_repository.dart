import '../../models/comment.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs the comment thread. The policy lets a caller through either as the author or because the parent post is public, so what comes back depends on which of those still holds.
class CommentsRepository {
  CommentsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<Comment>>> forThread() async {
    try {
      final rows = await _gateway.select(
        'comments',
        columns: 'id,post_id,author_id,body,created_at',
        limit: 100,
        cached: false,
      );
      return Ok(rows.map(Comment.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
