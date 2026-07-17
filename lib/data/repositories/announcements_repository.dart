import '../../models/announcement.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs Announcements. The policy gates on the caller role rather than on a user id, so it is not scoped per person, only to signed-in callers.
class AnnouncementsRepository {
  AnnouncementsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<Announcement>>> live() async {
    try {
      final rows = await _gateway.select(
        'announcements',
        columns: 'id,title,body,starts_at,ends_at',
        limit: 10,
        cached: false,
      );
      return Ok(rows.map(Announcement.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
