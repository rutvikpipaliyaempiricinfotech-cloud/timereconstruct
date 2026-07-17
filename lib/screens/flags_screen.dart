import 'package:flutter/material.dart';

import '../data/repositories/feature_flags_repository.dart';
import '../widgets/empty_state.dart';

class FlagsScreen extends StatefulWidget {
  const FlagsScreen({super.key, required this.repository});

  final FeatureFlagsRepository repository;

  @override
  State<FlagsScreen> createState() => _FlagsScreenState();
}

class _FlagsScreenState extends State<FlagsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.all();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature flags')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const EmptyState(message: 'No flags');
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
