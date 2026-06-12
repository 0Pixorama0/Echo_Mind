import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:echomind/app.dart';
import 'package:echomind/core/models.dart';
import 'package:echomind/core/safety.dart';
import 'package:echomind/screens/crisis/crisis_help_screen.dart';
import 'package:echomind/screens/dashboard/pattern_dashboard_screen.dart';
import 'package:echomind/screens/home/home_screen.dart';
import 'package:echomind/widgets/mood_selector.dart';

/// Smoke tests: verify each network-free screen builds and key interactions
/// work. (Reflect/Ask call the backend on init, so they're exercised manually
/// or via integration tests rather than here.)
Widget _host(Widget child) => MaterialApp(home: child);

void main() {
  testWidgets('App boots into onboarding', (tester) async {
    await tester.pumpWidget(const EchoMindApp());
    expect(find.text('EchoMind'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Onboarding gates the final Start button until consent is given',
      (tester) async {
    await tester.pumpWidget(const EchoMindApp());

    // Advance through the three consent pages.
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }

    final startBtn = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Start journaling'),
        matching: find.byType(FilledButton),
      ),
    );
    // Disabled until the age + consent checkboxes are ticked.
    expect(startBtn.onPressed, isNull);
  });

  testWidgets('Home shows the "not a therapist" disclaimer', (tester) async {
    await tester.pumpWidget(_host(const HomeScreen()));
    expect(find.textContaining('not a therapist'), findsWidgets);
  });

  testWidgets('Crisis screen lists both helplines', (tester) async {
    await tester.pumpWidget(_host(const CrisisHelpScreen()));
    expect(find.text('iCall'), findsOneWidget);
    expect(find.textContaining('Vandrevala'), findsOneWidget);
    expect(find.textContaining('9152987821'), findsOneWidget);
  });

  testWidgets('Pattern dashboard builds with themes', (tester) async {
    await tester.pumpWidget(_host(const PatternDashboardScreen()));
    expect(find.text('Recurring themes'), findsOneWidget);
    expect(find.text('Work pressure'), findsOneWidget);
  });

  testWidgets('Mood selector reports the tapped mood', (tester) async {
    Mood? picked;
    await tester.pumpWidget(
      _host(
        Scaffold(
          body: MoodSelector(selected: null, onChanged: (m) => picked = m),
        ),
      ),
    );
    await tester.tap(find.text('Good'));
    expect(picked, Mood.good);
  });

  test('Placeholder classifier flags demo crisis keywords as L3', () {
    const c = PlaceholderSafetyClassifier();
    expect(c.classify('rough day at work'), SafetyLevel.l1Normal);
    expect(c.classify('I want to die'), SafetyLevel.l3Crisis);
  });
}
