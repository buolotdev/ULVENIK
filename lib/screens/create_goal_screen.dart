import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../theme/app_colors.dart';
import 'goals_list_screen.dart' show DogSquarePhoto, DogPickerSheet;
import 'goal_details_screen.dart';
import 'add_skill_screen.dart';

/// Create / Edit Goal (Dogs & Goals handover, sections 07-09).
///
/// Dog preselected from where it was opened (My Dog / Client Dog label, no
/// pack badges), required title, optional description, Training / S&C /
/// Health categories (Sport only with the Sport Pack), Automatic or Manual
/// tracking, a measurable target or open-ended goal, searchable record
/// linking, optional priority (no default), due date, reminder (off by
/// default) and notes. One Save Goal button at the bottom, disabled until
/// the title is filled; saving opens the new Goal Details.
class CreateGoalScreen extends StatefulWidget {
  final String? initialDogName;
  final bool initialIsClientDog;
  final bool hasSportPack;
  final bool hasTrainerPack;
  final GoalInfo? editGoal;

  const CreateGoalScreen({
    super.key,
    this.initialDogName,
    this.initialIsClientDog = false,
    this.hasSportPack = false,
    this.hasTrainerPack = true,
    this.editGoal,
  });

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  static const _units = ['Sessions', 'Repetitions', 'Duration', 'Distance', 'Custom'];
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  late DogInfo _dog;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _notes = TextEditingController();
  final _targetValue = TextEditingController();
  final _customUnit = TextEditingController();

  String _category = 'Training';
  GoalTracking _tracking = GoalTracking.automatic;
  bool _openEnded = false;
  String _unit = 'Sessions';
  final List<String> _linked = [];
  String? _priority; // no default
  DateTime? _dueDate;
  bool _reminder = false;
  String _reminderTiming = 'On the due date';
  bool _saving = false;

  bool get _isEdit => widget.editGoal != null;
  bool get _canSave => _title.text.trim().isNotEmpty && !_saving;

  @override
  void initState() {
    super.initState();
    final e = widget.editGoal;
    _dog = SampleData.dogNamed(e?.dogName ?? widget.initialDogName ?? SampleData.myDogs.first.name);
    if (e != null) {
      _title.text = e.title;
      _description.text = e.description ?? '';
      _notes.text = e.notes ?? '';
      _category = e.category;
      _tracking = e.tracking;
      _openEnded = !e.isMeasurable;
      if (e.isMeasurable) {
        final known = _units.firstWhere((u) => e.targetUnit!.startsWith(u), orElse: () => 'Custom');
        _unit = known;
        if (known == 'Custom') _customUnit.text = e.targetUnit!;
        final v = e.targetValue!;
        _targetValue.text = v == v.roundToDouble() ? v.toInt().toString() : v.toString();
      }
      _linked.addAll(e.linkedRecords);
      _priority = e.priority;
      _dueDate = e.dueDate;
    }
    _title.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _notes.dispose();
    _targetValue.dispose();
    _customUnit.dispose();
    super.dispose();
  }

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  // ── Actions ─────────────────────────────────────────────────────────────
  void _pickDog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DogPickerSheet(
        selected: _dog.name,
        hasTrainerPack: widget.hasTrainerPack,
        onSelected: (d) {
          Navigator.pop(ctx);
          setState(() {
            _dog = d;
            _linked.clear(); // linked records belong to the selected dog
          });
        },
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primaryForestGreen,
            surface: AppColors.cardsCarbon,
            onSurface: AppColors.primaryTextOffWhite,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _openLinkRecords() {
    final groups = <String, List<String>>{
      'Skills': ['Recall', 'Heelwork', 'Retrieve'],
      'Exercises': ['Emergency Recall', 'Recall Through Distractions', 'Focused Heelwork'],
      'S&C activities': ['Swimming', 'Cavaletti Poles', 'Hill Work'],
      'Health records': ['Weight', 'Body Condition'],
      if (widget.hasSportPack) 'Sport skills': ['IGP Obedience', 'IGP Tracking'],
    };
    final draft = {..._linked};
    var query = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final q = query.trim().toLowerCase();
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.sizeOf(ctx).height * 0.8,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Link records for ${_dog.name}',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Linking alone does not add progress. Only qualifying recorded sessions count.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (v) => setSheet(() => query = v),
                        style: TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          hintText: 'Search your records',
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: UlvenikIcon(UlvenikIcons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 44),
                          filled: true,
                          fillColor: AppColors.backgroundObsidian,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        for (final entry in groups.entries)
                          if (entry.value.any((r) => q.isEmpty || r.toLowerCase().contains(q))) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 2),
                              child: Text(entry.key,
                                  style: TextStyle(
                                      color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                            for (final r in entry.value.where((r) => q.isEmpty || r.toLowerCase().contains(q)))
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppColors.primaryForestGreen,
                                value: draft.contains('$r (${_singular(entry.key)})'),
                                title: Text(r, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                                onChanged: (v) => setSheet(() {
                                  final key = '$r (${_singular(entry.key)})';
                                  v == true ? draft.add(key) : draft.remove(key);
                                }),
                              ),
                          ],
                        TextButton.icon(
                          onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AddSkillScreen())),
                          icon: UlvenikIcon(UlvenikIcons.add, size: 18, color: AppColors.primaryTextOffWhite),
                          label: Text('Create a new skill', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _linked
                              ..clear()
                              ..addAll(draft);
                          });
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: AppColors.onForestGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(draft.isEmpty ? 'Done' : 'Done (${draft.length})'),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  String _singular(String group) => switch (group) {
        'Skills' => 'skill',
        'Exercises' => 'exercise',
        'S&C activities' => 'S&C activity',
        'Health records' => 'health record',
        _ => 'sport skill',
      };

  void _save() {
    if (!_canSave) return;
    String? unit;
    num? value;
    if (!_openEnded) {
      value = num.tryParse(_targetValue.text.trim());
      unit = _unit == 'Custom' ? _customUnit.text.trim() : _unit;
      if (value == null || value <= 0 || unit.isEmpty) {
        AppSnackbar.show(context,
            message: 'Enter a target value and unit, or choose Open-ended.', type: SnackbarType.error);
        return;
      }
    }
    setState(() => _saving = true);
    final store = GoalsStore.instance;
    final goal = widget.editGoal ?? GoalInfo(id: store.newId(), dogName: _dog.name, title: '', category: _category, tracking: _tracking);
    goal
      ..dogName = _dog.name
      ..title = _title.text.trim()
      ..category = _category
      ..tracking = _tracking
      ..targetUnit = unit
      ..targetValue = value
      ..priority = _priority
      ..dueDate = _dueDate
      ..description = _description.text.trim().isEmpty ? null : _description.text.trim()
      ..notes = _notes.text.trim().isEmpty ? null : _notes.text.trim()
      ..linkedRecords = List.of(_linked);
    if (_isEdit) {
      store.save(goal); // no-op if already present; persists the mutation above
      AppSnackbar.show(context, message: 'Goal updated', type: SnackbarType.success);
      Navigator.pop(context);
    } else {
      store.save(goal);
      AppSnackbar.show(context, message: 'Goal created', type: SnackbarType.success);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GoalDetailsScreen.fromGoal(goal)));
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Training', UlvenikIcons.training),
      ('S&C', UlvenikIcons.strengthConditioning),
      ('Health', UlvenikIcons.health),
      if (widget.hasSportPack) ('Sport', null),
    ];
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Back',
          icon: UlvenikIcon(UlvenikIcons.back, size: 22, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(_isEdit ? 'Edit Goal' : 'Create Goal',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          // Dog
          _section('Dog', Material(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _isEdit ? null : _pickDog,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(children: [
                  DogSquarePhoto(dog: _dog, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_dog.name,
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text(_dog.isClient ? 'Client Dog' : 'My Dog',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  if (!_isEdit) Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
            ),
          )),

          // Title + description
          _section('Goal title', _field(_title, 'e.g. Complete 20 Recall Sessions', maxLines: 1)),
          _section('Description (optional)', _field(_description, 'Add details...', maxLines: 3)),

          // Category
          _section('Category', Wrap(spacing: 8, runSpacing: 8, children: [
            for (final c in categories)
              _Choice(
                label: c.$1,
                icon: c.$2,
                selected: _category == c.$1,
                onTap: () => setState(() => _category = c.$1),
              ),
          ])),

          // Tracking
          _section('Progress tracking', Column(children: [
            _RadioRow(
              title: 'Automatic',
              subtitle: 'Progress updates automatically from qualifying linked sessions and activities.',
              selected: _tracking == GoalTracking.automatic,
              onTap: () => setState(() => _tracking = GoalTracking.automatic),
            ),
            const SizedBox(height: 8),
            _RadioRow(
              title: 'Manual',
              subtitle: 'Track and update your progress manually.',
              selected: _tracking == GoalTracking.manual,
              onTap: () => setState(() => _tracking = GoalTracking.manual),
            ),
          ])),

          // Target
          _section('Target', Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Wrap(spacing: 8, children: [
              _Choice(label: 'Measurable target', selected: !_openEnded, onTap: () => setState(() => _openEnded = false)),
              _Choice(label: 'Open-ended', selected: _openEnded, onTap: () => setState(() => _openEnded = true)),
            ]),
            const SizedBox(height: 12),
            if (_openEnded)
              Text('No numerical target. Add progress notes and mark the goal complete when you decide.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4))
            else ...[
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final u in _units) _Choice(label: u, selected: _unit == u, onTap: () => setState(() => _unit = u)),
              ]),
              if (_unit == 'Custom') ...[
                const SizedBox(height: 10),
                _field(_customUnit, 'Unit name, e.g. Tracks', maxLines: 1),
              ],
              const SizedBox(height: 10),
              _field(
                _targetValue,
                _unit == 'Duration' ? 'Target in minutes' : _unit == 'Distance' ? 'Target in km' : 'Target value',
                maxLines: 1,
                keyboard: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ])),

          // Link records
          _section('Linked records', Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (_linked.isNotEmpty) ...[
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final r in _linked)
                  InputChip(
                    label: Text(r, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.backgroundObsidian,
                    side: BorderSide(color: AppColors.cardBorder),
                    deleteIconColor: AppColors.secondaryTextStoneGrey,
                    onDeleted: () => setState(() => _linked.remove(r)),
                  ),
              ]),
              const SizedBox(height: 10),
            ],
            SizedBox(
              height: 46,
              child: OutlinedButton(
                onPressed: _openLinkRecords,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_linked.isEmpty ? 'Link a Record' : 'Edit linked records'),
              ),
            ),
          ])),

          // Priority
          _section('Priority (optional)', Wrap(spacing: 8, children: [
            for (final p in const ['Low', 'Medium', 'High'])
              _Choice(label: p, selected: _priority == p, onTap: () => setState(() => _priority = _priority == p ? null : p)),
          ])),

          // Due date + reminder
          _section('Due date & reminder (optional)', Column(children: [
            _SettingRow(
              icon: UlvenikIcons.calendar,
              label: 'Due date',
              value: _dueDate == null ? 'None' : _date(_dueDate!),
              onTap: _pickDueDate,
              trailing: _dueDate == null
                  ? null
                  : IconButton(
                      tooltip: 'Clear due date',
                      icon: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                      onPressed: () => setState(() {
                        _dueDate = null;
                        _reminder = false;
                      }),
                    ),
            ),
            Divider(color: AppColors.cardBorder, height: 1),
            Row(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: UlvenikIcon(UlvenikIcons.notifications, size: 20, color: AppColors.secondaryTextStoneGrey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Reminder', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                  if (_dueDate == null)
                    Text('Set a due date to add a reminder.',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                ]),
              ),
              Switch(
                value: _reminder,
                activeThumbColor: AppColors.primaryTextOffWhite,
                activeTrackColor: AppColors.primaryForestGreen,
                onChanged: _dueDate == null ? null : (v) => setState(() => _reminder = v),
              ),
            ]),
            if (_reminder)
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final t in const ['On the due date', '1 day before', '1 week before'])
                    _Choice(label: t, selected: _reminderTiming == t, onTap: () => setState(() => _reminderTiming = t)),
                ]),
              ),
          ])),

          // Notes
          _section('Notes (optional)', _field(_notes, 'Anything else to remember...', maxLines: 3)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _canSave ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.onForestGreen,
                disabledBackgroundColor: AppColors.primaryForestGreen.withValues(alpha: 0.35),
                disabledForegroundColor: AppColors.primaryTextOffWhite.withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const UlvenikIcon(UlvenikIcons.save, size: 20),
                const SizedBox(width: 8),
                Text(_isEdit ? 'Save Changes' : 'Save Goal',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String label, Widget child) => Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(label, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            child,
          ]),
        ),
      );

  Widget _field(TextEditingController c, String hint, {int maxLines = 1, TextInputType? keyboard}) => TextField(
        controller: c,
        maxLines: maxLines,
        minLines: 1,
        keyboardType: keyboard,
        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.7)),
          filled: true,
          fillColor: AppColors.backgroundObsidian,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryForestGreen)),
        ),
      );
}

class _Choice extends StatelessWidget {
  final String label;
  final String? icon;
  final bool selected;
  final VoidCallback onTap;
  const _Choice({required this.label, required this.selected, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryForestGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.primaryForestGreen : Colors.white24),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[
              UlvenikIcon(icon!, size: 16, color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 6),
            ],
            Text(label,
                style: TextStyle(
                  color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                )),
          ]),
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _RadioRow({required this.title, required this.subtitle, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryForestGreen.withValues(alpha: 0.15) : AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primaryForestGreen : Colors.white12),
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.35)),
              ]),
            ),
            const SizedBox(width: 8),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey, size: 22),
          ]),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;
  const _SettingRow({required this.icon, required this.label, required this.value, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          UlvenikIcon(icon, size: 20, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14))),
          Text(value, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          trailing ?? SizedBox(width: 48, height: 48, child: Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey)),
        ]),
      ),
    );
  }
}
