import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import '../widgets/ulvenik_icon.dart';

class _SkillSlice {
  final String name;
  final String shortTag;
  final int percent;
  final Color color;

  const _SkillSlice({
    required this.name,
    required this.shortTag,
    required this.percent,
    required this.color,
  });
}

class _ProgressDataset {
  final String totalTime;
  final String timeDelta;
  final List<double> timeSpark;
  final String sessions;
  final String sessionsDelta;
  final List<double> sessionSpark;
  final String frequency;
  final int goalsCompleted;
  final String goalsSubtitle;
  final List<double> trendHours; // 7 points (0.0..3.2)
  final List<String> trendDates; // 7 date labels
  final List<String> xAxisLabels; // 5 x-axis labels
  final List<_SkillSlice> skills;
  final List<int> heatmapLevels; // 28 cells (0..3)

  const _ProgressDataset({
    required this.totalTime,
    required this.timeDelta,
    required this.timeSpark,
    required this.sessions,
    required this.sessionsDelta,
    required this.sessionSpark,
    required this.frequency,
    required this.goalsCompleted,
    required this.goalsSubtitle,
    required this.trendHours,
    required this.trendDates,
    required this.xAxisLabels,
    required this.skills,
    required this.heatmapLevels,
  });
}

class ClientProgressScreen extends StatefulWidget {
  const ClientProgressScreen({super.key});

  @override
  State<ClientProgressScreen> createState() => _ClientProgressScreenState();
}

class _ClientProgressScreenState extends State<ClientProgressScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = Color(0xFF0B0F12);
  static const Color _cardBg = Color(0xFF12181C);
  static const Color _cellIdle = Color(0xFF1A2329);
  static const Color _neonMint = Color(0xFF00FFA3);
  static const Color _skyBlue = Color(0xFF38BDF8);
  static const Color _violet = Color(0xFFA78BFA);
  static const Color _slateMuted = Color(0xFF475569);
  static const Color _textPrimary = Color(0xFFF8FAFC);
  static const Color _textSecondary = Color(0xFF94A3B8);
  static const Color _axisMuted = Color(0xFF64748B);

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  String _selectedPeriod = 'This Month';
  String _selectedTab = 'Overview';
  int _selectedTrendIndex = 5; // Highlights peak point just like Figma!
  bool _showTrendTooltip = false;
  int _selectedSkillIndex = 0;
  int? _selectedHeatmapDay;

  final List<String> _periods = const [
    'This Week',
    'This Month',
    'Last 3 Months',
    'Year to Date',
  ];

  final List<String> _tabs = const [
    'Overview',
    'Training',
    'S&C',
    'Skills',
    'Health',
  ];

  late final Map<String, _ProgressDataset> _tabDatasets = {
    'Overview': const _ProgressDataset(
      totalTime: '24h 35m',
      timeDelta: '+16% vs last month',
      timeSpark: [0.18, 0.34, 0.25, 0.48, 0.65, 0.56, 0.86],
      sessions: '18',
      sessionsDelta: '+12% vs last month',
      sessionSpark: [0.22, 0.42, 0.33, 0.55, 0.46, 0.68, 0.85],
      frequency: '4.5',
      goalsCompleted: 8,
      goalsSubtitle: '3 active goals',
      trendHours: [0.85, 1.55, 0.98, 2.18, 1.44, 2.54, 1.68],
      trendDates: [
        '6 Apr',
        '11 Apr',
        '16 Apr',
        '21 Apr',
        '25 Apr',
        '30 Apr',
        '4 May',
      ],
      xAxisLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      skills: [
        _SkillSlice(
          name: 'Focus & Drive',
          shortTag: 'TOP',
          percent: 45,
          color: _neonMint,
        ),
        _SkillSlice(
          name: 'Agility & S&C',
          shortTag: 'S&C',
          percent: 25,
          color: _skyBlue,
        ),
        _SkillSlice(
          name: 'Heelwork',
          shortTag: 'HEEL',
          percent: 18,
          color: _violet,
        ),
        _SkillSlice(
          name: 'Other Modules',
          shortTag: 'OTHER',
          percent: 12,
          color: _slateMuted,
        ),
      ],
      heatmapLevels: [
        0, 1, 2, 3, 1, 3, 0,
        1, 3, 3, 2, 0, 1, 3,
        0, 2, 3, 3, 2, 3, 1,
        3, 3, 0, 2, 3, 3, 3,
      ],
    ),
    'Training': const _ProgressDataset(
      totalTime: '14h 50m',
      timeDelta: '+21% vs last month',
      timeSpark: [0.24, 0.30, 0.48, 0.52, 0.72, 0.78, 0.92],
      sessions: '12',
      sessionsDelta: '+18% vs last month',
      sessionSpark: [0.20, 0.36, 0.45, 0.62, 0.58, 0.80, 0.90],
      frequency: '3.2',
      goalsCompleted: 5,
      goalsSubtitle: '2 active goals',
      trendHours: [1.10, 1.40, 1.75, 1.95, 2.35, 2.75, 2.15],
      trendDates: [
        '6 Apr',
        '11 Apr',
        '16 Apr',
        '21 Apr',
        '25 Apr',
        '30 Apr',
        '4 May',
      ],
      xAxisLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      skills: [
        _SkillSlice(
          name: 'Decoy Focus',
          shortTag: 'TOP',
          percent: 52,
          color: _neonMint,
        ),
        _SkillSlice(
          name: 'Scent Tracking',
          shortTag: 'TRACK',
          percent: 24,
          color: _skyBlue,
        ),
        _SkillSlice(
          name: 'Heelwork',
          shortTag: 'HEEL',
          percent: 16,
          color: _violet,
        ),
        _SkillSlice(
          name: 'Recall Proofing',
          shortTag: 'RECALL',
          percent: 8,
          color: _slateMuted,
        ),
      ],
      heatmapLevels: [
        1, 2, 2, 3, 2, 3, 1,
        2, 3, 3, 2, 1, 2, 3,
        1, 2, 3, 3, 3, 3, 2,
        3, 3, 1, 3, 3, 3, 3,
      ],
    ),
    'S&C': const _ProgressDataset(
      totalTime: '6h 15m',
      timeDelta: '+9% vs last month',
      timeSpark: [0.30, 0.28, 0.42, 0.40, 0.58, 0.64, 0.76],
      sessions: '8',
      sessionsDelta: '+10% vs last month',
      sessionSpark: [0.25, 0.35, 0.38, 0.50, 0.54, 0.66, 0.78],
      frequency: '2.0',
      goalsCompleted: 3,
      goalsSubtitle: '1 active goal',
      trendHours: [0.65, 1.05, 0.90, 1.45, 1.25, 1.80, 1.50],
      trendDates: [
        '6 Apr',
        '11 Apr',
        '16 Apr',
        '21 Apr',
        '25 Apr',
        '30 Apr',
        '4 May',
      ],
      xAxisLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      skills: [
        _SkillSlice(
          name: 'Core Balance',
          shortTag: 'TOP',
          percent: 40,
          color: _neonMint,
        ),
        _SkillSlice(
          name: 'Cavaletti Stride',
          shortTag: 'STRIDE',
          percent: 32,
          color: _skyBlue,
        ),
        _SkillSlice(
          name: 'Hind-End Power',
          shortTag: 'HIND',
          percent: 20,
          color: _violet,
        ),
        _SkillSlice(
          name: 'Warm-up Mobility',
          shortTag: 'MOB',
          percent: 8,
          color: _slateMuted,
        ),
      ],
      heatmapLevels: [
        0, 2, 0, 2, 0, 3, 0,
        1, 0, 3, 0, 2, 0, 3,
        0, 2, 0, 3, 0, 2, 1,
        2, 0, 3, 0, 3, 0, 3,
      ],
    ),
    'Skills': const _ProgressDataset(
      totalTime: '19h 10m',
      timeDelta: '+24% vs last month',
      timeSpark: [0.15, 0.29, 0.44, 0.58, 0.67, 0.81, 0.95],
      sessions: '15',
      sessionsDelta: '+15% vs last month',
      sessionSpark: [0.22, 0.32, 0.49, 0.53, 0.70, 0.77, 0.91],
      frequency: '3.8',
      goalsCompleted: 6,
      goalsSubtitle: '2 active goals',
      trendHours: [0.95, 1.35, 1.60, 2.05, 1.90, 2.65, 2.40],
      trendDates: [
        '6 Apr',
        '11 Apr',
        '16 Apr',
        '21 Apr',
        '25 Apr',
        '30 Apr',
        '4 May',
      ],
      xAxisLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      skills: [
        _SkillSlice(
          name: 'Sustained Eye Contact',
          shortTag: 'TOP',
          percent: 48,
          color: _neonMint,
        ),
        _SkillSlice(
          name: '2-Pip Whistle Recall',
          shortTag: 'RECALL',
          percent: 26,
          color: _skyBlue,
        ),
        _SkillSlice(
          name: 'A-Frame Contact',
          shortTag: 'AGIL',
          percent: 16,
          color: _violet,
        ),
        _SkillSlice(
          name: 'Crate Calmness',
          shortTag: 'CALM',
          percent: 10,
          color: _slateMuted,
        ),
      ],
      heatmapLevels: [
        1, 1, 2, 3, 2, 3, 0,
        2, 3, 2, 3, 1, 2, 3,
        1, 3, 3, 2, 3, 3, 2,
        3, 2, 1, 3, 3, 3, 3,
      ],
    ),
    'Health': const _ProgressDataset(
      totalTime: '3h 30m',
      timeDelta: '+5% vs last month',
      timeSpark: [0.40, 0.45, 0.50, 0.52, 0.60, 0.68, 0.74],
      sessions: '6',
      sessionsDelta: '+1 vs last month',
      sessionSpark: [0.45, 0.50, 0.55, 0.60, 0.65, 0.72, 0.80],
      frequency: '1.5',
      goalsCompleted: 2,
      goalsSubtitle: '1 active goal',
      trendHours: [0.55, 0.80, 0.75, 1.15, 1.05, 1.40, 1.25],
      trendDates: [
        '6 Apr',
        '11 Apr',
        '16 Apr',
        '21 Apr',
        '25 Apr',
        '30 Apr',
        '4 May',
      ],
      xAxisLabels: ['6 Apr', '13 Apr', '20 Apr', '27 Apr', '4 May'],
      skills: [
        _SkillSlice(
          name: 'Gait Symmetry',
          shortTag: 'TOP',
          percent: 50,
          color: _neonMint,
        ),
        _SkillSlice(
          name: 'Post-Agility Cooldown',
          shortTag: 'COOL',
          percent: 25,
          color: _skyBlue,
        ),
        _SkillSlice(
          name: 'Weight & Hydration',
          shortTag: 'VITAL',
          percent: 15,
          color: _violet,
        ),
        _SkillSlice(
          name: 'Vet Palpation Logs',
          shortTag: 'VET',
          percent: 10,
          color: _slateMuted,
        ),
      ],
      heatmapLevels: [
        1, 0, 2, 1, 0, 2, 1,
        2, 1, 2, 0, 2, 1, 3,
        1, 2, 1, 3, 1, 2, 1,
        2, 1, 2, 2, 3, 1, 3,
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
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

  double get _periodMultiplier {
    switch (_selectedPeriod) {
      case 'This Week':
        return 0.28;
      case 'Last 3 Months':
        return 2.85;
      case 'Year to Date':
        return 6.4;
      case 'This Month':
      default:
        return 1.0;
    }
  }

  _ProgressDataset get _activeData =>
      _tabDatasets[_selectedTab] ?? _tabDatasets['Overview']!;

  String _scaledSessions(String raw) {
    final base = int.tryParse(raw) ?? 18;
    return (base * _periodMultiplier).round().toString();
  }

  String _scaledDuration(String raw) {
    if (_selectedPeriod == 'This Month') return raw;
    final match = RegExp(r'(\d+)h\s*(\d+)m').firstMatch(raw);
    if (match == null) return raw;
    final totalMins = ((int.parse(match.group(1)!) * 60 +
                int.parse(match.group(2)!)) *
            _periodMultiplier)
        .round();
    final h = totalMins ~/ 60;
    final m = totalMins % 60;
    return '${h}h ${m}m';
  }

  String _formatHours(double hours) {
    final totalMins = (hours * 60).round();
    final h = totalMins ~/ 60;
    final m = totalMins % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  void _triggerChartRefresh() {
    _animController.forward(from: 0.0);
  }

  void _showPeriodPickerSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Progress Timeframe',
                  style: GoogleFonts.inter(
                    color: _textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ..._periods.map((period) {
                  final selected = _selectedPeriod == period;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      period,
                      style: GoogleFonts.inter(
                        color: selected ? _neonMint : _textPrimary,
                        fontSize: 15,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    trailing: selected
                        ? const UlvenikIcon(UlvenikIcons.completed,
                            color: _neonMint, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedPeriod = period;
                        _showTrendTooltip = false;
                      });
                      _triggerChartRefresh();
                      Navigator.of(ctx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateScrubPoint(double localX, double chartWidth) {
    const leftPad = 32.0;
    const rightPad = 12.0;
    final usableWidth = (chartWidth - leftPad - rightPad).clamp(1.0, 2000.0);
    final rel = ((localX - leftPad) / usableWidth).clamp(0.0, 1.0);
    final idx = (rel * 6).round().clamp(0, 6);
    setState(() {
      _selectedTrendIndex = idx;
      _showTrendTooltip = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _activeData;
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          children: [
            _buildHeader(canPop),
            const SizedBox(height: 20),
            _buildCategoryPills(),
            const SizedBox(height: 18),
            _buildMetricGrid(data),
            const SizedBox(height: 16),
            _buildTrainingTimeChartCard(data),
            const SizedBox(height: 16),
            _buildTopSkillsCard(data),
            const SizedBox(height: 16),
            _buildConsistencyCard(data),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool canPop) {
    return Row(
      children: [
        if (canPop) ...[
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(4),
              child: const UlvenikIcon(
                UlvenikIcons.back,
                color: _textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
        Expanded(
          child: Text(
            'Analytics',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ),
        GestureDetector(
          onTap: _showPeriodPickerSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedPeriod,
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
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

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final selected = _selectedTab == tab;
          return GestureDetector(
            onTap: () {
              if (_selectedTab == tab) return;
              setState(() {
                _selectedTab = tab;
                _selectedSkillIndex = 0;
                _selectedHeatmapDay = null;
                _showTrendTooltip = false;
              });
              _triggerChartRefresh();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? _neonMint.withValues(alpha: 0.1) : _cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? _neonMint.withValues(alpha: 0.75)
                      : Colors.white.withValues(alpha: 0.05),
                  width: 1.1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: _neonMint.withValues(alpha: 0.14),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                tab,
                style: GoogleFonts.inter(
                  color: selected ? _neonMint : _textSecondary,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricGrid(_ProgressDataset data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSparkMetricCard(
                iconKey: UlvenikIcons.trainingTime,
                label: 'Total Training Time',
                value: _scaledDuration(data.totalTime),
                delta: data.timeDelta,
                sparkPoints: data.timeSpark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSparkMetricCard(
                iconKey: UlvenikIcons.training,
                label: 'Sessions',
                value: _scaledSessions(data.sessions),
                delta: data.sessionsDelta,
                sparkPoints: data.sessionSpark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 146,
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const UlvenikIcon(UlvenikIcons.scheduledTraining, size: 18, color: _neonMint),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Training Frequency',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.frequency,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sessions per week',
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 146,
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const UlvenikIcon(UlvenikIcons.goals, size: 18, color: _neonMint),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Goals Completed',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _curvedAnim,
                      builder: (context, _) {
                        final shown =
                            (data.goalsCompleted * _curvedAnim.value).round();
                        return Text(
                          '$shown',
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.goalsSubtitle,
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 6,
                        width: double.infinity,
                        color: _cellIdle,
                        alignment: Alignment.centerLeft,
                        child: AnimatedBuilder(
                          animation: _curvedAnim,
                          builder: (context, _) {
                            final goalProgress = (data.goalsCompleted /
                                    (data.goalsCompleted + 3))
                                .clamp(0.15, 1.0);
                            return FractionallySizedBox(
                              widthFactor: goalProgress * _curvedAnim.value,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _neonMint,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSparkMetricCard({
    required String iconKey,
    required String label,
    required String value,
    required String delta,
    required List<double> sparkPoints,
  }) {
    return Container(
      height: 158,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UlvenikIcon(iconKey, size: 18, color: _neonMint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: _neonMint,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 32,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _curvedAnim,
              builder: (context, _) {
                return CustomPaint(
                  painter: _NeonSparklinePainter(
                    values: sparkPoints,
                    progress: _curvedAnim.value,
                    lineColor: _neonMint,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingTimeChartCard(_ProgressDataset data) {
    final activeIdx = _selectedTrendIndex.clamp(0, data.trendHours.length - 1);
    final selectedHours = data.trendHours[activeIdx];
    final selectedDate = data.trendDates[activeIdx];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UlvenikIcon(UlvenikIcons.progress, size: 18, color: _neonMint),
                  const SizedBox(width: 8),
                  Text(
                    'Training Time',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                _showTrendTooltip
                    ? '$selectedDate · ${_formatHours(selectedHours)}'
                    : 'Weekly trend',
                style: GoogleFonts.inter(
                  color: _showTrendTooltip ? _neonMint : _textSecondary,
                  fontSize: 12.5,
                  fontWeight:
                      _showTrendTooltip ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) =>
                    _updateScrubPoint(d.localPosition.dx, constraints.maxWidth),
                onHorizontalDragStart: (d) =>
                    _updateScrubPoint(d.localPosition.dx, constraints.maxWidth),
                onHorizontalDragUpdate: (d) =>
                    _updateScrubPoint(d.localPosition.dx, constraints.maxWidth),
                child: SizedBox(
                  height: 168,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _curvedAnim,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _WeeklyTrendChartPainter(
                          hours: data.trendHours,
                          dates: data.trendDates,
                          progress: _curvedAnim.value,
                          selectedIndex: activeIdx,
                          showScrubGuide: _showTrendTooltip,
                          lineColor: _neonMint,
                          axisColor: _axisMuted,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: data.xAxisLabels.map((lbl) {
                return Text(
                  lbl,
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 11,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSkillsCard(_ProgressDataset data) {
    final safeIdx = _selectedSkillIndex.clamp(0, data.skills.length - 1);
    final highlighted = data.skills[safeIdx];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UlvenikIcon(UlvenikIcons.skills, size: 18, color: _neonMint),
                  const SizedBox(width: 8),
                  Text(
                    'Top Skills',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                'By time spent',
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSkillIndex =
                        (_selectedSkillIndex + 1) % data.skills.length;
                  });
                },
                child: SizedBox(
                  width: 116,
                  height: 116,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _curvedAnim,
                        builder: (context, _) {
                          return CustomPaint(
                            size: const Size(116, 116),
                            painter: _SkillsDonutPainter(
                              slices: data.skills,
                              progress: _curvedAnim.value,
                              selectedIndex: safeIdx,
                            ),
                          );
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${highlighted.percent}%',
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            highlighted.shortTag,
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: List.generate(data.skills.length, (i) {
                    final s = data.skills[i];
                    final isSelected = i == safeIdx;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _selectedSkillIndex = i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: s.color,
                                shape: BoxShape.circle,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: s.color.withValues(alpha: 0.6),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                s.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: isSelected
                                      ? _textPrimary
                                      : _textSecondary,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              '${s.percent}%',
                              style: GoogleFonts.inter(
                                color: _textPrimary,
                                fontSize: 13,
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
        ],
      ),
    );
  }

  Widget _buildConsistencyCard(_ProgressDataset data) {
    final activeDays = data.heatmapLevels.where((l) => l > 0).length;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UlvenikIcon(UlvenikIcons.scheduledTraining, size: 18, color: _neonMint),
                  const SizedBox(width: 8),
                  Text(
                    'Your Consistency',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                '$activeDays / ${data.heatmapLevels.length} days',
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Recorded activity over the last 28 days.',
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _curvedAnim,
            builder: (context, _) {
              return Column(
                children: List.generate(4, (row) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: row < 3 ? 7 : 0),
                    child: Row(
                      children: List.generate(7, (col) {
                        final idx = row * 7 + col;
                        final level = data.heatmapLevels[idx];
                        final isSelected = _selectedHeatmapDay == idx;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: col < 6 ? 7 : 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedHeatmapDay =
                                      isSelected ? null : idx;
                                });
                              },
                              child: Opacity(
                                opacity: (0.25 + 0.75 * _curvedAnim.value)
                                    .clamp(0.0, 1.0),
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _heatmapColor(level),
                                    borderRadius: BorderRadius.circular(5),
                                    border: isSelected
                                        ? Border.all(
                                            color: _textPrimary,
                                            width: 1.4,
                                          )
                                        : null,
                                    boxShadow: level == 3
                                        ? [
                                            BoxShadow(
                                              color: _neonMint.withValues(
                                                alpha: 0.18,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ]
                                        : null,
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
              );
            },
          ),
          if (_selectedHeatmapDay != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _cellIdle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _neonMint.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Day ${_selectedHeatmapDay! + 1} · ${_heatmapSummary(data.heatmapLevels[_selectedHeatmapDay!])}',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const UlvenikIcon(UlvenikIcons.back, size: 14, color: _textSecondary),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Less active',
                style: GoogleFonts.inter(
                  color: _axisMuted,
                  fontSize: 11.5,
                ),
              ),
              Row(
                children: [0, 1, 2, 3].map((lvl) {
                  return Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _heatmapColor(lvl),
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
              Text(
                'More active',
                style: GoogleFonts.inter(
                  color: _axisMuted,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _heatmapColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF0E4F3B);
      case 2:
        return const Color(0xFF06B87A);
      case 3:
        return _neonMint;
      case 0:
      default:
        return _cellIdle;
    }
  }

  String _heatmapSummary(int level) {
    switch (level) {
      case 3:
        return '2 sessions · 1h 25m recorded';
      case 2:
        return '1 session · 50m recorded';
      case 1:
        return '1 session · 20m recorded';
      case 0:
      default:
        return 'No sessions recorded';
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: _cardBg,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }
}

class _NeonSparklinePainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final Color lineColor;

  _NeonSparklinePainter({
    required this.values,
    required this.progress,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || progress <= 0.0) return;

    final pts = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * (size.width - 6) + 3;
      final y = size.height - (values[i].clamp(0.0, 1.0) * (size.height - 8)) - 4;
      pts.add(Offset(x, y));
    }

    final fullPath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      fullPath.lineTo(pts[i].dx, pts[i].dy);
    }

    final metrics = fullPath.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final extractLen = metric.length * progress.clamp(0.0, 1.0);
    final animPath = metric.extractPath(0, extractLen);

    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(animPath, glowPaint);

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(animPath, strokePaint);

    final tangent = metric.getTangentForOffset(extractLen);
    if (tangent != null) {
      canvas.drawCircle(
        tangent.position,
        5,
        Paint()..color = lineColor.withValues(alpha: 0.28),
      );
      canvas.drawCircle(
        tangent.position,
        2.6,
        Paint()..color = lineColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NeonSparklinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.values != values;
  }
}

class _WeeklyTrendChartPainter extends CustomPainter {
  final List<double> hours;
  final List<String> dates;
  final double progress;
  final int selectedIndex;
  final bool showScrubGuide;
  final Color lineColor;
  final Color axisColor;

  _WeeklyTrendChartPainter({
    required this.hours,
    required this.dates,
    required this.progress,
    required this.selectedIndex,
    required this.showScrubGuide,
    required this.lineColor,
    required this.axisColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 30.0;
    const rightPad = 10.0;
    const topPad = 14.0;
    const bottomPad = 10.0;
    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;
    const maxHours = 3.1;

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (int h = 1; h <= 3; h++) {
      final y = topPad + chartH * (1 - (h / maxHours));
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - rightPad, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(
          text: '${h}h',
          style: TextStyle(
            color: axisColor,
            fontSize: 11,
            fontFamily: 'Inter',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    canvas.drawLine(
      Offset(leftPad, topPad + chartH),
      Offset(size.width - rightPad, topPad + chartH),
      gridPaint,
    );

    if (hours.length < 2 || progress <= 0.0) return;

    final points = <Offset>[];
    for (int i = 0; i < hours.length; i++) {
      final x = leftPad + (i / (hours.length - 1)) * chartW;
      final normalized = (hours[i] / maxHours).clamp(0.05, 0.96) * progress;
      final y = topPad + chartH * (1 - normalized);
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, topPad + chartH)
      ..lineTo(points.first.dx, topPad + chartH)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.24),
          lineColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(leftPad, topPad, chartW, chartH));
    canvas.drawPath(fillPath, fillPaint);

    if (showScrubGuide) {
      final sx = points[selectedIndex].dx;
      canvas.drawLine(
        Offset(sx, topPad),
        Offset(sx, topPad + chartH),
        Paint()
          ..color = lineColor.withValues(alpha: 0.35)
          ..strokeWidth = 1.2,
      );
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      if (i == selectedIndex) {
        canvas.drawCircle(
          pt,
          10,
          Paint()..color = lineColor.withValues(alpha: 0.22),
        );
        canvas.drawCircle(pt, 5.5, Paint()..color = lineColor);
        canvas.drawCircle(
          pt,
          5.5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      } else {
        canvas.drawCircle(pt, 4.0, Paint()..color = const Color(0xFF0B0F12));
        canvas.drawCircle(
          pt,
          3.2,
          Paint()..color = lineColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyTrendChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.showScrubGuide != showScrubGuide ||
        oldDelegate.hours != hours;
  }
}

class _SkillsDonutPainter extends CustomPainter {
  final List<_SkillSlice> slices;
  final double progress;
  final int selectedIndex;

  _SkillsDonutPainter({
    required this.slices,
    required this.progress,
    required this.selectedIndex,
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
        ..color = const Color(0xFF1A2329)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11,
    );

    double startAngle = -math.pi * 0.92;
    const gap = 0.06;

    for (int i = 0; i < slices.length; i++) {
      final slice = slices[i];
      final rawSweep = (slice.percent / 100.0) * 2 * math.pi * progress;
      final sweep = math.max(0.0, rawSweep - gap);
      if (sweep > 0) {
        final isSelected = i == selectedIndex;
        canvas.drawArc(
          rect,
          startAngle,
          sweep,
          false,
          Paint()
            ..color = slice.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = isSelected ? 13.0 : 11.0
            ..strokeCap = StrokeCap.round,
        );
      }
      startAngle += rawSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _SkillsDonutPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.slices != slices;
  }
}
