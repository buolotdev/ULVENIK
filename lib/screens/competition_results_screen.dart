import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'sport_pack_overview_screen.dart';

class _ResultSectionEntry {
  final TextEditingController nameCtrl;
  final TextEditingController scoreCtrl;
  final TextEditingController maxCtrl;
  final TextEditingController notesCtrl;

  _ResultSectionEntry({
    required String name,
    required String score,
    required String max,
    required String notes,
  })  : nameCtrl = TextEditingController(text: name),
        scoreCtrl = TextEditingController(text: score),
        maxCtrl = TextEditingController(text: max),
        notesCtrl = TextEditingController(text: notes);

  double get parsedScore => double.tryParse(scoreCtrl.text.trim()) ?? 0.0;
  double get parsedMax => double.tryParse(maxCtrl.text.trim()) ?? 0.0;

  void dispose() {
    nameCtrl.dispose();
    scoreCtrl.dispose();
    maxCtrl.dispose();
    notesCtrl.dispose();
  }
}

class _JudgeFeedbackEntry {
  final TextEditingController judgeNameCtrl;
  final TextEditingController commentsCtrl;

  _JudgeFeedbackEntry({
    required String judgeName,
    required String comments,
  })  : judgeNameCtrl = TextEditingController(text: judgeName),
        commentsCtrl = TextEditingController(text: comments);

  void dispose() {
    judgeNameCtrl.dispose();
    commentsCtrl.dispose();
  }
}

class _AwardChipModel {
  final String label;
  final bool hasGoldDot;
  final IconData icon;

  const _AwardChipModel({
    required this.label,
    required this.icon,
    this.hasGoldDot = false,
  });
}

class _AttachmentThumbModel {
  final String badge;
  final String caption;
  final String? imageAsset;
  final String fullFileName;

  const _AttachmentThumbModel({
    required this.badge,
    required this.caption,
    required this.fullFileName,
    this.imageAsset,
  });
}

class CompetitionResultsScreen extends StatefulWidget {
  const CompetitionResultsScreen({super.key});

  @override
  State<CompetitionResultsScreen> createState() =>
      _CompetitionResultsScreenState();
}

class _CompetitionResultsScreenState extends State<CompetitionResultsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _card = AppColors.cardsCarbon; // #1A1F22
  static const Color _subCard = Color(0xFF161B1E);
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _greenAccent = Color(0xFF3E8E72);
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _gold = AppColors.favouriteGold; // #B8920A
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stone = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _muted = Color(0xFF6E7772);
  static const Color _border = AppColors.cardBorder;
  static const Color _underline = Color(0x2EFFFFFF);

  late final AnimationController _animController;
  late final Animation<double> _curvedAnim;

  String _competitionTitle = 'Regional Agility Trial 2026';
  String _competitionDate = '29 July 2026';

  String _selectedOutcome = 'Passed';
  String _qualificationStatus = 'Qualified';

  final TextEditingController _overallRankCtrl =
      TextEditingController(text: '1st');
  final TextEditingController _classRankCtrl =
      TextEditingController(text: '1st / 18');
  final TextEditingController _teamRankCtrl = TextEditingController();

  final TextEditingController _totalScoreCtrl =
      TextEditingController(text: '92.40');
  final TextEditingController _maxScoreCtrl =
      TextEditingController(text: '100.00');
  bool _personalBestAuto = true;
  bool _syncingSectionScores = false;

  late final List<_ResultSectionEntry> _sections;
  int? _selectedSectionBarIndex = 0;

  final TextEditingController _faultPointsCtrl =
      TextEditingController(text: '0');
  final TextEditingController _penaltyPointsCtrl =
      TextEditingController(text: '0');
  final TextEditingController _timeFaultsCtrl =
      TextEditingController(text: '0.00 sec');
  final TextEditingController _eliminationsCtrl = TextEditingController();

  late final List<_AwardChipModel> _awards;
  late final List<_JudgeFeedbackEntry> _judges;
  final TextEditingController _notesCtrl = TextEditingController(
    text: '',
  );

  late final List<_AttachmentThumbModel> _attachments;

  static const List<String> _outcomeOptions = [
    'Passed',
    'Failed',
    'Withdrawn',
    'Eliminated',
    'Disqualified',
    'Retired',
  ];

  static const List<String> _qualificationOptions = [
    'Qualified',
    'Not\nQualified',
    'Pending',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _curvedAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _sections = [
      _ResultSectionEntry(
        name: 'Agility Round 1',
        score: '47.2',
        max: '50',
        notes: '',
      ),
      _ResultSectionEntry(
        name: 'Agility Round 2',
        score: '45.2',
        max: '50',
        notes: '',
      ),
    ];
    for (final s in _sections) {
      _attachSectionListeners(s);
    }

    _awards = [
      const _AwardChipModel(
        label: 'First Place',
        icon: Icons.emoji_events_outlined,
        hasGoldDot: true,
      ),
      const _AwardChipModel(
        label: 'Qualification Certificate',
        icon: Icons.verified_outlined,
      ),
      const _AwardChipModel(
        label: 'High in Trial',
        icon: Icons.star_border_rounded,
      ),
    ];

    _judges = [
      _JudgeFeedbackEntry(
        judgeName: 'H. Andersen',
        comments: '',
      ),
    ];

    _attachments = [
      const _AttachmentThumbModel(
        badge: 'PDF',
        caption: 'Scores',
        fullFileName: 'Official_Agility_ScoreSheet_2026.pdf',
      ),
      const _AttachmentThumbModel(
        badge: 'PDF',
        caption: 'Cert.',
        fullFileName: 'Regional_Qualification_Certificate.pdf',
      ),
      const _AttachmentThumbModel(
        badge: 'IMG',
        caption: 'Podium',
        fullFileName: 'Regional_Agility_Podium_Finish.jpg',
        imageAsset: 'assets/images/calendar_dog_thumb.jpg',
      ),
    ];

    _overallRankCtrl.addListener(() => setState(() {}));
    _totalScoreCtrl.addListener(() => setState(() {}));
    _maxScoreCtrl.addListener(() => setState(() {}));
    _notesCtrl.addListener(() => setState(() {}));
  }

  void _attachSectionListeners(_ResultSectionEntry entry) {
    void recalc() {
      if (_syncingSectionScores) return;
      _syncingSectionScores = true;
      double sumScore = 0;
      double sumMax = 0;
      for (final item in _sections) {
        sumScore += item.parsedScore;
        sumMax += item.parsedMax;
      }
      if (sumMax > 0) {
        _totalScoreCtrl.text = sumScore.toStringAsFixed(2);
        _maxScoreCtrl.text = sumMax.toStringAsFixed(2);
      }
      _syncingSectionScores = false;
      if (mounted) setState(() {});
    }

    entry.scoreCtrl.addListener(recalc);
    entry.maxCtrl.addListener(recalc);
    entry.nameCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _overallRankCtrl.dispose();
    _classRankCtrl.dispose();
    _teamRankCtrl.dispose();
    _totalScoreCtrl.dispose();
    _maxScoreCtrl.dispose();
    _faultPointsCtrl.dispose();
    _penaltyPointsCtrl.dispose();
    _timeFaultsCtrl.dispose();
    _eliminationsCtrl.dispose();
    _notesCtrl.dispose();
    for (final s in _sections) {
      s.dispose();
    }
    for (final j in _judges) {
      j.dispose();
    }
    super.dispose();
  }

  double get _totalScore =>
      double.tryParse(_totalScoreCtrl.text.trim()) ?? 0.0;
  double get _maxScore => double.tryParse(_maxScoreCtrl.text.trim()) ?? 100.0;

  double get _percentage =>
      _maxScore > 0 ? ((_totalScore / _maxScore) * 100.0).clamp(0.0, 999.0) : 0;

  String get _heroPlaceLabel {
    final raw = _overallRankCtrl.text.trim();
    if (raw.isEmpty) return _selectedOutcome;
    if (raw.toLowerCase().contains('place')) return raw;
    return '$raw Place';
  }

  String get _heroQualificationBadge =>
      _qualificationStatus.replaceAll('\n', ' ').toUpperCase();

  void _saveResults() {
    final store = SportPackStore.instance;
    store.recordCompetitionResult(
      competitionId: 'regional_agility_2026',
      totalScore: _totalScore.round(),
      maxScore: _maxScore.round(),
      phaseA: _sections.isNotEmpty ? _sections[0].parsedScore.round() : null,
      phaseB: _sections.length > 1 ? _sections[1].parsedScore.round() : null,
      placement: _heroPlaceLabel,
      qualificationResult:
          '${_qualificationStatus.replaceAll('\n', ' ')} · ${_percentage.toStringAsFixed(1)}%',
      notes: _notesCtrl.text.trim(),
      addQualificationBadge: _qualificationStatus == 'Qualified',
    );

    AppSnackbar.show(
      context,
      title: 'Competition Results Saved',
      message:
          '$_competitionTitle (${_totalScore.toStringAsFixed(1)} pts · $_heroPlaceLabel) saved.',
      type: SnackbarType.success,
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              color: _bg,
              border: Border(top: BorderSide(color: _border, width: 1)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest.withValues(alpha: 0.85),
                  foregroundColor: _offWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Results',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopHeader(),
            Container(height: 1, color: _border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 34),
                child: AnimatedBuilder(
                  animation: _curvedAnim,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroResultCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('OVERALL RESULT'),
                        const SizedBox(height: 10),
                        _buildOverallResultCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('SCORES'),
                        const SizedBox(height: 10),
                        _buildScoresCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('SECTION SCORES'),
                        const SizedBox(height: 10),
                        _buildSectionScoresCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('FAULTS & PENALTIES'),
                        const SizedBox(height: 10),
                        _buildFaultsPenaltiesCard(),
                        const SizedBox(height: 7),
                        const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            'All fields optional.',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 11.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSectionHeader('AWARDS'),
                        const SizedBox(height: 10),
                        _buildAwardsCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('JUDGE FEEDBACK'),
                        const SizedBox(height: 10),
                        _buildJudgeFeedbackCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('NOTES'),
                        const SizedBox(height: 10),
                        _buildNotesCard(),
                        const SizedBox(height: 22),
                        _buildSectionHeader('ATTACHMENTS'),
                        const SizedBox(height: 10),
                        _buildAttachmentsCard(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _stone,
              size: 28,
            ),
            splashRadius: 22,
            tooltip: 'Back',
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Competition Results',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _saveResults,
            child: const Text(
              'Save',
              style: TextStyle(
                color: _greenAccent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          color: _stone,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.15,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildHeroResultCard() {
    final animScore = _totalScore * _curvedAnim.value;
    final isQualified = _qualificationStatus == 'Qualified';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _openTrialSwitcherSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _competitionTitle,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const UlvenikIcon(UlvenikIcons.calendar,
                  color: _stone,
                  size: 13.5,
                ),
                const SizedBox(width: 6),
                Text(
                  _competitionDate,
                  style: const TextStyle(
                    color: _stone,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Center(
              child: RichText(
                text: TextSpan(
                  text: animScore.toStringAsFixed(1),
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.0,
                    fontFamily: 'Inter',
                  ),
                  children: const [
                    TextSpan(
                      text: ' pts',
                      style: TextStyle(
                        color: _stone,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _heroPlaceLabel,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isQualified
                      ? _forest.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isQualified ? _greenAccent : _border,
                  ),
                ),
                child: Text(
                  _heroQualificationBadge,
                  style: TextStyle(
                    color: isQualified ? _greenAccent : _stone,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallResultCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Competition Outcome',
            style: TextStyle(
              color: _stone,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _outcomeOptions.map((opt) {
              final active = _selectedOutcome == opt;
              return GestureDetector(
                onTap: () => setState(() => _selectedOutcome = opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? _forest.withValues(alpha: 0.22)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? _greenAccent : _border,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: active ? const Color(0xFF5BAE8E) : _stone,
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: _border),
          const SizedBox(height: 16),
          const Text(
            'Qualification Status',
            style: TextStyle(
              color: _stone,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_qualificationOptions.length, (i) {
              final opt = _qualificationOptions[i];
              final active = _qualificationStatus == opt;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i == _qualificationOptions.length - 1 ? 0 : 8,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _qualificationStatus = opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active
                            ? _forest.withValues(alpha: 0.22)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: active ? _greenAccent : _border,
                        ),
                      ),
                      child: Text(
                        opt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: active ? const Color(0xFF5BAE8E) : _stone,
                          fontSize: 12.8,
                          height: 1.2,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: _border),
          const SizedBox(height: 16),
          const Text(
            'Placing & Ranks',
            style: TextStyle(
              color: _stone,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCenteredRankField(
                  label: 'OVERALL',
                  controller: _overallRankCtrl,
                  hint: '1st',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCenteredRankField(
                  label: 'CLASS',
                  controller: _classRankCtrl,
                  hint: '1st / 18',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCenteredRankField(
                  label: 'TEAM',
                  controller: _teamRankCtrl,
                  hint: 'Optional',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredRankField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(
              color: _muted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: _underline),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: _forest, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoresCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreInputRow(
            icon: Icons.tag_rounded,
            label: 'Total Score',
            controller: _totalScoreCtrl,
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          _buildScoreInputRow(
            icon: Icons.tag_rounded,
            label: 'Maximum Score',
            controller: _maxScoreCtrl,
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.tag_rounded, color: _muted, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Percentage',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: _underline)),
                  ),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Calculated automatically from Total ÷ Maximum Score',
            style: TextStyle(
              color: _muted,
              fontSize: 11.5,
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined,
                color: _greenAccent,
                size: 19,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Best',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Arya\'s personal best will be updated automatically.',
                      style: TextStyle(
                        color: _greenAccent,
                        fontSize: 12,
                        height: 1.35,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _personalBestAuto,
                activeThumbColor: _offWhite,
                activeTrackColor: _greenAccent,
                inactiveThumbColor: _stone,
                inactiveTrackColor: _bg,
                onChanged: (v) => setState(() => _personalBestAuto = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreInputRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return Row(
      children: [
        UlvenikIcon.fromMaterial(icon, color: _muted, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: _offWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: const TextStyle(
                color: _muted,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _underline),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _forest, width: 1.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionScoresCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add individual section scores for each part of the competition. Section names are fully customisable.',
            style: TextStyle(
              color: _stone,
              fontSize: 12.5,
              height: 1.42,
              fontFamily: 'Inter',
            ),
          ),
          if (_sections.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildInteractiveSectionBreakdownBars(),
          ],
          const SizedBox(height: 14),
          ...List.generate(_sections.length, (i) {
            final sec = _sections[i];
            final isFocused = _selectedSectionBarIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                decoration: BoxDecoration(
                  color: _subCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isFocused
                        ? _mint.withValues(alpha: 0.45)
                        : _border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SECTION NAME',
                          style: TextStyle(
                            color: _stone,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.9,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_sections.length <= 1) {
                              AppSnackbar.show(
                                context,
                                title: 'Minimum 1 Section',
                                message:
                                    'Keep at least one section or edit its values directly.',
                                type: SnackbarType.info,
                              );
                              return;
                            }
                            setState(() {
                              final removed = _sections.removeAt(i);
                              removed.dispose();
                              _selectedSectionBarIndex = 0;
                            });
                            _animController.forward(from: 0.3);
                          },
                          child: const Icon(Icons.close_rounded,
                            color: _muted,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: sec.nameCtrl,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _underline),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _forest, width: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSubField(
                            label: 'SCORE',
                            controller: sec.scoreCtrl,
                            numeric: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSubField(
                            label: 'MAX',
                            controller: sec.maxCtrl,
                            numeric: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildSubField(
                      label: 'NOTES',
                      controller: sec.notesCtrl,
                      numeric: false,
                    ),
                  ],
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: () {
              final nextNum = _sections.length + 1;
              final added = _ResultSectionEntry(
                name: 'Jumping Round $nextNum',
                score: '46.0',
                max: '50',
                notes: '',
              );
              _attachSectionListeners(added);
              setState(() {
                _sections.add(added);
                _selectedSectionBarIndex = _sections.length - 1;
              });
              _animController.forward(from: 0.25);
            },
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: _ResultsDashedRectPainter(
                color: Colors.white.withValues(alpha: 0.14),
                radius: 12,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UlvenikIcon(UlvenikIcons.add, color: _greenAccent, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Add Section Score',
                      style: TextStyle(
                        color: _greenAccent,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveSectionBreakdownBars() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SECTION BREAKDOWN (TAP BAR TO FOCUS)',
                style: TextStyle(
                  color: _stone,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.9,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                'Live %',
                style: TextStyle(
                  color: _mint,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(_sections.length, (i) {
            final sec = _sections[i];
            final maxV = sec.parsedMax <= 0 ? 50.0 : sec.parsedMax;
            final ratio =
                (sec.parsedScore / maxV).clamp(0.0, 1.0) * _curvedAnim.value;
            final pct = ((sec.parsedScore / maxV) * 100).clamp(0.0, 100.0);
            final selected = _selectedSectionBarIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedSectionBarIndex = i),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: i == _sections.length - 1 ? 0 : 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sec.nameCtrl.text.trim().isEmpty
                                ? 'Section ${i + 1}'
                                : sec.nameCtrl.text.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected ? _offWhite : _stone,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Text(
                          '${sec.parsedScore.toStringAsFixed(1)}/${maxV.toStringAsFixed(0)} (${pct.toStringAsFixed(0)}%)',
                          style: TextStyle(
                            color: selected ? _mint : _offWhite,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6.5,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          selected ? _mint : _alpineBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSubField({
    required String label,
    required TextEditingController controller,
    required bool numeric,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _stone,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.85,
            fontFamily: 'Inter',
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: TextStyle(
            color: _offWhite,
            fontSize: numeric ? 15 : 13.5,
            fontWeight: numeric ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'Inter',
          ),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _underline),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _forest, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaultsPenaltiesCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _buildFaultRow(label: 'Fault Points', controller: _faultPointsCtrl),
          const SizedBox(height: 12),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          _buildFaultRow(
            label: 'Penalty Points',
            controller: _penaltyPointsCtrl,
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          _buildFaultRow(
            icon: Icons.history_toggle_off_rounded,
            label: 'Time Faults',
            controller: _timeFaultsCtrl,
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          _buildFaultRow(
            icon: Icons.close_rounded,
            label: 'Eliminations',
            controller: _eliminationsCtrl,
            hint: 'Optional',
          ),
        ],
      ),
    );
  }

  Widget _buildFaultRow({
    IconData? icon,
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          UlvenikIcon.fromMaterial(icon, color: _muted, size: 15.5),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: const TextStyle(
                color: _muted,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _underline),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _forest, width: 1.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAwardsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: List.generate(_awards.length, (i) {
              final aw = _awards[i];
              return Container(
                padding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
                decoration: BoxDecoration(
                  color: _subCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (aw.hasGoldDot) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: _gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                    ],
                    UlvenikIcon.fromMaterial(aw.icon, color: _stone, size: 15),
                    const SizedBox(width: 7),
                    Text(
                      aw.label,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 12.8,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _awards.removeAt(i)),
                      child: const Icon(Icons.close_rounded,
                        color: _muted,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openAddAwardSheet,
            behavior: HitTestBehavior.opaque,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.add, color: _greenAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  'Add Award',
                  style: TextStyle(
                    color: _greenAccent,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
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

  Widget _buildJudgeFeedbackCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(_judges.length, (i) {
            final j = _judges[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i == _judges.length - 1 ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'JUDGE NAME',
                        style: TextStyle(
                          color: _stone,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.9,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (_judges.length > 1)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final removed = _judges.removeAt(i);
                              removed.dispose();
                            });
                          },
                          child: const Icon(Icons.close_rounded,
                            color: _muted,
                            size: 16,
                          ),
                        )
                      else
                        const Icon(Icons.close_rounded,
                          color: _muted,
                          size: 16,
                        ),
                    ],
                  ),
                  TextField(
                    controller: j.judgeNameCtrl,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _underline),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _forest, width: 1.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'COMMENTS',
                    style: TextStyle(
                      color: _stone,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.9,
                      fontFamily: 'Inter',
                    ),
                  ),
                  TextField(
                    controller: j.commentsCtrl,
                    maxLines: 3,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 13.8,
                      height: 1.42,
                      fontFamily: 'Inter',
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _underline),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _forest, width: 1.4),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
          Container(height: 1, color: _border),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _judges.add(
                  _JudgeFeedbackEntry(
                    judgeName: 'M. Lindqvist (Ring 2)',
                    comments:
                        'Confident tunnel exits and balanced jump collection.',
                  ),
                );
              });
            },
            behavior: HitTestBehavior.opaque,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UlvenikIcon(UlvenikIcons.add, color: _greenAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  'Add Judge',
                  style: TextStyle(
                    color: _greenAccent,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
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

  Widget _buildNotesCard() {
    final len = _notesCtrl.text.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _notesCtrl,
            maxLines: 4,
            maxLength: 2000,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) =>
                null,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13.8,
              height: 1.46,
              fontFamily: 'Inter',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 12),
            ),
          ),
          Container(height: 1, color: _underline),
          const SizedBox(height: 8),
          Text(
            '$len / 2000',
            style: const TextStyle(
              color: _muted,
              fontSize: 11.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttachmentRow(
            icon: Icons.insert_drive_file_outlined,
            title: 'Score Sheets',
            subtitle: 'PDF, DOC',
            onTap: () => _addSampleAttachment(
              const _AttachmentThumbModel(
                badge: 'PDF',
                caption: 'Round 2',
                fullFileName: 'Round2_Judge_Scorecard.pdf',
              ),
            ),
          ),
          Container(height: 1, color: _border),
          _buildAttachmentRow(
            icon: Icons.description_outlined,
            title: 'Certificates',
            subtitle: 'PDF, JPG',
            onTap: () => _addSampleAttachment(
              const _AttachmentThumbModel(
                badge: 'PDF',
                caption: 'HIT Cert',
                fullFileName: 'High_In_Trial_Certificate.pdf',
              ),
            ),
          ),
          Container(height: 1, color: _border),
          _buildAttachmentRow(
            icon: Icons.photo_camera_outlined,
            title: 'Photos',
            subtitle: 'JPG, PNG, HEIC',
            onTap: () => _addSampleAttachment(
              const _AttachmentThumbModel(
                badge: 'IMG',
                caption: 'Finish',
                fullFileName: 'Clean_AFrame_Contact.jpg',
                imageAsset: 'assets/images/photo_viewer_1.jpg',
              ),
            ),
          ),
          Container(height: 1, color: _border),
          _buildAttachmentRow(
            icon: Icons.videocam_outlined,
            title: 'Videos',
            subtitle: 'MP4, MOV',
            onTap: () => _addSampleAttachment(
              const _AttachmentThumbModel(
                badge: 'MP4',
                caption: 'Run 1',
                fullFileName: 'Agility_Round1_FullRun.mp4',
              ),
            ),
          ),
          if (_attachments.isNotEmpty) ...[
            Container(height: 1, color: _border),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_attachments.length, (i) {
                  final att = _attachments[i];
                  return GestureDetector(
                    onTap: () {
                      AppSnackbar.show(
                        context,
                        title: 'Previewing Attachment',
                        message: att.fullFileName,
                        type: SnackbarType.info,
                      );
                    },
                    onLongPress: () =>
                        setState(() => _attachments.removeAt(i)),
                    child: att.imageAsset != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 58,
                              height: 58,
                              child: Image.asset(
                                att.imageAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: _forest.withValues(alpha: 0.35),
                                  child: const Icon(Icons.image_outlined,
                                    color: _offWhite,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: _subCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _border),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  att.badge,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  att.caption,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _stone,
                                    fontSize: 10,
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
        ],
      ),
    );
  }

  Widget _buildAttachmentRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: _stone, size: 19),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14.2,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details, color: _stone, size: 19),
          ],
        ),
      ),
    );
  }

  void _addSampleAttachment(_AttachmentThumbModel item) {
    if (_attachments.any((a) => a.fullFileName == item.fullFileName)) {
      AppSnackbar.show(
        context,
        title: 'Already Attached',
        message: '${item.fullFileName} is already in your attachments tray.',
        type: SnackbarType.info,
      );
      return;
    }
    setState(() => _attachments.add(item));
    AppSnackbar.show(
      context,
      title: 'Attachment Added',
      message: '${item.fullFileName} attached (long-press tile to remove).',
      type: SnackbarType.success,
    );
  }

  void _openAddAwardSheet() {
    final customCtrl = TextEditingController();
    const presets = [
      'Clean Run Ribbon',
      'Fastest Course Time',
      'Judge\'s Choice',
      'Best Contact Execution',
    ];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _stone.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add Competition Award',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presets.map((p) {
                      return ActionChip(
                        backgroundColor: _bg,
                        side: const BorderSide(color: _border),
                        label: Text(
                          p,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 12.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _awards.add(
                              _AwardChipModel(
                                label: p,
                                icon: Icons.emoji_events_outlined,
                              ),
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: customCtrl,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Or type custom award / title...',
                      hintStyle: const TextStyle(color: _muted, fontSize: 13.5),
                      filled: true,
                      fillColor: _bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final txt = customCtrl.text.trim();
                        if (txt.isNotEmpty) {
                          setState(() {
                            _awards.add(
                              _AwardChipModel(
                                label: txt,
                                icon: Icons.star_border_rounded,
                              ),
                            );
                          });
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Award'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openTrialSwitcherSheet() {
    const trials = [
      ('Regional Agility Trial 2026', '29 July 2026', '92.40', '100.00', '1st'),
      ('Southern Regional SV Trial', '15 Sep 2026', '282.00', '300.00', '1st'),
      ('IGP National 2026', '22 Jun 2026', '284.00', '300.00', '2nd'),
    ];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Switch Trial Result Sheet',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                ...trials.map((t) {
                  final sel = t.$1 == _competitionTitle;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _competitionTitle = t.$1;
                          _competitionDate = t.$2;
                          _totalScoreCtrl.text = t.$3;
                          _maxScoreCtrl.text = t.$4;
                          _overallRankCtrl.text = t.$5;
                        });
                        _animController.forward(from: 0.0);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: sel ? _forest.withValues(alpha: 0.2) : _bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sel ? _forest : _border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.$1,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${t.$2}  ·  ${t.$3}/${t.$4} pts',
                                    style: const TextStyle(
                                      color: _stone,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (sel)
                              const UlvenikIcon(UlvenikIcons.completed,
                                color: _mint,
                                size: 19,
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
}

class _ResultsDashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _ResultsDashedRectPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const double dashWidth = 4.5;
    const double dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ResultsDashedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
