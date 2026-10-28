import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum VetVisitStatus { completed, upcoming, cancelled }

class VetVisitItem {
  final String id;
  String title;
  String clinic;
  String veterinarian;
  DateTime date;
  VetVisitStatus status;
  String diagnosisNote;
  IconData categoryIcon;
  bool isFollowUpRequired;
  DateTime? followUpDate;
  bool hasReminder;
  String? cost;
  String? notes;

  VetVisitItem({
    required this.id,
    required this.title,
    required this.clinic,
    required this.veterinarian,
    required this.date,
    required this.status,
    required this.diagnosisNote,
    required this.categoryIcon,
    this.isFollowUpRequired = false,
    this.followUpDate,
    this.hasReminder = false,
    this.cost,
    this.notes,
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

class VetVisitsScreen extends StatefulWidget {
  final bool initialEmpty;
  const VetVisitsScreen({super.key, this.initialEmpty = false});

  @override
  State<VetVisitsScreen> createState() => _VetVisitsScreenState();
}

class _VetVisitsScreenState extends State<VetVisitsScreen> {
  late bool _isEmpty;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  String? _statusFilter = 'Completed';
  String? _yearFilter = '2026';
  String _sortOrder = 'Newest First'; // 'Newest First', 'Oldest First', 'Upcoming First'

  int _activeDogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB1YXtye7ut-Xy8SbE0O7PsbWaYMMDUGcUgrs_5DyuQ_RYNYdkg9_6UkC874WQ_lApH0Z9FFiVty0y22dhq7GL81LXKHvqoVb5ZHI6TguWj27SVq_k5nACDayLlNZ-QwiOieJvxxB2TE_s3EO0CA59_ANz6k4RCocVVhN9_H6STGLMMC-K8bRs41F2zuXxL7418x0fYLYdyw2vwFXZRUnNc-DLKHnoBME7AUROuHwtSLDXXBh0CB18',
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

  late List<VetVisitItem> _visits;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _initializeVisits();
  }

  void _initializeVisits() {
    _visits = [
      VetVisitItem(
        id: 'visit_1',
        title: 'Annual Health Check',
        clinic: 'City Vets',
        veterinarian: 'Dr. Sarah Connell',
        date: DateTime(2026, 3, 14),
        status: VetVisitStatus.completed,
        diagnosisNote: 'Annual examination and vaccinations',
        categoryIcon: Icons.content_paste_outlined,
        isFollowUpRequired: false,
        hasReminder: false,
        cost: '\$145.00',
        notes: 'Heart, lungs, eyes and ears checked in perfect health. Dental scale 1. Weight 34.2kg.',
      ),
      VetVisitItem(
        id: 'visit_2',
        title: 'Limping — Left Foreleg',
        clinic: 'City Vets',
        veterinarian: 'Dr. Sarah Connell',
        date: DateTime(2026, 1, 2),
        status: VetVisitStatus.completed,
        diagnosisNote: 'Lameness investigation',
        categoryIcon: Icons.medical_services_outlined,
        isFollowUpRequired: true,
        followUpDate: DateTime(2026, 1, 16),
        hasReminder: true,
        cost: '\$220.00',
        notes: 'Mild soft tissue strain from agility work. Prescribed rest and NSAIDs for 10 days.',
      ),
      VetVisitItem(
        id: 'visit_3',
        title: 'Booster Vaccination',
        clinic: 'City Vets',
        veterinarian: 'Dr. Sarah Connell',
        date: DateTime(2026, 8, 28),
        status: VetVisitStatus.upcoming,
        diagnosisNote: 'Annual booster due',
        categoryIcon: Icons.vaccines_outlined,
        isFollowUpRequired: false,
        hasReminder: true,
        cost: '\$95.00',
        notes: 'DHPPi Core booster and Leptospirosis regional booster appointment.',
      ),
      VetVisitItem(
        id: 'visit_4',
        title: 'Dental Assessment',
        clinic: 'City Vets',
        veterinarian: 'Dr. Michael Chang',
        date: DateTime(2025, 11, 10),
        status: VetVisitStatus.completed,
        diagnosisNote: 'Routine dental clean and polish',
        categoryIcon: Icons.health_and_safety_outlined,
        isFollowUpRequired: false,
        hasReminder: false,
        cost: '\$180.00',
        notes: 'Tartar removed from upper molars. Gums healthy with no gingivitis detected.',
      ),
      VetVisitItem(
        id: 'visit_5',
        title: 'Ear Canal Flushing',
        clinic: 'Alpine Animal Hospital',
        veterinarian: 'Dr. Sarah Connell',
        date: DateTime(2025, 7, 22),
        status: VetVisitStatus.completed,
        diagnosisNote: 'Otitis externa follow-up check',
        categoryIcon: Icons.hearing_outlined,
        isFollowUpRequired: false,
        hasReminder: false,
        cost: '\$85.00',
        notes: 'Yeast culture cleared. Ear canals dry and healthy.',
      ),
    ];
  }

  // ==========================================
  // DYNAMIC COMPUTED STATS
  // ==========================================
  int get _totalVisitsCount => _isEmpty ? 0 : 12; // 12 in mock lifetime records
  int get _upcomingVisitsCount => _visits.where((v) => v.status == VetVisitStatus.upcoming).length;
  int get _activeTreatmentsCount => _visits.where((v) => v.isFollowUpRequired || v.status == VetVisitStatus.upcoming).length;
  String get _lastVisitFormatted {
    final completed = _visits.where((v) => v.status == VetVisitStatus.completed).toList();
    if (completed.isEmpty) return 'None';
    completed.sort((a, b) => b.date.compareTo(a.date));
    return _formatDate(completed.first.date);
  }

  // Filtering & Sorting
  List<VetVisitItem> get _filteredVisits {
    var list = List<VetVisitItem>.from(_visits);

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((v) {
        return v.title.toLowerCase().contains(q) ||
            v.clinic.toLowerCase().contains(q) ||
            v.veterinarian.toLowerCase().contains(q) ||
            v.diagnosisNote.toLowerCase().contains(q);
      }).toList();
    }

    if (_statusFilter != null) {
      if (_statusFilter == 'Completed') {
        list = list.where((v) => v.status == VetVisitStatus.completed).toList();
      } else if (_statusFilter == 'Upcoming') {
        list = list.where((v) => v.status == VetVisitStatus.upcoming).toList();
      }
    }

    if (_yearFilter != null) {
      final y = int.tryParse(_yearFilter!);
      if (y != null) {
        list = list.where((v) => v.date.year == y).toList();
      }
    }

    if (_sortOrder == 'Newest First') {
      list.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortOrder == 'Oldest First') {
      list.sort((a, b) => a.date.compareTo(b.date));
    } else if (_sortOrder == 'Upcoming First') {
      list.sort((a, b) {
        if (a.status == VetVisitStatus.upcoming && b.status != VetVisitStatus.upcoming) return -1;
        if (a.status != VetVisitStatus.upcoming && b.status == VetVisitStatus.upcoming) return 1;
        return b.date.compareTo(a.date);
      });
    }

    return list;
  }

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
        'Vet Visits',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: true,
      actions: [
        // Search Icon (focuses search)
        IconButton(
          tooltip: 'Search Visits',
          icon: const Icon(Icons.search, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: () {
            if (_isEmpty) {
              setState(() => _isEmpty = false);
            }
            _searchFocusNode.requestFocus();
          },
        ),
        // Filter list preferences modal
        IconButton(
          tooltip: 'Filter Options',
          icon: const Icon(Icons.filter_list, color: AppColors.primaryTextOffWhite, size: 22),
          onPressed: _showFilterPreferencesModal,
        ),
        // Quick State Toggle (Populated / Empty)
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
        // Add Visit (+)
        IconButton(
          tooltip: 'Add Vet Visit',
          icon: const Icon(Icons.add, color: AppColors.primaryTextOffWhite, size: 24),
          onPressed: _showAddVisitModal,
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
  // POPULATED VIEW (Matches Image 1 & HTML)
  // ==========================================
  Widget _buildPopulatedView() {
    final visits = _filteredVisits;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Dog Selector Card
          _buildDogSelectorCard(),
          const SizedBox(height: 24),

          // 2. VET SUMMARY Card (2x2 Grid)
          _buildVetSummaryGrid(),
          const SizedBox(height: 24),

          // 3. Dedicated Search & Filters Form
          _buildSearchAndFiltersSection(),
          const SizedBox(height: 24),

          // 4. Recent Visits Section Header
          _buildRecentVisitsHeader(visits.length),
          const SizedBox(height: 12),

          // 5. Visits List Cards
          if (visits.isEmpty)
            _buildNoMatchingVisitsState()
          else
            ...visits.map((visit) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildVisitCard(visit),
                )),

          const SizedBox(height: 16),

          // 6. Primary Bottom CTA
          _buildPrimaryAddVisitButton(),

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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            _buildDogAvatar(_activeDog.avatarUrl, size: 36),
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
  // 2. VET SUMMARY (2x2 GRID)
  // ==========================================
  Widget _buildVetSummaryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VET SUMMARY',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              // Top Row: Total Visits & Upcoming
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _statusFilter = null;
                            _yearFilter = null;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
                        child: _buildSummaryBox(
                          icon: Icons.medical_services_outlined,
                          value: '$_totalVisitsCount',
                          label: 'TOTAL VISITS',
                          borderRight: true,
                          borderBottom: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _statusFilter = 'Upcoming';
                            _yearFilter = null;
                          });
                        },
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20)),
                        child: _buildSummaryBox(
                          icon: Icons.calendar_today_outlined,
                          value: '$_upcomingVisitsCount',
                          label: 'UPCOMING',
                          borderRight: false,
                          borderBottom: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom Row: Last Visit & Active Treatments
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryBox(
                        icon: Icons.schedule_outlined,
                        value: _lastVisitFormatted,
                        label: 'LAST VISIT',
                        isDateText: true,
                        borderRight: true,
                        borderBottom: false,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _statusFilter = null;
                            _searchQuery = 'lameness';
                            _searchController.text = 'lameness';
                          });
                        },
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                        child: _buildSummaryBox(
                          icon: Icons.content_paste_outlined,
                          value: '$_activeTreatmentsCount',
                          label: 'ACTIVE TREATMENTS',
                          borderRight: false,
                          borderBottom: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox({
    required IconData icon,
    required String value,
    required String label,
    bool isDateText = false,
    required bool borderRight,
    required bool borderBottom,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          right: borderRight ? BorderSide(color: Colors.white.withValues(alpha: 0.08)) : BorderSide.none,
          bottom: borderBottom ? BorderSide(color: Colors.white.withValues(alpha: 0.08)) : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF2E6B57), size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: isDateText ? 16 : 24,
              fontWeight: isDateText ? FontWeight.w600 : FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. SEARCH & FILTERS SECTION
  // ==========================================
  Widget _buildSearchAndFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dedicated Search Bar Container (Zero Underline!)
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _searchFocusNode.hasFocus ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF7A8F7A), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  cursorColor: const Color(0xFF95D3BB),
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search visits, vets, diagnoses...',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                    ),
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.close, color: Color(0xFF7A8F7A), size: 18),
                  ),
                ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  // Voice search simulation / clear
                  setState(() {
                    if (_searchQuery.isEmpty) {
                      _searchQuery = 'Connell';
                      _searchController.text = 'Connell';
                    } else {
                      _searchQuery = '';
                      _searchController.clear();
                    }
                  });
                },
                child: const Icon(Icons.mic, color: Color(0xFF7A8F7A), size: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Filter Pills Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    if (_statusFilter != null) ...[
                      _buildActiveFilterChip(
                        label: _statusFilter!,
                        onRemove: () => setState(() => _statusFilter = null),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (_yearFilter != null) ...[
                      _buildActiveFilterChip(
                        label: _yearFilter!,
                        onRemove: () => setState(() => _yearFilter = null),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (_statusFilter == null && _yearFilter == null) ...[
                      _buildQuickFilterPill('All', isSelected: true, onTap: () {}),
                      const SizedBox(width: 8),
                      _buildQuickFilterPill('Completed', isSelected: false, onTap: () => setState(() => _statusFilter = 'Completed')),
                      const SizedBox(width: 8),
                      _buildQuickFilterPill('Upcoming', isSelected: false, onTap: () => setState(() => _statusFilter = 'Upcoming')),
                      const SizedBox(width: 8),
                      _buildQuickFilterPill('2026', isSelected: false, onTap: () => setState(() => _yearFilter = '2026')),
                    ],
                  ],
                ),
              ),
            ),
            if (_statusFilter != null || _yearFilter != null || _searchQuery.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _statusFilter = null;
                    _yearFilter = null;
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveFilterChip({required String label, required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E6B57)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF95D3BB),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, color: Color(0xFF7A8F7A), size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterPill(String label, {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6B57) : AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E6B57) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.secondaryTextStoneGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. RECENT VISITS HEADER & SORT
  // ==========================================
  Widget _buildRecentVisitsHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'RECENT VISITS',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (_sortOrder == 'Newest First') {
                _sortOrder = 'Oldest First';
              } else if (_sortOrder == 'Oldest First') {
                _sortOrder = 'Upcoming First';
              } else {
                _sortOrder = 'Newest First';
              }
            });
          },
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Text(
                  _sortOrder,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.swap_vert, color: AppColors.secondaryTextStoneGrey, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. VISIT CARD (Matches Figma & HTML)
  // ==========================================
  Widget _buildVisitCard(VetVisitItem visit) {
    final bool isCompleted = visit.status == VetVisitStatus.completed;

    return InkWell(
      onTap: () => _showVisitDetailsModal(visit),
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
            // Top Row: Date & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(visit.date),
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E6B57),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'COMPLETED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cardsCarbon,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2E6B57)),
                    ),
                    child: const Text(
                      'UPCOMING',
                      style: TextStyle(
                        color: Color(0xFF95D3BB),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Title & Vet
            Text(
              visit.title,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${visit.clinic} · ${visit.veterinarian}',
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),

            // Investigation Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Icon(visit.categoryIcon, color: AppColors.secondaryTextStoneGrey, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      visit.diagnosisNote,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Footer Row
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (visit.isFollowUpRequired && visit.followUpDate != null)
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E6B57),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Follow-up: ${_formatDate(visit.followUpDate!)}',
                          style: const TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else if (visit.hasReminder)
                    const Row(
                      children: [
                        Icon(Icons.notifications, color: Color(0xFF95D3BB), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Reminder set',
                          style: TextStyle(
                            color: Color(0xFF95D3BB),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else
                    const Text(
                      'No follow-up required',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const Icon(Icons.chevron_right, color: Color(0xFF7A8F7A), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty Filter State
  Widget _buildNoMatchingVisitsState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.medical_services_outlined, size: 40, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(height: 12),
            const Text(
              'No visits found matching your filters',
              style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try clearing search terms or status filters.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF95D3BB),
                backgroundColor: AppColors.backgroundObsidian,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: const Color(0xFF95D3BB).withValues(alpha: 0.3)),
                ),
              ),
              onPressed: () {
                setState(() {
                  _statusFilter = null;
                  _yearFilter = null;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 6. PRIMARY CTA BUTTON
  // ==========================================
  Widget _buildPrimaryAddVisitButton() {
    return InkWell(
      onTap: _showAddVisitModal,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF2E6B57),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.add, color: Colors.white, size: 22),
            Text(
              'Add Vet Visit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // EMPTY STATE VIEW (Matches Image 2)
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

          // Stethoscope Central Icon Graphic
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
                Icons.medical_services_outlined,
                size: 36,
                color: Color(0xFF95D3BB),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Main Empty Title
          const Text(
            'No Vet Visits Recorded',
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
              'Keep a complete record of every veterinary appointment, diagnosis, and treatment throughout your dog\'s life.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Add Vet Visit CTA
          Center(
            child: SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6B57),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _showAddVisitModal,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add Vet Visit',
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
                'Learn about Vet Visits',
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
  // MODALS & ACTIONS (100% ZERO SNACKBARS!)
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
                    const Text('VISIT STATUS', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildFilterOptionPill(
                          'All Statuses',
                          isSelected: _statusFilter == null,
                          onTap: () {
                            setModalState(() => _statusFilter = null);
                            setState(() => _statusFilter = null);
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterOptionPill(
                          'Completed',
                          isSelected: _statusFilter == 'Completed',
                          onTap: () {
                            setModalState(() => _statusFilter = 'Completed');
                            setState(() => _statusFilter = 'Completed');
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterOptionPill(
                          'Upcoming',
                          isSelected: _statusFilter == 'Upcoming',
                          onTap: () {
                            setModalState(() => _statusFilter = 'Upcoming');
                            setState(() => _statusFilter = 'Upcoming');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('RECORD YEAR', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildFilterOptionPill(
                          'All Years',
                          isSelected: _yearFilter == null,
                          onTap: () {
                            setModalState(() => _yearFilter = null);
                            setState(() => _yearFilter = null);
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterOptionPill(
                          '2026',
                          isSelected: _yearFilter == '2026',
                          onTap: () {
                            setModalState(() => _yearFilter = '2026');
                            setState(() => _yearFilter = '2026');
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildFilterOptionPill(
                          '2025',
                          isSelected: _yearFilter == '2025',
                          onTap: () {
                            setModalState(() => _yearFilter = '2025');
                            setState(() => _yearFilter = '2025');
                          },
                        ),
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

  // Visit Details Modal Bottom Sheet
  void _showVisitDetailsModal(VetVisitItem visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
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
                          visit.title,
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
                    '${visit.clinic} · ${visit.veterinarian}',
                    style: const TextStyle(color: Color(0xFF95D3BB), fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow('Date', _formatDate(visit.date)),
                  _buildDetailRow('Status', visit.status == VetVisitStatus.completed ? 'COMPLETED' : 'UPCOMING'),
                  _buildDetailRow('Reason / Diagnosis', visit.diagnosisNote),
                  if (visit.cost != null) _buildDetailRow('Total Invoice', visit.cost!),
                  if (visit.isFollowUpRequired && visit.followUpDate != null)
                    _buildDetailRow('Next Follow-up', _formatDate(visit.followUpDate!)),
                  _buildDetailRow('Reminder Alert', visit.hasReminder ? 'Active' : 'Not set'),
                  if (visit.notes != null) ...[
                    const SizedBox(height: 8),
                    const Text('Clinical Notes', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      visit.notes!,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, height: 1.4),
                    ),
                  ],
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
                              _visits.removeWhere((v) => v.id == visit.id);
                            });
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Delete Visit'),
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
                              visit.hasReminder = !visit.hasReminder;
                            });
                            Navigator.pop(ctx);
                          },
                          icon: Icon(visit.hasReminder ? Icons.notifications_off : Icons.notifications_active, size: 18),
                          label: Text(visit.hasReminder ? 'Mute Alert' : 'Set Alert'),
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

  // Add Vet Visit Modal Bottom Sheet
  void _showAddVisitModal() {
    final titleCtrl = TextEditingController();
    final clinicCtrl = TextEditingController(text: 'City Vets');
    final vetCtrl = TextEditingController(text: 'Dr. Sarah Connell');
    final diagnosisCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    DateTime visitDate = DateTime.now();
    bool isCompleted = true;
    bool followUpRequired = false;
    DateTime followUpDate = DateTime.now().add(const Duration(days: 14));
    bool hasReminder = true;

    final presetChips = ['Annual Check', 'Vaccination', 'Lameness', 'Dental', 'Emergency', 'Surgery'];

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
                            'Add Vet Visit for ${_activeDog.name}',
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
                      const SizedBox(height: 12),

                      // Quick Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: presetChips.map((chip) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                label: Text(chip, style: const TextStyle(fontSize: 11)),
                                backgroundColor: AppColors.backgroundObsidian,
                                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                onPressed: () {
                                  setModalState(() {
                                    titleCtrl.text = chip;
                                    diagnosisCtrl.text = 'Clinical examination and care for $chip';
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title Field
                      TextField(
                        controller: titleCtrl,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          labelText: 'Visit Title / Reason',
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

                      // Clinic & Vet
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: clinicCtrl,
                              style: const TextStyle(color: AppColors.primaryTextOffWhite),
                              decoration: InputDecoration(
                                labelText: 'Clinic',
                                labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: vetCtrl,
                              style: const TextStyle(color: AppColors.primaryTextOffWhite),
                              decoration: InputDecoration(
                                labelText: 'Veterinarian',
                                labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Diagnosis Field
                      TextField(
                        controller: diagnosisCtrl,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          labelText: 'Summary Diagnosis / Treatment',
                          labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                          filled: true,
                          fillColor: AppColors.backgroundObsidian,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Date selector & Cost
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: visitDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  setModalState(() => visitDate = picked);
                                }
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
                                    Text(
                                      _formatDate(visitDate),
                                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
                                    ),
                                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF95D3BB)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: costCtrl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.primaryTextOffWhite),
                              decoration: InputDecoration(
                                labelText: 'Invoice Cost (\$)',
                                labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Status Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mark as Completed', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                          Switch(
                            value: isCompleted,
                            activeThumbColor: const Color(0xFF95D3BB),
                            activeTrackColor: const Color(0xFF2E6B57),
                            onChanged: (val) => setModalState(() => isCompleted = val),
                          ),
                        ],
                      ),

                      // Follow-up required switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Follow-up Required', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                          Switch(
                            value: followUpRequired,
                            activeThumbColor: const Color(0xFF95D3BB),
                            activeTrackColor: const Color(0xFF2E6B57),
                            onChanged: (val) => setModalState(() => followUpRequired = val),
                          ),
                        ],
                      ),

                      // Reminder switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Set Reminder Notification', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                          Switch(
                            value: hasReminder,
                            activeThumbColor: const Color(0xFF95D3BB),
                            activeTrackColor: const Color(0xFF2E6B57),
                            onChanged: (val) => setModalState(() => hasReminder = val),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6B57),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            final finalTitle = titleCtrl.text.trim().isEmpty ? 'Veterinary Checkup' : titleCtrl.text.trim();
                            final finalDiagnosis = diagnosisCtrl.text.trim().isEmpty ? 'Routine checkup and observation' : diagnosisCtrl.text.trim();

                            final newVisit = VetVisitItem(
                              id: 'visit_${DateTime.now().millisecondsSinceEpoch}',
                              title: finalTitle,
                              clinic: clinicCtrl.text.trim().isEmpty ? 'City Vets' : clinicCtrl.text.trim(),
                              veterinarian: vetCtrl.text.trim().isEmpty ? 'Dr. Sarah Connell' : vetCtrl.text.trim(),
                              date: visitDate,
                              status: isCompleted ? VetVisitStatus.completed : VetVisitStatus.upcoming,
                              diagnosisNote: finalDiagnosis,
                              categoryIcon: Icons.medical_services_outlined,
                              isFollowUpRequired: followUpRequired,
                              followUpDate: followUpRequired ? followUpDate : null,
                              hasReminder: hasReminder,
                              cost: costCtrl.text.trim().isEmpty ? null : '\$${costCtrl.text.trim()}',
                              notes: notesCtrl.text.trim(),
                            );

                            setState(() {
                              _visits.insert(0, newVisit);
                              _isEmpty = false;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('Save Vet Visit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
                      'About Vet Visits Manager',
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
                  'The Vet Visits Manager keeps a verified clinical log for trials, travel certifications, and sports dog maintenance.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 14),
                _buildEducationPoint(Icons.calendar_month, 'Keep tabs on booster and orthopedic check schedules.'),
                _buildEducationPoint(Icons.medication, 'Track active lameness and prescription courses seamlessly.'),
                _buildEducationPoint(Icons.receipt_long, 'Store itemized veterinary invoices for insurance claims.'),
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
                    child: const Text('Got it'),
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

  Widget _buildDogAvatar(String url, {double size = 36}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2E6B57),
        border: Border.all(color: const Color(0xFF2E6B57), width: 2),
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
