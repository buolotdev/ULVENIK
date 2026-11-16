import 'package:flutter/material.dart';

/// The approved Ulvenik brand marks.
///
/// [UlvenikLogo.full] is the complete stacked logo (mountain, wordmark and
/// "The journey builds the wolf." slogan). [UlvenikLogo.wordmark] is the
/// ULVENIK lettering on its own, for compact headers.
///
/// Both are trimmed, downscaled copies of the supplied brand files
/// (`stacked.png` and `white_text_only.png`); the artwork itself is unchanged.
class UlvenikLogo extends StatelessWidget {
  final String _asset;
  final double? width;
  final double? height;
  final double _aspectRatio;

  const UlvenikLogo.full({super.key, this.width, this.height})
      : _asset = 'assets/images/logo_full.png',
        _aspectRatio = 1600 / 706;

  const UlvenikLogo.wordmark({super.key, this.width, this.height})
      : _asset = 'assets/images/logo_wordmark.png',
        _aspectRatio = 1200 / 101;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final w = width ?? (height != null ? height! * _aspectRatio : null);
    return Semantics(
      label: 'Ulvenik',
      image: true,
      child: Image.asset(
        _asset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        cacheWidth: w != null ? (w * dpr).round() : null,
        excludeFromSemantics: true,
      ),
    );
  }
}
