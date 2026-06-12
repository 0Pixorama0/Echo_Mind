import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';

/// Multi-step consent onboarding. Per the SOW, signup requires explicit
/// acknowledgment of data handling, AI limitations, safety disclaimers, and an
/// 18+ age gate before the app opens.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool _ageOk = false;
  bool _consentData = false;
  bool _consentLimits = false;

  static const _lastPage = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canFinish => _ageOk && _consentData && _consentLimits;

  void _next() {
    if (_page < _lastPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    } else if (_canFinish) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          maxWidth: 560,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.gutter),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _ProgressDots(count: _lastPage + 1, active: _page),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _page = i),
                    children: [
                      const _WelcomePage(),
                      _ConsentPage(
                        icon: Icons.lock_outline,
                        title: 'Your words stay yours',
                        body:
                            'Your journal entries are encrypted and stored on '
                            'your phone. Only irreversible mathematical '
                            'representations (embeddings) ever reach the cloud '
                            '— never your raw text.',
                        checkboxLabel:
                            'I understand how my data is handled.',
                        value: _consentData,
                        onChanged: (v) =>
                            setState(() => _consentData = v ?? false),
                      ),
                      _ConsentPage(
                        icon: Icons.psychology_alt_outlined,
                        title: 'What EchoMind is — and isn\'t',
                        body:
                            'EchoMind helps you reflect and notice patterns. '
                            'It is not a therapist, not a medical tool, and '
                            'not a crisis service. If you\'re in distress, '
                            'EchoMind will point you to professional help.',
                        checkboxLabel:
                            'I understand EchoMind is not a substitute for '
                            'professional care.',
                        value: _consentLimits,
                        onChanged: (v) =>
                            setState(() => _consentLimits = v ?? false),
                      ),
                      _ConsentPage(
                        icon: Icons.verified_user_outlined,
                        title: 'One more thing',
                        body:
                            'EchoMind is for adults. Crisis resources are '
                            'available from every screen, any time, via the '
                            'Help button.',
                        checkboxLabel: 'I am 18 years or older.',
                        value: _ageOk,
                        onChanged: (v) =>
                            setState(() => _ageOk = v ?? false),
                      ),
                    ],
                  ),
                ),
                _BottomBar(
                  isLast: _page == _lastPage,
                  enabled: _page == _lastPage ? _canFinish : true,
                  onNext: _next,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.sage.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.spa_outlined, size: 32),
        ),
        const SizedBox(height: 24),
        Text('EchoMind',
            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text(
          'A private journal that helps you understand your week and notice '
          'patterns in your work and life.',
          style: text.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

class _ConsentPage extends StatelessWidget {
  const _ConsentPage({
    required this.icon,
    required this.title,
    required this.body,
    required this.checkboxLabel,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String body;
  final String checkboxLabel;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 20),
        Text(title,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Text(body, style: text.bodyLarge?.copyWith(height: 1.5)),
        const SizedBox(height: 28),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(value: value, onChanged: onChanged),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(checkboxLabel, style: text.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isLast,
    required this.enabled,
    required this.onNext,
  });

  final bool isLast;
  final bool enabled;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: enabled ? onNext : null,
        child: Text(isLast ? 'Start journaling' : 'Continue'),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            width: i == active ? 22 : 6,
            decoration: BoxDecoration(
              color: i == active
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}
