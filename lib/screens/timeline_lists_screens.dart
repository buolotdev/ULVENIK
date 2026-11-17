import 'package:flutter/material.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'timeline_common.dart';
import 'timeline_export_util.dart';

Widget _sortButton(bool newest, VoidCallback onTap) => Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onTap,
        icon: AnimatedRotation(
          turns: newest ? 0 : 0.5,
          duration: const Duration(milliseconds: 250),
          child: UlvenikIcon(UlvenikIcons.sort, size: 16, color: AppColors.secondaryTextStoneGrey),
        ),
        label: Text(newest ? 'Newest First' : 'Oldest First',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
      ),
    );

Widget _categoryButton(String value, VoidCallback onTap) => OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryTextOffWhite,
        side: BorderSide(color: AppColors.cardBorder),
        backgroundColor: AppColors.cardsCarbon,
        alignment: Alignment.centerLeft,
        minimumSize: const Size(double.infinity, 46),
      ),
      child: Row(children: [
        Expanded(child: Text(value)),
        Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextStoneGrey),
      ]),
    );

/// Favourites: events the user hearted, by original date. Hearts here are
/// independent of Media Library file favourites.
class TimelineFavouritesScreen extends StatefulWidget {
  final String initialDog;
  const TimelineFavouritesScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineFavouritesScreen> createState() => _TimelineFavouritesScreenState();
}

class _TimelineFavouritesScreenState extends State<TimelineFavouritesScreen> {
  final _store = TimelineStore.instance;
  final _search = TextEditingController();
  late String _dog = widget.initialDog;
  String _category = kAllCategories;
  bool _newest = true;

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

  @override
  Widget build(BuildContext context) {
    final all = _store.events(dog: dogScope(_dog)).where((e) => _store.isFavourite(e.id)).toList();
    final list = all
        .where((e) => (_category == kAllCategories || e.category == _category) && eventMatches(e, _search.text))
        .toList()
      ..sort((a, b) => _newest ? b.at.compareTo(a.at) : a.at.compareTo(b.at));

    return HealthScaffold(
      title: 'Favourites',
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
          const SizedBox(height: 14),
          if (all.isEmpty)
            Column(children: [
              EmptyState(
                icon: Icons.favorite_border,
                title: 'No Favourites Yet',
                message:
                    'Tap the heart on a Timeline event to save it here, so you can easily revisit your dog’s memorable moments.',
                actionLabel: 'Go to Timeline',
                onAction: () => Navigator.pop(context),
              ),
            ])
          else ...[
            searchField(_search, 'Search favourites...'),
            const SizedBox(height: 10),
            _categoryButton(_category, () async {
              final c = await showCategorySheet(context, _category);
              if (c != null) setState(() => _category = c);
            }),
            _sortButton(_newest, () => setState(() => _newest = !_newest)),
            if (list.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text('No favourites match your search or category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                ),
              ),
            for (final e in list)
              TimelineEventCard(
                event: e,
                showDog: _dog == kAllDogs,
                onTap: () => openEvent(context, e),
                trailing: favouriteHeart(e),
              ),
          ],
        ],
      ),
    );
  }
}

/// Timeline Archive: events hidden from the main Timeline. The originals and
/// their files are untouched; Restore puts the same event back at its original
/// date.
class TimelineArchiveScreen extends StatefulWidget {
  final String initialDog;
  const TimelineArchiveScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineArchiveScreen> createState() => _TimelineArchiveScreenState();
}

class _TimelineArchiveScreenState extends State<TimelineArchiveScreen> {
  final _store = TimelineStore.instance;
  final _search = TextEditingController();
  late String _dog = widget.initialDog;
  String _category = kAllCategories;
  bool _newest = true;
  bool _selecting = false;
  final Set<String> _selected = {};

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

  Map<String, TimelineEvent> _live() => {for (final e in _store.allEvents(dog: dogScope(_dog))) e.id: e};

  Future<void> _restore(List<ArchivedRef> refs) async {
    final n = refs.length;
    final dogLabel = _dog == kAllDogs ? 'their' : '$_dog’s';
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(n == 1 ? 'Restore 1 Event?' : 'Restore $n Events?',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              n == 1
                  ? 'This event will return to $dogLabel Timeline at its original date.'
                  : 'These events will return to $dogLabel Timeline at their original dates.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Restore Events', onPressed: () => Navigator.pop(ctx, true)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: AppColors.cardBorder)),
                child: Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              ),
            ),
          ]),
        ),
      ),
    );
    if (ok != true || !mounted) return;
    _store.restore(refs.map((r) => r.eventId));
    setState(() {
      _selected.clear();
      _selecting = false;
    });
    AppSnackbar.show(context, message: n == 1 ? 'Event restored' : '$n events restored', type: SnackbarType.success);
  }

  @override
  Widget build(BuildContext context) {
    final live = _live();
    final all = _store.archivedRefs().where((r) => _dog == kAllDogs || r.dog == _dog).toList();
    final q = _search.text.trim().toLowerCase();
    final list = all
        .where((r) =>
            (_category == kAllCategories || r.category == _category) && (q.isEmpty || r.title.toLowerCase().contains(q)))
        .toList()
      ..sort((a, b) => _newest ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    final eligible = list.where((r) => live.containsKey(r.eventId)).toList();
    final selectedRefs = eligible.where((r) => _selected.contains(r.eventId)).toList();

    return HealthScaffold(
      title: 'Timeline Archive',
      actions: all.isEmpty
          ? null
          : [
              TextButton(
                onPressed: () => setState(() {
                  _selecting = !_selecting;
                  _selected.clear();
                }),
                child: Text(_selecting ? 'Done' : 'Select',
                    style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
              ),
            ],
      bottom: _selecting && selectedRefs.isNotEmpty
          ? Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TimelineExportScreen(
                            initialDog: _dog, preselected: selectedRefs.map((r) => r.eventId).toSet())),
                  ),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: BorderSide(color: AppColors.cardBorder),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Export'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: PrimaryButton(label: 'Restore', onPressed: () => _restore(selectedRefs))),
            ])
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog);
              if (d != null) {
                setState(() {
                  _dog = d;
                  _selected.clear(); // no hidden selection across dogs
                });
              }
            },
          ),
          const SizedBox(height: 14),
          if (all.isEmpty)
            EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No Archived Events Yet',
              message:
                  'Events you archive from your dog’s Timeline will appear here. You can restore them whenever you need.',
              actionLabel: 'Go to Timeline',
              onAction: () => Navigator.pop(context),
            )
          else ...[
            searchField(_search, 'Search archive...'),
            const SizedBox(height: 10),
            _categoryButton(_category, () async {
              final c = await showCategorySheet(context, _category);
              if (c != null) setState(() => _category = c);
            }),
            if (_selecting)
              Row(children: [
                Expanded(
                  child: Text('${selectedRefs.length} selected',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    if (selectedRefs.length == eligible.length) {
                      _selected.clear();
                    } else {
                      _selected
                        ..clear()
                        ..addAll(eligible.map((r) => r.eventId));
                    }
                  }),
                  child: Text(selectedRefs.length == eligible.length && eligible.isNotEmpty ? 'Deselect All' : 'Select All',
                      style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                ),
                _sortButton(_newest, () => setState(() => _newest = !_newest)),
              ])
            else
              _sortButton(_newest, () => setState(() => _newest = !_newest)),
            if (list.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text('No archived events match your search or category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                ),
              ),
            for (final r in list)
              if (live[r.eventId] != null)
                TimelineEventCard(
                  event: live[r.eventId]!,
                  showDog: _dog == kAllDogs,
                  extraLine: 'Archived ${fmtDate(r.archivedAt)}',
                  onTap: () => _selecting
                      ? setState(() => _selected.contains(r.eventId) ? _selected.remove(r.eventId) : _selected.add(r.eventId))
                      : openEvent(context, live[r.eventId]!),
                  trailing: _selecting
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            _selected.contains(r.eventId) ? Icons.check_circle : Icons.circle_outlined,
                            color: _selected.contains(r.eventId) ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey,
                          ),
                        )
                      : null,
                )
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: HealthCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Original Record Deleted',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('${r.title} · ${r.category} · ${fmtDate(r.date)}',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      Text('Archived ${fmtDate(r.archivedAt)}',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final ok = await confirmDelete(context,
                                title: 'Remove Reference?',
                                message:
                                    'Only this leftover entry will be removed. Any files stored separately stay in your Media Library.');
                            if (ok) _store.restore([r.eventId]);
                          },
                          child: const Text('Remove Reference', style: TextStyle(color: Color(0xFFFFB4AB))),
                        ),
                      ),
                    ]),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

/// Timeline Export: Specific Events (exact chosen IDs) or Date Range, as a PDF
/// document or CSV spreadsheet. Nothing is generated for an empty scope.
class TimelineExportScreen extends StatefulWidget {
  final String initialDog;
  final Set<String>? preselected;
  const TimelineExportScreen({super.key, this.initialDog = kAllDogs, this.preselected});

  @override
  State<TimelineExportScreen> createState() => _TimelineExportScreenState();
}

class _TimelineExportScreenState extends State<TimelineExportScreen> {
  final _store = TimelineStore.instance;
  late String _dog = widget.initialDog;
  bool _pdf = true;
  late bool _specific = widget.preselected != null;
  late Set<String> _ids = {...?widget.preselected};
  TlPeriod _period = TlPeriod.lifetime;
  String _category = kAllCategories;
  bool _busy = false;

  List<TimelineEvent> get _events {
    if (_specific) {
      final all = _store.allEvents(dog: dogScope(_dog));
      return all.where((e) => _ids.contains(e.id)).toList()..sort((a, b) => b.at.compareTo(a.at));
    }
    return _store
        .events(dog: dogScope(_dog))
        .where((e) => (_category == kAllCategories || e.category == _category) && _period.contains(e.at))
        .toList()
      ..sort((a, b) => b.at.compareTo(a.at));
  }

  Future<void> _editSelection() async {
    final pool = widget.preselected != null
        ? _store.allEvents(dog: dogScope(_dog)).where((e) => _store.isArchived(e.id)).toList()
        : _store.events(dog: dogScope(_dog));
    final draft = {..._ids};
    final search = TextEditingController();
    String cat = kAllCategories;
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final shown = pool
              .where((e) => (cat == kAllCategories || e.category == cat) && eventMatches(e, search.text))
              .toList()
            ..sort((a, b) => b.at.compareTo(a.at));
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.85),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 12 + MediaQuery.viewInsetsOf(ctx).bottom),
                child: Column(children: [
                  Text('Select Events (${draft.length})',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: search,
                    onChanged: (_) => setSheet(() {}),
                    style: TextStyle(color: AppColors.primaryTextOffWhite),
                    decoration: healthDecoration('Search events...'),
                  ),
                  const SizedBox(height: 8),
                  ChoiceRow(
                    options: [kAllCategories, ...kTimelineCategories],
                    value: cat,
                    onChanged: (v) => setSheet(() => cat = v),
                  ),
                  Expanded(
                    child: ListView(children: [
                      for (final e in shown)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.primaryForestGreen,
                          checkColor: AppColors.primaryTextOffWhite,
                          title: Text(e.title, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                          subtitle: Text('${e.category} · ${fmtDate(e.at)}',
                              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                          value: draft.contains(e.id),
                          onChanged: (v) => setSheet(() => v == true ? draft.add(e.id) : draft.remove(e.id)),
                        ),
                    ]),
                  ),
                  PrimaryButton(label: 'Done', onPressed: () => Navigator.pop(ctx, draft)),
                ]),
              ),
            ),
          );
        },
      ),
    );
    search.dispose();
    if (result != null) setState(() => _ids = result);
  }

  Future<void> _generate() async {
    if (_busy) return;
    final events = _events;
    setState(() => _busy = true);
    final scope = _specific
        ? '${events.length} selected events'
        : '${_period.label} · ${_category == kAllCategories ? 'All Categories' : _category}';
    final dogLabel = _dog == kAllDogs ? 'All Dogs' : _dog;
    final base = 'Ulvenik_Timeline_${dogLabel.replaceAll(' ', '_')}_${exportStamp()}';
    await runExport(
      context,
      fileName: '$base.${_pdf ? 'pdf' : 'csv'}',
      pdf: _pdf,
      preparing: 'Preparing your selected Timeline events...',
      build: () async => _pdf ? await eventsPdf('Timeline · $dogLabel', scope, events) : eventsCsv(events),
    );
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final events = _events;
    final reason = _specific
        ? (events.isEmpty ? 'Select at least one event to export.' : null)
        : (events.isEmpty ? 'No events found for this period. Choose a different date range.' : null);

    Widget formatCard(String label, String sub, bool pdf) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: HealthCard(
            onTap: () => setState(() => _pdf = pdf),
            child: Row(children: [
              Icon(_pdf == pdf ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: _pdf == pdf ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(label, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(sub, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                ]),
              ),
            ]),
          ),
        );

    return HealthScaffold(
      title: 'Timeline Export',
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        if (reason != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(reason, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
          ),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: reason == null && !_busy ? _generate : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: AppColors.onForestGreen,
              disabledBackgroundColor: AppColors.cardsCarbon,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Generate Export', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog);
              if (d != null) {
                setState(() {
                  _dog = d;
                  _ids = {};
                });
              }
            },
          ),
          const SizedBox(height: 18),
          const SectionLabel('Format'),
          formatCard('PDF Document', 'A formatted report for reading, printing and sharing', true),
          formatCard('CSV Spreadsheet', 'Event data for Excel or Google Sheets', false),
          const SizedBox(height: 8),
          const SectionLabel('What to export'),
          ChoiceRow(
            options: const ['Specific Events', 'Date Range'],
            value: _specific ? 'Specific Events' : 'Date Range',
            onChanged: (v) => setState(() => _specific = v == 'Specific Events'),
          ),
          const SizedBox(height: 14),
          if (_specific) ...[
            Row(children: [
              Expanded(
                child: Text('Selected Events (${_ids.length})',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: _editSelection,
                child: Text('Edit Selection',
                    style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
              ),
            ]),
            for (final e in events)
              HealthCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e.title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
                      Text('${e.category} · ${fmtDate(e.at)}',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    ]),
                  ),
                ]),
              ),
          ] else ...[
            OutlinedButton(
              onPressed: () async {
                final p = await showTlPeriodSheet(context, _period);
                if (p != null) setState(() => _period = p);
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  backgroundColor: AppColors.cardsCarbon,
                  alignment: Alignment.centerLeft,
                  minimumSize: const Size(double.infinity, 46)),
              child: Text(_period.label),
            ),
            const SizedBox(height: 10),
            _categoryButton(_category, () async {
              final c = await showCategorySheet(context, _category);
              if (c != null) setState(() => _category = c);
            }),
            const SizedBox(height: 10),
            Text('${events.length} ${events.length == 1 ? 'event' : 'events'} in this scope',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}
