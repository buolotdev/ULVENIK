import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_memories_screen.dart';
import 'timeline_activity_map_screen.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

// Category Colors matching Figma
const Color _catTraining = Color(0xFF5D8FAF); // Blue
const Color _catSC = Color(0xFFB4823C);       // Orange / Bronze
const Color _catHealth = Color(0xFF8B3A3A);   // Red
const Color _catGoals = Color(0xFFB8920A);    // Yellow / Gold
const Color _catMedia = Color(0xFF7E57C2);    // Purple

class TimelineCompareScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineCompareScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Murphy',
  });

  @override
  State<TimelineCompareScreen> createState() => _TimelineCompareScreenState();
}

class _TimelineCompareScreenState extends State<TimelineCompareScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  String _selectedPreset = 'This Month vs Last Month';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _selectedDog = widget.initialDog;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showDatePickerModal(String period) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'SELECT $period',
                style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose comparison month or custom date interval for period analysis.',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  _buildPeriodOption('Sep 2026', true),
                  _buildPeriodOption('Aug 2026', false),
                  _buildPeriodOption('Jul 2026', false),
                  _buildPeriodOption('Jun 2026', false),
                  _buildPeriodOption('Custom Date Range...', false),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _forest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Apply', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _forest : _obsidian,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _mint : _cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? _offWhite : _stoneGrey, fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400),
        ),
      ),
    );
  }

  void _showMilestoneEventModal(String title, String date) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 18),
              const Text('MILESTONE EVENT DETAILS', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Recorded on $date • $_selectedDog', style: const TextStyle(color: _stoneGrey, fontSize: 13)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _forest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TimelineScreen()),
                    );
                  },
                  child: const Text('Open in Timeline', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isEmptyState ? _buildEmptyState() : _buildPopulatedState(),
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
        'Timeline Compare',
        style: TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
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
            setState(() => _isEmptyState = !_isEmptyState);
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
            if (val == 'map') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineActivityMapScreen()),
              );
            } else if (val == 'memories') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineMemoriesScreen()),
              );
            } else if (val == 'insights') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineInsightsScreen()),
              );
            } else if (val == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSettingsScreen()),
              );
            }
          },
          itemBuilder: (ctx) => const [
            PopupMenuItem(
              value: 'map',
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Activity Map', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'memories',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Memories', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'insights',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Insights', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Settings', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // POPULATED STATE (Matching Figma 'Timeline Compare - Populated State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedState() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // Top Period A vs Period B Selector Cards
              _buildPeriodHeader(isEmpty: false),
              const SizedBox(height: 12),

              // Presets Row (This Week vs Last Week | This Month vs Last Month)
              _buildPresetsRow(),
              const SizedBox(height: 18),

              // 1. Summary Bento Table
              _buildSummarySection(),
              const SizedBox(height: 16),

              // 2. Categories Bento Table & Proportional Distribution Bar
              _buildCategoriesSection(),
              const SizedBox(height: 16),

              // 3. Activity Chart (Interactive animated fl_chart dual line)
              _buildActivityChartSection(),
              const SizedBox(height: 16),

              // 4. Recording Consistency Table
              _buildConsistencySection(),
              const SizedBox(height: 16),

              // 5. Locations Table
              _buildLocationsSection(),
              const SizedBox(height: 16),

              // 6. Attachments Grid (2x2)
              _buildAttachmentsSection(),
              const SizedBox(height: 16),

              // 7. Milestones List
              _buildMilestonesSection(),
            ],
          ),
        ),

        // Bottom Action Bar: Change Dates | Export
        _buildBottomSplitBar(isEmpty: false),
      ],
    );
  }

  Widget _buildPeriodHeader({required bool isEmpty}) {
    return Row(
      children: [
        // Period A Card
        Expanded(
          child: GestureDetector(
            onTap: () => _showDatePickerModal('PERIOD A'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: const Border(
                  left: BorderSide(color: _mint, width: 3),
                  top: BorderSide(color: _cardBorder),
                  right: BorderSide(color: _cardBorder),
                  bottom: BorderSide(color: _cardBorder),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PERIOD A',
                        style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                      ),
                      Icon(Icons.edit, color: _stoneGrey, size: 14),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sep 2026',
                    style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEmpty ? 'No Data' : '74 Events',
                    style: TextStyle(color: isEmpty ? _stoneGrey : _mint, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Center VS Circle
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _obsidian,
            border: Border.all(color: _cardBorder, width: 1.5),
          ),
          child: const Center(
            child: Text(
              'VS',
              style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
        ),

        // Period B Card
        Expanded(
          child: GestureDetector(
            onTap: () => _showDatePickerModal('PERIOD B'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: const Border(
                  left: BorderSide(color: _catTraining, width: 3),
                  top: BorderSide(color: _cardBorder),
                  right: BorderSide(color: _cardBorder),
                  bottom: BorderSide(color: _cardBorder),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PERIOD B',
                        style: TextStyle(color: _catTraining, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                      ),
                      Icon(Icons.edit, color: _stoneGrey, size: 14),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Aug 2026',
                    style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEmpty ? 'No Data' : '61 Events',
                    style: TextStyle(color: isEmpty ? _stoneGrey : _catTraining, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetsRow() {
    final presets = ['This Week vs Last Week', 'This Month vs Last Month'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: presets.map((preset) {
          final isSelected = _selectedPreset == preset;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPreset = preset),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? _mint : _cardBorder),
                ),
                child: Text(
                  preset,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 1. Summary Card
  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildTableHeader(
            title: 'Summary',
            icon: Icons.list_alt,
            colA: 'SEP (A)',
            colB: 'AUG (B)',
            colDiff: 'DIFF',
          ),
          const SizedBox(height: 12),
          _buildTableRow('Total Events', '74', '61', '-13', diffIsNegative: true),
          _buildTableRow('Recording Days', '22', '18', '-4', diffIsNegative: true),
          _buildTableRow('First Event', '1 Sep', '1 Aug', '—'),
          _buildTableRow('Last Event', '14 Sep', '31 Aug', '—'),
        ],
      ),
    );
  }

  // 2. Categories Card & Proportional Distribution Bar
  Widget _buildCategoriesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(
            title: 'Categories',
            icon: Icons.category_outlined,
            colA: 'A',
            colB: 'B',
            colDiff: 'DIFF',
          ),
          const SizedBox(height: 12),
          _buildCategoryRow('Training', _catTraining, '34', '28', '-6'),
          _buildCategoryRow('S&C', _catSC, '18', '16', '-2'),
          _buildCategoryRow('Health', _catHealth, '8', '6', '-2'),
          _buildCategoryRow('Goals', _catGoals, '10', '7', '-3'),
          _buildCategoryRow('Media', _catMedia, '4', '4', '0'),
          const SizedBox(height: 16),

          // Stacked Proportional Distribution Bar
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
                // Period A bar
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PERIOD A (SEP)', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                    Text('100% (74)', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                _buildStackedProportionalBar(
                  ratios: [0.46, 0.24, 0.11, 0.13, 0.06],
                  colors: [_catTraining, _catSC, _catHealth, _catGoals, _catMedia],
                ),
                const SizedBox(height: 12),

                // Period B bar
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PERIOD B (AUG)', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                    Text('100% (61)', style: TextStyle(color: _catTraining, fontSize: 10, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                _buildStackedProportionalBar(
                  ratios: [0.45, 0.26, 0.10, 0.12, 0.07],
                  colors: [_catTraining, _catSC, _catHealth, _catGoals, _catMedia],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Proportional to total events in each period',
                  style: TextStyle(color: _stoneGrey, fontSize: 10, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedProportionalBar({
    required List<double> ratios,
    required List<Color> colors,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 8,
        child: Row(
          children: List.generate(ratios.length, (idx) {
            return Expanded(
              flex: (ratios[idx] * 100).toInt(),
              child: Container(color: colors[idx]),
            );
          }),
        ),
      ),
    );
  }

  // 3. Interactive Animated fl_chart Dual-Line Graph
  Widget _buildActivityChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.show_chart, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Activity',
                    style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                  ),
                ],
              ),
              Text(
                'EVENTS / DAY',
                style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart Container
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (val) => FlLine(color: const Color(0x10FFFFFF), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        const days = ['Day 1', 'Day 7', 'Day 14', 'Day 21', 'Day 28', 'End'];
                        final int index = val.toInt();
                        if (index >= 0 && index < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              days[index],
                              style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 8,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isA = spot.barIndex == 0;
                        return LineTooltipItem(
                          '${isA ? "Sep" : "Aug"}: ${spot.y.toInt()} events',
                          TextStyle(
                            color: isA ? _mint : _catTraining,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Period A (Sep 2026 - Green Line)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1.8),
                      FlSpot(1, 4.2),
                      FlSpot(2, 3.8),
                      FlSpot(3, 5.4),
                      FlSpot(4, 4.9),
                      FlSpot(5, 5.2),
                    ],
                    isCurved: true,
                    color: _mint,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                  ),

                  // Period B (Aug 2026 - Blue Line)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 2.2),
                      FlSpot(1, 3.5),
                      FlSpot(2, 4.6),
                      FlSpot(3, 3.2),
                      FlSpot(4, 4.5),
                      FlSpot(5, 3.8),
                    ],
                    isCurved: true,
                    color: _catTraining,
                    barWidth: 2.2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Chart Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegendItem('Sep 2026 (A)', _mint),
              const SizedBox(width: 24),
              _buildChartLegendItem('Aug 2026 (B)', _catTraining),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // 4. Recording Consistency Table
  Widget _buildConsistencySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildTableHeader(
            title: 'Recording Consistency',
            icon: Icons.local_fire_department_outlined,
            colA: 'A',
            colB: 'B',
            colDiff: 'DIFF',
          ),
          const SizedBox(height: 12),
          _buildTableRow('Recording Days', '22', '18', '-4', diffIsNegative: true),
          _buildTableRow('Avg Events/Day', '3.4', '3.4', '0'),
          _buildTableRow('Longest Streak', '9 d', '7 d', '-2', diffIsNegative: true),
          _buildTableRow('Longest Gap', '2 d', '3 d', '+1', diffIsPositive: true),
        ],
      ),
    );
  }

  // 5. Locations Table
  Widget _buildLocationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(
            title: 'Locations',
            icon: Icons.pin_drop_outlined,
            colA: 'A',
            colB: 'B',
            colDiff: 'DIFF',
          ),
          const SizedBox(height: 12),
          _buildTableRow('Locations Visited', '8', '6', '-2', diffIsNegative: true),
          _buildTableRow('New Locations', '2', '1', '-1', diffIsNegative: true),
          _buildTableRow('Shared Locations', '5', '5', '—'),
          const SizedBox(height: 12),
          const Divider(color: Color(0x14FFFFFF), height: 1),
          const SizedBox(height: 10),
          const Text('Most Visited (A): Riverside Trail — 14 visits', style: TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(height: 2),
          const Text('Most Visited (B): Training Field B — 11 visits', style: TextStyle(color: _stoneGrey, fontSize: 11)),
        ],
      ),
    );
  }

  // 6. Attachments Section (2x2 Grid)
  Widget _buildAttachmentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.camera_alt_outlined, color: _mint, size: 18),
              SizedBox(width: 8),
              Text('Attachments', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildAttachmentBentoTile('PHOTOS', '42', '31')),
              const SizedBox(width: 10),
              Expanded(child: _buildAttachmentBentoTile('VIDEOS', '14', '9')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildAttachmentBentoTile('VOICE NOTES', '6', '4')),
              const SizedBox(width: 10),
              Expanded(child: _buildAttachmentBentoTile('DOCUMENTS', '3', '2')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentBentoTile(String label, String countA, String countB) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _obsidian,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: countA, style: const TextStyle(color: _mint, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                const TextSpan(text: ' / ', style: TextStyle(color: _stoneGrey, fontSize: 14, fontFamily: 'Inter')),
                TextSpan(text: countB, style: const TextStyle(color: _catTraining, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 7. Milestones Section
  Widget _buildMilestonesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: _mint, size: 18),
              SizedBox(width: 8),
              Text('Milestones', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
            ],
          ),
          const SizedBox(height: 14),
          _buildMilestoneItem(
            periodBadge: 'A',
            periodColor: _mint,
            title: '100th Timeline Entry',
            date: '3 Sep 2026',
            onTap: () => _showMilestoneEventModal('100th Timeline Entry', '3 Sep 2026'),
          ),
          const SizedBox(height: 10),
          _buildMilestoneItem(
            periodBadge: 'B',
            periodColor: _catTraining,
            title: 'First Hydrotherapy Session',
            date: '12 Aug 2026',
            onTap: () => _showMilestoneEventModal('First Hydrotherapy Session', '12 Aug 2026'),
          ),
          const SizedBox(height: 10),
          _buildMilestoneItem(
            periodBadge: 'A',
            periodColor: _mint,
            title: 'Goal Completed: Distance Down Stay',
            date: '9 Sep 2026',
            onTap: () => _showMilestoneEventModal('Goal Completed: Distance Down Stay', '9 Sep 2026'),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem({
    required String periodBadge,
    required Color periodColor,
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: periodColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: periodColor.withValues(alpha: 0.5)),
          ),
          child: Center(
            child: Text(
              periodBadge,
              style: TextStyle(color: periodColor, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(date, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Row(
            children: [
              Text('View Event', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, color: _mint, size: 12),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // HELPER TABLE BUILDERS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildTableHeader({
    required String title,
    required IconData icon,
    required String colA,
    required String colB,
    required String colDiff,
  }) {
    return Row(
      children: [
        Icon(icon, color: _mint, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(colA, textAlign: TextAlign.right, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          child: Text(colB, textAlign: TextAlign.right, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text(colDiff, textAlign: TextAlign.right, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildTableRow(
    String label,
    String valA,
    String valB,
    String diff, {
    bool diffIsNegative = false,
    bool diffIsPositive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 13)),
          ),
          SizedBox(
            width: 50,
            child: Text(valA, textAlign: TextAlign.right, style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: Text(valB, textAlign: TextAlign.right, style: const TextStyle(color: _catTraining, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: Text(
              diff,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: diffIsNegative ? const Color(0xFFE57373) : (diffIsPositive ? _mint : _stoneGrey),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String label, Color dotColor, String valA, String valB, String diff) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(color: _offWhite, fontSize: 13)),
          ),
          SizedBox(
            width: 50,
            child: Text(valA, textAlign: TextAlign.right, style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: Text(valB, textAlign: TextAlign.right, style: const TextStyle(color: _catTraining, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: Text(
              diff,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: diff.startsWith('-') ? const Color(0xFFE57373) : (diff == '0' ? _stoneGrey : _mint),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSplitBar({required bool isEmpty}) {
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
              onTap: () => _showDatePickerModal('DATES'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Change Dates', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 20, color: const Color(0x1AFFFFFF)),
          Expanded(
            child: InkWell(
              onTap: isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exporting comparison PDF summary...')),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload_outlined, color: isEmpty ? _stoneGrey.withValues(alpha: 0.4) : _stoneGrey, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Export',
                      style: TextStyle(
                        color: isEmpty ? _stoneGrey.withValues(alpha: 0.4) : _offWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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

  // ════════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matching Figma 'Timeline Compare - Empty State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [
                // Period A vs B with No Data
                _buildPeriodHeader(isEmpty: true),
                const SizedBox(height: 12),
                _buildPresetsRow(),
                const SizedBox(height: 48),

                // Device comparison icon inside dashed outline
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.compare_arrows, color: _mint, size: 36),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Not Enough Timeline Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  'Add more records to your Timeline before meaningful comparisons can be displayed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        Text('Go to Timeline', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // "What gets compared?" card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.trending_up, color: _mint, size: 22),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What gets compared?',
                              style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Gait velocity, heart variability & track scent accuracy across matching timeframes.',
                              style: TextStyle(color: _stoneGrey, fontSize: 11, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildBottomSplitBar(isEmpty: true),
      ],
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
