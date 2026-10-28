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
const Color _gold = Color(0xFFECC94B);
const Color _blue = Color(0xFF5D8FAF);
const Color _orange = Color(0xFFDD6B20);
const Color _red = Color(0xFFE53E3E);
const Color _purple = Color(0xFF9F7AEA);

class SmartCollectionItem {
  final String id;
  final String name;
  final String rule;
  final int eventCount;
  final Color color;
  final IconData icon;
  final String lastUpdated;

  const SmartCollectionItem({
    required this.id,
    required this.name,
    required this.rule,
    required this.eventCount,
    required this.color,
    required this.icon,
    required this.lastUpdated,
  });
}

class TimelineSmartCollectionsScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineSmartCollectionsScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
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
  final Set<String> _favouriteIds = {'col_1', 'col_2'};

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final List<SmartCollectionItem> _collections = const [
    SmartCollectionItem(
      id: 'col_1',
      name: 'High Intensity S&C',
      rule: 'Heart Rate > 175 bpm • S&C',
      eventCount: 32,
      color: _orange,
      icon: Icons.whatshot,
      lastUpdated: 'Yesterday',
    ),
    SmartCollectionItem(
      id: 'col_2',
      name: 'Competition Wins & Podiums',
      rule: 'Competition + Placement <= 3',
      eventCount: 14,
      color: _gold,
      icon: Icons.emoji_events,
      lastUpdated: '3 days ago',
    ),
    SmartCollectionItem(
      id: 'col_3',
      name: 'Alpine Mountain Trail Runs',
      rule: 'Elevation > 800m • GPS Logged',
      eventCount: 28,
      color: _blue,
      icon: Icons.terrain,
      lastUpdated: 'Oct 24',
    ),
    SmartCollectionItem(
      id: 'col_4',
      name: 'Speed & Agility Masterclass',
      rule: 'Agility Obstacles < 45s Sequence',
      eventCount: 42,
      color: _mint,
      icon: Icons.bolt,
      lastUpdated: 'Oct 21',
    ),
    SmartCollectionItem(
      id: 'col_5',
      name: 'Injury & Vet Milestones',
      rule: 'Category = Vet | Medication',
      eventCount: 19,
      color: _red,
      icon: Icons.medical_services_outlined,
      lastUpdated: 'Sep 30',
    ),
    SmartCollectionItem(
      id: 'col_6',
      name: 'Photo & Video Highlights',
      rule: 'Has Media Attachments >= 1',
      eventCount: 86,
      color: _purple,
      icon: Icons.photo_library_outlined,
      lastUpdated: '2 hours ago',
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

  void _toggleFavourite(String id) {
    setState(() {
      if (_favouriteIds.contains(id)) {
        _favouriteIds.remove(id);
      } else {
        _favouriteIds.add(id);
      }
    });
  }

  void _showCreateCollectionModal() {
    final titleController = TextEditingController();
    String selectedRule = 'Heart Rate Threshold';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
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
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_motion, color: _mint, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'New Smart Collection',
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

                  // Name Field
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Collection Name (e.g. Scent Tracking 2026)',
                      hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF131718),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Rule Selection
                  const Text('Trigger Rule', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131718),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: DropdownButton<String>(
                      value: selectedRule,
                      dropdownColor: _carbon,
                      underline: const SizedBox.shrink(),
                      isExpanded: true,
                      items: [
                        'Heart Rate Threshold',
                        'Competition Score > 90',
                        'Elevation Profile > 500m',
                        'Has Media Attachments',
                        'Scent Training Category',
                      ].map((r) {
                        return DropdownMenuItem(
                          value: r,
                          child: Text(r, style: const TextStyle(color: _offWhite, fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedRule = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save Button
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
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _isEmptyState = false);
                      },
                      child: const Text('Create Collection', style: TextStyle(color: _offWhite)),
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
                  Icon(Icons.auto_awesome_motion, color: _mint, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'About Smart Collections',
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
                'Smart Collections dynamically aggregate timeline events based on configurable rules — such as peak heart rates, competition medals, trail elevation, or photo attachments.',
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
        child: _isEmptyState ? _buildEmptyState() : _buildPopulatedState(),
      ),
      floatingActionButton: _isEmptyState
          ? null
          : FloatingActionButton.extended(
              backgroundColor: _forest,
              icon: const Icon(Icons.add, color: _offWhite),
              label: const Text('New Smart Collection', style: TextStyle(color: _offWhite)),
              onPressed: _showCreateCollectionModal,
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
            if (val == 'toggle') {
              setState(() => _isEmptyState = !_isEmptyState);
            } else if (val == 'dog') {
              setState(() {
                _selectedDog = _selectedDog == 'Koda' ? 'Murphy' : 'Koda';
              });
            } else if (val == 'compare') {
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
                    _isEmptyState ? 'Switch to Populated' : 'Switch to Empty State',
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
              value: 'compare',
              child: Row(
                children: [
                  Icon(Icons.compare_arrows, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Compare', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'map',
              child: Row(
                children: [
                  Icon(Icons.map_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Activity Map', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
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
                        Icons.auto_awesome_motion_outlined,
                        size: 46,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'No Smart Collections Yet',
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
                    'Smart collections automatically group your timeline events using dynamic rules like high heart rate, competition medals, or mountain trails.',
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
                      onPressed: _showCreateCollectionModal,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: _offWhite, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Create First Collection',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: _showEducationalModal,
                    child: const Text(
                      'Learn about Smart Collections',
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
                      Icon(Icons.rule, color: _stoneGrey.withValues(alpha: 0.5), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Rules Engine',
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

  Widget _buildPopulatedState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. TOP METRICS SUMMARY BENTO
        _buildTopSummaryCard(),
        const SizedBox(height: 20),

        // 2. ACTIVE COLLECTIONS LIST
        _buildSectionHeader('ACTIVE SMART COLLECTIONS', '${_collections.length} Rules Running'),
        const SizedBox(height: 12),
        ..._collections.map((col) => _buildCollectionCard(col)),
        const SizedBox(height: 60), // Space for FAB
      ],
    );
  }

  Widget _buildTopSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildTopStat('COLLECTIONS', '${_collections.length} Active'),
              _buildTopStat('MATCHED EVENTS', '246 Events'),
              _buildTopStat('SYNC STATUS', 'Real-time'),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0x14FFFFFF), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.sync, color: _mint, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Auto-aggregating new events for $_selectedDog • 0 manual tagging needed',
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopStat(String label, String value) {
    return Expanded(
      child: Column(
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
      ),
    );
  }

  Widget _buildSectionHeader(String title, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          badge,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionCard(SmartCollectionItem item) {
    final isFav = _favouriteIds.contains(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimelineScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: item.color.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                ),
                const SizedBox(width: 14),

                // Name & Rule
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.rule,
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131718),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.eventCount} Events',
                              style: TextStyle(
                                color: item.color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Updated ${item.lastUpdated}',
                            style: const TextStyle(color: _stoneGrey, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Star Button
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? _gold : _stoneGrey,
                    size: 18,
                  ),
                  onPressed: () => _toggleFavourite(item.id),
                ),
              ],
            ),
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
