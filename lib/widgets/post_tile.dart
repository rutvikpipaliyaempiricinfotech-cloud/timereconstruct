import 'package:flutter/material.dart';

import '../models/post.dart';

class PostTile extends StatelessWidget {
  const PostTile(this.post, {super.key});

  final Post post;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(post.body),
        subtitle: post.createdAt == null ? null : Text('${post.createdAt}'),
      );
}
