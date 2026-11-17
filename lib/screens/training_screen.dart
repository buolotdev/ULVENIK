import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/persist.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import 'training_session_screen.dart';
import 'dog_profile_screen.dart';
import 'goals_list_screen.dart' show DogPickerSheet;

// ─── Computed Training Session Models & Store ────────────────────────────────

enum SessionStatus { draft, completed }

/// Normalizes a skill or exercise name so distinct counts are case-insensitive,
/// whitespace-insensitive, and work identically for built-in and custom entries.
String normalizeTrainingKey(String value) =>
    value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

class RecordedExerciseEntry {
  final String id;
  final String name;
  final int repetitions;
  final String? notes;
  final bool isCustom;

  const RecordedExerciseEntry({
    required this.id,
    required this.name,
    this.repetitions = 1,
    this.notes,
    this.isCustom = false,
  }) : assert(repetitions >= 1);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'repetitions': repetitions, 'notes': notes, 'isCustom': isCustom};
  factory RecordedExerciseEntry.fromJson(Map m) => RecordedExerciseEntry(
        id: m['id'],
        name: m['name'],
        repetitions: m['repetitions'] ?? 1,
        notes: m['notes'],
        isCustom: m['isCustom'] ?? false,
      );

  RecordedExerciseEntry copyWith({
    String? id,
    String? name,
    int? repetitions,
    String? notes,
    bool? isCustom,
  }) {
    return RecordedExerciseEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      repetitions: repetitions ?? this.repetitions,
      notes: notes ?? this.notes,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class RecordedSkillEntry {
  final String id;
  final String skillName;
  final List<RecordedExerciseEntry> exercises;
  final bool isCustom;

  const RecordedSkillEntry({
    required this.id,
    required this.skillName,
    this.exercises = const [],
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'skillName': skillName, 'exercises': [for (final e in exercises) e.toJson()], 'isCustom': isCustom};
  factory RecordedSkillEntry.fromJson(Map m) => RecordedSkillEntry(
        id: m['id'],
        skillName: m['skillName'],
        exercises: [for (final e in (m['exercises'] as List? ?? [])) RecordedExerciseEntry.fromJson(e as Map)],
        isCustom: m['isCustom'] ?? false,
      );

  /// Number of distinct exercises recorded under this skill.
  /// Repeating an exercise increases [RecordedExerciseEntry.repetitions]
  /// rather than inflating [distinctExerciseCount].
  int get distinctExerciseCount {
    final seen = <String>{};
    for (final ex in exercises) {
      final key = normalizeTrainingKey(ex.name);
      if (key.isNotEmpty) {
        seen.add(key);
      }
    }
    return seen.length;
  }

  /// Total repetitions logged across exercises under this skill (tracked separately).
  int get totalRepetitions =>
      exercises.fold<int>(0, (sum, ex) => sum + ex.repetitions);

  RecordedSkillEntry copyWith({
    String? id,
    String? skillName,
    List<RecordedExerciseEntry>? exercises,
    bool? isCustom,
  }) {
    return RecordedSkillEntry(
      id: id ?? this.id,
      skillName: skillName ?? this.skillName,
      exercises: exercises ?? this.exercises,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class SkillCatalogEntry {
  final String skillName;
  final List<String> exercises;
  final bool isCustom;

  const SkillCatalogEntry({
    required this.skillName,
    this.exercises = const [],
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {'skillName': skillName, 'exercises': exercises, 'isCustom': isCustom};
  factory SkillCatalogEntry.fromJson(Map m) => SkillCatalogEntry(
        skillName: m['skillName'],
        exercises: [for (final e in (m['exercises'] as List? ?? [])) '$e'],
        isCustom: m['isCustom'] ?? false,
      );

  SkillCatalogEntry copyWith({
    String? skillName,
    List<String>? exercises,
    bool? isCustom,
  }) {
    return SkillCatalogEntry(
      skillName: skillName ?? this.skillName,
      exercises: exercises ?? this.exercises,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

class TrainingSession {
  final String id;
  final String dogName;
  final String dogInitial;
  final String dogCategory; // 'My Dogs' or 'Client Dogs'
  final String title;
  final String dateLabel;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay? finishTime;
  final int? recordedDurationMinutes;
  final SessionStatus status;
  final List<RecordedSkillEntry> recordedSkills;
  final String location;
  final String purpose;
  final String notes;
  final List<String> equipment;
  final List<String> rewards;
  final List<String> sessionTags;
  final int? photoCount;
  final int? videoCount;
  final String? thumbnailUrl;
  final Color dogColor;

  const TrainingSession({
    required this.id,
    required this.dogName,
    required this.dogInitial,
    this.dogCategory = 'My Dogs',
    required this.title,
    required this.dateLabel,
    required this.date,
    this.startTime = const TimeOfDay(hour: 9, minute: 0),
    this.finishTime,
    this.recordedDurationMinutes,
    required this.status,
    this.recordedSkills = const [],
    this.location = 'Home Training Field',
    this.purpose = 'Skill Building',
    this.notes = '',
    this.equipment = const [],
    this.rewards = const [],
    this.sessionTags = const [],
    this.photoCount,
    this.videoCount,
    this.thumbnailUrl,
    required this.dogColor,
  });

  static Map<String, int>? _tod(TimeOfDay? t) => t == null ? null : {'h': t.hour, 'm': t.minute};
  static TimeOfDay? _todFrom(Map? m) => m == null ? null : TimeOfDay(hour: m['h'], minute: m['m']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'dogName': dogName,
        'dogInitial': dogInitial,
        'dogCategory': dogCategory,
        'title': title,
        'dateLabel': dateLabel,
        'date': date.toIso8601String(),
        'startTime': _tod(startTime),
        'finishTime': _tod(finishTime),
        'recordedDurationMinutes': recordedDurationMinutes,
        'status': status.name,
        'recordedSkills': [for (final s in recordedSkills) s.toJson()],
        'location': location,
        'purpose': purpose,
        'notes': notes,
        'equipment': equipment,
        'rewards': rewards,
        'sessionTags': sessionTags,
        'photoCount': photoCount,
        'videoCount': videoCount,
        'thumbnailUrl': thumbnailUrl,
        'dogColor': dogColor.toARGB32(),
      };

  factory TrainingSession.fromJson(Map m) => TrainingSession(
        id: m['id'],
        dogName: m['dogName'],
        dogInitial: m['dogInitial'],
        dogCategory: m['dogCategory'] ?? 'My Dogs',
        title: m['title'],
        dateLabel: m['dateLabel'],
        date: DateTime.parse(m['date']),
        startTime: _todFrom(m['startTime'] as Map?) ?? const TimeOfDay(hour: 9, minute: 0),
        finishTime: _todFrom(m['finishTime'] as Map?),
        recordedDurationMinutes: m['recordedDurationMinutes'],
        status: SessionStatus.values.firstWhere((s) => s.name == m['status'], orElse: () => SessionStatus.draft),
        recordedSkills: [for (final s in (m['recordedSkills'] as List? ?? [])) RecordedSkillEntry.fromJson(s as Map)],
        location: m['location'] ?? 'Home Training Field',
        purpose: m['purpose'] ?? 'Skill Building',
        notes: m['notes'] ?? '',
        equipment: [for (final e in (m['equipment'] as List? ?? [])) '$e'],
        rewards: [for (final r in (m['rewards'] as List? ?? [])) '$r'],
        sessionTags: [for (final t in (m['sessionTags'] as List? ?? [])) '$t'],
        photoCount: m['photoCount'],
        videoCount: m['videoCount'],
        thumbnailUrl: m['thumbnailUrl'],
        dogColor: Color(m['dogColor'] ?? 0xFF7A8F7A),
      );

  /// Duration in minutes recorded by the user (either entered directly or
  /// derived from start and finish times).
  int? get durationMinutes {
    if (recordedDurationMinutes != null && recordedDurationMinutes! > 0) {
      return recordedDurationMinutes;
    }
    if (finishTime != null) {
      var diff = (finishTime!.hour * 60 + finishTime!.minute) -
          (startTime.hour * 60 + startTime.minute);
      if (diff < 0) diff += 24 * 60;
      if (diff > 0) return diff;
    }
    return null;
  }

  /// Formatted session duration reflecting what the user recorded.
  String? get duration {
    final mins = durationMinutes;
    if (mins == null) return null;
    if (mins <= 60) return '$mins min';
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  /// Automatically calculated count of distinct skills recorded in this session.
  /// Each distinct skill is counted once even if multiple exercises are recorded under it.
  int get skillCount {
    final seen = <String>{};
    for (final skill in recordedSkills) {
      final key = normalizeTrainingKey(skill.skillName);
      if (key.isNotEmpty) {
        seen.add(key);
      }
    }
    return seen.length;
  }

  /// Automatically calculated count of distinct exercises recorded in this session.
  /// Repeating an exercise multiple times during a session updates its separate
  /// repetition count and never increases [exerciseCount].
  int get exerciseCount {
    final seen = <String>{};
    for (final skill in recordedSkills) {
      if (normalizeTrainingKey(skill.skillName).isEmpty) continue;
      for (final ex in skill.exercises) {
        final exKey = normalizeTrainingKey(ex.name);
        if (exKey.isNotEmpty) {
          seen.add(exKey);
        }
      }
    }
    return seen.length;
  }

  /// Total exercise repetitions recorded separately across the session.
  int get totalRepetitions =>
      recordedSkills.fold<int>(0, (sum, s) => sum + s.totalRepetitions);

  String get formattedSkillCount =>
      '$skillCount ${skillCount == 1 ? 'Skill' : 'Skills'}';

  String get formattedExerciseCount =>
      '$exerciseCount ${exerciseCount == 1 ? 'Exercise' : 'Exercises'}';

  /// Skill tags displayed underneath each session card — derived directly from
  /// the distinct skills actually recorded in the session.
  List<String> get skillTags {
    final seen = <String>{};
    final result = <String>[];
    for (final skill in recordedSkills) {
      final trimmed = skill.skillName.trim();
      if (trimmed.isEmpty) continue;
      if (seen.add(normalizeTrainingKey(trimmed))) {
        result.add(trimmed);
      }
    }
    return List.unmodifiable(result);
  }

  String get summaryStatsLine {
    final parts = <String>[
      ?duration,
      if (recordedSkills.isNotEmpty) formattedSkillCount,
      if (recordedSkills.isNotEmpty) formattedExerciseCount,
    ];
    return parts.join(' · ');
  }

  TrainingSession copyWith({
    String? id,
    String? dogName,
    String? dogInitial,
    String? dogCategory,
    String? title,
    String? dateLabel,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? finishTime,
    bool clearFinishTime = false,
    int? recordedDurationMinutes,
    bool clearRecordedDuration = false,
    SessionStatus? status,
    List<RecordedSkillEntry>? recordedSkills,
    String? location,
    String? purpose,
    String? notes,
    List<String>? equipment,
    List<String>? rewards,
    List<String>? sessionTags,
    int? photoCount,
    int? videoCount,
    String? thumbnailUrl,
    Color? dogColor,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      dogName: dogName ?? this.dogName,
      dogInitial: dogInitial ?? this.dogInitial,
      dogCategory: dogCategory ?? this.dogCategory,
      title: title ?? this.title,
      dateLabel: dateLabel ?? this.dateLabel,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      finishTime: clearFinishTime ? null : (finishTime ?? this.finishTime),
      recordedDurationMinutes: clearRecordedDuration
          ? null
          : (recordedDurationMinutes ?? this.recordedDurationMinutes),
      status: status ?? this.status,
      recordedSkills: recordedSkills ?? this.recordedSkills,
      location: location ?? this.location,
      purpose: purpose ?? this.purpose,
      notes: notes ?? this.notes,
      equipment: equipment ?? this.equipment,
      rewards: rewards ?? this.rewards,
      sessionTags: sessionTags ?? this.sessionTags,
      photoCount: photoCount ?? this.photoCount,
      videoCount: videoCount ?? this.videoCount,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      dogColor: dogColor ?? this.dogColor,
    );
  }
}

// ─── Reactive Store ──────────────────────────────────────────────────────────

class TrainingSessionStore {
  TrainingSessionStore._();

  static List<SkillCatalogEntry> _defaultCatalog() => const [
        SkillCatalogEntry(
          skillName: 'Emergency Down',
          exercises: [
            'Down on verbal cue',
            'Down at a distance',
            'Down in motion on whistle',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Distance Control',
          exercises: [
            'Maintaining the down while the handler moves away',
            'Sit-down-stand sequence at 4 metres',
            'Distance stand to down transition',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Focused Heelwork',
          exercises: [
            'Sustained eye contact in motion',
            'Left and right about-turns',
            'Halt to automatic sit',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Pace Transitions',
          exercises: [
            'Normal to fast pace transition',
            'Fast to slow pace with automatic sit',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Down Stay',
          exercises: [
            'Down on cue with calm settle',
            'Duration down with handler at 5 metres',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Distraction Control',
          exercises: [
            'Maintaining down stay with passing distraction',
            'Disengagement on handler cue',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Retrieve',
          exercises: [
            'Clean dummy pick-up on flat',
            'Direct return to front position',
            'Dumbbell retrieve over hurdle',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Hold & Delivery',
          exercises: [
            'Calm hold until release cue',
            'Seated front delivery to hand',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Position Changes',
          exercises: [
            'Sit to down fold-back',
            'Down to stand without forward creep',
            'Stand to sit tuck',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Recall',
          exercises: [
            'Whistle recall at 30m',
            'Recall past distraction',
            'Long-line recall on whistle',
            'Front finish to heel',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Heelwork',
          exercises: [
            'Left-hand turns',
            'Halt to automatic sit',
            'Figure of eight',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Stay',
          exercises: [
            'Two-minute sit stay',
            'Out-of-sight down stay',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Impulse Control',
          exercises: [
            'Wait at start line',
            'Leave distraction on recall path',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Tracking',
          exercises: [
            'Cold start track',
            'Article indication',
          ],
        ),
        SkillCatalogEntry(
          skillName: 'Protection',
          exercises: [
            'Blind search',
            'Hold and bark',
            'Grip development on sleeve',
            'Clean out on command',
          ],
        ),
      ];

  static List<TrainingSession> _defaultSessions() => [
        // ── Slide 2 Demonstration Records (genuine underlying skills & exercises) ──
        TrainingSession(
          id: 's_cooper_1',
          dogName: 'Cooper',
          dogInitial: 'C',
          dogCategory: 'My Dogs',
          title: 'Emergency Down Training',
          dateLabel: '15 Sep · 08:15',
          date: DateTime(2026, 9, 15),
          startTime: const TimeOfDay(hour: 8, minute: 15),
          finishTime: const TimeOfDay(hour: 8, minute: 23),
          recordedDurationMinutes: 8,
          status: SessionStatus.completed,
          location: 'Meadow Training Field',
          purpose: 'Skill Building',
          notes:
              'Immediate response on verbal down cue. Gradually increased handler distance while keeping calm stillness before release.',
          equipment: const ['Long Line (10m)'],
          rewards: const ['High-Value Food', 'Praise'],
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_cooper_1',
              skillName: 'Emergency Down',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_cooper_1',
                  name: 'Down on verbal cue',
                  repetitions: 4,
                ),
                RecordedExerciseEntry(
                  id: 'ex_cooper_2',
                  name: 'Down at a distance',
                  repetitions: 3,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_cooper_2',
              skillName: 'Distance Control',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_cooper_3',
                  name: 'Maintaining the down while the handler moves away',
                  repetitions: 3,
                ),
              ],
            ),
          ],
          dogColor: AppColors.secondarySage,
        ),
        TrainingSession(
          id: 's_jax_1',
          dogName: 'Jax',
          dogInitial: 'J',
          dogCategory: 'My Dogs',
          title: 'Focused Heelwork',
          dateLabel: '14 Sep · 17:10',
          date: DateTime(2026, 9, 14),
          startTime: const TimeOfDay(hour: 17, minute: 10),
          finishTime: const TimeOfDay(hour: 17, minute: 19),
          recordedDurationMinutes: 9,
          status: SessionStatus.completed,
          location: 'Club Training Pitch',
          purpose: 'Trial Prep',
          notes:
              'Clean shoulder alignment on about-turns and crisp transitions between fast and slow pace.',
          equipment: const ['Flat Collar', 'Ball on Rope'],
          rewards: const ['Tug Toy'],
          photoCount: 2,
          videoCount: 1,
          thumbnailUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBtnZIiE99uRwgthfLqDzuxeWGd8cxQATNqJM6VzC9pZrTZ31-ffB290LDjDtqheyJspt7ofm9yqIF0X0XFWx8dXCBjZbDHG8qdo0Mz-AuhKHlvFxLL-nAsQLvNI8DUFO-kmO-ZgtFTq-76pxDki6E3kNW1JrHqExT9Q5CibVDY4kJsbdsMkr3D67qmyZ2g8T-9UQBq28KytbkJ3sLu0KU1xi9Y5Mh_ZXxXm2p22Nih4geUdfZm0yE',
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_jax_1',
              skillName: 'Focused Heelwork',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_jax_1',
                  name: 'Sustained eye contact in motion',
                  repetitions: 4,
                ),
                RecordedExerciseEntry(
                  id: 'ex_jax_2',
                  name: 'Left and right about-turns',
                  repetitions: 5,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_jax_2',
              skillName: 'Pace Transitions',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_jax_3',
                  name: 'Normal to fast pace transition',
                  repetitions: 3,
                ),
                RecordedExerciseEntry(
                  id: 'ex_jax_4',
                  name: 'Fast to slow pace with automatic sit',
                  repetitions: 3,
                ),
              ],
            ),
          ],
          dogColor: AppColors.infoAlpineBlue,
        ),
        TrainingSession(
          id: 's_lady_1',
          dogName: 'Lady',
          dogInitial: 'L',
          dogCategory: 'My Dogs',
          title: 'Down Stay Training',
          dateLabel: '14 Sep · 10:00',
          date: DateTime(2026, 9, 14),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          finishTime: const TimeOfDay(hour: 10, minute: 7),
          recordedDurationMinutes: 7,
          status: SessionStatus.completed,
          location: 'Home Garden',
          purpose: 'Skill Building',
          notes:
              'Settled hips quickly on cue and held position steadily when a jogger passed outside the boundary.',
          equipment: const ['Boundary Mat'],
          rewards: const ['High-Value Food'],
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_lady_1',
              skillName: 'Down Stay',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_lady_1',
                  name: 'Down on cue with calm settle',
                  repetitions: 4,
                ),
                RecordedExerciseEntry(
                  id: 'ex_lady_2',
                  name: 'Duration down with handler at 5 metres',
                  repetitions: 2,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_lady_2',
              skillName: 'Distraction Control',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_lady_3',
                  name: 'Maintaining down stay with passing distraction',
                  repetitions: 3,
                ),
              ],
            ),
          ],
          dogColor: AppColors.secondarySage,
        ),
        TrainingSession(
          id: 's_lady_2',
          dogName: 'Lady',
          dogInitial: 'L',
          dogCategory: 'My Dogs',
          title: 'Retrieve Training',
          dateLabel: '13 Sep · 15:30',
          date: DateTime(2026, 9, 13),
          startTime: const TimeOfDay(hour: 15, minute: 30),
          finishTime: const TimeOfDay(hour: 15, minute: 36),
          recordedDurationMinutes: 6,
          status: SessionStatus.completed,
          location: 'Riverside Paddock',
          purpose: 'Skill Building',
          notes:
              'Enthusiastic outrun and clean pick-up without mouthing the canvas dummy.',
          equipment: const ['Canvas Dummy (500g)'],
          rewards: const ['High-Value Food', 'Praise'],
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_lady_3',
              skillName: 'Retrieve',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_lady_4',
                  name: 'Clean dummy pick-up on flat',
                  repetitions: 4,
                ),
                RecordedExerciseEntry(
                  id: 'ex_lady_5',
                  name: 'Direct return to front position',
                  repetitions: 4,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_lady_4',
              skillName: 'Hold & Delivery',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_lady_6',
                  name: 'Calm hold until release cue',
                  repetitions: 5,
                ),
              ],
            ),
          ],
          dogColor: AppColors.secondarySage,
        ),
        TrainingSession(
          id: 's_jax_2',
          dogName: 'Jax',
          dogInitial: 'J',
          dogCategory: 'My Dogs',
          title: 'Position Changes',
          dateLabel: '12 Sep · 18:00',
          date: DateTime(2026, 9, 12),
          startTime: const TimeOfDay(hour: 18, minute: 0),
          finishTime: const TimeOfDay(hour: 18, minute: 8),
          recordedDurationMinutes: 8,
          status: SessionStatus.completed,
          location: 'Club Training Pitch',
          purpose: 'Trial Prep',
          notes:
              'Rear feet stayed anchored on fold-back downs and clean stand transitions at 4 metres.',
          equipment: const ['Position Box Marker'],
          rewards: const ['Ball', 'High-Value Food'],
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_jax_3',
              skillName: 'Position Changes',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_jax_5',
                  name: 'Sit to down fold-back',
                  repetitions: 5,
                ),
                RecordedExerciseEntry(
                  id: 'ex_jax_6',
                  name: 'Down to stand without forward creep',
                  repetitions: 4,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_jax_4',
              skillName: 'Distance Control',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_jax_7',
                  name: 'Sit-down-stand sequence at 4 metres',
                  repetitions: 3,
                ),
              ],
            ),
          ],
          dogColor: AppColors.infoAlpineBlue,
        ),

        // ── Additional Workspace Records (Draft + Client Dogs) ──
        TrainingSession(
          id: 's1',
          dogName: 'Rex',
          dogInitial: 'R',
          dogCategory: 'My Dogs',
          title: 'Tracking Session: Woodland Trail',
          dateLabel: 'Today · Incomplete',
          date: DateTime(2026, 9, 15),
          startTime: const TimeOfDay(hour: 7, minute: 30),
          status: SessionStatus.draft,
          location: 'Nordic Woods Field',
          purpose: 'Trial Prep',
          notes:
              'Rex settled nicely at the scent pad and indicated the first leather article cleanly.',
          equipment: const ['Tracking Harness', 'Long Line (10m)'],
          rewards: const ['High-Value Food'],
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_rex_draft_1',
              skillName: 'Tracking',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_rex_draft_1',
                  name: 'Cold start track',
                  repetitions: 1,
                ),
                RecordedExerciseEntry(
                  id: 'ex_rex_draft_2',
                  name: 'Article indication',
                  repetitions: 2,
                ),
              ],
            ),
          ],
          dogColor: AppColors.secondarySage,
        ),
        TrainingSession(
          id: 's2',
          dogName: 'Murphy',
          dogInitial: 'M',
          dogCategory: 'Client Dogs',
          title: 'Morning Obedience Block',
          dateLabel: '11 Sep · 07:30',
          date: DateTime(2026, 9, 11),
          startTime: const TimeOfDay(hour: 7, minute: 30),
          finishTime: const TimeOfDay(hour: 8, minute: 15),
          recordedDurationMinutes: 45,
          status: SessionStatus.completed,
          location: 'Chelmsford Training Ground',
          purpose: 'Skill Building',
          notes:
              'Balanced morning obedience block covering whistle recall, left-hand heel turns, and steady stays.',
          equipment: const ['Long Line (10m)', 'Clicker'],
          rewards: const ['High-Value Food', 'Tug Toy'],
          photoCount: 4,
          videoCount: 1,
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_murphy_1',
              skillName: 'Recall',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_murphy_1',
                  name: 'Whistle recall at 30m',
                  repetitions: 4,
                ),
                RecordedExerciseEntry(
                  id: 'ex_murphy_2',
                  name: 'Recall past distraction',
                  repetitions: 3,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_murphy_2',
              skillName: 'Heelwork',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_murphy_3',
                  name: 'Left-hand turns',
                  repetitions: 5,
                ),
                RecordedExerciseEntry(
                  id: 'ex_murphy_4',
                  name: 'Halt to automatic sit',
                  repetitions: 4,
                ),
              ],
            ),
            RecordedSkillEntry(
              id: 'sk_murphy_3',
              skillName: 'Stay',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_murphy_5',
                  name: 'Two-minute sit stay',
                  repetitions: 2,
                ),
                RecordedExerciseEntry(
                  id: 'ex_murphy_6',
                  name: 'Out-of-sight down stay',
                  repetitions: 1,
                ),
              ],
            ),
          ],
          dogColor: AppColors.secondarySage,
        ),
        TrainingSession(
          id: 's5',
          dogName: 'Rex',
          dogInitial: 'R',
          dogCategory: 'My Dogs',
          title: 'Protection Work: Sleeve Drive',
          dateLabel: '10 Sep · 17:00',
          date: DateTime(2026, 9, 10),
          startTime: const TimeOfDay(hour: 17, minute: 0),
          finishTime: const TimeOfDay(hour: 18, minute: 0),
          recordedDurationMinutes: 60,
          status: SessionStatus.completed,
          location: 'Västervik Brukshundklubb',
          purpose: 'Club Night',
          notes:
              'Strong commitment through blind search and clean release on command.',
          equipment: const ['Bite Sleeve', 'Harness'],
          rewards: const ['Tug Toy'],
          sessionTags: const ['#ClubNight', '#IGP3_Prep'],
          recordedSkills: const [
            RecordedSkillEntry(
              id: 'sk_rex_1',
              skillName: 'Protection',
              exercises: [
                RecordedExerciseEntry(
                  id: 'ex_rex_1',
                  name: 'Blind search',
                  repetitions: 2,
                ),
                RecordedExerciseEntry(
                  id: 'ex_rex_2',
                  name: 'Hold and bark',
                  repetitions: 3,
                ),
                RecordedExerciseEntry(
                  id: 'ex_rex_3',
                  name: 'Grip development on sleeve',
                  repetitions: 3,
                ),
                RecordedExerciseEntry(
                  id: 'ex_rex_4',
                  name: 'Clean out on command',
                  repetitions: 4,
                ),
              ],
            ),
          ],
          dogColor: AppColors.secondarySage,
        ),
      ];

  static final ValueNotifier<List<TrainingSession>> sessionsNotifier =
      ValueNotifier<List<TrainingSession>>(_defaultSessions());

  static final ValueNotifier<List<SkillCatalogEntry>> skillCatalogNotifier =
      ValueNotifier<List<SkillCatalogEntry>>(_defaultCatalog());

  static bool _loading = false;

  /// Restores saved sessions and the custom-skill catalog from the device.
  /// If nothing was saved yet (fresh install), the illustrative defaults
  /// already loaded into the notifiers above are left in place.
  static Future<void> load() async {
    _loading = true;
    try {
      final sj = await Persist.read('store.trainingSessions');
      if (sj is List && sj.isNotEmpty) {
        sessionsNotifier.value = [for (final m in sj.cast<Map>()) TrainingSession.fromJson(m)];
      }
      final cj = await Persist.read('store.skillCatalog');
      if (cj is List && cj.isNotEmpty) {
        skillCatalogNotifier.value = [for (final m in cj.cast<Map>()) SkillCatalogEntry.fromJson(m)];
      }
    } catch (_) {
    } finally {
      _loading = false;
    }
  }

  static void _saveSessions() {
    if (_loading) return;
    Persist.write('store.trainingSessions', [for (final s in sessionsNotifier.value) s.toJson()]);
  }

  static void _saveCatalog() {
    if (_loading) return;
    Persist.write('store.skillCatalog', [for (final e in skillCatalogNotifier.value) e.toJson()]);
  }

  static TrainingSession? findById(String id) {
    for (final s in sessionsNotifier.value) {
      if (s.id == id) return s;
    }
    return null;
  }

  static void upsertSession(TrainingSession session) {
    final current = List<TrainingSession>.from(sessionsNotifier.value);
    final idx = current.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      current[idx] = session;
    } else {
      current.insert(0, session);
    }
    sessionsNotifier.value = current;
    _saveSessions();
  }

  static void deleteSession(String sessionId) {
    sessionsNotifier.value = sessionsNotifier.value
        .where((s) => s.id != sessionId)
        .toList(growable: false);
    _saveSessions();
  }

  /// Registers a user-created custom skill in the shared catalog so it can be
  /// selected in future sessions and calculated identically to starter skills.
  static SkillCatalogEntry registerCustomSkill(String rawSkillName) {
    final trimmed = rawSkillName.trim();
    final key = normalizeTrainingKey(trimmed);
    final current = List<SkillCatalogEntry>.from(skillCatalogNotifier.value);
    final existingIdx = current.indexWhere(
      (e) => normalizeTrainingKey(e.skillName) == key,
    );
    if (existingIdx >= 0) {
      return current[existingIdx];
    }
    final created = SkillCatalogEntry(
      skillName: trimmed,
      exercises: const [],
      isCustom: true,
    );
    current.add(created);
    skillCatalogNotifier.value = current;
    _saveCatalog();
    return created;
  }

  /// Registers a user-created custom exercise under [rawSkillName] (creating
  /// the skill entry if custom) without duplicating existing exercises.
  static void registerCustomExercise(
    String rawSkillName,
    String rawExerciseName,
  ) {
    final skillTrimmed = rawSkillName.trim();
    final exTrimmed = rawExerciseName.trim();
    if (skillTrimmed.isEmpty || exTrimmed.isEmpty) return;

    final skillKey = normalizeTrainingKey(skillTrimmed);
    final exKey = normalizeTrainingKey(exTrimmed);
    final current = List<SkillCatalogEntry>.from(skillCatalogNotifier.value);
    final idx = current.indexWhere(
      (e) => normalizeTrainingKey(e.skillName) == skillKey,
    );
    if (idx >= 0) {
      final entry = current[idx];
      final alreadyExists = entry.exercises.any(
        (ex) => normalizeTrainingKey(ex) == exKey,
      );
      if (!alreadyExists) {
        current[idx] = entry.copyWith(
          exercises: [...entry.exercises, exTrimmed],
        );
        skillCatalogNotifier.value = current;
        _saveCatalog();
      }
    } else {
      current.add(
        SkillCatalogEntry(
          skillName: skillTrimmed,
          exercises: [exTrimmed],
          isCustom: true,
        ),
      );
      skillCatalogNotifier.value = current;
      _saveCatalog();
    }
  }

  static List<String> exercisesForSkill(String skillName) {
    final key = normalizeTrainingKey(skillName);
    for (final entry in skillCatalogNotifier.value) {
      if (normalizeTrainingKey(entry.skillName) == key) {
        return entry.exercises;
      }
    }
    return const [];
  }

  static bool isCustomSkill(String skillName) {
    final key = normalizeTrainingKey(skillName);
    for (final entry in skillCatalogNotifier.value) {
      if (normalizeTrainingKey(entry.skillName) == key) {
        return entry.isCustom;
      }
    }
    return true;
  }

  static void resetForTesting() {
    sessionsNotifier.value = _defaultSessions();
    skillCatalogNotifier.value = _defaultCatalog();
  }
}

// ─── Main screen ──────────────────────────────────────────────────────────────

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

enum TrainingSubscriptionTier {
  coreOnly,
  coreAndSport,
  coreAndTrainer,
  complete,
}

enum _TrainingPeriod { lifetime, thisYear, last6Months, thisMonth }

/// Training Sessions — bottom-nav Training (Bottom Nav Training handover).
///
/// Compact header with a faded, right-cropped Ulvenik mark; action stack
/// Record Session (green) → Strength & Conditioning → Continue Draft (only
/// when drafts exist); live search; All / My / Client Dogs; Date Range ·
/// Lifetime; Recent Sessions with Newest / Oldest First by recorded date.
/// No bell, Export, Activity Library or Rewards shortcuts (moved to More / the
/// dog's S&C tab).
class _TrainingScreenState extends State<TrainingScreen> {
  bool _hasData = true; // demo toggle: double-tap the title
  int _activeFilter = 0;
  bool _sortNewest = true;
  _TrainingPeriod _period = _TrainingPeriod.lifetime;

  // Subscription tier: Client Dogs only appear with access to client dogs.
  final TrainingSubscriptionTier _subscriptionTier = TrainingSubscriptionTier.complete;

  List<String> get _availableFilters => switch (_subscriptionTier) {
        TrainingSubscriptionTier.coreOnly || TrainingSubscriptionTier.coreAndSport => const ['All Dogs', 'My Dogs'],
        _ => const ['All Dogs', 'My Dogs', 'Client Dogs'],
      };

  String get _selectedFilter => _availableFilters[_activeFilter.clamp(0, _availableFilters.length - 1)];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Derived data ──────────────────────────────────────────────────────────
  DateTime _recordedAt(TrainingSession s) =>
      DateTime(s.date.year, s.date.month, s.date.day, s.startTime.hour, s.startTime.minute);

  String _periodLabel(_TrainingPeriod p) => switch (p) {
        _TrainingPeriod.lifetime => 'Lifetime',
        _TrainingPeriod.thisYear => 'This Year',
        _TrainingPeriod.last6Months => 'Last 6 Months',
        _TrainingPeriod.thisMonth => 'This Month',
      };

  bool _inPeriod(DateTime d) {
    final now = DateTime.now();
    return switch (_period) {
      _TrainingPeriod.lifetime => true,
      _TrainingPeriod.thisYear => d.year == now.year,
      _TrainingPeriod.last6Months => !d.isBefore(DateTime(now.year, now.month - 6, now.day)),
      _TrainingPeriod.thisMonth => d.year == now.year && d.month == now.month,
    };
  }

  List<TrainingSession> _filteredSessionsFrom(List<TrainingSession> all) {
    final list = all.where((s) {
      if (s.status == SessionStatus.draft) return false; // drafts live under Continue Draft
      if (_selectedFilter != 'All Dogs' && s.dogCategory != _selectedFilter) return false;
      if (!_inPeriod(_recordedAt(s))) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery;
        return s.title.toLowerCase().contains(q) ||
            s.dogName.toLowerCase().contains(q) ||
            s.skillTags.any((t) => t.toLowerCase().contains(q)) ||
            s.recordedSkills.any((sk) => sk.exercises.any((ex) => ex.name.toLowerCase().contains(q)));
      }
      return true;
    }).toList();
    list.sort((a, b) => _sortNewest ? _recordedAt(b).compareTo(_recordedAt(a)) : _recordedAt(a).compareTo(_recordedAt(b)));
    return list;
  }

  String _cardMeta(TrainingSession s) {
    final d = _recordedAt(s);
    final hm = '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return [s.dogName, '${d.day} ${_months[d.month - 1]}', hm, ?s.duration].join(' · ');
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  void _showNewSessionSheet() => openNewTrainingSession(context);

  void _openSandC() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DogPickerSheet(
        selected: '',
        hasTrainerPack: _availableFilters.contains('Client Dogs'),
        onSelected: (dog) {
          Navigator.pop(ctx);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DogProfileScreen(dogName: dog.name, initialTab: 'S&C'),
          ));
        },
      ),
    );
  }

  void _openDraft(TrainingSession draft) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrainingSessionScreen(session: draft)));
  }

  void _continueDraft(List<TrainingSession> drafts) {
    if (drafts.length == 1) {
      _openDraft(drafts.first);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              Text('Choose a Draft',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              for (final d in drafts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: UlvenikIcon(UlvenikIcons.play, size: 22, color: AppColors.secondarySage),
                  title: Text(d.title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                  subtitle: Text('${d.dogName} · ${_cardMeta(d).split(' · ').skip(1).take(2).join(' · ')}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  trailing: UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openDraft(d);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPeriodSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Select Time Period',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final p in _TrainingPeriod.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_periodLabel(p), style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
                trailing: _period == p ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () {
                  setState(() => _period = p);
                  Navigator.pop(ctx);
                },
              ),
          ]),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<TrainingSession>>(
      valueListenable: TrainingSessionStore.sessionsNotifier,
      builder: (context, allSessions, _) {
        final completed = allSessions.where((s) => s.status != SessionStatus.draft).toList();
        final filtered = _filteredSessionsFrom(allSessions);
        final drafts = (_hasData ? allSessions.where((s) => s.status == SessionStatus.draft).toList() : <TrainingSession>[])
          ..sort((a, b) => _recordedAt(b).compareTo(_recordedAt(a)));

        return Scaffold(
          backgroundColor: AppColors.backgroundObsidian,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    _ActionRow(
                      label: 'Record Session',
                      icon: UlvenikIcons.recordSession,
                      primary: true,
                      onTap: _showNewSessionSheet,
                    ),
                    const SizedBox(height: 10),
                    _ActionRow(
                      label: 'Strength & Conditioning',
                      icon: UlvenikIcons.strengthConditioning,
                      onTap: _openSandC,
                    ),
                    if (drafts.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _ActionRow(
                        label: 'Continue Draft',
                        icon: UlvenikIcons.play,
                        onTap: () => _continueDraft(drafts),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 14),
                    _buildFilters(),
                    const SizedBox(height: 20),
                    if (_hasData && completed.isNotEmpty) ...[
                      _buildSessionListHeader(),
                      const SizedBox(height: 10),
                      _buildSessionList(filtered),
                    ] else
                      _buildEmptyState(),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 116,
      child: ClipRect(
        child: Stack(children: [
          // Original Ulvenik mark, large, faded and cropped at the right edge.
          Positioned(
            right: -70,
            top: -14,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.16,
                child: Image.asset('assets/images/brand.png', width: 260, cacheWidth: 600, excludeFromSemantics: true),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 120,
            bottom: 18,
            child: GestureDetector(
              onDoubleTap: () => setState(() => _hasData = !_hasData),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Training Sessions',
                    style: TextStyle(
                        color: AppColors.primaryTextOffWhite, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                const SizedBox(height: 2),
                Text(_selectedFilter == 'All Dogs' ? 'Across all dogs' : _selectedFilter,
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 15)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
        decoration: InputDecoration(
          hintText: 'Search sessions, dogs or skills...',
          hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14.5),
          filled: true,
          fillColor: AppColors.cardsCarbon,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: UlvenikIcon(UlvenikIcons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                  onPressed: _searchController.clear,
                ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryForestGreen)),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final isLifetime = _period == _TrainingPeriod.lifetime;
    return Wrap(spacing: 8, runSpacing: 10, children: [
      for (var i = 0; i < _availableFilters.length; i++)
        _Pill(
          label: _availableFilters[i],
          selected: _activeFilter == i,
          onTap: () => setState(() => _activeFilter = i),
        ),
      InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _openPeriodSheet,
        child: Container(
          padding: EdgeInsets.only(left: 12, right: isLifetime ? 12 : 4, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isLifetime ? Colors.white12 : AppColors.primaryForestGreen),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            UlvenikIcon(UlvenikIcons.calendar, size: 15, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 6),
            Text('Date Range · ${_periodLabel(_period)}',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
            if (!isLifetime)
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => setState(() => _period = _TrainingPeriod.lifetime),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 15, color: AppColors.secondaryTextStoneGrey),
                ),
              ),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildSessionListHeader() {
    return Row(children: [
      Expanded(
        child: Text('Recent Sessions',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      TextButton.icon(
        onPressed: () => setState(() => _sortNewest = !_sortNewest),
        icon: AnimatedRotation(
          turns: _sortNewest ? 0 : 0.5,
          duration: const Duration(milliseconds: 250),
          child: UlvenikIcon(UlvenikIcons.sort, size: 16, color: AppColors.secondaryTextStoneGrey),
        ),
        label: Text(_sortNewest ? 'Newest First' : 'Oldest First',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
      ),
    ]);
  }

  Widget _buildSessionList(List<TrainingSession> sessions) {
    if (sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(children: [
          Text('No sessions match your search or filters.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {
              _activeFilter = 0;
              _period = _TrainingPeriod.lifetime;
              _searchController.clear();
            }),
            child: Text('Clear Filters', style: TextStyle(color: AppColors.primaryTextOffWhite)),
          ),
        ]),
      );
    }
    return Column(children: [
      for (final s in sessions) ...[
        _SessionCard(
          title: s.title,
          meta: _cardMeta(s),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrainingSessionScreen(session: s))),
        ),
        const SizedBox(height: 10),
      ],
    ]);
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        UlvenikIcon(UlvenikIcons.training, size: 36, color: AppColors.secondarySage),
        const SizedBox(height: 16),
        Text('No sessions yet',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text("Record your first session to start building your dog's training history.",
            textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.5)),
      ]),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String label;
  final String icon;
  final bool primary;
  final VoidCallback onTap;
  const _ActionRow({required this.label, required this.icon, required this.onTap, this.primary = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: primary ? AppColors.primaryForestGreen : Colors.white12),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            UlvenikIcon(icon, size: 24, color: primary ? AppColors.primaryTextOffWhite : const Color(0xFF6FBF8E)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Pill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? AppColors.primaryForestGreen : Colors.white12),
          ),
          child: Text(label,
              style: TextStyle(
                color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
        ),
      );
}

/// Compact Training History card: title, dog · date · time · duration, chevron.
class _SessionCard extends StatelessWidget {
  final String title;
  final String meta;
  final VoidCallback onTap;
  const _SessionCard({required this.title, required this.meta, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(meta, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                ]),
              ),
              UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
            ]),
          ),
        ),
      );
}

// ─── Shared New Training Session entry point ─────────────────────────────────

const List<String> _shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Default title when the user leaves Session Name blank (Training Tab v39):
/// "Training Session · 7 Nov 2026".
String defaultTrainingSessionTitle(DateTime d) =>
    'Training Session · ${d.day} ${_shortMonths[d.month - 1]} ${d.year}';

/// Opens the one shared New Training Session workflow used by the main
/// Training tab, the dog profile, skill pages and exercise pages.
///
/// When [dogName] is supplied that dog is preselected and the dog picker is
/// skipped; otherwise the user chooses the dog first.
void openNewTrainingSession(
  BuildContext context, {
  String? dogName,
  String dogCategory = 'My Dogs',
}) {
  if (dogName == null) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _NewSessionSheet(),
    );
    return;
  }
  final now = DateTime.now();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TrainingSessionScreen(
        session: TrainingSession(
          id: 'session_${now.microsecondsSinceEpoch}',
          dogName: dogName,
          dogInitial: dogName.isEmpty ? '?' : dogName[0].toUpperCase(),
          dogCategory: dogCategory,
          title: defaultTrainingSessionTitle(now),
          dateLabel: 'Today · Draft',
          date: now,
          startTime: TimeOfDay.now(),
          status: SessionStatus.draft,
          recordedSkills: const [],
          notes: '',
          dogColor: AppColors.secondarySage,
        ),
        isNewSession: true,
      ),
    ),
  );
}

// ─── New Session bottom sheet ─────────────────────────────────────────────────

class _NewSessionSheet extends StatefulWidget {
  @override
  State<_NewSessionSheet> createState() => _NewSessionSheetState();
}

class _NewSessionSheetState extends State<_NewSessionSheet> {
  Map<String, dynamic>? _selectedDog;

  final List<Map<String, dynamic>> _dogs = [
    {
      'name': 'Cooper',
      'initial': 'C',
      'breed': 'Border Collie',
      'category': 'My Dogs',
      'color': AppColors.secondarySage,
    },
    {
      'name': 'Jax',
      'initial': 'J',
      'breed': 'Belgian Malinois',
      'category': 'My Dogs',
      'color': AppColors.infoAlpineBlue,
    },
    {
      'name': 'Lady',
      'initial': 'L',
      'breed': 'Labrador Retriever',
      'category': 'My Dogs',
      'color': AppColors.secondarySage,
    },
    {
      'name': 'Rex',
      'initial': 'R',
      'breed': 'German Shepherd',
      'category': 'My Dogs',
      'color': AppColors.secondarySage,
    },
    {
      'name': 'Murphy',
      'initial': 'M',
      'breed': 'Working Cocker Spaniel',
      'category': 'Client Dogs',
      'color': AppColors.secondarySage,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppColors.cardBorder),
          ),
          padding: EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'New Training Session',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select the dog for this session',
                  style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                // Dog list
                ..._dogs.map((dog) {
                  final isSelected =
                      _selectedDog != null && _selectedDog!['name'] == dog['name'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDog = dog),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryForestGreen
                                .withValues(alpha: 0.15)
                            : AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryForestGreen
                              : Colors.white12,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: (dog['color'] as Color)
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                dog['initial'] as String,
                                style: TextStyle(
                                  color: dog['color'] as Color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dog['name'] as String,
                                style: TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                dog['breed'] as String,
                                style: TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (isSelected)
                            UlvenikIcon(UlvenikIcons.completed,
                                color: AppColors.primaryForestGreen, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                // CTA
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedDog == null
                        ? null
                        : () {
                            final dog = _selectedDog!;
                            final now = DateTime.now();
                            final start = TimeOfDay.now();
                            final newSession = TrainingSession(
                              id: 'session_${now.microsecondsSinceEpoch}',
                              dogName: dog['name'] as String,
                              dogInitial: dog['initial'] as String,
                              dogCategory: dog['category'] as String,
                              title: defaultTrainingSessionTitle(now),
                              dateLabel: 'Today · Draft',
                              date: now,
                              startTime: start,
                              status: SessionStatus.draft,
                              recordedSkills: const [],
                              notes: '',
                              dogColor: dog['color'] as Color,
                            );
                            final navigator = Navigator.of(context);
                            navigator.pop();
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => TrainingSessionScreen(
                                  session: newSession,
                                  isNewSession: true,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      disabledBackgroundColor:
                          AppColors.primaryForestGreen.withValues(alpha: 0.3),
                      foregroundColor: AppColors.onForestGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      _selectedDog == null
                          ? 'Select a Dog to Continue'
                          : 'Start Session with ${_selectedDog!['name']} →',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
