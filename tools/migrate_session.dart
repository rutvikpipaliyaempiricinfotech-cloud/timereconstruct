// One-shot migration for devices still holding a v1 session blob.
//
// Run by hand against a debug build, not part of the app. This is the only
// caller of SessionManagerV1 left, which is why the class is still in the tree.
//
//   dart run tools/migrate_session.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timereconstruct/auth/legacy/session_manager_v1.dart';
import 'package:timereconstruct/auth/session_store.dart';

Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();
  final store = SessionStore(prefs);
  await store.load();

  if (!store.hasSession) {
    // ignore: avoid_print
    print('nothing to migrate');
    return;
  }

  // ignore: deprecated_member_use_from_same_package
  final legacy = SessionManagerV1(store);
  final ok = await legacy.refresh();

  // ignore: avoid_print
  print(ok ? 'migrated' : 'refresh rejected, user must sign in again');
}
