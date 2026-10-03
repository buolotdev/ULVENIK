import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'training_screen.dart';

// ─── Local models ─────────────────────────────────────────────────────────────

class _Section {
  String name;
  int mins;
  bool open;
  final List<String> categories;
  final List<String> exercises;

  _Section({
    required this.name,
    required this.mins,
    this.open = false,
    this.categories = const [],
    List<String>? exercises,
  }) : exercises = exercises ?? [];
}

class _Phase {
  final IconData icon;
  final Color color;
  final String name;
  final List<String> chips;
  final List<String> details;
  bool open;

  _Phase({
    required this.icon,
    required this.color,
    required this.name,
    required this.chips,
    required this.details,
    this.open = false,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class TrainingSessionScreen extends StatefulWidget {
  final TrainingSession session;

  const TrainingSessionScreen({super.key, required this.session});

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
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];

  static const List<String> _locationOptions = [
    'Nordic Woods Field',
    'Västervik Brukshundklubb',
    'Home Garden',
    'City Park',
  ];
  static const List<String> _purposeOptions = [
    'Trial Prep',
    'Skill Building',
    'Fitness',
    'Socialisation',
    'Club Night',
  ];
  static const List<String> _equipmentOptions = [
    'Prong Collar', 'Long Line (10m)', 'Bite Sleeve', 'Harness',
    'Clicker', 'Dumbbell',
  ];
  static const List<String> _rewardOptions = [
    'Tug Toy', 'High-Value Food', 'Ball', 'Praise',
  ];
  static const List<String> _tagOptions = [
    '#ClubNight', '#IGP3_Prep', '#NightTraining', '#Recall', '#Tracking',
  ];

  late SessionStatus _status;
  late String _title;
  late DateTime _date;
  late TimeOfDay _start;
  TimeOfDay? _finish;
  late String _location;
  String _weather = '16°C · Overcast';
  late String _purpose;
  late final TextEditingController _notes;
  bool _mediaExpanded = false;

  late final List<_Section> _sections;
  late final List<_Phase> _phases;
  late List<String> _equipment;
  late List<String> _rewards;
  late List<String> _tags;

  bool get _isDraft => _status == SessionStatus.draft;

  @override
  void initState() {
    super.initState();
    final s = widget.session;
    _status = s.status;
    _title = s.title;
    _date = _isDraft ? DateTime.now() : DateTime(2026, 6, 14);
    _start = const TimeOfDay(hour: 18, minute: 30);
    _finish = _isDraft ? null : const TimeOfDay(hour: 20, minute: 45);
    _location = _isDraft ? 'Nordic Woods Field' : 'Västervik Brukshundklubb';
    _purpose = 'Trial Prep';
    _notes = TextEditingController(
      text: _isDraft
          ? '${s.dogName} showed excellent drive during the initial heelwork phases. Maintained strong eye contact. Need to work on slowing down the retrieve return, slightly too frantic.'
          : 'Excellent focus in protection phase. ${s.dogName} handled the helper movement on the blind search with increased intensity. Need to watch the barking rhythm on the hold and bark, tends to get frantic if helper is stationary too long. Obedience routine was solid, but the send-away needs more drive off the line.',
    );

    _sections = [
      _Section(
        name: 'Heelwork',
        mins: 15,
        open: true,
        categories: const ['Competition Heelwork'],
        exercises: ['Figure of Eight x3'],
      ),
      _Section(name: 'Retrieve', mins: 10, exercises: ['Dumbbell Retrieve x2']),
    ];

    _phases = [
      _Phase(
        icon: Icons.sports_score,
        color: AppColors.infoAlpineBlue,
        name: 'Obedience',
        chips: const ['4 Exercises', '1 Note'],
        details: const [
          'Heel position x3',
          'Sit and Down stay',
          'Recall off the line',
          'Send-away',
        ],
      ),
      _Phase(
        icon: Icons.explore_outlined,
        color: AppColors.primaryForestGreen,
        name: 'Tracking',
        chips: const ['2 Articles', '1 Video'],
        details: const ['Article indication x2', 'Cold start track'],
      ),
      _Phase(
        icon: Icons.shield_outlined,
        color: AppColors.errorDestructive,
        name: 'Protection',
        chips: const ['6 Skills', '2 Videos', 'Notes'],
        details: const [
          'Blind search',
          'Hold and bark',
          'Sleeve work',
          'Out on command',
          'Escape and re-bite',
          'Courage test',
        ],
      ),
    ];

    _equipment = ['Prong Collar', 'Long Line (10m)', 'Bite Sleeve'];
    _rewards = ['Tug Toy', 'High-Value Food'];
    _tags = ['#ClubNight', '#IGP3_Prep', '#NightTraining'];
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  String get _duration {
    if (_finish == null) return 'Calculating...';
    var mins = (_finish!.hour * 60 + _finish!.minute) -
        (_start.hour * 60 + _start.minute);
    if (mins < 0) mins += 24 * 60;
    final h = mins ~/ 60;
    final m = mins % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
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
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final t = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : (_finish ?? _start),
      builder: (c, child) => Theme(data: _pickerTheme, child: child!),
    );
    if (t == null) return;
    setState(() => isStart ? _start = t : _finish = t);
  }

  Future<String?> _pickOption(String title, List<String> options, String current) {
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
                  style: _ts(18, AppColors.primaryTextOffWhite, FontWeight.w600)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: options
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
                  style: _ts(18, AppColors.primaryTextOffWhite, FontWeight.w600)),
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

  Future<void> _editChips(
      String title, List<String> options, List<String> selected,
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
                    style: _ts(18, AppColors.primaryTextOffWhite,
                        FontWeight.w600)),
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
                              ? AppColors.primaryForestGreen.withOpacity(0.25)
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
    if (result != null) setState(() => onDone(result));
  }

  void _saveDraft() => _toast('Draft saved', SnackbarType.success);

  void _complete() {
    if (_finish == null) {
      _toast('Set a finish time before completing the session',
          SnackbarType.warning);
      return;
    }
    setState(() => _status = SessionStatus.completed);
    _toast('Session completed', SnackbarType.success);
  }

  void _reopen() {
    setState(() => _status = SessionStatus.draft);
    _toast('Session reopened for editing', SnackbarType.info);
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
                  style: _ts(18, AppColors.primaryTextOffWhite,
                      FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                  'This will permanently remove "$_title" and all of its notes and media.',
                  style: _ts(14, AppColors.secondaryTextStoneGrey, FontWeight.w400,
                      1.4)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: _filledBtn('Delete Session', AppColors.errorDestructive,
                    () => Navigator.pop(c, true)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: _outlineBtn('Cancel', null, () => Navigator.pop(c, false)),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true && mounted) {
      _toast('Session deleted', SnackbarType.error);
      Navigator.of(context).maybePop();
    }
  }

  void _showMore() {
    final items = <(IconData, String, VoidCallback)>[
      (Icons.copy_outlined, 'Duplicate Session',
          () => _toast('Session duplicated as a new draft', SnackbarType.success)),
      (Icons.ios_share_outlined, 'Share Session',
          () => _toast('Share link copied', SnackbarType.info)),
      (Icons.picture_as_pdf_outlined, 'Export as PDF',
          () => _toast('Export started', SnackbarType.info)),
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
                  leading: Icon(i.$1, color: color),
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
                    duration: const Duration(milliseconds: 280),
                    child: _isDraft
                        ? KeyedSubtree(
                            key: const ValueKey('draft'), child: _buildDraft())
                        : KeyedSubtree(
                            key: const ValueKey('completed'),
                            child: _buildCompleted()),
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
                _circleBtn(Icons.chevron_left,
                    () => Navigator.of(context).maybePop()),
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
      color: AppColors.cardsCarbon.withOpacity(0.85),
      shape: const CircleBorder(side: BorderSide(color: Colors.white12)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.primaryTextOffWhite, size: 22),
        ),
      ),
    );
  }

  // ── Shared header ─────────────────────────────────────────────────────────

  Widget _buildHeader() {
    final s = widget.session;
    final badge = _isDraft
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: AppColors.primaryForestGreen.withOpacity(0.7)),
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
            child: Text('COMPLETED',
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
                color: s.dogColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryForestGreen),
              ),
              child: Center(
                child: Text(s.dogInitial,
                    style: _ts(16, s.dogColor, FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(s.dogName,
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
            const Icon(Icons.calendar_today_outlined,
                size: 14, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 6),
            Flexible(
              child: Text('${_fmtDate(_date)} · ${_fmtTime(_start)}',
                  style: _ts(14, AppColors.secondaryTextStoneGrey)),
            ),
          ],
        ),
      ],
    );
  }

  // ── Draft state ───────────────────────────────────────────────────────────

  Widget _buildDraft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _primaryBtn('Complete Session', Icons.check_circle_outline, _complete),
        const SizedBox(height: 10),
        _outlineBtn('Save Draft', Icons.save_outlined, _saveDraft),
        const SizedBox(height: 20),
        _card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _detailRow(Icons.edit_outlined, 'Title', _title, onTap: () async {
                final v = await _promptText('Session title', 'Title', _title);
                if (v != null && v.isNotEmpty) setState(() => _title = v);
              }),
              _detailRow(Icons.calendar_today_outlined, 'Date', _fmtDate(_date),
                  chevron: true, onTap: _pickDate),
              _detailRow(Icons.schedule, 'Start Time', _fmtTime(_start),
                  chevron: true, onTap: () => _pickTime(isStart: true)),
              _detailRow(Icons.update, 'Finish Time',
                  _finish == null ? 'Not set' : _fmtTime(_finish!),
                  chevron: true, onTap: () => _pickTime(isStart: false)),
              _detailRow(Icons.timer_outlined, 'Duration', _duration),
              _detailRow(Icons.place_outlined, 'Location', _location,
                  chevron: true, onTap: () async {
                final v = await _pickOption(
                    'Location', _locationOptions, _location);
                if (v != null) setState(() => _location = v);
              }),
              _detailRow(Icons.cloud_outlined, 'Weather', _weather),
              _detailRow(Icons.flag_outlined, 'Purpose', _purpose,
                  chevron: true, last: true, onTap: () async {
                final v =
                    await _pickOption('Purpose', _purposeOptions, _purpose);
                if (v != null) setState(() => _purpose = v);
              }),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _label('SESSION NOTES'),
        const SizedBox(height: 8),
        _card(
          child: TextField(
            controller: _notes,
            maxLines: null,
            minLines: 3,
            cursorColor: AppColors.primaryForestGreen,
            style: _ts(14, AppColors.primaryTextOffWhite, FontWeight.w400, 1.5),
            decoration: InputDecoration(
              hintText: 'Add notes about this session',
              hintStyle: _ts(14, AppColors.secondaryTextStoneGrey),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _label('SESSION SECTIONS'),
        const SizedBox(height: 10),
        ..._sections.map(_buildSectionCard),
        _dashedButton('Add Section', Icons.add, () async {
          final v = await _promptText('New section', 'e.g. Tracking');
          if (v != null && v.isNotEmpty) {
            setState(() => _sections.add(_Section(name: v, mins: 10, open: true)));
          }
        }),
        const SizedBox(height: 28),
        Center(
          child: TextButton(
            onPressed: _confirmDelete,
            child: Text('Delete Draft',
                style: _ts(13, const Color(0xFFB05A5A), FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(_Section sec) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _card(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => sec.open = !sec.open),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.drag_indicator,
                        color: AppColors.secondaryTextStoneGrey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(sec.name,
                          overflow: TextOverflow.ellipsis,
                          style: _ts(18, AppColors.primaryTextOffWhite,
                              FontWeight.w600)),
                    ),
                    Text('${sec.mins}m',
                        style: _ts(13, AppColors.secondaryTextStoneGrey)),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: sec.open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(Icons.expand_more,
                          color: AppColors.secondaryTextStoneGrey),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: sec.open
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sec.categories.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sec.categories
                                  .map((c) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundObsidian,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.white12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color:
                                                    AppColors.infoAlpineBlue,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(c,
                                                style: _ts(
                                                    12,
                                                    AppColors
                                                        .primaryTextOffWhite,
                                                    FontWeight.w500)),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          if (sec.categories.isNotEmpty)
                            const SizedBox(height: 12),
                          ...sec.exercises.map((e) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.only(
                                    left: 14, right: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundObsidian,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        child: Text(e,
                                            style: _ts(
                                                14,
                                                AppColors.primaryTextOffWhite,
                                                FontWeight.w500)),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          size: 18,
                                          color: AppColors
                                              .secondaryTextStoneGrey),
                                      onPressed: () => setState(
                                          () => sec.exercises.remove(e)),
                                    ),
                                  ],
                                ),
                              )),
                          _dashedButton('Add Exercise', Icons.add, () async {
                            final v = await _promptText(
                                'Add exercise', 'e.g. Figure of Eight x3');
                            if (v != null && v.isNotEmpty) {
                              setState(() => sec.exercises.add(v));
                            }
                          }, compact: true),
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

  Widget _buildCompleted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _primaryBtn('Edit Session', Icons.edit, _reopen)),
            const SizedBox(width: 12),
            Expanded(
                child:
                    _outlineBtn('More Options', Icons.more_horiz, _showMore)),
          ],
        ),
        const SizedBox(height: 20),
        _card(
          child: Column(
            children: [
              _metaRow('Dog', widget.session.dogName, first: true),
              _metaRow('Location', _location),
              _metaRow('Trainer/Helper', 'Erik Svensson'),
              _metaRow('Total Duration', _duration,
                  valueColor: AppColors.primaryForestGreen, last: true),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _label('SESSION NOTES'),
        const SizedBox(height: 8),
        _card(
          child: Text(_notes.text,
              style: _ts(14, AppColors.primaryTextOffWhite, FontWeight.w400, 1.55)),
        ),
        const SizedBox(height: 24),
        _label('PHASES LOGGED'),
        const SizedBox(height: 10),
        ..._phases.map(_buildPhaseCard),
        const SizedBox(height: 12),
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
        _chipCard('TAGS', _tags, () {
          _editChips('Tags', _tagOptions, _tags, (v) => _tags = v);
        }, square: true),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('RECORD INFO'),
              const SizedBox(height: 10),
              _infoRow('Created', '14 Jun 2026, 21:45'),
              const SizedBox(height: 6),
              _infoRow('Last edited', '15 Jun 2026, 08:12'),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SizedBox(
              width: double.infinity,
              child: _primaryBtn('Edit Session', null, _reopen),
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

  Widget _buildPhaseCard(_Phase p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _card(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => p.open = !p.open),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(p.icon, color: p.color, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(p.name,
                          style: _ts(18, AppColors.primaryTextOffWhite,
                              FontWeight.w600)),
                    ),
                    AnimatedRotation(
                      turns: p.open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(Icons.expand_more,
                          color: AppColors.secondaryTextStoneGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.chips.map(_miniTag).toList(),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: p.open
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            children: p.details
                                .map((d) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: p.color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(d,
                                                style: _ts(
                                                    14,
                                                    AppColors
                                                        .primaryTextOffWhite)),
                                          ),
                                        ],
                                      ),
                                    ))
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
    final total = _mediaUrls.length + 2; // two extra items beyond the preview
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
                  style: _ts(13, AppColors.primaryForestGreen, FontWeight.w600)),
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
                      isVideo ? 'Video viewer coming soon' : 'Photo viewer coming soon',
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
            Icon(icon, size: 20, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 12),
            Text(label, style: _ts(14, AppColors.secondaryTextStoneGrey)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: _ts(14, AppColors.primaryTextOffWhite, FontWeight.w500)),
            ),
            if (chevron) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right,
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
          Text(label, style: _ts(13, AppColors.secondaryTextStoneGrey, FontWeight.w500)),
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

  Widget _infoRow(String l, String v) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: _ts(12, AppColors.secondaryTextStoneGrey)),
          Text(v, style: _ts(12, AppColors.primaryTextOffWhite)),
        ],
      );

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
                Icon(icon, size: 18, color: AppColors.primaryTextOffWhite),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: _ts(14, AppColors.primaryTextOffWhite,
                        FontWeight.w600)),
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
                Icon(icon, size: 18, color: AppColors.primaryTextOffWhite),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: _ts(14, AppColors.primaryTextOffWhite,
                        FontWeight.w600)),
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
              Icon(icon, size: 18, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 6),
              Text(label,
                  style: _ts(13, AppColors.secondaryTextStoneGrey,
                      FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
