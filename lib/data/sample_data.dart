/// Shared demo records used by the Dogs and Goals screens so every screen
/// shows the same dogs and the same goal numbers. Replace with backend data.
library;

export 'goals_store.dart' show GoalInfo, GoalStatus, GoalTracking, GoalsStore;

import 'goals_store.dart';

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

  /// Compat: delegates to the real, saved GoalsStore.
  static List<GoalInfo> goalsFor(String dogName) => GoalsStore.instance.goalsFor(dogName);

}
