import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'competition_details_screen.dart';
import 'competitions_overview_screen.dart';
import 'create_sport_screen.dart';
import 'record_competition_result_screen.dart';
import 'sport_pack_overview_screen.dart';

class _SportSkillRowData {
  final String name;
  final int exercises;
  final int sessions;
  final String lastTrained;
  final String phaseTag;

  const _SportSkillRowData({
    required this.name,
    required this.exercises,
    required this.sessions,
    required this.lastTrained,
    required this.phaseTag,
  });

  _SportSkillRowData copyWith({
    int? exercises,
    int? sessions,
    String? lastTrained,
  }) {
    return _SportSkillRowData(
      name: name,
      exercises: exercises ?? this.exercises,
      sessions: sessions ?? this.sessions,
      lastTrained: lastTrained ?? this.lastTrained,
      phaseTag: phaseTag,
    );
  }
}

class _TrialProgressionPoint {
  final String label;
  final String trialName;
  final int phaseA;
  final int phaseB;
  final int phaseC;

  const _TrialProgressionPoint({
    required this.label,
    required this.trialName,
    required this.phaseA,
    required this.phaseB,
    required this.phaseC,
  });

  int get total => phaseA + phaseB + phaseC;
}

class SportDetailsIgpScreen extends StatefulWidget {
  final SportEntryModel? sport;

  const SportDetailsIgpScreen({
    super.key,
    this.sport,
  });

  @override
  State<SportDetailsIgpScreen> createState() => _SportDetailsIgpScreenState();
}

class _SportDetailsIgpScreenState extends State<SportDetailsIgpScreen>
    with SingleTickerProviderStateMixin {
  final SportPackStore _store = SportPackStore.instance;
  late final AnimationController _animController;
  late final Animation<double> _chartAnim;

  late String _sportId;
  bool _showAllSkills = false;
  int _selectedPhaseIndex = -1; // -1 = all phases, 0 = A, 1 = B, 2 = C
  int _selectedProgressionIndex = 4; // latest trial selected by default

  int _extraExercises = 0;
  int _extraSessions = 0;
  int _extraHours = 0;
  late String _notesText;

  late List<_SportSkillRowData> _skills;
  late List<SportQualificationModel> _localQuals;

  static const List<_TrialProgressionPoint> _progressionPoints = [
    _TrialProgressionPoint(
      label: 'Nov 25',
      trialName: 'Autumn Club Eval',
      phaseA: 84,
      phaseB: 82,
      phaseC: 88,
    ),
    _TrialProgressionPoint(
      label: 'Feb 26',
      trialName: 'Winter Working Cup',
      phaseA: 88,
      phaseB: 85,
      phaseC: 90,
    ),
    _TrialProgressionPoint(
      label: 'Apr 26',
      trialName: 'Club Trial — Spring 2026',
      phaseA: 91,
      phaseB: 87,
      phaseC: 92,
    ),
    _TrialProgressionPoint(
      label: 'Jul 26',
      trialName: 'Eastern Mock IGP',
      phaseA: 93,
      phaseB: 89,
      phaseC: 94,
    ),
    _TrialProgressionPoint(
      label: 'Sep 26',
      trialName: 'Southern Regional SV Trial',
      phaseA: 96,
      phaseB: 91,
      phaseC: 95,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sportId = widget.sport?.id ?? 'igp';
    _store.addListener(_onStoreChanged);

    final resolved = _resolveSport();
    _notesText = resolved.notes.trim();

    _skills = [
      const _SportSkillRowData(
        name: 'Heelwork',
        exercises: 8,
        sessions: 46,
        lastTrained: '2 days ago',
        phaseTag: 'Obedience',
      ),
      const _SportSkillRowData(
        name: 'Retrieve',
        exercises: 6,
        sessions: 38,
        lastTrained: 'Yesterday',
        phaseTag: 'Obedience',
      ),
      const _SportSkillRowData(
        name: 'Tracking',
        exercises: 12,
        sessions: 64,
        lastTrained: '3 days ago',
        phaseTag: 'Tracking',
      ),
      const _SportSkillRowData(
        name: 'Hold & Bark',
        exercises: 7,
        sessions: 42,
        lastTrained: '4 days ago',
        phaseTag: 'Protection',
      ),
      const _SportSkillRowData(
        name: 'Long Bite & Out',
        exercises: 9,
        sessions: 51,
        lastTrained: '5 days ago',
        phaseTag: 'Protection',
      ),
    ];

    _localQuals = [
      const SportQualificationModel(
        id: 'sd_qual_1',
        title: 'IGP 1',
        kind: 'Qualification',
        sportTag: 'IGP',
        date: '15 Sep 2026',
        organisation: 'SV',
        scoreSummary: '282 / 300 pts (A: 96 · B: 91 · C: 95) · SG',
      ),
      const SportQualificationModel(
        id: 'sd_qual_2',
        title: 'Best Protection',
        kind: 'Award',
        sportTag: 'IGP',
        date: '15 Sep 2026',
        organisation: 'SV',
        scoreSummary: 'Protection: 95 / 100 pts — Highest protection score of trial',
      ),
    ];

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
    _chartAnim = CurvedAnimation(
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
    super.dispose();
  }

  SportEntryModel _resolveSport() {
    for (final s in _store.sports) {
      if (s.id == _sportId) return s;
    }
    return widget.sport ??
        const SportEntryModel(
          id: 'igp',
          name: 'IGP',
          tag: 'IGP',
          organisation: 'Organisation: SV',
          currentLevel: 'IGP 2',
          targetLevel: 'IGP 3',
          skillsCount: 18,
          sessionsCount: 286,
          competitionsCount: 7,
          lastTrained: 'Yesterday',
        );
  }

  String _cleanOrg(String raw) {
    final cleaned = raw.replaceFirst('Organisation:', '').trim();
    if (cleaned.isEmpty || cleaned.toLowerCase() == 'no organisation') {
      return 'Independent';
    }
    return cleaned;
  }

  String _displayLevel(SportEntryModel sport) {
    if (sport.id == 'igp' && sport.currentLevel == 'IGP 1') {
      return 'IGP 2';
    }
    return sport.currentLevel;
  }

  void _openOverflowMenu(SportEntryModel sport) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryTextOffWhite,
                  ),
                  title: const Text(
                    'Edit Sport',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleEditSport(sport);
                  },
                ),
                ListTile(
                  leading: Icon(
                    sport.isArchived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                    color: AppColors.infoAlpineBlue,
                  ),
                  title: Text(
                    sport.isArchived ? 'Restore Sport' : 'Archive Sport',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleArchiveSport(sport);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFB55454),
                  ),
                  title: const Text(
                    'Delete Sport',
                    style: TextStyle(
                      color: Color(0xFFB55454),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmDeleteSport(sport);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openCreateSkillSheet() {
    final nameCtrl = TextEditingController();
    final exCtrl = TextEditingController(text: '5');
    String selectedPhase = 'Obedience';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CREATE SPORT SKILL',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildModalField(
                    controller: nameCtrl,
                    hint: 'Skill name (e.g. Sendaway / Blind Search)',
                  ),
                  const SizedBox(height: 10),
                  _buildModalField(
                    controller: exCtrl,
                    hint: 'Linked exercises count',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Tracking',
                      'Obedience',
                      'Protection',
                    ].map((phase) {
                      final active = selectedPhase == phase;
                      return GestureDetector(
                        onTap: () =>
                            setModalState(() => selectedPhase = phase),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primaryForestGreen
                                    .withValues(alpha: 0.22)
                                : AppColors.backgroundObsidian,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: active
                                  ? AppColors.primaryForestGreen
                                  : AppColors.cardBorder,
                            ),
                          ),
                          child: Text(
                            phase,
                            style: TextStyle(
                              color: active
                                  ? const Color(0xFF95D3BB)
                                  : AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) {
                          AppSnackbar.show(
                            context,
                            title: 'Skill Name Required',
                            message: 'Please enter a name for the sport skill.',
                            type: SnackbarType.warning,
                          );
                          return;
                        }
                        final ex = int.tryParse(exCtrl.text.trim()) ?? 4;
                        setState(() {
                          _skills.insert(
                            0,
                            _SportSkillRowData(
                              name: name,
                              exercises: ex,
                              sessions: 1,
                              lastTrained: 'Just now',
                              phaseTag: selectedPhase,
                            ),
                          );
                          _extraExercises += ex;
                          final idx = _store.sports
                              .indexWhere((s) => s.id == _sportId);
                          if (idx != -1) {
                            final s = _store.sports[idx];
                            _store.sports[idx] = s.copyWith(
                              skillsCount: s.skillsCount + 1,
                              lastTrained: 'Just now',
                            );
                          }
                        });
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          title: 'Skill Created',
                          message: '$name added to $selectedPhase.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Save Skill',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openRecordSessionSheet() {
    String selectedSkillName = _skills.first.name;
    int durationMinutes = 45;
    final sessionNoteCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RECORD TRAINING SESSION',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills.take(4).map((sk) {
                      final active = sk.name == selectedSkillName;
                      return GestureDetector(
                        onTap: () => setModalState(
                          () => selectedSkillName = sk.name,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primaryForestGreen
                                    .withValues(alpha: 0.22)
                                : AppColors.backgroundObsidian,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: active
                                  ? AppColors.primaryForestGreen
                                  : AppColors.cardBorder,
                            ),
                          ),
                          child: Text(
                            sk.name,
                            style: TextStyle(
                              color: active
                                  ? const Color(0xFF95D3BB)
                                  : AppColors.secondaryTextStoneGrey,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Session Duration',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '$durationMinutes min',
                        style: const TextStyle(
                          color: Color(0xFF95D3BB),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primaryForestGreen,
                      inactiveTrackColor: AppColors.backgroundObsidian,
                      thumbColor: const Color(0xFF95D3BB),
                    ),
                    child: Slider(
                      value: durationMinutes.toDouble(),
                      min: 15,
                      max: 120,
                      divisions: 7,
                      onChanged: (v) =>
                          setModalState(() => durationMinutes = v.round()),
                    ),
                  ),
                  _buildModalField(
                    controller: sessionNoteCtrl,
                    hint: 'Session takeaway (optional)',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _extraSessions += 1;
                          if (durationMinutes >= 45) {
                            _extraHours += 1;
                          }
                          final sIdx = _skills.indexWhere(
                            (sk) => sk.name == selectedSkillName,
                          );
                          if (sIdx != -1) {
                            _skills[sIdx] = _skills[sIdx].copyWith(
                              sessions: _skills[sIdx].sessions + 1,
                              lastTrained: 'Just now',
                            );
                          }
                          final storeIdx = _store.sports
                              .indexWhere((s) => s.id == _sportId);
                          if (storeIdx != -1) {
                            final sp = _store.sports[storeIdx];
                            _store.sports[storeIdx] = sp.copyWith(
                              sessionsCount: sp.sessionsCount + 1,
                              lastTrained: 'Just now',
                            );
                          }
                        });
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          title: 'Training Session Recorded',
                          message:
                              '$selectedSkillName ($durationMinutes min) added to sport history.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Record Session',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openAddCompetitionSheet(SportEntryModel sport) {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '14 Nov 2026');
    final locCtrl = TextEditingController(text: 'Cambridge, UK');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADD UPCOMING COMPETITION',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              _buildModalField(
                controller: titleCtrl,
                hint: 'Trial / Event title (e.g. Winter Championship)',
              ),
              const SizedBox(height: 10),
              _buildModalField(
                controller: dateCtrl,
                hint: 'Event date',
              ),
              const SizedBox(height: 10),
              _buildModalField(
                controller: locCtrl,
                hint: 'Venue / City',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: const BorderSide(color: AppColors.cardBorder),
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const RecordCompetitionResultScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log Past Result',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) {
                          AppSnackbar.show(
                            context,
                            title: 'Event Title Required',
                            message: 'Enter a competition name to schedule it.',
                            type: SnackbarType.warning,
                          );
                          return;
                        }
                        setState(() {
                          _store.competitions.insert(
                            0,
                            SportCompetitionModel(
                              id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
                              title: title,
                              sportTag: sport.tag,
                              level: _displayLevel(sport),
                              date: dateCtrl.text.trim(),
                              location: locCtrl.text.trim(),
                              status: 'Entered',
                            ),
                          );
                        });
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          title: 'Competition Scheduled',
                          message: '$title added to upcoming trials.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Add Entry',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddQualificationSheet(SportEntryModel sport) {
    final titleCtrl = TextEditingController();
    String selectedKind = 'Qualification';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD QUALIFICATION OR AWARD',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Qualification', 'Award'].map((kind) {
                      final active = selectedKind == kind;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedKind = kind),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primaryForestGreen
                                      .withValues(alpha: 0.22)
                                  : AppColors.backgroundObsidian,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: active
                                    ? AppColors.primaryForestGreen
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              kind,
                              style: TextStyle(
                                color: active
                                    ? const Color(0xFF95D3BB)
                                    : AppColors.secondaryTextStoneGrey,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  _buildModalField(
                    controller: titleCtrl,
                    hint: 'Title (e.g. IGP 2 / High in Trial)',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) {
                          AppSnackbar.show(
                            context,
                            title: 'Title Required',
                            message:
                                'Enter a qualification or award title first.',
                            type: SnackbarType.warning,
                          );
                          return;
                        }
                        final created = SportQualificationModel(
                          id: 'qual_${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          kind: selectedKind,
                          sportTag: sport.tag.toUpperCase(),
                          date: 'Today',
                          organisation: _cleanOrg(sport.organisation),
                          scoreSummary: 'Recorded from ${sport.name} details',
                        );
                        setState(() {
                          _localQuals.insert(0, created);
                          _store.qualifications.insert(0, created);
                        });
                        Navigator.pop(ctx);
                        AppSnackbar.show(
                          context,
                          title: '$selectedKind Added',
                          message: '$title recorded under ${sport.name}.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Save Honour',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openEditNotesDialog() {
    final ctrl = TextEditingController(text: _notesText);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _notesText.isEmpty ? 'ADD SPORT NOTE' : 'EDIT SPORT NOTES',
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 4,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 13.5,
                  height: 1.45,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: 'Add any additional notes about this sport…',
                  hintStyle: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13.5,
                    fontFamily: 'Inter',
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundObsidian,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primaryForestGreen),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() => _notesText = ctrl.text.trim());
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      title: 'Notes Saved',
                      message: 'Sport notes saved.',
                      type: SnackbarType.success,
                    );
                  },
                  child: Text(
                    _notesText.isEmpty ? 'Add Note' : 'Save Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.primaryTextOffWhite,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 13.5,
          fontFamily: 'Inter',
        ),
        filled: true,
        fillColor: AppColors.backgroundObsidian,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
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
    );
  }

  void _handleEditSport(SportEntryModel sport) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateSportScreen(initialSport: sport),
      ),
    );
  }

  void _handleArchiveSport(SportEntryModel sport) {
    final willArchive = !sport.isArchived;
    _store.toggleArchiveSport(sport.id);
    AppSnackbar.show(
      context,
      title: willArchive ? 'Sport Archived' : 'Sport Activated',
      message: willArchive
          ? '${sport.name} is now archived.'
          : '${sport.name} is now active.',
      type: SnackbarType.info,
    );
  }

  void _confirmDeleteSport(SportEntryModel sport) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: Text(
            'Delete ${sport.name}?',
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          content: const Text(
            'This removes the sport workspace from your active Sport Pack list. Past timeline logs remain preserved.',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 13.5,
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: AppColors.primaryTextOffWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _store.sports.removeWhere((s) => s.id == sport.id);
                Navigator.pop(ctx);
                AppSnackbar.show(
                  context,
                  title: 'Sport Deleted',
                  message: '${sport.name} was removed from My Sports.',
                  type: SnackbarType.warning,
                );
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sport = _resolveSport();
    final orgShort = _cleanOrg(sport.organisation);
    final levelText = _displayLevel(sport);
    final badgeCode = sport.tag.length > 3
        ? sport.tag.substring(0, 3).toUpperCase()
        : sport.tag.toUpperCase();

    final skillsTotal = sport.skillsCount;
    final exercisesTotal =
        (sport.id == 'igp' ? 54 : sport.skillsCount * 3) + _extraExercises;
    final sessionsTotal = sport.sessionsCount + _extraSessions;
    final competitionsTotal = sport.competitionsCount;
    final qualificationsCount = 4 + (_localQuals.length - 2).clamp(0, 99);
    final awardsCount = _localQuals.where((q) => q.kind == 'Award').length + 1;
    final trainingHours =
        (sport.id == 'igp' ? 142 : (sessionsTotal ~/ 2)) + _extraHours;

    final visibleSkills =
        _showAllSkills ? _skills : _skills.take(3).toList();

    final upcomingTrial = _store.upcomingCompetitions.isNotEmpty
        ? _store.upcomingCompetitions.first
        : const SportCompetitionModel(
            id: 'essex_trial',
            title: 'Essex Working Dog Trial',
            sportTag: 'IGP',
            level: 'IGP 2',
            date: '18 Sep 2026',
            location: 'Essex',
            status: 'Entered',
          );

    const springCompletedTrial = SportCompetitionModel(
      id: 'spring_club_2026',
      title: 'Club Trial — Spring 2026',
      sportTag: 'IGP',
      level: 'IGP 1',
      date: '15 Apr 2026',
      location: 'Norwich',
      status: 'Completed',
      totalScore: 270,
      maxScore: 300,
      phaseAScore: 91,
      phaseBScore: 87,
      phaseCScore: 92,
      placement: '2nd Place',
      qualificationResult: 'Qualified · SG (270/300)',
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(sport),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(
                      sport: sport,
                      badgeCode: badgeCode,
                      orgShort: orgShort,
                      levelText: levelText,
                    ),
                    const SizedBox(height: 22),
                    _buildSectionLabel('OVERVIEW'),
                    const SizedBox(height: 8),
                    _buildOverviewCard(
                      skillsTotal: skillsTotal,
                      exercisesTotal: exercisesTotal,
                      sessionsTotal: sessionsTotal,
                      competitionsTotal: competitionsTotal,
                      qualificationsCount: qualificationsCount,
                      awardsCount: awardsCount,
                      lastActivity: sport.lastTrained,
                    ),
                    const SizedBox(height: 22),
                    _buildSectionLabel('SKILLS'),
                    const SizedBox(height: 8),
                    _buildSkillsCard(visibleSkills),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showAllSkills = !_showAllSkills);
                        },
                        child: Text(
                          _showAllSkills
                              ? 'Show Top 3 Skills ↑'
                              : 'View All $skillsTotal Skills →',
                          style: const TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildSectionLabel('COMPETITIONS'),
                    const SizedBox(height: 8),
                    _buildCompetitionsCard(
                      upcomingTrial: upcomingTrial,
                      completedTrial: springCompletedTrial,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CompetitionsOverviewScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'View All $competitionsTotal Competitions →',
                          style: const TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                                        _buildSectionLabel('ACTIVE GOALS'),
                    const SizedBox(height: 8),
                    _buildActiveGoalsCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('QUALIFICATIONS & AWARDS'),
                    const SizedBox(height: 8),
                    _buildQualificationsCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('STATISTICS'),
                    const SizedBox(height: 8),
                    _buildStatisticsSection(
                      sessionsTotal: sessionsTotal,
                      trainingHours: trainingHours,
                      competitionsTotal: competitionsTotal,
                      qualificationsCount: qualificationsCount,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('NOTES'),
                        GestureDetector(
                          onTap: _openEditNotesDialog,
                          child: Text(
                            _notesText.isEmpty ? 'Add Note' : 'Edit',
                            style: const TextStyle(
                              color: AppColors.primaryForestGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_notesText.isEmpty)
                      GestureDetector(
                        onTap: _openEditNotesDialog,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardsCarbon,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'No notes added',
                                style: TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 13.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 16,
                                    color: AppColors.primaryForestGreen,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add Note',
                                    style: TextStyle(
                                      color: AppColors.primaryForestGreen,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _openEditNotesDialog,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardsCarbon,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            _notesText,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 13.5,
                              height: 1.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    _buildSectionLabel('QUICK ACTIONS'),
                    const SizedBox(height: 8),
                    _buildQuickActionsCard(sport),
                    const SizedBox(height: 22),
                    _buildSectionLabel('MORE OPTIONS'),
                    const SizedBox(height: 8),
                    _buildMoreOptionsCard(sport),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(SportEntryModel sport) {
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
          const Expanded(
            child: Center(
              child: Text(
                'Sport Details',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _openOverflowMenu(sport),
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
            tooltip: 'More Options',
          ),
        ],
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
        letterSpacing: 1.15,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildHeroCard({
    required SportEntryModel sport,
    required String badgeCode,
    required String orgShort,
    required String levelText,
  }) {
    final isActive = !sport.isArchived;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: Color(0xFF263036),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeCode,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sport.name,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$orgShort  •  $levelText',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _handleArchiveSport(sport),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryForestGreen.withValues(alpha: 0.22)
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Archived',
                    style: TextStyle(
                      color: isActive
                          ? const Color(0xFF95D3BB)
                          : AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sport.sessionsCount} Sessions',
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const Text(
                  '12d Streak',
                  style: TextStyle(
                    color: Color(0xFF95D3BB),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  'Last: ${sport.lastTrained}',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _openRecordSessionSheet,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text(
                'Record Training Session',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.primaryTextOffWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required int skillsTotal,
    required int exercisesTotal,
    required int sessionsTotal,
    required int competitionsTotal,
    required int qualificationsCount,
    required int awardsCount,
    required String lastActivity,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildOverviewTextRow('Created', 'March 2024'),
          Container(height: 1, color: AppColors.cardBorder),
          _buildOverviewDualStatRow(
            leftNum: '$skillsTotal',
            leftLabel: 'Skills',
            rightNum: '$exercisesTotal',
            rightLabel: 'Exercises',
          ),
          Container(height: 1, color: AppColors.cardBorder),
          _buildOverviewDualStatRow(
            leftNum: '$sessionsTotal',
            leftLabel: 'Sessions',
            rightNum: '$competitionsTotal',
            rightLabel: 'Competitions',
          ),
          Container(height: 1, color: AppColors.cardBorder),
          _buildOverviewDualStatRow(
            leftNum: '$qualificationsCount',
            leftLabel: 'Qualifications',
            rightNum: '$awardsCount',
            rightLabel: 'Awards',
          ),
          Container(height: 1, color: AppColors.cardBorder),
          _buildOverviewTextRow('Last Activity', lastActivity),
        ],
      ),
    );
  }

  Widget _buildOverviewTextRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 13.5,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            right,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 13.8,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewDualStatRow({
    required String leftNum,
    required String leftLabel,
    required String rightNum,
    required String rightLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$leftNum ',
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: leftLabel,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13.2,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$rightNum ',
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: rightLabel,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13.2,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsCard(List<_SportSkillRowData> skills) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(skills.length, (i) {
          final sk = skills[i];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  AppSnackbar.show(
                    context,
                    title: '${sk.name} (${sk.phaseTag})',
                    message:
                        '${sk.exercises} exercises · ${sk.sessions} sessions · Last trained ${sk.lastTrained}',
                    type: SnackbarType.info,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sk.name,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${sk.exercises} Exercises · ${sk.sessions} Sessions · Last: ${sk.lastTrained}',
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < skills.length - 1)
                Container(height: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCompetitionsCard({
    required SportCompetitionModel upcomingTrial,
    required SportCompetitionModel completedTrial,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildCompetitionRow(
            comp: upcomingTrial,
            pillLabel: 'Upcoming',
            accentColor: AppColors.primaryForestGreen,
            shortLocation: upcomingTrial.location.split(',').first,
          ),
          Container(height: 1, color: AppColors.cardBorder),
          _buildCompetitionRow(
            comp: completedTrial,
            pillLabel: 'Completed',
            accentColor: AppColors.secondaryTextStoneGrey,
            shortLocation: completedTrial.location.split(',').first,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionRow({
    required SportCompetitionModel comp,
    required String pillLabel,
    required Color accentColor,
    required String shortLocation,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CompetitionDetailsScreen(competition: comp),
          ),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 3.5, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                comp.title,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 14.8,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  pillLabel,
                                  style: const TextStyle(
                                    color: Color(0xFFB6CCB5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${comp.date} · $shortLocation',
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 19,
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

  Widget _buildActiveGoalsCard() {
    final goals = [
      (
        'Footstep Track Completion',
        'User Goal · 20 Recorded Tracks',
        0.75,
        '75% · 15/20 tracks completed',
        AppColors.primaryForestGreen,
      ),
      (
        'Protection Hold & Bark Duration',
        'User Goal · 45s Target Duration',
        0.40,
        '40% · Recorded: 18s / 45s target',
        const Color(0xFF95D3BB),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(goals.length, (idx) {
          final g = goals[idx];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (idx > 0) const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      g.$1,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  Text(
                    '${(g.$3 * 100).round()}%',
                    style: const TextStyle(
                      color: Color(0xFF95D3BB),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                g.$2,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: g.$3,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(g.$5),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                g.$4,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11.5,
                  fontFamily: 'Inter',
                ),
              ),
              if (idx < goals.length - 1) ...[
                const SizedBox(height: 14),
                Container(height: 1, color: AppColors.cardBorder),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQualificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(_localQuals.length, (i) {
          final q = _localQuals[i];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  AppSnackbar.show(
                    context,
                    title: '${q.title} (${q.kind})',
                    message: q.scoreSummary,
                    type: SnackbarType.info,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 16,
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          q.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.infoAlpineBlue.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          q.sportTag,
                          style: const TextStyle(
                            color: AppColors.infoAlpineBlue,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        q.date,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < _localQuals.length - 1)
                Container(height: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatisticsSection({
    required int sessionsTotal,
    required int trainingHours,
    required int competitionsTotal,
    required int qualificationsCount,
  }) {
    final activePoint = _progressionPoints[_selectedProgressionIndex];
    final phaseScores = [
      ('Section A', 'Tracking', activePoint.phaseA, AppColors.primaryForestGreen),
      ('Section B', 'Obedience', activePoint.phaseB, AppColors.infoAlpineBlue),
      ('Section C', 'Protection', activePoint.phaseC, const Color(0xFF95D3BB)),
    ];

    return AnimatedBuilder(
      animation: _chartAnim,
      builder: (context, _) {
        int animVal(int target) => (target * _chartAnim.value).round();
        return Column(
          children: [
            Container(
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
                          child: _buildStatGridCell(
                            value: '${animVal(sessionsTotal)}',
                            label: 'Training Sessions',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildStatGridCell(
                            value: '${animVal(trainingHours)}h',
                            label: 'Training Hours',
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
                          child: _buildStatGridCell(
                            value: '${animVal(competitionsTotal)}',
                            label: 'Competitions',
                          ),
                        ),
                        Container(width: 1, color: AppColors.cardBorder),
                        Expanded(
                          child: _buildStatGridCell(
                            value: '${animVal(qualificationsCount)}',
                            label: 'Qualifications',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${activePoint.trialName} · ${activePoint.total}/300',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      if (_selectedPhaseIndex != -1)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPhaseIndex = -1),
                          child: const Text(
                            'All Sections',
                            style: TextStyle(
                              color: AppColors.infoAlpineBlue,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(phaseScores.length, (idx) {
                      final entry = phaseScores[idx];
                      final isSelected = _selectedPhaseIndex == -1 ||
                          _selectedPhaseIndex == idx;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPhaseIndex =
                                _selectedPhaseIndex == idx ? -1 : idx;
                          });
                        },
                        child: Opacity(
                          opacity: isSelected ? 1.0 : 0.42,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 68,
                                height: 68,
                                child: CustomPaint(
                                  painter: _PhaseRingPainter(
                                    progress:
                                        (entry.$3 / 100.0) * _chartAnim.value,
                                    color: entry.$4,
                                    highlighted: _selectedPhaseIndex == idx,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${(entry.$3 * _chartAnim.value).round()}',
                                      style: const TextStyle(
                                        color: AppColors.primaryTextOffWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                entry.$1,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                entry.$2,
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 12),
                  const Text(
                    'Score Progression · Tap any trial bar to inspect phases',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 96,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(_progressionPoints.length, (i) {
                        final pt = _progressionPoints[i];
                        final int metricVal;
                        final double maxVal;
                        if (_selectedPhaseIndex == 0) {
                          metricVal = pt.phaseA;
                          maxVal = 100;
                        } else if (_selectedPhaseIndex == 1) {
                          metricVal = pt.phaseB;
                          maxVal = 100;
                        } else if (_selectedPhaseIndex == 2) {
                          metricVal = pt.phaseC;
                          maxVal = 100;
                        } else {
                          metricVal = pt.total;
                          maxVal = 300;
                        }
                        final selected = i == _selectedProgressionIndex;
                        final barHeight =
                            ((metricVal / maxVal) * 58 * _chartAnim.value)
                                .clamp(8.0, 58.0);

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() => _selectedProgressionIndex = i);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$metricVal',
                                  style: TextStyle(
                                    color: selected
                                        ? const Color(0xFF95D3BB)
                                        : AppColors.secondaryTextStoneGrey,
                                    fontSize: 11,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 26,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primaryForestGreen
                                        : AppColors.infoAlpineBlue
                                            .withValues(alpha: 0.35),
                                    borderRadius: BorderRadius.circular(6),
                                    border: selected
                                        ? Border.all(
                                            color: const Color(0xFF95D3BB),
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  pt.label,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.primaryTextOffWhite
                                        : AppColors.secondaryTextStoneGrey,
                                    fontSize: 10.5,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatGridCell({
    required String value,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 23,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 12.8,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(SportEntryModel sport) {
    final actions = [
      (
        Icons.fitness_center_rounded,
        'Create Skill',
        _openCreateSkillSheet,
      ),
      (
        Icons.calendar_today_outlined,
        'Record Training Session',
        _openRecordSessionSheet,
      ),
      (
        Icons.emoji_events_outlined,
        'Add Competition',
        () => _openAddCompetitionSheet(sport),
      ),
      (
        Icons.star_border_rounded,
        'Add Qualification or Award',
        () => _openAddQualificationSheet(sport),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(actions.length, (i) {
          final item = actions[i];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: item.$3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.$1,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          item.$2,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < actions.length - 1)
                Container(height: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMoreOptionsCard(SportEntryModel sport) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _buildOptionRow(
            label: 'Edit Sport',
            color: AppColors.primaryTextOffWhite,
            chevronColor: AppColors.secondaryTextStoneGrey,
            onTap: () => _handleEditSport(sport),
          ),
          Container(height: 1, color: AppColors.cardBorder),
          _buildOptionRow(
            label: sport.isArchived ? 'Restore Sport' : 'Archive Sport',
            color: AppColors.primaryTextOffWhite,
            chevronColor: AppColors.secondaryTextStoneGrey,
            onTap: () => _handleArchiveSport(sport),
          ),
          Container(height: 1, color: AppColors.cardBorder),
          _buildOptionRow(
            label: 'Delete Sport',
            color: const Color(0xFFA84C4C),
            chevronColor: const Color(0xFFA84C4C),
            onTap: () => _confirmDeleteSport(sport),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required String label,
    required Color color,
    required Color chevronColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: chevronColor,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool highlighted;

  const _PhaseRingPainter({
    required this.progress,
    required this.color,
    required this.highlighted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = highlighted ? 6.5 : 5.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - stroke;

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PhaseRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.highlighted != highlighted;
  }
}
