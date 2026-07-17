import 'package:flutter/foundation.dart';

import '../auth/auth_events.dart';
import '../auth/session_store.dart';

enum AuthStatus { unknown, active, lapsed, cleared }

/// Exposes the session for anything that cares to watch. Only Profile does.
class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier(this._store, this._events) {
    _events.stream.listen(_onEvent);
    _recompute();
  }

  final SessionStore _store;
  final AuthEvents _events;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  void _onEvent(AuthEvent event) {
    switch (event) {
      case AuthEvent.cleared:
        _set(AuthStatus.cleared);
      case AuthEvent.refreshed:
        _set(AuthStatus.active);
      case AuthEvent.refreshFailed:
        _recompute();
    }
  }

  void _recompute() {
    if (!_store.hasSession) {
      _set(AuthStatus.cleared);
    } else if (_store.isExpired) {
      _set(AuthStatus.lapsed);
    } else {
      _set(AuthStatus.active);
    }
  }

  void _set(AuthStatus next) {
    if (_status == next) return;
    _status = next;
    notifyListeners();
  }
}
