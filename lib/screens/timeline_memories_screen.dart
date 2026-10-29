import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_activity_map_screen.dart';
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

// Category Colors matching Figma
const Color _catTraining = Color(0xFF5D8FAF); // Blue
const Color _catSC = Color(0xFFB4823C);       // Bronze / Orange
const Color _catHealth = Color(0xFF8B3A3A);   // Red
const Color _catGoals = Color(0xFFB8920A);    // Yellow / Gold
const Color _catComp = Color(0xFF2E6B57);     // Forest Green
const Color _catPuppy = Color(0xFF57B69D);    // Teal

class TimelineMemoriesScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineMemoriesScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Murphy',
  });

  @override
  State<TimelineMemoriesScreen> createState() => _TimelineMemoriesScreenState();
}

class _TimelineMemoriesScreenState extends State<TimelineMemoriesScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  String? _selectedCategoryFilter;

  // Expansion toggles
  bool _expandedMonth = false;
  bool _expanded2023 = false;
  bool _expanded2022 = false;

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
    _animController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    String? tempFilter = _selectedCategoryFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 16),
                  const Text(
                    'FILTER MEMORY CATEGORIES',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      _buildFilterChip('All Memories', null, null, tempFilter, (c) => setModalState(() => tempFilter = c)),
                      _buildFilterChip('Training', 'Training', _catTraining, tempFilter, (c) => setModalState(() => tempFilter = c)),
                      _buildFilterChip('Goals', 'Goals', _catGoals, tempFilter, (c) => setModalState(() => tempFilter = c)),
                      _buildFilterChip('Health', 'Health', _catHealth, tempFilter, (c) => setModalState(() => tempFilter = c)),
                      _buildFilterChip('S&C', 'S&C', _catSC, tempFilter, (c) => setModalState(() => tempFilter = c)),
                      _buildFilterChip('Competition', 'Competition', _catComp, tempFilter, (c) => setModalState(() => tempFilter = c)),
                      _buildFilterChip('Puppyhood', 'Puppyhood', _catPuppy, tempFilter, (c) => setModalState(() => tempFilter = c)),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                        setState(() {
                          _selectedCategoryFilter = tempFilter;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Apply Filter', style: TextStyle(color: _offWhite)),
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

  Widget _buildFilterChip(
    String label,
    String? categoryValue,
    Color? color,
    String? currentSelected,
    ValueChanged<String?> onSelect,
  ) {
    final isSelected = currentSelected == categoryValue;
    return GestureDetector(
      onTap: () => onSelect(categoryValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? _forest).withValues(alpha: 0.25) : _obsidian,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? (color ?? _mint) : _cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _offWhite : _stoneGrey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showYearJumpPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 16),
              const Text(
                'BROWSE BY YEAR',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildYearButton('2026', true),
                  _buildYearButton('2025', false),
                  _buildYearButton('2024', false),
                  _buildYearButton('2023', false),
                  _buildYearButton('2022', false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearButton(String year, bool isCurrent) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _carbon,
            content: Text('Jumped to memories from $year', style: const TextStyle(color: _offWhite)),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrent ? _forest : _obsidian,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isCurrent ? _mint : _cardBorder),
        ),
        child: Text(
          year,
          style: TextStyle(
            color: isCurrent ? _offWhite : _stoneGrey,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _showShareModal(String memoryTitle) {
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
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'SHARE MEMORY',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Text(
                memoryTitle,
                style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.image_outlined, color: _mint),
                title: const Text('Export Memory Card (Image)', style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Memory card generated for sharing')),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.link, color: _mint),
                title: const Text('Copy Memory Link', style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Memory link copied to clipboard')),
                  );
                },
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
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Timeline Memories',
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
        IconButton(
          tooltip: 'Filter Memories',
          icon: Icon(
            Icons.tune,
            color: _selectedCategoryFilter != null ? _mint : _stoneGrey,
            size: 20,
          ),
          onPressed: _showFilterModal,
        ),
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
            if (val == 'map') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineActivityMapScreen()),
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
            } else if (val == 'export') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
              );
            } else if (val == 'stats') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineStatisticsScreen()),
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
              value: 'insights',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Timeline Insights', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.file_upload_outlined, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Export Timeline', style: TextStyle(color: _offWhite, fontSize: 13)),
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
  // POPULATED STATE (Matching Figma 'Timeline Memories - Populated State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildPopulatedState() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // Active Filter Indicator
              if (_selectedCategoryFilter != null) ...[
                _buildActiveFilterIndicator(),
                const SizedBox(height: 12),
              ],

              // 1. HERO MEMORY CARD (One Year Ago Today)
              _buildHeroMemoryCard(),
              const SizedBox(height: 24),

              // 2. TODAY (2 Memories)
              _buildSectionHeader('TODAY', '2 Memories'),
              const SizedBox(height: 10),
              _buildMemoryCard(
                category: 'TRAINING',
                categoryColor: _catTraining,
                timeBadge: '2 Years Ago',
                timeBadgeColor: const Color(0xFF382F10),
                timeBadgeTextColor: _gold,
                title: 'Scent Work Introduction — First Session',
                subtitle: '14 Sep 2023',
                details: 'Riverside Trail • 45 min • 3 skills',
                leadingWidget: _buildThumbnailBox(Icons.pets, _catTraining),
                onTap: () => _openEventDetail('Scent Work Introduction'),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'GOALS',
                categoryColor: _catGoals,
                timeBadge: '1 Year Ago',
                timeBadgeColor: const Color(0xFF382F10),
                timeBadgeTextColor: _gold,
                title: 'Completed Goal: Distance Down',
                subtitle: '14 Sep 2024',
                details: 'Achieved after 38 days • 22 sessions',
                leadingWidget: _buildIconBox(Icons.emoji_events_outlined, _gold),
                onTap: () => _openEventDetail('Distance Down Goal'),
              ),
              const SizedBox(height: 24),

              // 3. THIS MONTH (5 Memories)
              _buildSectionHeader('THIS MONTH', '5 Memories'),
              const SizedBox(height: 10),
              _buildMemoryCard(
                category: 'HEALTH',
                categoryColor: _catHealth,
                timeBadge: '3 Years Ago',
                timeBadgeColor: const Color(0xFF24282B),
                timeBadgeTextColor: _stoneGrey,
                title: 'Murphy\'s ACL Recovery — Final Checkup',
                subtitle: '7 Sep 2022',
                details: 'Recovery completed after 14 weeks rehabilitation',
                leadingWidget: _buildIconBox(Icons.medical_services_outlined, _catHealth),
                onTap: () => _openEventDetail('ACL Recovery'),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'S&C',
                categoryColor: _catSC,
                timeBadge: '2 Years Ago',
                timeBadgeColor: const Color(0xFF382F10),
                timeBadgeTextColor: _gold,
                title: 'First Conditioning Assessment',
                subtitle: '3 Sep 2023',
                details: 'Baseline recorded — 8 exercises logged',
                leadingWidget: _buildThumbnailBox(Icons.directions_run, _catSC),
                onTap: () => _openEventDetail('Conditioning Assessment'),
              ),

              // Expandable: + 3 more this month
              if (_expandedMonth) ...[
                const SizedBox(height: 8),
                _buildMemoryCard(
                  category: 'TRAINING',
                  categoryColor: _catTraining,
                  timeBadge: '2 Years Ago',
                  timeBadgeColor: const Color(0xFF382F10),
                  timeBadgeTextColor: _gold,
                  title: 'Long Line Recall Progression',
                  subtitle: '18 Sep 2023',
                  details: 'Field track • 30m distance tested',
                  leadingWidget: _buildThumbnailBox(Icons.explore_outlined, _catTraining),
                  onTap: () => _openEventDetail('Long Line Recall'),
                ),
                const SizedBox(height: 8),
                _buildMemoryCard(
                  category: 'HEALTH',
                  categoryColor: _catHealth,
                  timeBadge: '1 Year Ago',
                  timeBadgeColor: const Color(0xFF382F10),
                  timeBadgeTextColor: _gold,
                  title: 'Annual Dental & Vaccinations',
                  subtitle: '22 Sep 2024',
                  details: 'Dr. Evans Veterinary Clinic • All clear',
                  leadingWidget: _buildIconBox(Icons.vaccines_outlined, _catHealth),
                  onTap: () => _openEventDetail('Annual Vaccinations'),
                ),
                const SizedBox(height: 8),
                _buildMemoryCard(
                  category: 'GOALS',
                  categoryColor: _catGoals,
                  timeBadge: '3 Years Ago',
                  timeBadgeColor: const Color(0xFF24282B),
                  timeBadgeTextColor: _stoneGrey,
                  title: 'Beginner Agility Foundation Completed',
                  subtitle: '28 Sep 2022',
                  details: 'Weave poles & tunnel drive verified',
                  leadingWidget: _buildIconBox(Icons.flag_outlined, _gold),
                  onTap: () => _openEventDetail('Agility Foundation'),
                ),
              ],
              const SizedBox(height: 6),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _expandedMonth = !_expandedMonth),
                  child: Text(
                    _expandedMonth ? '— Show less this month' : '+ 3 more this month ˅',
                    style: const TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 4. MILESTONES (4 Memories)
              _buildSectionHeader('MILESTONES', '4 Memories'),
              const SizedBox(height: 10),
              _buildMemoryCard(
                category: 'MILESTONE',
                categoryColor: _mint,
                timeBadge: 'First Entry',
                timeBadgeColor: const Color(0xFF142B22),
                timeBadgeTextColor: _mint,
                title: 'Murphy Joins Ulvenik',
                subtitle: '2 Jan 2022',
                details: 'The beginning of Murphy\'s recorded journey',
                leadingWidget: _buildIconBox(Icons.flag_outlined, _mint),
                isMilestone: true,
                onTap: () => _openEventDetail('Murphy Joins Ulvenik'),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'MILESTONE',
                categoryColor: _mint,
                timeBadge: '100th Event',
                timeBadgeColor: const Color(0xFF142B22),
                timeBadgeTextColor: _mint,
                title: '100th Timeline Entry',
                subtitle: '18 Mar 2023',
                details: 'Reached 100 recorded Timeline events',
                leadingWidget: _buildIconBox(Icons.military_tech_outlined, _gold),
                isMilestone: true,
                onTap: () => _openEventDetail('100th Timeline Entry'),
              ),
              const SizedBox(height: 24),

              // 5. ACHIEVEMENTS (3 Memories)
              _buildSectionHeader('ACHIEVEMENTS', '3 Memories'),
              const SizedBox(height: 10),
              _buildMemoryCard(
                category: 'TRAINING',
                categoryColor: _catTraining,
                timeBadge: '1 Year Ago',
                timeBadgeColor: const Color(0xFF382F10),
                timeBadgeTextColor: _gold,
                title: 'Longest Recording Streak — 31 Days',
                subtitle: 'March 2025',
                details: 'Your best ever consecutive recording streak',
                leadingWidget: _buildThumbnailBox(Icons.local_fire_department_outlined, _catTraining),
                onTap: () => _openEventDetail('Longest Streak Achievement'),
              ),
              const SizedBox(height: 24),

              // 6. PREVIOUS YEARS
              const Text(
                'PREVIOUS YEARS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 14),

              // 2024 Subheading
              const Text(
                '2024',
                style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'COMPETITION',
                categoryColor: _catComp,
                title: 'Regional IGP I Tracking Trial',
                subtitle: '',
                details: 'Scored 94/100 • Qualified Excellent',
                leadingWidget: _buildIconBox(Icons.flag, _catComp),
                onTap: () => _openEventDetail('Regional IGP Trial'),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'TRAINING',
                categoryColor: _catTraining,
                title: 'First Broad Jump Regulation Clear',
                subtitle: '',
                details: 'Nordic Training Grounds • Height 1.2m',
                leadingWidget: _buildIconBox(Icons.fitness_center, _catTraining),
                onTap: () => _openEventDetail('Broad Jump Clear'),
              ),
              const SizedBox(height: 16),

              // 2023 Subheading
              const Text(
                '2023',
                style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'TRAINING',
                categoryColor: _catTraining,
                title: 'Heeling under High Distraction',
                subtitle: '',
                details: 'Suburban perimeter session',
                leadingWidget: _buildThumbnailBox(Icons.pets, _catTraining),
                onTap: () => _openEventDetail('Heeling Session'),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'GOALS',
                categoryColor: _catGoals,
                title: 'Foundation Heeling Certified',
                subtitle: '',
                details: 'Club evaluation passed 10/10',
                leadingWidget: _buildIconBox(Icons.flag_outlined, _catGoals),
                onTap: () => _openEventDetail('Foundation Heeling'),
              ),
              if (_expanded2023) ...[
                const SizedBox(height: 8),
                _buildMemoryCard(
                  category: 'HEALTH',
                  categoryColor: _catHealth,
                  title: 'Hip & Elbow Dysplasia Screening (Clear)',
                  subtitle: '',
                  details: 'OFA Certification recorded Grade 1',
                  leadingWidget: _buildIconBox(Icons.medical_services_outlined, _catHealth),
                  onTap: () => _openEventDetail('Screening Clear'),
                ),
              ],
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _expanded2023 = !_expanded2023),
                  child: Text(
                    _expanded2023 ? '— Less from 2023' : '+ More from 2023 ˅',
                    style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 2022 Subheading
              const Text(
                '2022',
                style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _buildMemoryCard(
                category: 'PUPPYHOOD',
                categoryColor: _catPuppy,
                title: 'First Crate Night & House Manners',
                subtitle: '',
                details: 'Zero distress logged',
                leadingWidget: _buildIconBox(Icons.sentiment_very_satisfied_outlined, _catPuppy),
                onTap: () => _openEventDetail('Puppy First Night'),
              ),
              if (_expanded2022) ...[
                const SizedBox(height: 8),
                _buildMemoryCard(
                  category: 'TRAINING',
                  categoryColor: _catTraining,
                  title: 'Name Recognition & Food Luring',
                  subtitle: '',
                  details: 'First training rep in Ulvenik',
                  leadingWidget: _buildIconBox(Icons.check_circle_outline, _catTraining),
                  onTap: () => _openEventDetail('Name Recognition'),
                ),
              ],
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _expanded2022 = !_expanded2022),
                  child: Text(
                    _expanded2022 ? '— Less from 2022' : '+ More from 2022 ˅',
                    style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Action Bar: Filter Categories | Browse Years
        _buildBottomSplitBar(),
      ],
    );
  }

  Widget _buildActiveFilterIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _mint.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list, color: _mint, size: 16),
              const SizedBox(width: 8),
              Text(
                'Filtered by: $_selectedCategoryFilter',
                style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _selectedCategoryFilter = null),
            child: const Text('Clear', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMemoryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF263339),
            Color(0xFF14191C),
            Color(0xFF101214),
          ],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mountain hero artwork placeholder / header
          Container(
            height: 140,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C3E47), Color(0xFF1E282D), Color(0xFF121618)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MountainSilhouettePainter(),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '• ONE YEAR AGO TODAY',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content below
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Murphy\'s First Off-Lead Recall Session',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '14 Sep 2025 • Riverside Trail',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A major training breakthrough — Murphy completed three successful off-lead recalls at Riverside Trail. Solid responsiveness despite bird distractions.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 18),

                // Primary CTA: Open Original Event
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
                    onPressed: () => _openEventDetail('Murphy\'s First Off-Lead Recall Session'),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Open Original Event',
                          style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Secondary CTA: Share This Memory
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showShareModal('Murphy\'s First Off-Lead Recall Session'),
                    icon: const Icon(Icons.share_outlined, color: _stoneGrey, size: 16),
                    label: const Text(
                      'Share This Memory',
                      style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
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

  Widget _buildSectionHeader(String title, String countBadge) {
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
          ),
        ),
        Text(
          countBadge,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryCard({
    required String category,
    required Color categoryColor,
    String? timeBadge,
    Color? timeBadgeColor,
    Color? timeBadgeTextColor,
    required String title,
    required String subtitle,
    required String details,
    required Widget leadingWidget,
    bool isMilestone = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leadingWidget,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Category dot + label + optional Time Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(color: categoryColor, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                category,
                                style: TextStyle(
                                  color: categoryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          if (timeBadge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: timeBadgeColor ?? const Color(0xFF24282B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                timeBadge,
                                style: TextStyle(
                                  color: timeBadgeTextColor ?? _stoneGrey,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Row(
                        children: [
                          if (isMilestone) ...[
                            const Icon(Icons.workspace_premium, color: _mint, size: 14),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Text(
                        details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailBox(IconData fallbackIcon, Color tint) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: _obsidian,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder),
      ),
      child: Center(
        child: Icon(fallbackIcon, color: tint, size: 22),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color tint) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: _obsidian,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder),
      ),
      child: Center(
        child: Icon(icon, color: tint, size: 20),
      ),
    );
  }

  Widget _buildBottomSplitBar() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _showFilterModal,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_list, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Filter Categories', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          Container(width: 1, height: 20, color: const Color(0x1AFFFFFF)),
          Expanded(
            child: InkWell(
              onTap: _showYearJumpPicker,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, color: _stoneGrey, size: 16),
                    SizedBox(width: 6),
                    Text('Browse Years', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // EMPTY STATE (Matching Figma 'Timeline Memories - Empty State.svg')
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Radar clock icon inside concentric circles
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _carbon,
                    border: Border.all(color: _cardBorder, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 16),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _obsidian,
                        border: Border.all(color: _mint.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.history_toggle_off, color: _mint, size: 26),
                      ),
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
                  'As your dog\'s journey grows, memorable moments and anniversaries will appear here automatically.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 32),

                // Go to Timeline CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                        Text(
                          'Go to Timeline',
                          style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: _offWhite, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Learn link
                GestureDetector(
                  onTap: _showLearnModal,
                  child: const Text(
                    'Learn about Timeline Memories',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Milestone Engine Card (Standby)
                Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.timeline, color: _mint, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'MILESTONE ENGINE',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14241E),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: _forest.withValues(alpha: 0.5)),
                            ),
                            child: const Text(
                              'STANDBY',
                              style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ulvenik logs field trails, agility trials, and physical conditioning milestones. Milestones consolidate annually into deep-memory scrolls.',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          height: 1.45,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Bar (Faint in Empty State)
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
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list, color: _stoneGrey.withValues(alpha: 0.4), size: 16),
                      const SizedBox(width: 6),
                      Text('Filter', style: TextStyle(color: _stoneGrey.withValues(alpha: 0.4), fontSize: 13)),
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
                      Icon(Icons.calendar_today_outlined, color: _stoneGrey.withValues(alpha: 0.4), size: 16),
                      const SizedBox(width: 6),
                      Text('Browse Years', style: TextStyle(color: _stoneGrey.withValues(alpha: 0.4), fontSize: 13)),
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
              const Text(
                'About Timeline Memories',
                style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text(
                'Timeline Memories automatically resurfaces significant past moments — like "One Year Ago Today", puppyhood foundations, major goal completions, and annual training milestones — so you can look back on your dog\'s progression over months and years.',
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

  void _openEventDetail(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
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
              const SizedBox(height: 16),
              const Text('ORIGINAL TIMELINE EVENT', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Logged for $_selectedDog • GPS verified', style: const TextStyle(color: _stoneGrey, fontSize: 12)),
              const SizedBox(height: 16),
              const Divider(color: Color(0x14FFFFFF)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TimelineScreen()),
                    );
                  },
                  child: const Text('View Full Timeline Record', style: TextStyle(color: _offWhite)),
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

/// Custom silhouette painter for the Mountain Hero card
class _MountainSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mountainPaint = Paint()
      ..color = const Color(0x4D1A252A)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.2, size.height * 0.35);
    path.lineTo(size.width * 0.45, size.height * 0.7);
    path.lineTo(size.width * 0.7, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, mountainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
