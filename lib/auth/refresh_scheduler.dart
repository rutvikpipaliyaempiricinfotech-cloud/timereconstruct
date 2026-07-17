import 'dart:async';

import '../config/supabase_config.dart';
import 'session_manager.dart';
import 'session_store.dart';

/// Schedules a refresh shortly before the access token lapses.
///
/// This is a plain Dart Timer, so it only advances while the isolate is being
/// scheduled. Once the OS suspends the process the timer stops counting, and a
/// deadline that falls inside a suspension simply never arrives. There is no
/// catch-up on the far side beyond whatever the lifecycle observer does.
class RefreshScheduler {
  RefreshScheduler(this._store, this._manager);

  final SessionStore _store;
  final SessionManager _manager;

  Timer? _timer;

  bool get isScheduled => _timer?.isActive ?? false;

  void schedule() {
    _timer?.cancel();

    final expiry = _store.expiresAt;
    if (expiry == null) return;

    final fireAt = expiry.subtract(SupabaseConfig.refreshLead);
    final delay = fireAt.difference(DateTime.now().toUtc());

    if (delay.isNegative) {
      unawaited(_refreshNow());
      return;
    }

    _timer = Timer(delay, _refreshNow);
  }

  Future<void> _refreshNow() async {
    await _manager.refresh();
    schedule();
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
