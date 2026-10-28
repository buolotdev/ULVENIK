import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MedicationStatus { active, paused, completed, expired }

class MedicationItem {
  final String id;
  String name;
  String dosage;
  String form;
  String frequency;
  String nextDoseDisplay;
  MedicationStatus status;
  String? notes;
  IconData icon;
  int missedCount;

  MedicationItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.frequency,
    required this.nextDoseDisplay,
    required this.status,
    this.notes,
    required this.icon,
    this.missedCount = 0,
  });
}

class DogProfile {
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String avatarUrl;

  const DogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.avatarUrl,
  });
}

class MedicationManagerScreen extends StatefulWidget {
  final bool initialEmpty;
  const MedicationManagerScreen({super.key, this.initialEmpty = false});

  @override
  State<MedicationManagerScreen> createState() => _MedicationManagerScreenState();
}

class _MedicationManagerScreenState extends State<MedicationManagerScreen> {
  late bool _isEmpty;
  String _selectedFilter = 'All';
  final List<String> _filterTabs = ['All', 'Active', 'Paused', 'Completed', 'Expired'];

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3 yrs',
      weight: '28.4 kg',
      avatarUrl:
          'https://images.unsplash.com/photo-1588943211346-0908a1fb0b01?q=80&w=500&auto=format&fit=crop',
    ),
    DogProfile(
      name: 'Luna',
      breed: 'Border Collie',
      age: '2 yrs',
      weight: '18.0 kg',
      avatarUrl:
          'https://images.unsplash.com/photo-1601633512349-2e1d09e51f89?q=80&w=500&auto=format&fit=crop',
    ),
    DogProfile(
      name: 'Thor',
      breed: 'German Shepherd',
      age: '4 yrs',
      weight: '34.0 kg',
      avatarUrl:
          'https://images.unsplash.com/photo-1589941013453-ec89f33b5455?q=80&w=500&auto=format&fit=crop',
    ),
  ];

  DogProfile get _activeDog => _dogs[_activeDogIndex];

  late List<MedicationItem> _medications;

  // Next dose hero medication
  MedicationItem? get _nextDoseItem {
    final active = _medications.where((m) => m.status == MedicationStatus.active).toList();
    return active.isNotEmpty ? active.first : null;
  }

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeMedications();
  }

  void _initializeMedications() {
    _medications = [
      MedicationItem(
        id: 'med_1',
        name: 'Metacam',
        dosage: '1.5mg',
        form: 'Oral Suspension',
        frequency: 'Once daily',
        nextDoseDisplay: 'Today, 08:00 AM',
        status: MedicationStatus.active,
        icon: Icons.vaccines_outlined,
        notes: 'Administer with morning meal to prevent stomach sensitivity.',
      ),
      MedicationItem(
        id: 'med_2',
        name: 'Omega-3 Fish Oil',
        dosage: '1000mg',
        form: 'Gel Capsule',
        frequency: 'With dinner',
        nextDoseDisplay: 'Today, 06:00 PM',
        status: MedicationStatus.active,
        icon: Icons.water_drop_outlined,
        notes: 'Supports healthy skin, dense coat, and joint lubrication.',
      ),
      MedicationItem(
        id: 'med_3',
        name: 'Apoquel',
        dosage: '5.4mg',
        form: 'Tablet',
        frequency: 'Once daily',
        nextDoseDisplay: 'Paused',
        status: MedicationStatus.paused,
        icon: Icons.healing_outlined,
        notes: 'Seasonal allergy relief. Paused during low-pollen months.',
      ),
      MedicationItem(
        id: 'med_4',
        name: 'Metronidazole',
        dosage: '250mg',
        form: 'Tablet',
        frequency: 'Completed',
        nextDoseDisplay: 'Completed 2 days ago',
        status: MedicationStatus.completed,
        icon: Icons.medication_outlined,
        notes: '10-day antibiotic course completed successfully.',
      ),
    ];
  }

  // Counters
  int get _activeCount => _medications.where((m) => m.status == MedicationStatus.active).length;
  int get _upcomingCount => _activeCount > 0 ? 3 : 0;
  int get _missedCount => _isEmpty ? 0 : 1;
  int get _completedCount => _medications.where((m) => m.status == MedicationStatus.completed).length;

  List<MedicationItem> get _filteredMedications {
    var list = _medications;

    if (_searchQuery.isNotEmpty) {
      list = list.where((m) {
        final query = _searchQuery.toLowerCase();
        return m.name.toLowerCase().contains(query) ||
            m.form.toLowerCase().contains(query) ||
            m.dosage.toLowerCase().contains(query);
      }).toList();
    }

    if (_selectedFilter == 'Active') {
      return list.where((m) => m.status == MedicationStatus.active).toList();
    } else if (_selectedFilter == 'Paused') {
      return list.where((m) => m.status == MedicationStatus.paused).toList();
    } else if (_selectedFilter == 'Completed') {
      return list.where((m) => m.status == MedicationStatus.completed).toList();
    } else if (_selectedFilter == 'Expired') {
      return list.where((m) => m.status == MedicationStatus.expired).toList();
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
      body: _isEmpty ? _buildEmptyStateView() : _buildPopulatedView(),
      floatingActionButton: _buildFab(),
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
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Search medications...',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 15),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
            )
          : const Text(
              'Medication Manager',
              style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
      actions: [
        // Search Toggle
        IconButton(
          tooltip: _isSearching ? 'Close Search' : 'Search Medications',
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: AppColors.secondaryTextStoneGrey,
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
        // Filter & Sort modal
        IconButton(
          tooltip: 'Filters & Preferences',
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 24),
          onPressed: _showFilterPreferencesModal,
        ),
        // Empty / Populated Toggle
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
        // Add button
        IconButton(
          tooltip: 'Add Medication',
          icon: const Icon(Icons.add_circle, color: Color(0xFF95D3BB), size: 26),
          onPressed: _showAddMedicationModal,
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
    final activeMeds = _filteredMedications.where((m) => m.status == MedicationStatus.active).toList();
    final pausedMeds = _filteredMedications.where((m) => m.status == MedicationStatus.paused).toList();
    final completedMeds =
        _filteredMedications.where((m) => m.status == MedicationStatus.completed).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDogSelector(),
          const SizedBox(height: 20),
          _buildMedicationOverviewGrid(),
          const SizedBox(height: 20),
          if (_nextDoseItem != null && (_selectedFilter == 'All' || _selectedFilter == 'Active')) ...[
            _buildNextDoseBanner(_nextDoseItem!),
            const SizedBox(height: 20),
          ],
          _buildFilterPills(),
          const SizedBox(height: 20),

          // Active Section
          if (activeMeds.isNotEmpty) ...[
            _buildSectionHeader('ACTIVE'),
            const SizedBox(height: 10),
            ...activeMeds.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildActiveMedicationCard(med),
                )),
            const SizedBox(height: 16),
          ],

          // Paused Section
          if (pausedMeds.isNotEmpty) ...[
            _buildSectionHeader('PAUSED'),
            const SizedBox(height: 10),
            ...pausedMeds.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPausedMedicationCard(med),
                )),
            const SizedBox(height: 16),
          ],

          // Completed Section
          if (completedMeds.isNotEmpty) ...[
            _buildSectionHeader('COMPLETED'),
            const SizedBox(height: 10),
            ...completedMeds.map((med) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCompletedMedicationCard(med),
                )),
          ],

          if (activeMeds.isEmpty && pausedMeds.isEmpty && completedMeds.isEmpty)
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
          _buildDogSelector(),
          const SizedBox(height: 20),
          _buildEmptyOverviewGrid(),
          const SizedBox(height: 48),
          _buildEmptyPlaceholderContent(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyOverviewGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MEDICATION OVERVIEW',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildEmptyStatBox('0', 'Active')),
              const SizedBox(width: 8),
              Expanded(child: _buildEmptyStatBox('0', 'Upcoming')),
              const SizedBox(width: 8),
              Expanded(child: _buildEmptyStatBox('0', 'Missed')),
              const SizedBox(width: 8),
              Expanded(child: _buildEmptyStatBox('0', 'Completed')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStatBox(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
            Icons.medication_outlined,
            color: Color(0xFF95D3BB),
            size: 30,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No Medications',
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
            '${_activeDog.name}\'s medications will appear here. Add a medication to track dosages, schedules and reminders in one place.',
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
          onTap: _showAddMedicationModal,
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
                Icon(Icons.medication_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Add Medication',
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
            'Learn about Medication Manager',
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
  // DOG SELECTOR CARD
  // ==========================================
  Widget _buildDogSelector() {
    return InkWell(
      onTap: _showDogSwitcherModal,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E6B57), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _activeDog.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF2E6B57),
                    child: const Icon(Icons.pets, color: Colors.white, size: 20),
                  ),
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
                    '${_activeDog.breed} · ${_activeDog.age}',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // MEDICATION OVERVIEW GRID
  // ==========================================
  Widget _buildMedicationOverviewGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MEDICATION OVERVIEW',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildOverviewMetricItem(
                  icon: Icons.medication_outlined,
                  count: '$_activeCount',
                  label: 'ACTIVE',
                ),
              ),
              Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildOverviewMetricItem(
                  icon: Icons.schedule_outlined,
                  count: '$_upcomingCount',
                  label: 'UPCOMING',
                ),
              ),
              Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildOverviewMetricItem(
                  icon: Icons.warning_amber_rounded,
                  count: '$_missedCount',
                  label: 'MISSED',
                  countColor: const Color(0xFFFFB4AB),
                  labelColor: const Color(0xFFFFB4AB),
                  iconColor: const Color(0xFFFFB4AB),
                ),
              ),
              Container(width: 1, height: 48, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildOverviewMetricItem(
                  icon: Icons.check_circle_outline,
                  count: '$_completedCount',
                  label: 'COMPLETED',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetricItem({
    required IconData icon,
    required String count,
    required String label,
    Color? countColor,
    Color? labelColor,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.secondaryTextStoneGrey, size: 16),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            color: countColor ?? AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: labelColor ?? AppColors.secondaryTextStoneGrey,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // NEXT DOSE HERO BANNER
  // ==========================================
  Widget _buildNextDoseBanner(MedicationItem med) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Left Green Accent Line
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF2E6B57),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E6B57).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFF95D3BB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEXT DOSE',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${med.name} ${med.dosage}',
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Due in 2 hours · 08:00 AM',
                        style: TextStyle(
                          color: Color(0xFF95D3BB),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _showRecordDoseModal(med),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const Text(
                      'Record Dose',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  // ==========================================
  // FILTER PILLS
  // ==========================================
  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filterTabs.map((tab) {
          final isSelected = tab == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedFilter = tab);
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2E6B57).withValues(alpha: 0.18)
                      : AppColors.cardsCarbon,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2E6B57)
                        : Colors.white.withValues(alpha: 0.08),
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
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
  // MEDICATION CARDS (ACTIVE, PAUSED, COMPLETED)
  // ==========================================
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildActiveMedicationCard(MedicationItem med) {
    return InkWell(
      onTap: () => _showMedicationDetailsModal(med),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Top Row
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(med.icon, color: AppColors.secondaryTextStoneGrey, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${med.dosage} · ${med.form}',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E6B57).withValues(alpha: 0.15),
                    border: Border.all(color: const Color(0xFF2E6B57).withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ACTIVE',
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
            const SizedBox(height: 14),
            // Info Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FREQUENCY',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        med.frequency,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEXT DOSE',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        med.nextDoseDisplay,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            ),
            // Actions Row
            Row(
              children: [
                InkWell(
                  onTap: () => _showRecordDoseModal(med),
                  child: Row(
                    children: const [
                      Icon(Icons.check, color: Color(0xFF95D3BB), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Record Dose',
                        style: TextStyle(
                          color: Color(0xFF95D3BB),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                InkWell(
                  onTap: () => _showSkipDoseModal(med),
                  child: Row(
                    children: const [
                      Icon(Icons.block, color: AppColors.secondaryTextStoneGrey, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Skip Dose',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPausedMedicationCard(MedicationItem med) {
    return InkWell(
      onTap: () => _showMedicationDetailsModal(med),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(med.icon, color: AppColors.secondaryTextStoneGrey, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${med.dosage} · ${med.form}',
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PAUSED',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      med.status = MedicationStatus.active;
                      med.nextDoseDisplay = 'Today, 08:00 AM';
                    });
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.play_arrow, color: AppColors.primaryTextOffWhite, size: 17),
                      SizedBox(width: 6),
                      Text(
                        'Resume',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                InkWell(
                  onTap: () {
                    setState(() {
                      med.status = MedicationStatus.completed;
                      med.nextDoseDisplay = 'Discontinued';
                    });
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.stop, color: AppColors.secondaryTextStoneGrey, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Stop Medication',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedMedicationCard(MedicationItem med) {
    return InkWell(
      onTap: () => _showMedicationDetailsModal(med),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon.withValues(alpha: 0.6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.archive_outlined, color: AppColors.secondaryTextStoneGrey, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    med.nextDoseDisplay,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'COMPLETED',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
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
            const Icon(Icons.medication_outlined, size: 36, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(height: 12),
            Text(
              'No $_selectedFilter medications',
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try changing your filter above to view other records.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF2E6B57),
      elevation: 4,
      onPressed: _showAddMedicationModal,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  // ==========================================
  // MODALS & DIALOGS (NO SNACKBARS!)
  // ==========================================

  /// Record Dose Modal
  void _showRecordDoseModal(MedicationItem med) {
    final noteController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Record Dose: ${med.name}',
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
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardsCarbon,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.medication_liquid_outlined, color: Color(0xFF95D3BB), size: 22),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${med.name} ${med.dosage}',
                              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              med.form,
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Time Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ADMINISTERED TIME',
                        style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF95D3BB)),
                        icon: const Icon(Icons.schedule, size: 16),
                        label: Text(selectedTime.format(context)),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null) {
                            setModalState(() => selectedTime = picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Notes (optional, e.g. given with dinner)',
                      hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.cardsCarbon,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                          med.nextDoseDisplay = 'Tomorrow, 08:00 AM';
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Confirm Dose', style: TextStyle(color: Colors.white, fontSize: 15)),
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

  /// Skip Dose Modal
  void _showSkipDoseModal(MedicationItem med) {
    String selectedReason = 'Dog refused meal';
    final reasons = ['Dog refused meal', 'Per veterinary advice', 'Digestive sensitivity / vomited', 'Travel delay', 'Other'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Skip Dose: ${med.name}',
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
                  const Text(
                    'REASON FOR SKIPPING',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...reasons.map((r) {
                    final isSelected = r == selectedReason;
                    return InkWell(
                      onTap: () => setModalState(() => selectedReason = r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2E6B57).withValues(alpha: 0.15)
                              : AppColors.cardsCarbon,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? const Color(0xFF95D3BB) : AppColors.secondaryTextStoneGrey,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              r,
                              style: TextStyle(
                                color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B3A3A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {
                          med.nextDoseDisplay = 'Tomorrow, 08:00 AM';
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Confirm Skip', style: TextStyle(color: Colors.white, fontSize: 14)),
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

  /// Add Medication Modal
  void _showAddMedicationModal() {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController(text: '1 tablet');
    String selectedForm = 'Tablet';
    String selectedFreq = 'Once daily';
    final notesCtrl = TextEditingController();

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
                          'Add Medication for ${_activeDog.name}',
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
                        labelText: 'Medication Name',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dosageCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      decoration: InputDecoration(
                        labelText: 'Dosage (e.g. 20mg, 1 tablet, 2ml)',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Form selector
                    const Text('FORM', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Tablet', 'Oral Suspension', 'Gel Capsule', 'Injection', 'Topical'].map((f) {
                          final isSel = f == selectedForm;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: isSel,
                              selectedColor: const Color(0xFF2E6B57),
                              backgroundColor: AppColors.cardsCarbon,
                              labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.secondaryTextStoneGrey, fontSize: 12),
                              onSelected: (_) => setModalState(() => selectedForm = f),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Frequency
                    const Text('FREQUENCY', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Once daily', 'Twice daily', 'With dinner', 'Every 8 hours', 'As needed'].map((fq) {
                          final isSel = fq == selectedFreq;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(fq),
                              selected: isSel,
                              selectedColor: const Color(0xFF2E6B57),
                              backgroundColor: AppColors.cardsCarbon,
                              labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.secondaryTextStoneGrey, fontSize: 12),
                              onSelected: (_) => setModalState(() => selectedFreq = fq),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      decoration: InputDecoration(
                        labelText: 'Instructions / Notes',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: AppColors.cardsCarbon,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                          if (nameCtrl.text.trim().isEmpty) return;
                          final newMed = MedicationItem(
                            id: 'med_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            dosage: dosageCtrl.text.trim(),
                            form: selectedForm,
                            frequency: selectedFreq,
                            nextDoseDisplay: 'Today, 08:00 AM',
                            status: MedicationStatus.active,
                            icon: Icons.medication_outlined,
                            notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                          );
                          setState(() {
                            _medications.insert(0, newMed);
                            _isEmpty = false;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Save Medication', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
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

  /// Medication Details Modal
  void _showMedicationDetailsModal(MedicationItem med) {
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
                    med.name,
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
                    _buildDetailRow('Dosage', med.dosage),
                    const SizedBox(height: 8),
                    _buildDetailRow('Form', med.form),
                    const SizedBox(height: 8),
                    _buildDetailRow('Frequency', med.frequency),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status', med.status.name.toUpperCase()),
                    if (med.notes != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow('Instructions', med.notes!),
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
                          _medications.removeWhere((m) => m.id == med.id);
                          if (_medications.isEmpty) _isEmpty = true;
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (med.status == MedicationStatus.active)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.pause, size: 18, color: Colors.white),
                        label: const Text('Pause', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            med.status = MedicationStatus.paused;
                            med.nextDoseDisplay = 'Paused';
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                    )
                  else if (med.status == MedicationStatus.paused)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6B57),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 18, color: Colors.white),
                        label: const Text('Resume', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            med.status = MedicationStatus.active;
                            med.nextDoseDisplay = 'Today, 08:00 AM';
                          });
                          Navigator.pop(ctx);
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
                    'Medication Preferences',
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
              const Text('DISPLAY VIEW', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6B57),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Apply', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Educational Guide Modal (Learn about Medication Manager)
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
                      'Medication Tracking Best Practices',
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
                _buildGuideSection(
                  '1. Consistency in Timing',
                  'Administer daily doses at consistent hours to maintain effective therapeutic plasma concentrations. Pair routines with feeding times whenever indicated.',
                ),
                const SizedBox(height: 12),
                _buildGuideSection(
                  '2. Food & GI Safety',
                  'NSAIDs (like Metacam) and certain antibiotics should always be given with or immediately following food to protect the gastrointestinal lining.',
                ),
                const SizedBox(height: 12),
                _buildGuideSection(
                  '3. Missed Dose Protocol',
                  'If a dose is missed by more than a few hours, do not double-up on the subsequent dose. Record the missed instance and resume the regular schedule.',
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
            style: const TextStyle(
              color: Color(0xFF95D3BB),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
