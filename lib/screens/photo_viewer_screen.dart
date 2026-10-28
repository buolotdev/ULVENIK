import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _pureBlack = Color(0xFF000000);
const Color _carbon = Color(0xFF1A1F22);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class PhotoViewerScreen extends StatefulWidget {
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late int _currentIndex;
  bool _isFavorite = false;
  bool _showExif = false;

  final List<Map<String, String>> _photos = [
    {
      'title': 'Koda Mountain Ridge Point',
      'date': 'Oct 28, 2026 • 08:15 AM',
      'exif': '85mm • f/1.4 • 1/2000s • ISO 200',
      'location': 'Riverside Alpine Pass',
    },
    {
      'title': 'Protection Escape Phase C Hit',
      'date': 'Oct 27, 2026 • 03:45 PM',
      'exif': '70mm • f/2.8 • 1/3200s • ISO 400',
      'location': 'Club Field #2',
    },
    {
      'title': 'Agility Weave Poles Full Extension',
      'date': 'Oct 25, 2026 • 10:20 AM',
      'exif': '50mm • f/1.8 • 1/1600s • ISO 100',
      'location': 'Training Grounds',
    },
    {
      'title': 'Scent Article Indication Posture',
      'date': 'Oct 23, 2026 • 07:10 AM',
      'exif': '35mm • f/2.0 • 1/800s • ISO 320',
      'location': 'Highland Pine Grid',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photos[_currentIndex];

    return Scaffold(
      backgroundColor: _pureBlack,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP HEADER APP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: _offWhite),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    children: [
                      Text(
                        '${_currentIndex + 1} of ${_photos.length}',
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        photo['date']!,
                        style: const TextStyle(color: _stoneGrey, fontSize: 10),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.redAccent : _offWhite,
                        ),
                        onPressed: () => setState(() => _isFavorite = !_isFavorite),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, color: _offWhite),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Photo export prepared.'), backgroundColor: _forest),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. PINCH-TO-ZOOM IMAGE VIEWPORT
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.pets, size: 90, color: _mint),
                              const SizedBox(height: 12),
                              Text(
                                photo['title']!,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                photo['location']!,
                                style: const TextStyle(color: _stoneGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        // EXIF Overlay
                        if (_showExif)
                          Positioned(
                            bottom: 14,
                            left: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _mint.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                'EXIF: ${photo['exif']} • GPS: 47.6062° N, 122.3321° W',
                                style: const TextStyle(color: _mint, fontSize: 11, fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. EXIF INFO TOGGLE BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: Icon(_showExif ? Icons.info : Icons.info_outline, color: _mint, size: 16),
                    label: Text(
                      _showExif ? 'Hide Metadata' : 'Show Camera EXIF',
                      style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () => setState(() => _showExif = !_showExif),
                  ),
                  Text(
                    photo['exif']!,
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
            ),

            // 4. BOTTOM THUMBNAIL CAROUSEL
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                itemBuilder: (ctx, idx) {
                  final isSelected = idx == _currentIndex;

                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = idx),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 54,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? _mint : Colors.white12,
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: isSelected ? _mint : _stoneGrey,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
