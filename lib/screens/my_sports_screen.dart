import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'sport_details_igp_screen.dart';
import 'create_sport_screen.dart';

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

class MySportsScreen extends StatefulWidget {
  const MySportsScreen({super.key});

  @override
  State<MySportsScreen> createState() => _MySportsScreenState();
}

class _MySportsScreenState extends State<MySportsScreen> {
  final List<Map<String, dynamic>> _sports = [
    {
      'name': 'IGP / Schutzhund',
      'fullTitle': 'Internationale Gebrauchshunde Prüfungsordnung',
      'dog': 'Koda • IGP III Candidate',
      'status': 'Active Primary',
      'phases': 'Phase A (Track) • Phase B (Obedience) • Phase C (Bite)',
      'sessions': '142 Recorded Drills',
      'color': _mint,
      'icon': Icons.sports_kabaddi,
    },
    {
      'name': 'Wilderness Search & Rescue',
      'fullTitle': 'Air Scent Area Search & High-Drive Grid',
      'dog': 'Koda & Murphy',
      'status': 'Mission Ready',
      'phases': 'Scent Indication • Sector Coverage • GPS Tracing',
      'sessions': '64 Recorded Drills',
      'color': _blue,
      'icon': Icons.terrain,
    },
    {
      'name': 'FCI Agility Masters',
      'fullTitle': 'High-Speed Obstacle & Tunnel Navigation',
      'dog': 'Murphy • Grade 2',
      'status': 'Active Trialing',
      'phases': 'Weave Poles • A-Frame • Hurdles • Dog Walk',
      'sessions': '88 Recorded Drills',
      'color': _gold,
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Mondioring',
      'fullTitle': 'Decoy Complex Protection & Handler Defense',
      'dog': 'Koda',
      'status': 'Off-Season Training',
      'phases': 'Jumping • Obedience • Decoy Defense Scenarios',
      'sessions': '32 Recorded Drills',
      'color': _purple,
      'icon': Icons.security,
    },
  ];

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
          'My Sports',
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateSportScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. INFO HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: _mint, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_sports.length} Active Canine Disciplines',
                        style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      const Text('Track trials, phase rules, and titles across canine sports', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. SPORTS LIST
          ..._sports.map((s) => _buildSportCard(s)),

          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text('Add Sport', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateSportScreen()),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSportCard(Map<String, dynamic> sport) {
    final Color color = sport['color'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(sport['icon'], color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sport['name'],
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 16,
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
                              sport['status'],
                              style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(sport['dog'], style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(sport['fullTitle'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF131718),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      sport['phases'],
                      style: const TextStyle(color: _stoneGrey, fontSize: 10, fontFamily: 'monospace'),
                    ),
                  ),
                  Text(
                    sport['sessions'],
                    style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w700),
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
