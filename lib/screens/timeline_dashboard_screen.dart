import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'record_session_screen.dart';
import 'weight_tracker_screen.dart';
import 'strength_conditioning_dashboard_screen.dart';
import 'timeline_event_details_screen.dart';
import 'timeline_filters_screen.dart';
import 'timeline_search_screen.dart';
import 'timeline_calendar_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';

/// Timeline Event Model for Timeline Dashboard
enum DashboardCategory { training, health, sc, goal, media }

class DashboardEventItem {
  final String id;
  final String title;
  final String timeLabel;
  final String dateGroup; // 'TODAY', 'YESTERDAY', 'MONDAY 18 AUG'
  final DashboardCategory category;
  final IconData icon;
  final Color categoryColor;
  final String categoryLabel;
  final String? location;
  final String? subtitle;
  final String? statusBadge;
  final bool hasStar;
  final String? photoUrl;

  const DashboardEventItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.dateGroup,
    required this.category,
    required this.icon,
    required this.categoryColor,
    required this.categoryLabel,
    this.location,
    this.subtitle,
    this.statusBadge,
    this.hasStar = false,
    this.photoUrl,
  });
}

/// Timeline Dashboard Screen (Batch 6 - Lines 172 & 173)
/// Supports both Populated State (Figma Image 1) and Empty State (Figma Image 2)
class TimelineDashboardScreen extends StatefulWidget {
  final bool initialEmpty;
  final String initialDog;

  const TimelineDashboardScreen({
    super.key,
    this.initialEmpty = false,
    this.initialDog = 'Atlas',
  });

  @override
  State<TimelineDashboardScreen> createState() =>
      _TimelineDashboardScreenState();
}

class _TimelineDashboardScreenState extends State<TimelineDashboardScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _surfaceVariant = Color(0xFF323533);
  static const Color _surfaceContainer = Color(0xFF1D201F);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _error = Color(0xFFFFB4AB);
  static const Color _tertiary = Color(0xFFFFB4AC);
  static const Color _secondary = Color(0xFFB6CCB5);

  // ─── Image Assets ──────────────────────────────────────────────────────────
  static const String _atlasAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCZXnrASjVdkjrub-V3MolnXsShGW3LdPz9Uprz347UzeA1aItL__BKEKaRXR3FYsk-qO8dmUvRBdoaGAR22wVjkUy6d6iBKuRHfvgg3Npz-IgdLIpm5eoph8I0FgPpTftR4jTW4SrZlD29MLK4LrjZdTZpUNBkEck84fdZpmdqsFP4i4lDkYNy6XFerF8hwK2X2fYfRrKUZWI2VRozG1u650h1X9M4z52n0gUU5Ynks1j01m_jQWw';

  static const String _dogCardAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCf2gWY9JxtkURkm0aW9PMdijBje6fhA4-oC68MCLJZyz8t7SaprwJ0N5EoOkmn6czwL_pcPp4cmkN7DPb-z7dsctasqNNcowjdwWGFPqxKd8aL5Tn_b0GXh-ZIck9LXZ09-l0P_1UZ_QhDb_BzjkfsEc0tV7FZwazPjD2tx6uoEr0tzSD1Zb9vBxmaC4G1_WD1s2d5FZCFNSvwzC2gNkXOHTMYTXycYQTFO3IqPKvcs-9D-ZR0GZI';

  static const String _agilityPhotoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAMfj32SNwRKCBsOeBz-RO2mqg-bQbocK9tbF4ZXyZajrofeN4TC6LhkIIsYi-mlg26NjXwLbeoFoRGepPW_8dlyG2v91FCfh8Ig2enAT5CRzTRjoeaEBrGalmozcExgyRqrU2abFKI6n5OX6Kodmm5nCUeCkyeIyyBINn1E55QGgU4nHqMLjh1eIo9MliJTflotG-oZ-xMEncQf0iZiNv10ADDtO0SqNT2ktgidgMtSaa-IUk1MDw';

  // ─── State Variables ────────────────────────────────────────────────────────
  late bool _isEmptyState;
  late String _selectedDog;
  String _selectedMetric = 'DURATION'; // 'DURATION', 'DISTANCE', 'EVENTS'
  int _selectedStatIndex = 0; // 0..5
  String _selectedFilter = 'All'; // 'All', 'Training', 'Health', 'S&C', 'Media', 'Goal'
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _isSearchActive = false;
  bool _showAnimatedGraph = true;

  // Granular Filter Bottom Sheet state
  Set<DashboardCategory> _activeCategories = {
    DashboardCategory.training,
    DashboardCategory.health,
    DashboardCategory.sc,
    DashboardCategory.goal,
    DashboardCategory.media,
  };
  String _dateRangeFilter = 'All Time';
  bool _mediaOnlyFilter = false;

  bool get _hasCustomFilters =>
      _activeCategories.length < 5 ||
      _dateRangeFilter != 'All Time' ||
      _mediaOnlyFilter ||
      _selectedFilter != 'All';

  // Chart Animation
  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;

  // Raw Event Data
  late List<DashboardEventItem> _allEvents;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _selectedDog = widget.initialDog;

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartAnim = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    _initSampleEvents();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initSampleEvents() {
    _allEvents = [
      // TODAY
      const DashboardEventItem(
        id: 'ev-dash-1',
        title: 'Obedience — Heel Work & Recall',
        timeLabel: '02:30 PM',
        dateGroup: 'TODAY',
        category: DashboardCategory.training,
        icon: Icons.fitness_center,
        categoryColor: _alpineBlue,
        categoryLabel: 'TRAINING',
        location: 'Riverside Park',
        subtitle: '3 Skills · 7 Exercises · 45 min',
        statusBadge: 'COMPLETED',
      ),
      const DashboardEventItem(
        id: 'ev-dash-2',
        title: 'Weight Recorded — 28.4 kg',
        timeLabel: '08:15 AM',
        dateGroup: 'TODAY',
        category: DashboardCategory.health,
        icon: Icons.scale,
        categoryColor: _error,
        categoryLabel: 'HEALTH',
        subtitle: 'Consistent morning weigh-in · Target: 28.5 kg',
      ),

      // YESTERDAY
      const DashboardEventItem(
        id: 'ev-dash-3',
        title: 'Off-Leash Recall — Goal Achieved',
        timeLabel: '05:45 PM',
        dateGroup: 'YESTERDAY',
        category: DashboardCategory.goal,
        icon: Icons.emoji_events,
        categoryColor: _mint,
        categoryLabel: 'GOAL',
        subtitle: '10 consecutive recall reps in high distraction park environment',
        hasStar: true,
      ),
      const DashboardEventItem(
        id: 'ev-dash-4',
        title: 'Sprint Drills',
        timeLabel: '11:00 AM',
        dateGroup: 'YESTERDAY',
        category: DashboardCategory.sc,
        icon: Icons.local_fire_department,
        categoryColor: _tertiary,
        categoryLabel: 'S&C',
        subtitle: '6 x 50m intervals · High sprint velocity · Heart rate: 168 bpm',
      ),
      const DashboardEventItem(
        id: 'ev-dash-5',
        title: 'Vet Visit',
        timeLabel: '09:30 AM',
        dateGroup: 'YESTERDAY',
        category: DashboardCategory.health,
        icon: Icons.medical_services,
        categoryColor: _error,
        categoryLabel: 'HEALTH',
        subtitle: 'Dr. Hansen · Annual orthopedic check · Clear joints & hips',
      ),

      // MONDAY 18 AUG
      const DashboardEventItem(
        id: 'ev-dash-6',
        title: 'Morning Agility Session',
        timeLabel: '10:15 AM',
        dateGroup: 'MONDAY 18 AUG',
        category: DashboardCategory.media,
        icon: Icons.photo_camera,
        categoryColor: _secondary,
        categoryLabel: 'MEDIA',
        subtitle: '3 Photos added',
        photoUrl: _agilityPhotoUrl,
      ),
      const DashboardEventItem(
        id: 'ev-dash-7',
        title: 'Bite Work & Engagement',
        timeLabel: '08:00 AM',
        dateGroup: 'MONDAY 18 AUG',
        category: DashboardCategory.training,
        icon: Icons.sports_score,
        categoryColor: _alpineBlue,
        categoryLabel: 'TRAINING',
        subtitle: 'Helper: Marcus · High drive control & release discipline',
        location: 'K9 Training Grounds',
        statusBadge: 'COMPLETED',
      ),
    ];
  }

  // Filtered Events
  List<DashboardEventItem> get _filteredEvents {
    if (_isEmptyState) return [];

    return _allEvents.where((e) {
      // Category filter check
      if (!_activeCategories.contains(e.category)) {
        return false;
      }
      // Date range filter
      if (_dateRangeFilter == 'Today' && e.dateGroup != 'TODAY') {
        return false;
      }
      if (_dateRangeFilter == 'Yesterday' && e.dateGroup != 'YESTERDAY') {
        return false;
      }
      if (_dateRangeFilter == 'This Week' && e.dateGroup == 'MONDAY 18 AUG') {
        return false;
      }
      // Media filter
      if (_mediaOnlyFilter && e.photoUrl == null && e.category != DashboardCategory.media) {
        return false;
      }
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = e.title.toLowerCase().contains(q);
        final matchesCat = e.categoryLabel.toLowerCase().contains(q);
        final matchesLoc = e.location?.toLowerCase().contains(q) ?? false;
        final matchesSub = e.subtitle?.toLowerCase().contains(q) ?? false;
        if (!matchesTitle && !matchesCat && !matchesLoc && !matchesSub) return false;
      }
      return true;
    }).toList();
  }

  void _selectQuickFilter(String f) {
    setState(() {
      _selectedFilter = f;
      if (f == 'All') {
        _activeCategories = {
          DashboardCategory.training,
          DashboardCategory.health,
          DashboardCategory.sc,
          DashboardCategory.goal,
          DashboardCategory.media,
        };
        _mediaOnlyFilter = false;
        _dateRangeFilter = 'All Time';
      } else if (f == 'Training') {
        _activeCategories = {DashboardCategory.training};
      } else if (f == 'Health') {
        _activeCategories = {DashboardCategory.health};
      } else if (f == 'S&C') {
        _activeCategories = {DashboardCategory.sc};
      } else if (f == 'Media') {
        _activeCategories = {DashboardCategory.media};
      } else if (f == 'Goal') {
        _activeCategories = {DashboardCategory.goal};
      }
    });
  }

  void _selectDog(String dog) {
    setState(() {
      _selectedDog = dog;
      if (dog == 'Nova') {
        _isEmptyState = true;
      } else {
        _isEmptyState = false;
      }
    });
  }

  void _toggleState() {
    setState(() {
      _isEmptyState = !_isEmptyState;
      if (_isEmptyState) {
        _selectedDog = 'Nova';
      } else {
        _selectedDog = 'Atlas';
      }
    });
  }

  // ─── Modal Interactions ────────────────────────────────────────────────────

  Future<void> _openTimelineFiltersScreen() async {
    final result = await Navigator.push<TimelineFilterResult>(
      context,
      MaterialPageRoute(
        builder: (_) => TimelineFiltersScreen(
          initialCategories: _activeCategories.map((c) {
            if (c == DashboardCategory.sc) return 'S&C';
            if (c == DashboardCategory.goal) return 'Goals';
            if (c == DashboardCategory.media) return 'Media';
            if (c == DashboardCategory.health) return 'Health';
            return 'Training';
          }).toSet(),
          initialDateRange: _dateRangeFilter,
          initialDog: _selectedDog,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (result.categories.isEmpty) {
          _activeCategories = Set.from(DashboardCategory.values);
        } else {
          _activeCategories = result.categories.map((c) {
            if (c == 'S&C') return DashboardCategory.sc;
            if (c == 'Goals') return DashboardCategory.goal;
            if (c == 'Media') return DashboardCategory.media;
            if (c == 'Health') return DashboardCategory.health;
            return DashboardCategory.training;
          }).toSet();
        }
        _dateRangeFilter = result.dateRange;
      });
    }
  }

  void _showFilterBottomSheet() {
    Set<DashboardCategory> tempCategories = Set.from(_activeCategories);
    String tempDateRange = _dateRangeFilter;
    bool tempMediaOnly = _mediaOnlyFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final matchCount = _allEvents.where((e) {
            if (!tempCategories.contains(e.category)) return false;
            if (tempDateRange == 'Today' && e.dateGroup != 'TODAY') return false;
            if (tempDateRange == 'Yesterday' && e.dateGroup != 'YESTERDAY') return false;
            if (tempDateRange == 'This Week' && e.dateGroup == 'MONDAY 18 AUG') return false;
            if (tempMediaOnly && e.photoUrl == null && e.category != DashboardCategory.media) {
              return false;
            }
            return true;
          }).length;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
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
                          'TIMELINE FILTERS',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempCategories = {
                                DashboardCategory.training,
                                DashboardCategory.health,
                                DashboardCategory.sc,
                                DashboardCategory.goal,
                                DashboardCategory.media,
                              };
                              tempDateRange = 'All Time';
                              tempMediaOnly = false;
                            });
                          },
                          child: const Text('Reset All',
                              style: TextStyle(color: _mint, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Categories
                    const Text('EVENT CATEGORIES',
                        style: TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterOptionChip(
                          label: 'Training',
                          icon: Icons.fitness_center,
                          color: _alpineBlue,
                          isSelected: tempCategories.contains(DashboardCategory.training),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories.contains(DashboardCategory.training)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(DashboardCategory.training);
                                }
                              } else {
                                tempCategories.add(DashboardCategory.training);
                              }
                            });
                          },
                        ),
                        _buildFilterOptionChip(
                          label: 'Health',
                          icon: Icons.scale,
                          color: _error,
                          isSelected: tempCategories.contains(DashboardCategory.health),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories.contains(DashboardCategory.health)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(DashboardCategory.health);
                                }
                              } else {
                                tempCategories.add(DashboardCategory.health);
                              }
                            });
                          },
                        ),
                        _buildFilterOptionChip(
                          label: 'S&C',
                          icon: Icons.local_fire_department,
                          color: _tertiary,
                          isSelected: tempCategories.contains(DashboardCategory.sc),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories.contains(DashboardCategory.sc)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(DashboardCategory.sc);
                                }
                              } else {
                                tempCategories.add(DashboardCategory.sc);
                              }
                            });
                          },
                        ),
                        _buildFilterOptionChip(
                          label: 'Goal',
                          icon: Icons.emoji_events,
                          color: _mint,
                          isSelected: tempCategories.contains(DashboardCategory.goal),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories.contains(DashboardCategory.goal)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(DashboardCategory.goal);
                                }
                              } else {
                                tempCategories.add(DashboardCategory.goal);
                              }
                            });
                          },
                        ),
                        _buildFilterOptionChip(
                          label: 'Media',
                          icon: Icons.photo_camera,
                          color: _secondary,
                          isSelected: tempCategories.contains(DashboardCategory.media),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories.contains(DashboardCategory.media)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(DashboardCategory.media);
                                }
                              } else {
                                tempCategories.add(DashboardCategory.media);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date Period
                    const Text('DATE PERIOD',
                        style: TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['All Time', 'Today', 'Yesterday', 'This Week'].map((d) {
                        final isSel = tempDateRange == d;
                        return ChoiceChip(
                          label: Text(d),
                          selected: isSel,
                          selectedColor: _forest,
                          backgroundColor: _surfaceContainer,
                          labelStyle: TextStyle(
                              color: isSel ? const Color(0xFFAAE9D0) : _stoneGrey,
                              fontSize: 12),
                          side: BorderSide(
                              color: isSel ? Colors.transparent : const Color(0x24FFFFFF)),
                          onSelected: (_) {
                            setModalState(() => tempDateRange = d);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Media Only Checkbox
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setModalState(() => tempMediaOnly = !tempMediaOnly);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.photo_outlined, color: _mint, size: 18),
                                SizedBox(width: 8),
                                Text('With Photos or Attachments Only',
                                    style: TextStyle(color: _offWhite, fontSize: 13)),
                              ],
                            ),
                            Checkbox(
                              value: tempMediaOnly,
                              activeColor: _mint,
                              checkColor: _obsidian,
                              onChanged: (val) {
                                setModalState(() => tempMediaOnly = val ?? false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() {
                            _activeCategories = tempCategories;
                            _dateRangeFilter = tempDateRange;
                            _mediaOnlyFilter = tempMediaOnly;
                            if (_activeCategories.length == 5) {
                              _selectedFilter = 'All';
                            } else if (_activeCategories.length == 1) {
                              final single = _activeCategories.first;
                              _selectedFilter = switch (single) {
                                DashboardCategory.training => 'Training',
                                DashboardCategory.health => 'Health',
                                DashboardCategory.sc => 'S&C',
                                DashboardCategory.goal => 'Goal',
                                DashboardCategory.media => 'Media',
                              };
                            } else {
                              _selectedFilter = 'Filtered (${_activeCategories.length})';
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'Apply Filters ($matchCount Events)',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
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

  Widget _buildFilterOptionChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _forest : _surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _mint : const Color(0x24FFFFFF),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFAAE9D0) : color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFAAE9D0) : _offWhite,
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'SELECT DOG TIMELINE DASHBOARD',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundImage: const NetworkImage(_atlasAvatarUrl),
                ),
                title: const Text('Atlas',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                subtitle: const Text('Belgian Malinois · 3 yrs (847 Events — Populated State)',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: _selectedDog == 'Atlas'
                    ? const Icon(Icons.check, color: _mint, size: 20)
                    : null,
                onTap: () {
                  _selectDog('Atlas');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: _forest,
                  child: const Text('N',
                      style: TextStyle(
                          color: _mint, fontWeight: FontWeight.w700)),
                ),
                title: const Text('Nova',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                subtitle: const Text('German Shepherd Puppy · 6 mos (0 Events — Empty State)',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: _selectedDog == 'Nova'
                    ? const Icon(Icons.check, color: _mint, size: 20)
                    : null,
                onTap: () {
                  _selectDog('Nova');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetailSheet(DashboardEventItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.categoryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, color: item.categoryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.categoryLabel,
                        style: TextStyle(
                          color: item.categoryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.timeLabel,
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (item.location != null) ...[
              Row(
                children: [
                  const Icon(Icons.location_on, color: _stoneGrey, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    item.location!,
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            if (item.subtitle != null) ...[
              Text(
                item.subtitle!,
                style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
            ],
            if (item.photoUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.photoUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _offWhite,
                        side: const BorderSide(color: Color(0x24FFFFFF)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        final isHealth = item.categoryLabel.toLowerCase().contains('health') ||
                            item.categoryLabel.toLowerCase().contains('vet');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TimelineEventDetailsScreen(
                              initialVariant: isHealth
                                  ? TimelineEventVariant.health
                                  : TimelineEventVariant.training,
                              eventId: item.id,
                              initialTitle: item.title,
                              initialDog: 'Atlas',
                            ),
                          ),
                        );
                      },
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'View Event Details',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
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

  void _showQuickAddModal() {
    final TextEditingController customTitleCtrl = TextEditingController();
    DashboardCategory selectedCat = DashboardCategory.training;

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(modalCtx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
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
                        'QUICK RECORD EVENT',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: _stoneGrey, size: 20),
                        onPressed: () => Navigator.pop(modalCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Option 1: Training Session -> RecordSessionScreen
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _alpineBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fitness_center, color: _alpineBlue),
                    ),
                    title: const Text('Training Session',
                        style: TextStyle(
                            color: _offWhite, fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: const Text('Launch interactive session recorder with skills & drills',
                        style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: _alpineBlue, size: 14),
                    onTap: () {
                      Navigator.pop(modalCtx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecordSessionScreen(
                            initialCategory: 'Training',
                            initialActivityName: 'Obedience Drills',
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Option 2: Health & Weight Record -> WeightTrackerScreen
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _error.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.scale, color: _error),
                    ),
                    title: const Text('Health & Weight Record',
                        style: TextStyle(
                            color: _offWhite, fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: const Text('Open Weight & Body Condition Tracker dashboard',
                        style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: _error, size: 14),
                    onTap: () {
                      Navigator.pop(modalCtx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WeightTrackerScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Option 3: Strength & Conditioning -> StrengthConditioningDashboardScreen
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _tertiary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_fire_department, color: _tertiary),
                    ),
                    title: const Text('Strength & Conditioning',
                        style: TextStyle(
                            color: _offWhite, fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: const Text('Resistance, treadmill, sprint intervals & recovery hub',
                        style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: _tertiary, size: 14),
                    onTap: () {
                      Navigator.pop(modalCtx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StrengthConditioningDashboardScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 24),

                  // Direct Inline Quick Event Logger
                  const Text(
                    'OR LOG DIRECTLY TO THIS TIMELINE',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x24FFFFFF)),
                    ),
                    child: TextField(
                      controller: customTitleCtrl,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 13,
                        decoration: TextDecoration.none,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter custom event title...',
                        hintStyle: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                          decoration: TextDecoration.none,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Category Selector Chips
                  Wrap(
                    spacing: 6,
                    children: [
                      DashboardCategory.training,
                      DashboardCategory.health,
                      DashboardCategory.sc,
                      DashboardCategory.goal,
                      DashboardCategory.media,
                    ].map((cat) {
                      final isSel = selectedCat == cat;
                      final label = switch (cat) {
                        DashboardCategory.training => 'Training',
                        DashboardCategory.health => 'Health',
                        DashboardCategory.sc => 'S&C',
                        DashboardCategory.goal => 'Goal',
                        DashboardCategory.media => 'Media',
                      };
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSel,
                        selectedColor: _forest,
                        backgroundColor: _surfaceContainer,
                        labelStyle: TextStyle(
                          color: isSel ? const Color(0xFFAAE9D0) : _stoneGrey,
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                        ),
                        side: BorderSide(
                          color: isSel ? Colors.transparent : const Color(0x24FFFFFF),
                        ),
                        onSelected: (_) => setModalState(() => selectedCat = cat),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Event to Feed',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      onPressed: () {
                        final title = customTitleCtrl.text.trim().isEmpty
                            ? 'Logged ${selectedCat.name.toUpperCase()} Activity'
                            : customTitleCtrl.text.trim();

                        final (icon, color, label) = switch (selectedCat) {
                          DashboardCategory.training => (Icons.fitness_center, _alpineBlue, 'TRAINING'),
                          DashboardCategory.health => (Icons.scale, _error, 'HEALTH'),
                          DashboardCategory.sc => (Icons.local_fire_department, _tertiary, 'S&C'),
                          DashboardCategory.goal => (Icons.emoji_events, _mint, 'GOAL'),
                          DashboardCategory.media => (Icons.photo_camera, _secondary, 'MEDIA'),
                        };

                        setState(() {
                          _allEvents.insert(
                            0,
                            DashboardEventItem(
                              id: 'ev-dash-custom-${DateTime.now().millisecondsSinceEpoch}',
                              title: title,
                              timeLabel: 'Just now',
                              dateGroup: 'TODAY',
                              category: selectedCat,
                              icon: icon,
                              categoryColor: color,
                              categoryLabel: label,
                              subtitle: 'Recorded via Timeline Dashboard Quick Logger',
                              statusBadge: selectedCat == DashboardCategory.training ? 'COMPLETED' : null,
                            ),
                          );
                          _isEmptyState = false;
                        });

                        Navigator.pop(modalCtx);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Build Method ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildTopAppBar(),
      body: _isEmptyState
          ? _buildEmptyStateContent()
          : _buildPopulatedStateContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickAddModal,
        backgroundColor: _mint,
        foregroundColor: const Color(0xFF002117),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Top App Bar ───────────────────────────────────────────────────────────

  PreferredSizeWidget _buildTopAppBar() {
    if (_isSearchActive) {
      return AppBar(
        backgroundColor: _carbon,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          onPressed: () {
            setState(() {
              _isSearchActive = false;
              _searchQuery = '';
              _searchController.clear();
            });
          },
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          autofocus: true,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 14,
            decoration: TextDecoration.none,
          ),
          onChanged: (val) => setState(() => _searchQuery = val.trim()),
          decoration: const InputDecoration(
            hintText: 'Search events by name, location...',
            hintStyle: TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              decoration: TextDecoration.none,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: _stoneGrey, size: 20),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _hasCustomFilters ? _mint : _stoneGrey,
              size: 22,
            ),
            tooltip: 'Filter Timeline',
            onPressed: _showFilterBottomSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0x14FFFFFF), height: 1),
        ),
      );
    }

    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _mint),
        onPressed: () => Navigator.maybePop(context),
      ),
      titleSpacing: 0,
      title: GestureDetector(
        onDoubleTap: _toggleState,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _mint, width: 2),
              ),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: const NetworkImage(_atlasAvatarUrl),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedDog,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Timeline',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: _stoneGrey, size: 22),
          tooltip: 'Search Events',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TimelineSearchScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.filter_list,
                color: _hasCustomFilters ? _mint : _stoneGrey,
                size: 22,
              ),
              if (_hasCustomFilters)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          tooltip: 'Filter Timeline',
          onPressed: _openTimelineFiltersScreen,
        ),
        IconButton(
          icon: const Icon(Icons.calendar_month_outlined, color: _stoneGrey, size: 22),
          tooltip: 'Timeline Calendar',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TimelineCalendarScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.insights_outlined, color: _stoneGrey, size: 22),
          tooltip: 'Timeline Statistics',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TimelineStatisticsScreen(),
              ),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: _stoneGrey, size: 22),
          color: _carbon,
          onSelected: (val) {
            if (val == 'toggle_state') {
              _toggleState();
            } else if (val == 'toggle_graph') {
              setState(() => _showAnimatedGraph = !_showAnimatedGraph);
            } else if (val == 'switch_dog') {
              _showDogSelectorModal();
            } else if (val == 'record') {
              _showQuickAddModal();
            } else if (val == 'event_details') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineEventDetailsScreen(),
                ),
              );
            } else if (val == 'timeline_filters') {
              _openTimelineFiltersScreen();
            } else if (val == 'timeline_search') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineSearchScreen(),
                ),
              );
            } else if (val == 'timeline_calendar') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineCalendarScreen(),
                ),
              );
            } else if (val == 'timeline_favourites') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineFavouritesScreen(),
                ),
              );
            } else if (val == 'timeline_archive') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineArchiveScreen(),
                ),
              );
            } else if (val == 'timeline_settings') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineSettingsScreen(),
                ),
              );
            } else if (val == 'timeline_insights') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineInsightsScreen(),
                ),
              );
            } else if (val == 'timeline_statistics') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelineStatisticsScreen(),
                ),
              );
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(
              value: 'timeline_favourites',
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Color(0xFFB8920A), size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Favourites',
                      style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_archive',
              child: Row(
                children: [
                  Icon(Icons.archive_outlined, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Archive',
                      style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Settings',
                      style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_insights',
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Insights',
                      style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_statistics',
              child: Row(
                children: [
                  Icon(Icons.insights_outlined, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Statistics',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_calendar',
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Calendar',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_search',
              child: Row(
                children: [
                  Icon(Icons.search, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Search',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'timeline_filters',
              child: Row(
                children: [
                  Icon(Icons.tune, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Filters',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'event_details',
              child: Row(
                children: [
                  Icon(Icons.event_note_outlined, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Timeline Event Details',
                      style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_state',
              child: Row(
                children: [
                  Icon(
                    _isEmptyState ? Icons.visibility : Icons.visibility_off_outlined,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isEmptyState
                        ? 'Switch to Populated State'
                        : 'Switch to Empty State',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_graph',
              child: Row(
                children: [
                  Icon(
                    _showAnimatedGraph ? Icons.timeline : Icons.show_chart,
                    color: _mint,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _showAnimatedGraph ? 'Hide Trend Chart' : 'Show Trend Chart',
                    style: const TextStyle(color: _offWhite, fontSize: 13),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'switch_dog',
              child: Row(
                children: [
                  Icon(Icons.pets, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Switch Dog', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'record',
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: _mint, size: 18),
                  SizedBox(width: 8),
                  Text('Quick Record Event', style: TextStyle(color: _offWhite, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: const Color(0x14FFFFFF), height: 1),
      ),
    );
  }

  // ===========================================================================
  // STATE 1: POPULATED STATE CONTENT (Figma Image 1)
  // ===========================================================================

  Widget _buildPopulatedStateContent() {
    final filtered = _filteredEvents;

    // Group events by dateGroup
    final Map<String, List<DashboardEventItem>> grouped = {};
    for (final e in filtered) {
      grouped.putIfAbsent(e.dateGroup, () => []).add(e);
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        // 1. Dog Selector Row (Figma Image 1)
        _buildDogSelectorCard(),
        const SizedBox(height: 16),

        // 2. Timeline Summary 6-Grid Card (Figma Image 1)
        _buildSummaryStatsGrid(),
        const SizedBox(height: 16),

        // 3. Interactive Animated Trend Graph (Responsive on card click)
        if (_showAnimatedGraph) ...[
          _buildAnimatedTrendCard(),
          const SizedBox(height: 16),
        ],

        // 4. Search Bar & Category Pills Filter
        _buildSearchBarWithTune(),
        const SizedBox(height: 12),
        _buildCategoryPillsRow(),
        const SizedBox(height: 20),

        // 5. Chronological Feed with Left Vertical Spine
        if (grouped.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  const Icon(Icons.filter_alt_off, color: _stoneGrey, size: 36),
                  const SizedBox(height: 10),
                  Text(
                    'No events found matching "$_selectedFilter"',
                    style: const TextStyle(color: _stoneGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _selectQuickFilter('All'),
                    child: const Text('Reset All Filters',
                        style: TextStyle(color: _mint)),
                  ),
                ],
              ),
            ),
          )
        else
          ...grouped.entries.map((entry) {
            return _buildDateGroupSection(entry.key, entry.value);
          }),
      ],
    );
  }

  // ─── Dog Selector Card (Figma Image 1) ──────────────────────────────────────

  Widget _buildDogSelectorCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _showDogSelectorModal,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x14FFFFFF), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: const NetworkImage(_dogCardAvatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDog,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Belgian Malinois · 3 yrs',
                      style: TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF404944), size: 24),
          ],
        ),
      ),
    );
  }

  // ─── Timeline Summary 6-Grid Card (Figma Image 1) ───────────────────────────

  Widget _buildSummaryStatsGrid() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Column(
        children: [
          // Row 1
          Row(
            children: [
              Expanded(
                child: _buildGridCell(
                  index: 0,
                  value: '847',
                  label: 'TOTAL EVENTS',
                  hasRightBorder: true,
                  hasBottomBorder: true,
                ),
              ),
              Expanded(
                child: _buildGridCell(
                  index: 1,
                  value: '12',
                  label: 'THIS WEEK',
                  hasRightBorder: true,
                  hasBottomBorder: true,
                ),
              ),
              Expanded(
                child: _buildGridCell(
                  index: 2,
                  value: '38',
                  label: 'THIS MONTH',
                  hasRightBorder: false,
                  hasBottomBorder: true,
                ),
              ),
            ],
          ),
          // Row 2
          Row(
            children: [
              Expanded(
                child: _buildGridCell(
                  index: 3,
                  value: '214',
                  label: 'THIS YEAR',
                  hasRightBorder: true,
                  hasBottomBorder: false,
                ),
              ),
              Expanded(
                child: _buildGridCell(
                  index: 4,
                  value: 'Today',
                  label: 'LAST ACTIVITY',
                  hasRightBorder: true,
                  hasBottomBorder: false,
                ),
              ),
              Expanded(
                child: _buildGridCell(
                  index: 5,
                  value: '23',
                  label: 'ACTIVE RECORDS',
                  hasRightBorder: false,
                  hasBottomBorder: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridCell({
    required int index,
    required String value,
    required String label,
    required bool hasRightBorder,
    required bool hasBottomBorder,
  }) {
    final isSelected = _selectedStatIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatIndex = index;
          _chartAnimController.reset();
          _chartAnimController.forward();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? _forest.withValues(alpha: 0.25) : Colors.transparent,
          border: Border(
            right: hasRightBorder
                ? const BorderSide(color: Color(0x14FFFFFF), width: 1)
                : BorderSide.none,
            bottom: hasBottomBorder
                ? const BorderSide(color: Color(0x14FFFFFF), width: 1)
                : BorderSide.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? _mint : _offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Animated Activity Trend Card ──────────────────────────────────────────

  Widget _buildAnimatedTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with metric toggle segmented tabs (Image 2 parity)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.show_chart, color: _mint, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'ACTIVITY TREND',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: _stoneGrey, size: 16),
                tooltip: 'Replay Animation',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented metric tabs: DURATION | DISTANCE | EVENTS (Image 2 parity)
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: _surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildMetricTabItem('DURATION'),
                _buildMetricTabItem('DISTANCE'),
                _buildMetricTabItem('EVENTS'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Interactive FL Chart
          AnimatedBuilder(
            animation: _chartAnim,
            builder: (context, _) {
              final p = _chartAnim.value;
              List<FlSpot> spots;

              if (_selectedMetric == 'DURATION') {
                spots = [
                  FlSpot(0, 1.2 * p),
                  FlSpot(1, 2.5 * p),
                  FlSpot(2, 1.8 * p),
                  FlSpot(3, 3.2 * p),
                  FlSpot(4, 2.0 * p),
                  FlSpot(5, 4.5 * p),
                  FlSpot(6, 3.0 * p),
                ];
              } else if (_selectedMetric == 'DISTANCE') {
                spots = [
                  FlSpot(0, 4.0 * p),
                  FlSpot(1, 8.5 * p),
                  FlSpot(2, 6.0 * p),
                  FlSpot(3, 12.0 * p),
                  FlSpot(4, 7.5 * p),
                  FlSpot(5, 15.0 * p),
                  FlSpot(6, 10.0 * p),
                ];
              } else {
                spots = [
                  FlSpot(0, 2 * p),
                  FlSpot(1, 5 * p),
                  FlSpot(2, 3 * p),
                  FlSpot(3, 8 * p),
                  FlSpot(4, 4 * p),
                  FlSpot(5, 9 * p),
                  FlSpot(6, 6 * p),
                ];
              }

              final maxY = _selectedMetric == 'DURATION'
                  ? 5.0
                  : (_selectedMetric == 'DISTANCE' ? 18.0 : 10.0);

              return SizedBox(
                height: 100,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, _) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            final i = val.toInt();
                            if (i >= 0 && i < days.length) {
                              return Text(
                                days[i],
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 10,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: maxY,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((s) {
                            String unit = _selectedMetric == 'DURATION'
                                ? 'hrs'
                                : (_selectedMetric == 'DISTANCE' ? 'km' : 'events');
                            return LineTooltipItem(
                              '${s.y.toStringAsFixed(1)} $unit',
                              const TextStyle(
                                color: _mint,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _mint,
                        barWidth: 2.2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: _obsidian,
                            strokeWidth: 2,
                            strokeColor: _mint,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _mint.withValues(alpha: 0.28),
                              _mint.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTabItem(String metric) {
    final isSel = _selectedMetric == metric;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMetric = metric;
            _chartAnimController.reset();
            _chartAnimController.forward();
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSel ? _mint : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            metric,
            style: TextStyle(
              color: isSel ? _offWhite : _stoneGrey,
              fontSize: 11,
              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Search Bar with Dedicated Tune Button (Web-safe) ───────────────────────

  Widget _buildSearchBarWithTune() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: _stoneGrey, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: const InputDecoration(
                hintText: 'Search timeline events...',
                hintStyle: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  decoration: TextDecoration.none,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.close, color: _stoneGrey, size: 16),
              ),
            ),
          const SizedBox(width: 4),
          // Dedicated Tune Button with direct hit testing
          Tooltip(
            message: 'Filter Timeline',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: _showFilterBottomSheet,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.tune,
                        color: _hasCustomFilters ? _mint : _stoneGrey,
                        size: 20,
                      ),
                      if (_hasCustomFilters)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: _mint,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Category Pills Row (Figma Image 1) ─────────────────────────────────────

  Widget _buildCategoryPillsRow() {
    final pills = [
      {'label': 'All', 'dotColor': null},
      {'label': 'Training', 'dotColor': _alpineBlue},
      {'label': 'Health', 'dotColor': _error},
      {'label': 'S&C', 'dotColor': _tertiary},
      {'label': 'Media', 'dotColor': _secondary},
      {'label': 'Goal', 'dotColor': _mint},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: pills.map((p) {
          final label = p['label'] as String;
          final dotColor = p['dotColor'] as Color?;
          final isSel = _selectedFilter == label;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _selectQuickFilter(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isSel ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSel ? _forest : const Color(0x24FFFFFF),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dotColor != null) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isSel ? const Color(0xFFAAE9D0) : _stoneGrey,
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Chronological Feed with Left Vertical Spine (Figma Image 1) ───────────

  Widget _buildDateGroupSection(String dateTitle, List<DashboardEventItem> items) {
    final isToday = dateTitle == 'TODAY';

    return Stack(
      children: [
        // Vertical Spine on the left side
        Positioned(
          left: 5,
          top: 14,
          bottom: 0,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              color: _forest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),

        // Section Content
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header with Spine Node Dot
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday ? _forest : _obsidian,
                      border: Border.all(
                        color: isToday ? _mint : const Color(0xFF404944),
                        width: isToday ? 2.5 : 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    dateTitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Cards Indented next to spine
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: items.map((item) => _buildDashboardCard(item)).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Timeline Feed Cards (Matching Image 1 Exact Anatomy) ───────────────────

  Widget _buildDashboardCard(DashboardEventItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showEventDetailSheet(item),
        child: Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          ),
          child: Stack(
            children: [
              // Top right radial accent for Goal cards (Image 1 parity)
              if (item.category == DashboardCategory.goal)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.0,
                        colors: [
                          _mint.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Category Tag + Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                item.icon,
                                color: item.categoryColor,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item.categoryLabel,
                              style: TextStyle(
                                color: item.categoryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        if (item.hasStar)
                          const Icon(Icons.star, color: _mint, size: 18)
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.timeLabel,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Row 2: Title and Optional Photo Thumbnail (Media Card)
                    if (item.photoUrl != null) ...[
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
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle!,
                                    style: const TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.photoUrl!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      if (item.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: _stoneGrey, size: 13),
                            const SizedBox(width: 3),
                            Text(
                              item.location!,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],

                    // Row 3: Footer with stats & Status Badge (Image 1 parity)
                    if (item.statusBadge != null || (item.subtitle != null && item.photoUrl == null && item.category == DashboardCategory.training)) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.subtitle ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (item.statusBadge != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _mint.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.statusBadge!,
                                  style: const TextStyle(
                                    color: _mint,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // STATE 2: EMPTY STATE CONTENT (Figma Image 2)
  // ===========================================================================

  Widget _buildEmptyStateContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        // 1. Dog Selector Pills: Atlas (checked), Nova (Figma Image 2)
        Row(
          children: [
            _buildDogPill('Atlas', isSelected: _selectedDog == 'Atlas'),
            const SizedBox(width: 8),
            _buildDogPill('Nova', isSelected: _selectedDog == 'Nova'),
          ],
        ),
        const SizedBox(height: 20),

        // 2. Metric Segmented Bar: DURATION | DISTANCE | EVENTS (Figma Image 2)
        Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          ),
          child: Row(
            children: [
              _buildMetricSegment('DURATION'),
              _buildMetricSegment('DISTANCE'),
              _buildMetricSegment('EVENTS'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 3. Section Header: Recent Activity & All Types Filter (Figma Image 2)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: _showFilterBottomSheet,
              child: const Row(
                children: [
                  Text(
                    'All Types',
                    style: TextStyle(color: _stoneGrey, fontSize: 13),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.filter_list, color: _stoneGrey, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),

        // 4. Center Spine Node & Curvy Path Graphic (Figma Image 2)
        Center(
          child: Column(
            children: [
              // Vertical spine dropping to plus node
              Container(
                width: 2,
                height: 40,
                color: _forest.withValues(alpha: 0.6),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _obsidian,
                  border: Border.all(color: _forest, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.add, color: _mint, size: 16),
                ),
              ),
              const SizedBox(height: 18),

              // Curvy path ribbon mark (Image 2 parity)
              CustomPaint(
                size: const Size(40, 40),
                painter: _CurvyRibbonPainter(color: _mint),
              ),
              const SizedBox(height: 24),

              // Empty State Headline
              const Text(
                'No Timeline Events Yet',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Every journey starts somewhere...',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Primary CTA: + Start Recording -> (Figma Image 2)
              SizedBox(
                width: 260,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecordSessionScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Start Recording',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Secondary CTA: Add a Health Record instead (Figma Image 2)
              TextButton(
                onPressed: _showQuickAddModal,
                child: const Text(
                  'Add a Health Record instead',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Switch back to Atlas Demo
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _stoneGrey,
                  side: const BorderSide(color: Color(0x24FFFFFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.sync, size: 16, color: _mint),
                label: const Text('Load Atlas Populated Timeline'),
                onPressed: () => _selectDog('Atlas'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDogPill(String dogName, {required bool isSelected}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _selectDog(dogName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _forest : const Color(0x24FFFFFF),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: _mint, size: 15),
              const SizedBox(width: 6),
            ],
            Text(
              dogName,
              style: TextStyle(
                color: isSelected ? _offWhite : _stoneGrey,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricSegment(String metric) {
    final isSel = _selectedMetric == metric;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMetric = metric;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSel ? _mint : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            metric,
            style: TextStyle(
              color: isSel ? _offWhite : _stoneGrey,
              fontSize: 11,
              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bottom Navigation Bar (Matching App Standard) ─────────────────────────

  Widget _buildBottomNav() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(top: BorderSide(color: Color(0x14FFFFFF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(icon: Icons.home_outlined, label: 'Home', isActive: false),
          _buildBottomNavItem(icon: Icons.pets_outlined, label: 'Dogs', isActive: false),
          _buildBottomNavItem(icon: Icons.fitness_center_outlined, label: 'Training', isActive: false),
          _buildBottomNavItem(icon: Icons.event_note, label: 'Timeline', isActive: true),
          _buildBottomNavItem(icon: Icons.more_horiz_outlined, label: 'More', isActive: false),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          Navigator.maybePop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? _mint : _stoneGrey,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? _mint : _stoneGrey,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Curvy Ribbon Graphic Painter for Empty State
class _CurvyRibbonPainter extends CustomPainter {
  final Color color;

  _CurvyRibbonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Curvy track S-shape ribbon loop
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.cubicTo(
      size.width * 0.05,
      size.height * 0.2,
      size.width * 0.45,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.55,
      size.height * 0.9,
      size.width * 0.95,
      size.height * 0.8,
      size.width * 0.8,
      size.height * 0.2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvyRibbonPainter oldDelegate) =>
      oldDelegate.color != color;
}
