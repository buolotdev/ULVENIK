import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'timeline_event_details_screen.dart';

class _CollectionMatchedEntry {
  final String title;
  final String subtitle;
  final bool isHealth;

  const _CollectionMatchedEntry({
    required this.title,
    required this.subtitle,
    required this.isHealth,
  });
}

class _SmartCollectionItem {
  final String id;
  final String section; // 'TIME', 'MEDIA', 'SPORT', 'HEALTH', 'CUSTOM'
  final String title;
  final String? description;
  final String badgeLabel;
  final Color badgeTextColor;
  final int eventCount;
  final String updatedLabel;
  final String ruleFormula;
  final String? coverImageUrl;
  final List<String>? collageUrls;
  final IconData? centerIcon;
  final Color? centerIconColor;
  final bool isHorizontalWide;
  final List<double> monthlySparkline;
  final List<_CollectionMatchedEntry> sampleEntries;
  bool isPinned;
  bool isArchived;

  _SmartCollectionItem({
    required this.id,
    required this.section,
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.badgeTextColor,
    required this.eventCount,
    required this.updatedLabel,
    required this.ruleFormula,
    required this.coverImageUrl,
    required this.collageUrls,
    required this.centerIcon,
    required this.centerIconColor,
    required this.isHorizontalWide,
    required this.monthlySparkline,
    required this.sampleEntries,
    required this.isPinned,
    required this.isArchived,
  });
}

class TimelineSmartCollectionsScreen extends StatefulWidget {
  final bool initialEmpty;

  const TimelineSmartCollectionsScreen({
    super.key,
    this.initialEmpty = false,
  });

  @override
  State<TimelineSmartCollectionsScreen> createState() =>
      _TimelineSmartCollectionsScreenState();
}

class _TimelineSmartCollectionsScreenState
    extends State<TimelineSmartCollectionsScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens (Exact from Figma SVGs) ─────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _appBarBg = Color(0xFF131719);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _darkSurface = Color(0xFF111412);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _bronze = Color(0xFFB4823C);
  static const Color _gold = Color(0xFFB8920A);
  static const Color _purple = Color(0xFF8C6EC4);
  static const Color _healthRed = Color(0xFFB85656);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x16FFFFFF);

  // Curated Nordic / Canine Sport Photography matching the Figma cards
  static const String _imgMistyAgility =
      'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=600&auto=format&fit=crop';
  static const String _imgMeadowTrail =
      'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=600&auto=format&fit=crop';
  static const String _imgHighlandRiver =
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=600&auto=format&fit=crop';
  static const String _imgPineForest =
      'https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=600&auto=format&fit=crop';
  static const String _imgTrainingHandler =
      'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=600&auto=format&fit=crop';
  static const String _imgRockyRidgeDog =
      'https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&w=600&auto=format&fit=crop';
  static const String _imgAlpineSummit =
      'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?q=80&w=600&auto=format&fit=crop';
  static const String _imgForestStream =
      'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=600&auto=format&fit=crop';
  static const String _imgVetSuite =
      'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?q=80&w=600&auto=format&fit=crop';
  static const String _imgVetExam =
      'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?q=80&w=600&auto=format&fit=crop';

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late bool _isEmptyState;
  String _searchQuery = '';
  String _badgeFilter = 'ALL'; // 'ALL', 'TIME', 'MEDIA', 'TRAINING', 'S&C', 'GOALS', 'HEALTH'
  String _sortMode = 'Default Grouping'; // 'Default Grouping', 'Most Events', 'Pinned First'
  bool _showArchived = false;

  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;

  late final List<_SmartCollectionItem> _collections = [
    // ── TIME-BASED RANGE ─────────────────────────────────────────────────────
    _SmartCollectionItem(
      id: 'sc_week',
      section: 'TIME',
      title: 'This Week',
      description: null,
      badgeLabel: 'TIME',
      badgeTextColor: _offWhite,
      eventCount: 12,
      updatedLabel: 'Updated just now',
      ruleFormula: 'date >= startOfWeek(now)',
      coverImageUrl: _imgMistyAgility,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [2, 3, 1, 2, 1, 3],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Recall & Engagement Work',
          subtitle: 'Today · Hylands Park · 45 mins',
          isHealth: false,
        ),
        _CollectionMatchedEntry(
          title: 'Scent Work — Track B',
          subtitle: '2 days ago · Riverside Trail · 550m',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_month',
      section: 'TIME',
      title: 'This Month',
      description: null,
      badgeLabel: 'TIME',
      badgeTextColor: _offWhite,
      eventCount: 47,
      updatedLabel: 'Updated 3h ago',
      ruleFormula: 'date.month == currentMonth',
      coverImageUrl: _imgMeadowTrail,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [9, 12, 11, 15, 14, 18],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Advanced Heel Work Session',
          subtitle: '3 Sep 2026 · 42 mins',
          isHealth: false,
        ),
        _CollectionMatchedEntry(
          title: 'Goal Completed: Distance Down Stay',
          subtitle: '9 Sep 2026 · Club Evaluation',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_last_month',
      section: 'TIME',
      title: 'Last Month',
      description: null,
      badgeLabel: 'TIME',
      badgeTextColor: _offWhite,
      eventCount: 61,
      updatedLabel: 'Updated 1 Sep',
      ruleFormula: 'date.month == previousMonth',
      coverImageUrl: _imgHighlandRiver,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [14, 16, 13, 18, 15, 17],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'First Hydrotherapy Session',
          subtitle: '12 Aug 2026 · Canine Rehab Suite',
          isHealth: true,
        ),
        _CollectionMatchedEntry(
          title: 'North Ridge Hill Repeats',
          subtitle: '24 Aug 2026 · 48 mins',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_year',
      section: 'TIME',
      title: 'This Year',
      description: null,
      badgeLabel: 'TIME',
      badgeTextColor: _offWhite,
      eventCount: 147,
      updatedLabel: 'Updated 3h ago',
      ruleFormula: 'date.year == 2026',
      coverImageUrl: _imgPineForest,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [18, 22, 26, 24, 30, 27],
      isPinned: true,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: '100th Timeline Entry',
          subtitle: '3 Sep 2026 · Milestone Unlocked',
          isHealth: false,
        ),
        _CollectionMatchedEntry(
          title: 'Regional IGP II — 1st Place',
          subtitle: '20 Jul 2026 · 286/300 pts',
          isHealth: false,
        ),
      ],
    ),

    // ── MEDIA & ARTIFACTS ────────────────────────────────────────────────────
    _SmartCollectionItem(
      id: 'sc_photos',
      section: 'MEDIA',
      title: 'Events with Photos',
      description: null,
      badgeLabel: 'MEDIA',
      badgeTextColor: _purple,
      eventCount: 89,
      updatedLabel: 'Updated 3h ago',
      ruleFormula: 'attachments.photos > 0',
      coverImageUrl: null,
      collageUrls: const [
        _imgTrainingHandler,
        _imgRockyRidgeDog,
        _imgPineForest,
        _imgHighlandRiver,
      ],
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [11, 14, 16, 15, 18, 15],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Long-Line Forest Tracking',
          subtitle: '4 photos attached · Blackwood Woods',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_videos',
      section: 'MEDIA',
      title: 'Events with Videos',
      description: null,
      badgeLabel: 'MEDIA',
      badgeTextColor: _purple,
      eventCount: 23,
      updatedLabel: 'Updated 2 Sep',
      ruleFormula: 'attachments.videos > 0',
      coverImageUrl: null,
      collageUrls: null,
      centerIcon: Icons.play_circle_outline,
      centerIconColor: _purple,
      isHorizontalWide: false,
      monthlySparkline: const [3, 4, 2, 5, 4, 5],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Heeling Gait Frame-Rate Review',
          subtitle: '3 clips · 60fps slow-motion',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_voice',
      section: 'MEDIA',
      title: 'Events with Voice Notes',
      description: null,
      badgeLabel: 'MEDIA',
      badgeTextColor: _purple,
      eventCount: 14,
      updatedLabel: 'Updated 28 Aug',
      ruleFormula: 'attachments.audio > 0',
      coverImageUrl: null,
      collageUrls: null,
      centerIcon: Icons.mic_none,
      centerIconColor: _purple,
      isHorizontalWide: false,
      monthlySparkline: const [1, 2, 3, 2, 4, 2],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Post-Track Handler Debrief Memo',
          subtitle: '28 Aug 2026 · 02:14 audio note',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_docs',
      section: 'MEDIA',
      title: 'Events with Documents',
      description: null,
      badgeLabel: 'MEDIA',
      badgeTextColor: _purple,
      eventCount: 8,
      updatedLabel: 'Updated 15 Aug',
      ruleFormula: 'attachments.pdf > 0',
      coverImageUrl: null,
      collageUrls: null,
      centerIcon: Icons.description_outlined,
      centerIconColor: _purple,
      isHorizontalWide: false,
      monthlySparkline: const [1, 1, 2, 1, 2, 1],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Annual Blood Chemistry & Hip Score PDF',
          subtitle: '15 Aug 2026 · Vet Clinic HQ',
          isHealth: true,
        ),
      ],
    ),

    // ── SPORT & CONDITIONING ─────────────────────────────────────────────────
    _SmartCollectionItem(
      id: 'sc_training_journey',
      section: 'SPORT',
      title: 'Training Journey',
      description: null,
      badgeLabel: 'TRAINING',
      badgeTextColor: _alpineBlue,
      eventCount: 94,
      updatedLabel: 'Updated 3h ago',
      ruleFormula: 'category == TRAINING',
      coverImageUrl: _imgTrainingHandler,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [12, 15, 16, 18, 17, 16],
      isPinned: true,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Advanced Heel Work Session',
          subtitle: '3 Sep 2026 · Riverside Trail · 42 mins',
          isHealth: false,
        ),
        _CollectionMatchedEntry(
          title: 'Scent Work — Track B',
          subtitle: '28 Aug 2026 · 550m aged trail',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_sc_journey',
      section: 'SPORT',
      title: 'S&C Journey',
      description: null,
      badgeLabel: 'S&C',
      badgeTextColor: _bronze,
      eventCount: 31,
      updatedLabel: 'Updated 1 Sep',
      ruleFormula: 'category == S&C',
      coverImageUrl: _imgRockyRidgeDog,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [4, 5, 5, 6, 5, 6],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Hill Repeats & Hindquarter Drive',
          subtitle: '24 Aug 2026 · North Ridge Trail',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_goal_journey',
      section: 'SPORT',
      title: 'Goal Journey',
      description: null,
      badgeLabel: 'GOALS',
      badgeTextColor: _gold,
      eventCount: 22,
      updatedLabel: 'Updated 9 Sep',
      ruleFormula: 'category == GOALS || milestone == true',
      coverImageUrl: _imgAlpineSummit,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [2, 3, 4, 4, 5, 4],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Goal Completed: Distance Down Stay',
          subtitle: '9 Sep 2026 · 38-day progression',
          isHealth: false,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_recent',
      section: 'SPORT',
      title: 'Recently Added',
      description: null,
      badgeLabel: 'TIME',
      badgeTextColor: _offWhite,
      eventCount: 6,
      updatedLabel: 'Updated just now',
      ruleFormula: 'createdAt >= now - 72h',
      coverImageUrl: _imgForestStream,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [1, 1, 2, 1, 3, 6],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Recall & Engagement Work',
          subtitle: 'Logged 3h ago · Hylands Park',
          isHealth: false,
        ),
      ],
    ),

    // ── HEALTH ───────────────────────────────────────────────────────────────
    _SmartCollectionItem(
      id: 'sc_health_records',
      section: 'HEALTH',
      title: 'Health Records',
      description: null,
      badgeLabel: 'HEALTH',
      badgeTextColor: _healthRed,
      eventCount: 38,
      updatedLabel: 'Updated 3 Sep',
      ruleFormula: 'category == HEALTH',
      coverImageUrl: _imgVetSuite,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: false,
      monthlySparkline: const [5, 7, 6, 6, 8, 6],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Orthopaedic Gait & Joint Assessment',
          subtitle: '18 Aug 2026 · Cleared full sport load',
          isHealth: true,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_weight_history',
      section: 'HEALTH',
      title: 'Weight History',
      description: null,
      badgeLabel: 'HEALTH',
      badgeTextColor: _healthRed,
      eventCount: 24,
      updatedLabel: 'Updated 1 Sep',
      ruleFormula: 'health.weightKg != null',
      coverImageUrl: null,
      collageUrls: null,
      centerIcon: Icons.monitor_weight_outlined,
      centerIconColor: _healthRed,
      isHorizontalWide: false,
      monthlySparkline: const [29.1, 29.3, 29.4, 29.2, 29.5, 29.4],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Bi-Weekly Conditioning Weigh-In: 29.4 kg',
          subtitle: '1 Sep 2026 · Lean sport condition 4.5/9',
          isHealth: true,
        ),
      ],
    ),
    _SmartCollectionItem(
      id: 'sc_vet_visits',
      section: 'HEALTH',
      title: 'Vet Visits',
      description: 'Medical\ncheckups & lab\nresults',
      badgeLabel: 'HEALTH',
      badgeTextColor: _healthRed,
      eventCount: 12,
      updatedLabel: 'Updated 7 Sep',
      ruleFormula: 'category == HEALTH && subtype == VET_VISIT',
      coverImageUrl: _imgVetExam,
      collageUrls: null,
      centerIcon: null,
      centerIconColor: null,
      isHorizontalWide: true,
      monthlySparkline: const [1, 2, 2, 3, 2, 2],
      isPinned: false,
      isArchived: false,
      sampleEntries: const [
        _CollectionMatchedEntry(
          title: 'Annual Wellness & Sport Screening',
          subtitle: '7 Sep 2026 · Vet Clinic HQ',
          isHealth: true,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _chartAnim = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _chartAnimController.dispose();
    super.dispose();
  }

  List<_SmartCollectionItem> get _filteredCollections {
    final list = _collections.where((item) {
      if (!_showArchived && item.isArchived) return false;
      if (_showArchived && !item.isArchived) return false;
      if (_badgeFilter != 'ALL' && item.badgeLabel != _badgeFilter) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return item.title.toLowerCase().contains(q) ||
            item.badgeLabel.toLowerCase().contains(q) ||
            item.ruleFormula.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    if (_sortMode == 'Most Events') {
      list.sort((a, b) => b.eventCount.compareTo(a.eventCount));
    } else if (_sortMode == 'Pinned First') {
      list.sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.eventCount.compareTo(a.eventCount);
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child:
                _isEmptyState ? _buildEmptyState() : _buildPopulatedState(),
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
        icon: UlvenikIcon.fromMaterial(
          _isEmptyState ? Icons.arrow_back : Icons.chevron_left,
          color: _stoneGrey,
          size: _isEmptyState ? 22 : 26,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Smart Collections',
        style: TextStyle(
          color: _offWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Search Smart Collections',
          icon: const UlvenikIcon(UlvenikIcons.search, color: _stoneGrey, size: 21),
          onPressed: () {
            _searchFocusNode.requestFocus();
          },
        ),
        PopupMenuButton<String>(
          icon: const UlvenikIcon(UlvenikIcons.more, color: _stoneGrey, size: 20),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: _cardBorder),
          ),
          onSelected: (val) {
            if (val == 'new_rule') {
              _showCreateRuleCollectionSheet();
            } else if (val == 'toggle_empty') {
              setState(() => _isEmptyState = !_isEmptyState);
              AppSnackbar.show(
                context,
                message: _isEmptyState
                    ? 'Switched to Empty State preview'
                    : 'Switched to Populated Smart Collections',
                type: SnackbarType.info,
              );
            } else if (val == 'toggle_archived') {
              setState(() => _showArchived = !_showArchived);
            } else if (val == 'reset') {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _badgeFilter = 'ALL';
                _sortMode = 'Default Grouping';
                _showArchived = false;
              });
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'new_rule',
              child: Text(
                '+ New Rule-Based Smart Collection',
                style: TextStyle(
                    color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            PopupMenuItem(
              value: 'toggle_empty',
              child: Text(
                _isEmptyState
                    ? 'Switch to Populated State'
                    : 'Switch to Empty State',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            PopupMenuItem(
              value: 'toggle_archived',
              child: Text(
                _showArchived
                    ? 'Show Active Collections'
                    : 'View Archived Collections',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text(
                'Reset Search, Sort & Filters',
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _cardBorder),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        enabled: !_isEmptyState,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(
          color: _offWhite,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: 'Search collections...',
          hintStyle: const TextStyle(
            color: _stoneGrey,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
          prefixIcon:
              const UlvenikIcon(UlvenikIcons.search, color: _stoneGrey, size: 19),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 17),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : IconButton(
                  icon:
                      const Icon(Icons.mic_none, color: _stoneGrey, size: 19),
                  onPressed: () {
                    if (_isEmptyState) return;
                    setState(() {
                      _searchController.text = 'Journey';
                      _searchQuery = 'Journey';
                    });
                    AppSnackbar.show(
                      context,
                      message: 'Voice filter matched "Journey" collections',
                      type: SnackbarType.info,
                    );
                  },
                ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // POPULATED STATE (Matches 04_smart_collections_populated.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedState() {
    final visible = _filteredCollections;
    final activeTotal = _collections.where((c) => !c.isArchived).length;

    final isGroupedView = _sortMode == 'Default Grouping' &&
        _badgeFilter == 'ALL' &&
        _searchQuery.trim().isEmpty &&
        !_showArchived;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 14),

          // Sync Status & Auto-Compiled / Create Rule Strip
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _forest,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  '$activeTotal SMART PRESETS SYNCED',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showCreateRuleCollectionSheet,
                child: const Text(
                  'AUTO-COMPILED',
                  style: TextStyle(
                    color: _sage,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),

          if (_badgeFilter != 'ALL' ||
              _sortMode != 'Default Grouping' ||
              _showArchived) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_alt_outlined,
                      color: _mint, size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      [
                        if (_showArchived) 'Archived',
                        if (_badgeFilter != 'ALL') 'Badge: $_badgeFilter',
                        if (_sortMode != 'Default Grouping') 'Sort: $_sortMode',
                      ].join(' · '),
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _badgeFilter = 'ALL';
                      _sortMode = 'Default Grouping';
                      _showArchived = false;
                    }),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          if (visible.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  const Icon(Icons.folder_off_outlined,
                      color: _stoneGrey, size: 32),
                  const SizedBox(height: 10),
                  Text(
                    _showArchived
                        ? 'No archived collections yet'
                        : 'No collections match your filter',
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else if (isGroupedView) ...[
            // Custom user-created collections (if any added via rule builder)
            if (visible.any((c) => c.section == 'CUSTOM')) ...[
              _buildSectionHeader('CUSTOM SMART RULES'),
              const SizedBox(height: 10),
              _buildTwoColumnGrid(
                  visible.where((c) => c.section == 'CUSTOM').toList()),
              const SizedBox(height: 22),
            ],

            // 1. TIME-BASED RANGE
            _buildSectionHeader('TIME-BASED RANGE'),
            const SizedBox(height: 10),
            _buildTwoColumnGrid(
                visible.where((c) => c.section == 'TIME').toList()),
            const SizedBox(height: 24),

            // 2. MEDIA & ARTIFACTS
            _buildSectionHeader('MEDIA & ARTIFACTS'),
            const SizedBox(height: 10),
            _buildTwoColumnGrid(
                visible.where((c) => c.section == 'MEDIA').toList()),
            const SizedBox(height: 24),

            // 3. SPORT & CONDITIONING
            _buildSectionHeader('SPORT & CONDITIONING'),
            const SizedBox(height: 10),
            _buildTwoColumnGrid(
                visible.where((c) => c.section == 'SPORT').toList()),
            const SizedBox(height: 24),

            // 4. HEALTH
            _buildSectionHeader('HEALTH'),
            const SizedBox(height: 10),
            _buildTwoColumnGrid(visible
                .where((c) => c.section == 'HEALTH' && !c.isHorizontalWide)
                .toList()),
            for (final wide in visible.where(
                (c) => c.section == 'HEALTH' && c.isHorizontalWide)) ...[
              const SizedBox(height: 12),
              _buildHorizontalVetCard(wide),
            ],
          ] else ...[
            _buildTwoColumnGrid(
                visible.where((c) => !c.isHorizontalWide).toList()),
            for (final wide in visible.where((c) => c.isHorizontalWide)) ...[
              const SizedBox(height: 12),
              _buildHorizontalVetCard(wide),
            ],
          ],

          const SizedBox(height: 18),
          // Interactive Create Rule-Based Collection Card
          GestureDetector(
            onTap: _showCreateRuleCollectionSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _forest.withValues(alpha: 0.45)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: _mint, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Custom Smart Collection',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Auto-compile entries by category, media, or duration rule',
                          style: TextStyle(color: _stoneGrey, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  const UlvenikIcon(UlvenikIcons.add, color: _mint, size: 20),
                ],
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
        color: _stoneGrey,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildTwoColumnGrid(List<_SmartCollectionItem> items) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 12));
      final left = items[i];
      final right = (i + 1 < items.length) ? items[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildGridCollectionCard(left)),
              const SizedBox(width: 12),
              Expanded(
                child: right != null
                    ? _buildGridCollectionCard(right)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildGridCollectionCard(_SmartCollectionItem item) {
    return GestureDetector(
      onTap: () => _openCollectionDetailSheet(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: item.isPinned
                  ? _mint.withValues(alpha: 0.35)
                  : _cardBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Artwork / Collage / Icon Hero Area
              SizedBox(
                height: 108,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item.collageUrls != null &&
                        item.collageUrls!.length == 4)
                      Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    child: _buildImgThumb(item.collageUrls![0])),
                                const SizedBox(width: 1.5),
                                Expanded(
                                    child: _buildImgThumb(item.collageUrls![1])),
                              ],
                            ),
                          ),
                          const SizedBox(height: 1.5),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    child: _buildImgThumb(item.collageUrls![2])),
                                const SizedBox(width: 1.5),
                                Expanded(
                                    child: _buildImgThumb(item.collageUrls![3])),
                              ],
                            ),
                          ),
                        ],
                      )
                    else if (item.coverImageUrl != null)
                      _buildImgThumb(item.coverImageUrl!)
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF13171A),
                              Color(0xFF1A1F22),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF22272C),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: UlvenikIcon.fromMaterial(
                            item.centerIcon ?? Icons.folder_special_outlined,
                            color: item.centerIconColor ?? _mint,
                            size: 20,
                          ),
                        ),
                      ),

                    // Bottom gradient fade into card surface
                    if (item.coverImageUrl != null || item.collageUrls != null)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.08),
                                _carbon.withValues(alpha: 0.96),
                              ],
                              stops: const [0.42, 1.0],
                            ),
                          ),
                        ),
                      ),

                    // Pin indicator top-left (if pinned)
                    if (item.isPinned)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _obsidian.withValues(alpha: 0.78),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.push_pin,
                              color: _mint, size: 11),
                        ),
                      ),

                    // Category Badge Top-Right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: _obsidian.withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Text(
                          item.badgeLabel,
                          style: TextStyle(
                            color: item.badgeTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Card Text Footer
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontFamily: 'Inter'),
                        children: [
                          TextSpan(
                            text: '${item.eventCount}',
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const TextSpan(
                            text: ' events',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.updatedLabel,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
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
    );
  }

  Widget _buildImgThumb(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: _darkSurface,
        child: const Icon(Icons.landscape_outlined,
            color: _stoneGrey, size: 22),
      ),
    );
  }

  Widget _buildHorizontalVetCard(_SmartCollectionItem item) {
    return GestureDetector(
      onTap: () => _openCollectionDetailSheet(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 144,
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _cardBorder),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 132,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item.coverImageUrl != null)
                      _buildImgThumb(item.coverImageUrl!),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            _carbon.withValues(alpha: 0.92),
                          ],
                          stops: const [0.55, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 13, 14, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: _obsidian.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.badgeLabel,
                              style: TextStyle(
                                color: item.badgeTextColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          item.description ??
                              'Medical checkups & lab results',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12.5,
                            height: 1.32,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontFamily: 'Inter'),
                              children: [
                                TextSpan(
                                  text: '${item.eventCount}',
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' events logged',
                                  style: TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.updatedLabel,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matches 04_smart_collections_empty.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 78,
                      height: 78,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _carbon,
                                border: Border.all(color: _cardBorder),
                              ),
                              child: const Icon(Icons.folder_open_outlined,
                                color: _sage,
                                size: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 4,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: _forest,
                              ),
                              child: const Icon(Icons.auto_awesome,
                                color: _mint,
                                size: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'No Collections Available',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Related Timeline events are automatically organised into collections as your history grows.',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.maybePop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: _offWhite,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM ACTION STRIP
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBottomActionStrip() {
    if (_isEmptyState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: const BoxDecoration(
          color: _appBarBg,
          border: Border(top: BorderSide(color: _cardBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UlvenikIcon(UlvenikIcons.sort,
                    color: _stoneGrey.withValues(alpha: 0.45), size: 17),
                const SizedBox(width: 6),
                Text(
                  'Sort',
                  style: TextStyle(
                    color: _stoneGrey.withValues(alpha: 0.45),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.manage_search,
                    color: _stoneGrey.withValues(alpha: 0.45), size: 18),
                const SizedBox(width: 6),
                Text(
                  'Search',
                  style: TextStyle(
                    color: _stoneGrey.withValues(alpha: 0.45),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: _appBarBg,
        border: Border(top: BorderSide(color: _cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showSortSheet,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.sort, color: _stoneGrey, size: 17),
                SizedBox(width: 6),
                Text(
                  'Sort',
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
            onTap: _showCreateRuleCollectionSheet,
            child: Text(
              '|   INDEX: SPORT v4.2   |',
              style: TextStyle(
                color: _stoneGrey.withValues(alpha: 0.6),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: _showFilterBadgeSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list,
                  color: _badgeFilter != 'ALL' ? _mint : _stoneGrey,
                  size: 17,
                ),
                const SizedBox(width: 6),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: _badgeFilter != 'ALL' ? _mint : _stoneGrey,
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
  // INTERACTIVE MODALS (Collection Inspector + Sparkline, Rule Builder, Sort/Filter)
  // ═══════════════════════════════════════════════════════════════════════════
  void _openCollectionDetailSheet(_SmartCollectionItem item) {
    int? scrubMonth;
    _chartAnimController.forward(from: 0);
    const months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _obsidian,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.badgeLabel,
                                    style: TextStyle(
                                      color: item.badgeTextColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.eventCount} matched events',
                                  style: const TextStyle(
                                      color: _stoneGrey, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: item.isPinned ? 'Unpin' : 'Pin Collection',
                        onPressed: () {
                          setModalState(() => item.isPinned = !item.isPinned);
                          setState(() {});
                          AppSnackbar.show(
                            context,
                            message: item.isPinned
                                ? 'Pinned "${item.title}"'
                                : 'Unpinned "${item.title}"',
                            type: SnackbarType.success,
                          );
                        },
                        icon: UlvenikIcon.fromMaterial(
                          item.isPinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          color: item.isPinned ? _mint : _stoneGrey,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        tooltip:
                            item.isArchived ? 'Restore' : 'Archive Collection',
                        onPressed: () {
                          setState(() => item.isArchived = !item.isArchived);
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            message: item.isArchived
                                ? 'Archived "${item.title}"'
                                : 'Restored "${item.title}"',
                            type: SnackbarType.info,
                          );
                        },
                        icon: UlvenikIcon.fromMaterial(
                          item.isArchived
                              ? Icons.unarchive_outlined
                              : Icons.archive_outlined,
                          color: _stoneGrey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: _mint, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Smart Rule: ${item.ruleFormula}',
                            style: const TextStyle(
                              color: _sage,
                              fontSize: 11.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Animated & Touch-Interactive 6-Month Collection Trend Mini-Chart
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '6-MONTH AUTO-MATCH TREND',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              scrubMonth != null
                                  ? '${months[scrubMonth!]}: ${item.monthlySparkline[scrubMonth!]}'
                                  : 'Tap bars to inspect',
                              style: const TextStyle(
                                color: _mint,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 68,
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              void onTouch(Offset local) {
                                final idx = ((local.dx / constraints.maxWidth) *
                                        item.monthlySparkline.length)
                                    .floor()
                                    .clamp(
                                        0, item.monthlySparkline.length - 1);
                                setModalState(() => scrubMonth = idx);
                              }

                              return GestureDetector(
                                onTapDown: (d) => onTouch(d.localPosition),
                                onHorizontalDragUpdate: (d) =>
                                    onTouch(d.localPosition),
                                child: AnimatedBuilder(
                                  animation: _chartAnim,
                                  builder: (context, _) {
                                    return CustomPaint(
                                      painter: _CollectionMiniBarPainter(
                                        values: item.monthlySparkline,
                                        progress: _chartAnim.value,
                                        accent: item.badgeTextColor == _offWhite
                                            ? _mint
                                            : item.badgeTextColor,
                                        selectedIndex: scrubMonth,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text(
                    'MATCHED TIMELINE ENTRIES',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final entry in item.sampleEntries)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _obsidian,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: UlvenikIcon.fromMaterial(
                          entry.isHealth
                              ? Icons.medical_services_outlined
                              : Icons.bolt,
                          color: item.badgeTextColor,
                          size: 17,
                        ),
                      ),
                      title: Text(
                        entry.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        entry.subtitle,
                        style: const TextStyle(
                            color: _stoneGrey, fontSize: 11.5),
                      ),
                      trailing: const UlvenikIcon(UlvenikIcons.details,
                          color: _stoneGrey, size: 18),
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TimelineEventDetailsScreen(
                              initialVariant: entry.isHealth
                                  ? TimelineEventVariant.health
                                  : TimelineEventVariant.training,
                              initialTitle: entry.title,
                              initialDog: 'Murphy',
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateRuleCollectionSheet() {
    final nameCtrl = TextEditingController();
    String selectedBadge = 'TRAINING';
    bool requireMedia = true;
    double minMins = 30;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 28,
              ),
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
                    'New Rule-Based Smart Collection',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g., High-Drive Trail Sessions',
                      hintStyle:
                          const TextStyle(color: _stoneGrey, fontSize: 13),
                      filled: true,
                      fillColor: _obsidian,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'MATCH CATEGORY RULE',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final cat in [
                        'TRAINING',
                        'S&C',
                        'GOALS',
                        'HEALTH',
                        'MEDIA'
                      ])
                        ChoiceChip(
                          label: Text(cat),
                          selected: selectedBadge == cat,
                          onSelected: (_) =>
                              setModalState(() => selectedBadge = cat),
                          selectedColor: _forest,
                          backgroundColor: _obsidian,
                          labelStyle: TextStyle(
                            color:
                                selectedBadge == cat ? _offWhite : _stoneGrey,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: _mint,
                    title: const Text(
                      'Require Photo or Video Attachment',
                      style: TextStyle(color: _offWhite, fontSize: 13.5),
                    ),
                    value: requireMedia,
                    onChanged: (v) => setModalState(() => requireMedia = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Minimum Session Duration',
                        style: TextStyle(color: _stoneGrey, fontSize: 12.5),
                      ),
                      Text(
                        '${minMins.round()} mins',
                        style: const TextStyle(
                            color: _mint,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider(
                    value: minMins,
                    min: 10,
                    max: 90,
                    divisions: 8,
                    activeColor: _forest,
                    onChanged: (v) => setModalState(() => minMins = v),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = nameCtrl.text.trim().isEmpty
                            ? '$selectedBadge >= ${minMins.round()}m'
                            : nameCtrl.text.trim();
                        final badgeColor = switch (selectedBadge) {
                          'TRAINING' => _alpineBlue,
                          'S&C' => _bronze,
                          'GOALS' => _gold,
                          'HEALTH' => _healthRed,
                          _ => _purple,
                        };
                        setState(() {
                          _isEmptyState = false;
                          _collections.insert(
                            0,
                            _SmartCollectionItem(
                              id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                              section: 'CUSTOM',
                              title: title,
                              description: null,
                              badgeLabel: selectedBadge,
                              badgeTextColor: badgeColor,
                              eventCount: 9,
                              updatedLabel: 'Compiled just now',
                              ruleFormula:
                                  'category == $selectedBadge && duration >= ${minMins.round()}m${requireMedia ? ' && hasMedia' : ''}',
                              coverImageUrl: null,
                              collageUrls: null,
                              centerIcon: Icons.auto_awesome,
                              centerIconColor: _mint,
                              isHorizontalWide: false,
                              monthlySparkline: const [1, 2, 1, 2, 1, 2],
                              isPinned: true,
                              isArchived: false,
                              sampleEntries: const [
                                _CollectionMatchedEntry(
                                  title: 'Auto-Matched Rule Session',
                                  subtitle: 'Riverside Trail · Rule verified',
                                  isHealth: false,
                                ),
                              ],
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          message:
                              'Created Smart Collection "$title" (9 events matched)',
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
                        'Compile Smart Collection',
                        style: TextStyle(fontWeight: FontWeight.w700),
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

  void _showSortSheet() {
    const modes = ['Default Grouping', 'Most Events', 'Pinned First'];
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
              const Text(
                'Sort Smart Collections',
                style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              for (final m in modes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    m,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                  ),
                  trailing: _sortMode == m
                      ? const Icon(Icons.check, color: _mint, size: 19)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _sortMode = m);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBadgeSheet() {
    const badges = [
      'ALL',
      'TIME',
      'MEDIA',
      'TRAINING',
      'S&C',
      'GOALS',
      'HEALTH'
    ];
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
              const Text(
                'Filter by Preset Type',
                style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final b in badges)
                    ChoiceChip(
                      label: Text(b),
                      selected: _badgeFilter == b,
                      onSelected: (_) {
                        Navigator.pop(ctx);
                        setState(() => _badgeFilter = b);
                      },
                      selectedColor: _forest,
                      backgroundColor: _obsidian,
                      labelStyle: TextStyle(
                        color: _badgeFilter == b ? _offWhite : _stoneGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollectionMiniBarPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final Color accent;
  final int? selectedIndex;

  _CollectionMiniBarPainter({
    required this.values,
    required this.progress,
    required this.accent,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = math.max(1.0, values.reduce(math.max));
    final slotW = size.width / values.length;
    final barW = math.min(28.0, slotW * 0.56);

    for (int i = 0; i < values.length; i++) {
      final norm = (values[i] / maxV).clamp(0.12, 1.0);
      final h = size.height * norm * progress;
      final left = i * slotW + (slotW - barW) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, size.height - h, barW, h),
        const Radius.circular(5),
      );
      final isSel = selectedIndex == i;
      canvas.drawRRect(
        rect,
        Paint()
          ..color = isSel
              ? accent
              : accent.withValues(alpha: selectedIndex == null ? 0.65 : 0.28),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CollectionMiniBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.accent != accent;
  }
}
