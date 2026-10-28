import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'my_sports_screen.dart';
import 'competitions_overview_screen.dart';
import 'qualifications_titles_awards_screen.dart';
import 'sport_statistics_screen.dart';
import 'sport_details_igp_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);
const Color _purple = Color(0xFF9F7AEA);
const Color _blue = Color(0xFF5D8FAF);

class SportPackOverviewScreen extends StatelessWidget {
  const SportPackOverviewScreen({super.key});

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
          'Sport Pack Hub',
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
          // 1. HERO CANINE SPORT CARD
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('IGP III CANDIDATE', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.emoji_events, color: _gold, size: 16),
                        SizedBox(width: 4),
                        Text('3 Podiums', style: TextStyle(color: _gold, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Koda vom Alpenhof',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                const Text('Belgian Malinois • Working Dog Registry #K9-8472', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatBento('14', 'Trials Entered'),
                    _StatBento('93.4', 'Avg Point Score'),
                    _StatBento('284 / 300', 'Personal Best'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. DISCIPLINE & SPORT HUBS
          _buildSectionHeader('SPORT PACK MODULES'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildModuleTile(
                  icon: Icons.sports_kabaddi,
                  title: 'My Sports & Disciplines',
                  subtitle: 'IGP, Agility, S&R, French Ring & Mondioring',
                  color: _mint,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MySportsScreen())),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildModuleTile(
                  icon: Icons.calendar_today_outlined,
                  title: 'Competitions & Trial Schedule',
                  subtitle: 'Upcoming regional, national & championship trials',
                  color: _blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompetitionsOverviewScreen())),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildModuleTile(
                  icon: Icons.military_tech_outlined,
                  title: 'Qualifications, Titles & Awards',
                  subtitle: 'Official BH, IGP 1, IGP 2, IGP 3 certificate records',
                  color: _gold,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QualificationsTitlesAwardsScreen())),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildModuleTile(
                  icon: Icons.insights_outlined,
                  title: 'Sport Analytics & Phase Curves',
                  subtitle: 'Phase A Tracking, Phase B Obedience, Phase C Protection',
                  color: _purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SportStatisticsScreen())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. UPCOMING TRIAL ALERT
          _buildSectionHeader('NEXT TRIAL ON CALENDAR'),
          const SizedBox(height: 8),
          Container(
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
                    color: _forest.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('NOV\n14', textAlign: TextAlign.center, style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w800, height: 1.1)),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pacific Northwest IGP Championship',
                        style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 2),
                      Text('Highland Park Grounds • IGP III Trial', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SportDetailsIgpScreen()),
                    );
                  },
                  child: const Text('View', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w700)),
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

  Widget _buildModuleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
      onTap: onTap,
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

class _StatBento extends StatelessWidget {
  final String val;
  final String label;

  const _StatBento(this.val, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10)),
      ],
    );
  }
}
