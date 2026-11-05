import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'goals_list_screen.dart';

class StatisticsTab extends StatefulWidget {
  final bool hasData;
  final String dogName;
  const StatisticsTab({super.key, required this.hasData, this.dogName = 'Arlo'});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  String _selectedFilter = 'Overview';
  String _selectedTimeframe = 'This Year';
  int _selectedSpotIndex = 7; // August default
  String? _selectedHeatmapInfo = '14 Aug · 3 sessions recorded';
  int? _selectedDayIndex;
  bool _isLoaded = false;

  static const List<String> _monthNames = [
    'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
    'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
  ];
  static const List<int> _monthSessions = [10, 12, 15, 20, 25, 22, 18, 14, 20, 28, 24, 20];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasData) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilters(),
          const SizedBox(height: 24),
          _buildTrainingOverviewGrid(),
          const SizedBox(height: 16),
          _buildChartCard(),
          const SizedBox(height: 16),
          _buildActivityHeatmap(),
          const SizedBox(height: 16),
          _buildTrainingByDay(),
          const SizedBox(height: 16),
          _buildMostTrainedSkills(),
          const SizedBox(height: 16),
          _buildGoalsProgress(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardsCarbon,
              border: Border.all(color: Colors.white12),
            ),
            child: const UlvenikIcon(UlvenikIcons.progress, color: Color(0xFF95d3bb), size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Statistics Yet',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Record your first training session to start building ${widget.dogName}’s statistics.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e6b57),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Record Training Session', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 16),
          const Text('Already have records? Try changing your filters', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12, decoration: TextDecoration.underline)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildFilterPill('Overview'),
                _buildFilterPill('Skills'),
                _buildFilterPill('S&C'),
                _buildFilterPill('Locations'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.cardsCarbon,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Lifetime', 'This Year', 'Last 6 Months', 'This Month'].map((tf) => ListTile(
                      title: Text(tf, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                      trailing: _selectedTimeframe == tf ? const UlvenikIcon(UlvenikIcons.completed, color: AppColors.primaryForestGreen) : null,
                      onTap: () {
                        setState(() => _selectedTimeframe = tf);
                        Navigator.pop(ctx);
                      },
                    )).toList(),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(_selectedTimeframe, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                  const SizedBox(width: 4),
                  const UlvenikIcon(UlvenikIcons.sort, color: AppColors.secondaryTextStoneGrey, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF323533) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingOverviewGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Training Overview', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGridStat('AVG SESSION', '42m')),
              Expanded(child: _buildGridStat('PER WEEK', '4.2')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGridStat('SESSIONS', '126')),
              Expanded(child: _buildGridStat('MOST ACTIVE', 'Sat')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Training Sessions Over Time', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      '${_monthNames[_selectedSpotIndex]}: ${_monthSessions[_selectedSpotIndex]} Sessions (Tap points to inspect)',
                      style: const TextStyle(color: Color(0xFF95d3bb), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2e6b57).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: const [
                    UlvenikIcon(UlvenikIcons.progress, color: Color(0xFF2e6b57), size: 16),
                    SizedBox(width: 4),
                    Text('▲ 14%', style: TextStyle(color: Color(0xFF2e6b57), fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(months[value.toInt()], style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 40,
                lineTouchData: LineTouchData(
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (touchResponse != null && touchResponse.lineBarSpots != null && touchResponse.lineBarSpots!.isNotEmpty) {
                      final spot = touchResponse.lineBarSpots!.first;
                      setState(() {
                        _selectedSpotIndex = spot.x.toInt().clamp(0, 11);
                      });
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        const months = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];
                        return LineTooltipItem(
                          '${months[spot.x.toInt()]}\n${spot.y.toInt()} Sessions',
                          const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, _isLoaded ? 10 : 0),
                      FlSpot(1, _isLoaded ? 12 : 0),
                      FlSpot(2, _isLoaded ? 15 : 0),
                      FlSpot(3, _isLoaded ? 20 : 0),
                      FlSpot(4, _isLoaded ? 25 : 0),
                      FlSpot(5, _isLoaded ? 22 : 0),
                      FlSpot(6, _isLoaded ? 18 : 0),
                      FlSpot(7, _isLoaded ? 14 : 0), // August
                      FlSpot(8, _isLoaded ? 20 : 0),
                      FlSpot(9, _isLoaded ? 28 : 0),
                      FlSpot(10, _isLoaded ? 24 : 0),
                      FlSpot(11, _isLoaded ? 20 : 0),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2e6b57),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x == 7, // highlight August
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.backgroundObsidian,
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF2e6b57),
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2e6b57).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutQuart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityHeatmap() {
    const months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Activity Heatmap', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              if (_selectedHeatmapInfo != null)
                Text(_selectedHeatmapInfo!,
                    style: const TextStyle(color: Color(0xFF95d3bb), fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          // Months across top
          Row(
            children: [
              const SizedBox(width: 18), // offset for day initials
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: months.map((m) => Text(m, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w600))).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Grid: 7 rows (days), columns (weeks)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day initial column
                Column(
                  children: days.map((d) => Container(
                    height: 14,
                    margin: const EdgeInsets.only(bottom: 4, right: 6),
                    alignment: Alignment.center,
                    child: Text(d, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
                // Week columns
                Row(
                  children: List.generate(20, (colIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: List.generate(7, (rowIndex) {
                          final dayNum = (colIndex * 7 + rowIndex) % 31 + 1;
                          final monthName = months[(colIndex ~/ 4).clamp(0, months.length - 1)];
                          final intensity = ((colIndex * 3 + rowIndex * 2) % 5);
                          final sessionCount = intensity == 0 ? 0 : (intensity == 4 ? 4 : intensity);
                          Color cellColor;
                          switch (intensity) {
                            case 0: cellColor = const Color(0xFF323533); break;
                            case 1: cellColor = const Color(0xFF2e6b57).withValues(alpha: 0.3); break;
                            case 2: cellColor = const Color(0xFF2e6b57).withValues(alpha: 0.6); break;
                            case 3: cellColor = const Color(0xFF2e6b57).withValues(alpha: 0.9); break;
                            case 4: cellColor = const Color(0xFF95d3bb); break;
                            default: cellColor = const Color(0xFF323533);
                          }
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedHeatmapInfo = sessionCount == 0
                                    ? '$dayNum $monthName · Rest day'
                                    : '$dayNum $monthName · $sessionCount session${sessionCount > 1 ? "s" : ""} recorded';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: cellColor,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: Colors.white12, width: 0.5),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Less', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              Row(
                children: [
                  _buildHeatmapLegendCell(const Color(0xFF323533)),
                  _buildHeatmapLegendCell(const Color(0xFF2e6b57).withValues(alpha: 0.3)),
                  _buildHeatmapLegendCell(const Color(0xFF2e6b57).withValues(alpha: 0.6)),
                  _buildHeatmapLegendCell(const Color(0xFF2e6b57).withValues(alpha: 0.9)),
                  _buildHeatmapLegendCell(const Color(0xFF95d3bb)),
                ],
              ),
              const Text('More', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapLegendCell(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTrainingByDay() {
    const daysData = [
      {'day': 'Mon', 'count': 14, 'factor': 0.36},
      {'day': 'Tue', 'count': 22, 'factor': 0.57},
      {'day': 'Wed', 'count': 18, 'factor': 0.47},
      {'day': 'Thu', 'count': 24, 'factor': 0.63},
      {'day': 'Fri', 'count': 20, 'factor': 0.52},
      {'day': 'Sat', 'count': 38, 'factor': 1.0},
      {'day': 'Sun', 'count': 26, 'factor': 0.68},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Training by Day', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              Text(_selectedDayIndex != null ? '${daysData[_selectedDayIndex!]["count"]} sessions' : 'Sat most active (38)',
                  style: const TextStyle(color: Color(0xFF95d3bb), fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(daysData.length, (i) {
                final item = daysData[i];
                final isSat = item['day'] == 'Sat';
                final isSelected = _selectedDayIndex == i;
                final isHighlight = isSat || isSelected;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${item["count"]}',
                          style: TextStyle(
                            color: isHighlight ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: FractionallySizedBox(
                            heightFactor: item['factor'] as double,
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: isHighlight ? const Color(0xFF2e6b57) : const Color(0xFF323533),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                border: isHighlight ? Border.all(color: const Color(0xFF95d3bb).withValues(alpha: 0.5)) : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['day'] as String,
                          style: TextStyle(
                            color: isHighlight ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostTrainedSkills() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Most Trained Skills', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildSkillProgress('Heel Work', '32 hrs', 0.75, const Color(0xFF2e6b57)),
          const SizedBox(height: 12),
          _buildSkillProgress('Recall', '24 hrs', 0.55, const Color(0xFF2e6b57).withValues(alpha: 0.8)),
          const SizedBox(height: 12),
          _buildSkillProgress('Retrieve', '18 hrs', 0.4, const Color(0xFF2e6b57).withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  Widget _buildSkillProgress(String name, String time, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
            Text(time, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFF323533), borderRadius: BorderRadius.circular(4)),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: percent),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            builder: (context, value, _) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Annual Goals', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  const SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 6,
                      color: Color(0xFF323533),
                    ),
                  ),
                  SizedBox.expand(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 0.7),
                      duration: const Duration(milliseconds: 1500),
                      builder: (context, value, _) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          color: const Color(0xFF2e6b57),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('7', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 28, fontWeight: FontWeight.w700)),
                        Text('OF 10', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsListScreen()));
              },
              child: const Text('View Active Goals', style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
