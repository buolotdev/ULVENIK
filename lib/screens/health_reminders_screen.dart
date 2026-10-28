import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'medication_manager_screen.dart';
import 'vaccination_manager_screen.dart';
import 'vet_visits_screen.dart';

enum ReminderStatus { overdue, dueToday, upcoming, completed }

enum ReminderCategory { medication, vaccination, vetVisit, supplement, grooming, wellness, other }

extension ReminderCategoryX on ReminderCategory {
  String get label {
    switch (this) {
      case ReminderCategory.medication:
        return 'Medication';
      case ReminderCategory.vaccination:
        return 'Vaccine';
      case ReminderCategory.vetVisit:
        return 'Vet Visit';
      case ReminderCategory.supplement:
        return 'Supplement';
      case ReminderCategory.grooming:
        return 'Grooming';
      case ReminderCategory.wellness:
        return 'Wellness';
      case ReminderCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ReminderCategory.medication:
        return Icons.medication_outlined;
      case ReminderCategory.vaccination:
        return Icons.vaccines_outlined;
      case ReminderCategory.vetVisit:
        return Icons.local_hospital_outlined;
      case ReminderCategory.supplement:
        return Icons.eco_outlined;
      case ReminderCategory.grooming:
        return Icons.content_cut_outlined;
      case ReminderCategory.wellness:
        return Icons.fitness_center_outlined;
      case ReminderCategory.other:
        return Icons.notifications_outlined;
    }
  }
}

class HealthReminderItem {
  final String id;
  String title;
  String timingText;
  DateTime dateTime;
  ReminderStatus status;
  ReminderCategory category;
  String dogName;
  String? note;
  bool isCompleted;
  String? snoozeText;

  HealthReminderItem({
    required this.id,
    required this.title,
    required this.timingText,
    required this.dateTime,
    required this.status,
    required this.category,
    required this.dogName,
    this.note,
    this.isCompleted = false,
    this.snoozeText,
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

class DailyAdherencePoint {
  final String dayLabel;
  final int totalScheduled;
  final int completedCount;
  final double adherencePct;

  const DailyAdherencePoint({
    required this.dayLabel,
    required this.totalScheduled,
    required this.completedCount,
    required this.adherencePct,
  });
}

class HealthRemindersScreen extends StatefulWidget {
  final bool initialEmpty;
  const HealthRemindersScreen({super.key, this.initialEmpty = false});

  @override
  State<HealthRemindersScreen> createState() => _HealthRemindersScreenState();
}

class _HealthRemindersScreenState extends State<HealthRemindersScreen>
    with SingleTickerProviderStateMixin {
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _errorMuted = Color(0xFF8B3A3A);
  static const _amber = Color(0xFFB4823C);
  static const _sage = Color(0xFF7A8F7A);

  late bool _isEmpty;
  late AnimationController _anim;

  // View Toggle: 0: List View, 1: Calendar/Adherence Graph View
  int _viewMode = 0; // 0: List, 1: Calendar & Graph

  // Filter: 'All', 'Due Today', 'Overdue', 'Upcoming', 'Medication', 'Vaccines', 'Appointments', 'Completed'
  String _selectedFilter = 'All';
  final List<String> _filters = const [
    'All',
    'Due Today',
    'Overdue',
    'Upcoming',
    'Medication',
    'Vaccines',
    'Appointments',
    'Completed',
  ];

  // Search
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _searchQuery = '';

  // Completed section collapsible state
  bool _completedExpanded = true;

  // Selected calendar day in calendar view
  int _selectedCalendarDay = 28; // 28 Aug

  // Touched bar index for graph
  int _touchedGraphIndex = -1;

  // Dog selector
  int _dogIndex = 0;
  final List<DogProfile> _dogs = const [
    DogProfile(
      name: 'Rex',
      breed: 'German Shepherd',
      age: '4 yrs',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDA43LSpqLueVgbV65C1BaUj8KmxU2uKYKkeOe869GPR6xGf7rZKXYqunE1wBNA3oSCOAA6IO77wsbLpg7BoDxBt6fbKNFh7r3Rn3RouJQxRp8-Hq_3F4IODz3kTbyfHFv6A--BsaKYHIF3RBVJYYuof7iNi_Hdc1xgK3cictN40i8cC7BjM-6V0mkqZI8G1GrUnzmduUQqWjvoRs4b0QiEbgtMpLPEF96BWQuexFVl7uRcedhssAc',
      isEmpty: false,
    ),
    DogProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '3 yrs',
      avatarUrl: null,
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

  // 7-day adherence data for animated chart
  final List<DailyAdherencePoint> _adherenceData = const [
    DailyAdherencePoint(dayLabel: 'Mon', totalScheduled: 3, completedCount: 3, adherencePct: 1.0),
    DailyAdherencePoint(dayLabel: 'Tue', totalScheduled: 4, completedCount: 4, adherencePct: 1.0),
    DailyAdherencePoint(dayLabel: 'Wed', totalScheduled: 3, completedCount: 3, adherencePct: 1.0),
    DailyAdherencePoint(dayLabel: 'Thu', totalScheduled: 5, completedCount: 4, adherencePct: 0.8),
    DailyAdherencePoint(dayLabel: 'Fri', totalScheduled: 4, completedCount: 3, adherencePct: 0.75),
    DailyAdherencePoint(dayLabel: 'Sat', totalScheduled: 4, completedCount: 2, adherencePct: 0.5),
    DailyAdherencePoint(dayLabel: 'Sun', totalScheduled: 2, completedCount: 0, adherencePct: 0.0),
  ];

  // Reminders list
  late List<HealthReminderItem> _reminders;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..forward();
    _initReminders();
  }

  void _initReminders() {
    _reminders = [
      // OVERDUE
      HealthReminderItem(
        id: 'rem-1',
        title: 'Kennel Cough Booster - Overdue',
        timingText: 'Was due 3 Aug',
        dateTime: DateTime.now().subtract(const Duration(days: 25)),
        status: ReminderStatus.overdue,
        category: ReminderCategory.vaccination,
        dogName: 'Rex',
        note: 'Annual Bordetella booster required before boarding.',
      ),
      HealthReminderItem(
        id: 'rem-2',
        title: 'Evening Apoquel Dose - Missed',
        timingText: 'Was due yesterday, 8:00 PM',
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        status: ReminderStatus.overdue,
        category: ReminderCategory.medication,
        dogName: 'Rex',
        note: '16mg Apoquel with dinner for seasonal dermatitis.',
      ),

      // DUE TODAY
      HealthReminderItem(
        id: 'rem-3',
        title: 'Morning Apoquel Dose',
        timingText: 'Today, 8:00 AM',
        dateTime: DateTime.now().copyWith(hour: 8, minute: 0),
        status: ReminderStatus.dueToday,
        category: ReminderCategory.medication,
        dogName: 'Rex',
        note: '16mg Apoquel tablet with morning meal.',
      ),
      HealthReminderItem(
        id: 'rem-4',
        title: 'Glucosamine Joint Supplement',
        timingText: 'Today, 1:00 PM',
        dateTime: DateTime.now().copyWith(hour: 13, minute: 0),
        status: ReminderStatus.dueToday,
        category: ReminderCategory.supplement,
        dogName: 'Rex',
        note: '1 soft chew with afternoon snack.',
      ),
      HealthReminderItem(
        id: 'rem-5',
        title: 'Evening Apoquel Dose',
        timingText: 'Today, 8:00 PM',
        dateTime: DateTime.now().copyWith(hour: 20, minute: 0),
        status: ReminderStatus.dueToday,
        category: ReminderCategory.medication,
        dogName: 'Rex',
        note: '16mg Apoquel tablet.',
      ),
      HealthReminderItem(
        id: 'rem-6',
        title: 'Otic Ear Drops & Cleanse',
        timingText: 'Today, 9:00 PM',
        dateTime: DateTime.now().copyWith(hour: 21, minute: 0),
        status: ReminderStatus.dueToday,
        category: ReminderCategory.wellness,
        dogName: 'Rex',
        note: 'Apply 4 drops into right ear canal and gently massage.',
      ),

      // TOMORROW
      HealthReminderItem(
        id: 'rem-7',
        title: 'Monthly Heartworm Chew',
        timingText: 'Tomorrow',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        status: ReminderStatus.upcoming,
        category: ReminderCategory.medication,
        dogName: 'Rex',
        note: 'Heartgard Plus flavored chewable.',
      ),

      // SAT 30 AUG
      HealthReminderItem(
        id: 'rem-8',
        title: 'Grooming Appointment',
        timingText: 'Sat 30 Aug, 10:00 AM',
        dateTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
        status: ReminderStatus.upcoming,
        category: ReminderCategory.grooming,
        dogName: 'Rex',
        note: 'Full coat deshedding, nail grinding, and paw balm.',
      ),
      HealthReminderItem(
        id: 'rem-9',
        title: 'Physiotherapy Stifle Review',
        timingText: 'Sat 30 Aug, 2:30 PM',
        dateTime: DateTime.now().add(const Duration(days: 2, hours: 6)),
        status: ReminderStatus.upcoming,
        category: ReminderCategory.vetVisit,
        dogName: 'Rex',
        note: 'Post-ACL extension range-of-motion assessment.',
      ),

      // COMPLETED
      HealthReminderItem(
        id: 'rem-10',
        title: 'Evening Walk',
        timingText: 'Completed yesterday',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        status: ReminderStatus.completed,
        category: ReminderCategory.wellness,
        dogName: 'Rex',
        isCompleted: true,
        note: '45-minute moderate walk in forest trail.',
      ),
      HealthReminderItem(
        id: 'rem-11',
        title: 'Morning Omega-3 Fish Oil',
        timingText: 'Completed today, 7:30 AM',
        dateTime: DateTime.now().subtract(const Duration(hours: 3)),
        status: ReminderStatus.completed,
        category: ReminderCategory.supplement,
        dogName: 'Rex',
        isCompleted: true,
        note: 'Pump 2ml onto kibble.',
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

  // Summary counts
  int get _dueTodayCount =>
      _reminders.where((r) => r.status == ReminderStatus.dueToday && !r.isCompleted).length;
  int get _upcomingCount =>
      _reminders.where((r) => r.status == ReminderStatus.upcoming && !r.isCompleted).length;
  int get _overdueCount =>
      _reminders.where((r) => r.status == ReminderStatus.overdue && !r.isCompleted).length;
  int get _completedCount => _reminders.where((r) => r.isCompleted).length;

  // Filtered Reminders
  List<HealthReminderItem> get _filteredReminders {
    return _reminders.where((item) {
      if (_dog.name != item.dogName && !_isEmpty) {
        // If switched to another dog profile that has data
      }

      // Filter tabs
      switch (_selectedFilter) {
        case 'Due Today':
          if (item.status != ReminderStatus.dueToday || item.isCompleted) return false;
          break;
        case 'Overdue':
          if (item.status != ReminderStatus.overdue || item.isCompleted) return false;
          break;
        case 'Upcoming':
          if (item.status != ReminderStatus.upcoming || item.isCompleted) return false;
          break;
        case 'Medication':
          if (item.category != ReminderCategory.medication) return false;
          break;
        case 'Vaccines':
          if (item.category != ReminderCategory.vaccination) return false;
          break;
        case 'Appointments':
          if (item.category != ReminderCategory.grooming &&
              item.category != ReminderCategory.vetVisit) {
            return false;
          }
          break;
        case 'Completed':
          if (!item.isCompleted) return false;
          break;
        case 'All':
        default:
          break;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchNote = (item.note ?? '').toLowerCase().contains(q);
        final matchCategory = item.category.label.toLowerCase().contains(q);
        if (!matchTitle && !matchNote && !matchCategory) return false;
      }

      return true;
    }).toList();
  }

  void _toggleComplete(HealthReminderItem item) {
    setState(() {
      item.isCompleted = !item.isCompleted;
      if (item.isCompleted) {
        item.status = ReminderStatus.completed;
      } else {
        // Revert to original approximate status
        if (item.timingText.contains('due') || item.timingText.contains('Missed')) {
          item.status = ReminderStatus.overdue;
        } else if (item.timingText.contains('Today')) {
          item.status = ReminderStatus.dueToday;
        } else {
          item.status = ReminderStatus.upcoming;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: item.isCompleted ? _forest : const Color(0xFF272B29),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              item.isCompleted ? Icons.check_circle : Icons.undo,
              color: item.isCompleted ? _mint : AppColors.primaryTextOffWhite,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.isCompleted ? 'Marked "${item.title}" completed' : 'Moved back to active',
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snoozeReminder(HealthReminderItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.snooze, color: _mint, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Snooze Reminder',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _buildSnoozeOption('1 Hour', 'Remind in 60 minutes', () {
                Navigator.pop(ctx);
                setState(() {
                  item.timingText = 'Snoozed for 1 hour';
                });
              }),
              _buildSnoozeOption('Tonight at 8:00 PM', 'After dinner schedule', () {
                Navigator.pop(ctx);
                setState(() {
                  item.timingText = 'Snoozed until 8:00 PM';
                });
              }),
              _buildSnoozeOption('Tomorrow Morning (8:00 AM)', 'Move to tomorrow routine', () {
                Navigator.pop(ctx);
                setState(() {
                  item.status = ReminderStatus.upcoming;
                  item.timingText = 'Tomorrow, 8:00 AM';
                });
              }),
              _buildSnoozeOption('Custom Date & Time', 'Pick exact time', () async {
                Navigator.pop(ctx);
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    item.timingText = 'Snoozed until ${picked.format(context)}';
                  });
                }
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSnoozeOption(String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
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
    );
  }

  void _navigateToCategory(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medication:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicationManagerScreen()));
        break;
      case ReminderCategory.vaccination:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VaccinationManagerScreen()));
        break;
      case ReminderCategory.vetVisit:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VetVisitsScreen()));
        break;
      default:
        break;
    }
  }

  void _showCreateReminderSheet() {
    final titleCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    ReminderCategory cat = ReminderCategory.medication;
    DateTime pickedDate = DateTime.now();
    TimeOfDay pickedTime = TimeOfDay.now();
    String repeatOption = 'Daily';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1F22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create Health Reminder',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.secondaryTextStoneGrey),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Title field
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      decoration: InputDecoration(
                        labelText: 'Reminder Name',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        hintText: 'e.g. Antibiotic Dose, Vet Follow-up',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                        filled: true,
                        fillColor: const Color(0xFF111412),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Category selector pills
                    const Text(
                      'CATEGORY',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ReminderCategory.values.map((c) {
                        final isSelected = c == cat;
                        return ChoiceChip(
                          label: Text(c.label),
                          selected: isSelected,
                          selectedColor: _forest,
                          backgroundColor: const Color(0xFF111412),
                          labelStyle: TextStyle(
                            color: isSelected ? _mint : AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          onSelected: (val) {
                            if (val) setModalState(() => cat = c);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    // Schedule Date & Time Row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final d = await showDatePicker(
                                context: modalCtx,
                                initialDate: pickedDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (d != null) setModalState(() => pickedDate = d);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF111412),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: _mint),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                      style: const TextStyle(
                                        color: AppColors.primaryTextOffWhite,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final t = await showTimePicker(
                                context: modalCtx,
                                initialTime: pickedTime,
                              );
                              if (t != null) setModalState(() => pickedTime = t);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF111412),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule, size: 16, color: _mint),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      pickedTime.format(context),
                                      style: const TextStyle(
                                        color: AppColors.primaryTextOffWhite,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Repeat option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Repeat Frequency',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DropdownButton<String>(
                          value: repeatOption,
                          dropdownColor: const Color(0xFF1A1F22),
                          underline: const SizedBox(),
                          style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                          items: const [
                            DropdownMenuItem(value: 'Once', child: Text('Once Only')),
                            DropdownMenuItem(value: 'Daily', child: Text('Every Day')),
                            DropdownMenuItem(value: 'Twice Daily', child: Text('Twice Daily')),
                            DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                            DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                          ],
                          onChanged: (val) {
                            if (val != null) setModalState(() => repeatOption = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Notes
                    TextField(
                      controller: noteCtrl,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Instructions / Notes (Optional)',
                        labelStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
                        filled: true,
                        fillColor: const Color(0xFF111412),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_alert, size: 18),
                        label: const Text(
                          'Save Reminder',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: AppColors.primaryTextOffWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) {
                            titleCtrl.text = 'Custom Health Reminder';
                          }
                          final newRem = HealthReminderItem(
                            id: 'rem-${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            timingText: 'Today, ${pickedTime.format(context)}',
                            dateTime: DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            ),
                            status: ReminderStatus.dueToday,
                            category: cat,
                            dogName: _dog.name,
                            note: noteCtrl.text.trim().isNotEmpty ? noteCtrl.text.trim() : null,
                          );

                          setState(() {
                            _reminders.insert(0, newRem);
                            if (_isEmpty) _isEmpty = false;
                          });

                          Navigator.pop(modalCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: _forest,
                              content: Text('Reminder created successfully!'),
                            ),
                          );
                        },
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

  void _showDogSelectorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Dog Profile',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              ..._dogs.asMap().entries.map((entry) {
                final idx = entry.key;
                final dog = entry.value;
                final isSelected = _dogIndex == idx;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _dogIndex = idx;
                      _isEmpty = dog.isEmpty;
                      _anim.forward(from: 0);
                    });
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? _forest.withValues(alpha: 0.25) : const Color(0xFF111412),
                      border: Border.all(
                        color: isSelected ? _mint : Colors.white.withValues(alpha: 0.08),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFF272B29),
                          backgroundImage:
                              dog.avatarUrl != null ? NetworkImage(dog.avatarUrl!) : null,
                          child: dog.avatarUrl == null
                              ? const Icon(Icons.pets, color: _mint, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    dog.name,
                                    style: TextStyle(
                                      color: isSelected ? _mint : AppColors.primaryTextOffWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (dog.isEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'NO DATA',
                                        style: TextStyle(color: Colors.white70, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ],
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
                        if (isSelected) const Icon(Icons.check_circle, color: _mint, size: 20),
                      ],
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

  void _showLearnDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: _mint, size: 22),
            SizedBox(width: 10),
            Text(
              'Health Reminders',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Automated & Synchronized Care',
              style: TextStyle(
                color: _mint,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ulvenik automatically generates smart reminders whenever you prescribe medications, schedule vaccination boosters, or book veterinary checkups.\n\nNever miss an Apoquel tablet, heartworm chew, or rehab session again with multi-tier alerts and push notification schedules.',
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: _mint, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101214),
      appBar: _buildTopAppBar(),
      floatingActionButton: _isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: _forest,
              foregroundColor: AppColors.primaryTextOffWhite,
              elevation: 4,
              onPressed: _showCreateReminderSheet,
              child: const Icon(Icons.notifications_active, size: 24),
            ),
      body: SafeArea(
        child: _isEmpty ? _buildEmptyState() : _buildPopulatedState(),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A1F22),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _sage),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: _showSearch
          ? TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Search reminders, meds, vaccines...',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            )
          : const Text(
              'Health Reminders',
              style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.close : Icons.search,
            color: _showSearch ? _mint : _forest,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                _searchController.clear();
                _searchQuery = '';
              } else {
                _searchFocus.requestFocus();
              }
            });
          },
        ),
        IconButton(
          tooltip: 'Toggle empty / populated',
          icon: Icon(
            _isEmpty ? Icons.toggle_off_outlined : Icons.toggle_on,
            color: _isEmpty ? AppColors.secondaryTextStoneGrey : _mint,
            size: 26,
          ),
          onPressed: () {
            setState(() {
              _isEmpty = !_isEmpty;
              _anim.forward(from: 0);
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add, color: _forest, size: 24),
          onPressed: _showCreateReminderSheet,
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
  // POPULATED STATE
  // ==========================================

  Widget _buildPopulatedState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dog Selector Card
          _buildDogCard(),
          const SizedBox(height: 16),

          // Reminder Summary Bento Card
          _buildSummaryBentoCard(),
          const SizedBox(height: 16),

          // View Toggle: List / Calendar & Analytics Graph
          _buildViewToggle(),
          const SizedBox(height: 14),

          // Filter Tabs (Horizontal Scroll)
          _buildFilterTabs(),
          const SizedBox(height: 20),

          // If Calendar/Graph mode is selected: Show interactive animated chart & calendar days
          if (_viewMode == 1) ...[
            _buildAnimatedAdherenceChart(),
            const SizedBox(height: 20),
            _buildCalendarDayStrip(),
            const SizedBox(height: 20),
          ],

          // Reminders content
          _buildRemindersList(),
        ],
      ),
    );
  }

  Widget _buildDogCard() {
    return InkWell(
      onTap: _showDogSelectorSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _forest, width: 2),
                image: _dog.avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_dog.avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _dog.avatarUrl == null
                  ? const Icon(Icons.pets, color: _mint, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dog.name,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${_dog.breed} · ${_dog.age}',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: _sage),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBentoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REMINDER SUMMARY',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.1,
            children: [
              _buildBentoCell(
                label: 'Due Today',
                count: _dueTodayCount,
                icon: Icons.schedule,
                iconColor: _forest,
                textColor: _forest,
                onTap: () => setState(() => _selectedFilter = 'Due Today'),
              ),
              _buildBentoCell(
                label: 'Upcoming',
                count: _upcomingCount,
                icon: Icons.event,
                iconColor: AppColors.primaryTextOffWhite,
                textColor: AppColors.primaryTextOffWhite,
                onTap: () => setState(() => _selectedFilter = 'Upcoming'),
              ),
              _buildBentoCell(
                label: 'Overdue',
                count: _overdueCount,
                icon: Icons.warning_amber_rounded,
                iconColor: _errorMuted,
                textColor: _errorMuted,
                onTap: () => setState(() => _selectedFilter = 'Overdue'),
              ),
              _buildBentoCell(
                label: 'Completed',
                count: _completedCount,
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primaryTextOffWhite,
                textColor: AppColors.primaryTextOffWhite,
                onTap: () => setState(() => _selectedFilter = 'Completed'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCell({
    required String label,
    required int count,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF111412).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
                Icon(icon, color: iconColor, size: 16),
              ],
            ),
            const SizedBox(height: 2),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: count.toDouble()),
              duration: const Duration(milliseconds: 600),
              builder: (context, val, child) {
                return Text(
                  val.toInt().toString(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F22),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() => _viewMode = 0),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _viewMode == 0 ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.format_list_bulleted,
                  size: 18,
                  color: _viewMode == 0 ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() => _viewMode = 1);
                _anim.forward(from: 0);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _viewMode == 1 ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: _viewMode == 1 ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final filter = _filters[i];
          final isSelected = _selectedFilter == filter;
          return InkWell(
            onTap: () => setState(() => _selectedFilter = filter),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? _forest : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? _forest : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // ANIMATED ADHERENCE GRAPH (CALENDAR VIEW)
  // ==========================================

  Widget _buildAnimatedAdherenceChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WEEKLY SCHEDULE ADHERENCE',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '86% Medication & Care Compliance',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: _mint, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+8% vs last wk',
                      style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Animated BarChart
          SizedBox(
            height: 150,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final progress = _anim.value;
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 6,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF272B29),
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final point = _adherenceData[group.x.toInt()];
                          return BarTooltipItem(
                            '${point.dayLabel}\n',
                            const TextStyle(color: _mint, fontWeight: FontWeight.bold, fontSize: 12),
                            children: [
                              TextSpan(
                                text: '${point.completedCount} of ${point.totalScheduled} Completed\n',
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${(point.adherencePct * 100).toInt()}% Adherence',
                                style: TextStyle(
                                  color: point.adherencePct >= 0.8 ? _mint : _amber,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        if (response?.spot != null && event is FlTapUpEvent) {
                          setState(() {
                            _touchedGraphIndex = response!.spot!.touchedBarGroupIndex;
                          });
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx < 0 || idx >= _adherenceData.length) {
                              return const SizedBox();
                            }
                            final isTouched = idx == _touchedGraphIndex;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _adherenceData[idx].dayLabel,
                                style: TextStyle(
                                  color: isTouched ? _mint : AppColors.secondaryTextStoneGrey,
                                  fontSize: 11,
                                  fontWeight: isTouched ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: _adherenceData.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final d = entry.value;
                      final isTouched = idx == _touchedGraphIndex;
                      final completedVal = (d.completedCount * progress).toDouble();
                      final scheduledVal = (d.totalScheduled * progress).toDouble();

                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: completedVal > 0 ? completedVal : 0.2,
                            color: isTouched
                                ? _mint
                                : (d.adherencePct == 1.0
                                    ? _forest
                                    : (d.adherencePct >= 0.75 ? _forest.withValues(alpha: 0.7) : _amber.withValues(alpha: 0.8))),
                            width: 14,
                            borderRadius: BorderRadius.circular(4),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: scheduledVal > 0 ? scheduledVal : 1.0,
                              color: const Color(0xFF111412),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                _ChartLegend(color: _forest, label: '100% On-time'),
                _ChartLegend(color: _amber, label: 'Missed / Snoozed'),
                _ChartLegend(color: Color(0xFF111412), label: 'Target'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDayStrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AUGUST 2026',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final day = 25 + i; // 25..31 Aug
              final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i];
              final isSelected = _selectedCalendarDay == day;
              final isToday = day == 28;

              return InkWell(
                onTap: () => setState(() => _selectedCalendarDay = day),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _forest
                        : (isToday ? _forest.withValues(alpha: 0.2) : const Color(0xFF1A1F22)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? _mint
                          : (isToday ? _forest : Colors.white.withValues(alpha: 0.08)),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekday,
                        style: TextStyle(
                          color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? _mint : AppColors.primaryTextOffWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // REMINDERS LIST SECTIONS
  // ==========================================

  Widget _buildRemindersList() {
    final list = _filteredReminders;

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            const Icon(Icons.filter_list_off, color: AppColors.secondaryTextStoneGrey, size: 36),
            const SizedBox(height: 12),
            const Text(
              'No matching reminders',
              style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing your filter "$_selectedFilter" or search query.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    final overdueList = list.where((r) => r.status == ReminderStatus.overdue && !r.isCompleted).toList();
    final dueTodayList = list.where((r) => r.status == ReminderStatus.dueToday && !r.isCompleted).toList();
    final upcomingList = list.where((r) => r.status == ReminderStatus.upcoming && !r.isCompleted).toList();
    final completedList = list.where((r) => r.isCompleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // OVERDUE SECTION
        if (overdueList.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'OVERDUE',
            color: _errorMuted,
            count: overdueList.length,
          ),
          const SizedBox(height: 10),
          ...overdueList.map((item) => _buildOverdueCard(item)),
          const SizedBox(height: 24),
        ],

        // DUE TODAY SECTION
        if (dueTodayList.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'DUE TODAY',
            color: _forest,
            count: dueTodayList.length,
          ),
          const SizedBox(height: 10),
          ...dueTodayList.map((item) => _buildDueTodayCard(item)),
          const SizedBox(height: 24),
        ],

        // UPCOMING SECTION
        if (upcomingList.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'UPCOMING',
            color: AppColors.secondaryTextStoneGrey,
            count: upcomingList.length,
          ),
          const SizedBox(height: 10),
          ...upcomingList.map((item) => _buildUpcomingCard(item)),
          const SizedBox(height: 24),
        ],

        // COMPLETED SECTION
        if (completedList.isNotEmpty) ...[
          InkWell(
            onTap: () => setState(() => _completedExpanded = !_completedExpanded),
            child: Row(
              children: [
                const Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${completedList.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Icon(
                  _completedExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.secondaryTextStoneGrey,
                  size: 20,
                ),
              ],
            ),
          ),
          if (_completedExpanded) ...[
            const SizedBox(height: 10),
            ...completedList.map((item) => _buildCompletedCard(item)),
          ],
        ],
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required Color color,
    required int count,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: color == _forest ? _mint : color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // OVERDUE CARD
  Widget _buildOverdueCard(HealthReminderItem item) {
    final isVaccine = item.category == ReminderCategory.vaccination;
    final accentColor = isVaccine ? _errorMuted : _amber;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Red/Amber vertical stripe
              Container(width: 4, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.timingText,
                                  style: const TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tooltip(
                            message: 'Open ${item.category.label}',
                            child: InkWell(
                              onTap: () => _navigateToCategory(item.category),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  isVaccine ? Icons.vaccines_outlined : Icons.medication_outlined,
                                  color: accentColor,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (item.note != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.note!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _toggleComplete(item),
                            child: const Text(
                              'Complete',
                              style: TextStyle(
                                color: _mint,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () => _snoozeReminder(item),
                            child: const Text(
                              'Snooze',
                              style: TextStyle(
                                color: _sage,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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

  // DUE TODAY CARD
  Widget _buildDueTodayCard(HealthReminderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _sage.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Checkbox
          InkWell(
            onTap: () => _toggleComplete(item),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _sage, width: 1.5),
              ),
              child: const SizedBox(),
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
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.timingText,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
                if (item.note != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.note!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tooltip(
            message: 'Open ${item.category.label}',
            child: InkWell(
              onTap: () => _navigateToCategory(item.category),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(item.category.icon, color: _sage, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UPCOMING CARD
  Widget _buildUpcomingCard(HealthReminderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Empty circle toggle
          InkWell(
            onTap: () => _toggleComplete(item),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
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
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.timingText,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
                if (item.note != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.note!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tooltip(
            message: 'Open ${item.category.label}',
            child: InkWell(
              onTap: () => _navigateToCategory(item.category),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(item.category.icon, color: AppColors.secondaryTextStoneGrey, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // COMPLETED CARD
  Widget _buildCompletedCard(HealthReminderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F22).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filled check circle
          InkWell(
            onTap: () => _toggleComplete(item),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _forest,
              ),
              child: const Icon(Icons.check, color: AppColors.primaryTextOffWhite, size: 14),
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
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 15,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white38,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.timingText,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
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
  // EMPTY STATE (Matches screenshot 2)
  // ==========================================

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dog switcher pill (Rex v / Fenris v) & View Toggle Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _showDogSelectorSheet,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: _forest,
                        backgroundImage:
                            _dog.avatarUrl != null ? NetworkImage(_dog.avatarUrl!) : null,
                        child: _dog.avatarUrl == null
                            ? const Icon(Icons.pets, color: _mint, size: 12)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _dog.name,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextStoneGrey, size: 16),
                    ],
                  ),
                ),
              ),
              // View Toggle
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F22),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.format_list_bulleted, size: 16, color: AppColors.primaryTextOffWhite),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.calendar_month, size: 16, color: AppColors.secondaryTextStoneGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4 Empty Bento metric tiles (0 counts)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.1,
            children: [
              _buildEmptyBentoCell('DUE TODAY', '0', _mint),
              _buildEmptyBentoCell('OVERDUE', '0', _errorMuted),
              _buildEmptyBentoCell('UPCOMING', '0', AppColors.primaryTextOffWhite),
              _buildEmptyBentoCell('COMPLETED', '0', AppColors.primaryTextOffWhite),
            ],
          ),
          const SizedBox(height: 16),

          // Category filter pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildEmptyFilterPill('All', true),
                const SizedBox(width: 8),
                _buildEmptyFilterPill('Medications', false),
                const SizedBox(width: 8),
                _buildEmptyFilterPill('Vaccines', false),
                const SizedBox(width: 8),
                _buildEmptyFilterPill('Appointments', false),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Big circular icon graphic
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1F22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 38,
                color: _mint,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Headline & description
          const Text(
            'No Health Reminders',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Health reminders from medications, vaccinations and appointments will automatically appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // + Create Reminder CTA Button
          ElevatedButton(
            onPressed: _showCreateReminderSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              foregroundColor: AppColors.primaryTextOffWhite,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_alert, size: 18),
                SizedBox(width: 8),
                Text(
                  'Create Reminder',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Learn text link
          Center(
            child: TextButton(
              onPressed: _showLearnDialog,
              child: const Text(
                'Learn about Health Reminders',
                style: TextStyle(
                  color: _mint,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBentoCell(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterPill(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF272B29) : const Color(0xFF1A1F22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? _mint.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
