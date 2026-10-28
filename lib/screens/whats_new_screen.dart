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

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({super.key});

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
          "What's New in Ulvenik",
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. RELEASE HERO BANNER
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'VERSION 2.4.0',
                        style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Text('Released October 2026', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'The Alpine Telemetry & Compare Update',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Major performance upgrades including side-by-side canine timeline comparison, topographic contour traces, and real-time Live Activities.',
                  style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. FEATURE HIGHLIGHTS
          _buildSectionHeader('KEY HIGHLIGHTS IN V2.4.0'),
          const SizedBox(height: 10),
          _buildHighlightCard(
            icon: Icons.compare_arrows,
            title: 'Timeline Compare & Progression Curves',
            description: 'Compare two canines (or two different years for the same dog) with interactive dual spline FlChart graphs, volume deltas, and category focus breakdowns.',
            color: _mint,
          ),
          const SizedBox(height: 10),
          _buildHighlightCard(
            icon: Icons.map_outlined,
            title: 'Topographic Activity Map & Heatmaps',
            description: 'Explore your field sessions on dark vector terrain with elevation contours, interactive circular marker pins, and GPS density heatmaps.',
            color: _blue,
          ),
          const SizedBox(height: 10),
          _buildHighlightCard(
            icon: Icons.widgets_outlined,
            title: 'Dynamic Island & Home Screen Widgets',
            description: 'Live Activity tracking for ongoing tracking and bite-work drills in Dynamic Island, plus small and medium widgets for training streaks and scheduled rest.',
            color: _gold,
          ),
          const SizedBox(height: 10),
          _buildHighlightCard(
            icon: Icons.auto_awesome_motion,
            title: 'Smart Rule Collections',
            description: 'Automatically cluster timeline events by custom rules such as high-intensity sessions, scent work, and personal best milestones.',
            color: _orange,
          ),
          const SizedBox(height: 24),

          // 3. PREVIOUS RELEASES
          _buildSectionHeader('PREVIOUS RELEASES'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              children: [
                ListTile(
                  title: Text('v2.3.0 — S&C Periodization & Injury Hub', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text('August 2026 • Periodized load curves & veterinary rehab tracking', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  trailing: Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                ),
                Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text('v2.2.0 — Canine Biometrics & BLE Heart Rate', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text('June 2026 • Wireless collar ingestion & real-time HRV', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  trailing: Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                ),
              ],
            ),
          ),
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

  Widget _buildHighlightCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.5),
                ),
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
