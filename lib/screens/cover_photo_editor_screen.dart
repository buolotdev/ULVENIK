import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';

/// Saved framing for a wide cover photo, stored relative to the frame size
/// so it renders the same at any width. The original photo is untouched.
class CoverCrop {
  final double scale;
  final double dx; // fraction of frame width
  final double dy; // fraction of frame height

  const CoverCrop({this.scale = 1, this.dx = 0, this.dy = 0});

  static const none = CoverCrop();

  Matrix4 matrixFor(Size frame) => Matrix4.identity()
    ..translateByDouble(dx * frame.width, dy * frame.height, 0, 1)
    ..scaleByDouble(scale, scale, 1, 1);
}

/// Shows [image] inside a wide frame using [crop]; never stretches the photo.
class CroppedCover extends StatelessWidget {
  final ImageProvider? image;
  final CoverCrop crop;
  final Widget placeholder;

  const CroppedCover({super.key, required this.image, required this.crop, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    if (image == null) return placeholder;
    return LayoutBuilder(
      builder: (context, c) => ClipRect(
        child: Transform(
          transform: crop.matrixFor(c.biggest),
          child: Image(
            image: image!,
            width: c.maxWidth,
            height: c.maxHeight,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => placeholder,
          ),
        ),
      ),
    );
  }
}

/// Reposition / zoom the dog's wide cover photo with a live preview, then
/// Save or Cancel (Dog Overview handover, section 01).
class CoverPhotoEditorScreen extends StatefulWidget {
  final ImageProvider image;
  final CoverCrop initial;
  final String dogName;

  const CoverPhotoEditorScreen({super.key, required this.image, required this.dogName, this.initial = CoverCrop.none});

  @override
  State<CoverPhotoEditorScreen> createState() => _CoverPhotoEditorScreenState();
}

class _CoverPhotoEditorScreenState extends State<CoverPhotoEditorScreen> {
  final _controller = TransformationController();
  Size _frame = Size.zero;
  bool _initialised = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CoverCrop get _current {
    if (_frame.isEmpty) return widget.initial;
    final m = _controller.value;
    return CoverCrop(
      scale: m.getMaxScaleOnAxis(),
      dx: m.getTranslation().x / _frame.width,
      dy: m.getTranslation().y / _frame.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite)),
        ),
        leadingWidth: 90,
        centerTitle: true,
        title: Text('Edit Cover Photo',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _current),
            child: Text('Save',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text('Drag to reposition. Pinch to zoom.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: LayoutBuilder(builder: (context, c) {
              _frame = c.biggest;
              if (!_initialised) {
                _controller.value = widget.initial.matrixFor(_frame);
                _initialised = true;
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(fit: StackFit.expand, children: [
                  InteractiveViewer(
                    transformationController: _controller,
                    minScale: 1,
                    maxScale: 4,
                    onInteractionEnd: (_) => setState(() {}),
                    child: Image(image: widget.image, width: c.maxWidth, height: c.maxHeight, fit: BoxFit.cover),
                  ),
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.secondaryTextStoneGrey),
                      ),
                    ),
                  ),
                ]),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text('Preview', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 150,
              child: Stack(fit: StackFit.expand, children: [
                CroppedCover(
                  image: widget.image,
                  crop: _current,
                  placeholder: ColoredBox(color: AppColors.cardsCarbon),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 1],
                      colors: [Colors.transparent, Color(0xD9121212)],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Text(widget.dogName,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => setState(() => _controller.value = Matrix4.identity()),
            icon: UlvenikIcon(UlvenikIcons.edit, size: 18, color: AppColors.primaryTextOffWhite),
            label: const Text('Reset framing'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryTextOffWhite,
              side: BorderSide(color: AppColors.cardBorder),
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your original photo is kept. Choosing a different photo will be added with photo-library access.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}
