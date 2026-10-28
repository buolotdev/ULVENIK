import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

enum RehabType {
  all('All'),
  physiotherapy('Physiotherapy'),
  hydrotherapy('Hydrotherapy'),
  underwaterTreadmill('Underwater Treadmill'),
  massage('Massage');

  final String label;
  const RehabType(this.label);
}

class RehabSession {
  final String id;
  String title;
  RehabType type;
  String therapist;
  String clinic;
  int durationMinutes;
  String conditionTag;
  double recoveryProgress; // 0.0 to 1.0
  String trendStatus; // IMPROVING ↑, NO CHANGE →, MONITOR ⚠
  DateTime date;
  String notes;
  List<String> exercises;
  String? waterTemp;
  double? treadmillSpeedKmh;

  RehabSession({
    required this.id,
    required this.title,
    required this.type,
    required this.therapist,
    required this.clinic,
    required this.durationMinutes,
    required this.conditionTag,
    required this.recoveryProgress,
    required this.trendStatus,
    required this.date,
    required this.notes,
    this.exercises = const [],
    this.waterTemp,
    this.treadmillSpeedKmh,
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

class RecoveryTrendPoint {
  final String month;
  final double recoveryPercent; // 0 to 100
  final String milestone;
  final String note;

  const RecoveryTrendPoint({
    required this.month,
    required this.recoveryPercent,
    required this.milestone,
    required this.note,
  });
}

class PhysioHydroHubScreen extends StatefulWidget {
  final bool initialEmpty;
  const PhysioHydroHubScreen({super.key, this.initialEmpty = false});

  @override
  State<PhysioHydroHubScreen> createState() => _PhysioHydroHubScreenState();
}

class _PhysioHydroHubScreenState extends State<PhysioHydroHubScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedFilterTab = 'All';

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAT2JDyeXSN-a8sdAHKBMKT7n_p0ntUYsNYQHZleAXv7z5Pc5ENx7qhgyul498o-SJEF16USkrxBOG1M7L2hor_gobIHyFjM_m2xIeJVWFCYxcv8HGmwis0RH5f5gVKx1VJKStltmL_jgSJLlGxoZsr-k6ZyFNkziNqYzeE4GOe5DBVOxf32NmY1D62UHF55_uU6HPDTRgskLWN9H1G4T6XWMwqmGoYNbSQDA8LSERwDQc5qllq2dA',
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

  // Chart animation controller & interactive state
  late AnimationController _chartAnimController;
  late Animation<double> _chartCurveAnimation;
  int _selectedChartPointIndex = 4; // Defaults to Aug/Sep (last active)

  final List<RecoveryTrendPoint> _trendPoints = const [
    RecoveryTrendPoint(
      month: 'Apr',
      recoveryPercent: 20.0,
      milestone: 'Initial Assessment',
      note: 'Baseline mobility 20%. Guarding left foreleg.',
    ),
    RecoveryTrendPoint(
      month: 'May',
      recoveryPercent: 35.0,
      milestone: 'Stretching & Passive ROM',
      note: 'Extension improved by 15°. Inflammation subsided.',
    ),
    RecoveryTrendPoint(
      month: 'Jun',
      recoveryPercent: 50.0,
      milestone: 'Hydrotherapy Initiated',
      note: 'Buoyancy swimming reduced joint loading.',
    ),
    RecoveryTrendPoint(
      month: 'Jul',
      recoveryPercent: 62.0,
      milestone: 'Treadmill Gait Re-training',
      note: 'Symmetrical stride achieved at 1.8 km/h.',
    ),
    RecoveryTrendPoint(
      month: 'Aug',
      recoveryPercent: 70.0,
      milestone: 'Agility Conditioning',
      note: 'Weight bearing symmetry reaches 88%.',
    ),
    RecoveryTrendPoint(
      month: 'Sep',
      recoveryPercent: 82.0,
      milestone: 'Pre-Competition Return',
      note: 'Full active extension with zero pain response.',
    ),
  ];

  late List<RehabSession> _sessions;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeSessions();

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

  void _initializeSessions() {
    _sessions = [
      RehabSession(
        id: 'sess_1',
        title: 'Gait & Mobility Session',
        type: RehabType.physiotherapy,
        therapist: 'Dr. Emma Walsh',
        clinic: 'Peak Rehab Clinic',
        durationMinutes: 55,
        conditionTag: 'LEFT FORELEG STRAIN',
        recoveryProgress: 0.70,
        trendStatus: 'IMPROVING ↑',
        date: DateTime(2026, 8, 28, 10, 0),
        notes:
            'Exceptional response to active range of motion and laser biostimulation. Carpal flexion angle is fully normalized.',
        exercises: [
          'Cavaletti rail stepping (3 sets x 8 reps)',
          'Wobble balance cushion stabilization (4 min)',
          'Class IV deep tissue therapeutic laser',
        ],
      ),
      RehabSession(
        id: 'sess_2',
        title: 'Pool Swimming Session',
        type: RehabType.hydrotherapy,
        therapist: 'Sarah Kimani',
        clinic: 'AquaVet Centre',
        durationMinutes: 40,
        conditionTag: 'HIP DYSPLASIA FLARE-UP',
        recoveryProgress: 0.55,
        trendStatus: 'IMPROVING ↑',
        date: DateTime(2026, 8, 24, 14, 30),
        waterTemp: '30.5°C',
        notes:
            'Warm water pool swimming with flotation vest. 4 continuous swim intervals. No reluctance or fatigue noted.',
        exercises: [
          'Low resistance straight lap swimming',
          'Gentle water jets against pelvic musculature',
          'Post-swim dry rubdown and passive hip stretch',
        ],
      ),
      RehabSession(
        id: 'sess_3',
        title: 'Range of Motion Assessment',
        type: RehabType.physiotherapy,
        therapist: 'Dr. Emma Walsh',
        clinic: 'Peak Rehab Clinic',
        durationMinutes: 45,
        conditionTag: 'HIP DYSPLASIA FLARE-UP',
        recoveryProgress: 0.40,
        trendStatus: 'NO CHANGE →',
        date: DateTime(2026, 8, 18, 11, 15),
        notes:
            'Goniometer measurement checkup. Hip abduction angle remains at 38°. Continued hydro sessions advised.',
        exercises: [
          'Goniometric joint mobility audit',
          'Ischial myofascial release massage',
          'Passive hamstring gentle elongations',
        ],
      ),
      RehabSession(
        id: 'sess_4',
        title: 'Underwater Treadmill Conditioning',
        type: RehabType.underwaterTreadmill,
        therapist: 'Sarah Kimani',
        clinic: 'AquaVet Centre',
        durationMinutes: 50,
        conditionTag: 'LEFT FORELEG STRAIN',
        recoveryProgress: 0.75,
        trendStatus: 'IMPROVING ↑',
        date: DateTime(2026, 8, 12, 16, 0),
        waterTemp: '29.8°C',
        treadmillSpeedKmh: 1.8,
        notes:
            'Water depth set to mid-shoulder to reduce 60% of gravitational weight. Rex walked cleanly with steady gait rhythm.',
        exercises: [
          '5 min warm-up walk at 1.2 km/h',
          '15 min steady endurance at 1.8 km/h',
          '5 min cooldown with decreasing water resistance',
        ],
      ),
    ];
  }

  // Filtered sessions
  List<RehabSession> get _filteredSessions {
    return _sessions.where((session) {
      // Type Filter
      if (_selectedFilterTab == 'Physiotherapy' &&
          session.type != RehabType.physiotherapy) {
        return false;
      }
      if (_selectedFilterTab == 'Hydrotherapy' &&
          session.type != RehabType.hydrotherapy) {
        return false;
      }
      if (_selectedFilterTab == 'Underwater Treadmill' &&
          session.type != RehabType.underwaterTreadmill) {
        return false;
      }
      if (_selectedFilterTab == 'Massage' && session.type != RehabType.massage) {
        return false;
      }

      // Search Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = session.title.toLowerCase().contains(query);
        final matchesTherapist = session.therapist.toLowerCase().contains(query);
        final matchesClinic = session.clinic.toLowerCase().contains(query);
        final matchesTag = session.conditionTag.toLowerCase().contains(query);
        final matchesNotes = session.notes.toLowerCase().contains(query);
        if (!matchesTitle &&
            !matchesTherapist &&
            !matchesClinic &&
            !matchesTag &&
            !matchesNotes) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // Summary Metrics calculations
  int get _totalSessionsCount => 14; // Matches Figma populated badge (14)
  int get _totalPhysioCount => 9; // Matches Figma (9)
  int get _totalHydroCount => 5; // Matches Figma (5)
  String get _currentProgressText => '70%'; // Matches Figma (70%)
  String get _nextApptDate => '02 Sep'; // Matches Figma
  int get _avgDurationMin => 48; // Matches Figma (48 min)

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
        icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey, size: 22),
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: 'Back',
      ),
      title: const Text(
        'Physio & Hydro',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: false,
      actions: [
        // Search quick trigger
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.primaryTextOffWhite, size: 20),
          tooltip: 'Search Sessions',
          onPressed: () {
            if (_isEmpty) {
              _toggleEmptyState(false);
            }
            _searchFocusNode.requestFocus();
          },
        ),
        // Filter options sheet
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.primaryTextOffWhite, size: 20),
          tooltip: 'Filter Options',
          onPressed: _showFilterOptionsModal,
        ),
        // Empty / Populated Toggle (Interactive testing switcher)
        IconButton(
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
            size: 26,
          ),
          tooltip: _isEmpty ? 'Switch to Populated State' : 'Switch to Empty State',
          onPressed: () => _toggleEmptyState(!_isEmpty),
        ),
        // Add Session
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.primaryTextOffWhite, size: 22),
          tooltip: 'Add Session',
          onPressed: _showAddSessionModal,
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
          // 1. Dog Selector Row
          _buildDogSelectorRow(),
          const SizedBox(height: 20),

          // 2. Rehabilitation Summary Grid (3x2, 6 boxes)
          _buildRehabSummaryGrid(),
          const SizedBox(height: 24),

          // 3. Recovery Trend Chart (Animated & Interactive)
          _buildRecoveryTrendCard(),
          const SizedBox(height: 20),

          // 4. Modality Filter Tabs
          _buildFilterTabs(),
          const SizedBox(height: 16),

          // 5. Dedicated Form Search Bar (Zero underline)
          _buildSearchBar(),
          const SizedBox(height: 24),

          // 6. Recent Sessions List
          _buildRecentSessionsSection(),
          const SizedBox(height: 24),

          // 7. Full Width Action Button (+ Add Session ->)
          _buildAddSessionCTA(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================
  // 1. DOG SELECTOR ROW
  // ==========================================
  Widget _buildDogSelectorRow() {
    return InkWell(
      onTap: _showDogSwitcherModal,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Avatar with primary-container border
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E6B57), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  _activeDog.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF2E6B57),
                    alignment: Alignment.center,
                    child: const Icon(Icons.pets, size: 20, color: Color(0xFF95D3BB)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activeDog.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _activeDog.breed,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. REHABILITATION SUMMARY GRID (6 boxes)
  // ==========================================
  Widget _buildRehabSummaryGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

        return Column(
          children: [
            // Top Row of 3 boxes
            Row(
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    label: 'SESSIONS',
                    icon: Icons.calendar_month_outlined,
                    valueWidget: Text(
                      '$_totalSessionsCount',
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => setState(() => _selectedFilterTab = 'All'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    label: 'PHYSIO',
                    icon: Icons.fitness_center_outlined,
                    valueWidget: Text(
                      '$_totalPhysioCount',
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => setState(() => _selectedFilterTab = 'Physiotherapy'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    label: 'HYDRO',
                    icon: Icons.pool_outlined,
                    valueWidget: Text(
                      '$_totalHydroCount',
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => setState(() => _selectedFilterTab = 'Hydrotherapy'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacing),
            // Bottom Row of 3 boxes
            Row(
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    label: 'PROGRESS',
                    icon: Icons.trending_up,
                    valueWidget: Text(
                      _currentProgressText,
                      style: const TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    label: 'NEXT APPT',
                    icon: Icons.event_available_outlined,
                    valueWidget: Text(
                      _nextApptDate,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: _buildSummaryBox(
                    label: 'AVG DUR',
                    icon: Icons.timer_outlined,
                    valueWidget: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$_avgDurationMin',
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'min',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
    required String label,
    required IconData icon,
    required Widget valueWidget,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Icon(icon, size: 15, color: AppColors.secondaryTextStoneGrey),
              ],
            ),
            valueWidget,
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. RECOVERY TREND CHART (Animated & Interactive)
  // ==========================================
  Widget _buildRecoveryTrendCard() {
    final activePoint = _trendPoints[_selectedChartPointIndex.clamp(0, _trendPoints.length - 1)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recovery Trend',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  // Replay animation smoothly
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
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2E6B57).withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF95D3BB),
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
                  '${activePoint.recoveryPercent.toInt()}% Recovery',
                  style: const TextStyle(
                    color: Color(0xFF95D3BB),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activePoint.milestone,
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
          const SizedBox(height: 16),

          // Animated Chart Area
          SizedBox(
            height: 150,
            child: AnimatedBuilder(
              animation: _chartCurveAnimation,
              builder: (context, child) {
                final animValue = _chartCurveAnimation.value;

                final List<FlSpot> animatedSpots = List.generate(_trendPoints.length, (i) {
                  final targetY = _trendPoints[i].recoveryPercent;
                  // Animate smoothly upward from 0.0 to targetY
                  return FlSpot(i.toDouble(), targetY * animValue);
                });

                return Stack(
                  children: [
                    // Y Axis labels (100%, 50%, 0%)
                    Positioned(
                      left: 0,
                      top: 4,
                      bottom: 24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('100%', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                          Text('50%', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                          Text('0%', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                        ],
                      ),
                    ),

                    // The fl_chart LineChart with touch interaction
                    Padding(
                      padding: const EdgeInsets.only(left: 36, right: 6, bottom: 20),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (_trendPoints.length - 1).toDouble(),
                          minY: 0,
                          maxY: 100,
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
                          titlesData: const FlTitlesData(
                            show: false, // Custom X-axis rendered below
                          ),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) => [], // Custom header box
                            ),
                            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                              if (touchResponse != null &&
                                  touchResponse.lineBarSpots != null &&
                                  touchResponse.lineBarSpots!.isNotEmpty) {
                                final spotIndex = touchResponse.lineBarSpots!.first.spotIndex;
                                if (spotIndex >= 0 &&
                                    spotIndex < _trendPoints.length &&
                                    spotIndex != _selectedChartPointIndex) {
                                  setState(() {
                                    _selectedChartPointIndex = spotIndex;
                                  });
                                }
                              }
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: animatedSpots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: const Color(0xFF2E6B57),
                              barWidth: 3.0,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF2E6B57).withValues(alpha: 0.28),
                                    const Color(0xFF2E6B57).withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) => true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final isSelected = index == _selectedChartPointIndex;
                                  return FlDotCirclePainter(
                                    radius: isSelected ? 6.0 : 3.5,
                                    color: isSelected
                                        ? const Color(0xFF95D3BB)
                                        : const Color(0xFF2E6B57),
                                    strokeWidth: isSelected ? 2.5 : 1.5,
                                    strokeColor: isSelected
                                        ? Colors.white
                                        : const Color(0xFF95D3BB),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // X-Axis Month Labels along bottom
                    Positioned(
                      left: 36,
                      right: 6,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_trendPoints.length, (index) {
                          final isSelected = index == _selectedChartPointIndex;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedChartPointIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Text(
                                _trendPoints[index].month,
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
  // 4. FILTER TABS
  // ==========================================
  Widget _buildFilterTabs() {
    final tabs = [
      'All',
      'Physiotherapy',
      'Hydrotherapy',
      'Underwater Treadmill',
      'Massage',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == _selectedFilterTab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilterTab = tab;
                });
              },
              borderRadius: BorderRadius.circular(24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E6B57) : AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2E6B57)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFAAE9D0)
                        : AppColors.secondaryTextStoneGrey,
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
                hintText: 'Search therapist, clinic, exercises...',
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
  // 6. RECENT SESSIONS SECTION
  // ==========================================
  Widget _buildRecentSessionsSection() {
    final list = _filteredSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Sessions',
              style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${list.length} sessions',
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                const Icon(Icons.search_off, size: 36, color: AppColors.secondaryTextStoneGrey),
                const SizedBox(height: 12),
                const Text(
                  'No matching sessions found',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Try adjusting your search query or modality filters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                      _selectedFilterTab = 'All';
                    });
                  },
                  child: const Text('Reset Filters', style: TextStyle(color: Color(0xFF95D3BB))),
                ),
              ],
            ),
          )
        else
          ...list.map((session) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSessionCard(session),
              )),
      ],
    );
  }

  Widget _buildSessionCard(RehabSession session) {
    IconData typeIcon;
    Color iconColor;

    switch (session.type) {
      case RehabType.physiotherapy:
        typeIcon = Icons.fitness_center_outlined;
        iconColor = const Color(0xFF2E6B57);
        break;
      case RehabType.hydrotherapy:
        typeIcon = Icons.pool_outlined;
        iconColor = const Color(0xFF5D8FAF); // Alpine blue
        break;
      case RehabType.underwaterTreadmill:
        typeIcon = Icons.directions_walk_outlined;
        iconColor = const Color(0xFF95D3BB);
        break;
      case RehabType.massage:
        typeIcon = Icons.spa_outlined;
        iconColor = const Color(0xFFB6CCB5);
        break;
      case RehabType.all:
        typeIcon = Icons.medical_services_outlined;
        iconColor = const Color(0xFF2E6B57);
        break;
    }

    final isImproving = session.trendStatus.contains('IMPROVING');

    return InkWell(
      onTap: () => _showSessionDetailsModal(session),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(typeIcon, size: 16, color: iconColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              session.title,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${session.therapist} • ${session.clinic}',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${session.durationMinutes} min',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Condition Tag Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.medical_services_outlined, size: 13, color: AppColors.errorDestructive),
                  const SizedBox(width: 6),
                  Text(
                    session.conditionTag,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Animated Recovery Progress Bar & Status
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recovery',
                              style: TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(session.recoveryProgress * 100).toInt()}%',
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Animated progress bar
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: session.recoveryProgress),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Stack(
                              children: [
                                Container(
                                  height: 4,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundObsidian,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: value.clamp(0.0, 1.0),
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E6B57),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    session.trendStatus,
                    style: TextStyle(
                      color: isImproving
                          ? const Color(0xFF95D3BB)
                          : AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
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

  // ==========================================
  // 7. FULL WIDTH ACTION BUTTON (+ Add Session ->)
  // ==========================================
  Widget _buildAddSessionCTA() {
    return InkWell(
      onTap: _showAddSessionModal,
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
          children: const [
            Icon(Icons.add, color: Color(0xFFAAE9D0), size: 20),
            SizedBox(width: 8),
            Text(
              'Add Session',
              style: TextStyle(
                color: Color(0xFFAAE9D0),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward, color: Color(0xFFAAE9D0), size: 18),
          ],
        ),
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
          // Top Dog Card (Matches Image 2)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                _buildDogAvatar(_activeDog.avatarUrl, size: 42),
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
                        '${_activeDog.breed} · ${_activeDog.age}',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 70),

          // Large Water Waves Icon Badge
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
                Icons.waves,
                color: Color(0xFF95D3BB),
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'No Rehabilitation Sessions',
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
              'Track every physiotherapy and hydrotherapy session throughout ${_activeDog.name}\'s recovery journey.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Add Session Button
          _buildAddSessionCTA(),
          const SizedBox(height: 20),

          // Learn about Rehabilitation Tracking link
          Center(
            child: GestureDetector(
              onTap: _showLearnRehabModal,
              child: const Text(
                'Learn about Rehabilitation Tracking',
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

  // ==========================================
  // INTERACTIVE MODALS (ZERO SNACKBARS)
  // ==========================================

  // 1. ADD REHABILITATION SESSION MODAL
  void _showAddSessionModal() {
    final titleController = TextEditingController();
    final therapistController = TextEditingController(text: 'Dr. Emma Walsh');
    final clinicController = TextEditingController(text: 'Peak Rehab Clinic');
    final durationController = TextEditingController(text: '45');
    final conditionController = TextEditingController(text: 'LEFT FORELEG STRAIN');
    final notesController = TextEditingController();

    RehabType selectedType = RehabType.physiotherapy;
    double recoveryValue = 0.65;
    String selectedTrend = 'IMPROVING ↑';

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
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Rehab Session',
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

                      // Modality Type Selector
                      const Text(
                        'MODALITY',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          RehabType.physiotherapy,
                          RehabType.hydrotherapy,
                          RehabType.underwaterTreadmill,
                          RehabType.massage,
                        ].map((type) {
                          final isSel = selectedType == type;
                          return ChoiceChip(
                            label: Text(type.label),
                            selected: isSel,
                            selectedColor: const Color(0xFF2E6B57),
                            backgroundColor: AppColors.backgroundObsidian,
                            labelStyle: TextStyle(
                              color: isSel
                                  ? const Color(0xFFAAE9D0)
                                  : AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                            ),
                            onSelected: (val) {
                              setModalState(() {
                                selectedType = type;
                                if (type == RehabType.hydrotherapy) {
                                  clinicController.text = 'AquaVet Centre';
                                  therapistController.text = 'Sarah Kimani';
                                } else if (type == RehabType.physiotherapy) {
                                  clinicController.text = 'Peak Rehab Clinic';
                                  therapistController.text = 'Dr. Emma Walsh';
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Session Title
                      _buildModalField('SESSION TITLE', titleController, 'e.g. Gait & Mobility Session'),
                      const SizedBox(height: 12),

                      // Therapist & Clinic
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalField('THERAPIST', therapistController, 'Therapist Name'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModalField('DURATION (MIN)', durationController, '45', keyboardType: TextInputType.number),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildModalField('CLINIC / FACILITY', clinicController, 'Clinic Name'),
                      const SizedBox(height: 12),

                      _buildModalField('CONDITION / DIAGNOSIS', conditionController, 'e.g. HIP DYSPLASIA'),
                      const SizedBox(height: 16),

                      // Recovery Progress Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'RECOVERY PROGRESS',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${(recoveryValue * 100).toInt()}%',
                            style: const TextStyle(
                              color: Color(0xFF95D3BB),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF2E6B57),
                          inactiveTrackColor: AppColors.backgroundObsidian,
                          thumbColor: const Color(0xFF95D3BB),
                          overlayColor: const Color(0xFF95D3BB).withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: recoveryValue,
                          min: 0.0,
                          max: 1.0,
                          divisions: 20,
                          onChanged: (val) {
                            setModalState(() => recoveryValue = val);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Trend Status Picker
                      const Text(
                        'TREND STATUS',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['IMPROVING ↑', 'NO CHANGE →', 'MONITOR ⚠'].map((trend) {
                          final isSel = selectedTrend == trend;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(trend),
                              selected: isSel,
                              selectedColor: const Color(0xFF2E6B57),
                              backgroundColor: AppColors.backgroundObsidian,
                              labelStyle: TextStyle(
                                color: isSel ? const Color(0xFFAAE9D0) : AppColors.secondaryTextStoneGrey,
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                              ),
                              onSelected: (val) => setModalState(() => selectedTrend = trend),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      _buildModalField('SESSION NOTES', notesController, 'Key observations and exercises done...', maxLines: 3),
                      const SizedBox(height: 24),

                      // Save Button
                      InkWell(
                        onTap: () {
                          final newSession = RehabSession(
                            id: 'sess_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim().isEmpty
                                ? '${selectedType.label} Session'
                                : titleController.text.trim(),
                            type: selectedType,
                            therapist: therapistController.text.trim().isEmpty
                                ? 'Dr. Emma Walsh'
                                : therapistController.text.trim(),
                            clinic: clinicController.text.trim().isEmpty
                                ? 'Peak Rehab Clinic'
                                : clinicController.text.trim(),
                            durationMinutes: int.tryParse(durationController.text.trim()) ?? 45,
                            conditionTag: conditionController.text.trim().isEmpty
                                ? 'LEFT FORELEG STRAIN'
                                : conditionController.text.trim().toUpperCase(),
                            recoveryProgress: recoveryValue,
                            trendStatus: selectedTrend,
                            date: DateTime.now(),
                            notes: notesController.text.trim().isEmpty
                                ? 'Completed scheduled physical therapy routine with steady progress.'
                                : notesController.text.trim(),
                            exercises: [
                              'Active range of motion therapy',
                              'Joint stability reinforcement',
                              'Cooldown and myofascial release',
                            ],
                          );

                          Navigator.pop(ctx);
                          setState(() {
                            _isEmpty = false;
                            _sessions.insert(0, newSession);
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
                            'Save Session',
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

  Widget _buildModalField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
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
            keyboardType: keyboardType,
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

  // 2. SESSION DETAILS MODAL
  void _showSessionDetailsModal(RehabSession session) {
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
                          session.title,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
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
                    '${session.therapist} • ${session.clinic}',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Info Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDetailBadge(Icons.timer_outlined, '${session.durationMinutes} min'),
                      _buildDetailBadge(Icons.medical_services_outlined, session.conditionTag),
                      _buildDetailBadge(Icons.trending_up, session.trendStatus),
                      if (session.waterTemp != null)
                        _buildDetailBadge(Icons.water_drop_outlined, session.waterTemp!),
                      if (session.treadmillSpeedKmh != null)
                        _buildDetailBadge(Icons.speed, '${session.treadmillSpeedKmh} km/h'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Recovery Bar
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recovery Progress Score',
                              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${(session.recoveryProgress * 100).toInt()}%',
                              style: const TextStyle(color: Color(0xFF95D3BB), fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: session.recoveryProgress,
                            backgroundColor: AppColors.cardsCarbon,
                            valueColor: const AlwaysStoppedAnimation(Color(0xFF2E6B57)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Exercises
                  if (session.exercises.isNotEmpty) ...[
                    const Text(
                      'EXERCISES PERFORMED',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    ...session.exercises.map((ex) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 5, right: 8),
                                child: Icon(Icons.check_circle, size: 14, color: Color(0xFF95D3BB)),
                              ),
                              Expanded(
                                child: Text(ex, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],

                  // Notes
                  const Text(
                    'CLINICAL NOTES',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    session.notes,
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Delete / Edit Actions (ZERO SNACKBARS)
                  Row(
                    children: [
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
                              _sessions.removeWhere((s) => s.id == session.id);
                              if (_sessions.isEmpty) _isEmpty = true;
                            });
                          },
                          child: const Text('Delete Session', style: TextStyle(color: AppColors.errorDestructive, fontSize: 13)),
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
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close', style: TextStyle(color: Color(0xFFAAE9D0), fontSize: 13)),
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

  Widget _buildDetailBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.backgroundObsidian,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF95D3BB)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
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
                          _buildDogAvatar(dog.avatarUrl, size: 36),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dog.name, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                Text('${dog.breed} · ${dog.age}', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
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

  // 4. LEARN REHABILITATION MODAL
  void _showLearnRehabModal() {
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
                        'Rehabilitation Tracking',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildLearnSection(
                    Icons.sports_gymnastics,
                    'Targeted Physiotherapy',
                    'Focuses on targeted active/passive joint range of motion (ROM), isometric stabilization, and neuromuscular muscle recruitment.',
                  ),
                  const SizedBox(height: 12),
                  _buildLearnSection(
                    Icons.pool,
                    'Hydrotherapy & Water Treadmill',
                    'Warm water (29–31°C) buoyancy offsets up to 60% of gravitational weight-bearing, permitting non-concussive cardiovascular conditioning and synovial joint lubrication.',
                  ),
                  const SizedBox(height: 12),
                  _buildLearnSection(
                    Icons.trending_up,
                    'Recovery Progression Tracking',
                    'Regular bi-weekly recovery scores objectively measure gait symmetry, carpal extension angles, and resistance to fatigue over a 6-month rehabilitation curve.',
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
                      child: const Text('Got It', style: TextStyle(color: Color(0xFFAAE9D0), fontSize: 14, fontWeight: FontWeight.w600)),
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

  Widget _buildLearnSection(IconData icon, String title, String body) {
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
                  'Filter by Modality',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...['All', 'Physiotherapy', 'Hydrotherapy', 'Underwater Treadmill', 'Massage'].map((tab) {
                  final isSelected = tab == _selectedFilterTab;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(tab, style: TextStyle(color: isSelected ? const Color(0xFF95D3BB) : AppColors.primaryTextOffWhite, fontSize: 14)),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF95D3BB)) : null,
                    onTap: () {
                      setState(() => _selectedFilterTab = tab);
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
