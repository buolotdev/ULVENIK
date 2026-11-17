import 'package:flutter/material.dart';
import '../data/app_settings.dart';

/// The approved Ulvenik brand marks.
///
/// [UlvenikLogo.full] is the complete stacked logo (mountain, wordmark and
/// "The journey builds the wolf." slogan). [UlvenikLogo.wordmark] is the
/// ULVENIK lettering on its own, for compact headers.
///
/// Both are trimmed, downscaled copies of the supplied brand files
/// (`stacked.png`/`black_stack.png` and `white_text_only.png`/
/// `black_text_only.png`); the artwork itself is unchanged. The light-ink
/// variant is used automatically in Light theme so the mark stays legible
/// on a light background.
class UlvenikLogo extends StatelessWidget {
  final String _lightAsset;
  final String _darkAsset;
  final double? width;
  final double? height;
  final double _aspectRatio;

  /// Pins the light-ink (white) mark regardless of the app theme — for a
  /// screen with its own fixed dark backdrop (a photo, not the app surface).
  final bool forceLight;

  const UlvenikLogo.full({super.key, this.width, this.height, this.forceLight = false})
      : _lightAsset = 'assets/images/logo_full.png',
        _darkAsset = 'assets/images/logo_full_dark.png',
        _aspectRatio = 1600 / 706;

  const UlvenikLogo.wordmark({super.key, this.width, this.height, this.forceLight = false})
      : _lightAsset = 'assets/images/logo_wordmark.png',
        _darkAsset = 'assets/images/logo_wordmark_dark.png',
        _aspectRatio = 1200 / 101;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final w = width ?? (height != null ? height! * _aspectRatio : null);
    // "Light" asset = light-coloured ink, for a dark background; chosen when
    // the app itself is NOT in Light theme (i.e. the surface behind it is dark).
    final asset = (forceLight || AppSettings.instance.isDark) ? _lightAsset : _darkAsset;
    return Semantics(
      label: 'Ulvenik',
      image: true,
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        cacheWidth: w != null ? (w * dpr).round() : null,
        excludeFromSemantics: true,
      ),
    );
  }
}
