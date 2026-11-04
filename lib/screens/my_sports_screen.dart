import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'competitions_overview_screen.dart';
import 'create_sport_screen.dart';
import 'sport_details_igp_screen.dart';
import 'sport_pack_overview_screen.dart';
import 'subscription_details_screen.dart';

class MySportsScreen extends StatefulWidget {
  final int initialFilterIndex;
  final bool hasSportPack;

  const MySportsScreen({
    super.key,
    this.initialFilterIndex = 0,
    this.hasSportPack = true,
  });

  @override
  State<MySportsScreen> createState() => _MySportsScreenState();
}

class _MySportsScreenState extends State<MySportsScreen>
    with SingleTickerProviderStateMixin {
  final SportPackStore _store = SportPackStore.instance;
  late final AnimationController _animController;
  late final Animation<double> _progressAnim;

  bool _searchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 0 = All, 1 = Active, 2 = Archived
  late int _statusFilter;
  // 'sessions', 'skills', 'competitions', 'name'
  String _sortBy = 'sessions';
  String? _selectedBarSportId;

  static const Map<String, int> _defaultExercisesBySportId = {
    'igp': 54,
    'agility': 28,
    'psa': 22,
  };

  static const Map<String, String> _figmaDisplayLevels = {
    'igp': 'Level: IGP 2',
    'agility': 'Level: Foundation',
    'psa': 'Level: No level',
  };

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.initialFilterIndex.clamp(0, 2);
    _store.addListener(_onStoreChanged);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
    _progressAnim = CurvedAnimation(
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

  int _exercisesFor(SportEntryModel sport) {
    return _defaultExercisesBySportId[sport.id] ?? (sport.skillsCount * 3);
  }

  String _levelLineFor(SportEntryModel sport) {
    if (_figmaDisplayLevels.containsKey(sport.id)) {
      return _figmaDisplayLevels[sport.id]!;
    }
    if (sport.currentLevel.trim().isEmpty ||
        sport.currentLevel.toLowerCase() == 'none') {
      return 'Level: No level';
    }
    return 'Level: ${sport.currentLevel}';
  }

  List<SportEntryModel> get _filteredSports {
    final q = _searchQuery.trim().toLowerCase();
    final list = _store.sports.where((sport) {
      if (_statusFilter == 1 && sport.isArchived) return false;
      if (_statusFilter == 2 && !sport.isArchived) return false;
      if (_selectedBarSportId != null && sport.id != _selectedBarSportId) {
        return false;
      }
      if (q.isEmpty) return true;
      return sport.name.toLowerCase().contains(q) ||
          sport.tag.toLowerCase().contains(q) ||
          sport.organisation.toLowerCase().contains(q) ||
          sport.currentLevel.toLowerCase().contains(q);
    }).toList();

    switch (_sortBy) {
      case 'skills':
        list.sort((a, b) => b.skillsCount.compareTo(a.skillsCount));
        break;
      case 'competitions':
        list.sort((a, b) => b.competitionsCount.compareTo(a.competitionsCount));
        break;
      case 'name':
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'sessions':
      default:
        list.sort((a, b) => b.sessionsCount.compareTo(a.sessionsCount));
        break;
    }
    return list;
  }

  Color _segmentColorForIndex(int index) {
    const palette = [
      AppColors.primaryForestGreen,
      AppColors.infoAlpineBlue,
      AppColors.secondarySage,
      AppColors.bronzeAccent,
      Color(0xFF95D3BB),
    ];
    return palette[index % palette.length];
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
                          'FILTER & SORT SPORTS',
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
                              _statusFilter = 0;
                              _sortBy = 'sessions';
                              _selectedBarSportId = null;
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
                        _buildSheetChoiceChip(
                          label: 'All (${_store.sports.length})',
                          selected: _statusFilter == 0,
                          onTap: () {
                            setState(() => _statusFilter = 0);
                            setModalState(() {});
                          },
                        ),
                        _buildSheetChoiceChip(
                          label:
                              'Active (${_store.sports.where((s) => !s.isArchived).length})',
                          selected: _statusFilter == 1,
                          onTap: () {
                            setState(() => _statusFilter = 1);
                            setModalState(() {});
                          },
                        ),
                        _buildSheetChoiceChip(
                          label:
                              'Archived (${_store.sports.where((s) => s.isArchived).length})',
                          selected: _statusFilter == 2,
                          onTap: () {
                            setState(() => _statusFilter = 2);
                            setModalState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Sort Order',
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
                        _buildSheetChoiceChip(
                          label: 'Most Sessions',
                          selected: _sortBy == 'sessions',
                          onTap: () {
                            setState(() => _sortBy = 'sessions');
                            setModalState(() {});
                          },
                        ),
                        _buildSheetChoiceChip(
                          label: 'Most Skills',
                          selected: _sortBy == 'skills',
                          onTap: () {
                            setState(() => _sortBy = 'skills');
                            setModalState(() {});
                          },
                        ),
                        _buildSheetChoiceChip(
                          label: 'Most Competitions',
                          selected: _sortBy == 'competitions',
                          onTap: () {
                            setState(() => _sortBy = 'competitions');
                            setModalState(() {});
                          },
                        ),
                        _buildSheetChoiceChip(
                          label: 'Name (A–Z)',
                          selected: _sortBy == 'name',
                          onTap: () {
                            setState(() => _sortBy = 'name');
                            setModalState(() {});
                          },
                        ),
                      ],
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
                          'Apply View',
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
      },
    );
  }

  Widget _buildSheetChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryForestGreen.withValues(alpha: 0.22)
              : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected ? AppColors.primaryForestGreen : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? const Color(0xFF95D3BB)
                : AppColors.secondaryTextStoneGrey,
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  void _openSportActionsSheet(SportEntryModel sport) {
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
                Text(
                  '${sport.name.toUpperCase()} OPTIONS',
                  style: const TextStyle(
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
                  leading: const Icon(
                    Icons.open_in_new_rounded,
                    color: Color(0xFF95D3BB),
                  ),
                  title: const Text(
                    'Open Sport Details',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SportDetailsIgpScreen(sport: sport),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    sport.isArchived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                    color: AppColors.infoAlpineBlue,
                  ),
                  title: Text(
                    sport.isArchived ? 'Restore to Active Sports' : 'Archive Sport',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    final archiving = !sport.isArchived;
                    _store.toggleArchiveSport(sport.id);
                    AppSnackbar.show(
                      context,
                      title: archiving ? 'Sport Archived' : 'Sport Restored',
                      message: archiving
                          ? '${sport.name} moved to Archived Sports.'
                          : '${sport.name} restored to Active Sports.',
                      type: SnackbarType.info,
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

  @override
  Widget build(BuildContext context) {
    if (!widget.hasSportPack) {
      return Scaffold(
        backgroundColor: AppColors.backgroundObsidian,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryForestGreen.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.emoji_events_outlined,
                            size: 32,
                            color: AppColors.primaryForestGreen,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Sport Pack Required',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'This area is available exclusively to Sport Pack subscribers. Manage competition entries, trials, sport skills, qualifications, and performance metrics.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 14,
                            height: 1.45,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionDetailsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryForestGreen,
                            foregroundColor: AppColors.primaryTextOffWhite,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Upgrade to Sport Pack',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final allSports = _store.sports;
    final totalSports = allSports.length;
    final activeSports = allSports.where((s) => !s.isArchived).length;
    final archivedSports = allSports.where((s) => s.isArchived).length;
    final totalSkills =
        allSports.fold<int>(0, (sum, item) => sum + item.skillsCount);
    final totalSessions =
        allSports.fold<int>(0, (sum, item) => sum + item.sessionsCount);
    final totalCompetitions =
        allSports.fold<int>(0, (sum, item) => sum + item.competitionsCount);

    final displayedSports = _filteredSports;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      floatingActionButton: FloatingActionButton(
        heroTag: 'my_sports_fab',
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.primaryTextOffWhite,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateSportScreen(),
            ),
          );
        },
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
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('SPORT SUMMARY'),
                    const SizedBox(height: 10),
                    _buildSportSummaryCard(
                      allSports: allSports,
                      totalSports: totalSports,
                      activeSports: activeSports,
                      archivedSports: archivedSports,
                      totalSkills: totalSkills,
                      totalSessions: totalSessions,
                      totalCompetitions: totalCompetitions,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('Sport'),
                        if (_statusFilter != 0 || _selectedBarSportId != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _statusFilter = 0;
                                _selectedBarSportId = null;
                              });
                            },
                            child: Text(
                              _selectedBarSportId != null
                                  ? 'Clear selection'
                                  : (_statusFilter == 1
                                      ? 'Showing Active · Show All'
                                      : 'Showing Archived · Show All'),
                              style: const TextStyle(
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
                    if (displayedSports.isEmpty)
                      _buildEmptyState()
                    else
                      ...displayedSports.map(
                        (sport) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildSportCard(sport),
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
  }

  Widget _buildTopBar() {
    final hasActiveFilter = _statusFilter != 0 || _sortBy != 'sessions';
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 6),
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
              Icons.chevron_left_rounded,
              color: AppColors.secondaryTextStoneGrey,
              size: 26,
            ),
            tooltip: 'Back',
          ),
          const SizedBox(width: 76),
          const Expanded(
            child: Center(
              child: Text(
                'Sport',
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
            tooltip: 'Search Sports',
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _openFilterSheet,
            icon: Icon(
              Icons.filter_list_rounded,
              color: hasActiveFilter
                  ? const Color(0xFF95D3BB)
                  : AppColors.secondaryTextStoneGrey,
              size: 21,
            ),
            tooltip: 'Filter & Sort',
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateSportScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.secondaryTextStoneGrey,
              size: 23,
            ),
            tooltip: 'Add Sport',
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
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: 'Search by sport, organisation, or level...',
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

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.15,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildSportSummaryCard({
    required List<SportEntryModel> allSports,
    required int totalSports,
    required int activeSports,
    required int archivedSports,
    required int totalSkills,
    required int totalSessions,
    required int totalCompetitions,
  }) {
    return AnimatedBuilder(
      animation: _progressAnim,
      builder: (context, _) {
        int animInt(int target) => (target * _progressAnim.value).round();
        SportEntryModel? selectedSport;
        if (_selectedBarSportId != null) {
          for (final item in allSports) {
            if (item.id == _selectedBarSportId) {
              selectedSport = item;
              break;
            }
          }
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSummaryMetricCell(
                        value: '${animInt(totalSports)}',
                        label: 'Total Sports',
                        highlighted: _statusFilter == 0 &&
                            _selectedBarSportId == null,
                        onTap: () => setState(() {
                          _statusFilter = 0;
                          _selectedBarSportId = null;
                        }),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryMetricCell(
                        value: '${animInt(activeSports)}',
                        label: 'Active Sports',
                        highlighted: _statusFilter == 1,
                        onTap: () => setState(() {
                          _statusFilter = _statusFilter == 1 ? 0 : 1;
                        }),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryMetricCell(
                        value: '${animInt(archivedSports)}',
                        label: 'Archived Sports',
                        highlighted: _statusFilter == 2,
                        onTap: () => setState(() {
                          _statusFilter = _statusFilter == 2 ? 0 : 2;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: AppColors.cardBorder),
              const SizedBox(height: 14),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSummaryMetricCell(
                        value: '${animInt(totalSkills)}',
                        label: 'Skills',
                        highlighted: _sortBy == 'skills',
                        onTap: () => setState(() => _sortBy = 'skills'),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryMetricCell(
                        value: '${animInt(totalSessions)}',
                        label: 'Total Sessions',
                        highlighted: _sortBy == 'sessions',
                        onTap: () => setState(() => _sortBy = 'sessions'),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryMetricCell(
                        value: '${animInt(totalCompetitions)}',
                        label: 'Total\nCompetitions',
                        highlighted: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CompetitionsOverviewScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (allSports.isNotEmpty && totalSessions > 0) ...[
                const SizedBox(height: 14),
                Container(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedSport != null
                          ? '${selectedSport.name}: ${selectedSport.sessionsCount} sessions (${((selectedSport.sessionsCount / totalSessions) * 100).round()}%)'
                          : 'Session Share · Tap bar segment to focus',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (selectedSport != null)
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedBarSportId = null),
                        child: const Text(
                          'All',
                          style: TextStyle(
                            color: AppColors.infoAlpineBlue,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: List.generate(allSports.length, (i) {
                        final item = allSports[i];
                        final rawShare = item.sessionsCount <= 0
                            ? 1
                            : item.sessionsCount;
                        final isSelected = _selectedBarSportId == null ||
                            _selectedBarSportId == item.id;
                        return Expanded(
                          flex: (rawShare * _progressAnim.value * 100)
                              .round()
                              .clamp(1, 100000),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBarSportId =
                                    _selectedBarSportId == item.id
                                        ? null
                                        : item.id;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: i < allSports.length - 1 ? 3 : 0,
                              ),
                              color: _segmentColorForIndex(i).withValues(
                                alpha: isSelected ? 1.0 : 0.28,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryMetricCell({
    required String value,
    required String label,
    required bool highlighted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: highlighted
                    ? const Color(0xFF95D3BB)
                    : AppColors.primaryTextOffWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
                height: 1.3,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportCard(SportEntryModel sport) {
    final initial = sport.name.isNotEmpty
        ? sport.name.substring(0, 1).toUpperCase()
        : 'S';
    final exercisesCount = _exercisesFor(sport);
    final levelText = _levelLineFor(sport);

    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SportDetailsIgpScreen(sport: sport),
            ),
          );
        },
        onLongPress: () => _openSportActionsSheet(sport),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14181B),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            sport.name,
                            style: const TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 18.5,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        if (sport.isArchived) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ARCHIVED',
                              style: TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openSportActionsSheet(sport),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.infoAlpineBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sport.tag.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.infoAlpineBlue,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                sport.organisation,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                levelText,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: AppColors.cardBorder),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: _progressAnim,
                builder: (context, _) {
                  int animCount(int v) => (v * _progressAnim.value).round();
                  return IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildCardMiniStat(
                            value: '${animCount(sport.skillsCount)}',
                            label: 'Skills',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildCardMiniStat(
                            value: '${animCount(exercisesCount)}',
                            label: 'Exercises',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildCardMiniStat(
                            value: '${animCount(sport.sessionsCount)}',
                            label: 'Sessions',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildCardMiniStat(
                            value: '${animCount(sport.competitionsCount)}',
                            label: 'Competitions',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: AppColors.cardBorder),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 15,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Last active: ${sport.lastTrained}',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12.8,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 19,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardMiniStat({
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isArchivedView = _statusFilter == 2;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(
            isArchivedView
                ? Icons.inventory_2_outlined
                : Icons.sports_score_rounded,
            color: AppColors.secondaryTextStoneGrey,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            isArchivedView
                ? 'No Archived Sports Yet'
                : 'No Matching Sports Found',
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isArchivedView
                ? 'Tap any sport badge pill (e.g. PSA) or long-press a sport card to archive or restore it.'
                : 'Adjust your search query or reset filters to view all sports.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 12.8,
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () {
              setState(() {
                _statusFilter = 0;
                _selectedBarSportId = null;
                _searchController.clear();
                _searchQuery = '';
              });
            },
            child: const Text(
              'Show All Sports',
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
