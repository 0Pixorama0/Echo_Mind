import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../widgets/common.dart';
import '../../widgets/crisis_help_button.dart';

/// Account, subscription, privacy, and DPDP-required data controls (export /
/// delete). All actions are mocked in the scaffold.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [CrisisHelpAction()],
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                context.gutter, 8, context.gutter, 32),
            children: [
              const _AccountCard(),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Privacy & data'),
              const SizedBox(height: 12),
              _Tile(
                icon: Icons.lock_outline,
                title: 'How your data is protected',
                subtitle:
                    'Entries are encrypted on this device. Only embeddings '
                    'reach the cloud.',
                onTap: () {},
              ),
              _Tile(
                icon: Icons.download_outlined,
                title: 'Export my data',
                subtitle: 'Download a copy of everything (DPDP).',
                onTap: () => _toast(context, 'Export started (mock).'),
              ),
              _Tile(
                icon: Icons.delete_outline,
                title: 'Delete my account & data',
                subtitle: 'Permanently erase everything.',
                danger: true,
                onTap: () => _confirmDelete(context),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Subscription'),
              const SizedBox(height: 12),
              _Tile(
                icon: Icons.workspace_premium_outlined,
                title: 'EchoMind Plus',
                subtitle: 'Free trial — ₹499/month after.',
                onTap: () => _toast(context, 'Manage subscription (mock).'),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Integrations'),
              const SizedBox(height: 12),
              _Tile(
                icon: Icons.calendar_today_outlined,
                title: 'Google Calendar',
                subtitle: 'Read events for weekly context. Not connected.',
                onTap: () => _toast(context, 'Connect Calendar (mock).'),
              ),
              _Tile(
                icon: Icons.mail_outline,
                title: 'Gmail (labeled threads)',
                subtitle: 'Read only threads you label. Not connected.',
                onTap: () => _toast(context, 'Connect Gmail (mock).'),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'About'),
              const SizedBox(height: 12),
              _Tile(
                icon: Icons.info_outline,
                title: 'EchoMind is not a therapist',
                subtitle:
                    'Not a medical tool, diagnosis, or crisis service.',
                onTap: () {},
              ),
              const _AppVersion(),
            ],
          ),
        ),
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete everything?'),
        content: const Text(
          'This permanently erases your account and all journal data. This '
          'cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _toast(context, 'Account deletion requested (mock).');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: scheme.primary.withValues(alpha: 0.18),
            child: Text('A',
                style: TextStyle(
                    color: scheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aarav',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('aarav@example.com',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = danger ? scheme.error : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: Icon(icon, color: danger ? scheme.error : scheme.primary),
        title: Text(title,
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: TextStyle(color: scheme.onSurfaceVariant)),
        trailing: Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Text(
          'EchoMind v0.1.0 · MVP scaffold',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
