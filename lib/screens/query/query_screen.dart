import 'package:flutter/material.dart';

import '../../core/api.dart';
import '../../core/mock_data.dart';
import '../../core/responsive.dart';
import '../../widgets/crisis_help_button.dart';

/// Conversational query over the user's own entries. In the real app this runs
/// the RAG flow: embed the query → vector match → fetch matching entries from
/// local encrypted storage → send only those snippets to the Claude proxy.
/// Here, answers are canned.
class QueryScreen extends StatefulWidget {
  const QueryScreen({super.key});

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final _controller = TextEditingController();
  final _api = EchoMindApi();
  final _messages = <_Msg>[];
  bool _thinking = false;

  static const _suggestions = [
    'What was I stressed about last week?',
    'When did I feel best recently?',
    'What patterns show up around my sleep?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> _ask(String text) async {
    final q = text.trim();
    if (q.isEmpty || _thinking) return;
    setState(() {
      _messages.add(_Msg(q, isUser: true));
      _controller.clear();
      _thinking = true;
    });

    try {
      // In the real app the phone does the local vector match + retrieval and
      // sends only the matched snippets. Here we pass the mock entries.
      final answer = await _api.query(q, MockData.entries);
      if (!mounted) return;
      if (answer == null) {
        openCrisisHelp(context); // backend flagged a crisis in the question
        setState(() => _thinking = false);
        return;
      }
      setState(() {
        _messages.add(_Msg(answer, isUser: false));
        _thinking = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _messages.add(_Msg(MockData.sampleAnswers['default']!, isUser: false));
        _thinking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask'),
        actions: const [CrisisHelpAction()],
      ),
      body: SafeArea(
        child: ContentWidth(
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? _EmptyState(
                        suggestions: _suggestions,
                        onPick: _ask,
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            context.gutter, 12, context.gutter, 12),
                        itemCount: _messages.length + (_thinking ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i >= _messages.length) {
                            return const _Bubble(
                              text: '…',
                              isUser: false,
                            );
                          }
                          final m = _messages[i];
                          return _Bubble(text: m.text, isUser: m.isUser);
                        },
                      ),
              ),
              _Composer(
                controller: _controller,
                onSend: () => _ask(_controller.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.suggestions, required this.onPick});
  final List<String> suggestions;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.gutter),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.forum_outlined, size: 40, color: scheme.primary),
          const SizedBox(height: 14),
          Text(
            'Ask about your own entries',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Answers come only from what you\'ve written, and stay private.',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          for (final s in suggestions) ...[
            OutlinedButton(
              onPressed: () => onPick(s),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(s),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.isUser});
  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? scheme.primary.withValues(alpha: 0.16)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(text, style: const TextStyle(height: 1.45)),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.gutter,
        8,
        context.gutter,
        MediaQuery.viewInsetsOf(context).bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Ask about your week…',
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: onSend,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  const _Msg(this.text, {required this.isUser});
  final String text;
  final bool isUser;
}
