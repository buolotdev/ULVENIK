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

  static String _label(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:  return '';
      case PasswordStrength.weak:   return 'Weak';
      case PasswordStrength.fair:   return 'Fair';
      case PasswordStrength.good:   return 'Good';
      case PasswordStrength.strong: return 'Strong';
    }
  }

  static Color _labelColor(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:  return Colors.transparent;
      case PasswordStrength.weak:   return const Color(0xFFFF5B5B);
      case PasswordStrength.fair:   return const Color(0xFFFFB347);
      case PasswordStrength.good:   return const Color(0xFF5D8FAF);
      case PasswordStrength.strong: return AppColors.primaryForestGreen;
    }
  }

  // Bar is ALWAYS 100% filled. The gradient colors expand as strength grows.
  // Weak:   [red, red]
  // Fair:   [red, yellow] — 50/50 blended at center
  // Good:   [red, yellow, blue] — 33% each
  // Strong: [red, yellow, blue, green] — 25% each
  static List<Color> _gradientColors(PasswordStrength s) {
    const red    = Color(0xFFFF5B5B);
    const amber  = Color(0xFFFFB347);
    const blue   = Color(0xFF5D8FAF);
    const green  = AppColors.primaryForestGreen;

    switch (s) {
      case PasswordStrength.empty:  return [red, red];
      case PasswordStrength.weak:   return [red, red];
      case PasswordStrength.fair:   return [red, amber];
      case PasswordStrength.good:   return [red, amber, blue];
      case PasswordStrength.strong: return [red, amber, blue, green];
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength  = evaluate(password);
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    final label      = _label(strength);
    final labelColor = _labelColor(strength);
    final colors     = _gradientColors(strength);

    final hasUpper   = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower   = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber  = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(password);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ── Full-width gradient bar ──────────────────────────
          TweenAnimationBuilder<List<Color>>(
            tween: _ColorListTween(end: colors),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            builder: (context, animatedColors, _) {
              return Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(colors: animatedColors),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // ── Label row ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                child: Text(label),
              ),
              if (strength == PasswordStrength.strong)
                const Text(
                  'All requirements met ✓',
                  style: TextStyle(
                    color: AppColors.primaryForestGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Checklist ─────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CheckItem(label: 'At least 8 characters', met: password.length >= 8),
              const SizedBox(height: 6),
              _CheckItem(label: 'Uppercase letter',       met: hasUpper),
              const SizedBox(height: 6),
              _CheckItem(label: 'Lowercase letter',       met: hasLower),
              const SizedBox(height: 6),
              _CheckItem(label: 'Number',                 met: hasNumber),
              const SizedBox(height: 6),
              _CheckItem(label: 'Special character',      met: hasSpecial),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Interpolates between two lists of Colors via lerp
class _ColorListTween extends Tween<List<Color>> {
  _ColorListTween({required List<Color> end}) : super(begin: end, end: end);

  @override
  List<Color> lerp(double t) {
    final b = begin!;
    final e = end!;
    final maxLen = e.length > b.length ? e.length : b.length;

    return List.generate(maxLen, (i) {
      final cb = i < b.length ? b[i] : b.last;
      final ce = i < e.length ? e[i] : e.last;
      return Color.lerp(cb, ce, t)!;
    });
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final bool met;

  const _CheckItem({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met ? AppColors.primaryForestGreen : Colors.transparent,
            border: Border.all(
              color: met ? AppColors.primaryForestGreen : Colors.white24,
              width: 1.5,
            ),
          ),
          child: met
              ? const Icon(Icons.check, size: 10, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: met ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            fontWeight: met ? FontWeight.w500 : FontWeight.w400,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
