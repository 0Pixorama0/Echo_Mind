import 'package:flutter/material.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/app_shell.dart';
import 'theme/app_theme.dart';

class EchoMindApp extends StatelessWidget {
  const EchoMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const RootGate(),
    );
  }
}

/// Decides between onboarding and the main app. For the scaffold this is an
/// in-memory flag; the real app persists consent + age-gate acknowledgment.
class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> {
  bool _onboarded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _onboarded
          ? const AppShell()
          : OnboardingScreen(
              onComplete: () => setState(() => _onboarded = true),
            ),
    );
  }
}
