import 'package:flutter_test/flutter_test.dart';
import 'package:timereconstruct/utils/result.dart';

void main() {
  test('Ok routes to the ok branch', () {
    const result = Ok<List<int>>([1, 2]);
    final length = result.when(ok: (v) => v.length, failed: (_) => -1);
    expect(length, 2);
  });

  test('Failed routes to the failed branch', () {
    final Result<List<int>> result = Failed<List<int>>(StateError('boom'));
    final length = result.when(ok: (v) => v.length, failed: (_) => -1);
    expect(length, -1);
  });

  test('an empty Ok is not distinguishable from a filtered-out read', () {
    const Result<List<int>> result = Ok<List<int>>([]);
    final shown = result.when(ok: (v) => v.isEmpty ? 'empty' : 'rows', failed: (_) => 'error');
    expect(shown, 'empty');
  });
}
