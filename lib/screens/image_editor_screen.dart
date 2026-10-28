import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _pureBlack = Color(0xFF000000);
const Color _carbon = Color(0xFF1A1F22);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ImageEditorScreen extends StatefulWidget {
  final String imagePath;
  final bool isCircleCrop;

  const ImageEditorScreen({
    super.key,
    this.imagePath = 'assets/images/koda_avatar.png',
    this.isCircleCrop = true,
  });

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  double _scale = 1.0;
  double _rotation = 0.0;
  String _aspectRatio = 'Circle 1:1';
  Offset _offset = Offset.zero;

  void _rotateImage() {
    setState(() {
      _rotation = (_rotation + 90.0) % 360.0;
    });
  }

  void _resetTransform() {
    setState(() {
      _scale = 1.0;
      _rotation = 0.0;
      _offset = Offset.zero;
      _aspectRatio = 'Circle 1:1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pureBlack,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: _offWhite, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Crop & Position',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: _stoneGrey, size: 22),
                    tooltip: 'Reset',
                    onPressed: _resetTransform,
                  ),
                ],
              ),
            ),

            // 2. CROP WORKSPACE WITH GUIDE OVERLAY
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24, width: 1),
                      borderRadius: _aspectRatio == 'Circle 1:1'
                          ? BorderRadius.circular(200)
                          : BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Transformable Canine Image Preview
                        GestureDetector(
                          onScaleUpdate: (details) {
                            setState(() {
                              _scale = (_scale * details.scale).clamp(0.8, 3.0);
                              _offset += details.focalPointDelta;
                            });
                          },
                          child: Transform.translate(
                            offset: _offset,
                            child: Transform.rotate(
                              angle: _rotation * 3.1415926535 / 180,
                              child: Transform.scale(
                                scale: _scale,
                                child: Container(
                                  color: _carbon,
                                  child: const Center(
                                    child: Icon(
                                      Icons.pets,
                                      size: 110,
                                      color: _mint,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Rule of Thirds Guidelines
                        IgnorePointer(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0x33FFFFFF), width: 0.8)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0x33FFFFFF), width: 0.8)),
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                        IgnorePointer(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(color: Color(0x33FFFFFF), width: 0.8)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(color: Color(0x33FFFFFF), width: 0.8)),
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),

                        // Corner Frame Accents
                        IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: _mint, width: 2),
                              borderRadius: _aspectRatio == 'Circle 1:1'
                                  ? BorderRadius.circular(200)
                                  : BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. ZOOM SLIDER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  const Icon(Icons.zoom_out, color: _stoneGrey, size: 18),
                  Expanded(
                    child: Slider(
                      value: _scale,
                      min: 0.8,
                      max: 3.0,
                      activeColor: _mint,
                      inactiveColor: const Color(0xFF262A2E),
                      onChanged: (val) => setState(() => _scale = val),
                    ),
                  ),
                  const Icon(Icons.zoom_in, color: _mint, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 4. ASPECT RATIO PILLS & ROTATE TOOL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: ['Circle 1:1', 'Square 1:1', '4:3'].map((ratio) {
                      final isSel = _aspectRatio == ratio;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            ratio,
                            style: TextStyle(
                              color: isSel ? _offWhite : _stoneGrey,
                              fontSize: 11,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          selected: isSel,
                          selectedColor: _forest,
                          backgroundColor: _carbon,
                          onSelected: (val) => setState(() => _aspectRatio = ratio),
                        ),
                      );
                    }).toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.rotate_right, color: _mint, size: 24),
                    tooltip: 'Rotate 90°',
                    onPressed: _rotateImage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 5. BOTTOM CONFIRMATION BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cropped photo updated successfully.'),
                        backgroundColor: _forest,
                      ),
                    );
                  },
                  child: const Text(
                    'Save & Apply Photo',
                    style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
