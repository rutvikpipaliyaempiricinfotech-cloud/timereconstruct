import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/auth_events.dart';
import '../data/repositories/profiles_repository.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_banner.dart';

/// The one screen that was migrated onto the auth bus during the tab rewrite.
/// It notices a cleared session and says so instead of just going quiet.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.repository,
    required this.events,
  });

  final ProfilesRepository repository;
  final AuthEvents events;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Map<String, dynamic>>> _future;
  StreamSubscription<AuthEvent>? _sub;
  bool _signedOut = false;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.me();
    _sub = widget.events.stream.listen((event) {
      if (event == AuthEvent.cleared && mounted) {
        setState(() => _signedOut = true);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Column(
        children: [
          if (_signedOut)
            const ErrorBanner(message: 'Your session ended. Sign in again to continue.'),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snapshot.data ?? const <Map<String, dynamic>>[];
                if (rows.isEmpty) {
                  return const EmptyState(message: 'Profile unavailable');
                }
                return ListTile(title: Text(rows.first['display_name'].toString()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
