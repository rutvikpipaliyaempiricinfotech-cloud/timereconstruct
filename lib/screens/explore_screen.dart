import 'package:flutter/material.dart';

import '../data/repositories/public_posts_repository.dart';
import '../models/public_post.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.repository});

  final PublicPostsRepository repository;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<Result<List<PublicPost>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.trending();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.trending());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<PublicPost>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'Nothing trending');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'Nothing trending')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].title)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'Nothing trending'),
            );
          },
        ),
      ),
    );
  }
}
