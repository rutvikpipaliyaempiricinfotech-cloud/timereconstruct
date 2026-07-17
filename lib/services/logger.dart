import 'dart:developer' as developer;

enum LogLevel { debug, info, warn, error }

class Logger {
  const Logger(this.tag);

  final String tag;

  void debug(String message) => _emit(LogLevel.debug, message);
  void info(String message) => _emit(LogLevel.info, message);
  void warn(String message) => _emit(LogLevel.warn, message);
  void error(String message, [Object? cause]) =>
      _emit(LogLevel.error, cause == null ? message : '$message: $cause');

  void _emit(LogLevel level, String message) {
    developer.log(message, name: '${level.name}/$tag');
  }
}
