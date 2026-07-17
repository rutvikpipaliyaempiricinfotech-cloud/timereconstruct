import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.url, required this.fallback, this.radius = 20});

  final String? url;
  final String fallback;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) {
      return CircleAvatar(
        radius: radius,
        child: Text(fallback.isEmpty ? '?' : fallback.characters.first.toUpperCase()),
      );
    }
    return CircleAvatar(radius: radius, backgroundImage: NetworkImage(url));
  }
}
