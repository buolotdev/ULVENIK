import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _WidgetPreviewKind {
  recentActivity,
  recordingStreak,
  todaysActivity,
  lastEvent,
  timelineSummary,
  categoryBreakdown,
  monthlyActivity,
  recordingConsistency,
  healthReminders,
  latestWeight,
  activeGoals,
  goalProgressRing,
  recentPhotos,
  recentVideos,
}

class _GalleryWidgetItem {
  final String id;
  final String section; // 'ACTIVITY', 'STATISTICS', 'HEALTH', 'GOALS', 'MEDIA'
  final String title;
  final String shortDashboardName;
  final String badgeLabel;
  final Color badgeColor;
  final _WidgetPreviewKind previewKind;
  String selectedSize; // 'S', 'M', 'L'
  bool isAdded;
  String dogFilter; // 'All Dogs', 'Murphy', 'Freya'
  Color accentOverride;
  String goalProgressSource; // 'Recorded Sessions & Milestones' | 'Manual Progress Entry'

  _GalleryWidgetItem({
    required this.id,
    required this.section,
    required this.title,
    required this.shortDashboardName,
    required this.badgeLabel,
    required this.badgeColor,
    required this.previewKind,
    required this.selectedSize,
    required this.isAdded,
    required this.dogFilter,
    required this.accentOverride,
    this.goalProgressSource = 'Recorded Sessions & Milestones',
  });
}

class TimelineWidgetsScreen extends StatefulWidget {
  final bool initialEmpty;

  const TimelineWidgetsScreen({
    super.key,
    this.initialEmpty = false,
  });

  @override
  State<TimelineWidgetsScreen> createState() => _TimelineWidgetsScreenState();
}

class _TimelineWidgetsScreenState extends State<TimelineWidgetsScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens (Exact from Figma SVGs) ─────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _appBarBg = Color(0xFF131719);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _previewDark = Color(0xFF111517);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _emeraldText = Color(0xFF3E8E72);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sageOlive = Color(0xFF7A8F7A);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _bronze = Color(0xFFB4823C);
  static const Color _gold = Color(0xFFB8920A);
  static const Color _healthRed = Color(0xFFA84C4C);
  static const Color _purple = Color(0xFF8668BF);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x16FFFFFF);

  late bool _isEmptyState;
  String _selectedWidgetId = 'w_recent_activity';
  String _sizeFilterTab = 'ALL'; // 'ALL', 'S', 'M', 'L'
  int _selectedMonthBarIndex = 2; // 'Aug' highlighted on Monthly Activity

  late AnimationController _animController;
  late Animation<double> _anim;

  late final List<_GalleryWidgetItem> _widgets = [
    // ── ACTIVITY (4 Available) ───────────────────────────────────────────────
    _GalleryWidgetItem(
      id: 'w_recent_activity',
      section: 'ACTIVITY',
      title: 'Recent Timeline\nActivity',
      shortDashboardName: 'Recent Activity',
      badgeLabel: 'ACTIVITY',
      badgeColor: _sageOlive,
      previewKind: _WidgetPreviewKind.recentActivity,
      selectedSize: 'M',
      isAdded: true,
      dogFilter: 'All Dogs',
      accentOverride: _forest,
    ),
    _GalleryWidgetItem(
      id: 'w_recording_streak',
      section: 'ACTIVITY',
      title: 'Recording Streak',
      shortDashboardName: 'Streak',
      badgeLabel: 'ACTIVITY',
      badgeColor: _sageOlive,
      previewKind: _WidgetPreviewKind.recordingStreak,
      selectedSize: 'S',
      isAdded: true,
      dogFilter: 'All Dogs',
      accentOverride: _forest,
    ),
    _GalleryWidgetItem(
      id: 'w_todays_activity',
      section: 'ACTIVITY',
      title: "Today's Activity",
      shortDashboardName: 'Today',
      badgeLabel: 'ACTIVITY',
      badgeColor: _sageOlive,
      previewKind: _WidgetPreviewKind.todaysActivity,
      selectedSize: 'M',
      isAdded: false,
      dogFilter: 'Murphy',
      accentOverride: _forest,
    ),
    _GalleryWidgetItem(
      id: 'w_last_event',
      section: 'ACTIVITY',
      title: 'Last Timeline Event',
      shortDashboardName: 'Last Event',
      badgeLabel: 'ACTIVITY',
      badgeColor: _sageOlive,
      previewKind: _WidgetPreviewKind.lastEvent,
      selectedSize: 'S',
      isAdded: false,
      dogFilter: 'Murphy',
      accentOverride: _alpineBlue,
    ),

    // ── STATISTICS (4 Available) ─────────────────────────────────────────────
    _GalleryWidgetItem(
      id: 'w_summary',
      section: 'STATISTICS',
      title: 'Timeline Summary',
      shortDashboardName: 'Summary',
      badgeLabel: 'STATS',
      badgeColor: _alpineBlue,
      previewKind: _WidgetPreviewKind.timelineSummary,
      selectedSize: 'L',
      isAdded: false,
      dogFilter: 'All Dogs',
      accentOverride: _alpineBlue,
    ),
    _GalleryWidgetItem(
      id: 'w_category_breakdown',
      section: 'STATISTICS',
      title: 'Category Breakdown',
      shortDashboardName: 'Categories',
      badgeLabel: 'STATS',
      badgeColor: _alpineBlue,
      previewKind: _WidgetPreviewKind.categoryBreakdown,
      selectedSize: 'M',
      isAdded: false,
      dogFilter: 'All Dogs',
      accentOverride: _alpineBlue,
    ),
    _GalleryWidgetItem(
      id: 'w_monthly_activity',
      section: 'STATISTICS',
      title: 'Monthly Activity',
      shortDashboardName: 'This Week',
      badgeLabel: 'STATS',
      badgeColor: _alpineBlue,
      previewKind: _WidgetPreviewKind.monthlyActivity,
      selectedSize: 'M',
      isAdded: true,
      dogFilter: 'All Dogs',
      accentOverride: _forest,
    ),
    _GalleryWidgetItem(
      id: 'w_consistency',
      section: 'STATISTICS',
      title: 'Recording Consistency',
      shortDashboardName: 'Consistency',
      badgeLabel: 'STATS',
      badgeColor: _alpineBlue,
      previewKind: _WidgetPreviewKind.recordingConsistency,
      selectedSize: 'L',
      isAdded: false,
      dogFilter: 'All Dogs',
      accentOverride: _forest,
    ),

    // ── HEALTH (2 Available) ─────────────────────────────────────────────────
    _GalleryWidgetItem(
      id: 'w_health_reminders',
      section: 'HEALTH',
      title: 'Upcoming Health\nReminders',
      shortDashboardName: 'Reminders',
      badgeLabel: 'HEALTH',
      badgeColor: _healthRed,
      previewKind: _WidgetPreviewKind.healthReminders,
      selectedSize: 'M',
      isAdded: false,
      dogFilter: 'Murphy',
      accentOverride: _healthRed,
    ),
    _GalleryWidgetItem(
      id: 'w_latest_weight',
      section: 'HEALTH',
      title: 'Latest Weight',
      shortDashboardName: 'Weight',
      badgeLabel: 'HEALTH',
      badgeColor: _healthRed,
      previewKind: _WidgetPreviewKind.latestWeight,
      selectedSize: 'S',
      isAdded: false,
      dogFilter: 'Murphy',
      accentOverride: _healthRed,
    ),

    // ── GOALS (2 Available) ──────────────────────────────────────────────────
    _GalleryWidgetItem(
      id: 'w_active_goals',
      section: 'GOALS',
      title: 'Active Goals',
      shortDashboardName: 'Goals',
      badgeLabel: 'GOALS',
      badgeColor: _gold,
      previewKind: _WidgetPreviewKind.activeGoals,
      selectedSize: 'M',
      isAdded: false,
      dogFilter: 'Murphy',
      accentOverride: _gold,
    ),
    _GalleryWidgetItem(
      id: 'w_goal_progress',
      section: 'GOALS',
      title: 'Goal Progress',
      shortDashboardName: '7/10 Goals',
      badgeLabel: 'GOALS',
      badgeColor: _gold,
      previewKind: _WidgetPreviewKind.goalProgressRing,
      selectedSize: 'S',
      isAdded: false,
      dogFilter: 'Murphy',
      accentOverride: _forest,
      goalProgressSource: 'Manual Progress Entry',
    ),

    // ── MEDIA (2 Available) ──────────────────────────────────────────────────
    _GalleryWidgetItem(
      id: 'w_recent_photos',
      section: 'MEDIA',
      title: 'Recent Photos',
      shortDashboardName: 'Photos',
      badgeLabel: 'MEDIA',
      badgeColor: _purple,
      previewKind: _WidgetPreviewKind.recentPhotos,
      selectedSize: 'M',
      isAdded: false,
      dogFilter: 'All Dogs',
      accentOverride: _purple,
    ),
    _GalleryWidgetItem(
      id: 'w_recent_videos',
      section: 'MEDIA',
      title: 'Recent Videos',
      shortDashboardName: 'Videos',
      badgeLabel: 'MEDIA',
      badgeColor: _purple,
      previewKind: _WidgetPreviewKind.recentVideos,
      selectedSize: 'M',
      isAdded: false,
      dogFilter: 'All Dogs',
      accentOverride: _forest,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(
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

  _GalleryWidgetItem get _selectedWidget => _widgets.firstWhere(
        (w) => w.id == _selectedWidgetId,
        orElse: () => _widgets.first,
      );

  List<_GalleryWidgetItem> get _activeDashboardWidgets =>
      _widgets.where((w) => w.isAdded).toList();

  String _fullSizeName(String code) {
    return switch (code) {
      'S' => 'Small',
      'L' => 'Large',
      _ => 'Medium',
    };
  }

  void _resetLayout() {
    setState(() {
      _isEmptyState = false;
      _sizeFilterTab = 'ALL';
      for (final w in _widgets) {
        w.isAdded = w.id == 'w_recent_activity' ||
            w.id == 'w_recording_streak' ||
            w.id == 'w_monthly_activity';
      }
      _widgets[0].selectedSize = 'M';
      _widgets[1].selectedSize = 'S';
      _widgets[6].selectedSize = 'M';
      _selectedWidgetId = 'w_recent_activity';
    });
    _animController.forward(from: 0);
    AppSnackbar.show(
      context,
      message: 'Home Dashboard reset to default 3 active widgets',
      type: SnackbarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isEmptyState
                ? _buildEmptyState()
                : _buildPopulatedGallery(),
          ),
          _buildBottomFooterDock(),
        ],
      ),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.timeline),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _appBarBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _stoneGrey, size: 22),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Timeline Widgets',
        style: TextStyle(
          color: _offWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: _stoneGrey, size: 21),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: _cardBorder),
          ),
          onSelected: (val) {
            if (val == 'toggle_empty') {
              setState(() => _isEmptyState = !_isEmptyState);
              if (!_isEmptyState) _animController.forward(from: 0);
              AppSnackbar.show(
                context,
                message: _isEmptyState
                    ? 'Switched to Empty State preview'
                    : 'Switched to Populated Widget Gallery',
                type: SnackbarType.info,
              );
            } else if (val.startsWith('size_')) {
              setState(() => _sizeFilterTab = val.substring(5));
            } else if (val == 'edit_layout') {
              _showEditDashboardLayoutSheet();
            } else if (val == 'reset') {
              _resetLayout();
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle_empty',
              child: Text(
                _isEmptyState
                    ? 'Switch to Populated Gallery'
                    : 'Switch to Empty State',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'edit_layout',
              child: Text(
                'Edit Home Dashboard Slots',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'size_ALL',
              child: Text(
                'Filter Size: Show All (S / M / L)',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'size_S',
              child: Text(
                'Filter Size: Small Only',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'size_M',
              child: Text(
                'Filter Size: Medium Only',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'size_L',
              child: Text(
                'Filter Size: Large Only',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text(
                'Reset Default Layout',
                style: TextStyle(color: _mint, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _cardBorder),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // POPULATED GALLERY (Matches 05_timeline_widgets_populated.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedGallery() {
    const sections = [
      ('ACTIVITY', '4 Available'),
      ('STATISTICS', '4 Available'),
      ('HEALTH', '2 Available'),
      ('GOALS', '2 Available'),
      ('MEDIA', '2 Available'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Home Dashboard Active Slots Card
          _buildHomeDashboardCard(),

          if (_sizeFilterTab != 'ALL') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.aspect_ratio, color: _mint, size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Showing ${_fullSizeName(_sizeFilterTab)} ($_sizeFilterTab) widgets',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _sizeFilterTab = 'ALL'),
                    child: const Text(
                      'Show All',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          for (int s = 0; s < sections.length; s++) ...[
            Builder(
              builder: (_) {
                final secKey = sections[s].$1;
                final secItems = _widgets.where((w) {
                  if (w.section != secKey) return false;
                  if (_sizeFilterTab != 'ALL' &&
                      w.selectedSize != _sizeFilterTab) {
                    return false;
                  }
                  return true;
                }).toList();

                if (secItems.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            secKey,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            sections[s].$2,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildWidgetSectionGrid(secItems),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHomeDashboardCard() {
    final active = _activeDashboardWidgets;
    return Container(
      width: double.infinity,
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
            children: [
              const Icon(Icons.grid_view_outlined,
                  color: _stoneGrey, size: 17),
              const SizedBox(width: 8),
              const Text(
                'Home Dashboard',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _cardBorder),
                ),
                child: Text(
                  '${active.length} Widgets Active',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showEditDashboardLayoutSheet,
                child: const Text(
                  'Edit Layout',
                  style: TextStyle(
                    color: _emeraldText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _previewDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: active.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: Text(
                        'No active widgets — tap "+ Add" on any card below',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < active.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          _buildDashboardMiniSlot(active[i]),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardMiniSlot(_GalleryWidgetItem item) {
    final isSel = _selectedWidgetId == item.id;
    final slotWidth = switch (item.selectedSize) {
      'S' => 84.0,
      'L' => 136.0,
      _ => 116.0,
    };

    return GestureDetector(
      onTap: () {
        setState(() => _selectedWidgetId = item.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: slotWidth,
        height: 68,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSel ? _forest : _cardBorder,
            width: isSel ? 1.4 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    item.shortDashboardName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSel ? _offWhite : _stoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isSel)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _emeraldText,
                    ),
                  ),
              ],
            ),
            if (item.previewKind == _WidgetPreviewKind.recordingStreak)
              const Text(
                '12d',
                style: TextStyle(
                  color: _emeraldText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              )
            else if (item.previewKind == _WidgetPreviewKind.monthlyActivity)
              Row(
                children: [
                  for (final h in [7.0, 11.0, 6.0, 9.0])
                    Container(
                      width: 14,
                      height: h,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 3.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 42,
                    height: 3.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            Text(
              _fullSizeName(item.selectedSize),
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetSectionGrid(List<_GalleryWidgetItem> items) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 12));
      final left = items[i];
      final right = (i + 1 < items.length) ? items[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildGalleryCard(left)),
              const SizedBox(width: 12),
              Expanded(
                child: right != null
                    ? _buildGalleryCard(right)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildGalleryCard(_GalleryWidgetItem item) {
    final isSelected = _selectedWidgetId == item.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedWidgetId = item.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _forest : _cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Live Animated Widget Preview Box
              Container(
                height: 122,
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                color: _previewDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _carbon,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: item.badgeColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          item.badgeLabel,
                          style: TextStyle(
                            color: item.badgeColor,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _anim,
                        builder: (context, _) {
                          return _buildMiniWidgetCanvas(item, _anim.value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Card Body: Title + S/M/L Pills + Add/Added Button
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 10),

                      // S / M / L Selector Row
                      Row(
                        children: [
                          for (final sz in const ['S', 'M', 'L']) ...[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.selectedSize = sz;
                                  _selectedWidgetId = item.id;
                                });
                              },
                              child: Container(
                                width: 25,
                                height: 22,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: item.selectedSize == sz
                                      ? _forest
                                      : _previewDark,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: item.selectedSize == sz
                                        ? _forest
                                        : _cardBorder,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  sz,
                                  style: TextStyle(
                                    color: item.selectedSize == sz
                                        ? _offWhite
                                        : _stoneGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 11),

                      // "+ Add" or "✓ Added ✓" Button
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: item.isAdded
                            ? OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    item.isAdded = false;
                                    _selectedWidgetId = item.id;
                                  });
                                  AppSnackbar.show(
                                    context,
                                    message:
                                        'Removed "${item.title.replaceAll('\n', ' ')}" from Home Dashboard',
                                    type: SnackbarType.info,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF141918),
                                  foregroundColor: _emeraldText,
                                  side: BorderSide(
                                      color: _forest.withValues(alpha: 0.7)),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check, size: 13),
                                    SizedBox(width: 5),
                                    Text(
                                      'Added',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.check, size: 11),
                                  ],
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    item.isAdded = true;
                                    _selectedWidgetId = item.id;
                                  });
                                  AppSnackbar.show(
                                    context,
                                    message:
                                        'Pinned "${item.title.replaceAll('\n', ' ')}" (${_fullSizeName(item.selectedSize)}) to Home Dashboard',
                                    type: SnackbarType.success,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _forest,
                                  foregroundColor: _offWhite,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, size: 15),
                                    SizedBox(width: 4),
                                    Text(
                                      'Add',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
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
            ],
          ),
        ),
      ),
    );
  }

  // ─── All 14 Exact Mini Widget Previews ────────────────────────────────────
  Widget _buildMiniWidgetCanvas(_GalleryWidgetItem item, double p) {
    switch (item.previewKind) {
      case _WidgetPreviewKind.recentActivity:
        const dots = [_alpineBlue, _forest, _gold];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: dots[i]),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (0.95 - i * 0.08) * p.clamp(0.2, 1.0),
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );

      case _WidgetPreviewKind.recordingStreak:
        final days = item.dogFilter == 'Freya' ? 9 : 12;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department_outlined,
                color: _sageOlive, size: 15),
            Text(
              '${(days * p).round()}',
              style: TextStyle(
                color: item.accentOverride,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const Text(
              'DAYS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
          ],
        );

      case _WidgetPreviewKind.todaysActivity:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TODAY',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 3),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontFamily: 'Inter'),
                children: [
                  TextSpan(
                    text: '3',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' sessions',
                    style: TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Container(
                height: 4.5,
                width: double.infinity,
                color: Colors.white.withValues(alpha: 0.08),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.68 * p,
                  child: Container(color: item.accentOverride),
                ),
              ),
            ),
          ],
        );

      case _WidgetPreviewKind.lastEvent:
        return Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: _alpineBlue, size: 6),
                    SizedBox(width: 5),
                    Text(
                      'Recall Drill',
                      style: TextStyle(color: _stoneGrey, fontSize: 9.5),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '42m • Riverside',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );

      case _WidgetPreviewKind.timelineSummary:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _MiniStatPair(value: '147', label: 'EVENTS'),
                ),
                Expanded(
                  child: _MiniStatPair(value: '23', label: 'SITES'),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _MiniStatPair(value: '82h', label: 'LOGGED'),
                ),
                Expanded(
                  child: _MiniStatPair(value: '94d', label: 'STREAK'),
                ),
              ],
            ),
          ],
        );

      case _WidgetPreviewKind.categoryBreakdown:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distribution',
                  style: TextStyle(color: _stoneGrey, fontSize: 9.5),
                ),
                Text(
                  '100%',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 6,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: p.clamp(0.1, 1.0),
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: Container(color: _alpineBlue)),
                      const SizedBox(width: 1.5),
                      Expanded(flex: 3, child: Container(color: _bronze)),
                      const SizedBox(width: 1.5),
                      Expanded(flex: 2, child: Container(color: _gold)),
                      const SizedBox(width: 1.5),
                      Expanded(flex: 1, child: Container(color: _healthRed)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                Icon(Icons.circle, color: _alpineBlue, size: 5),
                SizedBox(width: 4),
                Text('Train',
                    style: TextStyle(color: _stoneGrey, fontSize: 8.5)),
                SizedBox(width: 8),
                Icon(Icons.circle, color: _bronze, size: 5),
                SizedBox(width: 4),
                Text('S&C', style: TextStyle(color: _stoneGrey, fontSize: 8.5)),
              ],
            ),
          ],
        );

      case _WidgetPreviewKind.monthlyActivity:
        const bars = [('Jun', 0.45), ('Jul', 0.65), ('Aug', 0.92), ('Sep', 0.56)];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < bars.length; i++)
              GestureDetector(
                onTap: () => setState(() => _selectedMonthBarIndex = i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 14,
                      height: 44 * bars[i].$2 * p,
                      decoration: BoxDecoration(
                        color: _selectedMonthBarIndex == i
                            ? _emeraldText
                            : _forest.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bars[i].$1,
                      style: TextStyle(
                        color: _selectedMonthBarIndex == i
                            ? _offWhite
                            : _stoneGrey,
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );

      case _WidgetPreviewKind.recordingConsistency:
        const alphas = [
          [0.25, 0.75, 0.9, 0.35, 0.85, 0.95, 0.6],
          [0.7, 0.85, 0.3, 0.65, 0.9, 0.8, 0.55],
        ];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int r = 0; r < 2; r++) ...[
              if (r > 0) const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int c = 0; c < 7; c++)
                    Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: alphas[r][c] * p),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                ],
              ),
            ],
          ],
        );

      case _WidgetPreviewKind.healthReminders:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final label in const [
              'Rabies Booster • Oct 12',
              'Heartworm Pill • Tomorrow',
            ]) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 4.5),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_none,
                        color: _healthRed, size: 11),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 8.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      case _WidgetPreviewKind.latestWeight:
        final wt = item.dogFilter == 'Freya' ? '26.8' : '32.4';
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontFamily: 'Inter'),
                children: [
                  TextSpan(
                    text: wt,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(
                    text: 'kg',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'LATEST WEIGHT',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        );

      case _WidgetPreviewKind.activeGoals:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMiniGoalBar('Recall 30m', '80%', 0.80 * p),
            const SizedBox(height: 8),
            _buildMiniGoalBar('Down Stay', '65%', 0.65 * p),
          ],
        );

      case _WidgetPreviewKind.goalProgressRing:
        return Center(
          child: SizedBox(
            width: 52,
            height: 52,
            child: CustomPaint(
              painter: _SegmentedGoalRingPainter(
                progress: 0.7 * p,
                color: item.accentOverride,
              ),
              child: const Center(
                child: Text(
                  '7/10',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );

      case _WidgetPreviewKind.recentPhotos:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int r = 0; r < 2; r++) ...[
              if (r > 0) const SizedBox(height: 5),
              Row(
                children: [
                  for (int c = 0; c < 2; c++) ...[
                    if (c > 0) const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: _carbon,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Icon(Icons.photo_camera_outlined,
                            color: _stoneGrey, size: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        );

      case _WidgetPreviewKind.recentVideos:
        return Center(
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _carbon,
              border: Border.all(color: _cardBorder),
            ),
            child: const Icon(Icons.play_arrow, color: _emeraldText, size: 20),
          ),
        );
    }
  }

  Widget _buildMiniGoalBar(String label, String pct, double ratio) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: _stoneGrey, fontSize: 8.5)),
            Text(pct,
                style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            height: 3.5,
            width: double.infinity,
            color: Colors.white.withValues(alpha: 0.08),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: ratio.clamp(0.05, 1.0),
              child: Container(color: _forest),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matches 05_timeline_widgets_empty.png 100%)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 82,
              height: 82,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF161B1D),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: _sageOlive,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _carbon,
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: _sageOlive,
                        size: 14,
                      ),
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
                fontSize: 21,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose widgets to personalise your\nTimeline dashboard.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _isEmptyState = false);
                  _animController.forward(from: 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Add Widget',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DOCKED CONFIGURATION DRAWER + STICKY FOOTER BAR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBottomFooterDock() {
    final sel = _selectedWidget;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isEmptyState)
          GestureDetector(
            onTap: () => _showConfigureWidgetModal(sel),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF171C1F),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                border: Border(top: BorderSide(color: _cardBorder)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 34,
                    height: 3.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _emeraldText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sel.title.replaceAll('\n', ' '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: _obsidian,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Text(
                          'Selected',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Tap to configure',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        // Bottom Reset Layout / + Add Widget Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: const BoxDecoration(
            color: _appBarBg,
            border: Border(top: BorderSide(color: _cardBorder)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _isEmptyState ? null : _resetLayout,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: _isEmptyState
                          ? _stoneGrey.withValues(alpha: 0.45)
                          : _stoneGrey,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Reset Layout',
                      style: TextStyle(
                        color: _isEmptyState
                            ? _stoneGrey.withValues(alpha: 0.45)
                            : _stoneGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isEmptyState) {
                    setState(() => _isEmptyState = false);
                    _animController.forward(from: 0);
                    return;
                  }
                  _showConfigureWidgetModal(sel);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: _emeraldText, size: 17),
                    SizedBox(width: 5),
                    Text(
                      'Add Widget',
                      style: TextStyle(
                        color: _emeraldText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERACTIVE CONFIGURATION & LAYOUT SHEETS
  // ═══════════════════════════════════════════════════════════════════════════
  void _showConfigureWidgetModal(_GalleryWidgetItem item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Configure ${item.title.replaceAll('\n', ' ')}',
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 112,
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _previewDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: item.accentOverride.withValues(alpha: 0.6)),
                    ),
                    child: _buildMiniWidgetCanvas(item, 1.0),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'WIDGET SIZE FAMILY',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final sz in [
                        ('S', 'Small (1×1)'),
                        ('M', 'Medium (2×1)'),
                        ('L', 'Large (2×2)'),
                      ])
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() => item.selectedSize = sz.$1);
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: item.selectedSize == sz.$1
                                    ? _forest
                                    : _obsidian,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: _cardBorder),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                sz.$2,
                                style: TextStyle(
                                  color: item.selectedSize == sz.$1
                                      ? _offWhite
                                      : _stoneGrey,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DOG DATA SOURCE',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final dog in ['All Dogs', 'Murphy', 'Freya'])
                        ChoiceChip(
                          label: Text(dog),
                          selected: item.dogFilter == dog,
                          onSelected: (_) {
                            setModalState(() => item.dogFilter = dog);
                            setState(() {});
                          },
                          selectedColor: _forest,
                          backgroundColor: _obsidian,
                          labelStyle: TextStyle(
                            color:
                                item.dogFilter == dog ? _offWhite : _stoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  if (item.section == 'GOALS') ...[
                    const SizedBox(height: 16),
                    const Text(
                      'GOAL PROGRESS SOURCE',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Goal progress is calculated from objective recorded sessions/milestones or entered manually by you.',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final src in const [
                          'Recorded Sessions & Milestones',
                          'Manual Progress Entry',
                        ])
                          ChoiceChip(
                            label: Text(src),
                            selected: item.goalProgressSource == src,
                            onSelected: (_) {
                              setModalState(() => item.goalProgressSource = src);
                              setState(() {});
                            },
                            selectedColor: _forest,
                            backgroundColor: _obsidian,
                            labelStyle: TextStyle(
                              color: item.goalProgressSource == src
                                  ? _offWhite
                                  : _stoneGrey,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'ACCENT THEME',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final c in [_forest, _alpineBlue, _gold, _purple])
                        GestureDetector(
                          onTap: () {
                            setModalState(() => item.accentOverride = c);
                            setState(() {});
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: c,
                              border: Border.all(
                                color: item.accentOverride == c
                                    ? _offWhite
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => item.isAdded = true);
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          message:
                              'Saved & pinned "${item.title.replaceAll('\n', ' ')}" (${item.dogFilter})',
                          type: SnackbarType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        item.isAdded
                            ? 'Save Widget Configuration'
                            : 'Pin to Home Dashboard',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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

  void _showEditDashboardLayoutSheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final active = _activeDashboardWidgets;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Home Dashboard Slots',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${active.length} active widget slots pinned to Home Dashboard',
                    style: const TextStyle(color: _stoneGrey, fontSize: 12.5),
                  ),
                  const SizedBox(height: 12),
                  for (final w in active)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.drag_indicator,
                          color: _stoneGrey, size: 19),
                      title: Text(
                        w.title.replaceAll('\n', ' '),
                        style: const TextStyle(
                            color: _offWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${_fullSizeName(w.selectedSize)} · ${w.dogFilter}',
                        style:
                            const TextStyle(color: _stoneGrey, fontSize: 11.5),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: _healthRed, size: 19),
                        onPressed: () {
                          setModalState(() => w.isAdded = false);
                          setState(() {});
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
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
}

class _MiniStatPair extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStatPair({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFF5F6F2),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA7B0AB),
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _SegmentedGoalRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SegmentedGoalRingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5,
    );

    const segments = 5;
    const gap = 0.16;
    final segSweep = (2 * math.pi / segments) - gap;
    final filledSegments = (progress * segments).clamp(0.0, segments.toDouble());

    for (int i = 0; i < segments; i++) {
      final start = -math.pi / 2 + i * (segSweep + gap);
      final segFill = (filledSegments - i).clamp(0.0, 1.0);
      if (segFill <= 0) continue;
      canvas.drawArc(
        rect,
        start,
        segSweep * segFill,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedGoalRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
