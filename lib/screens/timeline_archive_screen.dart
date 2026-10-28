import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_dashboard_screen.dart';
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

// Category Colors
const Color _catTraining = Color(0xFF5D8FAF); // Alpine Blue
const Color _catSC = Color(0xFFDD6B20); // Orange / S&C
const Color _catHealth = Color(0xFFE53E3E); // Red / Coral
const Color _catGoals = Color(0xFFECC94B); // Yellow

class ArchivedEventItem {
  final String id;
  final String category;
  final Color categoryColor;
  final String date;
  final DateTime dateTime;
  final String title;
  final String archivedDate;
  final IconData icon;
  final List<String>? photoUrls;
  final int? extraPhotoCount;
  final String? attachmentName;
  final String? attachmentSize;
  final bool isOrphaned;
  final String? orphanedWarning;
  bool isSelected;

  ArchivedEventItem({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.date,
    required this.dateTime,
    required this.title,
    required this.archivedDate,
    required this.icon,
    this.photoUrls,
    this.extraPhotoCount,
    this.attachmentName,
    this.attachmentSize,
    this.isOrphaned = false,
    this.orphanedWarning,
    this.isSelected = false,
  });
}

class TimelineArchiveScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineArchiveScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Koda',
  });

  @override
  State<TimelineArchiveScreen> createState() => _TimelineArchiveScreenState();
}

class _TimelineArchiveScreenState extends State<TimelineArchiveScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late String _selectedDog;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryFilter;
  String _sortOrder = 'Most Recent'; // 'Most Recent', 'Oldest First', 'Title A-Z', 'Category'

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  late List<ArchivedEventItem> _allArchivedEvents;

  // Sample canine avatars
  static const String _kodaAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD5a3uQvAZDqpVduQIwWPTfeXdnzvnZUAHhyLAu2f3BbeSL-M9SXOmi1QJAwn2Cde95uSh3xO6OAoEasiYE6MqnwVGZMQhX8E6_AulDrKbDOg-19Y2XY2WQvefPY7ecnzkudfXktfncSAUHbRYfdfW9pd8Lz7sFhaW0OujFgJOV6god8KDIDOx_bAseHiV5lHPP73kboSt3BIjv5MBYJawjarbxorlGSV-s67INL-aMnVJgDTIbiho';
  static const String _murphyAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAAcLbiDicBjYD6Lz8o3P1eq3ZYTW94TSp9IVpwMikl7LlGjta4VtqjreCYkJY_4ZasiFwWYpriHDdXkEO3jmS9xRmGbJzpWa1hBVZlUila8o9ns6mteZzpKnxJESTW2PrUoOe_m1EbJ-bkbq3xfw0Flgqraws3s-OoXC_8e7FcVgNo3lt14w4ZmLFnuxrQQVhkLcTqw7k4xaW1HYO4t2Oui7ynBnZ_2KVKm257yPnfcS_ZGbSQlJo';

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

    _initSampleData();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initSampleData() {
    _allArchivedEvents = [
      ArchivedEventItem(
        id: 'arch-1',
        category: 'Training',
        categoryColor: _catTraining,
        date: '24 Aug 2026',
        dateTime: DateTime(2026, 8, 24),
        title: 'Tracking — Field Exercise (Advanced)',
        archivedDate: '27 Aug 2026',
        icon: Icons.explore_outlined,
        isSelected: true,
        photoUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC9VGsaoANfm2IZNlGqpN8Mc2RyHfS8fUfmXZCQUrQKjRKfEwatK1QbGcFhcHvH5oob49sCCpvaye_jO965oaG1ECZYrJEd4HVLU-mNbKWxB_n25WznJDLroWUF3Qs-oRdMlet3nv8CWX0BXA_WTjMoKvtGs9i8-oiTAVPYnQ9_VGfZFs2S34hxAodqieHd0p9X_1baaSNavMC9kDE5V-P25r4uA82XwJuwLI18N6ipqtXduFVz_Cs',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA5FgWD2i1unJHuVMs7xYGIHfRAWlfmDzMl4UDozRaJ24GcMuGHNGrfykCZFVs2d9c12U4-fx_kZuu7QIoslWEiA6im1AkO_7BuTFH9etoeCbe69vPcInwmUlKrSnzozgbOF_Yf50UBt3sV1svztHGc3xGazeLrIuPnowR2kqJcPM1ycrN-MpwjuRdzXx8aqqjNNwtGGx60UhD-xSKwYsa0RWgZkJtKMlUpC3VlDRVifvpIVv6qCik',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC9VGsaoANfm2IZNlGqpN8Mc2RyHfS8fUfmXZCQUrQKjRKfEwatK1QbGcFhcHvH5oob49sCCpvaye_jO965oaG1ECZYrJEd4HVLU-mNbKWxB_n25WznJDLroWUF3Qs-oRdMlet3nv8CWX0BXA_WTjMoKvtGs9i8-oiTAVPYnQ9_VGfZFs2S34hxAodqieHd0p9X_1baaSNavMC9kDE5V-P25r4uA82XwJuwLI18N6ipqtXduFVz_Cs',
        ],
        extraPhotoCount: 1,
      ),
      ArchivedEventItem(
        id: 'arch-2',
        category: 'Health',
        categoryColor: _catHealth,
        date: '15 Jan 2026',
        dateTime: DateTime(2026, 1, 15),
        title: 'Annual Check-up — January 2026',
        archivedDate: '25 Aug 2026',
        icon: Icons.medical_services_outlined,
        isSelected: true,
        attachmentName: 'Vet_Report_Koda_2026.pdf',
        attachmentSize: '1.2 MB Document',
      ),
      ArchivedEventItem(
        id: 'arch-3',
        category: 'Training',
        categoryColor: _catTraining,
        date: '8 Jan 2026',
        dateTime: DateTime(2026, 1, 8),
        title: 'Obedience — Basic Commands Refresher',
        archivedDate: '12 Jan 2026',
        icon: Icons.sports_kabaddi_outlined,
        isSelected: true,
      ),
      ArchivedEventItem(
        id: 'arch-4',
        category: 'ORPHANED RECORD',
        categoryColor: _stoneGrey,
        date: '4 Sep 2023',
        dateTime: DateTime(2023, 9, 4),
        title: 'Early Puppy Training — First Week',
        archivedDate: '10 Sep 2023',
        icon: Icons.link_off,
        isOrphaned: true,
        orphanedWarning: 'Original record deleted — reference only',
        isSelected: false,
      ),
      ArchivedEventItem(
        id: 'arch-5',
        category: 'Goals',
        categoryColor: _catGoals,
        date: '12 Nov 2025',
        dateTime: DateTime(2025, 11, 12),
        title: '25 Tracking Sessions',
        archivedDate: '15 Nov 2025',
        icon: Icons.flag_outlined,
        isSelected: false,
      ),
      ArchivedEventItem(
        id: 'arch-6',
        category: 'S&C',
        categoryColor: _catSC,
        date: '2 Oct 2025',
        dateTime: DateTime(2025, 10, 2),
        title: 'Conditioning Block — Puppy Foundation',
        archivedDate: '5 Oct 2025',
        icon: Icons.bolt_outlined,
        isSelected: false,
      ),
    ];
  }

  List<ArchivedEventItem> get _filteredEvents {
    if (_isEmptyState) return [];

    List<ArchivedEventItem> list = List.from(_allArchivedEvents);

    // Category filter
    if (_selectedCategoryFilter != null) {
      list = list.where((e) => e.category == _selectedCategoryFilter).toList();
    }

    // Search query filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) =>
          e.title.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.date.toLowerCase().contains(q)).toList();
    }

    // Sorting
    if (_sortOrder == 'Most Recent') {
      list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (_sortOrder == 'Oldest First') {
      list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (_sortOrder == 'Title A-Z') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortOrder == 'Category') {
      list.sort((a, b) => a.category.compareTo(b.category));
    }

    return list;
  }

  int get _selectedCount => _allArchivedEvents.where((e) => e.isSelected).length;

  void _toggleSelection(ArchivedEventItem item) {
    setState(() {
      item.isSelected = !item.isSelected;
    });
  }

  void _selectAll(bool select) {
    setState(() {
      for (final item in _allArchivedEvents) {
        item.isSelected = select;
      }
    });
  }

  void _restoreSelectedEvents() {
    final selected = _allArchivedEvents.where((e) => e.isSelected).toList();
    if (selected.isEmpty) return;

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
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.restore, color: _mint, size: 40),
              const SizedBox(height: 14),
              Text(
                'Restore ${selected.length} Events?',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'These events will be returned to your active timeline for $_selectedDog.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _allArchivedEvents.removeWhere((e) => e.isSelected);
                          if (_allArchivedEvents.isEmpty) {
                            _isEmptyState = true;
                          }
                        });
                      },
                      child: const Text(
                        'Confirm Restore',
                        style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _restoreSingleEvent(ArchivedEventItem item) {
    setState(() {
      _allArchivedEvents.remove(item);
      if (_allArchivedEvents.isEmpty) {
        _isEmptyState = true;
      }
    });
  }

  void _removeReference(ArchivedEventItem item) {
    setState(() {
      _allArchivedEvents.remove(item);
      if (_allArchivedEvents.isEmpty) {
        _isEmptyState = true;
      }
    });
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
                'SORT ARCHIVED EVENTS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              _buildSortOption(ctx, 'Most Recent'),
              _buildSortOption(ctx, 'Oldest First'),
              _buildSortOption(ctx, 'Title A-Z'),
              _buildSortOption(ctx, 'Category'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext ctx, String label) {
    final bool isSelected = _sortOrder == label;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? _mint : _stoneGrey,
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? _offWhite : _stoneGrey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
      onTap: () {
        setState(() => _sortOrder = label);
        Navigator.pop(ctx);
      },
    );
  }

  void _showFilterSheet() {
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
                'FILTER ARCHIVE BY CATEGORY',
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
                  _buildFilterChip('All Categories', null, null),
                  _buildFilterChip('Training', 'Training', _catTraining),
                  _buildFilterChip('S&C', 'S&C', _catSC),
                  _buildFilterChip('Health', 'Health', _catHealth),
                  _buildFilterChip('Goals', 'Goals', _catGoals),
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
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Apply Filter', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? cat, Color? color) {
    final bool isSelected = _selectedCategoryFilter == cat;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryFilter = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _forest : const Color(0xFF242A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _mint : _cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
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

  void _showDogSelectorModal() {
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
                'SELECT CANINE PROFILE',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              _buildDogOption(ctx, 'Koda', 'Border Collie, 3 Years • Handler: Erik Voss', _kodaAvatar),
              _buildDogOption(ctx, 'Murphy', 'Belgian Malinois, 4 Years • Handler: Erik Voss', _murphyAvatar),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDogOption(BuildContext ctx, String name, String subtitle, String avatarUrl) {
    final bool isSelected = _selectedDog == name;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(name, style: const TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check, color: _mint) : null,
      onTap: () {
        setState(() => _selectedDog = name);
        Navigator.pop(ctx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isEmptyState
            ? _buildEmptyState()
            : _buildPopulatedState(events),
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
        'Timeline Archive',
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
              if (!_isEmptyState && _allArchivedEvents.isEmpty) {
                _initSampleData();
              }
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
              setState(() => _isEmptyState = !_isEmptyState);
            } else if (val == 'select_all') {
              _selectAll(true);
            } else if (val == 'deselect_all') {
              _selectAll(false);
            } else if (val == 'dog') {
              _showDogSelectorModal();
            } else if (val == 'favourites') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineFavouritesScreen()),
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
            } else if (val == 'insights') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelineInsightsScreen()),
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
            const PopupMenuItem(
              value: 'select_all',
              child: Row(
                children: [
                  Icon(Icons.select_all, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Select All Events', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'deselect_all',
              child: Row(
                children: [
                  Icon(Icons.deselect, color: _stoneGrey, size: 18),
                  SizedBox(width: 10),
                  Text('Deselect All', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'dog',
              child: Row(
                children: [
                  Icon(Icons.pets, color: _mint, size: 18),
                  SizedBox(width: 10),
                  Text('Switch Canine', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
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
                        Icons.archive_outlined,
                        size: 44,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'No Archived Events',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Archived Timeline events will appear here. Archive events from your Timeline to keep your active feed focused.',
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
                          Icon(Icons.arrow_back, color: _offWhite, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Return to Timeline',
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
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEmptyState = false;
                        _initSampleData();
                      });
                    },
                    child: const Text(
                      'Load Sample Archive Data',
                      style: TextStyle(color: _mint, fontSize: 13),
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
                child: InkWell(
                  onTap: _showFilterSheet,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list, color: _stoneGrey, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'FILTER',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: const Color(0x26FFFFFF)),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() => _isEmptyState = false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: _stoneGrey, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'SEARCH',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopulatedState(List<ArchivedEventItem> events) {
    final selectedCount = _selectedCount;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. Canine Header Profile
        _buildCanineProfileHeader(),
        const SizedBox(height: 16),

        // 2. TIMELINE ARCHIVE SUMMARY Card
        _buildArchiveSummaryCard(),
        const SizedBox(height: 16),

        // 3. Search Bar
        _buildSearchBar(),
        const SizedBox(height: 16),

        // 4. ARCHIVED EVENTS Header & Actions Row
        _buildArchiveHeaderRow(events.length),
        const SizedBox(height: 12),

        // 5. Action Control Bar (Deselect All, Export, Restore)
        _buildActionControlBar(),
        const SizedBox(height: 14),

        // 6. MULTI-SELECT MODE Bar
        _buildMultiSelectBar(selectedCount),
        const SizedBox(height: 14),

        // 7. Event Cards
        if (events.isEmpty)
          _buildNoSearchResults()
        else
          ...events.map((e) => _buildArchivedEventCard(e)),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCanineProfileHeader() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _showDogSelectorModal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                _selectedDog == 'Murphy' ? _murphyAvatar : _kodaAvatar,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDog,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _selectedDog == 'Murphy'
                        ? 'Belgian Malinois, 4 Years • Handler: Erik Voss'
                        : 'Border Collie, 3 Years • Handler: Erik Voss',
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.swap_horiz, color: _mint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildArchiveSummaryCard() {
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
          const Text(
            'TIMELINE ARCHIVE SUMMARY',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 14),

          // 3-columns
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '23',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ARCHIVED\nEVENTS',
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
                      '18.4',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'MB STORAGE\nUSED',
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
                        '3 Days Ago',
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
                      'LAST\nARCHIVED',
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

          // Bottom category breakdown taking full width
          Row(
            children: [
              const Text(
                'INCLUDES\nDATA FOR',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDotCategory('Training', _catTraining),
                    _buildDotCategory('S&C', _catSC),
                    _buildDotCategory('Health', _catHealth),
                    _buildDotCategory('Goals', _catGoals),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDotCategory(String label, Color color) {
    final bool isSelected = _selectedCategoryFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryFilter = _selectedCategoryFilter == label ? null : label;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSelected ? 10 : 7,
            height: isSelected ? 10 : 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _offWhite : _stoneGrey,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _offWhite, fontSize: 14),
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
          hintText: 'Search archive...',
          hintStyle: const TextStyle(color: _stoneGrey, fontSize: 14),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : const Icon(Icons.mic_none, color: _stoneGrey, size: 20),
        ),
      ),
    );
  }

  Widget _buildArchiveHeaderRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'ARCHIVED EVENTS',
              style: TextStyle(
                color: _offWhite,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF242A2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showSortModal,
          child: Row(
            children: [
              Text(
                _sortOrder,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: _stoneGrey, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionControlBar() {
    final bool allSelected = _allArchivedEvents.isNotEmpty &&
        _allArchivedEvents.every((e) => e.isSelected);

    return Row(
      children: [
        // Deselect / Select All
        InkWell(
          onTap: () => _selectAll(!allSelected),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text(
              allSelected ? 'Deselect All' : 'Select All',
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const Spacer(),

        // Export Button
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimelineExportScreen()),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              children: [
                Icon(Icons.file_download_outlined, color: _offWhite, size: 16),
                SizedBox(width: 4),
                Text(
                  'Export',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Restore Pill Button
        GestureDetector(
          onTap: _restoreSelectedEvents,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: _forest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.restore, color: _mint, size: 15),
                SizedBox(width: 6),
                Text(
                  'Restore',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectBar(int selectedCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF242A2E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'MULTI-SELECT MODE',
              style: TextStyle(
                color: _mint,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            '$selectedCount Selected',
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchivedEventCard(ArchivedEventItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected ? _mint.withValues(alpha: 0.4) : _cardBorder,
          width: item.isSelected ? 1.2 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleSelection(item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular leading icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.categoryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: item.categoryColor, size: 18),
                    ),
                    const SizedBox(width: 12),

                    // Title & Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.category} • ${item.date}',
                            style: TextStyle(
                              color: item.isOrphaned ? _stoneGrey : item.categoryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.title,
                            style: TextStyle(
                              color: item.isOrphaned ? _stoneGrey : _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.archive_outlined, color: _stoneGrey, size: 13),
                              const SizedBox(width: 4),
                              Text(
                                'Archived ${item.archivedDate}',
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Checkbox
                    GestureDetector(
                      onTap: () => _toggleSelection(item),
                      child: Icon(
                        item.isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: item.isSelected ? _mint : _stoneGrey,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                // Photo Thumbnails Strip
                if (item.photoUrls != null && item.photoUrls!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ...item.photoUrls!.map((url) => Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                      if (item.extraPhotoCount != null && item.extraPhotoCount! > 0)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF242A2E),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Center(
                            child: Text(
                              '+${item.extraPhotoCount}',
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],

                // Attachment Document Box
                if (item.attachmentName != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131618),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description_outlined, color: _mint, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.attachmentName!,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.attachmentSize!,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Orphaned Record Warning & Link
                if (item.isOrphaned) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131618),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: _stoneGrey, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              item.orphanedWarning!,
                              style: const TextStyle(color: _stoneGrey, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _removeReference(item),
                          child: const Text(
                            'Remove Reference',
                            style: TextStyle(
                              color: Color(0xFFE53E3E),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Bottom Single Restore button for unselected items
                if (!item.isSelected && !item.isOrphaned) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _restoreSingleEvent(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF242A2E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.restore, color: _mint, size: 13),
                              SizedBox(width: 4),
                              Text(
                                'Restore',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 48, color: _stoneGrey),
            const SizedBox(height: 12),
            const Text(
              'No matches found',
              style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'No archived items match "$_searchQuery"',
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategoryFilter = null;
                });
              },
              child: const Text('Reset Search & Filters', style: TextStyle(color: _mint)),
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
