import 'package:flutter/material.dart';

import '../data/repositories/notifications_repository.dart';
import '../models/app_notification.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.repository});

  final NotificationsRepository repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<Result<List<AppNotification>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.unread();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.unread());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<AppNotification>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'You are all caught up');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'You are all caught up')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].kind)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'You are all caught up'),
            );
          },
        ),
      ),
    );
  }
}
