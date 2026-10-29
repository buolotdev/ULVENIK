import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_memories_screen.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

// Figma Exact Category Colors
const Color _catTraining = Color(0xFF5D8FAF); // Blue
const Color _catSC = Color(0xFFB4823C);       // Bronze / Orange
const Color _catHealth = Color(0xFF8B3A3A);   // Red
const Color _catGoals = Color(0xFFB8920A);    // Yellow / Gold
const Color _catComp = Color(0xFF2E6B57);     // Forest Green

enum ActivityMapDisplayMode {
  defaultMode,
  markerSelectedMode,
  emptyMode,
}

class MapLocation {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final Color color;
  final int count;
  final int visits;
  final String firstVisit;
  final String lastVisit;
  final double distanceKm;
  final int elevationM;
  final Offset relativePos;
  final String description;

  const MapLocation({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.color,
    required this.count,
    required this.visits,
    required this.firstVisit,
    required this.lastVisit,
    required this.distanceKm,
    required this.elevationM,
    required this.relativePos,
    required this.description,
  });
}

class TimelineActivityMapScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineActivityMapScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Murphy',
  });

  @override
  State<TimelineActivityMapScreen> createState() =>
      _TimelineActivityMapScreenState();
}

class _TimelineActivityMapScreenState extends State<TimelineActivityMapScreen>
    with SingleTickerProviderStateMixin {
  late ActivityMapDisplayMode _displayMode;
  late String _selectedDog;
  String _selectedCategory = 'All';
  late MapLocation _selectedLocation;
  bool _showHeatmap = false;
  bool _splitRoutes = false;
  double _zoomLevel = 1.0;

  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  final List<MapLocation> _locations = const [
    MapLocation(
      id: 'loc_riverside',
      name: 'Riverside Trail Loop',
      subtitle: '4.8 km Track • Mixed Forest & Riverbank',
      category: 'Training',
      color: _catTraining,
      count: 18,
      visits: 34,
      firstVisit: 'Jan 2022',
      lastVisit: '3 Sep 2026',
      distanceKm: 4.8,
      elevationM: 320,
      relativePos: Offset(0.38, 0.42),
      description: 'Primary endurance track with aged tracking scent lines along the river bank.',
    ),
    MapLocation(
      id: 'loc_alpine',
      name: 'Alpine Ridge Summit',
      subtitle: '6.2 km Incline • Rocky Terrain & Sprints',
      category: 'S&C',
      color: _catSC,
      count: 7,
      visits: 19,
      firstVisit: 'May 2023',
      lastVisit: '18 Aug 2026',
      distanceKm: 6.2,
      elevationM: 1420,
      relativePos: Offset(0.72, 0.28),
      description: 'High elevation hill sprints and rocky incline agility testing.',
    ),
    MapLocation(
      id: 'loc_bavarian',
      name: 'Bavarian Forest Grid',
      subtitle: '3.1 km Dense Pines • Tracking Zone',
      category: 'Goals',
      color: _catGoals,
      count: 9,
      visits: 26,
      firstVisit: 'Oct 2022',
      lastVisit: '22 Aug 2026',
      distanceKm: 3.1,
      elevationM: 480,
      relativePos: Offset(0.55, 0.65),
      description: 'Dense woodland scent preservation zone with varied vegetation.',
    ),
    MapLocation(
      id: 'loc_meadow',
      name: 'Meadow Agility Arena',
      subtitle: '2.0 km Flat Grass • Agility & Focus',
      category: 'Competition',
      color: _catComp,
      count: 4,
      visits: 12,
      firstVisit: 'Mar 2024',
      lastVisit: '29 Jul 2026',
      distanceKm: 2.0,
      elevationM: 190,
      relativePos: Offset(0.22, 0.74),
      description: 'Open flat ground agility obstacles and high speed recall sequences.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _displayMode = widget.initialEmpty
        ? ActivityMapDisplayMode.emptyMode
        : ActivityMapDisplayMode.defaultMode;
    _selectedDog = widget.initialDog;
    _selectedLocation = _locations.first;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _cycleDisplayState() {
    setState(() {
      if (_displayMode == ActivityMapDisplayMode.defaultMode) {
        _displayMode = ActivityMapDisplayMode.markerSelectedMode;
      } else if (_displayMode == ActivityMapDisplayMode.markerSelectedMode) {
        _displayMode = ActivityMapDisplayMode.emptyMode;
      } else {
        _displayMode = ActivityMapDisplayMode.defaultMode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: _buildBodyForCurrentState(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _offWhite),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TimelineScreen()),
            );
          }
        },
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Timeline Activity Map',
            style: TextStyle(
              color: _offWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            _selectedDog,
            style: const TextStyle(
              color: _mint,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
      actions: [
        // Quick State Switcher Tooltip button
        IconButton(
          tooltip: 'Switch State (Default / Selected / Empty)',
          icon: Icon(
            _displayMode == ActivityMapDisplayMode.emptyMode
                ? Icons.visibility_off_outlined
                : _displayMode == ActivityMapDisplayMode.markerSelectedMode
                    ? Icons.pin_drop
                    : Icons.map_outlined,
            color: _mint,
            size: 20,
          ),
          onPressed: _cycleDisplayState,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _stoneGrey),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF272B29)),
          ),
          onSelected: (val) {
            if (val == 'default_state') {
              setState(() => _displayMode = ActivityMapDisplayMode.defaultMode);
            } else if (val == 'marker_selected') {
              setState(() => _displayMode = ActivityMapDisplayMode.markerSelectedMode);
            } else if (val == 'empty_state') {
              setState(() => _displayMode = ActivityMapDisplayMode.emptyMode);
            } else if (val == 'heatmap') {
              setState(() => _showHeatmap = !_showHeatmap);
            } else if (val == 'memories') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineMemoriesScreen()),
              );
            } else if (val == 'insights') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineInsightsScreen()),
              );
            } else if (val == 'favourites') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineFavouritesScreen()),
              );
            } else if (val == 'archive') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineArchiveScreen()),
              );
            } else if (val == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSettingsScreen()),
              );
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(
              value: 'default_state',
              child: Row(
                children: [
                  Icon(Icons.map, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('State 1: Default State', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'marker_selected',
              child: Row(
                children: [
                  Icon(Icons.location_on, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('State 2: Marker Selected', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'empty_state',
              child: Row(
                children: [
                  Icon(Icons.location_off, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('State 3: Empty State', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem(
              value: 'heatmap',
              child: Row(
                children: [
                  Icon(_showHeatmap ? Icons.layers_clear : Icons.layers, color: _mint, size: 18),
                  const SizedBox(width: 10),
                  Text(_showHeatmap ? 'Disable Heatmap' : 'Enable Heatmap Overlay',
                      style: const TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            const PopupMenuItem(
              value: 'memories',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Memories', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'insights',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Insights', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Settings', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyForCurrentState() {
    switch (_displayMode) {
      case ActivityMapDisplayMode.emptyMode:
        return _buildEmptyState();
      case ActivityMapDisplayMode.markerSelectedMode:
        return _buildMarkerSelectedState();
      case ActivityMapDisplayMode.defaultMode:
        return _buildDefaultState();
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STATE 1: DEFAULT STATE (Matching Figma 'Timeline Activity Map - Default State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildDefaultState() {
    return Stack(
      children: [
        // 1. Dark Vector Map Canvas Background
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              // Tapping canvas does not deselect in default mode
            },
            child: _buildVectorMapCanvas(isMarkerSelected: false),
          ),
        ),

        // 2. Top Metrics Carousel (23 Locations, Riverside Trail Most Visited, 147 Mapped Events)
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: _buildTopMetricsCarousel(),
        ),

        // 3. Floating Map Controls (Right side: Layers, Split route, Recenter)
        Positioned(
          right: 16,
          bottom: 156,
          child: _buildFloatingControls(),
        ),

        // 4. Bottom Selected Preview Card & Category Legend
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Riverside Trail Preview Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildDefaultLocationCard(),
              ),
              const SizedBox(height: 10),

              // Bottom Category Legend (Training, S&C, Health, Goals, Competition)
              _buildCategoryLegendBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopMetricsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildMetricBentoCard(
            title: '23 Locations',
            subtitle: 'ALL RECORDED',
            icon: Icons.place_outlined,
            accentColor: _catTraining,
          ),
          const SizedBox(width: 10),
          _buildMetricBentoCard(
            title: 'Riverside Trail',
            subtitle: 'MOST VISITED • 34 SESSIONS',
            icon: Icons.star_outline,
            accentColor: _mint,
          ),
          const SizedBox(width: 10),
          _buildMetricBentoCard(
            title: '147 Events',
            subtitle: 'GPS MAPPED SESSIONS',
            icon: Icons.verified_outlined,
            accentColor: _catSC,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBentoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xE61A1F22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 14),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLocationCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLocation = _locations.first;
          _displayMode = ActivityMapDisplayMode.markerSelectedMode;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xF21A1F22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 14, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _forest.withValues(alpha: 0.5)),
              ),
              child: const Center(
                child: Icon(Icons.navigation_outlined, color: _mint, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        _selectedLocation.name,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${_selectedLocation.distanceKm} km',
                          style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_selectedLocation.visits} Sessions Recorded • Jan 2022 - Sep 2026',
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLegendBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: Color(0x14FFFFFF), width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildLegendItem('Training', _catTraining),
            const SizedBox(width: 16),
            _buildLegendItem('S&C', _catSC),
            const SizedBox(width: 16),
            _buildLegendItem('Health', _catHealth),
            const SizedBox(width: 16),
            _buildLegendItem('Goals', _catGoals),
            const SizedBox(width: 16),
            _buildLegendItem('Competition', _catComp),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = _selectedCategory == label ? 'All' : label;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: _offWhite, width: 1.5) : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isSelected ? _offWhite : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STATE 2: MARKER SELECTED STATE (Matching Figma 'Timeline Activity Map - Marker Selected.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildMarkerSelectedState() {
    return Stack(
      children: [
        // 1. Dark Vector Map Canvas Background
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() => _displayMode = ActivityMapDisplayMode.defaultMode);
            },
            child: _buildVectorMapCanvas(isMarkerSelected: true),
          ),
        ),

        // 2. Top GPS Coordinate Pill (51.236° N • 0.570° W)
        Positioned(
          top: 14,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xE6101214),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _forest),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2)),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.gps_fixed, color: _mint, size: 14),
                  SizedBox(width: 6),
                  Text(
                    '51.236° N • 0.570° W',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3. Floating Map Controls (Right side)
        Positioned(
          right: 16,
          bottom: 350,
          child: _buildFloatingControls(),
        ),

        // 4. Expanded Bottom Sheet Panel
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildMarkerSelectedBottomSheet(),
        ),
      ],
    );
  }

  Widget _buildMarkerSelectedBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(color: Color(0x24FFFFFF), width: 1.2),
          left: BorderSide(color: Color(0x14FFFFFF), width: 1),
          right: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 24, offset: Offset(0, -6)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
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
            const SizedBox(height: 14),

            // Title + Close Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedLocation.name,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedLocation.subtitle,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 20),
                  onPressed: () {
                    setState(() => _displayMode = ActivityMapDisplayMode.defaultMode);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3 Stat Columns (34 Visits, Jan 2022 First Visit, 3 Sep 2026 Last Visit)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _obsidian,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn('${_selectedLocation.visits} Visits', 'TOTAL SESSIONS'),
                  Container(width: 1, height: 26, color: const Color(0x14FFFFFF)),
                  _buildStatColumn(_selectedLocation.firstVisit, 'FIRST VISIT'),
                  Container(width: 1, height: 26, color: const Color(0x14FFFFFF)),
                  _buildStatColumn(_selectedLocation.lastVisit, 'LAST VISIT'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Header: RECENT FIELD SESSIONS
            const Text(
              'RECENT FIELD SESSIONS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            // List of Recent Sessions
            _buildSessionListItem(
              title: 'Recall & Retrieval Drills',
              time: '3 Sep 2026 • 08:30 • 48 min',
              tag: 'Training',
              tagColor: _catTraining,
            ),
            const SizedBox(height: 8),
            _buildSessionListItem(
              title: 'Morning Heelwork Session',
              time: '28 Aug 2026 • 09:15 • 35 min',
              tag: 'S&C',
              tagColor: _catSC,
            ),
            const SizedBox(height: 16),

            // Dual CTA Buttons: View All Events Here / Open in Timeline
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0x33FFFFFF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TimelineScreen()),
                      );
                    },
                    child: const Text(
                      'View All Events Here',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TimelineScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Open in Timeline',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: _offWhite, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionListItem({
    required String title,
    required String time,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _obsidian,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.route, color: tagColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  time,
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STATE 3: EMPTY STATE (Matching Figma 'Timeline Activity Map - Empty State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Stack(
      children: [
        // 1. Dark Vector Map Grid with faint lines
        Positioned.fill(
          child: _buildVectorMapCanvas(isEmpty: true),
        ),

        // 2. Top GPS Status Pills (GPS ACTIVE • OFFLINE READY | 390m • SE 142°)
        Positioned(
          top: 14,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xE61A1F22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.gps_fixed, color: _mint, size: 12),
                    SizedBox(width: 6),
                    Text(
                      'GPS ACTIVE • OFFLINE READY',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xE61A1F22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: const Text(
                  '390m • SE 142°',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. Centered Empty Card
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xF21A1F22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _cardBorder),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 20, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with ripple circle
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _obsidian,
                      border: Border.all(color: _cardBorder, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.pin_drop_outlined,
                        color: _stoneGrey,
                        size: 34,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'No Recorded Locations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'Record a GPS track or tag locations during training sessions to build your dog\'s activity map.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const TimelineScreen()),
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go to Timeline',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 4. Bottom Scale Bar & Nordic Grid
        Positioned(
          left: 16,
          right: 16,
          bottom: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Scale Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 1, height: 6, color: _stoneGrey),
                      Container(width: 60, height: 1, color: _stoneGrey),
                      Container(width: 1, height: 6, color: _stoneGrey),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text('500 m', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                ],
              ),
              const Text(
                'WGS 84 • NORDIC SPORT GRID',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        // 5. Bottom Action Bar for Empty State
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: _obsidian,
              border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: _stoneGrey.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, height: 20, color: const Color(0x1AFFFFFF)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_upload_outlined, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Export GPX',
                          style: TextStyle(
                            color: _stoneGrey.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // COMMON MAP COMPONENTS & CONTROLS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildFloatingControls() {
    return Column(
      children: [
        _buildMapControlBtn(
          icon: Icons.layers_outlined,
          isActive: _showHeatmap,
          tooltip: 'Toggle Heatmap',
          onTap: () => setState(() => _showHeatmap = !_showHeatmap),
        ),
        const SizedBox(height: 8),
        _buildMapControlBtn(
          icon: Icons.alt_route,
          isActive: _splitRoutes,
          tooltip: 'Toggle Split Routes',
          onTap: () => setState(() => _splitRoutes = !_splitRoutes),
        ),
        const SizedBox(height: 8),
        _buildMapControlBtn(
          icon: Icons.my_location,
          tooltip: 'Recenter',
          onTap: () {
            setState(() {
              _zoomLevel = 1.0;
              _selectedLocation = _locations.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMapControlBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    String? tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? _forest : const Color(0xCC1A1F22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? _mint : _cardBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? _mint : _offWhite,
          size: 19,
        ),
      ),
    );
  }

  Widget _buildVectorMapCanvas({bool isMarkerSelected = false, bool isEmpty = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // Dark map terrain painter with waterways, contours, and tracks
            CustomPaint(
              size: Size(w, h),
              painter: _FigmaTerrainPainter(
                zoom: _zoomLevel,
                showHeatmap: _showHeatmap,
                isEmpty: isEmpty,
              ),
            ),

            // If empty mode, don't show location markers
            if (!isEmpty) ...[
              // Numbered Cluster & Pin Markers from Figma
              ..._locations.map((loc) {
                final isSelectedLoc = isMarkerSelected && loc.id == _selectedLocation.id;
                final pinX = loc.relativePos.dx * w;
                final pinY = loc.relativePos.dy * h;

                return Positioned(
                  left: pinX - 24,
                  top: pinY - 24,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocation = loc;
                        _displayMode = ActivityMapDisplayMode.markerSelectedMode;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Selected Badge floating directly above
                        if (isSelectedLoc)
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _forest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _mint, width: 1.2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black54, blurRadius: 6),
                                ],
                              ),
                              child: const Text(
                                '• SELECTED',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ),

                        // Hotspot Ring / Circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: isSelectedLoc ? 48 : 40,
                          height: isSelectedLoc ? 48 : 40,
                          decoration: BoxDecoration(
                            color: _carbon,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelectedLoc ? _mint : loc.color,
                              width: isSelectedLoc ? 3.0 : 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isSelectedLoc ? _mint : loc.color).withValues(alpha: isSelectedLoc ? 0.6 : 0.3),
                                blurRadius: isSelectedLoc ? 18 : 8,
                                spreadRadius: isSelectedLoc ? 4 : 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${loc.count}',
                              style: TextStyle(
                                color: isSelectedLoc ? _mint : _offWhite,
                                fontSize: isSelectedLoc ? 15 : 13,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Label
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelectedLoc ? _mint : _cardBorder,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            loc.name.split(' ').first,
                            style: TextStyle(
                              color: isSelectedLoc ? _mint : _offWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note, 'Timeline', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineDashboardScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Canvas Painter that recreates the Figma dark map layout (Waterways, Trail lines, Grid)
class _FigmaTerrainPainter extends CustomPainter {
  final double zoom;
  final bool showHeatmap;
  final bool isEmpty;

  _FigmaTerrainPainter({
    required this.zoom,
    required this.showHeatmap,
    required this.isEmpty,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark obsidian background
    final bgPaint = Paint()..color = const Color(0xFF101315);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Faint Nordic Sport Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x08FFFFFF)
      ..strokeWidth = 1.0;

    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 3. Contour curves (White 3% opacity like Figma)
    final contourPaint = Paint()
      ..color = const Color(0x0AFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final p1 = Path()
      ..moveTo(-40, size.height * 0.25)
      ..cubicTo(size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.3, size.width * 1.1, size.height * 0.22);
    canvas.drawPath(p1, contourPaint);

    final p2 = Path()
      ..moveTo(-30, size.height * 0.45)
      ..cubicTo(size.width * 0.3, size.height * 0.4, size.width * 0.6, size.height * 0.52, size.width * 1.1, size.height * 0.42);
    canvas.drawPath(p2, contourPaint);

    final p3 = Path()
      ..moveTo(-20, size.height * 0.7)
      ..cubicTo(size.width * 0.25, size.height * 0.65, size.width * 0.65, size.height * 0.78, size.width * 1.1, size.height * 0.68);
    canvas.drawPath(p3, contourPaint);

    if (!isEmpty) {
      // 4. River / Waterway (Dark blue vector ribbon stroke 24px)
      final riverWaterPaint = Paint()
        ..color = const Color(0xFF131D27)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24.0
        ..strokeCap = StrokeCap.round;

      final riverPath = Path()
        ..moveTo(size.width * 0.45, 0)
        ..cubicTo(size.width * 0.48, size.height * 0.2, size.width * 0.28, size.height * 0.4, size.width * 0.55, size.height * 0.7)
        ..cubicTo(size.width * 0.65, size.height * 0.85, size.width * 0.42, size.height * 0.95, size.width * 0.44, size.height);
      canvas.drawPath(riverPath, riverWaterPaint);

      // River Center Flow Line
      final riverCenterPaint = Paint()
        ..color = const Color(0x335D8FAF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawPath(riverPath, riverCenterPaint);

      // 5. Active Trail Curves (Riverside Trail Loop green/sage dashed trace)
      final trailPaint = Paint()
        ..color = const Color(0x737A8F7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final trailLoop = Path()
        ..moveTo(size.width * 0.32, size.height * 0.26)
        ..cubicTo(size.width * 0.55, size.height * 0.28, size.width * 0.85, size.height * 0.32, size.width * 0.88, size.height * 0.35);
      canvas.drawPath(trailLoop, trailPaint);

      // Training Track (Blue line)
      final trackPaint = Paint()
        ..color = const Color(0x665D8FAF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      final trackPath = Path()
        ..moveTo(size.width * 0.2, size.height * 0.62)
        ..cubicTo(size.width * 0.5, size.height * 0.64, size.width * 0.65, size.height * 0.62, size.width * 0.85, size.height * 0.72);
      canvas.drawPath(trackPath, trackPaint);

      // 6. Heatmap Gradient if active
      if (showHeatmap) {
        final heatCenter = Offset(size.width * 0.38, size.height * 0.42);
        final heatPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0x99ECC94B),
              const Color(0x55E53E3E),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: heatCenter, radius: 100 * zoom));
        canvas.drawCircle(heatCenter, 100 * zoom, heatPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FigmaTerrainPainter oldDelegate) {
    return oldDelegate.zoom != zoom ||
        oldDelegate.showHeatmap != showHeatmap ||
        oldDelegate.isEmpty != isEmpty;
  }
}
