import 'package:flutter/material.dart';

import '../data/repositories/announcements_repository.dart';
import '../models/announcement.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key, required this.repository});

  final AnnouncementsRepository repository;

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late Future<Result<List<Announcement>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.live();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.live());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<Announcement>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'No announcements');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'No announcements')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].title)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'No announcements'),
            );
          },
        ),
      ),
    );
  }
}
