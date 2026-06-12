import 'package:flutter/material.dart';

import '../core/models.dart';

/// Horizontal 5-point mood picker used when writing an entry.
class MoodSelector extends StatelessWidget {
  const MoodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Mood? selected;
  final ValueChanged<Mood> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final mood in Mood.values)
              _MoodChip(
                mood: mood,
                isSelected: mood == selected,
                onTap: () => onChanged(mood),
              ),
          ],
        );
      },
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  final Mood mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? mood.color.withValues(alpha: 0.25)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? mood.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              mood.label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
