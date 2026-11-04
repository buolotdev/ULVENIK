import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'sport_pack_overview_screen.dart';

class _ResultAttachmentItem {
  final String name;
  final String sizeLabel;

  const _ResultAttachmentItem({
    required this.name,
    required this.sizeLabel,
  });
}

class RecordCompetitionResultScreen extends StatefulWidget {
  final SportCompetitionModel? competition;

  const RecordCompetitionResultScreen({
    super.key,
    this.competition,
  });

  @override
  State<RecordCompetitionResultScreen> createState() =>
      _RecordCompetitionResultScreenState();
}

class _RecordCompetitionResultScreenState
    extends State<RecordCompetitionResultScreen>
    with SingleTickerProviderStateMixin {
  final SportPackStore _store = SportPackStore.instance;
  late final AnimationController _animController;
  late final Animation<double> _chartAnim;

  late String _selectedCompetitionId;
  late String _selectedCompetitionTitle;
  late String _selectedSportTag;
  late String _selectedDateLabel;

  String _resultStatus = 'Completed';
  late final TextEditingController _scoreController;
  late final TextEditingController _placementController;
  late final TextEditingController _judgeCommentsController;
  late final TextEditingController _personalNotesController;

  double _phaseA = 96.0;
  double _phaseB = 95.5;
  double _phaseC = 96.0;
  int _selectedPhaseIndex = 0;

  late List<String> _qualifications;
  late List<String> _awards;
  late List<_ResultAttachmentItem> _attachments;

  @override
  void initState() {
    super.initState();
    final comp = widget.competition;
    _selectedCompetitionId = comp?.id ?? 'essex_trial';
    _selectedCompetitionTitle = comp?.title ?? 'Essex Working Dog Trial';
    _selectedSportTag = comp?.sportTag ?? 'IGP';
    _selectedDateLabel = (comp == null || comp.id == 'essex_trial')
        ? '18 September 2026'
        : comp.date;

    if (comp?.phaseAScore != null) _phaseA = comp!.phaseAScore!.toDouble();
    if (comp?.phaseBScore != null) _phaseB = comp!.phaseBScore!.toDouble();
    if (comp?.phaseCScore != null) _phaseC = comp!.phaseCScore!.toDouble();

    _scoreController = TextEditingController(
      text: comp?.totalScore != null
          ? '${comp!.totalScore} / ${comp.maxScore ?? 300}'
          : '287.5 / 300',
    );
    _placementController = TextEditingController(
      text: comp?.placement ?? '2nd',
    );
    _judgeCommentsController = TextEditingController();
    _personalNotesController = TextEditingController();

    _qualifications = ['IGP 1'];
    _awards = [];
    _attachments = [
      const _ResultAttachmentItem(
        name: 'Score Sheet.pdf',
        sizeLabel: '28 KB',
      ),
    ];

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    )..forward();
    _chartAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _scoreController.dispose();
    _placementController.dispose();
    _judgeCommentsController.dispose();
    _personalNotesController.dispose();
    super.dispose();
  }

  double get _computedTotal => _phaseA + _phaseB + _phaseC;

  String _formatScoreNumber(double v) {
    if ((v - v.roundToDouble()).abs() < 0.05) {
      return '${v.round()}';
    }
    return v.toStringAsFixed(1);
  }

  void _syncScoreFromPhases() {
    final total = _computedTotal;
    _scoreController.text = '${_formatScoreNumber(total)} / 300';
  }

  void _openCompetitionPicker() {
    final choices = _store.competitions;
    if (choices.isEmpty) return;

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
                  'SELECT COMPETITION',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                ...choices.map((c) {
                  final active = c.id == _selectedCompetitionId;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      c.title,
                      style: TextStyle(
                        color: active
                            ? const Color(0xFF95D3BB)
                            : AppColors.primaryTextOffWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    subtitle: Text(
                      '${c.sportTag} · ${c.date} · ${c.location}',
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: active
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF95D3BB),
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCompetitionId = c.id;
                        _selectedCompetitionTitle = c.title;
                        _selectedSportTag = c.sportTag;
                        _selectedDateLabel = c.date;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openStatusPicker() {
    const statuses = [
      'Completed',
      'Qualified',
      'Did Not Qualify',
      'Withdrawn',
    ];
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
                const SizedBox(height: 14),
                const Text(
                  'SELECT RESULT STATUS',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                ...statuses.map((st) {
                  final active = st == _resultStatus;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      st,
                      style: TextStyle(
                        color: active
                            ? const Color(0xFF95D3BB)
                            : AppColors.primaryTextOffWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    trailing: active
                        ? const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF95D3BB),
                          )
                        : null,
                    onTap: () {
                      setState(() => _resultStatus = st);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddChipSheet({required bool isAward}) {
    final ctrl = TextEditingController();
    final presets = isAward
        ? [
            'Best Protection Work',
            'High in Trial',
            'Best Tracking',
            'Judge\'s Choice',
          ]
        : ['IGP 2', 'IGP 3', 'BH-VT', 'FPr 2'];

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
                isAward ? 'ADD AWARD' : 'ADD QUALIFICATION',
                style: const TextStyle(
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
                children: presets.map((p) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isAward) {
                          if (!_awards.contains(p)) _awards.add(p);
                        } else {
                          if (!_qualifications.contains(p)) {
                            _qualifications.add(p);
                          }
                        }
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        '+ $p',
                        style: const TextStyle(
                          color: Color(0xFF95D3BB),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: isAward
                      ? 'Or enter custom award...'
                      : 'Or enter custom qualification...',
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
                    final v = ctrl.text.trim();
                    if (v.isNotEmpty) {
                      setState(() {
                        if (isAward) {
                          _awards.add(v);
                        } else {
                          _qualifications.add(v);
                        }
                      });
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    isAward ? 'Add Award' : 'Add Qualification',
                    style: const TextStyle(
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

  void _handleAddAttachment() {
    const sampleDocs = [
      _ResultAttachmentItem(name: 'Judge_Critique_Card.pdf', sizeLabel: '64 KB'),
      _ResultAttachmentItem(name: 'Podium_Photo.jpg', sizeLabel: '1.4 MB'),
      _ResultAttachmentItem(name: 'Tracking_Sketch.pdf', sizeLabel: '42 KB'),
    ];
    final nextDoc = sampleDocs[_attachments.length % sampleDocs.length];
    setState(() {
      _attachments.add(nextDoc);
    });
    AppSnackbar.show(
      context,
      title: 'Attachment Added',
      message: '${nextDoc.name} (${nextDoc.sizeLabel}) attached.',
      type: SnackbarType.info,
    );
  }

  void _handleSaveResult() {
    final rawScoreText = _scoreController.text.trim();
    if (rawScoreText.isEmpty && _resultStatus != 'Withdrawn') {
      AppSnackbar.show(
        context,
        title: 'Score Required',
        message: 'Enter a score or mark the entry as Withdrawn.',
        type: SnackbarType.warning,
      );
      return;
    }

    int parsedTotal = _computedTotal.round();
    int parsedMax = 300;
    if (rawScoreText.contains('/')) {
      final parts = rawScoreText.split('/');
      final left = double.tryParse(parts[0].trim());
      final right = int.tryParse(parts[1].trim());
      if (left != null) parsedTotal = left.round();
      if (right != null && right > 0) parsedMax = right;
    } else {
      final single = double.tryParse(rawScoreText);
      if (single != null) parsedTotal = single.round();
    }

        final placement = _placementController.text.trim().isEmpty
        ? 'Completed'
        : _placementController.text.trim();
    final combinedNotes = [
      if (_judgeCommentsController.text.trim().isNotEmpty)
        _judgeCommentsController.text.trim(),
      if (_personalNotesController.text.trim().isNotEmpty)
        _personalNotesController.text.trim(),
    ].join(' • ');

    final qualSummary = [
      if (_qualifications.isNotEmpty) _qualifications.join(', '),
      if (_awards.isNotEmpty) _awards.join(', '),
    ].join(' • ');

    _store.recordCompetitionResult(
      competitionId: _selectedCompetitionId,
      totalScore: parsedTotal,
      maxScore: parsedMax,
      phaseA: _phaseA.round(),
      phaseB: _phaseB.round(),
      phaseC: _phaseC.round(),
      placement: placement,
      qualificationResult: qualSummary,
      notes: combinedNotes,
      addQualificationBadge:
          _qualifications.isNotEmpty || _awards.isNotEmpty,
    );

    AppSnackbar.show(
      context,
      title: 'Result Saved',
      message:
          '$_selectedCompetitionTitle recorded ($parsedTotal/$parsedMax · $placement).',
      type: SnackbarType.success,
    );

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleCancel() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompetitionHeaderCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('RESULT'),
                    const SizedBox(height: 8),
                    _buildResultFormCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('QUALIFICATIONS & AWARDS'),
                    const SizedBox(height: 8),
                    _buildQualificationsAndAwardsCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('COMMENTS & NOTES'),
                    const SizedBox(height: 8),
                    _buildCommentsAndNotesCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('ATTACHMENTS'),
                    const SizedBox(height: 8),
                    _buildAttachmentsCard(),
                  ],
                ),
              ),
            ),
            _buildBottomActionFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _handleCancel,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const Text(
            'Record Result',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: _handleSaveResult,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
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

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildCompetitionHeaderCard() {
    return GestureDetector(
      onTap: _openCompetitionPicker,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
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
                Expanded(
                  child: Text(
                    _selectedCompetitionTitle,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 19.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (widget.competition == null)
                  const Icon(
                    Icons.unfold_more_rounded,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoAlpineBlue.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _selectedSportTag.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.infoAlpineBlue,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  _selectedDateLabel,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _resultStatus,
                style: const TextStyle(
                  color: Color(0xFF3BA383),
                  fontSize: 11.8,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultFormCard() {
    final phases = [
      ('Phase A', 'Tracking', _phaseA, AppColors.primaryForestGreen),
      ('Phase B', 'Obedience', _phaseB, AppColors.infoAlpineBlue),
      ('Phase C', 'Protection', _phaseC, const Color(0xFF95D3BB)),
    ];
    final activePhaseValue = _selectedPhaseIndex == 0
        ? _phaseA
        : (_selectedPhaseIndex == 1 ? _phaseB : _phaseC);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('RESULT STATUS *'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _openStatusPicker,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF172420),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.35),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 3.5,
                      color: const Color(0xFF3BA383),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _resultStatus,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
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

          const SizedBox(height: 20),
          _buildFieldLabel('SCORE'),
          TextField(
            controller: _scoreController,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15.5,
              fontFamily: 'Inter',
            ),
            decoration: _underlineDecoration('e.g. 287.5 / 300'),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _chartAnim,
            builder: (context, _) {
              return Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phase Score Rings · Tap phase to fine-tune',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11.2,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          '${_formatScoreNumber(_computedTotal)}/300',
                          style: const TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(phases.length, (i) {
                        final ph = phases[i];
                        final selected = i == _selectedPhaseIndex;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPhaseIndex = i),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CustomPaint(
                                  painter: _RecordPhaseRingPainter(
                                    progress:
                                        (ph.$3 / 100.0) * _chartAnim.value,
                                    color: ph.$4,
                                    selected: selected,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _formatScoreNumber(
                                        ph.$3 * _chartAnim.value,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.primaryTextOffWhite,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ph.$1,
                                style: TextStyle(
                                  color: selected
                                      ? const Color(0xFF95D3BB)
                                      : AppColors.primaryTextOffWhite,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                ph.$2,
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 10.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryForestGreen,
                        inactiveTrackColor: AppColors.cardsCarbon,
                        thumbColor: const Color(0xFF95D3BB),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: activePhaseValue.clamp(50.0, 100.0),
                        min: 50,
                        max: 100,
                        divisions: 100,
                        onChanged: (val) {
                          setState(() {
                            if (_selectedPhaseIndex == 0) {
                              _phaseA = val;
                            } else if (_selectedPhaseIndex == 1) {
                              _phaseB = val;
                            } else {
                              _phaseC = val;
                            }
                            _syncScoreFromPhases();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel('PLACEMENT'),
          TextField(
            controller: _placementController,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15.5,
              fontFamily: 'Inter',
            ),
            decoration: _underlineDecoration('e.g. 1st, 2nd, Finalist'),
          ),
        ],
      ),
    );
  }

  InputDecoration _underlineDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.7),
        fontSize: 14.5,
        fontFamily: 'Inter',
      ),
      contentPadding: const EdgeInsets.only(top: 10, bottom: 9),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryForestGreen,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _buildQualificationsAndAwardsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _openAddChipSheet(isAward: false),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Color(0xFF95D3BB), size: 18),
                SizedBox(width: 6),
                Text(
                  'Add Qualification',
                  style: TextStyle(
                    color: Color(0xFF95D3BB),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          if (_qualifications.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _qualifications.map((q) {
                return _buildRemovableChip(
                  label: q,
                  onRemove: () => setState(() => _qualifications.remove(q)),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _openAddChipSheet(isAward: true),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Color(0xFF95D3BB), size: 18),
                SizedBox(width: 6),
                Text(
                  'Add Award',
                  style: TextStyle(
                    color: Color(0xFF95D3BB),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          if (_awards.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _awards.map((aw) {
                return _buildRemovableChip(
                  label: aw,
                  onRemove: () => setState(() => _awards.remove(aw)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRemovableChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.secondaryTextStoneGrey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsAndNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel("JUDGE'S COMMENTS"),
          TextField(
            controller: _judgeCommentsController,
            maxLines: 3,
            minLines: 2,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 14.5,
              height: 1.45,
              fontFamily: 'Inter',
            ),
            decoration: _underlineDecoration('Judge critique and scoresheet remarks...'),
          ),
          const SizedBox(height: 22),
          _buildFieldLabel('PERSONAL NOTES'),
          TextField(
            controller: _personalNotesController,
            maxLines: 3,
            minLines: 2,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 14.5,
              height: 1.45,
              fontFamily: 'Inter',
            ),
            decoration: _underlineDecoration(
              'What went well, areas to improve, weather\nconditions...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _handleAddAttachment,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.attach_file_rounded,
                  color: Color(0xFF95D3BB),
                  size: 18,
                ),
                SizedBox(width: 6),
                Text(
                  'Add Attachment',
                  style: TextStyle(
                    color: Color(0xFF95D3BB),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          if (_attachments.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...List.generate(_attachments.length, (i) {
              final att = _attachments[i];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i < _attachments.length - 1 ? 10 : 0,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 21,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              att.name,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              att.sizeLabel,
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _attachments.removeAt(i));
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(
                    color: AppColors.secondaryTextStoneGrey
                        .withValues(alpha: 0.45),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 7,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleSaveResult,
                child: const Text(
                  'Save Result',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordPhaseRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool selected;

  const _RecordPhaseRingPainter({
    required this.progress,
    required this.color,
    required this.selected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = selected ? 6.0 : 4.8;
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
  bool shouldRepaint(covariant _RecordPhaseRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.selected != selected;
  }
}
