import 'package:flutter/material.dart';

import '../data/repositories/announcements_repository.dart';
import '../data/repositories/comments_repository.dart';
import '../data/repositories/feature_flags_repository.dart';
import '../data/repositories/notifications_repository.dart';
import '../data/repositories/posts_repository.dart';
import '../data/repositories/profiles_repository.dart';
import '../data/repositories/public_posts_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/supabase_gateway.dart';
import '../screens/announcements_screen.dart';
import '../screens/comments_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/flags_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../services/analytics.dart';
import '../state/auth_state.dart';

class Routes {
  const Routes._();

  static const feed = '/';
  static const profile = '/profile';
  static const notifications = '/notifications';
  static const explore = '/explore';
  static const comments = '/comments';
  static const settings = '/settings';
  static const announcements = '/announcements';
  static const flags = '/flags';
}

class AppRouter {
  AppRouter({
    required this.gateway,
    required this.authState,
    required this.analytics,
  });

  final SupabaseGateway gateway;
  final AuthStateNotifier authState;
  final Analytics analytics;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    analytics.screen(settings.name ?? 'unknown');

    return switch (settings.name) {
      Routes.feed => _page(FeedScreen(repository: PostsRepository(gateway))),
      Routes.profile => _page(ProfileScreen(
          repository: ProfilesRepository(gateway),
          authState: authState,
        )),
      Routes.notifications =>
        _page(NotificationsScreen(repository: NotificationsRepository(gateway))),
      Routes.explore =>
        _page(ExploreScreen(repository: PublicPostsRepository(gateway))),
      Routes.comments =>
        _page(CommentsScreen(repository: CommentsRepository(gateway))),
      Routes.settings =>
        _page(SettingsScreen(repository: SettingsRepository(gateway))),
      Routes.announcements =>
        _page(AnnouncementsScreen(repository: AnnouncementsRepository(gateway))),
      Routes.flags =>
        _page(FlagsScreen(repository: FeatureFlagsRepository(gateway))),
      _ => null,
    };
  }

  MaterialPageRoute<dynamic> _page(Widget child) =>
      MaterialPageRoute<dynamic>(builder: (_) => child);
}
