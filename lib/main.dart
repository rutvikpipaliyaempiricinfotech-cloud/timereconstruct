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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final store = SessionStore(prefs);
  await store.load();

  final events = AuthEvents();
  final manager = SessionManager(store, events);
  final scheduler = RefreshScheduler(store, manager);
  final tokenProvider = TokenProvider(store, manager);

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.publishableKey,
    // Handing our own provider in. From here the SDK asks us for the token on
    // every request and does not consult its own session.
    accessToken: tokenProvider.call,
  );

  final gateway = SupabaseGateway(Supabase.instance.client);

  AppLifecycleObserver(scheduler).attach();
  ConnectivityMonitor(store, manager).start();
  scheduler.schedule();

  runApp(TimeReconstructApp(gateway: gateway, events: events));
}
