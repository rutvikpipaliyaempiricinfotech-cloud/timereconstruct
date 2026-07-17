import 'package:flutter/material.dart';

import '../data/repositories/notifications_repository.dart';
import '../widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.repository});

  final NotificationsRepository repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.unread();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const EmptyState(message: 'You are all caught up');
          }
          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(rows[i].values.first.toString()),
            ),
          );
        },
      ),
    );
  }
}
