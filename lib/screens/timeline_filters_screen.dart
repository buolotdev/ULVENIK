import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Result returned when filters are applied
class TimelineFilterResult {
  final Set<String> categories;
  final String dateRange;
  final String dog;
  final int matchCount;
  final bool hasActiveFilters;

  const TimelineFilterResult({
    required this.categories,
    required this.dateRange,
    required this.dog,
    required this.matchCount,
    required this.hasActiveFilters,
  });
}

/// Saved Filter Preset Model
class SavedFilterPreset {
  final String id;
  final String name;
  final String description;
  final Set<String> categories;
  final String dateRange;
  final String dog;

  const SavedFilterPreset({
    required this.id,
    required this.name,
    required this.description,
    required this.categories,
    required this.dateRange,
    this.dog = 'All Dogs',
  });
}

/// Timeline Filters Screen (Batch 6 - Line 176: Partially Applied State)
/// Matches Figma Frame with:
/// - Top Navigation with "Reset All"
/// - Horizontal Active Filter Chips Row with close icons (Training, Health, Last 30 Days)
/// - Saved Filters Card (Training Only, Health History, Competition Results) with Apply buttons
/// - Event Categories Card with 2-column grid and dot badges
/// - Interactive Animated Event Breakdown Graph
/// - Date Range and Dog Selection
/// - Sticky Bottom Bar with "Reset" and "Apply (186)"
class TimelineFiltersScreen extends StatefulWidget {
  final Set<String>? initialCategories;
  final String? initialDateRange;
  final String? initialDog;

  const TimelineFiltersScreen({
    super.key,
    this.initialCategories,
    this.initialDateRange,
    this.initialDog,
  });

  @override
  State<TimelineFiltersScreen> createState() => _TimelineFiltersScreenState();
}

class _TimelineFiltersScreenState extends State<TimelineFiltersScreen>
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
  static const Color _healthDot = Color(0xFFFFB4AB);
  static const Color _scDot = Color(0xFFB6CCB5);
  static const Color _goalsDot = Color(0xFFFFD1CC);
  static const Color _mediaDot = Color(0xFFA7B0AB);
  static const Color _gold = Color(0xFFF9A826);
  static const Color _borderHairline = Color(0x14FFFFFF);

  // ─── Filter State (Defaults to Partially Applied State in Figma) ─────────────
  late Set<String> _selectedCategories;
  late String _selectedDateRange;
  late String _selectedDog;

  // Accordion Section Expansion States
  bool _isSavedFiltersExpanded = true;
  bool _isCategoriesExpanded = true;
  bool _isDateRangeExpanded = false;
  bool _isDogsExpanded = false;
  bool _showAnalyticsChart = true;

  // Animation controller for the interactive bar chart
  late AnimationController _chartAnimController;
  late Animation<double> _chartCurveAnimation;
  int? _touchedBarIndex;

  // Saved Filter Presets
  late List<SavedFilterPreset> _savedPresets;

  // Mock Event Database for dynamic count calculations
  final List<Map<String, dynamic>> _mockEvents = [
    // Training events
    for (int i = 0; i < 112; i++)
      {
        'category': 'Training',
        'daysAgo': (i % 60),
        'dog': i % 2 == 0 ? 'Atlas' : 'Murphy',
      },
    // Health events
    for (int i = 0; i < 74; i++)
      {
        'category': 'Health',
        'daysAgo': (i % 45),
        'dog': i % 3 == 0 ? 'Atlas' : 'Freya',
      },
    // S&C events
    for (int i = 0; i < 48; i++)
      {
        'category': 'S&C',
        'daysAgo': (i % 90),
        'dog': i % 2 == 0 ? 'Atlas' : 'Murphy',
      },
    // Goals events
    for (int i = 0; i < 26; i++)
      {
        'category': 'Goals',
        'daysAgo': (i % 120),
        'dog': i % 2 == 0 ? 'Freya' : 'Atlas',
      },
    // Media events
    for (int i = 0; i < 35; i++)
      {
        'category': 'Media',
        'daysAgo': (i % 30),
        'dog': 'Atlas',
      },
    // Competition events
    for (int i = 0; i < 18; i++)
      {
        'category': 'Competition',
        'daysAgo': (i % 180),
        'dog': 'Freya',
      },
  ];

  @override
  void initState() {
    super.initState();

    // Default to Figma Partially Applied State:
    // Categories: Training, Health
    // Date Range: Last 30 Days
    _selectedCategories = widget.initialCategories != null
        ? Set<String>.from(widget.initialCategories!)
        : {'Training', 'Health'};

    _selectedDateRange = widget.initialDateRange ?? 'Last 30 Days';
    _selectedDog = widget.initialDog ?? 'All Dogs';

    // Animation Controller for Chart
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _chartCurveAnimation = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    // Init Presets matching Figma
    _savedPresets = [
      const SavedFilterPreset(
        id: 'preset-1',
        name: 'Training Only',
        description: 'Training events in last 7 days',
        categories: {'Training'},
        dateRange: 'Last 7 Days',
      ),
      const SavedFilterPreset(
        id: 'preset-2',
        name: 'Health History',
        description: 'All health related events',
        categories: {'Health'},
        dateRange: 'All Time',
      ),
      const SavedFilterPreset(
        id: 'preset-3',
        name: 'Competition Results',
        description: 'Last year competition events',
        categories: {'Competition'},
        dateRange: 'This Year',
      ),
    ];
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  // ─── Filter Calculations ────────────────────────────────────────────────────

  int get _calculatedMatchCount {
    int maxDays = 9999;
    if (_selectedDateRange == 'Today') {
      maxDays = 1;
    } else if (_selectedDateRange == 'Last 7 Days') {
      maxDays = 7;
    } else if (_selectedDateRange == 'Last 30 Days') {
      maxDays = 30;
    } else if (_selectedDateRange == 'Last 90 Days') {
      maxDays = 90;
    } else if (_selectedDateRange == 'This Year') {
      maxDays = 365;
    }

    return _mockEvents.where((e) {
      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(e['category'])) {
        return false;
      }
      if (e['daysAgo'] > maxDays) return false;
      if (_selectedDog != 'All Dogs' && e['dog'] != _selectedDog) return false;
      return true;
    }).length;
  }

  int _countForCategory(String cat) {
    int maxDays = 9999;
    if (_selectedDateRange == 'Today') {
      maxDays = 1;
    } else if (_selectedDateRange == 'Last 7 Days') {
      maxDays = 7;
    } else if (_selectedDateRange == 'Last 30 Days') {
      maxDays = 30;
    } else if (_selectedDateRange == 'Last 90 Days') {
      maxDays = 90;
    } else if (_selectedDateRange == 'This Year') {
      maxDays = 365;
    }

    return _mockEvents.where((e) {
      if (e['category'] != cat) return false;
      if (e['daysAgo'] > maxDays) return false;
      if (_selectedDog != 'All Dogs' && e['dog'] != _selectedDog) return false;
      return true;
    }).length;
  }

  bool get _hasActiveFilters {
    return _selectedCategories.isNotEmpty ||
        _selectedDateRange != 'All Time' ||
        _selectedDog != 'All Dogs';
  }

  void _resetAllFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedDateRange = 'All Time';
      _selectedDog = 'All Dogs';
    });
    _chartAnimController.forward(from: 0.0);
  }

  void _toggleCategory(String cat) {
    setState(() {
      if (_selectedCategories.contains(cat)) {
        _selectedCategories.remove(cat);
      } else {
        _selectedCategories.add(cat);
      }
    });
    _chartAnimController.forward(from: 0.2);
  }

  void _applyPreset(SavedFilterPreset preset) {
    setState(() {
      _selectedCategories = Set.from(preset.categories);
      _selectedDateRange = preset.dateRange;
      _selectedDog = preset.dog;
    });
    _chartAnimController.forward(from: 0.0);
  }

  void _showSavePresetDialog() {
    final nameCtrl = TextEditingController(
      text: _selectedCategories.isNotEmpty
          ? '${_selectedCategories.join(', ')} Filter'
          : 'Custom Filter',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _borderHairline),
        ),
        title: const Text(
          'Save Current Filter Preset',
          style: TextStyle(
            color: _offWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Give your filter preset a memorable name:',
              style: TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameCtrl,
              autofocus: true,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: _surfaceDim,
                hintText: 'e.g. Weekly Conditioning',
                hintStyle: const TextStyle(color: Color(0x66A7B0AB)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _borderHairline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _borderHairline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _mint),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _savedPresets.insert(
                    0,
                    SavedFilterPreset(
                      id: 'preset-${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      description:
                          '${_selectedCategories.isEmpty ? "All categories" : _selectedCategories.join(", ")} · $_selectedDateRange',
                      categories: Set.from(_selectedCategories),
                      dateRange: _selectedDateRange,
                      dog: _selectedDog,
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save Preset'),
          ),
        ],
      ),
    );
  }

  void _applyAndReturn() {
    final result = TimelineFilterResult(
      categories: Set.from(_selectedCategories),
      dateRange: _selectedDateRange,
      dog: _selectedDog,
      matchCount: _calculatedMatchCount,
      hasActiveFilters: _hasActiveFilters,
    );
    Navigator.of(context).pop(result);
  }

  // ─── Build Method ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final matchCount = _calculatedMatchCount;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildTopAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 672),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Horizontal Active Filter Chips Row (Figma Top)
                _buildActiveFilterChipsRow(),
                const SizedBox(height: 16),

                // 2. Saved Filters Card (Figma Item 1)
                _buildSavedFiltersCard(),
                const SizedBox(height: 16),

                // 3. Event Categories Card (Figma Item 2: 2-column grid)
                _buildEventCategoriesCard(),
                const SizedBox(height: 16),

                // 4. Interactive Animated Volume Distribution Chart
                _buildInteractiveDistributionGraph(),
                const SizedBox(height: 16),

                // 5. Date Range Selection Card
                _buildDateRangeCard(),
                const SizedBox(height: 16),

                // 6. Dog Selection Card
                _buildDogSelectorCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildStickyBottomBar(matchCount),
    );
  }

  // ─── Top Navigation Bar (Figma Header) ──────────────────────────────────────

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _stoneGrey, size: 24),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Timeline Filters',
        style: TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: _hasActiveFilters ? _resetAllFilters : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Reset All',
              style: TextStyle(
                color: _hasActiveFilters ? _mint : _stoneGrey.withValues(alpha: 0.4),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: _borderHairline, height: 1),
      ),
    );
  }

  // ─── Active Filter Chips Row (Figma: Training ×, Health ×, Last 30 Days ×) ──

  Widget _buildActiveFilterChipsRow() {
    final List<Map<String, dynamic>> chips = [];

    // Category chips
    for (final cat in _selectedCategories) {
      chips.add({
        'label': cat,
        'onRemove': () => _toggleCategory(cat),
      });
    }

    // Date range chip
    if (_selectedDateRange != 'All Time') {
      chips.add({
        'label': _selectedDateRange,
        'onRemove': () => setState(() => _selectedDateRange = 'All Time'),
      });
    }

    // Dog chip
    if (_selectedDog != 'All Dogs') {
      chips.add({
        'label': _selectedDog,
        'onRemove': () => setState(() => _selectedDog = 'All Dogs'),
      });
    }

    if (chips.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderHairline, width: 1),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: _stoneGrey),
            SizedBox(width: 8),
            Text(
              'No active filters — showing all timeline events',
              style: TextStyle(color: _stoneGrey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (ctx, index) {
          final chip = chips[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _forest,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: _forest, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chip['label'] as String,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: chip['onRemove'] as VoidCallback,
                  borderRadius: BorderRadius.circular(9999),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF7A8F7A),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Saved Filters Card (Figma Card 1) ──────────────────────────────────────

  Widget _buildSavedFiltersCard() {
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
          // Header with expand/collapse toggle & "+ Save Current" action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(
                    () => _isSavedFiltersExpanded = !_isSavedFiltersExpanded),
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    const Text(
                      'SAVED FILTERS',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _isSavedFiltersExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: _stoneGrey,
                      size: 18,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _showSavePresetDialog,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_add_outlined,
                          color: _mint, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Save Current',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_isSavedFiltersExpanded) ...[
            const SizedBox(height: 14),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedPresets.length,
              separatorBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(color: _borderHairline, height: 1),
              ),
              itemBuilder: (ctx, index) {
                final preset = _savedPresets[index];
                final isCurrent = _isPresetActive(preset);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.filter_list,
                            color: Color(0xFF7A8F7A),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  preset.name,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  preset.description,
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => _applyPreset(preset),
                      child: Text(
                        isCurrent ? 'Active' : 'Apply',
                        style: TextStyle(
                          color: isCurrent ? _mintLight : _mint,
                          fontSize: 13,
                          fontWeight: isCurrent
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  bool _isPresetActive(SavedFilterPreset preset) {
    if (_selectedCategories.length != preset.categories.length) return false;
    if (!_selectedCategories.containsAll(preset.categories)) return false;
    if (_selectedDateRange != preset.dateRange) return false;
    return true;
  }

  // ─── Event Categories Card (Figma Card 2: 2-Column Grid) ────────────────────

  Widget _buildEventCategoriesCard() {
    final categories = [
      {
        'key': 'Training',
        'label': 'Training',
        'dotColor': _alpineBlue,
        'isLocked': false,
      },
      {
        'key': 'Health',
        'label': 'Health',
        'dotColor': _healthDot,
        'isLocked': false,
      },
      {
        'key': 'S&C',
        'label': 'S&C',
        'dotColor': _scDot,
        'isLocked': false,
      },
      {
        'key': 'Goals',
        'label': 'Goals',
        'dotColor': _goalsDot,
        'isLocked': false,
      },
      {
        'key': 'Media',
        'label': 'Media',
        'dotColor': _mediaDot,
        'isLocked': false,
      },
      {
        'key': 'Competition',
        'label': 'Competition',
        'dotColor': _gold,
        'isLocked': true,
        'badge': 'Sport Pack',
      },
    ];

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
          // Header with Expand Toggle
          InkWell(
            onTap: () => setState(
                () => _isCategoriesExpanded = !_isCategoriesExpanded),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EVENT CATEGORIES',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Icon(
                  _isCategoriesExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: _stoneGrey,
                  size: 20,
                ),
              ],
            ),
          ),

          if (_isCategoriesExpanded) ...[
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.7,
              ),
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                final cat = categories[index];
                final key = cat['key'] as String;
                final label = cat['label'] as String;
                final dotColor = cat['dotColor'] as Color;
                final isLocked = cat['isLocked'] as bool;
                final badge = cat['badge'] as String?;
                final isSelected = _selectedCategories.contains(key);

                if (isLocked) {
                  return InkWell(
                    onTap: () => _toggleCategory(key),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? _forest : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? _forest : _borderHairline,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSelected) ...[
                                Container(
                                  width: 8,
                                  height: 8,
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
                                  color: isSelected ? _offWhite : _stoneGrey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _surfaceDim,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: _borderHairline),
                                ),
                                child: Text(
                                  badge!,
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
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

                return InkWell(
                  onTap: () => _toggleCategory(key),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? _forest : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _forest : _borderHairline,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: TextStyle(
                                color: isSelected ? _offWhite : const Color(0xFFE1E3E0),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // ─── Interactive Animated Volume Distribution Graph ────────────────────────

  Widget _buildInteractiveDistributionGraph() {
    final categories = ['Training', 'Health', 'S&C', 'Goals', 'Media', 'Competition'];
    final colors = [
      _alpineBlue,
      _healthDot,
      _scDot,
      _goalsDot,
      _mediaDot,
      _gold,
    ];

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
              InkWell(
                onTap: () => setState(
                    () => _showAnalyticsChart = !_showAnalyticsChart),
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    const Text(
                      'FILTERED EVENT BREAKDOWN',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _showAnalyticsChart
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: _stoneGrey,
                      size: 18,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$_calculatedMatchCount Matches',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (_showAnalyticsChart) ...[
            const SizedBox(height: 6),
            const Text(
              'Tap any column below to toggle category filtering:',
              style: TextStyle(color: _stoneGrey, fontSize: 12),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 160,
              child: AnimatedBuilder(
                animation: _chartCurveAnimation,
                builder: (context, _) {
                  return BarChart(
                    BarChartData(
                      maxY: 120,
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
                              const TextStyle(
                                color: _offWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: '${rod.toY.toInt()} events',
                                  style: const TextStyle(
                                    color: _mint,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event is FlTapUpEvent &&
                              response != null &&
                              response.spot != null) {
                            final index = response.spot!.touchedBarGroupIndex;
                            if (index >= 0 && index < categories.length) {
                              _toggleCategory(categories[index]);
                            }
                          }
                          setState(() {
                            if (response == null || response.spot == null) {
                              _touchedBarIndex = null;
                            } else {
                              _touchedBarIndex =
                                  response.spot!.touchedBarGroupIndex;
                            }
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) {
                              if (val == 0 || val == 50 || val == 100) {
                                return Text(
                                  '${val.toInt()}',
                                  style: const TextStyle(
                                    color: Color(0x66A7B0AB),
                                    fontSize: 10,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx >= 0 && idx < categories.length) {
                                final isSelected =
                                    _selectedCategories.contains(categories[idx]);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    categories[idx].substring(0, 3),
                                    style: TextStyle(
                                      color: isSelected ? _offWhite : _stoneGrey,
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 40,
                        getDrawingHorizontalLine: (val) => FlLine(
                          color: _borderHairline,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(categories.length, (idx) {
                        final cat = categories[idx];
                        final rawCount = _countForCategory(cat);
                        final animatedY =
                            rawCount * _chartCurveAnimation.value;
                        final isSelected =
                            _selectedCategories.contains(cat);
                        final isTouched = _touchedBarIndex == idx;

                        return BarChartGroupData(
                          x: idx,
                          barRods: [
                            BarChartRodData(
                              toY: animatedY,
                              color: isSelected
                                  ? colors[idx]
                                  : colors[idx].withValues(alpha: 0.3),
                              width: isTouched ? 22 : 18,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(5)),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 120,
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

  // ─── Date Range Selection Card ──────────────────────────────────────────────

  Widget _buildDateRangeCard() {
    final ranges = [
      'All Time',
      'Today',
      'Last 7 Days',
      'Last 30 Days',
      'Last 90 Days',
      'This Year',
    ];

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
          InkWell(
            onTap: () => setState(
                () => _isDateRangeExpanded = !_isDateRangeExpanded),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'DATE RANGE',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedDateRange,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isDateRangeExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: _stoneGrey,
                  size: 20,
                ),
              ],
            ),
          ),

          if (_isDateRangeExpanded) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ranges.map((range) {
                final isSelected = _selectedDateRange == range;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedDateRange = range);
                    _chartAnimController.forward(from: 0.2);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _forest : _surfaceDim,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _forest : _borderHairline,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      range,
                      style: TextStyle(
                        color: isSelected ? _offWhite : _stoneGrey,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Dog Selection Card ─────────────────────────────────────────────────────

  Widget _buildDogSelectorCard() {
    final dogs = ['All Dogs', 'Atlas', 'Murphy', 'Freya'];

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
          InkWell(
            onTap: () =>
                setState(() => _isDogsExpanded = !_isDogsExpanded),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'DOG FILTER',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedDog,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isDogsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: _stoneGrey,
                  size: 20,
                ),
              ],
            ),
          ),

          if (_isDogsExpanded) ...[
            const SizedBox(height: 14),
            Row(
              children: dogs.map((dog) {
                final isSelected = _selectedDog == dog;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedDog = dog);
                        _chartAnimController.forward(from: 0.2);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? _forest : _surfaceDim,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? _forest : _borderHairline,
                            width: 1,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            dog,
                            style: TextStyle(
                              color: isSelected ? _offWhite : _stoneGrey,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Sticky Bottom Bar (Figma: Reset & Apply (186)) ─────────────────────────

  Widget _buildStickyBottomBar(int matchCount) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(top: BorderSide(color: _borderHairline, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Reset Button
          TextButton(
            onPressed: _hasActiveFilters ? _resetAllFilters : null,
            child: Text(
              'Reset',
              style: TextStyle(
                color: _hasActiveFilters
                    ? _stoneGrey
                    : _stoneGrey.withValues(alpha: 0.4),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Apply (186) Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _applyAndReturn,
              child: Text(
                'Apply ($matchCount)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
