import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'activity_library_screen.dart';
import 'activity_details_screen.dart';
import 'create_activity_screen.dart';
import 'record_session_screen.dart';
import 'export_screen.dart';
import 'sc_archive_screen.dart';
import 'sc_settings_screen.dart';

class SCDogProfile {
  final String name;
  final String breed;
  final String age;
  final String avatarUrl;
  final bool hasData;

  const SCDogProfile({
    required this.name,
    required this.breed,
    required this.age,
    required this.avatarUrl,
    required this.hasData,
  });
}

class SCActivity {
  final String id;
  final String name;
  final int sessionCount;
  final String lastTrained;
  final String imageUrl;
  final String category;
  final String equipment;

  const SCActivity({
    required this.id,
    required this.name,
    required this.sessionCount,
    required this.lastTrained,
    required this.imageUrl,
    required this.category,
    required this.equipment,
  });
}

class SCWeeklyDayPoint {
  final String day;
  final int minutes;
  final int loadPoints;
  final String activityName;

  const SCWeeklyDayPoint({
    required this.day,
    required this.minutes,
    required this.loadPoints,
    required this.activityName,
  });
}

class StrengthConditioningDashboardScreen extends StatefulWidget {
  final bool initialEmpty;
  const StrengthConditioningDashboardScreen({super.key, this.initialEmpty = false});

  @override
  State<StrengthConditioningDashboardScreen> createState() =>
      _StrengthConditioningDashboardScreenState();
}

class _StrengthConditioningDashboardScreenState
    extends State<StrengthConditioningDashboardScreen>
    with SingleTickerProviderStateMixin {
  // Theme Constants
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _surfaceDeep = Color(0xFF15181A);
  static const _mint = Color(0xFF95D3BB);
  static const _forest = Color(0xFF2E6B57);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _muted = Color(0xFFA7B0AB);

  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  late bool _isEmpty;
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;

  int _selectedDogIndex = 0;
  final List<SCDogProfile> _dogs = const [
    SCDogProfile(
      name: 'Nova',
      breed: 'Border Collie',
      age: '2yr',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAdDW8A4WGIiYdWeCAtZKduQJ2QmUSNc9gAwO2IaTcjjJuYQPKfk89WMU6UUmxK7urh4l_xzkv8D8tr1smcw6PP7QQc8viFAkYknrqymPBd6t0gyfLokq7BAEvPoiWX23d3qlL_94hp92Sy2FJiEJIcBtPBmLLQpHg30Jd0qmlw7w6oPUDahgsOAvkzOt60PEKu78U4eQ55NMtDP27xicUqPYAsC6-1fzlrWHj7jfkXmn_CDlmfybM',
      hasData: true,
    ),
    SCDogProfile(
      name: 'Koda',
      breed: 'Belgian Malinois',
      age: '3yr',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCEEEZqYjnCtyUkkdWFmJD5gjvME_CawWVeC4M8yr3BJHy2pLiY3DrKJnnN4Zj1pW7LTRhRC6tWVlizBZ12z_bZp-gDBmeQ2PuDaOqDosZRxZ6U-nNipgYyvAVBbPYXn0vXvpZc6snv4amyKsgr8upqHDjMfTrO2Rcc5rQWZFywvb_jsZUlIs1plG1tmoIUhKi9niSiK2KAJG2PVpUxFTRskaWF3-D7BB12aCEwhM1NN_dbIyortMQ',
      hasData: true,
    ),
    SCDogProfile(
      name: 'Fenris',
      breed: 'Working Malinois',
      age: '1yr 4m',
      avatarUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=500&q=80',
      hasData: false,
    ),
  ];
  SCDogProfile get _dog => _dogs[_selectedDogIndex];

  // Activities Data
  late List<SCActivity> _activities;

  // Graph Data (Weekly Training Load)
  String _graphMetric = 'Duration'; // 'Duration' or 'Load Points'
  int _selectedChartDayIndex = -1;

  final List<SCWeeklyDayPoint> _weeklyPoints = const [
    SCWeeklyDayPoint(day: 'Mon', minutes: 35, loadPoints: 180, activityName: 'Treadmill Intervals'),
    SCWeeklyDayPoint(day: 'Tue', minutes: 45, loadPoints: 240, activityName: 'Weighted Carries'),
    SCWeeklyDayPoint(day: 'Wed', minutes: 50, loadPoints: 290, activityName: 'Hill Sprints'),
    SCWeeklyDayPoint(day: 'Thu', minutes: 30, loadPoints: 150, activityName: 'Resistance Dragging'),
    SCWeeklyDayPoint(day: 'Fri', minutes: 60, loadPoints: 340, activityName: 'Full Body Circuit'),
    SCWeeklyDayPoint(day: 'Sat', minutes: 45, loadPoints: 220, activityName: 'Core & Balance'),
    SCWeeklyDayPoint(day: 'Sun', minutes: 10, loadPoints: 60, activityName: 'Active Recovery Walk'),
  ];

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.initialEmpty;
    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    _activities = [
      const SCActivity(
        id: 'act-1',
        name: 'Treadmill Intervals',
        sessionCount: 24,
        lastTrained: '2 days ago',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD0tv-caVYxMzioxPycLH9wYX0cuS93HnRJhWtdkZGCyN2vDTlRjMoOW03-vTKnLdJhZ6wkzTgtWt7ZAeAGAScEQESqfK2ccNJU7Q9U1ECZgu3kk0L5RVpKT8qDcZr71mJH2CH-D5c1A_8Uwpt1DKrMBiVLXAkKyrn3sMqUGp1-iu0z7lMR-RptsD2RlOvTfVkRT6vide1OS2vaJFlZmA21mL4flRTknQeSHxqgTBwMwzNiMmdQ4_8',
        category: 'Endurance & Speed',
        equipment: 'Canine Treadmill, Heart Monitor',
      ),
      const SCActivity(
        id: 'act-2',
        name: 'Weighted Carries',
        sessionCount: 18,
        lastTrained: '1 week ago',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBnswTOXQkQ27w1JDyHodwmWD2zok1u22riI1126Yg-p5Z7I69vM0386KCivbsHEtIHFsS9GwL4gV1WJMbLS_eRbp4S-nDxPf3tYjnS3w1gNBi_2e7SUiE4vEUdzG8tycF6RMzG2MDg6MwXcUeLnlI_e-Y2_hboL8NlIgXbN5qb1St8DF_tE0GvVENV_ccQWCa9C3dIUnMRuTK_5ePMzVCQVBNNYrWAPsb6B4q0-5eW689_8RsOboY',
        category: 'Strength & Hypertrophy',
        equipment: 'Weighted Vest, Saddlebags (2.2kg)',
      ),
      const SCActivity(
        id: 'act-3',
        name: 'Hill Sprints',
        sessionCount: 12,
        lastTrained: '3 days ago',
        imageUrl:
            'https://images.unsplash.com/photo-1534361960057-19889db9621e?auto=format&fit=crop&w=600&q=80',
        category: 'Explosive Power',
        equipment: '15-degree Incline Grass Slope',
      ),
      const SCActivity(
        id: 'act-4',
        name: 'Resistance Dragging',
        sessionCount: 9,
        lastTrained: '5 days ago',
        imageUrl:
            'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=600&q=80',
        category: 'Posterior Chain',
        equipment: 'Sled / Tire Drag Harness (4kg)',
      ),
    ];
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  void _showDogSelectorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
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
                'Switch Athlete Profile',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(_dogs.length, (idx) {
                final d = _dogs[idx];
                final isSelected = idx == _selectedDogIndex;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? _surfaceHigh : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: _mint.withValues(alpha: 0.4))
                        : null,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(d.avatarUrl),
                      radius: 20,
                    ),
                    title: Text(
                      d.name,
                      style: TextStyle(
                        color: isSelected ? _mint : _offWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${d.breed} · ${d.age}',
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: _mint, size: 20)
                        : (d.hasData
                            ? null
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('No Activities',
                                    style: TextStyle(
                                        color: _muted, fontSize: 10)),
                              )),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _selectedDogIndex = idx;
                        _isEmpty = !d.hasData;
                        _chartAnimController.reset();
                        _chartAnimController.forward();
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showActivityDetailsModal(SCActivity activity) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _mint.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      activity.category.toUpperCase(),
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Last: ${activity.lastTrained}',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                activity.name,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _surfaceDeep,
                  borderRadius: BorderRadius.circular(10),
                  border: _hairlineBorder,
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Total Completed Sessions',
                        '${activity.sessionCount} sessions'),
                    Divider(
                        height: 16, color: Colors.white.withValues(alpha: 0.06)),
                    _buildDetailRow('Prescribed Equipment', activity.equipment),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ActivityDetailsScreen(
                        activity: LibraryActivityItem(
                          id: activity.id,
                          name: activity.name,
                          description:
                              '${activity.category} conditioning for canine athletes',
                          sessionCount: activity.sessionCount,
                          lastTrained: activity.lastTrained,
                          streakDays: 8,
                          isFavourite: true,
                          icon: Icons.fitness_center,
                          category: activity.category,
                          equipment: activity.equipment,
                        ),
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Full Activity Details & History',
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
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child:
                          const Text('Close', style: TextStyle(color: _muted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showRecordSessionModal(activity.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Start Session',
                          style: TextStyle(fontWeight: FontWeight.w600)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: _muted, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showRecordSessionModal([String? defaultActivity]) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordSessionScreen(
          initialActivityName: defaultActivity,
          startWithActivity: defaultActivity != null,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _isEmpty = false;
      });
    }
  }

  Future<void> _openCreateActivityScreen() async {
    final created = await Navigator.of(context).push<LibraryActivityItem>(
      MaterialPageRoute(
        builder: (_) => const CreateActivityScreen(),
      ),
    );
    if (created != null && mounted) {
      setState(() {
        _activities.insert(
          0,
          SCActivity(
            id: created.id,
            name: created.name,
            sessionCount: 0,
            lastTrained: 'Just created',
            imageUrl:
                'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=600&q=80',
            category: created.category,
            equipment: created.equipment,
          ),
        );
        _isEmpty = false;
      });
    }
  }

  void _showLearnDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), side: _hairlineSide),
        title: const Text('About S&C Tracking',
            style: TextStyle(color: _offWhite, fontSize: 18)),
        content: const Text(
          'Strength & Conditioning in Ulvenik tracks power, endurance, posterior chain load, and sprint volume for canine athletes.\n\nWorkouts connect directly with health records and veterinary wellness checks to ensure balanced progression without injury risk.',
          style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: _mint)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _muted),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Strength & Conditioning',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Search Activities',
            icon: const Icon(Icons.search, color: _muted),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ActivityLibraryScreen(),
                ),
              );
            },
          ),
          // Toggle State Button (Populated vs Empty)
          IconButton(
            tooltip: _isEmpty
                ? 'Switch to Populated S&C'
                : 'Switch to Empty S&C',
            icon: Icon(
              _isEmpty ? Icons.fitness_center_outlined : Icons.fitness_center,
              color: _mint,
            ),
            onPressed: () {
              setState(() {
                _isEmpty = !_isEmpty;
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
            },
          ),
          IconButton(
            tooltip: 'Export Data',
            icon: const Icon(Icons.ios_share, color: _mint),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ExportScreen(dogName: _dog.name),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Archive',
            icon: const Icon(Icons.inventory_2_outlined, color: _mint),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SCArchiveScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'S & C Settings',
            icon: const Icon(Icons.settings_outlined, color: _mint),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SCSettingsScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            tooltip: 'Options',
            icon: const Icon(Icons.more_vert, color: _muted),
            color: _carbon,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCSettingsScreen(),
                  ),
                );
              } else if (val == 'dog') {
                _showDogSelectorSheet();
              } else if (val == 'export') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExportScreen(dogName: _dog.name),
                  ),
                );
              } else if (val == 'archive') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCArchiveScreen(),
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('S & C Settings', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'dog',
                child: Row(
                  children: [
                    Icon(Icons.pets, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Switch Dog Profile', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.ios_share, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Export Data', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('View Archive', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dog Selector Button
              _buildDogSelectorCard(),
              const SizedBox(height: 20),

              if (_isEmpty) ...[
                _buildEmptyStateView(),
              ] else ...[
                _buildPopulatedStateView(),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecordSessionModal(),
        backgroundColor: _forest,
        foregroundColor: _offWhite,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }

  // ==========================================
  // DOG SELECTOR CARD
  // ==========================================
  Widget _buildDogSelectorCard() {
    return InkWell(
      onTap: _showDogSelectorSheet,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: _hairlineBorder,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _forest, width: 2),
                image: DecorationImage(
                  image: NetworkImage(_dog.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dog.name,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _isEmpty
                        ? 'Active Profile'
                        : '${_dog.breed} · ${_dog.age}',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: _muted, size: 20),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // POPULATED STATE VIEW
  // ==========================================
  Widget _buildPopulatedStateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. THIS WEEK Summary
        _buildSectionHeader('THIS WEEK'),
        const SizedBox(height: 10),
        _buildThisWeekCard(),
        const SizedBox(height: 24),

        // 2. Animated & Interactive Graph (Weekly Load & Intensity)
        _buildSectionHeader('WEEKLY TRAINING LOAD & INTENSITY'),
        const SizedBox(height: 10),
        _buildAnimatedGraphCard(),
        const SizedBox(height: 24),

        // 3. ACTIVITY LIBRARY Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSectionHeader('ACTIVITY LIBRARY'),
            Row(
              children: [
                InkWell(
                  onTap: _openCreateActivityScreen,
                  child: const Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: _mint, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'New',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ActivityLibraryScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 12,
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
          ],
        ),
        const SizedBox(height: 10),
        _buildActivityLibraryCards(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          color: _muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // THIS WEEK Summary Card (2x2 Grid)
  Widget _buildThisWeekCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: _hairlineBorder,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCell(
                  icon: Icons.timer_outlined,
                  label: 'Sessions',
                  value: '7',
                ),
              ),
              Container(width: 1, height: 80, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildMetricCell(
                  icon: Icons.schedule_outlined,
                  label: 'Duration',
                  value: '4h 35m',
                ),
              ),
            ],
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          Row(
            children: [
              Expanded(
                child: _buildMetricCell(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Streak',
                  value: '12 Days',
                ),
              ),
              Container(width: 1, height: 80, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: _buildMetricCell(
                  icon: Icons.track_changes_outlined,
                  label: 'Active Goals',
                  value: '3',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _muted, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ANIMATED GRAPH (Weekly Training Load fl_chart)
  // ==========================================
  Widget _buildAnimatedGraphCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _graphMetric == 'Duration'
                          ? '4h 35m Total Weekly Conditioning'
                          : '1,480 Total Load Points',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Mon · 12 Oct — Sun · 18 Oct',
                      style: TextStyle(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Segmented Switcher
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _surfaceDeep,
                  borderRadius: BorderRadius.circular(6),
                  border: _hairlineBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGraphPill('Duration'),
                    _buildGraphPill('Load Points'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 130,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (context, child) {
                final progress = _chartProgress.value;
                final isDuration = _graphMetric == 'Duration';
                final maxY = isDuration ? 70.0 : 400.0;

                return LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => _surfaceHigh,
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final idx = spot.spotIndex;
                            if (idx < 0 || idx >= _weeklyPoints.length) return null;
                            final pt = _weeklyPoints[idx];
                            return LineTooltipItem(
                              '${pt.day} · ${pt.activityName}\n',
                              const TextStyle(
                                  color: _mint,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                              children: [
                                TextSpan(
                                  text: isDuration
                                      ? '${pt.minutes} min conditioning'
                                      : '${pt.loadPoints} load points',
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                      touchCallback: (event, response) {
                        if (response?.lineBarSpots != null &&
                            response!.lineBarSpots!.isNotEmpty &&
                            event is FlTapUpEvent) {
                          setState(() {
                            _selectedChartDayIndex =
                                response.lineBarSpots!.first.spotIndex;
                          });
                        }
                      },
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: isDuration ? 20 : 100,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.white.withValues(alpha: 0.04),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: isDuration ? 20 : 100,
                          getTitlesWidget: (val, meta) => Text(
                            isDuration
                                ? '${val.toInt()}m'
                                : '${val.toInt()}',
                            style:
                                const TextStyle(color: _muted, fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx < 0 || idx >= _weeklyPoints.length) {
                              return const SizedBox();
                            }
                            final isSel = idx == _selectedChartDayIndex;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _weeklyPoints[idx].day,
                                style: TextStyle(
                                  color: isSel ? _mint : _muted,
                                  fontSize: 11,
                                  fontWeight:
                                      isSel ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _weeklyPoints.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final pt = entry.value;
                          final rawY = isDuration
                              ? pt.minutes.toDouble()
                              : pt.loadPoints.toDouble();
                          return FlSpot(idx.toDouble(), rawY * progress);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _mint,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final isSel = index == _selectedChartDayIndex;
                            return FlDotCirclePainter(
                              radius: isSel ? 5.5 : 3.5,
                              color: isSel ? _offWhite : _mint,
                              strokeWidth: isSel ? 2.5 : 1.5,
                              strokeColor: _forest,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              _mint.withValues(alpha: 0.28),
                              _forest.withValues(alpha: 0.02),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphPill(String title) {
    final isSel = _graphMetric == title;
    return InkWell(
      onTap: () => setState(() => _graphMetric = title),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSel ? _forest : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSel ? _offWhite : _muted,
            fontSize: 10,
            fontWeight: isSel ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ACTIVITY LIBRARY CARDS (Horizontal scrolling, matches HTML & Screenshot 1)
  Widget _buildActivityLibraryCards() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _activities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (ctx, idx) {
          final act = _activities[idx];
          return InkWell(
            onTap: () => _showActivityDetailsModal(act),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 170,
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(10),
                border: _hairlineBorder,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Background Image Overlay
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.18,
                        child: Image.network(
                          act.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: _surfaceDeep),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act.name,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${act.sessionCount} Sessions',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Last: ${act.lastTrained}',
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // EMPTY STATE VIEW (Matches Screenshot 2)
  // ==========================================
  Widget _buildEmptyStateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. THIS WEEK Summary (All dashes)
        _buildSectionHeader('THIS WEEK'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(16),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildEmptySummaryCell('SESSIONS', '—')),
                  Expanded(child: _buildEmptySummaryCell('DURATION', '—')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildEmptySummaryCell('STREAK', '0 Days')),
                  Expanded(child: _buildEmptySummaryCell('ACTIVE GOALS', '—')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),

        // 2. Empty Illustration (Rotated dumbbell icon)
        Center(
          child: Transform.rotate(
            angle: 0.785, // 45 degrees
            child: const Icon(Icons.fitness_center, color: _mint, size: 40),
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'No Activities Yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Create your first Strength & Conditioning activity to begin tracking your dog\'s physical development.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Primary Button: + Create Activity →
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [_forest, Color(0xFF225243)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: _mint.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: _forest.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _openCreateActivityScreen,
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: _offWhite, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Create Activity',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Learn about S&C Link
        Center(
          child: InkWell(
            onTap: _showLearnDialog,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Learn about Strength & Conditioning',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: _mint, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySummaryCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        if (value == '—')
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: _muted.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
