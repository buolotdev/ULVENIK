import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

enum AllergyType { food, environmental, medication }

enum AllergySeverity { severe, moderate, mild }

enum AllergyStatus { confirmed, suspected }

class AllergyItem {
  final String id;
  String name;
  AllergyType type;
  AllergySeverity severity;
  AllergyStatus status;
  DateTime? lastReactionDate;
  int reactionHistoryCount;
  String symptoms;
  String emergencyProtocol;
  String notes;

  AllergyItem({
    required this.id,
    required this.name,
    required this.type,
    required this.severity,
    required this.status,
    this.lastReactionDate,
    this.reactionHistoryCount = 1,
    required this.symptoms,
    required this.emergencyProtocol,
    required this.notes,
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
  });
}

class AllergyFlareUpPoint {
  final String month;
  final double severityScore; // 0 to 10 scale
  final int reactionCount;
  final String description;

  const AllergyFlareUpPoint({
    required this.month,
    required this.severityScore,
    required this.reactionCount,
    required this.description,
  });
}

class AllergiesSensitivitiesScreen extends StatefulWidget {
  final bool initialEmpty;
  const AllergiesSensitivitiesScreen({super.key, this.initialEmpty = false});

  @override
  State<AllergiesSensitivitiesScreen> createState() =>
      _AllergiesSensitivitiesScreenState();
}

class _AllergiesSensitivitiesScreenState
    extends State<AllergiesSensitivitiesScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Confirmed, Suspected, Food, Environmental, Medication

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC0fX8ehfwLDKuXof0BYGnCFQyfzTRYeenv5B9eK4cbHeXdq-_mw_JO_EIaSFjFVGojq-q5qIT6jwQR7xiGeM06lgtVf6J93yRMTsVm4W2t-_xJpDCfNk6ErYW_GsnuP2HmowhOh8Zmgru8LS9B_4j4d7M9odPKKSpDyOy3sPYcS-CIPOYT8ZEt-1CSKAkZsTfp_2buTmEaBMivAsXkjiVJsML17F6xy9JmV3qQaC99QnirPDybsXA',
    ),
    DogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3y 2m',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr_VJmHZE56JGN_MKaqBxjql_dWzuwgd8_u7Cg5v9emxxzrLMd-q0uEzNPLRnTDRLSDSwlvg4a3B7iJHZ_psMLbCo7pBzYvh7LnaDIVWSm1xzp1ljVksHA-ede6cZVj-m6PZTvIBKrHdQgQE0ZCp5mGDk5Rgdd8sdlA3dqATiv6-qLDU87fDK7J5hc2qlShDZnoXO0eijdi2H5k4mtTE9vjlwdVZKXZATLtdF05mZoU8fFSi_XYig',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
    ),
  ];

  DogProfile get _activeDog => _dogs[_activeDogIndex];

  // Flare-up trend animation controller & interactive state
  late AnimationController _chartAnimController;
  late Animation<double> _chartCurveAnimation;
  int _selectedChartMonthIndex = 5; // August (most recent reaction)

  final List<AllergyFlareUpPoint> _flareUpPoints = const [
    AllergyFlareUpPoint(
      month: 'Mar',
      severityScore: 2.5,
      reactionCount: 1,
      description: 'Penicillin mild urticaria reaction (Resolved with dose adjustment)',
    ),
    AllergyFlareUpPoint(
      month: 'Apr',
      severityScore: 0.0,
      reactionCount: 0,
      description: 'Zero flare-ups recorded. Diet strictly controlled.',
    ),
    AllergyFlareUpPoint(
      month: 'May',
      severityScore: 1.5,
      reactionCount: 1,
      description: 'Mild environmental contact dermatitis after field run.',
    ),
    AllergyFlareUpPoint(
      month: 'Jun',
      severityScore: 5.5,
      reactionCount: 1,
      description: 'Moderate grass pollen reaction. Conjunctivitis and paw licking.',
    ),
    AllergyFlareUpPoint(
      month: 'Jul',
      severityScore: 1.0,
      reactionCount: 0,
      description: 'Controlled with post-training paw wash and wipes.',
    ),
    AllergyFlareUpPoint(
      month: 'Aug',
      severityScore: 8.5,
      reactionCount: 1,
      description: 'Severe chicken treat ingestion. Acute facial swelling and hives.',
    ),
  ];

  late List<AllergyItem> _allergies;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeAllergies();

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

  void _initializeAllergies() {
    _allergies = [
      AllergyItem(
        id: 'alg_1',
        name: 'Chicken',
        type: AllergyType.food,
        severity: AllergySeverity.severe,
        status: AllergyStatus.confirmed,
        lastReactionDate: DateTime(2026, 8, 2),
        reactionHistoryCount: 3,
        symptoms: 'Acute facial angioedema, intense generalized pruritus, gastrointestinal distress.',
        emergencyProtocol: 'Administer oral Diphenhydramine 25mg immediately. Contact Peak Emergency Vets if breathing changes.',
        notes: 'Strict avoidance of chicken meal, chicken fat, and hydrolyzed poultry protein.',
      ),
      AllergyItem(
        id: 'alg_2',
        name: 'Grass Pollen',
        type: AllergyType.environmental,
        severity: AllergySeverity.moderate,
        status: AllergyStatus.confirmed,
        lastReactionDate: DateTime(2026, 6, 14),
        reactionHistoryCount: 2,
        symptoms: 'Pododermatitis (paw redness/licking), conjunctival hyperemia, seasonal sneezing.',
        emergencyProtocol: 'Rinse paws with chlorhexidine wash after trail runs. Apply soothing hydrocortisone balm.',
        notes: 'Peaks in late spring and early summer. Antihistamine pre-treatment recommended before trial competitions.',
      ),
      AllergyItem(
        id: 'alg_3',
        name: 'Penicillin',
        type: AllergyType.medication,
        severity: AllergySeverity.mild,
        status: AllergyStatus.confirmed,
        lastReactionDate: DateTime(2025, 3, 18),
        reactionHistoryCount: 1,
        symptoms: 'Mild localized hives and transient skin erythema.',
        emergencyProtocol: 'Discontinue course immediately. Flag medical chart: use Cephalosporins or Fluoroquinolones instead.',
        notes: 'Noted during dental procedure antibiotic prophylaxis.',
      ),
      AllergyItem(
        id: 'alg_4',
        name: 'Dust Mites',
        type: AllergyType.environmental,
        severity: AllergySeverity.mild,
        status: AllergyStatus.suspected,
        symptoms: 'Occasional nighttime scratching and dry ear margins.',
        emergencyProtocol: 'Hypoallergenic bed covers, HEPA vacuuming twice weekly.',
        notes: 'Intradermal skin testing pending next scheduled vet check.',
      ),
      AllergyItem(
        id: 'alg_5',
        name: 'Beef',
        type: AllergyType.food,
        severity: AllergySeverity.moderate,
        status: AllergyStatus.suspected,
        symptoms: 'Soft stool flare-up after raw beef tendon chews.',
        emergencyProtocol: 'Elimination diet trial ongoing. Currently on novel protein (Salmon & Venison).',
        notes: 'Suspected cross-reactivity with bovine dairy proteins.',
      ),
    ];
  }

  // Filtered lists
  List<AllergyItem> get _confirmedAllergies {
    return _filteredAllergies
        .where((a) => a.status == AllergyStatus.confirmed)
        .toList();
  }

  List<AllergyItem> get _suspectedAllergies {
    return _filteredAllergies
        .where((a) => a.status == AllergyStatus.suspected)
        .toList();
  }

  List<AllergyItem> get _filteredAllergies {
    return _allergies.where((item) {
      // Category / Status Filter
      if (_selectedFilter == 'Confirmed' &&
          item.status != AllergyStatus.confirmed) {
        return false;
      }
      if (_selectedFilter == 'Suspected' &&
          item.status != AllergyStatus.suspected) {
        return false;
      }
      if (_selectedFilter == 'Food' && item.type != AllergyType.food) {
        return false;
      }
      if (_selectedFilter == 'Environmental' &&
          item.type != AllergyType.environmental) {
        return false;
      }
      if (_selectedFilter == 'Medication' &&
          item.type != AllergyType.medication) {
        return false;
      }

      // Search Query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = item.name.toLowerCase().contains(query);
        final matchesSymptoms = item.symptoms.toLowerCase().contains(query);
        final matchesNotes = item.notes.toLowerCase().contains(query);
        final matchesProtocol = item.emergencyProtocol.toLowerCase().contains(query);
        if (!matchesName && !matchesSymptoms && !matchesNotes && !matchesProtocol) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // Summary Metrics calculations
  int get _confirmedCount =>
      _allergies.where((a) => a.status == AllergyStatus.confirmed).length; // 3
  int get _suspectedCount =>
      _allergies.where((a) => a.status == AllergyStatus.suspected).length; // 2
  int get _severeCount =>
      _allergies.where((a) => a.severity == AllergySeverity.severe).length; // 1
  int get _foodCount =>
      _allergies.where((a) => a.type == AllergyType.food).length; // 2
  int get _envCount =>
      _allergies.where((a) => a.type == AllergyType.environmental).length; // 2
  int get _medsCount =>
      _allergies.where((a) => a.type == AllergyType.medication).length; // 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildTopAppBar(),
      body: _isEmpty ? _buildEmptyStateView() : _buildPopulatedView(),
      bottomNavigationBar: _isEmpty ? null : _buildStickyBottomCTA(),
    );
  }

  // ==========================================
  // TOP APP BAR
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
        'Allergies & Sensitivities',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          tooltip: 'Search Allergies',
          onPressed: () {
            if (_isEmpty) _toggleEmptyState(false);
            _searchFocusNode.requestFocus();
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 20),
          tooltip: 'Filter Allergies',
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
          icon: const Icon(Icons.add, color: Color(0xFF95D3BB), size: 22),
          tooltip: 'Add Allergy',
          onPressed: _showAddAllergyModal,
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Dog Selector Card
          _buildDogSelectorCard(),
          const SizedBox(height: 20),

          // 2. Summary Grid (3x2, 6 boxes)
          _buildSummaryGrid(),
          const SizedBox(height: 20),

          // 3. Flare-Up & Reaction Trend Chart (Animated & Interactive)
          _buildFlareUpTrendCard(),
          const SizedBox(height: 20),

          // 4. Interactive Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 16),

          // 5. Dedicated Form Search Bar (Zero underline)
          _buildSearchBar(),
          const SizedBox(height: 24),

          // 6. Confirmed Allergies List
          _buildConfirmedListSection(),
          const SizedBox(height: 24),

          // 7. Suspected Allergies List
          _buildSuspectedListSection(),
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
            const Icon(Icons.chevron_right, color: Color(0xFFB6CCB5), size: 22),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. SUMMARY GRID (3x2 Grid - 6 Boxes)
  // ==========================================
  Widget _buildSummaryGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

        return Column(
          children: [
            // Top Row: Confirmed, Suspected, Severe
            Row(
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    valueText: '$_confirmedCount',
                    label: 'CONFIRMED',
                    onTap: () => setState(() => _selectedFilter = 'Confirmed'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    valueText: '$_suspectedCount',
                    label: 'SUSPECTED',
                    onTap: () => setState(() => _selectedFilter = 'Suspected'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    valueText: '$_severeCount',
                    label: 'SEVERE',
                    textColor: const Color(0xFF8B3A3A),
                    bottomBorderColor: const Color(0xFF8B3A3A),
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacing),
            // Bottom Row: Food, Environmental, Meds
            Row(
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    icon: Icons.restaurant,
                    valueText: '$_foodCount',
                    label: 'FOOD',
                    onTap: () => setState(() => _selectedFilter = 'Food'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    icon: Icons.eco,
                    valueText: '$_envCount',
                    label: 'ENV',
                    onTap: () => setState(() => _selectedFilter = 'Environmental'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    icon: Icons.medication,
                    valueText: '$_medsCount',
                    label: 'MEDS',
                    onTap: () => setState(() => _selectedFilter = 'Medication'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryBox({
    IconData? icon,
    required String valueText,
    required String label,
    Color textColor = AppColors.primaryTextOffWhite,
    Color? bottomBorderColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(icon, size: 16, color: AppColors.secondaryTextStoneGrey),
                    Text(
                      valueText,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor == const Color(0xFF8B3A3A)
                            ? const Color(0xFF8B3A3A)
                            : AppColors.secondaryTextStoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (bottomBorderColor != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 2, color: bottomBorderColor),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. ALLERGY FLARE-UP TREND CHART (Animated & Interactive)
  // ==========================================
  Widget _buildFlareUpTrendCard() {
    final activePoint = _flareUpPoints[_selectedChartMonthIndex.clamp(0, _flareUpPoints.length - 1)];

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
                'Reaction & Flare-Up Trend',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                },
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: const [
                    Text(
                      'Last 6 Months',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.refresh, size: 12, color: AppColors.secondaryTextStoneGrey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Interactive Tooltip Box
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: activePoint.severityScore > 6
                    ? const Color(0xFF8B3A3A)
                    : (activePoint.severityScore > 3
                        ? const Color(0xFFB4823C)
                        : const Color(0xFF2E6B57)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: activePoint.severityScore > 6
                        ? const Color(0xFF8B3A3A)
                        : (activePoint.severityScore > 3
                            ? const Color(0xFFB4823C)
                            : const Color(0xFF95D3BB)),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${activePoint.month}: ',
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  activePoint.reactionCount == 0
                      ? 'No Reactions'
                      : (activePoint.severityScore > 6
                          ? 'Severe Flare-Up'
                          : (activePoint.severityScore > 3 ? 'Moderate Flare-Up' : 'Mild Reaction')),
                  style: TextStyle(
                    color: activePoint.severityScore > 6
                        ? const Color(0xFFFFB4AB)
                        : (activePoint.severityScore > 3
                            ? const Color(0xFFB4823C)
                            : const Color(0xFF95D3BB)),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activePoint.description,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Animated fl_chart LineChart
          SizedBox(
            height: 120,
            child: AnimatedBuilder(
              animation: _chartCurveAnimation,
              builder: (context, child) {
                final animValue = _chartCurveAnimation.value;

                final spots = List.generate(_flareUpPoints.length, (i) {
                  final targetY = _flareUpPoints[i].severityScore;
                  return FlSpot(i.toDouble(), targetY * animValue);
                });

                return Stack(
                  children: [
                    // Y-axis indicator
                    Positioned(
                      left: 0,
                      top: 4,
                      bottom: 22,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('High', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                          Text('Mod', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                          Text('Low', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 6, bottom: 20),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (_flareUpPoints.length - 1).toDouble(),
                          minY: 0,
                          maxY: 10,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 5,
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
                                    spotIndex < _flareUpPoints.length &&
                                    spotIndex != _selectedChartMonthIndex) {
                                  setState(() {
                                    _selectedChartMonthIndex = spotIndex;
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
                                    const Color(0xFF8B3A3A).withValues(alpha: 0.22),
                                    const Color(0xFF2E6B57).withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final isSelected = index == _selectedChartMonthIndex;
                                  final score = _flareUpPoints[index].severityScore;
                                  final dotColor = score > 6
                                      ? const Color(0xFF8B3A3A)
                                      : (score > 3
                                          ? const Color(0xFFB4823C)
                                          : const Color(0xFF2E6B57));

                                  return FlDotCirclePainter(
                                    radius: isSelected ? 5.5 : 3.0,
                                    color: isSelected ? const Color(0xFF95D3BB) : dotColor,
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

                    // X-Axis Month Labels
                    Positioned(
                      left: 30,
                      right: 6,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_flareUpPoints.length, (index) {
                          final isSelected = index == _selectedChartMonthIndex;
                          return InkWell(
                            onTap: () => setState(() => _selectedChartMonthIndex = index),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Text(
                                _flareUpPoints[index].month,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF95D3BB)
                                      : AppColors.secondaryTextStoneGrey,
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
  // 4. INTERACTIVE FILTER CHIPS
  // ==========================================
  Widget _buildFilterChips() {
    final filters = [
      'All',
      'Confirmed',
      'Suspected',
      'Food',
      'Environmental',
      'Medication',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((chip) {
          final isSelected = chip == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedFilter = chip),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E6B57) : AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2E6B57)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  chip,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFF5F6F2)
                        : AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
  // 5. DEDICATED FORM SEARCH BAR (Zero Underline)
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
                hintText: 'Search allergies, symptoms, reactions...',
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
  // 6. CONFIRMED ALLERGIES LIST SECTION
  // ==========================================
  Widget _buildConfirmedListSection() {
    final list = _confirmedAllergies;

    if (list.isEmpty && _selectedFilter != 'Suspected') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: const Center(
          child: Text(
            'No confirmed allergies match current criteria.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
          ),
        ),
      );
    }

    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'CONFIRMED ALLERGIES',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...list.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildConfirmedCard(item),
            )),
      ],
    );
  }

  Widget _buildConfirmedCard(AllergyItem item) {
    Color stripColor;
    String severityLabel;
    Color severityTextColor;
    Color severityBgColor;

    switch (item.severity) {
      case AllergySeverity.severe:
        stripColor = const Color(0xFF8B3A3A);
        severityLabel = 'SEVERE';
        severityTextColor = const Color(0xFFFFB4AB);
        severityBgColor = const Color(0xFF8B3A3A).withValues(alpha: 0.15);
        break;
      case AllergySeverity.moderate:
        stripColor = const Color(0xFFB4823C);
        severityLabel = 'MODERATE';
        severityTextColor = const Color(0xFFB4823C);
        severityBgColor = const Color(0xFFB4823C).withValues(alpha: 0.15);
        break;
      case AllergySeverity.mild:
        stripColor = const Color(0xFFB6CCB5);
        severityLabel = 'MILD';
        severityTextColor = const Color(0xFFB6CCB5);
        severityBgColor = const Color(0xFFB6CCB5).withValues(alpha: 0.15);
        break;
    }

    IconData typeIcon;
    switch (item.type) {
      case AllergyType.food:
        typeIcon = Icons.restaurant;
        break;
      case AllergyType.environmental:
        typeIcon = Icons.eco;
        break;
      case AllergyType.medication:
        typeIcon = Icons.medication;
        break;
    }

    return InkWell(
      onTap: () => _showAllergyDetailsModal(item),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full-height 3px severity color strip
              Container(width: 3.5, color: stripColor),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF111412),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Icon(typeIcon, size: 18, color: AppColors.secondaryTextStoneGrey),
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    // Severity Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: severityBgColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        severityLabel,
                                        style: TextStyle(
                                          color: severityTextColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // Confirmed Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2E6B57).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'CONFIRMED',
                                        style: TextStyle(
                                          color: Color(0xFF95D3BB),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Footer Row: Last Reaction & History
                      Container(
                        padding: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last Reaction',
                                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.lastReactionDate != null
                                      ? _formatDate(item.lastReactionDate!)
                                      : 'None recorded',
                                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            if (item.reactionHistoryCount > 1)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'History',
                                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.reactionHistoryCount} recorded',
                                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                          ],
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

  // ==========================================
  // 7. SUSPECTED ALLERGIES LIST SECTION
  // ==========================================
  Widget _buildSuspectedListSection() {
    final list = _suspectedAllergies;

    if (list.isEmpty && _selectedFilter != 'Confirmed') {
      return const SizedBox.shrink();
    }

    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'SUSPECTED',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...list.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildSuspectedCard(item),
            )),
      ],
    );
  }

  Widget _buildSuspectedCard(AllergyItem item) {
    IconData typeIcon;
    String typeLabel;
    switch (item.type) {
      case AllergyType.food:
        typeIcon = Icons.restaurant;
        typeLabel = 'Food';
        break;
      case AllergyType.environmental:
        typeIcon = Icons.eco;
        typeLabel = 'Environmental';
        break;
      case AllergyType.medication:
        typeIcon = Icons.medication;
        typeLabel = 'Medication';
        break;
    }

    return InkWell(
      onTap: () => _showAllergyDetailsModal(item),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(typeIcon, color: AppColors.secondaryTextStoneGrey, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      typeLabel,
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Text(
                'SUSPECTED',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STICKY BOTTOM CTA (+ Add Allergy)
  // ==========================================
  Widget _buildStickyBottomCTA() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: InkWell(
        onTap: _showAddAllergyModal,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E6B57),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E6B57).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Color(0xFFF5F6F2), size: 20),
              SizedBox(width: 8),
              Text(
                'Add Allergy',
                style: TextStyle(
                  color: Color(0xFFF5F6F2),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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
          // Current Profile Card (Rex)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(10),
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
                      const Text(
                        'Current Profile',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _activeDog.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.unfold_more, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 90),

          // Shield Badge
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
                Icons.shield_outlined,
                color: Color(0xFF95D3BB),
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Heading
          const Text(
            'No Allergies Recorded',
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
              'Record allergies and sensitivities to keep important health information organised and accessible for owners, trainers and vets.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // + Add Allergy Button
          InkWell(
            onTap: _showAddAllergyModal,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E6B57),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E6B57).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Color(0xFFF5F6F2), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Add Allergy',
                    style: TextStyle(
                      color: Color(0xFFF5F6F2),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                'Learn about Allergy Tracking',
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

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = dt.day.toString().padLeft(2, '0');
    return '$day ${months[dt.month - 1]} ${dt.year}';
  }

  // ==========================================
  // INTERACTIVE MODALS (ZERO SNACKBARS)
  // ==========================================

  // 1. ADD ALLERGY MODAL
  void _showAddAllergyModal() {
    final nameController = TextEditingController();
    final symptomsController = TextEditingController();
    final protocolController = TextEditingController();
    final notesController = TextEditingController();

    AllergyType selectedType = AllergyType.food;
    AllergySeverity selectedSeverity = AllergySeverity.moderate;
    AllergyStatus selectedStatus = AllergyStatus.confirmed;

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
                            'Add Allergy or Sensitivity',
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

                      _buildModalField('ALLERGEN NAME', nameController, 'e.g. Chicken, Beef, Dairy, Bee Sting'),
                      const SizedBox(height: 14),

                      // Allergen Type
                      const Text(
                        'TYPE / CATEGORY',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildChoiceChip('Food', selectedType == AllergyType.food, () => setModalState(() => selectedType = AllergyType.food)),
                          const SizedBox(width: 8),
                          _buildChoiceChip('Environmental', selectedType == AllergyType.environmental, () => setModalState(() => selectedType = AllergyType.environmental)),
                          const SizedBox(width: 8),
                          _buildChoiceChip('Medication', selectedType == AllergyType.medication, () => setModalState(() => selectedType = AllergyType.medication)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Severity
                      const Text(
                        'SEVERITY LEVEL',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildChoiceChip('Severe', selectedSeverity == AllergySeverity.severe, () => setModalState(() => selectedSeverity = AllergySeverity.severe), activeColor: const Color(0xFF8B3A3A)),
                          const SizedBox(width: 8),
                          _buildChoiceChip('Moderate', selectedSeverity == AllergySeverity.moderate, () => setModalState(() => selectedSeverity = AllergySeverity.moderate), activeColor: const Color(0xFFB4823C)),
                          const SizedBox(width: 8),
                          _buildChoiceChip('Mild', selectedSeverity == AllergySeverity.mild, () => setModalState(() => selectedSeverity = AllergySeverity.mild), activeColor: const Color(0xFF2E6B57)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Status
                      const Text(
                        'DIAGNOSIS STATUS',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildChoiceChip('Confirmed', selectedStatus == AllergyStatus.confirmed, () => setModalState(() => selectedStatus = AllergyStatus.confirmed)),
                          const SizedBox(width: 8),
                          _buildChoiceChip('Suspected', selectedStatus == AllergyStatus.suspected, () => setModalState(() => selectedStatus = AllergyStatus.suspected)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      _buildModalField('SYMPTOMS OBSERVED', symptomsController, 'e.g. Facial swelling, hives, paw licking, vomiting', maxLines: 2),
                      const SizedBox(height: 12),

                      _buildModalField('EMERGENCY ACTION PROTOCOL', protocolController, 'e.g. Administer 25mg Diphenhydramine, seek urgent veterinary care', maxLines: 2),
                      const SizedBox(height: 12),

                      _buildModalField('ADDITIONAL NOTES', notesController, 'Triggers, safe substitutes, test results...', maxLines: 2),
                      const SizedBox(height: 24),

                      // Save Button
                      InkWell(
                        onTap: () {
                          final newAllergy = AllergyItem(
                            id: 'alg_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameController.text.trim().isEmpty ? 'New Allergen' : nameController.text.trim(),
                            type: selectedType,
                            severity: selectedSeverity,
                            status: selectedStatus,
                            lastReactionDate: DateTime.now(),
                            reactionHistoryCount: 1,
                            symptoms: symptomsController.text.trim().isEmpty
                                ? 'Localized cutaneous irritation and itching.'
                                : symptomsController.text.trim(),
                            emergencyProtocol: protocolController.text.trim().isEmpty
                                ? 'Remove allergen source and monitor vital signs.'
                                : protocolController.text.trim(),
                            notes: notesController.text.trim().isEmpty
                                ? 'Recorded in health profile.'
                                : notesController.text.trim(),
                          );

                          Navigator.pop(ctx);
                          setState(() {
                            _isEmpty = false;
                            _allergies.insert(0, newAllergy);
                          });
                          _chartAnimController.reset();
                          _chartAnimController.forward();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E6B57),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Save Allergy Record',
                            style: TextStyle(
                              color: Color(0xFFF5F6F2),
                              fontSize: 14,
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

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onSelect, {Color? activeColor}) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? (activeColor ?? const Color(0xFF2E6B57)) : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? (activeColor ?? const Color(0xFF2E6B57))
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // 2. ALLERGY DETAILS MODAL
  void _showAllergyDetailsModal(AllergyItem item) {
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildMiniBadge(
                        item.severity.name.toUpperCase(),
                        item.severity == AllergySeverity.severe
                            ? const Color(0xFFFFB4AB)
                            : (item.severity == AllergySeverity.moderate
                                ? const Color(0xFFB4823C)
                                : const Color(0xFFB6CCB5)),
                      ),
                      const SizedBox(width: 6),
                      _buildMiniBadge(
                        item.status.name.toUpperCase(),
                        item.status == AllergyStatus.confirmed
                            ? const Color(0xFF95D3BB)
                            : AppColors.secondaryTextStoneGrey,
                      ),
                      const SizedBox(width: 6),
                      _buildMiniBadge(
                        item.type.name.toUpperCase(),
                        AppColors.secondaryTextStoneGrey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (item.lastReactionDate != null)
                    _buildDetailRow('Last Reaction', _formatDate(item.lastReactionDate!)),
                  _buildDetailRow('Reaction Occurrences', '${item.reactionHistoryCount} recorded in health history'),
                  const SizedBox(height: 14),

                  // Emergency Protocol Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B3A3A).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF8B3A3A).withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB4AB), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'EMERGENCY ACTION PROTOCOL',
                              style: TextStyle(
                                color: Color(0xFFFFB4AB),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.emergencyProtocol,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'SYMPTOMS',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(item.symptoms, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 12),

                  const Text(
                    'CLINICAL NOTES',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(item.notes, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8B3A3A)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _allergies.removeWhere((a) => a.id == item.id);
                              if (_allergies.isEmpty) _isEmpty = true;
                            });
                          },
                          child: const Text('Delete Allergy', style: TextStyle(color: Color(0xFFFFB4AB), fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6B57),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() {
                              item.lastReactionDate = DateTime.now();
                              item.reactionHistoryCount += 1;
                            });
                          },
                          child: const Text('Log Reaction Now', style: TextStyle(color: Color(0xFFF5F6F2), fontSize: 13)),
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

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
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

  // 3. DOG SWITCHER MODAL
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
                                Text('${dog.breed} • ${dog.age}', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
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

  // 4. LEARN ALLERGY MODAL
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
                        'Canine Allergy Guidelines',
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
                    Icons.restaurant,
                    'Food Allergies vs Sensitivities',
                    'True food allergies are immune-mediated (IgE hypersensitivity) often triggered by intact proteins like chicken or beef. Symptoms involve facial swelling, severe itching, or GI distress.',
                  ),
                  const SizedBox(height: 12),
                  _buildLearnPoint(
                    Icons.eco,
                    'Atopic Environmental Allergies',
                    'Caused by airborne pollen, molds, and dust mites entering through compromised epidermal skin barriers. Regular barrier repair washes minimize allergen penetration.',
                  ),
                  const SizedBox(height: 12),
                  _buildLearnPoint(
                    Icons.emergency,
                    'Emergency Protocol Readiness',
                    'Always document emergency antihistamine dosages calculated by your veterinarian. Have an emergency contact plan for travel and working trials.',
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E6B57),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Understood', style: TextStyle(color: Color(0xFFF5F6F2), fontSize: 14, fontWeight: FontWeight.w600)),
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

  // 5. FILTER OPTIONS MODAL
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
                ...['All', 'Confirmed', 'Suspected', 'Food', 'Environmental', 'Medication'].map((tab) {
                  final isSelected = tab == _selectedFilter;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(tab, style: TextStyle(color: isSelected ? const Color(0xFF95D3BB) : AppColors.primaryTextOffWhite, fontSize: 14)),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF95D3BB)) : null,
                    onTap: () {
                      setState(() => _selectedFilter = tab);
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
