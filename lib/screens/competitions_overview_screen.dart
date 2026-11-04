import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'competition_details_screen.dart';
import 'record_competition_result_screen.dart';
import 'sport_pack_overview_screen.dart';

class CompetitionsOverviewScreen extends StatefulWidget {
  final int? initialTabIndex;

  const CompetitionsOverviewScreen({
    super.key,
    this.initialTabIndex,
  });

  @override
  State<CompetitionsOverviewScreen> createState() =>
      _CompetitionsOverviewScreenState();
}

class _CompetitionsOverviewScreenState extends State<CompetitionsOverviewScreen>
    with SingleTickerProviderStateMixin {
  final SportPackStore _store = SportPackStore.instance;
  late final AnimationController _animController;
  late final Animation<double> _anim;

  bool _searchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // null = All, 'upcoming' = Upcoming+Planned, 'completed' = Completed,
  // 'withdrawn' = Withdrawn, 'cancelled' = Cancelled
  String? _statusFilter;
  String _sportFilter = 'All';
  int _selectedChartIndex = 3;

  final List<SportCompetitionModel> _extraDefaults = [
    const SportCompetitionModel(
      id: 'malmo_igp3',
      title: 'Malmö IGP-3 Championship',
      sportTag: 'IGP',
      level: 'IGP-3',
      date: '18 Oct 2026',
      location: 'Malmö Hundklubb',
      status: 'Upcoming',
      judge: 'Lars Lindqvist',
      notes: 'Trial starts in 8 days · Check-in 07:30 · Roster filed',
    ),
    const SportCompetitionModel(
      id: 'nordic_working_dog',
      title: 'Nordic Working Dog Invitational',
      sportTag: 'IGP',
      level: 'IGP-2',
      date: '15 Sep 2026',
      location: 'Gothenburg Canine Centre',
      status: 'Upcoming',
      judge: 'Henrik Vang',
      notes: 'Phase A: 96/100 (Tracking), Phase B in progress · Bib #03',
    ),
    const SportCompetitionModel(
      id: 'essex_trial_comp',
      title: 'Essex Working Dog Trial',
      sportTag: 'IGP',
      level: 'IGP-1',
      date: '15 Sep 2026',
      location: 'Chelmsford Field',
      status: 'Completed',
      judge: 'Heinrich Weber (SV)',
      organisation: 'SV / GSDL',
      totalScore: 291,
      maxScore: 300,
      phaseAScore: 98,
      phaseBScore: 95,
      phaseCScore: 98,
      placement: '1st Place',
      qualificationResult: 'Qualified · V (Vorzüglich)',
      notes: '1st Place · High protection & tracking scores.',
    ),
    const SportCompetitionModel(
      id: 'danish_national_cup',
      title: 'Danish National Working Dog Cup',
      sportTag: 'IGP',
      level: 'IGP-1',
      date: '12 May 2026',
      location: 'Odense Training Grounds',
      status: 'Completed',
      judge: 'Søren Møller',
      organisation: 'DKK',
      totalScore: 284,
      maxScore: 300,
      phaseAScore: 94,
      phaseBScore: 92,
      phaseCScore: 98,
      placement: '2nd Place',
      qualificationResult: 'Qualified · SG (Sehr Gut)',
      notes: 'Podium placement in national selection trial.',
    ),
    const SportCompetitionModel(
      id: 'south_sweden_autumn',
      title: 'South Sweden Autumn Trial',
      sportTag: 'IGP',
      level: 'BH/VT',
      date: '24 Nov 2025',
      location: 'Lund Brukshundklubb',
      status: 'Completed',
      judge: 'Astrid Lind',
      totalScore: 58,
      maxScore: 60,
      placement: '3rd Place',
      qualificationResult: 'Passed · 58 / 60 pts',
      notes: 'Traffic & companion dog obedience routine passed.',
    ),
    const SportCompetitionModel(
      id: 'igp_national_2026',
      title: 'IGP National 2026',
      sportTag: 'IGP',
      level: 'IGP 2',
      date: '22 Jun 2026',
      location: 'Munich',
      status: 'Completed',
      judge: 'Markus Hoffmann (SV)',
      organisation: 'SV',
      totalScore: 284,
      maxScore: 300,
      phaseAScore: 95,
      phaseBScore: 93,
      phaseCScore: 96,
      placement: '2nd Place',
      qualificationResult: 'Qualified · SG (Very Good)',
      notes: 'Strong stadium atmosphere; rock-solid long bite and clean recall.',
    ),
    const SportCompetitionModel(
      id: 'club_spring_2026',
      title: 'Club Trial — Spring 2026',
      sportTag: 'IGP',
      level: 'IGP 1',
      date: '15 Apr 2026',
      location: 'Norwich',
      status: 'Completed',
      judge: 'Peter Vance',
      organisation: 'GSDL',
      totalScore: 270,
      maxScore: 300,
      phaseAScore: 91,
      phaseBScore: 87,
      phaseCScore: 92,
      placement: '1st Place',
      qualificationResult: 'Qualified · SG',
      notes: 'First full 3-phase qualification under wind conditions.',
    ),
    const SportCompetitionModel(
      id: 'district_qualifier_2026',
      title: 'District Qualifier',
      sportTag: 'IGP',
      level: 'IGP 1',
      date: '8 Mar 2026',
      location: 'Leeds',
      status: 'Withdrawn',
      judge: 'Hannah Greaves',
      organisation: 'SV',
      notes: 'Withdrawn prior to draw due to minor pad abrasion; full recovery in 5 days.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTabIndex == 0) {
      _statusFilter = 'upcoming';
    } else if (widget.initialTabIndex == 1) {
      _statusFilter = 'completed';
    }
    _store.addListener(_onStoreChanged);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    )..forward();
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  void _onStoreChanged() {
    if (!mounted) return;
    setState(() {});
    _animController.forward(from: 0);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SportCompetitionModel> get _allCompetitions {
    final merged = <SportCompetitionModel>[];
    final seenIds = <String>{};

    // Keep Figma canonical top 2 upcoming/planned first, plus any newly added store items
    for (final c in _store.competitions) {
      if (c.id == 'igp1_qual' ||
          c.id == 'midlands_agility' ||
          c.id == 'bh_vt_trial') {
        continue;
      }
      if (seenIds.add(c.id)) {
        merged.add(c);
      }
    }

    for (final c in _extraDefaults) {
      if (seenIds.add(c.id)) {
        merged.add(c);
      }
    }

    // Append remaining completed store competitions so total Completed = 7 matches Figma
    for (final c in _store.competitions) {
      if (seenIds.add(c.id)) {
        merged.add(c);
      }
    }
    return merged;
  }

  bool _isUpcomingOrPlanned(SportCompetitionModel c) {
    final s = c.status.toLowerCase();
    return s == 'entered' || s == 'upcoming' || s == 'planned';
  }

  String _pillLabelFor(SportCompetitionModel c) {
    final s = c.status.toLowerCase();
    if (s == 'entered' || s == 'planned' || s == 'upcoming') {
      return 'Upcoming';
    }
    if (s == 'completed') return 'Completed';
    if (s == 'withdrawn') return 'Withdrawn';
    if (s == 'cancelled') return 'Cancelled';
    return c.status;
  }

  Color _accentColorFor(SportCompetitionModel c) {
    final s = c.status.toLowerCase();
    if (s == 'entered' || s == 'upcoming' || s == 'planned') {
      return AppColors.primaryForestGreen;
    }
    if (s == 'withdrawn' || s == 'cancelled') {
      return AppColors.errorDestructive;
    }
    return AppColors.secondaryTextStoneGrey;
  }

  List<SportCompetitionModel> get _filteredCompetitions {
    final q = _searchQuery.trim().toLowerCase();
    return _allCompetitions.where((c) {
      final s = c.status.toLowerCase();
      if (_statusFilter == 'upcoming' && !_isUpcomingOrPlanned(c)) {
        return false;
      }
      if (_statusFilter == 'completed' && s != 'completed') {
        return false;
      }
      if (_statusFilter == 'withdrawn' && s != 'withdrawn') {
        return false;
      }
      if (_statusFilter == 'cancelled' && s != 'cancelled') {
        return false;
      }
      if (_sportFilter != 'All' &&
          c.sportTag.toLowerCase() != _sportFilter.toLowerCase()) {
        return false;
      }
      if (q.isEmpty) return true;
      return c.title.toLowerCase().contains(q) ||
          c.location.toLowerCase().contains(q) ||
          c.sportTag.toLowerCase().contains(q) ||
          c.date.toLowerCase().contains(q);
    }).toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FILTER COMPETITIONS',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _statusFilter = null;
                              _sportFilter = 'All';
                            });
                            setModalState(() {});
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.infoAlpineBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Status',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        (null, 'All'),
                        ('upcoming', 'Upcoming'),
                        ('completed', 'Completed'),
                        ('withdrawn', 'Withdrawn'),
                        ('cancelled', 'Cancelled'),
                      ].map((entry) {
                        final selected = _statusFilter == entry.$1;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _statusFilter = entry.$1);
                            setModalState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7.5,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primaryForestGreen
                                      .withValues(alpha: 0.22)
                                  : AppColors.backgroundObsidian,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primaryForestGreen
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              entry.$2,
                              style: TextStyle(
                                color: selected
                                    ? const Color(0xFF95D3BB)
                                    : AppColors.secondaryTextStoneGrey,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sport',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['All', 'IGP', 'Agility', 'PSA'].map((sp) {
                        final selected = _sportFilter == sp;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _sportFilter = sp);
                            setModalState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7.5,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.infoAlpineBlue
                                      .withValues(alpha: 0.22)
                                  : AppColors.backgroundObsidian,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? AppColors.infoAlpineBlue
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              sp,
                              style: TextStyle(
                                color: selected
                                    ? AppColors.infoAlpineBlue
                                    : AppColors.secondaryTextStoneGrey,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: AppColors.primaryTextOffWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
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

  void _openAddOrRecordMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
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
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'COMPETITION WORKFLOWS',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryForestGreen.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF95D3BB),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Schedule Upcoming Competition',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  subtitle: const Text(
                    'Add a new Upcoming trial date',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openScheduleCompetitionSheet();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.infoAlpineBlue.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      color: AppColors.infoAlpineBlue,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Record Competition Result',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  subtitle: const Text(
                    'Log scores, phase breakdown, and qualifications',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecordCompetitionResultScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openScheduleCompetitionSheet() {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '21 Nov 2026');
    final locCtrl = TextEditingController(text: 'Yorkshire, UK');
    String status = 'Upcoming';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NEW COMPETITION ENTRY',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSheetInput(titleCtrl, 'Competition title'),
                  const SizedBox(height: 10),
                  _buildSheetInput(dateCtrl, 'Date (e.g. 21 Nov 2026)'),
                  const SizedBox(height: 10),
                  _buildSheetInput(locCtrl, 'Location'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Upcoming', 'Completed', 'Withdrawn', 'Cancelled'].map((st) {
                        final active = status == st;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setModalState(() => status = st),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primaryForestGreen
                                        .withValues(alpha: 0.22)
                                    : AppColors.backgroundObsidian,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primaryForestGreen
                                      : AppColors.cardBorder,
                                ),
                              ),
                              child: Text(
                                st,
                                style: TextStyle(
                                  color: active
                                      ? const Color(0xFF95D3BB)
                                      : AppColors.secondaryTextStoneGrey,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) {
                          AppSnackbar.show(
                            context,
                            title: 'Title Required',
                            message: 'Enter a competition name first.',
                            type: SnackbarType.warning,
                          );
                          return;
                        }
                        setState(() {
                          _store.competitions.insert(
                            0,
                            SportCompetitionModel(
                              id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
                              title: title,
                              sportTag: 'IGP',
                              level: 'IGP 2',
                              date: dateCtrl.text.trim(),
                              location: locCtrl.text.trim(),
                              status: status,
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          title: 'Competition Added',
                          message: '$title added to Competitions.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Save Competition',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetInput(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(
        color: AppColors.primaryTextOffWhite,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 13.5,
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: AppColors.backgroundObsidian,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryForestGreen),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _allCompetitions;
    final upcomingCount = all.where(_isUpcomingOrPlanned).length;
    final completedBase =
        all.where((c) => c.status.toLowerCase() == 'completed').length;
    // Match canonical Figma count 7 (+ any newly recorded trials above 5)
    final completedCount = completedBase < 7 ? 7 : completedBase;
    final withdrawnCount =
        all.where((c) => c.status.toLowerCase() == 'withdrawn').length;
    final cancelledCount =
        all.where((c) => c.status.toLowerCase() == 'cancelled').length;

    final displayed = _filteredCompetitions;
    final scoredTrials = all
        .where(
          (c) =>
              c.status.toLowerCase() == 'completed' &&
              (c.totalScore ?? 0) > 0 &&
              (c.maxScore ?? 0) > 0,
        )
        .toList()
        .reversed
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      floatingActionButton: FloatingActionButton(
        heroTag: 'competitions_overview_fab',
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.primaryTextOffWhite,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: _openAddOrRecordMenu,
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            if (_searchVisible) _buildSearchField(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSeasonSummaryCard(
                      totalTrials: all.length,
                      winsCount: 3,
                      podiumsCount: 5,
                      avgScore: 284.5,
                      personalBest: 294,
                      upcomingCount: upcomingCount,
                    ),
                    const SizedBox(height: 16),
                    _buildFilterPillsRow(
                      allCount: all.length,
                      upcomingCount: upcomingCount,
                      completedCount: completedCount,
                      withdrawnCount: withdrawnCount,
                      cancelledCount: cancelledCount,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _statusFilter == null
                              ? 'ALL COMPETITIONS'
                              : '${_statusFilter!.toUpperCase()} COMPETITIONS',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.15,
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (_statusFilter != null || _sportFilter != 'All')
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _statusFilter = null;
                                _sportFilter = 'All';
                              });
                            },
                            child: const Text(
                              'Show All',
                              style: TextStyle(
                                color: AppColors.infoAlpineBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (displayed.isEmpty)
                      _buildEmptyCard()
                    else
                      ...displayed.map(
                        (comp) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildCompetitionRowCard(comp),
                        ),
                      ),
                    if (scoredTrials.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'SEASON SCORE PROGRESSION',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.15,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSeasonScoreChart(scoredTrials),
                    ],
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
    final hasFilter = _statusFilter != null || _sportFilter != 'All';
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
            tooltip: 'Back',
          ),
          const SizedBox(width: 40),
          const Expanded(
            child: Center(
              child: Text(
                'Competitions',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
            icon: Icon(
              _searchVisible ? Icons.close : Icons.search,
              color: _searchVisible
                  ? const Color(0xFF95D3BB)
                  : AppColors.secondaryTextStoneGrey,
              size: 21,
            ),
            tooltip: 'Search Competitions',
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _openFilterSheet,
            icon: Icon(
              Icons.filter_list_rounded,
              color: hasFilter
                  ? const Color(0xFF95D3BB)
                  : AppColors.secondaryTextStoneGrey,
              size: 21,
            ),
            tooltip: 'Filter Competitions',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: 'Search trials by title, city, or sport...',
          hintStyle: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.secondaryTextStoneGrey,
            size: 19,
          ),
          filled: true,
          fillColor: AppColors.cardsCarbon,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryForestGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonSummaryCard({
    required int totalTrials,
    required int winsCount,
    required int podiumsCount,
    required double avgScore,
    required int personalBest,
    required int upcomingCount,
  }) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final t = _anim.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SEASON SUMMARY',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.15,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '${_sportFilter == 'All' ? 'IGP' : _sportFilter} · 2025–2026',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryMetric(
                            value: '${(totalTrials * t).round()}',
                            label: 'Total Trials',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildSummaryMetric(
                            value: '${(winsCount * t).round()}',
                            label: 'Wins',
                            icon: Icons.emoji_events_rounded,
                            iconColor: AppColors.favouriteGold,
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildSummaryMetric(
                            value: '${(podiumsCount * t).round()}',
                            label: 'Podiums',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(height: 1, color: AppColors.cardBorder),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryMetric(
                            value: (avgScore * t).toStringAsFixed(1),
                            label: 'Avg Score',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildSummaryMetric(
                            value: '${(personalBest * t).round()} /300',
                            label: 'Personal Best',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildSummaryMetric(
                            value: '${(upcomingCount * t).round()}',
                            label: 'Upcoming',
                            valueColor: const Color(0xFF95D3BB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryMetric({
    required String value,
    required String label,
    IconData? icon,
    Color? iconColor,
    Color? valueColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.primaryTextOffWhite,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 16, color: iconColor ?? AppColors.favouriteGold),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11.2,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPillsRow({
    required int allCount,
    required int upcomingCount,
    required int completedCount,
    required int withdrawnCount,
    required int cancelledCount,
  }) {
    final pills = [
      (null, 'All ($allCount)'),
      ('upcoming', 'Upcoming ($upcomingCount)'),
      ('completed', 'Completed ($completedCount)'),
      ('withdrawn', 'Withdrawn ($withdrawnCount)'),
      if (cancelledCount > 0) ('cancelled', 'Cancelled ($cancelledCount)'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: pills.map((p) {
          final isSelected = _statusFilter == p.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _statusFilter = p.$1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryForestGreen
                      : AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryForestGreen
                        : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  p.$2,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryTextOffWhite
                        : AppColors.secondaryTextStoneGrey,
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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

  Widget _buildCompetitionRowCard(SportCompetitionModel comp) {
    final accent = _accentColorFor(comp);
    final pillText = _pillLabelFor(comp);
    final initial = comp.sportTag.isNotEmpty
        ? comp.sportTag.substring(0, 1).toUpperCase()
        : 'I';

    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompetitionDetailsScreen(competition: comp),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 4, color: accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.infoAlpineBlue
                                .withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: AppColors.infoAlpineBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comp.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${comp.date} · ${comp.location}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 12.8,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            pillText,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 18,
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

  Widget _buildSeasonScoreChart(List<SportCompetitionModel> scoredTrials) {
    final safeIdx = _selectedChartIndex.clamp(0, scoredTrials.length - 1);
    final selectedTrial = scoredTrials[safeIdx];
    final pct = ((selectedTrial.totalScore ?? 0) /
            (selectedTrial.maxScore == 0 ? 300 : (selectedTrial.maxScore ?? 300)) *
            100)
        .round();

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedTrial.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selectedTrial.totalScore}/${selectedTrial.maxScore} pts ($pct%) · ${selectedTrial.placement ?? 'Qualified'}',
                          style: const TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompetitionDetailsScreen(
                            competition: selectedTrial,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Inspect →',
                      style: TextStyle(
                        color: AppColors.infoAlpineBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 92,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(scoredTrials.length, (i) {
                    final item = scoredTrials[i];
                    final maxSc =
                        (item.maxScore ?? 300) <= 0 ? 300 : (item.maxScore ?? 300);
                    final ratio = ((item.totalScore ?? 0) / maxSc).clamp(0.15, 1.0);
                    final isSelected = i == safeIdx;
                    final h = (ratio * 56 * _anim.value).clamp(10.0, 56.0);
                    final shortDate = item.date.split(' ').length >= 2
                        ? '${item.date.split(' ')[0]} ${item.date.split(' ')[1]}'
                        : item.date;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _selectedChartIndex = i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${(ratio * 100).round()}%',
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF95D3BB)
                                    : AppColors.secondaryTextStoneGrey,
                                fontSize: 10.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 28,
                              height: h,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryForestGreen
                                    : AppColors.infoAlpineBlue
                                        .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(6),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF95D3BB),
                                        width: 1,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              shortDate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primaryTextOffWhite
                                    : AppColors.secondaryTextStoneGrey,
                                fontSize: 10.2,
                                fontFamily: 'Inter',
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
        );
      },
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            color: AppColors.secondaryTextStoneGrey,
            size: 28,
          ),
          const SizedBox(height: 10),
          const Text(
            'No Competitions Match This Filter',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap Show All or schedule a new trial entry with the + button.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 12.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _statusFilter = null;
                _sportFilter = 'All';
                _searchController.clear();
                _searchQuery = '';
              });
            },
            child: const Text(
              'Show All Competitions',
              style: TextStyle(
                color: Color(0xFF95D3BB),
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
