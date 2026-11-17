import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/custom_snackbar.dart';
import 'edit_exercise_screen.dart';
import 'skill_details_screen.dart';
import 'training_screen.dart' show openNewTrainingSession;

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseName;
  final String skillName;
  final String dogName;
  final String description;

  const ExerciseDetailsScreen({
    super.key,
    this.exerciseName = 'Emergency Recall',
    this.skillName = 'Recall',
    this.dogName = 'Koda',
    this.description = '',
  });

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  double _goalProgress = 0.55;
  bool _showAll = false;
  late String _name = widget.exerciseName;
  final List<_ExSession> _sessions = [
    _ExSession('JUL', '22', 'Forest Trail Alpha', 90),
    _ExSession('JUL', '15', 'Open Field Training', 75),
    _ExSession('JUL', '08', 'Riverside Walk', 80),
    _ExSession('JUN', '30', 'Park Distractions', 70),
    _ExSession('JUN', '21', 'Back Garden', 85),
  ];

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
                child: Icon(Icons.archive_outlined,
                  color: AppColors.primaryForestGreen,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Archive Exercise?',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This exercise will be removed from your active exercises. Your training history will be preserved, and you can restore it at any time.',
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
                    foregroundColor: AppColors.onForestGreen,
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
                    side: BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cancel',
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
              Text(
                'This exercise will be permanently deleted. Your previous training sessions and their records will remain intact.',
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
                  border: Border.all(color: AppColors.cardBorder),
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
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'The exercise and its description',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.cardBorder, height: 1),
                    ),
                    Row(
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
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Past session records\nHistorical chart data',
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
                    side: BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Cancel',
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
                Text(
                  'Update Goal Progress',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Update your dog’s progress based on your own assessment.',
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
                    Text('Progress',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                    Text(
                      '${(tempVal * 100).round()}%',
                      style: TextStyle(
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
                      foregroundColor: AppColors.onForestGreen,
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

  void _editSessionSuccessRate(int index) {
    final ctrl = TextEditingController(text: '${_sessions[index].rate}');
    String? error;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text('Success Rate',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  'Enter your own assessment for this session, from 0 to 100.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16),
                  decoration: InputDecoration(
                    suffixText: '%',
                    errorText: error,
                    filled: true,
                    fillColor: AppColors.backgroundObsidian,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.cardBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryForestGreen)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final v = int.tryParse(ctrl.text.trim());
                      if (v == null || v < 0 || v > 100) {
                        setSheet(() => error = 'Enter a number from 0 to 100.');
                        return;
                      }
                      setState(() => _sessions[index].rate = v);
                      Navigator.pop(ctx);
                      AppSnackbar.show(context, message: 'Success rate saved', type: SnackbarType.success);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.onForestGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
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
                leading: UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
                title: Text('Edit Exercise', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final renamed = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditExerciseScreen(
                        exerciseName: _name,
                        skillName: widget.skillName,
                        description: widget.description,
                      ),
                    ),
                  );
                  if (renamed != null && mounted) setState(() => _name = renamed);
                },
              ),
              ListTile(
                leading: Icon(Icons.archive_outlined, color: AppColors.primaryForestGreen),
                title: Text('Archive Exercise', style: TextStyle(color: AppColors.primaryTextOffWhite)),
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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: UlvenikIcon(UlvenikIcons.back, color: AppColors.primaryForestGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exercise Details',
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
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
            _buildNameDescription(),
            _buildRecordButton(),
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

  // ── Cover ───────────────────────────────────────────────────────────────
  Widget _buildHero() {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBueCszLZ4HtZ9M8HO3ajK-D7RVLePGO2p2cqumBTDbbBUi4X_X1He-g6FrOROixcqUzW7MapbW9AlSSQHDVNujmiZLFIysng7iR2whfwOa0cP64tvjziDDCtwFCI59RLZ37QWpxecCzsOz4CZrdSkyIMJrTm_UmC93oAkUWWqXdEC4fvZs2aHZtNQl8nwfLJ4r2Ank5s9fc4RBlO-Zto84JCiTghI0CUn3E-M4TSO3O_t_l1Ybw6c',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => ColoredBox(color: AppColors.cardsCarbon),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundObsidian.withValues(alpha: 0.0),
                  AppColors.backgroundObsidian.withValues(alpha: 0.6),
                  AppColors.backgroundObsidian,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _name,
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          if (widget.description.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45),
            ),
          ],
        ],
      ),
    );
  }

  // ── Record Session (single button) ──────────────────────────────────────
  Widget _buildRecordButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => openNewTrainingSession(context, dogName: widget.dogName),
          icon: const UlvenikIcon(UlvenikIcons.recordSession, size: 20),
          label: const Text('Record Session', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryForestGreen,
            foregroundColor: AppColors.onForestGreen,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
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
          Text(
            'Linked Skill',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SkillDetailsScreen(skillName: widget.skillName, dogName: widget.dogName),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF191c1b),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(11),
                      child: UlvenikIcon(UlvenikIcons.skills, color: AppColors.secondarySage),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.skillName,
                          style: TextStyle(
                              color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'View ${widget.skillName}',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
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
              Text(
                'Active Goal',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: _updateGoalProgress,
                child: Row(
                  children: [
                    UlvenikIcon(UlvenikIcons.edit, size: 14, color: AppColors.secondarySage),
                    SizedBox(width: 4),
                    Text(
                      'Update Progress',
                      style: TextStyle(color: AppColors.secondarySage, fontSize: 12, fontWeight: FontWeight.w500),
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
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Emergency Recall at 50m with distraction',
                          style: TextStyle(
                              color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryForestGreen.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.primaryForestGreen.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
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
                      Expanded(
                        child: Text(
                          'Started 12 Jun',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${(_goalProgress * 100).round()}% COMPLETE',
                        style: TextStyle(
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
    final shown = _showAll ? _sessions : _sessions.take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _showAll ? 'All Sessions' : 'Recent Sessions',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          for (final s in shown) ...[
            _buildSessionCard(s, _sessions.indexOf(s)),
            const SizedBox(height: 12),
          ],
          if (_sessions.length > 3)
            Center(
              child: TextButton(
                onPressed: () => setState(() => _showAll = !_showAll),
                child: Text(
                  _showAll ? 'Show Fewer' : 'View All Sessions',
                  style: TextStyle(
                      color: AppColors.primaryForestGreen, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(_ExSession s, int index) {
    return GestureDetector(
      onTap: () => _editSessionSuccessRate(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF323533),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(s.month,
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0)),
                  Text(s.day,
                      style: TextStyle(
                          color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.title,
                      style: TextStyle(
                          color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('Success Rate: ${s.rate}%',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                ],
              ),
            ),
            UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }
}

class _ExSession {
  final String month;
  final String day;
  final String title;
  int rate;
  _ExSession(this.month, this.day, this.title, this.rate);
}
