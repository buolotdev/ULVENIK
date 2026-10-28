import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);
const Color _orange = Color(0xFFDD6B20);
const Color _blue = Color(0xFF5D8FAF);

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedScope = 'All';

  final List<String> _recentSearches = [
    'Trail Agility',
    'NexGard Chewable',
    'Koda Heart Rate',
    'Bite Phase C',
  ];

  final List<Map<String, dynamic>> _allDatabaseItems = [
    {
      'title': 'Koda',
      'subtitle': 'Belgian Malinois • 3 yrs • IGP III & S&R',
      'scope': 'Dogs',
      'icon': Icons.pets,
      'color': _mint,
    },
    {
      'title': 'Murphy',
      'subtitle': 'German Shepherd • 18 mos • Tracking Foundation',
      'scope': 'Dogs',
      'icon': Icons.pets,
      'color': _mint,
    },
    {
      'title': 'Riverside Trail Scent & Contour Run',
      'subtitle': 'Timeline • Oct 28 • 8.4 km • 142 bpm avg',
      'scope': 'Timeline',
      'icon': Icons.timeline,
      'color': _blue,
    },
    {
      'title': 'Weave Pole High-Drive Footwork Drill',
      'subtitle': 'Drills & S&C • 6 reps • 18.2s best time',
      'scope': 'Drills',
      'icon': Icons.fitness_center,
      'color': _gold,
    },
    {
      'title': 'Protection Phase C: Escape Bite & Hold',
      'subtitle': 'Drills • Decoy: Marcus Vance • Full Grip',
      'scope': 'Drills',
      'icon': Icons.sports_kabaddi,
      'color': _gold,
    },
    {
      'title': 'NexGard Spectra Preventative Chewable',
      'subtitle': 'Health Logs • Next due Nov 28, 2026',
      'scope': 'Health Logs',
      'icon': Icons.medication_outlined,
      'color': _orange,
    },
    {
      'title': 'Annual Rabies Antibody Titer Test',
      'subtitle': 'Health Logs • 2.4 IU/mL • Immunity Confirmed',
      'scope': 'Health Logs',
      'icon': Icons.vaccines_outlined,
      'color': _orange,
    },
    {
      'title': 'Alpine Ridge Session Footage (4K 60fps)',
      'subtitle': 'Media • 480 MB • Scent Trail Cam 01',
      'scope': 'Media',
      'icon': Icons.videocam_outlined,
      'color': _mint,
    },
  ];

  List<Map<String, dynamic>> get _results {
    if (_query.trim().isEmpty) return [];

    return _allDatabaseItems.where((item) {
      final matchesScope = _selectedScope == 'All' || item['scope'] == _selectedScope;
      final matchesQuery = item['title'].toLowerCase().contains(_query.toLowerCase()) ||
          item['subtitle'].toLowerCase().contains(_query.toLowerCase());
      return matchesScope && matchesQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final isSearching = _query.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Global Search',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. SEARCH INPUT
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search dogs, drills, medical, GPS & media...',
                hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: _mint, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: _stoneGrey, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
          ),
          const SizedBox(height: 14),

          // 2. SCOPE FILTER PILLS
          _buildScopePills(),
          const SizedBox(height: 18),

          // 3. SEARCH RESULTS OR RECENT SEARCHES
          if (!isSearching) ...[
            _buildSectionHeader('RECENT SEARCHES'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((term) {
                return ActionChip(
                  label: Text(term, style: const TextStyle(color: _offWhite, fontSize: 12)),
                  backgroundColor: _carbon,
                  side: const BorderSide(color: _cardBorder),
                  avatar: const Icon(Icons.history, color: _mint, size: 16),
                  onPressed: () {
                    _searchController.text = term;
                    setState(() => _query = term);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('POPULAR HANDLER TAGS'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['#Agility', '#Conditioning', '#NexGard', '#BiteWork', '#HRV', '#GPS'].map((tag) {
                return ActionChip(
                  label: Text(tag, style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600)),
                  backgroundColor: _forest.withValues(alpha: 0.2),
                  side: BorderSide(color: _mint.withValues(alpha: 0.3)),
                  onPressed: () {
                    _searchController.text = tag.replaceAll('#', '');
                    setState(() => _query = tag.replaceAll('#', ''));
                  },
                );
              }).toList(),
            ),
          ] else ...[
            _buildSectionHeader('RESULTS (${results.length})'),
            const SizedBox(height: 10),
            if (results.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off, color: _stoneGrey, size: 36),
                    SizedBox(height: 10),
                    Text('No matching records found', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Try broadening your search term or changing the category filter.', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  ],
                ),
              )
            else
              ...results.map((item) => _buildResultTile(item)),
          ],

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildScopePills() {
    final scopes = ['All', 'Dogs', 'Drills', 'Health Logs', 'Timeline', 'Media'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: scopes.map((s) {
          final isSelected = _selectedScope == s;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedScope = s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? _mint : _cardBorder),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultTile(Map<String, dynamic> item) {
    final Color color = item['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item['icon'], color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['scope'],
                        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item['subtitle'],
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
        ],
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
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
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
