import '../utils/clock.dart';

/// Short-lived in-memory cache of read responses.
///
/// Cuts the reload flicker when someone bounces between tabs. A hit inside the
/// window is served without touching the network at all, so the freshness of
/// the caller's session is not consulted on that path.
class ResponseCache {
  ResponseCache({Clock? clock, this.ttl = const Duration(minutes: 5)})
      : _clock = clock ?? Clock.system;

  final Clock _clock;
  final Duration ttl;
  final Map<String, _Entry> _entries = {};

  List<Map<String, dynamic>>? get(String key) {
    final entry = _entries[key];
    if (entry == null) return null;
    if (_clock.nowUtc().isAfter(entry.storedAt.add(ttl))) {
      _entries.remove(key);
      return null;
    }
    return entry.rows;
  }

  void put(String key, List<Map<String, dynamic>> rows) {
    _entries[key] = _Entry(rows, _clock.nowUtc());
  }

  void invalidate(String key) => _entries.remove(key);

  void clear() => _entries.clear();

  int get size => _entries.length;
}

class _Entry {
  _Entry(this.rows, this.storedAt);

  final List<Map<String, dynamic>> rows;
  final DateTime storedAt;
}
