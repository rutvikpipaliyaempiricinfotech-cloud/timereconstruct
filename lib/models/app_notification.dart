import '../utils/json.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.kind,
    this.readAt,
    this.createdAt,
  });

  final int id;
  final String userId;
  final String kind;
  final DateTime? readAt;
  final DateTime? createdAt;

  bool get isUnread => readAt == null;

  factory AppNotification.fromJson(Map<String, dynamic> map) => AppNotification(
        id: Json.intOf(map, 'id'),
        userId: Json.str(map, 'user_id'),
        kind: Json.str(map, 'kind'),
        readAt: Json.dateOrNull(map, 'read_at'),
        createdAt: Json.dateOrNull(map, 'created_at'),
      );
}
