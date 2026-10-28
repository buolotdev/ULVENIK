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

class CompetitionResultsScreen extends StatelessWidget {
  final String title;
  final String score;
  final String placement;

  const CompetitionResultsScreen({
    super.key,
    this.title = 'National Fall Working Dog Championship',
    this.score = '284 / 300 pts (Vorzüglich)',
    this.placement = '1st Place • Gold Medalist',
  });

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
          'Official Results',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: _mint),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Results certificate shared.'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. GOLD PODIUM HERO BANNER
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _gold.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: _gold, size: 20),
                        const SizedBox(width: 6),
                        Text(placement, style: const TextStyle(color: _gold, fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('OFFICIAL V', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text('Score: $score', style: const TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                const Text('Koda vom Alpenhof • Handler: Alex Rivers • Judge: Dieter Müller', style: TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. PHASE SCORE DETAILS
          _buildSectionHeader('OFFICIAL PHASE BREAKDOWN'),
          const SizedBox(height: 8),
          _buildPhaseCard('PHASE A — TRACKING (FÄHRTE)', '96 / 100 PTS', 'Deep methodical nose, sharp corner turns, all 3 articles retrieved promptly.', _mint),
          _buildPhaseCard('PHASE B — OBEDIENCE (UNTERORDNUNG)', '92 / 100 PTS', 'Attentive close heeling, fast send out and immediate drop on command.', _gold),
          _buildPhaseCard('PHASE C — PROTECTION (SCHUTZDIENST)', '96 / 100 PTS', 'Instant hold and bark, hard full grip on escape bite, TSB: Pronounced (a).', _mint),
          const SizedBox(height: 20),

          // 3. JUDGE'S REMARKS
          _buildSectionHeader('JUDGE\'S EVALUATION NOTES'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“Exemplary working spirit and exceptional power in the courage test. Koda exhibits high focus and clean outs throughout the entire protection phase.”',
                  style: TextStyle(color: _offWhite, fontSize: 13, height: 1.5, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('— Dieter Müller, Head FCI Judge', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
                    Text('Scorebook Seal: VERIFIED', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                  ],
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

  Widget _buildPhaseCard(String title, String pts, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
              Text(pts, style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: _stoneGrey, fontSize: 11, height: 1.4)),
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
