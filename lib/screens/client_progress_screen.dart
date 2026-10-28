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

class ClientProgressScreen extends StatefulWidget {
  final String dogName;

  const ClientProgressScreen({
    super.key,
    this.dogName = 'Baron',
  });

  @override
  State<ClientProgressScreen> createState() => _ClientProgressScreenState();
}

class _ClientProgressScreenState extends State<ClientProgressScreen> {
  String _timeframe = 'All Sessions (14)';

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
        title: Text(
          'Progress: ${widget.dogName}',
          style: const TextStyle(
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
              children: ['All Sessions (14)', 'Last 30 Days', 'Phase B Focus', 'Phase C Bite'].map((tf) {
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

          // 2. METRIC BENTO CARD
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
                    _MetricItem('88%', 'Overall Mastery (+14%)'),
                    _MetricItem('18.5h', 'Total Lesson Hours'),
                    _MetricItem('100%', 'Homework Return (6/6)'),
                  ],
                ),
                SizedBox(height: 12),
                Divider(color: Color(0x0FFFFFFF), height: 1),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MetricItem('Phase B', 'Primary Focus Area'),
                    _MetricItem('Decoy Vance', 'Trial Helper Assessor'),
                    _MetricItem('Ready', 'IGP 1 Trial Candidate'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. ANIMATED PROGRESS SPLINE CURVE (Interactive fl_chart)
          _buildSectionHeader('MASTERY SCORE PROGRESSION (14 LESSONS)'),
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
                    Text('Trajectory: +23% Gain since Intake', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('Target: 90%', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      minY: 60,
                      maxY: 100,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) => _forest,
                          tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                            return LineTooltipItem(
                              'Lesson ${spot.x.toInt() + 1}: ${spot.y.toInt()}% Score',
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
                              '${val.toInt()}%',
                              style: const TextStyle(color: _stoneGrey, fontSize: 9),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, _) => Text(
                              'L${val.toInt() + 1}',
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
                            FlSpot(0, 65),
                            FlSpot(1, 68),
                            FlSpot(2, 72),
                            FlSpot(3, 70),
                            FlSpot(4, 75),
                            FlSpot(5, 78),
                            FlSpot(6, 82),
                            FlSpot(7, 85),
                            FlSpot(8, 88),
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

          // 4. CRITERIA ACCURACY BARS
          _buildSectionHeader('DRILL CRITERIA ACCURACY'),
          const SizedBox(height: 8),
          _buildCriteriaBar('Focused Heeling Eye Contact', 0.90, '90%', _mint),
          _buildCriteriaBar('Down on the Move Execution', 0.86, '86%', _mint),
          _buildCriteriaBar('1m Hurdle Clean Clearance', 0.82, '82%', _gold),
          _buildCriteriaBar('Clean Out on Decoy Sleeve', 0.88, '88%', _mint),

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

  Widget _buildCriteriaBar(String title, double val, String pct, Color color) {
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
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(pct, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: val,
              backgroundColor: const Color(0xFF131718),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
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

class _MetricItem extends StatelessWidget {
  final String val;
  final String label;

  const _MetricItem(this.val, this.label);

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

