import 'package:flutter/material.dart';

import '../data/repositories/settings_repository.dart';
import '../widgets/empty_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.repository});

  final SettingsRepository repository;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.forUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const EmptyState(message: 'Settings unavailable');
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
