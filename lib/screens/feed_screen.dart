import 'package:flutter/material.dart';

import '../data/repositories/posts_repository.dart';
import '../models/post.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.repository});

  final PostsRepository repository;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<Result<List<Post>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.timeline();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.timeline());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<Post>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'No posts yet');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'No posts yet')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].body)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'No posts yet'),
            );
          },
        ),
      ),
    );
  }
}
