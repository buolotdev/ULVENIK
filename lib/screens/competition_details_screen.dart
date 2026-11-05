import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'record_competition_result_screen.dart';
import 'sport_pack_overview_screen.dart';

class _AttachmentDoc {
  final String fileName;
  final String uploadedDate;
  final String previewSummary;

  const _AttachmentDoc({
    required this.fileName,
    required this.uploadedDate,
    required this.previewSummary,
  });
}

class CompetitionDetailsScreen extends StatefulWidget {
  final SportCompetitionModel? competition;

  const CompetitionDetailsScreen({
    super.key,
    this.competition,
  });

  @override
  State<CompetitionDetailsScreen> createState() =>
      _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen>
    with SingleTickerProviderStateMixin {
  final SportPackStore _store = SportPackStore.instance;
  late final AnimationController _animController;
  late final Animation<double> _chartAnim;

  late String _compId;
  late String _title;
  late String _dateDisplay;
  late String _startTime;
  late String _organisation;
  late String _judge;
  late String _club;
  late String _venue;
  late String _entryNumber;
  late String _entryClass;
  late String _handler;
  late String _location;
  late String _notes;

  int _selectedPhaseIndex = 0;

  late List<_AttachmentDoc> _attachments;

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);

    final initial = widget.competition;
    _compId = initial?.id ?? 'essex_trial';
    final isDefaultEssex = _compId == 'essex_trial';

    _title = initial?.title ?? 'Essex Working Dog Trial';
    _dateDisplay = isDefaultEssex
        ? '18 September 2026'
        : (initial?.date ?? '18 September 2026');
    _startTime = '09:00';
    _organisation = isDefaultEssex ? 'SV' : (initial?.organisation ?? 'SV');
    _judge = isDefaultEssex
        ? 'Hans Müller'
        : (initial?.judge ?? 'Hans Müller');
    _club = 'South Essex Working Dog Club';
    _venue = 'Barleyfields Training Ground';
    _entryNumber = '47';
    _entryClass = initial?.level ?? 'IGP 2';
    _handler = 'James Walker';
    _location = initial?.location ?? 'Essex, UK';
    _notes = '';

    _attachments = [
      const _AttachmentDoc(
        fileName: 'Entry Confirmation.pdf',
        uploadedDate: 'Uploaded 2 Aug 2026',
        previewSummary:
            'Official SV/GSDL Entry #47 · Dog: Zeus (Belgian Malinois) · Class: IGP 2 · Handler: James Walker · Fee Paid.',
      ),
      const _AttachmentDoc(
        fileName: 'Running Order.pdf',
        uploadedDate: 'Uploaded 14 Sep 2026',
        previewSummary:
            'Phase A Tracking Draw: Group 2 at 09:00 · Phase B Obedience: 11:30 · Phase C Protection: 14:15 · Judge: Hans Müller.',
      ),
    ];

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _chartAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  void _onStoreChanged() {
    if (!mounted) return;
    setState(() {});
    _animController.forward(from: 0);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _animController.dispose();
    super.dispose();
  }

  SportCompetitionModel _resolveCompetition() {
    for (final c in _store.competitions) {
      if (c.id == _compId) return c;
    }
    return widget.competition ??
        SportCompetitionModel(
          id: _compId,
          title: _title,
          sportTag: 'IGP',
          level: _entryClass,
          date: _dateDisplay,
          location: _location,
          status: 'Entered',
          judge: _judge,
          organisation: _organisation,
          notes: _notes,
        );
  }

  void _openRecordResult(SportCompetitionModel comp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecordCompetitionResultScreen(competition: comp),
      ),
    );
  }

  void _openEditCompetitionSheet() {
    final titleCtrl = TextEditingController(text: _title);
    final dateCtrl = TextEditingController(text: _dateDisplay);
    final timeCtrl = TextEditingController(text: _startTime);
    final judgeCtrl = TextEditingController(text: _judge);
    final venueCtrl = TextEditingController(text: _venue);
    final entryNoCtrl = TextEditingController(text: _entryNumber);

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
            MediaQuery.of(ctx).viewInsets.bottom + 22,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EDIT COMPETITION DETAILS',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                _buildEditInput('Title', titleCtrl),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildEditInput('Date', dateCtrl)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildEditInput('Start Time', timeCtrl)),
                  ],
                ),
                const SizedBox(height: 10),
                _buildEditInput('Judge', judgeCtrl),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildEditInput('Venue', venueCtrl),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: _buildEditInput('Entry #', entryNoCtrl),
                    ),
                  ],
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
                        if (titleCtrl.text.trim().isNotEmpty) {
                          _title = titleCtrl.text.trim();
                        }
                        if (dateCtrl.text.trim().isNotEmpty) {
                          _dateDisplay = dateCtrl.text.trim();
                        }
                        if (timeCtrl.text.trim().isNotEmpty) {
                          _startTime = timeCtrl.text.trim();
                        }
                        if (judgeCtrl.text.trim().isNotEmpty) {
                          _judge = judgeCtrl.text.trim();
                        }
                        if (venueCtrl.text.trim().isNotEmpty) {
                          _venue = venueCtrl.text.trim();
                        }
                        if (entryNoCtrl.text.trim().isNotEmpty) {
                          _entryNumber = entryNoCtrl.text.trim();
                        }
                        final idx = _store.competitions
                            .indexWhere((c) => c.id == _compId);
                        if (idx != -1) {
                          _store.competitions[idx] =
                              _store.competitions[idx].copyWith(
                            title: _title,
                            date: _dateDisplay,
                            judge: _judge,
                          );
                        }
                      });
                      Navigator.pop(ctx);
                      AppSnackbar.show(
                        context,
                        title: 'Competition Updated',
                        message: '$_title details saved.',
                        type: SnackbarType.success,
                      );
                    },
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
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

  Widget _buildEditInput(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 13.8,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundObsidian,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryForestGreen),
            ),
          ),
        ),
      ],
    );
  }

  void _openEditNotesSheet() {
    final notesCtrl = TextEditingController(text: _notes);
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
                _notes.isEmpty ? 'ADD COMPETITION NOTE' : 'COMPETITION NOTES',
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
                controller: notesCtrl,
                maxLines: 4,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  height: 1.45,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: 'Add any additional notes about this competition…',
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
                    setState(() => _notes = notesCtrl.text.trim());
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      title: 'Notes Saved',
                      message: 'Competition notes saved.',
                      type: SnackbarType.success,
                    );
                  },
                  child: Text(
                    _notes.isEmpty ? 'Add Note' : 'Save Notes',
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

  void _openAttachmentPreview(_AttachmentDoc doc) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
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
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const UlvenikIcon(UlvenikIcons.training,
                        color: Color(0xFF3BA383),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.fileName,
                            style: const TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doc.uploadedDate,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12.5,
                              fontFamily: 'Inter',
                            ),
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
                  child: Text(
                    doc.previewSummary,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13.5,
                      height: 1.45,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Done',
                      style: TextStyle(
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

  void _openMoreMenu(SportCompetitionModel comp) {
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
                  leading: const UlvenikIcon(UlvenikIcons.edit,
                    color: AppColors.primaryTextOffWhite,
                  ),
                  title: const Text(
                    'Edit Competition',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openEditCompetitionSheet();
                  },
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.overflowMenu,
                    color: Color(0xFF3BA383),
                  ),
                  title: const Text(
                    'Add Scorebook / Schedule PDF',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachments.add(
                        const _AttachmentDoc(
                          fileName: 'Tracking_Field_Map.pdf',
                          uploadedDate: 'Uploaded Just now',
                          previewSummary:
                              'Barleyfields Pasture Plot B · Grass height 12cm · Parking & assembly area north gate.',
                        ),
                      );
                    });
                    AppSnackbar.show(
                      context,
                      title: 'Attachment Added',
                      message: 'Tracking_Field_Map.pdf attached to trial.',
                      type: SnackbarType.success,
                    );
                  },
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.goals,
                    color: AppColors.infoAlpineBlue,
                  ),
                  title: Text(
                    comp.status.toLowerCase() == 'completed'
                        ? 'Update Recorded Result'
                        : 'Record Competition Result',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openRecordResult(comp);
                  },
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
    final comp = _resolveCompetition();
    final isCompleted = comp.status.toLowerCase() == 'completed' &&
        (comp.totalScore != null || comp.qualificationResult != null);

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(comp),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(comp, isCompleted),
                    const SizedBox(height: 22),
                    _buildSectionLabel('COMPETITION INFORMATION'),
                    const SizedBox(height: 8),
                    _buildInformationCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('RESULT'),
                    const SizedBox(height: 8),
                    if (isCompleted)
                      _buildRecordedResultCard(comp)
                    else
                      _buildNoResultCard(comp),
                    const SizedBox(height: 22),
                    _buildSectionLabel('QUALIFICATIONS & AWARDS'),
                    const SizedBox(height: 8),
                    _buildQualificationsSection(comp, isCompleted),
                    const SizedBox(height: 22),
                    _buildSectionLabel('NOTES'),
                    const SizedBox(height: 8),
                    _buildNotesCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('ATTACHMENTS'),
                    const SizedBox(height: 8),
                    _buildAttachmentsCard(),
                  ],
                ),
              ),
            ),
            _buildBottomActionFooter(comp, isCompleted),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(SportCompetitionModel comp) {
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
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Competition Details',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _openMoreMenu(comp),
            icon: const UlvenikIcon(UlvenikIcons.more,
              color: AppColors.secondaryTextStoneGrey,
              size: 22,
            ),
            tooltip: 'More',
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

  Widget _buildHeroCard(SportCompetitionModel comp, bool isCompleted) {
    final statusLabel = comp.status.toLowerCase() == 'entered'
        ? 'Upcoming'
        : comp.status;

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
          Text(
            _title,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                decoration: BoxDecoration(
                  color: AppColors.infoAlpineBlue.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  comp.sportTag.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.infoAlpineBlue,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '•  $_dateDisplay',
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.infoAlpineBlue.withValues(alpha: 0.16)
                  : AppColors.primaryForestGreen.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: isCompleted
                    ? AppColors.infoAlpineBlue
                    : const Color(0xFF3BA383),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const UlvenikIcon(UlvenikIcons.timeline,
                color: AppColors.secondaryTextStoneGrey,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                _location,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    final rows = [
      ('Date', _dateDisplay),
      ('Start Time', _startTime),
      ('Organisation', _organisation),
      ('Judge', _judge),
      ('Club', _club),
      ('Venue', _venue),
      ('Entry Number', _entryNumber),
      ('Entry Class', _entryClass),
      ('Handler', _handler),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final item = rows[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.$1,
                      style: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        item.$2,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13.8,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i < rows.length - 1)
                Container(height: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNoResultCard(SportCompetitionModel comp) {
    final readinessPhases = [
      ('Phase A · Tracking', 94, '600 paces, 4 corners, 3 articles ready'),
      ('Phase B · Obedience', 89, 'Heelwork & retrieve speed dialled in'),
      ('Phase C · Protection', 95, 'Clean outs & deep grips verified'),
    ];
    final selectedReadiness = readinessPhases[_selectedPhaseIndex];

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              const UlvenikIcon(UlvenikIcons.goals,
                color: AppColors.secondaryTextStoneGrey,
                size: 36,
              ),
              const SizedBox(height: 12),
              const Text(
                'No Result Recorded',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _openRecordResult(comp),
                  child: const Text(
                    'Record Result',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _chartAnim,
          builder: (context, _) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pre-Trial Phase Readiness · Tap bar to inspect target',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(readinessPhases.length, (i) {
                    final item = readinessPhases[i];
                    final selected = i == _selectedPhaseIndex;
                    final val = (item.$2 * _chartAnim.value).round();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _selectedPhaseIndex = i),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.$1,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.primaryTextOffWhite
                                        : AppColors.secondaryTextStoneGrey,
                                    fontSize: 12.5,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Text(
                                  '$val / 100 target',
                                  style: TextStyle(
                                    color: selected
                                        ? const Color(0xFF3BA383)
                                        : AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: (item.$2 / 100.0) * _chartAnim.value,
                                minHeight: 7,
                                backgroundColor: AppColors.backgroundObsidian,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  selected
                                      ? AppColors.primaryForestGreen
                                      : AppColors.infoAlpineBlue
                                          .withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Text(
                    selectedReadiness.$3,
                    style: const TextStyle(
                      color: Color(0xFF95D3BB),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecordedResultCard(SportCompetitionModel comp) {
    final total = comp.totalScore ?? 282;
    final max = (comp.maxScore == null || comp.maxScore == 0)
        ? 300
        : comp.maxScore!;
    final pA = comp.phaseAScore ?? 95;
    final pB = comp.phaseBScore ?? 91;
    final pC = comp.phaseCScore ?? 96;
    final phases = [
      ('Section A', 'Tracking', pA, AppColors.primaryForestGreen),
      ('Section B', 'Obedience', pB, AppColors.infoAlpineBlue),
      ('Section C', 'Protection', pC, const Color(0xFF3BA383)),
    ];

    return AnimatedBuilder(
      animation: _chartAnim,
      builder: (context, _) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(total * _chartAnim.value).round()} / $max pts',
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${comp.placement ?? '1st Place'}  ·  ${comp.qualificationResult ?? 'Qualified'}',
                        style: const TextStyle(
                          color: Color(0xFF3BA383),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColors.primaryForestGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Official Score',
                      style: TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(phases.length, (i) {
                  final ph = phases[i];
                  final selected = _selectedPhaseIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPhaseIndex = i),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CustomPaint(
                            painter: _CompPhaseRingPainter(
                              progress: (ph.$3 / 100.0) * _chartAnim.value,
                              color: ph.$4,
                              selected: selected,
                            ),
                            child: Center(
                              child: Text(
                                '${(ph.$3 * _chartAnim.value).round()}',
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
                          ph.$1,
                          style: TextStyle(
                            color: selected
                                ? AppColors.primaryTextOffWhite
                                : AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          ph.$2,
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQualificationsSection(
    SportCompetitionModel comp,
    bool isCompleted,
  ) {
    if (!isCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Text(
          'No qualifications or awards linked to this\ncompetition.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 13.5,
            height: 1.45,
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
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
            child: const UlvenikIcon(UlvenikIcons.goals,
              color: Color(0xFF3BA383),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_entryClass · ${comp.qualificationResult ?? 'Qualified'}',
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$_organisation · $_dateDisplay',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12.5,
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
    if (_notes.isEmpty) {
      return GestureDetector(
        onTap: _openEditNotesSheet,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'No notes added',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13.8,
                  fontFamily: 'Inter',
                ),
              ),
              Row(
                children: [
                  UlvenikIcon(UlvenikIcons.add,
                    size: 16,
                    color: Color(0xFF3BA383),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Add Note',
                    style: TextStyle(
                      color: Color(0xFF3BA383),
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
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _notes,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 13.8,
              height: 1.5,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _openEditNotesSheet,
              child: const Text(
                'Edit Notes',
                style: TextStyle(
                  color: Color(0xFF3BA383),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: List.generate(_attachments.length, (i) {
          final doc = _attachments[i];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openAttachmentPreview(doc),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      const UlvenikIcon(UlvenikIcons.training,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 21,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.fileName,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              doc.uploadedDate,
                              style: const TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12.2,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Open',
                        style: TextStyle(
                          color: Color(0xFF3BA383),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < _attachments.length - 1)
                Container(height: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomActionFooter(
    SportCompetitionModel comp,
    bool isCompleted,
  ) {
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
            child: SizedBox(
              height: 46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: const BorderSide(color: AppColors.cardBorder),
                  backgroundColor: AppColors.cardsCarbon,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: _openEditCompetitionSheet,
                child: const Text(
                  'Edit Competition',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: () => _openRecordResult(comp),
                child: Text(
                  isCompleted ? 'Update Result' : 'Record Result',
                  style: const TextStyle(
                    fontSize: 14,
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

class _CompPhaseRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool selected;

  const _CompPhaseRingPainter({
    required this.progress,
    required this.color,
    required this.selected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = selected ? 6.5 : 5.0;
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
  bool shouldRepaint(covariant _CompPhaseRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.selected != selected;
  }
}
