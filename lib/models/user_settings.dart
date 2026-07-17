import '../utils/json.dart';

class UserSettings {
  const UserSettings({
    required this.userId,
    required this.locale,
    required this.pushEnabled,
    required this.theme,
  });

  final String userId;
  final String locale;
  final bool pushEnabled;
  final String theme;

  factory UserSettings.fromJson(Map<String, dynamic> map) => UserSettings(
        userId: Json.str(map, 'user_id'),
        locale: Json.str(map, 'locale', fallback: 'en'),
        pushEnabled: Json.boolOf(map, 'push_enabled', fallback: true),
        theme: Json.str(map, 'theme', fallback: 'system'),
      );
}
