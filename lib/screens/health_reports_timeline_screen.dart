import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';

class HealthTrendPoint {
  final String monthLabel;
  final double weightKg;
  final int eventCount;
  final String note;
  final DateTime date;

  const HealthTrendPoint({
    required this.monthLabel,
    required this.weightKg,
    required this.eventCount,
    required this.note,
    required this.date,
  });
}

enum EntryType { vetVisit, weight, medication, condition, reminder }

extension EntryTypeX on EntryType {
  String get label {
    switch (this) {
      case EntryType.vetVisit:
        return 'Vet Visit';
      case EntryType.weight:
        return 'Weight Check';
      case EntryType.medication:
        return 'Medication';
      case EntryType.condition:
        return 'Condition';
      case EntryType.reminder:
        return 'Reminder';
    }
  }

  String get chipLabel {
    switch (this) {
      case EntryType.vetVisit:
        return 'Vet Visits';
      case EntryType.weight:
        return 'Weight';
      case EntryType.medication:
        return 'Medications';
      case EntryType.condition:
        return 'Conditions';
      case EntryType.reminder:
        return 'Reminders';
    }
  }

  IconData get icon {
    switch (this) {
      case EntryType.vetVisit:
        return Icons.local_hospital_outlined;
      case EntryType.weight:
        return Icons.scale_outlined;
      case EntryType.medication:
        return Icons.medication_outlined;
      case EntryType.condition:
        return Icons.warning_amber_rounded;
      case EntryType.reminder:
        return Icons.notifications_none;
    }
  }
}

class TimelineEntry {
  final String id;
  String title;
  EntryType type;
  DateTime date;
  String? status; // Completed, Active, Resolved, Upcoming
  String detail;
  double? weightKg;

  TimelineEntry({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    this.status,
    this.detail = '',
    this.weightKg,
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

class HealthReportsTimelineScreen extends StatefulWidget {
  final bool initialEmpty;
  const HealthReportsTimelineScreen({super.key, this.initialEmpty = false});

  @override
  State<HealthReportsTimelineScreen> createState() =>
      _HealthReportsTimelineScreenState();
}

class _HealthReportsTimelineScreenState
    extends State<HealthReportsTimelineScreen>
    with SingleTickerProviderStateMixin {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _red = Color(0xFF8B3A3A);

  late bool _isEmpty;
  late AnimationController _anim;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showSearch = false;
  String _query = '';

  final Set<EntryType> _typeFilters = {};
  int? _yearFilter = 2024;

  int _dogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAdPi5IF7xuadCUOJ8WoAel6gkwTRefaDtau4H0iqehtbxEq9OSmnwtdxQatBzYZXu7QW1Z91tOlnO1C7X1ra3hxAXYouz_B10NTFIrKea2fhQdo3lIzn2l-rJz4SkMum4C7PVXdHKxh9rWe5fQL7_88pBzRRjJBBwS4FUy0FpQ0j9MuKUTAKmS8KYNsE44n-ksx3_zQcu3bDhXlW59UuZLt48EURFtTe3a5h6w9vERnEvh-Ie02ZY',
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
  DogProfile get _dog => _dogs[_dogIndex];

  int _selectedTrendMetric = 0; // 0: Weight (kg), 1: Health Events
  int _selectedTrendRange = 1; // 0: 3M, 1: 6M, 2: 1Y
  int _selectedTrendIndex = -1;

  final List<HealthTrendPoint> _rexTrend = [
    HealthTrendPoint(monthLabel: 'Jan', weightKg: 27.2, eventCount: 1, note: 'Annual baseline evaluation', date: DateTime(2024, 1, 15)),
    HealthTrendPoint(monthLabel: 'Feb', weightKg: 27.5, eventCount: 2, note: 'Vaccine booster & deworming', date: DateTime(2024, 2, 20)),
    HealthTrendPoint(monthLabel: 'Mar', weightKg: 27.8, eventCount: 1, note: 'Spring weight monitoring', date: DateTime(2024, 3, 10)),
    HealthTrendPoint(monthLabel: 'Apr', weightKg: 28.0, eventCount: 3, note: 'Left stifle strain diagnosis', date: DateTime(2024, 4, 18)),
    HealthTrendPoint(monthLabel: 'May', weightKg: 28.1, eventCount: 4, note: 'Hydro session & rehab start', date: DateTime(2024, 5, 22)),
    HealthTrendPoint(monthLabel: 'Jun', weightKg: 28.2, eventCount: 3, note: 'Glucosamine chew & laser review', date: DateTime(2024, 6, 10)),
    HealthTrendPoint(monthLabel: 'Jul', weightKg: 28.3, eventCount: 2, note: 'Skin allergy review & Cytopoint', date: DateTime(2024, 7, 14)),
    HealthTrendPoint(monthLabel: 'Aug', weightKg: 28.4, eventCount: 4, note: 'Annual health check completed', date: DateTime(2024, 8, 14)),
    HealthTrendPoint(monthLabel: 'Sep', weightKg: 28.4, eventCount: 2, note: 'Upcoming booster reminder', date: DateTime(2024, 9, 18)),
  ];

  final List<HealthTrendPoint> _kodaTrend = [
    HealthTrendPoint(monthLabel: 'Jan', weightKg: 29.8, eventCount: 2, note: 'Working dog conditioning exam', date: DateTime(2024, 1, 12)),
    HealthTrendPoint(monthLabel: 'Feb', weightKg: 30.1, eventCount: 1, note: 'Weight calibration check', date: DateTime(2024, 2, 14)),
    HealthTrendPoint(monthLabel: 'Mar', weightKg: 30.4, eventCount: 2, note: 'Dental polish & prophylaxis', date: DateTime(2024, 3, 22)),
    HealthTrendPoint(monthLabel: 'Apr', weightKg: 30.6, eventCount: 3, note: 'Interdigital cyst treatment', date: DateTime(2024, 4, 15)),
    HealthTrendPoint(monthLabel: 'May', weightKg: 30.8, eventCount: 2, note: 'Ear cytology & cleansing', date: DateTime(2024, 5, 19)),
    HealthTrendPoint(monthLabel: 'Jun', weightKg: 31.0, eventCount: 4, note: 'Physio evaluation & conditioning', date: DateTime(2024, 6, 25)),
    HealthTrendPoint(monthLabel: 'Jul', weightKg: 31.1, eventCount: 2, note: 'Flea & tick preventative dose', date: DateTime(2024, 7, 10)),
    HealthTrendPoint(monthLabel: 'Aug', weightKg: 31.2, eventCount: 3, note: 'Blood panel & general wellness', date: DateTime(2024, 8, 18)),
    HealthTrendPoint(monthLabel: 'Sep', weightKg: 31.2, eventCount: 2, note: 'Scheduled rabies booster', date: DateTime(2024, 9, 22)),
  ];

  final List<HealthTrendPoint> _lunaTrend = [
    HealthTrendPoint(monthLabel: 'Jan', weightKg: 18.2, eventCount: 1, note: 'New patient registration', date: DateTime(2024, 1, 10)),
    HealthTrendPoint(monthLabel: 'Feb', weightKg: 18.5, eventCount: 2, note: 'Core DHPP puppy boosters', date: DateTime(2024, 2, 18)),
    HealthTrendPoint(monthLabel: 'Mar', weightKg: 18.7, eventCount: 1, note: 'Microchip & weight log', date: DateTime(2024, 3, 15)),
    HealthTrendPoint(monthLabel: 'Apr', weightKg: 18.9, eventCount: 2, note: 'Post-spay incision review', date: DateTime(2024, 4, 12)),
    HealthTrendPoint(monthLabel: 'May', weightKg: 19.1, eventCount: 3, note: 'Swim conditioning session', date: DateTime(2024, 5, 20)),
    HealthTrendPoint(monthLabel: 'Jun', weightKg: 19.3, eventCount: 2, note: 'Nutritional consult & diet check', date: DateTime(2024, 6, 14)),
    HealthTrendPoint(monthLabel: 'Jul', weightKg: 19.4, eventCount: 3, note: 'Ophthalmology evaluation', date: DateTime(2024, 7, 22)),
    HealthTrendPoint(monthLabel: 'Aug', weightKg: 19.5, eventCount: 2, note: 'Pre-agility fitness clearance', date: DateTime(2024, 8, 16)),
    HealthTrendPoint(monthLabel: 'Sep', weightKg: 19.5, eventCount: 1, note: 'Annual wellness check reminder', date: DateTime(2024, 9, 25)),
  ];

  List<HealthTrendPoint> get _currentTrend {
    final base = _dogIndex == 0 ? _rexTrend : (_dogIndex == 1 ? _kodaTrend : _lunaTrend);
    if (_selectedTrendRange == 0) return base.sublist(base.length - 3);
    if (_selectedTrendRange == 1) return base.sublist(base.length - 6);
    return base;
  }

  int get _activeTrendIndex {
    final list = _currentTrend;
    if (_selectedTrendIndex >= 0 && _selectedTrendIndex < list.length) {
      return _selectedTrendIndex;
    }
    return list.length - 1;
  }

  late List<TimelineEntry> _entries;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..forward();
    _entries = [
      TimelineEntry(
        id: 't1',
        title: 'Annual Health Check',
        type: EntryType.vetVisit,
        date: DateTime(2024, 8, 14),
        status: 'Completed',
        detail: 'Full physical exam, heart and lung auscultation, dental check. All vitals normal.',
      ),
      TimelineEntry(
        id: 't2',
        title: '28.4 kg',
        type: EntryType.weight,
        date: DateTime(2024, 8, 14),
        detail: 'Recorded at annual check. Body condition score 5/9.',
        weightKg: 28.4,
      ),
      TimelineEntry(
        id: 't3',
        title: 'Apoquel Started',
        type: EntryType.medication,
        date: DateTime(2024, 8, 2),
        status: 'Active',
        detail: '16mg once daily for seasonal itching. Review in 4 weeks.',
      ),
      TimelineEntry(
        id: 't4',
        title: 'Joint Support Chew',
        type: EntryType.medication,
        date: DateTime(2024, 6, 10),
        status: 'Active',
        detail: 'Daily glucosamine chew.',
      ),
      TimelineEntry(
        id: 't5',
        title: 'Antibiotic Course',
        type: EntryType.medication,
        date: DateTime(2024, 5, 3),
        status: 'Active',
        detail: 'Amoxicillin 10-day course following paw laceration.',
      ),
      TimelineEntry(
        id: 't6',
        title: 'Seasonal Skin Allergy',
        type: EntryType.condition,
        date: DateTime(2024, 7, 20),
        status: 'Active',
        detail: 'Recurring itching and paw licking. Managed with Apoquel.',
      ),
      TimelineEntry(
        id: 't7',
        title: 'Left Foreleg Strain',
        type: EntryType.condition,
        date: DateTime(2024, 4, 18),
        status: 'Active',
        detail: 'Soft tissue strain. Rehab ongoing.',
      ),
      TimelineEntry(
        id: 't8',
        title: 'Booster Vaccination Due',
        type: EntryType.reminder,
        date: DateTime(2024, 9, 18),
        status: 'Upcoming',
        detail: 'Annual DHPP booster at City Vets.',
      ),
      TimelineEntry(
        id: 't9',
        title: 'Flea & Worm Treatment',
        type: EntryType.reminder,
        date: DateTime(2024, 9, 1),
        status: 'Upcoming',
        detail: 'Quarterly preventive treatment.',
      ),
      TimelineEntry(
        id: 't10',
        title: 'Dental Scale & Polish',
        type: EntryType.vetVisit,
        date: DateTime(2023, 11, 12),
        status: 'Completed',
        detail: 'Routine dental clean under sedation.',
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

  // ---------- derived ----------
  List<TimelineEntry> get _visible {
    final list = _entries.where((e) {
      if (_typeFilters.isNotEmpty && !_typeFilters.contains(e.type)) return false;
      if (_yearFilter != null && e.date.year != _yearFilter) return false;
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        return e.title.toLowerCase().contains(q) ||
            e.detail.toLowerCase().contains(q) ||
            e.type.label.toLowerCase().contains(q);
      }
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  int get _totalRecords => 114 + _entries.length;
  int get _activeConditions =>
      _entries.where((e) => e.type == EntryType.condition && e.status == 'Active').length;
  int get _activeMeds =>
      _entries.where((e) => e.type == EntryType.medication && e.status == 'Active').length;
  int get _reminders =>
      _entries.where((e) => e.type == EntryType.reminder && e.status == 'Upcoming').length;

  TimelineEntry? get _lastVet {
    final l = _entries.where((e) => e.type == EntryType.vetVisit).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return l.isEmpty ? null : l.first;
  }

  TimelineEntry? get _lastWeight {
    final l = _entries.where((e) => e.weightKg != null).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return l.isEmpty ? null : l.first;
  }

  String _fmt(DateTime d, {bool year = true}) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final base = '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]}';
    return year ? '$base ${d.year}' : base;
  }

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: _appBar(),
      body: _isEmpty ? _emptyView() : _populatedView(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundObsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _mint),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text('Health Reports & Timeline',
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(_showSearch ? Icons.search_off : Icons.search,
              color: AppColors.secondaryTextStoneGrey, size: 22),
          onPressed: () {
            if (_isEmpty) setState(() => _isEmpty = false);
            setState(() => _showSearch = !_showSearch);
            if (_showSearch) {
              _searchFocus.requestFocus();
            } else {
              _searchController.clear();
              _query = '';
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.secondaryTextStoneGrey, size: 22),
          onPressed: _showFilterSheet,
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.secondaryTextStoneGrey, size: 22),
          onPressed: _showShareSheet,
        ),
        IconButton(
          tooltip: 'Toggle empty / populated',
          icon: Icon(_isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
              color: _isEmpty ? AppColors.secondaryTextStoneGrey : _mint, size: 26),
          onPressed: () {
            setState(() => _isEmpty = !_isEmpty);
            _replay();
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _populatedView() {
    final list = _visible;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dogCard(),
          const SizedBox(height: 24),
          const Text('OVERVIEW',
              style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          _overviewGrid(),
          const SizedBox(height: 20),
          _buildGraphCard(),
          const SizedBox(height: 20),
          _filterRow(),
          if (_showSearch) ...[
            const SizedBox(height: 14),
            _searchBar(),
          ],
          const SizedBox(height: 24),
          if (list.isEmpty)
            _noMatches()
          else
            _timeline(list),
          const SizedBox(height: 24),
          _primaryButton('Add Health Record', _showAddSheet),
        ],
      ),
    );
  }

  // ---------- widgets ----------
  Widget _avatar(String url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _forest,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Icon(Icons.pets, size: size * 0.5, color: _mint),
        ),
      ),
    );
  }

  Widget _dogCard() {
    return InkWell(
      onTap: _showDogSheet,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(children: [
          _avatar(_dog.avatarUrl, 46),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_dog.name,
                    style: const TextStyle(
                        color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('${_dog.breed} · ${_dog.age}',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
        ]),
      ),
    );
  }

  Widget _overviewTile({
    required IconData icon,
    required Color iconColor,
    required Widget value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(height: 10),
            value,
            const SizedBox(height: 2),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _countText(int target, {Color color = AppColors.primaryTextOffWhite}) {
    return TweenAnimationBuilder<int>(
      key: ValueKey('$target-${_anim.value == 0}'),
      tween: IntTween(begin: 0, end: target),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (c, v, w) => Text('$v',
          style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w600)),
    );
  }

  Widget _overviewGrid() {
    final vet = _lastVet;
    final w = _lastWeight;
    final tiles = <Widget>[
      _overviewTile(
        icon: Icons.folder_open,
        iconColor: AppColors.secondaryTextStoneGrey,
        value: _countText(_totalRecords),
        label: 'Total Records',
        onTap: () {
          setState(() {
            _typeFilters.clear();
            _yearFilter = null;
          });
          _replay();
        },
      ),
      _overviewTile(
        icon: Icons.warning_amber_rounded,
        iconColor: _red,
        value: _countText(_activeConditions, color: _red),
        label: 'Active Conditions',
        onTap: () => _applyType(EntryType.condition),
      ),
      _overviewTile(
        icon: Icons.medication_outlined,
        iconColor: AppColors.secondaryTextStoneGrey,
        value: _countText(_activeMeds),
        label: 'Medications',
        onTap: () => _applyType(EntryType.medication),
      ),
      _overviewTile(
        icon: Icons.event,
        iconColor: AppColors.secondaryTextStoneGrey,
        value: Text(vet == null ? '—' : _fmt(vet.date, year: false),
            style: const TextStyle(
                color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        label: 'Last Vet Visit',
        onTap: () => _applyType(EntryType.vetVisit),
      ),
      _overviewTile(
        icon: Icons.scale_outlined,
        iconColor: AppColors.secondaryTextStoneGrey,
        value: Text.rich(TextSpan(
          text: w == null ? '—' : w.weightKg!.toStringAsFixed(1),
          style: const TextStyle(
              color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w600),
          children: const [
            TextSpan(
                text: ' kg',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
          ],
        )),
        label: 'Current Weight',
        onTap: () => _applyType(EntryType.weight),
      ),
      _overviewTile(
        icon: Icons.notifications_none,
        iconColor: _mint,
        value: _countText(_reminders, color: _mint),
        label: 'Reminders',
        onTap: () => _applyType(EntryType.reminder),
      ),
    ];
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 8) / 2;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tiles.map((t) => SizedBox(width: w, height: 112, child: t)).toList(),
      );
    });
  }

  Widget _buildGraphCard() {
    final trendList = _currentTrend;
    final activeIdx = _activeTrendIndex;
    final activePoint = trendList[activeIdx.clamp(0, trendList.length - 1)];
    final isWeight = _selectedTrendMetric == 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isWeight ? Icons.show_chart_rounded : Icons.bar_chart_rounded,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'HEALTH TREND & WEIGHT',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    _metricPill('Weight', 0),
                    _metricPill('Events', 1),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isWeight ? _mint.withValues(alpha: 0.2) : const Color(0xFF5D8FAF).withValues(alpha: 0.2),
              ),
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
                            '${activePoint.monthLabel} 2024',
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isWeight ? _forest : const Color(0xFF5D8FAF)).withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isWeight ? '${activePoint.weightKg.toStringAsFixed(1)} kg' : '${activePoint.eventCount} Events',
                              style: TextStyle(
                                color: isWeight ? _mint : const Color(0xFF5D8FAF),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        activePoint.note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      _query = activePoint.monthLabel;
                      _showSearch = true;
                    });
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _forest),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_alt_outlined, size: 13, color: _mint),
                        SizedBox(width: 4),
                        Text(
                          'View',
                          style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final curveProgress = Curves.easeOutCubic.transform(_anim.value);

                final spots = List.generate(trendList.length, (i) {
                  final p = trendList[i];
                  final targetVal = isWeight ? p.weightKg : p.eventCount.toDouble();
                  return FlSpot(i.toDouble(), targetVal * curveProgress);
                });

                final minY = isWeight ? 25.0 : 0.0;
                final maxY = isWeight ? 33.0 : 5.0;

                final lineColor = isWeight ? _mint : const Color(0xFF5D8FAF);
                final areaColor = isWeight ? _forest : const Color(0xFF5D8FAF);

                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 4,
                      bottom: 22,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isWeight ? '33k' : '5+',
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                          Text(isWeight ? '29k' : '2.5',
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                          Text(isWeight ? '25k' : '0',
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 9)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 6, bottom: 20),
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: (trendList.length - 1).toDouble(),
                          minY: minY * curveProgress,
                          maxY: maxY,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: isWeight ? 3.0 : 2.5,
                            getDrawingHorizontalLine: (value) => FlLine(
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
                                    spotIndex < trendList.length &&
                                    spotIndex != _selectedTrendIndex) {
                                  setState(() {
                                    _selectedTrendIndex = spotIndex;
                                  });
                                }
                              }
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              curveSmoothness: 0.35,
                              color: lineColor,
                              barWidth: 2.8,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    areaColor.withValues(alpha: 0.28),
                                    areaColor.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(
                                show: true,
                                checkToShowDot: (spot, barData) => true,
                                getDotPainter: (spot, percent, barData, index) {
                                  final isSelected = index == activeIdx;
                                  return FlDotCirclePainter(
                                    radius: isSelected ? 5.5 : 3.0,
                                    color: isSelected ? _mint : areaColor,
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
                    Positioned(
                      left: 24,
                      right: 6,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: trendList.map((pt) {
                          final isSel = pt == activePoint;
                          return Text(
                            pt.monthLabel,
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _rangeChip('3 Months', 0),
              const SizedBox(width: 8),
              _rangeChip('6 Months', 1),
              const SizedBox(width: 8),
              _rangeChip('All Year', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricPill(String label, int index) {
    final sel = _selectedTrendMetric == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTrendMetric != index) {
          setState(() {
            _selectedTrendMetric = index;
            _selectedTrendIndex = -1;
          });
          _replay();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: sel ? _forest : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: sel ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _rangeChip(String label, int index) {
    final sel = _selectedTrendRange == index;
    return GestureDetector(
      onTap: () {
        if (_selectedTrendRange != index) {
          setState(() {
            _selectedTrendRange = index;
            _selectedTrendIndex = -1;
          });
          _replay();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: sel ? _forest.withValues(alpha: 0.25) : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: sel ? _mint.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: sel ? _mint : AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _applyType(EntryType t) {
    setState(() {
      _typeFilters
        ..clear()
        ..add(t);
      _yearFilter = null;
    });
    _replay();
  }

  Widget _filterRow() {
    Widget active(String label, VoidCallback onRemove) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _forest),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(label, style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(width: 4),
                const Icon(Icons.close, size: 16, color: _mint),
              ]),
            ),
          ),
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(children: [
        ..._typeFilters.map((t) => active(t.chipLabel, () {
              setState(() => _typeFilters.remove(t));
              _replay();
            })),
        if (_yearFilter != null)
          active('$_yearFilter', () {
            setState(() => _yearFilter = null);
            _replay();
          }),
        InkWell(
          onTap: _showFilterSheet,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Text('Add Filter',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500)),
              SizedBox(width: 4),
              Icon(Icons.add, size: 16, color: AppColors.secondaryTextStoneGrey),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(children: [
        const Icon(Icons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Search health history...',
              hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        if (_query.isNotEmpty)
          GestureDetector(
            onTap: () {
              _searchController.clear();
              setState(() => _query = '');
            },
            child: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey, size: 18),
          ),
      ]),
    );
  }

  Widget _noMatches() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(children: [
        const Text('No records match these filters.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            setState(() {
              _typeFilters.clear();
              _yearFilter = null;
              _query = '';
              _searchController.clear();
            });
            _replay();
          },
          child: const Text('Clear filters', style: TextStyle(color: _mint)),
        ),
      ]),
    );
  }

  /// Timeline with an animated spine that draws downward and cards that
  /// fade/slide in one after another.
  Widget _timeline(List<TimelineEntry> list) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final spine = Curves.easeOutCubic.transform(_anim.value);
        return Stack(
          children: [
            Positioned(
              left: 15,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  heightFactor: spine,
                  child: Container(width: 2, color: _forest.withValues(alpha: 0.5)),
                ),
              ),
            ),
            Column(
              children: List.generate(list.length, (i) {
                final start = (i * 0.08).clamp(0.0, 0.7);
                final end = (start + 0.3).clamp(0.0, 1.0);
                final t = Curves.easeOut
                    .transform(((_anim.value - start) / (end - start)).clamp(0.0, 1.0));
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, (1 - t) * 14),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: i == list.length - 1 ? 0 : 20),
                      child: _timelineItem(list[i]),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _statusBadge(String s) {
    final good = s == 'Completed' || s == 'Active' || s == 'Upcoming';
    final color = s == 'Resolved' ? AppColors.secondaryTextStoneGrey : (good ? _mint : _red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(s.toUpperCase(),
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
    );
  }

  Widget _timelineItem(TimelineEntry e) {
    final highlight = e.status != null;
    final isCondition = e.type == EntryType.condition && e.status == 'Active';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: InkWell(
            onTap: () => _showDetails(e),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(e.type.icon,
                      size: 20,
                      color: isCondition ? _red : (highlight ? _mint : AppColors.secondaryTextStoneGrey)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title,
                            style: const TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text('${e.type.label} · ${_fmt(e.date)}',
                            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (e.status != null) ...[
                    const SizedBox(width: 8),
                    _statusBadge(e.status!),
                  ],
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 11,
          top: 6,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              shape: BoxShape.circle,
              border: Border.all(color: highlight ? _mint : _forest),
            ),
          ),
        ),
      ],
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap, {bool arrow = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: _forest, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: arrow ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
            if (arrow) const Icon(Icons.arrow_forward, size: 18, color: AppColors.primaryTextOffWhite),
          ],
        ),
      ),
    );
  }

  // ---------- empty ----------
  Widget _emptyView() {
    const vitals = ['WEIGHT', 'BODY COND', 'RESTING HR', 'TEMP', 'RESP RATE', 'HYDRATION'];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: LayoutBuilder(builder: (context, c) {
              final w = c.maxWidth / 3;
              return Wrap(
                runSpacing: 22,
                children: vitals
                    .map((v) => SizedBox(
                          width: w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v,
                                  style: const TextStyle(
                                      color: AppColors.secondaryTextStoneGrey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6)),
                              const SizedBox(height: 6),
                              Container(width: 28, height: 2, color: AppColors.primaryTextOffWhite),
                            ],
                          ),
                        ))
                    .toList(),
              );
            }),
          ),
          const SizedBox(height: 60),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardsCarbon,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const Icon(Icons.favorite_border, color: _mint, size: 52),
            ),
          ),
          const SizedBox(height: 24),
          const Text('No Health History Yet',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "As you begin recording your dog's health, a complete medical timeline will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 28),
          _primaryButton('Add Health Record', _showAddSheet, arrow: true),
          const SizedBox(height: 14),
          InkWell(
            onTap: _showLearnSheet,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              alignment: Alignment.center,
              child: const Text('Learn about Health Records',
                  style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- sheets (no snackbars) ----------
  Future<T?> _sheet<T>(Widget Function(BuildContext) b) => showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: b,
      );

  Widget _header(BuildContext ctx, String t) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(t,
                style: const TextStyle(
                    color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      );

  Widget _chip(String label, bool sel, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: sel ? _forest : AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: sel ? _forest : Colors.white.withValues(alpha: 0.08)),
          ),
          child: Text(label,
              style: TextStyle(
                  color: sel ? Colors.white : AppColors.secondaryTextStoneGrey,
                  fontSize: 12,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
        ),
      );

  Widget _field(String label, TextEditingController c, String hint, {int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextField(
            controller: c,
            maxLines: lines,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSheet() {
    final title = TextEditingController();
    final detail = TextEditingController();
    final weight = TextEditingController();
    EntryType type = EntryType.vetVisit;

    _sheet((ctx) => StatefulBuilder(builder: (ctx, setM) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(ctx, 'Add Health Record'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: EntryType.values
                          .map((t) => _chip(t.label, type == t, () => setM(() => type = t)))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    _field('TITLE', title, type == EntryType.weight ? 'e.g. Weekly weigh-in' : 'e.g. Annual Health Check'),
                    if (type == EntryType.weight) ...[
                      const SizedBox(height: 12),
                      _field('WEIGHT (KG)', weight, 'e.g. 28.4'),
                    ],
                    const SizedBox(height: 12),
                    _field('DETAILS', detail, 'Notes, findings, dosage...', lines: 3),
                    const SizedBox(height: 18),
                    _primaryButton('Save Record', () {
                      final kg = double.tryParse(weight.text.trim());
                      final entry = TimelineEntry(
                        id: 't${DateTime.now().millisecondsSinceEpoch}',
                        title: type == EntryType.weight && kg != null
                            ? '${kg.toStringAsFixed(1)} kg'
                            : (title.text.trim().isEmpty ? type.label : title.text.trim()),
                        type: type,
                        date: DateTime.now(),
                        status: type == EntryType.vetVisit
                            ? 'Completed'
                            : type == EntryType.medication || type == EntryType.condition
                                ? 'Active'
                                : type == EntryType.reminder
                                    ? 'Upcoming'
                                    : null,
                        detail: detail.text.trim(),
                        weightKg: type == EntryType.weight ? kg : null,
                      );
                      Navigator.pop(ctx);
                      setState(() {
                        _isEmpty = false;
                        _entries.insert(0, entry);
                        _yearFilter = null;
                      });
                      _replay();
                    }),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  void _showDetails(TimelineEntry e) {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(ctx, e.title),
                  Text('${e.type.label} · ${_fmt(e.date)}',
                      style: const TextStyle(color: _mint, fontSize: 13)),
                  if (e.status != null) ...[
                    const SizedBox(height: 12),
                    _statusBadge(e.status!),
                  ],
                  const SizedBox(height: 16),
                  const Text('DETAILS',
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(e.detail.isEmpty ? 'No additional details.' : e.detail,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _entries.removeWhere((x) => x.id == e.id);
                            if (_entries.isEmpty) _isEmpty = true;
                          });
                          _replay();
                        },
                        child: const Text('Delete', style: TextStyle(color: Color(0xFFFFB4AB))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (e.status == 'Active' &&
                              (e.type == EntryType.condition || e.type == EntryType.medication)) {
                            setState(() => e.status = 'Resolved');
                          } else if (e.status == 'Upcoming') {
                            setState(() => e.status = 'Completed');
                          }
                        },
                        child: Text(
                          e.status == 'Active' && e.type == EntryType.condition
                              ? 'Mark Resolved'
                              : e.status == 'Active' && e.type == EntryType.medication
                                  ? 'Mark Finished'
                                  : e.status == 'Upcoming'
                                      ? 'Mark Done'
                                      : 'Close',
                          style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }

  void _showFilterSheet() {
    final years = {..._entries.map((e) => e.date.year)}.toList()..sort((a, b) => b.compareTo(a));
    _sheet((ctx) => StatefulBuilder(builder: (ctx, setM) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(ctx, 'Filter Timeline'),
                  const Text('RECORD TYPE',
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: EntryType.values.map((t) {
                      final sel = _typeFilters.contains(t);
                      return _chip(t.chipLabel, sel, () {
                        setM(() {});
                        setState(() => sel ? _typeFilters.remove(t) : _typeFilters.add(t));
                      });
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('YEAR',
                      style: TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _chip('All', _yearFilter == null, () {
                        setM(() {});
                        setState(() => _yearFilter = null);
                      }),
                      ...years.map((y) => _chip('$y', _yearFilter == y, () {
                            setM(() {});
                            setState(() => _yearFilter = y);
                          })),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _primaryButton('Apply', () {
                    Navigator.pop(ctx);
                    _replay();
                  }),
                ],
              ),
            ),
          );
        }));
  }

  void _showShareSheet() {
    bool done = false;
    String format = 'PDF Report';
    _sheet((ctx) => StatefulBuilder(builder: (ctx, setM) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(ctx, 'Share Health Report'),
                  Text("Export ${_dog.name}'s timeline (${_visible.length} records shown).",
                      style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['PDF Report', 'CSV Data', 'Vet Summary']
                        .map((f) => _chip(f, format == f, () => setM(() {
                              format = f;
                              done = false;
                            })))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: done
                        ? Container(
                            key: const ValueKey('done'),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _forest.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _forest),
                            ),
                            child: Row(children: [
                              const Icon(Icons.check_circle, color: _mint),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('$format ready to share.',
                                    style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500)),
                              ),
                            ]),
                          )
                        : KeyedSubtree(
                            key: const ValueKey('btn'),
                            child: _primaryButton('Generate $format', () => setM(() => done = true)),
                          ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  void _showDogSheet() {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(ctx, 'Select Dog Profile'),
                ...List.generate(_dogs.length, (i) {
                  final d = _dogs[i];
                  final sel = i == _dogIndex;
                  return InkWell(
                    onTap: () {
                      setState(() => _dogIndex = i);
                      Navigator.pop(ctx);
                      _replay();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: sel ? _forest.withValues(alpha: 0.25) : AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sel ? _forest : Colors.white.withValues(alpha: 0.06)),
                      ),
                      child: Row(children: [
                        _avatar(d.avatarUrl, 38),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name,
                                  style: const TextStyle(
                                      color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('${d.breed} · ${d.age}',
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        if (sel) const Icon(Icons.check_circle, color: _mint, size: 20),
                      ]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }

  void _showLearnSheet() {
    _sheet((ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(ctx, 'Health Records'),
                const Text(
                  "Every vet visit, weight check, medication, condition and reminder is logged here and shown on one chronological timeline. Share it with your vet, trainer or insurer in a tap.",
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),
                _primaryButton('Got It', () => Navigator.pop(ctx)),
              ],
            ),
          ),
        ));
  }
}
