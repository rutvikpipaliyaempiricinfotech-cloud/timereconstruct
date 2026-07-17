import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => MaterialBanner(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onRetry ?? () {},
            child: const Text('Retry'),
          ),
        ],
      );
}
