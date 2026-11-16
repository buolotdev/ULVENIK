import 'package:flutter/foundation.dart';
import 'persist.dart';

/// In-memory Health data, kept per dog so one dog's records never appear on
/// another dog's profile. Demo data only until a backend exists.
class WeightEntry {
  final String id;
  DateTime date;
  double value;
  String unit; // 'kg' | 'lb' — the unit the record was entered in
  String? time;
  String notes;
  WeightEntry({
    required this.id,
    required this.date,
    required this.value,
    this.unit = 'kg',
    this.time,
    this.notes = '',
  });
  double get kg => unit == 'lb' ? value * 0.45359237 : value;
}

class BcsEntry {
  final String id;
  DateTime date;
  int score; // 1..9
  String notes;
  BcsEntry({required this.id, required this.date, required this.score, this.notes = ''});
}

enum ReminderType { medication, supplement, vaccination, parasite, vetAppointment, other }

extension ReminderTypeLabel on ReminderType {
  String get label => switch (this) {
        ReminderType.medication => 'Medication',
        ReminderType.supplement => 'Supplement',
        ReminderType.vaccination => 'Vaccination',
        ReminderType.parasite => 'Parasite Prevention',
        ReminderType.vetAppointment => 'Vet Appointment',
        ReminderType.other => 'Other',
      };
}

class HealthReminder {
  final String id;
  String title;
  DateTime due; // date (+ time when [hasTime])
  bool hasTime;
  ReminderType type;
  String repeat; // None | Daily | Weekly | Monthly | Custom
  String? linkedRecord;
  String notes;
  String? notify; // null = notifications off
  bool completed;
  HealthReminder({
    required this.id,
    required this.title,
    required this.due,
    this.hasTime = false,
    this.type = ReminderType.other,
    this.repeat = 'None',
    this.linkedRecord,
    this.notes = '',
    this.notify,
    this.completed = false,
  });
}

/// A generic dated record in a Health category (Parasite Prevention,
/// Reproductive Health areas, …). [fields] holds the category-specific values.
class HealthLog {
  final String id;
  final String area;
  String title;
  DateTime date;
  Map<String, String> fields;
  String notes;
  HealthLog({
    required this.id,
    required this.area,
    required this.title,
    required this.date,
    Map<String, String>? fields,
    this.notes = '',
  }) : fields = fields ?? {};
}

class HealthStore extends ChangeNotifier {
  HealthStore._();
  static final HealthStore instance = HealthStore._();

  final Map<String, List<WeightEntry>> _weights = {};
  final Map<String, List<BcsEntry>> _bcs = {};
  final Map<String, List<HealthReminder>> _reminders = {};
  final Map<String, List<HealthLog>> _logs = {};
  int _seq = 0;
  String newId() => 'h${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  // ── Weight ──────────────────────────────────────────────────────────────
  List<WeightEntry> weights(String dog) {
    final l = List<WeightEntry>.from(_weights[dog] ?? const []);
    l.sort((a, b) => b.date.compareTo(a.date));
    return l;
  }

  void saveWeight(String dog, WeightEntry e) {
    final l = _weights.putIfAbsent(dog, () => []);
    final i = l.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      l[i] = e;
    } else {
      l.add(e);
    }
    notifyListeners();
  }

  void deleteWeight(String dog, String id) {
    _weights[dog]?.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── Body condition ──────────────────────────────────────────────────────
  List<BcsEntry> bcs(String dog) {
    final l = List<BcsEntry>.from(_bcs[dog] ?? const []);
    l.sort((a, b) => b.date.compareTo(a.date));
    return l;
  }

  void saveBcs(String dog, BcsEntry e) {
    final l = _bcs.putIfAbsent(dog, () => []);
    final i = l.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      l[i] = e;
    } else {
      l.add(e);
    }
    notifyListeners();
  }

  void deleteBcs(String dog, String id) {
    _bcs[dog]?.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── Reminders / appointments ────────────────────────────────────────────
  List<HealthReminder> reminders(String dog) => List.of(_reminders[dog] ?? const []);

  /// Future, not-completed items, soonest first.
  List<HealthReminder> upcoming(String dog) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final l = reminders(dog).where((r) {
      if (r.completed) return false;
      return r.hasTime ? !r.due.isBefore(now) : !r.due.isBefore(today);
    }).toList();
    l.sort((a, b) => a.due.compareTo(b.due));
    return l;
  }

  List<HealthReminder> completed(String dog) {
    final l = reminders(dog).where((r) => r.completed).toList();
    l.sort((a, b) => b.due.compareTo(a.due));
    return l;
  }

  /// Not completed and already past.
  List<HealthReminder> overdue(String dog) {
    final up = upcoming(dog).map((e) => e.id).toSet();
    final l = reminders(dog).where((r) => !r.completed && !up.contains(r.id)).toList();
    l.sort((a, b) => b.due.compareTo(a.due));
    return l;
  }

  void saveReminder(String dog, HealthReminder r) {
    final l = _reminders.putIfAbsent(dog, () => []);
    final i = l.indexWhere((x) => x.id == r.id);
    if (i >= 0) {
      l[i] = r;
    } else {
      l.add(r);
    }
    notifyListeners();
  }

  void deleteReminder(String dog, String id) {
    _reminders[dog]?.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void touch() => notifyListeners();

  // ── Generic logs ────────────────────────────────────────────────────────
  List<HealthLog> logs(String dog, String area) {
    final l = (_logs[dog] ?? const <HealthLog>[]).where((x) => x.area == area).toList();
    l.sort((a, b) => b.date.compareTo(a.date));
    return l;
  }

  List<HealthLog> allLogs(String dog) => List.of(_logs[dog] ?? const []);

  void saveLog(String dog, HealthLog e) {
    final l = _logs.putIfAbsent(dog, () => []);
    final i = l.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      l[i] = e;
    } else {
      l.add(e);
    }
    notifyListeners();
  }

  void deleteLog(String dog, String id) {
    _logs[dog]?.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Records held by this store for [dog] (weights, BCS and category logs).
  int recordCount(String dog) =>
      (_weights[dog]?.length ?? 0) + (_bcs[dog]?.length ?? 0) + (_logs[dog]?.length ?? 0);


  // ── Persistence ─────────────────────────────────────────────────────────
  bool _loading = false;

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (!_loading) _save();
  }

  void _save() => Persist.write('store.health', {
        'weights': {for (final e in _weights.entries) e.key: [for (final w in e.value) {'id': w.id, 'date': w.date.toIso8601String(), 'value': w.value, 'unit': w.unit, 'time': w.time, 'notes': w.notes}]},
        'bcs': {for (final e in _bcs.entries) e.key: [for (final b in e.value) {'id': b.id, 'date': b.date.toIso8601String(), 'score': b.score, 'notes': b.notes}]},
        'reminders': {
          for (final e in _reminders.entries)
            e.key: [for (final r in e.value) {'id': r.id, 'title': r.title, 'due': r.due.toIso8601String(), 'hasTime': r.hasTime, 'type': r.type.name, 'repeat': r.repeat, 'linked': r.linkedRecord, 'notes': r.notes, 'notify': r.notify, 'completed': r.completed}]
        },
        'logs': {for (final e in _logs.entries) e.key: [for (final l in e.value) {'id': l.id, 'area': l.area, 'title': l.title, 'date': l.date.toIso8601String(), 'fields': l.fields, 'notes': l.notes}]},
      });

  Future<void> load() async {
    final j = await Persist.read('store.health');
    if (j is! Map) return;
    _loading = true;
    try {
      List<Map> L(Object? v) => [for (final x in (v as List? ?? [])) x as Map];
      Map<String, List<T>> M<T>(Object? v, T Function(Map) f) =>
          {for (final e in ((v as Map?) ?? {}).entries) e.key as String: [for (final x in L(e.value)) f(x)]};
      _weights
        ..clear()
        ..addAll(M(j['weights'], (m) => WeightEntry(id: m['id'], date: DateTime.parse(m['date']), value: (m['value'] as num).toDouble(), unit: m['unit'] ?? 'kg', time: m['time'], notes: m['notes'] ?? '')));
      _bcs
        ..clear()
        ..addAll(M(j['bcs'], (m) => BcsEntry(id: m['id'], date: DateTime.parse(m['date']), score: m['score'], notes: m['notes'] ?? '')));
      _reminders
        ..clear()
        ..addAll(M(j['reminders'], (m) => HealthReminder(id: m['id'], title: m['title'], due: DateTime.parse(m['due']), hasTime: m['hasTime'] ?? false, type: ReminderType.values.firstWhere((t) => t.name == m['type'], orElse: () => ReminderType.other), repeat: m['repeat'] ?? 'None', linkedRecord: m['linked'], notes: m['notes'] ?? '', notify: m['notify'], completed: m['completed'] ?? false)));
      _logs
        ..clear()
        ..addAll(M(j['logs'], (m) => HealthLog(id: m['id'], area: m['area'], title: m['title'] ?? '', date: DateTime.parse(m['date']), fields: {for (final e in ((m['fields'] as Map?) ?? {}).entries) '${e.key}': '${e.value}'}, notes: m['notes'] ?? '')));
    } catch (_) {
    } finally {
      _loading = false;
      super.notifyListeners();
    }
  }

}
