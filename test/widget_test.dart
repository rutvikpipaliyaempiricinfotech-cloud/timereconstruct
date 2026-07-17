import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timereconstruct/models/comment.dart';
import 'package:timereconstruct/models/post.dart';
import 'package:timereconstruct/widgets/avatar.dart';
import 'package:timereconstruct/widgets/comment_tile.dart';
import 'package:timereconstruct/widgets/empty_state.dart';
import 'package:timereconstruct/widgets/error_banner.dart';
import 'package:timereconstruct/widgets/post_tile.dart';

Future<void> pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  testWidgets('EmptyState shows its message and nothing else', (tester) async {
    await pump(tester, const EmptyState(message: 'No posts yet'));

    expect(find.text('No posts yet'), findsOneWidget);
    // The point of this widget: it says nothing about why the list is empty.
    expect(find.byType(ErrorBanner), findsNothing);
  });

  testWidgets('ErrorBanner surfaces its message with a retry', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ErrorBanner(
          message: 'Your session ended.',
          onRetry: () => tapped = true,
        ),
      ),
    ));

    expect(find.text('Your session ended.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(tapped, isTrue);
  });

  testWidgets('PostTile renders the body', (tester) async {
    await pump(
      tester,
      PostTile(Post.fromJson(const {'id': 1, 'user_id': 'u', 'body': 'hello'})),
    );
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('CommentTile names its parent post', (tester) async {
    await pump(
      tester,
      CommentTile(
        Comment.fromJson(const {'id': 2, 'post_id': 42, 'author_id': 'u', 'body': 'nice'}),
      ),
    );
    expect(find.text('nice'), findsOneWidget);
    expect(find.text('on post 42'), findsOneWidget);
  });

  testWidgets('Avatar falls back to an initial when there is no url', (tester) async {
    await pump(tester, const Avatar(fallback: 'Rutvik P'));
    expect(find.text('R'), findsOneWidget);
  });
}
