import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'timeline_event_details_screen.dart';
import 'timeline_filters_screen.dart';
import 'timeline_search_screen.dart';
import 'record_session_screen.dart';
import 'add_health_record_screen.dart';
import 'timeline_statistics_screen.dart';

/// Calendar View Mode (Batch 6 - Lines 179, 180, 181)
enum CalendarViewMode { month, week, day }

/// Timeline Calendar Screen
/// Integrates:
/// - Line 179: Timeline Calendar - Month View
/// - Line 180: Timeline Calendar - Day View
/// - Line 181: Timeline Calendar - Week View
class TimelineCalendarScreen extends StatefulWidget {
  final CalendarViewMode initialViewMode;
  final DateTime? initialDate;

  const TimelineCalendarScreen({
    super.key,
    this.initialViewMode = CalendarViewMode.month,
    this.initialDate,
  });

  @override
  State<TimelineCalendarScreen> createState() => _TimelineCalendarScreenState();
}

class _TimelineCalendarScreenState extends State<TimelineCalendarScreen>
    with TickerProviderStateMixin {
  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _surfaceVariant = Color(0xFF323533);
  static const Color _surfaceContainer = Color(0xFF1D201F);
  static const Color _surfaceDim = Color(0xFF111412);
  static const Color _offWhite = Color(0xFFE1E3E0);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _muted = Color(0xFF89938E);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _errorMuted = Color(0xFF8B3A3A);
  static const Color _errorLight = Color(0xFFFFB4AB);
  static const Color _catSc = Color(0xFFB4823C);
  static const Color _catGoals = Color(0xFFB8920A);
  static const Color _catMedia = Color(0xFF7A5BAF);
  static const Color _borderHairline = Color(0x14FFFFFF);

  // ─── Image URLs ─────────────────────────────────────────────────────────────
  static const String _agilityPhotoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBEu8L92JTrAd1YoW5Go2hVl0UrcTlEInKlG5bpALn7PNs7XJ-gJ8DDxWcquZEH6pOk6iWB5L2GkFvGvIRHhFBGq6EUH6lyXyp189QQlnuYHBqvpWvfUuc-Wlo8QmGr2I5vlxyJarkGdtVTIB4CwepVJl1TOMNK4vmbDTeoF9-j1oFCYNrU6qdv46D3XWj6RCqsic3ylOUmF2g9FTTHfg2dtWex6yfmG6naC2csjAYo7fZZCnCBf14';
  static const String _targetPawsPhotoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC2GIKXJThtHrBwz1YNhUg4KkKsdFbAwPgDag8EtquFaegWBBcMziMQXBOPhwcFScfZAlijh2DQrf9QCEZzBObyttw6eUeulEZXM7fPjEAoYpM9i7J1WGxfY8LCx3SZdY4bwSCpdW4pNrM-fkPlTyUlwrfVYgBBaCeqTtM4HR30c4dkAeyO-uqvFzwIBHVDosVdIHB_qCxo5PzI4-OtSDaLNHl1i-53riPLZpM-urrgeRQ2EAJcIZI';

  // ─── State ─────────────────────────────────────────────────────────────────
  late CalendarViewMode _viewMode;
  late DateTime _selectedDate;
  late DateTime _displayedMonth; // First day of the month currently shown
  String _selectedDog = 'Atlas'; // Atlas | Nova | All
  bool _weekDetailsExpanded = false;
  int _graphTouchedIndex = -1;

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _chartAnimController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _chartProgress;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.initialViewMode;
    // Default to August 14, 2026 for populated month state (as in Figma)
    // or August 27, 2026 for populated day state
    final initial = widget.initialDate ??
        (_viewMode == CalendarViewMode.day
            ? DateTime(2026, 8, 27)
            : DateTime(2026, 8, 14));
    _selectedDate = initial;
    _displayedMonth = DateTime(initial.year, initial.month, 1);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );

    _fadeController.forward();
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chartAnimController.dispose();
    super.dispose();
  }

  void _switchViewMode(CalendarViewMode mode) {
    if (_viewMode == mode) return;
    setState(() {
      _viewMode = mode;
      _fadeController.forward(from: 0.0);
      _chartAnimController.forward(from: 0.0);
    });
  }

  void _selectDate(DateTime date, {bool autoSwitchToDay = false}) {
    setState(() {
      _selectedDate = date;
      _displayedMonth = DateTime(date.year, date.month, 1);
      if (autoSwitchToDay) {
        _viewMode = CalendarViewMode.day;
      }
      _chartAnimController.forward(from: 0.0);
    });
  }

  void _jumpToToday() {
    // Set to 27 August 2026 (the "Today" anchor in the design)
    final today = DateTime(2026, 8, 27);
    _selectDate(today);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
        1,
      );
      // Keep selected date within bounds
      if (_selectedDate.month != _displayedMonth.month ||
          _selectedDate.year != _displayedMonth.year) {
        _selectedDate = DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          _selectedDate.day.clamp(1, _daysInMonth(_displayedMonth)),
        );
      }
      _chartAnimController.forward(from: 0.0);
    });
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
      _displayedMonth = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        1,
      );
      _chartAnimController.forward(from: 0.0);
    });
  }

  void _changeWeek(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta * 7));
      _displayedMonth = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        1,
      );
      _chartAnimController.forward(from: 0.0);
    });
  }

  int _daysInMonth(DateTime dt) {
    final nextMonth = DateTime(dt.year, dt.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  // ─── Mock Data Repository ───────────────────────────────────────────────────

  /// Category indicator dots for days in August 2026
  List<Color> _getDotsForDay(DateTime date) {
    if (date.year != 2026 || date.month != 8) return [];
    switch (date.day) {
      case 1:
        return [_alpineBlue];
      case 3:
        return [_catSc, _catMedia];
      case 5:
        return [_alpineBlue];
      case 7:
        return [_catGoals];
      case 9:
        return [_errorMuted];
      case 11:
        return [_alpineBlue, _catSc];
      case 13:
        return [_alpineBlue];
      case 14:
        return [_alpineBlue, _mint, _errorMuted];
      case 15:
        return [_mint];
      case 16:
        return [_mint];
      case 27: // Today
        return [_alpineBlue, _mint];
      default:
        return [];
    }
  }

  /// Summary count of events on selected date
  Map<String, dynamic> _getDailySummary(DateTime date) {
    if (date.day == 14 && date.month == 8 && date.year == 2026) {
      return {
        'training': 3,
        'health': 1,
        'sc': 1,
        'goals': null,
        'media': 2,
        'comp': 1,
        'total': 6,
      };
    } else if (date.day == 27 && date.month == 8 && date.year == 2026) {
      return {
        'training': 2,
        'health': null,
        'sc': 1,
        'goals': 1,
        'media': 3,
        'comp': null,
        'total': 5,
      };
    } else if (date.day == 20 && date.month == 8 && date.year == 2026) {
      return {
        'training': 0,
        'health': 0,
        'sc': 0,
        'goals': null,
        'media': 0,
        'comp': null,
        'total': 0,
      };
    } else if (_getDotsForDay(date).isNotEmpty) {
      return {
        'training': 1,
        'health': 1,
        'sc': null,
        'goals': null,
        'media': 1,
        'comp': null,
        'total': 2,
      };
    }
    return {
      'training': 0,
      'health': 0,
      'sc': 0,
      'goals': null,
      'media': 0,
      'comp': null,
      'total': 0,
    };
  }

  /// Events for a given date
  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    if (date.day == 14 && date.month == 8 && date.year == 2026) {
      return [
        {
          'time': '08:00',
          'duration': '60 min',
          'category': 'TRAINING',
          'categoryLabel': 'Training',
          'color': _alpineBlue,
          'icon': Icons.pets,
          'title': 'Tracking — Field Exercise',
          'location': 'North Pine Forest',
          'desc':
              'Track lay 45 min prior, 3 articles recovered cleanly. Strong wind from NW.',
          'type': 'training',
        },
        {
          'time': '13:30',
          'duration': '30 min',
          'category': 'HEALTH',
          'categoryLabel': 'Health',
          'color': _errorLight,
          'icon': Icons.local_hospital,
          'title': 'Annual Vaccination Booster',
          'location': 'Vet Clinic Center',
          'desc':
              'DHPP & Rabies booster administered. Weight verified at 34.2 kg.',
          'type': 'health',
        },
        {
          'time': '18:00',
          'duration': '90 min',
          'category': 'COMPETITION',
          'categoryLabel': 'Competition',
          'color': _mint,
          'icon': Icons.sports_score,
          'title': 'IGP3 Regional Trial',
          'location': 'Regional Stadium',
          'desc':
              'High scoring obedience routine (96/100). Flawless dumbbell retrieve over hurdle.',
          'type': 'training',
        },
        {
          'time': '10:30',
          'duration': '45 min',
          'category': 'S&C',
          'categoryLabel': 'S&C',
          'color': _catSc,
          'icon': Icons.fitness_center,
          'title': 'Core Stability & Proprioception',
          'location': 'Home Gym',
          'desc': 'Peanut ball balancing drills and rear-end awareness work.',
          'type': 'training',
        },
        {
          'time': '16:00',
          'duration': 'Upload',
          'category': 'MEDIA',
          'categoryLabel': 'Media',
          'color': _catMedia,
          'icon': Icons.photo_camera,
          'title': 'Trial Field Media Upload',
          'location': 'Media Vault',
          'desc': '3 photos and 1 slow-mo video clip uploaded.',
          'type': 'training',
        },
      ];
    } else if (date.day == 27 && date.month == 8 && date.year == 2026) {
      return [
        {
          'time': '08:30',
          'duration': '60 min',
          'category': 'TRAINING',
          'categoryLabel': 'Training',
          'color': _mint,
          'icon': Icons.pets,
          'title': 'Morning Obedience',
          'location': 'Local Park',
          'desc':
              'Focused on loose leash walking and basic sit/stay commands with high distractions in the local park.',
          'type': 'training',
        },
        {
          'time': '10:00',
          'duration': '45 min',
          'category': 'S&C',
          'categoryLabel': 'S&C',
          'color': _alpineBlue,
          'icon': Icons.fitness_center,
          'title': 'Core & Balance',
          'location': 'Training Hall',
          'desc': 'Peanut ball exercises and cavaletti drills.',
          'type': 'training',
        },
        {
          'time': '12:15',
          'duration': 'Log',
          'category': 'MILESTONE',
          'categoryLabel': 'Goal',
          'color': const Color(0xFFF59E0B),
          'icon': Icons.emoji_events,
          'title': 'Achieved 5min Out-of-Sight Stay',
          'location': 'Training Facility',
          'desc': 'Goal completed 2 weeks ahead of schedule.',
          'type': 'training',
        },
        {
          'time': '16:00',
          'duration': '90 min',
          'category': 'TRAINING',
          'categoryLabel': 'Training',
          'color': _mint,
          'icon': Icons.directions_run,
          'title': 'Agility Drills',
          'location': 'Agility Course',
          'desc':
              'Focusing on tight turns and weave pole entries. Field conditions were muddy.',
          'type': 'training',
        },
        {
          'time': '18:30',
          'duration': 'Upload',
          'category': 'MEDIA',
          'categoryLabel': 'Media',
          'color': _stoneGrey,
          'icon': Icons.photo_camera,
          'title': 'Session Recordings',
          'location': 'Local Park & Hall',
          'desc': '3 media assets attached.',
          'type': 'media',
          'hasMedia': true,
        },
      ];
    }
    return [];
  }

  // ─── Builder Methods ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildTopAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildViewSelectorPill(),
                  const SizedBox(height: 20),
                  if (_viewMode == CalendarViewMode.month) ...[
                    _buildMonthCalendarCard(),
                    const SizedBox(height: 24),
                    _buildInteractiveGraphCard('Monthly Activity Cadence'),
                    const SizedBox(height: 24),
                    _buildDailySummaryCard(),
                    const SizedBox(height: 16),
                    _buildEventsListSection(),
                  ] else if (_viewMode == CalendarViewMode.week) ...[
                    _buildWeekStripCard(),
                    const SizedBox(height: 12),
                    _buildWeekSelectedDayPreview(),
                    const SizedBox(height: 24),
                    _buildInteractiveGraphCard('Weekly Workload Distribution'),
                    const SizedBox(height: 24),
                    _buildWeekDetailsEventList(),
                  ] else ...[
                    _buildDayDateNavStrip(),
                    const SizedBox(height: 20),
                    _buildDayDailySummaryCard(),
                    const SizedBox(height: 24),
                    _buildInteractiveGraphCard('Hourly Activity Schedule'),
                    const SizedBox(height: 24),
                    _buildDayTimelineEvents(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFab(),
    );
  }

  // ─── Top App Bar ────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _mint, size: 22),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Timeline Calendar',
        style: TextStyle(
          color: _offWhite,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: false,
      actions: [
        // "Today" Button
        TextButton(
          onPressed: _jumpToToday,
          style: TextButton.styleFrom(
            foregroundColor: _mint,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text(
            'Today',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _mint,
            ),
          ),
        ),
        // Filter / Search Shortcut
        IconButton(
          icon: const Icon(Icons.search, color: _stoneGrey, size: 20),
          tooltip: 'Search Timeline',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TimelineSearchScreen(),
              ),
            );
          },
        ),
        // Timeline Statistics Shortcut
        IconButton(
          icon: const Icon(Icons.insights_outlined, color: _stoneGrey, size: 20),
          tooltip: 'Timeline Statistics',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TimelineStatisticsScreen(),
              ),
            );
          },
        ),
        // More Options
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: _stoneGrey, size: 22),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: _borderHairline),
          ),
          onSelected: (val) {
            if (val == 'statistics') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineStatisticsScreen(),
                ),
              );
            } else if (val == 'switch_dog') {
              _showDogSelectorDialog();
            } else if (val == 'filters') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineFiltersScreen(),
                ),
              );
            } else if (val == 'reset_month') {
              _selectDate(DateTime(2026, 8, 14));
            } else if (val == 'empty_test') {
              _selectDate(DateTime(2026, 8, 20), autoSwitchToDay: true);
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(
              value: 'statistics',
              child: Row(
                children: [
                  Icon(Icons.insights_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Statistics',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'switch_dog',
              child: Row(
                children: [
                  const Icon(Icons.pets, color: _mint, size: 18),
                  const SizedBox(width: 10),
                  Text('Dog: $_selectedDog',
                      style: const TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'filters',
              child: Row(
                children: [
                  Icon(Icons.tune, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Filters',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'reset_month',
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: _alpineBlue, size: 18),
                  SizedBox(width: 10),
                  Text('View 14 Aug (Populated)',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'empty_test',
              child: Row(
                children: [
                  Icon(Icons.event_busy, color: _errorLight, size: 18),
                  SizedBox(width: 10),
                  Text('View 20 Aug (Empty State)',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Segmented View Selector ────────────────────────────────────────────────

  Widget _buildViewSelectorPill() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderHairline),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildSegmentButton(
            label: 'Month',
            isSelected: _viewMode == CalendarViewMode.month,
            onTap: () => _switchViewMode(CalendarViewMode.month),
          ),
          _buildSegmentButton(
            label: 'Week',
            isSelected: _viewMode == CalendarViewMode.week,
            onTap: () => _switchViewMode(CalendarViewMode.week),
          ),
          _buildSegmentButton(
            label: 'Day',
            isSelected: _viewMode == CalendarViewMode.day,
            onTap: () => _switchViewMode(CalendarViewMode.day),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? _forest : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? _offWhite : _muted,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Month View Card ────────────────────────────────────────────────────────

  Widget _buildMonthCalendarCard() {
    final monthName = _formatMonthYear(_displayedMonth);
    final daysInMonth = _daysInMonth(_displayedMonth);
    // Find weekday of 1st day (1 = Mon, 7 = Sun)
    final firstWeekday = _displayedMonth.weekday; // 1 = Monday
    final leadDays = firstWeekday - 1; // 0 for Mon, 6 for Sun

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderHairline),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left,
                        color: _stoneGrey, size: 22),
                    onPressed: () => _changeMonth(-1),
                    splashRadius: 18,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right,
                        color: _stoneGrey, size: 22),
                    onPressed: () => _changeMonth(1),
                    splashRadius: 18,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Day of Week Header: M T W T F S S
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar Grid
          _buildMonthGrid(leadDays, daysInMonth),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(int leadDays, int daysInMonth) {
    final totalCells = leadDays + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - leadDays + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 48));
              }

              final cellDate = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                dayNumber,
              );
              final isSelected = cellDate.year == _selectedDate.year &&
                  cellDate.month == _selectedDate.month &&
                  cellDate.day == _selectedDate.day;
              final isToday = cellDate.year == 2026 &&
                  cellDate.month == 8 &&
                  cellDate.day == 27;

              final dots = _getDotsForDay(cellDate);

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _selectDate(cellDate),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _forest
                          : isToday
                              ? _carbon
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: _mint, width: 1)
                          : isToday
                              ? Border.all(color: _mint, width: 1)
                              : null,
                    ),
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: isSelected
                                ? _offWhite
                                : isToday
                                    ? _mint
                                    : _offWhite,
                            fontSize: 13,
                            fontWeight: isSelected || isToday
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Dots
                        if (dots.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dots
                                .take(3)
                                .map((color) => Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ))
                                .toList(),
                          )
                        else
                          const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  // ─── Daily Summary Card (Month View) ────────────────────────────────────────

  Widget _buildDailySummaryCard() {
    final summary = _getDailySummary(_selectedDate);
    final dayLabel = '${_selectedDate.day} ${_monthAbbr(_selectedDate.month)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$dayLabel Summary',
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _switchViewMode(CalendarViewMode.day),
              child: const Row(
                children: [
                  Text(
                    'Full Day View',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: _mint, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3x2 Grid
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderHairline),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildSummaryCell(
                    label: 'TRAINING',
                    dotColor: _alpineBlue,
                    count: summary['training'],
                    isRightBorder: true,
                    isBottomBorder: true,
                  ),
                  _buildSummaryCell(
                    label: 'HEALTH',
                    dotColor: _errorMuted,
                    count: summary['health'],
                    isRightBorder: true,
                    isBottomBorder: true,
                  ),
                  _buildSummaryCell(
                    label: 'S&C',
                    dotColor: _catSc,
                    count: summary['sc'],
                    isRightBorder: false,
                    isBottomBorder: true,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildSummaryCell(
                    label: 'GOALS',
                    dotColor: _catGoals,
                    count: summary['goals'],
                    isRightBorder: true,
                    isBottomBorder: false,
                  ),
                  _buildSummaryCell(
                    label: 'MEDIA',
                    dotColor: _catMedia,
                    count: summary['media'],
                    isRightBorder: true,
                    isBottomBorder: false,
                  ),
                  _buildSummaryCell(
                    label: 'COMP.',
                    dotColor: _forest,
                    count: summary['comp'],
                    isRightBorder: false,
                    isBottomBorder: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCell({
    required String label,
    required Color dotColor,
    required dynamic count,
    required bool isRightBorder,
    required bool isBottomBorder,
  }) {
    final countText = count == null
        ? '—'
        : count == 0
            ? '0'
            : '$count';

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            right: isRightBorder
                ? const BorderSide(color: _borderHairline, width: 1)
                : BorderSide.none,
            bottom: isBottomBorder
                ? const BorderSide(color: _borderHairline, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              countText,
              style: TextStyle(
                color: count == null ? _muted : _offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Event List for Selected Date (Month View) ──────────────────────────────

  Widget _buildEventsListSection() {
    final events = _getEventsForDate(_selectedDate);

    if (events.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderHairline),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: _forest.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.event_busy, color: _mint, size: 22),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Events Recorded',
              style: TextStyle(
                color: _offWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nothing was recorded for this date. Keep track of progress by logging an event.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickActionBtn(
                  label: '+ Training',
                  onTap: () => _openRecordEvent('training'),
                ),
                const SizedBox(width: 12),
                _buildQuickActionBtn(
                  label: '+ Health',
                  onTap: () => _openRecordEvent('health'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: events.map((ev) => _buildMonthEventCard(ev)).toList(),
    );
  }

  Widget _buildMonthEventCard(Map<String, dynamic> ev) {
    final color = ev['color'] as Color;
    final title = ev['title'] as String;
    final category = ev['categoryLabel'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openEventDetails(ev),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left indicator bar
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        category,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: _muted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Week View Components ───────────────────────────────────────────────────

  Widget _buildWeekStripCard() {
    // Calculate week start (Monday)
    final weekday = _selectedDate.weekday; // 1 = Mon
    final monday = _selectedDate.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final weekRangeText =
        '${monday.day}–${sunday.day} ${_monthAbbr(sunday.month).toUpperCase()} ${sunday.year}';

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderHairline),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Nav header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: _stoneGrey, size: 20),
                onPressed: () => _changeWeek(-1),
                splashRadius: 18,
                visualDensity: VisualDensity.compact,
              ),
              Text(
                weekRangeText,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.chevron_right, color: _stoneGrey, size: 20),
                onPressed: () => _changeWeek(1),
                splashRadius: 18,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 7 columns
          Row(
            children: List.generate(7, (index) {
              final dayDate = monday.add(Duration(days: index));
              final isSelected = dayDate.year == _selectedDate.year &&
                  dayDate.month == _selectedDate.month &&
                  dayDate.day == _selectedDate.day;
              final dots = _getDotsForDay(dayDate);
              final dayAbbr = _weekdayAbbr(dayDate.weekday);
              final eventCount = _getDailySummary(dayDate)['total'] as int? ?? 0;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _selectDate(dayDate),
                  child: Column(
                    children: [
                      Text(
                        dayAbbr,
                        style: TextStyle(
                          color: isSelected ? _mint : _muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _mint
                                  : (dayDate.day == 13
                                      ? _forest
                                      : Colors.transparent),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${dayDate.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : (dayDate.day == 13 ? _offWhite : _offWhite),
                                fontSize: 13,
                                fontWeight: isSelected || dayDate.day == 13
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          // Badge count if selected (like the "6" badge in screenshot)
                          if (isSelected && eventCount > 0)
                            Positioned(
                              top: -6,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _surfaceVariant,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: _borderHairline, width: 0.5),
                                ),
                                child: Text(
                                  '$eventCount',
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Indicator dots
                      SizedBox(
                        height: 6,
                        child: dots.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: dots
                                    .take(3)
                                    .map((c) => Container(
                                          width: 4.5,
                                          height: 4.5,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: c,
                                            shape: BoxShape.circle,
                                          ),
                                        ))
                                    .toList(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelectedDayPreview() {
    final summary = _getDailySummary(_selectedDate);
    final total = summary['total'] as int? ?? 0;
    final dayOfWeek = _weekdayAbbr(_selectedDate.weekday);
    final monthAbbr = _monthAbbr(_selectedDate.month).toUpperCase();
    final headerTitle = '$dayOfWeek · ${_selectedDate.day} $monthAbbr';

    return Container(
      decoration: BoxDecoration(
        color: _carbon.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(color: _borderHairline),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headerTitle,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$total Events',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (total > 0) ...[
            _buildWeekPreviewRow(
              color: _alpineBlue,
              text: '08:00 - Tracking Session (Forest)',
            ),
            const SizedBox(height: 4),
            _buildWeekPreviewRow(
              color: _errorLight,
              text: '13:30 - Annual Vaccination',
            ),
            const SizedBox(height: 4),
            _buildWeekPreviewRow(
              color: _mint,
              text: '18:00 - IGP3 Trial Preparation',
            ),
          ] else
            const Text(
              'No scheduled entries for this day.',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekPreviewRow({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDetailsEventList() {
    final events = _getEventsForDate(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => _switchViewMode(CalendarViewMode.day),
              child: const Text('Open in Day View',
                  style: TextStyle(color: _mint, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (events.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderHairline),
            ),
            child: const Center(
              child: Text(
                'No events for this date.',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ),
          )
        else ...[
          ...events
              .take(_weekDetailsExpanded ? events.length : 3)
              .map((ev) => _buildWeekDetailCard(ev)),
          if (events.length > 3)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _weekDetailsExpanded = !_weekDetailsExpanded;
                  });
                },
                child: Text(
                  _weekDetailsExpanded
                      ? 'Show fewer events'
                      : 'View ${events.length - 3} more events',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildWeekDetailCard(Map<String, dynamic> ev) {
    final color = ev['color'] as Color;
    final time = ev['time'] as String;
    final category = ev['category'] as String;
    final title = ev['title'] as String;
    final location = ev['location'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openEventDetails(ev),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline node ring
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: _carbon, width: 2),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 38,
                      color: _borderHairline,
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: _muted, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 12,
                            ),
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
      ),
    );
  }

  // ─── Day View Components ────────────────────────────────────────────────────

  Widget _buildDayDateNavStrip() {
    final dayNum = _selectedDate.day;
    final monthStr = _monthAbbr(_selectedDate.month).toUpperCase();
    final yearStr = '${_selectedDate.year}';
    final isToday = _selectedDate.day == 27 &&
        _selectedDate.month == 8 &&
        _selectedDate.year == 2026;

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: _stoneGrey, size: 22),
            onPressed: () => _changeDay(-1),
            splashRadius: 18,
            visualDensity: VisualDensity.compact,
          ),
          Row(
            children: [
              Text(
                '$dayNum $monthStr $yearStr',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              if (isToday) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'TODAY',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: _stoneGrey, size: 22),
            onPressed: () => _changeDay(1),
            splashRadius: 18,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildDayDailySummaryCard() {
    final summary = _getDailySummary(_selectedDate);

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderHairline),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: _mint, size: 20),
              SizedBox(width: 8),
              Text(
                'Daily Summary',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 3 cols x 2 rows
          Row(
            children: [
              _buildDaySummaryMetric('TRAINING', summary['training']),
              _buildDaySummaryMetric('HEALTH', summary['health']),
              _buildDaySummaryMetric('S&C', summary['sc']),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildDaySummaryMetric('GOAL', summary['goals']),
              _buildDaySummaryMetric('MEDIA', summary['media']),
              _buildDaySummaryMetric('COMP', summary['comp']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySummaryMetric(String label, dynamic count) {
    final countStr = count == null
        ? '—'
        : count == 0
            ? '0'
            : '$count';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            countStr,
            style: TextStyle(
              color: count == null ? _muted : _offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTimelineEvents() {
    final events = _getEventsForDate(_selectedDate);

    if (events.isEmpty) {
      // Empty State for Day (e.g. 20 AUG)
      return Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderHairline),
        ),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: _forest.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.event_busy, color: _mint, size: 22),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Events Recorded',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Nothing was recorded for this date. Keep track of your dog's progress by logging an event.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _muted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(DateTime(2026, 8, 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('View Previous Events',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickActionBtn(
                  label: '+ Training',
                  onTap: () => _openRecordEvent('training'),
                ),
                const SizedBox(width: 12),
                _buildQuickActionBtn(
                  label: '+ Health',
                  onTap: () => _openRecordEvent('health'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Populated vertical timeline track
    return Stack(
      children: [
        // Continuous vertical line
        Positioned(
          left: 10,
          top: 24,
          bottom: 24,
          child: Container(
            width: 1,
            color: _borderHairline,
          ),
        ),
        // Event cards
        Column(
          children: events.map((ev) => _buildDayTimelineCard(ev)).toList(),
        ),
      ],
    );
  }

  Widget _buildDayTimelineCard(Map<String, dynamic> ev) {
    final color = ev['color'] as Color;
    final time = ev['time'] as String;
    final duration = ev['duration'] as String;
    final category = ev['category'] as String;
    final title = ev['title'] as String;
    final desc = ev['desc'] as String;
    final icon = ev['icon'] as IconData;
    final hasMedia = ev['hasMedia'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Container(
            width: 21,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: _obsidian, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Main Event Card
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderHairline),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openEventDetails(ev),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time Column
                        SizedBox(
                          width: 58,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                time,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                duration,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(icon, color: color, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                desc,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                              // Media previews if attached
                              if (hasMedia) ...[
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 80,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      _buildMediaThumb(_agilityPhotoUrl),
                                      const SizedBox(width: 8),
                                      _buildMediaThumb(_targetPawsPhotoUrl),
                                      const SizedBox(width: 8),
                                      _buildVideoThumb('0:45'),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaThumb(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        color: _surfaceContainer,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: _surfaceVariant,
            child: const Icon(Icons.image, color: _muted),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoThumb(String duration) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderHairline),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.play_circle_outline, color: _offWhite, size: 28),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                duration,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Interactive Animated Graph Card ────────────────────────────────────────

  Widget _buildInteractiveGraphCard(String title) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderHairline),
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
                  const Icon(Icons.bar_chart, color: _mint, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                _viewMode == CalendarViewMode.month
                    ? '4 Weeks'
                    : _viewMode == CalendarViewMode.week
                        ? 'Mon–Sun'
                        : '8am–8pm',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (ctx, _) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 6,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => _surfaceContainer,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.round()} Events',
                            const TextStyle(
                              color: _mint,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        if (response != null && response.spot != null) {
                          setState(() {
                            _graphTouchedIndex =
                                response.spot!.touchedBarGroupIndex;
                          });
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            String text = '';
                            if (_viewMode == CalendarViewMode.month) {
                              text = 'W${val.toInt() + 1}';
                            } else if (_viewMode == CalendarViewMode.week) {
                              const days = [
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S',
                                'S'
                              ];
                              text = days[val.toInt().clamp(0, 6)];
                            } else {
                              const hours = [
                                '8a',
                                '10a',
                                '12p',
                                '2p',
                                '4p',
                                '6p',
                                '8p'
                              ];
                              text = hours[val.toInt().clamp(0, 6)];
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: _generateBarGroups(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegendItem(_alpineBlue, 'Training'),
              const SizedBox(width: 14),
              _buildChartLegendItem(_errorLight, 'Health'),
              const SizedBox(width: 14),
              _buildChartLegendItem(_mint, 'Comp'),
              const SizedBox(width: 14),
              _buildChartLegendItem(_catSc, 'S&C'),
            ],
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    final progress = _chartProgress.value;

    if (_viewMode == CalendarViewMode.month) {
      // 4 weeks
      final weekValues = [12.0, 18.0, 15.0, 22.0];
      return List.generate(4, (i) {
        final val = (weekValues[i] / 4.0) * progress;
        final isSelected = _graphTouchedIndex == i;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: isSelected ? _mint : _forest,
              width: 18,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 6,
                color: _surfaceDim,
              ),
            ),
          ],
        );
      });
    } else if (_viewMode == CalendarViewMode.week) {
      // 7 days (Mon-Sun)
      final dailyValues = [1.0, 0.0, 2.0, 6.0, 1.0, 3.0, 1.0];
      return List.generate(7, (i) {
        final val = dailyValues[i] * progress;
        final isSelected = _graphTouchedIndex == i || i == 3; // Thu 14
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: isSelected
                  ? _mint
                  : (i == 3 ? _mint : _alpineBlue.withValues(alpha: 0.6)),
              width: 12,
              borderRadius: BorderRadius.circular(3),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 6,
                color: _surfaceDim,
              ),
            ),
          ],
        );
      });
    } else {
      // 7 hour slots for Day
      final hourValues = [2.0, 1.0, 1.0, 0.0, 2.0, 1.0, 0.0];
      return List.generate(7, (i) {
        final val = hourValues[i] * progress;
        final isSelected = _graphTouchedIndex == i;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: isSelected ? _mint : _forest,
              width: 12,
              borderRadius: BorderRadius.circular(3),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 6,
                color: _surfaceDim,
              ),
            ),
          ],
        );
      });
    }
  }

  Widget _buildChartLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: _muted, fontSize: 10),
        ),
      ],
    );
  }

  // ─── Quick Helpers & Navigation ─────────────────────────────────────────────

  Widget _buildQuickActionBtn({
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: _offWhite,
        side: const BorderSide(color: _forest),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _openEventDetails(Map<String, dynamic> ev) {
    final isHealth = ev['category'] == 'HEALTH';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TimelineEventDetailsScreen(
          initialVariant: isHealth
              ? TimelineEventVariant.health
              : TimelineEventVariant.training,
          initialTitle: ev['title'] as String?,
          initialDog: _selectedDog,
        ),
      ),
    );
  }

  void _openRecordEvent(String type) {
    if (type == 'training') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const RecordSessionScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddHealthRecordScreen(),
        ),
      );
    }
  }

  void _showDogSelectorDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Dog Calendar',
              style: TextStyle(
                color: _offWhite,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _buildDogTile('Atlas', 'German Shepherd · Working Line',
                _selectedDog == 'Atlas', () {
              Navigator.pop(ctx);
              setState(() => _selectedDog = 'Atlas');
            }),
            _buildDogTile(
                'Nova', 'Belgian Malinois · Sport Pack', _selectedDog == 'Nova',
                () {
              Navigator.pop(ctx);
              setState(() => _selectedDog = 'Nova');
            }),
            _buildDogTile('All Dogs', 'Global Unified Timeline',
                _selectedDog == 'All Dogs', () {
              Navigator.pop(ctx);
              setState(() => _selectedDog = 'All Dogs');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDogTile(
      String name, String breed, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? _forest.withValues(alpha: 0.3) : _surfaceDim,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? _mint : _borderHairline,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _forest,
          child: Text(
            name.substring(0, 1),
            style: const TextStyle(
                color: _mint, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        title: Text(name,
            style: const TextStyle(
                color: _offWhite, fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(breed,
            style: const TextStyle(color: _stoneGrey, fontSize: 12)),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: _mint, size: 20)
            : null,
        onTap: onTap,
      ),
    );
  }

  // ─── Floating Action Button ─────────────────────────────────────────────────

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        _showQuickAddBottomSheet();
      },
      backgroundColor: _forest,
      foregroundColor: _offWhite,
      elevation: 2,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 26),
    );
  }

  void _showQuickAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Quick Log for Date',
              style: TextStyle(
                color: _offWhite,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_selectedDate.day} ${_monthAbbr(_selectedDate.month)} ${_selectedDate.year} · $_selectedDog',
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _alpineBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fitness_center,
                    color: _alpineBlue, size: 20),
              ),
              title: const Text('Training Session',
                  style: TextStyle(color: _offWhite, fontSize: 14)),
              subtitle: const Text('Record drills, tracking, or obedience',
                  style: TextStyle(color: _muted, fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                _openRecordEvent('training');
              },
            ),
            ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _errorLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.local_hospital, color: _errorLight, size: 20),
              ),
              title: const Text('Health Record',
                  style: TextStyle(color: _offWhite, fontSize: 14)),
              subtitle: const Text('Log vet visit, vaccine, or medication',
                  style: TextStyle(color: _muted, fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                _openRecordEvent('health');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Navigation Shell ────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(top: BorderSide(color: _borderHairline)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
              _buildNavItem(
                  Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
              _buildNavItem(Icons.event_note, 'Timeline', true, () {}),
              _buildNavItem(Icons.more_horiz, 'More', false, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? _mint : _muted,
            size: 22,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isActive ? _mint : _muted,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Formatting Utilities ───────────────────────────────────────────────────

  String _formatMonthYear(DateTime dt) {
    const months = [
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
      'December'
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  String _monthAbbr(int month) {
    const abbrs = [
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
    return abbrs[month - 1];
  }

  String _weekdayAbbr(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }
}
