import 'package:flutter/material.dart';

import '../data/repositories/comments_repository.dart';
import '../models/comment.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.repository});

  final CommentsRepository repository;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future<Result<List<Comment>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.forThread();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.forThread());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<Comment>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'No comments');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'No comments')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].body)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'No comments'),
            );
          },
        ),
      ),
    );
  }
}
