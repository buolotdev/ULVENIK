import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum VaccineStatus { current, dueSoon, overdue, expired }

class VaccineItem {
  final String id;
  String name;
  VaccineStatus status;
  String statusSubtitle;
  DateTime validUntil;
  DateTime administeredDate;
  String? batchNumber;
  String? clinicName;
  String? veterinarian;
  bool isCore;
  IconData icon;

  VaccineItem({
    required this.id,
    required this.name,
    required this.status,
    required this.statusSubtitle,
    required this.validUntil,
    required this.administeredDate,
    this.batchNumber,
    this.clinicName,
    this.veterinarian,
    this.isCore = false,
    required this.icon,
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

class VaccinationManagerScreen extends StatefulWidget {
  final bool initialEmpty;
  const VaccinationManagerScreen({super.key, this.initialEmpty = false});

  @override
  State<VaccinationManagerScreen> createState() => _VaccinationManagerScreenState();
}

class _VaccinationManagerScreenState extends State<VaccinationManagerScreen> {
  late bool _isEmpty;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Current', 'Due Soon', 'Overdue', 'Expired'];

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3y 2m',
      avatarUrl:
          'https://images.unsplash.com/photo-1588943211346-0908a1fb0b01?q=80&w=500&auto=format&fit=crop',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1601633512349-2e1d09e51f89?q=80&w=500&auto=format&fit=crop',
    ),
    DogProfile(
      name: 'Thor',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://images.unsplash.com/photo-1589941013453-ec89f33b5455?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  DogProfile get _activeDog => _dogs[_activeDogIndex];

  late List<VaccineItem> _vaccines;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeVaccines();
  }

  void _initializeVaccines() {
    _vaccines = [
      VaccineItem(
        id: 'vax_1',
        name: 'Bordetella',
        status: VaccineStatus.overdue,
        statusSubtitle: 'Expired 12 days ago (Oct 14, 2023)',
        administeredDate: DateTime(2022, 10, 14),
        validUntil: DateTime(2023, 10, 14),
        clinicName: 'Nordic Veterinary Clinic',
        veterinarian: 'Dr. Stevens',
        batchNumber: 'BOR-2022-881',
        isCore: false,
        icon: Icons.event_busy,
      ),
      VaccineItem(
        id: 'vax_2',
        name: 'Leptospirosis',
        status: VaccineStatus.dueSoon,
        statusSubtitle: 'Due in 18 days (Nov 15, 2023)',
        administeredDate: DateTime(2022, 11, 15),
        validUntil: DateTime(2023, 11, 15),
        clinicName: 'Alpine Veterinary Care',
        veterinarian: 'Dr. Lindqvist',
        batchNumber: 'LEP-2022-410',
        isCore: false,
        icon: Icons.notifications_active,
      ),
      VaccineItem(
        id: 'vax_3',
        name: 'DHPPi (Core)',
        status: VaccineStatus.current,
        statusSubtitle: 'Valid until May 2026',
        administeredDate: DateTime(2023, 5, 20),
        validUntil: DateTime(2026, 5, 20),
        clinicName: 'Stockholm Animal Hospital',
        veterinarian: 'Dr. Holm',
        batchNumber: 'DHP-2023-102',
        isCore: true,
        icon: Icons.vaccines,
      ),
      VaccineItem(
        id: 'vax_4',
        name: 'Rabies',
        status: VaccineStatus.current,
        statusSubtitle: 'Valid until Aug 2025',
        administeredDate: DateTime(2022, 8, 10),
        validUntil: DateTime(2025, 8, 10),
        clinicName: 'Stockholm Animal Hospital',
        veterinarian: 'Dr. Holm',
        batchNumber: 'RAB-2022-771',
        isCore: true,
        icon: Icons.verified,
      ),
      VaccineItem(
        id: 'vax_5',
        name: 'Lungworm Prevention',
        status: VaccineStatus.current,
        statusSubtitle: 'Valid until Dec 2023',
        administeredDate: DateTime(2023, 6, 1),
        validUntil: DateTime(2023, 12, 1),
        clinicName: 'Nordic Veterinary Clinic',
        veterinarian: 'Dr. Stevens',
        batchNumber: 'LNG-2023-339',
        isCore: false,
        icon: Icons.bug_report,
      ),
    ];
  }

  // Dynamic Metrics
  int get _currentCount => _vaccines.where((v) => v.status == VaccineStatus.current).length;
  int get _dueSoonCount => _vaccines.where((v) => v.status == VaccineStatus.dueSoon).length;
  int get _overdueCount => _vaccines.where((v) => v.status == VaccineStatus.overdue).length;
  int get _lifetimeCount => _vaccines.length + (_isEmpty ? 0 : 1); // includes past archived booster

  // Overdue Hero item
  VaccineItem? get _overdueHeroItem {
    final overdueList = _vaccines.where((v) => v.status == VaccineStatus.overdue).toList();
    return overdueList.isNotEmpty ? overdueList.first : null;
  }

  List<VaccineItem> get _filteredVaccines {
    var list = _vaccines;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((v) {
        return v.name.toLowerCase().contains(query) ||
            (v.clinicName?.toLowerCase().contains(query) ?? false) ||
            (v.batchNumber?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_selectedFilter == 'Current') {
      return list.where((v) => v.status == VaccineStatus.current).toList();
    } else if (_selectedFilter == 'Due Soon') {
      return list.where((v) => v.status == VaccineStatus.dueSoon).toList();
    } else if (_selectedFilter == 'Overdue') {
      return list.where((v) => v.status == VaccineStatus.overdue).toList();
    } else if (_selectedFilter == 'Expired') {
      return list.where((v) => v.status == VaccineStatus.overdue || v.status == VaccineStatus.expired).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_isSearching) _buildDedicatedSearchHeader(),
          Expanded(
            child: _isEmpty ? _buildEmptyStateView() : _buildPopulatedView(),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  // ==========================================
  // DEDICATED SEARCH BAR FORM
  // ==========================================
  Widget _buildDedicatedSearchHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundObsidian,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dedicated Search Form Container
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F22),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF95D3BB).withValues(alpha: 0.4),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search,
                  color: Color(0xFF95D3BB),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    cursorColor: const Color(0xFF95D3BB),
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search vaccines, clinic, lot number...',
                      hintStyle: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E6B57).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF95D3BB).withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found ${_filteredVaccines.length} ${_filteredVaccines.length == 1 ? 'record' : 'records'} for "$_searchQuery"',
                    style: const TextStyle(
                      color: Color(0xFFAAE9D0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // APP BAR
  // ==========================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey, size: 24),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text(
        'Vaccination Manager',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      actions: [
        // Search icon toggle
        IconButton(
          tooltip: _isSearching ? 'Close Search' : 'Search Vaccines',
          icon: Icon(
            _isSearching ? Icons.search_off : Icons.search,
            color: _isSearching ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _searchQuery = '';
              }
            });
          },
        ),
        // Filter modal
        IconButton(
          tooltip: 'Filters & Preferences',
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 24),
          onPressed: _showFilterPreferencesModal,
        ),
        // Quick State Toggle (Populated / Empty)
        IconButton(
          tooltip: _isEmpty ? 'Switch to Populated' : 'Switch to Empty',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : const Color(0xFF95D3BB),
            size: 26,
          ),
          onPressed: () {
            setState(() => _isEmpty = !_isEmpty);
          },
        ),
        // Add Button
        IconButton(
          tooltip: 'Add Vaccination',
          icon: const Icon(Icons.add_circle, color: Color(0xFF95D3BB), size: 26),
          onPressed: _showAddVaccineModal,
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
  // POPULATED VIEW
  // ==========================================
  Widget _buildPopulatedView() {
    final overdueList = _filteredVaccines.where((v) => v.status == VaccineStatus.overdue).toList();
    final dueSoonList = _filteredVaccines.where((v) => v.status == VaccineStatus.dueSoon).toList();
    final currentList = _filteredVaccines.where((v) => v.status == VaccineStatus.current).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDogSelectorCard(),
          const SizedBox(height: 20),
          _buildSummaryGrid(),
          const SizedBox(height: 20),
          if (_overdueHeroItem != null && (_selectedFilter == 'All' || _selectedFilter == 'Overdue')) ...[
            _buildOverdueAlertStrip(_overdueHeroItem!),
            const SizedBox(height: 20),
          ],
          _buildFilterTabs(),
          const SizedBox(height: 24),

          // OVERDUE SECTION
          if (overdueList.isNotEmpty) ...[
            _buildSectionHeader('Overdue', isOverdue: true),
            const SizedBox(height: 12),
            ...overdueList.map((vax) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildVaccineCard(vax),
                )),
            const SizedBox(height: 20),
          ],

          // DUE SOON SECTION
          if (dueSoonList.isNotEmpty) ...[
            _buildSectionHeader('Due Soon'),
            const SizedBox(height: 12),
            ...dueSoonList.map((vax) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildVaccineCard(vax),
                )),
            const SizedBox(height: 20),
          ],

          // CURRENT SECTION
          if (currentList.isNotEmpty) ...[
            _buildSectionHeader('Current'),
            const SizedBox(height: 12),
            ...currentList.map((vax) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildVaccineCard(vax),
                )),
          ],

          if (overdueList.isEmpty && dueSoonList.isEmpty && currentList.isEmpty)
            _buildNoMatchingFilterState(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ==========================================
  // EMPTY STATE VIEW (Matches Image 2)
  // ==========================================
  Widget _buildEmptyStateView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Horizontal dog avatar selector strip (from Image 2)
          _buildEmptyDogAvatarStrip(),
          const SizedBox(height: 24),
          _buildEmptySummaryCard(),
          const SizedBox(height: 48),
          _buildEmptyPlaceholderContent(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyDogAvatarStrip() {
    return Row(
      children: [
        // Dog 1: Koda
        _buildDogAvatarCircle(
          isSelected: _activeDogIndex == 0,
          name: 'Koda',
          avatarUrl: _dogs[0].avatarUrl,
          onTap: () => setState(() => _activeDogIndex = 0),
        ),
        const SizedBox(width: 16),
        // Dog 2: Luna
        _buildDogAvatarCircle(
          isSelected: _activeDogIndex == 1,
          name: 'Luna',
          avatarUrl: _dogs[1].avatarUrl,
          onTap: () => setState(() => _activeDogIndex = 1),
        ),
        const SizedBox(width: 16),
        // Add Dog Circle
        InkWell(
          onTap: _showAddDogPrompt,
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardsCarbon,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: const Icon(Icons.add, color: AppColors.secondaryTextStoneGrey, size: 24),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDogAvatarCircle({
    required bool isSelected,
    required String name,
    required String avatarUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF2E6B57) : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF2E6B57),
                  child: const Icon(Icons.pets, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              color: isSelected ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildEmptyBentoMetric(Icons.vaccines_outlined, '0', 'TOTAL')),
          Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.08)),
          Expanded(child: _buildEmptyBentoMetric(Icons.calendar_month_outlined, '0', 'UPCOMING')),
          Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.08)),
          Expanded(child: _buildEmptyBentoMetric(Icons.history_outlined, '0', 'EXPIRED')),
          Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.08)),
          Expanded(child: _buildEmptyBentoMetric(Icons.warning_amber_rounded, '0', 'ALERTS')),
        ],
      ),
    );
  }

  Widget _buildEmptyBentoMetric(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 16),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholderContent() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: Color(0xFF95D3BB),
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No Vaccinations Recorded',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Keep ${_activeDog.name}\'s vaccination history organised in one place. Add records to ensure they are always ready for training, trials, and travel.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 28),
        InkWell(
          onTap: _showAddVaccineModal,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2E6B57),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E6B57).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.vaccines_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Add Vaccination',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: _showLearnModal,
          child: const Text(
            'Learn about Vaccination Manager',
            style: TextStyle(
              color: Color(0xFF95D3BB),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF95D3BB),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // DOG SELECTOR CARD (POPULATED)
  // ==========================================
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSwitcherModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                _activeDog.avatarUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 44,
                  height: 44,
                  color: const Color(0xFF2E6B57),
                  child: const Icon(Icons.pets, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activeDog.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_activeDog.breed} • ${_activeDog.age}',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.unfold_more, color: AppColors.secondaryTextStoneGrey, size: 22),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SUMMARY GRID (4 COLUMNS)
  // ==========================================
  Widget _buildSummaryGrid() {
    return Row(
      children: [
        // Current
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.health_and_safety_outlined,
            count: '$_currentCount',
            label: 'Current',
            iconColor: const Color(0xFF95D3BB),
          ),
        ),
        const SizedBox(width: 8),
        // Due Soon
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.notifications_outlined,
            count: '$_dueSoonCount',
            label: 'Due Soon',
          ),
        ),
        const SizedBox(width: 8),
        // Overdue (Highlight red)
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.warning_amber_rounded,
            count: '$_overdueCount',
            label: 'Overdue',
            hasRedStrip: _overdueCount > 0,
            countColor: _overdueCount > 0 ? const Color(0xFFFFB4AB) : null,
            labelColor: _overdueCount > 0 ? const Color(0xFFFFB4AB) : null,
            iconColor: _overdueCount > 0 ? const Color(0xFFFFB4AB) : null,
            borderColor: _overdueCount > 0 ? const Color(0xFF8B3A3A) : null,
          ),
        ),
        const SizedBox(width: 8),
        // Lifetime
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.calendar_month_outlined,
            count: '$_lifetimeCount',
            label: 'Lifetime',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCardItem({
    required IconData icon,
    required String count,
    required String label,
    Color? iconColor,
    Color? countColor,
    Color? labelColor,
    Color? borderColor,
    bool hasRedStrip = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: borderColor ?? Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          children: [
            if (hasRedStrip)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  color: const Color(0xFF8B3A3A),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: iconColor ?? AppColors.secondaryTextStoneGrey, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      count,
                      style: TextStyle(
                        color: countColor ?? AppColors.primaryTextOffWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        color: labelColor ?? AppColors.secondaryTextStoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
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

  // ==========================================
  // OVERDUE ALERT HERO STRIP
  // ==========================================
  Widget _buildOverdueAlertStrip(VaccineItem vax) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                color: const Color(0xFF8B3A3A),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
              children: [
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OVERDUE ACTION REQUIRED',
                        style: TextStyle(
                          color: Color(0xFFFFB4AB),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vax.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vax.statusSubtitle,
                        style: const TextStyle(
                          color: Color(0xFFFFB4AB),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6B57),
                    foregroundColor: const Color(0xFF95D3BB),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showRenewModal(vax),
                  child: const Text(
                    'Renew Now',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  // ==========================================
  // FILTER TABS (PILLS)
  // ==========================================
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedFilter = filter);
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E6B57) : AppColors.cardsCarbon,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryTextOffWhite,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // VACCINE CARD
  // ==========================================
  Widget _buildSectionHeader(String title, {bool isOverdue = false}) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: isOverdue ? const Color(0xFFFFB4AB) : AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildVaccineCard(VaccineItem vax) {
    Color iconCircleBg;
    Color iconColor;
    Border? iconBorder;
    bool hasRedStrip = vax.status == VaccineStatus.overdue;

    if (vax.status == VaccineStatus.overdue) {
      iconCircleBg = AppColors.backgroundObsidian;
      iconColor = const Color(0xFFFFB4AB);
      iconBorder = Border.all(color: const Color(0xFF8B3A3A));
    } else if (vax.status == VaccineStatus.dueSoon) {
      iconCircleBg = AppColors.backgroundObsidian;
      iconColor = const Color(0xFF95D3BB);
      iconBorder = Border.all(color: const Color(0xFF2E6B57));
    } else {
      iconCircleBg = const Color(0xFF2E6B57);
      iconColor = Colors.white;
      iconBorder = Border.all(color: const Color(0xFF2E6B57));
    }

    return InkWell(
      onTap: () => _showVaccineDetailsModal(vax),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(
            children: [
              if (hasRedStrip)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: const Color(0xFF8B3A3A),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconCircleBg,
                      border: iconBorder,
                    ),
                    child: Icon(vax.icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vax.name,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vax.statusSubtitle,
                          style: TextStyle(
                            color: vax.status == VaccineStatus.overdue
                                ? const Color(0xFFFFB4AB)
                                : AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildNoMatchingFilterState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.vaccines_outlined, size: 36, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No vaccines matching "$_searchQuery"'
                  : 'No $_selectedFilter records',
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try searching by a different name, clinic, or lot number.'
                  : 'Try selecting another filter above.',
              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF95D3BB),
                  backgroundColor: const Color(0xFF1A1F22),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: const Color(0xFF95D3BB).withValues(alpha: 0.4)),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Reset Search', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF2E6B57),
      elevation: 4,
      onPressed: _showAddVaccineModal,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  // ==========================================
  // MODALS & ACTIONS (NO SNACKBARS!)
  // ==========================================

  /// Renew Modal (Triggered by "Renew Now" on overdue alert)
  void _showRenewModal(VaccineItem vax) {
    DateTime renewDate = DateTime.now();
    final batchCtrl = TextEditingController(text: '${vax.name.substring(0, 3).toUpperCase()}-2024-991');
    final clinicCtrl = TextEditingController(text: vax.clinicName ?? 'Nordic Veterinary Clinic');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Renew ${vax.name}',
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
              const SizedBox(height: 16),
              TextField(
                controller: batchCtrl,
                style: const TextStyle(color: AppColors.primaryTextOffWhite),
                decoration: InputDecoration(
                  labelText: 'Lot / Batch Number',
                  labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                  filled: true,
                  fillColor: AppColors.cardsCarbon,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: clinicCtrl,
                style: const TextStyle(color: AppColors.primaryTextOffWhite),
                decoration: InputDecoration(
                  labelText: 'Clinic / Hospital',
                  labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                  filled: true,
                  fillColor: AppColors.cardsCarbon,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6B57).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2E6B57).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: Color(0xFF95D3BB), size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Will update status to Current and set validity to +1 year.',
                        style: TextStyle(color: Color(0xFF95D3BB), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6B57),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    setState(() {
                      vax.status = VaccineStatus.current;
                      vax.administeredDate = renewDate;
                      vax.validUntil = DateTime(renewDate.year + 1, renewDate.month, renewDate.day);
                      vax.statusSubtitle = 'Valid until ${_formatMonthYear(vax.validUntil)}';
                      vax.batchNumber = batchCtrl.text.trim();
                      vax.clinicName = clinicCtrl.text.trim();
                      vax.icon = Icons.health_and_safety_outlined;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Confirm Renewal', style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Add Vaccination Record Modal
  void _showAddVaccineModal() {
    final nameCtrl = TextEditingController();
    final clinicCtrl = TextEditingController(text: 'Nordic Veterinary Clinic');
    final batchCtrl = TextEditingController();
    bool isCoreVaccine = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
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
                          'Add Vaccine for ${_activeDog.name}',
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      decoration: InputDecoration(
                        labelText: 'Vaccine Name (e.g. Rabies, DHPPi, Lyme)',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: clinicCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      decoration: InputDecoration(
                        labelText: 'Veterinary Clinic',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: batchCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      decoration: InputDecoration(
                        labelText: 'Batch / Lot Number (optional)',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Core / Non-Core Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Core Vaccine (Required)',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Switch(
                          value: isCoreVaccine,
                          activeThumbColor: const Color(0xFF95D3BB),
                          activeTrackColor: const Color(0xFF2E6B57),
                          onChanged: (val) => setModalState(() => isCoreVaccine = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6B57),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (nameCtrl.text.trim().isEmpty) return;
                          final now = DateTime.now();
                          final newVax = VaccineItem(
                            id: 'vax_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            status: VaccineStatus.current,
                            statusSubtitle: 'Valid until ${_formatMonthYear(DateTime(now.year + 1, now.month, now.day))}',
                            administeredDate: now,
                            validUntil: DateTime(now.year + 1, now.month, now.day),
                            clinicName: clinicCtrl.text.trim(),
                            batchNumber: batchCtrl.text.trim().isEmpty ? 'N/A' : batchCtrl.text.trim(),
                            isCore: isCoreVaccine,
                            icon: isCoreVaccine ? Icons.verified : Icons.vaccines,
                          );

                          setState(() {
                            _vaccines.insert(0, newVax);
                            _isEmpty = false;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Save Vaccination', style: TextStyle(color: Colors.white, fontSize: 15)),
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

  /// Vaccine Details Modal
  void _showVaccineDetailsModal(VaccineItem vax) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vax.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 20,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Status', vax.status.name.toUpperCase()),
                    const SizedBox(height: 8),
                    _buildDetailRow('Validity', vax.statusSubtitle),
                    const SizedBox(height: 8),
                    _buildDetailRow('Type', vax.isCore ? 'Core Protection' : 'Lifestyle / Regional'),
                    if (vax.clinicName != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow('Clinic', vax.clinicName!),
                    ],
                    if (vax.veterinarian != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow('Veterinarian', vax.veterinarian!),
                    ],
                    if (vax.batchNumber != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow('Lot / Batch', vax.batchNumber!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      onPressed: () {
                        setState(() {
                          _vaccines.removeWhere((v) => v.id == vax.id);
                          if (_vaccines.isEmpty) _isEmpty = true;
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6B57),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                      label: const Text('Renew Dose', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showRenewModal(vax);
                      },
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
        Text(value, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// Dog Switcher Modal
  void _showDogSwitcherModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Dog',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(_dogs.length, (i) {
                final dog = _dogs[i];
                final isSelected = i == _activeDogIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() => _activeDogIndex = i);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2E6B57).withValues(alpha: 0.15)
                            : AppColors.cardsCarbon,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              dog.avatarUrl,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 36,
                                height: 36,
                                color: const Color(0xFF2E6B57),
                                child: const Icon(Icons.pets, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
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
                                  ),
                                ),
                                Text(
                                  '${dog.breed} • ${dog.age}',
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Color(0xFF95D3BB), size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAddDogPrompt() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Dog', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text('To register another canine, navigate to the Dogs tab and select Add Dog.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E6B57)),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Understood', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Filter & Preferences Modal
  void _showFilterPreferencesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Vaccination Preferences',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('STATE VIEW', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() => _isEmpty = false);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !_isEmpty ? const Color(0xFF2E6B57).withValues(alpha: 0.2) : AppColors.cardsCarbon,
                          border: Border.all(color: !_isEmpty ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Populated State',
                          style: TextStyle(color: !_isEmpty ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() => _isEmpty = true);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isEmpty ? const Color(0xFF2E6B57).withValues(alpha: 0.2) : AppColors.cardsCarbon,
                          border: Border.all(color: _isEmpty ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Empty State',
                          style: TextStyle(color: _isEmpty ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey),
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

  /// Educational Guide Modal (Learn about Vaccination Manager)
  void _showLearnModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Canine Vaccination Protocol',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGuideSection(
                  '1. Core vs Non-Core Vaccines',
                  'Core vaccines (DHPPi, Rabies) are medically essential for all dogs. Non-core vaccines (Bordetella, Leptospirosis, Lyme) depend on exposure risk in trial grounds and forested habitats.',
                ),
                const SizedBox(height: 12),
                _buildGuideSection(
                  '2. Titer Testing Options',
                  'For seasoned working dogs, serological antibody titers can be recorded to confirm adequate immunity before administering unnecessary annual booster revaccinations.',
                ),
                const SizedBox(height: 12),
                _buildGuideSection(
                  '3. Trial & Travel Certification',
                  'Major working trials and international travel require strict rabies titers and non-expired certificates. Keep lot numbers documented for inspection.',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E6B57),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Got It', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuideSection(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF95D3BB), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  String _formatMonthYear(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}
