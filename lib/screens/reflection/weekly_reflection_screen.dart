import 'package:flutter/material.dart';

import '../../core/api.dart';
import '../../core/mock_data.dart';
import '../../core/models.dart';
import '../../core/responsive.dart';
import '../../widgets/common.dart';
import '../../widgets/crisis_help_button.dart';

/// Weekly AI-generated reflection. Fetches from the EchoMind proxy
/// (`/api/reflection/weekly`); falls back to mock content when the backend is
/// unreachable. Framed explicitly as a reflection of the user's own notes.
class WeeklyReflectionScreen extends StatefulWidget {
  const WeeklyReflectionScreen({super.key});

  @override
  State<WeeklyReflectionScreen> createState() => _WeeklyReflectionScreenState();
}

class _WeeklyReflectionScreenState extends State<WeeklyReflectionScreen> {
  final _api = EchoMindApi();
  WeeklyReflection? _reflection;
  bool _loading = true;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _offline = false;
    });
    try {
      final result = await _api.weeklyReflection(MockData.entries);
      if (!mounted) return;
      if (result == null) {
        // Backend flagged a crisis in the week's entries.
        openCrisisHelp(context);
        setState(() {
          _reflection = MockData.weeklyReflection;
          _loading = false;
        });
        return;
      }
      setState(() {
        _reflection = result;
        _loading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _reflection = MockData.weeklyReflection; // graceful offline fallback
        _offline = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflect'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate',
          ),
          const CrisisHelpAction(),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? const _ReflectionLoading()
            : ContentWidth(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                      context.gutter, 8, context.gutter, 120),
                  children: [
                    if (_offline) const _OfflineNote(),
                    Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            color: scheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _reflection!.weekLabel,
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
                            _reflection!.summary,
                            style:
                                const TextStyle(fontSize: 16, height: 1.55),
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
                                  child: Text(_reflection!.gentleNudge,
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
                    for (final h in _reflection!.highlights) ...[
                      _HighlightTile(text: h),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      'This is a reflection of your own entries, not advice or '
                      'a diagnosis.',
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

class _ReflectionLoading extends StatelessWidget {
  const _ReflectionLoading();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('Reading back your week…',
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.cloud_off, size: 16, color: scheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Showing a sample reflection — backend not connected.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
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
