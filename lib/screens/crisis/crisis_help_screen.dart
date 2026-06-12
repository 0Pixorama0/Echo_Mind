import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/mock_data.dart';
import '../../core/models.dart';
import '../../core/responsive.dart';
import '../../theme/app_colors.dart';

/// Always-available crisis help. Reached from the Help control on every screen,
/// and shown automatically when the safety classifier flags L3.
class CrisisHelpScreen extends StatelessWidget {
  const CrisisHelpScreen({super.key});

  Future<void> _call(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Call $phone')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Get help now'),
      ),
      body: SafeArea(
        child: ContentWidth(
          maxWidth: 560,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                context.gutter, 8, context.gutter, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.crisis.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.favorite, color: AppColors.crisis),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'If you\'re in distress or thinking about harming '
                        'yourself, you deserve support right now. These free, '
                        'confidential helplines are staffed by trained people.',
                        style: TextStyle(height: 1.45),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              for (final r in MockData.crisisResources) ...[
                _HelplineCard(resource: r, onCall: () => _call(context, r.phone)),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              Text(
                'If you are in immediate danger, call your local emergency '
                'number (112 in India).',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'EchoMind is not a crisis service.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelplineCard extends StatelessWidget {
  const _HelplineCard({required this.resource, required this.onCall});
  final CrisisResource resource;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    resource.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  resource.hours,
                  style: TextStyle(
                      color: scheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(resource.description,
                style: const TextStyle(height: 1.4)),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onCall,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.crisis,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.call),
                label: Text('Call ${resource.phone}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
