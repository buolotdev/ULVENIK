import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  /// Rebuilds for the brightness that is current right now; call it again
  /// (the app does, from its root widget) whenever the saved theme changes.
  static ThemeData themeFor(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.primaryTextOffWhite,
      displayColor: AppColors.primaryTextOffWhite,
    );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.backgroundObsidian,
      primaryColor: AppColors.primaryForestGreen,
      colorScheme: (isDark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
        primary: AppColors.primaryForestGreen,
        secondary: AppColors.secondarySage,
        surface: AppColors.cardsCarbon,
        error: AppColors.errorDestructive,
        onPrimary: const Color(0xFFF5F6F2), // white text on the green accent, both themes
        onSecondary: const Color(0xFFF5F6F2),
        onSurface: AppColors.primaryTextOffWhite,
        onError: AppColors.primaryTextOffWhite,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.cardsCarbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)), // 16-20px based on docs
          side: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        filled: false,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.onForestGreen,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(), // 50% circle
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryForestGreen,
          foregroundColor: AppColors.onForestGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
