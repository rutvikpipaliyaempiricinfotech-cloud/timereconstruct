import 'dart:async';

import 'session_manager.dart';
import 'session_store.dart';

/// Handed to SupabaseClient as its `accessToken` callback.
///
/// Worth knowing what supplying this does: SupabaseClient._getAccessToken()
/// returns whatever this gives back the moment the callback is non-null, and
/// never reaches auth.getSession(). GoTrue's own expiry check and its refresh
/// de-duplication both sit behind that call, so neither is in play here.
/// Whatever this returns is what goes on the wire.
class TokenProvider {
  TokenProvider(this._store, this._manager);

  final SessionStore _store;
  final SessionManager _manager;

  Future<String?> call() async {
    if (!_store.hasSession) {
      // Null makes the client fall back to the publishable key, so the request
      // lands as an anonymous one rather than failing.
      return null;
    }

    if (_store.isExpired) {
      // Kick a refresh off and let this caller through. Whoever gets back
      // first repopulates the store for the next request.
      unawaited(_manager.refresh());
      return null;
    }

    return _store.accessToken;
  }
}
