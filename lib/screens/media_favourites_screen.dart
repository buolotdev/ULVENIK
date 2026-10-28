import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'video_viewer_screen.dart';
import 'photo_viewer_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class MediaFavouritesScreen extends StatefulWidget {
  final bool initialEmpty;

  const MediaFavouritesScreen({super.key, this.initialEmpty = false});

  @override
  State<MediaFavouritesScreen> createState() => _MediaFavouritesScreenState();
}

class _MediaFavouritesScreenState extends State<MediaFavouritesScreen> {
  late bool _isEmpty;

  final List<Map<String, dynamic>> _favourites = [
    {
      'type': 'video',
      'title': 'Bite Phase C Escape (4K 60fps)',
      'dog': 'Koda',
      'duration': '03:45',
      'date': 'Oct 28',
    },
    {
      'type': 'photo',
      'title': 'Alpine Ridge Pointing Posture',
      'dog': 'Koda',
      'date': 'Oct 28',
    },
    {
      'type': 'video',
      'title': 'Scent Article Indication Slow-Mo',
      'dog': 'Koda',
      'duration': '02:04',
      'date': 'Oct 22',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
  }

  void _removeFavorite(int index) {
    setState(() {
      _favourites.removeAt(index);
      if (_favourites.isEmpty) _isEmpty = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favorites.'), backgroundColor: _forest, duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorite Media',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Empty State',
            icon: Icon(
              _isEmpty ? Icons.visibility : Icons.visibility_off_outlined,
              color: _mint,
              size: 20,
            ),
            onPressed: () => setState(() => _isEmpty = !_isEmpty),
          ),
        ],
      ),
      body: _isEmpty
          ? _buildEmptyState()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // 1. HEADER BANNER
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131718),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _gold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: _gold, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_favourites.length} Bookmarked Media Highlights',
                          style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. FAVORITES GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: _favourites.length,
                  itemBuilder: (ctx, idx) {
                    final item = _favourites[idx];
                    final isVideo = item['type'] == 'video';

                    return Container(
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _cardBorder),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isVideo) {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => VideoViewerScreen(title: item['title'])));
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoViewerScreen()));
                                }
                              },
                              child: Container(
                                color: const Color(0xFF131718),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Center(
                                      child: Icon(
                                        isVideo ? Icons.videocam : Icons.image,
                                        color: _mint.withValues(alpha: 0.6),
                                        size: 38,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => _removeFavorite(idx),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.star, color: _gold, size: 16),
                                        ),
                                      ),
                                    ),
                                    if (isVideo && item['duration'] != null)
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            item['duration'],
                                            style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item['dog'], style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w600)),
                                    Text(item['date'], style: const TextStyle(color: _stoneGrey, fontSize: 10)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _carbon,
                border: Border.all(color: _cardBorder),
              ),
              child: const Icon(Icons.star_outline, size: 36, color: _gold),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Favorite Media Saved',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Star important training drill videos and high-definition photos in your media library to view them here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => setState(() => _isEmpty = false),
              child: const Text('View Sample Favorites', style: TextStyle(color: _offWhite)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
