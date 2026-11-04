import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _CalendarViewTab { month, week, day, year, agenda }

enum _EventCategory { training, health, goal, physio, competition }

class _CalendarEventItem {
  final String id;
  final DateTime date;
  final String title;
  final String dogName;
  final String timeOrDue;
  final String detailOrLocation;
  final _EventCategory category;
  final bool isPlannedBadge;
  final bool isCompleted;

  const _CalendarEventItem({
    required this.id,
    required this.date,
    required this.title,
    required this.dogName,
    required this.timeOrDue,
    required this.detailOrLocation,
    required this.category,
    this.isPlannedBadge = false,
    this.isCompleted = false,
  });

  _CalendarEventItem copyWith({
    bool? isPlannedBadge,
    bool? isCompleted,
    String? timeOrDue,
    String? detailOrLocation,
  }) {
    return _CalendarEventItem(
      id: id,
      date: date,
      title: title,
      dogName: dogName,
      timeOrDue: timeOrDue ?? this.timeOrDue,
      detailOrLocation: detailOrLocation ?? this.detailOrLocation,
      category: category,
      isPlannedBadge: isPlannedBadge ?? this.isPlannedBadge,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class GlobalCalendarScreen extends StatefulWidget {
  final bool hasSportPack;

  const GlobalCalendarScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<GlobalCalendarScreen> createState() => _GlobalCalendarScreenState();
}

class _GlobalCalendarScreenState extends State<GlobalCalendarScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _innerCard = Color(0xFF212629);
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _alpineBlue = AppColors.infoAlpineBlue;
  static const Color _bronze = AppColors.bronzeAccent;
  static const Color _destructive = AppColors.errorDestructive;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _mutedOutMonth = Color(0xFF47504C);
  static const Color _cardBorder = AppColors.cardBorder;

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _shortMonths = [
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
    'Dec',
  ];

  static const List<String> _weekdayFull = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _shortWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final List<String> _dogs = ['Murphy', 'Monty', 'Minnie'];
  String _selectedDogFilter = 'All Dogs';
  _EventCategory? _selectedCategoryFilter; // null == All Categories
  _CalendarViewTab _activeTab = _CalendarViewTab.month;

  bool _searchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  late DateTime _displayedMonth;
  late DateTime _selectedDate;
  late List<_CalendarEventItem> _events;
  int _nextEventId = 100;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(2026, 9, 1);
    _selectedDate = DateTime(2026, 9, 16);
    _events = _buildSeededEvents();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CalendarEventItem> _buildSeededEvents() {
    return [
      // Exact Figma Sept 16 selected-date events
      _CalendarEventItem(
        id: 'ev_1',
        date: DateTime(2026, 9, 16),
        title: 'Morning Obedience Session',
        dogName: 'Murphy',
        timeOrDue: '09:00',
        detailOrLocation: '45 min',
        category: _EventCategory.training,
      ),
      _CalendarEventItem(
        id: 'ev_2',
        date: DateTime(2026, 9, 16),
        title: 'Vet Check-Up',
        dogName: 'Murphy',
        timeOrDue: '14:30',
        detailOrLocation: 'Riverside Vets',
        category: _EventCategory.health,
      ),
      _CalendarEventItem(
        id: 'ev_3',
        date: DateTime(2026, 9, 16),
        title: 'Complete Recall Goal',
        dogName: 'Murphy',
        timeOrDue: 'Due today',
        detailOrLocation: '',
        category: _EventCategory.goal,
        isPlannedBadge: true,
      ),

      // Exact Figma UPCOMING events
      _CalendarEventItem(
        id: 'ev_4',
        date: DateTime(2026, 9, 19),
        title: 'Hydrotherapy Session',
        dogName: 'Murphy',
        timeOrDue: '11:00',
        detailOrLocation: 'Nordic Canine Rehab',
        category: _EventCategory.physio,
      ),
      if (widget.hasSportPack)
        _CalendarEventItem(
          id: 'ev_5',
          date: DateTime(2026, 9, 21),
          title: 'Competition – IGP Trial',
          dogName: 'Murphy',
          timeOrDue: '08:30',
          detailOrLocation: 'Regional Working Trial',
          category: _EventCategory.competition,
          isPlannedBadge: true,
        ),
      _CalendarEventItem(
        id: 'ev_6',
        date: DateTime(2026, 9, 23),
        title: 'Vaccination Due',
        dogName: 'Monty',
        timeOrDue: '10:15',
        detailOrLocation: 'Annual Booster · Riverside Vets',
        category: _EventCategory.health,
      ),
      _CalendarEventItem(
        id: 'ev_7',
        date: DateTime(2026, 9, 25),
        title: 'Weekly Weight Check',
        dogName: 'Minnie',
        timeOrDue: '18:00',
        detailOrLocation: 'Home Scale Log',
        category: _EventCategory.goal,
      ),

      // Additional September 2026 calendar dot events matching Figma month grid
      _CalendarEventItem(
        id: 'ev_8',
        date: DateTime(2026, 9, 1),
        title: 'Heelwork & Impulse Drill',
        dogName: 'Murphy',
        timeOrDue: '08:30',
        detailOrLocation: '35 min',
        category: _EventCategory.training,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_9',
        date: DateTime(2026, 9, 3),
        title: 'Underwater Treadmill',
        dogName: 'Monty',
        timeOrDue: '13:00',
        detailOrLocation: '30 min',
        category: _EventCategory.physio,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_10',
        date: DateTime(2026, 9, 3),
        title: 'Scent Article Check',
        dogName: 'Murphy',
        timeOrDue: 'Due 17:00',
        detailOrLocation: 'Field Marker',
        category: _EventCategory.goal,
        isCompleted: true,
      ),
      if (widget.hasSportPack)
        _CalendarEventItem(
          id: 'ev_11',
          date: DateTime(2026, 9, 5),
          title: 'Club Mock Trial',
          dogName: 'Murphy',
          timeOrDue: '09:30',
          detailOrLocation: 'IGP Phase B',
          category: _EventCategory.competition,
          isCompleted: true,
        ),
      _CalendarEventItem(
        id: 'ev_12',
        date: DateTime(2026, 9, 7),
        title: 'Tracking Line Session',
        dogName: 'Monty',
        timeOrDue: '07:45',
        detailOrLocation: '50 min',
        category: _EventCategory.training,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_13',
        date: DateTime(2026, 9, 9),
        title: 'Mobility & Core Balance',
        dogName: 'Minnie',
        timeOrDue: '16:00',
        detailOrLocation: '25 min',
        category: _EventCategory.physio,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_14',
        date: DateTime(2026, 9, 10),
        title: 'Flea & Tick Prevention',
        dogName: 'Minnie',
        timeOrDue: '09:00',
        detailOrLocation: 'Monthly Dose',
        category: _EventCategory.health,
        isCompleted: true,
      ),
      if (widget.hasSportPack)
        _CalendarEventItem(
          id: 'ev_15',
          date: DateTime(2026, 9, 12),
          title: 'Gundog Steadiness Field Day',
          dogName: 'Murphy',
          timeOrDue: '09:00',
          detailOrLocation: '90 min',
          category: _EventCategory.competition,
          isCompleted: true,
        ),
      _CalendarEventItem(
        id: 'ev_16',
        date: DateTime(2026, 9, 12),
        title: 'Agility Weave Poles',
        dogName: 'Minnie',
        timeOrDue: '11:30',
        detailOrLocation: '40 min',
        category: _EventCategory.training,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_17',
        date: DateTime(2026, 9, 12),
        title: 'Post-Trial Cooldown Flush',
        dogName: 'Murphy',
        timeOrDue: '14:00',
        detailOrLocation: '20 min',
        category: _EventCategory.physio,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_18',
        date: DateTime(2026, 9, 12),
        title: 'Dental Tartar Inspection',
        dogName: 'Monty',
        timeOrDue: '18:30',
        detailOrLocation: 'Home Check',
        category: _EventCategory.health,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_19',
        date: DateTime(2026, 9, 14),
        title: 'Distance Control Milestone',
        dogName: 'Murphy',
        timeOrDue: 'Due 19:00',
        detailOrLocation: '15m Sit-Down',
        category: _EventCategory.goal,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_20',
        date: DateTime(2026, 9, 15),
        title: 'Retrieve Dumbbell Hold',
        dogName: 'Murphy',
        timeOrDue: '08:15',
        detailOrLocation: '30 min',
        category: _EventCategory.training,
        isCompleted: true,
      ),
      _CalendarEventItem(
        id: 'ev_21',
        date: DateTime(2026, 9, 18),
        title: 'Log Weekly Conditioning',
        dogName: 'Monty',
        timeOrDue: 'Due 20:00',
        detailOrLocation: 'S&C Block 3',
        category: _EventCategory.goal,
        isPlannedBadge: true,
      ),
      _CalendarEventItem(
        id: 'ev_22',
        date: DateTime(2026, 9, 22),
        title: 'Urban Distraction Walk',
        dogName: 'Minnie',
        timeOrDue: '17:00',
        detailOrLocation: '40 min',
        category: _EventCategory.training,
      ),
      _CalendarEventItem(
        id: 'ev_23',
        date: DateTime(2026, 9, 26),
        title: 'Protection Bark & Hold',
        dogName: 'Murphy',
        timeOrDue: '10:00',
        detailOrLocation: '45 min',
        category: _EventCategory.training,
      ),
      if (widget.hasSportPack)
        _CalendarEventItem(
          id: 'ev_24',
          date: DateTime(2026, 9, 26),
          title: 'Autumn Club Qualifier',
          dogName: 'Monty',
          timeOrDue: '13:30',
          detailOrLocation: 'North Field',
          category: _EventCategory.competition,
          isPlannedBadge: true,
        ),
      _CalendarEventItem(
        id: 'ev_25',
        date: DateTime(2026, 9, 28),
        title: 'End-of-Month Goal Review',
        dogName: 'Murphy',
        timeOrDue: '19:00',
        detailOrLocation: 'Q3 Targets',
        category: _EventCategory.goal,
      ),
      _CalendarEventItem(
        id: 'ev_26',
        date: DateTime(2026, 9, 30),
        title: 'Night Scent Discrimination',
        dogName: 'Murphy',
        timeOrDue: '19:30',
        detailOrLocation: '35 min',
        category: _EventCategory.training,
      ),
      _CalendarEventItem(
        id: 'ev_27',
        date: DateTime(2026, 9, 30),
        title: 'Laser & Physio Assessment',
        dogName: 'Minnie',
        timeOrDue: '15:00',
        detailOrLocation: 'Nordic Canine Rehab',
        category: _EventCategory.physio,
      ),
      // October & August sample events for month navigation
      _CalendarEventItem(
        id: 'ev_28',
        date: DateTime(2026, 8, 28),
        title: 'Late Summer Trail Pack Walk',
        dogName: 'Murphy',
        timeOrDue: '08:00',
        detailOrLocation: '60 min',
        category: _EventCategory.training,
        isCompleted: true,
      ),
      if (widget.hasSportPack)
        _CalendarEventItem(
          id: 'ev_29',
          date: DateTime(2026, 10, 4),
          title: 'Autumn Championship Entry',
          dogName: 'Murphy',
          timeOrDue: '09:00',
          detailOrLocation: 'National Stadium',
          category: _EventCategory.competition,
          isPlannedBadge: true,
        ),
    ];
  }

  List<_EventCategory> get _availableCategories => _EventCategory.values
      .where((cat) => widget.hasSportPack || cat != _EventCategory.competition)
      .toList();

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Color _categoryColor(_EventCategory cat) {
    switch (cat) {
      case _EventCategory.training:
        return _forest;
      case _EventCategory.health:
        return _destructive;
      case _EventCategory.goal:
        return _sageMint;
      case _EventCategory.physio:
        return _alpineBlue;
      case _EventCategory.competition:
        return _bronze;
    }
  }

  IconData _categoryIcon(_EventCategory cat) {
    switch (cat) {
      case _EventCategory.training:
        return Icons.fitness_center_rounded;
      case _EventCategory.health:
        return Icons.favorite_border_rounded;
      case _EventCategory.goal:
        return Icons.adjust_rounded;
      case _EventCategory.physio:
        return Icons.waves_rounded;
      case _EventCategory.competition:
        return Icons.emoji_events_outlined;
    }
  }

  String _categoryLabel(_EventCategory cat) {
    switch (cat) {
      case _EventCategory.training:
        return 'Training';
      case _EventCategory.health:
        return 'Health';
      case _EventCategory.goal:
        return 'Goals';
      case _EventCategory.physio:
        return 'Physio';
      case _EventCategory.competition:
        return 'Competitions';
    }
  }

  bool _matchesActiveFilters(_CalendarEventItem item) {
    if (!widget.hasSportPack && item.category == _EventCategory.competition) {
      return false;
    }
    if (_selectedDogFilter != 'All Dogs' && item.dogName != _selectedDogFilter) {
      return false;
    }
    if (_selectedCategoryFilter != null &&
        item.category != _selectedCategoryFilter) {
      return false;
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      final hay =
          '${item.title} ${item.dogName} ${item.detailOrLocation}'.toLowerCase();
      if (!hay.contains(q)) return false;
    }
    return true;
  }

  List<_CalendarEventItem> _eventsForDate(DateTime date) {
    return _events
        .where((e) => _isSameDay(e.date, date) && _matchesActiveFilters(e))
        .toList();
  }

  List<_CalendarEventItem> get _upcomingEvents {
    final list = _events.where((e) {
      final isAfterSelected = e.date.isAfter(
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      );
      return isAfterSelected && _matchesActiveFilters(e);
    }).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list.take(6).toList();
  }

  void _changeMonth(int delta) {
    setState(() {
      final nextMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
        1,
      );
      final maxDays = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
      _displayedMonth = nextMonth;
      _selectedDate = DateTime(
        nextMonth.year,
        nextMonth.month,
        _selectedDate.day.clamp(1, maxDays),
      );
    });
  }

  void _jumpToToday() {
    setState(() {
      _displayedMonth = DateTime(2026, 9, 1);
      _selectedDate = DateTime(2026, 9, 16);
    });
  }

  String _formatMonthYear(DateTime d) =>
      '${_monthNames[d.month - 1]} ${d.year}';

  String _formatSelectedDayHeading(DateTime d) {
    // Preserve exact Figma display on anchor date Sept 16 if desired, or real weekday
    if (d.year == 2026 && d.month == 9 && d.day == 16) {
      return 'Tuesday, 16 September';
    }
    final wd = _weekdayFull[d.weekday - 1];
    return '$wd, ${d.day} ${_monthNames[d.month - 1]}';
  }

  String _formatUpcomingDate(DateTime d) {
    // Match exact Figma short labels on seeded upcoming dates
    if (d.year == 2026 && d.month == 9) {
      if (d.day == 19) return 'Thu 19 Sep';
      if (d.day == 21) return 'Sat 21 Sep';
      if (d.day == 23) return 'Mon 23 Sep';
      if (d.day == 25) return 'Wed 25 Sep';
    }
    final wd = _shortWeekdays[d.weekday - 1];
    return '$wd ${d.day} ${_shortMonths[d.month - 1]}';
  }

  void _openAddDogWorkspaceModal() {
    final ctrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSheetHandle(),
              const SizedBox(height: 16),
              const Text(
                'Add Dog to Calendar Filter',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Add another dog workspace pill to filter schedules quickly.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  color: _stoneGrey,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: ctrl,
                autofocus: true,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: _offWhite,
                ),
                decoration: InputDecoration(
                  hintText: 'Dog name (e.g. Freya)',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: _stoneGrey.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: _obsidian,
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
                    borderSide: const BorderSide(color: _forest, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final name = ctrl.text.trim();
                    if (name.isEmpty) return;
                    setState(() {
                      if (!_dogs.contains(name)) {
                        _dogs.add(name);
                      }
                      _selectedDogFilter = name;
                    });
                    Navigator.of(sheetCtx).pop();
                    AppSnackbar.show(
                      context,
                      title: 'Calendar Filter Added',
                      message: 'Now viewing schedule for $name.',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Add Dog Filter',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
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

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSheetHandle(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Calendar Events',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDogFilter = 'All Dogs';
                              _selectedCategoryFilter = null;
                            });
                            setModalState(() {});
                          },
                          child: const Text(
                            'Reset All',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _mint,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'CATEGORY',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSheetCategoryChip(
                          label: 'All Categories',
                          active: _selectedCategoryFilter == null,
                          dotColor: _mint,
                          onTap: () {
                            setState(() => _selectedCategoryFilter = null);
                            setModalState(() {});
                          },
                        ),
                        ..._availableCategories.map((cat) {
                          return _buildSheetCategoryChip(
                            label: _categoryLabel(cat),
                            active: _selectedCategoryFilter == cat,
                            dotColor: _categoryColor(cat),
                            onTap: () {
                              setState(() => _selectedCategoryFilter = cat);
                              setModalState(() {});
                            },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
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
      },
    );
  }

  Widget _buildSheetCategoryChip({
    required String label,
    required bool active,
    required Color dotColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? _forest.withValues(alpha: 0.22) : _obsidian,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? _forest : _cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? _offWhite : _stoneGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEventDetailsSheet(_CalendarEventItem item) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        final accent = _categoryColor(item.category);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _categoryIcon(item.category),
                        color: accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: _offWhite,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${item.dogName} · ${_formatUpcomingDate(item.date)} · ${item.timeOrDue}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              color: _stoneGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item.detailOrLocation.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Text(
                      'Details: ${item.detailOrLocation}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _destructive,
                          side: BorderSide(
                            color: _destructive.withValues(alpha: 0.45),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _events.removeWhere((e) => e.id == item.id);
                          });
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Event Removed',
                            message: 'Removed "${item.title}" from calendar.',
                            type: SnackbarType.info,
                          );
                        },
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text(
                          'Delete',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final idx =
                              _events.indexWhere((e) => e.id == item.id);
                          if (idx != -1) {
                            final nextCompleted = !item.isCompleted;
                            setState(() {
                              _events[idx] = item.copyWith(
                                isCompleted: nextCompleted,
                                isPlannedBadge:
                                    nextCompleted ? false : item.isPlannedBadge,
                              );
                            });
                          }
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: item.isCompleted
                                ? 'Marked Planned'
                                : 'Marked Completed',
                            message: 'Updated status for "${item.title}".',
                            type: SnackbarType.success,
                          );
                        },
                        icon: Icon(
                          item.isCompleted
                              ? Icons.replay_rounded
                              : Icons.check_circle_outline_rounded,
                          size: 18,
                        ),
                        label: Text(
                          item.isCompleted ? 'Mark Planned' : 'Complete',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddEventSheet({_EventCategory initialCategory = _EventCategory.training}) {
    _EventCategory chosenCat = initialCategory;
    String chosenDog = _selectedDogFilter == 'All Dogs'
        ? _dogs.first
        : _selectedDogFilter;
    String chosenTime = '09:00';
    final titleCtrl = TextEditingController();
    final detailCtrl = TextEditingController();

    const Map<_EventCategory, List<String>> presets = {
      _EventCategory.training: [
        'Heelwork & Focus Session',
        'Scent Discrimination Drill',
        'Agility Sequence Run',
      ],
      _EventCategory.health: [
        'Annual Vet Wellness Check',
        'Parasite Preventative Dose',
        'Dental & Coat Check',
      ],
      _EventCategory.goal: [
        '30m Recall Proofing Goal',
        'Weekly Weight Log Reminder',
        'Submit Trial Entry Form',
      ],
      _EventCategory.physio: [
        'Hydrotherapy Treadmill',
        'Core Balance & Cavaletti',
      ],
      _EventCategory.competition: [
        'Regional IGP Club Trial',
        'Working Gundog Assessment',
      ],
    };

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final currentPresets = presets[chosenCat] ?? const [];
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSheetHandle(),
                    const SizedBox(height: 16),
                    Text(
                      'Add Event · ${_selectedDate.day} ${_shortMonths[_selectedDate.month - 1]} ${_selectedDate.year}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'EVENT TYPE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _availableCategories.map((cat) {
                          final selected = chosenCat == cat;
                          final color = _categoryColor(cat);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() => chosenCat = cat);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? color.withValues(alpha: 0.22)
                                      : _obsidian,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected ? color : _cardBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _categoryIcon(cat),
                                      size: 14,
                                      color: color,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _categoryLabel(cat),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12.5,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: selected ? _offWhite : _stoneGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'DOG WORKSPACE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _dogs.map((dog) {
                        final selected = chosenDog == dog;
                        return GestureDetector(
                          onTap: () => setModalState(() => chosenDog = dog),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _obsidian,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? _forest : _cardBorder,
                              ),
                            ),
                            child: Text(
                              dog,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: selected ? _mint : _stoneGrey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'EVENT TITLE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        color: _offWhite,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter session, check-up, or reminder title',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          color: _stoneGrey.withValues(alpha: 0.6),
                        ),
                        filled: true,
                        fillColor: _obsidian,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: _forest,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                    if (currentPresets.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: currentPresets.map((preset) {
                          return GestureDetector(
                            onTap: () {
                              titleCtrl.text = preset;
                              setModalState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _obsidian,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: Text(
                                preset,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: _stoneGrey,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TIME',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: _stoneGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children:
                                    ['09:00', '11:30', '14:30', '17:30'].map((t) {
                                  final active = chosenTime == t;
                                  return GestureDetector(
                                    onTap: () =>
                                        setModalState(() => chosenTime = t),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: active
                                            ? _forest.withValues(alpha: 0.24)
                                            : _obsidian,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: active ? _forest : _cardBorder,
                                        ),
                                      ),
                                      child: Text(
                                        t,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: active
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: active ? _offWhite : _stoneGrey,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: detailCtrl,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: _offWhite,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Duration or location (optional, e.g. 45 min)',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: _stoneGrey.withValues(alpha: 0.6),
                        ),
                        filled: true,
                        fillColor: _obsidian,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: _forest,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () {
                          final finalTitle = titleCtrl.text.trim().isEmpty
                              ? (currentPresets.isNotEmpty
                                  ? currentPresets.first
                                  : 'Scheduled ${_categoryLabel(chosenCat)}')
                              : titleCtrl.text.trim();
                          final finalDetail = detailCtrl.text.trim().isEmpty
                              ? (chosenCat == _EventCategory.training
                                  ? '45 min'
                                  : '')
                              : detailCtrl.text.trim();

                          _nextEventId++;
                          final created = _CalendarEventItem(
                            id: 'ev_$_nextEventId',
                            date: _selectedDate,
                            title: finalTitle,
                            dogName: chosenDog,
                            timeOrDue: chosenCat == _EventCategory.goal
                                ? 'Due $chosenTime'
                                : chosenTime,
                            detailOrLocation: finalDetail,
                            category: chosenCat,
                            isPlannedBadge: chosenCat == _EventCategory.goal ||
                                chosenCat == _EventCategory.competition,
                          );

                          setState(() {
                            _events.add(created);
                            if (_selectedDogFilter != 'All Dogs' &&
                                _selectedDogFilter != chosenDog) {
                              _selectedDogFilter = 'All Dogs';
                            }
                            if (_selectedCategoryFilter != null &&
                                _selectedCategoryFilter != chosenCat) {
                              _selectedCategoryFilter = null;
                            }
                          });

                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Event Scheduled',
                            message:
                                'Added "$finalTitle" for $chosenDog on ${_selectedDate.day} ${_shortMonths[_selectedDate.month - 1]}.',
                            type: SnackbarType.success,
                          );
                        },
                        child: const Text(
                          'Save to Calendar',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _eventsForDate(_selectedDate);
    final upcoming = _upcomingEvents;

    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEventSheet(),
        backgroundColor: _forest,
        foregroundColor: _offWhite,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            if (_searchVisible) _buildSearchFieldBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForestHeroBanner(),
                    _buildDogFilterStrip(),
                    _buildMonthNavigationRow(),
                    _buildViewModeTabsRow(),
                    _buildCategoryFilterPillsBar(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildActiveCalendarView(),
                          const SizedBox(height: 20),
                          _buildSelectedDayAgendaCard(dayEvents),
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.only(left: 2),
                            child: Text(
                              'UPCOMING',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: _stoneGrey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildUpcomingListCard(upcoming),
                        ],
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

  Widget _buildTopBar() {
    final hasActiveCategory = _selectedCategoryFilter != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 12, 12),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _stoneGrey,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Calendar',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible) _searchController.clear();
              });
            },
            icon: Icon(
              _searchVisible ? Icons.close_rounded : Icons.search_rounded,
              color: _searchVisible ? _mint : _stoneGrey,
              size: 21,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _openFilterSheet,
                icon: Icon(
                  Icons.tune_rounded,
                  color: hasActiveCategory ? _mint : _stoneGrey,
                  size: 21,
                ),
              ),
              if (hasActiveCategory)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFieldBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(bottom: BorderSide(color: _cardBorder)),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: _offWhite,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search sessions, vet visits, trials or dogs...',
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            color: _stoneGrey.withValues(alpha: 0.65),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 18,
            color: _stoneGrey,
          ),
          filled: true,
          fillColor: _carbon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
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
    );
  }

  Widget _buildForestHeroBanner() {
    final heroTitle =
        _selectedDogFilter == 'All Dogs' ? 'Murphy' : _selectedDogFilter;

    return SizedBox(
      height: 118,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/calendar_hero_banner.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: _carbon),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _obsidian.withValues(alpha: 0.72),
                  _obsidian.withValues(alpha: 0.38),
                  _obsidian.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        heroTitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: _offWhite,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatMonthYear(_displayedMonth),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: _stoneGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Image.asset(
                      'assets/images/calendar_dog_thumb.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: _carbon,
                        child: const Icon(
                          Icons.pets_rounded,
                          color: _mint,
                          size: 20,
                        ),
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

  Widget _buildDogFilterStrip() {
    final pills = ['All Dogs', ..._dogs];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF14181A),
        border: Border(
          top: BorderSide(color: _cardBorder),
          bottom: BorderSide(color: _cardBorder),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (final label in pills) ...[
              _buildDogPill(label),
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onTap: _openAddDogWorkspaceModal,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _carbon,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 18,
                  color: _stoneGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDogPill(String label) {
    final active = _selectedDogFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedDogFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? _forest.withValues(alpha: 0.22) : _carbon,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? _forest.withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? _mint : _stoneGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthNavigationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF14181A),
        border: Border(
          bottom: BorderSide(color: _cardBorder),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _changeMonth(-1),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.chevron_left_rounded,
                color: _stoneGrey,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _formatMonthYear(_displayedMonth),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.5,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _jumpToToday,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Today',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _mint,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _changeMonth(1),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.chevron_right_rounded,
                color: _stoneGrey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeTabsRow() {
    const items = <(_CalendarViewTab, String)>[
      (_CalendarViewTab.month, 'Month'),
      (_CalendarViewTab.week, 'Week'),
      (_CalendarViewTab.day, 'Day'),
      (_CalendarViewTab.year, 'Year'),
      (_CalendarViewTab.agenda, 'Agenda'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF14181A),
        border: Border(
          bottom: BorderSide(color: _cardBorder),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((entry) {
          final selected = _activeTab == entry.$1;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = entry.$1),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Text(
                    entry.$2,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? _offWhite : _stoneGrey,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2.2,
                  width: selected ? 44 : 0,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryFilterPillsBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _buildInlineCategoryPill(
            label: 'All Categories',
            dotColor: _mint,
            active: _selectedCategoryFilter == null,
            onTap: () => setState(() => _selectedCategoryFilter = null),
          ),
          for (final cat in _availableCategories) ...[
            const SizedBox(width: 8),
            _buildInlineCategoryPill(
              label: _categoryLabel(cat),
              dotColor: _categoryColor(cat),
              active: _selectedCategoryFilter == cat,
              onTap: () {
                setState(() {
                  _selectedCategoryFilter =
                      _selectedCategoryFilter == cat ? null : cat;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInlineCategoryPill({
    required String label,
    required Color dotColor,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _forest.withValues(alpha: 0.20) : _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? _forest.withValues(alpha: 0.7) : _cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.5,
              height: 6.5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? _offWhite : _stoneGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCalendarView() {
    switch (_activeTab) {
      case _CalendarViewTab.month:
        return _buildMonthGridCard();
      case _CalendarViewTab.week:
        return _buildWeekLoadCard();
      case _CalendarViewTab.day:
        return _buildDayFocusCard();
      case _CalendarViewTab.year:
        return _buildYearOverviewCard();
      case _CalendarViewTab.agenda:
        return _buildMasterAgendaSummaryCard();
    }
  }

  Widget _buildMonthGridCard() {
    final firstOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final leadingDays = firstOfMonth.weekday - 1; // MON=0 .. SUN=6
    final startCellDate = firstOfMonth.subtract(Duration(days: leadingDays));
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final totalUsedCells = leadingDays + daysInMonth;
    final rowCount = (totalUsedCells / 7).ceil();

    const headers = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: headers
                .map(
                  (h) => Expanded(
                    child: Center(
                      child: Text(
                        h,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                          color: _stoneGrey,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(height: 1, color: _cardBorder),
          ),
          const SizedBox(height: 12),
          for (int row = 0; row < rowCount; row++) ...[
            if (row > 0) const SizedBox(height: 10),
            Row(
              children: [
                for (int col = 0; col < 7; col++)
                  Expanded(
                    child: _buildMonthDayCell(
                      startCellDate.add(Duration(days: row * 7 + col)),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthDayCell(DateTime cellDate) {
    final inCurrentMonth = cellDate.month == _displayedMonth.month &&
        cellDate.year == _displayedMonth.year;
    final isSelected = _isSameDay(cellDate, _selectedDate);
    final cellEvents = inCurrentMonth ? _eventsForDate(cellDate) : const <_CalendarEventItem>[];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = cellDate;
          if (!inCurrentMonth) {
            _displayedMonth = DateTime(cellDate.year, cellDate.month, 1);
          }
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: isSelected
                  ? BoxDecoration(
                      color: _forest.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _forest,
                        width: 1.3,
                      ),
                    )
                  : null,
              child: Text(
                '${cellDate.day}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: !inCurrentMonth
                      ? _mutedOutMonth
                      : (isSelected ? _mint : _offWhite),
                ),
              ),
            ),
            const SizedBox(height: 3),
            if (cellEvents.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0;
                      i < (cellEvents.length > 3 ? 2 : cellEvents.length);
                      i++) ...[
                    if (i > 0) const SizedBox(width: 3),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _categoryColor(cellEvents[i].category),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  if (cellEvents.length > 3) ...[
                    const SizedBox(width: 3),
                    Text(
                      '+${cellEvents.length - 2}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekLoadCard() {
    final monday =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final weekDates = List.generate(7, (i) => monday.add(Duration(days: i)));
    final counts = weekDates.map((d) => _eventsForDate(d).length).toList();
    final maxCount = counts.fold<int>(1, (m, c) => c > m ? c : m);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week of ${monday.day} ${_shortMonths[monday.month - 1]}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
              Text(
                '${counts.fold<int>(0, (a, b) => a + b)} scheduled items',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: _mint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDate = weekDates[i]),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        Text(
                          '${counts[i]}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5,
                            color: _isSameDay(weekDates[i], _selectedDate)
                                ? _mint
                                : _stoneGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          width: 18,
                          height: 10.0 + (counts[i] / maxCount) * 52.0,
                          decoration: BoxDecoration(
                            color: _isSameDay(weekDates[i], _selectedDate)
                                ? _forest
                                : _forest.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _shortWeekdays[i].toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _isSameDay(weekDates[i], _selectedDate)
                                ? _mint
                                : _stoneGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${weekDates[i].day}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: _isSameDay(weekDates[i], _selectedDate)
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: _offWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayFocusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                _displayedMonth =
                    DateTime(_selectedDate.year, _selectedDate.month, 1);
              });
            },
            icon: const Icon(Icons.chevron_left_rounded, color: _stoneGrey),
          ),
          Column(
            children: [
              const Text(
                'FOCUSED DAY SCHEDULE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: _mint,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatSelectedDayHeading(_selectedDate),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
                _displayedMonth =
                    DateTime(_selectedDate.year, _selectedDate.month, 1);
              });
            },
            icon: const Icon(Icons.chevron_right_rounded, color: _stoneGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildYearOverviewCard() {
    final year = _displayedMonth.year;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
        ),
        itemBuilder: (context, idx) {
          final monthNum = idx + 1;
          final isCurrent = _displayedMonth.month == monthNum;
          final count = _events
              .where(
                (e) =>
                    e.date.year == year &&
                    e.date.month == monthNum &&
                    _matchesActiveFilters(e),
              )
              .length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _displayedMonth = DateTime(year, monthNum, 1);
                _selectedDate = DateTime(year, monthNum, 1);
                _activeTab = _CalendarViewTab.month;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCurrent
                    ? _forest.withValues(alpha: 0.22)
                    : _obsidian,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent ? _forest : _cardBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _shortMonths[idx],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isCurrent ? _mint : _offWhite,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$count events',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: _stoneGrey,
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

  Widget _buildMasterAgendaSummaryCard() {
    final monthItems = _events
        .where(
          (e) =>
              e.date.year == _displayedMonth.year &&
              e.date.month == _displayedMonth.month &&
              _matchesActiveFilters(e),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_formatMonthYear(_displayedMonth)} Master Agenda (${monthItems.length})',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _offWhite,
            ),
          ),
          const SizedBox(height: 12),
          if (monthItems.isEmpty)
            const Text(
              'No events match your current filters this month.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: _stoneGrey,
              ),
            )
          else
            for (int i = 0; i < monthItems.take(6).length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _buildSelectedDayEventTile(monthItems[i], showDatePrefix: true),
            ],
        ],
      ),
    );
  }

  Widget _buildSelectedDayAgendaCard(List<_CalendarEventItem> dayEvents) {
    final countLabel =
        dayEvents.length == 1 ? '1 event' : '${dayEvents.length} events';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _formatSelectedDayHeading(_selectedDate),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Text(
                countLabel,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _stoneGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (dayEvents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: _innerCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No sessions, vet visits, or goals scheduled on this day yet. Use a quick action below to schedule one.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  height: 1.45,
                  color: _stoneGrey,
                ),
              ),
            )
          else
            for (int i = 0; i < dayEvents.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _buildSelectedDayEventTile(dayEvents[i]),
            ],
          const SizedBox(height: 16),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickAddLink(
                label: '+ Add Training',
                onTap: () => _openAddEventSheet(
                  initialCategory: _EventCategory.training,
                ),
              ),
              _buildQuickAddLink(
                label: '+ Add Health',
                onTap: () => _openAddEventSheet(
                  initialCategory: _EventCategory.health,
                ),
              ),
              _buildQuickAddLink(
                label: '+ Add Reminder',
                onTap: () => _openAddEventSheet(
                  initialCategory: _EventCategory.goal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayEventTile(
    _CalendarEventItem item, {
    bool showDatePrefix = false,
  }) {
    final accent = _categoryColor(item.category);
    final subtitleParts = <String>[
      if (showDatePrefix) '${item.date.day} ${_shortMonths[item.date.month - 1]}',
      item.dogName,
      item.timeOrDue,
      if (item.detailOrLocation.isNotEmpty) item.detailOrLocation,
    ];

    return Material(
      color: _innerCard,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openEventDetailsSheet(item),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 13, 12, 13),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _obsidian.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _categoryIcon(item.category),
                          size: 17,
                          color: item.category == _EventCategory.training
                              ? _mint
                              : accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      decoration: item.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: item.isCompleted
                                          ? _stoneGrey
                                          : _offWhite,
                                    ),
                                  ),
                                ),
                                if (item.isPlannedBadge || item.isCompleted) ...[
                                  const SizedBox(width: 8),
                                  _buildStatusPill(
                                    item.isCompleted ? 'DONE' : 'PLANNED',
                                    isDone: item.isCompleted,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitleParts.join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                color: _stoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: _stoneGrey,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAddLink({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _mint,
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingListCard(List<_CalendarEventItem> upcoming) {
    if (upcoming.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: const Text(
          'No upcoming events after the selected date match your filters.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: _stoneGrey,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < upcoming.length; i++) ...[
            if (i > 0) Container(height: 1, color: _cardBorder),
            _buildUpcomingRow(upcoming[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildUpcomingRow(_CalendarEventItem item) {
    final accent = _categoryColor(item.category);
    final IconData upcomingIcon = item.title.contains('Vaccination')
        ? Icons.vaccines_outlined
        : (item.title.contains('Weight')
            ? Icons.hourglass_empty_rounded
            : _categoryIcon(item.category));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDate = item.date;
            _displayedMonth = DateTime(item.date.year, item.date.month, 1);
          });
          _openEventDetailsSheet(item);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
          child: Row(
            children: [
              Container(
                width: 5.5,
                height: 5.5,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                upcomingIcon,
                size: 18,
                color: accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: _offWhite,
                            ),
                          ),
                        ),
                        if (item.isPlannedBadge || item.isCompleted) ...[
                          const SizedBox(width: 8),
                          _buildStatusPill(
                            item.isCompleted ? 'DONE' : 'PLANNED',
                            isDone: item.isCompleted,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_formatUpcomingDate(item.date)} · ${item.dogName}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _stoneGrey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(String text, {bool isDone = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDone
            ? _forest.withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDone ? _mint : _stoneGrey,
        ),
      ),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
