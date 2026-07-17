import 'package:flutter/material.dart';

import 'auth/auth_events.dart';
import 'data/repositories/announcements_repository.dart';
import 'data/repositories/comments_repository.dart';
import 'data/repositories/feature_flags_repository.dart';
import 'data/repositories/notifications_repository.dart';
import 'data/repositories/posts_repository.dart';
import 'data/repositories/profiles_repository.dart';
import 'data/repositories/public_posts_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/supabase_gateway.dart';
import 'screens/announcements_screen.dart';
import 'screens/comments_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/flags_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

class TimeReconstructApp extends StatelessWidget {
  const TimeReconstructApp({
    super.key,
    required this.gateway,
    required this.events,
  });

  final SupabaseGateway gateway;
  final AuthEvents events;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'timereconstruct',
      routes: {
        '/': (_) => FeedScreen(repository: PostsRepository(gateway)),
        '/profile': (_) =>
            ProfileScreen(repository: ProfilesRepository(gateway), events: events),
        '/notifications': (_) =>
            NotificationsScreen(repository: NotificationsRepository(gateway)),
        '/explore': (_) => ExploreScreen(repository: PublicPostsRepository(gateway)),
        '/comments': (_) => CommentsScreen(repository: CommentsRepository(gateway)),
        '/settings': (_) => SettingsScreen(repository: SettingsRepository(gateway)),
        '/announcements': (_) =>
            AnnouncementsScreen(repository: AnnouncementsRepository(gateway)),
        '/flags': (_) => FlagsScreen(repository: FeatureFlagsRepository(gateway)),
      },
    );
  }
}
