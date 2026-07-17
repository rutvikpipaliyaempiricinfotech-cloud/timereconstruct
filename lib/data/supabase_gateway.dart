import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/logger.dart';
import '../services/response_cache.dart';

/// Every read goes out through here.
///
/// The Authorization header is not set here. It is resolved per request by the
/// accessToken callback wired up in main.dart, so by the time a call lands in
/// this class the decision about what identity it carries has already been made
/// somewhere else.
class SupabaseGateway {
  SupabaseGateway(
    this._client, {
    ResponseCache? cache,
    Logger? logger,
  })  : _cache = cache ?? ResponseCache(),
        _log = logger ?? const Logger('gateway');

  final SupabaseClient _client;
  final ResponseCache _cache;
  final Logger _log;

  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    int? limit,
    bool cached = false,
  }) async {
    if (cached) {
      final hit = _cache.get(table);
      if (hit != null) {
        // Served straight from memory. No request goes out, so nothing about
        // the current session is checked on this path.
        _log.debug('cache hit for $table');
        return hit;
      }
    }

    final builder = _client.from(table).select(columns);
    final dynamic raw = limit == null ? await builder : await builder.limit(limit);
    final rows = (raw as List).cast<Map<String, dynamic>>();

    if (cached) _cache.put(table, rows);
    return rows;
  }

  void invalidate(String table) => _cache.invalidate(table);
}
