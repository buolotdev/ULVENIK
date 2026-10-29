import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_settings_screen.dart';
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

// Category Colors
const Color _catTraining = Color(0xFF5D8FAF); // Alpine Blue
const Color _catSC = Color(0xFFDD6B20); // Orange / S&C
const Color _catHealth = Color(0xFFE53E3E); // Red / Coral
const Color _catGoals = Color(0xFFECC94B); // Yellow
const Color _catConsistency = Color(0xFF48BB78); // Green
const Color _catMilestone = Color(0xFF38B2AC); // Teal

class TimelineInsightsScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineInsightsScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineInsightsScreen> createState() => _TimelineInsightsScreenState();
}

class _TimelineInsightsScreenState extends State<TimelineInsightsScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  String? _selectedCategoryFilter;
  bool _isRefreshing = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  // Accordion Expand/Collapse Map
  final Map<String, bool> _expandedCategories = {
    'Recording Consistency': true,
    'Training': false,
    'Strength & Conditioning': false,
    'Health': false,
    'Goals': false,
    'Milestones': false,
    'Activity Balance': false,
  };

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _selectedDog = widget.initialDog;

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

  void _toggleCategory(String cat) {
    setState(() {
      _expandedCategories[cat] = !(_expandedCategories[cat] ?? false);
    });
  }

  void _triggerRefresh() {
    setState(() => _isRefreshing = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    });
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
                  Icon(Icons.lightbulb_outline, color: _mint, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'About Timeline Insights',
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
                'Ulvenik automatically analyzes your Timeline logs across Training, Health, Goals, and S&C to compute streaks, peak training periods, and habit trends.',
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

  void _showInsightDetailModal({
    required String title,
    required String subtitle,
    required String value,
    required String category,
    required Color color,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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

              // Category Pill
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: _stoneGrey, fontSize: 13, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 18),

              // Metric Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131618),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CURRENT VALUE',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Animated Trend Chart
              const Text(
                '6-MONTH TREND ANALYSIS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
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
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 8),
                          FlSpot(1, 14),
                          FlSpot(2, 12),
                          FlSpot(3, 20),
                          FlSpot(4, 26),
                          FlSpot(5, 31),
                        ],
                        isCurved: true,
                        color: color,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: color.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  child: const Text('Close', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String? tempFilter = _selectedCategoryFilter;
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                      'FILTER INSIGHT CATEGORIES',
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
                        _buildFilterModalChip('All Insights', null, null, tempFilter, (c) => setModalState(() => tempFilter = c)),
                        _buildFilterModalChip('Consistency', 'Consistency', _catConsistency, tempFilter, (c) => setModalState(() => tempFilter = c)),
                        _buildFilterModalChip('Training', 'Training', _catTraining, tempFilter, (c) => setModalState(() => tempFilter = c)),
                        _buildFilterModalChip('S&C', 'S&C', _catSC, tempFilter, (c) => setModalState(() => tempFilter = c)),
                        _buildFilterModalChip('Health', 'Health', _catHealth, tempFilter, (c) => setModalState(() => tempFilter = c)),
                        _buildFilterModalChip('Goals', 'Goals', _catGoals, tempFilter, (c) => setModalState(() => tempFilter = c)),
                        _buildFilterModalChip('Milestones', 'Milestones', _catMilestone, tempFilter, (c) => setModalState(() => tempFilter = c)),
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
                        onPressed: () {
                          setState(() {
                            _selectedCategoryFilter = tempFilter;
                            if (tempFilter != null) {
                              final catMap = {
                                'Consistency': 'Recording Consistency',
                                'Training': 'Training',
                                'S&C': 'Strength & Conditioning',
                                'Health': 'Health',
                                'Goals': 'Goals',
                                'Milestones': 'Milestones',
                              };
                              if (catMap.containsKey(tempFilter)) {
                                _expandedCategories[catMap[tempFilter]!] = true;
                              }
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Apply Filter', style: TextStyle(color: _offWhite)),
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

  Widget _buildFilterModalChip(
    String label,
    String? cat,
    Color? color,
    String? currentFilter,
    ValueChanged<String?> onSelect,
  ) {
    final bool isSelected = currentFilter == cat;
    return GestureDetector(
      onTap: () => onSelect(cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _forest : const Color(0xFF242A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _mint : _cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
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
        'Timeline Insights',
        style: TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              tooltip: 'Filter Insights',
              icon: Icon(
                _selectedCategoryFilter != null ? Icons.filter_alt : Icons.filter_alt_outlined,
                color: _selectedCategoryFilter != null ? _mint : _stoneGrey,
                size: 20,
              ),
              onPressed: _showFilterModal,
            ),
            if (_selectedCategoryFilter != null)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: _mint,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
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
            } else if (val == 'refresh') {
              _triggerRefresh();
            } else if (val == 'dog') {
              setState(() {
                _selectedDog = _selectedDog == 'Koda' ? 'Murphy' : 'Koda';
              });
              _triggerRefresh();
            } else if (val == 'export') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
              );
            } else if (val == 'stats') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineStatisticsScreen()),
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
            PopupMenuItem(
              value: 'dog',
              child: Row(
                children: [
                  const Icon(Icons.pets, color: _mint, size: 18),
                  const SizedBox(width: 10),
                  Text('Switch Dog ($_selectedDog)',
                      style: const TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Refresh Insights', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.file_download_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Export Insights', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem(
              value: 'stats',
              child: Row(
                children: [
                  Icon(Icons.insights, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Statistics', style: TextStyle(color: _offWhite, fontSize: 13)),
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
                        Icons.lightbulb_outline,
                        size: 48,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Not Enough Timeline Data',
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
                    'Add more records to your Timeline and insights will be generated automatically.',
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
                      'Learn about Timeline Insights',
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
                      Icon(Icons.filter_list, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Filter',
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
              Container(width: 1, height: 20, color: const Color(0x1AFFFFFF)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_upload_outlined, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Export',
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
        // 1. TOP SUMMARY BENTO CARD
        _buildTopSummaryCard(),
        const SizedBox(height: 16),

        // Active Filter indicator pill (if filtered)
        if (_selectedCategoryFilter != null) ...[
          _buildActiveFilterBar(),
          const SizedBox(height: 12),
        ],

        // 2. RECENTLY DISCOVERED Header & Cards
        _buildRecentlyDiscoveredSection(),
        const SizedBox(height: 16),

        // 3. Filter & Export Action Bar
        _buildFilterExportRow(),
        const SizedBox(height: 20),

        // 4. INSIGHT CATEGORIES
        _buildInsightCategoriesSection(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildActiveFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _mint.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt, color: _mint, size: 16),
              const SizedBox(width: 8),
              Text(
                'Filtered by: $_selectedCategoryFilter',
                style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          InkWell(
            onTap: () => setState(() => _selectedCategoryFilter = null),
            child: const Row(
              children: [
                Text('Clear Filter', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600)),
                SizedBox(width: 4),
                Icon(Icons.close, color: _mint, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSummaryCard() {
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
          // 3 metrics
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '24',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ACTIVE\nINSIGHTS',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _isRefreshing ? 'Updating...' : 'Just Now',
                        maxLines: 1,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'LAST\nUPDATED',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3 Years',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PERIOD\nANALYSED',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
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

          // Bottom refresh row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: _stoneGrey, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Insights for $_selectedDog • Updates automatically',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _triggerRefresh,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isRefreshing
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2, color: _mint),
                          )
                        : const Icon(Icons.refresh, color: _mint, size: 14),
                    const SizedBox(width: 4),
                    const Text(
                      'Refresh',
                      style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
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

  Widget _buildRecentlyDiscoveredSection() {
    final showGoals = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Goals';
    final showTraining = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Training';

    if (!showGoals && !showTraining) {
      return const SizedBox.shrink();
    }

    final newCount = (showGoals ? 1 : 0) + (showTraining ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENTLY DISCOVERED',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2A15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _catGoals.withValues(alpha: 0.4)),
              ),
              child: Text(
                '• $newCount New',
                style: const TextStyle(color: _catGoals, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Card 1: Goals
        if (showGoals) ...[
          _buildHighlightCard(
            category: 'GOALS',
            categoryColor: _catGoals,
            title: 'Longest Goal Yet\nCompleted',
            metricVal: '94 Days',
            metricLabel: 'duration',
            detailText: 'Heel Work Perfection — your longest goal to date, c...',
            onTap: () => _showInsightDetailModal(
              title: 'Longest Goal Yet Completed',
              subtitle: 'Heel Work Perfection achieved in 94 consecutive days',
              value: '94 Days',
              category: 'Goals',
              color: _catGoals,
            ),
          ),
          if (showTraining) const SizedBox(height: 12),
        ],

        // Card 2: Training
        if (showTraining)
          _buildHighlightCard(
            category: 'TRAINING',
            categoryColor: _catTraining,
            title: 'New Favourite\nLocation Emerging',
            metricVal: '14 Sessions',
            metricLabel: 'this month',
            detailText: 'Riverside Trail has become your most visited training...',
            onTap: () => _showInsightDetailModal(
              title: 'New Favourite Location Emerging',
              subtitle: 'Riverside Trail logged 14 times this month',
              value: '14 Sessions',
              category: 'Training',
              color: _catTraining,
            ),
          ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required String category,
    required Color categoryColor,
    required String title,
    required String metricVal,
    required String metricLabel,
    required String detailText,
    required VoidCallback onTap,
  }) {
    return Container(
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with category dot and NEW badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(color: categoryColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: TextStyle(
                            color: categoryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF362E12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: _catGoals,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title + Metric Value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          height: 1.25,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          metricVal,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          metricLabel,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(color: Color(0x14FFFFFF), height: 1),
                const SizedBox(height: 10),

                // Footer row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        detailText,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterExportRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF)),
          bottom: BorderSide(color: Color(0x14FFFFFF)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _showFilterModal,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_list, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Filter', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 20, color: const Color(0x14FFFFFF)),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload_outlined, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Export', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCategoriesSection() {
    final showConsistency = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Consistency';
    final showTraining = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Training';
    final showSC = _selectedCategoryFilter == null || _selectedCategoryFilter == 'S&C';
    final showHealth = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Health';
    final showGoals = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Goals';
    final showMilestones = _selectedCategoryFilter == null || _selectedCategoryFilter == 'Milestones';
    final showActivityBalance = _selectedCategoryFilter == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INSIGHT CATEGORIES',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),

        // 1. Recording Consistency (4 insights)
        if (showConsistency) ...[
          _buildCategoryAccordion(
            title: 'Recording Consistency',
            icon: Icons.local_fire_department_outlined,
            color: _catConsistency,
            insightCount: 4,
            isExpanded: _selectedCategoryFilter == 'Consistency' || (_expandedCategories['Recording Consistency'] ?? false),
            onHeaderTap: () => _toggleCategory('Recording Consistency'),
            items: [
              _buildInsightItem(
                icon: Icons.local_fire_department_outlined,
                title: 'Current Streak',
                subtitle: '12 consecutive recording days',
                value: '12 Days',
                color: _catConsistency,
              ),
              _buildInsightItem(
                icon: Icons.emoji_events_outlined,
                title: 'Longest Streak',
                subtitle: 'Achieved in March 2025',
                value: '31 Days',
                color: _catConsistency,
              ),
              _buildInsightItem(
                icon: Icons.calendar_today_outlined,
                title: 'Most Consistent Month',
                subtitle: 'Most entries ever recorded',
                value: 'March 2025',
                color: _catConsistency,
              ),
              _buildInsightItem(
                icon: Icons.access_time,
                title: 'Average Days Between Entries',
                subtitle: 'Across the full Timeline history',
                value: '1.4 Days',
                color: _catConsistency,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 2. Training (5 insights)
        if (showTraining) ...[
          _buildCategoryAccordion(
            title: 'Training',
            icon: Icons.explore_outlined,
            color: _catTraining,
            insightCount: 5,
            isExpanded: _selectedCategoryFilter == 'Training' || (_expandedCategories['Training'] ?? false),
            onHeaderTap: () => _toggleCategory('Training'),
            items: [
              _buildInsightItem(
                icon: Icons.fitness_center_outlined,
                title: 'Most Trained Skill',
                subtitle: 'Field Tracking & Retrieval',
                value: '42 Sessions',
                color: _catTraining,
              ),
              _buildInsightItem(
                icon: Icons.timer_outlined,
                title: 'Average Session Duration',
                subtitle: 'Consistently sustained focus',
                value: '48 Mins',
                color: _catTraining,
              ),
              _buildInsightItem(
                icon: Icons.wb_sunny_outlined,
                title: 'Peak Training Window',
                subtitle: 'Saturday Mornings 08:00',
                value: 'Optimal',
                color: _catTraining,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 3. Strength & Conditioning (3 insights)
        if (showSC) ...[
          _buildCategoryAccordion(
            title: 'Strength & Conditioning',
            icon: Icons.bolt_outlined,
            color: _catSC,
            insightCount: 3,
            isExpanded: _selectedCategoryFilter == 'S&C' || (_expandedCategories['Strength & Conditioning'] ?? false),
            onHeaderTap: () => _toggleCategory('Strength & Conditioning'),
            items: [
              _buildInsightItem(
                icon: Icons.speed_outlined,
                title: 'Weekly S&C Volume',
                subtitle: 'Sprint work, hills & core',
                value: '3.5 Hours',
                color: _catSC,
              ),
              _buildInsightItem(
                icon: Icons.replay_outlined,
                title: 'Recovery Compliance',
                subtitle: 'Required 24h rest adhered',
                value: '96% Rate',
                color: _catSC,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 4. Health (4 insights)
        if (showHealth) ...[
          _buildCategoryAccordion(
            title: 'Health',
            icon: Icons.monitor_heart_outlined,
            color: _catHealth,
            insightCount: 4,
            isExpanded: _selectedCategoryFilter == 'Health' || (_expandedCategories['Health'] ?? false),
            onHeaderTap: () => _toggleCategory('Health'),
            items: [
              _buildInsightItem(
                icon: Icons.scale_outlined,
                title: 'Weight Stability',
                subtitle: 'Average 28.4 kg across year',
                value: 'Optimal',
                color: _catHealth,
              ),
              _buildInsightItem(
                icon: Icons.vaccines_outlined,
                title: 'Preventative Care',
                subtitle: 'Vaccines & check-ups current',
                value: 'Up to Date',
                color: _catHealth,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 5. Goals (4 insights)
        if (showGoals) ...[
          _buildCategoryAccordion(
            title: 'Goals',
            icon: Icons.flag_outlined,
            color: _catGoals,
            insightCount: 4,
            isExpanded: _selectedCategoryFilter == 'Goals' || (_expandedCategories['Goals'] ?? false),
            onHeaderTap: () => _toggleCategory('Goals'),
            items: [
              _buildInsightItem(
                icon: Icons.task_alt,
                title: 'Goals Completed',
                subtitle: 'Across all canine programs',
                value: '18 Total',
                color: _catGoals,
              ),
              _buildInsightItem(
                icon: Icons.trending_up,
                title: 'Average Completion Velocity',
                subtitle: 'Days from creation to mastery',
                value: '32 Days',
                color: _catGoals,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 6. Milestones (5 insights)
        if (showMilestones) ...[
          _buildCategoryAccordion(
            title: 'Milestones',
            icon: Icons.emoji_events_outlined,
            color: _catMilestone,
            insightCount: 5,
            isExpanded: _selectedCategoryFilter == 'Milestones' || (_expandedCategories['Milestones'] ?? false),
            onHeaderTap: () => _toggleCategory('Milestones'),
            items: [
              _buildInsightItem(
                icon: Icons.workspace_premium_outlined,
                title: 'Major Milestones Logged',
                subtitle: 'Puppy foundation to trial ready',
                value: '12 Badges',
                color: _catMilestone,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 7. Activity Balance (1 insight)
        if (showActivityBalance) ...[
          _buildCategoryAccordion(
            title: 'Activity Balance',
            icon: Icons.pie_chart_outline,
            color: _offWhite,
            insightCount: 1,
            isExpanded: _expandedCategories['Activity Balance'] ?? false,
            onHeaderTap: () => _toggleCategory('Activity Balance'),
            items: [
              _buildInsightItem(
                icon: Icons.donut_large_outlined,
                title: 'Training vs Rest Ratio',
                subtitle: '60% Training, 30% S&C, 10% Other',
                value: 'Balanced',
                color: _offWhite,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryAccordion({
    required String title,
    required IconData icon,
    required Color color,
    required int insightCount,
    required bool isExpanded,
    required VoidCallback onHeaderTap,
    required List<Widget> items,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? color.withValues(alpha: 0.3) : _cardBorder,
        ),
      ),
      child: Column(
        children: [
          // Header Row
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onHeaderTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, color: _offWhite, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF242A2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$insightCount insights',
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeInOutCubic,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: _stoneGrey,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Animated CrossFade for Content Body
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(color: Color(0x14FFFFFF), height: 1),
                ...items,
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 260),
            sizeCurve: Curves.easeInOutCubic,
            firstCurve: Curves.easeInOutCubic,
            secondCurve: Curves.easeInOutCubic,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _showInsightDetailModal(
        title: title,
        subtitle: subtitle,
        value: value,
        category: 'Metric Detail',
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
              ],
            ),
          ],
        ),
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
