import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'training_screen.dart';

// ─── Local mutable working models for live session editing ───────────────────

class _EditableExercise {
  String id;
  String name;
  int repetitions;
  String? notes;
  bool isCustom;

  _EditableExercise({
    required this.id,
    required this.name,
    this.repetitions = 1,
    this.notes,
    this.isCustom = false,
  });

  factory _EditableExercise.fromEntry(RecordedExerciseEntry entry) {
    return _EditableExercise(
      id: entry.id,
      name: entry.name,
      repetitions: entry.repetitions,
      notes: entry.notes,
      isCustom: entry.isCustom,
    );
  }

  RecordedExerciseEntry toEntry() {
    return RecordedExerciseEntry(
      id: id,
      name: name.trim(),
      repetitions: repetitions < 1 ? 1 : repetitions,
      notes: notes,
      isCustom: isCustom,
    );
  }
}

class _EditableSkill {
  String id;
  String skillName;
  bool isCustom;
  bool open;
  final List<_EditableExercise> exercises;

  _EditableSkill({
    required this.id,
    required this.skillName,
    this.isCustom = false,
    this.open = true,
    List<_EditableExercise>? exercises,
  }) : exercises = exercises ?? [];

  factory _EditableSkill.fromEntry(RecordedSkillEntry entry) {
    return _EditableSkill(
      id: entry.id,
      skillName: entry.skillName,
      isCustom: entry.isCustom,
      open: true,
      exercises: entry.exercises.map(_EditableExercise.fromEntry).toList(),
    );
  }

  RecordedSkillEntry toEntry() {
    return RecordedSkillEntry(
      id: id,
      skillName: skillName.trim(),
      isCustom: isCustom,
      exercises: exercises.map((e) => e.toEntry()).toList(),
    );
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class TrainingSessionScreen extends StatefulWidget {
  final TrainingSession session;
  final bool isNewSession;

  const TrainingSessionScreen({
    super.key,
    required this.session,
    this.isNewSession = false,
  });

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  static const String _heroImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAzU4TdlERYJVUgVdsr7lJ8DZFavYDTksXswDyQuEMLlNsKiXqJGjJad2zRGqd2ibKYehwzPDTAizHKzNhifbp44NfWAFL-Rl4zffvvhWUMt93n77tVP4tql3yPVRn8sNdzWjJLNSKuYVoDJXAnLeoqdAtzst_h1iNayOteb9nZ0HLwqIgjNL3zU2DYy8wU-k1SfK2rg8DPnSut9yIGwM0aDTFJGGUGg76OCK6Laj93d4g7ijmaPXU';

  static const List<String> _mediaUrls = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBIasfW7yL_aU7sEvfdTiSXGLyb1g20EsEgwDqN0nGfGaC7fTVx2awMtE-WmqwXNd-mmstruwNj9Vk_iRuftQc-CECnynNldoSGf02F4nPvtYQglgrokPude4MXwqkLcJqNbuJShM3nI_pZTOT1HfxVQaRto9uvMLijyjWQ8lWNc88MvxyAzq2jgkqtFhXpMmcG89Y2d9E0auqsoDo90lFX96iDqx5Oielv8Eaa1vt_Lkh_vXP0-D0',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBBmRlx3JgPoXkquxAnKr69Lkc2xV6Sy_1uqv3eJJkhlBV5zA7c--MPeQlL9JnF-4VqG-7hvLtPSZhh7LEINP2KpdnKyyRJtR2IfSuD0dpEkl5hB5cxcHGIImn-KrZDSQGeL8dwD84N5ZyCOVnQ4e6ZF6dwFArNzliT4wz_nxr_EDkgR1jvvdtUTJMieokAeUE2N58Hlyu5AVQJ65ia1K5_lcgpKnGt_dgJBonmXGKobGvH0v42f7A',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBDKbIAa40psh_xi_X9N5IQzp1jLtzwUBTYleWBHgfGrAeSsBp2UNziPCCrDy-g9lNzfF07ImcnZJqHVTVkiFXLAsaR9WztMIKbSZgIvm-ULKkpfdWrNvCHj2uwkhZfNUCXEHfX2FrjsDd6en1ZPwKP6K_HHWLHZ7OksPe3zHDKeOk6AjAc9fDkeL7hZBJAtUCfjb-UapMrnCGhve6kBTNd7YQowE49FpPfg-yCrsAAPBMYqaaekE',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCwhqKjCEN1lrJrYPRQQZUcKRRppY-fNmAGEUAiwHqjNAOIqChoHRteWsaDUOazmdMGEMd2XUhsNMXiozs-pHP1XUCu6vTXW_-GPIj8ErUfAamkCvgD2KK9Nvo8Gb7yU7EEERgTvukyxLQeCglCCEgobKSmKN7ihR_zOu1eXCdCQRQaYUh0OdDeVrrC-C_8Wrdr6oBvR5D1eE8qRE11o9vDNE-yoyNskzIQ4D4bITHupHglwEZoNI-Y',
  ];

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _locationOptions = [
    'Meadow Training Field',
    'Club Training Pitch',
    'Nordic Woods Field',
    'Västervik Brukshundklubb',
    'Home Garden',
    'Riverside Paddock',
    'Chelmsford Training Ground',
  ];

  static const List<String> _purposeOptions = [
    'Skill Building',
    'Trial Prep',
    'Fitness',
    'Socialisation',
    'Club Night',
  ];

  static const List<String> _equipmentOptions = [
    'Long Line (10m)',
    'Flat Collar',
    'Harness',
    'Clicker',
    'Canvas Dummy (500g)',
    'Position Box Marker',
    'Boundary Mat',
    'Bite Sleeve',
    'Dumbbell',
  ];

  static const List<String> _rewardOptions = [
    'High-Value Food',
    'Tug Toy',
    'Ball',
    'Praise',
    'Play',
  ];

  static const List<String> _tagOptions = [
    '#ClubNight',
    '#IGP3_Prep',
    '#MorningSession',
    '#Proofing',
    '#FieldWork',
  ];

  late TrainingSession _savedSnapshot;
  late SessionStatus _status;
  late bool _isEditing;
  late String _title;
  late DateTime _date;
  late TimeOfDay _start;
  TimeOfDay? _finish;
  int? _recordedDurationMinutes;
  late String _location;
  final String _weather = '16°C · Overcast';
  late String _purpose;
  late final TextEditingController _notes;
  bool _mediaExpanded = false;

  late List<_EditableSkill> _skills;
  late List<String> _equipment;
  late List<String> _rewards;
  late List<String> _sessionTags;

  bool get _isDraft => _status == SessionStatus.draft;
  bool get _inEditorMode => _isDraft || _isEditing;

  @override
  void initState() {
    super.initState();
    final latest =
        TrainingSessionStore.findById(widget.session.id) ?? widget.session;
    _savedSnapshot = latest;
    _notes = TextEditingController();
    _loadFromSession(latest);
    _isEditing = latest.status == SessionStatus.draft;
  }

  void _loadFromSession(TrainingSession s) {
    _status = s.status;
    _title = s.title;
    _date = s.date;
    _start = s.startTime;
    _finish = s.finishTime;
    _recordedDurationMinutes = s.recordedDurationMinutes;
    _location = s.location;
    _purpose = s.purpose;
    _notes.text = s.notes;
    _skills = s.recordedSkills.map(_EditableSkill.fromEntry).toList();
    _equipment = List<String>.from(s.equipment);
    _rewards = List<String>.from(s.rewards);
    _sessionTags = List<String>.from(s.sessionTags);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  // ── Live Computed Session Snapshot ────────────────────────────────────────

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  String _buildDateLabel(SessionStatus status) {
    if (status == SessionStatus.draft) {
      return '${_date.day} ${_shortMonths[_date.month - 1]} · Incomplete';
    }
    return '${_date.day} ${_shortMonths[_date.month - 1]} · ${_fmtTime(_start)}';
  }

  TrainingSession _buildUpdatedSession({SessionStatus? overrideStatus}) {
    final targetStatus = overrideStatus ?? _status;
    return _savedSnapshot.copyWith(
      title: _title.trim().isEmpty ? _savedSnapshot.title : _title.trim(),
      date: _date,
      dateLabel: _buildDateLabel(targetStatus),
      startTime: _start,
      finishTime: _finish,
      clearFinishTime: _finish == null,
      recordedDurationMinutes: _recordedDurationMinutes,
      clearRecordedDuration: _recordedDurationMinutes == null,
      status: targetStatus,
      recordedSkills: _skills.map((s) => s.toEntry()).toList(),
      location: _location,
      purpose: _purpose,
      notes: _notes.text.trim(),
      equipment: List<String>.from(_equipment),
      rewards: List<String>.from(_rewards),
      sessionTags: List<String>.from(_sessionTags),
    );
  }

  void _persistToStore({SessionStatus? overrideStatus}) {
    final updated = _buildUpdatedSession(overrideStatus: overrideStatus);
    _savedSnapshot = updated;
    TrainingSessionStore.upsertSession(updated);
  }

  String get _durationDisplay {
    final preview = _buildUpdatedSession();
    return preview.duration ?? 'Not recorded yet';
  }

  void _toast(String msg, SnackbarType type) =>
      AppSnackbar.show(context, message: msg, type: type);

  ThemeData get _pickerTheme => ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryForestGreen,
          surface: AppColors.cardsCarbon,
          onSurface: AppColors.primaryTextOffWhite,
        ),
      );

  TextStyle _ts(double size, Color color,
          [FontWeight w = FontWeight.w400, double? height]) =>
      TextStyle(fontSize: size, color: color, fontWeight: w, height: height);

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (c, child) => Theme(data: _pickerTheme, child: child!),
    );
    if (d != null) {
      setState(() => _date = d);
      if (_isDraft && !widget.isNewSession) _persistToStore();
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final t = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : (_finish ?? _start),
      builder: (c, child) => Theme(data: _pickerTheme, child: child!),
    );
    if (t == null) return;
    setState(() {
      if (isStart) {
        _start = t;
      } else {
        _finish = t;
      }
      if (_finish != null) {
        var diff = (_finish!.hour * 60 + _finish!.minute) -
            (_start.hour * 60 + _start.minute);
        if (diff < 0) diff += 24 * 60;
        if (diff > 0) {
          _recordedDurationMinutes = diff;
        }
      }
    });
    if (_isDraft && !widget.isNewSession) _persistToStore();
  }

  Future<void> _editDurationMinutes() async {
    final currentMins = _buildUpdatedSession().durationMinutes;
    final ctrl = TextEditingController(
      text: currentMins != null ? '$currentMins' : '',
    );
    final result = await showDialog<int>(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: AppColors.cardsCarbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recorded Duration',
                  style: _ts(18, AppColors.primaryTextOffWhite, FontWeight.w600)),
              const SizedBox(height: 6),
              Text(
                'Enter the duration recorded for this session in minutes.',
                style: _ts(13, AppColors.secondaryTextStoneGrey, FontWeight.w400, 1.4),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: _ts(15, AppColors.primaryTextOffWhite),
                  cursorColor: AppColors.primaryForestGreen,
                  decoration: InputDecoration(
                    hintText: 'e.g. 8',
                    suffixText: 'min',
                    suffixStyle: _ts(14, AppColors.secondaryTextStoneGrey),
                    hintStyle: _ts(15, AppColors.secondaryTextStoneGrey),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onSubmitted: (v) {
                    final parsed = int.tryParse(v.trim());
                    Navigator.pop(c, parsed);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: Text('Cancel',
                        style: _ts(14, AppColors.secondaryTextStoneGrey,
                            FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      final parsed = int.tryParse(ctrl.text.trim());
                      Navigator.pop(c, parsed);
                    },
                    child: Text('Save',
                        style: _ts(
                            14, AppColors.primaryForestGreen, FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (result != null && result > 0) {
      setState(() {
        _recordedDurationMinutes = result;
        final totalEndMinutes = (_start.hour * 60 + _start.minute + result) % (24 * 60);
        _finish = TimeOfDay(
          hour: totalEndMinutes ~/ 60,
          minute: totalEndMinutes % 60,
        );
      });
      if (_isDraft && !widget.isNewSession) _persistToStore();
    }
  }

  Future<String?> _pickOption(
      String title, List<String> options, String current) {
    final merged = {...options, if (current.isNotEmpty) current}.toList();
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sheetHandle(),
              Text(title,
                  style:
                      _ts(18, AppColors.primaryTextOffWhite, FontWeight.w600)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: merged
                      .map((o) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(o,
                                style: _ts(15, AppColors.primaryTextOffWhite)),
                            trailing: o == current
                                ? const Icon(Icons.check,
                                    color: AppColors.primaryForestGreen)
                                : null,
                            onTap: () => Navigator.pop(c, o),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetHandle() => Center(
        child: Container(
          width: 36,
          height: 4,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              color: Colors.white24, borderRadius: BorderRadius.circular(2)),
        ),
      );

  Future<String?> _promptText(String title, String hint, [String initial = '']) {
    final ctrl = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: AppColors.cardsCarbon,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      _ts(18, AppColors.primaryTextOffWhite, FontWeight.w600)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  style: _ts(15, AppColors.primaryTextOffWhite),
                  cursorColor: AppColors.primaryForestGreen,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: _ts(15, AppColors.secondaryTextStoneGrey),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onSubmitted: (v) => Navigator.pop(c, v.trim()),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: Text('Cancel',
                        style: _ts(14, AppColors.secondaryTextStoneGrey,
                            FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(c, ctrl.text.trim()),
                    child: Text('Save',
                        style: _ts(14, AppColors.primaryForestGreen,
                            FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add / Create Custom Skill Sheet ───────────────────────────────────────

  Future<void> _showAddSkillSheet() async {
    final customCtrl = TextEditingController();
    final selectedName = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (c) => StatefulBuilder(
        builder: (c, setSheet) {
          final catalog = TrainingSessionStore.skillCatalogNotifier.value;
          final query = customCtrl.text.trim().toLowerCase();
          final filteredCatalog = query.isEmpty
              ? catalog
              : catalog
                  .where((e) => e.skillName.toLowerCase().contains(query))
                  .toList();
          final exactCatalogMatch = catalog.any(
            (e) =>
                normalizeTrainingKey(e.skillName) ==
                normalizeTrainingKey(customCtrl.text),
          );

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(c).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHandle(),
                    Text(
                      'Add Skill to Session',
                      style: _ts(
                          18, AppColors.primaryTextOffWhite, FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select one of your skills or enter a custom skill name. Each distinct skill is counted once per session.',
                      style: _ts(13, AppColors.secondaryTextStoneGrey,
                          FontWeight.w400, 1.4),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const UlvenikIcon(UlvenikIcons.skills,
                              size: 18,
                              color: AppColors.secondaryTextStoneGrey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: customCtrl,
                              onChanged: (_) => setSheet(() {}),
                              style: _ts(14, AppColors.primaryTextOffWhite),
                              cursorColor: AppColors.primaryForestGreen,
                              decoration: InputDecoration(
                                hintText:
                                    'Search or create custom skill (e.g. Platform Send)...',
                                hintStyle:
                                    _ts(13, AppColors.secondaryTextStoneGrey),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onSubmitted: (v) {
                                if (v.trim().isNotEmpty) {
                                  Navigator.pop(c, v.trim());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (customCtrl.text.trim().isNotEmpty &&
                        !exactCatalogMatch) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: _primaryBtn(
                          'Create Custom Skill "${customCtrl.text.trim()}"',
                          Icons.add_circle_outline,
                          () => Navigator.pop(c, customCtrl.text.trim()),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _label('YOUR SKILLS'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filteredCatalog.map((entry) {
                        final alreadyInSession = _skills.any(
                          (s) =>
                              normalizeTrainingKey(s.skillName) ==
                              normalizeTrainingKey(entry.skillName),
                        );
                        return GestureDetector(
                          onTap: () => Navigator.pop(c, entry.skillName),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: alreadyInSession
                                  ? AppColors.primaryForestGreen
                                      .withValues(alpha: 0.22)
                                  : AppColors.backgroundObsidian,
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: alreadyInSession
                                    ? AppColors.primaryForestGreen
                                    : Colors.white12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (alreadyInSession) ...[
                                  const Icon(Icons.check,
                                      size: 14,
                                      color: AppColors.primaryForestGreen),
                                  const SizedBox(width: 5),
                                ],
                                Text(
                                  entry.skillName,
                                  style: _ts(
                                    13,
                                    alreadyInSession
                                        ? AppColors.primaryTextOffWhite
                                        : AppColors.secondaryTextStoneGrey,
                                    FontWeight.w500,
                                  ),
                                ),
                                if (entry.isCustom) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    'CUSTOM',
                                    style: _ts(
                                        9,
                                        AppColors.primaryForestGreen,
                                        FontWeight.w700),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    if (selectedName == null || selectedName.trim().isEmpty) return;
    final cleanName = selectedName.trim();
    final key = normalizeTrainingKey(cleanName);

    final existingIdx = _skills.indexWhere(
      (s) => normalizeTrainingKey(s.skillName) == key,
    );
    if (existingIdx >= 0) {
      setState(() => _skills[existingIdx].open = true);
      _toast(
        '"${_skills[existingIdx].skillName}" is already recorded in this session (counted once)',
        SnackbarType.info,
      );
      return;
    }

    final isCustom = TrainingSessionStore.isCustomSkill(cleanName);
    if (isCustom) {
      TrainingSessionStore.registerCustomSkill(cleanName);
    }

    setState(() {
      _skills.add(
        _EditableSkill(
          id: 'sk_${DateTime.now().microsecondsSinceEpoch}',
          skillName: cleanName,
          isCustom: isCustom,
          open: true,
        ),
      );
    });
    if (_isDraft && !widget.isNewSession) _persistToStore();
  }

  // ── Add / Create Custom Exercise (with Separate Repetitions) Sheet ────────

  Future<void> _showAddExerciseSheet(_EditableSkill skill) async {
    final nameCtrl = TextEditingController();
    int reps = 1;

    final result = await showModalBottomSheet<(String, int)>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (c) => StatefulBuilder(
        builder: (c, setSheet) {
          final suggestions =
              TrainingSessionStore.exercisesForSkill(skill.skillName);
          final canAdd = nameCtrl.text.trim().isNotEmpty;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(c).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHandle(),
                    Text(
                      'Add Exercise · ${skill.skillName}',
                      style: _ts(
                          18, AppColors.primaryTextOffWhite, FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select an exercise or enter a custom one. Repetitions are recorded separately and do not increase the distinct exercise count.',
                      style: _ts(13, AppColors.secondaryTextStoneGrey,
                          FontWeight.w400, 1.4),
                    ),
                    if (suggestions.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _label('SUGGESTED EXERCISES'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: suggestions.map((exName) {
                          final selected = normalizeTrainingKey(nameCtrl.text) ==
                              normalizeTrainingKey(exName);
                          return GestureDetector(
                            onTap: () => setSheet(() => nameCtrl.text = exName),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primaryForestGreen
                                        .withValues(alpha: 0.25)
                                    : AppColors.backgroundObsidian,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primaryForestGreen
                                      : Colors.white12,
                                ),
                              ),
                              child: Text(
                                exName,
                                style: _ts(
                                  13,
                                  selected
                                      ? AppColors.primaryTextOffWhite
                                      : AppColors.secondaryTextStoneGrey,
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _label('EXERCISE NAME'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: nameCtrl,
                        onChanged: (_) => setSheet(() {}),
                        style: _ts(14, AppColors.primaryTextOffWhite),
                        cursorColor: AppColors.primaryForestGreen,
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Down on verbal cue (or custom exercise)',
                          hintStyle:
                              _ts(13, AppColors.secondaryTextStoneGrey),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repetitions',
                                  style: _ts(14, AppColors.primaryTextOffWhite,
                                      FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Recorded separately from exercise count',
                                  style: _ts(
                                      11, AppColors.secondaryTextStoneGrey),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Decrease repetitions',
                            onPressed: reps > 1
                                ? () => setSheet(() => reps--)
                                : null,
                            icon: Icon(Icons.remove_circle_outline,
                              color: reps > 1
                                  ? AppColors.primaryTextOffWhite
                                  : Colors.white24,
                              size: 22,
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '$reps',
                              textAlign: TextAlign.center,
                              style: _ts(16, AppColors.primaryTextOffWhite,
                                  FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Increase repetitions',
                            onPressed: () => setSheet(() => reps++),
                            icon: const UlvenikIcon(UlvenikIcons.add,
                              color: AppColors.primaryForestGreen,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canAdd
                            ? () =>
                                Navigator.pop(c, (nameCtrl.text.trim(), reps))
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          disabledBackgroundColor: AppColors.primaryForestGreen
                              .withValues(alpha: 0.3),
                          foregroundColor: AppColors.primaryTextOffWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add Exercise',
                          style: _ts(14, AppColors.primaryTextOffWhite,
                              FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    if (result == null) return;
    final exName = result.$1.trim();
    final addedReps = result.$2;
    if (exName.isEmpty) return;

    final exKey = normalizeTrainingKey(exName);

    // Check if this exercise was already recorded anywhere in this session
    for (final sk in _skills) {
      final existingIdx = sk.exercises.indexWhere(
        (e) => normalizeTrainingKey(e.name) == exKey,
      );
      if (existingIdx >= 0) {
        setState(() {
          sk.exercises[existingIdx].repetitions += addedReps;
          sk.open = true;
        });
        if (_isDraft && !widget.isNewSession) _persistToStore();
        _toast(
          'Added $addedReps ${addedReps == 1 ? 'rep' : 'reps'} to "${sk.exercises[existingIdx].name}" (distinct exercise count unchanged)',
          SnackbarType.info,
        );
        return;
      }
    }

    final catalogExercises =
        TrainingSessionStore.exercisesForSkill(skill.skillName);
    final isKnownInCatalog = catalogExercises.any(
      (e) => normalizeTrainingKey(e) == exKey,
    );
    final isCustomEx = !isKnownInCatalog;
    if (isCustomEx) {
      TrainingSessionStore.registerCustomExercise(skill.skillName, exName);
    }

    setState(() {
      skill.exercises.add(
        _EditableExercise(
          id: 'ex_${DateTime.now().microsecondsSinceEpoch}',
          name: exName,
          repetitions: addedReps,
          isCustom: isCustomEx,
        ),
      );
      skill.open = true;
    });
    if (_isDraft && !widget.isNewSession) _persistToStore();
  }

  Future<void> _editChips(
      String title,
      List<String> options,
      List<String> selected,
      ValueChanged<List<String>> onDone) async {
    final temp = List<String>.from(selected);
    final all = {...options, ...selected}.toList();
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => StatefulBuilder(
        builder: (c, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHandle(),
                Text(title,
                    style: _ts(
                        18, AppColors.primaryTextOffWhite, FontWeight.w600)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: all.map((o) {
                    final on = temp.contains(o);
                    return GestureDetector(
                      onTap: () =>
                          setSheet(() => on ? temp.remove(o) : temp.add(o)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: on
                              ? AppColors.primaryForestGreen
                                  .withValues(alpha: 0.25)
                              : AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                              color: on
                                  ? AppColors.primaryForestGreen
                                  : Colors.white12),
                        ),
                        child: Text(o,
                            style: _ts(
                                13,
                                on
                                    ? AppColors.primaryTextOffWhite
                                    : AppColors.secondaryTextStoneGrey)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: _primaryBtn('Done', null, () => Navigator.pop(c, temp)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (result != null) {
      setState(() => onDone(result));
      _persistToStore();
    }
  }

  void _saveDraft() {
    _persistToStore(overrideStatus: SessionStatus.draft);
    _toast('Draft saved', SnackbarType.success);
  }

  void _completeSession() {
    if (_recordedDurationMinutes == null && _finish == null) {
      _recordedDurationMinutes = 10;
      final endMins = (_start.hour * 60 + _start.minute + 10) % (24 * 60);
      _finish = TimeOfDay(hour: endMins ~/ 60, minute: endMins % 60);
    }
    setState(() {
      _status = SessionStatus.completed;
      _isEditing = false;
    });
    _persistToStore(overrideStatus: SessionStatus.completed);
    _toast('Session completed', SnackbarType.success);
  }

  void _saveCompletedEdits() {
    setState(() => _isEditing = false);
    _persistToStore(overrideStatus: SessionStatus.completed);
    _toast('Session updated', SnackbarType.success);
  }

  void _cancelCompletedEdits() {
    setState(() {
      _loadFromSession(_savedSnapshot);
      _isEditing = false;
    });
  }

  void _enterEditMode() {
    setState(() => _isEditing = true);
  }

  Future<void> _confirmDelete() async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sheetHandle(),
              Text('Delete this session?',
                  style:
                      _ts(18, AppColors.primaryTextOffWhite, FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                  'This will permanently remove "$_title" and all recorded skills, exercises, notes, and media. This action cannot be undone.',
                  style: _ts(14, AppColors.secondaryTextStoneGrey,
                      FontWeight.w400, 1.4)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: _filledBtn(
                    'Permanently Delete Session',
                    AppColors.errorDestructive,
                    () => Navigator.pop(c, true)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child:
                    _outlineBtn('Cancel', null, () => Navigator.pop(c, false)),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true && mounted) {
      TrainingSessionStore.deleteSession(_savedSnapshot.id);
      _toast('Session deleted', SnackbarType.error);
      Navigator.of(context).maybePop();
    }
  }

  void _showMore() {
    final items = <(IconData, String, VoidCallback)>[
      (
        Icons.copy_outlined,
        'Duplicate Session',
        () {
          final copy = _buildUpdatedSession(overrideStatus: SessionStatus.draft)
              .copyWith(
            id: 'session_${DateTime.now().microsecondsSinceEpoch}',
            title: '$_title (Copy)',
            dateLabel: 'Today · Incomplete',
          );
          TrainingSessionStore.upsertSession(copy);
          _toast('Session duplicated as a new draft', SnackbarType.success);
        }
      ),
      (
        Icons.ios_share_outlined,
        'Share Session',
        () => _toast('Share link copied', SnackbarType.info)
      ),
      (
        Icons.picture_as_pdf_outlined,
        'Export as PDF',
        () => _toast('Export started', SnackbarType.info)
      ),
      (Icons.delete_outline, 'Delete Session', _confirmDelete),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),
              ...items.map((i) {
                final destructive = i.$2.startsWith('Delete');
                final color = destructive
                    ? const Color(0xFFD08080)
                    : AppColors.primaryTextOffWhite;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: UlvenikIcon.fromMaterial(i.$1, color: color),
                  title: Text(i.$2, style: _ts(15, color)),
                  onTap: () {
                    Navigator.pop(c);
                    i.$3();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final topSafe = MediaQuery.of(context).padding.top;
    final heroH = (width * 0.6).clamp(200.0, 300.0) + topSafe * 0.5;
    final preview = _buildUpdatedSession();

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHero(heroH, topSafe),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: _inEditorMode
                        ? KeyedSubtree(
                            key: const ValueKey('editor'),
                            child: _buildEditor(preview),
                          )
                        : KeyedSubtree(
                            key: const ValueKey('completed'),
                            child: _buildCompleted(preview),
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

  Widget _buildHero(double height, double topSafe) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _heroImage,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F3B33), Color(0xFF14201C)],
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  AppColors.backgroundObsidian,
                ],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          Positioned(
            top: topSafe + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleBtn(
                    Icons.chevron_left, () => Navigator.of(context).maybePop()),
                _circleBtn(Icons.more_vert, _showMore),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.cardsCarbon.withValues(alpha: 0.85),
      shape: const CircleBorder(side: BorderSide(color: Colors.white12)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: UlvenikIcon.fromMaterial(icon, color: AppColors.primaryTextOffWhite, size: 22),
        ),
      ),
    );
  }

  // ── Shared header with live auto-calculated summary ───────────────────────

  Widget _buildHeader(TrainingSession preview) {
    final badge = _isDraft
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.7)),
            ),
            child: Text('DRAFT',
                style: _ts(11, AppColors.primaryForestGreen, FontWeight.w700)
                    .copyWith(letterSpacing: 0.6)),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryForestGreen,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(_isEditing ? 'EDITING' : 'COMPLETED',
                style: _ts(11, const Color(0xFFAAE9D0), FontWeight.w700)
                    .copyWith(letterSpacing: 0.6)),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: preview.dogColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryForestGreen),
              ),
              child: Center(
                child: Text(preview.dogInitial,
                    style: _ts(16, preview.dogColor, FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(preview.dogName,
                  overflow: TextOverflow.ellipsis,
                  style: _ts(16, AppColors.primaryTextOffWhite, FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            badge,
          ],
        ),
        const SizedBox(height: 14),
        Text(_title,
            style: _ts(28, AppColors.primaryTextOffWhite, FontWeight.w700, 1.2)),
        const SizedBox(height: 6),
        Row(
          children: [
            const UlvenikIcon(UlvenikIcons.calendar,
                size: 14, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 6),
            Flexible(
              child: Text('${_fmtDate(_date)} · ${_fmtTime(_start)}',
                  style: _ts(14, AppColors.secondaryTextStoneGrey)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Auto-calculated session statistics strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Wrap(
            spacing: 14,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _headerStatItem(
                Icons.schedule_outlined,
                preview.duration ?? 'No duration yet',
              ),
              _headerStatItem(
                Icons.layers_outlined,
                preview.formattedSkillCount,
              ),
              _headerStatItem(
                Icons.repeat,
                preview.formattedExerciseCount,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UlvenikIcon.fromMaterial(icon, size: 15, color: AppColors.primaryForestGreen),
        const SizedBox(width: 5),
        Text(
          text,
          style: _ts(13, AppColors.primaryTextOffWhite, FontWeight.w600),
        ),
      ],
    );
  }

  // ── Draft / Editor state ──────────────────────────────────────────────────

  Widget _buildEditor(TrainingSession preview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(preview),
        const SizedBox(height: 20),
        if (_isDraft) ...[
          _primaryBtn(
              'Complete Session', Icons.check_circle_outline, _completeSession),
          const SizedBox(height: 10),
          _outlineBtn('Save Draft', Icons.save_outlined, _saveDraft),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _primaryBtn(
                    'Save Changes', Icons.check_circle_outline, _saveCompletedEdits),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _outlineBtn('Cancel', null, _cancelCompletedEdits),
              ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        _card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _detailRow(Icons.edit_outlined, 'Title', _title,
                  chevron: true, onTap: () async {
                final v = await _promptText('Session Title', 'Title', _title);
                if (v != null && v.isNotEmpty) {
                  setState(() => _title = v);
                  if (_isDraft && !widget.isNewSession) _persistToStore();
                }
              }),
              _detailRow(Icons.calendar_today_outlined, 'Date', _fmtDate(_date),
                  chevron: true, onTap: _pickDate),
              _detailRow(Icons.schedule, 'Start Time', _fmtTime(_start),
                  chevron: true, onTap: () => _pickTime(isStart: true)),
              _detailRow(
                  Icons.update,
                  'Finish Time',
                  _finish == null ? 'Not set' : _fmtTime(_finish!),
                  chevron: true,
                  onTap: () => _pickTime(isStart: false)),
              _detailRow(Icons.timer_outlined, 'Duration', _durationDisplay,
                  chevron: true, onTap: _editDurationMinutes),
              _detailRow(Icons.place_outlined, 'Location', _location,
                  chevron: true, onTap: () async {
                final v =
                    await _pickOption('Location', _locationOptions, _location);
                if (v != null) {
                  setState(() => _location = v);
                  if (_isDraft && !widget.isNewSession) _persistToStore();
                }
              }),
              _detailRow(Icons.cloud_outlined, 'Weather', _weather),
              _detailRow(Icons.flag_outlined, 'Purpose', _purpose,
                  chevron: true, last: true, onTap: () async {
                final v =
                    await _pickOption('Purpose', _purposeOptions, _purpose);
                if (v != null) {
                  setState(() => _purpose = v);
                  if (_isDraft && !widget.isNewSession) _persistToStore();
                }
              }),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              _label('SKILLS & EXERCISES'),
              Text(
                '${preview.formattedSkillCount} · ${preview.formattedExerciseCount}',
                style: _ts(12, AppColors.primaryForestGreen, FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_skills.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _card(
              child: Text(
                'No skills recorded yet. Add a skill and its exercises below — Ulvenik automatically calculates distinct skills and exercises for you.',
                style: _ts(
                    13, AppColors.secondaryTextStoneGrey, FontWeight.w400, 1.45),
              ),
            ),
          ),
        ..._skills.map(_buildEditableSkillCard),
        _dashedButton('Add Skill', Icons.add, _showAddSkillSheet),
        const SizedBox(height: 24),
        _label('SESSION NOTES'),
        const SizedBox(height: 8),
        _card(
          child: TextField(
            controller: _notes,
            maxLines: null,
            minLines: 3,
            onChanged: (_) {
              if (_isDraft && !widget.isNewSession) _persistToStore();
            },
            cursorColor: AppColors.primaryForestGreen,
            style:
                _ts(14, AppColors.primaryTextOffWhite, FontWeight.w400, 1.5),
            decoration: InputDecoration(
              hintText: 'Add notes about this session...',
              hintStyle: _ts(14, AppColors.secondaryTextStoneGrey),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: TextButton(
            onPressed: _confirmDelete,
            child: Text(_isDraft ? 'Delete Draft' : 'Delete Session',
                style: _ts(13, const Color(0xFFB05A5A), FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableSkillCard(_EditableSkill skill) {
    final distinctEx = skill.toEntry().distinctExerciseCount;
    final exLabel =
        '$distinctEx ${distinctEx == 1 ? 'Exercise' : 'Exercises'}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _card(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => skill.open = !skill.open),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
                child: Row(
                  children: [
                    const UlvenikIcon(UlvenikIcons.skills,
                        color: AppColors.primaryForestGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  skill.skillName,
                                  overflow: TextOverflow.ellipsis,
                                  style: _ts(17, AppColors.primaryTextOffWhite,
                                      FontWeight.w600),
                                ),
                              ),
                              if (skill.isCustom) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryForestGreen
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'CUSTOM',
                                    style: _ts(
                                        9,
                                        AppColors.primaryForestGreen,
                                        FontWeight.w700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            exLabel,
                            style: _ts(12, AppColors.secondaryTextStoneGrey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove Skill',
                      icon: const Icon(Icons.delete_outline,
                          size: 19, color: AppColors.secondaryTextStoneGrey),
                      onPressed: () {
                        setState(() => _skills.remove(skill));
                        if (_isDraft && !widget.isNewSession) _persistToStore();
                      },
                    ),
                    AnimatedRotation(
                      turns: skill.open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(Icons.expand_more,
                          color: AppColors.secondaryTextStoneGrey),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: skill.open
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...skill.exercises.map(
                            (ex) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.only(
                                  left: 12, top: 8, bottom: 8, right: 4),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundObsidian,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ex.name,
                                          style: _ts(
                                              14,
                                              AppColors.primaryTextOffWhite,
                                              FontWeight.w500),
                                        ),
                                        if (ex.isCustom)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              'Custom exercise',
                                              style: _ts(
                                                  11,
                                                  AppColors.primaryForestGreen,
                                                  FontWeight.w500),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Separate repetitions stepper
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardsCarbon,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.white12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: ex.repetitions > 1
                                              ? () {
                                                  setState(
                                                      () => ex.repetitions--);
                                                  if (_isDraft &&
                                                      !widget.isNewSession) {
                                                    _persistToStore();
                                                  }
                                                }
                                              : null,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(Icons.remove,
                                              size: 14,
                                              color: ex.repetitions > 1
                                                  ? AppColors
                                                      .secondaryTextStoneGrey
                                                  : Colors.white24,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Text(
                                            '${ex.repetitions} ${ex.repetitions == 1 ? 'rep' : 'reps'}',
                                            style: _ts(
                                                12,
                                                AppColors.primaryTextOffWhite,
                                                FontWeight.w600),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() => ex.repetitions++);
                                            if (_isDraft &&
                                                !widget.isNewSession) {
                                              _persistToStore();
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(4),
                                            child: UlvenikIcon(UlvenikIcons.add,
                                              size: 14,
                                              color:
                                                  AppColors.primaryForestGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove Exercise',
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.close,
                                        size: 18,
                                        color:
                                            AppColors.secondaryTextStoneGrey),
                                    onPressed: () {
                                      setState(() => skill.exercises.remove(ex));
                                      if (_isDraft && !widget.isNewSession) {
                                        _persistToStore();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _dashedButton(
                            'Add Exercise',
                            Icons.add,
                            () => _showAddExerciseSheet(skill),
                            compact: true,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  // ── Completed state ───────────────────────────────────────────────────────

  Widget _buildCompleted(TrainingSession preview) {
    final hasNotes = _notes.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(preview),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _primaryBtn('Edit Session', Icons.edit, _enterEditMode),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _outlineBtn('More Options', Icons.more_horiz, _showMore),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _card(
          child: Column(
            children: [
              _metaRow('Dog', preview.dogName, first: true),
              _metaRow('Location', _location),
              _metaRow('Purpose', _purpose),
              _metaRow(
                'Recorded Duration',
                preview.duration ?? 'Not recorded',
                valueColor: AppColors.primaryForestGreen,
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              _label('SKILLS & EXERCISES'),
              Text(
                '${preview.formattedSkillCount} · ${preview.formattedExerciseCount}',
                style: _ts(12, AppColors.primaryForestGreen, FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_skills.isEmpty)
          _card(
            child: Text(
              'No skills recorded in this session.',
              style: _ts(13, AppColors.secondaryTextStoneGrey),
            ),
          )
        else
          ..._skills.map(_buildCompletedSkillCard),
        if (preview.skillTags.isNotEmpty) ...[
          const SizedBox(height: 4),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('SKILL TAGS'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: preview.skillTags.map(_miniTag).toList(),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('SESSION NOTES'),
            if (!hasNotes)
              GestureDetector(
                onTap: _enterEditMode,
                child: Text('Add Note',
                    style: _ts(
                        13, AppColors.primaryForestGreen, FontWeight.w600)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _card(
          child: Text(
            hasNotes ? _notes.text.trim() : 'No notes added',
            style: _ts(
              14,
              hasNotes
                  ? AppColors.primaryTextOffWhite
                  : AppColors.secondaryTextStoneGrey,
              FontWeight.w400,
              1.55,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildMedia(),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, c) {
          final eq = _chipCard('EQUIPMENT USED', _equipment, () {
            _editChips('Equipment used', _equipmentOptions, _equipment,
                (v) => _equipment = v);
          });
          final rw = _chipCard('REWARDS USED', _rewards, () {
            _editChips(
                'Rewards used', _rewardOptions, _rewards, (v) => _rewards = v);
          });
          if (c.maxWidth >= 560) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: eq),
                const SizedBox(width: 12),
                Expanded(child: rw),
              ],
            );
          }
          return Column(children: [eq, const SizedBox(height: 12), rw]);
        }),
        const SizedBox(height: 12),
        _chipCard('TAGS', _sessionTags, () {
          _editChips('Tags', _tagOptions, _sessionTags, (v) => _sessionTags = v);
        }, square: true),
        const SizedBox(height: 28),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SizedBox(
              width: double.infinity,
              child: _primaryBtn('Edit Session', null, _enterEditMode),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _confirmDelete,
            child: Text('Delete Session',
                style: _ts(13, const Color(0xFFB05A5A), FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedSkillCard(_EditableSkill skill) {
    final entry = skill.toEntry();
    final distinctEx = entry.distinctExerciseCount;
    final exCountChip =
        '$distinctEx ${distinctEx == 1 ? 'Exercise' : 'Exercises'}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _card(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => skill.open = !skill.open),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const UlvenikIcon(UlvenikIcons.skills,
                        color: AppColors.primaryForestGreen, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(skill.skillName,
                          style: _ts(18, AppColors.primaryTextOffWhite,
                              FontWeight.w600)),
                    ),
                    _miniTag(exCountChip),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: skill.open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(Icons.expand_more,
                          color: AppColors.secondaryTextStoneGrey),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: skill.open
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            children: skill.exercises
                                .map(
                                  (ex) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryForestGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            ex.name,
                                            style: _ts(
                                                14,
                                                AppColors.primaryTextOffWhite),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _miniTag(
                                          '${ex.repetitions} ${ex.repetitions == 1 ? 'rep' : 'reps'}',
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedia() {
    final total = _mediaUrls.length + 2;
    final items = List<int>.generate(total, (i) => i);
    final visible = _mediaExpanded ? items : items.take(4).toList();
    final hidden = total - 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('MEDIA'),
            GestureDetector(
              onTap: () =>
                  _toast('Media manager coming soon', SnackbarType.info),
              child: Text('Manage Media',
                  style:
                      _ts(13, AppColors.primaryForestGreen, FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(builder: (context, c) {
          const gap = 8.0;
          final size = (c.maxWidth - gap * 2) / 3;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              ...visible.map((i) {
                final url = _mediaUrls[i % _mediaUrls.length];
                final isVideo = i == 0 || i == 3;
                return GestureDetector(
                  onTap: () => _toast(
                      isVideo
                          ? 'Video viewer coming soon'
                          : 'Photo viewer coming soon',
                      SnackbarType.info),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.cardsCarbon,
                              child: const Icon(Icons.image_outlined,
                                  color: AppColors.secondaryTextStoneGrey),
                            ),
                          ),
                          if (isVideo)
                            Positioned(
                              right: 6,
                              bottom: 6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.videocam,
                                    size: 12,
                                    color: AppColors.primaryTextOffWhite),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (!_mediaExpanded && hidden > 0)
                GestureDetector(
                  onTap: () => setState(() => _mediaExpanded = true),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: AppColors.cardsCarbon,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Center(
                      child: Text('+$hidden more',
                          style: _ts(13, AppColors.secondaryTextStoneGrey,
                              FontWeight.w500)),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _chipCard(String title, List<String> chips, VoidCallback onEdit,
      {bool square = false}) {
    return SizedBox(
      width: double.infinity,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _label(title),
                GestureDetector(
                  onTap: onEdit,
                  child: Text('Edit',
                      style: _ts(
                          13, AppColors.primaryForestGreen, FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            chips.isEmpty
                ? Text('None added',
                    style: _ts(13, AppColors.secondaryTextStoneGrey))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: chips
                        .map((c) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: square
                                    ? AppColors.cardsCarbon
                                    : AppColors.backgroundObsidian,
                                borderRadius:
                                    BorderRadius.circular(square ? 6 : 9999),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Text(c,
                                  style: _ts(
                                      12,
                                      square
                                          ? AppColors.secondaryTextStoneGrey
                                          : AppColors.primaryTextOffWhite)),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  // ── Small building blocks ─────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }

  Widget _label(String t) => Text(t,
      style: _ts(11, AppColors.secondaryTextStoneGrey, FontWeight.w700)
          .copyWith(letterSpacing: 0.8));

  Widget _miniTag(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(t, style: _ts(11, AppColors.secondaryTextStoneGrey)),
      );

  Widget _detailRow(IconData icon, String label, String value,
      {VoidCallback? onTap, bool chevron = false, bool last = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: label == 'Title' ? const Radius.circular(16) : Radius.zero,
        bottom: last ? const Radius.circular(16) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, size: 20, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 12),
            Text(label, style: _ts(14, AppColors.secondaryTextStoneGrey)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: _ts(
                      14, AppColors.primaryTextOffWhite, FontWeight.w500)),
            ),
            if (chevron) ...[
              const SizedBox(width: 4),
              const UlvenikIcon(UlvenikIcons.details,
                  size: 18, color: AppColors.secondaryTextStoneGrey),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metaRow(String label, String value,
      {Color? valueColor, bool first = false, bool last = false}) {
    return Container(
      padding: EdgeInsets.only(top: first ? 0 : 12, bottom: last ? 0 : 12),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Text(label,
              style: _ts(
                  13, AppColors.secondaryTextStoneGrey, FontWeight.w500)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: _ts(14, valueColor ?? AppColors.primaryTextOffWhite,
                    valueColor != null ? FontWeight.w600 : FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _primaryBtn(String label, IconData? icon, VoidCallback onTap) =>
      _filledBtn(label, AppColors.primaryForestGreen, onTap, icon: icon);

  Widget _filledBtn(String label, Color color, VoidCallback onTap,
      {IconData? icon}) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                UlvenikIcon.fromMaterial(icon, size: 18, color: AppColors.primaryTextOffWhite),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: _ts(
                        14, AppColors.primaryTextOffWhite, FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlineBtn(String label, IconData? icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                UlvenikIcon.fromMaterial(icon, size: 18, color: AppColors.primaryTextOffWhite),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: _ts(
                        14, AppColors.primaryTextOffWhite, FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashedButton(String label, IconData icon, VoidCallback onTap,
      {bool compact = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: compact ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UlvenikIcon.fromMaterial(icon, size: 18, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 6),
              Text(label,
                  style: _ts(
                      13, AppColors.secondaryTextStoneGrey, FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
