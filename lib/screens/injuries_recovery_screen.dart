import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum InjuryStatus { active, recovering, resolved }

class InjuryItem {
  final String id;
  String title;
  String bodyArea;
  DateTime date;
  String severity; // Mild, Moderate, Severe
  InjuryStatus status;
  double recoveryProgress; // 0.0 to 1.0
  String recoveryStage; // RESTING, REHABILITATION, LIGHT EXERCISE, RETURN TO SPORT, RESOLVED
  String diagnosisNotes;
  String treatmentPlan;
  String? clinic;

  InjuryItem({
    required this.id,
    required this.title,
    required this.bodyArea,
    required this.date,
    required this.severity,
    required this.status,
    required this.recoveryProgress,
    required this.recoveryStage,
    required this.diagnosisNotes,
    required this.treatmentPlan,
    this.clinic,
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
  });
}

class InjuriesRecoveryScreen extends StatefulWidget {
  final bool initialEmpty;
  const InjuriesRecoveryScreen({super.key, this.initialEmpty = false});

  @override
  State<InjuriesRecoveryScreen> createState() => _InjuriesRecoveryScreenState();
}

class _InjuriesRecoveryScreenState extends State<InjuriesRecoveryScreen> {
  late bool _isEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? _selectedStatusFilter = 'Active'; // 'Active', 'Recovering', 'Resolved', null = all
  bool _seeAllResolved = false;

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCtaU2iGJ_VBCVyQdAKDQ8maadSfzmF1rpQhwCvvQgxuHJRwpLOfOgKoACu-xQoOjb_f3C2xrjS0uND3MCa4HjorEt6AnK-UlQCY4_ESs6hlMt-Ao1I-SjMasqTTzaIhPBvTYLjsGKdYz2MaolJEVqxmbuYX5o_0GIusJblMzsmTb_ycStx1-xgin0zl2HtTwOxdzrfZiLMp1_dL1mjX2zn_uYogJczGyOewllRUbjYEYKFU1Wn2kY',
    ),
    DogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3y 2m',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBr_VJmHZE56JGN_MKaqBxjql_dWzuwgd8_u7Cg5v9emxxzrLMd-q0uEzNPLRnTDRLSDSwlvg4a3B7iJHZ_psMLbCo7pBzYvh7LnaDIVWSm1xzp1ljVksHA-ede6cZVj-m6PZTvIBKrHdQgQE0ZCp5mGDk5Rgdd8sdlA3dqATiv6-qLDU87fDK7J5hc2qlShDZnoXO0eijdi2H5k4mtTE9vjlwdVZKXZATLtdF05mZoU8fFSi_XYig',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
    ),
  ];

  DogProfile get _activeDog => _dogs[_activeDogIndex];

  late List<InjuryItem> _injuries;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeInjuries();
  }

  void _initializeInjuries() {
    _injuries = [
      InjuryItem(
        id: 'inj_1',
        title: 'Left Foreleg Strain',
        bodyArea: 'Left Foreleg',
        date: DateTime(2026, 8, 10),
        severity: 'Moderate',
        status: InjuryStatus.active,
        recoveryProgress: 0.35,
        recoveryStage: 'RESTING',
        diagnosisNotes: 'Soft tissue strain from agility weave pole training.',
        treatmentPlan: 'Strict crate rest, cold therapy 3x daily, and anti-inflammatory course.',
        clinic: 'City Vets · Dr. Sarah Connell',
      ),
      InjuryItem(
        id: 'inj_2',
        title: 'Hip Dysplasia Flare-up',
        bodyArea: 'Hip',
        date: DateTime(2026, 6, 22),
        severity: 'Moderate',
        status: InjuryStatus.recovering,
        recoveryProgress: 0.70,
        recoveryStage: 'REHABILITATION',
        diagnosisNotes: 'Secondary inflammation following strenuous mountain sprint.',
        treatmentPlan: 'Hydrotherapy 2x/week, controlled leash walks, and joint supplements.',
        clinic: 'City Vets · Dr. Sarah Connell',
      ),
      InjuryItem(
        id: 'inj_3',
        title: 'Paw Laceration',
        bodyArea: 'Right Paw',
        date: DateTime(2026, 3, 12),
        severity: 'Mild',
        status: InjuryStatus.resolved,
        recoveryProgress: 1.0,
        recoveryStage: 'RESOLVED',
        diagnosisNotes: 'Superficial cut on pad from sharp trail rock.',
        treatmentPlan: 'Cleaned, disinfected, antiseptic wrap for 4 days. Healed cleanly.',
        clinic: 'Alpine Animal Clinic',
      ),
      InjuryItem(
        id: 'inj_4',
        title: 'Ear Infection',
        bodyArea: 'Left Ear',
        date: DateTime(2026, 1, 4),
        severity: 'Mild',
        status: InjuryStatus.resolved,
        recoveryProgress: 1.0,
        recoveryStage: 'RESOLVED',
        diagnosisNotes: 'Mild yeast overgrowth after lake swimming.',
        treatmentPlan: 'Antifungal ear drop drops for 7 days. Follow-up swab clear.',
        clinic: 'City Vets',
      ),
      InjuryItem(
        id: 'inj_5',
        title: 'Sprained Dewclaw',
        bodyArea: 'Right Foreleg',
        date: DateTime(2025, 10, 15),
        severity: 'Mild',
        status: InjuryStatus.resolved,
        recoveryProgress: 1.0,
        recoveryStage: 'RESOLVED',
        diagnosisNotes: 'Caught claw on fence mesh during bite work.',
        treatmentPlan: 'Trimmed and bandaged. Full recovery in 10 days.',
        clinic: 'City Vets',
      ),
      InjuryItem(
        id: 'inj_6',
        title: 'Tail Contusion',
        bodyArea: 'Tail',
        date: DateTime(2025, 7, 28),
        severity: 'Mild',
        status: InjuryStatus.resolved,
        recoveryProgress: 1.0,
        recoveryStage: 'RESOLVED',
        diagnosisNotes: 'Bruising from impact with kennel gate.',
        treatmentPlan: 'Cold compression and rest.',
        clinic: 'City Vets',
      ),
    ];
  }

  // Dynamic Metrics
  int get _activeCount => _injuries.where((i) => i.status == InjuryStatus.active).length;
  int get _recoveringCount => _injuries.where((i) => i.status == InjuryStatus.recovering).length;
  int get _resolvedCount => _injuries.where((i) => i.status == InjuryStatus.resolved).length;
  String get _avgRecoveryDays => '18 days';

  // Filtered lists
  List<InjuryItem> get _filteredInjuries {
    var list = List<InjuryItem>.from(_injuries);

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((i) {
        return i.title.toLowerCase().contains(q) ||
            i.bodyArea.toLowerCase().contains(q) ||
            i.diagnosisNotes.toLowerCase().contains(q) ||
            i.severity.toLowerCase().contains(q);
      }).toList();
    }

    if (_selectedStatusFilter != null) {
      if (_selectedStatusFilter == 'Active') {
        list = list.where((i) => i.status == InjuryStatus.active).toList();
      } else if (_selectedStatusFilter == 'Recovering') {
        list = list.where((i) => i.status == InjuryStatus.recovering).toList();
      } else if (_selectedStatusFilter == 'Resolved') {
        list = list.where((i) => i.status == InjuryStatus.resolved).toList();
      }
    }

    return list;
  }

  List<InjuryItem> get _currentInjuries =>
      _filteredInjuries.where((i) => i.status == InjuryStatus.active || i.status == InjuryStatus.recovering).toList();

  List<InjuryItem> get _resolvedInjuries =>
      _filteredInjuries.where((i) => i.status == InjuryStatus.resolved).toList();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildAppBar(),
      body: _isEmpty ? _buildEmptyStateView() : _buildPopulatedView(),
    );
  }

  // ==========================================
  // TOP APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextOffWhite, size: 24),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Injuries & Recovery',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: true,
      actions: [
        // Search Icon
        IconButton(
          tooltip: 'Search Records',
          icon: const Icon(Icons.search, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: () {
            if (_isEmpty) setState(() => _isEmpty = false);
            _searchFocusNode.requestFocus();
          },
        ),
        // Filter / Tune
        IconButton(
          tooltip: 'Filter Options',
          icon: const Icon(Icons.tune, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: _showFilterPreferencesModal,
        ),
        // State Toggle (Populated / Empty)
        IconButton(
          tooltip: _isEmpty ? 'Preview Populated' : 'Preview Empty',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
            size: 26,
          ),
          onPressed: () {
            setState(() => _isEmpty = !_isEmpty);
          },
        ),
        // Add Record (+)
        IconButton(
          tooltip: 'Add Injury',
          icon: const Icon(Icons.add, color: AppColors.primaryTextOffWhite, size: 24),
          onPressed: _showAddInjuryModal,
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.white.withValues(alpha: 0.08),
          height: 1,
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED VIEW (Matches HTML & Design)
  // ==========================================
  Widget _buildPopulatedView() {
    final currentList = _currentInjuries;
    final resolvedList = _resolvedInjuries;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Dog Selector
          _buildDogSelectorCard(),
          const SizedBox(height: 24),

          // 2. INJURY SUMMARY Card
          _buildInjurySummaryCard(),
          const SizedBox(height: 24),

          // 3. Search Bar
          _buildSearchBar(),
          const SizedBox(height: 12),

          // 4. Active Filter Pills
          _buildFilterPillsRow(),
          const SizedBox(height: 24),

          // 5. CURRENT INJURIES Section
          if (_selectedStatusFilter != 'Resolved') ...[
            const Text(
              'CURRENT INJURIES',
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            if (currentList.isEmpty)
              _buildEmptySubSection('No active or recovering injuries found.')
            else
              ...currentList.map((injury) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCurrentInjuryCard(injury),
                  )),
            const SizedBox(height: 20),
          ],

          // 6. RESOLVED INJURIES Section
          if (_selectedStatusFilter != 'Active' && _selectedStatusFilter != 'Recovering') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RESOLVED INJURIES',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _seeAllResolved = !_seeAllResolved);
                  },
                  child: Row(
                    children: [
                      Text(
                        _seeAllResolved ? 'Show Less' : 'See All',
                        style: const TextStyle(
                          color: Color(0xFF95D3BB),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _seeAllResolved ? Icons.expand_less : Icons.arrow_forward,
                        size: 14,
                        color: const Color(0xFF95D3BB),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (resolvedList.isEmpty)
              _buildEmptySubSection('No resolved injuries found.')
            else ...[
              ...(_seeAllResolved ? resolvedList : resolvedList.take(2)).map((injury) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildResolvedInjuryCard(injury),
                  )),
            ],
            const SizedBox(height: 24),
          ],

          // 7. Add Injury Button (Primary CTA)
          _buildAddInjuryCTA(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================
  // 1. DOG SELECTOR CARD
  // ==========================================
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSwitcherModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            _buildDogAvatar(_activeDog.avatarUrl, size: 38),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activeDog.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_activeDog.breed} · ${_activeDog.age}',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. INJURY SUMMARY CARD (2x2 Grid)
  // ==========================================
  Widget _buildInjurySummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INJURY SUMMARY',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          // 2x2 Grid with hairline dividers
          Stack(
            children: [
              // Vertical Divider
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Horizontal Divider
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Column(
                children: [
                  // Top Row: Active & Recovering
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedStatusFilter = 'Active');
                          },
                          child: _buildSummaryQuadrant(
                            icon: Icons.healing,
                            value: '$_activeCount',
                            label: 'ACTIVE',
                            isTop: true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedStatusFilter = 'Recovering');
                          },
                          child: _buildSummaryQuadrant(
                            icon: Icons.monitor_heart_outlined,
                            value: '$_recoveringCount',
                            label: 'RECOVERING',
                            isTop: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Bottom Row: Resolved & Avg Recovery
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedStatusFilter = 'Resolved');
                          },
                          child: _buildSummaryQuadrant(
                            icon: Icons.check_circle_outline,
                            value: '$_resolvedCount',
                            label: 'RESOLVED',
                            isTop: false,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedStatusFilter = null);
                          },
                          child: _buildSummaryQuadrant(
                            icon: Icons.schedule,
                            value: _avgRecoveryDays,
                            label: 'AVG RECOVERY',
                            isTop: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryQuadrant({
    required IconData icon,
    required String value,
    required String label,
    required bool isTop,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: isTop ? 8 : 16,
        bottom: isTop ? 16 : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. SEARCH BAR (Zero Underline!)
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _searchFocusNode.hasFocus ? const Color(0xFF95D3BB) : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              cursorColor: const Color(0xFF95D3BB),
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search injuries, body area, diagnosis…',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              child: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 18),
            ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              setState(() {
                if (_searchQuery.isEmpty) {
                  _searchQuery = 'Foreleg';
                  _searchController.text = 'Foreleg';
                } else {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
            child: const Icon(Icons.mic, color: AppColors.secondaryTextStoneGrey, size: 20),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. ACTIVE FILTER PILLS ROW
  // ==========================================
  Widget _buildFilterPillsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // Active Filter Pill with Close
          if (_selectedStatusFilter != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF95D3BB)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedStatusFilter!,
                    style: const TextStyle(
                      color: Color(0xFF95D3BB),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => _selectedStatusFilter = null),
                    child: const Icon(Icons.close, color: Color(0xFF95D3BB), size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          _buildQuickFilterTab('All', isSelected: _selectedStatusFilter == null, onTap: () => setState(() => _selectedStatusFilter = null)),
          const SizedBox(width: 8),
          _buildQuickFilterTab('Active', isSelected: _selectedStatusFilter == 'Active', onTap: () => setState(() => _selectedStatusFilter = 'Active')),
          const SizedBox(width: 8),
          _buildQuickFilterTab('Recovering', isSelected: _selectedStatusFilter == 'Recovering', onTap: () => setState(() => _selectedStatusFilter = 'Recovering')),
          const SizedBox(width: 8),
          _buildQuickFilterTab('Resolved', isSelected: _selectedStatusFilter == 'Resolved', onTap: () => setState(() => _selectedStatusFilter = 'Resolved')),
        ],
      ),
    );
  }

  Widget _buildQuickFilterTab(String label, {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6B57) : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF95D3BB) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 5. CURRENT INJURY CARD (Active & Recovering)
  // ==========================================
  Widget _buildCurrentInjuryCard(InjuryItem injury) {
    final isActive = injury.status == InjuryStatus.active;

    return InkWell(
      onTap: () => _showInjuryDetailsModal(injury),
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
            // Top Row: Title + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    injury.title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B3A3A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cardsCarbon,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF95D3BB)),
                    ),
                    child: const Text(
                      'RECOVERING',
                      style: TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Metadata Row: Body Area, Date, Severity
            Column(
              children: [
                _buildCardMetaRow(Icons.pets_outlined, injury.bodyArea),
                const SizedBox(height: 4),
                _buildCardMetaRow(Icons.calendar_month_outlined, _formatDate(injury.date)),
                if (injury.severity.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildCardMetaRow(Icons.sell_outlined, injury.severity),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Animated Recovery Progress Bar
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: injury.recoveryProgress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, _) {
                final displayPercent = (animValue * 100).toInt();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RECOVERY PROGRESS',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '$displayPercent%',
                          style: const TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: animValue,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF95D3BB),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF95D3BB).withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),

            // Divider & Bottom Stage Tag
            Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    injury.recoveryStage.toUpperCase(),
                    style: TextStyle(
                      color: isActive ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMetaRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
        ),
      ],
    );
  }

  // ==========================================
  // 6. RESOLVED INJURY CARD
  // ==========================================
  Widget _buildResolvedInjuryCard(InjuryItem injury) {
    return InkWell(
      onTap: () => _showInjuryDetailsModal(injury),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          injury.title,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.check_circle, color: AppColors.secondaryTextStoneGrey, size: 18),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${injury.bodyArea} · ${_formatDate(injury.date)}',
                          style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          'RESOLVED',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              // Bottom full green indicator line (from HTML)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: const Color(0xFF95D3BB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySubSection(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
        ),
      ),
    );
  }

  // ==========================================
  // 7. PRIMARY ADD INJURY BUTTON
  // ==========================================
  Widget _buildAddInjuryCTA() {
    return InkWell(
      onTap: _showAddInjuryModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF2E6B57),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFFAAE9D0), size: 20),
            SizedBox(width: 8),
            Text(
              'Add Injury',
              style: TextStyle(
                color: Color(0xFFAAE9D0),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, color: Color(0xFFAAE9D0), size: 18),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE VIEW
  // ==========================================
  Widget _buildEmptyStateView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dog Selector Card
          _buildDogSelectorCard(),
          const SizedBox(height: 80),

          // Central Graphic
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const Icon(
                Icons.healing_outlined,
                size: 36,
                color: Color(0xFF95D3BB),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Heading
          const Text(
            'No Injuries Recorded',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Keep track of acute injuries, chronic flare-ups, and rehabilitation progress to protect your dog\'s athletic longevity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Add First Injury CTA
          Center(
            child: SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6B57),
                  foregroundColor: const Color(0xFFAAE9D0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _showAddInjuryModal,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add First Injury',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Educational Link
          Center(
            child: TextButton(
              onPressed: _showEducationalModal,
              child: const Text(
                'Learn about Injury & Return to Sport',
                style: TextStyle(
                  color: Color(0xFF95D3BB),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  // ==========================================
  // MODALS & ACTIONS (100% ZERO SNACKBARS)
  // ==========================================

  // Dog Switcher Modal
  void _showDogSwitcherModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Dog Profile',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...List.generate(_dogs.length, (index) {
                  final dog = _dogs[index];
                  final isSelected = index == _activeDogIndex;
                  return InkWell(
                    onTap: () {
                      setState(() => _activeDogIndex = index);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2E6B57).withValues(alpha: 0.25) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF95D3BB) : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildDogAvatar(dog.avatarUrl, size: 36),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dog.name,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF95D3BB) : AppColors.primaryTextOffWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${dog.breed} · ${dog.age}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF95D3BB), size: 20),
                        ],
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

  // Injury Details Modal Sheet
  void _showInjuryDetailsModal(InjuryItem injury) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              injury.title,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${injury.bodyArea} · Severity: ${injury.severity}',
                        style: const TextStyle(color: Color(0xFF95D3BB), fontSize: 13),
                      ),
                      const SizedBox(height: 16),

                      _buildDetailRow('Date Identified', _formatDate(injury.date)),
                      _buildDetailRow('Current Status', injury.status.name.toUpperCase()),
                      _buildDetailRow('Recovery Stage', injury.recoveryStage),
                      if (injury.clinic != null) _buildDetailRow('Attending Clinic', injury.clinic!),
                      const SizedBox(height: 12),

                      // Interactive Recovery Progress Slider
                      const Text(
                        'Update Recovery Progress',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: injury.recoveryProgress,
                              min: 0.0,
                              max: 1.0,
                              divisions: 20,
                              activeColor: const Color(0xFF95D3BB),
                              inactiveColor: AppColors.backgroundObsidian,
                              onChanged: (val) {
                                setModalState(() {
                                  injury.recoveryProgress = val;
                                  if (val >= 1.0) {
                                    injury.status = InjuryStatus.resolved;
                                    injury.recoveryStage = 'RESOLVED';
                                  } else if (val >= 0.5) {
                                    injury.status = InjuryStatus.recovering;
                                    injury.recoveryStage = 'REHABILITATION';
                                  } else {
                                    injury.status = InjuryStatus.active;
                                    injury.recoveryStage = 'RESTING';
                                  }
                                });
                                setState(() {});
                              },
                            ),
                          ),
                          Text(
                            '${(injury.recoveryProgress * 100).toInt()}%',
                            style: const TextStyle(color: Color(0xFF95D3BB), fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      const Text('Clinical Diagnosis', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(injury.diagnosisNotes, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                      const SizedBox(height: 12),

                      const Text('Treatment & Rehab Plan', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(injury.treatmentPlan, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                      const SizedBox(height: 24),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFFFB4AB),
                                side: const BorderSide(color: Color(0xFF8B3A3A)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                setState(() {
                                  _injuries.removeWhere((i) => i.id == injury.id);
                                });
                                Navigator.pop(ctx);
                              },
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Delete'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E6B57),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                setState(() {
                                  injury.status = InjuryStatus.resolved;
                                  injury.recoveryProgress = 1.0;
                                  injury.recoveryStage = 'RESOLVED';
                                });
                                Navigator.pop(ctx);
                              },
                              icon: const Icon(Icons.check_circle_outline, size: 18),
                              label: const Text('Mark Resolved'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Add Injury Modal Bottom Sheet
  void _showAddInjuryModal() {
    final titleCtrl = TextEditingController();
    final bodyAreaCtrl = TextEditingController(text: 'Left Foreleg');
    final diagnosisCtrl = TextEditingController();
    final treatmentCtrl = TextEditingController();
    final clinicCtrl = TextEditingController(text: 'City Vets');

    String selectedSeverity = 'Moderate';
    String selectedStage = 'RESTING';
    InjuryStatus selectedStatus = InjuryStatus.active;
    DateTime injuryDate = DateTime.now();

    final bodyAreaChips = ['Left Foreleg', 'Right Foreleg', 'Hip', 'Spine', 'Paw', 'Shoulder', 'Neck', 'Ear'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Injury for ${_activeDog.name}',
                            style: const TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Injury Title
                      TextField(
                        controller: titleCtrl,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          labelText: 'Injury / Condition Name (e.g. Muscle Strain, Cruciate Tear)',
                          labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                          filled: true,
                          fillColor: AppColors.backgroundObsidian,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF95D3BB)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Body Area Chips
                      const Text('Body Area Affected', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: bodyAreaChips.map((area) {
                            final isSel = bodyAreaCtrl.text == area;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(area, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : AppColors.primaryTextOffWhite)),
                                selected: isSel,
                                selectedColor: const Color(0xFF2E6B57),
                                backgroundColor: AppColors.backgroundObsidian,
                                onSelected: (val) {
                                  if (val) setModalState(() => bodyAreaCtrl.text = area);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Severity Selector & Status
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedSeverity,
                              dropdownColor: AppColors.cardsCarbon,
                              style: const TextStyle(color: AppColors.primaryTextOffWhite),
                              decoration: InputDecoration(
                                labelText: 'Severity',
                                labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: ['Mild', 'Moderate', 'Severe'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (val) => setModalState(() => selectedSeverity = val ?? 'Moderate'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<InjuryStatus>(
                              initialValue: selectedStatus,
                              dropdownColor: AppColors.cardsCarbon,
                              style: const TextStyle(color: AppColors.primaryTextOffWhite),
                              decoration: InputDecoration(
                                labelText: 'Initial Status',
                                labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: const [
                                DropdownMenuItem(value: InjuryStatus.active, child: Text('Active')),
                                DropdownMenuItem(value: InjuryStatus.recovering, child: Text('Recovering')),
                                DropdownMenuItem(value: InjuryStatus.resolved, child: Text('Resolved')),
                              ],
                              onChanged: (val) {
                                setModalState(() {
                                  selectedStatus = val ?? InjuryStatus.active;
                                  if (selectedStatus == InjuryStatus.active) selectedStage = 'RESTING';
                                  if (selectedStatus == InjuryStatus.recovering) selectedStage = 'REHABILITATION';
                                  if (selectedStatus == InjuryStatus.resolved) selectedStage = 'RESOLVED';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Date Picker & Clinic
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: injuryDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) setModalState(() => injuryDate = picked);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundObsidian,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDate(injuryDate), style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF95D3BB)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: clinicCtrl,
                              style: const TextStyle(color: AppColors.primaryTextOffWhite),
                              decoration: InputDecoration(
                                labelText: 'Clinic / Vet',
                                labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Diagnosis & Notes
                      TextField(
                        controller: diagnosisCtrl,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          labelText: 'Diagnosis & Clinical Observation',
                          labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                          filled: true,
                          fillColor: AppColors.backgroundObsidian,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Treatment & Rehab Plan
                      TextField(
                        controller: treatmentCtrl,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          labelText: 'Treatment Plan / Prescribed Rest',
                          labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                          filled: true,
                          fillColor: AppColors.backgroundObsidian,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6B57),
                            foregroundColor: const Color(0xFFAAE9D0),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            final finalTitle = titleCtrl.text.trim().isEmpty ? 'Acute Strain' : titleCtrl.text.trim();
                            final finalDiagnosis = diagnosisCtrl.text.trim().isEmpty ? 'Lameness and local soreness.' : diagnosisCtrl.text.trim();
                            final finalTreatment = treatmentCtrl.text.trim().isEmpty ? 'Rest and controlled walks.' : treatmentCtrl.text.trim();

                            final newInjury = InjuryItem(
                              id: 'inj_${DateTime.now().millisecondsSinceEpoch}',
                              title: finalTitle,
                              bodyArea: bodyAreaCtrl.text.trim().isEmpty ? 'Foreleg' : bodyAreaCtrl.text.trim(),
                              date: injuryDate,
                              severity: selectedSeverity,
                              status: selectedStatus,
                              recoveryProgress: selectedStatus == InjuryStatus.resolved ? 1.0 : (selectedStatus == InjuryStatus.recovering ? 0.6 : 0.2),
                              recoveryStage: selectedStage,
                              diagnosisNotes: finalDiagnosis,
                              treatmentPlan: finalTreatment,
                              clinic: clinicCtrl.text.trim().isEmpty ? null : clinicCtrl.text.trim(),
                            );

                            setState(() {
                              _injuries.insert(0, newInjury);
                              _isEmpty = false;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('Save Injury Record', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Filter Preferences Modal
  void _showFilterPreferencesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter & Sort Options',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('INJURY STATUS', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterOptionPill('All Statuses', isSelected: _selectedStatusFilter == null, onTap: () {
                          setModalState(() => _selectedStatusFilter = null);
                          setState(() => _selectedStatusFilter = null);
                        }),
                        _buildFilterOptionPill('Active', isSelected: _selectedStatusFilter == 'Active', onTap: () {
                          setModalState(() => _selectedStatusFilter = 'Active');
                          setState(() => _selectedStatusFilter = 'Active');
                        }),
                        _buildFilterOptionPill('Recovering', isSelected: _selectedStatusFilter == 'Recovering', onTap: () {
                          setModalState(() => _selectedStatusFilter = 'Recovering');
                          setState(() => _selectedStatusFilter = 'Recovering');
                        }),
                        _buildFilterOptionPill('Resolved', isSelected: _selectedStatusFilter == 'Resolved', onTap: () {
                          setModalState(() => _selectedStatusFilter = 'Resolved');
                          setState(() => _selectedStatusFilter = 'Resolved');
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6B57),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOptionPill(String label, {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6B57) : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF95D3BB) : Colors.white.withValues(alpha: 0.1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Educational Modal
  void _showEducationalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Injury Tracking & Longevity',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tracking injuries accurately ensures proper return-to-sport timelines and prevents premature loading of recovering tissues.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                _buildEducationPoint(Icons.healing, 'Log soft-tissue strains, paw lacerations, and orthopedic flare-ups.'),
                _buildEducationPoint(Icons.trending_up, 'Visualize progressive return-to-sport recovery milestones.'),
                _buildEducationPoint(Icons.history, 'Keep a lifetime athletic injury log for veterinary assessments.'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E6B57),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Understood'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEducationPoint(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF95D3BB), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // Crash-proof avatar builder
  Widget _buildDogAvatar(String url, {double size = 36}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2E6B57),
        border: Border.all(color: const Color(0xFF95D3BB), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: const Color(0xFF2E6B57),
            alignment: Alignment.center,
            child: Icon(Icons.pets, color: Colors.white, size: size * 0.5),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    return '$day $month ${dt.year}';
  }
}
