import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'certificates_documents_screen.dart';

enum _AccordionSection {
  titles,
  qualifications,
  awards,
  personalBests,
  milestones,
}

class _TitleRecordItem {
  final String id;
  final String code;
  final String eventName;
  final String dateLabel;
  final DateTime date;
  final String sport;
  final bool hasCertificate;
  final int phaseA;
  final int phaseB;
  final int phaseC;
  final String judge;
  final bool isHiddenDefault;

  const _TitleRecordItem({
    required this.id,
    required this.code,
    required this.eventName,
    required this.dateLabel,
    required this.date,
    required this.sport,
    required this.hasCertificate,
    required this.phaseA,
    required this.phaseB,
    required this.phaseC,
    required this.judge,
    this.isHiddenDefault = false,
  });

  int get totalScore => phaseA + phaseB + phaseC;
}

class AchievementsTitlesScreen extends StatefulWidget {
  const AchievementsTitlesScreen({super.key});

  @override
  State<AchievementsTitlesScreen> createState() =>
      _AchievementsTitlesScreenState();
}

class _AchievementsTitlesScreenState extends State<AchievementsTitlesScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _card = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _greenAccent = Color(0xFF3E8E72);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stone = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _muted = Color(0xFF7B8580);
  static const Color _border = AppColors.cardBorder; // rgba(255,255,255,0.08)

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  final Set<_AccordionSection> _expanded = {_AccordionSection.titles};
  bool _showAllTitles = false;

  String _sportFilter = 'All Sports';
  bool _certificateOnly = false;
  String _sortMode = 'Newest First';

  late final List<_TitleRecordItem> _titles;
  late final List<_TitleRecordItem> _qualifications;
  late final List<_TitleRecordItem> _awards;
  late final List<_TitleRecordItem> _personalBests;
  late final List<_TitleRecordItem> _milestones;

  final int _extraQualificationsOffset = 8; // 4 sample rows + 8 = 12 total
  final int _extraAwardsOffset = 4; // 3 sample rows + 4 = 7 total
  final int _extraPersonalBestsOffset = 5; // 4 sample rows + 5 = 9 total
  final int _winsCount = 3;

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

    _titles = [
      _TitleRecordItem(
        id: 't_igp3',
        code: 'IGP3',
        eventName: 'National IGP Championship 2024',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 97,
        phaseB: 94,
        phaseC: 98,
        judge: 'Klaus Richter (FCI / SV)',
      ),
      _TitleRecordItem(
        id: 't_igp2',
        code: 'IGP2',
        eventName: 'Regional Qualifier 2023',
        dateLabel: '22 Jun 2023',
        date: DateTime(2023, 6, 22),
        sport: 'IGP',
        hasCertificate: false,
        phaseA: 93,
        phaseB: 90,
        phaseC: 94,
        judge: 'Henrik Lindqvist (FCI)',
      ),
      _TitleRecordItem(
        id: 't_igp1',
        code: 'IGP1',
        eventName: 'Club Trial 2022',
        dateLabel: '05 Mar 2022',
        date: DateTime(2022, 3, 5),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 91,
        phaseB: 88,
        phaseC: 92,
        judge: 'Søren Dalgaard (DKK)',
      ),
      _TitleRecordItem(
        id: 't_bhvt',
        code: 'BH-VT',
        eventName: 'Companion & Traffic Safety Exam 2021',
        dateLabel: '16 Oct 2021',
        date: DateTime(2021, 10, 16),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 58,
        phaseB: 40,
        phaseC: 0,
        judge: 'Maja Bergström (SKK)',
        isHiddenDefault: true,
      ),
    ];

    _qualifications = [
      _TitleRecordItem(
        id: 'q_1',
        code: 'IGP3 Championship Leg',
        eventName: 'Nordic Sieger Selection 2025',
        dateLabel: '18 Aug 2025',
        date: DateTime(2025, 8, 18),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 96,
        phaseB: 93,
        phaseC: 96,
        judge: 'Markus Hoffmann (SV)',
      ),
      _TitleRecordItem(
        id: 'q_2',
        code: 'FH1 Advanced Tracking',
        eventName: 'Autumn Grassland Field Trial',
        dateLabel: '03 Nov 2024',
        date: DateTime(2024, 11, 3),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 95,
        phaseB: 0,
        phaseC: 0,
        judge: 'Henrik Lindqvist (FCI)',
      ),
      _TitleRecordItem(
        id: 'q_3',
        code: 'Open Agility Grade 5',
        eventName: 'Midlands Open Agility Cup',
        dateLabel: '19 May 2024',
        date: DateTime(2024, 5, 19),
        sport: 'Agility',
        hasCertificate: false,
        phaseA: 48,
        phaseB: 47,
        phaseC: 0,
        judge: 'Claire Bennett (KC)',
      ),
      _TitleRecordItem(
        id: 'q_4',
        code: 'AD 20 km Endurance',
        eventName: 'Zealand Working Dog Ring',
        dateLabel: '09 Apr 2023',
        date: DateTime(2023, 4, 9),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 100,
        phaseB: 0,
        phaseC: 0,
        judge: 'Søren Dalgaard (DKK)',
      ),
    ];

    _awards = [
      _TitleRecordItem(
        id: 'a_1',
        code: 'High in Trial (289 / 300 V)',
        eventName: 'National IGP Championship 2024',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 97,
        phaseB: 94,
        phaseC: 98,
        judge: 'Klaus Richter (FCI / SV)',
      ),
      _TitleRecordItem(
        id: 'a_2',
        code: 'Best Phase C Protection (98 pts)',
        eventName: 'National IGP Championship 2024',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: false,
        phaseA: 0,
        phaseB: 0,
        phaseC: 98,
        judge: 'Klaus Richter (FCI / SV)',
      ),
      _TitleRecordItem(
        id: 'a_3',
        code: 'Fastest Clean Jumping Round',
        eventName: 'Regional Agility Trial 2026',
        dateLabel: '29 Jul 2026',
        date: DateTime(2026, 7, 29),
        sport: 'Agility',
        hasCertificate: true,
        phaseA: 47,
        phaseB: 45,
        phaseC: 0,
        judge: 'H. Andersen',
      ),
    ];

    _personalBests = [
      _TitleRecordItem(
        id: 'pb_1',
        code: '289 / 300 pts · Aggregate IGP PB',
        eventName: 'National IGP Championship 2024',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 97,
        phaseB: 94,
        phaseC: 98,
        judge: 'Klaus Richter (FCI / SV)',
      ),
      _TitleRecordItem(
        id: 'pb_2',
        code: '98 / 100 pts · Protection PB',
        eventName: 'National IGP Championship 2024',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: false,
        phaseA: 0,
        phaseB: 0,
        phaseC: 98,
        judge: 'Klaus Richter (FCI / SV)',
      ),
      _TitleRecordItem(
        id: 'pb_3',
        code: '97 / 100 pts · Tracking PB',
        eventName: 'National IGP Championship 2024',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: false,
        phaseA: 97,
        phaseB: 0,
        phaseC: 0,
        judge: 'Klaus Richter (FCI / SV)',
      ),
      _TitleRecordItem(
        id: 'pb_4',
        code: '31.42s · Clear Agility Course PB',
        eventName: 'Regional Agility Trial 2026',
        dateLabel: '29 Jul 2026',
        date: DateTime(2026, 7, 29),
        sport: 'Agility',
        hasCertificate: false,
        phaseA: 50,
        phaseB: 50,
        phaseC: 0,
        judge: 'H. Andersen',
      ),
    ];

    _milestones = [
      _TitleRecordItem(
        id: 'm_1',
        code: 'IGP1 → IGP3 Full Working Trilogy',
        eventName: 'Completed all three FCI IGP grades',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 97,
        phaseB: 94,
        phaseC: 98,
        judge: 'Official FCI Working Scorebook',
      ),
      _TitleRecordItem(
        id: 'm_2',
        code: '250 Recorded Training Sessions',
        eventName: 'Consistent multi-season conditioning',
        dateLabel: '02 Jun 2025',
        date: DateTime(2025, 6, 2),
        sport: 'IGP',
        hasCertificate: false,
        phaseA: 90,
        phaseB: 90,
        phaseC: 90,
        judge: 'Recorded Training Records',
      ),
      _TitleRecordItem(
        id: 'm_3',
        code: 'First National Championship Podium',
        eventName: '1st Place National Finish',
        dateLabel: '14 Sep 2024',
        date: DateTime(2024, 9, 14),
        sport: 'IGP',
        hasCertificate: true,
        phaseA: 97,
        phaseB: 94,
        phaseC: 98,
        judge: 'Klaus Richter (FCI / SV)',
      ),
    ];
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilter =>
      _sportFilter != 'All Sports' || _certificateOnly;

  List<_TitleRecordItem> _filterAndSort(
    List<_TitleRecordItem> source, {
    bool respectDefaultHidden = false,
  }) {
    final list = source.where((item) {
      if (respectDefaultHidden &&
          !_showAllTitles &&
          !_hasActiveFilter &&
          item.isHiddenDefault) {
        return false;
      }
      if (_sportFilter != 'All Sports' && item.sport != _sportFilter) {
        return false;
      }
      if (_certificateOnly && !item.hasCertificate) {
        return false;
      }
      return true;
    }).toList();

    if (_sortMode == 'Newest First') {
      list.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortMode == 'Oldest First') {
      list.sort((a, b) => a.date.compareTo(b.date));
    } else if (_sortMode == 'Highest Score') {
      list.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    } else {
      list.sort((a, b) => a.code.compareTo(b.code));
    }
    return list;
  }

  int get _titlesDisplayCount =>
      _hasActiveFilter ? _filterAndSort(_titles).length : _titles.length;

  int get _qualsDisplayCount => _hasActiveFilter
      ? _filterAndSort(_qualifications).length
      : _qualifications.length + _extraQualificationsOffset;

  int get _awardsDisplayCount => _hasActiveFilter
      ? _filterAndSort(_awards).length
      : _awards.length + _extraAwardsOffset;

  int get _pbDisplayCount => _hasActiveFilter
      ? _filterAndSort(_personalBests).length
      : _personalBests.length + _extraPersonalBestsOffset;

  int get _milestonesDisplayCount =>
      _filterAndSort(_milestones).length;

  void _toggleSection(_AccordionSection section) {
    setState(() {
      if (_expanded.contains(section)) {
        _expanded.remove(section);
      } else {
        _expanded.add(section);
      }
    });
  }

  void _focusSection(_AccordionSection section) {
    setState(() {
      _expanded.add(section);
    });
    _animController.forward(from: 0.35);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Container(height: 1, color: _border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
                child: AnimatedBuilder(
                  animation: _curvedAnim,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_hasActiveFilter || _sortMode != 'Newest First') ...[
                          _buildFilterStatusBanner(),
                          const SizedBox(height: 14),
                        ],
                        _buildSummaryGridCard(),
                        const SizedBox(height: 18),
                        _buildAccordionCard(
                          section: _AccordionSection.titles,
                          leadingIcon: Icons.emoji_events_outlined,
                          title: 'Titles',
                          badgeCount: _titlesDisplayCount,
                          items: _filterAndSort(
                            _titles,
                            respectDefaultHidden: true,
                          ),
                          itemIcon: Icons.emoji_events_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildAccordionCard(
                          section: _AccordionSection.qualifications,
                          leadingIcon: Icons.outlined_flag_rounded,
                          title: 'Qualifications',
                          badgeCount: _qualsDisplayCount,
                          items: _filterAndSort(_qualifications),
                          itemIcon: Icons.outlined_flag_rounded,
                        ),
                        const SizedBox(height: 12),
                        _buildAccordionCard(
                          section: _AccordionSection.awards,
                          leadingIcon: Icons.workspace_premium_outlined,
                          title: 'Awards',
                          badgeCount: _awardsDisplayCount,
                          items: _filterAndSort(_awards),
                          itemIcon: Icons.workspace_premium_outlined,
                        ),
                        const SizedBox(height: 12),
                        _buildAccordionCard(
                          section: _AccordionSection.personalBests,
                          leadingIcon: Icons.star_border_rounded,
                          title: 'Personal Bests',
                          badgeCount: _pbDisplayCount,
                          items: _filterAndSort(_personalBests),
                          itemIcon: Icons.star_border_rounded,
                          showScoreBarsInline: true,
                        ),
                        const SizedBox(height: 12),
                        _buildAccordionCard(
                          section: _AccordionSection.milestones,
                          leadingIcon: Icons.calendar_today_outlined,
                          title: 'Milestones',
                          badgeCount: _milestonesDisplayCount,
                          items: _filterAndSort(_milestones),
                          itemIcon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildAddCustomAchievementButton(),
                        const SizedBox(height: 12),
                        _buildGenerateReportButton(),
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
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _offWhite,
              size: 28,
            ),
            splashRadius: 22,
            tooltip: 'Back',
          ),
          const SizedBox(width: 28),
          const Expanded(
            child: Center(
              child: Text(
                'Achievements & Titles',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _openFilterSheet,
            icon: Icon(Icons.filter_alt_outlined,
              color: _hasActiveFilter ? _mint : _offWhite,
              size: 22,
            ),
            tooltip: 'Filter achievements',
          ),
          IconButton(
            onPressed: _openSortSheet,
            icon: Icon(Icons.filter_list_rounded,
              color: _sortMode != 'Newest First' ? _mint : _stone,
              size: 22,
            ),
            tooltip: 'Sort achievements',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterStatusBanner() {
    final labels = <String>[
      if (_sportFilter != 'All Sports') _sportFilter,
      if (_certificateOnly) 'Certified Only',
      if (_sortMode != 'Newest First') 'Sort: $_sortMode',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _forest.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _mint.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, color: _mint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              labels.join('  ·  '),
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
                _sportFilter = 'All Sports';
                _certificateOnly = false;
                _sortMode = 'Newest First';
              });
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

  Widget _buildSummaryGridCard() {
    final t = _curvedAnim.value;
    String animInt(int v) => '${(v * t).round()}';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildGridMetricCell(
                    value: animInt(_titlesDisplayCount),
                    label: 'TITLES',
                    onTap: () => _focusSection(_AccordionSection.titles),
                  ),
                ),
                Container(width: 1, color: _border),
                Expanded(
                  child: _buildGridMetricCell(
                    value: animInt(_qualsDisplayCount),
                    label: 'QUALIFICATIONS',
                    onTap: () =>
                        _focusSection(_AccordionSection.qualifications),
                  ),
                ),
                Container(width: 1, color: _border),
                Expanded(
                  child: _buildGridMetricCell(
                    value: animInt(_awardsDisplayCount),
                    label: 'AWARDS',
                    onTap: () => _focusSection(_AccordionSection.awards),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(height: 1, color: _border),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildGridMetricCell(
                    value: animInt(_pbDisplayCount),
                    label: 'PERSONAL\nBESTS',
                    onTap: () =>
                        _focusSection(_AccordionSection.personalBests),
                  ),
                ),
                Container(width: 1, color: _border),
                Expanded(
                  child: _buildGridMetricCell(
                    value: animInt(_winsCount),
                    label: 'WINS',
                    onTap: () => _focusSection(_AccordionSection.milestones),
                  ),
                ),
                Container(width: 1, color: _border),
                Expanded(
                  child: _buildGridMetricCell(
                    value: _titles.first.code,
                    label: 'HIGHEST',
                    onTap: () => _openAchievementInspector(_titles.first),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMetricCell({
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 23,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
                height: 1.15,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _stone,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                height: 1.35,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordionCard({
    required _AccordionSection section,
    required IconData leadingIcon,
    required String title,
    required int badgeCount,
    required List<_TitleRecordItem> items,
    required IconData itemIcon,
    bool showScoreBarsInline = false,
  }) {
    final isOpen = _expanded.contains(section);

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _toggleSection(section),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  UlvenikIcon.fromMaterial(leadingIcon, color: _stone, size: 19),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: _stone,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  UlvenikIcon.fromMaterial(
                    isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: _stone,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen) ...[
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  'No matching $title records under active filter.',
                  style: const TextStyle(
                    color: _stone,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              )
            else
              ...List.generate(items.length, (i) {
                final item = items[i];
                return Column(
                  children: [
                    Container(height: 1, color: _border),
                    _buildExpandedRow(
                      item: item,
                      icon: itemIcon,
                      showScoreBar: showScoreBarsInline,
                    ),
                  ],
                );
              }),
            if (section == _AccordionSection.titles &&
                !_hasActiveFilter &&
                _titles.any((e) => e.isHiddenDefault) &&
                _showAllTitles) ...[
              Container(height: 1, color: _border),
              TextButton(
                onPressed: () => setState(() => _showAllTitles = false),
                child: const Text(
                  'Collapse earlier foundational title',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedRow({
    required _TitleRecordItem item,
    required IconData icon,
    required bool showScoreBar,
  }) {
    final pct = item.totalScore > 100
        ? (item.totalScore / 300.0).clamp(0.0, 1.0)
        : (item.totalScore / 100.0).clamp(0.0, 1.0);

    return InkWell(
      onTap: () => _openAchievementInspector(item),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(11),
              ),
              child: UlvenikIcon.fromMaterial(icon, color: _greenAccent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.code,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.eventName,
                    style: const TextStyle(
                      color: _stone,
                      fontSize: 13.2,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 7,
                    runSpacing: 4,
                    children: [
                      Text(
                        item.dateLabel,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (item.hasCertificate) ...[
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _stone.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CertificatesDocumentsScreen(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              UlvenikIcon(UlvenikIcons.training,
                                color: _greenAccent,
                                size: 13,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Certificate',
                                style: TextStyle(
                                  color: _greenAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (showScoreBar) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct * _curvedAnim.value,
                        minHeight: 5.5,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(_mint),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const UlvenikIcon(UlvenikIcons.details,
              color: _stone,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCustomAchievementButton() {
    return Material(
      color: _forest.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: _openAddCustomAchievementSheet,
        child: Container(
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _forest.withValues(alpha: 0.65)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UlvenikIcon(UlvenikIcons.add, color: _greenAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Add Custom Achievement',
                style: TextStyle(
                  color: _greenAccent,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateReportButton() {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: _openGenerateReportSheet,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _border),
          ),
          child: const Row(
            children: [
              Icon(Icons.ios_share_rounded, color: _stone, size: 19),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Generate Achievement Report',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              UlvenikIcon(UlvenikIcons.details, color: _stone, size: 19),
            ],
          ),
        ),
      ),
    );
  }

  void _openAchievementInspector(_TitleRecordItem item) {
    int selectedPhase = 0;
    final phases = <(String, int, int)>[
      if (item.phaseA > 0)
        ('Phase A · Tracking / Course', item.phaseA, 100),
      if (item.phaseB > 0)
        ('Phase B · Obedience / Control', item.phaseB, 100),
      if (item.phaseC > 0)
        ('Phase C · Protection / Final', item.phaseC, 100),
    ];

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
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _forest.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.emoji_events_outlined,
                            color: _mint,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.code,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${item.eventName} · ${item.dateLabel}',
                                style: const TextStyle(
                                  color: _stone,
                                  fontSize: 12.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Judge: ${item.judge}',
                            style: const TextStyle(
                              color: _stone,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            item.sport,
                            style: const TextStyle(
                              color: _alpineBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (phases.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'PHASE BREAKDOWN (TAP BAR TO INSPECT)',
                        style: TextStyle(
                          color: _stone,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.95,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(phases.length, (i) {
                        final p = phases[i];
                        final active = i == selectedPhase;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedPhase = i),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: active
                                  ? _forest.withValues(alpha: 0.16)
                                  : _bg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: active
                                    ? _mint.withValues(alpha: 0.5)
                                    : _border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      p.$1,
                                      style: TextStyle(
                                        color: active ? _offWhite : _stone,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    Text(
                                      '${p.$2} / ${p.$3}',
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (p.$2 / p.$3).clamp(0.0, 1.0),
                                    minHeight: 6,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.08),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      active ? _mint : _alpineBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            title: 'Achievement Verified',
                            message:
                                '${item.code} (${item.eventName}) record copied.',
                            type: SnackbarType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const UlvenikIcon(UlvenikIcons.completed, size: 18),
                        label: Text(
                          item.hasCertificate
                              ? 'Share Verified Title & Certificate'
                              : 'Share Official Title Summary',
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

  void _openFilterSheet() {
    String tempSport = _sportFilter;
    bool tempCert = _certificateOnly;
    bool tempAllTitles = _showAllTitles;

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
                      'Filter Achievements & Titles',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['All Sports', 'IGP', 'Agility', 'PSA']
                          .map((sp) {
                        final active = tempSport == sp;
                        return GestureDetector(
                          onTap: () => setModalState(() => tempSport = sp),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? _forest.withValues(alpha: 0.25)
                                  : _bg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: active ? _mint : _border,
                              ),
                            ),
                            child: Text(
                              sp,
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
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: tempCert,
                      activeThumbColor: _offWhite,
                      activeTrackColor: _forest,
                      title: const Text(
                        'Has Linked Certificate Only',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      onChanged: (v) => setModalState(() => tempCert = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: tempAllTitles,
                      activeThumbColor: _offWhite,
                      activeTrackColor: _forest,
                      title: const Text(
                        'Show Foundational BH-VT Title in List',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      onChanged: (v) => setModalState(() => tempAllTitles = v),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _sportFilter = tempSport;
                            _certificateOnly = tempCert;
                            _showAllTitles = tempAllTitles;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Apply Filters'),
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

  void _openSortSheet() {
    const modes = [
      'Newest First',
      'Oldest First',
      'Highest Score',
      'Alphabetical (A–Z)',
    ];
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
                  'Sort Achievements',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                ...modes.map((m) {
                  final sel = _sortMode == m;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      m,
                      style: TextStyle(
                        color: sel ? _mint : _offWhite,
                        fontSize: 14.5,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: sel
                        ? const Icon(Icons.check_rounded, color: _mint)
                        : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _sortMode = m);
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

  void _openAddCustomAchievementSheet() {
    final codeCtrl = TextEditingController();
    final eventCtrl =
        TextEditingController(text: 'Scandinavian Working Championship');
    _AccordionSection targetSection = _AccordionSection.titles;
    String sport = 'IGP';
    bool hasCert = true;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SafeArea(
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
                        'Add Custom Achievement',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          (_AccordionSection.titles, 'Title'),
                          (_AccordionSection.qualifications, 'Qualification'),
                          (_AccordionSection.awards, 'Award'),
                          (_AccordionSection.personalBests, 'Personal Best'),
                          (_AccordionSection.milestones, 'Milestone'),
                        ].map((pair) {
                          final active = targetSection == pair.$1;
                          return GestureDetector(
                            onTap: () =>
                                setModalState(() => targetSection = pair.$1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? _forest.withValues(alpha: 0.25)
                                    : _bg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: active ? _mint : _border,
                                ),
                              ),
                              child: Text(
                                pair.$2,
                                style: TextStyle(
                                  color: active ? _offWhite : _stone,
                                  fontSize: 12.5,
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
                      const SizedBox(height: 14),
                      TextField(
                        controller: codeCtrl,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Title / Achievement Name *',
                          hintText: 'e.g. FH2, Nordic Champion, Clean Sweep',
                          labelStyle: const TextStyle(color: _stone),
                          hintStyle: const TextStyle(color: _muted),
                          filled: true,
                          fillColor: _bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: eventCtrl,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Competition / Trial Event',
                          labelStyle: const TextStyle(color: _stone),
                          filled: true,
                          fillColor: _bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: sport,
                              dropdownColor: _card,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 13.5,
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Sport',
                                labelStyle: const TextStyle(color: _stone),
                                filled: true,
                                fillColor: _bg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: ['IGP', 'Agility', 'PSA']
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setModalState(() => sport = v);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: hasCert,
                              activeColor: _forest,
                              title: const Text(
                                'Certificate',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              onChanged: (v) =>
                                  setModalState(() => hasCert = v ?? false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = codeCtrl.text.trim().isEmpty
                                ? 'FH2 Master Tracking'
                                : codeCtrl.text.trim();
                            final created = _TitleRecordItem(
                              id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                              code: name,
                              eventName: eventCtrl.text.trim().isEmpty
                                  ? 'Official Sport Trial 2026'
                                  : eventCtrl.text.trim(),
                              dateLabel: '18 Sep 2026',
                              date: DateTime(2026, 9, 18),
                              sport: sport,
                              hasCertificate: hasCert,
                              phaseA: 96,
                              phaseB: 94,
                              phaseC: 95,
                              judge: 'FCI Officiating Judge',
                            );
                            Navigator.pop(ctx);
                            setState(() {
                              switch (targetSection) {
                                case _AccordionSection.titles:
                                  _titles.insert(0, created);
                                  break;
                                case _AccordionSection.qualifications:
                                  _qualifications.insert(0, created);
                                  break;
                                case _AccordionSection.awards:
                                  _awards.insert(0, created);
                                  break;
                                case _AccordionSection.personalBests:
                                  _personalBests.insert(0, created);
                                  break;
                                case _AccordionSection.milestones:
                                  _milestones.insert(0, created);
                                  break;
                              }
                              _expanded.add(targetSection);
                            });
                            _animController.forward(from: 0.25);
                            AppSnackbar.show(
                              context,
                              title: 'Achievement Added',
                              message: '$name added to your sport record.',
                              type: SnackbarType.success,
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
                            'Save Custom Achievement',
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
              ),
            );
          },
        );
      },
    );
  }

  void _openGenerateReportSheet() {
    String selectedFormat = 'Official FCI / Kennel Club PDF Dossier';
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
                    const Text(
                      'Generate Achievement Report',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Includes $_titlesDisplayCount Titles · $_qualsDisplayCount Qualifications · $_awardsDisplayCount Awards · Highest: ${_titles.first.code}',
                      style: const TextStyle(
                        color: _stone,
                        fontSize: 12.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...[
                      'Official FCI / Kennel Club PDF Dossier',
                      'Working Career & Pedigree Portfolio (PDF)',
                      'Complete Trial & Title Ledger (CSV)',
                    ].map((fmt) {
                      final active = selectedFormat == fmt;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () =>
                              setModalState(() => selectedFormat = fmt),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active ? _mint : _border,
                              ),
                            ),
                            child: Row(
                              children: [
                                UlvenikIcon.fromMaterial(
                                  active
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: active ? _mint : _stone,
                                  size: 19,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    fmt,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            title: 'Achievement Report Ready',
                            message: 'Generated $selectedFormat for sharing.',
                            type: SnackbarType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.ios_share_rounded, size: 18),
                        label: const Text(
                          'Export & Share Report',
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
}
