import 'logger.dart';

/// Fire and forget. Swallows its own failures on purpose, an analytics outage
/// should never take a screen down with it.
class Analytics {
  Analytics({Logger? logger}) : _log = logger ?? const Logger('analytics');

  final Logger _log;
  final List<String> _sent = [];

  List<String> get sent => List.unmodifiable(_sent);

  void screen(String name) => _track('screen:$name');
  void event(String name, {Map<String, Object?> props = const {}}) =>
      _track(props.isEmpty ? name : '$name ${props.keys.join(",")}');

  void _track(String line) {
    _sent.add(line);
    _log.debug(line);
  }
}
