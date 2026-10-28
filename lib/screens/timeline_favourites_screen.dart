import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_event_details_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_calendar_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _sage = Color(0xFF7A8F7A);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _favouriteGold = Color(0xFFB8920A);

// Category Colors
const Color _catTraining = Color(0xFF5D8FAF); // Alpine Blue
const Color _catCompetition = Color(0xFF48BB78); // Mint / Green
const Color _catGoals = Color(0xFFECC94B); // Yellow
const Color _catHealth = Color(0xFFE53E3E); // Red / Coral
const Color _catSC = Color(0xFFDD6B20); // Orange / S&C

class FavouriteEventItem {
  final String id;
  final String category;
  final Color categoryColor;
  final String title;
  final String date;
  final DateTime dateTime;
  final int photoCount;
  final int videoCount;
  final int? trophyCount;
  final bool hasLink;
  final bool hasDocument;
  final bool hasLocation;
  bool isFavourited;

  FavouriteEventItem({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.date,
    required this.dateTime,
    this.photoCount = 0,
    this.videoCount = 0,
    this.trophyCount,
    this.hasLink = false,
    this.hasDocument = false,
    this.hasLocation = false,
    this.isFavourited = true,
  });
}

class TimelineFavouritesScreen extends StatefulWidget {
  final bool initialEmpty;

  const TimelineFavouritesScreen({
    super.key,
    this.initialEmpty = false,
  });

  @override
  State<TimelineFavouritesScreen> createState() =>
      _TimelineFavouritesScreenState();
}

class _TimelineFavouritesScreenState extends State<TimelineFavouritesScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryFilter; // null = all, or 'Training', 'Competition', etc.
  String _sortOrder = 'Newest First'; // 'Newest First', 'Oldest First', 'Title A-Z', 'Category'

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  late List<FavouriteEventItem> _allEvents;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    _initSampleData();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initSampleData() {
    _allEvents = [
      FavouriteEventItem(
        id: 'fav-1',
        category: 'Training',
        categoryColor: _catTraining,
        title: 'Perfect Recall — 50m Distance Achievement',
        date: '27 Aug 2026',
        dateTime: DateTime(2026, 8, 27),
        photoCount: 4,
        videoCount: 1,
      ),
      FavouriteEventItem(
        id: 'fav-2',
        category: 'Competition',
        categoryColor: _catCompetition,
        title: 'IGP3 Regional Trial — 1st Place, Obedience',
        date: '14 Aug 2026',
        dateTime: DateTime(2026, 8, 14),
        trophyCount: 12,
        photoCount: 12,
      ),
      FavouriteEventItem(
        id: 'fav-3',
        category: 'Goals',
        categoryColor: _catGoals,
        title: '50 Successful Retrieves — Lifetime Milestone',
        date: '12 Aug 2026',
        dateTime: DateTime(2026, 8, 12),
        hasLink: true,
      ),
      FavouriteEventItem(
        id: 'fav-4',
        category: 'Health',
        categoryColor: _catHealth,
        title: 'Post-Surgery Recovery — Fully Cleared',
        date: '3 Apr 2026',
        dateTime: DateTime(2026, 4, 3),
        hasDocument: true,
      ),
      FavouriteEventItem(
        id: 'fav-5',
        category: 'S&C',
        categoryColor: _catSC,
        title: 'Agility Conditioning — Phase 1 Complete',
        date: '18 Mar 2026',
        dateTime: DateTime(2026, 3, 18),
      ),
      FavouriteEventItem(
        id: 'fav-6',
        category: 'Training',
        categoryColor: _catTraining,
        title: 'First Off-Lead Tracking Run',
        date: '3 Mar 2026',
        dateTime: DateTime(2026, 3, 3),
        photoCount: 1,
        hasLocation: true,
      ),
    ];
  }

  List<FavouriteEventItem> get _filteredEvents {
    if (_isEmptyState) return [];

    List<FavouriteEventItem> list = _allEvents.where((e) => e.isFavourited).toList();

    // Category filter
    if (_selectedCategoryFilter != null) {
      list = list.where((e) => e.category == _selectedCategoryFilter).toList();
    }

    // Search query filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) =>
          e.title.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.date.toLowerCase().contains(q)).toList();
    }

    // Sorting
    if (_sortOrder == 'Newest First') {
      list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (_sortOrder == 'Oldest First') {
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (_sortOrder == 'Title A-Z') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortOrder == 'Category') {
      list.sort((a, b) => a.category.compareTo(b.category));
    }

    return list;
  }

  void _toggleFavourite(FavouriteEventItem item) {
    setState(() {
      item.isFavourited = !item.isFavourited;
      // If all items removed, automatically show empty state
      if (_allEvents.every((e) => !e.isFavourited)) {
        _isEmptyState = true;
      }
    });
  }

  void _restoreAllFavourites() {
    setState(() {
      for (final e in _allEvents) {
        e.isFavourited = true;
      }
      _isEmptyState = false;
      _selectedCategoryFilter = null;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _showSortModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SORT FAVOURITES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              _buildSortOption(ctx, 'Newest First'),
              _buildSortOption(ctx, 'Oldest First'),
              _buildSortOption(ctx, 'Title A-Z'),
              _buildSortOption(ctx, 'Category'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext ctx, String label) {
    final bool isSelected = _sortOrder == label;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? _mint : _stoneGrey,
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? _offWhite : _stoneGrey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
      onTap: () {
        setState(() => _sortOrder = label);
        Navigator.pop(ctx);
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FILTER BY CATEGORY',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  _buildCategoryFilterChip('All Categories', null, null),
                  _buildCategoryFilterChip('Training', 'Training', _catTraining),
                  _buildCategoryFilterChip('Competition', 'Competition', _catCompetition),
                  _buildCategoryFilterChip('Goals', 'Goals', _catGoals),
                  _buildCategoryFilterChip('Health', 'Health', _catHealth),
                  _buildCategoryFilterChip('S&C', 'S&C', _catSC),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: _offWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilterChip(String label, String? categoryValue, Color? color) {
    final bool isSelected = _selectedCategoryFilter == categoryValue;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategoryFilter = categoryValue);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _forest : const Color(0xFF242A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _mint : _cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _offWhite : _stoneGrey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isEmptyState
            ? _buildEmptyState()
            : _buildPopulatedState(events),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _offWhite),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TimelineScreen()),
            );
          }
        },
      ),
      title: const Text(
        'FAVOURITES',
        style: TextStyle(
          color: _offWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Toggle Empty/Populated State',
          icon: Icon(
            _isEmptyState ? Icons.visibility : Icons.visibility_off_outlined,
            color: _mint,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _isEmptyState = !_isEmptyState;
              if (!_isEmptyState && _allEvents.every((e) => !e.isFavourited)) {
                _restoreAllFavourites();
              }
            });
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _stoneGrey),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF272B29)),
          ),
          onSelected: (val) {
            if (val == 'toggle') {
              setState(() => _isEmptyState = !_isEmptyState);
            } else if (val == 'restore') {
              _restoreAllFavourites();
            } else if (val == 'archive') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineArchiveScreen()),
              );
            } else if (val == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSettingsScreen()),
              );
            } else if (val == 'insights') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineInsightsScreen()),
              );
            } else if (val == 'stats') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineStatisticsScreen()),
              );
            } else if (val == 'export') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
              );
            } else if (val == 'dashboard') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineDashboardScreen()),
              );
            } else if (val == 'calendar') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineCalendarScreen()),
              );
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    _isEmptyState ? Icons.check_circle_outline : Icons.highlight_off,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isEmptyState ? 'Switch to Populated' : 'Switch to Empty State',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'restore',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Restore All Favourites',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(Icons.archive_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Archive',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Settings',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'insights',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Insights',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'stats',
              child: Row(
                children: [
                  Icon(Icons.insights, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Statistics',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.file_download_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Export',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'dashboard',
              child: Row(
                children: [
                  Icon(Icons.space_dashboard_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Dashboard',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _carbon,
                border: Border.all(color: _cardBorder),
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_border,
                  size: 44,
                  color: _stoneGrey,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Favourite Events',
              style: TextStyle(
                color: _offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Favourite your most important Timeline moments to access them quickly. Tap the heart icon on any event to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TimelineScreen()),
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Go to Timeline',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: _offWhite, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _restoreAllFavourites,
              child: const Text(
                'Load Demo Favourites',
                style: TextStyle(
                  color: _mint,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulatedState(List<FavouriteEventItem> events) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // 1. Search Box
              _buildSearchBar(),
              const SizedBox(height: 16),

              // 2. Metrics Bento Card
              _buildMetricsBentoCard(),
              const SizedBox(height: 16),

              // 3. Filter Chips Row
              _buildActiveFilterBar(),
              const SizedBox(height: 16),

              // 4. Section Header: FAVOURITE EVENTS + Count / Sort Label
              _buildSectionSubheader(events.length),
              const SizedBox(height: 12),

              // 5. Events List
              if (events.isEmpty)
                _buildNoSearchResults()
              else
                ...events.map((e) => _buildEventCard(e)),

              const SizedBox(height: 80), // Padding above sticky bottom bar
            ],
          ),
        ),

        // Sticky Sort / Filter Action Bar
        _buildStickySortFilterBar(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _offWhite, fontSize: 14),
        onChanged: (val) {
          setState(() => _searchQuery = val);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
          hintText: 'Search favourites...',
          hintStyle: const TextStyle(color: _stoneGrey, fontSize: 14),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : const Icon(Icons.mic_none, color: _stoneGrey, size: 20),
        ),
      ),
    );
  }

  Widget _buildMetricsBentoCard() {
    final activeCount = _allEvents.where((e) => e.isFavourited).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          // Top Row: 3 metric columns
          Row(
            children: [
              // Col 1: Saved moments
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$activeCount',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'SAVED\nMOMENTS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 38, color: const Color(0x1AFFFFFF)),

              // Col 2: Latest
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'LATEST',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 38, color: const Color(0x1AFFFFFF)),

              // Col 3: Oldest
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      "Aug '23",
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'OLDEST',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0x14FFFFFF), height: 1),
          const SizedBox(height: 12),

          // Bottom Row: ACROSS label and category color indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ACROSS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              Row(
                children: [
                  _buildBentoDot(_catTraining, 'Training'),
                  const SizedBox(width: 8),
                  _buildBentoDot(_catCompetition, 'Competition'),
                  const SizedBox(width: 8),
                  _buildBentoDot(_catGoals, 'Goals'),
                  const SizedBox(width: 8),
                  _buildBentoDot(_catHealth, 'Health'),
                  const SizedBox(width: 8),
                  _buildBentoDot(_catSC, 'S&C'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoDot(Color color, String category) {
    final bool isSelected = _selectedCategoryFilter == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategoryFilter == category) {
            _selectedCategoryFilter = null;
          } else {
            _selectedCategoryFilter = category;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: isSelected ? 12 : 8,
        height: isSelected ? 12 : 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6)]
              : null,
        ),
      ),
    );
  }

  Widget _buildActiveFilterBar() {
    return Row(
      children: [
        if (_selectedCategoryFilter != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF242A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(_selectedCategoryFilter!),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _selectedCategoryFilter!,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => setState(() => _selectedCategoryFilter = null),
                  child: const Icon(Icons.close, color: _stoneGrey, size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF242A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list, color: _mint, size: 13),
                SizedBox(width: 4),
                Text(
                  'All Categories',
                  style: TextStyle(color: _offWhite, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        const Spacer(),
        if (_selectedCategoryFilter != null || _searchQuery.isNotEmpty)
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryFilter = null;
                _searchController.clear();
                _searchQuery = '';
              });
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: _sage,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'Training':
        return _catTraining;
      case 'Competition':
        return _catCompetition;
      case 'Goals':
        return _catGoals;
      case 'Health':
        return _catHealth;
      case 'S&C':
        return _catSC;
      default:
        return _mint;
    }
  }

  Widget _buildSectionSubheader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'FAVOURITE EVENTS',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
        GestureDetector(
          onTap: _showSortModal,
          child: Row(
            children: [
              Text(
                '$count Events · $_sortOrder',
                style: const TextStyle(
                  color: _mint,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.swap_vert, color: _mint, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 48, color: _stoneGrey),
            const SizedBox(height: 12),
            const Text(
              'No matches found',
              style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'No favourites match "$_searchQuery"',
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategoryFilter = null;
                });
              },
              child: const Text('Reset Search & Filters', style: TextStyle(color: _mint)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(FavouriteEventItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TimelineEventDetailsScreen(
                  initialVariant: item.category == 'Health'
                      ? TimelineEventVariant.health
                      : TimelineEventVariant.training,
                  initialTitle: item.title,
                  eventId: item.id,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Category indicator + Heart icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: item.categoryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.category,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _toggleFavourite(item),
                      child: Icon(
                        item.isFavourited ? Icons.favorite : Icons.favorite_border,
                        color: item.isFavourited ? _favouriteGold : _stoneGrey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Event Title
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Event Date
                Text(
                  item.date,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),

                // Bottom Metadata Row with hairline divider
                const Divider(color: Color(0x14FFFFFF), height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Media badges
                    if (item.photoCount > 0) ...[
                      const Icon(Icons.camera_alt_outlined, color: _stoneGrey, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        '${item.photoCount}',
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      const SizedBox(width: 14),
                    ],
                    if (item.videoCount > 0) ...[
                      const Icon(Icons.videocam_outlined, color: _stoneGrey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${item.videoCount}',
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      const SizedBox(width: 14),
                    ],
                    if (item.trophyCount != null) ...[
                      const Icon(Icons.emoji_events_outlined, color: _stoneGrey, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        '${item.trophyCount}',
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      const SizedBox(width: 14),
                    ],
                    if (item.hasLink) ...[
                      const Icon(Icons.link, color: _stoneGrey, size: 16),
                      const SizedBox(width: 14),
                    ],
                    if (item.hasDocument) ...[
                      const Icon(Icons.description_outlined, color: _stoneGrey, size: 15),
                      const SizedBox(width: 14),
                    ],
                    if (item.hasLocation) ...[
                      const Icon(Icons.location_on_outlined, color: _stoneGrey, size: 15),
                      const SizedBox(width: 14),
                    ],

                    const Spacer(),
                    const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickySortFilterBar() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _showSortModal,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sort, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Sort',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 20, color: const Color(0x26FFFFFF)),
          Expanded(
            child: InkWell(
              onTap: _showFilterSheet,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tune, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
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

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note, 'Timeline', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineDashboardScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
