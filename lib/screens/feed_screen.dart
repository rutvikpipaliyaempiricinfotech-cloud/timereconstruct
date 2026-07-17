import 'package:flutter/material.dart';

import '../data/repositories/posts_repository.dart';
import '../widgets/empty_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.repository});

  final PostsRepository repository;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.timeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const EmptyState(message: 'No posts yet');
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
