import 'package:flutter/material.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';

class TimeReconstructApp extends StatelessWidget {
  const TimeReconstructApp({super.key, required this.router});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'timereconstruct',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: Routes.feed,
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
