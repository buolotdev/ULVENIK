import 'activity_library_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
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
  final List<CustomActivityMetric>? customMetrics;

  const ActivityStatisticsScreen({
    super.key,
    this.activityName = 'Swimming Fitness',
    this.initialEmpty = false,
    this.customMetrics,
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
  late List<CustomActivityMetric> _customMetrics;
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;

  // Selected Date Filter Pill
  String _selectedDatePill = 'Last 30 Days';

  // Selected Graph Interval (D, W, M, Y)
  String _selectedInterval = 'W';

  // Selected Trend Metric (Default to session frequency over time)
  String _selectedTrendMetric = 'Sessions';

  // Interactive selected point index on graph (-1 means default W3 / index 2)
  int _selectedSpotIndex = 2;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    if (widget.customMetrics != null) {
      _customMetrics = widget.customMetrics!;
    } else if (widget.activityName == 'Swimming Fitness') {
      _customMetrics = const [
        CustomActivityMetric(id: 'm1', name: 'Distance', unit: 'metres'),
      ];
    } else if (widget.activityName == 'Treadmill Intervals') {
      _customMetrics = const [
        CustomActivityMetric(id: 'm2', name: 'Speed', unit: 'mph'),
        CustomActivityMetric(id: 'm3', name: 'Incline', unit: '%'),
      ];
    } else if (widget.activityName == 'Weighted Carries') {
      _customMetrics = const [
        CustomActivityMetric(id: 'm4', name: 'Load', unit: 'kg'),
        CustomActivityMetric(id: 'm5', name: 'Repetitions', unit: 'reps'),
      ];
    } else {
      _customMetrics = const [];
    }

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
    if (_selectedTrendMetric == 'Sessions') {
      // Standard session frequency over time
      switch (_selectedInterval) {
        case 'D':
          return const [
            FlSpot(0, 1.0),
            FlSpot(1, 2.0),
            FlSpot(2, 3.0),
            FlSpot(3, 2.0),
            FlSpot(4, 3.0),
            FlSpot(5, 4.0),
            FlSpot(6, 2.0),
          ];
        case 'M':
          return const [
            FlSpot(0, 8.0),
            FlSpot(1, 10.0),
            FlSpot(2, 14.0),
            FlSpot(3, 12.0),
          ];
        case 'Y':
          return const [
            FlSpot(0, 24.0),
            FlSpot(1, 38.0),
            FlSpot(2, 48.0),
            FlSpot(3, 42.0),
          ];
        case 'W':
        default:
          return const [
            FlSpot(0, 3.0),
            FlSpot(1, 8.0),
            FlSpot(2, 12.0),
            FlSpot(3, 11.0),
          ];
      }
    } else {
      // Trend based on custom numerical metric (e.g. Distance / Load)
      switch (_selectedInterval) {
        case 'D':
          return const [
            FlSpot(0, 500),
            FlSpot(1, 1200),
            FlSpot(2, 1800),
            FlSpot(3, 1600),
            FlSpot(4, 1400),
            FlSpot(5, 2000),
            FlSpot(6, 1500),
          ];
        case 'M':
          return const [
            FlSpot(0, 4200),
            FlSpot(1, 6800),
            FlSpot(2, 8500),
            FlSpot(3, 7900),
          ];
        case 'Y':
          return const [
            FlSpot(0, 15000),
            FlSpot(1, 24000),
            FlSpot(2, 32000),
            FlSpot(3, 28000),
          ];
        case 'W':
        default:
          return const [
            FlSpot(0, 600),
            FlSpot(1, 1400),
            FlSpot(2, 1850),
            FlSpot(3, 1700),
          ];
      }
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
    if (_selectedTrendMetric == 'Sessions') {
      switch (_selectedInterval) {
        case 'D':
          final vals = ['1 Session', '2 Sessions', '3 Sessions', '2 Sessions', '3 Sessions', '4 Sessions', '2 Sessions'];
          return spotIndex < vals.length ? vals[spotIndex] : '2 Sessions';
        case 'M':
          final vals = ['8 Sessions', '10 Sessions', '14 Sessions', '12 Sessions'];
          return spotIndex < vals.length ? vals[spotIndex] : '10 Sessions';
        case 'Y':
          final vals = ['24 Sessions', '38 Sessions', '48 Sessions', '42 Sessions'];
          return spotIndex < vals.length ? vals[spotIndex] : '40 Sessions';
        case 'W':
        default:
          final vals = ['3 Sessions', '8 Sessions', '12 Sessions', '11 Sessions'];
          return spotIndex < vals.length ? vals[spotIndex] : '12 Sessions';
      }
    } else {
      final unit = _customMetrics.isNotEmpty ? _customMetrics.first.unit : '';
      switch (_selectedInterval) {
        case 'D':
          final vals = ['500 $unit', '1,200 $unit', '1,800 $unit', '1,600 $unit', '1,400 $unit', '2,000 $unit', '1,500 $unit'];
          return spotIndex < vals.length ? vals[spotIndex] : '1,500 $unit';
        case 'M':
          final vals = ['4,200 $unit', '6,800 $unit', '8,500 $unit', '7,900 $unit'];
          return spotIndex < vals.length ? vals[spotIndex] : '7,000 $unit';
        case 'Y':
          final vals = ['15k $unit', '24k $unit', '32k $unit', '28k $unit'];
          return spotIndex < vals.length ? vals[spotIndex] : '25k $unit';
        case 'W':
        default:
          final vals = ['600 $unit', '1,400 $unit', '1,850 $unit', '1,700 $unit'];
          return spotIndex < vals.length ? vals[spotIndex] : '1,850 $unit';
      }
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
          initialCustomMetrics: _customMetrics,
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
          icon: const UlvenikIcon(UlvenikIcons.back, color: _offWhite, size: 24),
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
            icon: UlvenikIcon.fromMaterial(
              _isEmpty ? Icons.analytics_outlined : Icons.analytics,
              color: _mint,
              size: 22,
            ),
            onPressed: _toggleState,
          ),
          PopupMenuButton<String>(
            icon: const UlvenikIcon(UlvenikIcons.overflowMenu, color: _stoneGrey, size: 22),
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
                    UlvenikIcon.fromMaterial(
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
                    UlvenikIcon(UlvenikIcons.progress, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Insights', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'record',
                child: Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.add, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Record New Session', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.overflowMenu, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Analytics Report', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.overflowMenu, color: _offWhite, size: 18),
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
          pills: const ['Last 7 Days', 'Last 30 Days', 'This Year'],
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
          // Standard Statistics: Total Sessions & Total Duration
          Row(
            children: [
              Expanded(
                child: _buildOverviewMetricItem(
                  title: 'Total Sessions',
                  value: '48',
                  valueSize: 24,
                  onTap: () => _showMetricBreakdown(
                    'Total Sessions',
                    '48 completed',
                    'Recorded across active conditioning weeks.',
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

          // Row 2: Avg Duration & Custom Metric Statistic
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
                    'Average active duration per workout session.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (_customMetrics.isNotEmpty)
                Expanded(
                  child: _buildOverviewMetricItem(
                    title: 'Avg ${_customMetrics.first.name}',
                    value: _customMetrics.first.name.toLowerCase().contains('distance')
                        ? '1,850 m'
                        : _customMetrics.first.name.toLowerCase().contains('speed')
                            ? '18.4 mph'
                            : _customMetrics.first.name.toLowerCase().contains('load')
                                ? '16.5 kg'
                                : '10 ${_customMetrics.first.unit}',
                    valueSize: 20,
                    onTap: () => _showMetricBreakdown(
                      'Avg ${_customMetrics.first.name}',
                      'Recorded custom performance metric.',
                      'Calculated average across all completed sessions.',
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
          if (_customMetrics.length > 1) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewMetricItem(
                    title: 'Max ${_customMetrics[1].name}',
                    value: _customMetrics[1].name.toLowerCase().contains('incline')
                        ? '8%'
                        : _customMetrics[1].name.toLowerCase().contains('reps')
                            ? '15 reps'
                            : '20 ${_customMetrics[1].unit}',
                    valueSize: 20,
                    onTap: () => _showMetricBreakdown(
                      'Max ${_customMetrics[1].name}',
                      'Peak performance value',
                      'Highest recorded ${_customMetrics[1].name} for this activity.',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (_customMetrics.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_selectedTrendMetric != 'Sessions') {
                              setState(() {
                                _selectedTrendMetric = 'Sessions';
                                _chartAnimController.reset();
                                _chartAnimController.forward();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _selectedTrendMetric == 'Sessions'
                                  ? _forest
                                  : _surfaceHigh,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Sessions',
                              style: TextStyle(
                                color: _selectedTrendMetric == 'Sessions'
                                    ? _offWhite
                                    : _stoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            if (_selectedTrendMetric != _customMetrics.first.name) {
                              setState(() {
                                _selectedTrendMetric = _customMetrics.first.name;
                                _chartAnimController.reset();
                                _chartAnimController.forward();
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _selectedTrendMetric == _customMetrics.first.name
                                  ? _forest
                                  : _surfaceHigh,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _customMetrics.first.name,
                              style: TextStyle(
                                color: _selectedTrendMetric == _customMetrics.first.name
                                    ? _offWhite
                                    : _stoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
                    maxY: _selectedTrendMetric == 'Sessions'
                        ? (_selectedInterval == 'Y' ? 55 : 16)
                        : (_selectedInterval == 'Y' ? 35000 : 2200),
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
                          reservedSize: 32,
                          interval: _selectedTrendMetric == 'Sessions'
                              ? (_selectedInterval == 'Y' ? 20 : 5)
                              : (_selectedInterval == 'Y' ? 10000 : 1000),
                          getTitlesWidget: (val, meta) {
                            if (_selectedTrendMetric == 'Sessions') {
                              if (_selectedInterval == 'Y') {
                                if (val == 0 || val == 20 || val == 40) {
                                  return Text('${val.toInt()}',
                                      style: const TextStyle(
                                          color: _stoneGrey, fontSize: 10));
                                }
                              } else {
                                if (val == 0 || val == 5 || val == 10 || val == 15) {
                                  return Text('${val.toInt()}',
                                      style: const TextStyle(
                                          color: _stoneGrey, fontSize: 10));
                                }
                              }
                            } else {
                              if (val == 0) {
                                return const Text('0',
                                    style: TextStyle(
                                        color: _stoneGrey, fontSize: 10));
                              }
                              if (val == 1000 || val == 10000) {
                                return const Text('1k',
                                    style: TextStyle(
                                        color: _stoneGrey, fontSize: 10));
                              }
                              if (val == 2000 || val == 20000) {
                                return const Text('2k',
                                    style: TextStyle(
                                        color: _stoneGrey, fontSize: 10));
                              }
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

        // 2. Metrics Placeholder Card (Aligned with custom S&C metrics)
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
              if (_customMetrics.isNotEmpty) ...[
                const SizedBox(height: 24),
                for (int i = 0; i < _customMetrics.length; i += 2) ...[
                  if (i > 0) const SizedBox(height: 24),
                  if (i + 1 < _customMetrics.length)
                    _buildEmptyMetricRow(
                      'Avg ${_customMetrics[i].name}',
                      'Max ${_customMetrics[i + 1].name}',
                    )
                  else
                    _buildEmptyMetricRow(
                      'Avg ${_customMetrics[i].name}',
                      'Max ${_customMetrics[i].name}',
                    ),
                ],
              ],
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
                  UlvenikIcon(UlvenikIcons.play, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Record Session',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  UlvenikIcon(UlvenikIcons.details, size: 16),
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
