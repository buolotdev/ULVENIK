import 'dart:async';
import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
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
const Color _catHealth = Color(0xFFE53E3E);
const Color _catGoals = Color(0xFFECC94B);

class TimelineMemoriesScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineMemoriesScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineMemoriesScreen> createState() => _TimelineMemoriesScreenState();
}

class _TimelineMemoriesScreenState extends State<TimelineMemoriesScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  String _selectedFilter = 'All';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  // Favorite toggles
  final Set<String> _favouriteIds = {'mem_1', 'mem_3'};

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

  void _showStoryPlayerModal({
    required String title,
    required String subtitle,
    required String date,
    required String dogName,
    required Color accentColor,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (ctx) => _MemoryStoryPlayer(
        title: title,
        subtitle: subtitle,
        date: date,
        dogName: dogName,
        accentColor: accentColor,
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
                  Icon(Icons.auto_awesome, color: _mint, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'About Timeline Memories',
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
                'Memories curate your canine milestones, past anniversaries ("On This Day"), and high-performance training arcs into visual retrospectives.',
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
        'Timeline Memories',
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
            } else if (val == 'stats') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineStatisticsScreen()),
              );
            } else if (val == 'export') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
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
              value: 'favourites',
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Color(0xFFB8920A), size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Favourites', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(Icons.archive_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Archive', style: TextStyle(color: _offWhite, fontSize: 13)),
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
            const PopupMenuItem(
              value: 'stats',
              child: Row(
                children: [
                  Icon(Icons.insights, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Statistics', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.file_download_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Export', style: TextStyle(color: _offWhite, fontSize: 13)),
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
                        Icons.auto_awesome,
                        size: 44,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'No Memories Yet',
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
                    'As you record milestones, training breakthroughs, and health logs, Ulvenik will automatically assemble memory reels and anniversary flashbacks.',
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
                      'Learn about Memories',
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
                        'Share',
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
        // 1. TOP 3-METRIC SUMMARY CARD
        _buildTopSummaryCard(),
        const SizedBox(height: 16),

        // 2. FILTER PILLS
        _buildFilterPills(),
        const SizedBox(height: 20),

        // 3. "ON THIS DAY" FEATURED FLASHBACK HERO
        _buildFlashbackHero(),
        const SizedBox(height: 24),

        // 4. MEMORY COLLECTIONS / TIME CAPSULES
        _buildSectionHeader('CURATED CAPSULES', '4 collections'),
        const SizedBox(height: 12),
        _buildCapsulesCarousel(),
        const SizedBox(height: 24),

        // 5. ALL MEMORIES FEED
        _buildSectionHeader('RECENT MEMORIES', '18 moments'),
        const SizedBox(height: 12),
        _buildMemoriesFeed(),
        const SizedBox(height: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '18',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'MEMORIES\nCREATED',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '2 Days Ago',
                        maxLines: 1,
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'LAST\nDISCOVERED',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3 Years',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'TIMELINE\nSPAN',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0x14FFFFFF), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: _mint, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Curated highlights for $_selectedDog • Updated daily',
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills() {
    final filters = ['All', 'On This Day', 'Milestones', 'Training', 'S&C'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _mint : _cardBorder,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFlashbackHero() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.35)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF262111),
            Color(0xFF16191B),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showStoryPlayerModal(
            title: "Koda's Agility Breakthrough",
            subtitle: '1 Year Ago Today — Flawless 12-Weave Pole Sequence',
            date: '28 OCT 2025',
            dogName: _selectedDog,
            accentColor: _gold,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF362E12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _gold.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, color: _gold, size: 14),
                          SizedBox(width: 6),
                          Text(
                            '1 YEAR AGO TODAY',
                            style: TextStyle(
                              color: _gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_circle_fill, color: _gold, size: 28),
                  ],
                ),
                const SizedBox(height: 14),

                // Main Title
                Text(
                  "$_selectedDog's Agility Breakthrough",
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'First full speed 12-weave sequence completed without faults in Bavarian trail training.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.4,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),

                // Video/Photo reel preview container
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF101214),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2326),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.sports_score, color: _gold, size: 32),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2326),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.timer, color: _catTraining, size: 32),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2326),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.terrain, color: _mint, size: 32),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.slideshow, color: _offWhite, size: 12),
                              SizedBox(width: 4),
                              Text('3 Media • 0:45', style: TextStyle(color: _offWhite, fontSize: 10)),
                            ],
                          ),
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

  Widget _buildCapsulesCarousel() {
    final capsules = [
      {
        'title': 'Summer 2026 Agility Arc',
        'count': '14 Moments',
        'color': _catTraining,
        'icon': Icons.flare,
      },
      {
        'title': 'First Field Trial Mastery',
        'count': '8 Moments',
        'color': _gold,
        'icon': Icons.emoji_events_outlined,
      },
      {
        'title': 'Summit Endurance Sprint',
        'count': '22 Moments',
        'color': _catSC,
        'icon': Icons.landscape_outlined,
      },
      {
        'title': 'Puppy Foundation Archive',
        'count': '34 Moments',
        'color': _catHealth,
        'icon': Icons.pets,
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: capsules.length,
        separatorBuilder: (_, i) => const SizedBox(width: 12),
        itemBuilder: (ctx, idx) {
          final c = capsules[idx];
          final color = c['color'] as Color;
          return Container(
            width: 160,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(c['icon'] as IconData, color: color, size: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c['count'] as String,
                      style: const TextStyle(color: _stoneGrey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMemoriesFeed() {
    final memories = [
      {
        'id': 'mem_1',
        'title': 'Mountain Summit Sprint & Recall',
        'category': 'TRAINING',
        'categoryColor': _catTraining,
        'date': '14 SEP 2026',
        'metrics': '1,200m Elev • 4.8 km',
        'description': 'Rapid whistle recall executed at high elevation overlooking the valley.',
      },
      {
        'id': 'mem_2',
        'title': 'Tracking Trial Grade 2 Certification',
        'category': 'GOALS',
        'categoryColor': _catGoals,
        'date': '02 AUG 2026',
        'metrics': '98/100 Pts • Gold Badge',
        'description': 'Flawless cornering on 400-pace track with aged leather target.',
      },
      {
        'id': 'mem_3',
        'title': 'High Load Conditioning Milestone',
        'category': 'S&C',
        'categoryColor': _catSC,
        'date': '19 JUN 2026',
        'metrics': '45 Mins • 185 bpm Peak',
        'description': 'Sand resistance sprint drills and core stabilization recovery.',
      },
    ];

    return Column(
      children: memories.map((m) {
        final id = m['id'] as String;
        final isFav = _favouriteIds.contains(id);
        final color = m['categoryColor'] as Color;

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
              onTap: () => _showStoryPlayerModal(
                title: m['title'] as String,
                subtitle: m['description'] as String,
                date: m['date'] as String,
                dogName: _selectedDog,
                accentColor: color,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Date & Star
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(
                              m['category'] as String,
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              m['date'] as String,
                              style: const TextStyle(color: _stoneGrey, fontSize: 11),
                            ),
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? _gold : _stoneGrey,
                            size: 18,
                          ),
                          onPressed: () => _toggleFavourite(id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(
                      m['title'] as String,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m['description'] as String,
                      style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 12),

                    // Metrics tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131618),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        m['metrics'] as String,
                        style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
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

/// Interactive Story / Reel Player for Memories
class _MemoryStoryPlayer extends StatefulWidget {
  final String title;
  final String subtitle;
  final String date;
  final String dogName;
  final Color accentColor;

  const _MemoryStoryPlayer({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.dogName,
    required this.accentColor,
  });

  @override
  State<_MemoryStoryPlayer> createState() => _MemoryStoryPlayerState();
}

class _MemoryStoryPlayerState extends State<_MemoryStoryPlayer> {
  int _currentSlide = 0;
  final int _totalSlides = 3;
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _progress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          if (_currentSlide < _totalSlides - 1) {
            _currentSlide++;
            _progress = 0.0;
          } else {
            _timer?.cancel();
            Navigator.pop(context);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Stack(
          children: [
            // Slide Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.accentColor.withValues(alpha: 0.3),
                    const Color(0xFF101214),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _currentSlide == 0
                      ? Icons.landscape
                      : _currentSlide == 1
                          ? Icons.pets
                          : Icons.emoji_events,
                  size: 100,
                  color: widget.accentColor.withValues(alpha: 0.4),
                ),
              ),
            ),

            // Story Progress Bars
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(_totalSlides, (idx) {
                  double val = 0.0;
                  if (idx < _currentSlide) {
                    val = 1.0;
                  } else if (idx == _currentSlide) {
                    val = _progress;
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: val,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation(widget.accentColor),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Top Header: Dog Name & Date & Close Button
            Positioned(
              top: 32,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: widget.accentColor.withValues(alpha: 0.2),
                    child: Text(
                      widget.dogName[0],
                      style: TextStyle(
                        color: widget.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dogName,
                        style: const TextStyle(
                          color: _offWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: _offWhite),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Bottom Caption & Controls
            Positioned(
              bottom: 32,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.slideshow, color: widget.accentColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Moment ${_currentSlide + 1} of $_totalSlides',
                            style: TextStyle(color: widget.accentColor, fontSize: 12),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: _offWhite, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
