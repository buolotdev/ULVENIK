import 'package:flutter/foundation.dart';
import 'persist.dart';
import '../widgets/session_rating.dart';

/// Sport Pack data, per dog. Everything is user-created: no preset sports,
/// skills, exercises or competitions. In-memory until a backend exists.
class Sport {
  final String id;
  String name;
  String description;
  String notes;
  bool archived;
  bool deleted; // removed from lists; past sessions/competitions keep its name
  Sport({
    required this.id,
    required this.name,
    this.description = '',
    this.notes = '',
    this.archived = false,
    this.deleted = false,
  });
}

enum SportItemKind { skill, exercise }

class SportItem {
  final String id;
  final String sportId;
  final SportItemKind kind;
  String name;
  String description;
  bool linked; // linked from Core Training, not created here
  bool archived;
  bool deleted;
  SportItem({
    required this.id,
    required this.sportId,
    required this.kind,
    required this.name,
    this.description = '',
    this.linked = false,
    this.archived = false,
    this.deleted = false,
  });
  String get kindLabel => kind == SportItemKind.skill ? 'Skill' : 'Exercise';
}

/// One sport inside a session, with the skills/exercises worked under it and
/// optional time attributed to it. Names are copied so history stays correct.
class SportEntry {
  final String sportId;
  final String sportName;
  final List<String> itemIds;
  final List<String> itemNames;
  final int? minutes; // only when the user attributed time to this sport
  const SportEntry(this.sportId, this.sportName, this.itemIds, this.itemNames, this.minutes);
}

class SportSession {
  final String id;
  String name;
  DateTime at;
  int? durationMinutes; // one optional duration for the whole session
  List<SportEntry> entries;
  List<String> rewards;
  List<String> equipment;
  String notes;
  List<String> media;
  SessionRating? rating;
  SportSession({
    required this.id,
    required this.name,
    required this.at,
    this.durationMinutes,
    List<SportEntry>? entries,
    List<String>? rewards,
    List<String>? equipment,
    this.notes = '',
    List<String>? media,
    this.rating,
  })  : entries = entries ?? [],
        rewards = rewards ?? [],
        equipment = equipment ?? [],
        media = media ?? [];

  bool involves(String sportId) => entries.any((e) => e.sportId == sportId);

  /// Time attributed to [sportId]: the whole session duration when only that
  /// sport was trained, otherwise only what the user entered for it. Never
  /// divided or multiplied between sports.
  int? minutesFor(String sportId) {
    if (!involves(sportId)) return null;
    if (entries.length == 1) return durationMinutes;
    return entries.firstWhere((e) => e.sportId == sportId).minutes;
  }
}

class CompetitionResult {
  String label;
  String value;
  CompetitionResult(this.label, this.value);
}

class Competition {
  final String id;
  String name;
  String sportId;
  String sportName;
  DateTime date;
  String location;
  String organisation;
  String level;
  String result;
  String placement;
  String judge;
  String notes;
  List<CompetitionResult> custom;
  List<String> files;
  String? reminder; // null = off; otherwise the chosen timing
  String status; // Upcoming | Completed | Withdrawn | Cancelled
  bool archived;
  Competition({
    required this.id,
    required this.name,
    required this.sportId,
    required this.sportName,
    required this.date,
    this.location = '',
    this.organisation = '',
    this.level = '',
    this.result = '',
    this.placement = '',
    this.judge = '',
    this.notes = '',
    List<CompetitionResult>? custom,
    List<String>? files,
    this.reminder,
    this.status = 'Upcoming',
    this.archived = false,
  })  : custom = custom ?? [],
        files = files ?? [];

  /// An upcoming event: status Upcoming and the date has not passed.
  bool get isUpcoming {
    final n = DateTime.now();
    return status == 'Upcoming' && !date.isBefore(DateTime(n.year, n.month, n.day));
  }

  /// A passed date does not prove the event happened, so it asks for review.
  bool get needsReview {
    final n = DateTime.now();
    return status == 'Upcoming' && date.isBefore(DateTime(n.year, n.month, n.day));
  }
}

class SportStore extends ChangeNotifier {
  SportStore._();
  static final SportStore instance = SportStore._();

  final Map<String, List<Sport>> _sports = {};
  final Map<String, List<SportItem>> _items = {};
  final Map<String, List<SportSession>> _sessions = {};
  final Map<String, List<Competition>> _competitions = {};
  int _seq = 0;
  String newId() => 'sp${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  // ── Sports ──────────────────────────────────────────────────────────────
  List<Sport> sports(String dog, {bool archived = false}) =>
      (_sports[dog] ?? const <Sport>[]).where((s) => !s.deleted && s.archived == archived).toList();

  Sport? sport(String dog, String id) {
    for (final s in _sports[dog] ?? const <Sport>[]) {
      if (s.id == id) return s;
    }
    return null;
  }

  void saveSport(String dog, Sport s) {
    final l = _sports.putIfAbsent(dog, () => []);
    if (!l.any((x) => x.id == s.id)) l.add(s);
    notifyListeners();
  }

  void setSportArchived(String dog, String id, bool v) {
    sport(dog, id)?.archived = v;
    notifyListeners();
  }

  /// Removes the sport from lists only; sessions and competitions stay.
  void deleteSport(String dog, String id) {
    sport(dog, id)?.deleted = true;
    notifyListeners();
  }

  // ── Skills & exercises ──────────────────────────────────────────────────
  List<SportItem> items(String dog, String sportId, {SportItemKind? kind, bool archived = false}) =>
      (_items[dog] ?? const <SportItem>[])
          .where((i) =>
              i.sportId == sportId && !i.deleted && i.archived == archived && (kind == null || i.kind == kind))
          .toList();

  SportItem? item(String dog, String id) {
    for (final i in _items[dog] ?? const <SportItem>[]) {
      if (i.id == id) return i;
    }
    return null;
  }

  void saveItem(String dog, SportItem i) {
    final l = _items.putIfAbsent(dog, () => []);
    if (!l.any((x) => x.id == i.id)) l.add(i);
    notifyListeners();
  }

  void setItemArchived(String dog, String id, bool v) {
    item(dog, id)?.archived = v;
    notifyListeners();
  }

  void deleteItem(String dog, String id) {
    item(dog, id)?.deleted = true;
    notifyListeners();
  }

  // ── Sessions ────────────────────────────────────────────────────────────
  /// All of the dog's sport sessions, newest first by session date. One record
  /// per session however many sports it involves.
  List<SportSession> sessions(String dog, {String? sportId}) {
    final l = (_sessions[dog] ?? const <SportSession>[]).where((s) => sportId == null || s.involves(sportId)).toList();
    l.sort((a, b) => b.at.compareTo(a.at));
    return l;
  }

  SportSession? session(String dog, String id) {
    for (final s in _sessions[dog] ?? const <SportSession>[]) {
      if (s.id == id) return s;
    }
    return null;
  }

  void saveSession(String dog, SportSession s) {
    final l = _sessions.putIfAbsent(dog, () => []);
    if (!l.any((x) => x.id == s.id)) l.add(s);
    notifyListeners();
  }

  void deleteSession(String dog, String id) {
    _sessions[dog]?.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ── Competitions ────────────────────────────────────────────────────────
  List<Competition> competitions(String dog, {String? sportId, bool archived = false}) =>
      (_competitions[dog] ?? const <Competition>[])
          .where((c) => c.archived == archived && (sportId == null || c.sportId == sportId))
          .toList();

  Competition? competition(String dog, String id) {
    for (final c in _competitions[dog] ?? const <Competition>[]) {
      if (c.id == id) return c;
    }
    return null;
  }

  void saveCompetition(String dog, Competition c) {
    final l = _competitions.putIfAbsent(dog, () => []);
    if (!l.any((x) => x.id == c.id)) l.add(c);
    notifyListeners();
  }

  void deleteCompetition(String dog, String id) {
    _competitions[dog]?.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void touch() => notifyListeners();

  // ── Persistence ─────────────────────────────────────────────────────────
  bool _loading = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (!_loading) _save();
  }

  void _save() => Persist.write('store.sport', {
        'sports': {for (final e in _sports.entries) e.key: [for (final s in e.value) {'id': s.id, 'name': s.name, 'description': s.description, 'notes': s.notes, 'archived': s.archived, 'deleted': s.deleted}]},
        'items': {for (final e in _items.entries) e.key: [for (final i in e.value) {'id': i.id, 'sportId': i.sportId, 'kind': i.kind.name, 'name': i.name, 'description': i.description, 'linked': i.linked, 'archived': i.archived, 'deleted': i.deleted}]},
        'sessions': {
          for (final e in _sessions.entries)
            e.key: [
              for (final s in e.value)
                {
                  'id': s.id, 'name': s.name, 'at': s.at.toIso8601String(), 'duration': s.durationMinutes,
                  'entries': [for (final en in s.entries) {'sportId': en.sportId, 'sportName': en.sportName, 'itemIds': en.itemIds, 'itemNames': en.itemNames, 'minutes': en.minutes}],
                  'rewards': s.rewards, 'equipment': s.equipment, 'notes': s.notes, 'media': s.media, 'rating': s.rating?.name,
                }
            ]
        },
        'competitions': {
          for (final e in _competitions.entries)
            e.key: [
              for (final c in e.value)
                {
                  'id': c.id, 'name': c.name, 'sportId': c.sportId, 'sportName': c.sportName, 'date': c.date.toIso8601String(),
                  'location': c.location, 'organisation': c.organisation, 'level': c.level, 'result': c.result, 'placement': c.placement,
                  'judge': c.judge, 'notes': c.notes, 'custom': [for (final r in c.custom) {'l': r.label, 'v': r.value}],
                  'files': c.files, 'reminder': c.reminder, 'status': c.status, 'archived': c.archived,
                }
            ]
        },
      });

  Future<void> load() async {
    final j = await Persist.read('store.sport');
    if (j is! Map) return;
    _loading = true;
    try {
      List<Map> L(Object? v) => [for (final x in (v as List? ?? [])) x as Map];
      Map<String, List<T>> M<T>(Object? v, T Function(Map) f) =>
          {for (final e in ((v as Map?) ?? {}).entries) e.key as String: [for (final x in L(e.value)) f(x)]};
      List<String> S(Object? v) => [for (final x in (v as List? ?? [])) '$x'];
      _sports
        ..clear()
        ..addAll(M(j['sports'], (m) => Sport(id: m['id'], name: m['name'], description: m['description'] ?? '', notes: m['notes'] ?? '', archived: m['archived'] ?? false, deleted: m['deleted'] ?? false)));
      _items
        ..clear()
        ..addAll(M(j['items'], (m) => SportItem(id: m['id'], sportId: m['sportId'], kind: SportItemKind.values.firstWhere((k) => k.name == m['kind']), name: m['name'], description: m['description'] ?? '', linked: m['linked'] ?? false, archived: m['archived'] ?? false, deleted: m['deleted'] ?? false)));
      _sessions
        ..clear()
        ..addAll(M(j['sessions'], (m) => SportSession(
              id: m['id'], name: m['name'], at: DateTime.parse(m['at']), durationMinutes: m['duration'],
              entries: [for (final en in L(m['entries'])) SportEntry(en['sportId'], en['sportName'], S(en['itemIds']), S(en['itemNames']), en['minutes'])],
              rewards: S(m['rewards']), equipment: S(m['equipment']), notes: m['notes'] ?? '', media: S(m['media']),
              rating: m['rating'] == null ? null : SessionRating.values.firstWhere((r) => r.name == m['rating'], orElse: () => SessionRating.good),
            )));
      _competitions
        ..clear()
        ..addAll(M(j['competitions'], (m) => Competition(
              id: m['id'], name: m['name'], sportId: m['sportId'], sportName: m['sportName'] ?? '', date: DateTime.parse(m['date']),
              location: m['location'] ?? '', organisation: m['organisation'] ?? '', level: m['level'] ?? '', result: m['result'] ?? '',
              placement: m['placement'] ?? '', judge: m['judge'] ?? '', notes: m['notes'] ?? '',
              custom: [for (final r in L(m['custom'])) CompetitionResult('${r['l']}', '${r['v']}')],
              files: S(m['files']), reminder: m['reminder'], status: m['status'] ?? 'Upcoming', archived: m['archived'] ?? false,
            )));
    } catch (_) {
    } finally {
      _loading = false;
      super.notifyListeners();
    }
  }

}
