import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../auth/session_manager.dart';
import '../auth/session_store.dart';

/// Retries a refresh once the connection comes back, so a flap during a
/// refresh does not leave the app sitting on a lapsed token.
class ConnectivityMonitor {
  ConnectivityMonitor(this._store, this._manager);

  final SessionStore _store;
  final SessionManager _manager;

  StreamSubscription<List<ConnectivityResult>>? _sub;

  void start() {
    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (!online) return;
      if (!_store.hasSession) return;
      if (!_store.isExpired) return;
      _manager.refresh();
    });
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }
}
