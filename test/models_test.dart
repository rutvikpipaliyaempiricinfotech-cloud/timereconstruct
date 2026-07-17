import 'package:flutter_test/flutter_test.dart';
import 'package:timereconstruct/models/app_notification.dart';
import 'package:timereconstruct/models/comment.dart';
import 'package:timereconstruct/models/post.dart';
import 'package:timereconstruct/models/profile.dart';

void main() {
  test('Post reads the columns the repository asks for', () {
    final post = Post.fromJson({
      'id': 7,
      'user_id': '11111111-1111-1111-1111-111111111111',
      'body': 'hello',
      'created_at': '2026-01-01T12:00:00Z',
    });

    expect(post.id, 7);
    expect(post.body, 'hello');
    expect(post.createdAt?.isUtc, isTrue);
  });

  test('a missing column falls back rather than throwing', () {
    final profile = Profile.fromJson({'id': 'abc'});
    expect(profile.handle, isEmpty);
    expect(profile.avatarUrl, isNull);
  });

  test('a null read_at means unread', () {
    final unread = AppNotification.fromJson({'id': 1, 'kind': 'mention'});
    final read = AppNotification.fromJson({
      'id': 2,
      'kind': 'reply',
      'read_at': '2026-01-01T12:00:00Z',
    });

    expect(unread.isUnread, isTrue);
    expect(read.isUnread, isFalse);
  });

  test('Comment keeps the parent post id', () {
    final comment = Comment.fromJson({'id': 3, 'post_id': 42, 'body': 'nice'});
    expect(comment.postId, 42);
  });
}
