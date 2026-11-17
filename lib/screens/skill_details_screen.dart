import 'package:flutter/material.dart';
import '../data/app_settings.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'add_exercise_screen.dart';
import 'exercise_details_screen.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/session_rating.dart';
import 'training_screen.dart' show openNewTrainingSession, TrainingSessionStore, SessionStatus;
import 'training_session_screen.dart';
import 'goals_list_screen.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';
import 'media_library_screen.dart';
import 'cover_photo_editor_screen.dart';

class _SkillSessionRecord {
  final String date;
  SessionRating? rating;
  final String title;
  final String time;
  final String location;

  _SkillSessionRecord({
    required this.date,
    required this.rating,
    required this.title,
    required this.time,
    required this.location,
  });
}

class SkillDetailsScreen extends StatefulWidget {
  final String skillName;
  final String dogName;

  const SkillDetailsScreen({super.key, required this.skillName, this.dogName = 'Murphy'});

  @override
  State<SkillDetailsScreen> createState() => _SkillDetailsScreenState();
}

class _SkillDetailsScreenState extends State<SkillDetailsScreen> {
  double _goalProgress = 0.70;
  String _notes =
      'Currently responding well to the whistle, but environmental distractions (especially other dogs playing) are still causing hesitation. Need to increase reward value in high-distraction scenarios and work more on intermediate distances before pushing range.';
  CoverCrop _coverCrop = CoverCrop.none;
  static const _moss = Color(0xFF5E7D68); // muted forest green
  static const _coverUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDY3-D7uDa6UVSFWdzwIDiVgIXMfrPq8xUIF00RNYpeYcXHFhC4SIwPHWloidY-mly7XhrzMlw_zKvuxoL8dKgv5lgSNs6NzNoBS3gKFBJOk7eDPxyPazW65y37IPvR7GaJrb1ceoTA7VocVqJbNN_Gj1ovA89vv5JgFL6W3163VK2DHOqk9jLb1SBRLCYOk-z9QQupHmc0yYEvGZzG6vN3p2yszP28oURDUoFUFvvy55R49XWjzv0';

  final List<_SkillSessionRecord> _sessions = [
    _SkillSessionRecord(
      date: '22 JULY 2026',
      rating: SessionRating.excellent,
      title: 'Emergency Recall',
      time: '15m',
      location: 'Woods',
    ),
    _SkillSessionRecord(
      date: '20 JULY 2026',
      rating: SessionRating.mixed,
      title: 'Recall Through Distractions',
      time: '20m',
      location: 'Park',
    ),
  ];

  void _toast(BuildContext context, String msg) {
    AppSnackbar.show(context, message: msg, type: SnackbarType.info);
  }

  void _openAddExercise(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddExerciseScreen(parentSkill: widget.skillName)),
    );
  }

  void _showProgressDialog() {
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
                  'Update your dog\'s progress based on your own assessment.',
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
                    Text(
                      'Progress',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Tap the percentage to type an exact value (0-100).
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        final v = await _askPercent((tempVal * 100).round());
                        if (v != null) setSheetState(() => tempVal = v / 100);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          '${(tempVal * 100).round()}%',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
                    divisions: 100,
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
                      _toast(context, 'Goal progress updated to ${(tempVal * 100).round()}%');
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

  Future<int?> _askPercent(int current) {
    final ctrl = TextEditingController(text: '$current');
    return showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        title: Text('Exact progress', style: TextStyle(color: AppColors.primaryTextOffWhite)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          style: TextStyle(color: AppColors.primaryTextOffWhite),
          decoration: const InputDecoration(suffixText: '%', hintText: '0-100'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text.trim());
              Navigator.pop(ctx, v?.clamp(0, 100));
            },
            child: const Text('Done'),
          ),
        ],
      ),
    ).whenComplete(ctrl.dispose);
  }

  void _openSkillMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: UlvenikIcon(UlvenikIcons.edit, size: 22, color: AppColors.primaryTextOffWhite),
              title: Text('Edit Skill', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              subtitle: Text('Name, description, photo and notes',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              onTap: () {
                Navigator.pop(ctx);
                _editNotes();
              },
            ),
            ListTile(
              leading: const SizedBox(width: 22),
              title: Text('Archive Skill', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                _confirm(
                  title: 'Archive Skill?',
                  message:
                      'This skill will be removed from your active skills, along with its linked exercises. Your training history will be preserved, and you can restore the skill at any time.',
                  action: 'Archive Skill',
                  destructive: false,
                  done: 'Skill archived',
                );
              },
            ),
            ListTile(
              leading: const SizedBox(width: 22),
              title: const Text('Delete Skill', style: TextStyle(color: Color(0xFFE08A8A))),
              onTap: () {
                Navigator.pop(ctx);
                _confirm(
                  title: 'Delete Skill?',
                  message:
                      'This skill and its linked exercises will be permanently deleted. Your previous training sessions and their records will remain intact.',
                  action: 'Delete Skill',
                  destructive: true,
                  done: 'Skill deleted',
                );
              },
            ),
          ]),
        ),
      ),
    );
  }

  void _confirm({
    required String title,
    required String message,
    required String action,
    required bool destructive,
    required String done,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _toast(context, done);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: destructive ? const Color(0xD98B3A3A) : AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(action, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _editNotes() async {
    final ctrl = TextEditingController(text: _notes);
    final v = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Skill notes',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                autofocus: true,
                minLines: 3,
                maxLines: 8,
                style: TextStyle(color: AppColors.primaryTextOffWhite),
                decoration: InputDecoration(
                  hintText: 'Add training cues, observations or reminders...',
                  filled: true,
                  fillColor: AppColors.backgroundObsidian,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.onForestGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
    ctrl.dispose();
    if (v != null && mounted) setState(() => _notes = v);
  }

  Future<void> _editCover() async {
    final r = await Navigator.push<CoverCrop>(
      context,
      MaterialPageRoute(
        builder: (_) => CoverPhotoEditorScreen(image: const NetworkImage(_coverUrl), dogName: widget.skillName, initial: _coverCrop),
      ),
    );
    if (r != null && mounted) setState(() => _coverCrop = r);
  }

  void _openSession(_SkillSessionRecord sess) {
    final all = TrainingSessionStore.sessionsNotifier.value.where((x) => x.status == SessionStatus.completed).toList();
    if (all.isEmpty) return;
    final match = all.firstWhere((x) => x.title == sess.title, orElse: () => all.first);
    Navigator.push(context, MaterialPageRoute(builder: (_) => TrainingSessionScreen(session: match)));
  }

  void _editSessionRating(_SkillSessionRecord session) {
    showSessionRatingSheet(
      context,
      current: session.rating,
      onChanged: (r) => setState(() => session.rating = r),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppSettings.instance.isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: AppSettings.instance.isDark ? Brightness.dark : Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeroSection(context),
          const SizedBox(height: 24),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          _buildGoalsSection(),
          const SizedBox(height: 32),
          _buildExercisesSection(context),
          const SizedBox(height: 32),
          _buildRecentSessions(),
          const SizedBox(height: 32),
          _buildMediaSection(context),
          const SizedBox(height: 32),
          _buildNotesSection(context),
          const SizedBox(height: 32),
          _buildTimelineSection(),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 380 + topSafe,
      child: Stack(
        children: [
          // Full bleed image
          Positioned.fill(
            child: CroppedCover(
              image: const NetworkImage(_coverUrl),
              crop: _coverCrop,
              placeholder: ColoredBox(color: AppColors.cardsCarbon),
            ),
          ),
          // Bottom-up gradient fading into app background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.backgroundObsidian,
                    AppColors.backgroundObsidian.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.65],
                ),
              ),
            ),
          ),
          // Floating back button — no AppBar, no clip
          Positioned(
            top: topSafe + 4,
            left: 4,
            child: IconButton(
              icon: UlvenikIcon(UlvenikIcons.back, color: AppColors.primaryTextOffWhite),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: topSafe + 4,
            right: 4,
            child: IconButton(
              tooltip: 'Skill options',
              icon: UlvenikIcon(UlvenikIcons.overflowMenu, color: AppColors.primaryTextOffWhite),
              onPressed: _openSkillMenu,
            ),
          ),
          Positioned(
            top: topSafe + 56,
            right: 10,
            child: Material(
              color: const Color(0x99121212),
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Edit cover photo',
                icon: UlvenikIcon(UlvenikIcons.edit, size: 18, color: AppColors.primaryTextOffWhite),
                onPressed: _editCover,
              ),
            ),
          ),
          // Text content pinned to bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.skillName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Returning immediately to the handler upon command, regardless of distractions. Essential for safety and advanced off-lead work.',
                  style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _actionBtn(context, Icons.note_add_outlined, 'Record Session', true)),
          const SizedBox(width: 12),
          Expanded(child: _actionBtn(context, Icons.add, 'Add Exercise', false)),
        ],
      ),
    );
  }

  Widget _actionBtn(BuildContext context, IconData icon, String label, bool isPrimary) {
    final color = isPrimary ? AppColors.primaryForestGreen : AppColors.secondarySage;
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (label == 'Add Exercise') {
            _openAddExercise(context);
          } else if (label == 'Record Session') {
            openNewTrainingSession(context, dogName: 'Koda');
          } else {
            _toast(context, '$label tapped');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: UlvenikIcon.fromMaterial(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _showProgressDialog,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.edit, size: 16, color: _moss),
                      SizedBox(width: 6),
                      Text('Update Progress',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: _moss)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reliable Off-Lead Recall', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Target: 95% success', style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primaryForestGreen.withValues(alpha: 0.3)),
                      ),
                      child: Text('ACTIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primaryForestGreen)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedProgressBar(value: _goalProgress),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.secondaryTextStoneGrey)),
                    AnimatedPercentText(value: _goalProgress, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primaryForestGreen)),
                  ],
                ),
              ],
            ),
          ),
          // Shown because this skill has more than one active goal.
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GoalsListScreen(dogName: widget.dogName)),
              ),
              style: TextButton.styleFrom(foregroundColor: AppColors.secondaryTextStoneGrey, padding: const EdgeInsets.symmetric(horizontal: 4)),
              child: const Text('View All Goals ›', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              TextButton.icon(
                onPressed: () => _openAddExercise(context),
                icon: UlvenikIcon(UlvenikIcons.add, size: 16, color: AppColors.primaryForestGreen),
                label: Text('Add', style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 13, fontWeight: FontWeight.w500)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _exerciseCard(context, 'Emergency Recall (Whistle)', 'Last trained yesterday'),
          const SizedBox(height: 8),
          _exerciseCard(context, 'Recall Through Distractions', 'Last trained 3 days ago'),
        ],
      ),
    );
  }

  Widget _exerciseCard(BuildContext context, String title, String subtitle) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExerciseDetailsScreen(
                  exerciseName: title,
                  skillName: widget.skillName,
                  dogName: widget.dogName,
                )),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                ],
              ),
              UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 12),
          ..._sessions.map((sess) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _sessionCard(sess),
              )),
        ],
      ),
    );
  }

  Widget _sessionCard(_SkillSessionRecord sess) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _openSession(sess),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sess.date, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.secondaryTextStoneGrey)),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    SessionRatingBadge(
                      rating: sess.rating,
                      onTap: () => _editSessionRating(sess),
                    ),
                    const SizedBox(width: 6),
                    UlvenikIcon(UlvenikIcons.details, size: 16, color: AppColors.secondaryTextStoneGrey),
                  ]),
                ],
              ),
              const SizedBox(height: 8),
              Text(sess.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
              const SizedBox(height: 4),
              Row(
                children: [
                  UlvenikIcon(UlvenikIcons.trainingTime, size: 14, color: AppColors.secondaryTextStoneGrey),
                  const SizedBox(width: 4),
                  Text(sess.time, style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                  const SizedBox(width: 16),
                  Icon(Icons.park_outlined, size: 14, color: AppColors.secondaryTextStoneGrey),
                  const SizedBox(width: 4),
                  Text(sess.location, style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            const Expanded(child: Text('Media', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white))),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaLibraryScreen())),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite.withValues(alpha: 0.85)),
              child: const Text('View All', style: TextStyle(fontSize: 13)),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuAWdcOCoMvbNFAGZR3-ZeA-ng9wdnZWH0A8hqEnQjIjOrAESkliugFTkFXqKqK39CxGhYAuWzTV2VXb_IiPYna8RmjZSORcUAmPvLahrByZGKy0RY9SWPUjHKVRoYXUz1ju_UCBPaJCU6BvtvtEqhu3fJ_IHDlLgWjrJxMjuLp1Zg9ShY9djAmSbT3hSnQRZaCayhAw4B44G7dLTyZCa-COeORAJyYehWXnZ4uMWJRhLAtBGqG6HaI', false),
              const SizedBox(width: 12),
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuCa2aWzuH0UPmHSQgCMt7frfI2jQ_NcJNZ_N0djoUVIoyPvQwYoZBrmOmsTWvPc7_2uRxQyxC6-YAZt_umSvYPQI_9rTFLUSpMem6ipS-l-HiJ6nY6i7uWrEpoD9gpYPLfLDhEHwRoenhR-0B5y2bnL4uPY1Gw7a956QhJsWtIPbFahQCBB3ksytPtlzGWHzi1qQcT6byT5cwpl65EI98dXW75C-dA86xu1NEdp8wInj7BmnBEufAU', true),
              const SizedBox(width: 12),
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuBO3BowfrjkdK40p267-lzO09xEWnNX0iq90gZVi1s-sTLTUl8bTQyZ4swRy5qcCwmWf_jjlIKI5YxoQrGjIOzMhUiaIczXVfOBdMD6udvDPLdWBnYb1w-BJLCoMll3LqB62JQsHU3_mlJ2uzTxM55WuPojySqEKcNOwRuCUYMRf_HYFKkoJSbdj8NEjHR3EC2zQavX3EIJj0gfFYDLKgWJRLb_Z2pwTvEq79Pr_gez-QZV9vloylo', false),
              const SizedBox(width: 12),
              _mediaThumb(context, 'https://lh3.googleusercontent.com/aida-public/AB6AXuDwH3FVo8zqd_wGLwquwjabB2HTKLkb9X1X7LbiRm6AJIW4iZcpfSMQ2NZQmHM_TkBnOXGlMLXww4yFK947McK_d2iyHDoNou7LvE9QVjnhlUP3pA4AweNpizBGe5ERh4VT5CJxfvoHy6aG4vtb4n1od_t5KsDMn8drswas_caOYspXo1r_l7X7BYplrn5D9GduG79Kq1k9ai0FrRFqas6w_i_txfqJHXSnlf4YkEj5wMipNcUdNP4', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mediaThumb(BuildContext context, String url, bool isVideo) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => isVideo ? VideoViewerScreen(title: widget.skillName) : const PhotoViewerScreen())),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(url, fit: BoxFit.cover),
              if (isVideo)
                Container(
                  color: Colors.black38,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const UlvenikIcon(UlvenikIcons.play, color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              TextButton.icon(
                onPressed: _editNotes,
                icon: UlvenikIcon(UlvenikIcons.edit, size: 16, color: AppColors.secondarySage),
                label: Text('Edit', style: TextStyle(color: AppColors.secondarySage, fontSize: 13, fontWeight: FontWeight.w500)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              _notes.isEmpty ? 'No notes yet' : _notes,
              style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skill History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 16),
          _timelineItem('TODAY', AppColors.primaryForestGreen, 'Training Session', 'Practiced whistle recall in the woods. Solid response.'),
          _timelineItem('15 JULY 2026', AppColors.secondarySage, 'Goal Updated', 'Target adjusted to 95% success rate.'),
          _timelineItem('10 JULY 2026', AppColors.secondaryTextStoneGrey, 'Training Session', 'Struggled with distractions at the park. Shortened distance.', isLast: true),
        ],
      ),
    );
  }

  Widget _timelineItem(String date, Color color, String title, String desc, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: Colors.white12,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: color)),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
