import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ClientProgressScreen extends StatefulWidget {
  final String dogName;

  const ClientProgressScreen({
    super.key,
    this.dogName = 'Murphy',
  });

  @override
  State<ClientProgressScreen> createState() => _ClientProgressScreenState();
}

class _ClientProgressScreenState extends State<ClientProgressScreen> {
  String _activeCategory = 'Overview';
  String _selectedMonth = 'This Month';
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMonth,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _stoneGrey, size: 16),
                style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600),
                items: const [
                  DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                  DropdownMenuItem(value: 'Last Month', child: Text('Last Month')),
                  DropdownMenuItem(value: 'Last 90 Days', child: Text('Last 90 Days')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedMonth = v);
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Category Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Overview', 'Training', 'S&C', 'Skills', 'Health'].map((cat) {
                  final isSel = _activeCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _activeCategory = cat),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSel ? const Color(0xFF34D399) : _cardBorder,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSel ? const Color(0xFF34D399) : _stoneGrey,
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

            const SizedBox(height: 18),

            // 2x2 Bento Metric Grid
            Row(
              children: [
                Expanded(
                  child: _buildBentoCard(
                    title: 'Total Training Time',
                    value: '24h 35m',
                    delta: '+16% vs last month',
                    isSparkline: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBentoCard(
                    title: 'Sessions',
                    value: '18',
                    delta: '+12% vs last month',
                    isSparkline: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildFreqCard(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSuccessRateCard(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Training Time (Weekly Trend) with Interactive Animated LineChart
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Training Time',
                        style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text('Weekly trend', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 3.5,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '${spot.y.toStringAsFixed(1)} hours\n',
                                  const TextStyle(color: _mint, fontWeight: FontWeight.bold),
                                );
                              }).toList();
                            },
                          ),
                          touchCallback: (event, response) {
                            setState(() {
                              if (response != null && response.lineBarSpots != null && event is! FlTapUpEvent) {
                                _touchedIndex = response.lineBarSpots!.first.spotIndex;
                              } else {
                                _touchedIndex = null;
                              }
                            });
                          },
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (v) => const FlLine(color: Color(0x14FFFFFF), strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (val, meta) {
                                if (val == 0) return const SizedBox.shrink();
                                return Text(
                                  '${val.toInt()}h',
                                  style: const TextStyle(color: _stoneGrey, fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                const weeks = ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'];
                                if (val.toInt() >= 0 && val.toInt() < weeks.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      weeks[val.toInt()],
                                      style: TextStyle(
                                        color: _touchedIndex == val.toInt() ? _mint : _stoneGrey,
                                        fontSize: 10,
                                        fontWeight: _touchedIndex == val.toInt() ? FontWeight.w700 : FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 0.9),
                              FlSpot(1, 1.8),
                              FlSpot(2, 1.2),
                              FlSpot(3, 2.2),
                              FlSpot(4, 1.6),
                              FlSpot(5, 2.7),
                              FlSpot(6, 1.9),
                            ],
                            isCurved: true,
                            curveSmoothness: 0.35,
                            color: const Color(0xFF34D399),
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: const Color(0xFF34D399),
                                  strokeWidth: 2,
                                  strokeColor: _obsidian,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF34D399).withValues(alpha: 0.25),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 400),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Top Skills Donut Chart Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Top Skills', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('By time spent', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Donut Circle
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                sectionsSpace: 3,
                                centerSpaceRadius: 36,
                                sections: [
                                  PieChartSectionData(color: const Color(0xFF34D399), value: 45, radius: 14, showTitle: false),
                                  PieChartSectionData(color: const Color(0xFF5D8FAF), value: 25, radius: 14, showTitle: false),
                                  PieChartSectionData(color: const Color(0xFF9F7AEA), value: 18, radius: 14, showTitle: false),
                                  PieChartSectionData(color: const Color(0xFF4A5568), value: 12, radius: 14, showTitle: false),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('45%', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w800)),
                                Text('TOP', style: TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Skill rows
                      Expanded(
                        child: Column(
                          children: [
                            _buildSkillBreakdown(const Color(0xFF34D399), 'Focus & Drive', '45%'),
                            const SizedBox(height: 8),
                            _buildSkillBreakdown(const Color(0xFF5D8FAF), 'Agility & S&C', '25%'),
                            const SizedBox(height: 8),
                            _buildSkillBreakdown(const Color(0xFF9F7AEA), 'Heelwork', '18%'),
                            const SizedBox(height: 8),
                            _buildSkillBreakdown(const Color(0xFF4A5568), 'Other Modules', '12%'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Your Consistency Card (with Heatmap)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Consistency', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x1F34D399),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Top 15%', style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text("You're in the top 15% of active working dog teams this month.", style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 16),

                  // Heatmap Grid: 7 cols x 4 rows
                  Column(
                    children: List.generate(4, (row) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (col) {
                            final alphaIndex = (row * 7 + col) % 5;
                            final colors = [
                              const Color(0xFF14191E),
                              const Color(0xFF1E3A2E),
                              const Color(0xFF265842),
                              const Color(0xFF34D399),
                              const Color(0xFF14191E),
                            ];
                            return Container(
                              width: 38,
                              height: 24,
                              decoration: BoxDecoration(
                                color: colors[alphaIndex],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Less active', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                      const Spacer(),
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color(0xFF1E3A2E), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 4),
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color(0xFF265842), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 4),
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color(0xFF34D399), borderRadius: BorderRadius.circular(2))),
                        ],
                      ),
                      const Spacer(),
                      const Text('More active', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String value,
    required String delta,
    required bool isSparkline,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(delta, style: const TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF34D399).withValues(alpha: 0.1),
                  const Color(0xFF34D399).withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreqCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Training Frequency', style: TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(height: 4),
          const Text('4.5', style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          const Text('Sessions per week', style: TextStyle(color: _stoneGrey, fontSize: 10)),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.circle, color: Color(0xFF34D399), size: 7),
              SizedBox(width: 5),
              Text('Consistent pace', style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessRateCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Success Rate', style: TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(height: 4),
          const Text('82%', style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          const Text('+6% vs last month', style: TextStyle(color: _stoneGrey, fontSize: 10)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const LinearProgressIndicator(
              value: 0.82,
              backgroundColor: Color(0xFF262C30),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBreakdown(Color color, String name, String pct) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 8),
        const SizedBox(width: 8),
        Expanded(child: Text(name, style: const TextStyle(color: _offWhite, fontSize: 12))),
        Text(pct, style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
