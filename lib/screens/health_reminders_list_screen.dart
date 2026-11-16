import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

String reminderWhen(HealthReminder r) => fmtDate(r.due) + (r.hasTime ? ' · ${fmtTime(r.due)}' : '');

Widget reminderIcon(HealthReminder r, {double size = 20}) => r.type == ReminderType.vetAppointment
    ? Icon(Icons.medical_services_outlined, size: size, color: kHealthGreen)
    : UlvenikIcon(UlvenikIcons.notifications, size: size, color: kHealthGreen);

Future<void> openReminder(BuildContext context, String dogName, HealthReminder r) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => HealthReminderForm(dogName: dogName, entry: r)));

/// Health Reminders for one dog: upcoming (soonest first), overdue and
/// completed history, with Add Reminder.
class HealthRemindersListScreen extends StatelessWidget {
  final String dogName;
  const HealthRemindersListScreen({super.key, required this.dogName});

  @override
  Widget build(BuildContext context) {
    final store = HealthStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final up = store.upcoming(dogName);
        final over = store.overdue(dogName);
        final done = store.completed(dogName);
        final empty = up.isEmpty && over.isEmpty && done.isEmpty;

        Widget tile(HealthReminder r, {bool muted = false}) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HealthCard(
                onTap: () => openReminder(context, dogName, r),
                child: Row(children: [
                  reminderIcon(r, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.title,
                          style: TextStyle(
                              color: muted ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: r.completed ? TextDecoration.lineThrough : null)),
                      const SizedBox(height: 2),
                      Text('${r.type.label} · ${reminderWhen(r)}${r.repeat == 'None' ? '' : ' · ${r.repeat}'}',
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
            );

        return HealthScaffold(
          title: 'Health Reminders',
          bottom: empty
              ? null
              : PrimaryButton(
                  label: 'Add Reminder',
                  icon: UlvenikIcons.add,
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HealthReminderForm(dogName: dogName))),
                ),
          body: empty
              ? Center(
                  child: EmptyState(
                    icon: Icons.notifications_none,
                    title: 'No Health Reminders Yet',
                    message: 'Add a reminder for an appointment, treatment or dose.',
                    actionLabel: 'Add Reminder',
                    onAction: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HealthReminderForm(dogName: dogName))),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    const SectionLabel('Upcoming Reminders'),
                    if (up.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: Text('Nothing upcoming.',
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                      ),
                    for (final r in up) tile(r),
                    if (over.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const SectionLabel('Overdue'),
                      for (final r in over) tile(r),
                    ],
                    if (done.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const SectionLabel('Completed Reminders'),
                      for (final r in done) tile(r, muted: true),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

class HealthReminderForm extends StatefulWidget {
  final String dogName;
  final HealthReminder? entry;
  const HealthReminderForm({super.key, required this.dogName, this.entry});

  @override
  State<HealthReminderForm> createState() => _HealthReminderFormState();
}

class _HealthReminderFormState extends State<HealthReminderForm> {
  late final _title = TextEditingController(text: widget.entry?.title ?? '');
  late final _linked = TextEditingController(text: widget.entry?.linkedRecord ?? '');
  late final _notes = TextEditingController(text: widget.entry?.notes ?? '');
  late DateTime? _date = widget.entry?.due;
  late TimeOfDay? _time =
      (widget.entry?.hasTime ?? false) ? TimeOfDay.fromDateTime(widget.entry!.due) : null;
  late ReminderType _type = widget.entry?.type ?? ReminderType.other;
  late String _repeat = widget.entry?.repeat ?? 'None';
  late bool _notifyOn = widget.entry?.notify != null;
  late String _notify = widget.entry?.notify ?? 'At Scheduled Time';
  String? _titleError;
  String? _dateError;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _linked.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    setState(() {
      _titleError = _title.text.trim().isEmpty ? 'Please enter a reminder title.' : null;
      _dateError = _date == null ? 'Please choose a date.' : null;
    });
    if (_titleError != null || _dateError != null) return;
    _saving = true;
    final d = _date!;
    final due = _time == null ? d : DateTime(d.year, d.month, d.day, _time!.hour, _time!.minute);
    final store = HealthStore.instance;
    store.saveReminder(
      widget.dogName,
      HealthReminder(
        id: widget.entry?.id ?? store.newId(),
        title: _title.text.trim(),
        due: due,
        hasTime: _time != null,
        type: _type,
        repeat: _repeat,
        linkedRecord: _linked.text.trim().isEmpty ? null : _linked.text.trim(),
        notes: _notes.text.trim(),
        notify: _notifyOn ? _notify : null,
        completed: widget.entry?.completed ?? false,
      ),
    );
    AppSnackbar.show(context, message: 'Reminder saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  Future<void> _complete() async {
    final e = widget.entry!;
    e.completed = !e.completed;
    HealthStore.instance.saveReminder(widget.dogName, e);
    AppSnackbar.show(context,
        message: e.completed ? 'Reminder marked as completed' : 'Reminder restored', type: SnackbarType.success);
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    final ok = await confirmDelete(context,
        title: 'Delete reminder?', message: 'This reminder will be permanently deleted.');
    if (!ok || !mounted) return;
    HealthStore.instance.deleteReminder(widget.dogName, widget.entry!.id);
    AppSnackbar.show(context, message: 'Reminder deleted', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.entry != null;
    return HealthScaffold(
      title: editing ? 'Edit Reminder' : 'Add Reminder',
      actions: [
        if (editing)
          PopupMenuButton<String>(
            color: AppColors.cardsCarbon,
            icon: const UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
            onSelected: (v) => v == 'done' ? _complete() : _delete(),
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: 'done',
                  child: Text(widget.entry!.completed ? 'Mark as Upcoming' : 'Mark as Completed',
                      style: const TextStyle(color: AppColors.primaryTextOffWhite))),
              const PopupMenuItem(
                  value: 'delete', child: Text('Delete Reminder', style: TextStyle(color: Color(0xFFFFB4AB)))),
            ],
          ),
      ],
      bottom: PrimaryButton(label: 'Save', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Reminder Title', required: true),
          TextField(
            controller: _title,
            onChanged: (_) => _titleError == null ? null : setState(() => _titleError = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. Booster vaccination', error: _titleError),
          ),
          const FieldLabel('Date', required: true),
          DateField(
            value: _date,
            error: _dateError,
            onChanged: (d) => setState(() {
              _date = d;
              _dateError = null;
            }),
          ),
          const FieldLabel('Type', required: true),
          ChoiceRow(
            options: [for (final t in ReminderType.values) t.label],
            value: _type.label,
            onChanged: (v) => setState(() => _type = ReminderType.values.firstWhere((t) => t.label == v)),
          ),
          const FieldLabel('Time'),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: _time ?? TimeOfDay.now());
              if (t != null) setState(() => _time = t);
            },
            child: InputDecorator(
              decoration: healthDecoration('Select time'),
              child: Row(children: [
                Expanded(
                  child: Text(_time == null ? 'Select time' : _time!.format(context),
                      style: TextStyle(
                          color: _time == null ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                          fontSize: 14.5)),
                ),
                if (_time != null)
                  GestureDetector(
                    onTap: () => setState(() => _time = null),
                    child: const Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                  ),
              ]),
            ),
          ),
          const FieldLabel('Repeat'),
          ChoiceRow(
            options: const ['None', 'Daily', 'Weekly', 'Monthly', 'Custom'],
            value: _repeat,
            onChanged: (v) => setState(() => _repeat = v),
          ),
          const FieldLabel('Linked Health Record'),
          TextField(
            controller: _linked,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. Booster vaccination record'),
          ),
          const FieldLabel('Notes'),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 5,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add notes...'),
          ),
          const SizedBox(height: 14),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primaryForestGreen,
            title: const Text('Notifications',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
            subtitle: const Text('Device alerts need notification permission and are optional.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            value: _notifyOn,
            onChanged: (v) => setState(() => _notifyOn = v),
          ),
          if (_notifyOn)
            ChoiceRow(
              options: const ['At Scheduled Time', '1 Hour Before', '1 Day Before', 'Custom'],
              value: _notify,
              onChanged: (v) => setState(() => _notify = v),
            ),
        ],
      ),
    );
  }
}
