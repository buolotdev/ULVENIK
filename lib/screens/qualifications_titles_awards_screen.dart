import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum AchievementCategory { qualification, title, award, certificate }

class SportPhaseScore {
  final String phaseName;
  final int score;
  final int maxScore;
  final int passMinimum;
  final String judgeNote;

  const SportPhaseScore({
    required this.phaseName,
    required this.score,
    required this.maxScore,
    required this.passMinimum,
    required this.judgeNote,
  });
}

class SportAchievementItem {
  final String id;
  final String name;
  final String sport;
  final AchievementCategory category;
  final String dateLabel;
  final DateTime date;
  final String dogName;
  final String venue;
  final String judge;
  final String registryCode;
  final List<SportPhaseScore> phases;
  final List<String> requirementsMet;
  final String nextStepLabel;
  final double nextStepProgress;
  final bool isArchived;

  const SportAchievementItem({
    required this.id,
    required this.name,
    required this.sport,
    required this.category,
    required this.dateLabel,
    required this.date,
    required this.dogName,
    required this.venue,
    required this.judge,
    required this.registryCode,
    required this.phases,
    required this.requirementsMet,
    required this.nextStepLabel,
    required this.nextStepProgress,
    this.isArchived = false,
  });

  String get categoryLabel {
    switch (category) {
      case AchievementCategory.qualification:
        return 'Qualification';
      case AchievementCategory.title:
        return 'Title';
      case AchievementCategory.award:
        return 'Award';
      case AchievementCategory.certificate:
        return 'Certificate';
    }
  }

  IconData get leadingIcon {
    switch (category) {
      case AchievementCategory.qualification:
      case AchievementCategory.award:
        return Icons.emoji_events_outlined;
      case AchievementCategory.title:
        return Icons.star_border_rounded;
      case AchievementCategory.certificate:
        return Icons.description_outlined;
    }
  }
}

class QualificationsTitlesAwardsScreen extends StatefulWidget {
  const QualificationsTitlesAwardsScreen({super.key});

  @override
  State<QualificationsTitlesAwardsScreen> createState() =>
      _QualificationsTitlesAwardsScreenState();
}

class _QualificationsTitlesAwardsScreenState
    extends State<QualificationsTitlesAwardsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _card = AppColors.cardsCarbon; // #1A1F22
  static const Color _iconBox = Color(0xFF23292D);
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stone = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder; // rgba(255,255,255,0.08)

  late final AnimationController _entryAnim;

  bool _searchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _selectedDog = 'All Dogs';
  String _selectedSport = 'All Sports';
  String _selectedYear = 'All Years';
  AchievementCategory? _selectedCategory;
  bool _showEarlierRecords = false;

  late List<SportAchievementItem> _items;

  @override
  void initState() {
    super.initState();
    _entryAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();

    _items = [
      SportAchievementItem(
        id: 'ach_1',
        name: 'IGP 1',
        sport: 'IGP',
        category: AchievementCategory.qualification,
        dateLabel: '15 Sep 2026',
        date: DateTime(2026, 9, 15),
        dogName: 'Rex',
        venue: 'Nordic Working Dog Club — Roskilde',
        judge: 'Henrik Lindqvist (FCI)',
        registryCode: 'FCI-IGP1-2026-8841',
        phases: const [
          SportPhaseScore(
            phaseName: 'Phase A · Tracking',
            score: 96,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'Deep nose commitment on both corners; decisive article indication.',
          ),
          SportPhaseScore(
            phaseName: 'Phase B · Obedience',
            score: 91,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'Crisp heeling transitions and fast recall; slight sit-in-motion delay.',
          ),
          SportPhaseScore(
            phaseName: 'Phase C · Protection',
            score: 97,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'Full calm grips, instant outs under high drive, strong guard phases.',
          ),
        ],
        requirementsMet: const [
          'Valid BH-VT temperament & traffic test on file',
          'Minimum 70/100 achieved across Phases A, B, and C',
          'Official scorebook stamped by FCI-licensed judge',
        ],
        nextStepLabel: 'IGP 2 Qualification Pathway (2 / 3 prerequisites ready)',
        nextStepProgress: 0.67,
      ),
      SportAchievementItem(
        id: 'ach_2',
        name: 'Best Protection Work',
        sport: 'IGP',
        category: AchievementCategory.award,
        dateLabel: '15 Sep 2026',
        date: DateTime(2026, 9, 15),
        dogName: 'Rex',
        venue: 'Nordic Working Dog Club — Roskilde',
        judge: 'Henrik Lindqvist (FCI)',
        registryCode: 'NWDC-SPEC-2026-09',
        phases: const [
          SportPhaseScore(
            phaseName: 'Blind Search & Hold/Bark',
            score: 29,
            maxScore: 30,
            passMinimum: 21,
            judgeNote: 'Tight six-blind pattern and sustained rhythmic barking.',
          ),
          SportPhaseScore(
            phaseName: 'Escape & Re-attack Prevention',
            score: 39,
            maxScore: 40,
            passMinimum: 28,
            judgeNote: 'Explosive entry, full grip, clean release on first verbal cue.',
          ),
          SportPhaseScore(
            phaseName: 'Long Attack Courage Test',
            score: 29,
            maxScore: 30,
            passMinimum: 21,
            judgeNote: 'Unwavering line at speed with dominant helper control.',
          ),
        ],
        requirementsMet: const [
          'Highest Phase C score across all trial classes (97/100)',
          'Pronounced TSB ("a" rating) confirmed by trial judge',
        ],
        nextStepLabel: 'Regional Sieger Protection Cup Nomination',
        nextStepProgress: 0.85,
      ),
      SportAchievementItem(
        id: 'ach_3',
        name: 'IPO Champion 2025',
        sport: 'IGP',
        category: AchievementCategory.title,
        dateLabel: '12 Nov 2025',
        date: DateTime(2025, 11, 12),
        dogName: 'Rex',
        venue: 'Scandinavian Working Championship — Malmö',
        judge: 'Maja Bergström (SKK / FCI)',
        registryCode: 'SKK-CH-2025-419',
        phases: const [
          SportPhaseScore(
            phaseName: 'Phase A · Championship Track',
            score: 98,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'Flawless 800-pace grassland track in crosswind conditions.',
          ),
          SportPhaseScore(
            phaseName: 'Phase B · Championship Obedience',
            score: 94,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'High animation, straight retrieves over 1m hurdle and A-frame.',
          ),
          SportPhaseScore(
            phaseName: 'Phase C · Championship Protection',
            score: 96,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: '288/300 V (Vorzüglich / Excellent) overall championship winner.',
          ),
        ],
        requirementsMet: const [
          'Three qualifying V-rated (286+) trials under two different FCI judges',
          'Zero disqualifications during championship season',
          'DNA & microchip verification completed at check-in',
        ],
        nextStepLabel: '2026 Title Defence — National Selection Qualified',
        nextStepProgress: 1.0,
      ),
      SportAchievementItem(
        id: 'ach_4',
        name: 'BH',
        sport: 'IGP',
        category: AchievementCategory.qualification,
        dateLabel: '4 Mar 2025',
        date: DateTime(2025, 3, 4),
        dogName: 'Rex',
        venue: 'Copenhagen Hundesport Arena',
        judge: 'Søren Dalgaard (DKK)',
        registryCode: 'DKK-BHVT-2025-112',
        phases: const [
          SportPhaseScore(
            phaseName: 'Part A · Field Obedience',
            score: 56,
            maxScore: 60,
            passMinimum: 42,
            judgeNote: 'Focused off-leash heeling, solid down-stay under distraction.',
          ),
          SportPhaseScore(
            phaseName: 'Part B · Traffic & Temperament',
            score: 40,
            maxScore: 40,
            passMinimum: 40,
            judgeNote: 'Neutral and confident around cyclists, joggers, cars, and other dogs.',
          ),
        ],
        requirementsMet: const [
          'Dog minimum age requirement (15 months) verified',
          'Handler companion dog rule exam passed',
          '70%+ field obedience & unconditional traffic safety pass',
        ],
        nextStepLabel: 'Prerequisite Completed → Unlocked IGP 1 & Tracking Trials',
        nextStepProgress: 1.0,
      ),
      SportAchievementItem(
        id: 'ach_5',
        name: 'Kennel Club Foundation Certificate',
        sport: 'AGILITY',
        category: AchievementCategory.certificate,
        dateLabel: '18 Jan 2025',
        date: DateTime(2025, 1, 18),
        dogName: 'Luna',
        venue: 'North Sealand Indoor Agility Hall',
        judge: 'Camilla Krogh',
        registryCode: 'KC-FDN-2025-078',
        phases: const [
          SportPhaseScore(
            phaseName: 'Contact Zone Execution',
            score: 48,
            maxScore: 50,
            passMinimum: 35,
            judgeNote: 'Reliable 2-on-2-off stops on dogwalk and A-frame.',
          ),
          SportPhaseScore(
            phaseName: 'Weave & Tunnel Commitment',
            score: 47,
            maxScore: 50,
            passMinimum: 35,
            judgeNote: 'Independent 12-pole entries from both left and right angles.',
          ),
        ],
        requirementsMet: const [
          'Obstacle safety & jump height measurement recorded',
          'Clean 14-obstacle foundation course under standard course time',
        ],
        nextStepLabel: 'Grade 1–2 Official Agility Debut Ready',
        nextStepProgress: 0.90,
      ),
      // 3 earlier archived season records so total career tallies match 4 Qualifications, 1 Title, 3 Awards
      SportAchievementItem(
        id: 'ach_6',
        name: 'FPr 1 Tracking Qualification',
        sport: 'IGP',
        category: AchievementCategory.qualification,
        dateLabel: '19 Oct 2024',
        date: DateTime(2024, 10, 19),
        dogName: 'Rex',
        venue: 'Odense Working Field Trial',
        judge: 'Søren Dalgaard (DKK)',
        registryCode: 'DKK-FPR1-2024-503',
        phases: const [
          SportPhaseScore(
            phaseName: 'Phase A · Single Track',
            score: 93,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'Steady pace across plough soil transition; both articles indicated.',
          ),
        ],
        requirementsMet: const [
          'Minimum 70/100 tracking points earned',
          '2 leather/wood articles recovered cleanly',
        ],
        nextStepLabel: 'FPr 2 / IGP 1 Tracking Ready',
        nextStepProgress: 1.0,
        isArchived: true,
      ),
      SportAchievementItem(
        id: 'ach_7',
        name: 'AD Endurance Test (20 km)',
        sport: 'IGP',
        category: AchievementCategory.qualification,
        dateLabel: '8 Sep 2024',
        date: DateTime(2024, 9, 8),
        dogName: 'Rex',
        venue: 'Zealand Forest Ring',
        judge: 'Henrik Lindqvist (FCI)',
        registryCode: 'FCI-AD-2024-309',
        phases: const [
          SportPhaseScore(
            phaseName: '20 km Trotting & Vet Recovery',
            score: 100,
            maxScore: 100,
            passMinimum: 100,
            judgeNote: 'Sound pads, normal heart-rate recovery at 8 km, 15 km, and 20 km checks.',
          ),
        ],
        requirementsMet: const [
          '3 veterinary pad & pulse checks passed cleanly',
          'Post-run obedience alertness check passed',
        ],
        nextStepLabel: 'Breed Survey (Körung) Prerequisite Satisfied',
        nextStepProgress: 1.0,
        isArchived: true,
      ),
      SportAchievementItem(
        id: 'ach_8',
        name: 'High in Trial — Autumn Cup',
        sport: 'IGP',
        category: AchievementCategory.award,
        dateLabel: '3 Nov 2024',
        date: DateTime(2024, 11, 3),
        dogName: 'Rex',
        venue: 'Aarhus Sportdog Invitational',
        judge: 'Maja Bergström (SKK / FCI)',
        registryCode: 'ASI-HIT-2024-01',
        phases: const [
          SportPhaseScore(
            phaseName: 'Combined Obedience & Control',
            score: 96,
            maxScore: 100,
            passMinimum: 70,
            judgeNote: 'Highest aggregate score out of 24 entered working dogs.',
          ),
        ],
        requirementsMet: const [
          '1st Place overall aggregate score in Autumn Cup',
        ],
        nextStepLabel: 'Club Honour Roll Inducted',
        nextStepProgress: 1.0,
        isArchived: true,
      ),
      SportAchievementItem(
        id: 'ach_9',
        name: 'Judge’s Choice — Fastest Clean Run',
        sport: 'AGILITY',
        category: AchievementCategory.award,
        dateLabel: '14 Dec 2024',
        date: DateTime(2024, 12, 14),
        dogName: 'Luna',
        venue: 'Winter Jumpers Open — Odense',
        judge: 'Camilla Krogh',
        registryCode: 'WJO-AWD-2024-12',
        phases: const [
          SportPhaseScore(
            phaseName: 'Jumpers Course (31.4s / 0 Faults)',
            score: 100,
            maxScore: 100,
            passMinimum: 80,
            judgeNote: '5.18 m/s ground speed with zero bar knockdowns.',
          ),
        ],
        requirementsMet: const [
          'Zero course or time faults recorded',
          'Fastest winning time in Medium/Large division',
        ],
        nextStepLabel: '2025 Open Agility Series Seeded',
        nextStepProgress: 1.0,
        isArchived: true,
      ),
    ];
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilter =>
      _selectedDog != 'All Dogs' ||
      _selectedSport != 'All Sports' ||
      _selectedYear != 'All Years' ||
      _selectedCategory != null ||
      _searchQuery.trim().isNotEmpty;

  List<SportAchievementItem> get _dogAndYearFilteredPool {
    return _items.where((item) {
      if (_selectedDog != 'All Dogs' && item.dogName != _selectedDog) {
        return false;
      }
      if (_selectedSport != 'All Sports' && item.sport != _selectedSport) {
        return false;
      }
      if (_selectedYear != 'All Years' &&
          item.date.year.toString() != _selectedYear) {
        return false;
      }
      return true;
    }).toList();
  }

  int get _qualificationCount => _dogAndYearFilteredPool
      .where((e) => e.category == AchievementCategory.qualification)
      .length;

  int get _titleCount => _dogAndYearFilteredPool
      .where((e) => e.category == AchievementCategory.title)
      .length;

  int get _awardCount => _dogAndYearFilteredPool
      .where((e) => e.category == AchievementCategory.award)
      .length;

  String get _latestDateLabel {
    final pool = _dogAndYearFilteredPool;
    if (pool.isEmpty) return '—';
    final sorted = [...pool]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first.dateLabel;
  }

  List<SportAchievementItem> get _visibleItems {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _dogAndYearFilteredPool.where((item) {
      // When no filters or search are active and archived toggle is off, show the exact 5 primary items from Figma
      if (!_hasActiveFilter && !_showEarlierRecords && item.isArchived) {
        return false;
      }
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (query.isNotEmpty) {
        final hay =
            '${item.name} ${item.sport} ${item.categoryLabel} ${item.dogName} ${item.venue} ${item.judge}'
                .toLowerCase();
        if (!hay.contains(query)) return false;
      }
      return true;
    }).toList();
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  void _toggleCategoryCard(AchievementCategory category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
    _entryAnim.forward(from: 0.25);
  }

  void _resetFilters() {
    setState(() {
      _selectedDog = 'All Dogs';
      _selectedSport = 'All Sports';
      _selectedYear = 'All Years';
      _selectedCategory = null;
      _searchQuery = '';
      _searchController.clear();
    });
    _entryAnim.forward(from: 0.25);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleItems;
    final archivedHiddenCount = !_hasActiveFilter && !_showEarlierRecords
        ? _items.where((e) => e.isArchived).length
        : 0;

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: _openAddAchievementSheet,
          backgroundColor: _forest,
          elevation: 4,
          shape: const CircleBorder(),
          child: const UlvenikIcon(UlvenikIcons.add,
            color: _offWhite,
            size: 28,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            if (_searchVisible) _buildSearchBar(),
            Container(height: 1, color: _border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
                children: [
                  _buildSummaryStrip(),
                  if (_hasActiveFilter) ...[
                    const SizedBox(height: 14),
                    _buildActiveFilterBanner(),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _hasActiveFilter
                            ? 'FILTERED ACHIEVEMENTS (${visible.length})'
                            : 'ALL ACHIEVEMENTS',
                        style: const TextStyle(
                          color: _stone,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (_showEarlierRecords && !_hasActiveFilter)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showEarlierRecords = false),
                          child: const Text(
                            'Hide 2024 archive',
                            style: TextStyle(
                              color: _mint,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (visible.isEmpty)
                    _buildEmptyFilteredState()
                  else
                    ...List.generate(visible.length, (index) {
                      final item = visible[index];
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _entryAnim,
                          curve: Interval(
                            (index * 0.08).clamp(0.0, 0.7),
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildAchievementCard(item),
                        ),
                      );
                    }),
                  if (archivedHiddenCount > 0) ...[
                    const SizedBox(height: 4),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() => _showEarlierRecords = true);
                          _entryAnim.forward(from: 0.3);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _stone,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                        icon: const UlvenikIcon(UlvenikIcons.history, size: 16),
                        label: Text(
                          'Show $archivedHiddenCount earlier 2024 qualifications & awards',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _stone,
              size: 28,
            ),
            splashRadius: 22,
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'Qualifications & Awards',
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
          IconButton(
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible && _searchQuery.isNotEmpty) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
            icon: UlvenikIcon.fromMaterial(
              _searchVisible ? Icons.close_rounded : Icons.search_rounded,
              color: _searchVisible ? _mint : _stone,
              size: 23,
            ),
            tooltip: 'Search achievements',
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _openFilterSheet,
                icon: Icon(Icons.filter_list_rounded,
                  color: _hasActiveFilter ? _mint : _stone,
                  size: 23,
                ),
                tooltip: 'Filter by dog, sport, or year',
              ),
              if (_hasActiveFilter)
                Positioned(
                  right: 10,
                  top: 10,
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: 'Search title, sport, judge, or venue...',
            hintStyle: TextStyle(
              color: _stone.withValues(alpha: 0.7),
              fontSize: 13.5,
              fontFamily: 'Inter',
            ),
            prefixIcon: const UlvenikIcon(UlvenikIcons.search, color: _stone, size: 19),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const Icon(Icons.clear_rounded, color: _stone, size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildStatCard(
            value: '$_qualificationCount',
            label: 'Qualifications',
            width: 88,
            selected: _selectedCategory == AchievementCategory.qualification,
            onTap: () => _toggleCategoryCard(AchievementCategory.qualification),
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            value: '$_titleCount',
            label: 'Titles',
            width: 86,
            selected: _selectedCategory == AchievementCategory.title,
            onTap: () => _toggleCategoryCard(AchievementCategory.title),
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            value: '$_awardCount',
            label: 'Awards',
            width: 86,
            selected: _selectedCategory == AchievementCategory.award,
            onTap: () => _toggleCategoryCard(AchievementCategory.award),
          ),
          const SizedBox(width: 10),
          _buildStatCard(
            value: _latestDateLabel,
            label: 'Latest',
            width: 104,
            valueFontSize: 14,
            selected: false,
            onTap: () {
              final pool = _dogAndYearFilteredPool;
              if (pool.isNotEmpty) {
                final sorted = [...pool]
                  ..sort((a, b) => b.date.compareTo(a.date));
                _openAchievementDetailsSheet(sorted.first);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required double width,
    required bool selected,
    required VoidCallback onTap,
    double valueFontSize = 18,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _forest.withValues(alpha: 0.22) : _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _mint.withValues(alpha: 0.65) : _border,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _offWhite,
                fontSize: valueFontSize,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                height: 1.15,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? _mint : _stone,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterBanner() {
    final chips = <String>[
      if (_selectedDog != 'All Dogs') _selectedDog,
      if (_selectedSport != 'All Sports') _selectedSport,
      if (_selectedYear != 'All Years') _selectedYear,
      if (_selectedCategory != null)
        _selectedCategory!.name[0].toUpperCase() +
            _selectedCategory!.name.substring(1),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _forest.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _mint.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, color: _mint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              chips.isEmpty
                  ? 'Search: "$_searchQuery"'
                  : 'Filtered by ${chips.join(' · ')}',
              style: const TextStyle(
                color: _offWhite,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: _resetFilters,
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

  Widget _buildAchievementCard(SportAchievementItem item) {
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _openAchievementDetailsSheet(item),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _iconBox,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: UlvenikIcon.fromMaterial(
                  item.leadingIcon,
                  color: _stone,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildSportBadge(item.sport),
                        _buildCategoryBadge(item.categoryLabel),
                        Text(
                          item.dateLabel,
                          style: const TextStyle(
                            color: _stone,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const UlvenikIcon(UlvenikIcons.details,
                color: _stone,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportBadge(String sport) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _alpineBlue.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _alpineBlue.withValues(alpha: 0.28)),
      ),
      child: Text(
        sport.toUpperCase(),
        style: const TextStyle(
          color: _alpineBlue,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _stone,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _iconBox,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.emoji_events_outlined,
              color: _stone,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No matching qualifications or awards',
            style: TextStyle(
              color: _offWhite,
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try clearing active sport, dog, or year filters, or log a new qualification with the + button.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _stone,
              fontSize: 13,
              height: 1.45,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              foregroundColor: _mint,
              side: BorderSide(color: _mint.withValues(alpha: 0.45)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet() {
    String tempDog = _selectedDog;
    String tempSport = _selectedSport;
    String tempYear = _selectedYear;
    AchievementCategory? tempCat = _selectedCategory;

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
            Widget buildChipGroup<T>({
              required String title,
              required List<T> options,
              required T selected,
              required String Function(T) labelOf,
              required ValueChanged<T> onSelect,
            }) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _stone,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: options.map((opt) {
                      final active = opt == selected;
                      return GestureDetector(
                        onTap: () => setModalState(() => onSelect(opt)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
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
                            labelOf(opt),
                            style: TextStyle(
                              color: active ? _offWhite : _stone,
                              fontSize: 12.5,
                              fontWeight:
                                  active ? FontWeight.w600 : FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }

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
                          color: _stone.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Qualifications & Awards',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempDog = 'All Dogs';
                              tempSport = 'All Sports';
                              tempYear = 'All Years';
                              tempCat = null;
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: _mint, fontFamily: 'Inter'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    buildChipGroup<String>(
                      title: 'DOG WORKSPACE',
                      options: const ['All Dogs', 'Rex', 'Luna', 'Fenris'],
                      selected: tempDog,
                      labelOf: (s) => s,
                      onSelect: (s) => tempDog = s,
                    ),
                    const SizedBox(height: 18),
                    buildChipGroup<String>(
                      title: 'SPORT',
                      options: const [
                        'All Sports',
                        'IGP',
                        'AGILITY',
                        'OBEDIENCE',
                        'TRACKING',
                      ],
                      selected: tempSport,
                      labelOf: (s) => s,
                      onSelect: (s) => tempSport = s,
                    ),
                    const SizedBox(height: 18),
                    buildChipGroup<AchievementCategory?>(
                      title: 'ACHIEVEMENT TYPE',
                      options: const [
                        null,
                        AchievementCategory.qualification,
                        AchievementCategory.title,
                        AchievementCategory.award,
                        AchievementCategory.certificate,
                      ],
                      selected: tempCat,
                      labelOf: (c) {
                        if (c == null) return 'All Types';
                        switch (c) {
                          case AchievementCategory.qualification:
                            return 'Qualifications';
                          case AchievementCategory.title:
                            return 'Titles';
                          case AchievementCategory.award:
                            return 'Awards';
                          case AchievementCategory.certificate:
                            return 'Certificates';
                        }
                      },
                      onSelect: (c) => tempCat = c,
                    ),
                    const SizedBox(height: 18),
                    buildChipGroup<String>(
                      title: 'SEASON / YEAR',
                      options: const ['All Years', '2026', '2025', '2024'],
                      selected: tempYear,
                      labelOf: (s) => s,
                      onSelect: (s) => tempYear = s,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _selectedDog = tempDog;
                            _selectedSport = tempSport;
                            _selectedYear = tempYear;
                            _selectedCategory = tempCat;
                          });
                          _entryAnim.forward(from: 0.25);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
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

  void _openAchievementDetailsSheet(SportAchievementItem item) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _AchievementInspectorSheet(
        item: item,
        onShare: () {
          Navigator.of(ctx).pop();
          AppSnackbar.show(
            context,
            title: 'Summary Ready',
            message:
                '${item.name} (${item.sport}) official record copied for sharing.',
            type: SnackbarType.success,
          );
        },
      ),
    );
  }

  void _openAddAchievementSheet() {
    final nameCtrl = TextEditingController();
    final venueCtrl =
        TextEditingController(text: 'Nordic Working Dog Club — Roskilde');
    final judgeCtrl = TextEditingController(text: 'Henrik Lindqvist (FCI)');
    final scoreCtrl = TextEditingController(text: '284');

    AchievementCategory category = AchievementCategory.qualification;
    String sport = 'IGP';
    String dog = 'Rex';
    DateTime pickedDate = DateTime(2026, 10, 4);
    String? errorMsg;

    String formatDate(DateTime d) {
      const months = [
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
      return '${d.day} ${months[d.month - 1]} ${d.year}';
    }

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
            final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SafeArea(
                child: SingleChildScrollView(
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
                            color: _stone.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Log Qualification, Title or Award',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'ACHIEVEMENT TYPE',
                        style: TextStyle(
                          color: _stone,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AchievementCategory.values.map((c) {
                          final active = c == category;
                          final label = c.name[0].toUpperCase() +
                              c.name.substring(1);
                          return GestureDetector(
                            onTap: () => setModalState(() => category = c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
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
                                label,
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
                      const Text(
                        'TITLE / QUALIFICATION NAME',
                        style: TextStyle(
                          color: _stone,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameCtrl,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g. IGP 2, Clean Run Ribbon, FH 1',
                          hintStyle: TextStyle(
                            color: _stone.withValues(alpha: 0.6),
                            fontSize: 13.5,
                          ),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _mint),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          'IGP 2',
                          'FH 1 Tracking',
                          'Clean Run Award',
                          'Nordic Winner 2026',
                        ].map((preset) {
                          return ActionChip(
                            backgroundColor: _bg,
                            side: const BorderSide(color: _border),
                            label: Text(
                              preset,
                              style: const TextStyle(
                                color: _stone,
                                fontSize: 11.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                            onPressed: () {
                              setModalState(() {
                                nameCtrl.text = preset;
                                errorMsg = null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownBox(
                              label: 'SPORT',
                              value: sport,
                              items: const [
                                'IGP',
                                'AGILITY',
                                'OBEDIENCE',
                                'TRACKING',
                              ],
                              onChanged: (v) {
                                if (v != null) setModalState(() => sport = v);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdownBox(
                              label: 'DOG',
                              value: dog,
                              items: const ['Rex', 'Luna', 'Fenris'],
                              onChanged: (v) {
                                if (v != null) setModalState(() => dog = v);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final chosen = await showDatePicker(
                                  context: ctx,
                                  initialDate: pickedDate,
                                  firstDate: DateTime(2018),
                                  lastDate: DateTime(2030),
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
                                if (chosen != null) {
                                  setModalState(() => pickedDate = chosen);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _bg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _border),
                                ),
                                child: Row(
                                  children: [
                                    const UlvenikIcon(UlvenikIcons.calendar,
                                      color: _stone,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        formatDate(pickedDate),
                                        style: const TextStyle(
                                          color: _offWhite,
                                          fontSize: 13.5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: scoreCtrl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 13.5,
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Total Score (pts)',
                                labelStyle: const TextStyle(
                                  color: _stone,
                                  fontSize: 12,
                                ),
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
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: judgeCtrl,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13.5,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Judge & Registry',
                          labelStyle: const TextStyle(
                            color: _stone,
                            fontSize: 12,
                          ),
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: venueCtrl,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13.5,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Trial Club / Venue',
                          labelStyle: const TextStyle(
                            color: _stone,
                            fontSize: 12,
                          ),
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                      if (errorMsg != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorMsg!,
                          style: const TextStyle(
                            color: Color(0xFFE07A7A),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            final title = nameCtrl.text.trim();
                            if (title.isEmpty) {
                              setModalState(() {
                                errorMsg =
                                    'Please enter a qualification, title, or award name.';
                              });
                              return;
                            }
                            final parsedScore =
                                int.tryParse(scoreCtrl.text.trim()) ?? 280;
                            final perPhase =
                                (parsedScore / 3).round().clamp(70, 100);
                            final created = SportAchievementItem(
                              id: 'ach_${DateTime.now().millisecondsSinceEpoch}',
                              name: title,
                              sport: sport,
                              category: category,
                              dateLabel: formatDate(pickedDate),
                              date: pickedDate,
                              dogName: dog,
                              venue: venueCtrl.text.trim().isEmpty
                                  ? 'Official Sport Trial'
                                  : venueCtrl.text.trim(),
                              judge: judgeCtrl.text.trim().isEmpty
                                  ? 'FCI Officiating Judge'
                                  : judgeCtrl.text.trim(),
                              registryCode:
                                  'ULV-${sport.toUpperCase()}-${pickedDate.year}-${_items.length + 101}',
                              phases: [
                                SportPhaseScore(
                                  phaseName: 'Phase A · Tracking / Course',
                                  score: perPhase,
                                  maxScore: 100,
                                  passMinimum: 70,
                                  judgeNote:
                                      'Consistent pace and clean execution recorded.',
                                ),
                                SportPhaseScore(
                                  phaseName: 'Phase B · Obedience / Control',
                                  score: (perPhase - 2).clamp(70, 100),
                                  maxScore: 100,
                                  passMinimum: 70,
                                  judgeNote:
                                      'Attentive work and reliable transitions.',
                                ),
                                SportPhaseScore(
                                  phaseName: 'Phase C · Final Assessment',
                                  score: (perPhase + 2).clamp(70, 100),
                                  maxScore: 100,
                                  passMinimum: 70,
                                  judgeNote:
                                      'Official scorebook verified at trial desk.',
                                ),
                              ],
                              requirementsMet: const [
                                'All minimum phase scores achieved',
                                'Logged in official dog sport record',
                              ],
                              nextStepLabel:
                                  'Next Level Progression Unlocked',
                              nextStepProgress: 0.75,
                            );

                            Navigator.of(ctx).pop();
                            setState(() {
                              _items.insert(0, created);
                            });
                            _entryAnim.forward(from: 0.25);
                            AppSnackbar.show(
                              context,
                              title: 'Achievement Saved',
                              message:
                                  '$title added to $dog’s sport qualifications & awards.',
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
                            'Save Achievement',
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

  Widget _buildDropdownBox({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _stone,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: _card,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _stone),
              style: const TextStyle(
                color: _offWhite,
                fontSize: 13.5,
                fontFamily: 'Inter',
              ),
              items: items
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _AchievementInspectorSheet extends StatefulWidget {
  final SportAchievementItem item;
  final VoidCallback onShare;

  const _AchievementInspectorSheet({
    required this.item,
    required this.onShare,
  });

  @override
  State<_AchievementInspectorSheet> createState() =>
      _AchievementInspectorSheetState();
}

class _AchievementInspectorSheetState extends State<_AchievementInspectorSheet>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = AppColors.infoAlpineBlue;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stone = AppColors.secondaryTextStoneGrey;
  static const Color _border = AppColors.cardBorder;

  late final AnimationController _barAnim;
  late final Animation<double> _curved;
  int _selectedPhaseIndex = 0;

  @override
  void initState() {
    super.initState();
    _barAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _curved = CurvedAnimation(parent: _barAnim, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _barAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final phases = item.phases;
    final selectedPhase = phases[_selectedPhaseIndex.clamp(0, phases.length - 1)];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: _mint.withValues(alpha: 0.35)),
                  ),
                  child: UlvenikIcon.fromMaterial(item.leadingIcon, color: _mint, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.dogName} · ${item.dateLabel} · ${item.registryCode}',
                        style: const TextStyle(
                          color: _stone,
                          fontSize: 12,
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
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: [
                  _metaRow('Venue', item.venue),
                  const SizedBox(height: 8),
                  _metaRow('Officiating Judge', item.judge),
                  const SizedBox(height: 8),
                  _metaRow('Sport & Type',
                      '${item.sport} · ${item.categoryLabel}'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PHASE BREAKDOWN (TAP BAR TO INSPECT)',
                  style: TextStyle(
                    color: _stone,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Pass min shown',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _curved,
              builder: (context, _) {
                return Column(
                  children: List.generate(phases.length, (i) {
                    final p = phases[i];
                    final isSelected = i == _selectedPhaseIndex;
                    final ratio =
                        (p.score / p.maxScore).clamp(0.0, 1.0) * _curved.value;
                    final minRatio =
                        (p.passMinimum / p.maxScore).clamp(0.0, 1.0);
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPhaseIndex = i),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _forest.withValues(alpha: 0.16)
                              : _bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? _mint.withValues(alpha: 0.55)
                                : _border,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  p.phaseName,
                                  style: TextStyle(
                                    color: isSelected ? _offWhite : _stone,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Text(
                                  '${(p.score * _curved.value).round()} / ${p.maxScore} pts',
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LayoutBuilder(
                              builder: (ctx, constraints) {
                                final fullW = constraints.maxWidth;
                                return Stack(
                                  children: [
                                    Container(
                                      height: 8,
                                      width: fullW,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Container(
                                      height: 8,
                                      width: fullW * ratio,
                                      decoration: BoxDecoration(
                                        color: isSelected ? _mint : _alpineBlue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Positioned(
                                      left: (fullW * minRatio - 1)
                                          .clamp(0.0, fullW - 2),
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 2,
                                        color: _offWhite.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.rate_review_outlined,
                    color: _alpineBlue,
                    size: 17,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      '${selectedPhase.phaseName} (min ${selectedPhase.passMinimum} pts): ${selectedPhase.judgeNote}',
                      style: const TextStyle(
                        color: _stone,
                        fontSize: 12.5,
                        height: 1.4,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'VERIFIED REQUIREMENTS & PROGRESSION',
              style: TextStyle(
                color: _stone,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            ...item.requirementsMet.map(
              (req) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const UlvenikIcon(UlvenikIcons.completed,
                      color: _mint,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        req,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 12.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.nextStepLabel,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Text(
                        '${(item.nextStepProgress * 100).round()}%',
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _curved,
                    builder: (context, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.nextStepProgress * _curved.value,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: const AlwaysStoppedAnimation<Color>(_forest),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: widget.onShare,
                icon: const Icon(Icons.ios_share_rounded, size: 18),
                label: const Text(
                  'Share Official Qualification Summary',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _stone,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
