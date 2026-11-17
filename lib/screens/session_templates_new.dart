import 'package:flutter/material.dart';
import '../data/persist.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/session_items_picker.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_record_session_screen.dart';
import 'timeline_export_util.dart';
import 'training_screen.dart';
import 'training_session_screen.dart';

/// A reusable S&C session plan. It holds structure only — never a date,
/// result, rating or private note from an earlier session.
class SessionTemplate {
  final String id;
  final String dog;
  String name;
  String type; // 'S&C' | 'Training'
  List<String> activityIds; // S&C: activity ids; Training: skill names
  int? targetMinutes;
  List<String> equipment;
  List<String> rewards;
  String plan;
  bool favourite;
  bool archived;
  int uses; // distinct saved sessions started from this template
  DateTime? lastUsed;
  SessionTemplate({
    required this.id,
    required this.dog,
    required this.name,
    this.type = 'S&C',
    List<String>? activityIds,
    this.targetMinutes,
    List<String>? equipment,
    List<String>? rewards,
    this.plan = '',
    this.favourite = false,
    this.archived = false,
    this.uses = 0,
    this.lastUsed,
  })  : activityIds = activityIds ?? [],
        equipment = equipment ?? [],
        rewards = rewards ?? [];

  Map<String, dynamic> toJson() => {
        'id': id, 'dog': dog, 'name': name, 'type': type, 'activityIds': activityIds, 'target': targetMinutes, 'equipment': equipment,
        'rewards': rewards, 'plan': plan, 'favourite': favourite, 'archived': archived, 'uses': uses,
        'lastUsed': lastUsed?.toIso8601String(),
      };
  factory SessionTemplate.fromJson(Map m) => SessionTemplate(
        id: m['id'], dog: m['dog'], name: m['name'], type: m['type'] ?? 'S&C',
        activityIds: [for (final x in (m['activityIds'] as List? ?? [])) '$x'],
        targetMinutes: m['target'],
        equipment: [for (final x in (m['equipment'] as List? ?? [])) '$x'],
        rewards: [for (final x in (m['rewards'] as List? ?? [])) '$x'],
        plan: m['plan'] ?? '', favourite: m['favourite'] ?? false, archived: m['archived'] ?? false,
        uses: m['uses'] ?? 0, lastUsed: DateTime.tryParse('${m['lastUsed'] ?? ''}'),
      );
}

class TemplateStore extends ChangeNotifier {
  TemplateStore._();
  static final TemplateStore instance = TemplateStore._();
  final List<SessionTemplate> _items = [];
  int _seq = 0;
  String newId() => 'tpl${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  List<SessionTemplate> all(String dog, {bool archived = false}) =>
      _items.where((t) => t.dog == dog && t.archived == archived).toList();
  SessionTemplate? byId(String id) => _items.where((t) => t.id == id).firstOrNull;
  bool nameTaken(String dog, String name, {String? exceptId}) =>
      _items.any((t) => t.dog == dog && t.id != exceptId && t.name.toLowerCase() == name.toLowerCase());

  Future<void> load() async {
    final j = await Persist.read('store.templates');
    if (j is! List) return;
    _items
      ..clear()
      ..addAll([for (final m in j.cast<Map>()) SessionTemplate.fromJson(m)]);
    notifyListeners();
  }

  void save(SessionTemplate t) {
    if (!_items.any((x) => x.id == t.id)) _items.add(t);
    _persist();
    notifyListeners();
  }

  void touch() {
    _persist();
    notifyListeners();
  }

  /// Times used: S&C templates count saved S&C sessions started from them;
  /// Training templates count completed Training sessions carrying their tag.
  int usesOf(SessionTemplate t) {
    if (t.type != 'Training') return t.uses;
    return TrainingSessionStore.sessionsNotifier.value
        .where((s) => s.status == SessionStatus.completed && s.sessionTags.contains('tpl:${t.id}'))
        .length;
  }

  /// Called once when a session started from a template is actually saved.
  void markUsed(String id) {
    final t = byId(id);
    if (t == null) return;
    t.uses += 1;
    t.lastUsed = DateTime.now();
    touch();
  }

  void _persist() => Persist.write('store.templates', [for (final t in _items) t.toJson()]);
}

String _activityNames(String dog, SessionTemplate t) {
  if (t.type == 'Training') return t.activityIds.isEmpty ? 'No skills' : t.activityIds.join(', ');
  final names = [for (final id in t.activityIds) SCStore.instance.activity(dog, id)?.name].whereType<String>();
  return names.isEmpty ? 'No activities' : names.join(', ');
}

/// Session Templates for one dog: only templates the user saved.
class SessionTemplatesScreen extends StatefulWidget {
  final String dogName;
  const SessionTemplatesScreen({super.key, required this.dogName});

  @override
  State<SessionTemplatesScreen> createState() => _SessionTemplatesScreenState();
}

class _SessionTemplatesScreenState extends State<SessionTemplatesScreen> {
  final _store = TemplateStore.instance;
  final _search = TextEditingController();
  String _sort = 'Recently Used';
  String? _activity; // filter: activity id
  bool _favOnly = false;

  @override
  void initState() {
    super.initState();
    _store.addListener(_r);
    _search.addListener(_r);
  }

  @override
  void dispose() {
    _store.removeListener(_r);
    _search.dispose();
    super.dispose();
  }

  void _r() {
    if (mounted) setState(() {});
  }

  String get dog => widget.dogName;

  Future<void> _filters() async {
    String? act = _activity;
    bool fav = _favOnly;
    final acts = SCStore.instance.activities(dog);
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Filter templates', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SectionLabel('Activity'),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ChoiceChip(label: const Text('All Activities'), selected: act == null, onSelected: (_) => setSheet(() => act = null), showCheckmark: false, backgroundColor: AppColors.backgroundObsidian, selectedColor: AppColors.primaryForestGreen),
                for (final a in acts)
                  ChoiceChip(label: Text(a.name), selected: act == a.id, onSelected: (_) => setSheet(() => act = a.id), showCheckmark: false, backgroundColor: AppColors.backgroundObsidian, selectedColor: AppColors.primaryForestGreen),
              ]),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primaryForestGreen,
                title: Text('Favourites only', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                value: fav,
                onChanged: (v) => setSheet(() => fav = v),
              ),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setSheet(() {
                      act = null;
                      fav = false;
                    }),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite, side: BorderSide(color: AppColors.cardBorder), minimumSize: const Size(0, 50)),
                    child: const Text('Reset Filters'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: PrimaryButton(label: 'Apply Filters', onPressed: () => Navigator.pop(ctx, true))),
              ]),
            ]),
          ),
        ),
      ),
    );
    if (ok == true) setState(() {
      _activity = act;
      _favOnly = fav;
    });
  }

  Future<void> _sortSheet() async {
    final v = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final o in const ['Recently Used', 'Most Used', 'Alphabetical (A-Z)', 'Favourites First'])
            ListTile(
              title: Text(o, style: TextStyle(color: AppColors.primaryTextOffWhite)),
              trailing: o == _sort ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
              onTap: () => Navigator.pop(ctx, o),
            ),
        ]),
      ),
    );
    if (v != null) setState(() => _sort = v);
  }

  void _review(SessionTemplate t) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('${t.type} session', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              const SizedBox(height: 12),
              for (final r in [
                ('Activities', _activityNames(dog, t)),
                if (t.targetMinutes != null) ('Target duration', '${t.targetMinutes} min'),
                ('Times used', '${_store.usesOf(t)}'),
                if (t.equipment.isNotEmpty) ('Equipment', t.equipment.join(', ')),
                if (t.rewards.isNotEmpty) ('Rewards', t.rewards.join(', ')),
                if (t.plan.isNotEmpty) ('Session plan', t.plan),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.$1, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    Text(r.$2, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
                  ]),
                ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TemplateFormScreen(dogName: dog, template: t)));
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite, side: BorderSide(color: AppColors.cardBorder), minimumSize: const Size(0, 50)),
                    child: const Text('Edit Template'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    label: 'Use Template',
                    onPressed: () {
                      Navigator.pop(ctx);
                      if (t.type == 'Training') {
                        // A fresh draft: plan and targets stay planned, results are entered by you.
                        final now = DateTime.now();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrainingSessionScreen(
                              session: TrainingSession(
                                id: 'session_${now.microsecondsSinceEpoch}',
                                dogName: dog,
                                dogInitial: dog.isEmpty ? '?' : dog[0].toUpperCase(),
                                title: defaultTrainingSessionTitle(now),
                                dateLabel: 'Today · Draft',
                                date: now,
                                startTime: TimeOfDay.now(),
                                status: SessionStatus.draft,
                                recordedSkills: [
                                  for (var i = 0; i < t.activityIds.length; i++)
                                    RecordedSkillEntry(id: 'tplskill_${now.microsecondsSinceEpoch}_$i', skillName: t.activityIds[i]),
                                ],
                                equipment: t.equipment,
                                rewards: t.rewards,
                                sessionTags: ['tpl:${t.id}'],
                                dogColor: AppColors.secondarySage,
                              ),
                              isNewSession: true,
                            ),
                          ),
                        );
                        return;
                      }
                      // Opening or cancelling never counts as a use: only a saved session does.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SCRecordSessionScreen(
                            dogName: dog,
                            presetActivityIds: t.activityIds,
                            presetRewards: t.rewards,
                            presetEquipment: t.equipment,
                            templateId: t.id,
                            planNote: t.plan,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final all = _store.all(dog);
    final q = _search.text.trim().toLowerCase();
    final list = all.where((t) {
      if (_favOnly && !t.favourite) return false;
      if (_activity != null && !t.activityIds.contains(_activity)) return false;
      if (q.isEmpty) return true;
      return t.name.toLowerCase().contains(q) || _activityNames(dog, t).toLowerCase().contains(q);
    }).toList();
    int byName(SessionTemplate a, SessionTemplate b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
    switch (_sort) {
      case 'Most Used':
        list.sort((a, b) => _store.usesOf(b) != _store.usesOf(a) ? _store.usesOf(b).compareTo(_store.usesOf(a)) : byName(a, b));
      case 'Alphabetical (A-Z)':
        list.sort(byName);
      case 'Favourites First':
        list.sort((a, b) => a.favourite != b.favourite ? (a.favourite ? -1 : 1) : byName(a, b));
      default:
        list.sort((a, b) {
          final x = a.lastUsed, y = b.lastUsed;
          if (x == null && y == null) return byName(a, b);
          if (x == null) return 1;
          if (y == null) return -1;
          return y.compareTo(x);
        });
    }
    return HealthScaffold(
      title: 'Session Templates',
      actions: [
        IconButton(
          tooltip: 'Add Template',
          icon: UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryForestGreen),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TemplateFormScreen(dogName: dog))),
        ),
        IconButton(
          tooltip: 'More',
          icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            backgroundColor: AppColors.cardsCarbon,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (ctx) => SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                  title: Text('Export Templates', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _export(list.isEmpty ? all : list);
                  },
                ),
                ListTile(
                  title: Text('Archived Templates', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LibraryArchiveScreen(dogName: dog, initialView: 'Session Templates')));
                  },
                ),
              ]),
            ),
          ),
        ),
      ],
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.copy_all_outlined,
                title: 'No Templates Yet',
                message: 'Save a session plan to reuse it for future S&C sessions.',
                actionLabel: 'Add Template',
                onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TemplateFormScreen(dogName: dog))),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                TextField(
                  controller: _search,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                  decoration: healthDecoration('Search templates...'),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _sortSheet,
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite, side: BorderSide(color: AppColors.cardBorder), backgroundColor: AppColors.cardsCarbon, minimumSize: const Size(0, 44)),
                      child: Text(_sort, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _filters,
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryTextOffWhite,
                          side: BorderSide(color: (_activity != null || _favOnly) ? AppColors.primaryForestGreen : Colors.white12),
                          backgroundColor: AppColors.cardsCarbon,
                          minimumSize: const Size(0, 44)),
                      child: const Text('Filters'),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(children: [
                      Text('No Matching Templates', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('Try another search term or clear your search.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                      TextButton(
                        onPressed: _search.clear,
                        child: Text('Clear Search', style: TextStyle(color: AppColors.primaryForestGreen)),
                      ),
                    ]),
                  ),
                for (final t in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HealthCard(
                      onTap: () => _review(t),
                      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t.name, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15.5, fontWeight: FontWeight.w600)),
                            Text('${t.type} · ${_activityNames(dog, t)}', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                            if (t.targetMinutes != null) Text('Target ${t.targetMinutes} min', style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5)),
                          ]),
                        ),
                        IconButton(
                          tooltip: t.favourite ? 'Remove from Favourites' : 'Add to Favourites',
                          icon: Icon(t.favourite ? Icons.favorite : Icons.favorite_border, size: 22, color: t.favourite ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey),
                          onPressed: () {
                            t.favourite = !t.favourite;
                            _store.touch();
                          },
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _export(List<SessionTemplate> list) async {
    final rows = <List<String>>[
      ['Name', 'Type', 'Activities', 'Target Minutes', 'Equipment', 'Rewards', 'Times Used'],
      for (final t in list) [t.name, t.type, _activityNames(dog, t), '${t.targetMinutes ?? ''}', t.equipment.join('; '), t.rewards.join('; '), '${_store.usesOf(t)}'],
    ];
    final pdf = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text('PDF Document', style: TextStyle(color: AppColors.primaryTextOffWhite)), onTap: () => Navigator.pop(ctx, true)),
          ListTile(title: Text('CSV Spreadsheet', style: TextStyle(color: AppColors.primaryTextOffWhite)), onTap: () => Navigator.pop(ctx, false)),
        ]),
      ),
    );
    if (pdf == null || !mounted) return;
    await runExport(
      context,
      fileName: 'Ulvenik_Templates_${exportStamp()}.${pdf ? 'pdf' : 'csv'}',
      pdf: pdf,
      build: () async => pdf ? await tablePdf('Session Templates', ['${list.length} templates'], rows) : tableCsv(rows),
    );
  }
}

/// Create or edit a template. The name is required and may not silently
/// overwrite another template.
class TemplateFormScreen extends StatefulWidget {
  final String dogName;
  final SessionTemplate? template;
  final List<String>? presetActivityIds;
  final List<String>? presetRewards;
  final List<String>? presetEquipment;
  final String? presetName;
  const TemplateFormScreen({
    super.key,
    required this.dogName,
    this.template,
    this.presetActivityIds,
    this.presetRewards,
    this.presetEquipment,
    this.presetName,
  });

  @override
  State<TemplateFormScreen> createState() => _TemplateFormScreenState();
}

class _TemplateFormScreenState extends State<TemplateFormScreen> {
  final _store = TemplateStore.instance;
  late final _name = TextEditingController(text: widget.template?.name ?? widget.presetName ?? '');
  late final _target = TextEditingController(text: widget.template?.targetMinutes?.toString() ?? '');
  late final _plan = TextEditingController(text: widget.template?.plan ?? '');
  late String _type = widget.template?.type ?? 'S&C';
  late Set<String> _acts = {...?widget.template?.activityIds, ...?widget.presetActivityIds};
  late List<String> _equipment = [...?widget.template?.equipment, ...?widget.presetEquipment];
  late List<String> _rewards = [...?widget.template?.rewards, ...?widget.presetRewards];
  late bool _fav = widget.template?.favourite ?? false;
  String? _nameError;
  String? _targetError;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _plan.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final t = _target.text.trim();
    setState(() {
      _nameError = name.isEmpty
          ? 'Enter a template name.'
          : _store.nameTaken(widget.dogName, name, exceptId: widget.template?.id)
              ? 'A template with this name already exists.'
              : null;
      _targetError = t.isNotEmpty && (int.tryParse(t) == null || int.parse(t) <= 0) ? 'Enter a positive number of minutes.' : null;
    });
    if (_nameError != null || _targetError != null) return;
    final tpl = widget.template ?? SessionTemplate(id: _store.newId(), dog: widget.dogName, name: name);
    tpl
      ..name = name
      ..type = _type
      ..activityIds = _acts.toList()
      ..targetMinutes = t.isEmpty ? null : int.parse(t)
      ..equipment = _equipment
      ..rewards = _rewards
      ..plan = _plan.text.trim()
      ..favourite = _fav;
    _store.save(tpl);
    AppSnackbar.show(context, message: 'Template saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final acts = SCStore.instance.activities(widget.dogName);
    final skills = [for (final e in TrainingSessionStore.skillCatalogNotifier.value) e.skillName];
    return HealthScaffold(
      title: widget.template == null ? 'Create Template' : 'Edit Template',
      actions: widget.template == null
          ? null
          : [
              IconButton(
                tooltip: 'Archive Template',
                icon: Icon(Icons.inventory_2_outlined, color: AppColors.secondaryTextStoneGrey),
                onPressed: () {
                  widget.template!.archived = true;
                  _store.touch();
                  Navigator.pop(context);
                },
              ),
            ],
      bottom: Row(children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite, side: BorderSide(color: AppColors.cardBorder), minimumSize: const Size(0, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: PrimaryButton(label: widget.template == null ? 'Save Template' : 'Save Changes', icon: UlvenikIcons.save, onPressed: _save)),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Template name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => setState(() => _nameError = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. Recall practice', error: _nameError),
          ),
          const FieldLabel('Type', required: true),
          ChoiceRow(
            options: const ['S&C', 'Training'],
            value: _type,
            onChanged: widget.template != null
                ? (_) {}
                : (v) => setState(() {
                      if (v != _type) _acts = {}; // sources differ by type; nothing carries over silently
                      _type = v;
                    }),
          ),
          FieldLabel(_type == 'Training' ? 'Skills' : 'Activities'),
          if (_type == 'Training')
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final n in skills)
                FilterChip(
                  label: Text(n),
                  selected: _acts.contains(n),
                  onSelected: (v) => setState(() => v ? _acts.add(n) : _acts.remove(n)),
                  showCheckmark: false,
                  backgroundColor: AppColors.cardsCarbon,
                  selectedColor: AppColors.primaryForestGreen,
                  side: BorderSide(color: AppColors.cardBorder),
                  labelStyle: TextStyle(color: _acts.contains(n) ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey, fontSize: 13),
                ),
            ])
          else if (acts.isEmpty)
            Text('No Activities Added Yet. Add an activity to your library to use it in a template.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4))
          else
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final a in acts)
                FilterChip(
                  label: Text(a.name),
                  selected: _acts.contains(a.id),
                  onSelected: (v) => setState(() => v ? _acts.add(a.id) : _acts.remove(a.id)),
                  showCheckmark: false,
                  backgroundColor: AppColors.cardsCarbon,
                  selectedColor: AppColors.primaryForestGreen,
                  side: BorderSide(color: AppColors.cardBorder),
                  labelStyle: TextStyle(color: _acts.contains(a.id) ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey, fontSize: 13),
                ),
            ]),
          const FieldLabel('Target duration (minutes)'),
          TextField(
            controller: _target,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _targetError = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter minutes', error: _targetError),
          ),
          const SizedBox(height: 18),
          SessionItemsField(kind: SessionItemKind.equipment, selected: _equipment, onChanged: (v) => setState(() => _equipment = v)),
          const SizedBox(height: 10),
          SessionItemsField(kind: SessionItemKind.rewards, selected: _rewards, onChanged: (v) => setState(() => _rewards = v)),
          const FieldLabel('Session plan'),
          TextField(
            controller: _plan,
            minLines: 3,
            maxLines: 6,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add instructions for using this template...'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primaryForestGreen,
            title: Text('Favourite template', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            value: _fav,
            onChanged: (v) => setState(() => _fav = v),
          ),
        ],
      ),
    );
  }
}

/// Library Archive: archived activities and templates, hidden from new
/// selections. Restoring puts the same item back; past sessions are untouched.
class LibraryArchiveScreen extends StatefulWidget {
  final String dogName;
  final String initialView; // Activities | Session Templates
  const LibraryArchiveScreen({super.key, required this.dogName, this.initialView = 'Activities'});

  @override
  State<LibraryArchiveScreen> createState() => _LibraryArchiveScreenState();
}

class _LibraryArchiveScreenState extends State<LibraryArchiveScreen> {
  late String _view = widget.initialView;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final acts = SCStore.instance;
    final tpls = TemplateStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([acts, tpls]),
      builder: (context, _) {
        final items = _view == 'Activities'
            ? [for (final a in acts.activities(widget.dogName, archived: true)) (a.name, 'Activity', () => acts.setArchived(widget.dogName, a.id, false))]
            : [for (final t in tpls.all(widget.dogName, archived: true)) (t.name, 'Session template', () {
                  t.archived = false;
                  tpls.touch();
                })];
        final shown = items.where((e) => q.isEmpty || e.$1.toLowerCase().contains(q)).toList();
        return HealthScaffold(
          title: 'Library Archive',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              ChoiceRow(options: const ['Activities', 'Session Templates'], value: _view, onChanged: (v) => setState(() => _view = v)),
              const SizedBox(height: 8),
              Text('Archived activities and templates are hidden from new selections. Existing session records remain unchanged.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4)),
              const SizedBox(height: 12),
              TextField(controller: _search, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5), decoration: healthDecoration('Search archived items...')),
              const SizedBox(height: 12),
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: _view == 'Activities' ? 'No Archived Activities' : 'No Archived Templates',
                  message: _view == 'Activities' ? 'Activities you archive will appear here.' : 'Templates you archive will appear here.',
                )
              else if (shown.isEmpty)
                Text('Nothing matches your search.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              for (final e in shown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HealthCard(
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.$1, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                          Text(e.$2, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        ]),
                      ),
                      TextButton(
                        onPressed: e.$3,
                        child: Text('Restore', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
