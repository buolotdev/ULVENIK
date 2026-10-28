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
const Color _gold = Color(0xFFECC94B);
const Color _blue = Color(0xFF5D8FAF);
const Color _purple = Color(0xFF9F7AEA);

class ManageRewardTypesScreen extends StatefulWidget {
  const ManageRewardTypesScreen({super.key});

  @override
  State<ManageRewardTypesScreen> createState() =>
      _ManageRewardTypesScreenState();
}

class _ManageRewardTypesScreenState extends State<ManageRewardTypesScreen> {
  final List<Map<String, dynamic>> _types = [
    {
      'title': 'High Drive & Tug Toys',
      'desc': 'Bite balls on rope, French linen tugs, flirt poles & balls',
      'count': '6 Items Registered',
      'driveTier': '90–100% Peak Drive',
      'color': _gold,
      'icon': Icons.sports_baseball,
    },
    {
      'title': 'High-Value Food & Meats',
      'desc': 'Freeze-dried beef liver, string cheese, hot dogs & sardines',
      'count': '8 Items Registered',
      'driveTier': '70–85% Focus Drive',
      'color': _mint,
      'icon': Icons.lunch_dining,
    },
    {
      'title': 'Social Praise & Physical Touch',
      'desc': 'Verbal marker bridge, chest strokes, handler roughhouse play',
      'count': '4 Items Registered',
      'driveTier': '40–60% Maintenance',
      'color': _blue,
      'icon': Icons.thumb_up_alt_outlined,
    },
    {
      'title': 'Environmental Release Rewards',
      'desc': 'Release to search sector, river swim, off-leash exploration',
      'count': '3 Items Registered',
      'driveTier': '75–90% Drive Reset',
      'color': _purple,
      'icon': Icons.nature_people_outlined,
    },
  ];

  void _showAddTypeDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Reward Type', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Type Name (e.g. Scent Distractions)',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Description & Drive Level',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
              ),
            ),
          ],
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
                  _types.add({
                    'title': titleController.text.trim(),
                    'desc': descController.text.trim().isEmpty ? 'Custom canine reinforcer category' : descController.text.trim(),
                    'count': '0 Items Registered',
                    'driveTier': 'Custom Drive Value',
                    'color': _mint,
                    'icon': Icons.category_outlined,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add Category', style: TextStyle(color: _offWhite)),
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
          'Manage Reward Types',
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
            onPressed: _showAddTypeDialog,
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
                const Icon(Icons.category, color: _mint, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_types.length} Reinforcer Categories',
                        style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Group reinforcement tools by stimulation and value tier.',
                        style: TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 2. TYPES LIST
          ..._types.map((type) => _buildTypeCard(type)),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTypeCard(Map<String, dynamic> type) {
    final Color color = type['color'];

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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(type['icon'], color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type['title'],
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type['driveTier'],
                        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(type['desc'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                const SizedBox(height: 4),
                Text(type['count'], style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
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
              _buildNavItem(Icons.pets, 'Dogs', true, () {
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
              _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
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

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
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

