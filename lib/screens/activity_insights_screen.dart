import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_snackbar.dart';
import 'record_session_screen.dart';
import 'activity_statistics_screen.dart';
import 'activity_goals_screen.dart';

/// Screen representing "Activity Insights" covering both:
/// 1. Populated State (Line 153 in Handover Doc)
/// 2. Empty State (Line 152 in Handover Doc)
///
/// Features dynamic Consistency Bento Grid, animated and interactive LineChart
/// with glowing stroke and active tooltip, metric tabs (Sessions / Duration / Avg Duration),
/// Weekly/Monthly interval switcher, Milestones carousel, Progress Summary cards,
/// state toggling, and clean navigation flow.
class ActivityInsightsScreen extends StatefulWidget {
  final String activityName;
  final bool initialEmpty;

  const ActivityInsightsScreen({
    super.key,
    this.activityName = 'Swimming Fitness',
    this.initialEmpty = false,
  });

  @override
  State<ActivityInsightsScreen> createState() => _ActivityInsightsScreenState();
}

class _ActivityInsightsScreenState extends State<ActivityInsightsScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
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
  String _selectedDateRange = 'Last 90 Days';

  // Activity Trends Sub-tab: 'Sessions', 'Duration', 'Avg Duration'
  String _selectedTrendTab = 'Sessions';

  // Chart Interval: 'Weekly' or 'Monthly'
  String _selectedInterval = 'Weekly';

  // Interactive selected point index on graph (default to 6 which corresponds to W3 Aug in Weekly)
  int _selectedSpotIndex = 6;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
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
  // DATA PROVIDERS FOR TRENDS CHART
  // ===========================================================================

  List<FlSpot> _getChartPoints() {
    if (_selectedInterval == 'Monthly') {
      // 5 months: Apr, May, Jun, Jul, Aug
      if (_selectedTrendTab == 'Duration') {
        return const [
          FlSpot(0, 14.0),
          FlSpot(1, 22.0),
          FlSpot(2, 28.0),
          FlSpot(3, 34.0),
          FlSpot(4, 40.0),
        ];
      } else if (_selectedTrendTab == 'Avg Duration') {
        return const [
          FlSpot(0, 36.0),
          FlSpot(1, 38.0),
          FlSpot(2, 42.0),
          FlSpot(3, 44.0),
          FlSpot(4, 46.0),
        ];
      } else {
        // Sessions
        return const [
          FlSpot(0, 6.0),
          FlSpot(1, 9.0),
          FlSpot(2, 11.0),
          FlSpot(3, 14.0),
          FlSpot(4, 18.0),
        ];
      }
    } else {
      // Weekly: 8 weeks (W1 Jul - W4 Aug)
      // Matches Figma polyline curve exactly:
      // Starts low ~2.0, rises to ~4.5, ~6.0, peaks at ~9.5 at W4 Jul, dips to ~4.0 at W1 Aug,
      // rises to ~7.0 at W2 Aug, hits 12.0 at W3 Aug, and climbs to 13.5 at W4 Aug.
      if (_selectedTrendTab == 'Duration') {
        return const [
          FlSpot(0, 1.5),
          FlSpot(1, 3.2),
          FlSpot(2, 4.8),
          FlSpot(3, 7.5),
          FlSpot(4, 3.0),
          FlSpot(5, 5.5),
          FlSpot(6, 9.2),
          FlSpot(7, 10.5),
        ];
      } else if (_selectedTrendTab == 'Avg Duration') {
        return const [
          FlSpot(0, 35.0),
          FlSpot(1, 38.0),
          FlSpot(2, 40.0),
          FlSpot(3, 45.0),
          FlSpot(4, 38.0),
          FlSpot(5, 42.0),
          FlSpot(6, 46.0),
          FlSpot(7, 47.0),
        ];
      } else {
        // Sessions
        return const [
          FlSpot(0, 2.5),
          FlSpot(1, 4.5),
          FlSpot(2, 6.0),
          FlSpot(3, 9.5),
          FlSpot(4, 4.0),
          FlSpot(5, 7.0),
          FlSpot(6, 12.0),
          FlSpot(7, 13.5),
        ];
      }
    }
  }

  List<String> _getXAxisLabels() {
    if (_selectedInterval == 'Monthly') {
      return ['Apr', 'May', 'Jun', 'Jul', 'Aug'];
    }
    return [
      'W1 Jul',
      'W2 Jul',
      'W3 Jul',
      'W4 Jul',
      'W1 Aug',
      'W2 Aug',
      'W3 Aug',
      'W4 Aug',
    ];
  }

  double _getMaxY() {
    if (_selectedTrendTab == 'Duration') return 15;
    if (_selectedTrendTab == 'Avg Duration') return 60;
    return 15; // Sessions: 0, 5, 10, 15
  }

  double _getYInterval() {
    if (_selectedTrendTab == 'Duration') return 5;
    if (_selectedTrendTab == 'Avg Duration') return 15;
    return 5;
  }

  String _formatYAxisTitle(double value) {
    if (_selectedTrendTab == 'Duration') {
      return '${value.toInt()}h';
    } else if (_selectedTrendTab == 'Avg Duration') {
      return '${value.toInt()}m';
    } else {
      return value.toInt().toString();
    }
  }

  String _getTooltipTitle(int index) {
    final labels = _getXAxisLabels();
    if (index >= 0 && index < labels.length) {
      return labels[index].toUpperCase();
    }
    return 'W3 AUG';
  }

  String _getTooltipValue(int index) {
    if (_selectedInterval == 'Monthly') {
      if (_selectedTrendTab == 'Duration') {
        const vals = ['14.0h', '22.0h', '28.0h', '34.0h', '40.0h'];
        return index < vals.length ? vals[index] : '28.0h';
      } else if (_selectedTrendTab == 'Avg Duration') {
        const vals = ['36m avg', '38m avg', '42m avg', '44m avg', '46m avg'];
        return index < vals.length ? vals[index] : '42m avg';
      } else {
        const vals = ['6 Sessions', '9 Sessions', '11 Sessions', '14 Sessions', '18 Sessions'];
        return index < vals.length ? vals[index] : '14 Sessions';
      }
    } else {
      if (_selectedTrendTab == 'Duration') {
        const vals = ['1.5h', '3.2h', '4.8h', '7.5h', '3.0h', '5.5h', '9.2h', '10.5h'];
        return index < vals.length ? vals[index] : '9.2h';
      } else if (_selectedTrendTab == 'Avg Duration') {
        const vals = ['35m avg', '38m avg', '40m avg', '45m avg', '38m avg', '42m avg', '46m avg', '47m avg'];
        return index < vals.length ? vals[index] : '46m avg';
      } else {
        const vals = [
          '2 Sessions',
          '4 Sessions',
          '6 Sessions',
          '9 Sessions',
          '4 Sessions',
          '7 Sessions',
          '12 Sessions',
          '14 Sessions',
        ];
        return index < vals.length ? vals[index] : '12 Sessions';
      }
    }
  }

  // Dynamic Bento Metrics based on Date Range
  Map<String, dynamic> _getBentoMetrics() {
    switch (_selectedDateRange) {
      case 'Last 30 Days':
        return {
          'currentStreak': '8 Days',
          'longestStreak': '14 Days',
          'mostConsistent': 'August',
          'avgWeek': '3.2',
          'totalSessions': '18',
          'avgMonth': '18.0',
        };
      case 'Last 6 Months':
        return {
          'currentStreak': '12 Days',
          'longestStreak': '31 Days',
          'mostConsistent': 'March',
          'avgWeek': '2.6',
          'totalSessions': '92',
          'avgMonth': '11.2',
        };
      case 'All Time':
        return {
          'currentStreak': '12 Days',
          'longestStreak': '42 Days',
          'mostConsistent': 'March',
          'avgWeek': '2.5',
          'totalSessions': '164',
          'avgMonth': '10.8',
        };
      case 'Last 90 Days':
      default:
        return {
          'currentStreak': '12 Days',
          'longestStreak': '31 Days',
          'mostConsistent': 'March',
          'avgWeek': '2.8',
          'totalSessions': '48',
          'avgMonth': '10.4',
        };
    }
  }

  // ===========================================================================
  // INTERACTIVE MODAL SHEETS
  // ===========================================================================

  void _showMilestoneModal({
    required String milestone,
    required String title,
    required bool achieved,
    required String description,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: achieved ? _forest.withValues(alpha: 0.25) : _obsidian,
                    shape: BoxShape.circle,
                    border: _hairlineBorder,
                  ),
                  child: Icon(
                    achieved ? Icons.emoji_events : Icons.lock,
                    color: achieved ? _mint : _stoneGrey,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$milestone $title',
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        achieved ? 'Milestone Achieved' : 'In Progress',
                        style: TextStyle(
                          color: achieved ? _mint : _stoneGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBentoDetailModal({
    required String title,
    required String value,
    required String explanation,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: _mint,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              explanation,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Dismiss', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
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
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onDoubleTap: _toggleState,
          child: Column(
            children: [
              const Text(
                'Activity Insights',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
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
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _mint),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'toggle') {
                _toggleState();
              } else if (val == 'record') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecordSessionScreen(
                      initialActivityName: widget.activityName,
                      startWithActivity: true,
                    ),
                  ),
                );
              } else if (val == 'stats') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityStatisticsScreen(
                      activityName: widget.activityName,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'goals') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityGoalsScreen(
                      activityName: widget.activityName,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'share') {
                ScaffoldMessenger.of(context).clearSnackBars();
                AppSnackbar.show(
                  context,
                  message: 'Activity Insights report copied to clipboard',
                  type: SnackbarType.success,
                );
              } else if (val == 'export') {
                ScaffoldMessenger.of(context).clearSnackBars();
                AppSnackbar.show(
                  context,
                  message: 'Exporting Swimming Fitness Insights summary...',
                  type: SnackbarType.info,
                );
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      _isEmpty ? Icons.insights : Icons.hourglass_empty,
                      color: _mint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEmpty ? 'Switch to Populated State' : 'Switch to Empty State',
                      style: const TextStyle(color: _offWhite, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'record',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Record Session', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Statistics', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'goals',
                child: Row(
                  children: [
                    Icon(Icons.flag, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Goals', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Share Insights', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Analytics', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
        child: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
      ),
    );
  }

  // ===========================================================================
  // STATE A: POPULATED STATE (SCREENSHOT 1)
  // ===========================================================================

  Widget _buildPopulatedState() {
    final bento = _getBentoMetrics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Date Range Filter Pills
        _buildDateRangeSelector(),
        const SizedBox(height: 24),

        // 2. Consistency Section (Bento Grid)
        _buildConsistencyBentoGrid(bento),
        const SizedBox(height: 24),

        // 3. Activity Trends Section (Interactive Animated Graph)
        _buildActivityTrendsCard(),
        const SizedBox(height: 24),

        // 4. Milestones Section
        _buildMilestonesSection(),
        const SizedBox(height: 24),

        // 5. Progress Summary Section
        _buildProgressSummaryCard(),
      ],
    );
  }

  // 1. Date Range Filter Selector
  Widget _buildDateRangeSelector() {
    final ranges = ['Last 30 Days', 'Last 90 Days', 'Last 6 Months', 'All Time'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ranges.map((range) {
          final isSelected = _selectedDateRange == range;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDateRange = range;
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(9999),
                  border: isSelected
                      ? Border.all(color: _forest)
                      : _hairlineBorder,
                ),
                child: Text(
                  range,
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

  // 2. Consistency Bento Grid
  Widget _buildConsistencyBentoGrid(Map<String, dynamic> bento) {
    return Column(
      children: [
        // Row 1: Current Streak + Longest Streak
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                title: 'CURRENT STREAK',
                value: bento['currentStreak'],
                valueColor: _mint,
                onTap: () => _showBentoDetailModal(
                  title: 'Current Streak',
                  value: bento['currentStreak'],
                  explanation:
                      'Your dog has stayed active for 12 consecutive training days without missing a scheduled session.',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBentoCard(
                title: 'LONGEST STREAK',
                value: bento['longestStreak'],
                valueColor: _offWhite,
                onTap: () => _showBentoDetailModal(
                  title: 'Longest Streak',
                  value: bento['longestStreak'],
                  explanation:
                      'All-time best streak achieved in June 2026. Keep this pace to beat it!',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Most Consistent + Avg / Week
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                title: 'MOST CONSISTENT',
                value: bento['mostConsistent'],
                valueColor: _offWhite,
                onTap: () => _showBentoDetailModal(
                  title: 'Most Consistent Month',
                  value: bento['mostConsistent'],
                  explanation:
                      'March recorded the highest density of swim sessions and lowest gap between workouts.',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBentoCard(
                title: 'AVG / WEEK',
                value: bento['avgWeek'],
                valueColor: _offWhite,
                onTap: () => _showBentoDetailModal(
                  title: 'Average Sessions Per Week',
                  value: '${bento['avgWeek']} Sessions',
                  explanation:
                      'Calculated over the selected period. Recommended target for swimming conditioning is 3.0 sessions/week.',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 3: Total Sessions + Avg / Month (Full Width)
        InkWell(
          onTap: () => _showBentoDetailModal(
            title: 'Session Frequency Breakdown',
            value: '${bento['totalSessions']} Total Sessions',
            explanation:
                'Averaging ${bento['avgMonth']} sessions per month. Your dog has completed a strong aerobic training cycle.',
          ),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: _hairlineBorder,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL SESSIONS',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bento['totalSessions'],
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'AVG / MONTH',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bento['avgMonth'],
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String value,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: _hairlineBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Activity Trends Section (Interactive Animated Graph)
  Widget _buildActivityTrendsCard() {
    final points = _getChartPoints();
    final xLabels = _getXAxisLabels();
    final maxY = _getMaxY();
    final yInterval = _getYInterval();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Activity Trends',
            style: TextStyle(
              color: _offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Internal Sub-tabs (Sessions, Duration, Avg Duration)
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: ['Sessions', 'Duration', 'Avg Duration'].map((tab) {
                final isSelected = _selectedTrendTab == tab;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTrendTab = tab;
                      _chartAnimController.reset();
                      _chartAnimController.forward();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8, right: 18),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? const Border(
                              bottom: BorderSide(color: _mint, width: 2),
                            )
                          : null,
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSelected ? _mint : _stoneGrey,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Chart Area with Y-axis Labels and Animated Line
          SizedBox(
            height: 190,
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
                    maxY: maxY,
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
                        getTooltipColor: (_) => _carbon,
                        tooltipBorder: BorderSide(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        tooltipPadding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final title = _getTooltipTitle(spot.spotIndex);
                            final val = _getTooltipValue(spot.spotIndex);
                            return LineTooltipItem(
                              '$title\n',
                              const TextStyle(
                                color: _stoneGrey,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.05,
                              ),
                              children: [
                                TextSpan(
                                  text: val,
                                  style: const TextStyle(
                                    color: _mint,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: yInterval,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: Colors.white.withValues(alpha: 0.05),
                        strokeWidth: 0.8,
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
                          reservedSize: 26,
                          interval: yInterval,
                          getTitlesWidget: (val, meta) {
                            return Text(
                              _formatYAxisTitle(val),
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // custom below
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: _hairlineSide,
                        bottom: _hairlineSide,
                      ),
                    ),
                    lineBarsData: [
                      // Glow Line Layer (thicker, translucent)
                      LineChartBarData(
                        spots: animatedSpots,
                        isCurved: false,
                        color: _forest.withValues(alpha: 0.28),
                        barWidth: 6,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                      // Main Crisp Line Layer
                      LineChartBarData(
                        spots: animatedSpots,
                        isCurved: false,
                        color: _forest,
                        barWidth: 2.2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) {
                            return spot.x.toInt() == _selectedSpotIndex;
                          },
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4.5,
                              color: _carbon,
                              strokeWidth: 2.2,
                              strokeColor: _forest,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // X-Axis Labels (Highlight active point in Mint)
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(xLabels.length, (i) {
                final isSelected = i == _selectedSpotIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSpotIndex = i);
                  },
                  child: Text(
                    xLabels[i].toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? _mint : _stoneGrey,
                      fontSize: 9,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Weekly / Monthly Toggle Pill
          Center(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.circular(9999),
                border: _hairlineBorder,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ['Weekly', 'Monthly'].map((interval) {
                  final isSel = _selectedInterval == interval;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedInterval = interval;
                        _selectedSpotIndex = interval == 'Weekly' ? 6 : 4;
                        _chartAnimController.reset();
                        _chartAnimController.forward();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSel ? _carbon : Colors.transparent,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        interval.toUpperCase(),
                        style: TextStyle(
                          color: isSel ? _offWhite : _stoneGrey,
                          fontSize: 10,
                          fontWeight:
                              isSel ? FontWeight.w700 : FontWeight.w500,
                          letterSpacing: 0.05,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Milestones Section
  Widget _buildMilestonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Milestones',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildMilestoneCard(
                milestone: '10',
                achieved: true,
                description:
                    'Achieved: Completed 10 swimming fitness workouts! Core water confidence baseline established.',
              ),
              const SizedBox(width: 12),
              _buildMilestoneCard(
                milestone: '25',
                achieved: true,
                description:
                    'Achieved: 25 completed sessions! Noticeable gain in canine stamina, stroke power, and muscle recovery.',
              ),
              const SizedBox(width: 12),
              _buildMilestoneCard(
                milestone: '50',
                achieved: true,
                description:
                    'Achieved: 50 milestone reached! Exceptional dedication and conditioning benchmark reached.',
              ),
              const SizedBox(width: 12),
              _buildMilestoneCard(
                milestone: '100',
                achieved: false,
                description:
                    'Locked: 52 sessions remaining to unlock the elite Century Club milestone badge!',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneCard({
    required String milestone,
    required bool achieved,
    required String description,
  }) {
    return InkWell(
      onTap: () => _showMilestoneModal(
        milestone: milestone,
        title: 'Sessions Milestone',
        achieved: achieved,
        description: description,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 110,
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: achieved
              ? _hairlineBorder
              : Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  style: BorderStyle.solid,
                ),
        ),
        child: Opacity(
          opacity: achieved ? 1.0 : 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: achieved
                      ? _forest.withValues(alpha: 0.22)
                      : _obsidian,
                  shape: BoxShape.circle,
                  border: achieved ? null : _hairlineBorder,
                ),
                child: Icon(
                  achieved ? Icons.emoji_events : Icons.lock,
                  color: achieved ? _mint : _stoneGrey,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                milestone,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'SESSIONS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Progress Summary Section
  Widget _buildProgressSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Summary',
            style: TextStyle(
              color: _offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 16),
          _buildSummaryItem(
            icon: Icons.trending_up,
            richText: RichText(
              text: const TextSpan(
                style: TextStyle(color: _offWhite, fontSize: 14, height: 1.4),
                children: [
                  TextSpan(text: 'Activity has increased by '),
                  TextSpan(
                    text: '15%',
                    style: TextStyle(
                        color: _mint, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                      text: ' compared to the previous 90-day period.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            icon: Icons.calendar_month,
            richText: RichText(
              text: const TextSpan(
                style: TextStyle(color: _offWhite, fontSize: 14, height: 1.4),
                children: [
                  TextSpan(text: 'Highly consistent, averaging '),
                  TextSpan(
                    text: '3 sessions',
                    style: TextStyle(
                        color: _mint, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' per week with minimal gaps.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            icon: Icons.timer,
            richText: RichText(
              text: const TextSpan(
                style: TextStyle(color: _offWhite, fontSize: 14, height: 1.4),
                children: [
                  TextSpan(text: 'Duration remains stable at an average of '),
                  TextSpan(
                    text: '45m',
                    style: TextStyle(
                        color: _mint, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' per session.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
            icon: Icons.local_fire_department,
            richText: RichText(
              text: const TextSpan(
                style: TextStyle(color: _offWhite, fontSize: 14, height: 1.4),
                children: [
                  TextSpan(
                      text:
                          'On track to beat longest streak of 31 days if current pace is maintained.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required Widget richText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _mint, size: 20),
        const SizedBox(width: 12),
        Expanded(child: richText),
      ],
    );
  }

  // ===========================================================================
  // STATE B: EMPTY STATE (SCREENSHOT 2)
  // ===========================================================================

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        // Centered Date Range Pill
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(9999),
              border: _hairlineBorder,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: _stoneGrey, size: 14),
                SizedBox(width: 8),
                Text(
                  'Last 90 Days',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 90),

        // Large Circular Icon Container
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2825),
            shape: BoxShape.circle,
            border: Border.all(
              color: _forest.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.trending_up,
              color: _mint,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Title
        const Text(
          'No Insights Available',
          style: TextStyle(
            color: _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Description
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Complete more sessions to unlock insights into your dog\'s Strength & Conditioning progress.',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 36),

        // Action CTA: ▶ Record Session →
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecordSessionScreen(
                    initialActivityName: widget.activityName,
                    startWithActivity: true,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, size: 16, color: _offWhite),
                SizedBox(width: 8),
                Text(
                  'Record Session',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 16, color: _offWhite),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
