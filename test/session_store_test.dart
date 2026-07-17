import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timereconstruct/auth/session_store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<SessionStore> makeStore() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionStore(prefs);
  }

  test('a fresh store has no session and reads as expired', () async {
    final store = await makeStore();
    expect(store.hasSession, isFalse);
    expect(store.isExpired, isTrue);
  });

  test('a saved session survives a reload', () async {
    final store = await makeStore();
    await store.save(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

    final reloaded = await makeStore();
    await reloaded.load();

    expect(reloaded.hasSession, isTrue);
    expect(reloaded.accessToken, 'access');
    expect(reloaded.isExpired, isFalse);
  });

  test('an expiry in the past reads as expired, with no grace window', () async {
    final store = await makeStore();
    await store.save(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(seconds: 1)),
    );
    expect(store.isExpired, isTrue);
  });

  test('clear drops everything', () async {
    final store = await makeStore();
    await store.save(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
    await store.clear();
    expect(store.hasSession, isFalse);
    expect(store.accessToken, isNull);
  });
}
