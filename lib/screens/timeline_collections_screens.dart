import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'timeline_common.dart';

/// One row in the overview: either a built-in rule or a saved definition.
class _Def {
  final String key; // 'b:<name>' or 'c:<id>'
  final String name;
  final String group;
  final String rule;
  final bool Function(TimelineEvent e) test;
  final SmartCollection? custom;
  final bool pinned;
  _Def(this.key, this.name, this.group, this.rule, this.test, {this.custom, this.pinned = false});
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

List<_Def> _definitions(TimelineStore st) {
  final now = DateTime.now();
  final today = _day(now);
  final weekStart = today.subtract(Duration(days: today.weekday - 1));
  bool hasMedia(TimelineEvent e, bool Function(MediaItem i) f) =>
      e.linkKey.isNotEmpty &&
      MediaStore.instance.items(e.dog).any((i) => i.links.any((l) => l.key == e.linkKey) && f(i));

  _Def b(String name, String group, String rule, bool Function(TimelineEvent) t) =>
      _Def('b:$name', name, group, rule, t, pinned: st.isBuiltInPinned('b:$name'));

  return [
    for (final c in st.collections())
      _Def('c:${c.id}', c.name, 'My Collections', c.rule, (e) => st.matches(c, e), custom: c, pinned: c.pinned),
    b('This Week', 'By Date', 'Records dated this week', (e) => !e.at.isBefore(weekStart) && e.at.isBefore(weekStart.add(const Duration(days: 7)))),
    b('This Month', 'By Date', 'Records dated this month and year', (e) => e.at.year == now.year && e.at.month == now.month),
    b('Last Month', 'By Date', 'Records dated last month', (e) {
      final lm = DateTime(now.year, now.month - 1);
      return e.at.year == lm.year && e.at.month == lm.month;
    }),
    b('This Year', 'By Date', 'Records dated this year', (e) => e.at.year == now.year),
    b('Events with Photos', 'With Attachments', 'Records with at least one photo', (e) => hasMedia(e, (i) => i.type == MediaType.photo)),
    b('Events with Videos', 'With Attachments', 'Records with at least one video', (e) => hasMedia(e, (i) => i.type == MediaType.video)),
    b('Events with Documents', 'With Attachments', 'Records with at least one document', (e) => hasMedia(e, (i) => i.type == MediaType.document)),
    b('Training Records', 'By Record Type', 'Training sessions', (e) => e.category == 'Training'),
    b('S&C Records', 'By Record Type', 'S&C sessions', (e) => e.category == 'S&C'),
    b('Sport Records', 'By Record Type', 'Sport sessions and competitions', (e) => e.category == 'Sport'),
    b('Milestones', 'By Record Type', 'Manual milestones', (e) => e.category == 'Milestones'),
    b('Health Records', 'Health', 'All Health records', (e) => e.category == 'Health'),
    b('Weight Records', 'Health', 'Saved weights', (e) => e.typeLabel == 'Weight'),
    b('Vet Visit Records', 'Health', 'Saved vet visit records', (e) => e.typeLabel == 'Vet Visit'),
  ];
}

const _groups = ['My Collections', 'By Date', 'With Attachments', 'By Record Type', 'Health'];

/// Smart Collections: reusable filters that return Timeline records. These are
/// not Media Library collections and never copy or move anything.
class TimelineSmartCollectionsScreen extends StatefulWidget {
  final String initialDog;
  const TimelineSmartCollectionsScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineSmartCollectionsScreen> createState() => _TimelineSmartCollectionsScreenState();
}

class _TimelineSmartCollectionsScreenState extends State<TimelineSmartCollectionsScreen> {
  final _store = TimelineStore.instance;
  final _search = TextEditingController();
  late String _dog = widget.initialDog;
  String _sort = 'Grouped';
  String _type = 'All Collections';

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

  void _open(_Def d) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SmartCollectionDetailScreen(defKey: d.key, dog: _dog)),
      );

  Future<void> _pick(String title, List<String> options, String current, ValueChanged<String> set) async {
    final v = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            for (final o in options)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(o, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                trailing: o == current ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () => Navigator.pop(ctx, o),
              ),
          ]),
        ),
      ),
    );
    if (v != null) setState(() => set(v));
  }

  @override
  Widget build(BuildContext context) {
    final events = _store.events(dog: dogScope(_dog));
    final defs = _definitions(_store);
    int count(_Def d) => events.where(d.test).length;
    final q = _search.text.trim().toLowerCase();
    var list = defs.where((d) {
      if (q.isNotEmpty && !d.name.toLowerCase().contains(q)) return false;
      return switch (_type) {
        'All Collections' => true,
        'My Collections' => d.group == 'My Collections',
        'By Date' => d.group == 'By Date',
        'With Attachments' => d.group == 'With Attachments',
        'Training' => d.name == 'Training Records',
        'S&C' => d.name == 'S&C Records',
        'Health' => d.group == 'Health',
        _ => true,
      };
    }).toList();
    final counts = {for (final d in list) d.key: count(d)};
    final grouped = _sort == 'Grouped';
    if (_sort == 'Most Events') {
      list.sort((a, b) {
        final c = counts[b.key]!.compareTo(counts[a.key]!);
        return c != 0 ? c : a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (_sort == 'Pinned First') {
      list.sort((a, b) {
        if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    }
    final noHistory = _store.events(dog: dogScope(_dog)).isEmpty && _store.collections().isEmpty;

    Widget row(_Def d) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: HealthCard(
            onTap: () => _open(d),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              Icon(d.group == 'My Collections' ? Icons.folder_special_outlined : Icons.filter_list, size: 20, color: AppColors.secondarySage),
              const SizedBox(width: 12),
              Expanded(
                child: Row(children: [
                  Flexible(
                    child: Text(d.name, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
                  ),
                  if (d.pinned)
                    Padding(padding: EdgeInsets.only(left: 6), child: Icon(Icons.push_pin_outlined, size: 15, color: AppColors.primaryForestGreen)),
                ]),
              ),
              Text('${counts[d.key]}', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
              const SizedBox(width: 6),
              UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
            ]),
          ),
        );

    return HealthScaffold(
      title: 'Smart Collections',
      actions: [
        IconButton(
          tooltip: 'More',
          icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            backgroundColor: AppColors.cardsCarbon,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (ctx) => SafeArea(
              child: ListTile(
                title: Text('Archived Collections', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ArchivedCollectionsScreen()));
                },
              ),
            ),
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog);
              if (d != null) setState(() => _dog = d);
            },
          ),
          const SizedBox(height: 6),
          Text('Find groups of records using saved filters.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
          const SizedBox(height: 12),
          if (noHistory)
            EmptyState(
              icon: Icons.folder_outlined,
              title: 'No Records to Group Yet',
              message:
                  'Collections help you find groups of Timeline records. Add your dog’s first record, or create a collection to automatically include future matches.',
              actionLabel: 'Create Collection',
              onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateCollectionScreen(dog: _dog))),
            )
          else ...[
            searchField(_search, 'Search collections...'),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pick('Sort Collections', const ['Grouped', 'Most Events', 'Pinned First'], _sort, (v) => _sort = v),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: BorderSide(color: AppColors.cardBorder),
                      backgroundColor: AppColors.cardsCarbon,
                      minimumSize: const Size(0, 44)),
                  child: Text(_sort, overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pick('Collection Type',
                      const ['All Collections', 'My Collections', 'By Date', 'With Attachments', 'Training', 'S&C', 'Health'], _type, (v) => _type = v),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: BorderSide(color: AppColors.cardBorder),
                      backgroundColor: AppColors.cardsCarbon,
                      minimumSize: const Size(0, 44)),
                  child: Text(_type, overflow: TextOverflow.ellipsis),
                ),
              ),
            ]),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateCollectionScreen(dog: _dog))),
                icon: UlvenikIcon(UlvenikIcons.add, size: 16, color: AppColors.primaryForestGreen),
                label: Text('Create Collection', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
              ),
            ),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(children: [
                  Text('No Matching Collections',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('Try another search or collection type.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                  TextButton(
                    onPressed: () {
                      _search.clear();
                      setState(() => _type = 'All Collections');
                    },
                    child: Text('Clear Search and Filters', style: TextStyle(color: AppColors.primaryForestGreen)),
                  ),
                ]),
              )
            else if (grouped)
              for (final g in _groups)
                if (list.any((d) => d.group == g)) ...[
                  SectionLabel(g),
                  for (final d in list.where((d) => d.group == g)) row(d),
                  if (g == 'My Collections' && !list.any((d) => d.group == g)) const SizedBox.shrink(),
                ]
            else
              for (final d in list) row(d),
            if (grouped && !defs.any((d) => d.group == 'My Collections') && _type == 'All Collections' && q.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('No Custom Collections Yet. Create one to group records your own way.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              ),
          ],
        ],
      ),
    );
  }
}

/// A collection's rule and the records that match it, newest first.
class SmartCollectionDetailScreen extends StatelessWidget {
  final String defKey;
  final String dog;
  const SmartCollectionDetailScreen({super.key, required this.defKey, required this.dog});

  @override
  Widget build(BuildContext context) {
    final st = TimelineStore.instance;
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        final d = _definitions(st).where((x) => x.key == defKey).firstOrNull;
        if (d == null) {
          return const HealthScaffold(title: 'Collection', body: Center(child: Text('This collection is no longer available.')));
        }
        final matches = st.events(dog: dogScope(dog)).where(d.test).toList()..sort((a, b) => b.at.compareTo(a.at));
        return HealthScaffold(
          title: d.name,
          actions: [
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
                      title: Text(d.pinned ? 'Unpin Collection' : 'Pin Collection', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                      onTap: () {
                        Navigator.pop(ctx);
                        if (d.custom != null) {
                          d.custom!.pinned = !d.custom!.pinned;
                          st.saveCollection(d.custom!);
                        } else {
                          st.toggleBuiltInPin(d.key);
                        }
                      },
                    ),
                    if (d.custom != null)
                      ListTile(
                        title: Text('Archive Collection', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          d.custom!
                            ..archived = true
                            ..pinned = false;
                          st.saveCollection(d.custom!);
                          Navigator.pop(context);
                        },
                      ),
                  ]),
                ),
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              HealthCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${matches.length} matching ${matches.length == 1 ? 'record' : 'records'}',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(d.rule, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                  Text(dog == kAllDogs ? 'All Dogs' : dog, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                ]),
              ),
              const SectionLabel('Matching Records'),
              if (matches.isEmpty)
                Text('No Matching Records', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              for (final e in matches) TimelineEventCard(event: e, showDog: dog == kAllDogs, onTap: () => openEvent(context, e)),
            ],
          ),
        );
      },
    );
  }
}

class CreateCollectionScreen extends StatefulWidget {
  final String dog;
  const CreateCollectionScreen({super.key, required this.dog});

  @override
  State<CreateCollectionScreen> createState() => _CreateCollectionScreenState();
}

class _CreateCollectionScreenState extends State<CreateCollectionScreen> {
  final _name = TextEditingController();
  final _min = TextEditingController();
  String _type = 'All Record Types';
  bool _media = false;
  String? _nameError;
  String? _minError;

  @override
  void dispose() {
    _name.dispose();
    _min.dispose();
    super.dispose();
  }

  bool get _durationOk => _type == 'Training' || _type == 'S&C';

  SmartCollection _draft() => SmartCollection(
        id: 'draft',
        name: _name.text.trim(),
        type: _type,
        mediaOnly: _media,
        minMinutes: _durationOk ? int.tryParse(_min.text.trim()) : null,
      );

  @override
  Widget build(BuildContext context) {
    final st = TimelineStore.instance;
    final d = _draft();
    final count = st.events(dog: dogScope(widget.dog)).where((e) => st.matches(d, e)).length;
    return HealthScaffold(
      title: 'Create Collection',
      bottom: Row(children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: BorderSide(color: AppColors.cardBorder),
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PrimaryButton(
            label: 'Create Collection',
            onPressed: () {
              final mins = _min.text.trim();
              setState(() {
                _nameError = _name.text.trim().isEmpty ? 'Enter a collection name.' : null;
                _minError = _durationOk && mins.isNotEmpty && (int.tryParse(mins) == null || int.parse(mins) <= 0)
                    ? 'Enter a positive whole number of minutes.'
                    : null;
              });
              if (_nameError != null || _minError != null) return;
              final c = SmartCollection(
                id: st.newId(),
                name: _name.text.trim(),
                type: _type,
                mediaOnly: _media,
                minMinutes: _durationOk ? int.tryParse(mins) : null,
              );
              st.saveCollection(c);
              AppSnackbar.show(context, message: 'Collection created', type: SnackbarType.success);
              Navigator.pop(context);
            },
          ),
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text('Save filters to group matching Timeline records automatically.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
          const FieldLabel('Dog'),
          HealthCard(child: Text(widget.dog == kAllDogs ? 'All Dogs' : widget.dog, style: TextStyle(color: AppColors.primaryTextOffWhite))),
          const FieldLabel('Collection name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => setState(() => _nameError = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. Training with Videos', error: _nameError),
          ),
          const FieldLabel('Record type'),
          ChoiceRow(
            options: ['All Record Types', ...kTimelineCategories],
            value: _type,
            onChanged: (v) => setState(() {
              _type = v;
              if (!(_type == 'Training' || _type == 'S&C')) _min.clear();
            }),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primaryForestGreen,
            title: Text('With photos or videos', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            subtitle: Text('Only include records with at least one photo or video.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            value: _media,
            onChanged: (v) => setState(() => _media = v),
          ),
          if (_durationOk) ...[
            const FieldLabel('Minimum session duration'),
            TextField(
              controller: _min,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() => _minError = null),
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Minutes', error: _minError),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Leave blank for any duration.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ),
          ],
          const SizedBox(height: 18),
          HealthCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.rule, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
              const SizedBox(height: 4),
              Text('$count matching ${count == 1 ? 'record' : 'records'} now',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
            ]),
          ),
        ],
      ),
    );
  }
}

class ArchivedCollectionsScreen extends StatelessWidget {
  const ArchivedCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = TimelineStore.instance;
    return ListenableBuilder(
      listenable: st,
      builder: (context, _) {
        final list = st.collections(archived: true);
        return HealthScaffold(
          title: 'Archived Collections',
          body: list.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Archived Collections Yet',
                    message: 'Custom collections you archive will appear here. Your original records and attachments stay unchanged.',
                    actionLabel: 'Back to Collections',
                    onAction: () => Navigator.pop(context),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    for (final c in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: HealthCard(
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(c.name, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                                Text(c.rule, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                              ]),
                            ),
                            TextButton(
                              onPressed: () {
                                c.archived = false; // restored unpinned, same definition
                                st.saveCollection(c);
                              },
                              child: Text('Restore Collection',
                                  style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600, fontSize: 13)),
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

/// Activity Map: only events with a saved map location can appear. Records in
/// this build don't store coordinates yet, so the truthful state is empty.
class TimelineActivityMapScreen extends StatelessWidget {
  final String initialDog;
  const TimelineActivityMapScreen({super.key, this.initialDog = kAllDogs});

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: 'Activity Map',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(dog: initialDog, onSwitch: () {}),
          EmptyState(
            icon: Icons.map_outlined,
            title: 'No Recorded Locations',
            message:
                'Events with a saved map location will appear here. Add a location when recording or editing an event to build your dog’s activity map.',
            actionLabel: 'Go to Timeline',
            onAction: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
