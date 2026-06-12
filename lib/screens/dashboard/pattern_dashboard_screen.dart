import 'package:flutter/material.dart';

import '../../core/mock_data.dart';
import '../../core/models.dart';
import '../../core/responsive.dart';
import '../../widgets/common.dart';
import '../../widgets/crisis_help_button.dart';

/// Pattern dashboard: mood over time + recurring themes. The chart is drawn
/// with a CustomPainter so the scaffold needs no charting dependency.
class PatternDashboardScreen extends StatelessWidget {
  const PatternDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patterns'),
        actions: const [CrisisHelpAction()],
      ),
      body: SafeArea(
        top: false,
        child: ContentWidth(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
                context.gutter, 8, context.gutter, 120),
            children: [
              const SectionHeader(title: 'Mood — last 14 days'),
              const SizedBox(height: 12),
              SoftCard(
                padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _MoodChartPainter(
                          values: MockData.moodTrend,
                          line: scheme.primary,
                          grid: scheme.onSurface.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('2 weeks ago',
                            style: Theme.of(context).textTheme.labelSmall),
                        Text('Today',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Avg mood',
                      value: '2.9',
                      caption: 'of 5',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Entries',
                      value: '${MockData.entries.length}',
                      caption: 'this period',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Recurring themes'),
              const SizedBox(height: 12),
              for (final t in MockData.themes) ...[
                _ThemeBar(pattern: t),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 4),
              Text(caption,
                  style:
                      TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeBar extends StatelessWidget {
  const _ThemeBar({required this.pattern});
  final ThemePattern pattern;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rising = pattern.trend > 0.1;
    final easing = pattern.trend < -0.1;
    final fraction = (pattern.mentions / 9).clamp(0.08, 1.0);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(pattern.label,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Icon(
                rising
                    ? Icons.trending_up
                    : easing
                        ? Icons.trending_down
                        : Icons.trending_flat,
                size: 18,
                color: rising
                    ? scheme.error
                    : easing
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text('${pattern.mentions}',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8,
              backgroundColor:
                  scheme.surfaceContainerHighest.withValues(alpha: 0.6),
              valueColor: AlwaysStoppedAnimation(
                rising ? scheme.error : scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChartPainter extends CustomPainter {
  _MoodChartPainter({
    required this.values,
    required this.line,
    required this.grid,
  });

  final List<double> values;
  final Color line;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const minV = 1.0, maxV = 5.0;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;

    // Horizontal gridlines for each mood level.
    for (var level = 0; level < 5; level++) {
      final y = size.height * (1 - level / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    double xFor(int i) => size.width * (i / (values.length - 1));
    double yFor(double v) =>
        size.height * (1 - (v - minV) / (maxV - minV));

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final p = Offset(xFor(i), yFor(values[i]));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    // Soft fill under the line.
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = line.withValues(alpha: 0.10),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );

    final dot = Paint()..color = line;
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(Offset(xFor(i), yFor(values[i])), 3, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodChartPainter old) =>
      old.values != values || old.line != line;
}
