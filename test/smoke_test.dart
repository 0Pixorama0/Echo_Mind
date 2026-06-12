import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:echomind/app.dart';
import 'package:echomind/core/safety.dart';

void main() {
  testWidgets('App boots into onboarding', (tester) async {
    await tester.pumpWidget(const EchoMindApp());
    expect(find.text('EchoMind'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  test('Placeholder classifier flags demo crisis keywords as L3', () {
    const c = PlaceholderSafetyClassifier();
    expect(c.classify('rough day at work'), SafetyLevel.l1Normal);
    expect(c.classify('I want to die'), SafetyLevel.l3Crisis);
  });
}
