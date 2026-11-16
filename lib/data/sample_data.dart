/// Shared demo records used by the Dogs and Goals screens so every screen
/// shows the same dogs and the same goal numbers. Replace with backend data.
library;

class DogInfo {
  final String name;
  final String breed;
  final String age;
  final String sex;
  final String? photoUrl;
  final DateTime? lastActive;
  final bool isClient;
  final String? ownerName;
  final int sessionCount;
  final int totalMinutes; // sum of recorded session durations only

  const DogInfo({
    required this.name,
    required this.breed,
    required this.age,
    required this.sex,
    this.photoUrl,
    this.lastActive,
    this.isClient = false,
    this.ownerName,
    this.sessionCount = 0,
    this.totalMinutes = 0,
  });

  /// "Breed · age · sex", the approved secondary line on dog cards.
  String get details => '$breed · $age · $sex';
}

enum GoalStatus { active, completed, overdue }

enum GoalTracking { automatic, manual }

class GoalInfo {
  final String dogName;
  final String title;
  final String category; // Training, S&C, Health, Sport
  final GoalTracking tracking;

  /// Sessions, Repetitions, Duration, Distance or a custom unit.
  /// Null means an open-ended goal with no numerical target.
  final String? targetUnit;
  final num? targetValue;
  final num current;
  final GoalStatus status;
  final String? priority; // Low / Medium / High, optional
  final DateTime? dueDate;
  final String? description;
  final String? notes;
  final List<String> linkedRecords;

  const GoalInfo({
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
    this.linkedRecords = const [],
  });

  bool get isMeasurable => targetUnit != null && targetValue != null && targetValue! > 0;

  /// 0..1 for measurable goals, null for open-ended goals (never invented).
  double? get progress => isMeasurable ? (current / targetValue!).clamp(0, 1).toDouble() : null;
}

class SampleData {
  SampleData._();

  static const String _img = 'https://lh3.googleusercontent.com/aida-public/';

  static final List<DogInfo> dogs = [
    DogInfo(
      name: 'Murphy', breed: 'Golden Retriever', age: '4 yrs', sex: 'Male',
      photoUrl: '${_img}AB6AXuDAm6Qjx7r8IjMbUPAoPZtLHLuvG0GSyXyqNYoE-0HvkL8R0uhRqzAJo_IppFqkRZBUCIxwx_3DkTS4wwh3N2HO0mGuLtzrdN0LrtKI6IeWju_DR5KZ5RlBnWoTDSUEt2FYMzjNLNcwt6GWeEOnLyHpsSF0KVQmVQ98Mpd5SIk2NoCP5PUwyYhXrhnZdD80Ah582bGM_kFuz7Z7DQoRmDKYzIqnKSgMYx8MPX4YMiDSzEnfyRyHxdQ',
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      sessionCount: 128, totalMinutes: 2520,
    ),
    DogInfo(
      name: 'Bella', breed: 'Belgian Malinois', age: '2 yrs', sex: 'Female',
      photoUrl: '${_img}AB6AXuA_FGLheOQECXltZJ7TsUvazbqLiSre1yRRKuQezkUBBZQ72U7xo9pc_zOrINWFZo7mLR2Ml-xjS2Z8_yKiR8etkKnpixjmkyGf5DtZF637KRF0kKrTTdiJ8u__KVQnHJ65-PQgSPDIQh8eLlq1BHg9yEN2POU9Xfc1RSkS8yEXEGlkysd7ZGtZLiWvC9iVPdKV30xIgiL3ooXAxC9Z0iLRQxJkidNmE7oJrDOQA7GdhUFY_apTsHQ',
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      sessionCount: 64, totalMinutes: 1310,
    ),
    const DogInfo(name: 'Monty', breed: 'Mixed Breed', age: '1 yr', sex: 'Male'),
    DogInfo(
      name: 'Luna', breed: 'Border Collie', age: '5 yrs', sex: 'Female',
      photoUrl: '${_img}AB6AXuD-dBzJ3N-iY9n3LL7Zjg-9n9zNG8t0rH2uPeaa4gsfQeqLIyVQ9EfpR71y6T19BFQFcx2pR9R0b-D2q9nV9zEk-1GGDSB3MyGVoEfUgINo-TBo_H7kxre8TJ3nJtnamMVrZHYDCh3yFMH9hhETUUce8CvddXDdjljTpk4DRmnO7MPoXouW9jaMcJZiL9iR3sPBW056jR8HpE4xVtatKp4IOVIwTtw0dPKosa_kZxvey903ZD03YVA',
      lastActive: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DogInfo(
      name: 'Axel', breed: 'Dutch Shepherd', age: '3 yrs', sex: 'Male',
      photoUrl: '${_img}AB6AXuDvoTz5a9TC8u0P6-Md-scQcGedKfr4MXS6Ie8LAbxJyqbiVSDXuswe5WMfqrcXgK1s_YinkrDcT3cJA9UGsimRU0FgiHrxtMc0wZsYzNUajf_uPPHrYen5iRNaMD4_V7SkMj-abO0YqW5ydXjqfTvaWiimGC222XSr8xkdo8-ZRh9wtLIghLjSVf6OlVKj43jAkmQ98l9R9zgAoO7JzPugZGsSnyF6j8IkQjXebvcBQa3Th9WsTbE',
      lastActive: DateTime.now().subtract(const Duration(days: 7)),
    ),
    const DogInfo(name: 'Nova', breed: 'German Shepherd', age: '6 mos', sex: 'Female'),
    DogInfo(
      name: 'Bailey', breed: 'Labrador Retriever', age: '3 yrs', sex: 'Female',
      isClient: true, ownerName: 'Olivia Reed',
      lastActive: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static List<DogInfo> get myDogs => dogs.where((d) => !d.isClient).toList();
  static List<DogInfo> get clientDogs => dogs.where((d) => d.isClient).toList();

  static DogInfo dogNamed(String name) =>
      dogs.firstWhere((d) => d.name == name, orElse: () => dogs.first);

  static final List<GoalInfo> goals = [
    GoalInfo(
      dogName: 'Murphy',
      title: 'Complete 20 Recall Sessions',
      category: 'Training',
      tracking: GoalTracking.automatic,
      targetUnit: 'Sessions', targetValue: 20, current: 14,
      priority: 'High',
      dueDate: DateTime(DateTime.now().year, 12, 31),
      description: 'Build a reliable recall in the park before spring.',
      linkedRecords: const ['Recall (skill)', 'Emergency Recall (exercise)'],
    ),
    const GoalInfo(
      dogName: 'Murphy',
      title: 'Improve confidence around livestock',
      category: 'Training',
      tracking: GoalTracking.manual,
    ),
    GoalInfo(
      dogName: 'Murphy',
      title: 'Swim 2 km in total',
      category: 'S&C',
      tracking: GoalTracking.automatic,
      targetUnit: 'Distance (km)', targetValue: 2, current: 0.8,
      linkedRecords: const ['Swimming (S&C activity)'],
    ),
    GoalInfo(
      dogName: 'Murphy',
      title: 'Record weight every month',
      category: 'Health',
      tracking: GoalTracking.manual,
      targetUnit: 'Sessions', targetValue: 12, current: 9,
      status: GoalStatus.overdue,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    GoalInfo(
      dogName: 'Murphy',
      title: 'Pass BH',
      category: 'Training',
      tracking: GoalTracking.manual,
      status: GoalStatus.completed,
      dueDate: DateTime(DateTime.now().year, 4, 20),
    ),
    GoalInfo(
      dogName: 'Bella',
      title: '50 heelwork sessions',
      category: 'Training',
      tracking: GoalTracking.automatic,
      targetUnit: 'Sessions', targetValue: 50, current: 31,
      priority: 'Medium',
    ),
  ];

  static List<GoalInfo> goalsFor(String dogName) => goals.where((g) => g.dogName == dogName).toList();
}
