import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class SportStatisticsScreen extends StatefulWidget {
  const SportStatisticsScreen({super.key});

  @override
  State<SportStatisticsScreen> createState() => _SportStatisticsScreenState();
}

class _SportStatisticsScreenState extends State<SportStatisticsScreen> {
  String _selectedFilter = 'Last 30 Days';
  int? _touchedIndex;

  final Map<String, List<double>> _monthlyData = {
    'Last 30 Days': [18.0, 24.0, 32.0, 45.0, 52.0, 48.0],
    'Last 90 Days': [28.0, 35.0, 42.0, 50.0, 58.0, 54.0],
    'This Year': [15.0, 22.0, 38.0, 48.0, 55.0, 60.0],
    'All Time': [30.0, 40.0, 48.0, 52.0, 57.0, 59.0],
  };

  @override
  Widget build(BuildContext context) {
    final filters = ['Last 30 Days', 'Last 90 Days', 'This Year', 'All Time'];
    final currentValues = _monthlyData[_selectedFilter] ?? [18.0, 24.0, 32.0, 45.0, 52.0, 48.0];

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
          'Sport Statistics',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: _offWhite, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.file_upload_outlined, color: _offWhite, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((f) {
                  final isSel = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFilter = f;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? _forest : _carbon,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel ? _forest : _cardBorder,
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isSel ? _offWhite : _stoneGrey,
                            fontSize: 13,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'SUMMARY',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // Summary 2x2 Bento Grid
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    '286',
                    'Training Sessions',
                    Icons.fitness_center_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    '142h',
                    'Training Hours',
                    Icons.schedule_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    '7',
                    'Competitions',
                    Icons.emoji_events_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    '4',
                    'Qualifications',
                    Icons.star_border,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'TRAINING',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // Training Card with Animated Interactive Chart
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
                      _buildTrainSubStat('286', 'Sessions'),
                      _buildTrainSubStat('142h', 'Total'),
                      _buildTrainSubStat('First: Mar', '2024'),
                      _buildTrainSubStat('Last:', 'Yesterday'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'MONTHLY SESSION VOLUME',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Apr – Sep 2026',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Animated Interactive BarChart
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 65,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              const months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
                              return BarTooltipItem(
                                '${months[group.x.toInt()]}\n',
                                const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${rod.toY.toInt()} sessions',
                                    style: const TextStyle(
                                      color: _mint,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          touchCallback: (event, response) {
                            setState(() {
                              if (response != null &&
                                  response.spot != null &&
                                  event is! FlTapUpEvent &&
                                  event is! FlPanEndEvent) {
                                _touchedIndex =
                                    response.spot!.touchedBarGroupIndex;
                              } else {
                                _touchedIndex = null;
                              }
                            });
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 20,
                              getTitlesWidget: (val, meta) {
                                if (val > 60) return const SizedBox.shrink();
                                return Text(
                                  val.toInt().toString(),
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                const labels = [
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                ];
                                if (val.toInt() >= 0 && val.toInt() < labels.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      labels[val.toInt()],
                                      style: TextStyle(
                                        color: _touchedIndex == val.toInt()
                                            ? _mint
                                            : _stoneGrey,
                                        fontSize: 11,
                                        fontWeight: _touchedIndex == val.toInt()
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            color: Color(0x1AFFFFFF),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: currentValues.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final val = entry.value;
                          final isTouched = _touchedIndex == idx;
                          return BarChartGroupData(
                            x: idx,
                            barRods: [
                              BarChartRodData(
                                toY: val,
                                color: isTouched ? _mint : _forest,
                                width: 22,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 60,
                                  color: const Color(0x0AFFFFFF),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'SKILLS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // Skills Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '18 Skills',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Active curriculum',
                              style: TextStyle(color: _stoneGrey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 40, color: _cardBorder),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '54 Exercises',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Specific drills',
                              style: TextStyle(color: _stoneGrey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 28),
                  Row(
                    children: const [
                      Icon(Icons.circle, color: Color(0xFF34D399), size: 10),
                      SizedBox(width: 6),
                      Text(
                        'Skills with Training: ',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      Text(
                        '16',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.circle, color: _stoneGrey, size: 10),
                      SizedBox(width: 6),
                      Text(
                        'Without Training: ',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      Text(
                        '2',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'COMPETITIONS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // Competitions Strip Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  _buildStatColumn('7', 'Entered'),
                  _buildStatDivider(),
                  _buildStatColumn('5', 'Completed'),
                  _buildStatDivider(),
                  _buildStatColumn('2', 'Upcoming'),
                  _buildStatDivider(),
                  _buildStatColumn('1', 'Withdrawn'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'ACHIEVEMENTS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // Achievements Strip Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  _buildStatColumn('4', 'Qualifications'),
                  _buildStatDivider(),
                  _buildStatColumn('1', 'Titles'),
                  _buildStatDivider(),
                  _buildStatColumn('3', 'Awards'),
                  _buildStatDivider(),
                  _buildStatColumn('0', 'Certificates'),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String value, String label, IconData icon) {
    return Container(
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
              Text(
                value,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Icon(icon, color: _stoneGrey, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainSubStat(String primary, String secondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          primary,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          secondary,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      color: _cardBorder,
    );
  }
}
