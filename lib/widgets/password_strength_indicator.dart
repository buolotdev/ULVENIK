import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum PasswordStrength { empty, weak, fair, good, strong }

class GradientConfig {
  final List<Color> colors;
  final List<double> stops;
  GradientConfig(this.colors, this.stops);
}

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
      case PasswordStrength.empty:  return 'Password Strength';
      case PasswordStrength.weak:   return 'Weak';
      case PasswordStrength.fair:   return 'Fair';
      case PasswordStrength.good:   return 'Good';
      case PasswordStrength.strong: return 'Strong';
    }
  }

  static Color _labelColor(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:  return AppColors.secondaryTextStoneGrey;
      case PasswordStrength.weak:   return const Color(0xFFFF5B5B);
      case PasswordStrength.fair:   return const Color(0xFFFFB347);
      case PasswordStrength.good:   return const Color(0xFF5D8FAF);
      case PasswordStrength.strong: return AppColors.primaryForestGreen;
    }
  }

  static GradientConfig _getGradient(PasswordStrength s) {
    const red    = Color(0xFFFF5B5B);
    const amber  = Color(0xFFFFB347);
    const blue   = Color(0xFF5D8FAF);
    const green  = AppColors.primaryForestGreen;

    switch (s) {
      case PasswordStrength.empty:
      case PasswordStrength.weak:
        return GradientConfig(
          [red, red, red, red, red, red, red, red],
          [0.0, 0.2, 0.3, 0.45, 0.55, 0.7, 0.8, 1.0],
        );
      case PasswordStrength.fair:
        return GradientConfig(
          [red, red, red, red, amber, amber, amber, amber],
          [0.0, 0.2, 0.3, 0.4, 0.6, 0.7, 0.8, 1.0], 
        );
      case PasswordStrength.good:
        return GradientConfig(
          [red, red, amber, amber, amber, amber, blue, blue],
          [0.0, 0.28, 0.38, 0.45, 0.55, 0.62, 0.72, 1.0], 
        );
      case PasswordStrength.strong:
        return GradientConfig(
          [red, red, amber, amber, blue, blue, green, green],
          [0.0, 0.2, 0.3, 0.45, 0.55, 0.7, 0.8, 1.0], 
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = evaluate(password);
    final isEmpty = strength == PasswordStrength.empty;
    
    final label      = _label(strength);
    final labelColor = _labelColor(strength);
    final gradConfig = _getGradient(strength);

    final hasUpper   = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower   = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber  = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // ── Full-width gradient bar ──────────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Empty background track
                Container(
                  width: constraints.maxWidth,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                // Colored fill (animates width from 0 to 100%)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  width: isEmpty ? 0 : constraints.maxWidth,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: LinearGradient(
                      colors: gradConfig.colors,
                      stops: gradConfig.stops,
                    ),
                  ),
                ),
              ],
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
                fontWeight: isEmpty ? FontWeight.w500 : FontWeight.w600,
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
