import 'package:flutter/material.dart';

import '../data/repositories/profiles_repository.dart';
import '../models/profile.dart';
import '../state/auth_state.dart';
import '../utils/result.dart';
import '../widgets/avatar.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_banner.dart';
import '../widgets/loading_indicator.dart';

/// The one screen wired to the auth state during the tab rewrite. It notices a
/// cleared session and says so rather than just going quiet like the rest.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.repository,
    required this.authState,
  });

  final ProfilesRepository repository;
  final AuthStateNotifier authState;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Result<List<Profile>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.me();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: AnimatedBuilder(
        animation: widget.authState,
        builder: (context, _) {
          final signedOut = widget.authState.status == AuthStatus.cleared;
          return Column(
            children: [
              if (signedOut)
                const ErrorBanner(
                  message: 'Your session ended. Sign in again to continue.',
                ),
              Expanded(
                child: FutureBuilder<Result<List<Profile>>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LoadingIndicator();
                    }
                    final result = snapshot.data;
                    if (result == null) {
                      return const EmptyState(message: 'Profile unavailable');
                    }
                    return result.when(
                      ok: (profiles) => profiles.isEmpty
                          ? const EmptyState(message: 'Profile unavailable')
                          : ListTile(
                              leading: Avatar(
                                url: profiles.first.avatarUrl,
                                fallback: profiles.first.displayName,
                              ),
                              title: Text(profiles.first.displayName),
                              subtitle: Text('@${profiles.first.handle}'),
                            ),
                      failed: (_) => const EmptyState(message: 'Profile unavailable'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
