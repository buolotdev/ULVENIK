import 'package:flutter/material.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'health_records_hub_screen.dart';
import 'sc_record_session_screen.dart';
import 'sport_competition_screens.dart';
import 'timeline_analysis_screens.dart';
import 'home_widgets.dart';
import 'timeline_collections_screens.dart';
import 'timeline_common.dart';
import 'timeline_lists_screens.dart';
import 'timeline_milestone_screens.dart';
import 'training_screen.dart' show openNewTrainingSession;

const _monthLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class _TlFilters {
  Set<String> categories = {}; // empty = All Categories
  TlPeriod period = TlPeriod.lifetime;
  bool mediaOnly = false;

  bool get active => categories.isNotEmpty || period.kind != 'Lifetime' || mediaOnly;

  _TlFilters copy() => _TlFilters()
    ..categories = {...categories}
    ..period = period
    ..mediaOnly = mediaOnly;
}

/// Timeline: the dog's original records in one chronological feed. Cards open
/// the exact original; nothing here is a copy.
class TimelineScreen extends StatefulWidget {
  final bool initialEmpty;
  const TimelineScreen({super.key, this.initialEmpty = false});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _store = TimelineStore.instance;
  final _search = TextEditingController();
  String _dog = kAllDogs;
  _TlFilters _filters = _TlFilters();
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

  void _go(Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));

  Future<void> _switchDog() async {
    final d = await showDogSheet(context, _dog);
    if (d != null) setState(() => _dog = d);
  }

  List<TimelineEvent> _visible() {
    final f = _filters;
    final list = _store.events(dog: dogScope(_dog)).where((e) {
      if (f.categories.isNotEmpty && !f.categories.contains(e.category)) return false;
      if (!f.period.contains(e.at)) return false;
      if (f.mediaOnly && _store.mediaCount(e) == 0) return false;
      return eventMatches(e, _search.text);
    }).toList();
    list.sort((a, b) => _newest ? b.at.compareTo(a.at) : a.at.compareTo(b.at));
    return list;
  }

  Future<void> _openFilters() async {
    final draft = _filters.copy();
    final applied = await showModalBottomSheet<_TlFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.85),
            child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
              Text('Filter Timeline',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Scope: ${_dog == kAllDogs ? 'All Dogs' : _dog}',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              const FieldLabelPlain('Categories'),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ChoiceChip(
                  label: const Text('All Categories'),
                  selected: draft.categories.isEmpty,
                  onSelected: (_) => setSheet(() => draft.categories.clear()),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                      color: draft.categories.isEmpty ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                      fontSize: 13),
                  backgroundColor: AppColors.backgroundObsidian,
                  selectedColor: AppColors.primaryForestGreen,
                  side: BorderSide(color: AppColors.cardBorder),
                ),
                for (final c in kTimelineCategories)
                  FilterChip(
                    label: Text(c),
                    selected: draft.categories.contains(c),
                    onSelected: (v) => setSheet(() => v ? draft.categories.add(c) : draft.categories.remove(c)),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                        color: draft.categories.contains(c) ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                        fontSize: 13),
                    backgroundColor: AppColors.backgroundObsidian,
                    selectedColor: AppColors.primaryForestGreen,
                    side: BorderSide(color: AppColors.cardBorder),
                  ),
              ]),
              const FieldLabelPlain('Period'),
              OutlinedButton(
                onPressed: () async {
                  final p = await showTlPeriodSheet(ctx, draft.period);
                  if (p != null) setSheet(() => draft.period = p);
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite,
                    side: BorderSide(color: AppColors.cardBorder),
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size(double.infinity, 46)),
                child: Text(draft.period.label),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primaryForestGreen,
                title: Text('With Photos or Videos Only', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                value: draft.mediaOnly,
                onChanged: (v) => setSheet(() => draft.mediaOnly = v),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setSheet(() {
                      draft.categories.clear();
                      draft.period = TlPeriod.lifetime;
                      draft.mediaOnly = false;
                    }),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: BorderSide(color: AppColors.cardBorder),
                        minimumSize: const Size(0, 50)),
                    child: const Text('Reset Filters'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: PrimaryButton(label: 'Apply Filters', onPressed: () => Navigator.pop(ctx, draft))),
              ]),
            ]),
          ),
        ),
      ),
    );
    if (applied != null) setState(() => _filters = applied);
  }

  Future<void> _addRecord() async {
    final type = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add Record',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            for (final t in ['Training Session', 'S&C Session', 'Health Record', 'Milestone', 'Competition'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () => Navigator.pop(ctx, t),
              ),
          ]),
        ),
      ),
    );
    if (type == null || !mounted) return;
    var dog = _dog;
    if (dog == kAllDogs) {
      final d = await showDogSheet(context, dog, allowAll: false);
      if (d == null || !mounted) return;
      dog = d;
    }
    switch (type) {
      case 'Training Session':
        openNewTrainingSession(context, dogName: dog);
      case 'S&C Session':
        _go(SCRecordSessionScreen(dogName: dog));
      case 'Health Record':
        _go(HealthRecordsHubScreen(dogName: dog));
      case 'Milestone':
        _go(MilestoneFormScreen(dogName: dog));
      default:
        _go(CompetitionFormScreen(dogName: dog));
    }
  }

  void _menu() => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) {
          Widget item(String label, Widget Function() screen) => ListTile(
                title: Text(label, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _go(screen());
                },
              );
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                item('Favourites', () => TimelineFavouritesScreen(initialDog: _dog)),
                item('Timeline Archive', () => TimelineArchiveScreen(initialDog: _dog)),
                item('Memories', () => TimelineMemoriesScreen(initialDog: _dog)),
                item('Compare', () => TimelineCompareScreen(initialDog: _dog)),
                item('Activity Map', () => TimelineActivityMapScreen(initialDog: _dog)),
                item('Home Widgets', () => const HomeWidgetsScreen()),
                item('Smart Collections', () => TimelineSmartCollectionsScreen(initialDog: _dog)),
                item('Statistics', () => TimelineStatisticsScreen(initialDog: _dog)),
                item('Timeline Export', () => TimelineExportScreen(initialDog: _dog)),
                item('Calendar', () => TimelineCalendarScreen(initialDog: _dog)),
              ]),
            ),
          );
        },
      );

  String _groupLabel(DateTime d) {
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${_monthLong[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final all = _store.events(dog: dogScope(_dog));
    final list = _visible();
    final q = _search.text.trim();

    final groups = <String, List<TimelineEvent>>{};
    for (final e in list) {
      groups.putIfAbsent(_groupLabel(e.at), () => []).add(e);
    }

    Widget body;
    if (all.isEmpty) {
      body = EmptyState(
        icon: Icons.timeline,
        title: 'No Events Yet',
        message: 'Add your first record to start building your dog’s Timeline.',
        actionLabel: 'Add Record',
        onAction: _addRecord,
      );
    } else if (list.isEmpty) {
      final onlyQuery = q.isNotEmpty && !_filters.active;
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Column(children: [
          Text('No Matching Events',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            onlyQuery
                ? 'Try another search term or clear your search.'
                : 'No events match your current filters${q.isEmpty ? '' : ' and search'}.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5),
          ),
          const SizedBox(height: 12),
          if (q.isNotEmpty)
            TextButton(
              onPressed: _search.clear,
              child: Text('Clear Search',
                  style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
          if (_filters.active)
            TextButton(
              onPressed: () => setState(() => _filters = _TlFilters()),
              child: Text('Clear Filters',
                  style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
        ]),
      );
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final g in groups.entries) ...[
          SectionLabel(g.key),
          for (final e in g.value)
            TimelineEventCard(
              event: e,
              showDog: _dog == kAllDogs,
              onTap: () => openEvent(context, e),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                favouriteHeart(e),
                PopupMenuButton<String>(
                  color: AppColors.cardsCarbon,
                  tooltip: 'More',
                  icon: UlvenikIcon(UlvenikIcons.more, size: 20, color: AppColors.secondaryTextStoneGrey),
                  onSelected: (_) {
                    _store.archive(e);
                    AppSnackbar.show(context, message: 'Event archived', type: SnackbarType.success);
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'archive', child: Text('Archive Event', style: TextStyle(color: AppColors.primaryTextOffWhite))),
                  ],
                ),
              ]),
            ),
        ],
      ]);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Timeline',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            tooltip: 'Add Record',
            icon: UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryForestGreen),
            onPressed: _addRecord,
          ),
          IconButton(
            tooltip: 'More',
            icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
            onPressed: _menu,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          TimelineDogHeader(dog: _dog, onSwitch: _switchDog),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: searchField(_search, 'Search events...')),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              width: 48,
              child: Badge(
                isLabelVisible: _filters.active,
                backgroundColor: AppColors.primaryForestGreen,
                label: Text('${_filters.categories.length + (_filters.period.kind != 'Lifetime' ? 1 : 0) + (_filters.mediaOnly ? 1 : 0)}'),
                child: OutlinedButton(
                  onPressed: _openFilters,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.cardsCarbon,
                    side: BorderSide(color: _filters.active ? AppColors.primaryForestGreen : AppColors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Icon(Icons.tune,
                      color: _filters.active ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            if (_filters.active)
              Expanded(
                child: Text(
                  [
                    if (_filters.categories.isNotEmpty) _filters.categories.join(', '),
                    if (_filters.period.kind != 'Lifetime') _filters.period.label,
                    if (_filters.mediaOnly) 'With photos or videos',
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                ),
              )
            else
              const Spacer(),
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
          ]),
          body,
        ],
      ),
    );
  }
}

class FieldLabelPlain extends StatelessWidget {
  final String text;
  const FieldLabelPlain(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(text,
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, fontWeight: FontWeight.w600)),
      );
}
