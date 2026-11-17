import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../data/sport_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_links.dart';
import 'sport_screens.dart';

Widget _cardFor(BuildContext context, Competition c, VoidCallback onTap, {Widget? trailing, bool history = false}) {
  final parts = [fmtDate(c.date), c.sportName, if (c.location.isNotEmpty) c.location];
  final outcome = [
    if (c.needsReview) 'Needs review' else if (c.status != 'Upcoming' && c.status != 'Completed') c.status,
    if (c.placement.isNotEmpty) c.placement,
    if (c.result.isNotEmpty) c.result,
  ].join(' · ');
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: HealthCard(
      onTap: onTap,
      child: Row(children: [
        UlvenikIcon(UlvenikIcons.completed, size: 22, color: AppColors.secondarySage),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.name,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(parts.join(' · '),
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            if (history && outcome.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(outcome,
                    style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5, fontWeight: FontWeight.w600)),
              ),
          ]),
        ),
        trailing ?? UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
      ]),
    ),
  );
}

/// Competitions & Trials. From the Sport tab it lists every sport; from an
/// individual sport it filters the same records to that sport (no copies).
/// A competition moves from Upcoming to History by itself once its date passes.
class CompetitionsScreen extends StatelessWidget {
  final String dogName;
  final String? sportId;
  const CompetitionsScreen({super.key, required this.dogName, this.sportId});

  void _add(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CompetitionFormScreen(dogName: dogName, sportId: sportId)),
      );

  void _open(BuildContext context, Competition c) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CompetitionDetailsScreen(dogName: dogName, competitionId: c.id)),
      );

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final all = store.competitions(dogName, sportId: sportId);
        final upcoming = all.where((c) => c.isUpcoming).toList()..sort((a, b) => a.date.compareTo(b.date));
        final history = all.where((c) => !c.isUpcoming).toList()..sort((a, b) => b.date.compareTo(a.date));
        return HealthScaffold(
          title: 'Competitions & Trials',
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
                        title: Text('Archived Competitions', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ArchivedCompetitionsScreen(dogName: dogName, sportId: sportId)),
                          );
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
          bottom: all.isEmpty ? null : PrimaryButton(label: 'Add Competition', icon: UlvenikIcons.add, onPressed: () => _add(context)),
          body: all.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.emoji_events_outlined,
                    title: 'No Competitions Yet',
                    message: 'Add your first competition to start building your dog’s competition history.',
                    actionLabel: 'Add Competition',
                    onAction: () => _add(context),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      const SectionLabel('Upcoming Competitions'),
                      for (final c in upcoming) _cardFor(context, c, () => _open(context, c)),
                      const SizedBox(height: 10),
                    ],
                    if (history.isNotEmpty) ...[
                      const SectionLabel('Competition History'),
                      for (final c in history) _cardFor(context, c, () => _open(context, c), history: true),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

class ArchivedCompetitionsScreen extends StatelessWidget {
  final String dogName;
  final String? sportId;
  const ArchivedCompetitionsScreen({super.key, required this.dogName, this.sportId});

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final list = store.competitions(dogName, sportId: sportId, archived: true)
          ..sort((a, b) => b.date.compareTo(a.date));
        return HealthScaffold(
          title: 'Archived Competitions',
          body: list.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Archived Competitions',
                    message: 'Competitions you archive will appear here.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final c in list)
                      _cardFor(
                        context,
                        c,
                        () {},
                        history: true,
                        trailing: TextButton(
                          onPressed: () {
                            c.archived = false;
                            store.touch();
                            AppSnackbar.show(context, message: 'Competition restored', type: SnackbarType.success);
                          },
                          child: Text('Restore',
                              style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class CompetitionDetailsScreen extends StatelessWidget {
  final String dogName;
  final String competitionId;
  const CompetitionDetailsScreen({super.key, required this.dogName, required this.competitionId});

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final c = store.competition(dogName, competitionId);
        if (c == null) return const HealthScaffold(title: 'Competition Details', body: SizedBox.shrink());

        Widget row(String k, String v) => v.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(k, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  const SizedBox(height: 3),
                  Text(v, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, height: 1.4)),
                ]),
              );

        return HealthScaffold(
          title: 'Competition Details',
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
                        title: Text('Edit Competition', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CompetitionFormScreen(dogName: dogName, competition: c)),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Archive Competition', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          c.archived = true;
                          store.touch();
                          AppSnackbar.show(context, message: 'Competition archived', type: SnackbarType.success);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                        title: const Text('Delete Competition', style: TextStyle(color: Color(0xFFFFB4AB))),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ok = await confirmDelete(context,
                              title: 'Delete competition?',
                              message: 'This competition and its results will be permanently deleted.');
                          if (!ok || !context.mounted) return;
                          MediaStore.instance.unlinkRecord(dogName, 'competition:${c.id}');
                          store.deleteCompetition(dogName, c.id);
                          AppSnackbar.show(context, message: 'Competition deleted', type: SnackbarType.success);
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
              Text(c.name,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
              if (c.needsReview) ...[
                const SizedBox(height: 14),
                HealthCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Did this competition take place?',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('The date has passed, but it is still marked Upcoming.',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, children: [
                      for (final st in const ['Completed', 'Withdrawn', 'Cancelled'])
                        ActionChip(
                          label: Text(st),
                          onPressed: () {
                            c.status = st;
                            c.reminder = null;
                            store.touch();
                          },
                          backgroundColor: AppColors.backgroundObsidian,
                          side: BorderSide(color: AppColors.cardBorder),
                          labelStyle: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
                        ),
                    ]),
                  ]),
                ),
              ],
              const SizedBox(height: 16),
              HealthCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  row('Status', c.needsReview ? 'Upcoming (date has passed)' : c.status),
                  row('Sport', c.sportName),
                  row('Date', fmtDate(c.date)),
                  row('Location', c.location),
                  row('Organisation / Club', c.organisation),
                  row('Competition Level / Class', c.level),
                  row('Result / Score', c.result),
                  row('Placement', c.placement),
                  row('Judge', c.judge),
                  for (final r in c.custom) row(r.label, r.value),
                  row('Notes', c.notes),
                  row('Photos, Videos & Documents', c.files.join(', ')),
                  if (c.reminder != null) row('Reminder', c.reminder!),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Add / Edit Competition. Name, sport and date are required; everything else
/// is optional and free-form (including any number of custom result fields).
class CompetitionFormScreen extends StatefulWidget {
  final String dogName;
  final String? sportId; // preselected, still changeable
  final Competition? competition;
  const CompetitionFormScreen({super.key, required this.dogName, this.sportId, this.competition});

  @override
  State<CompetitionFormScreen> createState() => _CompetitionFormScreenState();
}

class _CompetitionFormScreenState extends State<CompetitionFormScreen> {
  static const _timings = ['At Event Time', '1 Hour Before', '1 Day Before', 'Custom'];
  final _store = SportStore.instance;
  late final Competition? _c = widget.competition;
  late final _name = TextEditingController(text: _c?.name ?? '');
  late final _location = TextEditingController(text: _c?.location ?? '');
  late final _org = TextEditingController(text: _c?.organisation ?? '');
  late final _level = TextEditingController(text: _c?.level ?? '');
  late final _result = TextEditingController(text: _c?.result ?? '');
  late final _placement = TextEditingController(text: _c?.placement ?? '');
  late final _judge = TextEditingController(text: _c?.judge ?? '');
  late final _notes = TextEditingController(text: _c?.notes ?? '');
  late String? _sportId = _c?.sportId ?? widget.sportId;
  late DateTime? _date = _c?.date;
  late List<String> _files = [...?_c?.files];
  final Map<String, MediaFile> _pickedFiles = {};
  late bool _remind = _c?.reminder != null;
  late String _status = _c?.status ?? 'Upcoming';
  late String _timing = _c?.reminder == null
      ? _timings.first
      : (_timings.contains(_c!.reminder) ? _c.reminder! : 'Custom');
  late final List<({TextEditingController label, TextEditingController value})> _custom = [
    for (final r in _c?.custom ?? <CompetitionResult>[])
      (label: TextEditingController(text: r.label), value: TextEditingController(text: r.value)),
  ];
  String? _nameError;
  String? _sportError;
  String? _dateError;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _location, _org, _level, _result, _placement, _judge, _notes]) {
      c.dispose();
    }
    for (final r in _custom) {
      r.label.dispose();
      r.value.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    setState(() {
      _nameError = _name.text.trim().isEmpty ? 'Please enter a competition name.' : null;
      _sportError = _sportId == null ? 'Please choose a sport.' : null;
      _dateError = _date == null ? 'Please choose a date.' : null;
    });
    if (_nameError != null || _sportError != null || _dateError != null) return;
    _saving = true;
    final sport = _store.sport(widget.dogName, _sportId!);
    final c = _c ??
        Competition(id: _store.newId(), name: '', sportId: _sportId!, sportName: sport?.name ?? '', date: _date!);
    c
      ..name = _name.text.trim()
      ..sportId = _sportId!
      ..sportName = sport?.name ?? c.sportName
      ..date = _date!
      ..location = _location.text.trim()
      ..organisation = _org.text.trim()
      ..level = _level.text.trim()
      ..result = _result.text.trim()
      ..placement = _placement.text.trim()
      ..judge = _judge.text.trim()
      ..notes = _notes.text.trim()
      ..files = _files
      ..custom = [
        for (final r in _custom)
          if (r.label.text.trim().isNotEmpty || r.value.text.trim().isNotEmpty)
            CompetitionResult(r.label.text.trim(), r.value.text.trim()),
      ]
      ..status = _status
      ..reminder = (_remind && _status == 'Upcoming' && !_date!.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) ? _timing : null;
    _store.saveCompetition(widget.dogName, c);
    MediaStore.instance.attach(widget.dogName,
        [for (final n in _files) if (_pickedFiles[n] != null) _pickedFiles[n]!], MediaLinks.competition(widget.dogName, c.id),
        mediaDate: c.date.isAfter(DateTime.now()) ? DateTime.now() : c.date);
    AppSnackbar.show(context, message: 'Competition saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  Future<void> _addFiles() async {
    final r = await pickMediaFiles();
    if (r.isEmpty) return;
    setState(() {
      for (final f in r) {
        _pickedFiles[f.name] = f;
      }
      _files = {..._files, ...r.map((f) => f.name)}.toList();
    });
  }

  Widget _field(TextEditingController c, String label, String hint, {int lines = 1, String? error, bool required = false, bool showLabel = true}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (showLabel) FieldLabel(label, required: required),
        TextField(
          controller: c,
          minLines: lines,
          maxLines: lines == 1 ? 1 : lines + 2,
          onChanged: (_) => error == null ? null : setState(() {
            _nameError = null;
          }),
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
          decoration: healthDecoration(hint, error: error),
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    final sports = _store.sports(widget.dogName);
    final upcoming = _status == 'Upcoming' && _date != null && !_date!.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    return HealthScaffold(
      title: _c == null ? 'Add Competition' : 'Edit Competition',
      bottom: PrimaryButton(label: 'Save Competition', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _field(_name, 'Competition Name', 'Enter competition name', error: _nameError, required: true),
          const FieldLabel('Sport', required: true),
          if (sports.isEmpty)
            OutlinedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SportFormScreen(dogName: widget.dogName))),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 46)),
              child: const Text('Add Sport'),
            )
          else
            ChoiceRow(
              options: [for (final s in sports) s.name],
              value: sports.where((s) => s.id == _sportId).map((s) => s.name).firstOrNull,
              onChanged: (n) => setState(() {
                _sportId = sports.firstWhere((s) => s.name == n).id;
                _sportError = null;
              }),
            ),
          if (_sportError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(_sportError!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
            ),
          const FieldLabel('Competition Date', required: true),
          DateField(
            value: _date,
            error: _dateError,
            onChanged: (d) => setState(() {
              _date = d;
              _dateError = null;
            }),
          ),
          const FieldLabel('Status'),
          ChoiceRow(
            options: const ['Upcoming', 'Completed', 'Withdrawn', 'Cancelled'],
            value: _status,
            onChanged: (v) => setState(() {
              _status = v;
              if (v != 'Upcoming') _remind = false;
            }),
          ),
          if (_status != 'Upcoming')
            Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Reminders are only kept for upcoming competitions.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ),
          _field(_location, 'Location', 'Add location'),
          _field(_org, 'Organisation / Club', 'Add organisation or club'),
          _field(_level, 'Competition Level / Class', 'e.g. Grade 3'),
          _field(_result, 'Result / Score', 'Add result or score'),
          _field(_placement, 'Placement', 'e.g. 2nd'),
          _field(_judge, 'Judge', 'Add judge'),
          const SizedBox(height: 22),
          const SectionLabel('Custom Results'),
          for (var i = 0; i < _custom.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: TextField(
                    controller: _custom[i].label,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                    decoration: healthDecoration('Label'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _custom[i].value,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                    decoration: healthDecoration('Result'),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: Icon(Icons.close, size: 20, color: AppColors.secondaryTextStoneGrey),
                  onPressed: () => setState(() {
                    final r = _custom.removeAt(i);
                    r.label.dispose();
                    r.value.dispose();
                  }),
                ),
              ]),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _custom.add((label: TextEditingController(), value: TextEditingController()))),
              icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
              label: const Text('Add Result Field'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 44)),
            ),
          ),
          _field(_notes, 'Notes', 'Add notes...', lines: 3),
          const FieldLabel('Photos, Videos & Documents'),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _addFiles,
              icon: const Icon(Icons.attach_file, size: 18),
              label: const Text('Add File'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 44)),
            ),
          ),
          if (_files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 8, runSpacing: 6, children: [
                for (final n in _files)
                  InputChip(
                    label: Text(n, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.cardsCarbon,
                    side: BorderSide(color: AppColors.cardBorder),
                    deleteIconColor: AppColors.secondaryTextStoneGrey,
                    onDeleted: () => setState(() => _files = [..._files]..remove(n)),
                  ),
              ]),
            ),
          if (upcoming) ...[
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primaryForestGreen,
              title: Text('Reminder', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
              subtitle: Text('Device alerts need notification permission and are optional.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              value: _remind,
              onChanged: (v) => setState(() => _remind = v),
            ),
            if (_remind) ChoiceRow(options: _timings, value: _timing, onChanged: (v) => setState(() => _timing = v)),
          ],
        ],
      ),
    );
  }
}
