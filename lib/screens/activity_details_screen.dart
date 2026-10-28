import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'activity_library_screen.dart';
import 'record_session_screen.dart';
import 'session_details_screen.dart';
import 'activity_statistics_screen.dart';
import 'activity_goals_screen.dart';
import 'activity_insights_screen.dart';
import 'equipment_screen.dart';
import 'session_templates_screen.dart';
import 'export_screen.dart';
import 'sc_archive_screen.dart';
import '../widgets/custom_snackbar.dart';

class ActivityRecordedSession {
  final String id;
  final String date;
  final String duration;
  final int durationMinutes;
  final int rating;
  final String notes;
  final int photoCount;
  final String? imageUrl;

  const ActivityRecordedSession({
    required this.id,
    required this.date,
    required this.duration,
    required this.durationMinutes,
    required this.rating,
    required this.notes,
    this.photoCount = 0,
    this.imageUrl,
  });
}

class ActivityDetailsScreen extends StatefulWidget {
  final LibraryActivityItem? activity;
  final bool initialEmpty;

  const ActivityDetailsScreen({
    super.key,
    this.activity,
    this.initialEmpty = false,
  });

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen>
    with SingleTickerProviderStateMixin {
  // Scandinavian Theme Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceContainer = Color(0xFF1D201F);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _muted = Color(0xFFA7B0AB);
  static const _sage = Color(0xFF7A8F7A);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;

  late LibraryActivityItem _act;
  late List<ActivityRecordedSession> _sessions;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;

    _act = widget.activity ??
        LibraryActivityItem(
          id: 'act-swimming',
          name: 'Swimming Fitness',
          description: 'Open water endurance and swim fitness work',
          sessionCount: 48,
          lastTrained: 'Yesterday',
          streakDays: 12,
          isFavourite: true,
          icon: Icons.pool,
          category: 'Water Work',
          equipment: 'Canine Floatation Vest & Line',
        );

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    _initMockSessions();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  void _initMockSessions() {
    _sessions = [
      const ActivityRecordedSession(
        id: 's-1',
        date: '14 Aug',
        duration: '1h 20m',
        durationMinutes: 80,
        rating: 4,
        notes: 'Felt strong, water temperature was perfect...',
        photoCount: 3,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCNEGPfEr1XvxNFvDCRpVLO0QD1kD1MA6NK9FjmAB3G0XR90sAsPM3AJOZ0bLoIpzEyqfyHhCP2_WJCKaKsEDXMIPhcT9hrxh72E_NfN6nGTtleb1fo8Ahvv9Y9flsrBMtYrlJ_lsEzoEtZzA5Lz2JBllURLqCChSaKMfsNslHww3KAY6nmwedF2ughhxrcY750onofRrGXcmgq7Um3skvysnLOG8a53wrNnPZvH9WjUsiC4xpJErs',
      ),
      const ActivityRecordedSession(
        id: 's-2',
        date: '12 Aug',
        duration: '45m',
        durationMinutes: 45,
        rating: 3,
        notes: 'Quick recovery swim, focused on technique.',
        photoCount: 0,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAIwFVySrx2Ia9ACo3xOEfJT7mxeh8PPm0_lQjcRWA8Zn0C8WyhNQN5BOGopclrTrUcbiFjj0yKYy_MjdNVxSGu6xSN8y_LPcX1QyT7J7B6EHEaZsZ6PhrCZz3fHdLK3PWifvJer-3wuSsK1-8ukiiBgYPk9qw8X4ODgoIx5U6I0YPdCvP4kYShf0V7nSq0V-EMxWPQHaMI2LP8DlCUknYKRtBZhb_zZBL9atWM7iaBt7e6er_inuA',
      ),
      const ActivityRecordedSession(
        id: 's-3',
        date: '10 Aug',
        duration: '2h 40m',
        durationMinutes: 160,
        rating: 5,
        notes: 'Longest session to date. Pushed through the wall.',
        photoCount: 1,
        imageUrl: null, // Fallback icon in screenshot
      ),
      const ActivityRecordedSession(
        id: 's-4',
        date: '08 Aug',
        duration: '1h 05m',
        durationMinutes: 65,
        rating: 3,
        notes: 'Choppy water today, tough conditions.',
        photoCount: 0,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAVUKalnHyV3_mLGgNZ5Lr8gy0OithftSTn_nflji31NHOnFTasnhssqjku4Gka07mGLckcRxQqckBaefWojWfVN5Axl081wUD7j1G-ZWc0eRtmsPhCB8f4Wbm_Ytsyl0Tpml_0_A8x7H61LjDIaABKPBJGJLqMSh9Up8oi6bG1pAeOk_YligyZlMXE23jni9ffkHXuPTMGHrfhEs92MUD1mxV4JJE87Rulz4_F_tncYjbHXfYgAtk',
      ),
    ];
  }

  void _showRecordSessionSheet() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => RecordSessionScreen(
          initialActivityName: _act.name,
          initialCategory: _act.category,
          initialIcon: _act.icon,
          startWithActivity: true,
        ),
      ),
    );
    if (result != null && mounted) {
      final dur = result['durationMinutes'] as int? ?? 45;
      final newSession = ActivityRecordedSession(
        id: 's-${DateTime.now().millisecondsSinceEpoch}',
        date: result['date'] as String? ?? 'Today',
        duration: '${dur}m',
        durationMinutes: dur,
        rating: result['rating'] as int? ?? 5,
        notes: 'Consistent conditioning effort.',
      );
      setState(() {
        _sessions.insert(0, newSession);
        _isEmpty = false;
        _act = _act.copyWith(
          sessionCount: _act.sessionCount + 1,
          lastTrained: 'Today',
          streakDays: (_act.streakDays ?? 0) + 1,
        );
        _chartAnimController.reset();
        _chartAnimController.forward();
      });
    }
  }

  void _showEditActivitySheet() {
    final nameCtrl = TextEditingController(text: _act.name);
    final descCtrl = TextEditingController(text: _act.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Edit Activity Details',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Activity Name',
                labelStyle: const TextStyle(color: _muted),
                filled: true,
                fillColor: _surfaceHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: _hairlineSide,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: _muted),
                filled: true,
                fillColor: _surfaceHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: _hairlineSide,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _act = _act.copyWith(
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                    );
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Update Activity',
                    style: TextStyle(fontWeight: FontWeight.w600)),
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
      // No duplicate bottomNavigationBar! MainLayout handles it.
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _sage),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _isEmpty ? 'ULVENIK' : _act.name,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // State toggle button (Populated vs Empty)
          IconButton(
            tooltip: _isEmpty
                ? 'Switch to Populated State'
                : 'Switch to Empty State',
            icon: Icon(
              _isEmpty ? Icons.fitness_center_outlined : Icons.fitness_center,
              color: _mint,
            ),
            onPressed: () {
              setState(() {
                _isEmpty = !_isEmpty;
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _sage),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'toggle') {
                setState(() => _isEmpty = !_isEmpty);
              } else if (val == 'insights') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityInsightsScreen(
                      activityName: _act.name,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'stats') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityStatisticsScreen(
                      activityName: _act.name,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'goals') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityGoalsScreen(
                      activityName: _act.name,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'equipment') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const EquipmentScreen(),
                  ),
                );
              } else if (val == 'templates') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SessionTemplatesScreen(),
                  ),
                );
              } else if (val == 'export') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ExportScreen(),
                  ),
                );
              } else if (val == 'archive') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCArchiveScreen(),
                  ),
                );
              } else if (val == 'edit') {
                _showEditActivitySheet();
              } else if (val == 'record') {
                _showRecordSessionSheet();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'toggle',
                child: Text(
                  _isEmpty ? 'View Populated State' : 'View Empty State',
                  style: const TextStyle(color: _offWhite, fontSize: 13),
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Text('View Archive',
                    style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Training Data',
                    style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const PopupMenuItem(
                value: 'templates',
                child: Text('Session Templates',
                    style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const PopupMenuItem(
                value: 'equipment',
                child: Text('Equipment Inventory',
                    style: TextStyle(color: _offWhite, fontSize: 13)),
              ),
              const PopupMenuItem(
                value: 'insights',
                child: Text('Activity Insights',
                    style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const PopupMenuItem(
                value: 'goals',
                child: Text('Activity Goals',
                    style: TextStyle(color: _offWhite, fontSize: 13)),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: Text('Activity Statistics',
                    style: TextStyle(color: _offWhite, fontSize: 13)),
              ),
              const PopupMenuItem(
                value: 'record',
                child: Text('Record Session',
                    style: TextStyle(color: _offWhite, fontSize: 13)),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Activity',
                    style: TextStyle(color: _offWhite, fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Hero Summary Card
            _buildHeroSummaryCard(),
            const SizedBox(height: 24),

            if (_isEmpty) ...[
              _buildEmptyStateBody(),
            ] else ...[
              // Section 2: Quick Statistics
              _buildQuickStatisticsSection(),
              const SizedBox(height: 24),

              // Animated Graph: Duration & Progression
              _buildAnimatedProgressionGraph(),
              const SizedBox(height: 24),

              // Section 3: Recent Sessions
              _buildRecentSessionsSection(),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRecordSessionSheet,
        backgroundColor: _forest,
        foregroundColor: _offWhite,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }

  // ==========================================
  // SECTION 1: HERO SUMMARY CARD
  // ==========================================
  Widget _buildHeroSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: _hairlineBorder,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: _hairlineBorder,
                ),
                child: Icon(_act.icon, color: _sage, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _act.name,
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (!_isEmpty)
                          const Text(
                            '12 Jan 2026',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _act.description,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                    ),
                    if (_isEmpty) ...[
                      const SizedBox(height: 6),
                      const Text(
                        'Created 12 Jan 2026',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 14),

          // Sub-meta indicators (Wrapped to prevent any overflow)
          if (_isEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Text(
                  '0 Sessions',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('•', style: TextStyle(color: _muted)),
                Text(
                  'No Streak',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('•', style: TextStyle(color: _muted)),
                Text(
                  'Never Completed',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${_act.sessionCount} Sessions',
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text('•', style: TextStyle(color: _muted)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: _mint,
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${_act.streakDays ?? 12} Day Streak',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Text('•', style: TextStyle(color: _muted)),
                Text(
                  'Last: ${_act.lastTrained}',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 2: QUICK STATISTICS
  // ==========================================
  Widget _buildQuickStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUICK STATISTICS',
          style: TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(16),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatItem('Total Sessions', '${_act.sessionCount}')),
                  Expanded(child: _buildStatItem('Total Duration', '62h 15m')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatItem('Avg Duration', '1h 17m')),
                  Expanded(child: _buildStatItem('Longest Session', '2h 40m')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Current Streak',
                      '${_act.streakDays ?? 12} Days',
                      isHighlight: true,
                    ),
                  ),
                  Expanded(child: _buildStatItem('Last Completed', _act.lastTrained)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? _mint : _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // ANIMATED PROGRESSION GRAPH
  // ==========================================
  Widget _buildAnimatedProgressionGraph() {
    final points = [
      const FlSpot(0, 65),
      const FlSpot(1, 160),
      const FlSpot(2, 45),
      const FlSpot(3, 80),
      const FlSpot(4, 90),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SESSION DURATION PROGRESSION',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Recent Trend',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app, color: _mint, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Interactive',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (context, _) {
                final animatedSpots = points.map((p) {
                  return FlSpot(p.x, p.y * _chartProgress.value);
                }).toList();

                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 4,
                    minY: 0,
                    maxY: 180,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 60,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.white.withValues(alpha: 0.05),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 60,
                          getTitlesWidget: (val, meta) {
                            if (val == 0) return const SizedBox.shrink();
                            return Text(
                              '${val.toInt()}m',
                              style: const TextStyle(color: _muted, fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 24,
                          getTitlesWidget: (val, meta) {
                            final dates = ['08 Aug', '10 Aug', '12 Aug', '14 Aug', 'Latest'];
                            final idx = val.toInt();
                            if (idx >= 0 && idx < dates.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  dates[idx],
                                  style: const TextStyle(color: _muted, fontSize: 10),
                                ),
                              );
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
                        getTooltipColor: (_) => _surfaceHigh,
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final mins = spot.y.round();
                            final hours = mins ~/ 60;
                            final rem = mins % 60;
                            final durStr = hours > 0 ? '${hours}h ${rem}m' : '${rem}m';
                            return LineTooltipItem(
                              '$durStr\n',
                              const TextStyle(color: _mint, fontWeight: FontWeight.w700),
                              children: const [
                                TextSpan(
                                  text: 'Swim Training',
                                  style: TextStyle(color: _offWhite, fontSize: 11),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: animatedSpots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _mint,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: _forest,
                              strokeWidth: 2,
                              strokeColor: _mint,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _mint.withValues(alpha: 0.25),
                              _mint.withValues(alpha: 0.0),
                            ],
                          ),
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

  // ==========================================
  // SECTION 3: RECENT SESSIONS
  // ==========================================
  Widget _buildRecentSessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT SESSIONS',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                AppSnackbar.show(
                  context,
                  message: 'Displaying all ${_act.sessionCount} recorded sessions',
                  type: SnackbarType.info,
                );
              },
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: _mint, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(16),
            border: _hairlineBorder,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sessions.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            itemBuilder: (ctx, idx) {
              final sess = _sessions[idx];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SessionDetailsScreen(
                        sessionTitle: _act.name,
                        dateSubtitle: 'Session from ${sess.date} 2026',
                        shortDate: '${sess.date} 2026',
                        durationText: sess.duration,
                        initialRating: sess.rating,
                        notes: sess.notes,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.vertical(
                  top: idx == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: idx == _sessions.length - 1
                      ? const Radius.circular(16)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                          border: _hairlineBorder,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: sess.imageUrl != null
                            ? Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      sess.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.pool,
                                        color: _sage,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  Container(color: Colors.black26),
                                ],
                              )
                            : const Center(
                                child: Icon(
                                  Icons.pool,
                                  color: _sage,
                                  size: 22,
                                ),
                              ),
                      ),
                      const SizedBox(width: 14),
                      // Meta info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${sess.date} • ${sess.duration}',
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 13,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (starIdx) {
                                    final isFilled = starIdx < sess.rating;
                                    return Icon(
                                      isFilled ? Icons.star : Icons.star_border,
                                      color: _mint,
                                      size: 14,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              sess.notes,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (sess.photoCount > 0) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.photo_camera,
                                    color: _sage,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${sess.photoCount} Photo${sess.photoCount > 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      color: _sage,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: _sage, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // EMPTY STATE BODY
  // ==========================================
  Widget _buildEmptyStateBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _surfaceHigh,
              border: _hairlineBorder,
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: _mint,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Sessions Recorded',
            style: TextStyle(
              color: _offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "This activity hasn't been used yet. Record your first session to begin tracking your dog's progress.",
            style: TextStyle(
              color: _muted,
              fontSize: 14,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _showRecordSessionSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.play_arrow, size: 20),
              label: const Text(
                'Start First Session',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _showEditActivitySheet,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Activity',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: _mint),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
