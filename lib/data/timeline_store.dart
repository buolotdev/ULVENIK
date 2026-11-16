import 'package:flutter/material.dart';
import '../screens/body_condition_screen.dart';
import '../screens/health_log_screen.dart';
import '../screens/sc_session_details_screen.dart';
import '../screens/sport_competition_screens.dart';
import '../screens/sport_session_screens.dart';
import '../screens/timeline_milestone_screens.dart';
import '../screens/training_screen.dart';
import '../screens/training_session_screen.dart';
import '../screens/weight_records_screen.dart';
import 'health_store.dart';
import 'persist.dart';
import 'media_store.dart';
import 'sample_data.dart';
import 'sc_store.dart';
import 'sport_store.dart';

const kTimelineCategories = ['Training', 'S&C', 'Health', 'Sport', 'Milestones'];

/// One original record as it appears on the Timeline. Events are derived from
/// the saved originals (never copied), so opening one always resolves the same
/// record by ID, type and dog.
class TimelineEvent {
  final String id; // '<type>:<original id>'
  final String dog;
  final String category;
  final String typeLabel;
  final String title;
  final DateTime at;
  final bool hasTime;
  final String detail;
  final String notes;
  final String linkKey; // key MediaStore links use for this record ('' if none)
  final int? minutes; // recorded session duration, when there is one
  final Widget Function(BuildContext) open;
  const TimelineEvent({
    required this.id,
    required this.dog,
    required this.category,
    required this.typeLabel,
    required this.title,
    required this.at,
    required this.hasTime,
    required this.open,
    this.detail = '',
    this.notes = '',
    this.linkKey = '',
    this.minutes,
  });
}

class Milestone {
  final String id;
  final String dog;
  String title;
  DateTime date;
  String? time;
  String notes;
  List<String> attachments;
  Milestone({
    required this.id,
    required this.dog,
    required this.title,
    required this.date,
    this.time,
    this.notes = '',
    List<String>? attachments,
  }) : attachments = attachments ?? [];
}

class ArchivedRef {
  final String eventId;
  final String dog;
  final String category;
  final String title;
  final DateTime date; // original date
  final DateTime archivedAt;
  const ArchivedRef(this.eventId, this.dog, this.category, this.title, this.date, this.archivedAt);
}

String _two(int n) => n.toString().padLeft(2, '0');

/// A saved Smart Collection definition: a reusable filter over Timeline
/// records. It never copies or moves originals or files.
class SmartCollection {
  final String id;
  String name;
  String type; // 'All Record Types' or a Timeline category
  bool mediaOnly;
  int? minMinutes; // Training / S&C only
  bool pinned;
  bool archived;
  SmartCollection({
    required this.id,
    required this.name,
    this.type = 'All Record Types',
    this.mediaOnly = false,
    this.minMinutes,
    this.pinned = false,
    this.archived = false,
  });

  /// Plain-language rule.
  String get rule {
    final t = type == 'All Record Types' ? 'All records' : '$type records';
    return [
      t,
      if (mediaOnly) 'with photos or videos',
      if (minMinutes != null) 'lasting at least $minMinutes minutes',
    ].join(', ');
  }
}

class TimelineStore extends ChangeNotifier {
  TimelineStore._();
  static final TimelineStore instance = TimelineStore._();

  final Set<String> _favourites = {};
  final Map<String, ArchivedRef> _archived = {};
  final List<Milestone> _milestones = [];
  final List<SmartCollection> _collections = [];
  final Set<String> _pinnedBuiltIns = {};
  int _seq = 0;
  String newId() => 'tl${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  // ── Milestones (manual originals) ───────────────────────────────────────
  List<Milestone> milestones() => List.of(_milestones);
  Milestone? milestone(String id) => _milestones.where((m) => m.id == id).firstOrNull;

  void saveMilestone(Milestone m) {
    if (!_milestones.any((x) => x.id == m.id)) _milestones.add(m);
    notifyListeners();
  }

  void deleteMilestone(String id) {
    _milestones.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // ── Smart Collections ───────────────────────────────────────────────────
  List<SmartCollection> collections({bool archived = false}) => _collections.where((c) => c.archived == archived).toList();
  SmartCollection? collection(String id) => _collections.where((c) => c.id == id).firstOrNull;
  bool isBuiltInPinned(String key) => _pinnedBuiltIns.contains(key);

  void saveCollection(SmartCollection c) {
    if (!_collections.any((x) => x.id == c.id)) _collections.add(c);
    notifyListeners();
  }

  void toggleBuiltInPin(String key) {
    _pinnedBuiltIns.contains(key) ? _pinnedBuiltIns.remove(key) : _pinnedBuiltIns.add(key);
    notifyListeners();
  }

  /// Whether [e] matches a custom collection. Missing duration fails a minimum.
  bool matches(SmartCollection c, TimelineEvent e) {
    if (c.type != 'All Record Types' && e.category != c.type) return false;
    if (c.mediaOnly) {
      final n = e.linkKey.isEmpty
          ? 0
          : MediaStore.instance.items(e.dog).where((i) => i.links.any((l) => l.key == e.linkKey) && i.type != MediaType.document).length;
      if (n == 0) return false;
    }
    if (c.minMinutes != null && (e.minutes == null || e.minutes! < c.minMinutes!)) return false;
    return true;
  }

  // ── Favourites / archive ────────────────────────────────────────────────
  bool isFavourite(String eventId) => _favourites.contains(eventId);

  void toggleFavourite(String eventId) {
    _favourites.contains(eventId) ? _favourites.remove(eventId) : _favourites.add(eventId);
    notifyListeners();
  }

  bool isArchived(String eventId) => _archived.containsKey(eventId);
  List<ArchivedRef> archivedRefs() => _archived.values.toList();

  void archive(TimelineEvent e) {
    _archived[e.id] = ArchivedRef(e.id, e.dog, e.category, e.title, e.at, DateTime.now());
    notifyListeners();
  }

  void restore(Iterable<String> ids) {
    for (final id in ids) {
      _archived.remove(id);
    }
    notifyListeners();
  }

  // ── Derivation ──────────────────────────────────────────────────────────
  static List<String> dogNames() => [for (final d in SampleData.myDogs) d.name];

  /// Every original that qualifies for the Timeline, optionally for one dog.
  /// Archived events are only hidden by [events]; [allEvents] includes them.
  List<TimelineEvent> allEvents({String? dog}) {
    final out = <TimelineEvent>[];
    final dogs = dog == null ? dogNames() : [dog];

    for (final s in TrainingSessionStore.sessionsNotifier.value) {
      if (s.status != SessionStatus.completed || !dogs.contains(s.dogName)) continue;
      final t = s.startTime;
      final d = s.durationMinutes;
      out.add(TimelineEvent(
        id: 'training:${s.id}',
        dog: s.dogName,
        category: 'Training',
        typeLabel: 'Training Session',
        title: s.title,
        at: DateTime(s.date.year, s.date.month, s.date.day, t.hour, t.minute),
        hasTime: true,
        detail: d == null ? '' : _dur(d),
        minutes: d,
        notes: s.notes,
        linkKey: 'training:${s.id}',
        open: (_) => TrainingSessionScreen(session: s),
      ));
    }

    for (final dg in dogs) {
      for (final s in SCStore.instance.sessions(dg)) {
        out.add(TimelineEvent(
          id: 'sc:${s.id}',
          dog: dg,
          category: 'S&C',
          typeLabel: 'S&C Session',
          title: s.name,
          at: s.at,
          hasTime: true,
          detail: s.durationMinutes == null ? '' : _dur(s.durationMinutes!),
          minutes: s.durationMinutes,
          notes: s.notes,
          linkKey: 'sc:${s.id}',
          open: (_) => SCSessionDetailsScreen(dogName: dg, sessionId: s.id),
        ));
      }
      for (final s in SportStore.instance.sessions(dg)) {
        out.add(TimelineEvent(
          id: 'sport:${s.id}',
          dog: dg,
          category: 'Sport',
          typeLabel: 'Sport Session',
          title: s.name,
          at: s.at,
          hasTime: true,
          detail: s.durationMinutes == null ? '' : _dur(s.durationMinutes!),
          minutes: s.durationMinutes,
          notes: s.notes,
          linkKey: 'sport:${s.id}',
          open: (_) => SportSessionDetailsScreen(dogName: dg, sessionId: s.id),
        ));
      }
      for (final c in SportStore.instance.competitions(dg)) {
        out.add(TimelineEvent(
          id: 'competition:${c.id}',
          dog: dg,
          category: 'Sport',
          typeLabel: 'Competition',
          title: c.name,
          at: c.date,
          hasTime: false,
          detail: [c.sportName, if (c.placement.isNotEmpty) c.placement].join(' · '),
          notes: c.notes,
          linkKey: 'competition:${c.id}',
          open: (_) => CompetitionDetailsScreen(dogName: dg, competitionId: c.id),
        ));
      }
      for (final w in HealthStore.instance.weights(dg)) {
        out.add(TimelineEvent(
          id: 'weight:${w.id}',
          dog: dg,
          category: 'Health',
          typeLabel: 'Weight',
          title: 'Weight Check',
          at: w.time == null ? w.date : _withTime(w.date, w.time!),
          hasTime: w.time != null,
          detail: '${w.value == w.value.roundToDouble() ? w.value.toStringAsFixed(0) : w.value} ${w.unit}',
          notes: w.notes,
          open: (_) => WeightRecordsScreen(dogName: dg),
        ));
      }
      for (final b in HealthStore.instance.bcs(dg)) {
        out.add(TimelineEvent(
          id: 'bcs:${b.id}',
          dog: dg,
          category: 'Health',
          typeLabel: 'Body Condition',
          title: 'Body Condition Score',
          at: b.date,
          hasTime: false,
          detail: '${b.score} / 9',
          notes: b.notes,
          open: (_) => BodyConditionScreen(dogName: dg),
        ));
      }
      for (final l in HealthStore.instance.allLogs(dg)) {
        final cfg = allHealthConfigs.where((c) => c.area == l.area).firstOrNull;
        if (cfg == null) continue;
        out.add(TimelineEvent(
          id: 'health:${l.id}',
          dog: dg,
          category: 'Health',
          typeLabel: cfg.noun,
          title: l.title.isNotEmpty ? l.title : cfg.noun,
          at: l.date,
          hasTime: false,
          notes: l.notes,
          linkKey: 'health:${l.id}',
          open: (_) => healthLogDetails(dg, cfg, l.id),
        ));
      }
    }

    for (final m in _milestones.where((m) => dogs.contains(m.dog))) {
      out.add(TimelineEvent(
        id: 'milestone:${m.id}',
        dog: m.dog,
        category: 'Milestones',
        typeLabel: 'Milestone',
        title: m.title,
        at: m.time == null ? m.date : _withTime(m.date, m.time!),
        hasTime: m.time != null,
        notes: m.notes,
        open: (_) => MilestoneDetailsScreen(milestoneId: m.id),
      ));
    }
    return out;
  }

  /// Active (not archived) events.
  List<TimelineEvent> events({String? dog}) => allEvents(dog: dog).where((e) => !_archived.containsKey(e.id)).toList();

  /// Number of media items attached to an event's record.
  int mediaCount(TimelineEvent e) {
    if (e.linkKey.isEmpty) return 0;
    return MediaStore.instance.items(e.dog).where((i) => i.links.any((l) => l.key == e.linkKey)).length;
  }

  static String _dur(int m) {
    final h = m ~/ 60, r = m % 60;
    return h == 0 ? '${m}m' : (r == 0 ? '${h}h' : '${h}h ${r}m');
  }

  static DateTime _withTime(DateTime d, String hhmm) {
    final p = hhmm.split(':');
    final h = int.tryParse(p.first) ?? 0;
    final m = p.length > 1 ? int.tryParse(p[1]) ?? 0 : 0;
    return DateTime(d.year, d.month, d.day, h, m);
  }

  static String timeLabel(TimelineEvent e) => e.hasTime ? '${_two(e.at.hour)}:${_two(e.at.minute)}' : '';


  // ── Persistence ─────────────────────────────────────────────────────────
  bool _loading = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (!_loading) _save();
  }

  void _save() => Persist.write('store.timeline', {
        'favourites': _favourites.toList(),
        'archived': [for (final a in _archived.values) {'id': a.eventId, 'dog': a.dog, 'category': a.category, 'title': a.title, 'date': a.date.toIso8601String(), 'at': a.archivedAt.toIso8601String()}],
        'collections': [for (final c in _collections) {'id': c.id, 'name': c.name, 'type': c.type, 'media': c.mediaOnly, 'min': c.minMinutes, 'pinned': c.pinned, 'archived': c.archived}],
        'pinnedBuiltIns': _pinnedBuiltIns.toList(),
        'milestones': [for (final m in _milestones) {'id': m.id, 'dog': m.dog, 'title': m.title, 'date': m.date.toIso8601String(), 'time': m.time, 'notes': m.notes, 'attachments': m.attachments}],
      });

  Future<void> load() async {
    final j = await Persist.read('store.timeline');
    if (j is! Map) return;
    _loading = true;
    try {
      _favourites
        ..clear()
        ..addAll([for (final x in (j['favourites'] as List? ?? [])) '$x']);
      _archived
        ..clear()
        ..addAll({
          for (final m in (j['archived'] as List? ?? []).cast<Map>())
            m['id'] as String: ArchivedRef(m['id'], m['dog'], m['category'], m['title'], DateTime.parse(m['date']), DateTime.parse(m['at']))
        });
      _collections
        ..clear()
        ..addAll([
          for (final m in (j['collections'] as List? ?? []).cast<Map>())
            SmartCollection(id: m['id'], name: m['name'], type: m['type'] ?? 'All Record Types', mediaOnly: m['media'] ?? false, minMinutes: m['min'], pinned: m['pinned'] ?? false, archived: m['archived'] ?? false)
        ]);
      _pinnedBuiltIns
        ..clear()
        ..addAll([for (final x in (j['pinnedBuiltIns'] as List? ?? [])) '$x']);
      _milestones
        ..clear()
        ..addAll([
          for (final m in (j['milestones'] as List? ?? []).cast<Map>())
            Milestone(id: m['id'], dog: m['dog'], title: m['title'], date: DateTime.parse(m['date']), time: m['time'], notes: m['notes'] ?? '', attachments: [for (final a in (m['attachments'] as List? ?? [])) '$a'])
        ]);
    } catch (_) {
    } finally {
      _loading = false;
      super.notifyListeners();
    }
  }

}
