import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/session_items_picker.dart';
import '../widgets/session_rating.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_links.dart';
import 'sc_activity_form_screen.dart';
import 'session_templates_new.dart';
import 'sc_session_details_screen.dart';

String scDefaultName(DateTime d) => 'S&C Session · ${fmtDate(d)}';

/// Record S&C Session (also used to edit one). Several activities can go in
/// one session; each shows its own optional measurement fields. One session is
/// saved, never one per activity.
class SCRecordSessionScreen extends StatefulWidget {
  final String dogName;
  final String? activityId; // preselected
  final List<String>? presetActivityIds; // from a template
  final List<String>? presetRewards;
  final List<String>? presetEquipment;
  final String? templateId;
  final String? planNote; // template plan, shown apart from Notes
  final SCSession? session; // when editing
  const SCRecordSessionScreen({
    super.key,
    required this.dogName,
    this.activityId,
    this.session,
    this.presetActivityIds,
    this.presetRewards,
    this.presetEquipment,
    this.templateId,
    this.planNote,
  });

  @override
  State<SCRecordSessionScreen> createState() => _SCRecordSessionScreenState();
}

class _EntryDraft {
  final String activityId;
  final String name;
  final Map<SCMeasure, TextEditingController> ctrls;
  final Map<SCMeasure, String> units;
  _EntryDraft(this.activityId, this.name, this.ctrls, this.units);
}

class _SCRecordSessionScreenState extends State<SCRecordSessionScreen> {
  final _store = SCStore.instance;
  late final _name = TextEditingController(text: widget.session?.name ?? '');
  late final _notes = TextEditingController(text: widget.session?.notes ?? '');
  late final _minutes = TextEditingController(
      text: widget.session?.durationMinutes == null ? '' : '${widget.session!.durationMinutes}');
  late DateTime _at = widget.session?.at ?? DateTime.now();
  late List<String> _rewards = [...?widget.session?.rewards];
  late List<String> _equipment = [...?widget.session?.equipment];
  late List<String> _media = [...?widget.session?.media];
  final Map<String, MediaFile> _mediaFiles = {};
  late SessionRating? _rating = widget.session?.rating;
  final List<_EntryDraft> _entries = [];
  String? _error;
  bool _saving = false;

  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    final s = widget.session;
    if (s != null) {
      for (final e in s.entries) {
        _entries.add(_EntryDraft(
          e.activityId,
          e.activityName,
          {for (final en in e.values.entries) en.key: TextEditingController(text: _num(en.value.value))},
          {for (final en in e.values.entries) en.key: en.value.unit},
        ));
        // measurements the activity tracks now but this session didn't record
        final a = _store.activity(widget.dogName, e.activityId);
        for (final m in a?.measures ?? <SCMeasure>{}) {
          _entries.last.ctrls.putIfAbsent(m, () => TextEditingController());
          _entries.last.units.putIfAbsent(m, () => a!.units[m] ?? '');
        }
      }
    } else if (widget.presetActivityIds != null) {
      for (final id in widget.presetActivityIds!) {
        final a = _store.activity(widget.dogName, id);
        if (a != null && !a.archived && !a.deleted) _entries.add(_draftFor(a));
      }
      _rewards = [...?widget.presetRewards];
      _equipment = [...?widget.presetEquipment];
    } else if (widget.activityId != null) {
      final a = _store.activity(widget.dogName, widget.activityId!);
      if (a != null) _entries.add(_draftFor(a));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _name.dispose();
    _notes.dispose();
    _minutes.dispose();
    for (final e in _entries) {
      for (final c in e.ctrls.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  _EntryDraft _draftFor(SCActivity a) => _EntryDraft(
        a.id,
        a.name,
        {for (final m in a.measures) m: TextEditingController()},
        {for (final m in a.measures) m: a.units[m] ?? ''},
      );

  Future<void> _pickActivities() async {
    final all = _store.activities(widget.dogName);
    if (all.isEmpty) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => SCActivityFormScreen(dogName: widget.dogName)));
      return;
    }
    final chosen = {for (final e in _entries) e.activityId};
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final draft = {...chosen};
        return StatefulBuilder(
          builder: (ctx, setSheet) => SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                const Text('Select Activities',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final a in all)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryForestGreen,
                    checkColor: AppColors.primaryTextOffWhite,
                    title: Text(a.name, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                    value: draft.contains(a.id),
                    onChanged: (v) => setSheet(() => v == true ? draft.add(a.id) : draft.remove(a.id)),
                  ),
                const SizedBox(height: 8),
                PrimaryButton(label: 'Done', onPressed: () => Navigator.pop(ctx, draft)),
              ]),
            ),
          ),
        );
      },
    );
    if (result == null) return;
    setState(() {
      _entries.removeWhere((e) {
        final drop = !result.contains(e.activityId);
        if (drop) {
          for (final c in e.ctrls.values) {
            c.dispose();
          }
        }
        return drop;
      });
      for (final id in result) {
        if (_entries.any((e) => e.activityId == id)) continue;
        final a = _store.activity(widget.dogName, id);
        if (a != null) _entries.add(_draftFor(a));
      }
      _error = null;
    });
  }

  void _toggleTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      final mins = (_seconds / 60).ceil();
      setState(() => _minutes.text = '${mins < 1 ? 1 : mins}');
    } else {
      _seconds = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _seconds++));
      setState(() {});
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_at));
    if (t != null) setState(() => _at = DateTime(_at.year, _at.month, _at.day, t.hour, t.minute));
  }

  Future<void> _addMedia() async {
    final r = await pickMediaFiles(type: FileType.media);
    if (r.isEmpty) return;
    setState(() {
      for (final f in r) {
        _mediaFiles[f.name] = f;
      }
      _media = {..._media, ...r.map((f) => f.name)}.toList();
    });
  }

  void _save() {
    if (_saving) return;
    if (_entries.isEmpty) {
      setState(() => _error = 'Add at least one activity.');
      return;
    }
    _timer?.cancel();
    _saving = true;
    final entries = <SCEntry>[];
    for (final e in _entries) {
      final values = <SCMeasure, SCValue>{};
      e.ctrls.forEach((m, c) {
        final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
        if (v != null) values[m] = SCValue(v, e.units[m] ?? '');
      });
      entries.add(SCEntry(e.activityId, e.name, values));
    }
    final name = _name.text.trim().isEmpty ? scDefaultName(_at) : _name.text.trim();
    final dur = int.tryParse(_minutes.text.trim());
    final s = widget.session ?? SCSession(id: _store.newId(), name: name, at: _at);
    s
      ..name = name
      ..at = _at
      ..durationMinutes = (dur != null && dur > 0) ? dur : null
      ..entries = entries
      ..rewards = _rewards
      ..equipment = _equipment
      ..notes = _notes.text.trim()
      ..media = _media
      ..rating = _rating;
    _store.saveSession(widget.dogName, s);
    if (widget.templateId != null && widget.session == null) TemplateStore.instance.markUsed(widget.templateId!);
    MediaStore.instance.attach(widget.dogName,
        [for (final n in _media) if (_mediaFiles[n] != null) _mediaFiles[n]!], MediaLinks.sc(widget.dogName, s.id),
        mediaDate: _at);
    AppSnackbar.show(context, message: 'S&C session saved', type: SnackbarType.success);
    if (widget.session != null) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SCSessionDetailsScreen(dogName: widget.dogName, sessionId: s.id)),
      );
    }
  }

  Widget _numberField(_EntryDraft e, SCMeasure m) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(m.label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
      ),
      TextField(
        controller: e.ctrls[m],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
        decoration: healthDecoration('Enter ${m.label.toLowerCase()}', suffix: (e.units[m] ?? '').isEmpty ? null : e.units[m]),
      ),
      if (m.units.isNotEmpty) ...[
        const SizedBox(height: 8),
        ChoiceRow(
          options: m.units,
          value: (e.units[m] ?? '').isEmpty ? null : e.units[m],
          onChanged: (u) => setState(() => e.units[m] = u),
        ),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final timerText =
        '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';
    return HealthScaffold(
      title: widget.session == null ? 'Record S&C Session' : 'Edit Session',
      bottom: PrimaryButton(label: 'Save S&C Session', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if ((widget.planNote ?? '').trim().isNotEmpty) ...[
            HealthCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Session plan', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                const SizedBox(height: 4),
                Text(widget.planNote!, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, height: 1.4)),
              ]),
            ),
            const SizedBox(height: 6),
          ],
          const FieldLabel('Session Name'),
          TextField(
            controller: _name,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration(scDefaultName(_at)),
          ),
          const FieldLabel('Date', required: true),
          DateField(value: _at, onChanged: (d) => setState(() => _at = DateTime(d.year, d.month, d.day, _at.hour, _at.minute))),
          const FieldLabel('Time'),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _pickTime,
            child: InputDecorator(
              decoration: healthDecoration('Select time'),
              child: Text(fmtTime(_at),
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
            ),
          ),
          const FieldLabel('Session Duration'),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _minutes,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('Total minutes', suffix: 'min'),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: _toggleTimer,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: const BorderSide(color: Colors.white24),
                minimumSize: const Size(0, 50),
              ),
              child: Text(_timer != null ? 'Stop  $timerText' : 'Start Timer'),
            ),
          ]),
          const SizedBox(height: 22),
          const SectionLabel('Activities'),
          if (_entries.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Choose the activities you did in this session.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
            ),
          for (final e in _entries) ...[
            HealthCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.name,
                    style: const TextStyle(
                        color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                for (final m in SCMeasure.values)
                  if (e.ctrls.containsKey(m)) _numberField(e, m),
                if (e.ctrls.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('No measurements set for this activity.',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  ),
              ]),
            ),
            const SizedBox(height: 10),
          ],
          OutlinedButton.icon(
            onPressed: _pickActivities,
            icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
            label: Text(_entries.isEmpty ? 'Add Activities' : 'Change Activities'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryTextOffWhite,
              side: const BorderSide(color: Colors.white24),
              minimumSize: const Size(0, 46),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(_error!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
            ),
          const SizedBox(height: 22),
          SessionItemsField(kind: SessionItemKind.rewards, selected: _rewards, onChanged: (v) => setState(() => _rewards = v)),
          const SizedBox(height: 10),
          SessionItemsField(kind: SessionItemKind.equipment, selected: _equipment, onChanged: (v) => setState(() => _equipment = v)),
          const FieldLabel('Notes'),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 6,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add notes about this session...'),
          ),
          const FieldLabel('Photos and Videos'),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _addMedia,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: const Text('Add Photos or Videos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: const BorderSide(color: Colors.white24),
                minimumSize: const Size(0, 44),
              ),
            ),
          ),
          if (_media.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 8, runSpacing: 6, children: [
                for (final n in _media)
                  InputChip(
                    label: Text(n, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.cardsCarbon,
                    side: const BorderSide(color: Colors.white12),
                    deleteIconColor: AppColors.secondaryTextStoneGrey,
                    onDeleted: () => setState(() => _media = [..._media]..remove(n)),
                  ),
              ]),
            ),
          const SizedBox(height: 18),
          SessionRatingField(value: _rating, onChanged: (r) => setState(() => _rating = r)),
        ],
      ),
    );
  }
}
