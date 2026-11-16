import '../data/health_store.dart';
import '../data/media_store.dart';
import '../data/sc_store.dart';
import '../data/sport_store.dart';
import 'health_log_screen.dart';
import 'sc_session_details_screen.dart';
import 'sport_competition_screens.dart';
import 'sport_session_screens.dart';
import 'training_screen.dart';
import 'training_session_screen.dart';
import '../data/timeline_store.dart';
import 'timeline_milestone_screens.dart';

/// Builds the route back to a record for Media. One link per record, so a file
/// attached to several records still shows once in the library.
class MediaLinks {
  MediaLinks._();

  static MediaLink training(TrainingSession s) => MediaLink(
        key: 'training:${s.id}',
        section: 'Training',
        label: () => s.title,
        collections: () => [
          for (final k in s.recordedSkills) k.skillName,
        ],
        open: (_) => TrainingSessionScreen(session: s),
      );

  static MediaLink sc(String dog, String sessionId) => MediaLink(
        key: 'sc:$sessionId',
        section: 'S&C',
        label: () => SCStore.instance.session(dog, sessionId)?.name ?? 'S&C Session',
        collections: () => [
          for (final e in SCStore.instance.session(dog, sessionId)?.entries ?? <SCEntry>[]) e.activityName,
        ],
        open: (_) => SCSessionDetailsScreen(dogName: dog, sessionId: sessionId),
      );

  static MediaLink sport(String dog, String sessionId) => MediaLink(
        key: 'sport:$sessionId',
        section: 'Sport',
        label: () => SportStore.instance.session(dog, sessionId)?.name ?? 'Sport Session',
        collections: () => [
          for (final e in SportStore.instance.session(dog, sessionId)?.entries ?? <SportEntry>[]) ...[
            e.sportName,
            ...e.itemNames,
          ],
        ],
        open: (_) => SportSessionDetailsScreen(dogName: dog, sessionId: sessionId),
      );

  static MediaLink competition(String dog, String id) => MediaLink(
        key: 'competition:$id',
        section: 'Sport',
        label: () => SportStore.instance.competition(dog, id)?.name ?? 'Competition',
        collections: () => [SportStore.instance.competition(dog, id)?.sportName ?? ''],
        open: (_) => CompetitionDetailsScreen(dogName: dog, competitionId: id),
      );

  static MediaLink health(String dog, LogConfig config, String logId) => MediaLink(
        key: 'health:$logId',
        section: 'Health',
        label: () {
          for (final l in HealthStore.instance.allLogs(dog)) {
            if (l.id == logId) return l.title.isNotEmpty ? l.title : config.noun;
          }
          return config.noun;
        },
        collections: () => const [],
        open: (_) => healthLogDetails(dog, config, logId),
      );

  static MediaLink milestone(String id) => MediaLink(
        key: 'milestone:$id',
        section: 'Training',
        label: () => TimelineStore.instance.milestone(id)?.title ?? 'Milestone',
        collections: () => const [],
        open: (_) => MilestoneDetailsScreen(milestoneId: id),
      );

  /// Rebuilds a link from its saved key when the app starts.
  static MediaLink? fromKey(String dog, String key) {
    final i = key.indexOf(':');
    if (i < 0) return null;
    final type = key.substring(0, i);
    final id = key.substring(i + 1);
    switch (type) {
      case 'sc':
        return sc(dog, id);
      case 'sport':
        return sport(dog, id);
      case 'competition':
        return competition(dog, id);
      case 'milestone':
        return milestone(id);
      case 'training':
        final s = TrainingSessionStore.findById(id);
        return s == null ? null : training(s);
      case 'health':
        for (final l in HealthStore.instance.allLogs(dog)) {
          if (l.id == id) {
            final cfg = allHealthConfigs.where((c) => c.area == l.area).firstOrNull;
            return cfg == null ? null : health(dog, cfg, id);
          }
        }
        return null;
    }
    return null;
  }

  /// Every existing record of this dog that media can be linked to.
  static List<MediaLink> available(String dog) {
    final out = <MediaLink>[];
    for (final s in TrainingSessionStore.sessionsNotifier.value.where((s) => s.dogName == dog)) {
      out.add(training(s));
    }
    for (final s in SCStore.instance.sessions(dog)) {
      out.add(sc(dog, s.id));
    }
    for (final s in SportStore.instance.sessions(dog)) {
      out.add(sport(dog, s.id));
    }
    for (final c in SportStore.instance.competitions(dog)) {
      out.add(competition(dog, c.id));
    }
    for (final l in HealthStore.instance.allLogs(dog)) {
      final cfg = allHealthConfigs.where((c) => c.area == l.area).firstOrNull;
      if (cfg != null) out.add(health(dog, cfg, l.id));
    }
    return out;
  }
}
