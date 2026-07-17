import 'logger.dart';

class CrashReporter {
  CrashReporter({Logger? logger}) : _log = logger ?? const Logger('crash');

  final Logger _log;

  void recordError(Object error, StackTrace? stack, {String? reason}) {
    _log.error(reason ?? 'unhandled', error);
  }

  /// Breadcrumbs only, never the token itself.
  void leaveBreadcrumb(String message) => _log.debug('crumb: $message');
}
