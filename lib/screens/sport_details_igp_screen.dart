import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'record_competition_result_screen.dart';
import 'add_competition_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class SportDetailsIgpScreen extends StatelessWidget {
  const SportDetailsIgpScreen({super.key});

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
          'IGP Details',
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
          // 1. DISCIPLINE HERO BANNER
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
                      child: const Text('FCI RECOGNIZED', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                    const Text('300 PTS TOTAL', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Internationale Gebrauchshunde',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const Text('Prüfungsordnung (IGP)', style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Dog: Koda vom Alpenhof • Current Title: IGP 2 • Target: IGP 3', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. ANIMATED PHASE SCORES BAR CHART
          _buildSectionHeader('PHASE PERFORMANCE (KODA AVERAGE)'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Average Score: 284 / 300 pts (Vorzüglich)', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('Passing: 210 pts', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      barGroups: [
                        _makeBarGroup(0, 96, _mint),
                        _makeBarGroup(1, 92, _gold),
                        _makeBarGroup(2, 96, _mint),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, _) => Text(
                              '${val.toInt()}',
                              style: const TextStyle(color: _stoneGrey, fontSize: 9),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, _) {
                              switch (val.toInt()) {
                                case 0:
                                  return const Text('Phase A (Track)', style: TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w600));
                                case 1:
                                  return const Text('Phase B (Obed)', style: TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w600));
                                case 2:
                                  return const Text('Phase C (Bite)', style: TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w600));
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => const FlLine(color: Color(0x14FFFFFF), strokeWidth: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. PHASE DETAILS CARDS
          _buildSectionHeader('IGP THREE PHASES'),
          const SizedBox(height: 8),
          _buildPhaseCard('PHASE A — TRACKING (FÄHRTE)', '100 Pts Max • 70 Min', '600 paces, 3 articles, 50 min old scent trail. Koda holds a 96 pt average with intense methodical deep-nose indication.', _mint),
          _buildPhaseCard('PHASE B — OBEDIENCE (UNTERORDNUNG)', '100 Pts Max • 70 Min', 'Heeling through group, sit/down on the move, 1m hurdle retrieve, climbing retrieve, send-out and down.', _gold),
          _buildPhaseCard('PHASE C — PROTECTION (SCHUTZDIENST)', '100 Pts Max • 70 Min', 'Search for decoy, hold & bark, escape prevention, defense against attack, long bite, courage test. TSB: Pronounced.', _mint),
          const SizedBox(height: 20),

          // 4. ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RecordCompetitionResultScreen()),
                      );
                    },
                    child: const Text('Record Result', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _mint),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddCompetitionScreen()),
                      );
                    },
                    child: const Text('Add Trial Date', style: TextStyle(color: _mint, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
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
              Text(pts, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: _offWhite, fontSize: 12, height: 1.4)),
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
