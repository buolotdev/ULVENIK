import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Trainer Pack client data. Everything here is entered by the trainer; there
/// are no sample clients. Saved on the device. Trainer notes are private and
/// are never part of anything shown to or shared with a client.
class TrainerClient {
  final String id;
  String name;
  String email;
  String phone;
  List<String> dogs;
  DateTime clientSince;
  bool active; // false = Inactive
  bool archived;
  bool pinned;
  TrainerClient({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    List<String>? dogs,
    DateTime? clientSince,
    this.active = true,
    this.archived = false,
    this.pinned = false,
  })  : dogs = dogs ?? [],
        clientSince = clientSince ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'dogs': dogs,
        'since': clientSince.toIso8601String(),
        'active': active,
        'archived': archived,
        'pinned': pinned,
      };
  factory TrainerClient.fromJson(Map<String, dynamic> j) => TrainerClient(
        id: j['id'] as String,
        name: j['name'] as String,
        email: (j['email'] as String?) ?? '',
        phone: (j['phone'] as String?) ?? '',
        dogs: [for (final d in (j['dogs'] as List? ?? [])) d as String],
        clientSince: DateTime.tryParse((j['since'] as String?) ?? ''),
        active: (j['active'] as bool?) ?? true,
        archived: (j['archived'] as bool?) ?? false,
        pinned: (j['pinned'] as bool?) ?? false,
      );
}

const kHomeworkProgress = ['Not started', 'In progress', 'Completed'];

class Homework {
  final String id;
  final String clientId;
  String dog;
  String title;
  String instructions;
  DateTime? due;
  String progress; // Not started | In progress | Completed
  bool assigned; // false = draft
  final DateTime createdAt;
  Homework({
    required this.id,
    required this.clientId,
    required this.dog,
    required this.title,
    this.instructions = '',
    this.due,
    this.progress = 'Not started',
    this.assigned = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get outstanding => assigned && progress != 'Completed';

  /// Timing is separate from progress: overdue never replaces progress.
  String get timing {
    if (due == null) return 'No due date';
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    final d = DateTime(due!.year, due!.month, due!.day);
    final diff = d.difference(today).inDays;
    if (progress != 'Completed' && diff < 0) return 'Overdue';
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    return 'Due ${d.day}/${d.month}/${d.year}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'dog': dog,
        'title': title,
        'instructions': instructions,
        'due': due?.toIso8601String(),
        'progress': progress,
        'assigned': assigned,
        'created': createdAt.toIso8601String(),
      };
  factory Homework.fromJson(Map<String, dynamic> j) => Homework(
        id: j['id'] as String,
        clientId: j['clientId'] as String,
        dog: (j['dog'] as String?) ?? '',
        title: j['title'] as String,
        instructions: (j['instructions'] as String?) ?? '',
        due: DateTime.tryParse((j['due'] as String?) ?? ''),
        progress: (j['progress'] as String?) ?? 'Not started',
        assigned: (j['assigned'] as bool?) ?? true,
        createdAt: DateTime.tryParse((j['created'] as String?) ?? ''),
      );
}

class TrainerNote {
  final String id;
  final String clientId;
  String text;
  final DateTime at;
  TrainerNote({required this.id, required this.clientId, required this.text, DateTime? at}) : at = at ?? DateTime.now();

  Map<String, dynamic> toJson() => {'id': id, 'clientId': clientId, 'text': text, 'at': at.toIso8601String()};
  factory TrainerNote.fromJson(Map<String, dynamic> j) => TrainerNote(
      id: j['id'] as String,
      clientId: j['clientId'] as String,
      text: j['text'] as String,
      at: DateTime.tryParse((j['at'] as String?) ?? ''));
}

/// What a trainer may do with one client's records. Only actions the trainer
/// is entitled to configure live here; owner-controlled data (health) and
/// private trainer notes are never granted through these switches.
class AccessGrant {
  String preset; // Read Only | Training & Homework | Custom
  Set<String> grants;
  final List<AccessChange> history;
  AccessGrant({this.preset = 'Read Only', Set<String>? grants, List<AccessChange>? history})
      : grants = grants ?? {},
        history = history ?? [];

  Map<String, dynamic> toJson() =>
      {'preset': preset, 'grants': grants.toList(), 'history': [for (final h in history) h.toJson()]};
  factory AccessGrant.fromJson(Map<String, dynamic> j) => AccessGrant(
        preset: (j['preset'] as String?) ?? 'Read Only',
        grants: {for (final g in (j['grants'] as List? ?? [])) g as String},
        history: [for (final h in (j['history'] as List? ?? [])) AccessChange.fromJson(h as Map<String, dynamic>)],
      );
}

class AccessChange {
  final String actor;
  final String summary;
  final DateTime at;
  AccessChange(this.actor, this.summary, this.at);
  Map<String, dynamic> toJson() => {'actor': actor, 'summary': summary, 'at': at.toIso8601String()};
  factory AccessChange.fromJson(Map<String, dynamic> j) =>
      AccessChange((j['actor'] as String?) ?? '', (j['summary'] as String?) ?? '', DateTime.tryParse((j['at'] as String?) ?? '') ?? DateTime.now());
}

/// The trainer's one saved business identity. Nothing is pre-filled and no
/// verified/accredited status is ever inferred from what is entered.
class TrainerProfile {
  TrainerProfile();
  String businessName = '';
  String trainerName = ''; // empty = use the saved personal name
  String bio = '';
  String email = '';
  String instagram = '';
  String website = '';
  String photoPath = '';
  String coverPath = '';
  List<String> expertise = [];
  List<Map<String, String>> qualifications = []; // title, org, awarded, expires
  List<Map<String, String>> services = []; // name, description, duration, amount, currency, basis, enquiry

  Map<String, dynamic> toJson() => {
        'businessName': businessName,
        'trainerName': trainerName,
        'bio': bio,
        'email': email,
        'instagram': instagram,
        'website': website,
        'photoPath': photoPath,
        'coverPath': coverPath,
        'expertise': expertise,
        'qualifications': qualifications,
        'services': services,
      };

  static List<Map<String, String>> _maps(dynamic v) => [
        for (final m in (v as List? ?? [])) {for (final e in (m as Map).entries) e.key as String: '${e.value}'},
      ];

  factory TrainerProfile.fromJson(Map<String, dynamic> j) => TrainerProfile()
    ..businessName = (j['businessName'] as String?) ?? ''
    ..trainerName = (j['trainerName'] as String?) ?? ''
    ..bio = (j['bio'] as String?) ?? ''
    ..email = (j['email'] as String?) ?? ''
    ..instagram = (j['instagram'] as String?) ?? ''
    ..website = (j['website'] as String?) ?? ''
    ..photoPath = (j['photoPath'] as String?) ?? ''
    ..coverPath = (j['coverPath'] as String?) ?? ''
    ..expertise = [for (final e in (j['expertise'] as List? ?? [])) e as String]
    ..qualifications = _maps(j['qualifications'])
    ..services = _maps(j['services']);
}

class TrainerStore extends ChangeNotifier {
  TrainerStore._();
  static final TrainerStore instance = TrainerStore._();

  final List<TrainerClient> _clients = [];
  final List<Homework> _homework = [];
  final List<TrainerNote> _notes = [];
  final Map<String, AccessGrant> _access = {};
  TrainerProfile profile = TrainerProfile();
  SharedPreferences? _p;
  int _seq = 0;

  String newId() => 'tr${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  Future<void> load() async {
    try {
      _p = await SharedPreferences.getInstance();
      _clients
        ..clear()
        ..addAll([for (final j in jsonDecode(_p!.getString('trainer.clients') ?? '[]') as List) TrainerClient.fromJson(j as Map<String, dynamic>)]);
      _homework
        ..clear()
        ..addAll([for (final j in jsonDecode(_p!.getString('trainer.homework') ?? '[]') as List) Homework.fromJson(j as Map<String, dynamic>)]);
      _notes
        ..clear()
        ..addAll([for (final j in jsonDecode(_p!.getString('trainer.notes') ?? '[]') as List) TrainerNote.fromJson(j as Map<String, dynamic>)]);
      try {
        profile = TrainerProfile.fromJson(jsonDecode(_p!.getString('trainer.profile') ?? '{}') as Map<String, dynamic>);
      } catch (_) {
        profile = TrainerProfile();
      }
      _access
        ..clear()
        ..addAll({
          for (final e in (jsonDecode(_p!.getString('trainer.access') ?? '{}') as Map<String, dynamic>).entries)
            e.key: AccessGrant.fromJson(e.value as Map<String, dynamic>),
        });
    } catch (_) {}
  }

  Future<bool> saveProfile() {
    notifyListeners();
    return _persist();
  }

  AccessGrant access(String clientId) => _access.putIfAbsent(clientId, () => AccessGrant(grants: {...kPresetGrants['Read Only']!}));

  Future<bool> saveAccess(String clientId, AccessGrant g) {
    _access[clientId] = g;
    notifyListeners();
    return _persist();
  }

  Future<bool> _persist() async {
    try {
      final p = _p ?? await SharedPreferences.getInstance();
      _p = p;
      final a = await p.setString('trainer.clients', jsonEncode([for (final c in _clients) c.toJson()]));
      final b = await p.setString('trainer.homework', jsonEncode([for (final h in _homework) h.toJson()]));
      final c = await p.setString('trainer.notes', jsonEncode([for (final n in _notes) n.toJson()]));
      final d = await p.setString('trainer.access', jsonEncode({for (final e in _access.entries) e.key: e.value.toJson()}));
      final e = await p.setString('trainer.profile', jsonEncode(profile.toJson()));
      return a && b && c && d && e;
    } catch (_) {
      return false;
    }
  }

  // ── Clients ─────────────────────────────────────────────────────────────
  List<TrainerClient> clients() => List.of(_clients);
  TrainerClient? client(String id) => _clients.where((c) => c.id == id).firstOrNull;

  Future<bool> saveClient(TrainerClient c) {
    if (!_clients.any((x) => x.id == c.id)) _clients.add(c);
    notifyListeners();
    return _persist();
  }

  Future<bool> touchClient() {
    notifyListeners();
    return _persist();
  }

  // ── Homework ────────────────────────────────────────────────────────────
  List<Homework> homework(String clientId) {
    final l = _homework.where((h) => h.clientId == clientId).toList();
    l.sort((a, b) {
      if (a.outstanding != b.outstanding) return a.outstanding ? -1 : 1;
      final ad = a.due, bd = b.due;
      if (ad != null && bd != null) return ad.compareTo(bd);
      if (ad != null) return -1;
      if (bd != null) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return l;
  }

  int outstandingCount(String clientId) => _homework.where((h) => h.clientId == clientId && h.outstanding).length;

  Future<bool> saveHomework(Homework h) {
    if (!_homework.any((x) => x.id == h.id)) _homework.add(h);
    notifyListeners();
    return _persist();
  }

  Future<bool> deleteHomework(String id) {
    _homework.removeWhere((h) => h.id == id);
    notifyListeners();
    return _persist();
  }

  // ── Notes (private) ─────────────────────────────────────────────────────
  List<TrainerNote> notes(String clientId) =>
      _notes.where((n) => n.clientId == clientId).toList()..sort((a, b) => b.at.compareTo(a.at));

  Future<bool> addNote(TrainerNote n) {
    _notes.add(n);
    notifyListeners();
    return _persist();
  }

  Future<bool> deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    return _persist();
  }
}

/// Permission catalogue: section -> (key, label, helper). View always comes
/// first; the other actions depend on it.
const kAccessSections = <String, List<(String, String, String?)>>{
  'Dog Profile': [('profile.view', 'View dog profiles', null)],
  'Training': [
    ('training.view', 'View training sessions', null),
    ('training.add', 'Add training sessions', null),
    ('training.edit', 'Edit training sessions', null),
    ('training.delete', 'Delete training sessions', 'Only sessions you created.'),
  ],
  'S&C': [
    ('sc.view', 'View S&C sessions', null),
    ('sc.add', 'Add S&C sessions', null),
    ('sc.edit', 'Edit S&C sessions', null),
    ('sc.delete', 'Delete S&C sessions', 'Only sessions you created.'),
  ],
  'Goals': [
    ('goals.view', 'View goals', null),
    ('goals.add', 'Add goals', null),
    ('goals.edit', 'Edit goals', null),
    ('goals.achieve', 'Mark goals achieved', null),
  ],
  'Homework': [
    ('homework.view', 'View homework', null),
    ('homework.add', 'Assign homework', null),
    ('homework.edit', 'Edit homework', null),
  ],
  'Media': [
    ('media.view', 'View photos, videos and documents', null),
    ('media.add', 'Add photos, videos and documents', null),
  ],
  'Reports': [('reports.view', 'View reports', 'Reports are calculated from records you can already view.')],
  'Shared Notes': [
    ('notes.view', 'View shared notes', 'Private trainer notes are never shared.'),
    ('notes.add', 'Add shared notes', null),
  ],
};

/// Owner-controlled data: a trainer cannot grant this to themselves.
const kOwnerControlled = ['Health'];

const kPresetGrants = <String, Set<String>>{
  'Read Only': {
    'profile.view', 'training.view', 'sc.view', 'goals.view', 'homework.view', 'media.view', 'reports.view', 'notes.view',
  },
  'Training & Homework': {
    'profile.view', 'training.view', 'training.add', 'training.edit', 'sc.view', 'sc.add', 'sc.edit', 'goals.view',
    'homework.view', 'homework.add', 'homework.edit', 'media.view', 'media.add', 'reports.view', 'notes.view', 'notes.add',
  },
};
