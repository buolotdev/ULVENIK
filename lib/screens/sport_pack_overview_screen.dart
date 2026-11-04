import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'competition_details_screen.dart';
import 'competitions_overview_screen.dart';
import 'create_sport_screen.dart';
import 'my_sports_screen.dart';
import 'record_competition_result_screen.dart';
import 'sport_details_igp_screen.dart';
import 'subscription_details_screen.dart';

class SportDogWorkspace {
  final String id;
  final String name;
  final String breed;
  final int totalSports;
  final int sportSkills;
  final int trainingSessions;
  final int upcomingCompetitions;
  final int competitionsCompleted;
  final int qualifications;

  const SportDogWorkspace({
    required this.id,
    required this.name,
    required this.breed,
    required this.totalSports,
    required this.sportSkills,
    required this.trainingSessions,
    required this.upcomingCompetitions,
    required this.competitionsCompleted,
    required this.qualifications,
  });
}

class SportEntryModel {
  final String id;
  final String name;
  final String tag;
  final String organisation;
  final String currentLevel;
  final String targetLevel;
  final String scoringSystem;
  final int skillsCount;
  final int sessionsCount;
  final int competitionsCount;
  final String lastTrained;
  final String? nextCompetitionDate;
  final bool isArchived;
  final String notes;

  const SportEntryModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.organisation,
    this.currentLevel = 'IGP 1',
    this.targetLevel = 'IGP 2',
    this.scoringSystem = 'Points (0–300)',
    required this.skillsCount,
    required this.sessionsCount,
    required this.competitionsCount,
    required this.lastTrained,
    this.nextCompetitionDate,
    this.isArchived = false,
    this.notes = '',
  });

  SportEntryModel copyWith({
    String? name,
    String? tag,
    String? organisation,
    String? currentLevel,
    String? targetLevel,
    String? scoringSystem,
    int? skillsCount,
    int? sessionsCount,
    int? competitionsCount,
    String? lastTrained,
    String? nextCompetitionDate,
    bool? isArchived,
    String? notes,
  }) {
    return SportEntryModel(
      id: id,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      organisation: organisation ?? this.organisation,
      currentLevel: currentLevel ?? this.currentLevel,
      targetLevel: targetLevel ?? this.targetLevel,
      scoringSystem: scoringSystem ?? this.scoringSystem,
      skillsCount: skillsCount ?? this.skillsCount,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      competitionsCount: competitionsCount ?? this.competitionsCount,
      lastTrained: lastTrained ?? this.lastTrained,
      nextCompetitionDate: nextCompetitionDate ?? this.nextCompetitionDate,
      isArchived: isArchived ?? this.isArchived,
      notes: notes ?? this.notes,
    );
  }
}

class SportCompetitionModel {
  final String id;
  final String title;
  final String sportTag;
  final String level;
  final String date;
  final String location;
  final String status; // 'Upcoming', 'Completed', 'Withdrawn', 'Cancelled'
  final String judge;
  final String organisation;
  final int? totalScore;
  final int? maxScore;
  final int? phaseAScore;
  final int? phaseBScore;
  final int? phaseCScore;
  final String? placement;
  final String? qualificationResult;
  final String notes;

  const SportCompetitionModel({
    required this.id,
    required this.title,
    required this.sportTag,
    this.level = 'IGP 2',
    required this.date,
    required this.location,
    required this.status,
    this.judge = 'Klaus Richter (SV)',
    this.organisation = 'SV',
    this.totalScore,
    this.maxScore = 300,
    this.phaseAScore,
    this.phaseBScore,
    this.phaseCScore,
    this.placement,
    this.qualificationResult,
    this.notes = '',
  });

  bool get isUpcoming => status != 'Completed';

  SportCompetitionModel copyWith({
    String? title,
    String? sportTag,
    String? level,
    String? date,
    String? location,
    String? status,
    String? judge,
    String? organisation,
    int? totalScore,
    int? maxScore,
    int? phaseAScore,
    int? phaseBScore,
    int? phaseCScore,
    String? placement,
    String? qualificationResult,
    String? notes,
  }) {
    return SportCompetitionModel(
      id: id,
      title: title ?? this.title,
      sportTag: sportTag ?? this.sportTag,
      level: level ?? this.level,
      date: date ?? this.date,
      location: location ?? this.location,
      status: status ?? this.status,
      judge: judge ?? this.judge,
      organisation: organisation ?? this.organisation,
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      phaseAScore: phaseAScore ?? this.phaseAScore,
      phaseBScore: phaseBScore ?? this.phaseBScore,
      phaseCScore: phaseCScore ?? this.phaseCScore,
      placement: placement ?? this.placement,
      qualificationResult: qualificationResult ?? this.qualificationResult,
      notes: notes ?? this.notes,
    );
  }
}

class SportActivityItem {
  final String id;
  final IconData icon;
  final String title;
  final String sportTag;
  final String timeAgo;
  final String detailSummary;

  const SportActivityItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.sportTag,
    required this.timeAgo,
    required this.detailSummary,
  });
}

class SportQualificationModel {
  final String id;
  final String title;
  final String kind; // 'Qualification' or 'Award'
  final String sportTag;
  final String date;
  final String? organisation;
  final String scoreSummary;

  const SportQualificationModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.sportTag,
    required this.date,
    this.organisation,
    required this.scoreSummary,
  });
}

/// Shared reactive state across Batch 10A Sport Pack screens.
class SportPackStore extends ChangeNotifier {
  SportPackStore._();
  static final SportPackStore instance = SportPackStore._();

  int selectedDogIndex = 0;

  final List<SportDogWorkspace> dogs = const [
    SportDogWorkspace(
      id: 'zeus',
      name: 'Zeus',
      breed: 'Belgian Malinois',
      totalSports: 3,
      sportSkills: 42,
      trainingSessions: 286,
      upcomingCompetitions: 2,
      competitionsCompleted: 9,
      qualifications: 7,
    ),
    SportDogWorkspace(
      id: 'freja',
      name: 'Freja',
      breed: 'Dutch Shepherd',
      totalSports: 2,
      sportSkills: 29,
      trainingSessions: 164,
      upcomingCompetitions: 1,
      competitionsCompleted: 5,
      qualifications: 4,
    ),
    SportDogWorkspace(
      id: 'koda',
      name: 'Koda',
      breed: 'German Shepherd',
      totalSports: 2,
      sportSkills: 24,
      trainingSessions: 118,
      upcomingCompetitions: 1,
      competitionsCompleted: 3,
      qualifications: 2,
    ),
  ];

  final List<SportEntryModel> sports = [
    const SportEntryModel(
      id: 'igp',
      name: 'IGP',
      tag: 'IGP',
      organisation: 'Organisation: SV',
      currentLevel: 'IGP 1',
      targetLevel: 'IGP 2',
      scoringSystem: '3-Phase Points (A/B/C · 300 max)',
      skillsCount: 18,
      sessionsCount: 286,
      competitionsCount: 7,
      lastTrained: 'Yesterday',
      nextCompetitionDate: '18 Sep 2026',
      notes: 'Focusing on Phase A corner precision and Phase C calm grip transitions.',
    ),
    const SportEntryModel(
      id: 'agility',
      name: 'Agility',
      tag: 'Agility',
      organisation: 'No organisation',
      currentLevel: 'Grade 4',
      targetLevel: 'Grade 5',
      scoringSystem: 'Time + Faults',
      skillsCount: 12,
      sessionsCount: 146,
      competitionsCount: 4,
      lastTrained: '3 days ago',
      notes: 'Independent weave entries and tight wraps on jumps.',
    ),
    const SportEntryModel(
      id: 'psa',
      name: 'PSA',
      tag: 'PSA',
      organisation: 'Organisation: PSA UK',
      currentLevel: 'PDC',
      targetLevel: 'PSA 1',
      scoringSystem: 'Obedience + Protection Points',
      skillsCount: 8,
      sessionsCount: 54,
      competitionsCount: 0,
      lastTrained: '2 weeks ago',
      notes: 'Decoy neutrality and environmental surprise scenarios.',
    ),
  ];

  final List<SportCompetitionModel> competitions = [
    const SportCompetitionModel(
      id: 'essex_trial',
      title: 'Essex Working Dog Trial',
      sportTag: 'IGP',
      level: 'IGP 2',
      date: '18 Sep 2026',
      location: 'Essex, UK',
      status: 'Entered',
      judge: 'Heinrich Weber (SV)',
      organisation: 'SV / GSDL',
      notes: 'Early morning tracking draw on lush pasture; bring tracking flag & leather 10m line.',
    ),
    const SportCompetitionModel(
      id: 'club_autumn',
      title: 'Club Trial — Autumn 2026',
      sportTag: 'IGP',
      level: 'IGP 2',
      date: '12 Oct 2026',
      location: 'Location TBC',
      status: 'Upcoming',
      judge: 'Martin Lindqvist',
      organisation: 'SV',
      notes: 'Autumn regional club trial targeting IGP 2 qualification.',
    ),
    const SportCompetitionModel(
      id: 'igp1_qual',
      title: 'Southern Regional SV Trial',
      sportTag: 'IGP',
      level: 'IGP 1',
      date: '15 Sep 2026',
      location: 'Surrey, UK',
      status: 'Completed',
      judge: 'Klaus Richter (SV)',
      organisation: 'SV',
      totalScore: 282,
      maxScore: 300,
      phaseAScore: 96,
      phaseBScore: 91,
      phaseCScore: 95,
      placement: '1st Place',
      qualificationResult: 'Qualified · SG (Very Good)',
      notes: 'Awarded Best Protection Work; crisp outs and deep full grips.',
    ),
    const SportCompetitionModel(
      id: 'midlands_agility',
      title: 'Midlands Open Agility Cup',
      sportTag: 'Agility',
      level: 'Grade 4',
      date: '02 Aug 2026',
      location: 'Warwickshire, UK',
      status: 'Completed',
      judge: 'Claire Bennett',
      organisation: 'KC',
      totalScore: 0,
      maxScore: 0,
      placement: '2nd Place · Clear Round',
      qualificationResult: 'Clear · 34.82s',
      notes: 'Fast weave execution, zero contact faults.',
    ),
    const SportCompetitionModel(
      id: 'bh_vt_trial',
      title: 'Spring Working Dog BH/VT',
      sportTag: 'IGP',
      level: 'BH-VT',
      date: '10 May 2026',
      location: 'Kent, UK',
      status: 'Completed',
      judge: 'Thomas Becker',
      organisation: 'SV',
      totalScore: 58,
      maxScore: 60,
      placement: 'Passed',
      qualificationResult: 'BH/VT Qualified',
      notes: 'Clean traffic portion and focused off-lead heeling.',
    ),
  ];

  final List<SportActivityItem> recentActivities = [
    const SportActivityItem(
      id: 'act_1',
      icon: Icons.emoji_events_outlined,
      title: 'IGP 1 Qualification recorded',
      sportTag: 'IGP',
      timeAgo: '2 days ago',
      detailSummary: 'Southern Regional SV Trial · 282 / 300 pts (A: 96 · B: 91 · C: 95) · SG',
    ),
    const SportActivityItem(
      id: 'act_2',
      icon: Icons.layers_outlined,
      title: 'Advanced Tracking — session',
      sportTag: 'IGP',
      timeAgo: 'Yesterday',
      detailSummary: '600 paces, 4 corners, 3 articles indicated cleanly in 18 mph crosswind.',
    ),
    const SportActivityItem(
      id: 'act_3',
      icon: Icons.add,
      title: 'Competition added',
      sportTag: 'IGP',
      timeAgo: '3 days ago',
      detailSummary: 'Essex Working Dog Trial (18 Sep 2026 · Essex, UK) marked as Entered.',
    ),
    const SportActivityItem(
      id: 'act_4',
      icon: Icons.star_border_rounded,
      title: 'Agility Weave Poles skill',
      sportTag: 'Agility',
      timeAgo: '1 week ago',
      detailSummary: '12-pole independent entry speed improved to 2.95s over 6 reps.',
    ),
  ];

  final List<SportQualificationModel> qualifications = [
    const SportQualificationModel(
      id: 'qual_igp1',
      title: 'IGP 1',
      kind: 'Qualification',
      sportTag: 'IGP',
      date: '15 Sep 2026',
      organisation: 'SV',
      scoreSummary: '282 / 300 pts (A: 96 · B: 91 · C: 95) — Judge Klaus Richter',
    ),
    const SportQualificationModel(
      id: 'award_prot',
      title: 'Best Protection Work',
      kind: 'Award',
      sportTag: 'IGP',
      date: '15 Sep 2026',
      organisation: null,
      scoreSummary: 'Phase C 95 / 100 pts — High scoring protection routine of trial',
    ),
  ];

  SportDogWorkspace get activeDog => dogs[selectedDogIndex];

  List<SportEntryModel> get activeSports =>
      sports.where((s) => !s.isArchived).toList();

  List<SportCompetitionModel> get upcomingCompetitions =>
      competitions.where((c) => c.isUpcoming).toList();

  List<SportCompetitionModel> get completedCompetitions =>
      competitions.where((c) => !c.isUpcoming).toList();

  void selectDog(int index) {
    if (index < 0 || index >= dogs.length) return;
    selectedDogIndex = index;
    notifyListeners();
  }

  void addSport(SportEntryModel sport) {
    sports.insert(0, sport);
    recentActivities.insert(
      0,
      SportActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        icon: Icons.add,
        title: '${sport.name} sport added',
        sportTag: sport.tag,
        timeAgo: 'Just now',
        detailSummary: '${sport.organisation} · Current level: ${sport.currentLevel}',
      ),
    );
    notifyListeners();
  }

  void toggleArchiveSport(String id) {
    final idx = sports.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    sports[idx] = sports[idx].copyWith(isArchived: !sports[idx].isArchived);
    notifyListeners();
  }

  void recordCompetitionResult({
    required String competitionId,
    required int totalScore,
    required int maxScore,
    int? phaseA,
    int? phaseB,
    int? phaseC,
    required String placement,
    required String qualificationResult,
    required String notes,
    bool addQualificationBadge = true,
  }) {
    final idx = competitions.indexWhere((c) => c.id == competitionId);
    String compTitle = 'Trial Result';
    String sportTag = 'IGP';
    String dateStr = '18 Sep 2026';
    String orgStr = 'SV';
    String levelStr = 'IGP 2';

    if (idx != -1) {
      final existing = competitions[idx];
      compTitle = existing.title;
      sportTag = existing.sportTag;
      dateStr = existing.date;
      orgStr = existing.organisation;
      levelStr = existing.level;
      competitions[idx] = existing.copyWith(
        status: 'Completed',
        totalScore: totalScore,
        maxScore: maxScore,
        phaseAScore: phaseA,
        phaseBScore: phaseB,
        phaseCScore: phaseC,
        placement: placement,
        qualificationResult: qualificationResult,
        notes: notes.isNotEmpty ? notes : existing.notes,
      );
    } else {
      competitions.insert(
        0,
        SportCompetitionModel(
          id: competitionId,
          title: compTitle,
          sportTag: sportTag,
          level: levelStr,
          date: dateStr,
          location: 'Essex, UK',
          status: 'Completed',
          totalScore: totalScore,
          maxScore: maxScore,
          phaseAScore: phaseA,
          phaseBScore: phaseB,
          phaseCScore: phaseC,
          placement: placement,
          qualificationResult: qualificationResult,
          notes: notes,
        ),
      );
    }

    if (addQualificationBadge && qualificationResult.isNotEmpty) {
      qualifications.insert(
        0,
        SportQualificationModel(
          id: 'qual_${DateTime.now().millisecondsSinceEpoch}',
          title: '$levelStr ($placement)',
          kind: 'Qualification',
          sportTag: sportTag,
          date: dateStr,
          organisation: orgStr,
          scoreSummary: '$totalScore / $maxScore pts · $qualificationResult',
        ),
      );
    }

    recentActivities.insert(
      0,
      SportActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        icon: Icons.emoji_events_outlined,
        title: '$compTitle result recorded',
        sportTag: sportTag,
        timeAgo: 'Just now',
        detailSummary: '$totalScore / $maxScore pts · $placement · $qualificationResult',
      ),
    );
    notifyListeners();
  }
}

class SportPackOverviewScreen extends StatefulWidget {
  final bool hasSportPack;

  const SportPackOverviewScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<SportPackOverviewScreen> createState() =>
      _SportPackOverviewScreenState();
}

class _SportPackOverviewScreenState extends State<SportPackOverviewScreen>
    with SingleTickerProviderStateMixin {
  final SportPackStore _store = SportPackStore.instance;
  late final AnimationController _animController;
  late final Animation<double> _countAnim;

  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
    _countAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(String text) {
    if (_query.trim().isEmpty) return true;
    return text.toLowerCase().contains(_query.trim().toLowerCase());
  }

  void _openDogSelector() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SELECT ACTIVE DOG',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(_store.dogs.length, (i) {
                  final dog = _store.dogs[i];
                  final selected = i == _store.selectedDogIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _store.selectDog(i);
                        _animController.forward(from: 0);
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          title: 'Active Dog Switched',
                          message: 'Showing Sport Pack workspace for ${dog.name}.',
                          type: SnackbarType.info,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryForestGreen.withValues(alpha: 0.18)
                              : AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryForestGreen
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildDogAvatar(dog.name),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dog.name,
                                    style: const TextStyle(
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${dog.breed} · ${dog.totalSports} sports',
                                    style: const TextStyle(
                                      color: AppColors.secondaryTextStoneGrey,
                                      fontSize: 12.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF95D3BB),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openQuickActionsMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SPORT PACK ACTIONS',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                _buildQuickActionTile(
                  ctx,
                  icon: Icons.add_circle_outline_rounded,
                  title: 'Create Sport',
                  subtitle: 'Add IGP, Agility, PSA, Mondioring, or custom sport',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateSportScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickActionTile(
                  ctx,
                  icon: Icons.emoji_events_outlined,
                  title: 'Record Competition Result',
                  subtitle: 'Log scores, placements, and qualifications',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecordCompetitionResultScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickActionTile(
                  ctx,
                  icon: Icons.calendar_month_outlined,
                  title: 'Competitions Overview',
                  subtitle: 'Manage upcoming entries and past trial results',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CompetitionsOverviewScreen(),
                      ),
                    );
                  },
                ),
                _buildQuickActionTile(
                  ctx,
                  icon: Icons.sports_score_rounded,
                  title: 'My Sports',
                  subtitle: 'View and filter active & archived sports',
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MySportsScreen(hasSportPack: widget.hasSportPack),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionTile(
    BuildContext sheetContext, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF95D3BB), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.secondaryTextStoneGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQualificationDetails(SportQualificationModel item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Icon(
                        item.kind == 'Award'
                            ? Icons.star_border_rounded
                            : Icons.emoji_events_outlined,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${item.kind}  ·  ',
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              _buildSportPill(item.sportTag),
                              Text(
                                '  ·  ${item.date}',
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.organisation != null) ...[
                        Text(
                          'Awarding Body: ${item.organisation}',
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        item.scoreSummary,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                          height: 1.4,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SportDetailsIgpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Open Sport Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasSportPack) {
      return Scaffold(
        backgroundColor: AppColors.backgroundObsidian,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryForestGreen.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.emoji_events_outlined,
                            size: 32,
                            color: AppColors.primaryForestGreen,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Sport Pack Required',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'This area is available exclusively to Sport Pack subscribers. Manage competition entries, trials, sport skills, qualifications, and performance metrics.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 14,
                            height: 1.45,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionDetailsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryForestGreen,
                            foregroundColor: AppColors.primaryTextOffWhite,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Upgrade to Sport Pack',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final dog = _store.activeDog;
    final sportsOffset = _store.selectedDogIndex == 0
        ? _store.activeSports.length
        : dog.totalSports;
    final upcomingCount = _store.selectedDogIndex == 0
        ? _store.upcomingCompetitions.length
        : dog.upcomingCompetitions;
    final completedCount = _store.selectedDogIndex == 0
        ? (_store.completedCompetitions.length + 6)
        : dog.competitionsCompleted;
    final qualCount = _store.selectedDogIndex == 0
        ? (_store.qualifications.length + 5)
        : dog.qualifications;

    final filteredSports = _store.activeSports
        .where((s) => _matchesQuery('${s.name} ${s.organisation} ${s.tag}'))
        .toList();
    final filteredUpcoming = _store.upcomingCompetitions
        .where((c) => _matchesQuery('${c.title} ${c.location} ${c.sportTag} ${c.status}'))
        .toList();
    final filteredActivities = _store.recentActivities
        .where((a) => _matchesQuery('${a.title} ${a.sportTag} ${a.detailSummary}'))
        .toList();
    final filteredQuals = _store.qualifications
        .where((q) => _matchesQuery('${q.title} ${q.kind} ${q.sportTag} ${q.organisation ?? ""}'))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar: const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.primaryTextOffWhite,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: _openQuickActionsMenu,
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            if (_searchActive) _buildSearchField(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('ACTIVE DOG'),
                    const SizedBox(height: 8),
                    _buildActiveDogCard(dog),
                    const SizedBox(height: 22),
                    _buildSectionLabel('SPORT SUMMARY'),
                    const SizedBox(height: 8),
                    _buildSportSummaryGrid(
                      totalSports: sportsOffset,
                      sportSkills: dog.sportSkills,
                      trainingSessions: dog.trainingSessions,
                      upcomingCompetitions: upcomingCount,
                      competitionsCompleted: completedCount,
                      qualifications: qualCount,
                    ),
                    const SizedBox(height: 22),
                    _buildSectionHeaderWithLink(
                      label: 'MY SPORTS',
                      actionText: 'All Sports',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MySportsScreen(hasSportPack: widget.hasSportPack),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    if (filteredSports.isEmpty)
                      _buildEmptyFilterHint('No sports match "$_query"')
                    else
                      ...filteredSports.map(
                        (sport) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildSportCard(sport),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _buildSectionHeaderWithLink(
                      label: 'UPCOMING COMPETITIONS',
                      actionText: 'All Trials',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CompetitionsOverviewScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    if (filteredUpcoming.isEmpty)
                      _buildEmptyFilterHint('No upcoming competitions match "$_query"')
                    else
                      ...filteredUpcoming.map(
                        (comp) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildUpcomingCompetitionCard(comp),
                        ),
                      ),
                    const SizedBox(height: 10),
                    _buildSectionLabel('RECENT ACTIVITY'),
                    const SizedBox(height: 8),
                    if (filteredActivities.isEmpty)
                      _buildEmptyFilterHint('No recent activity matches "$_query"')
                    else
                      _buildRecentActivityCard(filteredActivities.take(4).toList()),
                    const SizedBox(height: 22),
                    _buildSectionLabel('QUALIFICATIONS & AWARDS'),
                    const SizedBox(height: 8),
                    if (filteredQuals.isEmpty)
                      _buildEmptyFilterHint('No qualifications match "$_query"')
                    else
                      ...filteredQuals.map(
                        (qual) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildQualificationCard(qual),
                        ),
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

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
            tooltip: 'Back',
          ),
          const SizedBox(width: 36),
          const Expanded(
            child: Center(
              child: Text(
                'Sport',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _searchActive = !_searchActive;
                if (!_searchActive) {
                  _searchController.clear();
                  _query = '';
                }
              });
            },
            icon: Icon(
              _searchActive ? Icons.close : Icons.search,
              color: _searchActive
                  ? const Color(0xFF95D3BB)
                  : AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
            tooltip: 'Search Sports',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateSportScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.secondaryTextStoneGrey,
              size: 24,
            ),
            tooltip: 'Create Sport',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: 'Filter sports, trials, qualifications...',
          hintStyle: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.secondaryTextStoneGrey,
            size: 19,
          ),
          filled: true,
          fillColor: AppColors.cardsCarbon,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryForestGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildSectionHeaderWithLink({
    required String label,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionLabel(label),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    color: AppColors.infoAlpineBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.infoAlpineBlue,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDogAvatar(String name) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.backgroundObsidian,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildActiveDogCard(SportDogWorkspace dog) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _openDogSelector,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              _buildDogAvatar(dog.name),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dog.name,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dog.breed,
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.secondaryTextStoneGrey,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportSummaryGrid({
    required int totalSports,
    required int sportSkills,
    required int trainingSessions,
    required int upcomingCompetitions,
    required int competitionsCompleted,
    required int qualifications,
  }) {
    return AnimatedBuilder(
      animation: _countAnim,
      builder: (context, _) {
        int animVal(int target) => (target * _countAnim.value).round();
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCell(
                        value: '${animVal(totalSports)}',
                        label: 'Total Sports',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MySportsScreen(hasSportPack: widget.hasSportPack),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    Expanded(
                      child: _buildSummaryCell(
                        value: '${animVal(sportSkills)}',
                        label: 'Skills',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SportDetailsIgpScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: AppColors.cardBorder),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCell(
                        value: '${animVal(trainingSessions)}',
                        label: 'Training Sessions',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SportDetailsIgpScreen(),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    Expanded(
                      child: _buildSummaryCell(
                        value: '${animVal(upcomingCompetitions)}',
                        label: 'Upcoming Competitions',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CompetitionsOverviewScreen(
                              initialTabIndex: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: AppColors.cardBorder),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCell(
                        value: '${animVal(competitionsCompleted)}',
                        label: 'Competitions\nCompleted',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CompetitionsOverviewScreen(
                              initialTabIndex: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: AppColors.cardBorder),
                    Expanded(
                      child: _buildSummaryCell(
                        value: '${animVal(qualifications)}',
                        label: 'Qualifications',
                        onTap: () {
                          if (_store.qualifications.isNotEmpty) {
                            _showQualificationDetails(_store.qualifications.first);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCell({
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12.5,
                height: 1.3,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: AppColors.infoAlpineBlue.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.infoAlpineBlue,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildSportCard(SportEntryModel sport) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SportDetailsIgpScreen(sport: sport),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sport.name,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  _buildSportPill(sport.tag),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                sport.organisation,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${sport.skillsCount} Skills  ·  ${sport.sessionsCount} Sessions  ·  ${sport.competitionsCount} Competitions  ·\nLast: ${sport.lastTrained}',
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12.8,
                  height: 1.45,
                  fontFamily: 'Inter',
                ),
              ),
              if (sport.nextCompetitionDate != null) ...[
                const SizedBox(height: 12),
                Container(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13.5,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Next: ${sport.nextCompetitionDate}',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCompetitionCard(SportCompetitionModel comp) {
    final isEntered = comp.status.toLowerCase() == 'entered';
    final accentColor = isEntered
        ? AppColors.primaryForestGreen
        : AppColors.bronzeAccent;

    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompetitionDetailsScreen(competition: comp),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 3.5, color: accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comp.title,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  _buildSportPill(comp.sportTag),
                                  Text(
                                    '${comp.date}  ·  ${comp.location}',
                                    style: const TextStyle(
                                      color: AppColors.secondaryTextStoneGrey,
                                      fontSize: 12.8,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            comp.status,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 20,
                        ),
                      ],
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

  Widget _buildRecentActivityCard(List<SportActivityItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  AppSnackbar.show(
                    context,
                    title: item.title,
                    message: item.detailSummary,
                    type: SnackbarType.info,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13.5,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 17,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 13.8,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildSportPill(item.sportTag),
                      const SizedBox(width: 8),
                      Text(
                        item.timeAgo,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                Container(height: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQualificationCard(SportQualificationModel qual) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showQualificationDetails(qual),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Icon(
                  qual.kind == 'Award'
                      ? Icons.star_border_rounded
                      : Icons.emoji_events_outlined,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 19,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      qual.title,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${qual.kind}  ·',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                        _buildSportPill(qual.sportTag),
                        Text(
                          qual.organisation != null
                              ? '·  ${qual.date}  ·  ${qual.organisation}'
                              : '·  ${qual.date}',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.secondaryTextStoneGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFilterHint(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 13,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
