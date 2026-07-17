import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper so the repositories are not each reaching for the global.
class SupabaseGateway {
  SupabaseGateway(this._client);

  final SupabaseClient _client;

  /// Every read goes out through here. The Authorization header is resolved by
  /// the accessToken callback wired up in main.dart, per request.
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    int? limit,
  }) async {
    final query = _client.from(table).select(columns);
    final rows = limit == null ? await query : await query.limit(limit);
    return List<Map<String, dynamic>>.from(rows as List);
  }
}
