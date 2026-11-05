import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/custom_snackbar.dart';
import 'edit_exercise_screen.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({super.key});

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  double _goalProgress = 0.55;
  int _session1SuccessRate = 90;
  int _session2SuccessRate = 75;

  void _showArchiveDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.archive_outlined,
                  color: AppColors.primaryForestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Archive Exercise?',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Archiving "Retrieve & Hold" will hide it from your active exercises. Historical session data will remain intact and you can restore it at any time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppSnackbar.show(context, message: 'Exercise archived', type: SnackbarType.success);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Archive Exercise',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline,
                  color: Color(0xFFFFB4AB),
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Exercise?',
                style: TextStyle(
                  color: Color(0xFFFFB4AB),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This action is permanent and cannot be undone. Please review what will happen if you proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFFFB4AB)),
                        SizedBox(width: 8),
                        Text(
                          'WILL BE DELETED',
                          style: TextStyle(
                            color: Color(0xFFFFB4AB),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Exercise definition and parameters\nAssociated tags and categories',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white12, height: 1),
                    ),
                    const Row(
                      children: [
                        UlvenikIcon(UlvenikIcons.completed, size: 16, color: AppColors.primaryForestGreen),
                        SizedBox(width: 8),
                        Text(
                          'WILL NOT BE DELETED',
                          style: TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        '47 past session records\nHistorical chart data',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    AppSnackbar.show(context, message: 'Exercise deleted', type: SnackbarType.success);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1A1A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Delete Exercise',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateGoalProgress() {
    double tempVal = _goalProgress;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Update Goal Progress',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter your recorded progress towards this goal. Ulvenik progression is handler-recorded rather than automated.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Handler Recorded Completion',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                    Text(
                      '${(tempVal * 100).round()}%',
                      style: const TextStyle(
                        color: AppColors.primaryForestGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primaryForestGreen,
                    inactiveTrackColor: Colors.white12,
                    thumbColor: AppColors.primaryForestGreen,
                    overlayColor: AppColors.primaryForestGreen.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: tempVal,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    onChanged: (v) => setSheetState(() => tempVal = v),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _goalProgress = tempVal);
                      Navigator.pop(ctx);
                      AppSnackbar.show(context, message: 'Goal progress set to ${(tempVal * 100).round()}%', type: SnackbarType.success);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Save Progress',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editSessionSuccessRate(int sessionIndex) {
    int currentRate = sessionIndex == 1 ? _session1SuccessRate : _session2SuccessRate;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Record Session Success Rate',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your recorded success rate for this session based on your criteria. Ulvenik does not judge performance automatically.',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              ...[100, 95, 90, 85, 80, 75, 60, 50].map((rate) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('$rate% Success Rate',
                        style: TextStyle(
                            color: rate == currentRate
                                ? AppColors.primaryForestGreen
                                : AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    trailing: rate == currentRate
                        ? const Icon(Icons.check, color: AppColors.primaryForestGreen, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        if (sessionIndex == 1) {
                          _session1SuccessRate = rate;
                        } else {
                          _session2SuccessRate = rate;
                        }
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(context, message: 'Session success rate updated to $rate%', type: SnackbarType.success);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
                title: const Text('Edit Exercise', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EditExerciseScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: AppColors.primaryForestGreen),
                title: const Text('Archive Exercise', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showArchiveDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                title: const Text('Delete Exercise', style: TextStyle(color: Color(0xFFFFB4AB))),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteDialog();
                },
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
      backgroundColor: AppColors.backgroundObsidian,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const UlvenikIcon(UlvenikIcons.back, color: AppColors.primaryForestGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ulvenik',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
            onPressed: _showMoreMenu,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHero(),
            _buildQuickActions(),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 24),
            _buildSkillHierarchy(),
            const SizedBox(height: 24),
            _buildActiveGoal(),
            const SizedBox(height: 24),
            _buildRecentSessions(),
          ],
        ),
      ),
    );
  }

  // ── Hero Section ────────────────────────────────────────────────────────
  Widget _buildHero() {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBueCszLZ4HtZ9M8HO3ajK-D7RVLePGO2p2cqumBTDbbBUi4X_X1He-g6FrOROixcqUzW7MapbW9AlSSQHDVNujmiZLFIysng7iR2whfwOa0cP64tvjziDDCtwFCI59RLZ37QWpxecCzsOz4CZrdSkyIMJrTm_UmC93oAkUWWqXdEC4fvZs2aHZtNQl8nwfLJ4r2Ank5s9fc4RBlO-Zto84JCiTghI0CUn3E-M4TSO3O_t_l1Ybw6c',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundObsidian.withValues(alpha: 0.0),
                  AppColors.backgroundObsidian.withValues(alpha: 0.5),
                  AppColors.backgroundObsidian,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Recall',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildChip('FOUNDATION'),
                    const SizedBox(width: 8),
                    _buildChip('OUTDOOR'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon.withValues(alpha: 0.5),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ── Quick Actions ───────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionIcon(
            icon: Icons.fiber_manual_record,
            label: 'RECORD',
            color: AppColors.primaryForestGreen,
            onTap: () {
              AppSnackbar.show(context, message: 'Record session coming soon', type: SnackbarType.info);
            },
          ),
          _buildActionIcon(
            icon: Icons.edit_outlined,
            label: 'EDIT',
            color: AppColors.secondaryTextStoneGrey,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditExerciseScreen()));
            },
          ),
          _buildActionIcon(
            icon: Icons.psychology_outlined,
            label: 'SKILL',
            color: AppColors.secondaryTextStoneGrey,
            onTap: () {
              AppSnackbar.show(context, message: 'Skill progress coming soon', type: SnackbarType.info);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isPrimary = color == AppColors.primaryForestGreen;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPrimary ? color.withValues(alpha: 0.1) : AppColors.cardsCarbon,
              border: Border.all(
                color: isPrimary ? color.withValues(alpha: 0.5) : Colors.white12,
              ),
            ),
            child: UlvenikIcon.fromMaterial(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Linked Skill ────────────────────────────────────────────────────────
  Widget _buildSkillHierarchy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Linked Skill',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              AppSnackbar.show(context, message: 'Skill progress coming soon', type: SnackbarType.info);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191c1b),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Icon(Icons.hub_outlined, color: AppColors.secondaryTextStoneGrey, size: 22),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recall',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tap to view skill progress',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Active Goal ─────────────────────────────────────────────────────────
  Widget _buildActiveGoal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Goal',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: _updateGoalProgress,
                child: const Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.edit, size: 14, color: AppColors.secondarySage),
                    SizedBox(width: 4),
                    Text(
                      'Update Progress',
                      style: TextStyle(
                        color: AppColors.secondarySage,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _updateGoalProgress,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Emergency Recall at 50m with distraction',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryForestGreen.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.primaryForestGreen.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedProgressBar(
                    value: _goalProgress,
                    height: 6,
                    color: AppColors.primaryForestGreen,
                    backgroundColor: AppColors.backgroundObsidian,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Started 12 Jun • Handler Assessed',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${(_goalProgress * 100).round()}% COMPLETE',
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Sessions ─────────────────────────────────────────────────────
  Widget _buildRecentSessions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              GestureDetector(
                onTap: () {
                  AppSnackbar.show(context, message: 'View All coming soon', type: SnackbarType.info);
                },
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    color: AppColors.primaryForestGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSessionCard(
            month: 'JUL',
            day: '22',
            title: 'Forest Trail Alpha',
            successRate: '$_session1SuccessRate%',
            indicatorColor: AppColors.primaryForestGreen,
            onTap: () => _editSessionSuccessRate(1),
          ),
          const SizedBox(height: 12),
          _buildSessionCard(
            month: 'JUL',
            day: '15',
            title: 'Open Field Training',
            successRate: '$_session2SuccessRate%',
            indicatorColor: const Color(0xFF3a4e3c),
            onTap: () => _editSessionSuccessRate(2),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required String month,
    required String day,
    required String title,
    required String successRate,
    required Color indicatorColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF323533),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    day,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Success Rate: $successRate',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }
}
