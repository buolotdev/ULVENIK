import 'package:flutter/material.dart';
import '../data/app_settings.dart';

/// Every colour the app paints with, resolved against the saved Appearance >
/// theme setting (Dark / Light / Device). Reading one of these outside a
/// build method still works, but a value only updates on screen once
/// something rebuilds after [AppSettings] notifies — which the app does from
/// its root widget, so every screen repaints on a theme change.
class AppColors {
  static bool get _dark => AppSettings.instance.isDark;

  static Color get backgroundObsidian => _dark ? const Color(0xFF121212) : const Color(0xFFF7F7F4);
  static Color get cardsCarbon => _dark ? const Color(0xFF1C1C1C) : const Color(0xFFFFFFFF);
  static Color get primaryForestGreen => const Color(0xFF2F5D50);

  /// Text/icon colour on top of the green accent (buttons, FAB, badges) —
  /// stays light in both themes, since the green itself doesn't change.
  static Color get onForestGreen => const Color(0xFFF5F6F2);
  static Color get secondarySage => _dark ? const Color(0xFF7A8F7A) : const Color(0xFF4F6657);
  static Color get infoAlpineBlue => _dark ? const Color(0xFF5D8FAF) : const Color(0xFF3C6E8F);
  static Color get primaryTextOffWhite => _dark ? const Color(0xFFF5F6F2) : const Color(0xFF1A1F1D);
  static Color get secondaryTextStoneGrey => _dark ? const Color(0xFFA7B0AB) : const Color(0xFF5B655F);
  static Color get cardBorder => _dark ? const Color(0x14FFFFFF) : const Color(0x14000000);
  static Color get errorDestructive => const Color(0xFF8B3A3A);
  static Color get destructiveMuted => const Color(0xD98B3A3A);
  static Color get bronzeAccent => const Color(0xFF9B6B3D);
  static Color get favouriteGold => const Color(0xFFB8920A);
  static Color get mediaViewerBackground => const Color(0xFF000000);
}
