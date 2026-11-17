import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../data/goals_store.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/custom_snackbar.dart';
import '../theme/app_colors.dart';
import 'create_goal_screen.dart';

/// Goal Details (Dogs & Goals handover, section 06).
///
/// Shows category, priority (only if chosen), name, status, Automatic /
/// Manual, progress, due date and description/notes only when provided.
/// Three-dot menu: Edit Goal, Mark as Completed, Archive Goal, Delete Goal.
/// Automatic goals offer View Linked Sessions; manual goals Update Progress.
/// Archive / Delete have no approved icon yet, so they are text-only.
class GoalDetailsScreen extends StatefulWidget {
  final GoalInfo goal;

  GoalDetailsScreen({
    super.key,
    String title = 'Complete 20 Recall Sessions',
    String category = 'Training',
    String targetText = 'Sessions',
    int current = 14,
    int total = 20,
    bool isAutomatic = true,
    String? priority,
  }) : goal = GoalInfo(
          id: 'preview',
          dogName: 'Murphy',
          title: title,
          category: _titleCase(category),
          tracking: isAutomatic ? GoalTracking.automatic : GoalTracking.manual,
          targetUnit: total > 0 ? targetText : null,
          targetValue: total > 0 ? total : null,
          current: current,
          priority: priority,
        );

  const GoalDetailsScreen.fromGoal(this.goal, {super.key});

  static String _titleCase(String s) {
    if (s.toUpperCase() == 'S&C') return 'S&C';
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  GoalStatus get _status => widget.goal.status;
  num get _current => widget.goal.current;
  final List<String> _updates = [];

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  GoalInfo get g => widget.goal;
  bool get _automatic => g.tracking == GoalTracking.automatic;
  double? get _progress => g.isMeasurable ? (_current / g.targetValue!).clamp(0, 1).toDouble() : null;
  String _fmt(num v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  // ── Menu actions ────────────────────────────────────────────────────────
  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const UlvenikIcon(UlvenikIcons.edit, size: 22, color: AppColors.primaryTextOffWhite),
              title: const Text('Edit Goal', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreateGoalScreen(editGoal: g)));
              },
            ),
            if (_status != GoalStatus.completed)
              ListTile(
                leading: const UlvenikIcon(UlvenikIcons.completed, size: 22, color: AppColors.primaryTextOffWhite),
                title: const Text('Mark as Completed', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => GoalsStore.instance.setStatus(g, GoalStatus.completed));
                  AppSnackbar.show(context, message: 'Goal marked as completed', type: SnackbarType.success);
                },
              ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const SizedBox(width: 22),
              title: const Text('Archive Goal', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                _confirm(
                  title: 'Archive Goal?',
                  message: '"${g.title}" will be removed from your active goals. Its history is kept and you can restore it later.',
                  action: 'Archive Goal',
                  destructive: false,
                  onConfirm: () {
                    GoalsStore.instance.setArchived(g, true);
                    AppSnackbar.show(context, message: 'Goal archived', type: SnackbarType.success);
                    Navigator.pop(context);
                  },
                );
              },
            ),
            ListTile(
              leading: const SizedBox(width: 22),
              title: const Text('Delete Goal', style: TextStyle(color: Color(0xFFE08A8A))),
              onTap: () {
                Navigator.pop(ctx);
                _confirm(
                  title: 'Delete Goal?',
                  message:
                      '"${g.title}" and its progress history will be permanently deleted. Linked training sessions and their records are not affected. This cannot be undone.',
                  action: 'Delete Goal',
                  destructive: true,
                  onConfirm: () {
                    GoalsStore.instance.delete(g.id);
                    AppSnackbar.show(context, message: 'Goal deleted', type: SnackbarType.success);
                    Navigator.pop(context);
                  },
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
    required VoidCallback onConfirm,
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
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: destructive ? const Color(0xD98B3A3A) : AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(action, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: const BorderSide(color: Colors.white24),
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

  // ── Automatic: linked sessions ──────────────────────────────────────────
  void _openLinkedSessions() {
    final now = DateTime.now();
    final sessions = [
      for (var i = 0; i < (_automatic && g.isMeasurable ? _current.floor().clamp(0, 5) : 0); i++)
        ('${g.linkedRecords.isNotEmpty ? g.linkedRecords.first.split(' (').first : g.category} session',
            now.subtract(Duration(days: i * 3 + 1))),
    ];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              const Text('Linked Sessions',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Only qualifying recorded sessions count towards this goal.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              if (g.linkedRecords.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Linked to: ${g.linkedRecords.join(', ')}',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ],
              const SizedBox(height: 12),
              if (sessions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('No qualifying sessions recorded yet.',
                      textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
                )
              else
                for (final s in sessions)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const UlvenikIcon(UlvenikIcons.recordSession, size: 22, color: AppColors.secondarySage),
                    title: Text(s.$1, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                    subtitle: Text(_date(s.$2), style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Manual: update progress ─────────────────────────────────────────────
  void _openUpdateProgress() {
    final ctrl = TextEditingController(text: g.isMeasurable ? _fmt(_current) : '');
    showModalBottomSheet<void>(
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
              const Text('Update Progress',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                g.isMeasurable
                    ? 'Enter your current progress towards ${_fmt(g.targetValue!)} ${g.targetUnit}.'
                    : 'Add a note about progress on this open-ended goal.',
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                autofocus: true,
                keyboardType: g.isMeasurable ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.multiline,
                maxLines: g.isMeasurable ? 1 : 3,
                style: const TextStyle(color: AppColors.primaryTextOffWhite),
                decoration: InputDecoration(
                  hintText: g.isMeasurable ? 'Current progress' : 'What has changed?',
                  suffixText: g.isMeasurable ? g.targetUnit : null,
                  filled: true,
                  fillColor: AppColors.backgroundObsidian,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (g.isMeasurable) {
                      final v = num.tryParse(ctrl.text.trim());
                      if (v == null || v < 0) return;
                      setState(() => GoalsStore.instance.setCurrent(g, v));
                    } else {
                      final note = ctrl.text.trim();
                      if (note.isEmpty) return;
                      setState(() => _updates.insert(0, note));
                    }
                    Navigator.pop(ctx);
                    AppSnackbar.show(context, message: 'Progress updated', type: SnackbarType.success);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Progress', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ),
      ),
    ).whenComplete(ctrl.dispose);
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Back',
          icon: const UlvenikIcon(UlvenikIcons.back, size: 22, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Goal Details',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            tooltip: 'More actions',
            icon: const UlvenikIcon(UlvenikIcons.overflowMenu, color: AppColors.primaryTextOffWhite),
            onPressed: _openMenu,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(g.category,
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              if (g.priority != null) _pill('${g.priority} priority', filled: false),
            ]),
            const SizedBox(height: 12),
            Text(g.title,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w600, height: 1.25)),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _pill(switch (_status) {
                GoalStatus.active => 'Active',
                GoalStatus.completed => 'Completed',
                GoalStatus.overdue => 'Overdue',
              }, filled: true),
              _pill(_automatic ? 'Automatic' : 'Manual', filled: false),
            ]),
            if (g.description != null && g.description!.trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(g.description!, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
            ],
          ])),
          const SizedBox(height: 12),
          _card(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Progress', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            if (g.isMeasurable) ...[
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: _fmt(_current),
                        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 28, fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: '  / ${_fmt(g.targetValue!)} ${g.targetUnit}',
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 15, fontWeight: FontWeight.w500)),
                  ])),
                ),
                Text('${(_progress! * 100).round()}%',
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 12),
              AnimatedProgressBar(
                value: _progress!,
                height: 6,
                backgroundColor: const Color(0xFF2C302E),
                color: AppColors.primaryForestGreen,
              ),
            ] else
              Text(
                _status == GoalStatus.completed ? 'Completed' : 'Open-ended goal · no numerical target',
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15),
              ),
            if (g.dueDate != null) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),
              const SizedBox(height: 14),
              Row(children: [
                const UlvenikIcon(UlvenikIcons.calendar, color: AppColors.secondaryTextStoneGrey, size: 18),
                const SizedBox(width: 8),
                const Expanded(child: Text('Due date', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13))),
                Text(_date(g.dueDate!), style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
              ]),
            ],
            if (_status != GoalStatus.completed) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _automatic ? _openLinkedSessions : _openUpdateProgress,
                  icon: UlvenikIcon(_automatic ? UlvenikIcons.history : UlvenikIcons.edit,
                      size: 18, color: AppColors.primaryTextOffWhite),
                  label: Text(_automatic ? 'View Linked Sessions' : 'Update Progress'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ])),
          if (_updates.isNotEmpty) ...[
            const SizedBox(height: 12),
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Progress notes',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500)),
              for (final u in _updates)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(u, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                ),
            ])),
          ],
          if (g.notes != null && g.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Notes', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(g.notes!, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, height: 1.45)),
            ])),
          ],
        ],
      ),
    );
  }

  Widget _card(Widget child) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );

  Widget _pill(String text, {required bool filled}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryForestGreen : Colors.transparent,
          border: Border.all(color: filled ? AppColors.primaryForestGreen : Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5, fontWeight: FontWeight.w500)),
      );
}
