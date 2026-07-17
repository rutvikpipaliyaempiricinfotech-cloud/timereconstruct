import '../utils/json.dart';

class Profile {
  const Profile({
    required this.id,
    required this.handle,
    required this.displayName,
    this.avatarUrl,
  });

  final String id;
  final String handle;
  final String displayName;
  final String? avatarUrl;

  factory Profile.fromJson(Map<String, dynamic> map) => Profile(
        id: Json.str(map, 'id'),
        handle: Json.str(map, 'handle'),
        displayName: Json.str(map, 'display_name'),
        avatarUrl: Json.strOrNull(map, 'avatar_url'),
      );
}
