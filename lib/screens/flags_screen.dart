import 'package:flutter/material.dart';

import '../data/repositories/feature_flags_repository.dart';
import '../models/feature_flag.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class FlagsScreen extends StatefulWidget {
  const FlagsScreen({super.key, required this.repository});

  final FeatureFlagsRepository repository;

  @override
  State<FlagsScreen> createState() => _FlagsScreenState();
}

class _FlagsScreenState extends State<FlagsScreen> {
  late Future<Result<List<FeatureFlag>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.all();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.all());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature flags')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<FeatureFlag>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'No flags');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'No flags')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].key)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'No flags'),
            );
          },
        ),
      ),
    );
  }
}
