import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'timeline_event_details_screen.dart';

class _CompareMilestone {
  final String periodTag; // 'A' or 'B'
  final String title;
  final String date;
  final bool isHealth;

  const _CompareMilestone({
    required this.periodTag,
    required this.title,
    required this.date,
    required this.isHealth,
  });
}

class _PeriodSnapshot {
  final String id;
  final String title;
  final String shortHeader;
  final int totalEvents;
  final int recordingDays;
  final String firstEvent;
  final String lastEvent;
  final int trainingCount;
  final int scCount;
  final int healthCount;
  final int goalsCount;
  final int mediaCount;
  final List<double> dailySeries;
  final double avgEventsPerDay;
  final int longestStreakDays;
  final int longestGapDays;
  final int locationsVisited;
  final int newLocations;
  final String mostVisitedLabel;
  final int photos;
  final int videos;
  final int voiceNotes;
  final int documents;
  final List<_CompareMilestone> milestones;

  const _PeriodSnapshot({
    required this.id,
    required this.title,
    required this.shortHeader,
    required this.totalEvents,
    required this.recordingDays,
    required this.firstEvent,
    required this.lastEvent,
    required this.trainingCount,
    required this.scCount,
    required this.healthCount,
    required this.goalsCount,
    required this.mediaCount,
    required this.dailySeries,
    required this.avgEventsPerDay,
    required this.longestStreakDays,
    required this.longestGapDays,
    required this.locationsVisited,
    required this.newLocations,
    required this.mostVisitedLabel,
    required this.photos,
    required this.videos,
    required this.voiceNotes,
    required this.documents,
    required this.milestones,
  });
}

class TimelineCompareScreen extends StatefulWidget {
  final bool initialEmpty;

  const TimelineCompareScreen({
    super.key,
    this.initialEmpty = false,
  });

  @override
  State<TimelineCompareScreen> createState() => _TimelineCompareScreenState();
}

class _TimelineCompareScreenState extends State<TimelineCompareScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens (Exact from Figma SVGs) ─────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _appBarBg = Color(0xFF131719);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _innerDark = Color(0xFF0E1214);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _periodAGreen = Color(0xFF3E8E72);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _bronze = Color(0xFFB4823C);
  static const Color _healthRed = Color(0xFF8B3A3A);
  static const Color _gold = Color(0xFFB8920A);
  static const Color _purple = Color(0xFF7A5BAF);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x16FFFFFF);

  static const List<_PeriodSnapshot> _periods = [
    _PeriodSnapshot(
      id: 'sep_2026',
      title: 'Sep 2026',
      shortHeader: 'SEP',
      totalEvents: 74,
      recordingDays: 22,
      firstEvent: '1 Sep',
      lastEvent: '14 Sep',
      trainingCount: 34,
      scCount: 18,
      healthCount: 8,
      goalsCount: 10,
      mediaCount: 4,
      dailySeries: [1.4, 2.2, 3.6, 3.3, 3.9, 3.5, 3.7, 3.1, 4.0, 3.3, 3.7],
      avgEventsPerDay: 3.4,
      longestStreakDays: 9,
      longestGapDays: 2,
      locationsVisited: 8,
      newLocations: 2,
      mostVisitedLabel: 'Riverside Trail — 14 visits',
      photos: 42,
      videos: 14,
      voiceNotes: 6,
      documents: 3,
      milestones: [
        _CompareMilestone(
          periodTag: 'A',
          title: '100th Timeline Entry',
          date: '3 Sep 2026',
          isHealth: false,
        ),
        _CompareMilestone(
          periodTag: 'A',
          title: 'Goal Completed: Distance Down Stay',
          date: '9 Sep 2026',
          isHealth: false,
        ),
      ],
    ),
    _PeriodSnapshot(
      id: 'aug_2026',
      title: 'Aug 2026',
      shortHeader: 'AUG',
      totalEvents: 61,
      recordingDays: 18,
      firstEvent: '1 Aug',
      lastEvent: '31 Aug',
      trainingCount: 28,
      scCount: 16,
      healthCount: 6,
      goalsCount: 7,
      mediaCount: 4,
      dailySeries: [1.8, 2.0, 3.1, 2.6, 3.4, 2.4, 2.9, 2.2, 3.2, 2.5, 2.8],
      avgEventsPerDay: 3.4,
      longestStreakDays: 7,
      longestGapDays: 3,
      locationsVisited: 6,
      newLocations: 1,
      mostVisitedLabel: 'Training Field B — 11 visits',
      photos: 31,
      videos: 9,
      voiceNotes: 4,
      documents: 2,
      milestones: [
        _CompareMilestone(
          periodTag: 'B',
          title: 'First Hydrotherapy Session',
          date: '12 Aug 2026',
          isHealth: true,
        ),
      ],
    ),
    _PeriodSnapshot(
      id: 'this_week',
      title: 'This Week',
      shortHeader: 'WK A',
      totalEvents: 19,
      recordingDays: 6,
      firstEvent: '9 Sep',
      lastEvent: '14 Sep',
      trainingCount: 9,
      scCount: 5,
      healthCount: 1,
      goalsCount: 3,
      mediaCount: 1,
      dailySeries: [2.0, 3.0, 4.0, 2.5, 3.5, 4.2, 3.0, 3.8, 3.4, 3.9, 4.1],
      avgEventsPerDay: 3.2,
      longestStreakDays: 6,
      longestGapDays: 1,
      locationsVisited: 4,
      newLocations: 1,
      mostVisitedLabel: 'Riverside Trail — 5 visits',
      photos: 12,
      videos: 5,
      voiceNotes: 2,
      documents: 1,
      milestones: [
        _CompareMilestone(
          periodTag: 'A',
          title: 'Goal Completed: Distance Down Stay',
          date: '9 Sep 2026',
          isHealth: false,
        ),
      ],
    ),
    _PeriodSnapshot(
      id: 'last_week',
      title: 'Last Week',
      shortHeader: 'WK B',
      totalEvents: 15,
      recordingDays: 5,
      firstEvent: '2 Sep',
      lastEvent: '8 Sep',
      trainingCount: 7,
      scCount: 4,
      healthCount: 1,
      goalsCount: 2,
      mediaCount: 1,
      dailySeries: [1.5, 2.5, 2.8, 2.0, 3.0, 2.4, 2.2, 2.9, 2.6, 2.5, 2.8],
      avgEventsPerDay: 3.0,
      longestStreakDays: 4,
      longestGapDays: 2,
      locationsVisited: 3,
      newLocations: 0,
      mostVisitedLabel: 'Blackwood Woods — 4 visits',
      photos: 9,
      videos: 3,
      voiceNotes: 1,
      documents: 1,
      milestones: [
        _CompareMilestone(
          periodTag: 'B',
          title: '100th Timeline Entry',
          date: '3 Sep 2026',
          isHealth: false,
        ),
      ],
    ),
    _PeriodSnapshot(
      id: 'jul_2026',
      title: 'Jul 2026',
      shortHeader: 'JUL',
      totalEvents: 54,
      recordingDays: 16,
      firstEvent: '2 Jul',
      lastEvent: '30 Jul',
      trainingCount: 25,
      scCount: 13,
      healthCount: 5,
      goalsCount: 8,
      mediaCount: 3,
      dailySeries: [1.2, 1.9, 2.5, 2.8, 2.4, 3.0, 2.6, 2.1, 2.9, 2.7, 2.4],
      avgEventsPerDay: 3.4,
      longestStreakDays: 6,
      longestGapDays: 4,
      locationsVisited: 5,
      newLocations: 1,
      mostVisitedLabel: 'Guildford Trial Grounds — 9 visits',
      photos: 27,
      videos: 8,
      voiceNotes: 3,
      documents: 2,
      milestones: [
        _CompareMilestone(
          periodTag: 'B',
          title: 'Regional IGP II — 1st Place',
          date: '20 Jul 2026',
          isHealth: false,
        ),
      ],
    ),
  ];

  late bool _isEmptyState;
  String _periodAId = 'sep_2026';
  String _periodBId = 'aug_2026';
  String _activePreset = 'This Month vs Last Month';
  bool _cumulativeChart = false;
  int? _selectedChartIndex;
  String? _highlightedCategory;

  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartAnim = CurvedAnimation(
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

  _PeriodSnapshot get _periodA =>
      _periods.firstWhere((p) => p.id == _periodAId, orElse: () => _periods[0]);

  _PeriodSnapshot get _periodB =>
      _periods.firstWhere((p) => p.id == _periodBId, orElse: () => _periods[1]);

  String _formatDiff(num a, num b, {bool decimals = false}) {
    // Matches Figma convention where Sep(74) vs Aug(61) displays -13 (B - A)
    final diff = b - a;
    if (diff.abs() < 0.01) return '0';
    final formatted =
        decimals ? diff.toStringAsFixed(1) : diff.round().toString();
    return diff > 0 ? '+$formatted' : formatted;
  }

  void _applyPreset(String preset) {
    setState(() {
      _isEmptyState = false;
      _activePreset = preset;
      _selectedChartIndex = null;
      if (preset == 'This Week vs Last Week') {
        _periodAId = 'this_week';
        _periodBId = 'last_week';
      } else if (preset == 'This Month vs Last Month') {
        _periodAId = 'sep_2026';
        _periodBId = 'aug_2026';
      } else {
        _periodAId = 'sep_2026';
        _periodBId = 'jul_2026';
      }
    });
    _chartAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isEmptyState
                ? _buildEmptyState()
                : _buildPopulatedState(_periodA, _periodB),
          ),
          _buildBottomActionStrip(),
        ],
      ),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.timeline),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _appBarBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const UlvenikIcon(UlvenikIcons.back, color: _stoneGrey, size: 26),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Timeline Compare',
        style: TextStyle(
          color: _offWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Select Comparison Windows',
          icon: UlvenikIcon.fromMaterial(
            _isEmptyState ? Icons.tune : Icons.filter_list,
            color: _stoneGrey,
            size: 20,
          ),
          onPressed: _showChangeDatesSheet,
        ),
        PopupMenuButton<String>(
          icon: const UlvenikIcon(UlvenikIcons.more, color: _stoneGrey, size: 20),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: _cardBorder),
          ),
          onSelected: (val) {
            if (val == 'toggle_empty') {
              setState(() => _isEmptyState = !_isEmptyState);
              if (!_isEmptyState) _chartAnimController.forward(from: 0);
              AppSnackbar.show(
                context,
                message: _isEmptyState
                    ? 'Switched to Empty State preview'
                    : 'Switched to Populated State',
                type: SnackbarType.info,
              );
            } else if (val == 'swap') {
              setState(() {
                final tmp = _periodAId;
                _periodAId = _periodBId;
                _periodBId = tmp;
                _activePreset = 'Custom';
                _selectedChartIndex = null;
              });
              _chartAnimController.forward(from: 0);
              AppSnackbar.show(
                context,
                message: 'Swapped Period A and Period B',
                type: SnackbarType.info,
              );
            } else if (val == 'reset') {
              _applyPreset('This Month vs Last Month');
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle_empty',
              child: Text(
                _isEmptyState
                    ? 'Switch to Populated State'
                    : 'Switch to Empty State',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'swap',
              child: Text(
                'Swap Period A ↔ Period B',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text(
                'Reset Default (Sep 2026 vs Aug 2026)',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _cardBorder),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED TOP PERIOD A vs PERIOD B SELECTOR + PRESET PILLS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPeriodHeaderSection(_PeriodSnapshot a, _PeriodSnapshot b) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPeriodSelectorCard(
                    tag: 'PERIOD A',
                    title: a.title,
                    subtitle: _isEmptyState ? 'No Data' : '${a.totalEvents} Events',
                    accentColor: _isEmptyState ? _mint : _periodAGreen,
                    barColor: _forest,
                    onTap: () => _showSinglePeriodPicker(isPeriodA: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPeriodSelectorCard(
                    tag: 'PERIOD B',
                    title: b.title,
                    subtitle: _isEmptyState ? 'No Data' : '${b.totalEvents} Events',
                    accentColor: _alpineBlue,
                    barColor: _alpineBlue,
                    onTap: () => _showSinglePeriodPicker(isPeriodA: false),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (_isEmptyState) return;
                setState(() {
                  final tmp = _periodAId;
                  _periodAId = _periodBId;
                  _periodBId = tmp;
                  _activePreset = 'Custom';
                });
                _chartAnimController.forward(from: 0);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _obsidian,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14), width: 1.2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'VS',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final preset in const [
                'This Week vs Last Week',
                'This Month vs Last Month',
                'Sep vs Jul Season',
              ]) ...[
                GestureDetector(
                  onTap: () => _applyPreset(preset),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 8.5),
                    decoration: BoxDecoration(
                      color: (!_isEmptyState && _activePreset == preset)
                          ? _forest
                          : _carbon,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (!_isEmptyState && _activePreset == preset)
                            ? _forest
                            : _cardBorder,
                      ),
                    ),
                    child: Text(
                      preset,
                      style: TextStyle(
                        color: (!_isEmptyState && _activePreset == preset)
                            ? _offWhite
                            : _stoneGrey,
                        fontSize: 12.5,
                        fontWeight: (!_isEmptyState && _activePreset == preset)
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelectorCard({
    required String tag,
    required String title,
    required String subtitle,
    required Color accentColor,
    required Color barColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: _cardBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3.5, color: barColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 12, 11, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tag,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                fontFamily: 'Inter',
                              ),
                            ),
                            UlvenikIcon(UlvenikIcons.edit,
                              color: accentColor.withValues(alpha: 0.85),
                              size: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // POPULATED STATE (7 Figma Cards in Exact Order)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedState(_PeriodSnapshot a, _PeriodSnapshot b) {
    // Combine milestones matching selected periods
    final combinedMilestones = <_CompareMilestone>[
      ...a.milestones.take(1),
      ...b.milestones,
      ...a.milestones.skip(1),
    ];

    final sharedLocs = math.min(a.locationsVisited, b.locationsVisited) - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _buildPeriodHeaderSection(a, b),
          const SizedBox(height: 18),

          // 1. SUMMARY CARD
          _buildSectionCard(
            icon: Icons.table_chart_outlined,
            title: 'Summary',
            colAHeader: '${a.shortHeader} (A)',
            colBHeader: '${b.shortHeader} (B)',
            showDiffHeader: true,
            child: Column(
              children: [
                _buildComparisonRow(
                  label: 'Total Events',
                  valA: '${a.totalEvents}',
                  valB: '${b.totalEvents}',
                  diff: _formatDiff(a.totalEvents, b.totalEvents),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'Recording Days',
                  valA: '${a.recordingDays}',
                  valB: '${b.recordingDays}',
                  diff: _formatDiff(a.recordingDays, b.recordingDays),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'First Event',
                  valA: a.firstEvent,
                  valB: b.firstEvent,
                  diff: '—',
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'Last Event',
                  valA: a.lastEvent,
                  valB: b.lastEvent,
                  diff: '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. CATEGORIES CARD + PROPORTIONAL STACKED BARS
          _buildSectionCard(
            icon: Icons.layers_outlined,
            title: 'Categories',
            colAHeader: 'A',
            colBHeader: 'B',
            showDiffHeader: true,
            child: Column(
              children: [
                _buildCategoryRow('Training', _alpineBlue, a.trainingCount, b.trainingCount),
                _buildRowDivider(),
                _buildCategoryRow('S&C', _bronze, a.scCount, b.scCount),
                _buildRowDivider(),
                _buildCategoryRow('Health', _healthRed, a.healthCount, b.healthCount),
                _buildRowDivider(),
                _buildCategoryRow('Goals', _gold, a.goalsCount, b.goalsCount),
                _buildRowDivider(),
                _buildCategoryRow('Media', _purple, a.mediaCount, b.mediaCount),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _innerDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: AnimatedBuilder(
                    animation: _chartAnim,
                    builder: (context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PERIOD A (${a.shortHeader})',
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Text(
                                '100% (${a.totalEvents})',
                                style: const TextStyle(
                                  color: _periodAGreen,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _buildProportionalBar(a, _chartAnim.value),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PERIOD B (${b.shortHeader})',
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Text(
                                '100% (${b.totalEvents})',
                                style: const TextStyle(
                                  color: _alpineBlue,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _buildProportionalBar(b, _chartAnim.value),
                          const SizedBox(height: 10),
                          const Text(
                            'Proportional to total events in each period',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. ACTIVITY DUAL-SERIES INTERACTIVE ANIMATED CHART CARD
          _buildActivityChartCard(a, b),
          const SizedBox(height: 16),

          // 4. RECORDING CONSISTENCY CARD
          _buildSectionCard(
            icon: Icons.local_fire_department_outlined,
            title: 'Recording\nConsistency',
            colAHeader: 'A',
            colBHeader: 'B',
            showDiffHeader: true,
            child: Column(
              children: [
                _buildComparisonRow(
                  label: 'Recording Days',
                  valA: '${a.recordingDays}',
                  valB: '${b.recordingDays}',
                  diff: _formatDiff(a.recordingDays, b.recordingDays),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'Avg Events/Day',
                  valA: a.avgEventsPerDay.toStringAsFixed(1),
                  valB: b.avgEventsPerDay.toStringAsFixed(1),
                  diff: _formatDiff(a.avgEventsPerDay, b.avgEventsPerDay,
                      decimals: true),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'Longest Streak',
                  valA: '${a.longestStreakDays} d',
                  valB: '${b.longestStreakDays} d',
                  diff: _formatDiff(a.longestStreakDays, b.longestStreakDays),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'Longest Gap',
                  valA: '${a.longestGapDays} d',
                  valB: '${b.longestGapDays} d',
                  diff: _formatDiff(a.longestGapDays, b.longestGapDays),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. LOCATIONS CARD
          _buildSectionCard(
            icon: Icons.location_on_outlined,
            title: 'Locations',
            colAHeader: 'A',
            colBHeader: 'B',
            showDiffHeader: true,
            child: Column(
              children: [
                _buildComparisonRow(
                  label: 'Locations Visited',
                  valA: '${a.locationsVisited}',
                  valB: '${b.locationsVisited}',
                  diff: _formatDiff(a.locationsVisited, b.locationsVisited),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'New Locations',
                  valA: '${a.newLocations}',
                  valB: '${b.newLocations}',
                  diff: _formatDiff(a.newLocations, b.newLocations),
                ),
                _buildRowDivider(),
                _buildComparisonRow(
                  label: 'Shared Locations',
                  valA: '$sharedLocs',
                  valB: '$sharedLocs',
                  diff: '—',
                ),
                _buildRowDivider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Most Visited (A):',
                      style: TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                    Flexible(
                      child: Text(
                        a.mostVisitedLabel,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Most Visited (B):',
                      style: TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                    Flexible(
                      child: Text(
                        b.mostVisitedLabel,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 6. ATTACHMENTS 2x2 GRID CARD
          _buildSectionCard(
            icon: Icons.photo_camera_outlined,
            title: 'Attachments',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildAttachmentTile('PHOTOS', a.photos, b.photos),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildAttachmentTile('VIDEOS', a.videos, b.videos),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildAttachmentTile(
                          'VOICE NOTES', a.voiceNotes, b.voiceNotes),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildAttachmentTile(
                          'DOCUMENTS', a.documents, b.documents),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 7. MILESTONES CARD
          _buildSectionCard(
            icon: Icons.emoji_events_outlined,
            title: 'Milestones',
            child: Column(
              children: [
                for (int i = 0; i < combinedMilestones.length; i++) ...[
                  if (i > 0) _buildRowDivider(),
                  _buildMilestoneRow(combinedMilestones[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
    String? colAHeader,
    String? colBHeader,
    bool showDiffHeader = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UlvenikIcon.fromMaterial(icon, color: _sage, size: 17),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              if (colAHeader != null)
                SizedBox(
                  width: 52,
                  child: Text(
                    colAHeader,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              if (colBHeader != null)
                SizedBox(
                  width: 54,
                  child: Text(
                    colBHeader,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              if (showDiffHeader)
                const SizedBox(
                  width: 44,
                  child: Text(
                    'DIFF',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildRowDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 1,
      color: Colors.white.withValues(alpha: 0.05),
    );
  }

  Widget _buildComparisonRow({
    required String label,
    required String valA,
    required String valB,
    required String diff,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
        SizedBox(
          width: 52,
          child: Text(
            valA,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: _periodAGreen,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
        SizedBox(
          width: 54,
          child: Text(
            valB,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: _alpineBlue,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            diff,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(String name, Color dotColor, int a, int b) {
    final isSelected = _highlightedCategory == name;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _highlightedCategory = isSelected ? null : name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          vertical: isSelected ? 4 : 0,
          horizontal: isSelected ? 6 : 0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? dotColor.withValues(alpha: 0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 7.5,
              height: 7.5,
              decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 52,
              child: Text(
                '$a',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: _periodAGreen,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 54,
              child: Text(
                '$b',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: _alpineBlue,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 44,
              child: Text(
                _formatDiff(a, b),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProportionalBar(_PeriodSnapshot p, double animProgress) {
    final segments = [
      ('Training', p.trainingCount, _alpineBlue),
      ('S&C', p.scCount, _bronze),
      ('Health', p.healthCount, _healthRed),
      ('Goals', p.goalsCount, _gold),
      ('Media', p.mediaCount, _purple),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 5.5,
        width: double.infinity,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: animProgress.clamp(0.05, 1.0),
          child: Row(
            children: [
              for (int i = 0; i < segments.length; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  flex: math.max(1, segments[i].$2),
                  child: Container(
                    color: _highlightedCategory == null ||
                            _highlightedCategory == segments[i].$1
                        ? segments[i].$3
                        : segments[i].$3.withValues(alpha: 0.25),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityChartCard(_PeriodSnapshot a, _PeriodSnapshot b) {
    List<double> buildSeries(List<double> raw) {
      if (!_cumulativeChart) return raw;
      double running = 0;
      return raw.map((v) {
        running += v;
        return running;
      }).toList();
    }

    final seriesA = buildSeries(a.dailySeries);
    final seriesB = buildSeries(b.dailySeries);
    const xTicks = ['Day 1', 'Day 7', 'Day 14', 'Day 21', 'Day 28', 'End'];

    final idx = (_selectedChartIndex != null &&
            _selectedChartIndex! < seriesA.length &&
            _selectedChartIndex! < seriesB.length)
        ? _selectedChartIndex
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UlvenikIcon(UlvenikIcons.progress, color: _sage, size: 17),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Activity',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _cumulativeChart = !_cumulativeChart;
                    _selectedChartIndex = null;
                  });
                  _chartAnimController.forward(from: 0);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _innerDark,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(
                    _cumulativeChart ? 'CUMULATIVE' : 'EVENTS / DAY',
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (idx != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _innerDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Checkpoint ${idx + 1}/${seriesA.length}',
                    style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'A: ${seriesA[idx].toStringAsFixed(1)}  ·  B: ${seriesB[idx].toStringAsFixed(1)}',
                    style: const TextStyle(
                        color: _offWhite,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
            decoration: BoxDecoration(
              color: _innerDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      void handleScrub(Offset local) {
                        final ratio =
                            (local.dx / constraints.maxWidth).clamp(0.0, 1.0);
                        final i = (ratio * (seriesA.length - 1)).round();
                        if (_selectedChartIndex != i) {
                          setState(() => _selectedChartIndex = i);
                        }
                      }

                      return GestureDetector(
                        onTapDown: (d) => handleScrub(d.localPosition),
                        onHorizontalDragUpdate: (d) =>
                            handleScrub(d.localPosition),
                        child: AnimatedBuilder(
                          animation: _chartAnim,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _DualCompareLinePainter(
                                seriesA: seriesA,
                                seriesB: seriesB,
                                progress: _chartAnim.value,
                                selectedIndex: idx,
                                colorA: _periodAGreen,
                                colorB: _alpineBlue,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final tick in xTicks)
                      Text(
                        tick,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 10,
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _periodAGreen,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${a.title} (A)',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _alpineBlue,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${b.title} (B)',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentTile(String label, int valA, int valB) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _innerDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Inter'),
              children: [
                TextSpan(
                  text: '$valA',
                  style: const TextStyle(
                    color: _periodAGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text: ' / ',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '$valB',
                  style: const TextStyle(
                    color: _alpineBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRow(_CompareMilestone item) {
    final isA = item.periodTag == 'A';
    final accent = isA ? _periodAGreen : _alpineBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: accent.withValues(alpha: 0.7)),
            ),
            alignment: Alignment.center,
            child: Text(
              item.periodTag,
              style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TimelineEventDetailsScreen(
                    initialVariant: item.isHealth
                        ? TimelineEventVariant.health
                        : TimelineEventVariant.training,
                    initialTitle: item.title,
                    initialDog: 'Murphy',
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Event',
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  UlvenikIcon(UlvenikIcons.details, color: accent, size: 13),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matches 03_timeline_compare_empty.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _buildPeriodHeaderSection(_periodA, _periodB),
          const SizedBox(height: 52),
          // Custom Split Comparison Graphic matching Figma SVG
          SizedBox(
            width: 88,
            height: 88,
            child: CustomPaint(
              painter: const _SplitCompareEmptyIconPainter(),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Not Enough Timeline Data',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _offWhite,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Add more records to your Timeline\nbefore meaningful comparisons can be\ndisplayed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.maybePop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Go to Timeline',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 8),
                  UlvenikIcon(UlvenikIcons.details, size: 17),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: _showWhatGetsComparedSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF272B29),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const UlvenikIcon(UlvenikIcons.progress,
                      color: _alpineBlue,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What gets compared?',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Sessions, duration, goals & recorded activity',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STICKY BOTTOM STRIP ("Change Dates" & "Export")
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBottomActionStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: _appBarBg,
        border: Border(
          top: BorderSide(color: _cardBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showChangeDatesSheet,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.calendar,
                    color: _stoneGrey, size: 15),
                SizedBox(width: 7),
                Text(
                  'Change Dates',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _isEmptyState
                ? () {
                    AppSnackbar.show(
                      context,
                      message:
                          'Select populated comparison periods first to export a report.',
                      type: SnackbarType.warning,
                    );
                  }
                : _showExportSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.overflowMenu,
                  color: _isEmptyState
                      ? _stoneGrey.withValues(alpha: 0.45)
                      : _periodAGreen,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Export',
                  style: TextStyle(
                    color: _isEmptyState
                        ? _stoneGrey.withValues(alpha: 0.45)
                        : _periodAGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERACTIVE MODALS
  // ═══════════════════════════════════════════════════════════════════════════
  void _showSinglePeriodPicker({required bool isPeriodA}) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isPeriodA ? 'Select Period A' : 'Select Period B',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (final p in _periods)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: UlvenikIcon(UlvenikIcons.calendar,
                    color: isPeriodA ? _periodAGreen : _alpineBlue,
                    size: 20,
                  ),
                  title: Text(
                    p.title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${p.totalEvents} events · ${p.recordingDays} recording days',
                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  trailing: ((isPeriodA && _periodAId == p.id) ||
                          (!isPeriodA && _periodBId == p.id))
                      ? const UlvenikIcon(UlvenikIcons.completed, color: _mint, size: 19)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _isEmptyState = false;
                      if (isPeriodA) {
                        _periodAId = p.id;
                      } else {
                        _periodBId = p.id;
                      }
                      _activePreset = 'Custom';
                      _selectedChartIndex = null;
                    });
                    _chartAnimController.forward(from: 0);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeDatesSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Change Comparison Dates',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              for (final preset in const [
                'This Month vs Last Month',
                'This Week vs Last Week',
                'Sep vs Jul Season',
              ])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const UlvenikIcon(UlvenikIcons.history,
                      color: _mint, size: 20),
                  title: Text(
                    preset,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: _activePreset == preset && !_isEmptyState
                      ? const UlvenikIcon(UlvenikIcons.completed, color: _mint, size: 18)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    _applyPreset(preset);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Export ${_periodA.title} vs ${_periodB.title}',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const UlvenikIcon(UlvenikIcons.training,
                    color: _mint, size: 21),
                title: const Text(
                  'Coach & Physio PDF Comparison Report',
                  style: TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Includes Summary, Category ratios, Activity curve & Milestones',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  AppSnackbar.show(
                    context,
                    message:
                        'Generated PDF Comparison (${_periodA.title} vs ${_periodB.title})',
                    type: SnackbarType.success,
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const UlvenikIcon(UlvenikIcons.training,
                    color: _alpineBlue, size: 21),
                title: const Text(
                  'Export Raw CSV Metrics',
                  style: TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Side-by-side daily recorded activity & attachment counts',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  AppSnackbar.show(
                    context,
                    message: 'CSV comparison metrics exported',
                    type: SnackbarType.success,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWhatGetsComparedSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'What Gets Compared?',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Timeline Compare compares any two date windows using only the objective records you have entered into Ulvenik — including sessions, duration, goals, recorded activity across categories (Training, S&C, Health, Goals, Media), recording patterns, saved locations, attachments, and milestones.',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _isEmptyState = false);
                    _chartAnimController.forward(from: 0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Preview Sample Comparison (Sep vs Aug)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS FOR DUAL LINE COMPARISON CHART & EMPTY ICON
// ═════════════════════════════════════════════════════════════════════════════

class _DualCompareLinePainter extends CustomPainter {
  final List<double> seriesA;
  final List<double> seriesB;
  final double progress;
  final int? selectedIndex;
  final Color colorA;
  final Color colorB;

  _DualCompareLinePainter({
    required this.seriesA,
    required this.seriesB,
    required this.progress,
    required this.selectedIndex,
    required this.colorA,
    required this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final len = math.min(seriesA.length, seriesB.length);
    if (len < 2) return;

    final allValues = [...seriesA, ...seriesB];
    final minV = allValues.reduce(math.min) * 0.8;
    final maxV = allValues.reduce(math.max) * 1.1;
    final span = (maxV - minV).abs() < 0.01 ? 1.0 : (maxV - minV);

    // Subtle horizontal grid lines matching Figma
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    for (int g = 0; g < 4; g++) {
      final y = size.height * (0.12 + g * 0.25);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    List<Offset> buildPoints(List<double> s) {
      final pts = <Offset>[];
      for (int i = 0; i < len; i++) {
        final x = (i / (len - 1)) * size.width;
        final norm = (s[i] - minV) / span;
        final targetY = size.height * 0.88 - (norm * size.height * 0.74);
        final y = size.height * 0.90 + (targetY - size.height * 0.90) * progress;
        pts.add(Offset(x, y));
      }
      return pts;
    }

    final ptsA = buildPoints(seriesA);
    final ptsB = buildPoints(seriesB);

    void drawSeries(List<Offset> pts, Color color) {
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.9
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );

      // Key vertex dots like Figma (indices 2, 4, 8)
      for (final idx in [2, 4, 8]) {
        if (idx < pts.length) {
          canvas.drawCircle(pts[idx], 3.0, Paint()..color = color);
        }
      }
    }

    drawSeries(ptsB, colorB);
    drawSeries(ptsA, colorA);

    if (selectedIndex != null &&
        selectedIndex! >= 0 &&
        selectedIndex! < len) {
      final x = ptsA[selectedIndex!].dx;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.24)
          ..strokeWidth = 1.1,
      );
      canvas.drawCircle(ptsA[selectedIndex!], 4.5, Paint()..color = colorA);
      canvas.drawCircle(ptsB[selectedIndex!], 4.5, Paint()..color = colorB);
    }
  }

  @override
  bool shouldRepaint(covariant _DualCompareLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.seriesA != seriesA ||
        oldDelegate.seriesB != seriesB;
  }
}

class _SplitCompareEmptyIconPainter extends CustomPainter {
  const _SplitCompareEmptyIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final glow = RadialGradient(
      colors: [
        const Color(0xFF95D3BB).withValues(alpha: 0.14),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: center, radius: 44));
    canvas.drawCircle(center, 44, Paint()..shader = glow);

    // Outer dashed frame
    final outer = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 52, height: 50),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      outer,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Left Mint Card
    final leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - 20, center.dy - 18, 18, 36),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      leftRect,
      Paint()
        ..color = const Color(0xFF95D3BB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(center.dx - 17, center.dy - 9),
      Offset(center.dx - 5, center.dy - 9),
      Paint()
        ..color = const Color(0xFF95D3BB)
        ..strokeWidth = 1.4,
    );
    canvas.drawCircle(
      Offset(center.dx - 11, center.dy + 3),
      4,
      Paint()
        ..color = const Color(0xFF95D3BB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Right Alpine Blue Card
    final rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx + 2, center.dy - 18, 18, 36),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      rightRect,
      Paint()
        ..color = const Color(0xFF5D8FAF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(center.dx + 5, center.dy - 9),
      Offset(center.dx + 17, center.dy - 9),
      Paint()
        ..color = const Color(0xFF5D8FAF)
        ..strokeWidth = 1.4,
    );
    canvas.drawLine(
      Offset(center.dx + 6, center.dy + 3),
      Offset(center.dx + 16, center.dy + 3),
      Paint()
        ..color = const Color(0xFF5D8FAF)
        ..strokeWidth = 1.4,
    );

    // Center Split Vertical Line
    canvas.drawLine(
      Offset(center.dx, center.dy - 26),
      Offset(center.dx, center.dy + 26),
      Paint()
        ..color = const Color(0xFF95D3BB)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
