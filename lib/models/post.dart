import '../utils/json.dart';

class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.body,
    this.createdAt,
  });

  final int id;
  final String userId;
  final String body;
  final DateTime? createdAt;

  factory Post.fromJson(Map<String, dynamic> map) => Post(
        id: Json.intOf(map, 'id'),
        userId: Json.str(map, 'user_id'),
        body: Json.str(map, 'body'),
        createdAt: Json.dateOrNull(map, 'created_at'),
      );
}
