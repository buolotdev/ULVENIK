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

class AchievementsTitlesScreen extends StatelessWidget {
  const AchievementsTitlesScreen({super.key});

  final List<Map<String, dynamic>> _badges = const [
    {
      'title': 'Century Tracker',
      'desc': 'Logged over 100 km of wilderness scent tracks',
      'icon': Icons.explore,
      'status': 'Unlocked • Oct 2026',
      'progress': 1.0,
      'color': _mint,
    },
    {
      'title': 'Iron Grip Protection',
      'desc': 'Completed 50 full-caliper long bites with clean outs',
      'icon': Icons.sports_kabaddi,
      'status': 'Unlocked • Oct 2026',
      'progress': 1.0,
      'color': _gold,
    },
    {
      'title': 'Speed Demon',
      'desc': 'Exceeded 32 km/h sprint velocity in trail tracking',
      'icon': Icons.speed,
      'status': 'Unlocked • Sep 2026',
      'progress': 1.0,
      'color': _mint,
    },
    {
      'title': 'Triple Crown Podium',
      'desc': 'Earned top-3 placements in three official trials',
      'icon': Icons.emoji_events,
      'status': 'Unlocked • Oct 2026',
      'progress': 1.0,
      'color': _gold,
    },
    {
      'title': 'IGP III Master',
      'desc': 'Pass official IGP 3 trial with over 270 points',
      'icon': Icons.military_tech,
      'status': 'In Progress • 85%',
      'progress': 0.85,
      'color': _stoneGrey,
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
          'Achievements & Titles',
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
          // 1. HERO BANNER
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.workspace_premium, color: _mint, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '12 Badges Unlocked',
                        style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 2),
                      Text('Canine milestones achieved across S&C, IGP, and S&R', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. BADGES LIST
          _buildSectionHeader('CAREER MILESTONE BADGES'),
          const SizedBox(height: 8),
          ..._badges.map((b) => _buildBadgeCard(b)),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> b) {
    final Color color = b['color'];
    final double progress = b['progress'];
    final isDone = progress >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDone ? color.withValues(alpha: 0.3) : _cardBorder),
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
                child: Icon(b['icon'], color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b['title'], style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(b['desc'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ),
              if (isDone)
                const Icon(Icons.check_circle, color: _mint, size: 20)
              else
                Text(b['status'].split('•')[1].trim(), style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
          if (!isDone) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF131718),
                valueColor: const AlwaysStoppedAnimation(_mint),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
