import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

/// Weight entry model
class WeightRecord {
  final String id;
  double weightKg;
  DateTime dateTime;
  double deltaKg;
  String? note;
  int bcsScore; // Body Condition Score 1-9
  final String recordedBy;
  final bool isManualNote;

  WeightRecord({
    required this.id,
    required this.weightKg,
    required this.dateTime,
    required this.deltaKg,
    this.note,
    this.bcsScore = 5,
    this.recordedBy = 'Owner',
    this.isManualNote = false,
  });
}

/// Dog profile model for switcher
class DogProfile {
  final String name;
  final String breed;
  final String age;
  final double targetWeightKg;
  final String avatarUrl;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.targetWeightKg,
    required this.avatarUrl,
  });
}

class WeightTrackerScreen extends StatefulWidget {
  final bool initialEmpty;
  const WeightTrackerScreen({super.key, this.initialEmpty = false});

  @override
  State<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  late bool _isEmpty;
  bool _isLoaded = false;
  bool _usePounds = false; // Metric vs Imperial
  bool _sortNewestFirst = true;

  String _selectedTimeframe = '1 Month';
  final List<String> _timeframes = ['1 Month', '3 Months', '6 Months', '1 Year', 'All Time'];

  // Active dog
  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3 yrs',
      targetWeightKg: 27.5,
      avatarUrl:
          'https://images.unsplash.com/photo-1588943211346-0908a1fb0b01?q=80&w=500&auto=format&fit=crop',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      targetWeightKg: 18.0,
      avatarUrl:
          'https://images.unsplash.com/photo-1601633512349-2e1d09e51f89?q=80&w=500&auto=format&fit=crop',
    ),
    DogProfile(
      name: 'Thor',
      breed: 'German Shepherd',
      age: '4 yrs',
      targetWeightKg: 34.0,
      avatarUrl:
          'https://images.unsplash.com/photo-1589941013453-ec89f33b5455?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  DogProfile get _activeDog => _dogs[_activeDogIndex];

  // Records state
  late List<WeightRecord> _records;

  // Selected chart point for tooltip
  int _selectedPointIndex = 1; // Default to point 1 (15 May 2025)

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeRecords();

    // Trigger chart entrance animation
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() => _isLoaded = true);
      }
    });
  }

  void _initializeRecords() {
    _records = [
      WeightRecord(
        id: 'rec_1',
        weightKg: 28.4,
        dateTime: DateTime(2025, 5, 21, 7, 30),
        deltaKg: 0.3,
        note: 'Morning weigh-in before training session. Great conditioning.',
        bcsScore: 5,
        isManualNote: true,
      ),
      WeightRecord(
        id: 'rec_2',
        weightKg: 28.1,
        dateTime: DateTime(2025, 5, 15, 8, 15),
        deltaKg: 0.0,
        note: 'Routine veterinary check scale.',
        bcsScore: 5,
        isManualNote: false,
      ),
      WeightRecord(
        id: 'rec_3',
        weightKg: 28.1,
        dateTime: DateTime(2025, 5, 1, 6, 45),
        deltaKg: -0.2,
        note: 'Post morning trail walk conditioning.',
        bcsScore: 5,
        isManualNote: false,
      ),
      WeightRecord(
        id: 'rec_4',
        weightKg: 28.3,
        dateTime: DateTime(2025, 4, 15, 7, 0),
        deltaKg: 0.1,
        note: 'Weekly weigh-in before morning feed.',
        bcsScore: 5,
        isManualNote: false,
      ),
      WeightRecord(
        id: 'rec_5',
        weightKg: 28.2,
        dateTime: DateTime(2025, 4, 1, 8, 30),
        deltaKg: 0.0,
        note: 'Start of seasonal conditioning.',
        bcsScore: 5,
        isManualNote: false,
      ),
    ];
  }

  // Unit conversion helpers
  double _toDisplayWeight(double kg) => _usePounds ? kg * 2.20462 : kg;
  String get _weightUnit => _usePounds ? 'lbs' : 'kg';

  String _formatWeight(double kg, {bool includeUnit = true}) {
    final val = _toDisplayWeight(kg).toStringAsFixed(1);
    return includeUnit ? '$val $_weightUnit' : val;
  }

  String _formatDelta(double deltaKg) {
    final converted = _usePounds ? deltaKg * 2.20462 : deltaKg;
    if (converted.abs() < 0.05) {
      return '- 0.0 $_weightUnit';
    } else if (converted > 0) {
      return '↑ ${converted.toStringAsFixed(1)} $_weightUnit';
    } else {
      return '↓ ${converted.abs().toStringAsFixed(1)} $_weightUnit';
    }
  }

  // Calculations
  double get _currentWeight => _records.isNotEmpty ? _records.first.weightKg : 0.0;
  double get _highestWeight =>
      _records.isNotEmpty ? _records.map((r) => r.weightKg).reduce((a, b) => a > b ? a : b) : 0.0;
  double get _lowestWeight =>
      _records.isNotEmpty ? _records.map((r) => r.weightKg).reduce((a, b) => a < b ? a : b) : 0.0;
  double get _averageWeight =>
      _records.isNotEmpty ? _records.map((r) => r.weightKg).reduce((a, b) => a + b) / _records.length : 0.0;

  double get _thirtyDayChange {
    if (_records.length < 2) return 0.0;
    return _records.first.weightKg - _records.last.weightKg;
  }

  double get _largestIncrease {
    final increases = _records.map((r) => r.deltaKg).where((d) => d > 0);
    return increases.isNotEmpty ? increases.reduce((a, b) => a > b ? a : b) : 0.8;
  }

  double get _largestDecrease {
    final decreases = _records.map((r) => r.deltaKg).where((d) => d < 0);
    return decreases.isNotEmpty ? decreases.reduce((a, b) => a < b ? a : b) : -1.2;
  }

  List<WeightRecord> get _sortedRecords {
    final list = List<WeightRecord>.from(_records);
    list.sort((a, b) => _sortNewestFirst
        ? b.dateTime.compareTo(a.dateTime)
        : a.dateTime.compareTo(b.dateTime));
    return list;
  }

  // Month abbreviations for chart X-axis
  final List<String> _chartMonths = const ['Apr', 'May', 'Jun', 'Jul', 'Aug'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildAppBar(),
      body: _isEmpty ? _buildEmptyStateView() : _buildPopulatedView(),
      floatingActionButton: _isEmpty ? _buildEmptyFab() : null,
    );
  }

  // ==========================================
  // TOP APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey, size: 24),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Weight Tracker',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: false,
      actions: [
        // Quick State Toggle button (Empty / Populated)
        IconButton(
          tooltip: _isEmpty ? 'Switch to Populated View' : 'Switch to Empty View',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
            size: 26,
          ),
          onPressed: () {
            setState(() {
              _isEmpty = !_isEmpty;
              if (!_isEmpty) {
                _isLoaded = false;
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) setState(() => _isLoaded = true);
                });
              }
            });
          },
        ),
        // Filter button
        IconButton(
          tooltip: 'Filters & Units',
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 24),
          onPressed: _showFilterModal,
        ),
        // Add button
        IconButton(
          tooltip: 'Add Weight Entry',
          icon: const Icon(Icons.add, color: Color(0xFF95D3BB), size: 26),
          onPressed: _showAddWeightModal,
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.white.withValues(alpha: 0.08),
          height: 1,
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED VIEW
  // ==========================================
  Widget _buildPopulatedView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDogSelector(),
          const SizedBox(height: 20),
          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildDateSelectorPills(),
          const SizedBox(height: 20),
          _buildGraphCard(),
          const SizedBox(height: 20),
          _buildTrendMetricsCard(),
          const SizedBox(height: 24),
          _buildHistorySection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================
  // EMPTY STATE VIEW (Matches Image 2)
  // ==========================================
  Widget _buildEmptyStateView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDogSelector(),
          const SizedBox(height: 20),
          _buildEmptySummaryCard(),
          const SizedBox(height: 48),
          _buildEmptyPlaceholderContent(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEmptySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monitor_weight_outlined, color: AppColors.secondaryTextStoneGrey, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Current Weight',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextOffWhite,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _weightUnit,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.flag_outlined, color: AppColors.secondaryTextStoneGrey, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'TARGET',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '— $_weightUnit',
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.trending_flat, color: AppColors.secondaryTextStoneGrey, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'CHANGE',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '—',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholderContent() {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            border: Border.all(color: const Color(0xFF2E6B57)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.more_horiz,
            color: Color(0xFF95D3BB),
            size: 28,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No Weight Records Yet',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Start tracking ${_activeDog.name}\'s weight to monitor long-term health and conditioning. Every entry builds a complete picture over time.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Add First Weight Button
        InkWell(
          onTap: _showAddWeightModal,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2E6B57),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E6B57).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.monitor_weight_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Add First Weight',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Learn about Weight Tracking
        GestureDetector(
          onTap: _showLearnModal,
          child: const Text(
            'Learn about Weight Tracking',
            style: TextStyle(
              color: Color(0xFF95D3BB),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF95D3BB),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyFab() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF2E6B57),
      elevation: 4,
      onPressed: _showAddWeightModal,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  // ==========================================
  // DOG SELECTOR CARD
  // ==========================================
  Widget _buildDogSelector() {
    return InkWell(
      onTap: _showDogSwitcherModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E6B57), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _activeDog.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF2E6B57),
                    child: const Icon(Icons.pets, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activeDog.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_activeDog.breed} · ${_activeDog.age}',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SUMMARY CARD
  // ==========================================
  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Top Big Display
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatWeight(_currentWeight, includeUnit: false),
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _weightUnit,
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_upward, color: Color(0xFF95D3BB), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatWeight(0.3, includeUnit: false)} $_weightUnit this month',
                      style: const TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 2x3 Grid
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCell(
                        label: 'CURRENT',
                        value: _formatWeight(_currentWeight),
                      ),
                    ),
                    Container(width: 1, height: 60, color: Colors.white.withValues(alpha: 0.08)),
                    Expanded(
                      child: _buildGridCell(
                        label: 'HIGHEST',
                        value: _formatWeight(_highestWeight),
                      ),
                    ),
                  ],
                ),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCell(
                        label: 'LOWEST',
                        value: _formatWeight(_lowestWeight),
                      ),
                    ),
                    Container(width: 1, height: 60, color: Colors.white.withValues(alpha: 0.08)),
                    Expanded(
                      child: _buildGridCell(
                        label: '30 DAY CHANGE',
                        value: _formatDelta(_thirtyDayChange),
                        valueColor: const Color(0xFF95D3BB),
                      ),
                    ),
                  ],
                ),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCell(
                        label: 'TARGET',
                        value: _formatWeight(_activeDog.targetWeightKg),
                        isItalic: true,
                      ),
                    ),
                    Container(width: 1, height: 60, color: Colors.white.withValues(alpha: 0.08)),
                    Expanded(
                      child: _buildGridCell(
                        label: 'LAST RECORDED',
                        value: '3 days ago',
                        isSmall: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCell({
    required String label,
    required String value,
    Color? valueColor,
    bool isItalic = false,
    bool isSmall = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.primaryTextOffWhite,
              fontSize: isSmall ? 14 : 18,
              fontWeight: isSmall ? FontWeight.w400 : FontWeight.w600,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TIMEFRAME PILLS
  // ==========================================
  Widget _buildDateSelectorPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _timeframes.map((tf) {
          final isSelected = tf == _selectedTimeframe;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTimeframe = tf;
                  _isLoaded = false;
                });
                Future.delayed(const Duration(milliseconds: 50), () {
                  if (mounted) setState(() => _isLoaded = true);
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2E6B57).withValues(alpha: 0.15)
                      : AppColors.cardsCarbon,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2E6B57)
                        : Colors.white.withValues(alpha: 0.08),
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tf,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // GRAPH CARD (Animated on open & Interactive with dynamic moving tooltip)
  // ==========================================
  Widget _buildGraphCard() {
    // 5 monthly progression data points matching the Figma curve
    final List<FlSpot> rawSpots = [
      const FlSpot(0, 26.8), // APR - Low starting point (~13% height)
      const FlSpot(1, 27.3), // MAY - Gentle initial rise (~30% height)
      const FlSpot(2, 28.1), // JUN - Accelerated mid ascent (~55% height)
      const FlSpot(3, 28.5), // JUL - Steep conditioning climb (~70% height)
      const FlSpot(4, 29.1), // AUG - Peak target conditioning (~90% height)
    ];

    // Corresponding metadata for each graph point
    final List<WeightRecord> chartEntries = [
      WeightRecord(
        id: 'chart_0',
        weightKg: 26.8,
        dateTime: DateTime(2025, 4, 1, 8, 30),
        deltaKg: 0.0,
        note: 'Start of seasonal conditioning.',
        bcsScore: 5,
      ),
      WeightRecord(
        id: 'chart_1',
        weightKg: 27.3,
        dateTime: DateTime(2025, 5, 1, 6, 45),
        deltaKg: 0.5,
        note: 'Post morning trail walk conditioning.',
        bcsScore: 5,
      ),
      WeightRecord(
        id: 'chart_2',
        weightKg: 28.1,
        dateTime: DateTime(2025, 5, 15, 8, 15),
        deltaKg: 0.2, // Matches "15 MAY 2025, 28.1 kg, ↑ 0.2 kg" in Figma!
        note: 'Routine veterinary check scale.',
        bcsScore: 5,
      ),
      WeightRecord(
        id: 'chart_3',
        weightKg: 28.5,
        dateTime: DateTime(2025, 7, 15, 7, 0),
        deltaKg: 0.4,
        note: 'Mid-summer conditioning check.',
        bcsScore: 5,
      ),
      WeightRecord(
        id: 'chart_4',
        weightKg: 29.1,
        dateTime: DateTime(2025, 8, 20, 7, 30),
        deltaKg: 0.6,
        note: 'Peak season conditioning check.',
        bcsScore: 5,
      ),
    ];

    // Animated spots: rise smoothly from baseline (26.4) up to full values
    const double minY = 26.4;
    const double maxY = 29.5;
    final animatedSpots = rawSpots.map((spot) {
      final y = _isLoaded ? spot.y : minY;
      return FlSpot(spot.x, y);
    }).toList();

    final safeIndex = _selectedPointIndex.clamp(0, chartEntries.length - 1);
    final activeRecord = chartEntries[safeIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WEIGHT OVER TIME',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Trend',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.north_east, color: AppColors.secondaryTextStoneGrey, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart & Dynamic Moving Tooltip Stack
          SizedBox(
            height: 200,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                const chartHeight = 200.0;

                // Active spot coordinates calculation
                final activeSpot = rawSpots[safeIndex];
                final xRatio = activeSpot.x / 4.0;
                final yRatio = (activeSpot.y - minY) / (maxY - minY);

                final pointPxX = xRatio * chartWidth;
                final pointPxY = chartHeight * (1.0 - yRatio);

                // Tooltip box dimensions
                const tooltipWidth = 140.0;
                const tooltipHeight = 104.0;

                // Dynamic offset calculation based on which point is active
                double targetLeft;
                double targetTop;

                if (safeIndex <= 1) {
                  // Left points (APR, MAY): place tooltip to the right of the dot
                  targetLeft = (pointPxX + 12.0).clamp(6.0, chartWidth - tooltipWidth - 6.0);
                  targetTop = (pointPxY - tooltipHeight - 6.0).clamp(4.0, chartHeight - tooltipHeight - 4.0);
                } else if (safeIndex == 2) {
                  // Middle point (JUN): place slightly to the right and above (matches Figma Image 1)
                  targetLeft = (pointPxX + 10.0).clamp(6.0, chartWidth - tooltipWidth - 6.0);
                  targetTop = (pointPxY - tooltipHeight - 6.0).clamp(4.0, chartHeight - tooltipHeight - 4.0);
                } else {
                  // Right points (JUL, AUG): place tooltip to the left of the dot so it never clips!
                  targetLeft = (pointPxX - tooltipWidth - 12.0).clamp(6.0, chartWidth - tooltipWidth - 6.0);
                  targetTop = (pointPxY - tooltipHeight * 0.55).clamp(4.0, chartHeight - tooltipHeight - 4.0);
                }

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Line Chart
                    Positioned.fill(
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 4,
                          minY: minY,
                          maxY: maxY,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 0.8,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withValues(alpha: 0.05),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: const FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) => [], // Rendered by moving UI box
                            ),
                            touchCallback: (event, response) {
                              if (response?.lineBarSpots != null &&
                                  response!.lineBarSpots!.isNotEmpty) {
                                final touchedIndex = response.lineBarSpots!.first.spotIndex;
                                if (touchedIndex >= 0 &&
                                    touchedIndex < chartEntries.length &&
                                    touchedIndex != _selectedPointIndex) {
                                  setState(() {
                                    _selectedPointIndex = touchedIndex;
                                  });
                                }
                              }
                            },
                          ),
                          lineBarsData: [
                            // Target Reference Line (Alpine Blue dashed curve)
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 27.20),
                                FlSpot(1, 27.35),
                                FlSpot(2, 27.50),
                                FlSpot(3, 27.65),
                                FlSpot(4, 27.80),
                              ],
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: const Color(0xFF5D8FAF).withValues(alpha: 0.65),
                              barWidth: 1.5,
                              dashArray: [4, 4],
                              dotData: const FlDotData(show: false),
                            ),
                            // Weight Trend Curve (Forest Green with gradient fill)
                            LineChartBarData(
                              spots: animatedSpots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: const Color(0xFF2E6B57),
                              barWidth: 2.5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) => true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final isSelected = index == safeIndex;
                                  if (isSelected) {
                                    return FlDotCirclePainter(
                                      radius: 6,
                                      color: const Color(0xFF95D3BB),
                                      strokeWidth: 2.5,
                                      strokeColor: AppColors.backgroundObsidian,
                                    );
                                  } else {
                                    return FlDotCirclePainter(
                                      radius: 3.5,
                                      color: AppColors.cardsCarbon,
                                      strokeWidth: 2,
                                      strokeColor: const Color(0xFF2E6B57),
                                    );
                                  }
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF2E6B57).withValues(alpha: 0.28),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutQuart,
                      ),
                    ),
                    // Animated Moving Tooltip Box (Follows the active point!)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: targetLeft,
                      top: targetTop,
                      child: Container(
                        width: tooltipWidth,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.55),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDateShort(activeRecord.dateTime).toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _formatWeight(activeRecord.weightKg),
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDelta(activeRecord.deltaKg),
                              style: TextStyle(
                                color: activeRecord.deltaKg < 0
                                    ? const Color(0xFFFFB4AB)
                                    : const Color(0xFF95D3BB),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            InkWell(
                              onTap: () => _showEntryDetailsModal(activeRecord),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'View Entry',
                                    style: TextStyle(
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.secondaryTextStoneGrey,
                                    size: 13,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Interactive Month Labels (Tapping any month directly moves the tooltip!)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_chartMonths.length, (i) {
              final isSelected = i == safeIndex;
              return InkWell(
                onTap: () {
                  setState(() => _selectedPointIndex = i);
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    _chartMonths[i].toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TREND METRICS CARD
  // ==========================================
  Widget _buildTrendMetricsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildGridCell(
                  label: 'AVERAGE',
                  value: _formatWeight(_averageWeight),
                ),
              ),
              Container(width: 1, height: 60, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildGridCell(
                  label: 'MONTHLY CHANGE',
                  value: _formatDelta(0.3),
                  valueColor: const Color(0xFF95D3BB),
                ),
              ),
            ],
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          Row(
            children: [
              Expanded(
                child: _buildGridCell(
                  label: 'LARGEST INCREASE',
                  value: '+${_formatWeight(_largestIncrease, includeUnit: false)} $_weightUnit',
                  valueColor: const Color(0xFFFFB4AB),
                ),
              ),
              Container(width: 1, height: 60, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildGridCell(
                  label: 'LARGEST DECREASE',
                  value: _formatDelta(_largestDecrease),
                  valueColor: const Color(0xFF95D3BB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HISTORY SECTION
  // ==========================================
  Widget _buildHistorySection() {
    final records = _sortedRecords;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HISTORY',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final rec = records[index];
            return _buildHistoryEntryCard(rec);
          },
        ),
      ],
    );
  }

  Widget _buildHistoryEntryCard(WeightRecord rec) {
    Color badgeColor;
    Color badgeBg;
    Color badgeBorder;

    if (rec.deltaKg > 0.05) {
      badgeColor = const Color(0xFF95D3BB);
      badgeBg = const Color(0xFF2E6B57).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFF2E6B57).withValues(alpha: 0.3);
    } else if (rec.deltaKg < -0.05) {
      badgeColor = const Color(0xFFFFB4AB);
      badgeBg = const Color(0xFF8B3A3A).withValues(alpha: 0.15);
      badgeBorder = const Color(0xFF8B3A3A).withValues(alpha: 0.3);
    } else {
      badgeColor = AppColors.secondaryTextStoneGrey;
      badgeBg = Colors.white.withValues(alpha: 0.05);
      badgeBorder = Colors.white.withValues(alpha: 0.08);
    }

    return InkWell(
      onTap: () => _showEntryDetailsModal(rec),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                rec.isManualNote ? Icons.edit_note : Icons.monitor_weight_outlined,
                color: AppColors.secondaryTextStoneGrey,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatWeight(rec.weightKg),
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDateTime(rec.dateTime),
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeBg,
                border: Border.all(color: badgeBorder),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _formatDelta(rec.deltaKg),
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.secondaryTextStoneGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // INTERACTIVE MODALS & BOTTOM SHEETS
  // ==========================================

  /// Dog Switcher Modal
  void _showDogSwitcherModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Dog',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(_dogs.length, (i) {
                final dog = _dogs[i];
                final isSelected = i == _activeDogIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _activeDogIndex = i;
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2E6B57).withValues(alpha: 0.15)
                            : AppColors.cardsCarbon,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              dog.avatarUrl,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 36,
                                height: 36,
                                color: const Color(0xFF2E6B57),
                                child: const Icon(Icons.pets, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dog.name,
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${dog.breed} · Target ${_formatWeight(dog.targetWeightKg)}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF95D3BB), size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Add Weight Modal
  void _showAddWeightModal() {
    double tempWeight = _currentWeight > 0 ? _currentWeight : _activeDog.targetWeightKg;
    DateTime tempDate = DateTime.now();
    int tempBcs = 5;
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Weight for ${_activeDog.name}',
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Weight Adjuster
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'WEIGHT VALUE',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton.filledTonal(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                                ),
                                icon: const Icon(Icons.remove, color: AppColors.primaryTextOffWhite),
                                onPressed: () {
                                  setModalState(() {
                                    tempWeight = (tempWeight - 0.1).clamp(5.0, 90.0);
                                  });
                                },
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '${tempWeight.toStringAsFixed(1)} $_weightUnit',
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton.filledTonal(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                                ),
                                icon: const Icon(Icons.add, color: AppColors.primaryTextOffWhite),
                                onPressed: () {
                                  setModalState(() {
                                    tempWeight = (tempWeight + 0.1).clamp(5.0, 90.0);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // BCS selector
                    const Text(
                      'BODY CONDITION SCORE (1-9)',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(9, (index) {
                          final score = index + 1;
                          final isSelected = score == tempBcs;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text('$score${score == 5 ? ' (Ideal)' : ''}'),
                              selected: isSelected,
                              selectedColor: const Color(0xFF2E6B57),
                              backgroundColor: AppColors.cardsCarbon,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                              onSelected: (_) {
                                setModalState(() => tempBcs = score);
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Notes field
                    TextField(
                      controller: noteController,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Notes (e.g. Weigh-in before breakfast)',
                        hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF2E6B57)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6B57),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final newDelta = _records.isNotEmpty ? tempWeight - _records.first.weightKg : 0.0;
                          final newRecord = WeightRecord(
                            id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
                            weightKg: tempWeight,
                            dateTime: tempDate,
                            deltaKg: newDelta,
                            note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                            bcsScore: tempBcs,
                            isManualNote: true,
                          );

                          setState(() {
                            _records.insert(0, newRecord);
                            _isEmpty = false;
                            _isLoaded = false;
                          });

                          Navigator.pop(ctx);

                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (mounted) setState(() => _isLoaded = true);
                          });
                        },
                        child: const Text(
                          'Save Weight Entry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
      },
    );
  }

  /// Entry Details Modal
  void _showEntryDetailsModal(WeightRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weight Entry Details',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatWeight(record.weightKg),
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E6B57).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF2E6B57).withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _formatDelta(record.deltaKg),
                            style: const TextStyle(
                              color: Color(0xFF95D3BB),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                    const SizedBox(height: 12),
                    _buildDetailRow('Timestamp', _formatDateTime(record.dateTime)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Body Condition', 'BCS ${record.bcsScore} / 9 (Ideal)'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Recorded By', record.recordedBy),
                    if (record.note != null && record.note!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow('Notes', record.note!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFB4AB),
                        side: const BorderSide(color: Color(0xFF8B3A3A)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      onPressed: () {
                        setState(() {
                          _records.removeWhere((r) => r.id == record.id);
                          if (_records.isEmpty) {
                            _isEmpty = true;
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6B57),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                      label: const Text('Edit Entry', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showEditWeightModal(record);
                      },
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Edit Weight Modal
  void _showEditWeightModal(WeightRecord record) {
    double tempWeight = record.weightKg;
    final noteController = TextEditingController(text: record.note ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Weight Entry',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardsCarbon,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.08)),
                          icon: const Icon(Icons.remove, color: AppColors.primaryTextOffWhite),
                          onPressed: () {
                            setModalState(() {
                              tempWeight = (tempWeight - 0.1).clamp(5.0, 90.0);
                            });
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${tempWeight.toStringAsFixed(1)} $_weightUnit',
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.08)),
                          icon: const Icon(Icons.add, color: AppColors.primaryTextOffWhite),
                          onPressed: () {
                            setModalState(() {
                              tempWeight = (tempWeight + 0.1).clamp(5.0, 90.0);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Notes',
                      filled: true,
                      fillColor: AppColors.cardsCarbon,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6B57),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {
                          record.weightKg = tempWeight;
                          record.note = noteController.text.trim();
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Update Entry', style: TextStyle(color: Colors.white, fontSize: 15)),
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

  /// Filter & Settings Modal
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Weight Preferences',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Units toggle
                  const Text(
                    'MEASUREMENT UNIT',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setModalState(() => _usePounds = false);
                            setState(() => _usePounds = false);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_usePounds
                                  ? const Color(0xFF2E6B57).withValues(alpha: 0.2)
                                  : AppColors.cardsCarbon,
                              border: Border.all(
                                color: !_usePounds ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Kilograms (kg)',
                              style: TextStyle(
                                color: !_usePounds ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                                fontWeight: !_usePounds ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setModalState(() => _usePounds = true);
                            setState(() => _usePounds = true);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _usePounds
                                  ? const Color(0xFF2E6B57).withValues(alpha: 0.2)
                                  : AppColors.cardsCarbon,
                              border: Border.all(
                                color: _usePounds ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Pounds (lbs)',
                              style: TextStyle(
                                color: _usePounds ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                                fontWeight: _usePounds ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Sort Order toggle
                  const Text(
                    'HISTORY SORTING',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setModalState(() => _sortNewestFirst = true);
                            setState(() => _sortNewestFirst = true);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _sortNewestFirst
                                  ? const Color(0xFF2E6B57).withValues(alpha: 0.2)
                                  : AppColors.cardsCarbon,
                              border: Border.all(
                                color: _sortNewestFirst ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Newest First',
                              style: TextStyle(
                                color: _sortNewestFirst ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                                fontWeight: _sortNewestFirst ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setModalState(() => _sortNewestFirst = false);
                            setState(() => _sortNewestFirst = false);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_sortNewestFirst
                                  ? const Color(0xFF2E6B57).withValues(alpha: 0.2)
                                  : AppColors.cardsCarbon,
                              border: Border.all(
                                color: !_sortNewestFirst ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Oldest First',
                              style: TextStyle(
                                color: !_sortNewestFirst ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                                fontWeight: !_sortNewestFirst ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6B57),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Apply Preferences', style: TextStyle(color: Colors.white, fontSize: 15)),
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

  /// Educational Guide Modal (Learn about Weight Tracking)
  void _showLearnModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weight & Conditioning Guide',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGuideSection(
                  '1. Regular Tracking',
                  'For active working breeds, monitor weight weekly at the same time of day (ideally morning before feeding) to detect conditioning changes early.',
                ),
                const SizedBox(height: 12),
                _buildGuideSection(
                  '2. Body Condition Score (BCS)',
                  'Ideal score is 4 to 5 on a 9-point scale. Ribs should be easily palpable with minimal fat cover, with an obvious waist when viewed from above and clear abdominal tuck.',
                ),
                const SizedBox(height: 12),
                _buildGuideSection(
                  '3. Seasonal Adjustments',
                  'Working dogs often burn significantly more calories in colder weather or during intense training cycles. Adjust caloric intake to preserve lean muscle mass.',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E6B57),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Got It', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuideSection(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF95D3BB),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FORMATTING UTILITIES
  // ==========================================
  String _formatDateTime(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;

    final hourNum = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final hour = hourNum.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';

    return '$day $month $year · $hour:$minute $period';
  }

  String _formatDateShort(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    return '$day $month $year';
  }
}
