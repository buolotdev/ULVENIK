import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_snackbar.dart';
import 'record_session_screen.dart';
import 'activity_insights_screen.dart';

/// Screen representing "Activity Statistics" covering both:
/// 1. Populated State (Line 149 in Handover Doc)
/// 2. Empty State (Line 148 in Handover Doc)
///
/// Features animated interactive graph, date range filter pills, metric breakdowns,
/// state toggling, and seamless navigation.
class ActivityStatisticsScreen extends StatefulWidget {
  final String activityName;
  final bool initialEmpty;

  const ActivityStatisticsScreen({
    super.key,
    this.activityName = 'Swimming Fitness',
    this.initialEmpty = false,
  });

  @override
  State<ActivityStatisticsScreen> createState() =>
      _ActivityStatisticsScreenState();
}

class _ActivityStatisticsScreenState extends State<ActivityStatisticsScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;

  // Selected Date Filter Pill
  String _selectedDatePill = 'Last 30 Days';

  // Selected Graph Interval (D, W, M, Y)
  String _selectedInterval = 'W';

  // Interactive selected point index on graph (-1 means default W3 / index 2)
  int _selectedSpotIndex = 2;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  void _toggleState() {
    setState(() {
      _isEmpty = !_isEmpty;
      if (!_isEmpty) {
        _chartAnimController.reset();
        _chartAnimController.forward();
      }
    });
  }

  // ===========================================================================
  // INTERACTIVE GRAPH DATA PROVIDER
  // ===========================================================================

  List<FlSpot> _getChartPoints() {
    switch (_selectedInterval) {
      case 'D':
        return const [
          FlSpot(0, 4.0),
          FlSpot(1, 12.0),
          FlSpot(2, 28.0),
          FlSpot(3, 34.0),
          FlSpot(4, 22.0),
          FlSpot(5, 38.0),
          FlSpot(6, 18.0),
        ];
      case 'M':
        return const [
          FlSpot(0, 18.0),
          FlSpot(1, 26.0),
          FlSpot(2, 36.0),
          FlSpot(3, 32.0),
        ];
      case 'Y':
        return const [
          FlSpot(0, 14.0),
          FlSpot(1, 28.0),
          FlSpot(2, 42.0),
          FlSpot(3, 38.0),
        ];
      case 'W':
      default:
        // Matches Figma curve: starts at ~8h at W1, rises to ~32.25h at W3, dips to 22h, rises to ~34h at W4
        return const [
          FlSpot(0, 8.5),
          FlSpot(1, 21.0),
          FlSpot(2, 32.25),
          FlSpot(3, 31.0),
        ];
    }
  }

  List<String> _getXAxisLabels() {
    switch (_selectedInterval) {
      case 'D':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'M':
        return ['May', 'Jun', 'Jul', 'Aug'];
      case 'Y':
        return ['2023', '2024', '2025', '2026'];
      case 'W':
      default:
        return ['W1', 'W2', 'W3', 'W4'];
    }
  }

  String _getTooltipValue(int spotIndex) {
    switch (_selectedInterval) {
      case 'D':
        final vals = ['4h 10m', '12h 00m', '28h 15m', '34h 45m', '22h 30m', '38h 10m', '18h 00m'];
        return spotIndex < vals.length ? vals[spotIndex] : '24h 00m';
      case 'M':
        final vals = ['18h 30m', '26h 15m', '36h 40m', '32h 15m'];
        return spotIndex < vals.length ? vals[spotIndex] : '30h 00m';
      case 'Y':
        final vals = ['142h', '210h', '320h', '248h'];
        return spotIndex < vals.length ? vals[spotIndex] : '200h';
      case 'W':
      default:
        final vals = ['8h 30m', '21h 00m', '32h 15m', '31h 00m'];
        return spotIndex < vals.length ? vals[spotIndex] : '32h 15m';
    }
  }

  // ===========================================================================
  // INTERACTIVE ACTION HANDLERS
  // ===========================================================================

  void _showMetricBreakdown(String title, String val, String subtitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '+18% vs last month',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              val,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRecordSession() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordSessionScreen(
          initialActivityName: widget.activityName,
          startWithActivity: true,
        ),
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // Seamless dark header matching Figma 1:1, no bottom border line
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite, size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: GestureDetector(
          onDoubleTap: _toggleState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Activity Statistics',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_isEmpty)
                Text(
                  widget.activityName,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          // State toggle button (Populated vs Empty)
          IconButton(
            tooltip: _isEmpty
                ? 'Switch to Populated State'
                : 'Switch to Empty State',
            icon: Icon(
              _isEmpty ? Icons.analytics_outlined : Icons.analytics,
              color: _mint,
              size: 22,
            ),
            onPressed: _toggleState,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _stoneGrey, size: 22),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'toggle') {
                _toggleState();
              } else if (val == 'insights') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityInsightsScreen(
                      activityName: widget.activityName,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'record') {
                _navigateToRecordSession();
              } else if (val == 'export') {
                ScaffoldMessenger.of(context).clearSnackBars();
                AppSnackbar.show(
                  context,
                  message: 'Exporting ${widget.activityName} performance PDF...',
                  type: SnackbarType.info,
                );
              } else if (val == 'share') {
                ScaffoldMessenger.of(context).clearSnackBars();
                AppSnackbar.show(
                  context,
                  message: 'Statistics summary copied to clipboard',
                  type: SnackbarType.success,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      _isEmpty ? Icons.bar_chart : Icons.hourglass_empty,
                      color: _mint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEmpty
                          ? 'View Populated State'
                          : 'View Empty State',
                      style: const TextStyle(color: _offWhite),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'insights',
                child: Row(
                  children: [
                    Icon(Icons.insights, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Insights', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'record',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Record New Session', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Analytics Report', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Share Statistics', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
          child: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
        ),
      ),
    );
  }

  // ===========================================================================
  // STATE A: POPULATED STATE (SCREENSHOT 1)
  // ===========================================================================

  Widget _buildPopulatedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header Section
        Text(
          widget.activityName,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Performance & Trends',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),

        // 2. Date Range Filter Pills (Horizontal Scrolling)
        _buildDateRangePills(
          pills: const ['Last 7 Days', 'Last 30 Days', 'This Year', 'All Time'],
        ),
        const SizedBox(height: 24),

        // 3. Section 1: Overview Grid Card
        _buildOverviewGridCard(),
        const SizedBox(height: 24),

        // 4. Section 2: Animated Activity Trend Chart Card
        _buildActivityTrendChartCard(),
      ],
    );
  }

  // Date Range Pills
  Widget _buildDateRangePills({required List<String> pills}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: pills.map((pill) {
          final isSelected = _selectedDatePill == pill;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedDatePill = pill;
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                });
              },
              borderRadius: BorderRadius.circular(9999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                  border: isSelected
                      ? Border.all(color: _mint.withValues(alpha: 0.5), width: 1)
                      : _hairlineBorder,
                ),
                child: Text(
                  pill,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Section 1: Overview Grid Card
  Widget _buildOverviewGridCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OVERVIEW',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(height: 18),
          // Row 1: Sessions & Total Duration
          Row(
            children: [
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Sessions',
                  value: '48',
                  valueSize: 24,
                  onTap: () => _showMetricBreakdown(
                    'Sessions',
                    '48 completed',
                    'Recorded across 6 active conditioning weeks.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Total Duration',
                  value: '62h 15m',
                  valueSize: 24,
                  onTap: () => _showMetricBreakdown(
                    'Total Duration',
                    '62h 15m',
                    'Total canine aerobic conditioning and endurance workload.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Row 2: Avg Duration & Longest Session
          Row(
            children: [
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Avg Duration',
                  value: '1h 17m',
                  valueSize: 20,
                  onTap: () => _showMetricBreakdown(
                    'Avg Duration',
                    '1h 17m',
                    'Average active swimming duration per workout session.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Longest Session',
                  value: '2h 40m',
                  valueSize: 20,
                  onTap: () => _showMetricBreakdown(
                    'Longest Session',
                    '2h 40m',
                    'Recorded on 10 Aug 2026 at Nordic fjord open water course.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Row 3: Current Streak & Longest Streak
          Row(
            children: [
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Current Streak',
                  value: '12 Days',
                  valueColor: _mint,
                  valueSize: 22,
                  onTap: () => _showMetricBreakdown(
                    'Current Streak',
                    '12 Consecutive Days',
                    'Target weekly frequency maintained without skipped sessions.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Longest Streak',
                  value: '31 Days',
                  valueSize: 22,
                  onTap: () => _showMetricBreakdown(
                    'Longest Streak',
                    '31 Consecutive Days',
                    'Peak training consistency reached in June 2026.',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetricItem({
    required String title,
    required String value,
    Color valueColor = _offWhite,
    double valueSize = 22,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: valueSize,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section 2: Animated Activity Trend Chart Card
  Widget _buildActivityTrendChartCard() {
    final points = _getChartPoints();
    final xLabels = _getXAxisLabels();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: ACTIVITY TREND + Interval Pills
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ACTIVITY TREND',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                ),
              ),
              // Interval selector pill (D, W, M, Y)
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(9999),
                  border: _hairlineBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['D', 'W', 'M', 'Y'].map((interval) {
                    final isSel = _selectedInterval == interval;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedInterval = interval;
                          _selectedSpotIndex = 2;
                          _chartAnimController.reset();
                          _chartAnimController.forward();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSel ? _surfaceHigh : Colors.transparent,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          interval,
                          style: TextStyle(
                            color: isSel ? _offWhite : _stoneGrey,
                            fontSize: 10,
                            fontWeight:
                                isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Interactive Chart Canvas
          SizedBox(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (context, _) {
                final animatedSpots = points.map((p) {
                  return FlSpot(p.x, p.y * _chartProgress.value);
                }).toList();

                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (points.length - 1).toDouble(),
                    minY: 0,
                    maxY: 45,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchCallback: (event, response) {
                        if (response?.lineBarSpots != null &&
                            response!.lineBarSpots!.isNotEmpty) {
                          final idx = response.lineBarSpots!.first.spotIndex;
                          if (idx != _selectedSpotIndex) {
                            setState(() => _selectedSpotIndex = idx);
                          }
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF323533),
                        tooltipBorder: BorderSide(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final tooltipStr = _getTooltipValue(spot.spotIndex);
                            return LineTooltipItem(
                              tooltipStr,
                              const TextStyle(
                                color: _offWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: Colors.white.withValues(alpha: 0.06),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 20,
                          getTitlesWidget: (val, meta) {
                            if (val == 0) {
                              return const Text('0h',
                                  style:
                                      TextStyle(color: _stoneGrey, fontSize: 10));
                            }
                            if (val == 20) {
                              return const Text('20h',
                                  style:
                                      TextStyle(color: _stoneGrey, fontSize: 10));
                            }
                            if (val == 40) {
                              return const Text('40h',
                                  style:
                                      TextStyle(color: _stoneGrey, fontSize: 10));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 24,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx >= 0 && idx < xLabels.length) {
                              final isHighlighted = idx == _selectedSpotIndex;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  xLabels[idx],
                                  style: TextStyle(
                                    color:
                                        isHighlighted ? _mint : _stoneGrey,
                                    fontSize: 11,
                                    fontWeight: isHighlighted
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
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: animatedSpots,
                        isCurved: true,
                        curveSmoothness: 0.38,
                        color: _forest,
                        barWidth: 3.2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final isSel = index == _selectedSpotIndex;
                            return FlDotCirclePainter(
                              radius: isSel ? 5.5 : 2.5,
                              color: isSel ? _offWhite : _forest,
                              strokeWidth: isSel ? 2.5 : 1.5,
                              strokeColor: _forest,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _forest.withValues(alpha: 0.30),
                              _forest.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STATE B: EMPTY STATE (SCREENSHOT 2)
  // ===========================================================================

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Date Range Filter Pills
        _buildDateRangePills(
          pills: const ['Last 30 Days', 'Last 3 Months', 'All Time'],
        ),
        const SizedBox(height: 24),

        // 2. Metrics Placeholder Card (6 empty items with dashes)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(14),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              _buildEmptyMetricRow('Total Sessions', 'Total Duration'),
              const SizedBox(height: 24),
              _buildEmptyMetricRow('Avg. Pace', 'Max Distance'),
              const SizedBox(height: 24),
              _buildEmptyMetricRow('Calories', 'Avg. Heart Rate'),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // 3. Center Illustration: 3 vertical bars icon
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 6,
                height: 18,
                decoration: BoxDecoration(
                  color: _stoneGrey.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 30,
                decoration: BoxDecoration(
                  color: _stoneGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 12,
                decoration: BoxDecoration(
                  color: _stoneGrey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4. Headline
        const Text(
          'No Statistics Available',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _offWhite,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // 5. Explanatory Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Text(
            'Complete your first session to begin generating statistics for this activity.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // 6. Action Button: Record Session
        Center(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                elevation: 0,
              ),
              onPressed: _navigateToRecordSession,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Record Session',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMetricRow(String leftTitle, String rightTitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftTitle,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 28,
                height: 3,
                decoration: BoxDecoration(
                  color: _offWhite,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rightTitle,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 28,
                height: 3,
                decoration: BoxDecoration(
                  color: _offWhite,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
