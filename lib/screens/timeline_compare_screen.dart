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
const Color _blue = Color(0xFF5D8FAF);

class TimelineCompareScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDogA;
  final String initialDogB;

  const TimelineCompareScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDogA = 'Koda',
    this.initialDogB = 'Murphy',
  });

  @override
  State<TimelineCompareScreen> createState() => _TimelineCompareScreenState();
}

class _TimelineCompareScreenState extends State<TimelineCompareScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _dogA;
  late String _dogB;
  String _compareMode = 'Dog vs Dog'; // 'Dog vs Dog' or 'Year vs Year'
  final String _timeframe = '2026';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _dogA = widget.initialDogA;
    _dogB = widget.initialDogB;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

  void _showEducationalModal() {
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
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.compare_arrows, color: _mint, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'About Timeline Compare',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Timeline Compare enables side-by-side progression audits between dogs or across multiple years to track conditioning volume, consistency deltas, and training focus.',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
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
                  child: const Text('Got it', style: TextStyle(color: _offWhite)),
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
            if (val == 'toggle') {
              setState(() => _isEmptyState = !_isEmptyState);
            } else if (val == 'swap') {
              setState(() {
                final temp = _dogA;
                _dogA = _dogB;
                _dogB = temp;
              });
            } else if (val == 'map') {
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
              value: 'swap',
              child: Row(
                children: [
                  Icon(Icons.swap_horiz, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Swap Compare Slots', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem(
              value: 'map',
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Activity Map', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'memories',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Memories', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
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

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Center(
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
                        Icons.compare_arrows_outlined,
                        size: 46,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Not Enough Comparison Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You need records across multiple dogs or distinct timeframes to generate comparative progression analytics.',
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
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: _showEducationalModal,
                    child: const Text(
                      'Learn about Timeline Compare',
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
          ),
        ),

        // Bottom Action Bar for Empty State
        Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.tune, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Compare Parameters',
                        style: TextStyle(
                          color: _stoneGrey.withValues(alpha: 0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopulatedState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. COMPARISON SELECTOR HEADER
        _buildComparisonHeader(),
        const SizedBox(height: 16),

        // 2. 3-METRIC COMPARISON BENTO
        _buildComparativeBento(),
        const SizedBox(height: 20),

        // 3. ANIMATED COMPARATIVE LINE CHART
        _buildComparativeChartCard(),
        const SizedBox(height: 20),

        // 4. CATEGORY BREAKDOWN COMPARISON
        _buildCategoryBreakdownCard(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildComparisonHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          // Mode Switcher Pills
          Row(
            children: [
              _buildModePill('Dog vs Dog'),
              const SizedBox(width: 8),
              _buildModePill('Year vs Year'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF121517),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _timeframe,
                  style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Two Target Slots
          Row(
            children: [
              // Slot A (Mint)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131718),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _mint.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        _compareMode == 'Dog vs Dog' ? _dogA : '$_dogA (2026)',
                        style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'VS',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
              // Slot B (Blue)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131718),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _blue.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        _compareMode == 'Dog vs Dog' ? _dogB : '$_dogA (2025)',
                        style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModePill(String mode) {
    final isSelected = _compareMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _compareMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _forest : const Color(0xFF121517),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _mint : _cardBorder),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: isSelected ? _offWhite : _stoneGrey,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildComparativeBento() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildCompareMetricCol('TOTAL EVENTS', '142', '98', '+45%'),
              _buildCompareMetricCol('CONSISTENCY', '88%', '64%', '+24%'),
              _buildCompareMetricCol('LOGGED TIME', '94h', '62h', '+32h'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompareMetricCol(String label, String valA, String valB, String delta) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                valA,
                style: const TextStyle(
                  color: _mint,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const Text(' / ', style: TextStyle(color: _stoneGrey, fontSize: 13)),
              Text(
                valB,
                style: const TextStyle(
                  color: _blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFF172922),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              delta,
              style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparativeChartCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ACTIVITY PROGRESSION (MONTHLY)',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(_dogA, style: const TextStyle(color: _offWhite, fontSize: 11)),
                  const SizedBox(width: 10),
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(_dogB, style: const TextStyle(color: _offWhite, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (val, meta) {
                        const months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
                        final idx = val.toInt();
                        if (idx >= 0 && idx < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[idx],
                              style: const TextStyle(color: _stoneGrey, fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Line A (Mint)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 14),
                      FlSpot(1, 19),
                      FlSpot(2, 16),
                      FlSpot(3, 28),
                      FlSpot(4, 32),
                      FlSpot(5, 38),
                    ],
                    isCurved: true,
                    color: _mint,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _mint.withValues(alpha: 0.12),
                    ),
                  ),
                  // Line B (Blue)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 10),
                      FlSpot(1, 12),
                      FlSpot(2, 18),
                      FlSpot(3, 20),
                      FlSpot(4, 22),
                      FlSpot(5, 25),
                    ],
                    isCurved: true,
                    color: _blue,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownCard() {
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
          const Text(
            'CATEGORY FOCUS DELTA',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),

          _buildCategoryCompareRow('Training', 0.45, 0.38, _mint, _blue),
          const SizedBox(height: 12),
          _buildCategoryCompareRow('Strength & Conditioning', 0.25, 0.30, _mint, _blue),
          const SizedBox(height: 12),
          _buildCategoryCompareRow('Health Logs', 0.15, 0.18, _mint, _blue),
          const SizedBox(height: 12),
          _buildCategoryCompareRow('Milestones & Goals', 0.15, 0.14, _mint, _blue),
        ],
      ),
    );
  }

  Widget _buildCategoryCompareRow(String category, double pctA, double pctB, Color colorA, Color colorB) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
            Text(
              '${(pctA * 100).toInt()}% vs ${(pctB * 100).toInt()}%',
              style: const TextStyle(color: _stoneGrey, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pctA,
                  backgroundColor: const Color(0xFF131718),
                  valueColor: AlwaysStoppedAnimation(colorA),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pctB,
                  backgroundColor: const Color(0xFF131718),
                  valueColor: AlwaysStoppedAnimation(colorB),
                  minHeight: 6,
                ),
              ),
            ),
          ],
        ),
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
