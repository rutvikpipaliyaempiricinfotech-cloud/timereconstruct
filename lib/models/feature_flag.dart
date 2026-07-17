import '../utils/json.dart';

class FeatureFlag {
  const FeatureFlag({
    required this.key,
    required this.enabled,
    required this.rollout,
  });

  final String key;
  final bool enabled;
  final int rollout;

  factory FeatureFlag.fromJson(Map<String, dynamic> map) => FeatureFlag(
        key: Json.str(map, 'key'),
        enabled: Json.boolOf(map, 'enabled'),
        rollout: Json.intOf(map, 'rollout'),
      );
}
