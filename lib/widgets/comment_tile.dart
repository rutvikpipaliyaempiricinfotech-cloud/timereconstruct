import 'package:flutter/material.dart';

import '../models/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile(this.comment, {super.key});

  final Comment comment;

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        title: Text(comment.body),
        subtitle: Text('on post ${comment.postId}'),
      );
}
