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

class MediaSearchScreen extends StatefulWidget {
  const MediaSearchScreen({super.key});

  @override
  State<MediaSearchScreen> createState() => _MediaSearchScreenState();
}

class _MediaSearchScreenState extends State<MediaSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _typeFilter = 'All';

  final List<Map<String, dynamic>> _mediaItems = [
    {'title': 'Bite Phase C Escape (4K)', 'dog': 'Koda', 'type': 'video', 'date': 'Oct 28'},
    {'title': 'Alpine Ridge Pointing Posture', 'dog': 'Koda', 'type': 'photo', 'date': 'Oct 28'},
    {'title': 'Weave Poles 12-Pole Sprint', 'dog': 'Murphy', 'type': 'video', 'date': 'Oct 27'},
    {'title': 'Koda OFA Hips Certificate', 'dog': 'Koda', 'type': 'doc', 'date': 'Oct 14'},
    {'title': 'Protection Hold & Bark', 'dog': 'Koda', 'type': 'photo', 'date': 'Oct 24'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _results {
    return _mediaItems.where((m) {
      final matchesQuery = _query.isEmpty ||
          m['title'].toLowerCase().contains(_query.toLowerCase()) ||
          m['dog'].toLowerCase().contains(_query.toLowerCase());
      final matchesType = _typeFilter == 'All' ||
          (_typeFilter == 'Videos' && m['type'] == 'video') ||
          (_typeFilter == 'Photos' && m['type'] == 'photo') ||
          (_typeFilter == 'Docs' && m['type'] == 'doc');
      return matchesQuery && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

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
          'Media Search',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. SEARCH INPUT
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search videos, photos & documents...',
                hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: _mint, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: _stoneGrey, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
          ),
          const SizedBox(height: 14),

          // 2. TYPE FILTER PILLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Videos', 'Photos', 'Docs'].map((t) {
                final isSel = _typeFilter == t;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _typeFilter = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
          ),
          const SizedBox(height: 18),

          // 3. RESULTS LIST
          Text(
            'MATCHING ASSETS (${results.length})',
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          if (results.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: const Column(
                children: [
                  Icon(Icons.search_off, color: _stoneGrey, size: 36),
                  SizedBox(height: 10),
                  Text('No media found', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Try checking for typos or searching by canine name.', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            )
          else
            ...results.map((item) {
              final isVideo = item['type'] == 'video';
              final isDoc = item['type'] == 'doc';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _cardBorder),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF131718),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isVideo ? Icons.videocam : (isDoc ? Icons.description : Icons.image),
                      color: _mint,
                      size: 20,
                    ),
                  ),
                  title: Text(item['title'], style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text('${item['dog']} • ${item['date']}', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                  onTap: () {
                    if (isVideo) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => VideoViewerScreen(title: item['title'])));
                    } else if (!isDoc) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoViewerScreen()));
                    }
                  },
                ),
              );
            }),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
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
