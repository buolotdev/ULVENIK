import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum PasswordStrength { empty, weak, fair, good, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return PasswordStrength.empty;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(password)) score++;

    if (score <= 1) return PasswordStrength.weak;
    if (score == 2) return PasswordStrength.fair;
    if (score <= 4) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  static String _label(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  static Color _color(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return Colors.transparent;
      case PasswordStrength.weak:
        return const Color(0xFFFF5B5B);
      case PasswordStrength.fair:
        return const Color(0xFFFFB347);
      case PasswordStrength.good:
        return const Color(0xFF5D8FAF);
      case PasswordStrength.strong:
        return AppColors.primaryForestGreen;
    }
  }

  static double _fillFraction(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return 0.0;
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = evaluate(password);
    final color = _color(strength);
    final fraction = _fillFraction(strength);
    final label = _label(strength);

    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // ── Segmented bar ──────────────────────────────────
          Row(
            children: List.generate(4, (i) {
              final segmentFilled = fraction >= (i + 1) / 4;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.only(right: i < 3 ? 5 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: segmentFilled ? color : Colors.white10,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 8),

          // ── Label + requirements ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(label),
              ),
              Text(
                _requirementHint(password),
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  static String _requirementHint(String password) {
    final hints = <String>[];
    if (password.length < 8) hints.add('8+ chars');
    if (!RegExp(r'[A-Z]').hasMatch(password)) hints.add('uppercase');
    if (!RegExp(r'[0-9]').hasMatch(password)) hints.add('number');
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(password)) {
      hints.add('symbol');
    }
    if (hints.isEmpty) return 'All requirements met ✓';
    return 'Needs: ${hints.join(', ')}';
  }
}
