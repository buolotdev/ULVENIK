import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

class SportStatisticsScreen extends StatefulWidget {
  const SportStatisticsScreen({super.key});

  @override
  State<SportStatisticsScreen> createState() => _SportStatisticsScreenState();
}

class _SportStatisticsScreenState extends State<SportStatisticsScreen> {
  String _timeframe = '2026 Season';

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
          'Sport Analytics',
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
          // 1. TIMEFRAME PILLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['2026 Season', 'All Time', 'Phase A', 'Phase B', 'Phase C'].map((tf) {
                final isSel = _timeframe == tf;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _timeframe = tf),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSel ? _forest : _carbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSel ? _mint : _cardBorder),
                      ),
                      child: Text(
                        tf,
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
          const SizedBox(height: 16),

          // 2. METRIC BENTO CARDS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatItem('3,840', 'Total Points'),
                    _StatItem('93.4', 'Avg Trial Score'),
                    _StatItem('100%', 'Pass Rate (14/14)'),
                  ],
                ),
                SizedBox(height: 12),
                Divider(color: Color(0x0FFFFFFF), height: 1),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatItem('98 pts', 'Phase C Personal Best'),
                    _StatItem('3', 'Gold Podiums'),
                    _StatItem('14', 'Official Trials'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. ANIMATED TRIAL SCORE PROGRESSION CURVE
          _buildSectionHeader('TRIAL POINT PROGRESSION (SPLINE CURVE)'),
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
                    Text('Career Progression: +8.0 pts Delta', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('14 Trials', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      minY: 70,
                      maxY: 100,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => _forest,
                          tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                            return LineTooltipItem(
                              'Trial ${spot.x.toInt() + 1}: ${spot.y.toInt()} pts',
                              const TextStyle(color: _offWhite, fontWeight: FontWeight.w800, fontSize: 11),
                            );
                          }).toList(),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => const FlLine(color: Color(0x14FFFFFF), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
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
                            getTitlesWidget: (val, _) => Text(
                              'T${val.toInt() + 1}',
                              style: const TextStyle(color: _stoneGrey, fontSize: 9),
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: _mint,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: _mint.withValues(alpha: 0.12),
                          ),
                          spots: const [
                            FlSpot(0, 88),
                            FlSpot(1, 89),
                            FlSpot(2, 91),
                            FlSpot(3, 90),
                            FlSpot(4, 93),
                            FlSpot(5, 94),
                            FlSpot(6, 96),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. PHASE POINT DISTRIBUTION DONUT CHART
          _buildSectionHeader('PHASE BALANCE'),
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
                SizedBox(
                  width: 100,
                  height: 100,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 28,
                      sections: [
                        PieChartSectionData(color: _mint, value: 34, title: 'A', radius: 18, titleStyle: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
                        PieChartSectionData(color: _gold, value: 32, title: 'B', radius: 18, titleStyle: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
                        PieChartSectionData(color: _forest, value: 34, title: 'C', radius: 18, titleStyle: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendRow(_mint, 'Phase A (Tracking)', '96 pts avg'),
                      SizedBox(height: 6),
                      _LegendRow(_gold, 'Phase B (Obedience)', '92 pts avg'),
                      SizedBox(height: 6),
                      _LegendRow(_forest, 'Phase C (Protection)', '96 pts avg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
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

class _StatItem extends StatelessWidget {
  final String val;
  final String label;

  const _StatItem(this.val, this.label);

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

class _LegendRow extends StatelessWidget {
  final Color color;
  final String title;
  final String stat;

  const _LegendRow(this.color, this.title, this.stat);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        Text(stat, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
