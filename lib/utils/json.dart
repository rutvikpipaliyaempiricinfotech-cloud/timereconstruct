/// Small readers so every model does not repeat the same casts.
class Json {
  const Json._();

  static String str(Map<String, dynamic> map, String key, {String fallback = ''}) {
    final value = map[key];
    return value is String ? value : fallback;
  }

  static String? strOrNull(Map<String, dynamic> map, String key) {
    final value = map[key];
    return value is String ? value : null;
  }

  static int intOf(Map<String, dynamic> map, String key, {int fallback = 0}) {
    final value = map[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static bool boolOf(Map<String, dynamic> map, String key, {bool fallback = false}) {
    final value = map[key];
    return value is bool ? value : fallback;
  }

  static DateTime? dateOrNull(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is! String) return null;
    return DateTime.tryParse(value)?.toUtc();
  }
}
