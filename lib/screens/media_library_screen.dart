import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'video_viewer_screen.dart';
import 'photo_viewer_screen.dart';
import 'document_viewer_screen.dart';
import 'media_upload_manager_screen.dart';
import 'media_collections_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class MediaLibraryScreen extends StatefulWidget {
  final bool initialEmpty;

  const MediaLibraryScreen({super.key, this.initialEmpty = false});

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  late bool _isEmpty;
  String _selectedTab = 'All';

  final List<Map<String, dynamic>> _mediaItems = [
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
      'title': 'Weave Poles 12-Pole Sprint',
      'dog': 'Murphy',
      'duration': '01:18',
      'date': 'Oct 27',
    },
    {
      'type': 'doc',
      'title': 'Koda OFA Hips & Elbows Certificate',
      'dog': 'Koda',
      'date': 'Oct 14',
    },
    {
      'type': 'photo',
      'title': 'Protection Hold & Bark Focus',
      'dog': 'Koda',
      'date': 'Oct 24',
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

  List<Map<String, dynamic>> get _filteredMedia {
    if (_selectedTab == 'All') return _mediaItems;
    if (_selectedTab == 'Videos') return _mediaItems.where((m) => m['type'] == 'video').toList();
    if (_selectedTab == 'Photos') return _mediaItems.where((m) => m['type'] == 'photo').toList();
    return _mediaItems.where((m) => m['type'] == 'doc').toList();
  }

  void _openItem(Map<String, dynamic> item) {
    if (item['type'] == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoViewerScreen(
            title: item['title'],
            dogName: item['dog'],
            duration: item['duration'] ?? '03:00',
          ),
        ),
      );
    } else if (item['type'] == 'photo') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PhotoViewerScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentViewerScreen(title: '${item['title']}.pdf'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredMedia;

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
          'Media Library',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Collections',
            icon: const Icon(Icons.folder_special_outlined, color: _mint),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MediaCollectionsScreen()),
              );
            },
          ),
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
                // 1. FILTER TABS
                _buildFilterTabs(),
                const SizedBox(height: 14),

                // 2. STORAGE STATUS BANNER
                _buildStorageStrip(),
                const SizedBox(height: 16),

                // 3. MEDIA GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: list.length,
                  itemBuilder: (ctx, idx) => _buildMediaCard(list[idx]),
                ),
                const SizedBox(height: 70),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.cloud_upload_outlined, color: _offWhite),
        label: const Text('Upload Media', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MediaUploadManagerScreen()),
          );
        },
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
              child: const Icon(Icons.perm_media_outlined, size: 36, color: _stoneGrey),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Media Uploaded',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Capture training videos, field photos, and upload OFA health certificates to preserve your canine archive.',
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
              child: const Text('View Sample Library', style: TextStyle(color: _offWhite)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['All', 'Videos', 'Photos', 'Docs'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((t) {
          final isSel = _selectedTab == t;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSel ? _mint : _cardBorder),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    color: isSel ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStorageStrip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_done_outlined, color: _mint, size: 18),
              SizedBox(width: 8),
              Text('Cloud Synced (1.24 GB / 10 GB)', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          Text('4K Supported', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildMediaCard(Map<String, dynamic> item) {
    final isVideo = item['type'] == 'video';
    final isDoc = item['type'] == 'doc';

    return GestureDetector(
      onTap: () => _openItem(item),
      child: Container(
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
              child: Container(
                color: const Color(0xFF131718),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Icon(
                        isVideo
                            ? Icons.videocam
                            : (isDoc ? Icons.description : Icons.image),
                        color: _mint.withValues(alpha: 0.6),
                        size: 40,
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
