import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'weight_tracker_screen.dart';
import 'medication_manager_screen.dart';
import 'vaccination_manager_screen.dart';
import 'vet_visits_screen.dart';
import 'injuries_recovery_screen.dart';
import 'physio_hydro_hub_screen.dart';
import 'supplements_screen.dart';
import 'health_reports_timeline_screen.dart';
import 'surgery_procedures_screen.dart';

class WeightDataPoint {
  final double dayIndex;
  final double weightKg;
  final String dateLabel;
  final String note;

  const WeightDataPoint({
    required this.dayIndex,
    required this.weightKg,
    required this.dateLabel,
    required this.note,
  });
}

class TimelineSummaryEvent {
  final String title;
  final String timeAgo;
  final IconData icon;
  final String category;

  const TimelineSummaryEvent({
    required this.title,
    required this.timeAgo,
    required this.icon,
    required this.category,
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String? avatarUrl;
  final bool isEmpty;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    this.avatarUrl,
    this.isEmpty = false,
  });
}

class HealthStatisticsScreen extends StatefulWidget {
  final bool initialEmpty;
  const HealthStatisticsScreen({super.key, this.initialEmpty = false});

  @override
  State<HealthStatisticsScreen> createState() => _HealthStatisticsScreenState();
}

class _HealthStatisticsScreenState extends State<HealthStatisticsScreen>
    with SingleTickerProviderStateMixin {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _errorMuted = Color(0xFF8B3A3A);
  late bool _isEmpty;
  late AnimationController _anim;

  // Timeframe filter: 0: 7D, 1: 30D, 2: 90D, 3: This Year, 4: Lifetime, 5: Custom
  int _selectedTimeframeIndex = 3; // "This Year"
  final List<String> _timeframeLabels = const [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'This Year',
    'Lifetime',
    'Custom',
  ];

  // Dog selector
  int _dogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDL_pJGeueYECq_s2mCvPKUChO0mJm6uQTP_L8rJkiOjeDFZSp2k8Km5b3jJyKAV4kGmQ7vEJFFz6btgzhIjIzHnTA9v9i7To_RoJz17Bce2pnnQO2AOEnXfYvRxXF3LbW3kmADLTNF6xuYrLSRo64QTwn9qOzDABXCL666BIvEIRHTJBNS3AL8_Ju_WR0CeETXTmF3BM-vd9wsQtUJGqknyTEsxkNzWTEEz2zw5g3HqtspSX64YzI',
      isEmpty: false,
    ),
    DogProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl: null,
      isEmpty: true,
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
      isEmpty: false,
    ),
  ];
  DogProfile get _dog => _dogs[_dogIndex];

  // Selected chart point for touch inspection
  int _selectedWeightPointIndex = -1;

  // Weight Trend Points dataset for Rex
  final List<WeightDataPoint> _rexWeightPoints = const [
    WeightDataPoint(dayIndex: 0, weightKg: 27.2, dateLabel: 'Jan 15', note: 'Winter baseline weight'),
    WeightDataPoint(dayIndex: 1, weightKg: 27.4, dateLabel: 'Feb 02', note: 'Post-training check'),
    WeightDataPoint(dayIndex: 2, weightKg: 27.8, dateLabel: 'Mar 10', note: 'Spring conditioning'),
    WeightDataPoint(dayIndex: 3, weightKg: 27.6, dateLabel: 'Apr 05', note: 'Routine vet scale'),
    WeightDataPoint(dayIndex: 4, weightKg: 28.0, dateLabel: 'Apr 28', note: 'Pre-surgery baseline'),
    WeightDataPoint(dayIndex: 5, weightKg: 28.1, dateLabel: 'May 18', note: 'Post-op recovery rest'),
    WeightDataPoint(dayIndex: 6, weightKg: 28.5, dateLabel: 'Jun 12', note: 'Hydrotherapy check-in'),
    WeightDataPoint(dayIndex: 7, weightKg: 28.3, dateLabel: 'Jul 04', note: 'Rehab mid-term weight'),
    WeightDataPoint(dayIndex: 8, weightKg: 28.9, dateLabel: 'Jul 24', note: 'Target muscle mass gained'),
    WeightDataPoint(dayIndex: 9, weightKg: 28.6, dateLabel: 'Aug 02', note: 'Annual health check'),
    WeightDataPoint(dayIndex: 10, weightKg: 28.4, dateLabel: 'Aug 14', note: 'Current optimal weight (-0.5kg)'),
  ];

  // Timeline events for Rex
  final List<TimelineSummaryEvent> _timelineEvents = const [
    TimelineSummaryEvent(
      title: 'Annual Checkup',
      timeAgo: '2 days ago',
      icon: Icons.medical_services,
      category: 'Vet Visit',
    ),
    TimelineSummaryEvent(
      title: 'Hydrotherapy Session',
      timeAgo: '1 week ago',
      icon: Icons.fitness_center,
      category: 'Rehab',
    ),
    TimelineSummaryEvent(
      title: 'Prescription Refill',
      timeAgo: '2 weeks ago',
      icon: Icons.medication,
      category: 'Medication',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _replay() => _anim.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildAppBar(),
      body: _isEmpty ? _buildEmptyView() : _buildPopulatedView(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.secondaryTextStoneGrey, size: 28),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Health Statistics',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 22),
          onPressed: _showFilterOptionsSheet,
        ),
        IconButton(
          icon: const Icon(Icons.ios_share, color: AppColors.secondaryTextStoneGrey, size: 22),
          onPressed: _showShareAccessSheet,
        ),
        IconButton(
          tooltip: 'Toggle empty / populated state',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : _mint,
            size: 26,
          ),
          onPressed: () {
            setState(() => _isEmpty = !_isEmpty);
            _replay();
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ==========================================
  // POPULATED VIEW
  // ==========================================
  Widget _buildPopulatedView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDogSelectorCard(),
          const SizedBox(height: 20),
          _buildTimeframeSelectorRow(),
          const SizedBox(height: 24),
          _buildHealthOverviewCard(),
          const SizedBox(height: 24),
          _buildWeightTrendChartCard(),
          const SizedBox(height: 24),
          _buildStatisticsCardsGrid(),
          const SizedBox(height: 24),
          _buildInjuryRecoveryProgressCard(),
          const SizedBox(height: 24),
          _buildTimelineSummaryCard(),
          const SizedBox(height: 24),
          _buildExportActionsGrid(),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Dog Selector Card
  // ------------------------------------------
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSelectSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildAvatar(_dog.avatarUrl, 44),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dog.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_dog.breed} • ${_dog.age}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.unfold_more,
              color: AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1D201F),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipOval(
        child: url != null
            ? Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Icon(Icons.pets, size: size * 0.5, color: _mint),
              )
            : Icon(Icons.pets, size: size * 0.5, color: _mint),
      ),
    );
  }

  // ------------------------------------------
  // Date Range Selector Row
  // ------------------------------------------
  Widget _buildTimeframeSelectorRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_timeframeLabels.length, (i) {
          final isSelected = i == _selectedTimeframeIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedTimeframeIndex = i);
                _replay();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _forest : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  _timeframeLabels[i],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ------------------------------------------
  // Health Overview Card
  // ------------------------------------------
  Widget _buildHealthOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HEALTH OVERVIEW',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricBlock(
                  label: 'Total Records',
                  targetCount: 124,
                  suffix: '',
                ),
              ),
              Expanded(
                child: _buildMetricBlock(
                  label: 'Current Weight',
                  targetCount: 28,
                  decimal: '.4',
                  suffix: ' kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricBlock(
                  label: 'Active Issues',
                  targetCount: 2,
                  suffix: '',
                  valueColor: _errorMuted,
                ),
              ),
              Expanded(
                child: _buildMetricBlock(
                  label: 'Active Meds',
                  targetCount: 3,
                  suffix: '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricBlock(
                  label: 'Supplements',
                  targetCount: 4,
                  suffix: '',
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Health Score',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          '—',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'SOON',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ],
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

  Widget _buildMetricBlock({
    required String label,
    required int targetCount,
    String? decimal,
    required String suffix,
    Color valueColor = AppColors.primaryTextOffWhite,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<int>(
          key: ValueKey('$label-$targetCount-${_anim.value == 0}'),
          tween: IntTween(begin: 0, end: targetCount),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, val, child) => RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
              children: [
                TextSpan(text: '$val'),
                if (decimal != null) TextSpan(text: decimal),
                TextSpan(
                  text: suffix,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Weight Trend Card (Interactive fl_chart LineChart)
  // ------------------------------------------
  Widget _buildWeightTrendChartCard() {
    final points = _rexWeightPoints;
    final activeSpot = _selectedWeightPointIndex >= 0 && _selectedWeightPointIndex < points.length
        ? points[_selectedWeightPointIndex]
        : points.last;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'WEIGHT TREND',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
              Icon(Icons.monitor_weight_outlined, size: 20, color: AppColors.secondaryTextStoneGrey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextOffWhite,
                          ),
                          children: [
                            TextSpan(text: activeSpot.weightKg.toStringAsFixed(1)),
                            const TextSpan(
                              text: 'kg',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '-0.5kg',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _mint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'Avg: 28.9kg',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Peak: 31.2kg',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${activeSpot.dateLabel} • ${activeSpot.note}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
          const SizedBox(height: 16),

          // Animated fl_chart LineChart with glowing curve
          SizedBox(
            height: 128,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final animCurve = Curves.easeOutCubic.transform(_anim.value);

                final spots = List.generate(points.length, (i) {
                  final target = points[i].weightKg;
                  return FlSpot(i.toDouble(), target * animCurve);
                });

                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (points.length - 1).toDouble(),
                    minY: 26.5 * animCurve,
                    maxY: 29.5,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1.0,
                      getDrawingHorizontalLine: (val) => FlLine(
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
                              spotIndex < points.length &&
                              spotIndex != _selectedWeightPointIndex) {
                            setState(() {
                              _selectedWeightPointIndex = spotIndex;
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
                        color: _forest,
                        barWidth: 2.8,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _mint.withValues(alpha: 0.18),
                              _forest.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) {
                            // Show dot at the last point or touched point
                            final idx = spot.x.toInt();
                            return idx == (points.length - 1) || idx == _selectedWeightPointIndex;
                          },
                          getDotPainter: (spot, percent, barData, index) {
                            final isLast = index == (points.length - 1);
                            return FlDotCirclePainter(
                              radius: isLast ? 4.5 : 3.5,
                              color: AppColors.backgroundObsidian,
                              strokeWidth: 2.2,
                              strokeColor: _forest,
                            );
                          },
                        ),
                      ),
                    ],
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
  // Statistics Grid (2 columns)
  // ------------------------------------------
  Widget _buildStatisticsCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Vet Visits Card
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                icon: Icons.medical_services,
                title: 'Vet Visits',
                mainValue: '14',
                footerText: '2 Emergency',
                footerColor: _errorMuted,
                extraWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildSparkBar(24, false),
                    const SizedBox(width: 3),
                    _buildSparkBar(18, false),
                    const SizedBox(width: 3),
                    _buildSparkBar(12, true),
                    const SizedBox(width: 3),
                    _buildSparkBar(16, false),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VetVisitsScreen()),
                ),
              ),
            ),

            // Medications Card
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                icon: Icons.medication,
                title: 'Medications',
                mainValue: '3',
                extraWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMedsLegendDot('Apoquel', _mint),
                    const SizedBox(height: 3),
                    _buildMedsLegendDot('Fish Oil', AppColors.secondaryTextStoneGrey),
                    const SizedBox(height: 3),
                    _buildMedsLegendDot('Meloxicam', AppColors.secondaryTextStoneGrey),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MedicationManagerScreen()),
                ),
              ),
            ),

            // Vaccinations Card
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                icon: Icons.vaccines,
                title: 'Vaccinations',
                mainValue: '5',
                mainValueSuffix: 'Up to date',
                mainValueSuffixColor: _mint,
                footerText: '1 Overdue',
                footerColor: _errorMuted,
                progressBarPct: 0.80,
                progressBarColor: _mint,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VaccinationManagerScreen()),
                ),
              ),
            ),

            // Injuries Card
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                icon: Icons.personal_injury,
                iconColor: _errorMuted,
                title: 'Injuries',
                mainValue: '3',
                mainValueSuffix: '1 ACTIVE',
                mainValueSuffixColor: _errorMuted,
                footerText: '2 Resolved',
                footerColor: AppColors.secondaryTextStoneGrey,
                progressBarPct: 0.65,
                progressBarColor: _errorMuted,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InjuriesRecoveryScreen()),
                ),
              ),
            ),

            // Rehabilitation Card
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                icon: Icons.fitness_center,
                title: 'Rehabilitation',
                mainValue: '18',
                footerWidget: Row(
                  children: const [
                    Text('Physio: ', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    Text('12  ', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                    Text('Hydro: ', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    Text('6', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhysioHydroHubScreen()),
                ),
              ),
            ),

            // Supplements Card
            SizedBox(
              width: cardWidth,
              child: _buildStatCard(
                icon: Icons.eco,
                title: 'Supplements',
                mainValue: '4',
                middleWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Consistency', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11)),
                    Text('88%', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                progressBarPct: 0.88,
                progressBarColor: _mint,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupplementsScreen()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    Color iconColor = _mint,
    required String title,
    required String mainValue,
    String? mainValueSuffix,
    Color? mainValueSuffixColor,
    String? footerText,
    Color? footerColor,
    Widget? footerWidget,
    Widget? extraWidget,
    Widget? middleWidget,
    double? progressBarPct,
    Color progressBarColor = _mint,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right, size: 16, color: AppColors.secondaryTextStoneGrey),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      mainValue,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    if (mainValueSuffix != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        mainValueSuffix,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: mainValueSuffixColor ?? AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ],
                  ],
                ),
                ?extraWidget,
              ],
            ),
            if (middleWidget != null) ...[
              const SizedBox(height: 8),
              middleWidget,
            ],
            if (progressBarPct != null) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 4,
                  width: double.infinity,
                  color: const Color(0xFF1D201F),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progressBarPct,
                    child: Container(color: progressBarColor),
                  ),
                ),
              ),
            ],
            if (footerText != null) ...[
              const SizedBox(height: 8),
              Text(
                footerText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: footerColor ?? AppColors.secondaryTextStoneGrey,
                ),
              ),
            ],
            if (footerWidget != null) ...[
              const SizedBox(height: 8),
              footerWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSparkBar(double height, bool isPrimary) {
    return Container(
      width: 5,
      height: height,
      decoration: BoxDecoration(
        color: isPrimary ? _forest : const Color(0xFF323533),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
      ),
    );
  }

  Widget _buildMedsLegendDot(String name, Color dotColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
        ),
        const SizedBox(width: 4),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: AppColors.secondaryTextStoneGrey,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Injury & Recovery Progress Section
  // ------------------------------------------
  Widget _buildInjuryRecoveryProgressCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INJURY & RECOVERY PROGRESS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecoveryBarRow('ACL Repair', 0.65, _errorMuted),
          const SizedBox(height: 14),
          _buildRecoveryBarRow('GDV Surgery', 0.85, _forest),
          const SizedBox(height: 14),
          _buildRecoveryBarRow('Paw Laceration', 1.0, _mint),
        ],
      ),
    );
  }

  Widget _buildRecoveryBarRow(String label, double pct, Color barColor) {
    final pctInt = (pct * 100).toInt();

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SurgeryProceduresScreen()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.primaryTextOffWhite,
                ),
              ),
              Text(
                '$pctInt%',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 5,
              width: double.infinity,
              color: const Color(0xFF1D201F),
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, child) {
                  final progress = (pct * Curves.easeOutCubic.transform(_anim.value)).clamp(0.0, 1.0);
                  return FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(color: barColor),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Timeline Summary Card
  // ------------------------------------------
  Widget _buildTimelineSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'TIMELINE SUMMARY',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
              Text(
                '4 events this mo',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_timelineEvents.length, (i) {
            final e = _timelineEvents[i];
            final isLast = i == _timelineEvents.length - 1;
            return Container(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12, top: i == 0 ? 0 : 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isLast ? Colors.transparent : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF323533),
                    ),
                    child: Icon(e.icon, size: 16, color: _mint),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e.timeAgo,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HealthReportsTimelineScreen()),
            ),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'View All 47 Events',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextOffWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Export Actions Grid
  // ------------------------------------------
  Widget _buildExportActionsGrid() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: _showPdfReportSheet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: const [
                  Icon(Icons.picture_as_pdf, size: 24, color: AppColors.primaryTextOffWhite),
                  SizedBox(height: 8),
                  Text(
                    'PDF Report',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: InkWell(
            onTap: _showShareAccessSheet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: const [
                  Icon(Icons.share, size: 24, color: AppColors.primaryTextOffWhite),
                  SizedBox(height: 8),
                  Text(
                    'Share Access',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // EMPTY VIEW (Matching Image 2)
  // ==========================================
  Widget _buildEmptyView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dog Selector showing selected profile
          _buildDogSelectorCard(),
          const SizedBox(height: 20),

          // Timeframe pills
          _buildTimeframeSelectorRow(),
          const SizedBox(height: 24),

          // Blank Health Overview Card with Dash indicators
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Health Overview',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    InkWell(
                      onTap: _showLearnSheet,
                      child: const Icon(Icons.info_outline, size: 18, color: AppColors.secondaryTextStoneGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _buildEmptyOverviewCell('HEALTH SCORE', '(Coming Soon)')),
                    Expanded(child: _buildEmptyOverviewCell('AVG WEIGHT', null)),
                    Expanded(child: _buildEmptyOverviewCell('VACCINES DUE', null)),
                    Expanded(child: _buildEmptyOverviewCell('VET VISITS', null)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildEmptyOverviewCell('MEDS ACTIVE', null)),
                    Expanded(child: _buildEmptyOverviewCell('INCIDENTS', null)),
                    const Expanded(child: SizedBox()),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),

          // Big Circular Chart Icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1D201F),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.ssid_chart,
                size: 38,
                color: _mint,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Headline & Subtitle
          const Text(
            'Not Enough Health Data',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Add more health records to unlock detailed statistics and long-term trends.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.secondaryTextStoneGrey,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Primary CTA Button
          InkWell(
            onTap: _showAddRecordSheet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _forest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.primaryTextOffWhite, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Add Health Record',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Educational Link
          Center(
            child: TextButton(
              onPressed: _showLearnSheet,
              child: const Text(
                'Learn about Health Statistics',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _mint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOverviewCell(String label, String? sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 6),
        if (sub != null)
          Text(
            sub,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.secondaryTextStoneGrey,
            ),
          )
        else
          Container(
            width: 24,
            height: 2.5,
            color: AppColors.primaryTextOffWhite,
          ),
      ],
    );
  }

  // ==========================================
  // MODALS & SHEETS
  // ==========================================

  Future<T?> _showSheet<T>(Widget Function(BuildContext) builder) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: builder,
    );
  }

  Widget _buildSheetHeader(BuildContext ctx, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
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
    );
  }

  void _showDogSelectSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Select Dog Profile'),
                const SizedBox(height: 10),
                ...List.generate(_dogs.length, (i) {
                  final d = _dogs[i];
                  final isSelected = i == _dogIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _dogIndex = i;
                        _isEmpty = d.isEmpty;
                      });
                      Navigator.pop(ctx);
                      _replay();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? _forest.withValues(alpha: 0.25) : AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? _forest : Colors.white.withValues(alpha: 0.06)),
                      ),
                      child: Row(
                        children: [
                          _buildAvatar(d.avatarUrl, 38),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.name,
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${d.breed} • ${d.age}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: _mint, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }

  void _showFilterOptionsSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Filter Health Statistics'),
                const SizedBox(height: 14),
                const Text(
                  'SELECT TIMEFRAME',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_timeframeLabels.length, (i) {
                    final isSel = i == _selectedTimeframeIndex;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedTimeframeIndex = i);
                        Navigator.pop(ctx);
                        _replay();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? _forest : AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSel ? _forest : Colors.white10),
                        ),
                        child: Text(
                          _timeframeLabels[i],
                          style: TextStyle(
                            color: isSel ? Colors.white : AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showPdfReportSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Generate Health PDF Report'),
                const SizedBox(height: 12),
                const Text(
                  'Compile a comprehensive clinical dossier for veterinary review or insurance validation.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 18),
                _buildReportCheckItem('Weight & Body Condition Trends', true),
                _buildReportCheckItem('Vaccination & Parasite Certificates', true),
                _buildReportCheckItem('Orthopedic & Surgical Milestones (TPLO)', true),
                _buildReportCheckItem('Medication Adherence History', true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Export PDF Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildReportCheckItem(String label, bool initialVal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: _mint),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
        ],
      ),
    );
  }

  void _showShareAccessSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Share Health Access'),
                const SizedBox(height: 12),
                const Text(
                  'Grant temporary or permanent read-only telemetry access to your vet, physio specialist or trainer.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.link, size: 20, color: _mint),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'https://app.ulvenik.com/records/rex-7b19a',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                        ),
                      ),
                      Text('Copy', style: TextStyle(color: _mint, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showAddRecordSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Add Health Record'),
                const SizedBox(height: 12),
                const Text(
                  'Choose a health metric to record for this dog profile:',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                _buildAddOptionTile(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Weight Entry',
                  subtitle: 'Log dog body mass in kilograms',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightTrackerScreen()));
                  },
                ),
                _buildAddOptionTile(
                  icon: Icons.local_hospital_outlined,
                  title: 'Vet Consultation',
                  subtitle: 'Record clinical examination or surgery',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const VetVisitsScreen()));
                  },
                ),
                _buildAddOptionTile(
                  icon: Icons.healing_outlined,
                  title: 'Injury or Incident',
                  subtitle: 'Log strain, laceration or recovery',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const InjuriesRecoveryScreen()));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAddOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: _mint, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }

  void _showLearnSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'About Health Statistics'),
                const SizedBox(height: 12),
                const Text(
                  'Ulvenik Health Statistics aggregate your dog’s wellness records over time:\n\n'
                  '• Weight Trends: Identifies micro-fluctuations and muscular conditioning changes.\n'
                  '• Medication & Supplement Consistency: Tracks ongoing treatment adherence.\n'
                  '• Clinical Interventions: Summarizes routine checkups vs emergency visits.\n'
                  '• Recovery Trajectory: Monitors progress toward full mobility clearances.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                    ),
                    child: const Text('Got It'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
