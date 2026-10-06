import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Progress bar that animates from 0 to [value] when it first appears.
class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color color;
  final Color backgroundColor;
  final Duration duration;
  final Duration delay;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 4,
    this.color = AppColors.primaryForestGreen,
    this.backgroundColor = Colors.white12,
    this.duration = const Duration(milliseconds: 1100),
    this.delay = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final total = duration + delay;
    final delayFraction = delay.inMilliseconds / total.inMilliseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: total,
      curve: Interval(delayFraction, 1, curve: Curves.easeOutCubic),
      builder: (context, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Container(
          height: height,
          color: backgroundColor,
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Percentage label that counts up in sync with [AnimatedProgressBar].
class AnimatedPercentText extends StatelessWidget {
  final double value;
  final TextStyle style;
  final Duration duration;
  final Duration delay;

  const AnimatedPercentText({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 1100),
    this.delay = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final total = duration + delay;
    final delayFraction = delay.inMilliseconds / total.inMilliseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: total,
      curve: Interval(delayFraction, 1, curve: Curves.easeOutCubic),
      builder: (context, v, _) => Text('${(v * 100).round()}%', style: style),
    );
  }
}
