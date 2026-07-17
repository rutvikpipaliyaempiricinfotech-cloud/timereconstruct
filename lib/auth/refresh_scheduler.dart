import 'dart:async';

import '../config/supabase_config.dart';
import 'session_manager.dart';
import 'session_store.dart';

/// Schedules a refresh shortly before the access token lapses.
///
/// This is a plain Dart Timer. It runs on the isolate's event loop, so it only
/// fires while the process is actually being scheduled. Once the OS suspends
/// the app the timer stops advancing, and a wall-clock deadline that passes
/// while suspended simply never arrives.
class RefreshScheduler {
  RefreshScheduler(this._store, this._manager);

  final SessionStore _store;
  final SessionManager _manager;

  Timer? _timer;

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

void unawaited(Future<void> future) {}
