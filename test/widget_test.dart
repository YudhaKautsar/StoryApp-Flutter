// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter/core/session_controller.dart';
import 'package:story_app_flutter/core/story.dart';
import 'package:story_app_flutter/core/story_api.dart';
import 'package:story_app_flutter/main.dart';

void main() {
  testWidgets('system back from register returns to login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const StoryApp());
    await tester.pumpAndSettle();

    expect(find.text('Senang melihatmu.'), findsOneWidget);
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Mulai bercerita.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Senang melihatmu.'), findsOneWidget);
  });

  test('parses a story returned by the API', () {
    final story = Story.fromJson({
      'id': 'story-1',
      'name': 'Ayu',
      'description': 'Pagi di tepi pantai.',
      'photoUrl': 'https://example.com/story.jpg',
      'createdAt': '2026-09-28T08:30:00.000Z',
    });

    expect(story.id, 'story-1');
    expect(story.name, 'Ayu');
    expect(story.description, 'Pagi di tepi pantai.');
    expect(story.photoUrl, 'https://example.com/story.jpg');
    expect(story.createdAt, DateTime.utc(2026, 9, 28, 8, 30));
  });

  test('fetches newest stories first', () async {
    final client = MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer token');
      return http.Response(
        jsonEncode({
          'listStory': [
            {
              'id': 'older',
              'name': 'Ayu',
              'description': 'Kemarin',
              'photoUrl': '',
              'createdAt': '2026-09-27T08:30:00.000Z',
            },
            {
              'id': 'newer',
              'name': 'Bima',
              'description': 'Hari ini',
              'photoUrl': '',
              'createdAt': '2026-09-28T08:30:00.000Z',
            },
          ],
        }),
        200,
      );
    });

    final stories = await StoryApi(client: client).fetchStories('token');

    expect(stories.map((story) => story.id), ['newer', 'older']);
  });

  test('restores language preference and clears the session', () async {
    SharedPreferences.setMockInitialValues({});
    final session = SessionController();
    addTearDown(session.dispose);

    await session.restore();
    await session.saveSession(token: 'session-token', name: 'Ayu');
    await session.changeLanguage('en');

    final restoredSession = SessionController();
    addTearDown(restoredSession.dispose);
    await restoredSession.restore();

    expect(restoredSession.token, 'session-token');
    expect(restoredSession.languageCode, 'en');

    await restoredSession.clearSession();
    expect(restoredSession.token, isNull);
  });
}
