import 'package:flutter/material.dart';

import '../../core/mock_data.dart';
import '../../core/models.dart';
import '../../core/responsive.dart';
import '../../widgets/common.dart';
import '../../widgets/crisis_help_button.dart';
import '../../widgets/not_therapist_banner.dart';
import '../journal/journal_entry_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final entries = MockData.entries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EchoMind'),
        actions: [
          const CrisisHelpAction(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                context.gutter, 8, context.gutter, 120),
            children: [
              Text(
                _greeting,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'A few quiet minutes to reflect.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              const NotTherapistBanner(),
              const SizedBox(height: 20),
              _PromptCard(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const JournalEntryScreen(),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Recent entries',
                trailing: Text(
                  '${entries.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (final e in entries) ...[
                _EntryTile(entry: e),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How was your day?',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Write or speak a few lines. Tag how you feel.',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: scheme.primary.withValues(alpha: 0.18),
            child: Icon(Icons.edit_outlined, color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});
  final JournalEntry entry;

  String _when(DateTime d) {
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(d.year, d.month, d.day))
        .inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: entry.mood.color.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.mood.emoji,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                    Text(entry.mood.label,
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              const Spacer(),
              if (entry.fromVoice)
                Icon(Icons.graphic_eq,
                    size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                _when(entry.createdAt),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            entry.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(height: 1.45),
          ),
          if (entry.themes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in entry.themes)
                  Chip(
                    label: Text(t),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                    backgroundColor:
                        scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
