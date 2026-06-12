import 'package:flutter/material.dart';

import '../../core/api.dart';
import '../../core/models.dart';
import '../../core/responsive.dart';
import '../../core/safety.dart';
import '../../widgets/crisis_help_button.dart';
import '../../widgets/mood_selector.dart';

/// Compose a journal entry: text + optional voice, with a mood tag.
///
/// On save the entry runs through the (placeholder) safety classifier first —
/// mirroring the SOW rule that the crisis classifier is the FIRST processing
/// step. An L3 result routes to the crisis help flow instead of saving.
class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _controller = TextEditingController();
  final _safety = const PlaceholderSafetyClassifier();
  final _api = EchoMindApi();
  Mood? _mood;
  bool _recording = false;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    _api.dispose();
    super.dispose();
  }

  bool get _canSave => _controller.text.trim().isNotEmpty && _mood != null;

  void _toggleVoice() {
    // Voice journaling is mocked here. Real flow: record → Whisper transcribe
    // → discard audio → keep text only (per SOW).
    setState(() => _recording = !_recording);
    if (!_recording) {
      final stub =
          'Spoke for a bit about a hectic day and feeling stretched thin.';
      final existing = _controller.text.trim();
      _controller.text = existing.isEmpty ? stub : '$existing\n$stub';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transcribed. Audio discarded.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _save() async {
    final text = _controller.text;

    // Local backstop first — instant and offline-safe. Safety is always the
    // FIRST step (SOW), even before we attempt the network.
    if (_safety.classify(text) == SafetyLevel.l3Crisis) {
      openCrisisHelp(context);
      return;
    }

    setState(() => _saving = true);
    try {
      final result = await _api.classify(text);
      if (!mounted) return;
      if (result.crisis) {
        openCrisisHelp(context);
        return;
      }
      _finishSave(level: result.level);
    } on Object {
      // Backend unreachable — proceed with the local (L1) result.
      if (!mounted) return;
      _finishSave(level: 'l1', offline: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _finishSave({required String level, bool offline = false}) {
    Navigator.of(context).pop();
    final msg = level == 'l2'
        ? 'Saved. Support resources are available any time.'
        : offline
            ? 'Entry saved (offline).'
            : 'Entry saved.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New entry'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          const CrisisHelpAction(),
          TextButton(
            onPressed: (_canSave && !_saving) ? _save : null,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: ContentWidth(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                context.gutter, 8, context.gutter, 32),
            children: [
              Text(
                'How are you feeling?',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              MoodSelector(
                selected: _mood,
                onChanged: (m) => setState(() => _mood = m),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _controller,
                maxLines: 10,
                minLines: 6,
                onChanged: (_) => setState(() {}),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText:
                      'What happened today? What\'s on your mind?',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _toggleVoice,
                      icon: Icon(_recording ? Icons.stop : Icons.mic_none),
                      style: _recording
                          ? OutlinedButton.styleFrom(
                              foregroundColor: scheme.error,
                              side: BorderSide(color: scheme.error),
                            )
                          : null,
                      label: Text(_recording
                          ? 'Stop & transcribe'
                          : 'Speak instead'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Voice is transcribed on your device; the audio is discarded.',
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
