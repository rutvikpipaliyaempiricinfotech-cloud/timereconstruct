import '../utils/json.dart';

class PublicPost {
  const PublicPost({
    required this.id,
    required this.title,
    required this.body,
    required this.authorHandle,
    this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final String authorHandle;
  final DateTime? createdAt;

  factory PublicPost.fromJson(Map<String, dynamic> map) => PublicPost(
        id: Json.intOf(map, 'id'),
        title: Json.str(map, 'title'),
        body: Json.str(map, 'body'),
        authorHandle: Json.str(map, 'author_handle'),
        createdAt: Json.dateOrNull(map, 'created_at'),
      );
}
