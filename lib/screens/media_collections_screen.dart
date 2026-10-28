import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _blue = Color(0xFF5D8FAF);
const Color _gold = Color(0xFFECC94B);
const Color _orange = Color(0xFFDD6B20);
const Color _purple = Color(0xFF9F7AEA);

class MediaCollectionsScreen extends StatefulWidget {
  const MediaCollectionsScreen({super.key});

  @override
  State<MediaCollectionsScreen> createState() => _MediaCollectionsScreenState();
}

class _MediaCollectionsScreenState extends State<MediaCollectionsScreen> {
  final List<Map<String, dynamic>> _collections = [
    {
      'title': 'IGP Phase C Bite Work',
      'count': '18 Videos • 4 Photos',
      'dog': 'Koda',
      'color': _mint,
      'icon': Icons.sports_kabaddi,
    },
    {
      'title': 'Alpine Wilderness S&R Scent',
      'count': '12 Videos • 8 Photos',
      'dog': 'Koda & Murphy',
      'color': _blue,
      'icon': Icons.terrain,
    },
    {
      'title': 'Agility & Weave Pole S&C',
      'count': '14 Videos',
      'dog': 'Murphy',
      'color': _gold,
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Veterinary OFA Records',
      'count': '6 Documents',
      'dog': 'Koda',
      'color': _orange,
      'icon': Icons.description,
    },
    {
      'title': 'PNW Championship Highlights',
      'count': '22 Videos • 16 Photos',
      'dog': 'Koda',
      'color': _purple,
      'icon': Icons.emoji_events,
    },
  ];

  void _showCreateCollectionDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Media Collection', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: titleController,
          style: const TextStyle(color: _offWhite, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Collection Name (e.g. Scent Drills)',
            hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  _collections.insert(0, {
                    'title': titleController.text.trim(),
                    'count': '0 Items',
                    'dog': 'All Dogs',
                    'color': _mint,
                    'icon': Icons.folder,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
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
          'Media Collections',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _mint),
            onPressed: _showCreateCollectionDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. HEADER SUMMARY
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_special_outlined, color: _mint, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_collections.length} Curated Albums',
                        style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      const Text('Organized by drill discipline, canine, and trial season', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. COLLECTIONS LIST
          ..._collections.map((col) => _buildCollectionCard(col)),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCollectionCard(Map<String, dynamic> col) {
    final Color color = col['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(col['icon'], color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  col['title'],
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(col['count'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131718),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(col['dog'], style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
        ],
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
