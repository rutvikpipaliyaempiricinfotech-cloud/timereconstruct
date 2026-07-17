import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'auth/auth_events.dart';
import 'auth/refresh_scheduler.dart';
import 'auth/session_manager.dart';
import 'auth/session_store.dart';
import 'auth/token_provider.dart';
import 'config/supabase_config.dart';
import 'data/supabase_gateway.dart';
import 'lifecycle/app_lifecycle_observer.dart';
import 'lifecycle/connectivity_monitor.dart';
import 'routing/app_router.dart';
import 'services/analytics.dart';
import 'services/logger.dart';
import 'services/response_cache.dart';
import 'state/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const log = Logger('boot');

  final prefs = await SharedPreferences.getInstance();
  final store = SessionStore(prefs);
  await store.load();

  final events = AuthEvents();

  final manager = SessionManager(store, events);
  final scheduler = RefreshScheduler(store, manager);
  final tokenProvider = TokenProvider(store, manager);

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
    accessToken: tokenProvider.call,
  );

  final gateway = SupabaseGateway(
    Supabase.instance.client,
    cache: ResponseCache(),
    logger: const Logger('gateway'),
  );

  final authState = AuthStateNotifier(store, events);
  final analytics = Analytics();

  AppLifecycleObserver(scheduler).attach();
  ConnectivityMonitor(store, manager).start();
  scheduler.schedule();

  log.info('boot complete, session=${store.hasSession}');

  runApp(TimeReconstructApp(
    router: AppRouter(
      gateway: gateway,
      authState: authState,
      analytics: analytics,
    ),
  ));
}
