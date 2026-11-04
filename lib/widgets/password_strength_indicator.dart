import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum PasswordStrength { empty, weak, good, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool isVisible;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    required this.isVisible,
  });

  static const Color mutedRed = Color(0xFFC75D5D);
  static const Color amberOrange = Color(0xFFD99B4B);
  static const Color sageGreen = AppColors.secondarySage; // #7A8F7A

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return PasswordStrength.empty;

    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(password)) {
      score++;
    }

    if (score < 3) return PasswordStrength.weak;
    if (score < 5) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  static String _label(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'WEAK';
      case PasswordStrength.good:
        return 'GOOD';
      case PasswordStrength.strong:
        return 'STRONG';
    }
  }

  static Color _strengthColor(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return AppColors.secondaryTextStoneGrey;
      case PasswordStrength.weak:
        return mutedRed;
      case PasswordStrength.good:
        return amberOrange;
      case PasswordStrength.strong:
        return sageGreen;
    }
  }

  static int _activeSegments(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.strong:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = evaluate(password);
    final label = _label(strength);
    final color = _strengthColor(strength);
    final activeCount = _activeSegments(strength);

    final hasMinLength = password.length >= 8;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(password);

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !isVisible
          ? const SizedBox(width: double.infinity, height: 0)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // ── 4 Segmented Bars + Strength Label ──────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 4 horizontal dashes
                    Expanded(
                      child: Row(
                        children: List.generate(4, (index) {
                          final isFilled = index < activeCount;
                          return Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              height: 4,
                              margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                              decoration: BoxDecoration(
                                color: isFilled
                                    ? color
                                    : Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Strength Label on the right
                    SizedBox(
                      width: 58,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: color,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          fontFamily: 'Inter',
                        ),
                        child: Text(label),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Checklist (Matching Image 5) ─────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CheckItem(label: 'At least 8 characters', met: hasMinLength),
                    const SizedBox(height: 8),
                    _CheckItem(label: 'One uppercase letter', met: hasUpper),
                    const SizedBox(height: 8),
                    _CheckItem(label: 'One lowercase letter', met: hasLower),
                    const SizedBox(height: 8),
                    _CheckItem(label: 'One number', met: hasNumber),
                    const SizedBox(height: 8),
                    _CheckItem(label: 'One special character', met: hasSpecial),
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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: met
                ? AppColors.secondarySage.withValues(alpha: 0.25)
                : Colors.transparent,
            border: Border.all(
              color: met
                  ? AppColors.secondarySage
                  : AppColors.secondaryTextStoneGrey.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: met
              ? const Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 11,
                    color: AppColors.secondarySage,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            color: met
                ? AppColors.primaryTextOffWhite
                : AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            fontWeight: met ? FontWeight.w500 : FontWeight.w400,
            fontFamily: 'Inter',
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
