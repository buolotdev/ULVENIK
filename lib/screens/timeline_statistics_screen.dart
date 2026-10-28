import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'timeline_calendar_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'record_session_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';

/// Timeline Statistics Screen
/// Figma Frames:
/// - Line 182: Timeline Statistics - Empty State (Node 780:6077)
/// - Line 183: Timeline Statistics - Populated State (Node 780:6164)
class TimelineStatisticsScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineStatisticsScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineStatisticsScreen> createState() =>
      _TimelineStatisticsScreenState();
}

class _TimelineStatisticsScreenState extends State<TimelineStatisticsScreen>
    with TickerProviderStateMixin {
  // Theme Palette (Exact Ulvenik Obsidian & Carbon luxury design tokens)
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _carbonBorder = Color(0xFF272B29);
  static const Color _cardBadgeBg = Color(0xFF272B29);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forestGreen = Color(0xFF2E6B57);
  static const Color _whiteText = Color(0xFFE1E3E0);
  static const Color _stoneGrey = Color(0xFFA7B0AB);

  // Category Colors
  static const Color _catTraining = Color(0xFF5D8FAF); // Alpine Blue
  static const Color _catHealth = Color(0xFF8D504A); // Muted Red / Coral
  static const Color _catComp = Color(0xFF2E6B57); // Forest Mint
  static const Color _catSC = Color(0xFFC28A47); // Amber / Conditioning
  static const Color _catOther = Color(0xFF6B7780); // Slate

  late bool _isEmpty;
  late String _currentDog;
  late String _selectedTimeframe;

  // Animation Controllers
  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Interactive Chart States
  int _activeMonthIndex = 7; // August
  int _activePieSlice = -1;

  // Empty State Week Navigator
  DateTime _emptyStateWeekStart = DateTime(2026, 10, 12);

  // Dog Metadata
  final Map<String, Map<String, String>> _dogsMeta = {
    'Koda': {
      'breed': 'Border Collie',
      'age': '3 Years',
      'handler': 'Erik Voss',
    },
    'Atlas': {
      'breed': 'German Shepherd',
      'age': '4 Years',
      'handler': 'Erik Voss',
    },
    'Nova': {
      'breed': 'Belgian Malinois',
      'age': '2 Years',
      'handler': 'Erik Voss',
    },
  };

  final List<String> _timeframes = [
    'All Time',
    'This Year',
    'Last Year',
    'This Month',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _currentDog = widget.initialDog;
    _selectedTimeframe = 'This Year';

    // Chart entrance animation
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartAnim = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    // Subtle breathing pulse for empty state wireframe skeletons
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTimeframeSelected(String tf) {
    if (_selectedTimeframe == tf) return;
    setState(() {
      _selectedTimeframe = tf;
      if (tf == 'This Month') {
        _activeMonthIndex = 9; // October
      } else {
        _activeMonthIndex = 7; // August peak
      }
    });
    _chartAnimController.reset();
    _chartAnimController.forward();
  }

  void _toggleState() {
    setState(() {
      _isEmpty = !_isEmpty;
    });
    if (!_isEmpty) {
      _chartAnimController.reset();
      _chartAnimController.forward();
    }
  }

  void _showDogSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Canine Profile',
                    style: TextStyle(
                      color: _whiteText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _stoneGrey, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._dogsMeta.entries.map((entry) {
                final dog = entry.key;
                final meta = entry.value;
                final isSelected = dog == _currentDog;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _forestGreen.withValues(alpha: 0.25) : _obsidian,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _mint : _carbonBorder,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? _forestGreen : _carbon,
                      child: Icon(
                        Icons.pets,
                        color: isSelected ? _mint : _stoneGrey,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      dog,
                      style: TextStyle(
                        color: isSelected ? _whiteText : _stoneGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '${meta['breed']} · ${meta['age']} · ${meta['handler']}',
                      style: const TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: _mint, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _currentDog = dog;
                        // Atlas demonstrates empty state; Koda has populated records
                        if (dog == 'Atlas') {
                          _isEmpty = true;
                        } else {
                          _isEmpty = false;
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showLearnTimelineModal() {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _forestGreen.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.insights, color: _mint, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'About Timeline Statistics',
                    style: TextStyle(
                      color: _whiteText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Ulvenik automatically compiles training logs, veterinary health visits, strength & conditioning sets, and competition performances into quantitative telemetry.',
                style: TextStyle(color: _stoneGrey, fontSize: 14, height: 1.45),
              ),
              const SizedBox(height: 14),
              _buildBulletItem('Weekly Volume & Streak Tracking', Icons.local_fire_department),
              _buildBulletItem('Categorical Load Balancing', Icons.donut_large),
              _buildBulletItem('Curved Spline Trend Telemetry', Icons.show_chart),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forestGreen,
                    foregroundColor: _whiteText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: _mint, size: 18),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: _whiteText, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // -------------------------------------------------------------
  // APP BAR (Exact Figma Frame Header)
  // -------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _whiteText, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Timeline Statistics',
        style: TextStyle(
          color: _mint,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _whiteText, size: 22),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: _carbonBorder),
          ),
          onSelected: (val) {
            if (val == 'toggle_state') {
              _toggleState();
            } else if (val == 'switch_dog') {
              _showDogSelectorModal();
            } else if (val == 'learn') {
              _showLearnTimelineModal();
            } else if (val == 'favourites') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineFavouritesScreen()),
              );
            } else if (val == 'archive') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineArchiveScreen()),
              );
            } else if (val == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSettingsScreen()),
              );
            } else if (val == 'insights') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineInsightsScreen()),
              );
            } else if (val == 'export') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
              );
            } else if (val == 'calendar') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineCalendarScreen()),
              );
            } else if (val == 'record') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecordSessionScreen()),
              );
            }
          },
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'toggle_state',
              child: Row(
                children: [
                  Icon(
                    _isEmpty ? Icons.bar_chart : Icons.hourglass_empty,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isEmpty ? 'Show Populated State' : 'Show Empty State',
                    style: const TextStyle(color: _whiteText, fontSize: 13),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'favourites',
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Color(0xFFB8920A), size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Favourites', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(Icons.archive_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Archive', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Settings', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'insights',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Insights', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.file_download_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Export', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'switch_dog',
              child: Row(
                children: [
                  Icon(Icons.pets, color: _stoneGrey, size: 18),
                  SizedBox(width: 10),
                  Text('Switch Dog Profile', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'calendar',
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: _stoneGrey, size: 18),
                  SizedBox(width: 10),
                  Text('Open Timeline Calendar', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'learn',
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _stoneGrey, size: 18),
                  SizedBox(width: 10),
                  Text('About Timeline', style: TextStyle(color: _whiteText, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: _carbonBorder.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // POPULATED STATE (Line 183 - Figma Node 780:6164)
  // -------------------------------------------------------------
  Widget _buildPopulatedState() {
    final meta = _dogsMeta[_currentDog] ?? _dogsMeta['Koda']!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),

          // Dog Profile Context Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentDog,
                      style: const TextStyle(
                        color: _whiteText,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${meta['breed']} · ${meta['age']} · ${meta['handler']}',
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _showDogSelectorModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _carbonBorder),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swap_horiz, color: _mint, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Switch',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Date Selector (Scrolling Pills)
          _buildTimeframePills(),

          const SizedBox(height: 20),

          // Overview Bento Row (Horizontal Scrolling Metric Cards)
          _buildOverviewMetricCards(),

          const SizedBox(height: 20),

          // Activity Over Time Card (Spline Area Chart with Tooltip)
          _buildActivityChartCard(),

          const SizedBox(height: 20),

          // Category Breakdown Card (Interactive Donut & Legend)
          _buildCategoryBreakdownCard(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TIMEFRAME PILLS (All Time | This Year | Last Year | This Month | Custom)
  // -------------------------------------------------------------
  Widget _buildTimeframePills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _timeframes.map((tf) {
          final isSelected = tf == _selectedTimeframe;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _onTimeframeSelected(tf),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forestGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? _forestGreen : _carbonBorder,
                    width: 1,
                  ),
                ),
                child: Text(
                  tf,
                  style: TextStyle(
                    color: isSelected ? Colors.white : _stoneGrey,
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

  // -------------------------------------------------------------
  // OVERVIEW ROW: BENTO METRIC CARDS
  // -------------------------------------------------------------
  Widget _buildOverviewMetricCards() {
    // Dynamic values based on timeframe
    final String totalEvents = _selectedTimeframe == 'This Month' ? '74' : '847';
    final String streak = '14';
    final String thirdMetric = _selectedTimeframe == 'This Month' ? '31' : '312';
    final String thirdLabel = _selectedTimeframe == 'This Month' ? 'THIS MONTH' : 'THIS YEAR';
    final String thirdBadge = _selectedTimeframe == 'This Month' ? '+8% vs last mo' : '+18% vs last year';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Card 1: TOTAL EVENTS
          _buildBentoCard(
            icon: Icons.calendar_month_outlined,
            iconColor: _mint,
            metric: totalEvents,
            label: 'TOTAL EVENTS',
            badgeText: '+12 this week',
            badgeTextColor: _mint,
          ),
          const SizedBox(width: 12),

          // Card 2: DAY STREAK
          _buildBentoCard(
            icon: Icons.local_fire_department_outlined,
            iconColor: _catHealth,
            metric: streak,
            label: 'DAY STREAK',
            badgeText: 'Longest: 31 days',
            badgeTextColor: _stoneGrey,
          ),
          const SizedBox(width: 12),

          // Card 3: THIS YEAR / THIS MONTH
          _buildBentoCard(
            icon: Icons.calendar_today_outlined,
            iconColor: _mint,
            metric: thirdMetric,
            label: thirdLabel,
            badgeText: thirdBadge,
            badgeTextColor: _mint,
          ),
          const SizedBox(width: 12),

          // Card 4: TOTAL DURATION
          _buildBentoCard(
            icon: Icons.timer_outlined,
            iconColor: _catTraining,
            metric: '98h',
            label: 'TOTAL DURATION',
            badgeText: 'Avg 46m / session',
            badgeTextColor: _stoneGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required Color iconColor,
    required String metric,
    required String label,
    required String badgeText,
    required Color badgeTextColor,
  }) {
    return Container(
      width: 142,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _carbonBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 12),
          Text(
            metric,
            style: const TextStyle(
              color: _whiteText,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _cardBadgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // ACTIVITY OVER TIME CARD (Interactive Animated Spline Area Chart)
  // -------------------------------------------------------------
  Widget _buildActivityChartCard() {
    // Months data representation
    final List<Map<String, dynamic>> monthlyPoints = [
      {'month': 'Jan', 'x': 0.0, 'events': 14},
      {'month': 'Feb', 'x': 1.0, 'events': 18},
      {'month': 'Mar', 'x': 2.0, 'events': 22},
      {'month': 'Apr', 'x': 3.0, 'events': 19},
      {'month': 'May', 'x': 4.0, 'events': 32},
      {'month': 'Jun', 'x': 5.0, 'events': 48},
      {'month': 'Jul', 'x': 6.0, 'events': 52},
      {'month': 'Aug', 'x': 7.0, 'events': 58}, // Active highlight
      {'month': 'Sep', 'x': 8.0, 'events': 16},
      {'month': 'Oct', 'x': 9.0, 'events': 34},
      {'month': 'Nov', 'x': 10.0, 'events': 78},
      {'month': 'Dec', 'x': 11.0, 'events': 42},
    ];

    final activePoint = monthlyPoints[_activeMonthIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _carbonBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ACTIVITY OVER TIME',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _carbonBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _mint,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${activePoint['events']} Events (${activePoint['month']})',
                      style: const TextStyle(
                        color: _whiteText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Chart Box with dark inner surface
          Container(
            height: 190,
            padding: const EdgeInsets.only(top: 18, right: 12, left: 6, bottom: 4),
            decoration: BoxDecoration(
              color: _obsidian,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _carbonBorder.withValues(alpha: 0.8)),
            ),
            child: AnimatedBuilder(
              animation: _chartAnim,
              builder: (ctx, child) {
                return Stack(
                  children: [
                    LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 11,
                        minY: 0,
                        maxY: 90,
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              interval: 1,
                              getTitlesWidget: (val, meta) {
                                final index = val.toInt();
                                // Match Figma exact displayed ticks: Jan, Apr, Jul, Oct, Dec
                                if (index == 0) {
                                  return _buildXAxisLabel('Jan');
                                } else if (index == 3) {
                                  return _buildXAxisLabel('Apr');
                                } else if (index == 6) {
                                  return _buildXAxisLabel('Jul');
                                } else if (index == 9) {
                                  return _buildXAxisLabel('Oct');
                                } else if (index == 11) {
                                  return _buildXAxisLabel('Dec');
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => _carbon,
                            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            tooltipBorder: const BorderSide(color: _carbonBorder),
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                final mIdx = spot.x.toInt().clamp(0, 11);
                                final monthName = monthlyPoints[mIdx]['month'];
                                return LineTooltipItem(
                                  '$monthName 2026\n',
                                  const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${spot.y.toInt()} Events',
                                      style: const TextStyle(
                                        color: _whiteText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                          touchCallback: (event, response) {
                            if (response != null &&
                                response.lineBarSpots != null &&
                                response.lineBarSpots!.isNotEmpty) {
                              final spot = response.lineBarSpots!.first;
                              final newIdx = spot.x.toInt().clamp(0, 11);
                              if (newIdx != _activeMonthIndex) {
                                setState(() {
                                  _activeMonthIndex = newIdx;
                                });
                              }
                            }
                          },
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            curveSmoothness: 0.38,
                            color: _mint,
                            barWidth: 2.8,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              checkToShowDot: (spot, barData) {
                                // Highlight the active month node with glowing circle
                                return spot.x.toInt() == _activeMonthIndex;
                              },
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 5,
                                  color: _mint,
                                  strokeWidth: 2.5,
                                  strokeColor: _forestGreen,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  _mint.withValues(alpha: 0.28 * _chartAnim.value),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            spots: monthlyPoints.map((pt) {
                              final x = pt['x'] as double;
                              final events = pt['events'] as int;
                              // Scale y with entrance animation
                              return FlSpot(x, events.toDouble() * _chartAnim.value);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    // Floating Tooltip Badge (Figma Style positioned above August peak)
                    if (_activeMonthIndex == 7)
                      Positioned(
                        top: 4,
                        right: 48,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _carbon,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _carbonBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'August 2026',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '58 Events',
                                style: TextStyle(
                                  color: _whiteText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }

  Widget _buildXAxisLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: _stoneGrey,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // CATEGORY BREAKDOWN CARD (Figma Donut Chart + Legend)
  // -------------------------------------------------------------
  Widget _buildCategoryBreakdownCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _carbonBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CATEGORY BREAKDOWN',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Donut Chart with Center Text
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 40,
                        sectionsSpace: 3,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            if (response != null &&
                                response.touchedSection != null) {
                              setState(() {
                                _activePieSlice =
                                    response.touchedSection!.touchedSectionIndex;
                              });
                            } else {
                              setState(() {
                                _activePieSlice = -1;
                              });
                            }
                          },
                        ),
                        sections: [
                          // Training 42%
                          PieChartSectionData(
                            color: _catTraining,
                            value: 42,
                            showTitle: false,
                            radius: _activePieSlice == 0 ? 22 : 17,
                          ),
                          // Health 16%
                          PieChartSectionData(
                            color: _catHealth,
                            value: 16,
                            showTitle: false,
                            radius: _activePieSlice == 1 ? 22 : 17,
                          ),
                          // Comp 8%
                          PieChartSectionData(
                            color: _catComp,
                            value: 8,
                            showTitle: false,
                            radius: _activePieSlice == 2 ? 22 : 17,
                          ),
                          // S&C 18%
                          PieChartSectionData(
                            color: _catSC,
                            value: 18,
                            showTitle: false,
                            radius: _activePieSlice == 3 ? 22 : 17,
                          ),
                          // Other 16%
                          PieChartSectionData(
                            color: _catOther,
                            value: 16,
                            showTitle: false,
                            radius: _activePieSlice == 4 ? 22 : 17,
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '847',
                          style: TextStyle(
                            color: _whiteText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Events',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Legend Column (Exact Figma Labels & Percentages)
              Expanded(
                child: Column(
                  children: [
                    _buildLegendRow('Training', '42%', _catTraining, 0),
                    const SizedBox(height: 10),
                    _buildLegendRow('Health', '16%', _catHealth, 1),
                    const SizedBox(height: 10),
                    _buildLegendRow('Comp', '8%', _catComp, 2),
                    const SizedBox(height: 10),
                    _buildLegendRow('S&C', '18%', _catSC, 3),
                    const SizedBox(height: 10),
                    _buildLegendRow('Other', '16%', _catOther, 4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String label, String percent, Color dotColor, int index) {
    final isSelected = _activePieSlice == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activePieSlice = isSelected ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? _obsidian : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
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
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? _mint : _whiteText,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Text(
              percent,
              style: TextStyle(
                color: isSelected ? _whiteText : _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // EMPTY STATE (Line 182 - Figma Node 780:6077)
  // -------------------------------------------------------------
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Week Navigator: < This Week Oct 12 - Oct 18 >
          _buildEmptyStateWeekNavigator(),

          const SizedBox(height: 28),

          // Empty Box Content
          Center(
            child: Column(
              children: [
                // 3-bar mint analytics icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _forestGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: _mint,
                    size: 46,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'No Statistics Yet',
                  style: TextStyle(
                    color: _whiteText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Timeline statistics will appear once you start recording events for $_currentDog.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // CTA Button: Go to Timeline ->
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forestGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TimelineDashboardScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Go to Timeline',
                          style: TextStyle(
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

                const SizedBox(height: 16),

                // Text link: Learn about the Timeline
                GestureDetector(
                  onTap: _showLearnTimelineModal,
                  child: const Text(
                    'Learn about the Timeline',
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

          const SizedBox(height: 32),

          // Wireframe Skeletons (Exact Figma 4 Cards Layout)
          _buildWireframeSkeletons(),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWeekNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: _stoneGrey, size: 24),
          onPressed: () {
            setState(() {
              _emptyStateWeekStart =
                  _emptyStateWeekStart.subtract(const Duration(days: 7));
            });
          },
        ),
        Column(
          children: [
            const Text(
              'This Week',
              style: TextStyle(
                color: _whiteText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${_formatDate(_emptyStateWeekStart)} - ${_formatDate(_emptyStateWeekStart.add(const Duration(days: 6)))}',
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: _stoneGrey, size: 24),
          onPressed: () {
            setState(() {
              _emptyStateWeekStart =
                  _emptyStateWeekStart.add(const Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  Widget _buildWireframeSkeletons() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (ctx, child) {
        final opacity = _pulseAnim.value;
        return Column(
          children: [
            // Top Large Skeleton (Activity Chart Shape)
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _carbon.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _carbonBorder.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(height: 12),

            // Middle Two Half Skeletons Side-by-side
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: _carbon.withValues(alpha: opacity),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _carbonBorder.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: _carbon.withValues(alpha: opacity),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _carbonBorder.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bottom Full Skeleton Card
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _carbon.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _carbonBorder.withValues(alpha: 0.6)),
              ),
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------
  // BOTTOM NAVIGATION BAR (Ulvenik Standard Bottom Nav)
  // -------------------------------------------------------------
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        border: Border(top: BorderSide(color: _carbonBorder.withValues(alpha: 0.8))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false, () {
              Navigator.popUntil(context, (r) => r.isFirst);
            }),
            _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
              _showDogSelectorModal();
            }),
            _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecordSessionScreen()),
              );
            }),
            _buildNavItem(Icons.event_note, 'Timeline', true, () {
              // Active tab
            }),
            _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
              _showLearnTimelineModal();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isActive ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
