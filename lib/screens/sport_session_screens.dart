import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../data/sport_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/period_sheet.dart';
import '../widgets/session_items_picker.dart';
import '../widgets/session_rating.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_links.dart';
import 'sport_screens.dart';

String sportDefaultName(DateTime d) => 'Sport Session · ${fmtDate(d)}';

String sportDuration(int minutes) {
  final h = minutes ~/ 60, m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

class _SportDraft {
  final String sportId;
  final String name;
  final Set<String> itemIds;
  final TextEditingController minutes;
  _SportDraft(this.sportId, this.name, this.itemIds, this.minutes);
}

/// Record Sport Session (also edits one). One saved record can involve
/// several of the dog's sports; each has its own skills and exercises and,
/// only when several sports are chosen, optional time attributed to it.
class SportRecordSessionScreen extends StatefulWidget {
  final String dogName;
  final String? sportId; // preselected
  final SportSession? session;
  const SportRecordSessionScreen({super.key, required this.dogName, this.sportId, this.session});

  @override
  State<SportRecordSessionScreen> createState() => _SportRecordSessionScreenState();
}

class _SportRecordSessionScreenState extends State<SportRecordSessionScreen> {
  final _store = SportStore.instance;
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
  final List<_SportDraft> _drafts = [];
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
        _drafts.add(_SportDraft(e.sportId, e.sportName, {...e.itemIds},
            TextEditingController(text: e.minutes == null ? '' : '${e.minutes}')));
      }
    } else if (widget.sportId != null) {
      final sp = _store.sport(widget.dogName, widget.sportId!);
      if (sp != null) _drafts.add(_SportDraft(sp.id, sp.name, {}, TextEditingController()));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _name.dispose();
    _notes.dispose();
    _minutes.dispose();
    for (final d in _drafts) {
      d.minutes.dispose();
    }
    super.dispose();
  }

  Future<void> _pickSports() async {
    final all = _store.sports(widget.dogName);
    if (all.isEmpty) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => SportFormScreen(dogName: widget.dogName)));
      return;
    }
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final draft = {for (final d in _drafts) d.sportId};
        return StatefulBuilder(
          builder: (ctx, setSheet) => SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                Text('Select Sports',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final s in all)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryForestGreen,
                    checkColor: AppColors.primaryTextOffWhite,
                    title: Text(s.name, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                    value: draft.contains(s.id),
                    onChanged: (v) => setSheet(() => v == true ? draft.add(s.id) : draft.remove(s.id)),
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
      _drafts.removeWhere((d) {
        final drop = !result.contains(d.sportId);
        if (drop) d.minutes.dispose();
        return drop;
      });
      for (final id in result) {
        if (_drafts.any((d) => d.sportId == id)) continue;
        final sp = _store.sport(widget.dogName, id);
        if (sp != null) _drafts.add(_SportDraft(sp.id, sp.name, {}, TextEditingController()));
      }
      _error = null;
    });
  }

  Future<void> _pickItems(_SportDraft d) async {
    final items = _store.items(widget.dogName, d.sportId);
    if (items.isEmpty) {
      AppSnackbar.show(context,
          message: 'Add skills or exercises to ${d.name} first.', type: SnackbarType.info);
      return;
    }
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final draft = {...d.itemIds};
        return StatefulBuilder(
          builder: (ctx, setSheet) => SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                Text('${d.name} · Skills & Exercises',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final i in items)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryForestGreen,
                    checkColor: AppColors.primaryTextOffWhite,
                    title: Text(i.name, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                    subtitle: Text(i.kindLabel,
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    value: draft.contains(i.id),
                    onChanged: (v) => setSheet(() => v == true ? draft.add(i.id) : draft.remove(i.id)),
                  ),
                const SizedBox(height: 8),
                PrimaryButton(label: 'Done', onPressed: () => Navigator.pop(ctx, draft)),
              ]),
            ),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        d.itemIds
          ..clear()
          ..addAll(result);
      });
    }
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
    if (_drafts.isEmpty) {
      setState(() => _error = 'Choose at least one sport.');
      return;
    }
    _timer?.cancel();
    _saving = true;
    final entries = <SportEntry>[];
    for (final d in _drafts) {
      final items = _store.items(widget.dogName, d.sportId).where((i) => d.itemIds.contains(i.id)).toList();
      // keep names of items that were since archived/deleted
      final known = items.map((i) => i.id).toSet();
      final oldNames = {
        for (final e in widget.session?.entries ?? <SportEntry>[])
          for (var k = 0; k < e.itemIds.length; k++) e.itemIds[k]: e.itemNames[k],
      };
      final ids = [...items.map((i) => i.id), ...d.itemIds.where((id) => !known.contains(id))];
      final names = [...items.map((i) => i.name), ...d.itemIds.where((id) => !known.contains(id)).map((id) => oldNames[id] ?? '')];
      final m = _drafts.length > 1 ? int.tryParse(d.minutes.text.trim()) : null;
      entries.add(SportEntry(d.sportId, d.name, ids, names, (m != null && m > 0) ? m : null));
    }
    final dur = int.tryParse(_minutes.text.trim());
    final name = _name.text.trim().isEmpty ? sportDefaultName(_at) : _name.text.trim();
    final s = widget.session ?? SportSession(id: _store.newId(), name: name, at: _at);
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
    MediaStore.instance.attach(widget.dogName,
        [for (final n in _media) if (_mediaFiles[n] != null) _mediaFiles[n]!], MediaLinks.sport(widget.dogName, s.id),
        mediaDate: _at);
    AppSnackbar.show(context, message: 'Sport session saved', type: SnackbarType.success);
    if (widget.session != null) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SportSessionDetailsScreen(dogName: widget.dogName, sessionId: s.id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerText =
        '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}';
    return HealthScaffold(
      title: widget.session == null ? 'Record Sport Session' : 'Edit Session',
      bottom: PrimaryButton(label: 'Save Sport Session', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Session Name'),
          TextField(
            controller: _name,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration(sportDefaultName(_at)),
          ),
          const FieldLabel('Date', required: true),
          DateField(
              value: _at,
              onChanged: (d) => setState(() => _at = DateTime(d.year, d.month, d.day, _at.hour, _at.minute))),
          const FieldLabel('Time'),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _pickTime,
            child: InputDecorator(
              decoration: healthDecoration('Select time'),
              child: Text(fmtTime(_at), style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
            ),
          ),
          const FieldLabel('Session Duration'),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _minutes,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('Total minutes', suffix: 'min'),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: _toggleTimer,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: BorderSide(color: AppColors.cardBorder),
                minimumSize: const Size(0, 50),
              ),
              child: Text(_timer != null ? 'Stop  $timerText' : 'Start Timer'),
            ),
          ]),
          const SizedBox(height: 22),
          const SectionLabel('Sports'),
          for (final d in _drafts) ...[
            HealthCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.name,
                    style: TextStyle(
                        color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _pickItems(d),
                  child: InputDecorator(
                    decoration: healthDecoration('Select skills and exercises'),
                    child: Text(
                      d.itemIds.isEmpty
                          ? 'Skills and Exercises (optional)'
                          : _store
                              .items(widget.dogName, d.sportId)
                              .where((i) => d.itemIds.contains(i.id))
                              .map((i) => i.name)
                              .join(', '),
                      style: TextStyle(
                          color: d.itemIds.isEmpty ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                          fontSize: 14.5),
                    ),
                  ),
                ),
                if (_drafts.length > 1) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: d.minutes,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                    decoration: healthDecoration('Time spent on ${d.name} (optional)', suffix: 'min'),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 10),
          ],
          OutlinedButton.icon(
            onPressed: _pickSports,
            icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
            label: Text(_drafts.isEmpty ? 'Add Sports' : 'Change Sports'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryTextOffWhite,
              side: BorderSide(color: AppColors.cardBorder),
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
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
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
                side: BorderSide(color: AppColors.cardBorder),
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
                    label: Text(n, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.cardsCarbon,
                    side: BorderSide(color: AppColors.cardBorder),
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

/// Saved Sport Session Details. ⋮ → Edit Session | Delete Session.
class SportSessionDetailsScreen extends StatelessWidget {
  final String dogName;
  final String sessionId;
  const SportSessionDetailsScreen({super.key, required this.dogName, required this.sessionId});

  static TextStyle get _body => TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, height: 1.45);

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final s = store.session(dogName, sessionId);
        if (s == null) return const HealthScaffold(title: 'Session Details', body: SizedBox.shrink());

        Widget section(String title, Widget child) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SectionLabel(title), child]),
            );

        return HealthScaffold(
          title: 'Session Details',
          actions: [
            IconButton(
              tooltip: 'More',
              icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: AppColors.cardsCarbon,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (ctx) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                        leading: UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
                        title: Text('Edit Session', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SportRecordSessionScreen(dogName: dogName, session: s)),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                        title: const Text('Delete Session', style: TextStyle(color: Color(0xFFFFB4AB))),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ok = await confirmDelete(context,
                              title: 'Delete session?',
                              message:
                                  'This session will be permanently deleted and removed from every sport it was recorded under.');
                          if (!ok || !context.mounted) return;
                          MediaStore.instance.unlinkRecord(dogName, 'sport:${s.id}');
                          store.deleteSession(dogName, s.id);
                          AppSnackbar.show(context, message: 'Session deleted', type: SnackbarType.success);
                          Navigator.pop(context);
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(s.name,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('${fmtDate(s.at)} · ${fmtTime(s.at)}',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              if (s.durationMinutes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text('Duration: ${sportDuration(s.durationMinutes!)}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                ),
              const SizedBox(height: 22),
              section(
                'Sports',
                Column(children: [
                  for (final e in s.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: HealthCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(
                              child: Text(e.sportName,
                                  style: TextStyle(
                                      color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            if (e.minutes != null)
                              Text(sportDuration(e.minutes!),
                                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                          ]),
                          if (e.itemNames.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(e.itemNames.join(', '),
                                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                            ),
                        ]),
                      ),
                    ),
                ]),
              ),
              if (s.rewards.isNotEmpty)
                section(SessionItemKind.rewards.usedTitle, Text(s.rewards.join(', '), style: _body)),
              if (s.equipment.isNotEmpty)
                section(SessionItemKind.equipment.usedTitle, Text(s.equipment.join(', '), style: _body)),
              if (s.notes.isNotEmpty) section('Notes', Text(s.notes, style: _body)),
              if (s.media.isNotEmpty) section('Photos and Videos', Text(s.media.join(', '), style: _body)),
              if (s.rating != null) section('Session Rating', SessionRatingBadge(rating: s.rating)),
            ],
          ),
        );
      },
    );
  }
}

/// Sport Sessions History: all of the dog's sport sessions, or only those
/// involving one sport. Search by name, date range, newest/oldest.
class SportSessionsHistoryScreen extends StatefulWidget {
  final String dogName;
  final String? sportId;
  const SportSessionsHistoryScreen({super.key, required this.dogName, this.sportId});

  @override
  State<SportSessionsHistoryScreen> createState() => _SportSessionsHistoryScreenState();
}

class _SportSessionsHistoryScreenState extends State<SportSessionsHistoryScreen> {
  final _store = SportStore.instance;
  final _search = TextEditingController();
  String _period = 'Lifetime';
  bool _newest = true;

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
    _search.addListener(_refresh);
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _record() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SportRecordSessionScreen(dogName: widget.dogName, sportId: widget.sportId)),
      );

  @override
  Widget build(BuildContext context) {
    final all = _store.sessions(widget.dogName, sportId: widget.sportId);
    final q = _search.text.trim().toLowerCase();
    final from = periodStart(_period);
    final list = all
        .where((s) => (q.isEmpty || s.name.toLowerCase().contains(q)) && (from == null || !s.at.isBefore(from)))
        .toList();
    if (!_newest) list.sort((a, b) => a.at.compareTo(b.at));

    return HealthScaffold(
      title: 'Sport Sessions',
      bottom: all.isEmpty
          ? null
          : PrimaryButton(label: 'Record Sport Session', icon: UlvenikIcons.recordSession, onPressed: _record),
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.emoji_events_outlined,
                title: 'No Sport Sessions Yet',
                message: 'Start recording your dog’s sport training journey.',
                actionLabel: 'Record Sport Session',
                onAction: _record,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                TextField(
                  controller: _search,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                  decoration: healthDecoration('Search sessions...').copyWith(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: UlvenikIcon(UlvenikIcons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 4,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        final p = await showPeriodSheet(context, _period);
                        if (p != null) setState(() => _period = p);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.cardsCarbon,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _period == 'Lifetime' ? AppColors.cardBorder : AppColors.primaryForestGreen),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          UlvenikIcon(UlvenikIcons.calendar, size: 15, color: AppColors.secondaryTextStoneGrey),
                          const SizedBox(width: 6),
                          Text('Date Range · $_period',
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                        ]),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _newest = !_newest),
                      icon: AnimatedRotation(
                        turns: _newest ? 0 : 0.5,
                        duration: const Duration(milliseconds: 250),
                        child: UlvenikIcon(UlvenikIcons.sort, size: 16, color: AppColors.secondaryTextStoneGrey),
                      ),
                      label: Text(_newest ? 'Newest First' : 'Oldest First',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (list.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('No sessions match your search or date range.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                    ),
                  ),
                for (final s in list) ...[
                  HealthCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SportSessionDetailsScreen(dogName: widget.dogName, sessionId: s.id)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.name,
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 3),
                          Text(
                            fmtDate(s.at) + (s.durationMinutes == null ? '' : ' · ${sportDuration(s.durationMinutes!)}'),
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                          ),
                          const SizedBox(height: 2),
                          Text(s.entries.map((e) => e.sportName).join(' · '),
                              style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5)),
                        ]),
                      ),
                      UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                    ]),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}
