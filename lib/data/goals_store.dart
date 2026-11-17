import 'package:flutter/foundation.dart';
import 'persist.dart';

/// Goals: real saved records per dog, not fixed demo data. Edits, completion,
/// archive and delete all change the one saved goal and persist to the
/// device, so they survive navigating away or restarting the app.
enum GoalStatus { active, completed, overdue }

enum GoalTracking { automatic, manual }

class GoalInfo {
  final String id;
  String dogName;
  String title;
  String category; // Training, S&C, Health, Sport
  GoalTracking tracking;

  /// Sessions, Repetitions, Duration, Distance or a custom unit.
  /// Null means an open-ended goal with no numerical target.
  String? targetUnit;
  num? targetValue;
  num current;
  GoalStatus status;
  String? priority; // Low / Medium / High, optional
  DateTime? dueDate;
  String? description;
  String? notes;
  List<String> linkedRecords;
  bool archived;
  DateTime? completedAt; // set when status becomes completed; never invented

  GoalInfo({
    required this.id,
    required this.dogName,
    required this.title,
    required this.category,
    required this.tracking,
    this.targetUnit,
    this.targetValue,
    this.current = 0,
    this.status = GoalStatus.active,
    this.priority,
    this.dueDate,
    this.description,
    this.notes,
    List<String>? linkedRecords,
    this.archived = false,
    this.completedAt,
  }) : linkedRecords = linkedRecords ?? [];

  bool get isMeasurable => targetUnit != null && targetValue != null && targetValue! > 0;

  /// 0..1 for measurable goals, null for open-ended goals (never invented).
  double? get progress => isMeasurable ? (current / targetValue!).clamp(0, 1).toDouble() : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'dogName': dogName,
        'title': title,
        'category': category,
        'tracking': tracking.name,
        'targetUnit': targetUnit,
        'targetValue': targetValue,
        'current': current,
        'status': status.name,
        'priority': priority,
        'dueDate': dueDate?.toIso8601String(),
        'description': description,
        'notes': notes,
        'linkedRecords': linkedRecords,
        'archived': archived,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory GoalInfo.fromJson(Map m) => GoalInfo(
        id: m['id'],
        dogName: m['dogName'],
        title: m['title'],
        category: m['category'],
        tracking: GoalTracking.values.firstWhere((t) => t.name == m['tracking'], orElse: () => GoalTracking.manual),
        targetUnit: m['targetUnit'],
        targetValue: m['targetValue'],
        current: m['current'] ?? 0,
        status: GoalStatus.values.firstWhere((s) => s.name == m['status'], orElse: () => GoalStatus.active),
        priority: m['priority'],
        dueDate: DateTime.tryParse('${m['dueDate'] ?? ''}'),
        description: m['description'],
        notes: m['notes'],
        linkedRecords: [for (final x in (m['linkedRecords'] as List? ?? [])) '$x'],
        archived: m['archived'] ?? false,
        completedAt: DateTime.tryParse('${m['completedAt'] ?? ''}'),
      );
}

class GoalsStore extends ChangeNotifier {
  GoalsStore._();
  static final GoalsStore instance = GoalsStore._();

  final List<GoalInfo> _goals = [];
  int _seq = 0;
  String newId() => 'goal${DateTime.now().microsecondsSinceEpoch}_${_seq++}';

  Future<void> load() async {
    final j = await Persist.read('store.goals');
    if (j is List && j.isNotEmpty) {
      _goals
        ..clear()
        ..addAll([for (final m in j.cast<Map>()) GoalInfo.fromJson(m)]);
    } else {
      _seedOnce();
    }
    notifyListeners();
  }

  void _save() => Persist.write('store.goals', [for (final g in _goals) g.toJson()]);

  List<GoalInfo> goalsFor(String dogName, {bool archived = false}) =>
      _goals.where((g) => g.dogName == dogName && g.archived == archived).toList();

  GoalInfo? byId(String id) => _goals.where((g) => g.id == id).firstOrNull;

  void save(GoalInfo g) {
    if (!_goals.any((x) => x.id == g.id)) _goals.add(g);
    _touch();
  }

  void setStatus(GoalInfo g, GoalStatus s) {
    g.status = s;
    if (s == GoalStatus.completed) g.completedAt ??= DateTime.now();
    _touch();
  }

  void setCurrent(GoalInfo g, num v) {
    g.current = v;
    _touch();
  }

  void setArchived(GoalInfo g, bool v) {
    g.archived = v;
    _touch();
  }

  void delete(String id) {
    _goals.removeWhere((g) => g.id == id);
    _touch();
  }

  void _touch() {
    _save();
    notifyListeners();
  }

  /// Illustrative starting goals, seeded once when nothing has been saved yet
  /// (e.g. a fresh install). Never re-added once the user has any goals.
  void _seedOnce() {
    final now = DateTime.now();
    _goals.addAll([
      GoalInfo(
        id: newId(),
        dogName: 'Murphy',
        title: 'Complete 20 Recall Sessions',
        category: 'Training',
        tracking: GoalTracking.automatic,
        targetUnit: 'Sessions',
        targetValue: 20,
        current: 14,
        priority: 'High',
        dueDate: DateTime(now.year, 12, 31),
        description: 'Build a reliable recall in the park before spring.',
        linkedRecords: ['Recall (skill)', 'Emergency Recall (exercise)'],
      ),
      GoalInfo(
        id: newId(),
        dogName: 'Murphy',
        title: 'Improve confidence around livestock',
        category: 'Training',
        tracking: GoalTracking.manual,
      ),
      GoalInfo(
        id: newId(),
        dogName: 'Murphy',
        title: 'Swim 2 km in total',
        category: 'S&C',
        tracking: GoalTracking.automatic,
        targetUnit: 'Distance (km)',
        targetValue: 2,
        current: 0.8,
        linkedRecords: ['Swimming (S&C activity)'],
      ),
      GoalInfo(
        id: newId(),
        dogName: 'Murphy',
        title: 'Record weight every month',
        category: 'Health',
        tracking: GoalTracking.manual,
        targetUnit: 'Sessions',
        targetValue: 12,
        current: 9,
        status: GoalStatus.overdue,
        dueDate: now.subtract(const Duration(days: 5)),
      ),
      GoalInfo(
        id: newId(),
        dogName: 'Murphy',
        title: 'Pass BH',
        category: 'Training',
        tracking: GoalTracking.manual,
        status: GoalStatus.completed,
        dueDate: DateTime(now.year, 4, 20),
      ),
      GoalInfo(
        id: newId(),
        dogName: 'Bella',
        title: '50 heelwork sessions',
        category: 'Training',
        tracking: GoalTracking.automatic,
        targetUnit: 'Sessions',
        targetValue: 50,
        current: 31,
        priority: 'Medium',
      ),
    ]);
    _save();
  }
}
