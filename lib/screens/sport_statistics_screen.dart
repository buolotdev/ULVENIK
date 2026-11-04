import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'competitions_overview_screen.dart';
import 'qualifications_titles_awards_screen.dart';
import 'sport_details_igp_screen.dart';

class _MonthlyVolumePoint {
  final String month;
  final int sessions;
  final int hours;
  final int igpSessions;
  final int agilitySessions;
  final int psaSessions;

  const _MonthlyVolumePoint({
    required this.month,
    required this.sessions,
    required this.hours,
    required this.igpSessions,
    required this.agilitySessions,
    required this.psaSessions,
  });
}

class _PeriodStatsSnapshot {
  final String rangeSubtitle;
  final int trainingSessions;
  final int trainingHours;
  final int competitionsCount;
  final int qualificationsCount;
  final String firstLabelTop;
  final String firstLabelBottom;
  final String lastLabelTop;
  final String lastLabelBottom;
  final int activeSkills;
  final int activeExercises;
  final int skillsWithTraining;
  final int skillsWithoutTraining;
  final int compEntered;
  final int compCompleted;
  final int compUpcoming;
  final int compWithdrawn;
  final int achQualifications;
  final int achTitles;
  final int achAwards;
  final int achCertificates;
  final List<_MonthlyVolumePoint> monthlyPoints;

  const _PeriodStatsSnapshot({
    required this.rangeSubtitle,
    required this.trainingSessions,
    required this.trainingHours,
    required this.competitionsCount,
    required this.qualificationsCount,
    required this.firstLabelTop,
    required this.firstLabelBottom,
    required this.lastLabelTop,
    required this.lastLabelBottom,
    required this.activeSkills,
    required this.activeExercises,
    required this.skillsWithTraining,
    required this.skillsWithoutTraining,
    required this.compEntered,
    required this.compCompleted,
    required this.compUpcoming,
    required this.compWithdrawn,
    required this.achQualifications,
    required this.achTitles,
    required this.achAwards,
    required this.achCertificates,
    required this.monthlyPoints,
  });
}

class SportStatisticsScreen extends StatefulWidget {
  const SportStatisticsScreen({super.key});

  @override
  State<SportStatisticsScreen> createState() => _SportStatisticsScreenState();
}

class _SportStatisticsScreenState extends State<SportStatisticsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _card = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stone = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder; // rgba(255,255,255,0.08)

  static const List<String> _periods = [
    'Last 30 Days',
    'Last 90 Days',
    'This Year',
    'All Time',
  ];

  static const List<String> _sports = [
    'All Sports',
    'IGP',
    'Agility',
    'PSA',
  ];

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  String _selectedPeriod = 'Last 30 Days';
  String _selectedSport = 'All Sports';
  String? _customDateLabel;
  bool _showHoursLineMode = false;
  int? _touchedMonthIndex;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  _PeriodStatsSnapshot get _activeSnapshot {
    double sportFactor = 1.0;
    if (_selectedSport == 'IGP') {
      sportFactor = 0.62;
    } else if (_selectedSport == 'Agility') {
      sportFactor = 0.25;
    } else if (_selectedSport == 'PSA') {
      sportFactor = 0.13;
    }

    int scaleInt(int base, {int min = 0}) {
      if (_selectedSport == 'All Sports') return base;
      final scaled = (base * sportFactor).round();
      return math.max(min, scaled);
    }

    List<_MonthlyVolumePoint> scalePoints(List<_MonthlyVolumePoint> raw) {
      if (_selectedSport == 'All Sports') return raw;
      return raw.map((p) {
        final s = _selectedSport == 'IGP'
            ? p.igpSessions
            : _selectedSport == 'Agility'
                ? p.agilitySessions
                : p.psaSessions;
        final h = math.max(1, (s * 0.5).round());
        return _MonthlyVolumePoint(
          month: p.month,
          sessions: s,
          hours: h,
          igpSessions: _selectedSport == 'IGP' ? s : 0,
          agilitySessions: _selectedSport == 'Agility' ? s : 0,
          psaSessions: _selectedSport == 'PSA' ? s : 0,
        );
      }).toList();
    }

    if (_selectedPeriod == 'Last 30 Days') {
      // Exact Figma baseline numbers on default load
      return _PeriodStatsSnapshot(
        rangeSubtitle: _customDateLabel ?? 'Apr – Sep 2026',
        trainingSessions: scaleInt(286, min: 18),
        trainingHours: scaleInt(142, min: 9),
        competitionsCount: scaleInt(7, min: 1),
        qualificationsCount: scaleInt(4, min: 1),
        firstLabelTop: 'First: Mar',
        firstLabelBottom: '2024',
        lastLabelTop: 'Last:',
        lastLabelBottom: 'Yesterday',
        activeSkills: scaleInt(18, min: 4),
        activeExercises: scaleInt(54, min: 10),
        skillsWithTraining: scaleInt(16, min: 3),
        skillsWithoutTraining: _selectedSport == 'All Sports' ? 2 : 1,
        compEntered: scaleInt(7, min: 1),
        compCompleted: scaleInt(5, min: 1),
        compUpcoming: _selectedSport == 'PSA' ? 0 : 2,
        compWithdrawn: _selectedSport == 'All Sports' ? 1 : 0,
        achQualifications: scaleInt(4, min: 1),
        achTitles: _selectedSport == 'PSA' ? 0 : 1,
        achAwards: scaleInt(3, min: 0),
        achCertificates: 0,
        monthlyPoints: scalePoints(const [
          _MonthlyVolumePoint(
            month: 'Apr',
            sessions: 41,
            hours: 20,
            igpSessions: 25,
            agilitySessions: 11,
            psaSessions: 5,
          ),
          _MonthlyVolumePoint(
            month: 'May',
            sessions: 48,
            hours: 24,
            igpSessions: 30,
            agilitySessions: 12,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Jun',
            sessions: 44,
            hours: 22,
            igpSessions: 27,
            agilitySessions: 11,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Jul',
            sessions: 52,
            hours: 26,
            igpSessions: 32,
            agilitySessions: 13,
            psaSessions: 7,
          ),
          _MonthlyVolumePoint(
            month: 'Aug',
            sessions: 49,
            hours: 24,
            igpSessions: 31,
            agilitySessions: 12,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Sep',
            sessions: 52,
            hours: 26,
            igpSessions: 33,
            agilitySessions: 13,
            psaSessions: 6,
          ),
        ]),
      );
    } else if (_selectedPeriod == 'Last 90 Days') {
      return _PeriodStatsSnapshot(
        rangeSubtitle: 'Jul – Sep 2026',
        trainingSessions: scaleInt(153, min: 14),
        trainingHours: scaleInt(76, min: 7),
        competitionsCount: scaleInt(3, min: 1),
        qualificationsCount: scaleInt(2, min: 1),
        firstLabelTop: 'First: 02',
        firstLabelBottom: 'Jul 2026',
        lastLabelTop: 'Last:',
        lastLabelBottom: 'Yesterday',
        activeSkills: scaleInt(18, min: 4),
        activeExercises: scaleInt(48, min: 9),
        skillsWithTraining: scaleInt(15, min: 3),
        skillsWithoutTraining: _selectedSport == 'All Sports' ? 3 : 1,
        compEntered: scaleInt(3, min: 1),
        compCompleted: scaleInt(2, min: 1),
        compUpcoming: _selectedSport == 'PSA' ? 0 : 1,
        compWithdrawn: 0,
        achQualifications: scaleInt(2, min: 1),
        achTitles: 0,
        achAwards: scaleInt(1, min: 0),
        achCertificates: 0,
        monthlyPoints: scalePoints(const [
          _MonthlyVolumePoint(
            month: 'Apr',
            sessions: 36,
            hours: 18,
            igpSessions: 22,
            agilitySessions: 9,
            psaSessions: 5,
          ),
          _MonthlyVolumePoint(
            month: 'May',
            sessions: 42,
            hours: 21,
            igpSessions: 26,
            agilitySessions: 11,
            psaSessions: 5,
          ),
          _MonthlyVolumePoint(
            month: 'Jun',
            sessions: 45,
            hours: 22,
            igpSessions: 28,
            agilitySessions: 11,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Jul',
            sessions: 52,
            hours: 26,
            igpSessions: 32,
            agilitySessions: 13,
            psaSessions: 7,
          ),
          _MonthlyVolumePoint(
            month: 'Aug',
            sessions: 49,
            hours: 24,
            igpSessions: 31,
            agilitySessions: 12,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Sep',
            sessions: 52,
            hours: 26,
            igpSessions: 33,
            agilitySessions: 13,
            psaSessions: 6,
          ),
        ]),
      );
    } else if (_selectedPeriod == 'This Year') {
      return _PeriodStatsSnapshot(
        rangeSubtitle: 'Jan – Sep 2026',
        trainingSessions: scaleInt(384, min: 32),
        trainingHours: scaleInt(192, min: 16),
        competitionsCount: scaleInt(6, min: 1),
        qualificationsCount: scaleInt(3, min: 1),
        firstLabelTop: 'First: 04',
        firstLabelBottom: 'Jan 2026',
        lastLabelTop: 'Last:',
        lastLabelBottom: 'Yesterday',
        activeSkills: scaleInt(18, min: 4),
        activeExercises: scaleInt(54, min: 10),
        skillsWithTraining: scaleInt(17, min: 4),
        skillsWithoutTraining: 1,
        compEntered: scaleInt(6, min: 1),
        compCompleted: scaleInt(4, min: 1),
        compUpcoming: _selectedSport == 'PSA' ? 0 : 2,
        compWithdrawn: 0,
        achQualifications: scaleInt(3, min: 1),
        achTitles: _selectedSport == 'PSA' ? 0 : 1,
        achAwards: scaleInt(2, min: 0),
        achCertificates: 1,
        monthlyPoints: scalePoints(const [
          _MonthlyVolumePoint(
            month: 'Apr',
            sessions: 44,
            hours: 22,
            igpSessions: 27,
            agilitySessions: 11,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'May',
            sessions: 50,
            hours: 25,
            igpSessions: 31,
            agilitySessions: 13,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Jun',
            sessions: 47,
            hours: 23,
            igpSessions: 29,
            agilitySessions: 12,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Jul',
            sessions: 55,
            hours: 28,
            igpSessions: 34,
            agilitySessions: 14,
            psaSessions: 7,
          ),
          _MonthlyVolumePoint(
            month: 'Aug',
            sessions: 51,
            hours: 25,
            igpSessions: 32,
            agilitySessions: 13,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'Sep',
            sessions: 56,
            hours: 28,
            igpSessions: 35,
            agilitySessions: 14,
            psaSessions: 7,
          ),
        ]),
      );
    } else {
      return _PeriodStatsSnapshot(
        rangeSubtitle: '2024 – 2026',
        trainingSessions: scaleInt(486, min: 54),
        trainingHours: scaleInt(248, min: 27),
        competitionsCount: scaleInt(11, min: 2),
        qualificationsCount: scaleInt(7, min: 1),
        firstLabelTop: 'First: Mar',
        firstLabelBottom: '2024',
        lastLabelTop: 'Last:',
        lastLabelBottom: 'Yesterday',
        activeSkills: scaleInt(22, min: 6),
        activeExercises: scaleInt(64, min: 14),
        skillsWithTraining: scaleInt(22, min: 6),
        skillsWithoutTraining: 0,
        compEntered: scaleInt(11, min: 2),
        compCompleted: scaleInt(9, min: 2),
        compUpcoming: _selectedSport == 'PSA' ? 0 : 2,
        compWithdrawn: _selectedSport == 'All Sports' ? 1 : 0,
        achQualifications: scaleInt(7, min: 1),
        achTitles: _selectedSport == 'PSA' ? 0 : 2,
        achAwards: scaleInt(4, min: 1),
        achCertificates: _selectedSport == 'All Sports' ? 2 : 1,
        monthlyPoints: scalePoints(const [
          _MonthlyVolumePoint(
            month: 'Apr',
            sessions: 46,
            hours: 23,
            igpSessions: 28,
            agilitySessions: 12,
            psaSessions: 6,
          ),
          _MonthlyVolumePoint(
            month: 'May',
            sessions: 53,
            hours: 27,
            igpSessions: 33,
            agilitySessions: 13,
            psaSessions: 7,
          ),
          _MonthlyVolumePoint(
            month: 'Jun',
            sessions: 49,
            hours: 25,
            igpSessions: 30,
            agilitySessions: 12,
            psaSessions: 7,
          ),
          _MonthlyVolumePoint(
            month: 'Jul',
            sessions: 58,
            hours: 29,
            igpSessions: 36,
            agilitySessions: 14,
            psaSessions: 8,
          ),
          _MonthlyVolumePoint(
            month: 'Aug',
            sessions: 54,
            hours: 27,
            igpSessions: 34,
            agilitySessions: 13,
            psaSessions: 7,
          ),
          _MonthlyVolumePoint(
            month: 'Sep',
            sessions: 59,
            hours: 30,
            igpSessions: 37,
            agilitySessions: 15,
            psaSessions: 7,
          ),
        ]),
      );
    }
  }

  void _selectPeriod(String period) {
    if (_selectedPeriod == period && _customDateLabel == null) return;
    setState(() {
      _selectedPeriod = period;
      _customDateLabel = null;
      _touchedMonthIndex = null;
    });
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final snap = _activeSnapshot;

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            Container(height: 1, color: _border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: AnimatedBuilder(
                  animation: _curvedAnim,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPeriodPills(),
                        if (_selectedSport != 'All Sports' ||
                            _customDateLabel != null) ...[
                          const SizedBox(height: 12),
                          _buildScopeBanner(),
                        ],
                        const SizedBox(height: 22),
                        _buildSectionHeader('SUMMARY'),
                        const SizedBox(height: 10),
                        _buildSummaryGrid(snap),
                        const SizedBox(height: 24),
                        _buildSectionHeader('TRAINING'),
                        const SizedBox(height: 10),
                        _buildTrainingCard(snap),
                        const SizedBox(height: 24),
                        _buildSectionHeader('SKILLS'),
                        const SizedBox(height: 10),
                        _buildSkillsCard(snap),
                        const SizedBox(height: 24),
                        _buildSectionHeader('COMPETITIONS'),
                        const SizedBox(height: 10),
                        _buildCompetitionsStrip(snap),
                        const SizedBox(height: 24),
                        _buildSectionHeader('ACHIEVEMENTS'),
                        const SizedBox(height: 10),
                        _buildAchievementsStrip(snap),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final hasCustomScope =
        _selectedSport != 'All Sports' || _customDateLabel != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 8, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _stone,
              size: 28,
            ),
            splashRadius: 22,
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'Sport Statistics',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _offWhite,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _openCalendarAndScopeSheet,
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: hasCustomScope ? _mint : _stone,
                  size: 20,
                ),
                tooltip: 'Date range & sport filter',
              ),
              if (hasCustomScope)
                Positioned(
                  right: 9,
                  top: 9,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: _openExportShareSheet,
            icon: const Icon(
              Icons.ios_share_rounded,
              color: _stone,
              size: 21,
            ),
            tooltip: 'Export or share statistics',
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(_periods.length, (i) {
          final period = _periods[i];
          final selected =
              _selectedPeriod == period && _customDateLabel == null;
          return Padding(
            padding: EdgeInsets.only(right: i == _periods.length - 1 ? 0 : 10),
            child: GestureDetector(
              onTap: () => _selectPeriod(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 9.5,
                ),
                decoration: BoxDecoration(
                  color: selected ? _forest : _card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected ? _forest : _border,
                    width: 1,
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: selected ? _offWhite : _stone,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScopeBanner() {
    final parts = <String>[
      if (_selectedSport != 'All Sports') 'Sport: $_selectedSport',
      if (_customDateLabel != null) 'Window: $_customDateLabel',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _forest.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _mint.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_outlined, color: _mint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              parts.join('  ·  '),
              style: const TextStyle(
                color: _offWhite,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedSport = 'All Sports';
                _customDateLabel = null;
                _touchedMonthIndex = null;
              });
              _animController.forward(from: 0.0);
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: _mint,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stone,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.15,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildSummaryGrid(_PeriodStatsSnapshot snap) {
    final t = _curvedAnim.value;
    final sessionsVal = (snap.trainingSessions * t).round();
    final hoursVal = (snap.trainingHours * t).round();
    final compsVal = (snap.competitionsCount * t).round();
    final qualsVal = (snap.qualificationsCount * t).round();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                value: '$sessionsVal',
                label: 'Training Sessions',
                icon: Icons.fitness_center_rounded,
                onTap: () => _openSportSplitSheet(
                  title: 'Training Sessions Breakdown',
                  totalLabel: '${snap.trainingSessions} Sessions',
                  igpValue: (snap.trainingSessions * 0.62).round(),
                  agilityValue: (snap.trainingSessions * 0.25).round(),
                  psaValue: snap.trainingSessions -
                      (snap.trainingSessions * 0.62).round() -
                      (snap.trainingSessions * 0.25).round(),
                  unit: 'sessions',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                value: '${hoursVal}h',
                label: 'Training Hours',
                icon: Icons.access_time_rounded,
                onTap: () => _openSportSplitSheet(
                  title: 'Training Hours Breakdown',
                  totalLabel: '${snap.trainingHours}h Recorded',
                  igpValue: (snap.trainingHours * 0.64).round(),
                  agilityValue: (snap.trainingHours * 0.23).round(),
                  psaValue: snap.trainingHours -
                      (snap.trainingHours * 0.64).round() -
                      (snap.trainingHours * 0.23).round(),
                  unit: 'h',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                value: '$compsVal',
                label: 'Competitions',
                icon: Icons.emoji_events_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CompetitionsOverviewScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                value: '$qualsVal',
                label: 'Qualifications',
                icon: Icons.star_border_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QualificationsTitlesAwardsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String value,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      height: 1.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      icon,
                      color: _stone,
                      size: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: _stone,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingCard(_PeriodStatsSnapshot snap) {
    final t = _curvedAnim.value;
    final points = snap.monthlyPoints;
    final selectedPoint =
        (_touchedMonthIndex != null && _touchedMonthIndex! < points.length)
            ? points[_touchedMonthIndex!]
            : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: _buildTrainingMiniMeta(
                  '${(snap.trainingSessions * t).round()}',
                  'Sessions',
                ),
              ),
              _buildTinyDot(),
              Expanded(
                flex: 8,
                child: _buildTrainingMiniMeta(
                  '${(snap.trainingHours * t).round()}h',
                  'Total',
                ),
              ),
              _buildTinyDot(),
              Expanded(
                flex: 11,
                child: _buildTrainingMiniMeta(
                  snap.firstLabelTop,
                  snap.firstLabelBottom,
                ),
              ),
              _buildTinyDot(),
              Expanded(
                flex: 11,
                child: _buildTrainingMiniMeta(
                  snap.lastLabelTop,
                  snap.lastLabelBottom,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: _border),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showHoursLineMode
                    ? 'MONTHLY TRAINING HOURS'
                    : 'MONTHLY SESSION VOLUME',
                style: const TextStyle(
                  color: _stone,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.9,
                  fontFamily: 'Inter',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showHoursLineMode = !_showHoursLineMode;
                  });
                  _animController.forward(from: 0.25);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      snap.rangeSubtitle,
                      style: const TextStyle(
                        color: Color(0xFF3E8E72),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showHoursLineMode
                          ? Icons.bar_chart_rounded
                          : Icons.show_chart_rounded,
                      color: const Color(0xFF3E8E72),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedPoint != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _mint.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${selectedPoint.month} 2026: ${selectedPoint.sessions} sessions · ${selectedPoint.hours}h  '
                      '(IGP ${selectedPoint.igpSessions} · Agility ${selectedPoint.agilitySessions} · PSA ${selectedPoint.psaSessions})',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 11.8,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _touchedMonthIndex = null),
                    child: const Icon(
                      Icons.close_rounded,
                      color: _stone,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              const chartHeight = 178.0;
              const rightAxisReserve = 28.0;
              final plotWidth = chartWidth - rightAxisReserve;

              void handleTouch(Offset localPos) {
                if (points.isEmpty) return;
                final clampedX = localPos.dx.clamp(0.0, plotWidth - 1);
                final slotWidth = plotWidth / points.length;
                final idx =
                    (clampedX / slotWidth).floor().clamp(0, points.length - 1);
                if (_touchedMonthIndex != idx) {
                  setState(() => _touchedMonthIndex = idx);
                }
              }

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => handleTouch(d.localPosition),
                onHorizontalDragUpdate: (d) => handleTouch(d.localPosition),
                child: SizedBox(
                  width: chartWidth,
                  height: chartHeight,
                  child: CustomPaint(
                    painter: _MonthlyVolumeChartPainter(
                      points: points,
                      progress: t,
                      selectedIndex: _touchedMonthIndex,
                      hoursLineMode: _showHoursLineMode,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingMiniMeta(String top, String bottom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          top,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _stone,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.35,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          bottom,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _stone,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.35,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildTinyDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 2,
        height: 2,
        decoration: BoxDecoration(
          color: _stone.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildSkillsCard(_PeriodStatsSnapshot snap) {
    final t = _curvedAnim.value;
    final skillsCount = (snap.activeSkills * t).round();
    final exercisesCount = (snap.activeExercises * t).round();
    final withTraining = (snap.skillsWithTraining * t).round();
    final withoutTraining = snap.skillsWithoutTraining;

    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openSkillsCoverageSheet(snap),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$skillsCount Skills',
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Container(width: 1, color: _border),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        '$exercisesCount Exercises',
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 18,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: _forest,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Skills with Training:  ',
                        style: TextStyle(
                          color: _stone,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '$withTraining',
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _stone.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Without Training:  ',
                        style: TextStyle(
                          color: _stone,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '$withoutTraining',
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompetitionsStrip(_PeriodStatsSnapshot snap) {
    final t = _curvedAnim.value;
    return _buildFourColumnStrip(
      items: [
        _StripStatItem(
          value: '${(snap.compEntered * t).round()}',
          label: 'Entered',
          onTap: () => _navigateToCompetitions(0),
        ),
        _StripStatItem(
          value: '${(snap.compCompleted * t).round()}',
          label: 'Completed',
          onTap: () => _navigateToCompetitions(1),
        ),
        _StripStatItem(
          value: '${(snap.compUpcoming * t).round()}',
          label: 'Upcoming',
          onTap: () => _navigateToCompetitions(0),
        ),
        _StripStatItem(
          value: '${snap.compWithdrawn}',
          label: 'Withdrawn',
          onTap: () => _navigateToCompetitions(0),
        ),
      ],
    );
  }

  Widget _buildAchievementsStrip(_PeriodStatsSnapshot snap) {
    final t = _curvedAnim.value;
    return _buildFourColumnStrip(
      items: [
        _StripStatItem(
          value: '${(snap.achQualifications * t).round()}',
          label: 'Qualifications',
          onTap: _navigateToQualifications,
        ),
        _StripStatItem(
          value: '${snap.achTitles}',
          label: 'Titles',
          onTap: _navigateToQualifications,
        ),
        _StripStatItem(
          value: '${(snap.achAwards * t).round()}',
          label: 'Awards',
          onTap: _navigateToQualifications,
        ),
        _StripStatItem(
          value: '${snap.achCertificates}',
          label: 'Certificates',
          onTap: _navigateToQualifications,
        ),
      ],
    );
  }

  void _navigateToCompetitions(int tabIdx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompetitionsOverviewScreen(initialTabIndex: tabIdx),
      ),
    );
  }

  void _navigateToQualifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QualificationsTitlesAwardsScreen(),
      ),
    );
  }

  Widget _buildFourColumnStrip({required List<_StripStatItem> items}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(items.length * 2 - 1, (idx) {
            if (idx.isOdd) {
              return Container(width: 1, color: _border);
            }
            final item = items[idx ~/ 2];
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.value,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _stone,
                          fontSize: 11.8,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _openCalendarAndScopeSheet() {
    String tempSport = _selectedSport;
    String tempPeriod = _selectedPeriod;
    String? tempCustom = _customDateLabel;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _stone.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date Range & Sport Scope',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SPORT',
                      style: TextStyle(
                        color: _stone,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sports.map((s) {
                        final active = s == tempSport;
                        return GestureDetector(
                          onTap: () => setModalState(() => tempSport = s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? _forest.withValues(alpha: 0.28)
                                  : _bg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: active
                                    ? _mint.withValues(alpha: 0.7)
                                    : _border,
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                color: active ? _offWhite : _stone,
                                fontSize: 13,
                                fontWeight: active
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'CUSTOM CALENDAR WINDOW',
                      style: TextStyle(
                        color: _stone,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: ctx,
                          firstDate: DateTime(2024, 1, 1),
                          lastDate: DateTime(2027, 12, 31),
                          initialDateRange: DateTimeRange(
                            start: DateTime(2026, 4, 1),
                            end: DateTime(2026, 9, 30),
                          ),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: _forest,
                                onPrimary: _offWhite,
                                surface: _card,
                                onSurface: _offWhite,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          const m = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ];
                          setModalState(() {
                            tempCustom =
                                '${picked.start.day} ${m[picked.start.month - 1]} – ${picked.end.day} ${m[picked.end.month - 1]} ${picked.end.year}';
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _offWhite,
                        side: const BorderSide(color: _border),
                        backgroundColor: _bg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.date_range_outlined,
                        color: _mint,
                        size: 18,
                      ),
                      label: Text(
                        tempCustom ?? 'Pick Custom Date Range...',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _selectedSport = tempSport;
                            _selectedPeriod = tempPeriod;
                            _customDateLabel = tempCustom;
                            _touchedMonthIndex = null;
                          });
                          _animController.forward(from: 0.0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Apply Statistics Scope',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openExportShareSheet() {
    final snap = _activeSnapshot;
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Share or Export Sport Statistics',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_selectedSport · $_selectedPeriod (${snap.trainingSessions} sessions, ${snap.trainingHours}h)',
                  style: const TextStyle(
                    color: _stone,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                _buildExportOptionTile(
                  ctx,
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'Export Season PDF Report',
                  subtitle:
                      'Includes monthly volume chart, skills coverage & trial summary',
                  toastMessage:
                      'Sport Statistics PDF generated for $_selectedSport ($_selectedPeriod).',
                ),
                const SizedBox(height: 10),
                _buildExportOptionTile(
                  ctx,
                  icon: Icons.table_chart_outlined,
                  title: 'Export CSV Session Ledger',
                  subtitle:
                      'Raw session durations, sport tags & exercise counts',
                  toastMessage:
                      'Exported ${snap.trainingSessions} sport training rows to CSV.',
                ),
                const SizedBox(height: 10),
                _buildExportOptionTile(
                  ctx,
                  icon: Icons.ios_share_rounded,
                  title: 'Share Coach / Club Snapshot',
                  subtitle:
                      'Copy formatted summary for your training director or helper',
                  toastMessage:
                      'Copied Sport Statistics summary to clipboard for sharing.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExportOptionTile(
    BuildContext sheetCtx, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String toastMessage,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pop(sheetCtx);
        AppSnackbar.show(
          context,
          title: 'Statistics Exported',
          message: toastMessage,
          type: SnackbarType.success,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _mint, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _stone,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _stone, size: 20),
          ],
        ),
      ),
    );
  }

  void _openSportSplitSheet({
    required String title,
    required String totalLabel,
    required int igpValue,
    required int agilityValue,
    required int psaValue,
    required String unit,
  }) {
    final total = math.max(1, igpValue + agilityValue + psaValue);
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      totalLabel,
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSplitRow('IGP (Tracking / Obedience / Protection)',
                    igpValue, total, _forest, unit),
                const SizedBox(height: 12),
                _buildSplitRow('Agility (Course & Contacts)', agilityValue,
                    total, _alpineBlue, unit),
                const SizedBox(height: 12),
                _buildSplitRow('PSA (Decoy Scenarios & Control)', psaValue,
                    total, AppColors.bronzeAccent, unit),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SportDetailsIgpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Open Sport & Training Records',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSplitRow(
    String label,
    int value,
    int total,
    Color barColor,
    String unit,
  ) {
    final pct = ((value / total) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Text(
              unit == 'h' ? '${value}h ($pct%)' : '$value $unit ($pct%)',
              style: const TextStyle(
                color: _stone,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (value / total).clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  void _openSkillsCoverageSheet(_PeriodStatsSnapshot snap) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Skills Coverage (${snap.skillsWithTraining}/${snap.activeSkills} Active)',
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${snap.activeExercises} exercises tracked across active sports.',
                  style: const TextStyle(
                    color: _stone,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                _buildSkillAttentionRow(
                  name: 'Focused Heelwork & Pace Transitions',
                  status: '46 sessions · Trained yesterday',
                  trained: true,
                ),
                const SizedBox(height: 8),
                _buildSkillAttentionRow(
                  name: 'Corner Commitment & Article Indication',
                  status: '38 sessions · Trained 2 days ago',
                  trained: true,
                ),
                if (snap.skillsWithoutTraining > 0) ...[
                  const SizedBox(height: 8),
                  _buildSkillAttentionRow(
                    name: 'Send Away (Voraus) — Down on Whistle',
                    status: 'Untrained in selected window',
                    trained: false,
                  ),
                  if (snap.skillsWithoutTraining > 1) ...[
                    const SizedBox(height: 8),
                    _buildSkillAttentionRow(
                      name: '1m Hurdle & Scaling Wall Retrieve',
                      status: 'Untrained in selected window',
                      trained: false,
                    ),
                  ],
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SportDetailsIgpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Inspect All Sport Skills',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillAttentionRow({
    required String name,
    required String status,
    required bool trained,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: trained ? _forest : _stone.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13.2,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    color: trained ? _stone : AppColors.bronzeAccent,
                    fontSize: 11.8,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StripStatItem {
  final String value;
  final String label;
  final VoidCallback onTap;

  const _StripStatItem({
    required this.value,
    required this.label,
    required this.onTap,
  });
}

class _MonthlyVolumeChartPainter extends CustomPainter {
  final List<_MonthlyVolumePoint> points;
  final double progress;
  final int? selectedIndex;
  final bool hoursLineMode;

  _MonthlyVolumeChartPainter({
    required this.points,
    required this.progress,
    required this.selectedIndex,
    required this.hoursLineMode,
  });

  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stone = AppColors.secondaryTextStoneGrey;
  static const Color _offWhite = AppColors.primaryTextOffWhite;

  @override
  void paint(Canvas canvas, Size size) {
    const double topPad = 14.0;
    const double bottomPad = 24.0;
    const double rightAxisW = 28.0;
    final double plotW = size.width - rightAxisW;
    final double plotH = size.height - topPad - bottomPad;

    final double maxVal = hoursLineMode ? 36.0 : 60.0;
    final List<int> yTicks =
        hoursLineMode ? const [0, 12, 24, 36] : const [0, 20, 40, 60];

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1.0;

    // Horizontal grid lines + right-aligned Y-axis labels matching Figma
    for (final tick in yTicks) {
      final frac = tick / maxVal;
      final y = topPad + plotH * (1.0 - frac);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: '$tick',
          style: TextStyle(
            color: _stone.withValues(alpha: 0.65),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width - tp.width, y - tp.height - 3));
    }

    if (points.isEmpty) return;

    final slotW = plotW / points.length;
    final List<Offset> centers = [];

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final rawVal =
          (hoursLineMode ? p.hours.toDouble() : p.sessions.toDouble())
              .clamp(0.0, maxVal);
      final animVal = rawVal * progress;
      final barH = (animVal / maxVal) * plotH;
      final cx = slotW * i + slotW * 0.5;
      final topY = topPad + plotH - barH;
      centers.add(Offset(cx, topY));

      final isSelected = selectedIndex == i;

      if (!hoursLineMode) {
        final barW = math.min(22.0, slotW * 0.46);
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(cx - barW / 2, topY, barW, barH),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
        );
        final barPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isSelected
                ? [
                    _mint,
                    _forest.withValues(alpha: 0.9),
                  ]
                : [
                    _forest.withValues(alpha: 0.92),
                    _forest.withValues(alpha: 0.35),
                  ],
          ).createShader(Rect.fromLTWH(cx - barW / 2, topY, barW, barH));
        canvas.drawRRect(rect, barPaint);
      }

      // Month X-axis label
      final monthTp = TextPainter(
        text: TextSpan(
          text: p.month,
          style: TextStyle(
            color: isSelected ? _offWhite : _stone,
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      monthTp.paint(
        canvas,
        Offset(cx - monthTp.width / 2, topPad + plotH + 7),
      );
    }

    // Smooth trend line + subtle glow area when in hours mode (or subtle trend overlay on bars)
    if (centers.length >= 2) {
      final linePath = Path()..moveTo(centers.first.dx, centers.first.dy);
      for (int i = 0; i < centers.length - 1; i++) {
        final p0 = centers[i];
        final p1 = centers[i + 1];
        final midX = (p0.dx + p1.dx) / 2;
        linePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
      }

      if (hoursLineMode) {
        final fillPath = Path.from(linePath)
          ..lineTo(centers.last.dx, topPad + plotH)
          ..lineTo(centers.first.dx, topPad + plotH)
          ..close();
        final fillPaint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _forest.withValues(alpha: 0.42),
              _forest.withValues(alpha: 0.02),
            ],
          ).createShader(Rect.fromLTWH(0, topPad, plotW, plotH));
        canvas.drawPath(fillPath, fillPaint);
      }

      final strokePaint = Paint()
        ..color = hoursLineMode ? _mint : _mint.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = hoursLineMode ? 2.4 : 1.7
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(linePath, strokePaint);

      for (int i = 0; i < centers.length; i++) {
        final c = centers[i];
        final isSel = selectedIndex == i;
        if (isSel) {
          canvas.drawCircle(
            c,
            8,
            Paint()..color = _mint.withValues(alpha: 0.22),
          );
        }
        canvas.drawCircle(
          c,
          isSel ? 4.5 : 3.0,
          Paint()..color = isSel ? _offWhite : _mint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MonthlyVolumeChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.hoursLineMode != hoursLineMode ||
        oldDelegate.points != points;
  }
}
