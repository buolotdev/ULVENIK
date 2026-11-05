import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'training_session_screen.dart';
import 'strength_conditioning_dashboard_screen.dart';
import 'activity_library_screen.dart';
import 'export_screen.dart';
import 'rewards_management_screen.dart';

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
  final String dogCategory; // 'My Dogs', 'Sport Dogs', 'Client Dogs'
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
          dogCategory: 'Sport Dogs',
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
          dogCategory: 'Sport Dogs',
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

        // ── Additional Workspace Records (Draft + Client/Sport Dogs) ──
        TrainingSession(
          id: 's1',
          dogName: 'Rex',
          dogInitial: 'R',
          dogCategory: 'Sport Dogs',
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
          dogCategory: 'Sport Dogs',
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
  }

  static void deleteSession(String sessionId) {
    sessionsNotifier.value = sessionsNotifier.value
        .where((s) => s.id != sessionId)
        .toList(growable: false);
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

class _TrainingScreenState extends State<TrainingScreen> {
  bool _hasData = true;
  int _activeFilter = 0;
  bool _sortNewest = true;
  bool _videoPlaying = false;

  // Subscription tier: adapts dog filters per client requirement
  TrainingSubscriptionTier _subscriptionTier =
      TrainingSubscriptionTier.complete;

  List<String> get _availableFilters {
    switch (_subscriptionTier) {
      case TrainingSubscriptionTier.coreOnly:
        return const []; // Core only: no category filter needed
      case TrainingSubscriptionTier.coreAndSport:
        return const ['All Dogs', 'My Dogs', 'Sport Dogs'];
      case TrainingSubscriptionTier.coreAndTrainer:
        return const ['All Dogs', 'My Dogs', 'Client Dogs'];
      case TrainingSubscriptionTier.complete:
        return const ['All Dogs', 'My Dogs', 'Sport Dogs', 'Client Dogs'];
    }
  }

  // Active filter chips (date range; dog chips can also be added/cleared)
  final List<String> _activeChips = ['Last 30 Days'];

  static const Set<String> _knownDogNames = {
    'Cooper',
    'Jax',
    'Lady',
    'Rex',
    'Murphy',
    'Koda',
  };

  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const String _heroImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAzU4TdlERYJVUgVdsr7lJ8DZFavYDTksXswDyQuEMLlNsKiXqJGjJad2zRGqd2ibKYehwzPDTAizHKzNhifbp44NfWAFL-Rl4zffvvhWUMt93n77tVP4tql3yPVRn8sNdzWjJLNSKuYVoDJXAnLeoqdAtzst_h1iNayOteb9nZ0HLwqIgjNL3zU2DYy8wU-k1SfK2rg8DPnSut9yIGwM0aDTFJGGUGg76OCK6Laj93d4g7ijmaPXU';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Derived filtered + sorted session list ────────────────────────────────

  List<TrainingSession> _filteredSessionsFrom(List<TrainingSession> all) {
    final selectedFilter = _availableFilters.isNotEmpty
        ? _availableFilters[
            _activeFilter.clamp(0, _availableFilters.length - 1)]
        : 'All Dogs';

    final list = all.where((s) {
      // Category filter
      if (selectedFilter != 'All Dogs' && s.dogCategory != selectedFilter) {
        return false;
      }
      // Active chip dog filter
      final chipDogs = _activeChips.where(_knownDogNames.contains).toList();
      if (chipDogs.isNotEmpty && !chipDogs.contains(s.dogName)) return false;
      // Search across session title, dog name, recorded skills, and exercises
      if (_searchQuery.isNotEmpty) {
        final matchesTitle = s.title.toLowerCase().contains(_searchQuery);
        final matchesDog = s.dogName.toLowerCase().contains(_searchQuery);
        final matchesSkill =
            s.skillTags.any((t) => t.toLowerCase().contains(_searchQuery));
        final matchesExercise = s.recordedSkills.any(
          (sk) => sk.exercises
              .any((ex) => ex.name.toLowerCase().contains(_searchQuery)),
        );
        return matchesTitle || matchesDog || matchesSkill || matchesExercise;
      }
      return true;
    }).toList();

    return _sortNewest ? list : list.reversed.toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<TrainingSession>>(
      valueListenable: TrainingSessionStore.sessionsNotifier,
      builder: (context, allSessions, _) {
        final filtered = _filteredSessionsFrom(allSessions);
        final draftSession = allSessions
            .where((s) => s.status == SessionStatus.draft)
            .firstOrNull;

        return Scaffold(
          backgroundColor: AppColors.backgroundObsidian,
          body: CustomScrollView(
            slivers: [
              _buildHero(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      _buildQuickActions(draftSession),
                      const SizedBox(height: 20),
                      _buildFilterPills(),
                      const SizedBox(height: 16),
                      if (_hasData && allSessions.isNotEmpty) ...[
                        if (_activeChips.isNotEmpty) ...[
                          _buildActiveChips(),
                          const SizedBox(height: 20),
                        ],
                        _buildSessionListHeader(filtered.length),
                        const SizedBox(height: 12),
                        _buildSessionList(filtered),
                      ] else
                        _buildEmptyState(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: false,
      stretch: true,
      backgroundColor: AppColors.backgroundObsidian,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _heroImage,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColors.cardsCarbon),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33101214), AppColors.backgroundObsidian],
                ),
              ),
            ),
            // Top controls
            Positioned(
              top: 48,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ExportScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.ios_share,
                          color: AppColors.primaryTextOffWhite, size: 18),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.cardsCarbon,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const UlvenikIcon(UlvenikIcons.notifications,
                            color: AppColors.primaryTextOffWhite, size: 20),
                      ),
                      Positioned(
                        top: 8,
                        right: 9,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primaryForestGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.backgroundObsidian,
                                width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Hero text — double tap to toggle state
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: GestureDetector(
                onDoubleTap: () => setState(() => _hasData = !_hasData),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          final nextIndex = (_subscriptionTier.index + 1) %
                              TrainingSubscriptionTier.values.length;
                          _subscriptionTier =
                              TrainingSubscriptionTier.values[nextIndex];
                          _activeFilter = 0;
                        });
                        final tierLabel = switch (_subscriptionTier) {
                          TrainingSubscriptionTier.coreOnly =>
                            'Core only (No filter)',
                          TrainingSubscriptionTier.coreAndSport =>
                            'Core + Sport (All | My Dogs | Sport)',
                          TrainingSubscriptionTier.coreAndTrainer =>
                            'Core + Trainer (All | My Dogs | Client)',
                          TrainingSubscriptionTier.complete =>
                            'Complete (All | My Dogs | Sport | Client)',
                        };
                        AppSnackbar.show(context,
                            message: 'Filter Mode: $tierLabel',
                            type: SnackbarType.info);
                      },
                      child: const Text(
                        'TRAINING',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Training Sessions',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Across all dogs',
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search,
              color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search sessions, dogs, skills...',
                hintStyle: TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => AppSnackbar.show(context,
                message: 'Voice search coming soon', type: SnackbarType.info),
            child: const Icon(Icons.mic_outlined,
                color: AppColors.secondaryTextStoneGrey, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Quick actions ─────────────────────────────────────────────────────────

  Widget _buildQuickActions(TrainingSession? draftSession) {
    final hasDraft = _hasData && draftSession != null;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                label: 'Record Session',
                icon: Icons.add,
                isPrimary: true,
                onTap: _showNewSessionSheet,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickAction(
                label: 'Strength & Conditioning',
                icon: Icons.fitness_center,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const StrengthConditioningDashboardScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                label: 'Activity Library',
                icon: Icons.list_alt,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ActivityLibraryScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickAction(
                label: hasDraft ? 'Continue Draft' : 'Recent Sessions',
                icon: hasDraft ? Icons.edit_outlined : Icons.schedule_outlined,
                hasDot: hasDraft,
                onTap: () {
                  if (hasDraft) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            TrainingSessionScreen(session: draftSession),
                      ),
                    );
                  } else {
                    setState(() {
                      _sortNewest = true;
                      _searchController.clear();
                    });
                    AppSnackbar.show(context,
                        message: 'Showing most recent sessions',
                        type: SnackbarType.info);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                label: 'Rewards & Reinforcers',
                icon: Icons.sports_baseball_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RewardsManagementScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required String label,
    required IconData icon,
    bool isPrimary = false,
    bool hasDot = false,
    VoidCallback? onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isPrimary
                    ? AppColors.primaryForestGreen
                    : AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isPrimary
                        ? AppColors.primaryForestGreen
                        : Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  UlvenikIcon.fromMaterial(icon,
                      size: 18,
                      color: isPrimary
                          ? AppColors.primaryTextOffWhite
                          : AppColors.secondaryTextStoneGrey),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasDot)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.backgroundObsidian, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  // ── Filter pills ──────────────────────────────────────────────────────────

  Widget _buildFilterPills() {
    if (_availableFilters.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: List.generate(_availableFilters.length, (i) {
        final isActive = _activeFilter == i;
        return GestureDetector(
          onTap: () => setState(() => _activeFilter = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryForestGreen
                  : AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                  color:
                      isActive ? AppColors.primaryForestGreen : Colors.white12),
            ),
            child: Text(
              _availableFilters[i],
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryTextOffWhite
                    : AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Active chips ──────────────────────────────────────────────────────────

  Widget _buildActiveChips() {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _activeChips
                .map((chip) => _buildChip(chip,
                    onRemove: () => setState(() => _activeChips.remove(chip))))
                .toList(),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _activeChips.clear()),
          child: const Text('Clear All',
              style:
                  TextStyle(color: AppColors.primaryForestGreen, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(
            color: AppColors.primaryForestGreen.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite, fontSize: 12)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: AppColors.secondaryTextStoneGrey),
          ),
        ],
      ),
    );
  }

  // ── Session list header ───────────────────────────────────────────────────

  Widget _buildSessionListHeader(int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'RECENT SESSIONS ($count)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _sortNewest = !_sortNewest),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _sortNewest ? 'Newest First' : 'Oldest First',
                style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                turns: _sortNewest ? 0 : 0.5,
                duration: const Duration(milliseconds: 250),
                child: const UlvenikIcon(UlvenikIcons.sort,
                    size: 16, color: AppColors.secondaryTextStoneGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Session list ──────────────────────────────────────────────────────────

  Widget _buildSessionList(List<TrainingSession> sessions) {
    if (sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off,
                  size: 40,
                  color:
                      AppColors.secondaryTextStoneGrey.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              const Text(
                'No sessions match your filters',
                style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _activeFilter = 0;
                    _activeChips.clear();
                    _searchController.clear();
                  });
                },
                child: const Text('Clear Filters',
                    style: TextStyle(color: AppColors.primaryForestGreen)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: sessions
          .map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSessionCard(s),
              ))
          .toList(),
    );
  }

  Widget _buildSessionCard(TrainingSession session) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrainingSessionScreen(session: session),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardThumbnail(session),
              const SizedBox(width: 16),
              Expanded(child: _buildCardContent(session)),
              if (session.status == SessionStatus.draft) _buildDraftBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardThumbnail(TrainingSession session) {
    if (session.thumbnailUrl != null) {
      return GestureDetector(
        onTap: () => setState(() => _videoPlaying = !_videoPlaying),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Image.network(
                  session.thumbnailUrl!,
                  fit: BoxFit.cover,
                  color: Colors.black45,
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (_, _, _) =>
                      Container(color: const Color(0xFF111412)),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      key: ValueKey(_videoPlaying),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Colors.black54, shape: BoxShape.circle),
                      child: UlvenikIcon.fromMaterial(
                        _videoPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.primaryTextOffWhite,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // No thumbnail
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF111412),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: UlvenikIcon.fromMaterial(
        session.status == SessionStatus.draft
            ? Icons.edit_outlined
            : Icons.landscape_outlined,
        color: session.status == SessionStatus.draft
            ? AppColors.secondaryTextStoneGrey
            : AppColors.secondaryTextStoneGrey.withValues(alpha: 0.2),
        size: session.status == SessionStatus.draft ? 28 : 36,
      ),
    );
  }

  Widget _buildCardContent(TrainingSession session) {
    final hasStats =
        session.duration != null || session.recordedSkills.isNotEmpty;
    final recordedSkillTags = session.skillTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dog row
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: session.dogColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12),
              ),
              child: Center(
                child: Text(
                  session.dogInitial,
                  style: TextStyle(
                    color: session.dogColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              session.dogName,
              style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          session.title,
          style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          session.dateLabel,
          style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey, fontSize: 12),
        ),
        // Automatically calculated stats row (duration · distinct skills · distinct exercises)
        if (hasStats) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              if (session.duration != null)
                _buildStat(Icons.schedule_outlined, session.duration!),
              if (session.recordedSkills.isNotEmpty)
                _buildStat(Icons.layers_outlined, session.formattedSkillCount),
              if (session.recordedSkills.isNotEmpty)
                _buildStat(Icons.repeat, session.formattedExerciseCount),
            ],
          ),
        ],
        // Skill tags automatically matching the skills recorded in this session
        if (recordedSkillTags.isNotEmpty ||
            session.photoCount != null ||
            session.videoCount != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...recordedSkillTags.map(_buildTag),
              if (session.photoCount != null)
                _buildMediaTag(
                    Icons.photo_camera_outlined, '${session.photoCount}'),
              if (session.videoCount != null)
                _buildMediaTag(
                    Icons.videocam_outlined, '${session.videoCount}'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UlvenikIcon.fromMaterial(icon, size: 13, color: AppColors.secondaryTextStoneGrey),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF111412),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
    );
  }

  Widget _buildMediaTag(IconData icon, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF111412),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UlvenikIcon.fromMaterial(icon, size: 10, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 3),
          Text(count,
              style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDraftBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF8d504a),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'DRAFT',
        style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: const Icon(Icons.bookmark_border_outlined,
                color: AppColors.primaryForestGreen, size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Sessions Yet',
            style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            "Start recording your first training\nsession to begin building your dog's\nlifelong training history.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showNewSessionSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.primaryTextOffWhite,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Record Training Session',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── New Session bottom sheet ───────────────────────────────────────────────

  void _showNewSessionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _NewSessionSheet(),
    );
  }
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
      'category': 'Sport Dogs',
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
      'category': 'Sport Dogs',
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
            border: Border.all(color: Colors.white12),
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
                const Text(
                  'New Training Session',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
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
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                dog['breed'] as String,
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (isSelected)
                            const UlvenikIcon(UlvenikIcons.completed,
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
                              title: '${dog['name']} Training Session',
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
                      foregroundColor: AppColors.primaryTextOffWhite,
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
