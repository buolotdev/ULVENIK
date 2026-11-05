import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'dog_profile_screen.dart';
import 'goal_details_screen.dart';
import 'health_record_details_screen.dart';
import 'session_details_screen.dart';
import 'timeline_event_details_screen.dart';

enum _SearchScope {
  all,
  dogs,
  training,
  goals,
  health,
  timeline,
  media,
  competitions,
  clients,
}

class _GlobalSearchItem {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final _SearchScope scope;
  final String dogName;
  final String summary;
  final String metricLine;
  final bool isMediaVideo;
  final bool isMediaPhoto;
  final bool isActiveBadge;
  final bool inInitialFigmaSet;

  const _GlobalSearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.scope,
    required this.dogName,
    required this.summary,
    required this.metricLine,
    this.isMediaVideo = false,
    this.isMediaPhoto = false,
    this.isActiveBadge = false,
    this.inInitialFigmaSet = false,
  });
}

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  late final TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  // Matches exact Figma initial state: query "Recall" + removable chips "Murphy" & "Training"
  String _query = 'Recall';
  List<String> _activeFilterChips = ['Murphy', 'Training'];
  _SearchScope _selectedScope = _SearchScope.all;
  bool _isInitialFigmaPreset = true;

  List<String> _recentSearches = [
    'Recall',
    'Murphy',
    'IGP Regional Trial',
    'Rabies Booster',
    'Heelwork Foundations',
    'Sarah Jenkins',
  ];

  static const List<_GlobalSearchItem> _allItems = [
    // Exact 7 items from Figma Global Search frame
    _GlobalSearchItem(
      id: 'ts_1',
      title: 'Recall Foundations',
      subtitle: 'Murphy · 14 Sep 2026 · 45 min',
      badge: 'TRAINING',
      scope: _SearchScope.training,
      dogName: 'Murphy',
      summary:
          'Long-line whistle recall drills across medium-distraction meadow ground. 14/15 immediate turn-backs.',
      metricLine: 'Duration: 45 min · Rating: 5/5 · Success: 93%',
      inInitialFigmaSet: true,
    ),
    _GlobalSearchItem(
      id: 'ts_2',
      title: 'Advanced Recall',
      subtitle: 'Murphy · 8 Sep 2026 · 30 min',
      badge: 'TRAINING',
      scope: _SearchScope.training,
      dogName: 'Murphy',
      summary:
          'Off-lead proofing past decoy scent articles and moving cyclists at Riverside Trail.',
      metricLine: 'Duration: 30 min · Rating: 4/5 · Distance: 1.4 km',
      inInitialFigmaSet: true,
    ),
    _GlobalSearchItem(
      id: 'ts_3',
      title: 'Recall & Retrieve',
      subtitle: 'Monty · 1 Sep 2026 · 60 min',
      badge: 'TRAINING',
      scope: _SearchScope.training,
      dogName: 'Monty',
      summary:
          'Combined blind water retrieve with mid-cast emergency stop and whistle recall.',
      metricLine: 'Duration: 60 min · Rating: 5/5 · Reps: 12',
      inInitialFigmaSet: true,
    ),
    _GlobalSearchItem(
      id: 'gl_1',
      title: 'Reliable Recall',
      subtitle: 'Murphy · Active',
      badge: 'ACTIVE',
      scope: _SearchScope.goals,
      dogName: 'Murphy',
      summary:
          'Achieve 20 consecutive zero-hesitation whistle recalls at 50m+ in high distraction.',
      metricLine: 'Progress: 16 / 20 sessions (80%) · Priority: High',
      isActiveBadge: true,
      inInitialFigmaSet: true,
    ),
    _GlobalSearchItem(
      id: 'gl_2',
      title: 'Off-Lead Recall',
      subtitle: 'Monty · Active',
      badge: 'ACTIVE',
      scope: _SearchScope.goals,
      dogName: 'Monty',
      summary:
          'Maintain clean off-lead check-ins every 4 minutes during open moorland hikes.',
      metricLine: 'Progress: 9 / 12 sessions (75%) · Priority: Medium',
      isActiveBadge: true,
      inInitialFigmaSet: true,
    ),
    _GlobalSearchItem(
      id: 'md_1',
      title: 'Recall Training Video',
      subtitle: 'Murphy · 10 Sep 2026',
      badge: 'VIDEO',
      scope: _SearchScope.media,
      dogName: 'Murphy',
      summary:
          '1080p 60fps clip capturing Murphy’s instant head-whip response on two-pip whistle cue.',
      metricLine: '00:48 · 1080p HD · 34.2 MB · Riverside Trail',
      isMediaVideo: true,
      inInitialFigmaSet: true,
    ),
    _GlobalSearchItem(
      id: 'md_2',
      title: 'Recall Session Photo',
      subtitle: 'Murphy · 10 Sep 2026',
      badge: 'PHOTO',
      scope: _SearchScope.media,
      dogName: 'Murphy',
      summary:
          'Front-sit finish position photo after 60m long-field recall repetition.',
      metricLine: '4032 × 3024 px · RAW+JPEG · 4.8 MB',
      isMediaPhoto: true,
      inInitialFigmaSet: true,
    ),

    // Additional cross-module items across Dogs, Health, Timeline, Competitions, Clients & more
    _GlobalSearchItem(
      id: 'dg_1',
      title: 'Murphy — Border Collie',
      subtitle: 'Working Line · 3 yrs · Recall & IGP Track',
      badge: 'DOG',
      scope: _SearchScope.dogs,
      dogName: 'Murphy',
      summary:
          'Primary sport dog workspace. Active in Obedience, Recall Proofing, and IGP Phase B/C.',
      metricLine: 'Weight: 21.4 kg · 142 Logged Sessions · 3 Active Goals',
    ),
    _GlobalSearchItem(
      id: 'dg_2',
      title: 'Monty — Labrador Retriever',
      subtitle: 'Field Trial Line · 4 yrs · Gundog & Retrieve',
      badge: 'DOG',
      scope: _SearchScope.dogs,
      dogName: 'Monty',
      summary:
          'Gundog retrieve and off-lead steadiness profile with active conditioning plan.',
      metricLine: 'Weight: 28.6 kg · 98 Logged Sessions · 2 Active Goals',
    ),
    _GlobalSearchItem(
      id: 'dg_3',
      title: 'Freya — Belgian Malinois',
      subtitle: 'Sport & Protection · 2 yrs · IGP1 Prep',
      badge: 'DOG',
      scope: _SearchScope.dogs,
      dogName: 'Freya',
      summary:
          'High-drive IGP prospect focused on focused heelwork, tracking corners, and bark-and-hold.',
      metricLine: 'Weight: 24.8 kg · 86 Logged Sessions · 4 Active Goals',
    ),
    _GlobalSearchItem(
      id: 'ts_4',
      title: 'Heelwork Foundations & Left Turns',
      subtitle: 'Freya · 12 Sep 2026 · 35 min',
      badge: 'TRAINING',
      scope: _SearchScope.training,
      dogName: 'Freya',
      summary:
          'Precision shoulder alignment on tight 90° left turns and pace transitions.',
      metricLine: 'Duration: 35 min · Rating: 5/5 · Focus Score: 96%',
    ),
    _GlobalSearchItem(
      id: 'hl_1',
      title: 'Annual Vet Check & Rabies Booster',
      subtitle: 'Murphy · 28 Aug 2026 · Northwood Vet Clinic',
      badge: 'HEALTH',
      scope: _SearchScope.health,
      dogName: 'Murphy',
      summary:
          'Full orthopedic & cardiac clearance ahead of autumn Recall and IGP trial season.',
      metricLine: 'Weight: 21.4 kg · Heart Rate: 68 bpm · Cleared for Sport',
    ),
    _GlobalSearchItem(
      id: 'hl_2',
      title: 'Post-Recall Paw Pad Inspection',
      subtitle: 'Monty · 3 Sep 2026 · Home Care',
      badge: 'HEALTH',
      scope: _SearchScope.health,
      dogName: 'Monty',
      summary:
          'Routine pad check and balm application following gravel trail recall intervals.',
      metricLine: 'Status: Resolved · Follow-up: None required',
    ),
    _GlobalSearchItem(
      id: 'tl_1',
      title: '100m Whistle Recall Milestone',
      subtitle: 'Murphy · 11 Sep 2026 · Timeline Milestone',
      badge: 'TIMELINE',
      scope: _SearchScope.timeline,
      dogName: 'Murphy',
      summary:
          'Personal best 6.8s split on 100m uphill recall logged to Global Timeline.',
      metricLine: 'Pinned Milestone · GPS Verified · Box Hill Ridge',
    ),
    _GlobalSearchItem(
      id: 'tl_2',
      title: 'Autumn Conditioning Block Started',
      subtitle: 'Freya · 4 Sep 2026 · Timeline Event',
      badge: 'TIMELINE',
      scope: _SearchScope.timeline,
      dogName: 'Freya',
      summary:
          'Started 6-week aerobic & core balance progression for trial readiness.',
      metricLine: '6-Week Cycle · 3x Weekly S&C',
    ),
    _GlobalSearchItem(
      id: 'cp_1',
      title: 'Nordic Obedience & Recall Cup',
      subtitle: 'Murphy · 24 Oct 2026 · Class 2 Entry',
      badge: 'COMPETITION',
      scope: _SearchScope.competitions,
      dogName: 'Murphy',
      summary:
          'Registered for Class 2 Obedience including recalls with mid-flight down-stay.',
      metricLine: 'Venue: Surrey Arena · Entry Confirmed · Draw #14',
      isActiveBadge: true,
    ),
    _GlobalSearchItem(
      id: 'cp_2',
      title: 'IGP Regional Trial — Autumn Qualifier',
      subtitle: 'Freya · 15 Nov 2026 · IGP1',
      badge: 'COMPETITION',
      scope: _SearchScope.competitions,
      dogName: 'Freya',
      summary:
          'Tracking (A), Obedience & Recall over Hurdle (B), and Protection (C) qualifier.',
      metricLine: 'Target Score: 275 / 300 pts · Judge: H. Lindqvist',
    ),
    _GlobalSearchItem(
      id: 'cl_1',
      title: 'Sarah Jenkins — Recall Homework Plan',
      subtitle: 'Client · Dog: Bella (Cocker Spaniel)',
      badge: 'CLIENT',
      scope: _SearchScope.clients,
      dogName: 'Bella',
      summary:
          'Week 3 client homework package: 10m check-in games and high-value reward markers.',
      metricLine: 'Trainer Pack · 4/5 Homework Sessions Completed',
    ),
    _GlobalSearchItem(
      id: 'cl_2',
      title: 'Marcus Thorne — Puppy Foundation Pack',
      subtitle: 'Client · Dog: Atlas (GSD)',
      badge: 'CLIENT',
      scope: _SearchScope.clients,
      dogName: 'Atlas',
      summary:
          '1-to-1 consultation notes, engagement markers, and loose-lead homework.',
      metricLine: 'Trainer Pack · Next Session: Thu 17:30',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _query);
    _searchFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      if (value.trim() != 'Recall') {
        _isInitialFigmaPreset = false;
      }
    });
  }

  void _removeFilterChip(String chip) {
    setState(() {
      _activeFilterChips.remove(chip);
      _isInitialFigmaPreset = false;
      if (chip == 'Training' && _selectedScope == _SearchScope.training) {
        _selectedScope = _SearchScope.all;
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilterChips = [];
      _selectedScope = _SearchScope.all;
      _isInitialFigmaPreset = false;
    });
  }

  void _selectScope(_SearchScope scope) {
    setState(() {
      _selectedScope = scope;
      _isInitialFigmaPreset = false;
      // Keep dog chips if any, replace scope chips
      _activeFilterChips.removeWhere((c) => _scopeNames.contains(c));
      if (scope != _SearchScope.all) {
        _activeFilterChips.add(_scopeLabel(scope));
      }
    });
  }

  void _toggleDogFilter(String dog) {
    setState(() {
      _isInitialFigmaPreset = false;
      if (_activeFilterChips.contains(dog)) {
        _activeFilterChips.remove(dog);
      } else {
        _activeFilterChips.removeWhere(
          (c) => c == 'Murphy' || c == 'Monty' || c == 'Freya',
        );
        _activeFilterChips.add(dog);
      }
    });
  }

  static const Set<String> _scopeNames = {
    'Dogs',
    'Training',
    'Goals',
    'Health',
    'Timeline',
    'Media',
    'Competitions',
    'Clients',
  };

  String _scopeLabel(_SearchScope scope) {
    switch (scope) {
      case _SearchScope.all:
        return 'All';
      case _SearchScope.dogs:
        return 'Dogs';
      case _SearchScope.training:
        return 'Training';
      case _SearchScope.goals:
        return 'Goals';
      case _SearchScope.health:
        return 'Health';
      case _SearchScope.timeline:
        return 'Timeline';
      case _SearchScope.media:
        return 'Media';
      case _SearchScope.competitions:
        return 'Competitions';
      case _SearchScope.clients:
        return 'Clients';
    }
  }

  String _sectionHeaderTitle(_SearchScope scope) {
    switch (scope) {
      case _SearchScope.training:
        return 'TRAINING SESSIONS';
      case _SearchScope.goals:
        return 'GOALS';
      case _SearchScope.media:
        return 'MEDIA';
      case _SearchScope.dogs:
        return 'DOGS';
      case _SearchScope.health:
        return 'HEALTH RECORDS';
      case _SearchScope.timeline:
        return 'TIMELINE';
      case _SearchScope.competitions:
        return 'COMPETITIONS';
      case _SearchScope.clients:
        return 'CLIENTS';
      case _SearchScope.all:
        return 'RESULTS';
    }
  }

  List<_GlobalSearchItem> get _filteredItems {
    if (_isInitialFigmaPreset) {
      return _allItems.where((i) => i.inInitialFigmaSet).toList();
    }

    final q = _query.trim().toLowerCase();
    final activeDogs = _activeFilterChips
        .where((c) => c == 'Murphy' || c == 'Monty' || c == 'Freya')
        .toSet();
    final activeScopes = _activeFilterChips
        .where((c) => _scopeNames.contains(c))
        .toSet();

    return _allItems.where((item) {
      if (_selectedScope != _SearchScope.all && item.scope != _selectedScope) {
        return false;
      }
      if (activeScopes.isNotEmpty) {
        final itemScopeName = _scopeLabel(item.scope);
        // When "Training" chip is active without explicit single-scope lock, include Training + linked Goals/Media if initial, otherwise match scope
        if (_selectedScope == _SearchScope.all &&
            !activeScopes.contains(itemScopeName)) {
          return false;
        }
      }
      if (activeDogs.isNotEmpty && !activeDogs.contains(item.dogName)) {
        return false;
      }
      if (q.isEmpty) return true;
      return item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q) ||
          item.dogName.toLowerCase().contains(q) ||
          item.badge.toLowerCase().contains(q) ||
          item.summary.toLowerCase().contains(q);
    }).toList();
  }

  void _applyRecentSearch(String term) {
    setState(() {
      _query = term;
      _searchController.text = term;
      _searchController.selection = TextSelection.collapsed(
        offset: term.length,
      );
      _isInitialFigmaPreset = false;
      _recentSearches.remove(term);
      _recentSearches.insert(0, term);
    });
  }

  void _recordSearchTerm(String term) {
    final cleaned = term.trim();
    if (cleaned.isEmpty) return;
    setState(() {
      _recentSearches.removeWhere(
        (e) => e.toLowerCase() == cleaned.toLowerCase(),
      );
      _recentSearches.insert(0, cleaned);
      if (_recentSearches.length > 8) {
        _recentSearches = _recentSearches.sublist(0, 8);
      }
    });
  }

  void _openResultPreview(_GlobalSearchItem item) {
    if (_query.trim().isNotEmpty) {
      _recordSearchTerm(_query);
    }

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: const BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTextStoneGrey.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildResultBadge(item),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        item.dogName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(sheetCtx).pop(),
                      icon: const Icon(Icons.close_rounded,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 20,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.summary,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.primaryTextOffWhite,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const UlvenikIcon(UlvenikIcons.progress,
                            size: 15,
                            color: Color(0xFF53A689),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.metricLine,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      _navigateToLinkedDestination(item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _destinationActionLabel(item.scope),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
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

  String _destinationActionLabel(_SearchScope scope) {
    switch (scope) {
      case _SearchScope.training:
        return 'Open Session Details';
      case _SearchScope.goals:
        return 'Open Goal Details';
      case _SearchScope.dogs:
        return 'Open Dog Profile';
      case _SearchScope.health:
        return 'Open Health Record';
      case _SearchScope.timeline:
        return 'Open Timeline Event';
      case _SearchScope.media:
        return 'Open Media Record';
      case _SearchScope.competitions:
        return 'View Competition Entry';
      case _SearchScope.clients:
        return 'Open Client Record';
      case _SearchScope.all:
        return 'Open Record';
    }
  }

  void _navigateToLinkedDestination(_GlobalSearchItem item) {
    Widget? screen;
    switch (item.scope) {
      case _SearchScope.training:
        screen = SessionDetailsScreen(
          sessionTitle: item.title,
          shortDate: '14 Sep 2026',
          dateSubtitle: item.subtitle,
          durationText: item.subtitle.contains('30 min')
              ? '30m'
              : item.subtitle.contains('60 min')
              ? '1h 00m'
              : '45m',
          notes: item.summary,
        );
        break;
      case _SearchScope.goals:
        screen = GoalDetailsScreen(
          title: item.title,
          category: 'TRAINING',
          current: item.dogName == 'Murphy' ? 16 : 9,
          total: item.dogName == 'Murphy' ? 20 : 12,
        );
        break;
      case _SearchScope.dogs:
        screen = const DogProfileScreen();
        break;
      case _SearchScope.health:
        screen = const HealthRecordDetailsScreen();
        break;
      case _SearchScope.timeline:
      case _SearchScope.media:
        screen = TimelineEventDetailsScreen(
          initialTitle: item.title,
          initialDog: item.dogName,
        );
        break;
      case _SearchScope.competitions:
      case _SearchScope.clients:
      case _SearchScope.all:
        AppSnackbar.show(
          context,
          title: item.title,
          message: '${item.metricLine} — synced in ${item.dogName} workspace.',
          type: SnackbarType.info,
        );
        return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen!));
  }

  @override
  Widget build(BuildContext context) {
    final bool showRecentState =
        _query.trim().isEmpty &&
        _selectedScope == _SearchScope.all &&
        _activeFilterChips.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      // CRITICAL: Modal screen — strictly NO bottomNavigationBar
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSearchHeader(),
            Container(height: 1, color: AppColors.cardBorder),
            _buildFilterAndScopeSection(),
            Expanded(
              child: showRecentState
                  ? _buildRecentAndDiscoveryBody()
                  : _buildSearchResultsBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSearchHeader() {
    final bool hasText = _query.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? AppColors.primaryForestGreen.withValues(alpha: 0.55)
                      : AppColors.cardBorder,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const UlvenikIcon(UlvenikIcons.search,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: _onQueryChanged,
                      onSubmitted: _recordSearchTerm,
                      cursorColor: AppColors.primaryForestGreen,
                      cursorWidth: 1.8,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search dogs, training, health, media...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (hasText)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _query = '';
                          _activeFilterChips = [];
                          _selectedScope = _SearchScope.all;
                          _isInitialFigmaPreset = false;
                        });
                        _searchFocusNode.requestFocus();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close_rounded,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndScopeSection() {
    if (_activeFilterChips.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < _activeFilterChips.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          _buildRemovableChip(_activeFilterChips[i]),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _clearAllFilters,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryForestGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!_isInitialFigmaPreset) ...[
              const SizedBox(height: 10),
              _buildScopePillsRow(),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
      child: _buildScopePillsRow(),
    );
  }

  Widget _buildRemovableChip(String label) {
    return GestureDetector(
      onTap: () => _removeFilterChip(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.16),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 7),
            const Icon(Icons.close_rounded,
              size: 14,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScopePillsRow() {
    const scopes = _SearchScope.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (int i = 0; i < scopes.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _buildScopePill(scopes[i]),
          ],
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 20,
            color: AppColors.cardBorder,
          ),
          const SizedBox(width: 10),
          for (final dog in const ['Murphy', 'Monty', 'Freya']) ...[
            _buildDogQuickPill(dog),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildScopePill(_SearchScope scope) {
    final bool selected = _selectedScope == scope;
    return GestureDetector(
      onTap: () => _selectScope(scope),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryForestGreen.withValues(alpha: 0.22)
              : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primaryForestGreen
                : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          _scopeLabel(scope),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? AppColors.primaryTextOffWhite
                : AppColors.secondaryTextStoneGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildDogQuickPill(String dog) {
    final bool active = _activeFilterChips.contains(dog);
    return GestureDetector(
      onTap: () => _toggleDogFilter(dog),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? AppColors.secondarySage.withValues(alpha: 0.22)
              : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.secondarySage : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UlvenikIcon(UlvenikIcons.dogs,
              size: 12,
              color: active
                  ? AppColors.primaryTextOffWhite
                  : AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 5),
            Text(
              dog,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active
                    ? AppColors.primaryTextOffWhite
                    : AppColors.secondaryTextStoneGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAndDiscoveryBody() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          Row(
            children: [
              const Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _recentSearches.clear()),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryForestGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _recentSearches.length; i++) ...[
                  if (i > 0)
                    Container(height: 1, color: AppColors.cardBorder),
                  InkWell(
                    onTap: () => _applyRecentSearch(_recentSearches[i]),
                    borderRadius: BorderRadius.vertical(
                      top: i == 0 ? const Radius.circular(16) : Radius.zero,
                      bottom: i == _recentSearches.length - 1
                          ? const Radius.circular(16)
                          : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          const UlvenikIcon(UlvenikIcons.history,
                            size: 18,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _recentSearches[i],
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTextOffWhite,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _recentSearches.removeAt(i);
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close_rounded,
                                size: 16,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        const Text(
          'SEARCH ACROSS WORKSPACE',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDiscoveryCard(
              icon: Icons.pets_outlined,
              label: 'Dogs',
              count: '3 profiles',
              scope: _SearchScope.dogs,
            ),
            _buildDiscoveryCard(
              icon: Icons.fitness_center_rounded,
              label: 'Training',
              count: '4 sessions',
              scope: _SearchScope.training,
            ),
            _buildDiscoveryCard(
              icon: Icons.favorite_border_rounded,
              label: 'Health',
              count: '2 records',
              scope: _SearchScope.health,
            ),
            _buildDiscoveryCard(
              icon: Icons.timeline_rounded,
              label: 'Timeline',
              count: '2 events',
              scope: _SearchScope.timeline,
            ),
            _buildDiscoveryCard(
              icon: Icons.perm_media_outlined,
              label: 'Media',
              count: '2 items',
              scope: _SearchScope.media,
            ),
            _buildDiscoveryCard(
              icon: Icons.emoji_events_outlined,
              label: 'Competitions',
              count: '2 entries',
              scope: _SearchScope.competitions,
            ),
            _buildDiscoveryCard(
              icon: Icons.people_outline_rounded,
              label: 'Clients',
              count: '2 clients',
              scope: _SearchScope.clients,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscoveryCard({
    required IconData icon,
    required String label,
    required String count,
    required _SearchScope scope,
  }) {
    final width = (MediaQuery.of(context).size.width - 40) / 2;
    return GestureDetector(
      onTap: () => _selectScope(scope),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
              ),
              child: UlvenikIcon.fromMaterial(
                icon,
                size: 18,
                color: const Color(0xFF53A689),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    count,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsBody() {
    final results = _filteredItems;
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.search_off_rounded,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No matches for "${_query.trim()}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextOffWhite,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Try clearing active scope filters or searching for Recall, Murphy, IGP, or Vaccination.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () {
                  setState(() {
                    _query = 'Recall';
                    _searchController.text = 'Recall';
                    _activeFilterChips = ['Murphy', 'Training'];
                    _selectedScope = _SearchScope.all;
                    _isInitialFigmaPreset = true;
                  });
                },
                child: const Text(
                  'Reset to Recall Search',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryForestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group in canonical Figma order: Training Sessions -> Goals -> Media -> Dogs -> Health -> Timeline -> Competitions -> Clients
    const groupOrder = <_SearchScope>[
      _SearchScope.training,
      _SearchScope.goals,
      _SearchScope.media,
      _SearchScope.dogs,
      _SearchScope.health,
      _SearchScope.timeline,
      _SearchScope.competitions,
      _SearchScope.clients,
    ];

    final sections = <Widget>[];
    for (final scope in groupOrder) {
      final groupItems = results.where((r) => r.scope == scope).toList();
      if (groupItems.isEmpty) continue;

      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: 22));
      }
      sections.add(
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            _sectionHeaderTitle(scope),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.4,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
        ),
      );
      sections.add(_buildSectionCard(groupItems));
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      children: sections,
    );
  }

  Widget _buildSectionCard(List<_GlobalSearchItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) Container(height: 1, color: AppColors.cardBorder),
            _buildResultRow(
              items[i],
              isFirst: i == 0,
              isLast: i == items.length - 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(
    _GlobalSearchItem item, {
    required bool isFirst,
    required bool isLast,
  }) {
    final bool isMedia = item.isMediaVideo || item.isMediaPhoto;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openResultPreview(item),
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isMedia ? 13 : 15,
          ),
          child: Row(
            children: [
              _buildLeadingIcon(item),
              SizedBox(width: isMedia ? 14 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedTitle(item.title, _query.trim()),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _buildResultBadge(item),
              const SizedBox(width: 10),
              const UlvenikIcon(UlvenikIcons.details,
                size: 18,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(_GlobalSearchItem item) {
    if (item.isMediaVideo || item.isMediaPhoto) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF212629),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: Center(
          child: UlvenikIcon.fromMaterial(
            item.isMediaVideo
                ? Icons.play_arrow_outlined
                : Icons.image_outlined,
            color: AppColors.secondaryTextStoneGrey,
            size: item.isMediaVideo ? 23 : 20,
          ),
        ),
      );
    }

    switch (item.scope) {
      case _SearchScope.training:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CustomPaint(painter: _BarbellGlyphPainter()),
        );
      case _SearchScope.goals:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CustomPaint(painter: _ConcentricTargetPainter()),
        );
      case _SearchScope.dogs:
        return const UlvenikIcon(UlvenikIcons.dogs,
          size: 20,
          color: AppColors.secondaryTextStoneGrey,
        );
      case _SearchScope.health:
        return const UlvenikIcon(UlvenikIcons.health,
          size: 20,
          color: AppColors.secondaryTextStoneGrey,
        );
      case _SearchScope.timeline:
        return const UlvenikIcon(UlvenikIcons.history,
          size: 20,
          color: AppColors.secondaryTextStoneGrey,
        );
      case _SearchScope.competitions:
        return const Icon(Icons.emoji_events_outlined,
          size: 20,
          color: AppColors.secondaryTextStoneGrey,
        );
      case _SearchScope.clients:
        return const Icon(Icons.person_outline_rounded,
          size: 20,
          color: AppColors.secondaryTextStoneGrey,
        );
      case _SearchScope.media:
      case _SearchScope.all:
        return const Icon(Icons.insert_drive_file_outlined,
          size: 20,
          color: AppColors.secondaryTextStoneGrey,
        );
    }
  }

  Widget _buildHighlightedTitle(String title, String query) {
    const baseStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 15.5,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryTextOffWhite,
    );

    if (query.isEmpty) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final lowerTitle = title.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerTitle.indexOf(lowerQuery);
    if (matchIndex < 0) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final before = title.substring(0, matchIndex);
    final match = title.substring(matchIndex, matchIndex + query.length);
    final after = title.substring(matchIndex + query.length);

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: baseStyle,
        children: [
          if (before.isNotEmpty) TextSpan(text: before),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                match,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextOffWhite,
                ),
              ),
            ),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }

  Widget _buildResultBadge(_GlobalSearchItem item) {
    if (item.isActiveBadge) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
        decoration: BoxDecoration(
          color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.primaryForestGreen.withValues(alpha: 0.42),
            width: 1,
          ),
        ),
        child: Text(
          item.badge,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Color(0xFF43987B),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
          width: 1,
        ),
      ),
      child: Text(
        item.badge,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
          color: AppColors.secondaryTextStoneGrey,
        ),
      ),
    );
  }
}

class _BarbellGlyphPainter extends CustomPainter {
  const _BarbellGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondaryTextStoneGrey
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cy = size.height / 2;
    // Center bar
    canvas.drawLine(Offset(5.5, cy), Offset(size.width - 5.5, cy), paint);
    // Inner plates
    canvas.drawLine(Offset(5.5, cy - 5.5), Offset(5.5, cy + 5.5), paint);
    canvas.drawLine(
      Offset(size.width - 5.5, cy - 5.5),
      Offset(size.width - 5.5, cy + 5.5),
      paint,
    );
    // Outer plates
    canvas.drawLine(Offset(2.5, cy - 3.5), Offset(2.5, cy + 3.5), paint);
    canvas.drawLine(
      Offset(size.width - 2.5, cy - 3.5),
      Offset(size.width - 2.5, cy + 3.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConcentricTargetPainter extends CustomPainter {
  const _ConcentricTargetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondaryTextStoneGrey
      ..strokeWidth = 1.35
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 8.5, paint);
    canvas.drawCircle(center, 5.2, paint);
    canvas.drawCircle(center, 2.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
