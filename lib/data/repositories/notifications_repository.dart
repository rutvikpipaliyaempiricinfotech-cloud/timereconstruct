import '../supabase_gateway.dart';

/// Backs Notifications. Polled on resume, which is why it tends to be first
/// out of the gate after the app comes back.
class NotificationsRepository {
  NotificationsRepository(this._gateway);
  final SupabaseGateway _gateway;

  Future<List<Map<String, dynamic>>> unread({int limit = 50}) => _gateway
      .select('notifications', columns: 'id,user_id,kind,read_at,created_at', limit: limit);
}
