import 'package:flutter/material.dart';

import '../../core/mock_data.dart';
import '../../core/responsive.dart';
import '../../widgets/common.dart';
import '../../widgets/crisis_help_button.dart';

/// Weekly AI-generated reflection summary (mocked). Frames itself explicitly as
/// a reflection of the user's own notes — not advice.
class WeeklyReflectionScreen extends StatelessWidget {
  const WeeklyReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = MockData.weeklyReflection;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflect'),
        actions: const [CrisisHelpAction()],
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                context.gutter, 8, context.gutter, 120),
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: scheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    r.weekLabel,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SoftCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.summary,
                      style: const TextStyle(fontSize: 16, height: 1.55),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 18, color: scheme.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(r.gentleNudge,
                                style: const TextStyle(height: 1.45)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'What stood out'),
              const SizedBox(height: 12),
              for (final h in r.highlights) ...[
                _HighlightTile(text: h),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 12),
              Text(
                'This is a reflection of your own entries, not advice or a '
                'diagnosis.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(height: 1.45))),
        ],
      ),
    );
  }
}
