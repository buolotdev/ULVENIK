import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ImageEditorResult {
  final String assetPath;
  final int quarterTurns;
  final double zoom;
  final bool isCircularCrop;

  const ImageEditorResult({
    required this.assetPath,
    this.quarterTurns = 0,
    this.zoom = 1.0,
    this.isCircularCrop = true,
  });
}

class ImageEditorScreen extends StatefulWidget {
  final String initialAssetPath;
  final int initialQuarterTurns;
  final double initialZoom;
  final bool initialCircularCrop;

  const ImageEditorScreen({
    super.key,
    this.initialAssetPath = 'assets/images/image_editor_sample.jpg',
    this.initialQuarterTurns = 0,
    this.initialZoom = 1.0,
    this.initialCircularCrop = true,
  });

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  static const List<(String, String, String)> _photoLibrary = [
    (
      'assets/images/image_editor_sample.jpg',
      'Forest K9 Handler',
      'Tactical Tracking Session · 1200 × 1200',
    ),
    (
      'assets/images/handler_profile_photo.jpg',
      'Nordic Forest Portrait',
      'Handler Profile · 1080 × 1080',
    ),
    (
      'assets/images/photo_viewer_1.jpg',
      'Field Session Capture',
      'Obedience & Recall · 1200 × 900',
    ),
    (
      'assets/images/photo_viewer_2.jpg',
      'Trail Ridge Portrait',
      'Endurance Conditioning · 1200 × 900',
    ),
  ];

  late String _assetPath;
  late int _quarterTurns;
  late double _zoom;
  late bool _isCircularCrop;

  /// Normalized pan offset relative to crop radius (-1.0 .. 1.0) so live
  /// avatar previews mirror the exact framing inside the crop aperture.
  Offset _normalizedPan = Offset.zero;
  double _gestureStartZoom = 1.0;
  Offset _gestureStartPan = Offset.zero;

  @override
  void initState() {
    super.initState();
    _assetPath = widget.initialAssetPath;
    _quarterTurns = widget.initialQuarterTurns % 4;
    _zoom = widget.initialZoom.clamp(1.0, 3.0);
    _isCircularCrop = widget.initialCircularCrop;
  }

  bool get _hasAdjustments =>
      _quarterTurns != 0 ||
      (_zoom - 1.0).abs() > 0.01 ||
      _normalizedPan.distance > 0.005;

  void _rotate90() {
    setState(() {
      _quarterTurns = (_quarterTurns + 1) % 4;
    });
  }

  void _resetAdjustments() {
    setState(() {
      _quarterTurns = 0;
      _zoom = 1.0;
      _normalizedPan = Offset.zero;
    });
  }

  Offset _clampNormalizedPan(Offset candidate, double zoom) {
    final maxShift = math.max(0.18, (zoom - 1.0) * 0.65 + 0.18);
    return Offset(
      candidate.dx.clamp(-maxShift, maxShift),
      candidate.dy.clamp(-maxShift, maxShift),
    );
  }

  void _saveAndClose() {
    Navigator.of(context).pop(
      ImageEditorResult(
        assetPath: _assetPath,
        quarterTurns: _quarterTurns,
        zoom: _zoom,
        isCircularCrop: _isCircularCrop,
      ),
    );
  }

  Future<void> _openChooseAnotherPhotoSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141819),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Color(0x22FFFFFF), width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A413E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Choose Another Photo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF5F6F2),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFA7B0AB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Select a portrait from your library to frame and crop.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Color(0xFFA7B0AB),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._photoLibrary.map((entry) {
                    final (path, title, subtitle) = entry;
                    final isCurrent = path == _assetPath;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isCurrent
                            ? AppColors.primaryForestGreen.withValues(alpha: 0.16)
                            : const Color(0xFF1B2021),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.of(sheetCtx).pop(path),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isCurrent
                                    ? AppColors.primaryForestGreen
                                    : const Color(0x18FFFFFF),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: _buildSafePhoto(path),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFF5F6F2),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        subtitle,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: Color(0xFFA7B0AB),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryForestGreen.withValues(
                                        alpha: 0.24,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'SELECTED',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        color: Color(0xFF95D3BB),
                                      ),
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFFA7B0AB),
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null || selected == _assetPath) return;
    setState(() {
      _assetPath = selected;
      _quarterTurns = 0;
      _zoom = 1.0;
      _normalizedPan = Offset.zero;
    });
  }

  Widget _buildSafePhoto(String path) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Image.asset(
        'assets/images/handler_profile_photo.jpg',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFF1A2421),
          alignment: Alignment.center,
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xFF95D3BB),
            size: 42,
          ),
        ),
      ),
    );
  }

  Widget _buildTransformedPhoto({required double viewportSize}) {
    final panPixels = Offset(
      _normalizedPan.dx * (viewportSize * 0.36),
      _normalizedPan.dy * (viewportSize * 0.36),
    );
    return Transform.translate(
      offset: panPixels,
      child: Transform.scale(
        scale: _zoom,
        child: RotatedBox(
          quarterTurns: _quarterTurns,
          child: SizedBox(
            width: viewportSize,
            height: viewportSize,
            child: _buildSafePhoto(_assetPath),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              children: [
                // Top Bar: Cancel | Profile Photo | Save
                SizedBox(
                  height: 54,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFA7B0AB),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Profile Photo',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF5F6F2),
                            letterSpacing: -0.2,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _saveAndClose,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF95D3BB),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scrollable/Responsive Editor Body
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Reserve space for controls (~84px) + preview (~118px)
                      // when screen height allows; otherwise scroll smoothly.
                      final idealSquare = math.min(
                        constraints.maxWidth,
                        math.max(250.0, constraints.maxHeight - 208),
                      );

                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Square Crop Viewport
                            Center(
                              child: SizedBox(
                                width: idealSquare,
                                height: idealSquare,
                                child: ClipRect(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onDoubleTap: () {
                                      setState(() {
                                        if (_zoom > 1.05) {
                                          _zoom = 1.0;
                                          _normalizedPan = Offset.zero;
                                        } else {
                                          _zoom = 1.75;
                                        }
                                      });
                                    },
                                    onScaleStart: (details) {
                                      _gestureStartZoom = _zoom;
                                      _gestureStartPan = _normalizedPan;
                                    },
                                    onScaleUpdate: (details) {
                                      setState(() {
                                        final nextZoom =
                                            (_gestureStartZoom * details.scale)
                                                .clamp(1.0, 3.0);
                                        final deltaNorm = Offset(
                                          details.focalPointDelta.dx /
                                              (idealSquare * 0.36),
                                          details.focalPointDelta.dy /
                                              (idealSquare * 0.36),
                                        );
                                        _zoom = nextZoom;
                                        _normalizedPan = _clampNormalizedPan(
                                          _normalizedPan + deltaNorm,
                                          nextZoom,
                                        );
                                        // Suppress unused field lint while keeping gesture anchor
                                        if (_gestureStartPan == Offset.infinite) {
                                          _normalizedPan = Offset.zero;
                                        }
                                      });
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(color: const Color(0xFF0A0D0E)),
                                        Center(
                                          child: _buildTransformedPhoto(
                                            viewportSize: idealSquare,
                                          ),
                                        ),
                                        IgnorePointer(
                                          child: CustomPaint(
                                            painter: _CropGuideOverlayPainter(
                                              isCircular: _isCircularCrop,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Transform & Zoom Controls Row
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _EditorToolButton(
                                    label: 'Rotate',
                                    onTap: _rotate90,
                                    icon: CustomPaint(
                                      size: const Size(22, 22),
                                      painter: _DashedRotateIconPainter(
                                        color: _quarterTurns != 0
                                            ? const Color(0xFF95D3BB)
                                            : const Color(0xFFC5CCC8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  _EditorToolButton(
                                    label: 'Reset',
                                    onTap: _resetAdjustments,
                                    icon: Icon(
                                      Icons.replay_rounded,
                                      size: 22,
                                      color: _hasAdjustments
                                          ? const Color(0xFFF5F6F2)
                                          : const Color(0xFFA7B0AB),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.zoom_in_rounded,
                                    size: 21,
                                    color: Color(0xFFA7B0AB),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 3.5,
                                        activeTrackColor: _zoom > 1.01
                                            ? AppColors.primaryForestGreen
                                            : const Color(0xFF2B2E2D),
                                        inactiveTrackColor:
                                            const Color(0xFF2B2E2D),
                                        thumbColor: _zoom > 1.01
                                            ? const Color(0xFF95D3BB)
                                            : const Color(0xFF565E5B),
                                        overlayColor: AppColors.primaryForestGreen
                                            .withValues(alpha: 0.18),
                                        thumbShape:
                                            const RoundSliderThumbShape(
                                          enabledThumbRadius: 6,
                                        ),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                          overlayRadius: 14,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _zoom,
                                        min: 1.0,
                                        max: 3.0,
                                        onChanged: (val) {
                                          setState(() {
                                            _zoom = val;
                                            _normalizedPan =
                                                _clampNormalizedPan(
                                              _normalizedPan,
                                              val,
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // PREVIEW Section
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'PREVIEW',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.9,
                                          color: Color(0xFFA7B0AB),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isCircularCrop = !_isCircularCrop;
                                          });
                                        },
                                        child: Text(
                                          _isCircularCrop
                                              ? '${_zoom.toStringAsFixed(1)}× · Circle Guide'
                                              : '${_zoom.toStringAsFixed(1)}× · Square Guide',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF6E7773),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Profile 48px Live Preview
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: ClipOval(
                                              child: Container(
                                                color: const Color(0xFF15191A),
                                                child: Center(
                                                  child: _buildTransformedPhoto(
                                                    viewportSize: 66,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Profile',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFA7B0AB),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 28),
                                      // Trainer Badge 36px Live Preview
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 48,
                                            child: Center(
                                              child: SizedBox(
                                                width: 36,
                                                height: 36,
                                                child: ClipOval(
                                                  child: Container(
                                                    color:
                                                        const Color(0xFF15191A),
                                                    child: Center(
                                                      child:
                                                          _buildTransformedPhoto(
                                                        viewportSize: 50,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Trainer Badge',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFA7B0AB),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Action Dock: Choose Another Photo + Save Profile Photo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E1112),
                    border: Border(
                      top: BorderSide(color: Color(0x1CFFFFFF), width: 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _openChooseAnotherPhotoSheet,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1E1F),
                            foregroundColor: const Color(0xFFD2D8D4),
                            side: const BorderSide(
                              color: Color(0xFF2B3130),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Choose Another Photo',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC5CCC8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _saveAndClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryForestGreen,
                            foregroundColor: const Color(0xFFF5F6F2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Profile Photo',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF5F6F2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorToolButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _EditorToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 26, height: 26, child: Center(child: icon)),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA7B0AB),
            ),
          ),
        ],
      ),
    );
  }
}

class _CropGuideOverlayPainter extends CustomPainter {
  final bool isCircular;

  const _CropGuideOverlayPainter({required this.isCircular});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.365;
    final cropRect = Rect.fromCircle(center: center, radius: radius);

    final outerPath = Path()..addRect(Offset.zero & size);
    final holePath = Path();
    if (isCircular) {
      holePath.addOval(cropRect);
    } else {
      holePath.addRRect(
        RRect.fromRectAndRadius(cropRect, const Radius.circular(24)),
      );
    }

    final maskPath = Path.combine(
      PathOperation.difference,
      outerPath,
      holePath,
    );

    canvas.drawPath(
      maskPath,
      Paint()..color = Colors.black.withValues(alpha: 0.62),
    );

    // Subtle aperture border
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.16);
    if (isCircular) {
      canvas.drawCircle(center, radius, ringPaint);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(cropRect, const Radius.circular(24)),
        ringPaint,
      );
    }

    // Crisp cardinal perimeter alignment ticks (12, 3, 6, 9 o'clock)
    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.72);

    const tickSpan = 6.0;
    // Top & Bottom horizontal tangent ticks
    canvas.drawLine(
      Offset(center.dx - tickSpan / 2, center.dy - radius),
      Offset(center.dx + tickSpan / 2, center.dy - radius),
      tickPaint,
    );
    canvas.drawLine(
      Offset(center.dx - tickSpan / 2, center.dy + radius),
      Offset(center.dx + tickSpan / 2, center.dy + radius),
      tickPaint,
    );
    // Left & Right vertical tangent ticks
    canvas.drawLine(
      Offset(center.dx - radius, center.dy - tickSpan / 2),
      Offset(center.dx - radius, center.dy + tickSpan / 2),
      tickPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius, center.dy - tickSpan / 2),
      Offset(center.dx + radius, center.dy + tickSpan / 2),
      tickPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CropGuideOverlayPainter oldDelegate) {
    return oldDelegate.isCircular != isCircular;
  }
}

class _DashedRotateIconPainter extends CustomPainter {
  final Color color;

  const _DashedRotateIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 1);
    final radius = size.width * 0.36;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;

    // Right solid half-arc + clockwise arrow head at top
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 0.95,
      false,
      paint,
    );

    // Left dashed segments matching Figma rotate-crop icon
    const dashAngles = [math.pi * 0.62, math.pi * 0.88, math.pi * 1.14];
    for (final start in dashAngles) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        0.32,
        false,
        paint,
      );
    }

    // Top arrowhead pointing right
    final arrowTip = Offset(center.dx + 1.5, center.dy - radius);
    final arrowPath = Path()
      ..moveTo(arrowTip.dx - 3.2, arrowTip.dy - 2.8)
      ..lineTo(arrowTip.dx + 1.0, arrowTip.dy)
      ..lineTo(arrowTip.dx - 3.2, arrowTip.dy + 2.8);
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRotateIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
