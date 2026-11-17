import 'dart:io';
import 'package:flutter/material.dart';
import '../data/goals_store.dart';
import '../data/health_store.dart';
import '../data/media_store.dart';
import '../data/persist.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import 'timeline_common.dart';

const kWidgetTypes = <String, String>{
  'recent': 'Recent Records',
  'today': 'Today’s Records',
  'health': 'Upcoming Health Reminders',
  'weight': 'Latest Weight',
  'goals': 'Active Goals',
  'photos': 'Recent Photos',
  'videos': 'Recent Videos',
};

const _widgetBlurb = <String, String>{
  'recent': 'Your newest records',
  'today': 'Records dated today',
  'health': 'Next health reminders and appointments',
  'weight': 'The most recent saved weight',
  'goals': 'Your dogs\' active goals',
  'photos': 'Your latest photos',
  'videos': 'Your latest videos',
};

class HomeWidgetCfg {
  final String id;
  final String type;
  String size; // Small | Medium | Large
  String dog; // kAllDogs or a dog name
  HomeWidgetCfg({required this.id, required this.type, this.size = 'Medium', this.dog = kAllDogs});
  int get rows => size == 'Small' ? 1 : (size == 'Large' ? 5 : 3);
}

/// Optional in-app Home panels. One instance per type; scope is saved per
/// panel. Nothing here is a phone home-screen widget.
class HomeWidgetsStore extends ChangeNotifier {
  HomeWidgetsStore._();
  static final HomeWidgetsStore instance = HomeWidgetsStore._();

  final List<HomeWidgetCfg> _items = [];
  List<HomeWidgetCfg> get items => List.of(_items);
  HomeWidgetCfg? byType(String t) => _items.where((w) => w.type == t).firstOrNull;

  Future<void> load() async {
    final j = await Persist.read('store.homeWidgets');
    if (j is! List) return;
    _items
      ..clear()
      ..addAll([
        for (final m in j.cast<Map>())
          HomeWidgetCfg(id: m['id'], type: m['type'], size: m['size'] ?? 'Medium', dog: m['dog'] ?? kAllDogs)
      ]);
    notifyListeners();
  }

  void _save() => Persist.write('store.homeWidgets', [for (final w in _items) {'id': w.id, 'type': w.type, 'size': w.size, 'dog': w.dog}]);

  void upsert(HomeWidgetCfg w) {
    final i = _items.indexWhere((x) => x.type == w.type);
    if (i >= 0) {
      _items[i] = w;
    } else {
      _items.add(w);
    }
    _save();
    notifyListeners();
  }

  void replaceAll(List<HomeWidgetCfg> list) {
    _items
      ..clear()
      ..addAll(list);
    _save();
    notifyListeners();
  }
}

String _label(String t) => kWidgetTypes[t] ?? t;

/// The panel shown on Home, built only from the saved records.
class HomeWidgetPanel extends StatelessWidget {
  final HomeWidgetCfg cfg;
  const HomeWidgetPanel({super.key, required this.cfg});

  @override
  Widget build(BuildContext context) {
    final tl = TimelineStore.instance;
    final dogs = cfg.dog == kAllDogs ? TimelineStore.dogNames() : [cfg.dog];
    final all = cfg.dog == kAllDogs;
    Widget line(String title, String sub, {VoidCallback? onTap}) => InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
              Text(sub, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ]),
          ),
        );
    Widget empty(String t) => Text(t, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5));

    final rows = <Widget>[];
    switch (cfg.type) {
      case 'recent':
        final ev = tl.events(dog: dogScope(cfg.dog))..sort((a, b) => b.at.compareTo(a.at));
        for (final e in ev.take(cfg.rows)) {
          rows.add(line(e.title, '${e.typeLabel}${all ? ' · ${e.dog}' : ''} · ${fmtDate(e.at)}', onTap: () => openEvent(context, e)));
        }
        if (rows.isEmpty) rows.add(empty('No Records Yet'));
      case 'today':
        final n = DateTime.now();
        final ev = tl.events(dog: dogScope(cfg.dog)).where((e) => e.at.year == n.year && e.at.month == n.month && e.at.day == n.day).toList()
          ..sort((a, b) => a.at.compareTo(b.at));
        for (final e in ev.take(cfg.rows)) {
          rows.add(line(e.title, '${e.typeLabel}${all ? ' · ${e.dog}' : ''}${e.hasTime ? ' · ${fmtTime(e.at)}' : ''}', onTap: () => openEvent(context, e)));
        }
        if (rows.isEmpty) rows.add(empty('No records dated today'));
      case 'health':
        final items = <(String, HealthReminder)>[
          for (final d in dogs) for (final r in HealthStore.instance.upcoming(d)) (d, r),
        ]..sort((a, b) => a.$2.due.compareTo(b.$2.due));
        for (final it in items.take(cfg.rows)) {
          rows.add(line(it.$2.title, '${all ? '${it.$1} · ' : ''}${fmtDate(it.$2.due)}'));
        }
        if (rows.isEmpty) rows.add(empty('No upcoming health events'));
      case 'weight':
        for (final d in dogs) {
          final w = HealthStore.instance.weights(d);
          if (w.isNotEmpty) rows.add(line('${fmtKg(w.first.value)} ${w.first.unit}', '${all ? '$d · ' : ''}${fmtDate(w.first.date)}'));
        }
        if (rows.isEmpty) rows.add(empty('No weights recorded'));
      case 'goals':
        final active = <(String, GoalInfo)>[
          for (final d in dogs) for (final g in GoalsStore.instance.goalsFor(d)) if (g.status == GoalStatus.active) (d, g),
        ];
        for (final it in active.take(cfg.rows)) {
          final g = it.$2;
          final sub = g.isMeasurable ? '${g.current}/${g.targetValue} ${g.targetUnit}' : 'Open-ended';
          rows.add(line(g.title, '${all ? '${it.$1} · ' : ''}$sub'));
        }
        if (rows.isEmpty) rows.add(empty('No active goals'));
      default:
        final type = cfg.type == 'photos' ? MediaType.photo : MediaType.video;
        final items = <MediaItem>[
          for (final d in dogs) ...MediaStore.instance.items(d).where((i) => i.type == type),
        ]..sort((a, b) => b.mediaDate.compareTo(a.mediaDate));
        final shown = items.take(cfg.rows == 1 ? 3 : (cfg.rows == 3 ? 4 : 8)).toList();
        if (shown.isEmpty) {
          rows.add(empty(cfg.type == 'photos' ? 'No photos yet' : 'No videos yet'));
        } else {
          rows.add(Wrap(spacing: 6, runSpacing: 6, children: [
            for (final i in shown)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: type == MediaType.photo && i.path != null
                      ? Image.file(File(i.path!), fit: BoxFit.cover, cacheWidth: 200, errorBuilder: (_, _, _) => ColoredBox(color: AppColors.backgroundObsidian))
                      : const ColoredBox(color: Color(0xFF232625), child: Icon(Icons.play_arrow, color: Colors.white70)),
                ),
              ),
          ]));
        }
    }
    return HealthCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_label(cfg.type), style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        ...rows,
      ]),
    );
  }
}

/// Added panels, in their saved order, for the bottom of Home.
class HomeWidgetsSection extends StatelessWidget {
  const HomeWidgetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = HomeWidgetsStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([store, TimelineStore.instance, HealthStore.instance, MediaStore.instance]),
      builder: (context, _) {
        final items = store.items;
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (final w in items) Padding(padding: const EdgeInsets.only(bottom: 12), child: HomeWidgetPanel(cfg: w)),
        ]);
      },
    );
  }
}

/// Choose which optional panels appear on Home.
class HomeWidgetsScreen extends StatelessWidget {
  const HomeWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = HomeWidgetsStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.items;
        return HealthScaffold(
          title: 'Home Widgets',
          actions: [
            if (items.isNotEmpty)
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditHomeLayoutScreen())),
                child: Text('Edit Layout', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
              ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Text('Choose which panels appear on your Home page.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
              const SizedBox(height: 14),
              if (items.isEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 14),
                  child: Text('No Home Widgets Added. Choose optional widgets to personalise your Home page.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
                ),
              for (final e in kWidgetTypes.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: HealthCard(
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.value, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                          Text(_widgetBlurb[e.key]!, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        ]),
                      ),
                      OutlinedButton(
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.cardsCarbon,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                          builder: (_) => _ConfigureSheet(type: e.key),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: store.byType(e.key) == null ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey,
                          side: BorderSide(color: store.byType(e.key) == null ? AppColors.primaryForestGreen : Colors.white24),
                        ),
                        child: Text(store.byType(e.key) == null ? 'Add to Home' : 'Added to Home', style: const TextStyle(fontSize: 12.5)),
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

class _ConfigureSheet extends StatefulWidget {
  final String type;
  const _ConfigureSheet({required this.type});

  @override
  State<_ConfigureSheet> createState() => _ConfigureSheetState();
}

class _ConfigureSheetState extends State<_ConfigureSheet> {
  late final HomeWidgetCfg? _existing = HomeWidgetsStore.instance.byType(widget.type);
  late String _size = _existing?.size ?? 'Medium';
  late String _dog = _existing?.dog ?? kAllDogs;

  @override
  Widget build(BuildContext context) {
    final dogs = TimelineStore.dogNames();
    // A saved dog that no longer exists is never silently replaced.
    final missing = _dog != kAllDogs && !dogs.contains(_dog);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_label(widget.type), style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SectionLabel('Widget Size'),
          ChoiceRow(options: const ['Small', 'Medium', 'Large'], value: _size, onChanged: (v) => setState(() => _size = v)),
          const SectionLabel('Dogs'),
          ChoiceRow(
            options: [kAllDogsLabel, ...dogs],
            value: missing ? null : (_dog == kAllDogs ? kAllDogsLabel : _dog),
            onChanged: (v) => setState(() => _dog = v == kAllDogsLabel ? kAllDogs : v),
          ),
          if (missing)
            const Padding(padding: EdgeInsets.only(top: 6), child: Text('Choose a Dog', style: TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5))),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite, side: BorderSide(color: AppColors.cardBorder), minimumSize: const Size(0, 50)),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PrimaryButton(
                label: 'Save Widget',
                onPressed: () {
                  if (missing) return;
                  HomeWidgetsStore.instance.upsert(
                      HomeWidgetCfg(id: _existing?.id ?? 'hw_${widget.type}', type: widget.type, size: _size, dog: _dog));
                  Navigator.pop(context);
                  AppSnackbar.show(context, message: 'Widget saved', type: SnackbarType.success);
                },
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

const kAllDogsLabel = 'All Dogs';

/// Drag-free reordering: Move Up / Move Down / Remove from Home, saved as a
/// whole with Save Layout.
class EditHomeLayoutScreen extends StatefulWidget {
  const EditHomeLayoutScreen({super.key});

  @override
  State<EditHomeLayoutScreen> createState() => _EditHomeLayoutScreenState();
}

class _EditHomeLayoutScreenState extends State<EditHomeLayoutScreen> {
  late List<HomeWidgetCfg> _draft = HomeWidgetsStore.instance.items;

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: 'Edit Home Layout',
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
            label: 'Save Layout',
            onPressed: () {
              HomeWidgetsStore.instance.replaceAll(_draft);
              Navigator.pop(context);
            },
          ),
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text('Move your Home widgets up or down, or remove them from Home.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
          const SizedBox(height: 12),
          for (var i = 0; i < _draft.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: HealthCard(
                padding: const EdgeInsets.fromLTRB(14, 6, 4, 6),
                child: Row(children: [
                  Expanded(child: Text(_label(_draft[i].type), style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15))),
                  IconButton(
                    tooltip: 'Move Up',
                    icon: const Icon(Icons.arrow_upward, size: 20),
                    color: AppColors.secondaryTextStoneGrey,
                    onPressed: i == 0
                        ? null
                        : () => setState(() {
                              final t = _draft[i];
                              _draft = [..._draft]..removeAt(i);
                              _draft.insert(i - 1, t);
                            }),
                  ),
                  IconButton(
                    tooltip: 'Move Down',
                    icon: const Icon(Icons.arrow_downward, size: 20),
                    color: AppColors.secondaryTextStoneGrey,
                    onPressed: i == _draft.length - 1
                        ? null
                        : () => setState(() {
                              final t = _draft[i];
                              _draft = [..._draft]..removeAt(i);
                              _draft.insert(i + 1, t);
                            }),
                  ),
                  IconButton(
                    tooltip: 'Remove from Home',
                    icon: const Icon(Icons.close, size: 20),
                    color: const Color(0xFFFFB4AB),
                    onPressed: () => setState(() => _draft = [..._draft]..removeAt(i)),
                  ),
                ]),
              ),
            ),
          if (_draft.isEmpty)
            Text('No Home Widgets Added.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          if (_draft.isNotEmpty)
            TextButton(
              onPressed: () async {
                final ok = await confirmDelete(context,
                    title: 'Reset Home layout?',
                    message: 'This removes all optional widgets from Home when you save. Your records and the required Home sections are not affected.');
                if (ok) setState(() => _draft = []);
              },
              child: Text('Reset Home Layout', style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
            ),
        ],
      ),
    );
  }
}
