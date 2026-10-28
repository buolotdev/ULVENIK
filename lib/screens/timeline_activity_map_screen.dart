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
const Color _gold = Color(0xFFECC94B);

// Category Colors
const Color _catTraining = Color(0xFF5D8FAF);
const Color _catSC = Color(0xFFDD6B20);

class MapHotspot {
  final String id;
  final String name;
  final String category;
  final Color color;
  final int sessions;
  final double distanceKm;
  final int elevationM;
  final Offset relativePos; // (0.0 to 1.0)
  final String description;

  const MapHotspot({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.sessions,
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
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineActivityMapScreen> createState() =>
      _TimelineActivityMapScreenState();
}

class _TimelineActivityMapScreenState extends State<TimelineActivityMapScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  String _selectedCategory = 'All';
  MapHotspot? _selectedHotspot;
  bool _showHeatmap = false;
  double _zoomLevel = 1.0;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final List<MapHotspot> _allHotspots = const [
    MapHotspot(
      id: 'spot_1',
      name: 'Riverside Trail & Valley',
      category: 'Training',
      color: _catTraining,
      sessions: 14,
      distanceKm: 38.4,
      elevationM: 320,
      relativePos: Offset(0.32, 0.45),
      description: 'Primary endurance track with aged tracking scent lines along the river bank.',
    ),
    MapHotspot(
      id: 'spot_2',
      name: 'Alpine Ridge Summit',
      category: 'S&C',
      color: _catSC,
      sessions: 8,
      distanceKm: 24.6,
      elevationM: 1420,
      relativePos: Offset(0.68, 0.28),
      description: 'High elevation hill sprints and rocky incline agility testing.',
    ),
    MapHotspot(
      id: 'spot_3',
      name: 'Bavarian Forest Grid',
      category: 'Tracking',
      color: _gold,
      sessions: 22,
      distanceKm: 55.8,
      elevationM: 480,
      relativePos: Offset(0.52, 0.62),
      description: 'Dense woodland scent preservation zone with varied vegetation.',
    ),
    MapHotspot(
      id: 'spot_4',
      name: 'Meadow Agility Arena',
      category: 'Training',
      color: _mint,
      sessions: 11,
      distanceKm: 18.2,
      elevationM: 190,
      relativePos: Offset(0.24, 0.72),
      description: 'Open flat ground agility obstacles and high speed recall sequences.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _selectedDog = widget.initialDog;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<MapHotspot> get _filteredHotspots {
    if (_selectedCategory == 'All') return _allHotspots;
    return _allHotspots
        .where((h) => h.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  void _showEducationalModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.map_outlined, color: _mint, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'About Activity Map',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Activity Map plots your outdoor GPS routes, high-frequency training grounds, and elevation profiles automatically when GPS is logged in Timeline events.',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Got it', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isEmptyState ? _buildEmptyState() : _buildMapState(),
      ),
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
      title: const Text(
        'Timeline Activity Map',
        style: TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Toggle Empty/Populated State',
          icon: Icon(
            _isEmptyState ? Icons.visibility : Icons.visibility_off_outlined,
            color: _mint,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _isEmptyState = !_isEmptyState;
              if (_isEmptyState) _selectedHotspot = null;
            });
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _stoneGrey),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF272B29)),
          ),
          onSelected: (val) {
            if (val == 'toggle') {
              setState(() {
                _isEmptyState = !_isEmptyState;
                if (_isEmptyState) _selectedHotspot = null;
              });
            } else if (val == 'heatmap') {
              setState(() => _showHeatmap = !_showHeatmap);
            } else if (val == 'dog') {
              setState(() {
                _selectedDog = _selectedDog == 'Koda' ? 'Murphy' : 'Koda';
              });
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
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    _isEmptyState ? Icons.check_circle_outline : Icons.highlight_off,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isEmptyState ? 'Switch to Map View' : 'Switch to Empty State',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'heatmap',
              child: Row(
                children: [
                  Icon(
                    _showHeatmap ? Icons.layers_clear : Icons.layers,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _showHeatmap ? 'Disable Heatmap' : 'Enable Heatmap Overlay',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'dog',
              child: Row(
                children: [
                  const Icon(Icons.pets, color: _mint, size: 18),
                  const SizedBox(width: 10),
                  Text('Switch Dog ($_selectedDog)',
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

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _carbon,
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_off_outlined,
                        size: 44,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'No Location History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enable GPS tagging when recording outdoor training, scent work, or conditioning sessions to plot heatmaps and route traces.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: _offWhite, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: _showEducationalModal,
                    child: const Text(
                      'Learn about Activity Map',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Action Bar for Empty State
        Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
      ],
    );
  }

  Widget _buildMapState() {
    return Stack(
      children: [
        // 1. Dark Vector Map Canvas Background
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_selectedHotspot != null) {
                setState(() => _selectedHotspot = null);
              }
            },
            child: _buildVectorMapCanvas(),
          ),
        ),

        // 2. Top Floating Filters & Dog Badge
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopPillsRow(),
            ],
          ),
        ),

        // 3. Floating Right Map Controls (Zoom +, Zoom -, Recenter, Heatmap)
        Positioned(
          right: 16,
          bottom: _selectedHotspot != null ? 240 : 150,
          child: Column(
            children: [
              _buildMapControlBtn(
                icon: Icons.add,
                onTap: () => setState(() => _zoomLevel = (_zoomLevel + 0.2).clamp(0.8, 2.0)),
              ),
              const SizedBox(height: 8),
              _buildMapControlBtn(
                icon: Icons.remove,
                onTap: () => setState(() => _zoomLevel = (_zoomLevel - 0.2).clamp(0.8, 2.0)),
              ),
              const SizedBox(height: 8),
              _buildMapControlBtn(
                icon: Icons.my_location,
                onTap: () {
                  setState(() {
                    _zoomLevel = 1.0;
                    _selectedHotspot = null;
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildMapControlBtn(
                icon: _showHeatmap ? Icons.whatshot : Icons.whatshot_outlined,
                isActive: _showHeatmap,
                onTap: () => setState(() => _showHeatmap = !_showHeatmap),
              ),
            ],
          ),
        ),

        // 4. Bottom Sliding Inspection Card / Default Stats Sheet
        Positioned(
          bottom: 12,
          left: 16,
          right: 16,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: _selectedHotspot != null
                ? _buildMarkerDetailCard(_selectedHotspot!)
                : _buildDefaultMetricsCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildVectorMapCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // Dark map texture with terrain contours
            CustomPaint(
              size: Size(w, h),
              painter: _TerrainContourPainter(
                zoom: _zoomLevel,
                showHeatmap: _showHeatmap,
              ),
            ),

            // Hotspot Pins
            ..._filteredHotspots.map((spot) {
              final isSelected = _selectedHotspot?.id == spot.id;
              final pinX = spot.relativePos.dx * w;
              final pinY = spot.relativePos.dy * h;

              return Positioned(
                left: pinX - 22,
                top: pinY - 22,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedHotspot = spot);
                  },
                  child: AnimatedScale(
                    scale: isSelected ? 1.25 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pin Circle
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _carbon,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? _mint : spot.color,
                              width: isSelected ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isSelected ? _mint : spot.color).withValues(alpha: 0.4),
                                blurRadius: isSelected ? 16 : 8,
                                spreadRadius: isSelected ? 4 : 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_on,
                              color: isSelected ? _mint : spot.color,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Title Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? _mint : _cardBorder,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            spot.name.split(' ').first,
                            style: TextStyle(
                              color: isSelected ? _mint : _offWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTopPillsRow() {
    final categories = ['All', 'Training', 'S&C', 'Tracking'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _mint.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.pets, color: _mint, size: 14),
                const SizedBox(width: 6),
                Text(
                  _selectedDog,
                  style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ...categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? _forest : Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? _mint : _cardBorder,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? _offWhite : _stoneGrey,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMapControlBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isActive ? _forest : const Color(0xCC1A1F22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? _mint : _cardBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(
          icon,
          color: isActive ? _mint : _offWhite,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDefaultMetricsCard() {
    return Container(
      key: const ValueKey('default_metrics'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricStat('HOTSPOTS', '${_filteredHotspots.length} Logged'),
              _buildMetricStat('TOTAL DIST', '55.8 km'),
              _buildMetricStat('MAX ELEV', '1,420 m'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0x14FFFFFF), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.touch_app_outlined, color: _mint, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Tap any pin on map to inspect terrain details',
                    style: TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
              Text(
                '$_selectedDog GPS',
                style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerDetailCard(MapHotspot spot) {
    return Container(
      key: ValueKey(spot.id),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: spot.color.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: spot.color.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: spot.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    spot.category.toUpperCase(),
                    style: TextStyle(
                      color: spot.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${spot.sessions} Sessions',
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                onPressed: () => setState(() => _selectedHotspot = null),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            spot.name,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            spot.description,
            style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 14),

          // 3 Metric Badges
          Row(
            children: [
              _buildPinPill(Icons.straighten, '${spot.distanceKm} km', 'Distance'),
              const SizedBox(width: 8),
              _buildPinPill(Icons.terrain, '${spot.elevationM} m', 'Elevation'),
              const SizedBox(width: 8),
              _buildPinPill(Icons.history, '${spot.sessions} Logs', 'Frequency'),
            ],
          ),
          const SizedBox(height: 14),

          // View in Timeline CTA
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View ${spot.sessions} Sessions in Timeline',
                    style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPinPill(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF121517),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: _mint, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _stoneGrey, fontSize: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

/// Custom Vector Terrain Contour Painter for Activity Map
class _TerrainContourPainter extends CustomPainter {
  final double zoom;
  final bool showHeatmap;

  _TerrainContourPainter({required this.zoom, required this.showHeatmap});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF121517);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x0AFFFFFF)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Elevation contour lines
    final contourPaint = Paint()
      ..color = const Color(0x14FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.35);
    path1.cubicTo(size.width * 0.3, size.height * 0.25, size.width * 0.6, size.height * 0.45, size.width, size.height * 0.3);
    canvas.drawPath(path1, contourPaint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.55);
    path2.cubicTo(size.width * 0.35, size.height * 0.65, size.width * 0.7, size.height * 0.48, size.width, size.height * 0.6);
    canvas.drawPath(path2, contourPaint);

    // River / trail path
    final trailPaint = Paint()
      ..color = const Color(0x335D8FAF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final riverPath = Path();
    riverPath.moveTo(size.width * 0.2, 0);
    riverPath.cubicTo(size.width * 0.28, size.height * 0.4, size.width * 0.42, size.height * 0.55, size.width * 0.65, size.height);
    canvas.drawPath(riverPath, trailPaint);

    // Heatmap circles if enabled
    if (showHeatmap) {
      final heatPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0x80ECC94B),
            const Color(0x40E53E3E),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(size.width * 0.45, size.height * 0.5), radius: 120 * zoom));
      canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.5), 120 * zoom, heatPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TerrainContourPainter oldDelegate) {
    return oldDelegate.zoom != zoom || oldDelegate.showHeatmap != showHeatmap;
  }
}
