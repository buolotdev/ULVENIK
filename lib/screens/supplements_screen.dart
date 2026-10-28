import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

enum SupplementStatus { active, due, given, stopped }

enum SupplementForm { powder, liquid, capsule, chew, tablet }

class SupplementItem {
  final String id;
  String name;
  String category;
  SupplementForm form;
  String dosage;
  String frequency;
  String nextDose;
  bool isDueToday;
  bool isGivenToday;
  SupplementStatus status;
  DateTime startDate;
  DateTime? stoppedDate;
  String notes;
  String brand;

  SupplementItem({
    required this.id,
    required this.name,
    required this.category,
    required this.form,
    required this.dosage,
    required this.frequency,
    required this.nextDose,
    required this.isDueToday,
    required this.isGivenToday,
    required this.status,
    required this.startDate,
    this.stoppedDate,
    required this.notes,
    this.brand = 'Ulvenik Performance Labs',
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String gender;
  final String avatarUrl;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.avatarUrl,
  });
}

class DailyAdherencePoint {
  final String day;
  final double adherenceRate; // 0.0 to 1.0 (e.g. 1.0 = 100%)
  final int dosesGiven;
  final int dosesTotal;

  const DailyAdherencePoint({
    required this.day,
    required this.adherenceRate,
    required this.dosesGiven,
    required this.dosesTotal,
  });
}

class SupplementsScreen extends StatefulWidget {
  final bool initialEmpty;
  const SupplementsScreen({super.key, this.initialEmpty = false});

  @override
  State<SupplementsScreen> createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'Belgian Malinois',
      age: '3y 2m',
      gender: 'Male',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA3NKwzUSgRC607ey_62dYiHjvXuaB0ycT5dLRsv8q0EDSuDId2MFO8dVFvXYJGU-tjv3W2LeIlWl90tc9jIXFYPGmAu2ZmR_9SvUXZmEP1NfZDT7Z2NGIXnB3yRStXLkps7WU4obJ-MSyx3BJhOq05fiRyIX16cQ8Ni1S-GZ6WyevYABreOsLIYO1jxlJf0CfX6gkTTLulBK6MAIyopxcnlNabbk4FDTg151EH3HyE1uYX07dlKKI',
    ),
    DogProfile(
      name: 'Odin',
      breed: 'Belgian Malinois',
      age: '4 yrs',
      gender: 'Male',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr_VJmHZE56JGN_MKaqBxjql_dWzuwgd8_u7Cg5v9emxxzrLMd-q0uEzNPLRnTDRLSDSwlvg4a3B7iJHZ_psMLbCo7pBzYvh7LnaDIVWSm1xzp1ljVksHA-ede6cZVj-m6PZTvIBKrHdQgQE0ZCp5mGDk5Rgdd8sdlA3dqATiv6-qLDU87fDK7J5hc2qlShDZnoXO0eijdi2H5k4mtTE9vjlwdVZKXZATLtdF05mZoU8fFSi_XYig',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      gender: 'Female',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
    ),
  ];

  DogProfile get _activeDog => _dogs[_activeDogIndex];

  // Adherence trend chart animation controller & interactive state
  late AnimationController _chartAnimController;
  late Animation<double> _chartCurveAnimation;
  int _selectedChartDayIndex = 6; // Sunday/Today (active point)

  final List<DailyAdherencePoint> _adherencePoints = const [
    DailyAdherencePoint(day: 'Mon', adherenceRate: 1.0, dosesGiven: 3, dosesTotal: 3),
    DailyAdherencePoint(day: 'Tue', adherenceRate: 1.0, dosesGiven: 3, dosesTotal: 3),
    DailyAdherencePoint(day: 'Wed', adherenceRate: 0.67, dosesGiven: 2, dosesTotal: 3),
    DailyAdherencePoint(day: 'Thu', adherenceRate: 1.0, dosesGiven: 3, dosesTotal: 3),
    DailyAdherencePoint(day: 'Fri', adherenceRate: 1.0, dosesGiven: 3, dosesTotal: 3),
    DailyAdherencePoint(day: 'Sat', adherenceRate: 1.0, dosesGiven: 3, dosesTotal: 3),
    DailyAdherencePoint(day: 'Sun', adherenceRate: 0.67, dosesGiven: 2, dosesTotal: 3),
  ];

  late List<SupplementItem> _supplements;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeSupplements();

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _chartCurveAnimation = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initializeSupplements() {
    _supplements = [
      SupplementItem(
        id: 'supp_1',
        name: 'Joint Flex Pro',
        category: 'Joint Health',
        form: SupplementForm.powder,
        dosage: '1 Scoop / Day',
        frequency: 'Daily with breakfast',
        nextDose: 'Tomorrow, 08:00',
        isDueToday: true,
        isGivenToday: true,
        status: SupplementStatus.active,
        startDate: DateTime(2026, 4, 10),
        notes: 'High concentration Glucosamine HCl, Chondroitin, and MSM for synovial fluid viscosity.',
      ),
      SupplementItem(
        id: 'supp_2',
        name: 'Salmon Oil',
        category: 'Skin & Coat',
        form: SupplementForm.liquid,
        dosage: '2 Pumps / Meal',
        frequency: 'Morning & evening meal',
        nextDose: 'Tomorrow, 08:00',
        isDueToday: true,
        isGivenToday: true,
        status: SupplementStatus.active,
        startDate: DateTime(2026, 3, 1),
        notes: 'Pure wild Alaskan salmon oil rich in EPA & DHA fatty acids. Promotes coat luster and reduces joint inflammation.',
      ),
      SupplementItem(
        id: 'supp_3',
        name: 'Probiotic Boost',
        category: 'Digestion',
        form: SupplementForm.capsule,
        dosage: '1 Capsule / Day',
        frequency: 'Daily with evening meal',
        nextDose: 'Today, 20:00',
        isDueToday: true,
        isGivenToday: false,
        status: SupplementStatus.active,
        startDate: DateTime(2026, 6, 15),
        notes: '10 Billion CFU multi-strain canine probiotic for gut microbiome resilience during competition stress.',
      ),
      SupplementItem(
        id: 'supp_4',
        name: 'Daily Complete',
        category: 'Multivitamin',
        form: SupplementForm.chew,
        dosage: '1 Chew / Day',
        frequency: 'Daily post-workout',
        nextDose: 'Tomorrow, 08:00',
        isDueToday: true,
        isGivenToday: true,
        status: SupplementStatus.active,
        startDate: DateTime(2026, 1, 15),
        notes: 'Complete micronutrient spectrum with B-complex vitamins, zinc, and antioxidants.',
      ),
      SupplementItem(
        id: 'supp_5',
        name: 'Electrolyte Boost',
        category: 'Hydration',
        form: SupplementForm.powder,
        dosage: '1 Sachet / 500ml',
        frequency: 'Pre/Post strenuous run',
        nextDose: 'Discontinued',
        isDueToday: false,
        isGivenToday: false,
        status: SupplementStatus.stopped,
        startDate: DateTime(2025, 7, 1),
        stoppedDate: DateTime(2025, 11, 30),
        notes: 'Used during high heat summer conditioning trials.',
      ),
      SupplementItem(
        id: 'supp_6',
        name: 'Recovery Blend',
        category: 'Muscle Repair',
        form: SupplementForm.powder,
        dosage: '1 Scoop / Day',
        frequency: 'Evening recovery meal',
        nextDose: 'Discontinued',
        isDueToday: false,
        isGivenToday: false,
        status: SupplementStatus.stopped,
        startDate: DateTime(2025, 8, 1),
        stoppedDate: DateTime(2025, 10, 15),
        notes: 'BCAA amino complex used during peak obstacle training.',
      ),
    ];
  }

  // Active vs Stopped lists
  List<SupplementItem> get _activeSupplements =>
      _supplements.where((s) => s.status == SupplementStatus.active).toList();

  List<SupplementItem> get _stoppedSupplements =>
      _supplements.where((s) => s.status == SupplementStatus.stopped).toList();

  // Filtered Active Supplements
  List<SupplementItem> get _filteredActiveSupplements {
    return _activeSupplements.where((item) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = item.name.toLowerCase().contains(query);
        final matchesCat = item.category.toLowerCase().contains(query);
        final matchesNotes = item.notes.toLowerCase().contains(query);
        final matchesDosage = item.dosage.toLowerCase().contains(query);
        if (!matchesName && !matchesCat && !matchesNotes && !matchesDosage) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // Schedule items for today
  List<SupplementItem> get _todayScheduleItems =>
      _activeSupplements.where((s) => s.isDueToday).toList();

  // Summary Metrics
  int get _activeCount => _activeSupplements.length; // Matches Figma (4)
  int get _dueTodayCount =>
      _activeSupplements.where((s) => s.isDueToday).length; // Matches Figma (3)
  int get _givenTodayCount =>
      _activeSupplements.where((s) => s.isGivenToday).length; // Matches Figma (2)
  int get _previouslyUsedCount => _stoppedSupplements.length + 4; // Matches Figma (6)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildTopAppBar(),
      body: _isEmpty ? _buildEmptyStateView() : _buildPopulatedView(),
    );
  }

  // ==========================================
  // TOP APP BAR (Matches HTML & Figma)
  // ==========================================
  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF95D3BB), size: 22),
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: 'Back',
      ),
      title: const Text(
        'Supplements',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          tooltip: 'Search Supplements',
          onPressed: () {
            if (_isEmpty) _toggleEmptyState(false);
            _searchFocusNode.requestFocus();
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 20),
          tooltip: 'Filter Supplements',
          onPressed: _showFilterOptionsModal,
        ),
        // Toggle State Button (Populated / Empty)
        IconButton(
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
            size: 26,
          ),
          tooltip: _isEmpty ? 'Switch to Populated State' : 'Switch to Empty State',
          onPressed: () => _toggleEmptyState(!_isEmpty),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.secondaryTextStoneGrey, size: 22),
          tooltip: 'Add Supplement',
          onPressed: _showAddSupplementModal,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _toggleEmptyState(bool empty) {
    setState(() {
      _isEmpty = empty;
    });
    if (!_isEmpty) {
      _chartAnimController.reset();
      _chartAnimController.forward();
    }
  }

  // ==========================================
  // POPULATED STATE VIEW
  // ==========================================
  Widget _buildPopulatedView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Dog Selector Card
          _buildDogSelectorCard(),
          const SizedBox(height: 20),

          // 2. Supplement Summary Grid (2x2 Grid)
          _buildSupplementSummaryGrid(),
          const SizedBox(height: 20),

          // 3. Weekly Adherence & Compliance Chart (Animated & Interactive)
          _buildAdherenceChartCard(),
          const SizedBox(height: 20),

          // 4. Today's Schedule Strip
          _buildTodayScheduleStrip(),
          const SizedBox(height: 20),

          // 5. Dedicated Form Search Bar (Zero underline)
          _buildSearchBar(),
          const SizedBox(height: 24),

          // 6. Active Supplements Section
          _buildActiveSupplementsSection(),
          const SizedBox(height: 28),

          // 7. Previously Used Section
          _buildPreviouslyUsedSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================
  // 1. DOG SELECTOR CARD
  // ==========================================
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSwitcherModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            _buildDogAvatar(_activeDog.avatarUrl, size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activeDog.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_activeDog.breed} • ${_activeDog.age}',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.unfold_more, color: AppColors.secondaryTextStoneGrey, size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. SUPPLEMENT SUMMARY GRID (2x2 Grid)
  // ==========================================
  Widget _buildSupplementSummaryGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryBox(
                icon: Icons.eco,
                iconColor: const Color(0xFF95D3BB),
                count: '$_activeCount',
                label: 'Active',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryBox(
                icon: Icons.notifications,
                iconColor: const Color(0xFFFFB4AB),
                count: '$_dueTodayCount',
                label: 'Due Today',
                onTap: _showRecordAdminModal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryBox(
                icon: Icons.check_circle,
                iconColor: const Color(0xFF95D3BB),
                count: '$_givenTodayCount',
                label: 'Given Today',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryBox(
                icon: Icons.archive,
                iconColor: AppColors.secondaryTextStoneGrey,
                count: '$_previouslyUsedCount',
                label: 'Previously Used',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryBox({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 22),
                Text(
                  count,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. WEEKLY ADHERENCE & COMPLIANCE CHART (Animated & Interactive)
  // ==========================================
  Widget _buildAdherenceChartCard() {
    final activePoint = _adherencePoints[_selectedChartDayIndex.clamp(0, _adherencePoints.length - 1)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Adherence',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: const [
                  Text(
                    '92% Compliance',
                    style: TextStyle(
                      color: Color(0xFF95D3BB),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.trending_up, size: 14, color: Color(0xFF95D3BB)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Interactive Tooltip Info Box
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2E6B57).withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF95D3BB),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${activePoint.day}: ',
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(activePoint.adherenceRate * 100).toInt()}% Adherence',
                  style: const TextStyle(
                    color: Color(0xFF95D3BB),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${activePoint.dosesGiven}/${activePoint.dosesTotal} doses given',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Animated fl_chart LineChart
          SizedBox(
            height: 110,
            child: AnimatedBuilder(
              animation: _chartCurveAnimation,
              builder: (context, child) {
                final animValue = _chartCurveAnimation.value;

                final spots = List.generate(_adherencePoints.length, (i) {
                  final targetY = _adherencePoints[i].adherenceRate * 100;
                  return FlSpot(i.toDouble(), targetY * animValue);
                });

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 20),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (_adherencePoints.length - 1).toDouble(),
                          minY: 0,
                          maxY: 110,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withValues(alpha: 0.04),
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                          ),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) => [],
                            ),
                            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                              if (touchResponse != null &&
                                  touchResponse.lineBarSpots != null &&
                                  touchResponse.lineBarSpots!.isNotEmpty) {
                                final spotIndex = touchResponse.lineBarSpots!.first.spotIndex;
                                if (spotIndex >= 0 &&
                                    spotIndex < _adherencePoints.length &&
                                    spotIndex != _selectedChartDayIndex) {
                                  setState(() {
                                    _selectedChartDayIndex = spotIndex;
                                  });
                                }
                              }
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: const Color(0xFF2E6B57),
                              barWidth: 2.8,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF2E6B57).withValues(alpha: 0.35),
                                    const Color(0xFF2E6B57).withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final isSelected = index == _selectedChartDayIndex;
                                  return FlDotCirclePainter(
                                    radius: isSelected ? 5.5 : 3.0,
                                    color: isSelected ? const Color(0xFF95D3BB) : const Color(0xFF2E6B57),
                                    strokeWidth: isSelected ? 2.0 : 1.2,
                                    strokeColor: isSelected ? Colors.white : const Color(0xFF95D3BB),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // X-Axis Day Labels
                    Positioned(
                      left: 6,
                      right: 6,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_adherencePoints.length, (index) {
                          final isSelected = index == _selectedChartDayIndex;
                          return InkWell(
                            onTap: () => setState(() => _selectedChartDayIndex = index),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Text(
                                _adherencePoints[index].day,
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                                  fontSize: 10,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. TODAY'S SCHEDULE STRIP
  // ==========================================
  Widget _buildTodayScheduleStrip() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "TODAY'S SCHEDULE",
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  'Oct 24',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Items
          _buildScheduleRow('Joint Flex Pro', true),
          _buildScheduleRow('Salmon Oil', true),
          _buildScheduleRow('Probiotic Boost', false, isLast: true),

          // Footer Action
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            alignment: Alignment.center,
            child: InkWell(
              onTap: _showRecordAdminModal,
              child: const Text(
                'Record Administration',
                style: TextStyle(
                  color: Color(0xFF95D3BB),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String name, bool isGiven, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isGiven ? Icons.check_circle : Icons.notifications,
                color: isGiven ? const Color(0xFF95D3BB) : const Color(0xFFFFB4AB),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            isGiven ? 'GIVEN' : 'DUE',
            style: TextStyle(
              color: isGiven ? const Color(0xFF95D3BB) : const Color(0xFFFFB4AB),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. DEDICATED SEARCH BAR (Zero Underline)
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Search supplements...',
                hintStyle: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 18),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. ACTIVE SUPPLEMENTS SECTION
  // ==========================================
  Widget _buildActiveSupplementsSection() {
    final list = _filteredActiveSupplements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'ACTIVE SUPPLEMENTS',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Center(
              child: Text(
                'No matching active supplements found.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              ),
            ),
          )
        else
          ...list.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildActiveSupplementCard(item),
              )),
      ],
    );
  }

  Widget _buildActiveSupplementCard(SupplementItem item) {
    final isDue = !item.isGivenToday && item.isDueToday;
    final bellColor = isDue ? const Color(0xFFFFB4AB) : const Color(0xFF95D3BB);

    return InkWell(
      onTap: () => _showSupplementDetailsModal(item),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.category} • ${_formatForm(item.form)}',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.notifications_active,
                  color: bellColor,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DOSAGE',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.dosage,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'NEXT DOSE',
                      style: TextStyle(
                        color: isDue ? const Color(0xFFFFB4AB) : AppColors.secondaryTextStoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.nextDose,
                      style: TextStyle(
                        color: isDue ? const Color(0xFFFFB4AB) : AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: isDue ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 7. PREVIOUSLY USED SECTION
  // ==========================================
  Widget _buildPreviouslyUsedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'PREVIOUSLY USED',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ..._stoppedSupplements.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => _showSupplementDetailsModal(item),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardsCarbon.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite.withValues(alpha: 0.75),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.category,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'STOPPED',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  // ==========================================
  // EMPTY STATE VIEW (Matches Screenshot 2)
  // ==========================================
  Widget _buildEmptyStateView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Dog Selector Card (Odin)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                _buildDogAvatar(_activeDog.avatarUrl, size: 40),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _activeDog.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_activeDog.gender} • ${_activeDog.breed}',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextStoneGrey, size: 22),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal Navigation Pills (Overview, Training, Supplements, Health)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildTabPill('Overview', false),
                _buildTabPill('Training', false),
                _buildTabPill('Supplements', true),
                _buildTabPill('Health', false),
              ],
            ),
          ),
          const SizedBox(height: 70),

          // Centered Circular Leaf/Eco Badge
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardsCarbon,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
              ),
              child: const Icon(
                Icons.eco_outlined,
                color: Color(0xFF95D3BB),
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Heading
          const Text(
            'No Supplements Recorded',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Keep track of every supplement ${_activeDog.name} receives. Build a comprehensive history to monitor performance and health outcomes over time.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // + Add Supplement CTA
          InkWell(
            onTap: _showAddSupplementModal,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Color(0xFFAAE9D0), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Add Supplement',
                    style: TextStyle(
                      color: Color(0xFFAAE9D0),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Color(0xFFAAE9D0), size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Learn link
          Center(
            child: GestureDetector(
              onTap: _showLearnModal,
              child: const Text(
                'Learn about Supplement Tracking',
                style: TextStyle(
                  color: Color(0xFF95D3BB),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF95D3BB),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTabPill(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6B57) : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFAAE9D0) : AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // HELPER: CRASH-PROOF DOG AVATAR
  // ==========================================
  Widget _buildDogAvatar(String url, {double size = 36}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2E6B57),
        border: Border.all(color: const Color(0xFF95D3BB), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: const Color(0xFF2E6B57),
            alignment: Alignment.center,
            child: Icon(Icons.pets, size: size * 0.55, color: const Color(0xFF95D3BB)),
          ),
        ),
      ),
    );
  }

  String _formatForm(SupplementForm form) {
    switch (form) {
      case SupplementForm.powder:
        return 'Powder';
      case SupplementForm.liquid:
        return 'Liquid';
      case SupplementForm.capsule:
        return 'Capsule';
      case SupplementForm.chew:
        return 'Chew';
      case SupplementForm.tablet:
        return 'Tablet';
    }
  }

  // ==========================================
  // INTERACTIVE MODALS (ZERO SNACKBARS)
  // ==========================================

  // 1. ADD SUPPLEMENT MODAL
  void _showAddSupplementModal() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController(text: 'Joint Health');
    final dosageController = TextEditingController(text: '1 Scoop / Day');
    final frequencyController = TextEditingController(text: 'Daily with breakfast');
    final notesController = TextEditingController();

    SupplementForm selectedForm = SupplementForm.powder;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
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
                          const Text(
                            'Add Supplement',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildModalField('SUPPLEMENT NAME', nameController, 'e.g. Joint Flex Pro'),
                      const SizedBox(height: 12),

                      _buildModalField('CATEGORY / PURPOSE', categoryController, 'e.g. Joint Health, Skin & Coat, Digestion'),
                      const SizedBox(height: 14),

                      // Form Selector
                      const Text(
                        'SUPPLEMENT FORM',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: SupplementForm.values.map((f) {
                          final isSel = selectedForm == f;
                          return ChoiceChip(
                            label: Text(_formatForm(f)),
                            selected: isSel,
                            selectedColor: const Color(0xFF2E6B57),
                            backgroundColor: AppColors.backgroundObsidian,
                            labelStyle: TextStyle(
                              color: isSel ? const Color(0xFFAAE9D0) : AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                            ),
                            onSelected: (val) => setModalState(() => selectedForm = f),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _buildModalField('DOSAGE', dosageController, 'e.g. 1 Scoop / Day'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModalField('FREQUENCY', frequencyController, 'e.g. Daily with meal'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildModalField('CLINICAL NOTES & ACTIVE INGREDIENTS', notesController, 'Key active compounds, Glucosamine, Omega-3s...', maxLines: 3),
                      const SizedBox(height: 24),

                      // Save Button
                      InkWell(
                        onTap: () {
                          final newSupplement = SupplementItem(
                            id: 'supp_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameController.text.trim().isEmpty ? 'Daily Supplement' : nameController.text.trim(),
                            category: categoryController.text.trim().isEmpty ? 'General Health' : categoryController.text.trim(),
                            form: selectedForm,
                            dosage: dosageController.text.trim().isEmpty ? '1 Unit / Day' : dosageController.text.trim(),
                            frequency: frequencyController.text.trim().isEmpty ? 'Daily' : frequencyController.text.trim(),
                            nextDose: 'Tomorrow, 08:00',
                            isDueToday: true,
                            isGivenToday: false,
                            status: SupplementStatus.active,
                            startDate: DateTime.now(),
                            notes: notesController.text.trim().isEmpty
                                ? 'Added to daily athletic nutritional protocol.'
                                : notesController.text.trim(),
                          );

                          Navigator.pop(ctx);
                          setState(() {
                            _isEmpty = false;
                            _supplements.insert(0, newSupplement);
                          });
                          _chartAnimController.reset();
                          _chartAnimController.forward();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E6B57),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Save Supplement',
                            style: TextStyle(
                              color: Color(0xFFAAE9D0),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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

  // 2. RECORD ADMINISTRATION MODAL
  void _showRecordAdminModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Administration",
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap to mark supplements as given today.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ..._todayScheduleItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.isGivenToday ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: item.isGivenToday ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${item.dosage} • ${item.frequency}',
                                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: item.isGivenToday ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
                              ),
                              onPressed: () {
                                setModalState(() {
                                  item.isGivenToday = !item.isGivenToday;
                                });
                                setState(() {});
                              },
                              child: Text(item.isGivenToday ? 'Undo' : 'Mark Given'),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E6B57),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Color(0xFFAAE9D0), fontSize: 14, fontWeight: FontWeight.w600),
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

  // 3. SUPPLEMENT DETAILS MODAL
  void _showSupplementDetailsModal(SupplementItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isActive = item.status == SupplementStatus.active;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  Text(
                    '${item.category} • ${_formatForm(item.form)}',
                    style: const TextStyle(color: Color(0xFF95D3BB), fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('Dosage', item.dosage),
                  _buildDetailRow('Frequency', item.frequency),
                  _buildDetailRow('Next Dose', item.nextDose),
                  _buildDetailRow('Status', isActive ? 'ACTIVE' : 'STOPPED'),
                  _buildDetailRow('Brand', item.brand),
                  const SizedBox(height: 14),

                  const Text(
                    'CLINICAL NOTES & INGREDIENTS',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.notes,
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      if (isActive)
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.errorDestructive),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              setState(() {
                                item.status = SupplementStatus.stopped;
                                item.stoppedDate = DateTime.now();
                              });
                            },
                            child: const Text('Stop Supplement', style: TextStyle(color: AppColors.errorDestructive, fontSize: 13)),
                          ),
                        )
                      else
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF95D3BB)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              setState(() {
                                item.status = SupplementStatus.active;
                                item.stoppedDate = null;
                              });
                            },
                            child: const Text('Re-activate', style: TextStyle(color: Color(0xFF95D3BB), fontSize: 13)),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6B57),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            if (isActive && !item.isGivenToday) {
                              setState(() {
                                item.isGivenToday = true;
                              });
                            }
                          },
                          child: Text(
                            isActive && !item.isGivenToday ? 'Mark Given Today' : 'Close',
                            style: const TextStyle(color: Color(0xFFAAE9D0), fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildModalField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // 4. LEARN SUPPLEMENT TRACKING MODAL
  void _showLearnModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Supplement Protocols',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildLearnPoint(
                    Icons.spa,
                    'Joint & Connective Tissue',
                    'Glucosamine, Chondroitin, and MSM preserve articular cartilage during high-impact bitesport, agility, and sprint deceleration.',
                  ),
                  const SizedBox(height: 12),
                  _buildLearnPoint(
                    Icons.water_drop,
                    'Omega-3 Fatty Acids (EPA & DHA)',
                    'Cold-water marine oils modulate systemic inflammation and maintain epithelial barrier strength.',
                  ),
                  const SizedBox(height: 12),
                  _buildLearnPoint(
                    Icons.security,
                    'Microbiome Resilience',
                    'Targeted canine probiotics prevent travel and training induced gastrointestinal dysbiosis.',
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E6B57),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Understood', style: TextStyle(color: Color(0xFFAAE9D0), fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearnPoint(IconData icon, String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E6B57).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF95D3BB)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(body, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  // 5. DOG SWITCHER MODAL
  void _showDogSwitcherModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Dog Profile',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...List.generate(_dogs.length, (index) {
                  final dog = _dogs[index];
                  final isSelected = index == _activeDogIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _activeDogIndex = index;
                      });
                      _chartAnimController.reset();
                      _chartAnimController.forward();
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2E6B57).withValues(alpha: 0.25) : AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildDogAvatar(dog.avatarUrl, size: 38),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dog.name, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                Text('${dog.gender} • ${dog.breed} • ${dog.age}', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF95D3BB), size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // 6. FILTER OPTIONS MODAL
  void _showFilterOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Category',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...['All', 'Joint Health', 'Skin & Coat', 'Digestion', 'Multivitamin'].map((category) {
                  final isSelected = category == _selectedFilter;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(category, style: TextStyle(color: isSelected ? const Color(0xFF95D3BB) : AppColors.primaryTextOffWhite, fontSize: 14)),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF95D3BB)) : null,
                    onTap: () {
                      setState(() {
                        _selectedFilter = category;
                        _searchQuery = category == 'All' ? '' : category;
                        _searchController.text = _searchQuery;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
