import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.primaryTextOffWhite,
      displayColor: AppColors.primaryTextOffWhite,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundObsidian,
      primaryColor: AppColors.primaryForestGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryForestGreen,
        secondary: AppColors.secondarySage,
        surface: AppColors.cardsCarbon,
        error: AppColors.errorDestructive,
        onPrimary: AppColors.primaryTextOffWhite,
        onSecondary: AppColors.primaryTextOffWhite,
        onSurface: AppColors.primaryTextOffWhite,
        onError: AppColors.primaryTextOffWhite,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: AppColors.cardsCarbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)), // 16-20px based on docs
          side: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryTextStoneGrey, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryTextStoneGrey, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryForestGreen, width: 1),
        ),
        filled: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.primaryTextOffWhite,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: CircleBorder(), // 50% circle
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryForestGreen,
          foregroundColor: AppColors.primaryTextOffWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
