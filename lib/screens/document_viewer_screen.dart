import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class DocumentPageContent {
  final int pageNumber;
  final String sectionHeader;
  final String subtitle;
  final List<MapEntry<String, String>> keyMetrics;
  final List<String> paragraphs;
  final String footerStamp;

  const DocumentPageContent({
    required this.pageNumber,
    required this.sectionHeader,
    required this.subtitle,
    required this.keyMetrics,
    required this.paragraphs,
    required this.footerStamp,
  });
}

class ViewerDocumentItem {
  final String id;
  final String headerTitle;
  final String cardTitle;
  final String shortDate;
  final String fullDate;
  final String timeLabel;
  final String dogName;
  final String activityCategory;
  final String formatAndSize;
  final String linkedRecordTitle;
  final String linkedRecordSub;
  String notes;
  final List<String> tags;
  final List<DocumentPageContent> pages;
  bool isFavourite;

  ViewerDocumentItem({
    required this.id,
    required this.headerTitle,
    required this.cardTitle,
    required this.shortDate,
    required this.fullDate,
    required this.timeLabel,
    required this.dogName,
    required this.activityCategory,
    required this.formatAndSize,
    required this.linkedRecordTitle,
    required this.linkedRecordSub,
    required this.notes,
    required this.tags,
    required this.pages,
    this.isFavourite = false,
  });
}

class _SearchMatchRef {
  final int pageIndex;
  final String snippet;

  const _SearchMatchRef({
    required this.pageIndex,
    required this.snippet,
  });
}

class DocumentViewerScreen extends StatefulWidget {
  final String? initialDocId;
  final String? overrideTitle;
  final String? dogName;
  final String? dateLabel;
  final bool? initialFavourite;

  const DocumentViewerScreen({
    super.key,
    this.initialDocId,
    this.overrideTitle,
    this.dogName,
    this.dateLabel,
    this.initialFavourite,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = Color(0xFF8E9598);
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _favGold = AppColors.favouriteGold;
  static const Color _alpineBlue = AppColors.infoAlpineBlue;

  late final PageController _pageController;
  final TransformationController _zoomController = TransformationController();
  final TextEditingController _searchController = TextEditingController();

  late int _docIndex;
  int _pageIndex = 0;
  double _zoomLevel = 1.0;
  bool _showSearchBar = false;
  String _searchQuery = '';
  int _activeMatchCursor = 0;
  bool _isDownloadedOffline = false;
  String? _selectedTag;
  final Set<String> _bookmarkedKeys = {'d1:0', 'd3:1'};

  late final List<ViewerDocumentItem> _documents = [
    ViewerDocumentItem(
      id: 'd1',
      headerTitle: 'Vet Report — Annual Clearance',
      cardTitle: 'Vet Report — Sport Conditioning Clearance',
      shortDate: '10 Jul',
      fullDate: '10 Jul 2026',
      timeLabel: '10:24 AM',
      dogName: 'Kodi',
      activityCategory: 'Veterinary Health',
      formatAndSize: 'PDF/A · 4 Pages · 2.4 MB',
      linkedRecordTitle: 'Veterinary Checkup — 10 Jul 2026',
      linkedRecordSub: 'Health · Bergen Canine Sports Clinic · Kodi',
      notes:
          'Cleared for full-load tracking, agility contacts, and alpine endurance intervals. Resting heart rate 58 bpm with clean auscultation and symmetric hind-limb drive.',
      tags: ['Vet Report', 'Cleared', 'Orthopedic', 'Competition Prep'],
      isFavourite: true,
      pages: const [
        DocumentPageContent(
          pageNumber: 1,
          sectionHeader: 'CLINICAL SUMMARY & SPORT CLEARANCE',
          subtitle: 'Bergen Canine Sports & Orthopedic Clinic · Ref #NO-2026-884',
          keyMetrics: [
            MapEntry('Patient', 'Kodi (NO48291/23)'),
            MapEntry('Resting HR', '58 bpm · Normal Sinus'),
            MapEntry('Body Weight', '29.4 kg · BCS 4.5/9'),
            MapEntry('Clearance', 'Cleared — Full Sport Load'),
          ],
          paragraphs: [
            'Comprehensive pre-trial physical examination performed prior to late-summer Nordic tracking and obedience trials. Mucous membranes pink, capillary refill <1.5s, core temperature 38.4°C.',
            'Thoracic auscultation confirms crisp vesicular breath sounds and athletic resting bradycardia without murmur. Palpation of lumbar spine, iliopsoas, and carpal flexors shows zero guarding or asymmetry.',
          ],
          footerStamp: 'Signed electronically · Dr. Ingrid Solberg, DVM CertCSRP',
        ),
        DocumentPageContent(
          pageNumber: 2,
          sectionHeader: 'GAIT & ORTHOPEDIC MOBILITY ASSESSMENT',
          subtitle: 'Pressure Walkway & Joint Flexion Goniometry',
          keyMetrics: [
            MapEntry('Forelimb Symmetry', '98.6% L/R Balance'),
            MapEntry('Hindlimb Thrust', '99.1% Peak Stance'),
            MapEntry('Hip Extension', '162° Bilateral'),
            MapEntry('Stifle Stability', 'Negative Drawer / Tibial'),
          ],
          paragraphs: [
            'Trot gait analysis over 24m force-plate corridor demonstrates even paw loading across all four quadrants. Clean transition from collected trot to extended recall stride without lumbar Dip.',
            'Iliopsoas stretch test and shoulder abduction angle within elite working-dog reference intervals. Continue twice-weekly cavaletti and balance pad conditioning.',
          ],
          footerStamp: 'Orthopedic Unit · Page 2 of 4 · Verified Copy',
        ),
        DocumentPageContent(
          pageNumber: 3,
          sectionHeader: 'HEMATOLOGY & METABOLIC PANEL',
          subtitle: 'Fasting Venous Sample · Nordic Vet Diagnostics Lab',
          keyMetrics: [
            MapEntry('Hematocrit (PCV)', '51.2% (Ref 37–55%)'),
            MapEntry('Creatine Kinase', '118 U/L · Optimal'),
            MapEntry('Creatinine', '84 µmol/L · Normal'),
            MapEntry('Electrolytes', 'Na/K Ratio 34.2'),
          ],
          paragraphs: [
            'Complete blood count reflects strong oxygen-carrying capacity consistent with regular fjord elevation training. Leukocyte differential unremarkable with zero inflammatory markers.',
            'Muscle recovery enzymes (CK and AST) remain low 24 hours after tracking interval work, confirming appropriate hydration and recovery nutrition.',
          ],
          footerStamp: 'Lab Batch #BG-7741 · ISO-17025 Accredited',
        ),
        DocumentPageContent(
          pageNumber: 4,
          sectionHeader: 'SEASON RECOMMENDATIONS & SIGN-OFF',
          subtitle: 'Competition Readiness & Hydration Protocol',
          keyMetrics: [
            MapEntry('Next Review', '10 Jan 2027'),
            MapEntry('Warm-Up Min', '12 min Dynamic Trot'),
            MapEntry('Cool-Down', '8 min Walk + Stretch'),
            MapEntry('Trial Status', 'Approved FCI / NKK'),
          ],
          paragraphs: [
            'Maintain 12-minute progressive warm-up including figure-eight turns and low tuck sits prior to high-drive heelwork or A-frame contacts.',
            'Official veterinary fitness certificate valid for national and Nordic working dog championships through January 2027.',
          ],
          footerStamp: 'NKK Sport Registry Seal · Document End (Page 4/4)',
        ),
      ],
    ),
    ViewerDocumentItem(
      id: 'd2',
      headerTitle: 'Vaccination Certificate',
      cardTitle: 'EU Pet Passport & Rabies Immunisation',
      shortDate: '21 Jun',
      fullDate: '21 Jun 2026',
      timeLabel: '02:15 PM',
      dogName: 'Freja',
      activityCategory: 'Immunisation',
      formatAndSize: 'PDF · 3 Pages · 1.8 MB',
      linkedRecordTitle: 'Booster Vaccination — 21 Jun 2026',
      linkedRecordSub: 'Health · Vestland Vet Care · Freja',
      notes:
          'Triennial Rabies + annual DHPPi/L4 booster recorded and stamped for cross-border Nordic competition travel in Sweden and Denmark.',
      tags: ['Vaccination', 'Passport', 'Travel Ready', 'Freja'],
      pages: const [
        DocumentPageContent(
          pageNumber: 1,
          sectionHeader: 'IMMUNISATION CERTIFICATE — RABIES & CORE',
          subtitle: 'EU Regulation 576/2013 Cross-Border Travel Record',
          keyMetrics: [
            MapEntry('Microchip ISO', '578098100764219'),
            MapEntry('Rabies Batch', 'Nobivac RL #A942B'),
            MapEntry('Valid Until', '21 Jun 2029'),
            MapEntry('Border Status', 'Cleared EU / EEA'),
          ],
          paragraphs: [
            'Animal identity verified via ISO transponder scan prior to vaccine administration. Zero adverse local or systemic reaction observed post-injection.',
            'Authorised for immediate competition entry across Norway, Sweden, Finland, and Denmark under FCI trial veterinary inspection rules.',
          ],
          footerStamp: 'Authorized Veterinarian Stamp · NO-4419',
        ),
        DocumentPageContent(
          pageNumber: 2,
          sectionHeader: 'CORE & LEPTOSPIROSIS BOOSTER LOG',
          subtitle: 'Annual Canine Infectious Disease Schedule',
          keyMetrics: [
            MapEntry('DHPPi Status', 'Valid to Jun 2029'),
            MapEntry('Lepto L4', 'Valid to Jun 2027'),
            MapEntry('Kennel Cough', 'KC Intranasal Active'),
            MapEntry('Echinococcus', ' Deworming Logged'),
          ],
          paragraphs: [
            'Full kennel cough and Leptospirosis 4-serovar coverage active for outdoor woodland water work and multi-dog training camps.',
          ],
          footerStamp: 'Immunisation Ledger · Page 2 of 3',
        ),
        DocumentPageContent(
          pageNumber: 3,
          sectionHeader: 'COMPETITION ORGANISER VERIFICATION PAGE',
          subtitle: 'QR Checksum & Veterinary Clinic Contact',
          keyMetrics: [
            MapEntry('Registry', 'Norsk Kennel Klub'),
            MapEntry('Dog Name', 'Freja av Ulvenik'),
            MapEntry('Checksum', 'SHA256-9F3C-B210'),
            MapEntry('Clinic Tel', '+47 55 21 89 00'),
          ],
          paragraphs: [
            'Present this certified digital copy or original passport during morning trial check-in prior to handler briefing.',
          ],
          footerStamp: 'Verified Digital Export · Page 3 of 3',
        ),
      ],
    ),
    ViewerDocumentItem(
      id: 'd3',
      headerTitle: 'Hip & Elbow Screening',
      cardTitle: 'FCI Radiographic Hip & Elbow Grading',
      shortDate: '14 Jun',
      fullDate: '14 Jun 2026',
      timeLabel: '11:05 AM',
      dogName: 'Bjørn',
      activityCategory: 'Orthopedic Screening',
      formatAndSize: 'PDF · 3 Pages · 3.2 MB',
      linkedRecordTitle: 'Radiology Screening — 14 Jun 2026',
      linkedRecordSub: 'Orthopedic · NKK Panel Review · Bjørn',
      notes:
          'Official NKK/FCI radiographic panel result: HD Grade A (0/0) and ED Grade 0 (0/0). Deep acetabular coverage with crisp Norberg angle.',
      tags: ['Hip Score', 'HD-A', 'ED-0', 'Orthopedic'],
      isFavourite: true,
      pages: const [
        DocumentPageContent(
          pageNumber: 1,
          sectionHeader: 'OFFICIAL FCI HIP DYSPLASIA CERTIFICATE',
          subtitle: 'Norsk Kennel Klub Central Radiology Panel',
          keyMetrics: [
            MapEntry('Hip Score (HD)', 'A / A (Free)'),
            MapEntry('Norberg Angle', '108° Left · 109° Right'),
            MapEntry('Elbow Grade (ED)', '0 / 0 (Normal)'),
            MapEntry('LTV Spine', 'Type 0 · Clear'),
          ],
          paragraphs: [
            'Ventrodorsal extended hip radiograph demonstrates tight congruent femoral head seating with sharp craniolateral acetabular rim bilaterally.',
            'Zero osteophytes, subchondral sclerosis, or joint remodelling detected on left or right elbow projections.',
          ],
          footerStamp: 'NKK Panelist Cert #NO-HD-3109',
        ),
        DocumentPageContent(
          pageNumber: 2,
          sectionHeader: 'MORGAN LINE & SPINAL ALIGNMENT NOTES',
          subtitle: 'Lumbosacral & Thoracic Screening Supplement',
          keyMetrics: [
            MapEntry('Spondylosis', '0 (Clear)'),
            MapEntry('Sacral Anatomy', 'Symmetric 3-Segment'),
            MapEntry('Sedation Protocol', 'Reversible Dexmed.'),
            MapEntry('Image Quality', 'Grade 1 Diagnostic'),
          ],
          paragraphs: [
            'Lumbosacral junction shows clean intervertebral disc spacing suitable for long-term harness pull, tracking, and jump collection.',
          ],
          footerStamp: 'Diagnostic Imaging Archive · Page 2 of 3',
        ),
        DocumentPageContent(
          pageNumber: 3,
          sectionHeader: 'BREEDING & SPORT ARCHIVE REGISTRATION',
          subtitle: 'DogWeb Public Health Entry Confirmation',
          keyMetrics: [
            MapEntry('DogWeb Sync', 'Published'),
            MapEntry('Archive ID', 'NKK-2026-66210'),
            MapEntry('Dog', 'Bjørn'),
            MapEntry('Format', 'DICOM + PDF/A'),
          ],
          paragraphs: [
            'Results permanently linked to pedigree database and Ulvenik health timeline.',
          ],
          footerStamp: 'End of Official Report · Page 3 of 3',
        ),
      ],
    ),
    ViewerDocumentItem(
      id: 'd4',
      headerTitle: 'IGP2 Trial Scorebook',
      cardTitle: 'Nordic Working Trial Judge Score Sheet',
      shortDate: '5 Jun',
      fullDate: '5 Jun 2026',
      timeLabel: '04:40 PM',
      dogName: 'Kodi',
      activityCategory: 'Competition',
      formatAndSize: 'PDF · 2 Pages · 1.4 MB',
      linkedRecordTitle: 'IGP2 Qualification Trial — 5 Jun 2026',
      linkedRecordSub: 'Competition · Voss Brukshundklubb · Kodi',
      notes:
          '96 pts in Phase A Tracking! Judge praised deep nose commitment through crosswind corner #2 and rock-solid article indication.',
      tags: ['Trial', 'Tracking', 'Scorebook', 'Qualification'],
      pages: const [
        DocumentPageContent(
          pageNumber: 1,
          sectionHeader: 'FCI IGP-2 OFFICIAL JUDGE SCORE SHEET',
          subtitle: 'Voss Brukshundklubb · Judge H. Lindqvist (FCI)',
          keyMetrics: [
            MapEntry('Phase A (Track)', '96 / 100 · Vorzüglich'),
            MapEntry('Phase B (Obed.)', '92 / 100 · Sehr Gut'),
            MapEntry('Phase C (Prot.)', '94 / 100 · Sehr Gut'),
            MapEntry('Total Score', '282 / 300 · 1st Place'),
          ],
          paragraphs: [
            'Tracking Phase A: Calm start at pole, steady deep scenting pace across damp pasture and gravel transition. All 3 articles indicated briskly and straight.',
            'Obedience Phase B: Expressive focused heelwork, rapid sit-in-motion, and clean dumbbell retrieve over 1m hurdle.',
          ],
          footerStamp: 'Trial Secretary Verified · Voss NKK #882',
        ),
        DocumentPageContent(
          pageNumber: 2,
          sectionHeader: 'JUDGE CRITIQUE & TITLE QUALIFICATION',
          subtitle: 'Advancement Eligibility to IGP-3',
          keyMetrics: [
            MapEntry('TSB Rating', 'Pronounced (a)'),
            MapEntry('Title Awarded', 'IGP-2 Qualification'),
            MapEntry('Next Class', 'Eligible for IGP-3'),
            MapEntry('Handler', 'M. Lindholm'),
          ],
          paragraphs: [
            'Confident, clear-headed working partner demonstrating exemplary nerve stability during gunshot test and long-distance recall.',
          ],
          footerStamp: 'Official Scorebook Extract · Page 2 of 2',
        ),
      ],
    ),
  ];

  ViewerDocumentItem get _currentDoc => _documents[_docIndex];

  bool get _isCurrentPageBookmarked =>
      _bookmarkedKeys.contains('${_currentDoc.id}:$_pageIndex');

  List<_SearchMatchRef> get _searchMatches {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final results = <_SearchMatchRef>[];
    for (int i = 0; i < _currentDoc.pages.length; i++) {
      final p = _currentDoc.pages[i];
      final combined = [
        p.sectionHeader,
        p.subtitle,
        ...p.keyMetrics.map((e) => '${e.key}: ${e.value}'),
        ...p.paragraphs,
        p.footerStamp,
      ];
      for (final line in combined) {
        if (line.toLowerCase().contains(q)) {
          results.add(_SearchMatchRef(pageIndex: i, snippet: line));
        }
      }
    }
    return results;
  }

  @override
  void initState() {
    super.initState();
    _docIndex = 0;
    if (widget.initialDocId != null) {
      final idx = _documents.indexWhere((d) => d.id == widget.initialDocId);
      if (idx != -1) _docIndex = idx;
    } else if (widget.overrideTitle != null) {
      final q = widget.overrideTitle!.toLowerCase();
      final idx = _documents.indexWhere(
        (d) =>
            d.headerTitle.toLowerCase().contains(q) ||
            d.cardTitle.toLowerCase().contains(q),
      );
      if (idx != -1) {
        _docIndex = idx;
      } else {
        _documents[0] = ViewerDocumentItem(
          id: _documents[0].id,
          headerTitle: widget.overrideTitle!,
          cardTitle: widget.overrideTitle!,
          shortDate: widget.dateLabel ?? _documents[0].shortDate,
          fullDate: widget.dateLabel != null
              ? '${widget.dateLabel} 2026'
              : _documents[0].fullDate,
          timeLabel: _documents[0].timeLabel,
          dogName: widget.dogName ?? _documents[0].dogName,
          activityCategory: _documents[0].activityCategory,
          formatAndSize: _documents[0].formatAndSize,
          linkedRecordTitle: _documents[0].linkedRecordTitle,
          linkedRecordSub: _documents[0].linkedRecordSub,
          notes: _documents[0].notes,
          tags: _documents[0].tags,
          pages: _documents[0].pages,
          isFavourite: widget.initialFavourite ?? _documents[0].isFavourite,
        );
      }
    }
    if (widget.initialFavourite != null) {
      _documents[_docIndex].isFavourite = widget.initialFavourite!;
    }
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _zoomController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _goToPage(int target) {
    final maxPage = _currentDoc.pages.length - 1;
    final clamped = target.clamp(0, maxPage);
    if (clamped == _pageIndex) return;
    _zoomController.value = Matrix4.identity();
    setState(() {
      _zoomLevel = 1.0;
      _pageIndex = clamped;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        clamped,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _cycleZoom() {
    final nextZoom = _zoomLevel == 1.0
        ? 1.5
        : (_zoomLevel == 1.5 ? 2.0 : 1.0);
    setState(() {
      _zoomLevel = nextZoom;
      _zoomController.value = Matrix4.diagonal3Values(nextZoom, nextZoom, 1.0);
    });
  }

  void _togglePageBookmark() {
    final key = '${_currentDoc.id}:$_pageIndex';
    setState(() {
      if (_bookmarkedKeys.contains(key)) {
        _bookmarkedKeys.remove(key);
        AppSnackbar.show(
          context,
          message: 'Removed bookmark from Page ${_pageIndex + 1}.',
          type: SnackbarType.info,
        );
      } else {
        _bookmarkedKeys.add(key);
        AppSnackbar.show(
          context,
          message: 'Bookmarked Page ${_pageIndex + 1} of ${_currentDoc.headerTitle}.',
          type: SnackbarType.success,
        );
      }
    });
  }

  void _stepSearchMatch(int delta) {
    final matches = _searchMatches;
    if (matches.isEmpty) return;
    final nextCursor = (_activeMatchCursor + delta) % matches.length;
    final normalized = nextCursor < 0 ? matches.length - 1 : nextCursor;
    setState(() => _activeMatchCursor = normalized);
    _goToPage(matches[normalized].pageIndex);
  }

  void _selectDocument(int index) {
    if (index == _docIndex) return;
    _zoomController.value = Matrix4.identity();
    setState(() {
      _docIndex = index;
      _pageIndex = 0;
      _zoomLevel = 1.0;
      _selectedTag = null;
      _activeMatchCursor = 0;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _showEditNotesDialog() {
    final controller = TextEditingController(text: _currentDoc.notes);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _cardBorder),
        ),
        title: const Text(
          'Edit Document Notes',
          style: TextStyle(
            color: _offWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _obsidian,
            hintText: 'Add clinical or handler notes...',
            hintStyle: const TextStyle(color: _stoneGrey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _forest),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _stoneGrey, fontFamily: 'Inter'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: _offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                _currentDoc.notes = controller.text.trim().isEmpty
                    ? _currentDoc.notes
                    : controller.text.trim();
              });
              Navigator.pop(ctx);
              AppSnackbar.show(
                context,
                message: 'Document notes saved.',
                type: SnackbarType.success,
              );
            },
            child: const Text('Save', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  void _showFullscreenReader() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _obsidian,
      builder: (ctx) {
        final page = _currentDoc.pages[_pageIndex];
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.92,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_currentDoc.headerTitle} · Page ${page.pageNumber}/${_currentDoc.pages.length}',
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const UlvenikIcon(UlvenikIcons.back, color: _offWhite),
                      ),
                    ],
                  ),
                ),
                const Divider(color: _cardBorder, height: 1),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.5,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildRenderedPaperSheet(page, isExpanded: true),
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

  void _showLinkedRecordSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const UlvenikIcon(UlvenikIcons.training,
                      color: Color(0xFF95D3BB),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentDoc.linkedRecordTitle,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _currentDoc.linkedRecordSub,
                          style: const TextStyle(
                            color: _stoneGrey,
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
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _obsidian,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: _currentDoc.pages.first.keyMetrics
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                m.key,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                m.value,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    padding: const EdgeInsets.symmetric(vertical: 13),
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
      ),
    );
  }

  void _showMoreMenu() {
    final docBookmarks = _bookmarkedKeys
        .where((k) => k.startsWith('${_currentDoc.id}:'))
        .map((k) => int.tryParse(k.split(':').last) ?? 0)
        .toList()
      ..sort();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const UlvenikIcon(UlvenikIcons.search, color: _offWhite),
                title: const Text(
                  'Search in Document',
                  style: TextStyle(color: _offWhite, fontFamily: 'Inter'),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _showSearchBar = true);
                },
              ),
              ListTile(
                leading: UlvenikIcon.fromMaterial(
                  _isCurrentPageBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: _favGold,
                ),
                title: Text(
                  _isCurrentPageBookmarked
                      ? 'Remove Bookmark (Page ${_pageIndex + 1})'
                      : 'Bookmark Page ${_pageIndex + 1}',
                  style: const TextStyle(color: _offWhite, fontFamily: 'Inter'),
                ),
                subtitle: docBookmarks.isEmpty
                    ? null
                    : Text(
                        'Bookmarked pages: ${docBookmarks.map((p) => p + 1).join(', ')}',
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                onTap: () {
                  Navigator.pop(ctx);
                  _togglePageBookmark();
                },
              ),
              ListTile(
                leading: const UlvenikIcon(UlvenikIcons.edit, color: _offWhite),
                title: const Text(
                  'Edit Notes',
                  style: TextStyle(color: _offWhite, fontFamily: 'Inter'),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditNotesDialog();
                },
              ),
              ListTile(
                leading: const UlvenikIcon(UlvenikIcons.overflowMenu, color: _offWhite),
                title: const Text(
                  'Export & Print Certified PDF',
                  style: TextStyle(color: _offWhite, fontFamily: 'Inter'),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  AppSnackbar.show(
                    context,
                    message: 'Prepared ${_currentDoc.headerTitle} for print/export.',
                    type: SnackbarType.success,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteDocument() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _cardBorder),
        ),
        title: const Text(
          'Delete Document?',
          style: TextStyle(
            color: _offWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        content: Text(
          'Remove "${_currentDoc.headerTitle}" from Media Library? Linked clinical metrics remain intact.',
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _stoneGrey, fontFamily: 'Inter'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorDestructive,
              foregroundColor: _offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.maybePop(context);
              AppSnackbar.show(
                context,
                message: 'Document removed from library.',
                type: SnackbarType.warning,
              );
            },
            child: const Text('Delete', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = _searchMatches;

    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDocumentHeroViewport(matches),
              if (_showSearchBar) _buildSearchInDocumentBar(matches),
              _buildPageSwitcherStrip(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildMetadataCard(),
                    const SizedBox(height: 12),
                    _buildActionStrip(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('LINKED RECORD'),
                    const SizedBox(height: 8),
                    _buildLinkedRecordCard(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('NOTES'),
                        GestureDetector(
                          onTap: _showEditNotesDialog,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              color: Color(0xFF95D3BB),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildNotesCard(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('TAGS'),
                    const SizedBox(height: 10),
                    _buildTagsWrap(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('RELATED DOCUMENTS'),
                    const SizedBox(height: 10),
                    _buildRelatedDocumentsRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentHeroViewport(List<_SearchMatchRef> matches) {
    final totalPages = _currentDoc.pages.length;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF171E22), Color(0xFF101417)],
        ),
        border: Border(
          bottom: BorderSide(color: _cardBorder),
        ),
      ),
      child: Column(
        children: [
          // Top overlaid header bar matching Figma
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const UlvenikIcon(UlvenikIcons.back,
                    color: _offWhite,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: Text(
                    _currentDoc.headerTitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Search in document',
                  onPressed: () {
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                      if (!_showSearchBar) {
                        _searchQuery = '';
                        _searchController.clear();
                      }
                    });
                  },
                  icon: UlvenikIcon(UlvenikIcons.search,
                    color: _showSearchBar ? const Color(0xFF95D3BB) : _offWhite,
                    size: 21,
                  ),
                ),
                IconButton(
                  tooltip: 'More options',
                  onPressed: _showMoreMenu,
                  icon: const UlvenikIcon(UlvenikIcons.overflowMenu,
                    color: _offWhite,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),

          // Multi-page interactive document canvas with < / > arrows and Page badge
          SizedBox(
            height: 315,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  onPageChanged: (idx) {
                    _zoomController.value = Matrix4.identity();
                    setState(() {
                      _pageIndex = idx;
                      _zoomLevel = 1.0;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final page = _currentDoc.pages[idx];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(26, 4, 26, 14),
                      child: InteractiveViewer(
                        transformationController:
                            idx == _pageIndex ? _zoomController : null,
                        minScale: 1.0,
                        maxScale: 3.0,
                        child: GestureDetector(
                          onDoubleTap: _cycleZoom,
                          child: _buildRenderedPaperSheet(page),
                        ),
                      ),
                    );
                  },
                ),

                // Left '<' page button
                if (_pageIndex > 0)
                  Positioned(
                    left: 4,
                    child: IconButton(
                      onPressed: () => _goToPage(_pageIndex - 1),
                      icon: UlvenikIcon(UlvenikIcons.back,
                        color: _offWhite.withValues(alpha: 0.85),
                        size: 28,
                      ),
                    ),
                  ),

                // Right '>' page button
                if (_pageIndex < totalPages - 1)
                  Positioned(
                    right: 4,
                    child: IconButton(
                      onPressed: () => _goToPage(_pageIndex + 1),
                      icon: UlvenikIcon(UlvenikIcons.details,
                        color: _offWhite.withValues(alpha: 0.85),
                        size: 28,
                      ),
                    ),
                  ),

                // Top-right bookmark ribbon & zoom pill on sheet
                Positioned(
                  top: 10,
                  right: 36,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _cycleZoom,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const UlvenikIcon(UlvenikIcons.details,
                                color: _offWhite,
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${(_zoomLevel * 100).round()}%',
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _togglePageBookmark,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: UlvenikIcon.fromMaterial(
                            _isCurrentPageBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: _isCurrentPageBookmarked
                                ? _favGold
                                : _offWhite,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom-right "Page X of Y" pill matching Figma's "3 of 12" badge
                Positioned(
                  bottom: 20,
                  right: 36,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Text(
                      '${_pageIndex + 1} of $totalPages',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenderedPaperSheet(
    DocumentPageContent page, {
    bool isExpanded = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isExpanded ? 20 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: isExpanded
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Official Nordic header strip
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ULVENIK DOC · PDF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'PAGE ${page.pageNumber}',
                  style: const TextStyle(
                    color: Color(0xFF5A6560),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildHighlightedDocText(
              page.sectionHeader,
              baseStyle: TextStyle(
                color: const Color(0xFF131A17),
                fontSize: isExpanded ? 14 : 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            _buildHighlightedDocText(
              page.subtitle,
              baseStyle: TextStyle(
                color: const Color(0xFF56635D),
                fontSize: isExpanded ? 11.5 : 9.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEee9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFD5DDD8)),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                children: page.keyMetrics.map((entry) {
                  return SizedBox(
                    width: isExpanded ? 145 : 122,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF63706A),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 1),
                        _buildHighlightedDocText(
                          entry.value,
                          baseStyle: TextStyle(
                            color: const Color(0xFF15201B),
                            fontSize: isExpanded ? 11 : 9.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            ...page.paragraphs.map(
              (para) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _buildHighlightedDocText(
                  para,
                  baseStyle: TextStyle(
                    color: const Color(0xFF28322E),
                    fontSize: isExpanded ? 12 : 9.8,
                    height: 1.42,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const Divider(color: Color(0xFFD6DDD8), height: 12),
            Row(
              children: [
                const UlvenikIcon(UlvenikIcons.completed,
                  size: 12,
                  color: _forest,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildHighlightedDocText(
                    page.footerStamp,
                    baseStyle: const TextStyle(
                      color: Color(0xFF4F5D56),
                      fontSize: 8.8,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedDocText(
    String text, {
    required TextStyle baseStyle,
  }) {
    final q = _searchQuery.trim();
    if (q.isEmpty) {
      return Text(text, style: baseStyle);
    }
    final lowerText = text.toLowerCase();
    final lowerQ = q.toLowerCase();
    if (!lowerText.contains(lowerQ)) {
      return Text(text, style: baseStyle);
    }

    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQ, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + q.length),
          style: baseStyle.copyWith(
            backgroundColor: const Color(0xFFFACC15),
            color: const Color(0xFF101214),
            fontWeight: FontWeight.w800,
          ),
        ),
      );
      start = index + q.length;
    }

    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
    );
  }

  Widget _buildSearchInDocumentBar(List<_SearchMatchRef> matches) {
    final quickTerms = ['Cleared', 'Hip', '58 bpm', 'Rabies', '96 / 100'];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(bottom: BorderSide(color: _cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) {
                      setState(() {
                        _searchQuery = v;
                        _activeMatchCursor = 0;
                      });
                      final m = _searchMatches;
                      if (m.isNotEmpty) {
                        _goToPage(m.first.pageIndex);
                      }
                    },
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Find text across all pages...',
                      hintStyle: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12.5,
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: const UlvenikIcon(UlvenikIcons.search,
                        color: _stoneGrey,
                        size: 18,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              icon: const UlvenikIcon(UlvenikIcons.back,
                                color: _stoneGrey,
                                size: 16,
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: _obsidian,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _forest),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _searchQuery.trim().isEmpty
                    ? '0/0'
                    : (matches.isEmpty
                          ? '0 hits'
                          : '${_activeMatchCursor + 1}/${matches.length}'),
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: matches.isEmpty ? null : () => _stepSearchMatch(-1),
                icon: UlvenikIcon(UlvenikIcons.sort,
                  color: matches.isEmpty
                      ? _stoneGrey.withValues(alpha: 0.4)
                      : _offWhite,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: matches.isEmpty ? null : () => _stepSearchMatch(1),
                icon: UlvenikIcon(UlvenikIcons.sort,
                  color: matches.isEmpty
                      ? _stoneGrey.withValues(alpha: 0.4)
                      : _offWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: quickTerms.map((term) {
                final active =
                    _searchQuery.toLowerCase() == term.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {
                      _searchController.text = term;
                      setState(() {
                        _searchQuery = term;
                        _activeMatchCursor = 0;
                      });
                      final m = _searchMatches;
                      if (m.isNotEmpty) {
                        _goToPage(m.first.pageIndex);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? _forest.withValues(alpha: 0.25)
                            : _obsidian,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: active ? _forest : _cardBorder,
                        ),
                      ),
                      child: Text(
                        term,
                        style: TextStyle(
                          color: active ? const Color(0xFF95D3BB) : _stoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageSwitcherStrip() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_currentDoc.pages.length, (idx) {
            final isSelected = idx == _pageIndex;
            final isBookmarked =
                _bookmarkedKeys.contains('${_currentDoc.id}:$idx');
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _goToPage(idx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _forest.withValues(alpha: 0.22)
                        : _carbon,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? _forest : _cardBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Page ${idx + 1}',
                        style: TextStyle(
                          color: isSelected ? _offWhite : _stoneGrey,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (isBookmarked) ...[
                        const SizedBox(width: 4),
                        const UlvenikIcon(UlvenikIcons.skills,
                          size: 13,
                          color: _favGold,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentDoc.cardTitle,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 17.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetaField('DATE', _currentDoc.fullDate),
              ),
              Expanded(
                child: _buildMetaField('DOG', _currentDoc.dogName),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetaField('TIME', _currentDoc.timeLabel),
              ),
              Expanded(
                child: _buildMetaField(
                  'CATEGORY',
                  _currentDoc.activityCategory,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentDoc.formatAndSize,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12.5,
                  fontFamily: 'Inter',
                ),
              ),
              Row(
                children: [
                  UlvenikIcon(UlvenikIcons.completed,
                    size: 14,
                    color: _alpineBlue.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Verified PDF',
                    style: TextStyle(
                      color: _alpineBlue,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildActionStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(
            icon: _currentDoc.isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: _currentDoc.isFavourite ? const Color(0xFFEAB308) : _stoneGrey,
            label: 'Favourite',
            onTap: () {
              setState(() {
                _currentDoc.isFavourite = !_currentDoc.isFavourite;
              });
              AppSnackbar.show(
                context,
                message: _currentDoc.isFavourite
                    ? 'Added document to Favourites.'
                    : 'Removed document from Favourites.',
                type: SnackbarType.info,
              );
            },
          ),
          _buildActionItem(
            icon: Icons.ios_share_rounded,
            iconColor: _stoneGrey,
            label: 'Share',
            onTap: () {
              AppSnackbar.show(
                context,
                message: 'Sharing "${_currentDoc.headerTitle}" PDF...',
                type: SnackbarType.info,
              );
            },
          ),
          _buildActionItem(
            icon: _isDownloadedOffline
                ? Icons.download_done_rounded
                : Icons.download_rounded,
            iconColor:
                _isDownloadedOffline ? const Color(0xFF95D3BB) : _stoneGrey,
            label: _isDownloadedOffline ? 'Saved' : 'Download',
            onTap: () {
              setState(() => _isDownloadedOffline = !_isDownloadedOffline);
              AppSnackbar.show(
                context,
                message: _isDownloadedOffline
                    ? 'Saved offline copy (${_currentDoc.formatAndSize}).'
                    : 'Removed offline cached copy.',
                type: SnackbarType.success,
              );
            },
          ),
          _buildActionItem(
            icon: Icons.open_in_new_rounded,
            iconColor: _stoneGrey,
            label: 'Open',
            onTap: _showFullscreenReader,
          ),
          _buildActionItem(
            icon: Icons.delete_outline_rounded,
            iconColor: _stoneGrey,
            label: 'Delete',
            onTap: _confirmDeleteDocument,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UlvenikIcon.fromMaterial(icon, color: iconColor, size: 21),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildLinkedRecordCard() {
    return GestureDetector(
      onTap: _showLinkedRecordSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            const UlvenikIcon(UlvenikIcons.training,
              color: _stoneGrey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentDoc.linkedRecordTitle,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _currentDoc.linkedRecordSub,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details,
              color: _stoneGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Text(
        _currentDoc.notes,
        style: const TextStyle(
          color: _offWhite,
          fontSize: 13.5,
          height: 1.5,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildTagsWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _currentDoc.tags.map((tag) {
        final isSelected = _selectedTag == tag;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTag = isSelected ? null : tag;
              if (_selectedTag != null) {
                _showSearchBar = true;
                _searchController.text = tag;
                _searchQuery = tag;
                _activeMatchCursor = 0;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _forest.withValues(alpha: 0.25) : _carbon,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _forest : _cardBorder,
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: isSelected ? const Color(0xFF95D3BB) : _offWhite,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRelatedDocumentsRow() {
    return SizedBox(
      height: 102,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _documents.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final doc = _documents[idx];
          final active = idx == _docIndex;
          return GestureDetector(
            onTap: () => _selectDocument(idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 96,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF21282D), Color(0xFF171C20)],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active ? _forest : _cardBorder,
                  width: active ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PDF',
                          style: TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      if (doc.isFavourite)
                        const UlvenikIcon(UlvenikIcons.health,
                          size: 12,
                          color: Color(0xFFEAB308),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    doc.headerTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doc.shortDate,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 10,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
