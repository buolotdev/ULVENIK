import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

enum ProcedureStatus {
  recovering,
  rehabilitation,
  fullyRecovered,
  scheduled,
}

extension ProcedureStatusX on ProcedureStatus {
  String get label {
    switch (this) {
      case ProcedureStatus.recovering:
        return 'RECOVERING';
      case ProcedureStatus.rehabilitation:
        return 'REHABILITATION';
      case ProcedureStatus.fullyRecovered:
        return 'FULLY RECOVERED';
      case ProcedureStatus.scheduled:
        return 'SCHEDULED';
    }
  }

  Color get color {
    switch (this) {
      case ProcedureStatus.recovering:
        return const Color(0xFF2E6B57); // Primary brand green
      case ProcedureStatus.rehabilitation:
        return const Color(0xFF95D3BB); // Mint
      case ProcedureStatus.fullyRecovered:
        return AppColors.secondaryTextStoneGrey;
      case ProcedureStatus.scheduled:
        return const Color(0xFF5D8FAF); // Alpine blue
    }
  }
}

class TimelineMilestone {
  final String title;
  final DateTime date;
  final bool isCompleted;
  final String? note;

  const TimelineMilestone({
    required this.title,
    required this.date,
    this.isCompleted = true,
    this.note,
  });
}

class ProcedureRecord {
  final String id;
  String title;
  String category;
  ProcedureStatus status;
  DateTime date;
  String practice;
  String surgeon;
  String reason;
  double recoveryProgress; // 0.0 to 1.0
  String? progressNote;
  DateTime? followUpDate;
  String? linkedInjury;
  List<TimelineMilestone> milestones;
  int attachmentCount;
  String notes;
  bool isMajor;

  ProcedureRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.practice,
    required this.surgeon,
    required this.reason,
    required this.recoveryProgress,
    this.progressNote,
    this.followUpDate,
    this.linkedInjury,
    this.milestones = const [],
    this.attachmentCount = 0,
    this.notes = '',
    this.isMajor = true,
  });
}

class RecoveryWeekSpot {
  final String label;
  final double weekNum;
  final double targetPct;
  final double actualPct;
  final String milestone;
  final String careInstruction;

  const RecoveryWeekSpot({
    required this.label,
    required this.weekNum,
    required this.targetPct,
    required this.actualPct,
    required this.milestone,
    required this.careInstruction,
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String? avatarUrl;
  final bool isEmpty;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    this.avatarUrl,
    this.isEmpty = false,
  });
}

class SurgeryProceduresScreen extends StatefulWidget {
  final bool initialEmpty;
  const SurgeryProceduresScreen({super.key, this.initialEmpty = false});

  @override
  State<SurgeryProceduresScreen> createState() => _SurgeryProceduresScreenState();
}

class _SurgeryProceduresScreenState extends State<SurgeryProceduresScreen>
    with SingleTickerProviderStateMixin {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _errorMuted = Color(0xFF8B3A3A);
  static const _alpineBlue = Color(0xFF5D8FAF);

  late bool _isEmpty;
  late AnimationController _anim;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showSearch = false;
  String _searchQuery = '';

  // Filter category: 0: All, 1: Major Surgery, 2: Minor Procedure, 3: Recovering, 4: Fully Recovered
  int _selectedFilterIndex = 0;
  final List<String> _filterLabels = const [
    'All',
    'Major Surgery',
    'Minor Procedure',
    'Recovering',
    'Fully Recovered',
  ];

  // Chart state
  int _selectedChartWeekIndex = 4; // defaults to week 8 (65%)
  bool _showChart = true;

  int _dogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD5Y-lRbyJP54jK7HDaeJMBJqo4sn4odRiu2io0FDrJ3XuvWprzrI0-V1DqniD83r100sBmPwEYmkwRMxtHneJ5WL1vgjew5IMUNIx2MCGsdQI81znlByftrSuuMpGK1Xy-ISAUV0SdsnwLX6BaUSpPbL6A_CMnvNTpibaYZ-ZonQ9J2P4iJL-Eb2zDWuxtJkSfSNYORrm51Ug678n2WqUm1Wgx_c0fv3CPLlTamxU_fn3IAaD9duw',
      isEmpty: false,
    ),
    DogProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl: null, // Shows paw icon
      isEmpty: true,
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
      isEmpty: false,
    ),
  ];

  DogProfile get _dog => _dogs[_dogIndex];

  // Rex's Recovery Trajectory Data for TPLO
  final List<RecoveryWeekSpot> _tploRecoveryTrajectory = const [
    RecoveryWeekSpot(
      label: 'Wk 1',
      weekNum: 1,
      targetPct: 15,
      actualPct: 15,
      milestone: 'Post-op confinement & icing',
      careInstruction: 'Strict crate rest, cold compression 3x daily, pain medication.',
    ),
    RecoveryWeekSpot(
      label: 'Wk 2',
      weekNum: 2,
      targetPct: 25,
      actualPct: 28,
      milestone: 'Suture removal & gentle PROM',
      careInstruction: 'Sutures removed by surgeon. Passive range of motion exercises begun.',
    ),
    RecoveryWeekSpot(
      label: 'Wk 4',
      weekNum: 4,
      targetPct: 40,
      actualPct: 42,
      milestone: 'Controlled leash walks (10m)',
      careInstruction: 'Short controlled 5-10 min leash walks on flat, non-slip surfaces.',
    ),
    RecoveryWeekSpot(
      label: 'Wk 6',
      weekNum: 6,
      targetPct: 55,
      actualPct: 54,
      milestone: 'Radiographic bone consolidation',
      careInstruction: 'X-rays show excellent osteotomy union. Hydrotherapy cleared.',
    ),
    RecoveryWeekSpot(
      label: 'Wk 8',
      weekNum: 8,
      targetPct: 65,
      actualPct: 65,
      milestone: 'Hydrotherapy & underwater treadmill',
      careInstruction: 'Current phase: 20 min water treadmill at 0.8 m/s. Improving gait!',
    ),
    RecoveryWeekSpot(
      label: 'Wk 10',
      weekNum: 10,
      targetPct: 80,
      actualPct: 80,
      milestone: 'Proprioception & hill incline walks',
      careInstruction: 'Scheduled: Cavaletti rails and gentle incline walking.',
    ),
    RecoveryWeekSpot(
      label: 'Wk 12',
      weekNum: 12,
      targetPct: 100,
      actualPct: 100,
      milestone: 'Final veterinary clearance',
      careInstruction: 'Final orthopedic clearance & return to sport conditioning.',
    ),
  ];

  late List<ProcedureRecord> _procedures;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _loadRexProcedures();
  }

  void _loadRexProcedures() {
    _procedures = [
      ProcedureRecord(
        id: 'p1',
        title: 'Cruciate Ligament Repair (TPLO)',
        category: 'ORTHOPAEDIC SURGERY',
        status: ProcedureStatus.recovering,
        date: DateTime(2025, 7, 14),
        practice: 'Nordic Veterinary Specialists',
        surgeon: 'Mr. James Eriksson RCVS',
        reason: 'ACL rupture',
        recoveryProgress: 0.65,
        progressNote: 'IMPROVING ↑',
        followUpDate: DateTime(2025, 8, 28),
        linkedInjury: 'Injury — ACL Rupture',
        isMajor: true,
        attachmentCount: 4,
        notes:
            'Tibial plateau leveling osteotomy (TPLO) performed on left stifle. 3.5mm Synthes locking plate placed. Good post-op alignment verified on orthogonal radiographs.',
        milestones: [
          TimelineMilestone(
            title: 'Procedure Performed',
            date: DateTime(2025, 7, 14),
            isCompleted: true,
            note: 'Successful TPLO left stifle, stable construct.',
          ),
          TimelineMilestone(
            title: 'Discharged from Hospital',
            date: DateTime(2025, 7, 16),
            isCompleted: true,
            note: 'Discharged with cephalexin and gabapentin.',
          ),
          TimelineMilestone(
            title: 'Medication Started',
            date: DateTime(2025, 7, 16),
            isCompleted: true,
            note: 'Course of NSAIDs and gastroprotectant ongoing.',
          ),
          TimelineMilestone(
            title: 'Physiotherapy Started',
            date: DateTime(2025, 7, 28),
            isCompleted: true,
            note: 'PROM and underwater treadmill initialized.',
          ),
          TimelineMilestone(
            title: 'Follow-up Appointment',
            date: DateTime(2025, 8, 28),
            isCompleted: false,
            note: 'Clinical lameness score review and 8-week radiographs.',
          ),
        ],
      ),
      ProcedureRecord(
        id: 'p2',
        title: 'Gastric Dilatation-Volvulus (GDV) Repair',
        category: 'SOFT TISSUE SURGERY',
        status: ProcedureStatus.rehabilitation,
        date: DateTime(2025, 1, 10),
        practice: 'Capital Animal Emergency Hospital',
        surgeon: 'Dr. Sarah Lindqvist DVM',
        reason: 'Acute gastric torsion & bloat',
        recoveryProgress: 0.85,
        progressNote: 'STABLE',
        followUpDate: DateTime(2025, 3, 1),
        isMajor: true,
        attachmentCount: 2,
        notes:
            'Emergency surgical derotation and incisional gastropexy to right abdominal wall. Spleen checked healthy with no thrombosis.',
      ),
      ProcedureRecord(
        id: 'p3',
        title: 'Tooth Extraction — Upper Premolar',
        category: 'DENTAL SURGERY',
        status: ProcedureStatus.fullyRecovered,
        date: DateTime(2024, 9, 12),
        practice: 'Nordic Veterinary Specialists',
        surgeon: 'Dr. Henrik Dahl',
        reason: 'Slab fracture with pulp exposure',
        recoveryProgress: 1.0,
        progressNote: 'HEALED',
        isMajor: false,
        attachmentCount: 3,
        notes:
            'Surgical extraction of tooth 108 with mucoperiosteal flap and alveolar bone contouring. Absorbing sutures placed.',
      ),
      ProcedureRecord(
        id: 'p4',
        title: 'Endoscopy — Gastrointestinal',
        category: 'DIAGNOSTIC PROCEDURE',
        status: ProcedureStatus.fullyRecovered,
        date: DateTime(2024, 4, 5),
        practice: 'Ulvenik Canine Medical Centre',
        surgeon: 'Dr. Ingrid Møller',
        reason: 'Persistent foreign body screening',
        recoveryProgress: 1.0,
        progressNote: 'NORMAL',
        isMajor: false,
        attachmentCount: 1,
        notes:
            'Full gastroduodenoscopy performed under general anesthesia. Mucosa appeared healthy with mild duodenitis. No foreign bodies observed.',
      ),
    ];
  }

  void _loadLunaProcedures() {
    _procedures = [
      ProcedureRecord(
        id: 'p_l1',
        title: 'Laparoscopic Spay (Ovariectomy)',
        category: 'SOFT TISSUE SURGERY',
        status: ProcedureStatus.fullyRecovered,
        date: DateTime(2024, 5, 20),
        practice: 'Nordic Veterinary Specialists',
        surgeon: 'Dr. Sarah Lindqvist DVM',
        reason: 'Elective neutering',
        recoveryProgress: 1.0,
        progressNote: 'FULLY HEALED',
        isMajor: true,
        attachmentCount: 2,
        notes:
            'Minimally invasive two-port laparoscopic ovariectomy. Rapid recovery, skin glued.',
      ),
      ProcedureRecord(
        id: 'p_l2',
        title: 'Superficial Laceration Repair (Paw Pad)',
        category: 'MINOR PROCEDURE',
        status: ProcedureStatus.fullyRecovered,
        date: DateTime(2024, 8, 14),
        practice: 'Ulvenik Canine Medical Centre',
        surgeon: 'Dr. Henrik Dahl',
        reason: 'Sharp flint cut during field training',
        recoveryProgress: 1.0,
        progressNote: 'RESOLVED',
        isMajor: false,
        attachmentCount: 1,
        notes:
            'Deep pad laceration irrigated and closed with 3-0 Monocryl sutures. Pressure bandage worn for 5 days.',
      ),
    ];
  }

  @override
  void dispose() {
    _anim.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _replay() => _anim.forward(from: 0);

  // Derived filtered procedures
  List<ProcedureRecord> get _filteredProcedures {
    return _procedures.where((p) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = p.title.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.practice.toLowerCase().contains(q) ||
            p.surgeon.toLowerCase().contains(q) ||
            p.reason.toLowerCase().contains(q);
        if (!match) return false;
      }

      // Category chip filter
      switch (_selectedFilterIndex) {
        case 1: // Major Surgery
          return p.isMajor;
        case 2: // Minor Procedure
          return !p.isMajor;
        case 3: // Recovering
          return p.status == ProcedureStatus.recovering ||
              p.status == ProcedureStatus.rehabilitation;
        case 4: // Fully Recovered
          return p.status == ProcedureStatus.fullyRecovered;
        default: // All
          return true;
      }
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  int get _totalCount => _dog.isEmpty ? 0 : (_procedures.length + 3); // 7 for Rex
  int get _majorCount => _dog.isEmpty ? 0 : _procedures.where((p) => p.isMajor).length;
  int get _activeRecoveryCount => _dog.isEmpty
      ? 0
      : _procedures
          .where((p) =>
              p.status == ProcedureStatus.recovering ||
              p.status == ProcedureStatus.rehabilitation)
          .length;
  int get _upcomingFollowUpCount => _dog.isEmpty
      ? 0
      : _procedures.where((p) => p.followUpDate != null && p.recoveryProgress < 1.0).length + 1;

  String _formatDate(DateTime d) {
    const months = [
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
      'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatShortDate(DateTime d) {
    const months = [
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
      'Dec'
    ];
    return '${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildAppBar(),
      body: _isEmpty ? _buildEmptyView() : _buildPopulatedView(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.cardsCarbon,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8F7A), size: 24),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Surgery & Procedures',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.search_off : Icons.search,
            color: const Color(0xFF2E6B57),
            size: 24,
          ),
          onPressed: () {
            if (_isEmpty) setState(() => _isEmpty = false);
            setState(() => _showSearch = !_showSearch);
            if (_showSearch) {
              _searchFocus.requestFocus();
            } else {
              _searchController.clear();
              setState(() => _searchQuery = '');
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: Color(0xFF2E6B57), size: 24),
          onPressed: _showTuneFilterSheet,
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Color(0xFF2E6B57), size: 24),
          onPressed: _showAddProcedureSheet,
        ),
        IconButton(
          tooltip: 'Toggle empty / populated state',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : _mint,
            size: 26,
          ),
          onPressed: () {
            setState(() => _isEmpty = !_isEmpty);
            _replay();
          },
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.08),
          height: 1.0,
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED VIEW
  // ==========================================
  Widget _buildPopulatedView() {
    final list = _filteredProcedures;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDogSelectorCard(),
          const SizedBox(height: 24),
          _buildSummaryGrid(),
          const SizedBox(height: 20),
          _buildFilterChipsRow(),
          if (_showSearch) ...[
            const SizedBox(height: 14),
            _buildSearchBar(),
          ],
          const SizedBox(height: 20),
          if (_showChart && _selectedFilterIndex != 4) ...[
            _buildRecoveryTrendChartCard(),
            const SizedBox(height: 20),
          ],
          if (list.isEmpty)
            _buildNoMatchingRecordsCard()
          else
            _buildProcedureList(list),
          const SizedBox(height: 24),
          _buildAddProcedureCTAButton(),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Dog Selector Row
  // ------------------------------------------
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSelectSheet,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildAvatar(_dog.avatarUrl, 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _dog.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextOffWhite,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_dog.breed} · ${_dog.age}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.secondaryTextStoneGrey,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.expand_more,
              color: Color(0xFF7A8F7A),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1D201F),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipOval(
        child: url != null
            ? Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Icon(
                  Icons.pets,
                  size: size * 0.55,
                  color: _mint,
                ),
              )
            : Icon(
                Icons.pets,
                size: size * 0.55,
                color: _mint,
              ),
      ),
    );
  }

  // ------------------------------------------
  // Summary Grid (2x2 divide with dividers)
  // ------------------------------------------
  Widget _buildSummaryGrid() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCell(
                  label: 'TOTAL PROCEDURES',
                  value: _totalCount,
                  isError: false,
                  onTap: () => setState(() => _selectedFilterIndex = 0),
                ),
              ),
              Container(width: 1, height: 72, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildSummaryCell(
                  label: 'MAJOR SURGERIES',
                  value: _majorCount,
                  isError: false,
                  onTap: () => setState(() => _selectedFilterIndex = 1),
                ),
              ),
            ],
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCell(
                  label: 'ACTIVE RECOVERY',
                  value: _activeRecoveryCount,
                  isError: true,
                  onTap: () => setState(() => _selectedFilterIndex = 3),
                ),
              ),
              Container(width: 1, height: 72, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildSummaryCell(
                  label: 'UPCOMING FOLLOW-UPS',
                  value: _upcomingFollowUpCount,
                  isError: false,
                  onTap: _showUpcomingFollowUpsSheet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCell({
    required String label,
    required int value,
    required bool isError,
    required VoidCallback onTap,
  }) {
    final textColor = isError ? _errorMuted : AppColors.primaryTextOffWhite;
    final labelColor = isError ? _errorMuted : AppColors.secondaryTextStoneGrey;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.55,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 4),
            TweenAnimationBuilder<int>(
              key: ValueKey('$value-${_anim.value == 0}'),
              tween: IntTween(begin: 0, end: value),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, val, child) => Text(
                '$val',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // Filter Chips Row
  // ------------------------------------------
  Widget _buildFilterChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_filterLabels.length, (i) {
          final isSelected = i == _selectedFilterIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedFilterIndex = i);
                _replay();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _forest : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  _filterLabels[i],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search procedure, surgeon or clinic...',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 18),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Animated Interactive Recovery Trend Graph
  // ------------------------------------------
  Widget _buildRecoveryTrendChartCard() {
    final trajectory = _tploRecoveryTrajectory;
    final activeSpot = trajectory[_selectedChartWeekIndex.clamp(0, trajectory.length - 1)];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title & Chart Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: _mint, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'TPLO RECOVERY TRAJECTORY',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _forest),
                ),
                child: const Text(
                  '12-WEEK PROTOCOL',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Interactive milestone banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _forest.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            activeSpot.label,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _forest.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${activeSpot.actualPct.toInt()}% HEALED',
                              style: const TextStyle(
                                color: _mint,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (activeSpot.weekNum == 8) ...[
                            const SizedBox(width: 6),
                            const Text(
                              '• CURRENT PHASE',
                              style: TextStyle(
                                color: _mint,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        activeSpot.milestone,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeSpot.careInstruction,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Animated fl_chart LineChart
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final animCurve = Curves.easeOutCubic.transform(_anim.value);

                final actualSpots = List.generate(trajectory.length, (i) {
                  final target = trajectory[i].actualPct;
                  return FlSpot(i.toDouble(), target * animCurve);
                });

                final expectedSpots = List.generate(trajectory.length, (i) {
                  final target = trajectory[i].targetPct;
                  return FlSpot(i.toDouble(), target * animCurve);
                });

                return Stack(
                  children: [
                    // Left Y-axis labels
                    Positioned(
                      left: 0,
                      top: 4,
                      bottom: 22,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('100%', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                          Text('50%', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                          Text('0%', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 28, right: 8, bottom: 20),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (trajectory.length - 1).toDouble(),
                          minY: 0,
                          maxY: 110,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50,
                            getDrawingHorizontalLine: (val) => FlLine(
                              color: Colors.white.withValues(alpha: 0.04),
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                          ),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) => [],
                            ),
                            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                              if (touchResponse != null &&
                                  touchResponse.lineBarSpots != null &&
                                  touchResponse.lineBarSpots!.isNotEmpty) {
                                final spotIndex = touchResponse.lineBarSpots!.first.spotIndex;
                                if (spotIndex >= 0 &&
                                    spotIndex < trajectory.length &&
                                    spotIndex != _selectedChartWeekIndex) {
                                  setState(() {
                                    _selectedChartWeekIndex = spotIndex;
                                  });
                                }
                              }
                            },
                          ),
                          lineBarsData: [
                            // Expected Target Line (Subtle dashed line)
                            LineChartBarData(
                              spots: expectedSpots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: Colors.white.withValues(alpha: 0.2),
                              barWidth: 1.8,
                              dashArray: [4, 4],
                              dotData: const FlDotData(show: false),
                            ),
                            // Actual Progress Line (Solid Mint/Forest gradient)
                            LineChartBarData(
                              spots: actualSpots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: _mint,
                              barWidth: 2.8,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    _forest.withValues(alpha: 0.35),
                                    _forest.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) => true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final isSelected = index == _selectedChartWeekIndex;
                                  final isCurrentWeek = index == 4;
                                  return FlDotCirclePainter(
                                    radius: isSelected ? 5.5 : 3.2,
                                    color: isSelected
                                        ? _mint
                                        : (isCurrentWeek ? const Color(0xFF5D8FAF) : _forest),
                                    strokeWidth: isSelected ? 2.0 : 1.0,
                                    strokeColor: isSelected ? Colors.white : _mint,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // X-Axis Week Labels
                    Positioned(
                      left: 28,
                      right: 8,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: trajectory.map((pt) {
                          final isSel = pt == activeSpot;
                          return Text(
                            pt.label,
                            style: TextStyle(
                              color: isSel ? _mint : AppColors.secondaryTextStoneGrey,
                              fontSize: 10,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w400,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Procedure List Rendering
  // ------------------------------------------
  Widget _buildProcedureList(List<ProcedureRecord> list) {
    return Column(
      children: List.generate(list.length, (i) {
        final p = list[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildProcedureCard(p),
        );
      }),
    );
  }

  Widget _buildProcedureCard(ProcedureRecord p) {
    if (p.id == 'p1') {
      // Card 1: Active Recovery Orthopaedic surgery (TPLO) with left accent bar and mini-timeline
      return Column(
        children: [
          InkWell(
            onTap: () => _showProcedureDetailSheet(p),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 3,
                    child: Container(color: _errorMuted),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(19, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        p.category,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.55,
                                          color: AppColors.secondaryTextStoneGrey,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: _forest),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          p.status.label,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: _forest,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    p.title,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextOffWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.secondaryTextStoneGrey,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // 2x2 Meta Grid
                        _buildMetaGrid(p),
                        const SizedBox(height: 14),

                        // Recovery Progress Bar
                        _buildProgressBar(p),
                        const SizedBox(height: 12),

                        // Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (p.followUpDate != null)
                              _buildPillBadge(
                                icon: Icons.event,
                                label: 'Follow-up: ${_formatShortDate(p.followUpDate!)}',
                                onTap: () => _showFollowUpDetail(p),
                              ),
                            if (p.linkedInjury != null)
                              _buildPillBadge(
                                icon: Icons.link,
                                label: 'Linked: ${p.linkedInjury!}',
                                onTap: () => _showLinkedInjuryDetail(p),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Mini Timeline Card attached
          _buildMiniTimelineCard(p),
        ],
      );
    } else if (p.status == ProcedureStatus.rehabilitation) {
      // Card 2: Soft Tissue Surgery (GDV) with progress bar
      return InkWell(
        onTap: () => _showProcedureDetailSheet(p),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              p.category,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.55,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: _forest),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                p.status.label,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: _forest,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildProgressBar(p),
            ],
          ),
        ),
      );
    } else {
      // Card 3 & 4: Fully recovered procedures (dimmed opacity 0.8)
      return InkWell(
        onTap: () => _showProcedureDetailSheet(p),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            p.status.label,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 20,
                  ),
                ],
              ),
              if (p.attachmentCount > 0) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D201F),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attachment, size: 12, color: AppColors.secondaryTextStoneGrey),
                      const SizedBox(width: 4),
                      Text(
                        'Attachments (${p.attachmentCount})',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }

  // ------------------------------------------
  // Meta Grid Helper
  // ------------------------------------------
  Widget _buildMetaGrid(ProcedureRecord p) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMetaItem('DATE', _formatDate(p.date))),
            Expanded(child: _buildMetaItem('PRACTICE', p.practice)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetaItem('SURGEON', p.surgeon)),
            Expanded(child: _buildMetaItem('REASON', p.reason)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.55,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.primaryTextOffWhite,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Recovery Progress Bar
  // ------------------------------------------
  Widget _buildProgressBar(ProcedureRecord p) {
    final pctInt = (p.recoveryProgress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECOVERY PROGRESS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.55,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
            Row(
              children: [
                Text(
                  '$pctInt%',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _forest,
                  ),
                ),
                if (p.progressNote != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    p.progressNote!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _forest,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1D201F),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, child) {
              final progress = (p.recoveryProgress * Curves.easeOutCubic.transform(_anim.value)).clamp(0.0, 1.0);
              return FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPillBadge({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1D201F),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.secondaryTextStoneGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // Mini Timeline Card
  // ------------------------------------------
  Widget _buildMiniTimelineCard(ProcedureRecord p) {
    final milestones = p.milestones;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Stack(
            children: [
              // Continuous vertical spine
              Positioned(
                left: 7,
                top: 8,
                bottom: 8,
                width: 1,
                child: Container(
                  color: _forest.withValues(alpha: 0.3),
                ),
              ),
              Column(
                children: List.generate(milestones.length, (i) {
                  final m = milestones[i];
                  return Padding(
                    padding: EdgeInsets.only(bottom: i == milestones.length - 1 ? 0 : 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Milestone circle
                        if (m.isCompleted)
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardsCarbon,
                              border: Border.all(color: _forest, width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: _forest,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardsCarbon,
                              border: Border.all(
                                color: const Color(0xFF7A8F7A),
                                width: 1.2,
                              ),
                            ),
                          ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            m.title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: m.isCompleted ? FontWeight.w500 : FontWeight.w400,
                              color: m.isCompleted
                                  ? AppColors.primaryTextOffWhite
                                  : AppColors.secondaryTextStoneGrey,
                            ),
                          ),
                        ),
                        Text(
                          _formatShortDate(m.date),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _showFullTimelineSheet(p),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'View Full Timeline',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _forest,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: _forest),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchingRecordsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 36, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(height: 12),
          const Text(
            'No procedures match your filter.',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFilterIndex = 0;
                _searchQuery = '';
                _searchController.clear();
              });
            },
            child: const Text('Reset All Filters', style: TextStyle(color: _mint)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProcedureCTAButton() {
    return InkWell(
      onTap: _showAddProcedureSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _forest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.backgroundObsidian, size: 20),
            SizedBox(width: 8),
            Text(
              'Add Procedure',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.backgroundObsidian,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY VIEW (Matching Image 2 for Fenris)
  // ==========================================
  Widget _buildEmptyView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dog Selector showing Fenris
          _buildDogSelectorCard(),
          const SizedBox(height: 24),

          // Surgical History Blank Metric Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SURGICAL HISTORY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildEmptyField('Total Procedures')),
                    Expanded(child: _buildEmptyField('Last Surgery')),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _buildEmptyField('Implants')),
                    Expanded(child: _buildEmptyField('Complications')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Center Graphic: Rounded Box with Plus Icon
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.5),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.add,
                size: 30,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Heading & Subtitle
          const Text(
            'No Procedures Recorded',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Keep a permanent record of every surgical procedure and hospital visit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.secondaryTextStoneGrey,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Add Procedure Button
          InkWell(
            onTap: _showAddProcedureSheet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _forest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.primaryTextOffWhite, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Add Procedure',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: AppColors.primaryTextOffWhite, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Learn text link
          Center(
            child: TextButton(
              onPressed: _showLearnSheet,
              child: const Text(
                'Learn about Surgery & Procedures',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _mint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 3,
          color: AppColors.primaryTextOffWhite,
        ),
      ],
    );
  }

  // ==========================================
  // MODALS & BOTTOM SHEETS
  // ==========================================

  Future<T?> _showSheet<T>(Widget Function(BuildContext) builder) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: builder,
    );
  }

  Widget _buildSheetHeader(BuildContext ctx, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    );
  }

  // ------------------------------------------
  // Dog Switcher Modal
  // ------------------------------------------
  void _showDogSelectSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Select Dog Profile'),
                const SizedBox(height: 10),
                ...List.generate(_dogs.length, (i) {
                  final d = _dogs[i];
                  final isSelected = i == _dogIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _dogIndex = i;
                        _isEmpty = d.isEmpty;
                        if (i == 0) {
                          _loadRexProcedures();
                        } else if (i == 2) {
                          _loadLunaProcedures();
                        } else {
                          _procedures = [];
                        }
                      });
                      Navigator.pop(ctx);
                      _replay();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _forest.withValues(alpha: 0.25)
                            : AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? _forest : Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildAvatar(d.avatarUrl, 38),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.name,
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${d.breed} · ${d.age}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: _mint, size: 20),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }

  // ------------------------------------------
  // Procedure Details Sheet
  // ------------------------------------------
  void _showProcedureDetailSheet(ProcedureRecord p) {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHeader(ctx, p.title),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _forest),
                        ),
                        child: Text(
                          p.category,
                          style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: p.status.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          p.status.label,
                          style: TextStyle(
                            color: p.status.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Surgery Date', _formatDate(p.date)),
                        const Divider(color: Colors.white10),
                        _buildDetailRow('Hospital / Practice', p.practice),
                        const Divider(color: Colors.white10),
                        _buildDetailRow('Primary Surgeon', p.surgeon),
                        const Divider(color: Colors.white10),
                        _buildDetailRow('Indication / Reason', p.reason),
                        if (p.followUpDate != null) ...[
                          const Divider(color: Colors.white10),
                          _buildDetailRow('Next Follow-up', _formatDate(p.followUpDate!)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'CLINICAL & SURGICAL NOTES',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.notes.isNotEmpty ? p.notes : 'No extra notes recorded for this procedure.',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showFullTimelineSheet(p);
                          },
                          icon: const Icon(Icons.history, size: 18),
                          label: const Text('View Timeline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _mint,
                            side: const BorderSide(color: _forest),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: AppColors.primaryTextOffWhite,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildDetailRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Full Timeline Sheet
  // ------------------------------------------
  void _showFullTimelineSheet(ProcedureRecord p) {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHeader(ctx, 'Timeline · ${p.title}'),
                  const SizedBox(height: 12),
                  const Text(
                    'Complete chronological log from hospital intake through rehabilitation.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ...p.milestones.map((m) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: m.isCompleted
                              ? _forest.withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            m.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: m.isCompleted ? _mint : AppColors.secondaryTextStoneGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        m.title,
                                        style: const TextStyle(
                                          color: AppColors.primaryTextOffWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatDate(m.date),
                                      style: const TextStyle(
                                        color: AppColors.secondaryTextStoneGrey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                if (m.note != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    m.note!,
                                    style: const TextStyle(
                                      color: AppColors.secondaryTextStoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ));
  }

  // ------------------------------------------
  // Tune / Filter Sheet
  // ------------------------------------------
  void _showTuneFilterSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Filter Procedures'),
                const SizedBox(height: 14),
                const Text(
                  'SELECT FILTER CATEGORY',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_filterLabels.length, (i) {
                    final isSel = i == _selectedFilterIndex;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedFilterIndex = i);
                        Navigator.pop(ctx);
                        _replay();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? _forest : AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSel ? _forest : Colors.white10),
                        ),
                        child: Text(
                          _filterLabels[i],
                          style: TextStyle(
                            color: isSel ? Colors.white : AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Show Recovery Chart', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                    Switch(
                      value: _showChart,
                      activeThumbColor: _mint,
                      activeTrackColor: _forest,
                      onChanged: (v) {
                        setState(() => _showChart = v);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  // ------------------------------------------
  // Add Procedure Sheet Form
  // ------------------------------------------
  void _showAddProcedureSheet() {
    final titleCtrl = TextEditingController();
    final practiceCtrl = TextEditingController(text: 'Nordic Veterinary Specialists');
    final surgeonCtrl = TextEditingController(text: 'Mr. James Eriksson RCVS');
    final reasonCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();
    bool isMajor = true;
    double progress = 0.50;

    _showSheet((ctx) => StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSheetHeader(ctx, 'Record New Procedure'),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: 'PROCEDURE NAME',
                        child: TextField(
                          controller: titleCtrl,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                          decoration: _inputDecoration('e.g. Laparoscopic Gastropexy'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: 'DATE',
                              child: InkWell(
                                onTap: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (d != null) {
                                    setModalState(() => selectedDate = d);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundObsidian,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                  ),
                                  child: Text(
                                    _formatDate(selectedDate),
                                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFormField(
                              label: 'MAJOR SURGERY?',
                              child: Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text('Yes'),
                                    selected: isMajor,
                                    selectedColor: _forest,
                                    onSelected: (v) => setModalState(() => isMajor = true),
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChip(
                                    label: const Text('No'),
                                    selected: !isMajor,
                                    selectedColor: _forest,
                                    onSelected: (v) => setModalState(() => isMajor = false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: 'HOSPITAL / PRACTICE',
                        child: TextField(
                          controller: practiceCtrl,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                          decoration: _inputDecoration('Clinic or hospital name'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: 'LEAD SURGEON',
                        child: TextField(
                          controller: surgeonCtrl,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                          decoration: _inputDecoration('Surgeon name & credentials'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: 'REASON / INDICATION',
                        child: TextField(
                          controller: reasonCtrl,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                          decoration: _inputDecoration('e.g. Medial patellar luxation'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: 'RECOVERY PROGRESS (${(progress * 100).toInt()}%)',
                        child: Slider(
                          value: progress,
                          min: 0.0,
                          max: 1.0,
                          activeColor: _mint,
                          inactiveColor: Colors.white10,
                          onChanged: (v) => setModalState(() => progress = v),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: 'CLINICAL NOTES',
                        child: TextField(
                          controller: notesCtrl,
                          maxLines: 2,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                          decoration: _inputDecoration('Implants, medications, or post-op instructions'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          if (titleCtrl.text.trim().isEmpty) return;
                          final newP = ProcedureRecord(
                            id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            category: isMajor ? 'ORTHOPAEDIC SURGERY' : 'MINOR PROCEDURE',
                            status: progress >= 1.0
                                ? ProcedureStatus.fullyRecovered
                                : (progress > 0.7
                                    ? ProcedureStatus.rehabilitation
                                    : ProcedureStatus.recovering),
                            date: selectedDate,
                            practice: practiceCtrl.text.trim().isEmpty
                                ? 'Nordic Veterinary Specialists'
                                : practiceCtrl.text.trim(),
                            surgeon: surgeonCtrl.text.trim().isEmpty
                                ? 'Veterinary Surgeon'
                                : surgeonCtrl.text.trim(),
                            reason: reasonCtrl.text.trim().isEmpty
                                ? 'Clinical Procedure'
                                : reasonCtrl.text.trim(),
                            recoveryProgress: progress,
                            progressNote: progress >= 1.0 ? 'HEALED' : 'IN RECOVERY',
                            isMajor: isMajor,
                            notes: notesCtrl.text.trim(),
                            milestones: [
                              TimelineMilestone(
                                title: 'Procedure Performed',
                                date: selectedDate,
                                isCompleted: true,
                              ),
                            ],
                          );

                          setState(() {
                            _procedures.insert(0, newP);
                            if (_isEmpty) _isEmpty = false;
                          });
                          Navigator.pop(ctx);
                          _replay();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _forest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Save Procedure',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.55,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
      filled: true,
      fillColor: AppColors.backgroundObsidian,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _mint),
      ),
    );
  }

  // ------------------------------------------
  // Educational Sheet (Learn about procedures)
  // ------------------------------------------
  void _showLearnSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Surgery & Procedures in Ulvenik'),
                const SizedBox(height: 12),
                const Text(
                  'Keep a complete permanent surgical ledger for your dog:\n\n'
                  '• Track anesthesia notes, recovery timelines, and surgical implants.\n'
                  '• Follow milestone protocols like 12-week TPLO recovery curves.\n'
                  '• Link surgeries directly to active injuries or physiotherapy plans.\n'
                  '• Export verifiable hospital records directly to veterinarians or insurance.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.55),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Got It', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showFollowUpDetail(ProcedureRecord p) {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Follow-up Details'),
                const SizedBox(height: 12),
                _buildDetailRow('Scheduled Date', _formatDate(p.followUpDate!)),
                _buildDetailRow('Clinic', p.practice),
                _buildDetailRow('Purpose', '8-week orthopedic review and orthogonal radiographs'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showLinkedInjuryDetail(ProcedureRecord p) {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Linked Injury'),
                const SizedBox(height: 12),
                Text(
                  p.linkedInjury ?? 'No linked record',
                  style: const TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This surgical repair is linked to the ACL rupture condition in Rex’s injuries record. Recovery milestones sync automatically with the rehabilitation hub.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: AppColors.primaryTextOffWhite,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showUpcomingFollowUpsSheet() {
    _showSheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHeader(ctx, 'Upcoming Follow-ups (2)'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today, color: _mint, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TPLO 8-Week Review', style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                            Text('28 Aug 2025 · Nordic Veterinary Specialists', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today, color: _alpineBlue, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('GDV Abdominal Ultrasound', style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                            Text('15 Sep 2025 · Capital Animal Hospital', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
