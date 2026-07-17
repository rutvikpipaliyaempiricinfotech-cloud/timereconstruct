import 'package:flutter/material.dart';

import '../data/repositories/comments_repository.dart';
import '../widgets/empty_state.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.repository});

  final CommentsRepository repository;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.forThread();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const EmptyState(message: 'No comments');
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
