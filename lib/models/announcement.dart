import '../utils/json.dart';

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.startsAt,
    this.endsAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime? startsAt;
  final DateTime? endsAt;

  factory Announcement.fromJson(Map<String, dynamic> map) => Announcement(
        id: Json.intOf(map, 'id'),
        title: Json.str(map, 'title'),
        body: Json.str(map, 'body'),
        startsAt: Json.dateOrNull(map, 'starts_at'),
        endsAt: Json.dateOrNull(map, 'ends_at'),
      );
}
