import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

/// Trainer Pack Business Analytics Screen.
/// Uses strictly "Session" terminology throughout (Sessions This Week,
/// Session Activity, 32 Sessions, Average 1.6 sessions/day).
class TrainerAnalyticsScreen extends StatefulWidget {
  const TrainerAnalyticsScreen({super.key});

  @override
  State<TrainerAnalyticsScreen> createState() => _TrainerAnalyticsScreenState();
}

class _TrainerAnalyticsScreenState extends State<TrainerAnalyticsScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian; // #101214
  static const Color _carbon = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _mintAccent = Color(0xFF34D399);
  static const Color _sageLight = Color(0xFFB6CCB5);
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _cardBorder = AppColors.cardBorder;

  static const List<String> _timeframes = [
    'THIS WEEK',
    'THIS MONTH',
    'LAST 90 DAYS',
  ];

  String _selectedTimeframe = 'THIS WEEK';

  ({
    String activeClients,
    String clientDogs,
    String sessionsCount,
    String sessionsLabel,
    String activeGoals,
    String homeworkCompletion,
    String sessionsRecorded,
    String activityHeadline,
    String activityDelta,
    String activitySublabel,
    String averagePerDay,
    String peakDay,
    List<double> dailyBars,
  }) get _metrics {
    return switch (_selectedTimeframe) {
      'THIS MONTH' => (
          activeClients: '12',
          clientDogs: '21',
          sessionsCount: '32',
          sessionsLabel: 'SESSIONS THIS MONTH',
          activeGoals: '31',
          homeworkCompletion: '84%',
          sessionsRecorded: '54',
          activityHeadline: '32 Sessions',
          activityDelta: '↑ +12% vs last mo',
          activitySublabel: 'THIS MONTH',
          averagePerDay: 'Average 1.6 sessions/day',
          peakDay: 'PEAK: WED',
          dailyBars: [3.5, 5.0, 8.5, 6.0, 7.2, 3.4, 2.2],
        ),
      'LAST 90 DAYS' => (
          activeClients: '14',
          clientDogs: '24',
          sessionsCount: '94',
          sessionsLabel: 'SESSIONS (90 DAYS)',
          activeGoals: '31',
          homeworkCompletion: '86%',
          sessionsRecorded: '158',
          activityHeadline: '94 Sessions',
          activityDelta: '↑ +18% vs prior 90d',
          activitySublabel: 'LAST 90 DAYS',
          averagePerDay: 'Average 1.5 sessions/day',
          peakDay: 'PEAK: WED',
          dailyBars: [4.0, 5.5, 9.0, 6.5, 7.5, 4.0, 2.5],
        ),
      _ => (
          activeClients: '12',
          clientDogs: '21',
          sessionsCount: '8',
          sessionsLabel: 'SESSIONS THIS WEEK',
          activeGoals: '31',
          homeworkCompletion: '82%',
          sessionsRecorded: '14',
          activityHeadline: '32 Sessions',
          activityDelta: '↑ +12% vs last mo',
          activitySublabel: 'THIS MONTH',
          averagePerDay: 'Average 1.6 sessions/day',
          peakDay: 'PEAK: WED',
          dailyBars: [3.0, 4.5, 8.2, 5.6, 6.8, 3.0, 1.8],
        ),
    };
  }

  void _shareAnalytics() {
    AppSnackbar.show(
      context,
      title: 'Analytics Summary Exported',
      message: 'Prepared Trainer Pack session & client analytics summary.',
      type: SnackbarType.success,
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Analytics Timeframe',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                ..._timeframes.map((tf) {
                  final selected = _selectedTimeframe == tf;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      setState(() => _selectedTimeframe = tf);
                      Navigator.pop(ctx);
                    },
                    title: Text(
                      tf,
                      style: TextStyle(
                        color: selected ? _mint : _offWhite,
                        fontSize: 13.5,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_rounded,
                            color: _mint,
                            size: 20,
                          )
                        : null,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = _metrics;

    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeframeRow(),
                    const SizedBox(height: 16),
                    _buildSixMetricCard(m),
                    const SizedBox(height: 24),
                    _buildSectionTitle('SESSION ACTIVITY'),
                    const SizedBox(height: 8),
                    _buildSessionActivityCard(m),
                    const SizedBox(height: 24),
                    _buildSectionTitle('HOMEWORK'),
                    const SizedBox(height: 8),
                    _buildHomeworkCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('GOALS'),
                    const SizedBox(height: 8),
                    _buildGoalsCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('CLIENT ENGAGEMENT'),
                    const SizedBox(height: 8),
                    _buildClientEngagementCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _stoneGrey,
              size: 26,
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 36),
              child: Text(
                'Analytics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Export Analytics',
            visualDensity: VisualDensity.compact,
            onPressed: _shareAnalytics,
            icon: const Icon(Icons.ios_share_rounded,
              color: _stoneGrey,
              size: 19,
            ),
          ),
          IconButton(
            tooltip: 'Filter Timeframe',
            visualDensity: VisualDensity.compact,
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.tune_rounded,
              color: _stoneGrey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _timeframes.map((tf) {
          final isSel = _selectedTimeframe == tf;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeframe = tf),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSel
                      ? _forest.withValues(alpha: 0.22)
                      : _carbon,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSel ? _forest : _cardBorder,
                  ),
                ),
                child: Text(
                  tf,
                  style: TextStyle(
                    color: isSel ? _mint : _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.15,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildSixMetricCard(
    ({
      String activeClients,
      String clientDogs,
      String sessionsCount,
      String sessionsLabel,
      String activeGoals,
      String homeworkCompletion,
      String sessionsRecorded,
      String activityHeadline,
      String activityDelta,
      String activitySublabel,
      String averagePerDay,
      String peakDay,
      List<double> dailyBars,
    }) m,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCell(m.activeClients, 'ACTIVE CLIENTS'),
                ),
                const VerticalDivider(color: _cardBorder, width: 24),
                Expanded(
                  child: _buildMetricCell(m.clientDogs, 'CLIENT DOGS'),
                ),
              ],
            ),
          ),
          const Divider(color: _cardBorder, height: 28),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCell(m.sessionsCount, m.sessionsLabel),
                ),
                const VerticalDivider(color: _cardBorder, width: 24),
                Expanded(
                  child: _buildMetricCell(m.activeGoals, 'ACTIVE GOALS'),
                ),
              ],
            ),
          ),
          const Divider(color: _cardBorder, height: 28),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricCell(
                    m.homeworkCompletion,
                    'HOMEWORK\nCOMPLETION',
                    valueColor: _mint,
                  ),
                ),
                const VerticalDivider(color: _cardBorder, width: 24),
                Expanded(
                  child: _buildMetricCell(
                    m.sessionsRecorded,
                    'SESSIONS RECORDED',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell(
    String value,
    String label, {
    Color valueColor = _offWhite,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.65,
            height: 1.3,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildSessionActivityCard(
    ({
      String activeClients,
      String clientDogs,
      String sessionsCount,
      String sessionsLabel,
      String activeGoals,
      String homeworkCompletion,
      String sessionsRecorded,
      String activityHeadline,
      String activityDelta,
      String activitySublabel,
      String averagePerDay,
      String peakDay,
      List<double> dailyBars,
    }) m,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
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
                m.activityHeadline,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                m.activityDelta,
                style: const TextStyle(
                  color: _mint,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            m.activitySublabel,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 124,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        final idx = v.toInt();
                        if (idx >= 0 && idx < days.length) {
                          final isPeak = idx == 2;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[idx],
                              style: TextStyle(
                                color: isPeak ? _offWhite : _stoneGrey,
                                fontSize: 10.5,
                                fontWeight:
                                    isPeak ? FontWeight.w800 : FontWeight.w500,
                                fontFamily: 'Inter',
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
                  horizontalInterval: 3,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0x16FFFFFF),
                    strokeWidth: 1,
                    dashArray: [3, 3],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  final isHighlight = i == 2;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: m.dailyBars[i],
                        color: isHighlight
                            ? const Color(0xFFA7F3D0)
                            : _forest.withValues(alpha: 0.85),
                        width: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const Divider(color: _cardBorder, height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                m.averagePerDay,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF262C30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  m.peakDay,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Completion Rate',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '82%',
                style: TextStyle(
                  color: _mint,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.82,
              backgroundColor: Color(0xFF262C30),
              valueColor: AlwaysStoppedAnimation<Color>(_forest),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Icon(Icons.circle, color: _mintAccent, size: 7),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  '11 completed',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Icon(Icons.circle, color: _alpineBlue, size: 7),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  '2 awaiting review',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.circle, color: Color(0xFFB45353), size: 7),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  '1 overdue',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Icon(Icons.circle, color: Color(0xFF5A6560), size: 7),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  '14 total assigned',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: _cardBorder, height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Avg completion pace',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _alpineBlue.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    UlvenikIcon(UlvenikIcons.trainingTime,
                      color: Color(0xFF8BB8D6),
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '4.2 days',
                      style: TextStyle(
                        color: Color(0xFF8BB8D6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _buildGoalSummaryCol('31', 'ACTIVE')),
                const VerticalDivider(color: _cardBorder, width: 1),
                Expanded(child: _buildGoalSummaryCol('18', 'COMPLETED')),
                const VerticalDivider(color: _cardBorder, width: 1),
                Expanded(child: _buildGoalSummaryCol('5.2w', 'AVG TIME')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: Container(color: _forest),
                  ),
                  Expanded(
                    flex: 35,
                    child: Container(color: _sageLight),
                  ),
                  Expanded(
                    flex: 25,
                    child: Container(color: _alpineBlue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _GoalLegendDot(color: _forest, label: 'OBEDIENCE 40%'),
              _GoalLegendDot(color: _sageLight, label: 'SOCIAL 35%'),
              _GoalLegendDot(color: _alpineBlue, label: 'HEALTH 25%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummaryCol(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.55,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildClientEngagementCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '30-Day Activity & Submissions',
            style: TextStyle(
              color: _offWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 3,
                minY: 0,
                maxY: 10,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0x14FFFFFF),
                    strokeWidth: 1,
                    dashArray: [3, 3],
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (v, _) {
                        const weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                        final idx = v.toInt();
                        if (idx >= 0 && idx < weeks.length && v == idx) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weeks[idx],
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 10,
                                fontFamily: 'Inter',
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: _forest,
                    barWidth: 2.2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _forest.withValues(alpha: 0.14),
                    ),
                    spots: const [
                      FlSpot(0, 2.2),
                      FlSpot(1, 5.4),
                      FlSpot(2, 6.2),
                      FlSpot(3, 8.6),
                    ],
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: _alpineBlue,
                    barWidth: 1.8,
                    dashArray: [4, 4],
                    dotData: const FlDotData(show: false),
                    spots: const [
                      FlSpot(0, 1.4),
                      FlSpot(1, 3.6),
                      FlSpot(2, 4.5),
                      FlSpot(3, 6.8),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Icon(Icons.horizontal_rule_rounded, color: _forest, size: 16),
              SizedBox(width: 5),
              Text(
                'Training Activity',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(width: 16),
              UlvenikIcon(UlvenikIcons.more, color: _alpineBlue, size: 16),
              SizedBox(width: 5),
              Text(
                'Homework Submissions',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalLegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _GoalLegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

