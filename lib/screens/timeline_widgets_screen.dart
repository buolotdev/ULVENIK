import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_memories_screen.dart';
import 'timeline_activity_map_screen.dart';
import 'timeline_compare_screen.dart';
import 'timeline_smart_collections_screen.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

// Badge Colors
const Color _badgeActivity = Color(0xFF1E362D);
const Color _badgeStats = Color(0xFF203544);
const Color _badgeHealth = Color(0xFF381F23);
const Color _badgeGoals = Color(0xFF383214);
const Color _badgeMedia = Color(0xFF2B213A);

class TimelineWidgetsScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineWidgetsScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Murphy',
  });

  @override
  State<TimelineWidgetsScreen> createState() => _TimelineWidgetsScreenState();
}

class _TimelineWidgetsScreenState extends State<TimelineWidgetsScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;

  // Selected sizes for each widget (widget_id -> size 'S', 'M', 'L')
  final Map<String, String> _widgetSizes = {
    'recent_activity': 'M',
    'recording_streak': 'S',
    'today_activity': 'M',
    'last_event': 'S',
    'timeline_summary': 'L',
    'category_breakdown': 'M',
    'monthly_activity': 'M',
    'recording_consistency': 'L',
    'upcoming_health': 'M',
    'latest_weight': 'S',
    'active_goals': 'M',
    'goal_progress': 'S',
    'recent_photos': 'M',
    'recent_videos': 'M',
  };

  // Set of added widget IDs
  final Set<String> _addedWidgets = {'recent_activity', 'monthly_activity'};

  String _configuredWidget = 'Recent Timeline Activity';

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

  void _toggleWidgetAdded(String id, String name) {
    setState(() {
      if (_addedWidgets.contains(id)) {
        _addedWidgets.remove(id);
      } else {
        _addedWidgets.add(id);
        _configuredWidget = name;
      }
    });
  }

  void _showConfigureModal(String widgetName) {
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
              Text(
                'CONFIGURE WIDGET',
                style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              Text(widgetName, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Displaying telemetry for $_selectedDog', style: const TextStyle(color: _stoneGrey, fontSize: 13)),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.refresh, color: _mint),
                title: const Text('Refresh Widget Data', style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Widget refreshed with latest Timeline data')),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.palette_outlined, color: _mint),
                title: const Text('Change Accent Tint', style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () => Navigator.pop(ctx),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _forest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Done', style: TextStyle(color: _offWhite)),
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
        'Timeline Widgets',
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
            if (val == 'collections') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSmartCollectionsScreen()),
              );
            } else if (val == 'compare') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineCompareScreen()),
              );
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
          itemBuilder: (ctx) => const [
            PopupMenuItem(
              value: 'collections',
              child: Row(
                children: [
                  Icon(Icons.collections_bookmark_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Smart Collections', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'compare',
              child: Row(
                children: [
                  Icon(Icons.compare_arrows, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Compare', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
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
  // POPULATED STATE (Matching Figma 'Timeline Widgets - Populated Gallery.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedState() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // 1. Top Home Dashboard Active Widgets Banner
              _buildHomeDashboardBanner(),
              const SizedBox(height: 24),

              // 2. SECTION: ACTIVITY (4 Available)
              _buildSectionHeader('ACTIVITY', '4 Available'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'recent_activity',
                      title: 'Recent Timeline\nActivity',
                      badge: 'ACTIVITY',
                      badgeBg: _badgeActivity,
                      badgeTextColor: _mint,
                      previewWidget: _buildRecentActivityPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'recording_streak',
                      title: 'Recording Streak\n',
                      badge: 'ACTIVITY',
                      badgeBg: _badgeActivity,
                      badgeTextColor: _mint,
                      previewWidget: _buildStreakPreview(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'today_activity',
                      title: 'Today\'s Activity\n',
                      badge: 'ACTIVITY',
                      badgeBg: _badgeActivity,
                      badgeTextColor: _mint,
                      previewWidget: _buildTodayActivityPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'last_event',
                      title: 'Last Timeline Event\n',
                      badge: 'ACTIVITY',
                      badgeBg: _badgeActivity,
                      badgeTextColor: _mint,
                      previewWidget: _buildLastEventPreview(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. SECTION: STATISTICS (4 Available)
              _buildSectionHeader('STATISTICS', '4 Available'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'timeline_summary',
                      title: 'Timeline Summary\n',
                      badge: 'STATS',
                      badgeBg: _badgeStats,
                      badgeTextColor: const Color(0xFF5D8FAF),
                      previewWidget: _buildSummaryStatsPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'category_breakdown',
                      title: 'Category Breakdown\n',
                      badge: 'STATS',
                      badgeBg: _badgeStats,
                      badgeTextColor: const Color(0xFF5D8FAF),
                      previewWidget: _buildCategoryBreakdownPreview(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'monthly_activity',
                      title: 'Monthly Activity\n',
                      badge: 'STATS',
                      badgeBg: _badgeStats,
                      badgeTextColor: const Color(0xFF5D8FAF),
                      previewWidget: _buildMonthlyActivityPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'recording_consistency',
                      title: 'Recording Consistency\n',
                      badge: 'STATS',
                      badgeBg: _badgeStats,
                      badgeTextColor: const Color(0xFF5D8FAF),
                      previewWidget: _buildConsistencyMatrixPreview(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. SECTION: HEALTH (2 Available)
              _buildSectionHeader('HEALTH', '2 Available'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'upcoming_health',
                      title: 'Upcoming Health\nReminders',
                      badge: 'HEALTH',
                      badgeBg: _badgeHealth,
                      badgeTextColor: const Color(0xFFE57373),
                      previewWidget: _buildUpcomingHealthPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'latest_weight',
                      title: 'Latest Weight\n',
                      badge: 'HEALTH',
                      badgeBg: _badgeHealth,
                      badgeTextColor: const Color(0xFFE57373),
                      previewWidget: _buildLatestWeightPreview(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 5. SECTION: GOALS (2 Available)
              _buildSectionHeader('GOALS', '2 Available'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'active_goals',
                      title: 'Active Goals\n',
                      badge: 'GOALS',
                      badgeBg: _badgeGoals,
                      badgeTextColor: const Color(0xFFECC94B),
                      previewWidget: _buildActiveGoalsPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'goal_progress',
                      title: 'Goal Progress\n',
                      badge: 'GOALS',
                      badgeBg: _badgeGoals,
                      badgeTextColor: const Color(0xFFECC94B),
                      previewWidget: _buildGoalProgressPreview(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 6. SECTION: MEDIA (2 Available)
              _buildSectionHeader('MEDIA', '2 Available'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'recent_photos',
                      title: 'Recent Photos\n',
                      badge: 'MEDIA',
                      badgeBg: _badgeMedia,
                      badgeTextColor: const Color(0xFFB39DDB),
                      previewWidget: _buildRecentPhotosPreview(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildWidgetCard(
                      id: 'recent_videos',
                      title: 'Recent Videos\n',
                      badge: 'MEDIA',
                      badgeBg: _badgeMedia,
                      badgeTextColor: const Color(0xFFB39DDB),
                      previewWidget: _buildRecentVideosPreview(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Bottom Sticky Configuration Bar (Matching Figma bottom drawer panel)
        _buildBottomStickyConfigBar(),
      ],
    );
  }

  // 1. Top Home Dashboard Banner
  Widget _buildHomeDashboardBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
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
              const Row(
                children: [
                  Icon(Icons.dashboard_customize_outlined, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Home Dashboard',
                    style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '3 Widgets Active',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Drag widgets on Home to rearrange')),
                  );
                },
                child: const Text(
                  'Edit Layout',
                  style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 Miniature Preview Tiles
          Row(
            children: [
              // Tile 1: Recent Activity (Medium)
              Expanded(
                flex: 5,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _mint, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Activity', style: TextStyle(color: _offWhite, fontSize: 9, fontWeight: FontWeight.w700)),
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
                        ],
                      ),
                      Container(width: 40, height: 3, decoration: BoxDecoration(color: _stoneGrey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
                      const Text('Medium', style: TextStyle(color: _stoneGrey, fontSize: 8)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tile 2: Streak (Small)
              Expanded(
                flex: 3,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Streak', style: TextStyle(color: _stoneGrey, fontSize: 9)),
                      Text('12d', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w800)),
                      Text('Small', style: TextStyle(color: _stoneGrey, fontSize: 8)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tile 3: This Week (Medium)
              Expanded(
                flex: 5,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('This Week', style: TextStyle(color: _stoneGrey, fontSize: 9)),
                      Row(
                        children: [
                          Container(width: 14, height: 8, color: _forest),
                          const SizedBox(width: 3),
                          Container(width: 14, height: 14, color: _mint),
                          const SizedBox(width: 3),
                          Container(width: 14, height: 10, color: _forest),
                        ],
                      ),
                      const Text('Medium', style: TextStyle(color: _stoneGrey, fontSize: 8)),
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

  Widget _buildSectionHeader(String title, String countLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          countLabel,
          style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // WIDGET CARD BUILDER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildWidgetCard({
    required String id,
    required String title,
    required String badge,
    required Color badgeBg,
    required Color badgeTextColor,
    required Widget previewWidget,
  }) {
    final isAdded = _addedWidgets.contains(id);
    final selectedSize = _widgetSizes[id] ?? 'M';

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAdded ? _forest.withValues(alpha: 0.8) : _cardBorder,
          width: isAdded ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget Preview Stage
          Container(
            height: 96,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _obsidian,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: previewWidget),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),

          // Size Selectors (S, M, L)
          Row(
            children: ['S', 'M', 'L'].map((s) {
              final isSizeSelected = selectedSize == s;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _widgetSizes[id] = s),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSizeSelected ? _forest : const Color(0xFF1E2326),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isSizeSelected ? _mint : _cardBorder),
                    ),
                    child: Center(
                      child: Text(
                        s,
                        style: TextStyle(
                          color: isSizeSelected ? _offWhite : _stoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Add / Added CTA Button
          SizedBox(
            width: double.infinity,
            height: 36,
            child: isAdded
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _forest.withValues(alpha: 0.8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: _forest.withValues(alpha: 0.15),
                    ),
                    onPressed: () => _toggleWidgetAdded(id, title),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: _mint, size: 14),
                        SizedBox(width: 4),
                        Text('Added', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _toggleWidgetAdded(id, title),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: _offWhite, size: 14),
                        SizedBox(width: 4),
                        Text('Add', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // MINIATURE PREVIEWS FOR WIDGET CARDS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildRecentActivityPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDotLine(const Color(0xFF5D8FAF)),
        const SizedBox(height: 6),
        _buildDotLine(const Color(0xFFB4823C)),
        const SizedBox(height: 6),
        _buildDotLine(const Color(0xFF8B3A3A)),
      ],
    );
  }

  Widget _buildDotLine(Color dotColor) {
    return Row(
      children: [
        Container(width: 5, height: 5, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Container(width: 50, height: 2.5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
      ],
    );
  }

  Widget _buildStreakPreview() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: _mint, size: 20),
          SizedBox(height: 2),
          Text('12', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
          Text('DAYS', style: TextStyle(color: _stoneGrey, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildTodayActivityPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('TODAY', style: TextStyle(color: _stoneGrey, fontSize: 8, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        const Row(
          children: [
            Text('3 ', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w800)),
            Text('sessions', style: TextStyle(color: _stoneGrey, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            height: 4,
            width: double.infinity,
            color: Colors.white12,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.65,
              child: Container(color: _forest),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastEventPreview() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: Color(0xFF5D8FAF), size: 6),
            SizedBox(width: 4),
            Text('Recall Drill', style: TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(height: 4),
        Text('42m • Riverside', style: TextStyle(color: _stoneGrey, fontSize: 9)),
      ],
    );
  }

  Widget _buildSummaryStatsPreview() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniStat('147', 'EVENTS'),
            _MiniStat('23', 'SITES'),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MiniStat('82h', 'LOGGED'),
            _MiniStat('94d', 'STREAK'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdownPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Distribution', style: TextStyle(color: _stoneGrey, fontSize: 8)),
            Text('100%', style: TextStyle(color: _offWhite, fontSize: 8, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(flex: 40, child: Container(color: const Color(0xFF5D8FAF))),
                Expanded(flex: 30, child: Container(color: const Color(0xFFB4823C))),
                Expanded(flex: 20, child: Container(color: const Color(0xFF8B3A3A))),
                Expanded(flex: 10, child: Container(color: const Color(0xFFECC94B))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text('• Train  • S&C', style: TextStyle(color: _stoneGrey, fontSize: 8)),
      ],
    );
  }

  Widget _buildMonthlyActivityPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildBarColumn('Jun', 16),
        _buildBarColumn('Jul', 26),
        _buildBarColumn('Aug', 42),
        _buildBarColumn('Sep', 34),
      ],
    );
  }

  Widget _buildBarColumn(String month, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 10,
          height: height,
          decoration: BoxDecoration(
            color: _mint.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
        Text(month, style: const TextStyle(color: _stoneGrey, fontSize: 8)),
      ],
    );
  }

  Widget _buildConsistencyMatrixPreview() {
    return Center(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(12, (index) {
          final isHigh = index % 3 == 0;
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isHigh ? _mint : _forest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUpcomingHealthPreview() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.notifications_none, color: Color(0xFFE57373), size: 10),
            SizedBox(width: 4),
            Expanded(
              child: Text('Rabies Booster • Oct 12', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _offWhite, fontSize: 8)),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.notifications_none, color: Color(0xFFE57373), size: 10),
            SizedBox(width: 4),
            Expanded(
              child: Text('Heartworm Pill • Tomorrow', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: _offWhite, fontSize: 8)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLatestWeightPreview() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('32.4', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
              Text(' kg', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 2),
          Text('LATEST WEIGHT', style: TextStyle(color: _stoneGrey, fontSize: 7, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildActiveGoalsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recall 30m', style: TextStyle(color: _offWhite, fontSize: 8)),
            Text('80%', style: TextStyle(color: _mint, fontSize: 8, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(1.5),
          child: Container(height: 3, width: double.infinity, color: Colors.white12, child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: 0.8, child: Container(color: _mint))),
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Down Stay', style: TextStyle(color: _offWhite, fontSize: 8)),
            Text('65%', style: TextStyle(color: _mint, fontSize: 8, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(1.5),
          child: Container(height: 3, width: double.infinity, color: Colors.white12, child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: 0.65, child: Container(color: _forest))),
        ),
      ],
    );
  }

  Widget _buildGoalProgressPreview() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pie_chart_outline, color: Color(0xFFECC94B), size: 20),
          SizedBox(height: 2),
          Text('7/10', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildRecentPhotosPreview() {
    return Center(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(4, (_) {
          return Container(
            width: 24,
            height: 20,
            decoration: BoxDecoration(color: const Color(0xFF221A30), borderRadius: BorderRadius.circular(3), border: Border.all(color: Colors.white12)),
            child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFB39DDB), size: 10),
          );
        }),
      ),
    );
  }

  Widget _buildRecentVideosPreview() {
    return const Center(
      child: Icon(Icons.play_circle_outline, color: Color(0xFFB39DDB), size: 28),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BOTTOM STICKY CONFIGURATION BAR (Matching Figma bottom bar)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildBottomStickyConfigBar() {
    return Container(
      decoration: const BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        border: Border(top: BorderSide(color: Color(0x24FFFFFF), width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(1.5)),
            ),
          ),
          const SizedBox(height: 8),

          // Configured indicator row
          GestureDetector(
            onTap: () => _showConfigureModal(_configuredWidget),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                  _configuredWidget,
                  style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: const Color(0xFF22282B), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Selected', style: TextStyle(color: _stoneGrey, fontSize: 9)),
                ),
                const Spacer(),
                const Text('Tap to configure', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0x14FFFFFF), height: 1),
          const SizedBox(height: 10),

          // Action row: Reset Layout | + Add Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _addedWidgets.clear();
                    _addedWidgets.addAll(['recent_activity', 'monthly_activity']);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Widget layout reset to default presets')),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.refresh, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Reset Layout', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${_addedWidgets.length} widgets active on Timeline dashboard')),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.add, color: _mint, size: 16),
                    SizedBox(width: 4),
                    Text('Add Widget', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matching Figma 'Timeline Widgets - Empty State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 70),

                // 4 squares grid icon with + inside circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _carbon,
                    border: Border.all(color: _cardBorder, width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.grid_view, color: _stoneGrey, size: 34),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: _mint,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: _obsidian, size: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'No Timeline Widgets Added',
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
                  'Choose widgets to personalise your Timeline dashboard.',
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
                      setState(() => _isEmptyState = false);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: _offWhite, size: 16),
                        SizedBox(width: 6),
                        Text('Add Widget', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: _offWhite, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _showLearnModal,
                  child: const Text(
                    'Learn about Timeline Widgets',
                    style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Bar in Empty State
        Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.refresh, color: _stoneGrey.withValues(alpha: 0.4), size: 16),
                  const SizedBox(width: 6),
                  Text('Reset Layout', style: TextStyle(color: _stoneGrey.withValues(alpha: 0.4), fontSize: 13)),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _isEmptyState = false),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: _mint, size: 16),
                    SizedBox(width: 4),
                    Text('Add Widget', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLearnModal() {
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
              const Text('About Timeline Widgets', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                'Timeline Widgets let you surface real-time telemetry like streaks, recent sessions, upcoming veterinary appointments, and goal progression directly on your Home and Timeline dashboards in Small, Medium, or Large formats.',
                style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _forest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
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

class _MiniStat extends StatelessWidget {
  final String val;
  final String lbl;

  const _MiniStat(this.val, this.lbl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w800)),
        Text(lbl, style: const TextStyle(color: _stoneGrey, fontSize: 7, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
