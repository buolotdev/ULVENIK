import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'activity_details_screen.dart';
import 'create_activity_screen.dart';
import '../widgets/custom_snackbar.dart';

class LibraryActivityItem {
  final String id;
  String name;
  String description;
  int sessionCount;
  String lastTrained;
  int? streakDays;
  bool isFavourite;
  IconData icon;
  String category;
  String equipment;
  int defaultDurationMinutes;
  Color color;

  LibraryActivityItem({
    required this.id,
    required this.name,
    required this.description,
    required this.sessionCount,
    required this.lastTrained,
    this.streakDays,
    this.isFavourite = false,
    required this.icon,
    required this.category,
    required this.equipment,
    this.defaultDurationMinutes = 25,
    this.color = const Color(0xFF2E6B57),
  });

  LibraryActivityItem copyWith({
    String? name,
    String? description,
    int? sessionCount,
    String? lastTrained,
    int? streakDays,
    bool? isFavourite,
    IconData? icon,
    String? category,
    String? equipment,
    int? defaultDurationMinutes,
    Color? color,
  }) {
    return LibraryActivityItem(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      sessionCount: sessionCount ?? this.sessionCount,
      lastTrained: lastTrained ?? this.lastTrained,
      streakDays: streakDays ?? this.streakDays,
      isFavourite: isFavourite ?? this.isFavourite,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      equipment: equipment ?? this.equipment,
      defaultDurationMinutes:
          defaultDurationMinutes ?? this.defaultDurationMinutes,
      color: color ?? this.color,
    );
  }
}

class ActivityLibraryScreen extends StatefulWidget {
  final bool initialEmpty;
  const ActivityLibraryScreen({super.key, this.initialEmpty = false});

  @override
  State<ActivityLibraryScreen> createState() => _ActivityLibraryScreenState();
}

class _ActivityLibraryScreenState extends State<ActivityLibraryScreen>
    with SingleTickerProviderStateMixin {
  // Theme Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceContainer = Color(0xFF1D201F);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _muted = Color(0xFFA7B0AB);
  static const _textVariant = Color(0xFFBFC9C3);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  bool _showChart = false;
  String _selectedFilter = 'Recently Used'; // 'Recently Used', 'Alphabetical', 'Most Sessions', 'Highest Streak'
  String? _selectedCategory; // null = all
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;
  int _touchedBarIndex = -1;

  late List<LibraryActivityItem> _activities;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    _initMockActivities();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initMockActivities() {
    _activities = [
      LibraryActivityItem(
        id: 'act-1',
        name: 'Swimming Fitness',
        description: 'Open water endurance work',
        sessionCount: 48,
        lastTrained: 'Yesterday',
        streakDays: 12,
        isFavourite: true,
        icon: Icons.pool,
        category: 'Water Work',
        equipment: 'Canine Floatation Vest & Line',
        defaultDurationMinutes: 30,
      ),
      LibraryActivityItem(
        id: 'act-2',
        name: 'Treadmill Intervals',
        description: 'High intensity run',
        sessionCount: 24,
        lastTrained: '3 days ago',
        streakDays: null,
        isFavourite: true,
        icon: Icons.directions_run,
        category: 'Running',
        equipment: 'Dog Slatmill / Motorized Treadmill',
        defaultDurationMinutes: 20,
      ),
      LibraryActivityItem(
        id: 'act-3',
        name: 'Weighted Carries',
        description: 'Progressive load pack work',
        sessionCount: 18,
        lastTrained: '1 week ago',
        streakDays: null,
        isFavourite: false,
        icon: Icons.fitness_center,
        category: 'Strength',
        equipment: 'Weighted Saddlebags (2.5kg)',
        defaultDurationMinutes: 35,
      ),
      LibraryActivityItem(
        id: 'act-4',
        name: 'Balance Board Work',
        description: 'Core proprioception & stabilizer drills',
        sessionCount: 12,
        lastTrained: '2 weeks ago',
        streakDays: 5,
        isFavourite: false,
        icon: Icons.sports_gymnastics,
        category: 'Core',
        equipment: 'Circular Wobble Board',
        defaultDurationMinutes: 15,
      ),
      LibraryActivityItem(
        id: 'act-5',
        name: 'Agility Ladder',
        description: 'Footwork and hind leg coordination',
        sessionCount: 32,
        lastTrained: '2 days ago',
        streakDays: null,
        isFavourite: false,
        icon: Icons.grid_on,
        category: 'Agility',
        equipment: '10-Rung Ground Agility Ladder',
        defaultDurationMinutes: 25,
      ),
      LibraryActivityItem(
        id: 'act-6',
        name: 'Hill Sprints',
        description: 'Explosive uphill acceleration drills',
        sessionCount: 9,
        lastTrained: '1 month ago',
        streakDays: null,
        isFavourite: false,
        icon: Icons.terrain,
        category: 'Running',
        equipment: 'Sport Harness & 15m Long Line',
        defaultDurationMinutes: 20,
      ),
      LibraryActivityItem(
        id: 'act-7',
        name: 'Hydrotherapy Swim',
        description: 'Controlled resistance tank swim',
        sessionCount: 15,
        lastTrained: '4 days ago',
        streakDays: null,
        isFavourite: false,
        icon: Icons.waves,
        category: 'Water Work',
        equipment: 'Indoor Heated Hydro Tank',
        defaultDurationMinutes: 25,
      ),
      LibraryActivityItem(
        id: 'act-8',
        name: 'Core Stability',
        description: 'Dynamic balance and isometric holds',
        sessionCount: 21,
        lastTrained: 'Yesterday',
        streakDays: 3,
        isFavourite: false,
        icon: Icons.accessibility_new,
        category: 'Core',
        equipment: 'Inflatable K9 FitBone & Target Mat',
        defaultDurationMinutes: 15,
      ),
      LibraryActivityItem(
        id: 'act-9',
        name: 'Sled Pull',
        description: 'Heavy resistance drag for power development',
        sessionCount: 6,
        lastTrained: '2 weeks ago',
        streakDays: null,
        isFavourite: false,
        icon: Icons.drag_handle,
        category: 'Strength',
        equipment: 'X-Back Harness & Weighted Sled',
        defaultDurationMinutes: 30,
      ),
      LibraryActivityItem(
        id: 'act-10',
        name: 'Stair Climbing',
        description: 'Concentric and eccentric leg strength',
        sessionCount: 14,
        lastTrained: '5 days ago',
        streakDays: null,
        isFavourite: false,
        icon: Icons.stairs,
        category: 'Strength',
        equipment: 'Padded Y-Harness',
        defaultDurationMinutes: 20,
      ),
    ];
  }

  // Filtered & Sorted Lists
  List<LibraryActivityItem> get _filteredActivities {
    var list = _activities.where((act) {
      if (_searchQuery.isNotEmpty) {
        final matchesName = act.name.toLowerCase().contains(_searchQuery);
        final matchesDesc =
            act.description.toLowerCase().contains(_searchQuery);
        final matchesCat = act.category.toLowerCase().contains(_searchQuery);
        if (!matchesName && !matchesDesc && !matchesCat) return false;
      }
      if (_selectedCategory != null && act.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    switch (_selectedFilter) {
      case 'Alphabetical':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Most Sessions':
        list.sort((a, b) => b.sessionCount.compareTo(a.sessionCount));
        break;
      case 'Highest Streak':
        list.sort((a, b) => (b.streakDays ?? 0).compareTo(a.streakDays ?? 0));
        break;
      case 'Recently Used':
      default:
        // Keep initial mock order
        break;
    }

    return list;
  }

  List<LibraryActivityItem> get _favourites =>
      _filteredActivities.where((a) => a.isFavourite).toList();

  List<LibraryActivityItem> get _allOtherActivities =>
      _filteredActivities.where((a) => !a.isFavourite).toList();

  void _toggleFavourite(LibraryActivityItem item) {
    setState(() {
      item.isFavourite = !item.isFavourite;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackbar.show(
      context,
      message: item.isFavourite
          ? '${item.name} added to Favourites'
          : '${item.name} removed from Favourites',
      type: item.isFavourite ? SnackbarType.success : SnackbarType.info,
    );
  }

  void _showActivityDetails(LibraryActivityItem act) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityDetailsScreen(activity: act),
      ),
    );
  }

  Future<void> _openCreateActivityScreen() async {
    final newItem = await Navigator.of(context).push<LibraryActivityItem>(
      MaterialPageRoute(
        builder: (_) => const CreateActivityScreen(),
      ),
    );
    if (newItem != null && mounted) {
      setState(() {
        _activities.insert(0, newItem);
        _isEmpty = false;
      });
    }
  }

  void _showCategoryFilterSheet() {
    final categories = [
      'All Categories',
      'Water Work',
      'Running',
      'Strength',
      'Core',
      'Agility'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter by Category',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...categories.map((cat) {
              final isSelected = (cat == 'All Categories' &&
                      _selectedCategory == null) ||
                  cat == _selectedCategory;
              return ListTile(
                title: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? _mint : _offWhite,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: _mint)
                    : null,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  setState(() {
                    _selectedCategory = cat == 'All Categories' ? null : cat;
                  });
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showLearnDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: _hairlineSide,
        ),
        title: const Text('Activity Library',
            style: TextStyle(color: _offWhite, fontSize: 18)),
        content: const Text(
          'The Activity Library contains predefined and customized strength, power, sprint, and conditioning exercises.\n\nEach activity tracks completed sessions, streaks, and load volume to help ensure safe progressive overload for your dog.',
          style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: _mint)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // No duplicate bottomNavigationBar! Handled by MainLayout
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'ACTIVITY LIBRARY',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          // Animated Graph Toggle
          IconButton(
            tooltip: _showChart ? 'Hide Volume Chart' : 'Show Volume Chart',
            icon: Icon(
              _showChart ? Icons.bar_chart : Icons.bar_chart_outlined,
              color: _showChart ? _mint : _muted,
            ),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
                if (_showChart) {
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                }
              });
            },
          ),
          // Populated vs Empty Toggle
          IconButton(
            tooltip: _isEmpty
                ? 'Switch to Populated Library'
                : 'Switch to Empty Library',
            icon: Icon(
              _isEmpty ? Icons.fitness_center_outlined : Icons.fitness_center,
              color: _mint,
            ),
            onPressed: () {
              setState(() {
                _isEmpty = !_isEmpty;
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
            },
          ),
        ],
      ),
      body: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateActivityScreen,
        backgroundColor: _forest,
        foregroundColor: _offWhite,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE VIEW
  // ==========================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -math.pi / 4,
              child: const Icon(
                Icons.fitness_center,
                size: 48,
                color: _mint,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Activities Created',
              style: TextStyle(
                color: _offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Create your first Strength & Conditioning activity to begin building your dog's personalised conditioning programme.",
              style: TextStyle(
                color: _muted,
                fontSize: 14,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _openCreateActivityScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Create Activity',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _showLearnDialog,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Learn about the Activity Library',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: _mint),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED STATE VIEW
  // ==========================================
  Widget _buildPopulatedState() {
    final favourites = _favourites;
    final allActivities = _allOtherActivities;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          _buildSearchBar(),
          const SizedBox(height: 14),

          // Filter Row
          _buildFilterRow(),
          const SizedBox(height: 18),

          // Animated Volume & Frequency Chart (if enabled)
          if (_showChart) ...[
            _buildAnimatedVolumeChart(),
            const SizedBox(height: 22),
          ],

          // FAVOURITES Section
          if (favourites.isNotEmpty) ...[
            _buildSectionHeader('FAVOURITES'),
            const SizedBox(height: 10),
            _buildFavouritesContainer(favourites),
            const SizedBox(height: 24),
          ],

          // ALL ACTIVITIES Section
          _buildAllActivitiesHeader(allActivities.length),
          const SizedBox(height: 10),
          _buildAllActivitiesContainer(allActivities),
        ],
      ),
    );
  }

  // ------------------------------------------
  // SEARCH BAR
  // ------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _offWhite, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search activities...',
          hintStyle: const TextStyle(color: _muted, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _mint, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: _muted, size: 18),
                  onPressed: () => _searchController.clear(),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ------------------------------------------
  // FILTER ROW
  // ------------------------------------------
  Widget _buildFilterRow() {
    final filters = [
      'Recently Used',
      'Alphabetical',
      'Most Sessions',
      'Highest Streak',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          ...filters.map((f) {
            final isSelected = _selectedFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedFilter = f),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? _forest : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? null : _hairlineBorder,
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      color: isSelected ? _offWhite : _offWhite,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
          // Category Filter Pill with Down Arrow
          InkWell(
            onTap: _showCategoryFilterSheet,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _selectedCategory != null
                    ? _surfaceHigh
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: _selectedCategory != null
                    ? Border.all(color: _mint)
                    : _hairlineBorder,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCategory ?? 'Filter',
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: _mint, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // ANIMATED VOLUME & FREQUENCY CHART
  // ------------------------------------------
  Widget _buildAnimatedVolumeChart() {
    final topActivities = _activities.take(6).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVITY VOLUME BREAKDOWN',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Completed Sessions',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app, color: _mint, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Interactive',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (context, _) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 55,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => _surfaceHigh,
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        tooltipPadding: const EdgeInsets.all(8),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final act = topActivities[groupIndex];
                          return BarTooltipItem(
                            '${act.name}\n',
                            const TextStyle(
                              color: _mint,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: '${rod.toY.round()} sessions',
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        if (response != null &&
                            response.spot != null &&
                            event is FlTapUpEvent) {
                          setState(() {
                            _touchedBarIndex =
                                response.spot!.touchedBarGroupIndex;
                          });
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (val, meta) {
                            if (val % 20 == 0 && val > 0) {
                              return Text(
                                '${val.toInt()}',
                                style: const TextStyle(
                                    color: _muted, fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (index, meta) {
                            final idx = index.toInt();
                            if (idx < 0 || idx >= topActivities.length) {
                              return const SizedBox.shrink();
                            }
                            final words = topActivities[idx].name.split(' ');
                            final shortName = words.first;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                shortName.length > 6
                                    ? shortName.substring(0, 5)
                                    : shortName,
                                style: TextStyle(
                                  color: _touchedBarIndex == idx
                                      ? _mint
                                      : _muted,
                                  fontSize: 10,
                                  fontWeight: _touchedBarIndex == idx
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.white.withValues(alpha: 0.05),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(topActivities.length, (idx) {
                      final act = topActivities[idx];
                      final isTouched = _touchedBarIndex == idx;
                      final targetHeight = act.sessionCount.toDouble();
                      final animatedHeight = targetHeight * _chartProgress.value;

                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: animatedHeight,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(5)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: isTouched
                                  ? [_mint, const Color(0xFFB1F0D6)]
                                  : [_forest, _mint],
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
      ),
    );
  }

  // ------------------------------------------
  // FAVOURITES CONTAINER
  // ------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _muted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildFavouritesContainer(List<LibraryActivityItem> favourites) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: favourites.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
        itemBuilder: (ctx, idx) {
          final act = favourites[idx];
          return InkWell(
            onTap: () => _showActivityDetails(act),
            borderRadius: BorderRadius.vertical(
              top: idx == 0 ? const Radius.circular(12) : Radius.zero,
              bottom: idx == favourites.length - 1
                  ? const Radius.circular(12)
                  : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: _hairlineBorder,
                    ),
                    child: Icon(act.icon, color: _mint, size: 22),
                  ),
                  const SizedBox(width: 14),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                act.name,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              onTap: () => _toggleFavourite(act),
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.star, color: _mint, size: 20),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          act.description,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${act.sessionCount} Sessions · Last: ${act.lastTrained}',
                              style: const TextStyle(
                                color: _textVariant,
                                fontSize: 12,
                              ),
                            ),
                            if (act.streakDays != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: _mint,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${act.streakDays} Day Streak',
                                    style: const TextStyle(
                                      color: _mint,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------
  // ALL ACTIVITIES CONTAINER
  // ------------------------------------------
  Widget _buildAllActivitiesHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'ALL ACTIVITIES',
          style: TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          '$count Activities',
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAllActivitiesContainer(List<LibraryActivityItem> items) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: _hairlineBorder,
        ),
        child: const Center(
          child: Text(
            'No activities match your filters',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
        itemBuilder: (ctx, idx) {
          final act = items[idx];
          return InkWell(
            onTap: () => _showActivityDetails(act),
            borderRadius: BorderRadius.vertical(
              top: idx == 0 ? const Radius.circular(12) : Radius.zero,
              bottom: idx == items.length - 1
                  ? const Radius.circular(12)
                  : Radius.zero,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Icon box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _surfaceContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: _hairlineBorder,
                    ),
                    child: Icon(act.icon, color: _mint, size: 22),
                  ),
                  const SizedBox(width: 14),
                  // Title & Meta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          act.name,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${act.sessionCount} Sessions · Last: ${act.lastTrained}',
                              style: const TextStyle(
                                color: _textVariant,
                                fontSize: 12,
                              ),
                            ),
                            if (act.streakDays != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: _mint,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${act.streakDays} Day Streak',
                                    style: const TextStyle(
                                      color: _mint,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Actions: Favorite star and arrow
                  InkWell(
                    onTap: () => _toggleFavourite(act),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        act.isFavourite ? Icons.star : Icons.star_border,
                        color: act.isFavourite ? _mint : _muted,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right,
                    color: _muted,
                    size: 18,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
