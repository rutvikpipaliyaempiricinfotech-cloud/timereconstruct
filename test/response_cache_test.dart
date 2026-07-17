import 'package:flutter_test/flutter_test.dart';
import 'package:timereconstruct/services/response_cache.dart';
import 'package:timereconstruct/utils/clock.dart';

void main() {
  test('a hit inside the window comes back', () {
    final clock = FixedClock(DateTime.utc(2026, 1, 1, 12));
    final cache = ResponseCache(clock: clock, ttl: const Duration(minutes: 5));

    cache.put('posts', [
      {'id': 1}
    ]);
    clock.advance(const Duration(minutes: 4));

    expect(cache.get('posts'), isNotNull);
  });

  test('past the window it is dropped', () {
    final clock = FixedClock(DateTime.utc(2026, 1, 1, 12));
    final cache = ResponseCache(clock: clock, ttl: const Duration(minutes: 5));

    cache.put('posts', [
      {'id': 1}
    ]);
    clock.advance(const Duration(minutes: 6));

    expect(cache.get('posts'), isNull);
    expect(cache.size, 0);
  });

  test('invalidate removes one key and leaves the rest', () {
    final cache = ResponseCache();
    cache.put('posts', [
      {'id': 1}
    ]);
    cache.put('public_posts', [
      {'id': 2}
    ]);

    cache.invalidate('posts');

    expect(cache.get('posts'), isNull);
    expect(cache.get('public_posts'), isNotNull);
  });
}
