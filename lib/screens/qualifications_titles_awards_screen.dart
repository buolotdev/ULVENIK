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

class QualificationsTitlesAwardsScreen extends StatelessWidget {
  const QualificationsTitlesAwardsScreen({super.key});

  final List<Map<String, dynamic>> _titles = const [
    {
      'title': 'IGP 2 (Internationale Gebrauchshunde)',
      'date': 'October 12, 2026',
      'org': 'FCI / USCA Working Dog Commission',
      'score': '284 / 300 pts (Vorzüglich)',
      'status': 'Official Certified',
      'badge': 'TITLE',
      'color': _mint,
    },
    {
      'title': 'IGP 1 (Working Dog Title 1)',
      'date': 'May 18, 2026',
      'org': 'Regional Working Dog Trials',
      'score': '276 / 300 pts (Sehr Gut)',
      'status': 'Official Certified',
      'badge': 'TITLE',
      'color': _mint,
    },
    {
      'title': 'BH / VT (Traffic Safe Companion Dog)',
      'date': 'November 15, 2025',
      'org': 'FCI Begleithundprüfung',
      'score': 'Passed • Temperament Tested',
      'status': 'Foundational Prerequisite',
      'badge': 'QUALIFICATION',
      'color': _stoneGrey,
    },
    {
      'title': 'FH 1 (Advanced Tracking Title)',
      'date': 'September 08, 2026',
      'org': 'National Tracking Association',
      'score': '98 / 100 pts (Vorzüglich)',
      'status': 'Official Certified',
      'badge': 'TITLE',
      'color': _mint,
    },
  ];

  final List<Map<String, dynamic>> _awards = const [
    {
      'name': 'High in Trial — Protection (Phase C 96 pts)',
      'event': 'National Fall Working Dog Trial',
      'date': 'October 2026',
      'color': _gold,
    },
    {
      'name': '1st Place Gold Medal — IGP II Division',
      'event': 'Pacific Northwest Autumn Invitational',
      'date': 'October 2026',
      'color': _gold,
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
          'Titles & Awards',
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
          // 1. HERO SUMMARY CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.military_tech, color: _gold, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Koda vom Alpenhof',
                        style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 2),
                      Text('4 Official Working Titles • 2 Championship Awards', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. EARNED TITLES & QUALIFICATIONS
          _buildSectionHeader('OFFICIAL TITLES & QUALIFICATIONS'),
          const SizedBox(height: 8),
          ..._titles.map((t) => _buildTitleCard(t)),
          const SizedBox(height: 16),

          // 3. AWARDS & MEDALS
          _buildSectionHeader('AWARDS & SPECIAL HONORS'),
          const SizedBox(height: 8),
          ..._awards.map((a) => _buildAwardCard(a)),

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

  Widget _buildTitleCard(Map<String, dynamic> t) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _forest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(t['badge'], style: const TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.w800)),
              ),
              Text(t['date'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            t['title'],
            style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(t['org'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t['score'], style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
                Text(t['status'], style: const TextStyle(color: _stoneGrey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardCard(Map<String, dynamic> a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: _gold, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a['name'], style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('${a['event']} • ${a['date']}', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
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
