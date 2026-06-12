import 'package:flutter/material.dart';

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
  Mood? _mood;
  bool _recording = false;

  @override
  void dispose() {
    _controller.dispose();
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

  void _save() {
    final level = _safety.classify(_controller.text);
    if (level == SafetyLevel.l3Crisis) {
      // Crisis indicators: disable normal flow, redirect to help.
      openCrisisHelp(context);
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(level == SafetyLevel.l2Concerning
            ? 'Saved. Support resources are available any time.'
            : 'Entry saved.'),
      ),
    );
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
            onPressed: _canSave ? _save : null,
            child: const Text('Save'),
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
