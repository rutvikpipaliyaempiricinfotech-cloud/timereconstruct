import 'package:flutter/material.dart';

import '../data/repositories/settings_repository.dart';
import '../models/user_settings.dart';
import '../utils/result.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.repository});

  final SettingsRepository repository;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<Result<List<UserSettings>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.forUser();
  }

  Future<void> _reload() async {
    setState(() => _future = widget.repository.forUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<Result<List<UserSettings>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingIndicator();
            }
            final result = snapshot.data;
            if (result == null) return const EmptyState(message: 'Settings unavailable');
            return result.when(
              ok: (items) => items.isEmpty
                  ? const EmptyState(message: 'Settings unavailable')
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) =>
                          ListTile(title: Text(items[i].locale)),
                    ),
              // Nothing is shown to the user here beyond the same empty copy.
              failed: (_) => const EmptyState(message: 'Settings unavailable'),
            );
          },
        ),
      ),
    );
  }
}
