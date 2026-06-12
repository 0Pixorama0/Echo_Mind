import 'package:flutter/widgets.dart';

/// Device size buckets used across EchoMind so every screen adapts to "all
/// sizes" — small phones, large phones, foldables, and tablets.
enum FormFactor { compact, medium, expanded }

class Breakpoints {
  Breakpoints._();

  /// < 600 logical px → phones (single column, bottom navigation).
  static const double compact = 600;

  /// 600–1024 → large phones / small tablets (navigation rail).
  static const double medium = 1024;

  /// > 1024 → tablets / desktop (rail + roomy content).
}

FormFactor formFactorOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < Breakpoints.compact) return FormFactor.compact;
  if (width < Breakpoints.medium) return FormFactor.medium;
  return FormFactor.expanded;
}

extension ResponsiveContext on BuildContext {
  FormFactor get formFactor => formFactorOf(this);
  bool get isCompact => formFactor == FormFactor.compact;
  bool get isExpanded => formFactor == FormFactor.expanded;

  /// Horizontal padding that grows with the viewport.
  double get gutter => switch (formFactor) {
        FormFactor.compact => 16,
        FormFactor.medium => 28,
        FormFactor.expanded => 40,
      };
}

/// Centers and clamps page content so reading lines don't stretch absurdly
/// wide on tablets. Use it as the top-level wrapper of every screen body.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = 720,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
