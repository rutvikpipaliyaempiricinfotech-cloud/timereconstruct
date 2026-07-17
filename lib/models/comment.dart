import '../utils/json.dart';

class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.body,
    this.createdAt,
  });

  final int id;
  final int postId;
  final String authorId;
  final String body;
  final DateTime? createdAt;

  factory Comment.fromJson(Map<String, dynamic> map) => Comment(
        id: Json.intOf(map, 'id'),
        postId: Json.intOf(map, 'post_id'),
        authorId: Json.str(map, 'author_id'),
        body: Json.str(map, 'body'),
        createdAt: Json.dateOrNull(map, 'created_at'),
      );
}
