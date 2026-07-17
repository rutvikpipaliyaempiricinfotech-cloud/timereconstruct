/// Injectable now(). Tests replace it, everything else uses the default so a
/// timer and a token expiry are always compared against the same clock.
abstract class Clock {
  DateTime nowUtc();

  static Clock system = const _SystemClock();
}

class _SystemClock implements Clock {
  const _SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

class FixedClock implements Clock {
  FixedClock(this._now);

  DateTime _now;

  void advance(Duration by) => _now = _now.add(by);

  @override
  DateTime nowUtc() => _now;
}
