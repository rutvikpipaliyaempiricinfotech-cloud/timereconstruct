import '../../models/public_post.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs Explore. The curated feed is meant to be readable without an account. Cached the same way the Feed is.
class PublicPostsRepository {
  PublicPostsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<PublicPost>>> trending() async {
    try {
      final rows = await _gateway.select(
        'public_posts',
        columns: 'id,title,body,author_handle,created_at',
        limit: 25,
        cached: true,
      );
      return Ok(rows.map(PublicPost.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
