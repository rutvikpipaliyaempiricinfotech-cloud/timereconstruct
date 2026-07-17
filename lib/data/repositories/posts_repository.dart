import '../../models/post.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs the Feed. Rows in posts are owned, the policy matches on user_id. Cached, so a quick tab bounce does not re-read.
class PostsRepository {
  PostsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<Post>>> timeline() async {
    try {
      final rows = await _gateway.select(
        'posts',
        columns: 'id,user_id,body,created_at',
        limit: 40,
        cached: true,
      );
      return Ok(rows.map(Post.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
