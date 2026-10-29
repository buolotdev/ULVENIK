import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_memories_screen.dart';
import 'timeline_activity_map_screen.dart';
import 'timeline_compare_screen.dart';
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

// Badge Colors
const Color _catTime = Color(0xFF38434A);
const Color _catMedia = Color(0xFF4C3B6E);
const Color _catTraining = Color(0xFF5D8FAF);
const Color _catSC = Color(0xFFB4823C);
const Color _catGoals = Color(0xFFB8920A);
const Color _catHealth = Color(0xFF8B3A3A);

class TimelineSmartCollectionsScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineSmartCollectionsScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Murphy',
  });

  @override
  State<TimelineSmartCollectionsScreen> createState() =>
      _TimelineSmartCollectionsScreenState();
}

class _TimelineSmartCollectionsScreenState
    extends State<TimelineSmartCollectionsScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _selectedDog = widget.initialDog;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _openCollection(String title, int count) {
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
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 18),
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('$count matching events in collection • $_selectedDog', style: const TextStyle(color: _stoneGrey, fontSize: 13)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _forest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TimelineScreen()),
                    );
                  },
                  child: const Text('Open Filtered Timeline', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortModal() {
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
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 18),
              const Text('SORT SMART COLLECTIONS', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Preset Category Order (Default)', style: TextStyle(color: _offWhite, fontSize: 14)),
                trailing: const Icon(Icons.check, color: _mint),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                title: const Text('Most Events First', style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                title: const Text('Recently Updated First', style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () => Navigator.pop(ctx),
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
        child: _isEmptyState ? _buildEmptyState() : _buildPopulatedState(),
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
        'Smart Collections',
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
            setState(() => _isEmptyState = !_isEmptyState);
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
            if (val == 'compare') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineCompareScreen()),
              );
            } else if (val == 'map') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineActivityMapScreen()),
              );
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
            } else if (val == 'settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineSettingsScreen()),
              );
            }
          },
          itemBuilder: (ctx) => const [
            PopupMenuItem(
              value: 'compare',
              child: Row(
                children: [
                  Icon(Icons.compare_arrows, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Compare', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'map',
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Activity Map', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'memories',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Memories', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
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

  // ════════════════════════════════════════════════════════════════════════════
  // POPULATED STATE (Matching Figma 'Timeline Smart Collections - Populated State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedState() {
    return Column(
      children: [
        // 1. Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: _stoneGrey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Search collections...',
                      hintStyle: TextStyle(color: _stoneGrey, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic_none, color: _stoneGrey, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice search listening...')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // 2. Sync Status Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  const Text(
                    '15 SMART PRESETS SYNCED',
                    style: TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                ],
              ),
              const Text(
                'AUTO-COMPILED',
                style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Collections Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              // SECTION 1: TIME-BASED RANGE
              _buildSectionTitle('TIME-BASED RANGE'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'This Week',
                      eventCount: 12,
                      subtitle: 'Updated just now',
                      badge: 'TIME',
                      badgeColor: _catTime,
                      bgGradient: const [Color(0xFF283633), Color(0xFF161E1C)],
                      icon: Icons.calendar_view_week,
                      onTap: () => _openCollection('This Week', 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'This Month',
                      eventCount: 47,
                      subtitle: 'Updated 3h ago',
                      badge: 'TIME',
                      badgeColor: _catTime,
                      bgGradient: const [Color(0xFF243038), Color(0xFF141A1E)],
                      icon: Icons.calendar_month,
                      onTap: () => _openCollection('This Month', 47),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Last Month',
                      eventCount: 61,
                      subtitle: 'Updated 1 Sep',
                      badge: 'TIME',
                      badgeColor: _catTime,
                      bgGradient: const [Color(0xFF2B3439), Color(0xFF161B1E)],
                      icon: Icons.history,
                      onTap: () => _openCollection('Last Month', 61),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'This Year',
                      eventCount: 147,
                      subtitle: 'Updated 3h ago',
                      badge: 'TIME',
                      badgeColor: _catTime,
                      bgGradient: const [Color(0xFF24322C), Color(0xFF131C18)],
                      icon: Icons.date_range,
                      onTap: () => _openCollection('This Year', 147),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION 2: MEDIA & ARTIFACTS
              _buildSectionTitle('MEDIA & ARTIFACTS'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Events with Photos',
                      eventCount: 89,
                      subtitle: 'Updated 3h ago',
                      badge: 'MEDIA',
                      badgeColor: _catMedia,
                      bgGradient: const [Color(0xFF32283D), Color(0xFF1B1522)],
                      icon: Icons.photo_library_outlined,
                      onTap: () => _openCollection('Events with Photos', 89),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Events with Videos',
                      eventCount: 23,
                      subtitle: 'Updated 2 Sep',
                      badge: 'MEDIA',
                      badgeColor: _catMedia,
                      bgGradient: const [Color(0xFF2C243B), Color(0xFF161220)],
                      icon: Icons.play_circle_outline,
                      onTap: () => _openCollection('Events with Videos', 23),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Events with Voice Notes',
                      eventCount: 14,
                      subtitle: 'Updated 28 Aug',
                      badge: 'MEDIA',
                      badgeColor: _catMedia,
                      bgGradient: const [Color(0xFF272134), Color(0xFF14101D)],
                      icon: Icons.mic_none,
                      onTap: () => _openCollection('Events with Voice Notes', 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Events with Documents',
                      eventCount: 8,
                      subtitle: 'Updated 15 Aug',
                      badge: 'MEDIA',
                      badgeColor: _catMedia,
                      bgGradient: const [Color(0xFF262033), Color(0xFF13101C)],
                      icon: Icons.description_outlined,
                      onTap: () => _openCollection('Events with Documents', 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION 3: SPORT & CONDITIONING
              _buildSectionTitle('SPORT & CONDITIONING'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Training Journey',
                      eventCount: 94,
                      subtitle: 'Updated 3h ago',
                      badge: 'TRAINING',
                      badgeColor: _catTraining,
                      bgGradient: const [Color(0xFF223642), Color(0xFF111D24)],
                      icon: Icons.fitness_center_outlined,
                      onTap: () => _openCollection('Training Journey', 94),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'S&C Journey',
                      eventCount: 31,
                      subtitle: 'Updated 1 Sep',
                      badge: 'S&C',
                      badgeColor: _catSC,
                      bgGradient: const [Color(0xFF382A1B), Color(0xFF1E160C)],
                      icon: Icons.directions_run_outlined,
                      onTap: () => _openCollection('S&C Journey', 31),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Goal Journey',
                      eventCount: 22,
                      subtitle: 'Updated 9 Sep',
                      badge: 'GOALS',
                      badgeColor: _catGoals,
                      bgGradient: const [Color(0xFF363216), Color(0xFF1D1B08)],
                      icon: Icons.flag_outlined,
                      onTap: () => _openCollection('Goal Journey', 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Recently Added',
                      eventCount: 6,
                      subtitle: 'Updated just now',
                      badge: 'TIME',
                      badgeColor: _catTime,
                      bgGradient: const [Color(0xFF253337), Color(0xFF121B1D)],
                      icon: Icons.schedule,
                      onTap: () => _openCollection('Recently Added', 6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECTION 4: HEALTH & BIOMETRICS
              _buildSectionTitle('HEALTH & BIOMETRICS'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Health Records',
                      eventCount: 38,
                      subtitle: 'Updated 3 Sep',
                      badge: 'HEALTH',
                      badgeColor: _catHealth,
                      bgGradient: const [Color(0xFF352023), Color(0xFF1C1012)],
                      icon: Icons.monitor_heart_outlined,
                      onTap: () => _openCollection('Health Records', 38),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGridCollectionCard(
                      title: 'Weight History',
                      eventCount: 24,
                      subtitle: 'Updated 1 Sep',
                      badge: 'HEALTH',
                      badgeColor: _catHealth,
                      bgGradient: const [Color(0xFF331F21), Color(0xFF1B0F11)],
                      icon: Icons.scale_outlined,
                      onTap: () => _openCollection('Weight History', 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Wide Vet Visits Card
              _buildVetVisitsWideCard(),
            ],
          ),
        ),

        // Bottom Split Bar: Sort | INDEX: SPORT v4.2 | Filter
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildGridCollectionCard({
    required String title,
    required int eventCount,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required List<Color> bgGradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 154,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgGradient,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Icon + Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: _offWhite.withValues(alpha: 0.8), size: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom Titles & Counts
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          '$eventCount',
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'events',
                          style: TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _stoneGrey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVetVisitsWideCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openCollection('Vet Visits', 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Left Photo/Thumbnail representation
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2224),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _catHealth.withValues(alpha: 0.4)),
                  ),
                  child: const Center(
                    child: Icon(Icons.local_hospital_outlined, color: _catHealth, size: 28),
                  ),
                ),
                const SizedBox(width: 14),

                // Right Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vet Visits',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _catHealth.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'HEALTH',
                              style: TextStyle(color: _offWhite, fontSize: 9, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Medical checkups & lab results',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: '12 ', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
                            TextSpan(text: 'events logged  •  ', style: TextStyle(color: _stoneGrey, fontSize: 11, fontFamily: 'Inter')),
                            TextSpan(text: 'Updated 7 Sep', style: TextStyle(color: _stoneGrey, fontSize: 11, fontFamily: 'Inter')),
                          ],
                        ),
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

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showSortModal,
            child: const Row(
              children: [
                Icon(Icons.swap_vert, color: _stoneGrey, size: 16),
                SizedBox(width: 6),
                Text('Sort', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Text(
            'INDEX: SPORT v4.2',
            style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter presets applied')),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.filter_list, color: _stoneGrey, size: 16),
                SizedBox(width: 6),
                Text('Filter', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matching Figma 'Timeline Smart Collections - Empty State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Column(
      children: [
        // Search bar (disabled in empty state)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Icon(Icons.search, color: _stoneGrey, size: 20),
                SizedBox(width: 8),
                Text('Search collections...', style: TextStyle(color: _stoneGrey, fontSize: 14)),
                Spacer(),
                Icon(Icons.mic_none, color: _stoneGrey, size: 20),
                SizedBox(width: 12),
              ],
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Folder with sparkles icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _carbon,
                    border: Border.all(color: _cardBorder, width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.folder_open_outlined, color: _stoneGrey, size: 36),
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: _mint,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_awesome, color: _obsidian, size: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'No Collections Available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  'Collections appear automatically as Timeline events are recorded.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        Text('Go to Timeline', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _showLearnModal,
                  child: const Text(
                    'Learn about Smart Collections',
                    style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Bar (Faint)
        Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.swap_vert, color: _stoneGrey.withValues(alpha: 0.4), size: 16),
                  const SizedBox(width: 6),
                  Text('Sort', style: TextStyle(color: _stoneGrey.withValues(alpha: 0.4), fontSize: 13)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.search, color: _stoneGrey.withValues(alpha: 0.4), size: 16),
                  const SizedBox(width: 6),
                  Text('Search', style: TextStyle(color: _stoneGrey.withValues(alpha: 0.4), fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLearnModal() {
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
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 18),
              const Text('About Smart Collections', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                'Smart Collections dynamically aggregate your canine events by sport disciplines, media attachments, time horizons, and veterinary milestones without manual tagging.',
                style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _forest, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
