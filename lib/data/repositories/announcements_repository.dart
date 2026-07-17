import '../supabase_gateway.dart';

/// Backs Announcements. The policy gates on the caller's role rather than on
/// a user id, so it is not scoped per person, only to signed-in callers.
class AnnouncementsRepository {
  AnnouncementsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> live({int limit = 10}) => _gateway
      .select('announcements', columns: 'id,title,body,starts_at,ends_at', limit: limit);
}
