import 'package:flutter/widgets.dart';

import '../auth/refresh_scheduler.dart';

/// Keeps the refresh timer in step with the app being foregrounded.
///
/// Note we do not touch Supabase.instance.client.auth.startAutoRefresh() or
/// stopAutoRefresh(). Our scheduler owns refreshing, and running both would
/// mean two things chasing the same refresh token.
class AppLifecycleObserver with WidgetsBindingObserver {
  AppLifecycleObserver(this._scheduler);

  final RefreshScheduler _scheduler;

  void attach() => WidgetsBinding.instance.addObserver(this);
  void detach() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _scheduler.cancel();
      case AppLifecycleState.resumed:
        // Reschedules against whatever the store says now. If the token lapsed
        // while we were away this turns into an immediate refresh, which races
        // whatever the screens fire off in their own initState.
        _scheduler.schedule();
      case AppLifecycleState.inactive:
        break;
    }
  }
}
