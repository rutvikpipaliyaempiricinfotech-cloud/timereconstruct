import 'session_manager.dart';
import 'session_store.dart';

/// Handed to SupabaseClient as its `accessToken` callback.
///
/// Worth knowing: supplying this callback takes over from the SDK entirely.
/// SupabaseClient._getAccessToken() returns this the moment it is non-null and
/// never reaches auth.getSession(), so GoTrue's own expiry check and its
/// refresh de-duplication are both out of the picture. Whatever this returns is
/// what goes on the wire.
class TokenProvider {
  TokenProvider(this._store, this._manager);

  final SessionStore _store;
  final SessionManager _manager;

  Future<String?> call() async {
    if (!_store.hasSession) {
      // Returning null makes the client send the publishable key instead, so
      // the request lands as an anonymous one.
      return null;
    }

    if (_store.isExpired) {
      // Kick a refresh off and let the caller through. Whoever comes back
      // first repopulates the store for the next request.
      unawaited(_manager.refresh());
      return null;
    }

    return _store.accessToken;
  }
}

void unawaited(Future<void> future) {}
