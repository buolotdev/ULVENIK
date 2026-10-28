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
const Color _blue = Color(0xFF5D8FAF);
const Color _purple = Color(0xFF9F7AEA);

class TrainerReportsScreen extends StatefulWidget {
  const TrainerReportsScreen({super.key});

  @override
  State<TrainerReportsScreen> createState() => _TrainerReportsScreenState();
}

class _TrainerReportsScreenState extends State<TrainerReportsScreen> {
  String _timeframe = 'Oct 2026';

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
          'Trainer Analytics',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: _mint),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Monthly business report exported to PDF.'), backgroundColor: _forest),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. TIMEFRAME PILLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Oct 2026', 'Q3 2026', 'Year to Date', 'All Time'].map((tf) {
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
                    _MetricItem('28', 'Active Students'),
                    _MetricItem('114.5h', 'Teaching Hours'),
                    _MetricItem('96.4%', 'Client Retention'),
                  ],
                ),
                SizedBox(height: 12),
                Divider(color: Color(0x0FFFFFFF), height: 1),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MetricItem('\$4,250', 'Gross Monthly Fees'),
                    _MetricItem('94%', 'Homework Returned'),
                    _MetricItem('3', 'Titles Earned this Mo'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. ANIMATED MONTHLY TRAINING HOURS BAR CHART
          _buildSectionHeader('MONTHLY CLIENT TRAINING VOLUME (HOURS)'),
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
                    Text('6-Month Trend: Steady Growth', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('+32% vs May', style: TextStyle(color: _gold, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: BarChart(
                    BarChartData(
                      maxY: 130,
                      barGroups: [
                        _makeBarGroup(0, 85, _stoneGrey),
                        _makeBarGroup(1, 92, _stoneGrey),
                        _makeBarGroup(2, 98, _mint),
                        _makeBarGroup(3, 104, _mint),
                        _makeBarGroup(4, 110, _forest),
                        _makeBarGroup(5, 114.5, _mint),
                      ],
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (val, _) => Text(
                              '${val.toInt()}h',
                              style: const TextStyle(color: _stoneGrey, fontSize: 9),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, _) {
                              const months = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
                              return Text(months[val.toInt()], style: const TextStyle(color: _stoneGrey, fontSize: 9));
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

          // 4. CLIENT PROGRAM DISTRIBUTION PIE CHART
          _buildSectionHeader('STUDENT SPECIALTY ENROLLMENT'),
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
                        PieChartSectionData(color: _mint, value: 45, title: '45%', radius: 18, titleStyle: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
                        PieChartSectionData(color: _gold, value: 25, title: '25%', radius: 18, titleStyle: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
                        PieChartSectionData(color: _blue, value: 15, title: '15%', radius: 18, titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                        PieChartSectionData(color: _purple, value: 15, title: '15%', radius: 18, titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendRow(_mint, 'IGP / Schutzhund Prep', '13 Dogs'),
                      SizedBox(height: 6),
                      _LegendRow(_gold, 'Puppy Foundation', '7 Dogs'),
                      SizedBox(height: 6),
                      _LegendRow(_blue, 'Behavior Modification', '4 Dogs'),
                      SizedBox(height: 6),
                      _LegendRow(_purple, 'Competition Agility', '4 Dogs'),
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

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
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

