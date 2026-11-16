import 'package:flutter/foundation.dart';
import 'persist.dart';
import '../widgets/session_rating.dart';

/// Strength & Conditioning data, kept per dog. No preloaded activities:
/// everything here is created by the user. In-memory until a backend exists.
enum SCMeasure { reps, sets, duration, distance, weight }

extension SCMeasureX on SCMeasure {
  String get label => switch (this) {
        SCMeasure.reps => 'Repetitions',
        SCMeasure.sets => 'Sets',
        SCMeasure.duration => 'Duration',
        SCMeasure.distance => 'Distance',
        SCMeasure.weight => 'Resistance / Weight',
      };

  /// Units the user can choose from. Repetitions and Sets are simple counts.
  List<String> get units => switch (this) {
        SCMeasure.reps || SCMeasure.sets => const [],
        SCMeasure.duration => const ['sec', 'min', 'hr'],
        SCMeasure.distance => const ['m', 'km', 'ft', 'yd', 'mi'],
        SCMeasure.weight => const ['kg', 'lb'],
      };
}

class SCActivity {
  final String id;
  String name;
  String description;
  Set<SCMeasure> measures;
  Map<SCMeasure, String> units; // user-selected unit per measure
  bool archived;
  bool deleted; // removed from the library; history keeps the name
  SCActivity({
    required this.id,
    required this.name,
    this.description = '',
    Set<SCMeasure>? measures,
    Map<SCMeasure, String>? units,
    this.archived = false,
    this.deleted = false,
  })  : measures = measures ?? {},
        units = units ?? {};
}

class SCValue {
  final double value;
  final String unit; // '' for counts
  const SCValue(this.value, this.unit);
}

/// One activity inside a session, with the values entered for it. Values keep
/// their own unit and the activity name so history stays accurate even if the
/// activity is later edited or deleted.
class SCEntry {
  final String activityId;
  final String activityName;
  final Map<SCMeasure, SCValue> values;
  const SCEntry(this.activityId, this.activityName, this.values);
}

class SCSession {
  final String id;
  String name;
  DateTime at;
  int? durationMinutes; // total session duration, only when recorded
  List<SCEntry> entries;
  List<String> rewards;
  List<String> equipment;
  String notes;
  List<String> media;
  SessionRating? rating;
  SCSession({
    required this.id,
    required this.name,
    required this.at,
    this.durationMinutes,
    List<SCEntry>? entries,
    List<String>? rewards,
    List<String>? equipment,
    this.notes = '',
    List<String>? media,
    this.rating,
  })  : entries = entries ?? [],
        rewards = rewards ?? [],
        equipment = equipment ?? [],
        media = media ?? [];
}

class SCStore extends ChangeNotifier {
  SCStore._();
  static final SCStore instance = SCStore._();

  final Map<String, List<SCActivity>> _activities = {};
  final Map<String, List<SCSession>> _sessions = {};
  int _seq = 0;
  String newId() => 'sc${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  // ── Activities ──────────────────────────────────────────────────────────
  List<SCActivity> activities(String dog, {bool archived = false}) =>
      (_activities[dog] ?? const <SCActivity>[]).where((a) => !a.deleted && a.archived == archived).toList();

  SCActivity? activity(String dog, String id) {
    for (final a in _activities[dog] ?? const <SCActivity>[]) {
      if (a.id == id) return a;
    }
    return null;
  }

  void saveActivity(String dog, SCActivity a) {
    final l = _activities.putIfAbsent(dog, () => []);
    if (!l.any((x) => x.id == a.id)) l.add(a);
    notifyListeners();
  }

  void setArchived(String dog, String id, bool v) {
    activity(dog, id)?.archived = v;
    notifyListeners();
  }

  /// Removes the activity from the library only; sessions keep their records.
  void deleteActivity(String dog, String id) {
    activity(dog, id)?.deleted = true;
    notifyListeners();
  }

  // ── Sessions ────────────────────────────────────────────────────────────
  List<SCSession> sessions(String dog) {
    final l = List<SCSession>.from(_sessions[dog] ?? const []);
    l.sort((a, b) => b.at.compareTo(a.at));
    return l;
  }

  SCSession? session(String dog, String id) {
    for (final s in _sessions[dog] ?? const <SCSession>[]) {
      if (s.id == id) return s;
    }
    return null;
  }

  void saveSession(String dog, SCSession s) {
    final l = _sessions.putIfAbsent(dog, () => []);
    if (!l.any((x) => x.id == s.id)) l.add(s);
    notifyListeners();
  }

  void deleteSession(String dog, String id) {
    _sessions[dog]?.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ── Derived, per activity ───────────────────────────────────────────────
  List<SCSession> sessionsFor(String dog, String activityId) =>
      sessions(dog).where((s) => s.entries.any((e) => e.activityId == activityId)).toList();

  int sessionCount(String dog, String activityId) => sessionsFor(dog, activityId).length;

  DateTime? lastTrained(String dog, String activityId) {
    final l = sessionsFor(dog, activityId);
    return l.isEmpty ? null : l.first.at;
  }

  // ── Persistence ─────────────────────────────────────────────────────────
  bool _loading = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (!_loading) _save();
  }

  void _save() => Persist.write('store.sc', {
        'activities': {
          for (final e in _activities.entries)
            e.key: [for (final a in e.value) {'id': a.id, 'name': a.name, 'description': a.description, 'measures': [for (final m in a.measures) m.name], 'units': {for (final u in a.units.entries) u.key.name: u.value}, 'archived': a.archived, 'deleted': a.deleted}]
        },
        'sessions': {
          for (final e in _sessions.entries)
            e.key: [
              for (final s in e.value)
                {
                  'id': s.id, 'name': s.name, 'at': s.at.toIso8601String(), 'duration': s.durationMinutes,
                  'entries': [for (final en in s.entries) {'id': en.activityId, 'name': en.activityName, 'values': {for (final v in en.values.entries) v.key.name: {'v': v.value.value, 'u': v.value.unit}}}],
                  'rewards': s.rewards, 'equipment': s.equipment, 'notes': s.notes, 'media': s.media, 'rating': s.rating?.name,
                }
            ]
        },
      });

  Future<void> load() async {
    final j = await Persist.read('store.sc');
    if (j is! Map) return;
    _loading = true;
    try {
      SCMeasure meas(String n) => SCMeasure.values.firstWhere((m) => m.name == n);
      _activities
        ..clear()
        ..addAll({
          for (final e in ((j['activities'] as Map?) ?? {}).entries)
            e.key as String: [
              for (final m in (e.value as List).cast<Map>())
                SCActivity(
                  id: m['id'], name: m['name'], description: m['description'] ?? '',
                  measures: {for (final x in (m['measures'] as List? ?? [])) meas('$x')},
                  units: {for (final u in ((m['units'] as Map?) ?? {}).entries) meas('${u.key}'): '${u.value}'},
                  archived: m['archived'] ?? false, deleted: m['deleted'] ?? false,
                )
            ]
        });
      _sessions
        ..clear()
        ..addAll({
          for (final e in ((j['sessions'] as Map?) ?? {}).entries)
            e.key as String: [
              for (final m in (e.value as List).cast<Map>())
                SCSession(
                  id: m['id'], name: m['name'], at: DateTime.parse(m['at']), durationMinutes: m['duration'],
                  entries: [
                    for (final en in (m['entries'] as List).cast<Map>())
                      SCEntry(en['id'], en['name'], {for (final v in ((en['values'] as Map?) ?? {}).entries) meas('${v.key}'): SCValue(((v.value as Map)['v'] as num).toDouble(), '${(v.value as Map)['u'] ?? ''}')})
                  ],
                  rewards: [for (final x in (m['rewards'] as List? ?? [])) '$x'],
                  equipment: [for (final x in (m['equipment'] as List? ?? [])) '$x'],
                  notes: m['notes'] ?? '',
                  media: [for (final x in (m['media'] as List? ?? [])) '$x'],
                  rating: m['rating'] == null ? null : SessionRating.values.firstWhere((r) => r.name == m['rating'], orElse: () => SessionRating.good),
                )
            ]
        });
    } catch (_) {
    } finally {
      _loading = false;
      super.notifyListeners();
    }
  }

}
