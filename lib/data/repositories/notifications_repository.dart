import '../../models/app_notification.dart';
import '../../utils/result.dart';
import '../supabase_gateway.dart';

/// Backs Notifications. Polled on resume, so it tends to be first out of the gate once the app comes back.
class NotificationsRepository {
  NotificationsRepository(this._gateway);

  final SupabaseGateway _gateway;

  Future<Result<List<AppNotification>>> unread() async {
    try {
      final rows = await _gateway.select(
        'notifications',
        columns: 'id,user_id,kind,read_at,created_at',
        limit: 50,
        cached: false,
      );
      return Ok(rows.map(AppNotification.fromJson).toList());
    } catch (error) {
      return Failed(error);
    }
  }
}
