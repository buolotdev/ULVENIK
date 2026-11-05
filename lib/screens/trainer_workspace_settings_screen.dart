import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _AnalyticsDataset {
  final String totalTime;
  final String totalTimeDelta;
  final String sessions;
  final String sessionsDelta;
  final String frequency;
  final String goalsCompleted;
  final String goalsSubtitle;
  final List<double> timeSpark;
  final List<double> sessionsSpark;
  final List<double> freqSpark;
  final List<double> goalsSpark;
  final List<double> weeklyValues;
  final List<String> weeklyLabels;
  final List<String> weeklyFormatted;
  final String generalTime;
  final double generalRatio;
  final String scTime;
  final double scRatio;
  final String compTime;
  final double compRatio;
  final String peakLabel;
  final String activeWindow;
  final List<List<int>> heatmap;
  final int streakDays;
  final String streakSubtext;

  const _AnalyticsDataset({
    required this.totalTime,
    required this.totalTimeDelta,
    required this.sessions,
    required this.sessionsDelta,
    required this.frequency,
    required this.goalsCompleted,
    required this.goalsSubtitle,
    required this.timeSpark,
    required this.sessionsSpark,
    required this.freqSpark,
    required this.goalsSpark,
    required this.weeklyValues,
    required this.weeklyLabels,
    required this.weeklyFormatted,
    required this.generalTime,
    required this.generalRatio,
    required this.scTime,
    required this.scRatio,
    required this.compTime,
    required this.compRatio,
    required this.peakLabel,
    required this.activeWindow,
    required this.heatmap,
    required this.streakDays,
    required this.streakSubtext,
  });
}

class TrainerWorkspaceSettingsScreen extends StatefulWidget {
  final bool hasSportPack;
  final bool hasRecordedCompetitionActivity;

  const TrainerWorkspaceSettingsScreen({
    super.key,
    this.hasSportPack = false,
    this.hasRecordedCompetitionActivity = false,
  });

  @override
  State<TrainerWorkspaceSettingsScreen> createState() =>
      _TrainerWorkspaceSettingsScreenState();
}

class _TrainerWorkspaceSettingsScreenState
    extends State<TrainerWorkspaceSettingsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = Color(0xFF0A0C0E);
  static const Color _cardBg = Color(0xFF121619);
  static const Color _cardBorder = Color(0xFF1E252B);
  static const Color _mintBright = Color(0xFF34D399);
  static const Color _emerald = Color(0xFF10B981);
  static const Color _emeraldBorder = Color(0xFF059669);
  static const Color _emeraldDark = Color(0xFF064E3B);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFFC084FC);
  static const Color _textSecondary = Color(0xFF94A3B8);
  static const Color _textMuted = Color(0xFF64748B);
  static const Color _textLight = Color(0xFFCBD5E1);
  static const Color _trackBg = Color(0xFF1E293B);

  static const List<String> _periods = [
    'This Week',
    'This Month',
    'Last 3 Months',
    'This Year',
  ];

  static const List<String> _tabs = [
    'Overview',
    'Training',
    'S&C',
    'Skills',
    'Health',
  ];

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  String _selectedPeriod = 'This Month';
  int _selectedTabIndex = 0;
  int? _selectedTrendPoint;
  int? _selectedBreakdownIndex;
  (int, int)? _selectedHeatCell;
  int? _highlightedKpiIndex;

  static const Map<String, _AnalyticsDataset> _datasetsByTab = {
    'Overview': _AnalyticsDataset(
      totalTime: '24h 35m',
      totalTimeDelta: '+16%',
      sessions: '18',
      sessionsDelta: '+12%',
      frequency: '4.5',
      goalsCompleted: '8',
      goalsSubtitle: '3 active goals',
      timeSpark: [0.22, 0.24, 0.52, 0.56, 0.30, 0.48, 0.72],
      sessionsSpark: [0.16, 0.34, 0.32, 0.22, 0.26, 0.36, 0.70],
      freqSpark: [0.28, 0.18, 0.26, 0.48, 0.62, 0.54, 0.46],
      goalsSpark: [0.36, 0.42, 0.40, 0.48, 0.54, 0.62, 0.70],
      weeklyValues: [0.26, 0.54, 0.40, 0.63, 0.52, 0.67, 0.74],
      weeklyLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      weeklyFormatted: [
        '4h 10m',
        '5h 40m',
        '4h 25m',
        '6h 15m',
        '5h 30m',
        '6h 40m',
        '7h 10m',
      ],
      generalTime: '7h 15m',
      generalRatio: 0.62,
      scTime: '3h 20m',
      scRatio: 0.34,
      compTime: '1h 10m',
      compRatio: 0.16,
      peakLabel: 'Tuesdays peak',
      activeWindow: 'Most active time: 16:00 - 18:00',
      heatmap: [
        [0, 1, 2, 4, 1, 0, 0],
        [1, 4, 3, 2, 3, 1, 0],
        [0, 3, 4, 2, 0, 0, 0],
      ],
      streakDays: 12,
      streakSubtext: '15 sessions during this streak',
    ),
    'Training': _AnalyticsDataset(
      totalTime: '16h 20m',
      totalTimeDelta: '+19%',
      sessions: '12',
      sessionsDelta: '+15%',
      frequency: '3.2',
      goalsCompleted: '5',
      goalsSubtitle: '2 active goals',
      timeSpark: [0.20, 0.35, 0.46, 0.58, 0.52, 0.68, 0.80],
      sessionsSpark: [0.24, 0.30, 0.44, 0.38, 0.52, 0.60, 0.74],
      freqSpark: [0.22, 0.30, 0.42, 0.50, 0.58, 0.64, 0.62],
      goalsSpark: [0.40, 0.46, 0.52, 0.56, 0.62, 0.68, 0.74],
      weeklyValues: [0.30, 0.58, 0.48, 0.68, 0.60, 0.72, 0.82],
      weeklyLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      weeklyFormatted: [
        '2h 50m',
        '3h 45m',
        '3h 10m',
        '4h 20m',
        '3h 55m',
        '4h 30m',
        '4h 55m',
      ],
      generalTime: '9h 40m',
      generalRatio: 0.72,
      scTime: '4h 10m',
      scRatio: 0.38,
      compTime: '2h 30m',
      compRatio: 0.24,
      peakLabel: 'Thursdays peak',
      activeWindow: 'Most active time: 17:00 - 19:00',
      heatmap: [
        [1, 2, 2, 4, 2, 1, 0],
        [1, 3, 2, 4, 3, 1, 0],
        [0, 2, 3, 3, 1, 0, 0],
      ],
      streakDays: 14,
      streakSubtext: '12 sessions during this streak',
    ),
    'S&C': _AnalyticsDataset(
      totalTime: '5h 45m',
      totalTimeDelta: '+11%',
      sessions: '8',
      sessionsDelta: '+9%',
      frequency: '2.0',
      goalsCompleted: '3',
      goalsSubtitle: '1 active goal',
      timeSpark: [0.18, 0.28, 0.34, 0.48, 0.44, 0.56, 0.66],
      sessionsSpark: [0.20, 0.24, 0.36, 0.34, 0.42, 0.50, 0.62],
      freqSpark: [0.30, 0.32, 0.38, 0.44, 0.48, 0.52, 0.56],
      goalsSpark: [0.55, 0.58, 0.60, 0.64, 0.66, 0.70, 0.76],
      weeklyValues: [0.22, 0.40, 0.46, 0.54, 0.50, 0.62, 0.68],
      weeklyLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      weeklyFormatted: [
        '55m',
        '1h 15m',
        '1h 20m',
        '1h 35m',
        '1h 25m',
        '1h 45m',
        '1h 55m',
      ],
      generalTime: '1h 30m',
      generalRatio: 0.28,
      scTime: '3h 35m',
      scRatio: 0.76,
      compTime: '40m',
      compRatio: 0.14,
      peakLabel: 'Wednesdays peak',
      activeWindow: 'Most active time: 08:00 - 10:00',
      heatmap: [
        [1, 0, 4, 1, 2, 2, 0],
        [0, 2, 4, 2, 1, 3, 0],
        [0, 1, 3, 1, 1, 1, 0],
      ],
      streakDays: 9,
      streakSubtext: '6 sessions during this streak',
    ),
    'Skills': _AnalyticsDataset(
      totalTime: '8h 10m',
      totalTimeDelta: '+22%',
      sessions: '14',
      sessionsDelta: '+18%',
      frequency: '3.5',
      goalsCompleted: '6',
      goalsSubtitle: '2 active goals',
      timeSpark: [0.15, 0.26, 0.38, 0.42, 0.58, 0.64, 0.78],
      sessionsSpark: [0.22, 0.28, 0.40, 0.46, 0.50, 0.62, 0.72],
      freqSpark: [0.24, 0.34, 0.40, 0.52, 0.56, 0.60, 0.68],
      goalsSpark: [0.32, 0.34, 0.38, 0.42, 0.40, 0.46, 0.52],
      weeklyValues: [0.20, 0.38, 0.50, 0.58, 0.64, 0.70, 0.78],
      weeklyLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      weeklyFormatted: [
        '1h 15m',
        '1h 40m',
        '2h 05m',
        '2h 20m',
        '2h 35m',
        '2h 45m',
        '3h 05m',
      ],
      generalTime: '4h 50m',
      generalRatio: 0.58,
      scTime: '1h 35m',
      scRatio: 0.24,
      compTime: '1h 45m',
      compRatio: 0.28,
      peakLabel: 'Fridays peak',
      activeWindow: 'Most active time: 15:00 - 17:00',
      heatmap: [
        [0, 2, 1, 2, 4, 1, 0],
        [1, 2, 3, 2, 4, 2, 0],
        [0, 1, 2, 2, 3, 0, 0],
      ],
      streakDays: 11,
      streakSubtext: '10 sessions during this streak',
    ),
    'Health': _AnalyticsDataset(
      totalTime: '2h 30m',
      totalTimeDelta: '+8%',
      sessions: '6',
      sessionsDelta: '+5%',
      frequency: '1.5',
      goalsCompleted: '2',
      goalsSubtitle: '1 active goal',
      timeSpark: [0.30, 0.34, 0.32, 0.40, 0.44, 0.48, 0.54],
      sessionsSpark: [0.28, 0.32, 0.34, 0.38, 0.42, 0.46, 0.52],
      freqSpark: [0.34, 0.36, 0.36, 0.40, 0.42, 0.44, 0.48],
      goalsSpark: [0.70, 0.72, 0.76, 0.78, 0.80, 0.84, 0.88],
      weeklyValues: [0.38, 0.44, 0.42, 0.52, 0.56, 0.60, 0.66],
      weeklyLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      weeklyFormatted: [
        '25m',
        '30m',
        '28m',
        '35m',
        '38m',
        '42m',
        '45m',
      ],
      generalTime: '1h 05m',
      generalRatio: 0.44,
      scTime: '1h 00m',
      scRatio: 0.40,
      compTime: '25m',
      compRatio: 0.16,
      peakLabel: 'Sundays peak',
      activeWindow: 'Most active time: 10:00 - 12:00',
      heatmap: [
        [0, 1, 0, 1, 0, 2, 4],
        [0, 1, 1, 0, 1, 2, 4],
        [0, 0, 1, 0, 0, 1, 3],
      ],
      streakDays: 12,
      streakSubtext: '4 sessions during this streak',
    ),
  };

  bool _shouldShowCompetition(_AnalyticsDataset data) {
    return widget.hasSportPack &&
        widget.hasRecordedCompetitionActivity &&
        data.compRatio > 0 &&
        data.compTime.trim().isNotEmpty;
  }

  _AnalyticsDataset get _activeData {
    final base =
        _datasetsByTab[_tabs[_selectedTabIndex]] ?? _datasetsByTab['Overview']!;
    if (_selectedPeriod == 'This Month') return base;

    final mult = switch (_selectedPeriod) {
      'This Week' => 0.28,
      'Last 3 Months' => 2.85,
      'This Year' => 9.4,
      _ => 1.0,
    };

    final baseSess = int.tryParse(base.sessions) ?? 18;
    final scaledSess = math.max(1, (baseSess * mult).round());
    final baseGoals = int.tryParse(base.goalsCompleted) ?? 8;
    final scaledGoals = math.max(1, (baseGoals * mult).round());
    final periodHours = (24.58 * mult).round();
    final periodMins = ((24.58 * mult - periodHours).abs() * 60).round() % 60;

    return _AnalyticsDataset(
      totalTime:
          '${math.max(2, periodHours)}h ${periodMins.toString().padLeft(2, '0')}m',
      totalTimeDelta: base.totalTimeDelta,
      sessions: '$scaledSess',
      sessionsDelta: base.sessionsDelta,
      frequency: base.frequency,
      goalsCompleted: '$scaledGoals',
      goalsSubtitle: base.goalsSubtitle,
      timeSpark: base.timeSpark,
      sessionsSpark: base.sessionsSpark,
      freqSpark: base.freqSpark,
      goalsSpark: base.goalsSpark,
      weeklyValues: base.weeklyValues,
      weeklyLabels: base.weeklyLabels,
      weeklyFormatted: base.weeklyFormatted,
      generalTime: base.generalTime,
      generalRatio: base.generalRatio,
      scTime: base.scTime,
      scRatio: base.scRatio,
      compTime: base.compTime,
      compRatio: base.compRatio,
      peakLabel: base.peakLabel,
      activeWindow: base.activeWindow,
      heatmap: base.heatmap,
      streakDays: base.streakDays,
      streakSubtext: base.streakSubtext,
    );
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _triggerReplay() {
    _animController
      ..reset()
      ..forward();
  }

  void _showPeriodPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _cardBorder,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Timeframe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                ..._periods.map((period) {
                  final isSelected = period == _selectedPeriod;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(ctx);
                      if (period != _selectedPeriod) {
                        setState(() {
                          _selectedPeriod = period;
                          _selectedTrendPoint = null;
                        });
                        _triggerReplay();
                      }
                    },
                    title: Text(
                      period,
                      style: TextStyle(
                        color: isSelected ? _mintBright : Colors.white,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: isSelected
                        ? const UlvenikIcon(UlvenikIcons.completed,
                            color: _mintBright,
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
    final data = _activeData;
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _curvedAnim,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(canPop),
                  const SizedBox(height: 20),
                  _buildTabs(),
                  const SizedBox(height: 20),
                  _buildKpiGrid(data),
                  const SizedBox(height: 16),
                  _buildTrainingTimeCard(data),
                  const SizedBox(height: 16),
                  _buildSessionBreakdownCard(data),
                  const SizedBox(height: 16),
                  _buildHeatmapCard(data),
                  const SizedBox(height: 16),
                  _buildBestStreakCard(data),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool canPop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (canPop) ...[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: _cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: _cardBorder),
              ),
              child: const UlvenikIcon(UlvenikIcons.back,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Analytics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Tracking Milo's operational performance",
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _showPeriodPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedPeriod,
                  style: const TextStyle(
                    color: _textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 5),
                const UlvenikIcon(UlvenikIcons.sort,
                  color: _textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isSelected = i == _selectedTabIndex;
            return Padding(
              padding: EdgeInsets.only(right: i == _tabs.length - 1 ? 0 : 8),
              child: GestureDetector(
                onTap: () {
                  if (_selectedTabIndex != i) {
                    setState(() {
                      _selectedTabIndex = i;
                      _selectedTrendPoint = null;
                      _selectedBreakdownIndex = null;
                      _selectedHeatCell = null;
                    });
                    _triggerReplay();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _emerald.withValues(alpha: 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected ? _emeraldBorder : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    _tabs[i],
                    style: TextStyle(
                      color: isSelected ? _mintBright : _textSecondary,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildKpiGrid(_AnalyticsDataset data) {
    final compLabel = switch (_selectedPeriod) {
      'This Week' => 'vs last week',
      'Last 3 Months' => 'vs prior quarter',
      'This Year' => 'vs last year',
      _ => 'vs last month',
    };

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                index: 0,
                title: 'Total Training Time',
                badge: data.totalTimeDelta,
                value: data.totalTime,
                subtitle: compLabel,
                sparkPoints: data.timeSpark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(
                index: 1,
                title: 'Sessions',
                badge: data.sessionsDelta,
                value: data.sessions,
                subtitle: compLabel,
                sparkPoints: data.sessionsSpark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                index: 2,
                title: 'Training Frequency',
                value: data.frequency,
                subtitle: 'Sessions per week',
                sparkPoints: data.freqSpark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(
                index: 3,
                title: 'Goals Completed',
                value: data.goalsCompleted,
                subtitle: data.goalsSubtitle,
                sparkPoints: data.goalsSpark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required int index,
    required String title,
    String? badge,
    required String value,
    required String subtitle,
    required List<double> sparkPoints,
  }) {
    final isHighlighted = _highlightedKpiIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _highlightedKpiIndex = isHighlighted ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? _emeraldBorder : _cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (badge != null)
                  Text(
                    badge,
                    style: const TextStyle(
                      color: _mintBright,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: _textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 28,
              width: double.infinity,
              child: CustomPaint(
                painter: _SparklinePainter(
                  values: sparkPoints,
                  progress: _curvedAnim.value,
                  lineColor: _mintBright,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTimeCard(_AnalyticsDataset data) {
    final selectedIdx = _selectedTrendPoint;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Training Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                selectedIdx != null
                    ? 'Point ${selectedIdx + 1}: ${data.weeklyFormatted[selectedIdx]}'
                    : 'Weekly trend',
                style: TextStyle(
                  color: selectedIdx != null ? _mintBright : _textSecondary,
                  fontSize: 12,
                  fontWeight:
                      selectedIdx != null ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              void handleTouch(Offset localPos) {
                final count = data.weeklyValues.length;
                if (count <= 1) return;
                final ratio = (localPos.dx / width).clamp(0.0, 1.0);
                final idx = (ratio * (count - 1)).round();
                if (_selectedTrendPoint != idx) {
                  setState(() => _selectedTrendPoint = idx);
                }
              }

              return GestureDetector(
                onTapDown: (d) => handleTouch(d.localPosition),
                onHorizontalDragUpdate: (d) => handleTouch(d.localPosition),
                child: SizedBox(
                  height: 118,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _WeeklyTrendPainter(
                      values: data.weeklyValues,
                      progress: _curvedAnim.value,
                      selectedIndex: _selectedTrendPoint,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.weeklyLabels
                .map(
                  (label) => Text(
                    label,
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionBreakdownCard(_AnalyticsDataset data) {
    final showComp = _shouldShowCompetition(data);
    final segments = [
      ('General Training', data.generalTime, data.generalRatio, _mintBright),
      ('Strength & Cond.', data.scTime, data.scRatio, _skyBlue),
      if (showComp) ('Competition', data.compTime, data.compRatio, _purple),
    ];

    final safeSelectedIdx = (_selectedBreakdownIndex != null &&
            _selectedBreakdownIndex! < segments.length)
        ? _selectedBreakdownIndex
        : null;
    final activeSeg =
        safeSelectedIdx != null ? segments[safeSelectedIdx] : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
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
                'Session Breakdown',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Time spent',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (safeSelectedIdx == null) {
                      _selectedBreakdownIndex = 0;
                    } else if (safeSelectedIdx < segments.length - 1) {
                      _selectedBreakdownIndex = safeSelectedIdx + 1;
                    } else {
                      _selectedBreakdownIndex = null;
                    }
                  });
                },
                child: SizedBox(
                  width: 116,
                  height: 116,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(116, 116),
                        painter: _DonutBreakdownPainter(
                          progress: _curvedAnim.value,
                          selectedIndex: safeSelectedIdx,
                          ratios: segments.map((s) => s.$3).toList(),
                          colors: segments.map((s) => s.$4).toList(),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            activeSeg != null ? activeSeg.$2 : data.totalTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activeSeg != null
                                ? activeSeg.$1.split(' ').first
                                : 'Total',
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: List.generate(segments.length, (i) {
                    final seg = segments[i];
                    final isSelected = safeSelectedIdx == i;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i == segments.length - 1 ? 0 : 14,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBreakdownIndex = isSelected ? null : i;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: seg.$4,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    seg.$1,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : _textLight,
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                Text(
                                  seg.$2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: SizedBox(
                                height: 5,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Container(color: _trackBg),
                                    FractionallySizedBox(
                                      widthFactor:
                                          (seg.$3 * _curvedAnim.value)
                                              .clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: seg.$4,
                                          borderRadius:
                                              BorderRadius.circular(99),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        ],
      ),
    );
  }

  Widget _buildHeatmapCard(_AnalyticsDataset data) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const slotNames = ['Morning', 'Afternoon', 'Evening'];

    Color cellColor(int level) {
      return switch (level) {
        1 => _emeraldDark.withValues(alpha: 0.7),
        2 => const Color(0xFF047857),
        3 => _emerald,
        4 => _mintBright,
        _ => _trackBg.withValues(alpha: 0.65),
      };
    }

    String? cellDetail;
    if (_selectedHeatCell != null) {
      final (r, c) = _selectedHeatCell!;
      final lvl = data.heatmap[r][c];
      cellDetail =
          '${days[c]} · ${slotNames[r]}: ${lvl == 0 ? 'Rest slot' : '$lvl sessions recorded'}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Training Heatmap',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      cellDetail ?? data.activeWindow,
                      style: TextStyle(
                        color:
                            cellDetail != null ? _mintBright : _textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                data.peakLabel,
                style: const TextStyle(
                  color: _mintBright,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(7, (c) {
              return Expanded(
                child: Center(
                  child: Text(
                    days[c],
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          ...List.generate(data.heatmap.length, (r) {
            return Padding(
              padding: EdgeInsets.only(bottom: r == 2 ? 0 : 6),
              child: Row(
                children: List.generate(7, (c) {
                  final level = data.heatmap[r][c];
                  final isPeak = level == 4;
                  final isSelected = _selectedHeatCell == (r, c);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: c == 6 ? 0 : 6),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedHeatCell = isSelected ? null : (r, c);
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 28,
                          decoration: BoxDecoration(
                            color: cellColor(level),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : isPeak
                                      ? const Color(0xFF6EE7B7)
                                      : Colors.transparent,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Less active',
                style: TextStyle(
                  color: _textMuted,
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
              Row(
                children: List.generate(5, (lvl) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: cellColor(lvl),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
              const Text(
                'Highly active',
                style: TextStyle(
                  color: _textMuted,
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

  Widget _buildBestStreakCard(_AnalyticsDataset data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BEST STREAK',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${data.streakDays} days',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.streakSubtext,
            style: const TextStyle(
              color: _mintBright,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final Color lineColor;

  const _SparklinePainter({
    required this.values,
    required this.progress,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || progress <= 0) return;

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y =
          size.height - (values[i].clamp(0.0, 1.0) * size.height * 0.85) - 2;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.22),
          lineColor.withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.values != values;
}

class _WeeklyTrendPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final int? selectedIndex;

  const _WeeklyTrendPainter({
    required this.values,
    required this.progress,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E252B)
      ..strokeWidth = 1;

    for (var g = 1; g <= 3; g++) {
      final gy = size.height * (g / 4);
      canvas.drawLine(Offset(0, gy), Offset(size.width, gy), gridPaint);
    }

    if (values.length < 2 || progress <= 0) return;

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = 8 + (i / (values.length - 1)) * (size.width - 16);
      final y =
          size.height - (values[i].clamp(0.0, 1.0) * (size.height - 22)) - 8;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      path.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.28),
          const Color(0xFF10B981).withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final glowPaint = Paint()
      ..color = const Color(0xFF34D399).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glowPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF34D399)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    const nodeIndices = {1, 2, 4, 5, 6};
    for (var i = 0; i < points.length; i++) {
      if (!nodeIndices.contains(i) && selectedIndex != i) continue;
      final pt = points[i];
      final isSel = selectedIndex == i;
      canvas.drawCircle(
        pt,
        isSel ? 5.5 : 4.0,
        Paint()..color = const Color(0xFF0A0C0E),
      );
      canvas.drawCircle(
        pt,
        isSel ? 5.5 : 4.0,
        Paint()
          ..color = isSel ? Colors.white : const Color(0xFF34D399)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WeeklyTrendPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.values != values ||
      oldDelegate.selectedIndex != selectedIndex;
}

class _DonutBreakdownPainter extends CustomPainter {
  final double progress;
  final int? selectedIndex;
  final List<double> ratios;
  final List<Color> colors;

  const _DonutBreakdownPainter({
    required this.progress,
    required this.selectedIndex,
    required this.ratios,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    );

    final sum = ratios.fold<double>(0, (a, b) => a + b);
    if (sum <= 0 || progress <= 0) return;

    var startAngle = -math.pi * 0.92;
    final totalSweep = 2 * math.pi * progress;

    for (var i = 0; i < ratios.length; i++) {
      final sweep = (ratios[i] / sum) * totalSweep;
      final isDimmed = selectedIndex != null && selectedIndex != i;
      final paint = Paint()
        ..color = isDimmed ? colors[i].withValues(alpha: 0.35) : colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = selectedIndex == i ? 14 : 12
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        math.max(0.01, sweep - 0.06),
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutBreakdownPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.ratios != ratios;
}
