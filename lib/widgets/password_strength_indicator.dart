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
      case PasswordStrength.empty: return '';
      case PasswordStrength.weak: return 'Weak';
      case PasswordStrength.fair: return 'Fair';
      case PasswordStrength.good: return 'Good';
      case PasswordStrength.strong: return 'Strong';
    }
  }

  static double _fillFraction(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty: return 0.0;
      case PasswordStrength.weak:  return 0.2;
      case PasswordStrength.fair:  return 0.45;
      case PasswordStrength.good:  return 0.72;
      case PasswordStrength.strong: return 1.0;
    }
  }

  // Gradient goes from red → amber → blue → green
  static const List<Color> _gradientColors = [
    Color(0xFFFF5B5B),
    Color(0xFFFFB347),
    Color(0xFF5D8FAF),
    Color(0xFF2F5D50),
    AppColors.primaryForestGreen,
  ];

  static Color _labelColor(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:  return Colors.transparent;
      case PasswordStrength.weak:   return const Color(0xFFFF5B5B);
      case PasswordStrength.fair:   return const Color(0xFFFFB347);
      case PasswordStrength.good:   return const Color(0xFF5D8FAF);
      case PasswordStrength.strong: return AppColors.primaryForestGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = evaluate(password);
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    final fraction   = _fillFraction(strength);
    final label      = _label(strength);
    final labelColor = _labelColor(strength);

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

          // ── Single gradient bar ──────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              return SizedBox(
                width: totalWidth,
                height: 5,
                child: Stack(
                  children: [
                    // Track
                    Container(
                      width: totalWidth,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    // Animated filled portion
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      width: totalWidth * fraction,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        gradient: LinearGradient(
                          colors: _gradientColors,
                          stops: const [0.0, 0.33, 0.6, 0.85, 1.0],
                        ),
                      ),
                    ),
                  ],
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
            color: met
                ? AppColors.primaryTextOffWhite
                : AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            fontWeight: met ? FontWeight.w500 : FontWeight.w400,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
