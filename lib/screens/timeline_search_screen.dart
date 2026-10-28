import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'timeline_event_details_screen.dart';
import 'timeline_filters_screen.dart';

/// Timeline Search Result Item Model
class TimelineSearchResultItem {
  final String id;
  final String title;
  final String snippet;
  final String category; // 'Training', 'Health', 'S&C', 'Goals', 'Media', 'Competition'
  final String typeLabel;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final DateTime date;
  final int relevanceScore;

  const TimelineSearchResultItem({
    required this.id,
    required this.title,
    required this.snippet,
    required this.category,
    required this.typeLabel,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    required this.date,
    this.relevanceScore = 10,
  });
}

/// Timeline Search Screen (Batch 6 - Lines 177 & 178)
/// Implements both:
/// 1. Pre-search State (Figma Image 1): Toggles, Saved Searches, Recent Searches, Popular Searches
/// 2. Active Results State (Figma Image 2): Query Highlights, Filter Chips, Relevance Sorting,
///    Animated Interactive Category Graph, Result Feed, and "Save as saved search" Card
class TimelineSearchScreen extends StatefulWidget {
  final String? initialQuery;

  const TimelineSearchScreen({super.key, this.initialQuery});

  @override
  State<TimelineSearchScreen> createState() => _TimelineSearchScreenState();
}

class _TimelineSearchScreenState extends State<TimelineSearchScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _surfaceVariant = Color(0xFF323533);
  static const Color _surfaceDim = Color(0xFF111412);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _mintLight = Color(0xFFAAE9D0);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _healthDot = Color(0xFF8B3A3A);
  static const Color _scDot = Color(0xFF8B5E3C);
  static const Color _goalsDot = Color(0xFF7A6B2E);
  static const Color _mediaDot = Color(0xFF5A3A8B);
  static const Color _borderHairline = Color(0x14FFFFFF);

  // ─── Search Controllers & States ───────────────────────────────────────────
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  String _currentQuery = '';

  // Pre-search toggles
  bool _searchNotes = true;
  bool _searchAttachments = false;

  // Saved Searches
  final List<String> _savedSearches = [
    'Swimming',
    'Recall',
    'Nationals',
    'Hydrotherapy',
  ];

  // Recent Searches
  final List<String> _recentSearches = [
    'Vet Visit',
    'Hill Work',
    'Medication',
    'Weight',
    'Agility',
  ];

  // Popular Suggestions
  final List<String> _popularSuggestions = [
    'Heel Work',
    'Riverside Park',
    'Annual Health Check',
    'Off-Leash Recall',
    'Barkcroft Veterinary',
    'Sprint Drills',
  ];

  // Active Results State Filter & Sort
  String _selectedCategoryFilter = 'All'; // 'All', 'Training', 'Health', 'S&C', 'Goals', 'Media'
  String _selectedSort = 'Relevance'; // 'Relevance', 'Newest', 'Oldest'
  bool _showInteractiveChart = true;

  // Animation controller for search result graph
  late AnimationController _chartAnimController;
  late Animation<double> _chartCurveAnimation;
  int? _touchedGroupIndex;

  // Mock Database of Timeline Records
  final List<TimelineSearchResultItem> _database = [
    TimelineSearchResultItem(
      id: 'res-1',
      title: 'Obedience — Heel Work & Recall',
      snippet: '…practised Recall at 20m in park with light distraction…',
      category: 'Training',
      typeLabel: 'Training Session',
      timeAgo: '2 days ago',
      icon: Icons.fitness_center,
      iconColor: _alpineBlue,
      date: DateTime.now().subtract(const Duration(days: 2)),
      relevanceScore: 98,
    ),
    TimelineSearchResultItem(
      id: 'res-2',
      title: 'Off-Leash Recall — Goal Achieved',
      snippet: 'Recall goal completed: 10 consecutive flawless reps…',
      category: 'Goals',
      typeLabel: 'Goal Completed',
      timeAgo: '1 week ago',
      icon: Icons.emoji_events,
      iconColor: _goalsDot,
      date: DateTime.now().subtract(const Duration(days: 7)),
      relevanceScore: 94,
    ),
    TimelineSearchResultItem(
      id: 'res-3',
      title: 'Field Work — Recall & Retrieve',
      snippet: 'Group distraction recall drill with remote whistle…',
      category: 'Training',
      typeLabel: 'Training Session',
      timeAgo: '2 weeks ago',
      icon: Icons.fitness_center,
      iconColor: _alpineBlue,
      date: DateTime.now().subtract(const Duration(days: 14)),
      relevanceScore: 90,
    ),
    TimelineSearchResultItem(
      id: 'res-4',
      title: 'Obedience — Sit, Recall, Heel',
      snippet: '…focused session on recall foundation & swift return…',
      category: 'Training',
      typeLabel: 'Training Session',
      timeAgo: '3 weeks ago',
      icon: Icons.fitness_center,
      iconColor: _alpineBlue,
      date: DateTime.now().subtract(const Duration(days: 21)),
      relevanceScore: 86,
    ),
    TimelineSearchResultItem(
      id: 'res-5',
      title: 'Sprint Drills — Endurance Work',
      snippet: 'Notes: …short recall game before sprint intervals…',
      category: 'S&C',
      typeLabel: 'S&C Session',
      timeAgo: '1 month ago',
      icon: Icons.directions_run,
      iconColor: _scDot,
      date: DateTime.now().subtract(const Duration(days: 30)),
      relevanceScore: 78,
    ),
    TimelineSearchResultItem(
      id: 'res-6',
      title: 'Vet Visit — Annual Health Check',
      snippet: 'Atlas examined by Dr. Sarah Jenkins. Optimal health…',
      category: 'Health',
      typeLabel: 'Health Record',
      timeAgo: '1 month ago',
      icon: Icons.medical_services,
      iconColor: _healthDot,
      date: DateTime.now().subtract(const Duration(days: 35)),
      relevanceScore: 70,
    ),
    TimelineSearchResultItem(
      id: 'res-7',
      title: 'Riverside Park — Agility Practice',
      snippet: 'Heel work, weaves and obstacle recall routines…',
      category: 'Training',
      typeLabel: 'Training Session',
      timeAgo: '5 days ago',
      icon: Icons.fitness_center,
      iconColor: _alpineBlue,
      date: DateTime.now().subtract(const Duration(days: 5)),
      relevanceScore: 65,
    ),
    TimelineSearchResultItem(
      id: 'res-8',
      title: 'Swimming & Hydrotherapy Session',
      snippet: 'Low impact swimming conditioning in warm pool…',
      category: 'S&C',
      typeLabel: 'S&C Session',
      timeAgo: '2 weeks ago',
      icon: Icons.pool,
      iconColor: _scDot,
      date: DateTime.now().subtract(const Duration(days: 16)),
      relevanceScore: 60,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.initialQuery ?? '';
    _searchController = TextEditingController(text: _currentQuery);
    _searchFocusNode = FocusNode();

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _chartCurveAnimation = CurvedAnimation(
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

  // ─── Search Handlers ────────────────────────────────────────────────────────

  void _executeSearch(String query) {
    setState(() {
      _currentQuery = query.trim();
      _searchController.text = _currentQuery;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _currentQuery.length),
      );
      if (_currentQuery.isNotEmpty && !_recentSearches.contains(_currentQuery)) {
        _recentSearches.insert(0, _currentQuery);
      }
    });
    _chartAnimController.forward(from: 0.0);
  }

  void _clearSearch() {
    setState(() {
      _currentQuery = '';
      _searchController.clear();
      _selectedCategoryFilter = 'All';
    });
  }

  void _saveCurrentSearch() {
    if (_currentQuery.isNotEmpty && !_savedSearches.contains(_currentQuery)) {
      setState(() {
        _savedSearches.insert(0, _currentQuery);
      });
    }
  }

  // ─── Filtered Results Logic ─────────────────────────────────────────────────

  List<TimelineSearchResultItem> get _filteredResults {
    if (_currentQuery.isEmpty) return [];

    final q = _currentQuery.toLowerCase();

    final results = _database.where((item) {
      final matchesQuery = item.title.toLowerCase().contains(q) ||
          item.snippet.toLowerCase().contains(q) ||
          item.typeLabel.toLowerCase().contains(q);

      if (!matchesQuery) return false;

      if (_selectedCategoryFilter != 'All' &&
          item.category != _selectedCategoryFilter) {
        return false;
      }

      return true;
    }).toList();

    // Sort results
    if (_selectedSort == 'Relevance') {
      results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    } else if (_selectedSort == 'Newest') {
      results.sort((a, b) => b.date.compareTo(a.date));
    } else if (_selectedSort == 'Oldest') {
      results.sort((a, b) => a.date.compareTo(b.date));
    }

    return results;
  }

  int _countForCategory(String cat) {
    final q = _currentQuery.toLowerCase();
    return _database.where((item) {
      final matchesQuery = item.title.toLowerCase().contains(q) ||
          item.snippet.toLowerCase().contains(q) ||
          item.typeLabel.toLowerCase().contains(q);
      return matchesQuery && item.category == cat;
    }).length;
  }

  // ─── Main Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isSearching = _currentQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildTopAppBar(isSearching),
      body: isSearching
          ? _buildActiveResultsView()
          : _buildPreSearchView(),
    );
  }

  // ─── Top App Bar ───────────────────────────────────────────────────────────

  PreferredSizeWidget _buildTopAppBar(bool isSearching) {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _mint, size: 22),
        onPressed: () => Navigator.maybePop(context),
      ),
      titleSpacing: 0,
      title: Container(
        height: 42,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSearching ? _forest : _borderHairline,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search, color: _stoneGrey, size: 20),
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
                decoration: const InputDecoration(
                  hintText: "Search your dog's Timeline...",
                  hintStyle: TextStyle(
                    color: Color(0x66A7B0AB),
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: _executeSearch,
                onChanged: (val) {
                  setState(() {
                    _currentQuery = val;
                  });
                  if (_currentQuery.isNotEmpty) {
                    _chartAnimController.forward(from: 0.0);
                  }
                },
              ),
            ),
            if (isSearching)
              IconButton(
                icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                onPressed: _clearSearch,
              ),
          ],
        ),
      ),
      actions: [
        if (isSearching)
          IconButton(
            tooltip: 'Filter Timeline',
            icon: const Icon(Icons.tune, color: _mint, size: 22),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineFiltersScreen(),
                ),
              );
            },
          )
        else
          TextButton(
            onPressed: () => Navigator.maybePop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _stoneGrey, fontSize: 13),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: _borderHairline, height: 1),
      ),
    );
  }

  // ===========================================================================
  // STATE 1: PRE-SEARCH STATE (Figma Image 1)
  // ===========================================================================

  Widget _buildPreSearchView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 672),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Search Toggles Card
              _buildSearchTogglesCard(),
              const SizedBox(height: 16),

              // 2. Saved Searches Card
              _buildSavedSearchesCard(),
              const SizedBox(height: 16),

              // 3. Recent Searches Card
              _buildRecentSearchesCard(),
              const SizedBox(height: 16),

              // 4. Popular Searches in Atlas's Timeline
              _buildPopularSearchesCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Search Toggles Card (Figma Item 1) ─────────────────────────────────────

  Widget _buildSearchTogglesCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Notes',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Switch(
                  value: _searchNotes,
                  activeThumbColor: _mint,
                  activeTrackColor: _forest,
                  inactiveThumbColor: _stoneGrey,
                  inactiveTrackColor: _surfaceVariant,
                  onChanged: (val) => setState(() => _searchNotes = val),
                ),
              ],
            ),
          ),
          Container(color: _borderHairline, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Attachment Names',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Switch(
                  value: _searchAttachments,
                  activeThumbColor: _mint,
                  activeTrackColor: _forest,
                  inactiveThumbColor: _stoneGrey,
                  inactiveTrackColor: _surfaceVariant,
                  onChanged: (val) => setState(() => _searchAttachments = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Saved Searches Card (Figma Item 2) ─────────────────────────────────────

  Widget _buildSavedSearchesCard() {
    if (_savedSearches.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SAVED SEARCHES',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedSearches.length,
            separatorBuilder: (_, i) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(color: _borderHairline, height: 1),
                ),
            itemBuilder: (ctx, index) {
              final term = _savedSearches[index];
              return InkWell(
                onTap: () => _executeSearch(term),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bookmark, color: _forest, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            term,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.chevron_right, color: _mint, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Recent Searches Card (Figma Item 3) ─────────────────────────────────────

  Widget _buildRecentSearchesCard() {
    if (_recentSearches.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              InkWell(
                onTap: () => setState(() => _recentSearches.clear()),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentSearches.length,
            separatorBuilder: (_, i) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(color: _borderHairline, height: 1),
                ),
            itemBuilder: (ctx, index) {
              final term = _recentSearches[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _executeSearch(term),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, color: _mint, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              term,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: _mint, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _recentSearches.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Popular Searches Card (Figma Item 4) ───────────────────────────────────

  Widget _buildPopularSearchesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "POPULAR IN ATLAS'S TIMELINE",
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.8,
            ),
            itemCount: _popularSuggestions.length,
            itemBuilder: (ctx, index) {
              final term = _popularSuggestions[index];
              return InkWell(
                onTap: () => _executeSearch(term),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderHairline, width: 1),
                  ),
                  child: Text(
                    term,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
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

  // ===========================================================================
  // STATE 2: ACTIVE RESULTS STATE (Figma Image 2)
  // ===========================================================================

  Widget _buildActiveResultsView() {
    final results = _filteredResults;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 672),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Horizontal Category Filter Chips Row
              _buildCategoryChipsRow(),

              // 2. Interactive Animated Category Breakdown Graph
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInteractiveSearchDistributionChart(),
              ),

              // 3. Results Count & Relevance Sorting Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${results.length} RESULTS FOR "${_currentQuery.toUpperCase()}"',
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    PopupMenuButton<String>(
                      color: _carbon,
                      onSelected: (val) => setState(() => _selectedSort = val),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'Relevance', child: Text('Relevance', style: TextStyle(color: _offWhite))),
                        const PopupMenuItem(value: 'Newest', child: Text('Newest First', style: TextStyle(color: _offWhite))),
                        const PopupMenuItem(value: 'Oldest', child: Text('Oldest First', style: TextStyle(color: _offWhite))),
                      ],
                      child: Row(
                        children: [
                          Text(
                            _selectedSort,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_vert, color: _stoneGrey, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Results Feed
              if (results.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderHairline, width: 1),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off, color: _stoneGrey, size: 36),
                      const SizedBox(height: 12),
                      Text(
                        'No results found for "$_currentQuery"',
                        style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Try searching for "Recall", "Drills", "Health", or "Park"',
                        style: TextStyle(color: _stoneGrey, fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: results.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    final item = results[index];
                    return _buildSearchResultCard(item);
                  },
                ),

              const SizedBox(height: 16),

              // 5. Save Search Action Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderHairline, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bookmark_outline, color: _stoneGrey, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Save "$_currentQuery" as a saved search',
                            style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _saveCurrentSearch,
                        child: Text(
                          _savedSearches.contains(_currentQuery) ? 'Saved' : 'Save',
                          style: TextStyle(
                            color: _savedSearches.contains(_currentQuery) ? _mintLight : _mint,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  // ─── Category Filter Chips Row ──────────────────────────────────────────────

  Widget _buildCategoryChipsRow() {
    final categories = [
      {'label': 'All', 'dot': null},
      {'label': 'Training', 'dot': _alpineBlue},
      {'label': 'Health', 'dot': _healthDot},
      {'label': 'S&C', 'dot': _scDot},
      {'label': 'Goals', 'dot': _goalsDot},
      {'label': 'Media', 'dot': _mediaDot},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _borderHairline, width: 1)),
      ),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, i) => const SizedBox(width: 8),
          itemBuilder: (ctx, index) {
            final cat = categories[index];
            final label = cat['label'] as String;
            final dotColor = cat['dot'] as Color?;
            final isSelected = _selectedCategoryFilter == label;

            return InkWell(
              onTap: () {
                setState(() => _selectedCategoryFilter = label);
                _chartAnimController.forward(from: 0.2);
              },
              borderRadius: BorderRadius.circular(9999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: isSelected ? _forest : _borderHairline,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dotColor != null) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? _mintLight : _offWhite,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Interactive Animated Category Breakdown Graph ──────────────────────────

  Widget _buildInteractiveSearchDistributionChart() {
    final categories = ['Training', 'Health', 'S&C', 'Goals', 'Media'];
    final colors = [_alpineBlue, _healthDot, _scDot, _goalsDot, _mediaDot];

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => _showInteractiveChart = !_showInteractiveChart),
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    const Text(
                      'MATCH FREQUENCY BY CATEGORY',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _showInteractiveChart ? Icons.expand_less : Icons.expand_more,
                      color: _stoneGrey,
                      size: 18,
                    ),
                  ],
                ),
              ),
              const Text(
                'Tap bar to filter',
                style: TextStyle(color: _stoneGrey, fontSize: 11),
              ),
            ],
          ),

          if (_showInteractiveChart) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: AnimatedBuilder(
                animation: _chartCurveAnimation,
                builder: (context, _) {
                  return BarChart(
                    BarChartData(
                      maxY: 6,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => _obsidian,
                          tooltipBorder: const BorderSide(color: _borderHairline),
                          tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final catName = categories[groupIndex];
                            return BarTooltipItem(
                              '$catName\n',
                              const TextStyle(color: _offWhite, fontWeight: FontWeight.bold, fontSize: 11),
                              children: [
                                TextSpan(
                                  text: '${rod.toY.toInt()} matches',
                                  style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event is FlTapUpEvent && response != null && response.spot != null) {
                            final index = response.spot!.touchedBarGroupIndex;
                            if (index >= 0 && index < categories.length) {
                              setState(() {
                                _selectedCategoryFilter =
                                    _selectedCategoryFilter == categories[index]
                                        ? 'All'
                                        : categories[index];
                              });
                            }
                          }
                          setState(() {
                            if (response == null || response.spot == null) {
                              _touchedGroupIndex = null;
                            } else {
                              _touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                            }
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx >= 0 && idx < categories.length) {
                                final isSelected =
                                    _selectedCategoryFilter == categories[idx] ||
                                    _selectedCategoryFilter == 'All';
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    categories[idx],
                                    style: TextStyle(
                                      color: isSelected ? _offWhite : _stoneGrey,
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(categories.length, (idx) {
                        final cat = categories[idx];
                        final rawCount = _countForCategory(cat);
                        final animatedY = rawCount * _chartCurveAnimation.value;
                        final isSelected =
                            _selectedCategoryFilter == cat || _selectedCategoryFilter == 'All';
                        final isTouched = _touchedGroupIndex == idx;

                        return BarChartGroupData(
                          x: idx,
                          barRods: [
                            BarChartRodData(
                              toY: animatedY,
                              color: isSelected ? colors[idx] : colors[idx].withValues(alpha: 0.25),
                              width: isTouched ? 22 : 18,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 6,
                                color: _surfaceDim,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Search Result Card (Figma Card with <mark> highlighting) ───────────────

  Widget _buildSearchResultCard(TimelineSearchResultItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TimelineEventDetailsScreen(
              initialVariant: item.category == 'Health'
                  ? TimelineEventVariant.health
                  : TimelineEventVariant.training,
              initialTitle: item.title,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderHairline, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icon Box
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHighlightedRichText(
                    item.title,
                    _currentQuery,
                    baseStyle: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildHighlightedRichText(
                    item.snippet,
                    _currentQuery,
                    baseStyle: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.typeLabel} • ${item.timeAgo}',
                    style: const TextStyle(
                      color: Color(0x99A7B0AB),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
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

  // ─── Highlighted Text Widget (<mark> equivalent) ───────────────────────────

  Widget _buildHighlightedRichText(
    String fullText,
    String query, {
    required TextStyle baseStyle,
  }) {
    if (query.isEmpty) {
      return Text(fullText, style: baseStyle);
    }

    final spans = <InlineSpan>[];
    final lowerFull = fullText.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    while (true) {
      final index = lowerFull.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: fullText.substring(start), style: baseStyle));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(
          text: fullText.substring(start, index),
          style: baseStyle,
        ));
      }

      final matchText = fullText.substring(index, index + query.length);
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: _forest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Text(
              matchText,
              style: baseStyle.copyWith(
                color: _mintLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );

      start = index + query.length;
    }

    return RichText(text: TextSpan(children: spans));
  }
}
