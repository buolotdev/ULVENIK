import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import 'activity_insights_screen.dart';

/// Screen representing "Activity Goals" covering both:
/// 1. Populated State (Line 151 in Handover Doc)
/// 2. Empty State (Line 150 in Handover Doc)
///
/// Strictly matches Figma: Clean app bar, summary card, active goals with animated
/// progress bars, completed goals checklist, FAB for creating goals, and interactive
/// goal progress tracking.
class ActivityGoalsScreen extends StatefulWidget {
  final String activityName;
  final bool initialEmpty;

  const ActivityGoalsScreen({
    super.key,
    this.activityName = 'Swimming Fitness',
    this.initialEmpty = false,
  });

  @override
  State<ActivityGoalsScreen> createState() => _ActivityGoalsScreenState();
}

class _ActivityGoalsScreenState extends State<ActivityGoalsScreen>
    with SingleTickerProviderStateMixin {
  // Theme Color Palette
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  late AnimationController _progressAnimController;
  late Animation<double> _progressAnimation;

  // Active Goals Data
  late List<_ActiveGoalModel> _activeGoals;

  // Completed Goals Data
  late List<_CompletedGoalModel> _completedGoals;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;

    _progressAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressAnimController,
      curve: Curves.easeOutCubic,
    );

    _initGoalsData();
    _progressAnimController.forward();
  }

  void _initGoalsData() {
    _activeGoals = [
      _ActiveGoalModel(
        id: 'g-1',
        title: 'Complete 20 Sessions',
        targetDate: 'Target: 30 Sep 2026',
        current: 12,
        target: 20,
        unit: 'Sessions',
        status: 'IN PROGRESS',
      ),
      _ActiveGoalModel(
        id: 'g-2',
        title: 'Reach 30-Minute Continuous Swim',
        targetDate: 'Target: 15 Oct 2026',
        current: 22,
        target: 30,
        unit: 'minutes',
        status: 'IN PROGRESS',
      ),
      _ActiveGoalModel(
        id: 'g-3',
        title: 'Train 3× Per Week for 8 Weeks',
        targetDate: 'No Target Date',
        current: 0,
        target: 8,
        unit: 'weeks',
        status: 'NOT STARTED',
      ),
    ];

    _completedGoals = [
      _CompletedGoalModel(
        id: 'cg-1',
        title: 'Swim 5km Total',
        date: '12 Aug 2026',
        achievement: '10 / 10 Sessions',
      ),
      _CompletedGoalModel(
        id: 'cg-2',
        title: 'Master Flip Turn',
        date: '01 Jul 2026',
        achievement: 'Achieved',
      ),
      _CompletedGoalModel(
        id: 'cg-3',
        title: 'Sub 1:30 100m Free',
        date: '15 Jun 2026',
        achievement: '1:28 PB',
      ),
      _CompletedGoalModel(
        id: 'cg-4',
        title: 'Swim 30 Days Streak',
        date: '02 May 2026',
        achievement: '30 / 30 Days',
      ),
    ];
  }

  @override
  void dispose() {
    _progressAnimController.dispose();
    super.dispose();
  }

  void _toggleState() {
    setState(() {
      _isEmpty = !_isEmpty;
      if (!_isEmpty) {
        _progressAnimController.reset();
        _progressAnimController.forward();
      }
    });
  }

  int get _overallProgressPercentage {
    if (_activeGoals.isEmpty) return 0;
    double total = 0;
    for (final g in _activeGoals) {
      total += g.ratio;
    }
    return ((total / _activeGoals.length) * 100).round();
  }

  // ===========================================================================
  // INTERACTIVE ACTION HANDLERS
  // ===========================================================================

  void _showCreateGoalDialog() {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '20');
    String selectedUnit = 'Sessions';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 30));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
                'Create New Goal',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track performance targets for ${widget.activityName}',
                style: const TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 18),

              // Title Field
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: _offWhite, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  labelStyle: const TextStyle(color: _stoneGrey),
                  hintText: 'e.g. Reach 45-Minute Continuous Swim',
                  hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: _obsidian,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: _hairlineSide,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Target & Unit Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: targetCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: _offWhite, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: 'Target Number',
                        labelStyle: const TextStyle(color: _stoneGrey),
                        filled: true,
                        fillColor: _obsidian,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: _hairlineSide,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: _hairlineBorder,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedUnit,
                          dropdownColor: _carbon,
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          items: const [
                            DropdownMenuItem(
                                value: 'Sessions', child: Text('Sessions')),
                            DropdownMenuItem(
                                value: 'minutes', child: Text('Minutes')),
                            DropdownMenuItem(
                                value: 'km', child: Text('Kilometers')),
                            DropdownMenuItem(
                                value: 'weeks', child: Text('Weeks')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => selectedUnit = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Target Date Selector
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (picked != null) {
                    setSheetState(() => selectedDate = picked);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(10),
                    border: _hairlineBorder,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: _stoneGrey, size: 16),
                          SizedBox(width: 8),
                          Text('Target Date',
                              style: TextStyle(color: _stoneGrey, fontSize: 13)),
                        ],
                      ),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style:
                            const TextStyle(color: _offWhite, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Create CTA Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final title = titleCtrl.text.trim();
                    final target = int.tryParse(targetCtrl.text.trim()) ?? 10;
                    if (title.isEmpty) {
                      AppSnackbar.show(
                        context,
                        message: 'Please enter a goal title',
                        type: SnackbarType.warning,
                      );
                      return;
                    }

                    setState(() {
                      _activeGoals.insert(
                        0,
                        _ActiveGoalModel(
                          id: 'g-${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          targetDate:
                              'Target: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          current: 0,
                          target: target,
                          unit: selectedUnit,
                          status: 'NOT STARTED',
                        ),
                      );
                      _isEmpty = false;
                      _progressAnimController.reset();
                      _progressAnimController.forward();
                    });

                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      message: 'Goal created: $title',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Create Goal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalDetailSheet(_ActiveGoalModel goal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _buildStatusPill(goal.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(goal.targetDate,
                style: const TextStyle(color: _stoneGrey, fontSize: 13)),
            const SizedBox(height: 20),

            // Progress Summary Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.circular(10),
                border: _hairlineBorder,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CURRENT PROGRESS',
                          style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        '${goal.current} / ${goal.target} ${goal.unit}',
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${(goal.ratio * 100).toInt()}%',
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _mint,
                      side: BorderSide(color: _mint.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      setState(() {
                        goal.current = (goal.current + 1).clamp(0, goal.target);
                        if (goal.current > 0) goal.status = 'IN PROGRESS';
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        message: 'Progress logged: +1 ${goal.unit}',
                        type: SnackbarType.success,
                      );
                    },
                    child: Text('+1 ${goal.unit}'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      setState(() {
                        _activeGoals.remove(goal);
                        _completedGoals.insert(
                          0,
                          _CompletedGoalModel(
                            id: 'cg-${DateTime.now().millisecondsSinceEpoch}',
                            title: goal.title,
                            date: 'Today',
                            achievement: 'Achieved (${goal.target} ${goal.unit})',
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        message: 'Goal completed: ${goal.title}',
                        type: SnackbarType.success,
                      );
                    },
                    child: const Text('Mark Complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAllCompletedSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'COMPLETED GOALS (${_completedGoals.length})',
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _stoneGrey),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  itemCount: _completedGoals.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                  itemBuilder: (context, index) {
                    final cg = _completedGoals[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: _forest, size: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cg.title,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  cg.date,
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                cg.achievement,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              _buildCompletedBadge(),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLearnAboutGoals() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
            const Row(
              children: [
                Icon(Icons.flag_outlined, color: _mint, size: 22),
                SizedBox(width: 10),
                Text(
                  'About Canine Activity Goals',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Activity Goals help structure conditioning cycles for canine athletes:\n\n'
              '• Volume Targets: Build base conditioning through total logged sessions.\n'
              '• Duration Thresholds: Increase cardiovascular endurance systematically.\n'
              '• Frequency Consistency: Maintain multi-week active streaks to prevent deconditioning.\n\n'
              'Goals automatically integrate with your recorded training sessions and timeline.',
              style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // Strictly follows Figma: seamless dark header, no bottom hairline border
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite, size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: GestureDetector(
          onDoubleTap: _toggleState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Activity Goals',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                widget.activityName,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // State toggle button (Populated vs Empty)
          IconButton(
            tooltip: _isEmpty
                ? 'Switch to Populated State'
                : 'Switch to Empty State',
            icon: Icon(
              _isEmpty ? Icons.flag : Icons.outlined_flag,
              color: _mint,
              size: 22,
            ),
            onPressed: _toggleState,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: _stoneGrey, size: 22),
            color: _carbon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _hairlineSide,
            ),
            onSelected: (val) {
              if (val == 'toggle') {
                _toggleState();
              } else if (val == 'insights') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityInsightsScreen(
                      activityName: widget.activityName,
                      initialEmpty: _isEmpty,
                    ),
                  ),
                );
              } else if (val == 'create') {
                _showCreateGoalDialog();
              } else if (val == 'learn') {
                _showLearnAboutGoals();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      _isEmpty ? Icons.flag : Icons.hourglass_empty,
                      color: _mint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEmpty ? 'View Populated State' : 'View Empty State',
                      style: const TextStyle(color: _offWhite),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'insights',
                child: Row(
                  children: [
                    Icon(Icons.insights, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('Activity Insights', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'create',
                child: Row(
                  children: [
                    Icon(Icons.add, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Create Goal', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'learn',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Learn about Goals', style: TextStyle(color: _offWhite)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _showCreateGoalDialog,
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 28),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
        ),
      ),
    );
  }

  // ===========================================================================
  // STATE A: POPULATED STATE (SCREENSHOT 1)
  // ===========================================================================

  Widget _buildPopulatedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Goal Summary Card (3 columns)
        _buildPopulatedSummaryCard(),
        const SizedBox(height: 24),

        // 2. Active Goals Section Header
        const Text(
          'ACTIVE GOALS',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 12),

        // 3. Active Goal Cards List
        ..._activeGoals.map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildActiveGoalCard(g),
            )),
        const SizedBox(height: 16),

        // 4. Completed Goals Section Header
        const Text(
          'COMPLETED GOALS',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 12),

        // 5. Completed Goals Checklist Card
        _buildCompletedGoalsCard(),
        const SizedBox(height: 12),

        // 6. View All Completed Link
        GestureDetector(
          onTap: _showAllCompletedSheet,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All Completed',
                style: TextStyle(
                  color: _forest,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, color: _forest, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  // Summary Card: ACTIVE GOALS | COMPLETED | OVERALL PROGRESS
  Widget _buildPopulatedSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryColumn(
                'ACTIVE GOALS',
                '${_activeGoals.length}',
                _offWhite,
              ),
            ),
            VerticalDivider(
              color: Colors.white.withValues(alpha: 0.08),
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _buildSummaryColumn(
                'COMPLETED',
                '${_completedGoals.length}',
                _offWhite,
              ),
            ),
            VerticalDivider(
              color: Colors.white.withValues(alpha: 0.08),
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: _buildSummaryColumn(
                'OVERALL PROGRESS',
                '$_overallProgressPercentage%',
                _forest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String label, String value, Color valueColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // Active Goal Card with animated progress bar
  Widget _buildActiveGoalCard(_ActiveGoalModel goal) {
    return InkWell(
      onTap: () => _showGoalDetailSheet(goal),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: _hairlineBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Title + Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        goal.targetDate,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusPill(goal.status),
              ],
            ),
            const SizedBox(height: 16),

            // Animated Progress Bar
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, _) {
                final ratio = (goal.ratio * _progressAnimation.value).clamp(0.0, 1.0);
                return ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Container(
                    height: 4,
                    color: _obsidian,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          decoration: BoxDecoration(
                            color: goal.status == 'NOT STARTED'
                                ? Colors.transparent
                                : _forest,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // Bottom Progress Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PROGRESS',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                  ),
                ),
                Text(
                  '${goal.current} / ${goal.target} ${goal.unit}',
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    final isInProgress = status == 'IN PROGRESS';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isInProgress ? _forest : Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
        border: isInProgress
            ? null
            : Border.all(color: _stoneGrey.withValues(alpha: 0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isInProgress ? _offWhite : _stoneGrey,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }

  // Completed Goals Card (Checklist rows)
  Widget _buildCompletedGoalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: _hairlineBorder,
      ),
      child: Column(
        children: _completedGoals.map((cg) {
          final isLast = cg == _completedGoals.last;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: _forest,
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cg.title,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cg.date,
                            style: TextStyle(
                              color: _stoneGrey.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cg.achievement,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        _buildCompletedBadge(),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  color: Colors.white.withValues(alpha: 0.08),
                  height: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: _stoneGrey.withValues(alpha: 0.4)),
      ),
      child: const Text(
        'COMPLETED',
        style: TextStyle(
          color: _stoneGrey,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }

  // ===========================================================================
  // STATE B: EMPTY STATE (SCREENSHOT 2)
  // ===========================================================================

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Empty Summary Card (Dashes)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(14),
            border: _hairlineBorder,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildEmptySummaryColumn('ACTIVE'),
                ),
                VerticalDivider(
                  color: Colors.white.withValues(alpha: 0.08),
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: _buildEmptySummaryColumn('COMPLETED'),
                ),
                VerticalDivider(
                  color: Colors.white.withValues(alpha: 0.08),
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: _buildEmptySummaryColumn('OVERALL\nPROGRESS'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 56),

        // 2. Center Concentric Target / Power Graphic
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _carbon,
              border: Border.all(
                color: _forest.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.adjust,
                color: _mint,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // 3. Headline
        const Text(
          'No Goals Created',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        // 4. Subtitle Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: const Text(
            'Set your first goal to help track progress and stay consistent with this activity.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 36),

        // 5. Create Goal Action Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: _showCreateGoalDialog,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 20),
                SizedBox(width: 8),
                Text(
                  'Create Goal',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 6. Learn about Goals Text Link
        Center(
          child: InkWell(
            onTap: _showLearnAboutGoals,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Learn about Goals',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: _mint, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySummaryColumn(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 28,
          height: 3,
          decoration: BoxDecoration(
            color: _offWhite,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

// ─── Local Data Models ─────────────────────────────────────────────────────────

class _ActiveGoalModel {
  final String id;
  final String title;
  final String targetDate;
  int current;
  final int target;
  final String unit;
  String status;

  _ActiveGoalModel({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.current,
    required this.target,
    required this.unit,
    required this.status,
  });

  double get ratio => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
}

class _CompletedGoalModel {
  final String id;
  final String title;
  final String date;
  final String achievement;

  const _CompletedGoalModel({
    required this.id,
    required this.title,
    required this.date,
    required this.achievement,
  });
}
