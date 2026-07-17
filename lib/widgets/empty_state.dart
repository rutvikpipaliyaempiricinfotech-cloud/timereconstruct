import 'package:flutter/material.dart';

/// What a screen shows when its query comes back with nothing.
///
/// Deliberately quiet. An empty list is a normal thing for a new account to
/// see, so this does not imply anything went wrong.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.message = 'Nothing here yet'});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      );
}
