import 'dart:async';

enum AuthEvent { refreshed, refreshFailed, cleared }

/// Our own bus. Predates the move to supabase_flutter and the screens were
/// never migrated onto onAuthStateChange, so most of them do not listen here.
class AuthEvents {
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream => _controller.stream;

  void emit(AuthEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  void dispose() => _controller.close();
}
