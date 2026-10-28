import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'record_session_screen.dart';
import 'timeline_dashboard_screen.dart';
import 'timeline_event_details_screen.dart';
import 'timeline_filters_screen.dart';
import 'timeline_search_screen.dart';
import 'timeline_calendar_screen.dart';
import 'timeline_statistics_screen.dart';
import 'timeline_export_screen.dart';
import 'timeline_favourites_screen.dart';
import 'timeline_archive_screen.dart';
import 'timeline_settings_screen.dart';
import 'timeline_insights_screen.dart';
import 'timeline_memories_screen.dart';
import 'timeline_activity_map_screen.dart';
import 'timeline_compare_screen.dart';
import 'timeline_smart_collections_screen.dart';
import 'timeline_widgets_screen.dart';

/// Timeline Event Model
enum TimelineCategory { training, health, milestone, competition, goal }

class TimelineEventItem {
  final String id;
  final String dogName;
  final String dogAvatarUrl;
  final String title;
  final String timeLabel;
  final String dateGroup; // 'Today', 'Yesterday', 'Earlier This Week'
  final TimelineCategory category;
  final IconData icon;
  final Color iconColor;
  final String? duration;
  final String? location;
  final String? mediaBadge;
  final String? reportBadge;
  final String? goalBadge;
  final List<String>? tags;
  final String? smallThumbnailUrl;
  final String? widePhotoUrl;

  const TimelineEventItem({
    required this.id,
    required this.dogName,
    required this.dogAvatarUrl,
    required this.title,
    required this.timeLabel,
    required this.dateGroup,
    required this.category,
    required this.icon,
    required this.iconColor,
    this.duration,
    this.location,
    this.mediaBadge,
    this.reportBadge,
    this.goalBadge,
    this.tags,
    this.smallThumbnailUrl,
    this.widePhotoUrl,
  });
}

/// Global Timeline Screen (Batch 6 - Lines 170 & 171)
/// Contains both Populated State (Figma Image 1) and Empty State (Figma Image 2)
class TimelineScreen extends StatefulWidget {
  final bool initialEmpty;
  const TimelineScreen({super.key, this.initialEmpty = false});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _surfaceContainer = Color(0xFF1D201F);
  static const Color _surfaceContainerHigh = Color(0xFF272B29);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _gold = Color(0xFFF9A826);
  static const Color _errorMuted = Color(0xFF8B3A3A);

  // ─── Image Assets ──────────────────────────────────────────────────────────
  static const String _heroImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAqTYgzvEaNuqvQefFQTC_2yNS04uFbEtj4mVtZnx0hh6TPWj0riNoTVpWpYGCt0aE-0wsu1FjTHpeY66S3HImhM8ocwaelZekaa-DWUCgX81NGOeBqrwGeKCIbaNmS2FaH_SAxb_me6YVf7Y1-4ogI-V2EoST8jNxmUVHVEaca0suB0PkXzsbssq44gnH3xv84llgrcmqvgApQ-QOWRYwg8F1dj9p1wHj1U6lg6xll3yqfeLBf__o';

  static const String _murphyAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD5a3uQvAZDqpVduQIwWPTfeXdnzvnZUAHhyLAu2f3BbeSL-M9SXOmi1QJAwn2Cde95uSh3xO6OAoEasiYE6MqnwVGZMQhX8E6_AulDrKbDOg-19Y2XY2WQvefPY7ecnzkudfXktfncSAUHbRYfdfW9pd8Lz7sFhaW0OujFgJOV6god8KDIDOx_bAseHiV5lHPP73kboSt3BIjv5MBYJawjarbxorlGSV-s67INL-aMnVJgDTIbiho';

  static const String _freyaAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAAcLbiDicBjYD6Lz8o3P1eq3ZYTW94TSp9IVpwMikl7LlGjta4VtqjreCYkJY_4ZasiFwWYpriHDdXkEO3jmS9xRmGbJzpWa1hBVZlUila8o9ns6mteZzpKnxJESTW2PrUoOe_m1EbJ-bkbq3xfw0Flgqraws3s-OoXC_8e7FcVgNo3lt14w4ZmLFnuxrQQVhkLcTqw7k4xaW1HYO4t2Oui7ynBnZ_2KVKm257yPnfcS_ZGbSQlJo';

  static const String _parkThumb =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC9VGsaoANfm2IZNlGqpN8Mc2RyHfS8fUfmXZCQUrQKjRKfEwatK1QbGcFhcHvH5oob49sCCpvaye_jO965oaG1ECZYrJEd4HVLU-mNbKWxB_n25WznJDLroWUF3Qs-oRdMlet3nv8CWX0BXA_WTjMoKvtGs9i8-oiTAVPYnQ9_VGfZFs2S34hxAodqieHd0p9X_1baaSNavMC9kDE5V-P25r4uA82XwJuwLI18N6ipqtXduFVz_Cs';

  static const String _igpJumpPhoto =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA5FgWD2i1unJHuVMs7xYGIHfRAWlfmDzMl4UDozRaJ24GcMuGHNGrfykCZFVs2d9c12U4-fx_kZuu7QIoslWEiA6im1AkO_7BuTFH9etoeCbe69vPcInwmUlKrSnzozgbOF_Yf50UBt3sV1svztHGc3xGazeLrIuPnowR2kqJcPM1ycrN-MpwjuRdzXx8aqqjNNwtGGx60UhD-xSKwYsa0RWgZkJtKMlUpC3VlDRVifvpIVv6qCik';

  // ─── State ─────────────────────────────────────────────────────────────────
  late bool _isEmptyState;
  String _selectedDog = 'All Dogs'; // 'All Dogs', 'Murphy', 'Freya', 'Fenris'
  String _selectedFilter = 'All Events';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showGraph = true;

  // Filter State
  Set<TimelineCategory> _activeCategories = {
    TimelineCategory.training,
    TimelineCategory.health,
    TimelineCategory.milestone,
    TimelineCategory.competition,
    TimelineCategory.goal,
  };
  String _dateRangeFilter = 'All Time'; // 'All Time', 'Today', 'Yesterday', 'This Week'
  bool _mediaOnlyFilter = false;

  bool get _hasCustomFilters =>
      _activeCategories.length < 5 ||
      _dateRangeFilter != 'All Time' ||
      _mediaOnlyFilter ||
      _selectedFilter != 'All Events';

  // Chart Animation
  late AnimationController _chartAnimController;
  late Animation<double> _chartAnim;

  // Raw Event Data
  late List<TimelineEventItem> _allEvents;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;

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
    super.dispose();
  }

  void _initSampleEvents() {
    _allEvents = [
      // TODAY
      const TimelineEventItem(
        id: 'ev-1',
        dogName: 'Murphy',
        dogAvatarUrl: _murphyAvatar,
        title: 'Recall & Engagement Work',
        timeLabel: '06:42 PM',
        dateGroup: 'Today',
        category: TimelineCategory.training,
        icon: Icons.timer,
        iconColor: _sage,
        duration: '45 mins',
        location: 'Hylands Park',
        mediaBadge: '3 Videos',
        smallThumbnailUrl: _parkThumb,
      ),
      const TimelineEventItem(
        id: 'ev-2',
        dogName: 'Murphy',
        dogAvatarUrl: _murphyAvatar,
        title: 'First Off-Lead Walk in the Forest',
        timeLabel: '02:20 PM',
        dateGroup: 'Today',
        category: TimelineCategory.milestone,
        icon: Icons.edit_outlined,
        iconColor: _sage,
        tags: ['Hylands Park', 'Milestone'],
      ),

      // YESTERDAY
      const TimelineEventItem(
        id: 'ev-3',
        dogName: 'Freya',
        dogAvatarUrl: _freyaAvatar,
        title: 'Eye Examination',
        timeLabel: '10:00 AM',
        dateGroup: 'Yesterday',
        category: TimelineCategory.health,
        icon: Icons.local_hospital,
        iconColor: _errorMuted,
        reportBadge: 'Veterinary Report Attached',
      ),
      const TimelineEventItem(
        id: 'ev-4',
        dogName: 'Murphy',
        dogAvatarUrl: _murphyAvatar,
        title: '100 Recall Repetitions',
        timeLabel: '09:30 AM',
        dateGroup: 'Yesterday',
        category: TimelineCategory.goal,
        icon: Icons.ads_click,
        iconColor: _alpineBlue,
        goalBadge: 'Goal Progress',
      ),

      // EARLIER THIS WEEK
      const TimelineEventItem(
        id: 'ev-5',
        dogName: 'Murphy',
        dogAvatarUrl: _murphyAvatar,
        title: 'Endurance Circuit',
        timeLabel: 'Mon · 07:15 AM',
        dateGroup: 'Earlier This Week',
        category: TimelineCategory.training,
        icon: Icons.fitness_center,
        iconColor: _sage,
      ),
      const TimelineEventItem(
        id: 'ev-6',
        dogName: 'Freya',
        dogAvatarUrl: _freyaAvatar,
        title: 'IGP Trial — Regional Qualifier',
        timeLabel: 'Sat · 09:00 AM',
        dateGroup: 'Earlier This Week',
        category: TimelineCategory.competition,
        icon: Icons.emoji_events,
        iconColor: _gold,
        widePhotoUrl: _igpJumpPhoto,
      ),
    ];
  }

  // Filtered Events
  List<TimelineEventItem> get _filteredEvents {
    return _allEvents.where((e) {
      // Dog filter
      if (_selectedDog != 'All Dogs' && e.dogName != _selectedDog) {
        return false;
      }
      // Category filter (checked against active categories)
      if (!_activeCategories.contains(e.category)) {
        return false;
      }
      // Date range filter
      if (_dateRangeFilter == 'Today' && e.dateGroup != 'Today') {
        return false;
      }
      if (_dateRangeFilter == 'Yesterday' && e.dateGroup != 'Yesterday') {
        return false;
      }
      if (_dateRangeFilter == 'This Week' && e.dateGroup == 'Older') {
        return false;
      }
      // Media filter
      if (_mediaOnlyFilter &&
          e.smallThumbnailUrl == null &&
          e.widePhotoUrl == null &&
          e.mediaBadge == null) {
        return false;
      }
      // Search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = e.title.toLowerCase().contains(q);
        final matchesDog = e.dogName.toLowerCase().contains(q);
        final matchesLoc = e.location?.toLowerCase().contains(q) ?? false;
        if (!matchesTitle && !matchesDog && !matchesLoc) return false;
      }
      return true;
    }).toList();
  }

  void _selectQuickFilter(String f) {
    setState(() {
      _selectedFilter = f;
      if (f == 'All Events') {
        _activeCategories = {
          TimelineCategory.training,
          TimelineCategory.health,
          TimelineCategory.milestone,
          TimelineCategory.competition,
          TimelineCategory.goal,
        };
        _mediaOnlyFilter = false;
        _dateRangeFilter = 'All Time';
      } else if (f == 'Training') {
        _activeCategories = {TimelineCategory.training};
      } else if (f == 'Health') {
        _activeCategories = {TimelineCategory.health};
      } else if (f == 'Competition') {
        _activeCategories = {TimelineCategory.competition};
      } else if (f == 'Milestones') {
        _activeCategories = {TimelineCategory.milestone};
      } else if (f == 'Goals') {
        _activeCategories = {TimelineCategory.goal};
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
            if (c == TimelineCategory.goal || c == TimelineCategory.milestone) {
              return 'Goals';
            }
            if (c == TimelineCategory.competition) return 'Competition';
            if (c == TimelineCategory.health) return 'Health';
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
          _activeCategories = Set.from(TimelineCategory.values);
        } else {
          _activeCategories = result.categories.map((c) {
            if (c == 'Goals') return TimelineCategory.goal;
            if (c == 'Competition') return TimelineCategory.competition;
            if (c == 'Health') return TimelineCategory.health;
            return TimelineCategory.training;
          }).toSet();
        }
        if (result.dog != 'All Dogs') {
          _selectedDog = result.dog;
        }
        _dateRangeFilter = result.dateRange;
      });
    }
  }

  void _showFilterBottomSheet() {
    Set<TimelineCategory> tempCategories = Set.from(_activeCategories);
    String tempDateRange = _dateRangeFilter;
    bool tempMediaOnly = _mediaOnlyFilter;
    String tempDog = _selectedDog;

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
          final matchingCount = _allEvents.where((e) {
            if (tempDog != 'All Dogs' && e.dogName != tempDog) return false;
            if (!tempCategories.contains(e.category)) return false;
            if (tempDateRange == 'Today' && e.dateGroup != 'Today') return false;
            if (tempDateRange == 'Yesterday' && e.dateGroup != 'Yesterday') return false;
            if (tempDateRange == 'This Week' && e.dateGroup == 'Older') return false;
            if (tempMediaOnly &&
                e.smallThumbnailUrl == null &&
                e.widePhotoUrl == null &&
                e.mediaBadge == null) {
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
                                TimelineCategory.training,
                                TimelineCategory.health,
                                TimelineCategory.milestone,
                                TimelineCategory.competition,
                                TimelineCategory.goal,
                              };
                              tempDateRange = 'All Time';
                              tempMediaOnly = false;
                              tempDog = 'All Dogs';
                            });
                          },
                          child: const Text('Reset All',
                              style: TextStyle(color: _mint, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Section 1: Event Categories
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
                        _buildModalCategoryChip(
                          label: 'Training',
                          icon: Icons.fitness_center,
                          color: _sage,
                          isSelected:
                              tempCategories.contains(TimelineCategory.training),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories
                                  .contains(TimelineCategory.training)) {
                                if (tempCategories.length > 1) {
                                  tempCategories
                                      .remove(TimelineCategory.training);
                                }
                              } else {
                                tempCategories.add(TimelineCategory.training);
                              }
                            });
                          },
                        ),
                        _buildModalCategoryChip(
                          label: 'Health',
                          icon: Icons.local_hospital,
                          color: _errorMuted,
                          isSelected:
                              tempCategories.contains(TimelineCategory.health),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories
                                  .contains(TimelineCategory.health)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(TimelineCategory.health);
                                }
                              } else {
                                tempCategories.add(TimelineCategory.health);
                              }
                            });
                          },
                        ),
                        _buildModalCategoryChip(
                          label: 'Milestones',
                          icon: Icons.edit_outlined,
                          color: _sage,
                          isSelected:
                              tempCategories.contains(TimelineCategory.milestone),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories
                                  .contains(TimelineCategory.milestone)) {
                                if (tempCategories.length > 1) {
                                  tempCategories
                                      .remove(TimelineCategory.milestone);
                                }
                              } else {
                                tempCategories.add(TimelineCategory.milestone);
                              }
                            });
                          },
                        ),
                        _buildModalCategoryChip(
                          label: 'Competition',
                          icon: Icons.emoji_events,
                          color: _gold,
                          isSelected:
                              tempCategories.contains(TimelineCategory.competition),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories
                                  .contains(TimelineCategory.competition)) {
                                if (tempCategories.length > 1) {
                                  tempCategories
                                      .remove(TimelineCategory.competition);
                                }
                              } else {
                                tempCategories.add(TimelineCategory.competition);
                              }
                            });
                          },
                        ),
                        _buildModalCategoryChip(
                          label: 'Goals',
                          icon: Icons.ads_click,
                          color: _alpineBlue,
                          isSelected:
                              tempCategories.contains(TimelineCategory.goal),
                          onTap: () {
                            setModalState(() {
                              if (tempCategories
                                  .contains(TimelineCategory.goal)) {
                                if (tempCategories.length > 1) {
                                  tempCategories.remove(TimelineCategory.goal);
                                }
                              } else {
                                tempCategories.add(TimelineCategory.goal);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Date Period
                    const Text('DATE PERIOD',
                        style: TextStyle(
                            color: _offWhite,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          ['All Time', 'Today', 'Yesterday', 'This Week'].map((d) {
                        final isSel = tempDateRange == d;
                        return ChoiceChip(
                          label: Text(d),
                          selected: isSel,
                          selectedColor: _forest,
                          backgroundColor: _surfaceContainer,
                          labelStyle: TextStyle(
                              color: isSel
                                  ? const Color(0xFFAAE9D0)
                                  : _stoneGrey,
                              fontSize: 12),
                          side: BorderSide(
                              color: isSel
                                  ? Colors.transparent
                                  : const Color(0x24FFFFFF)),
                          onSelected: (_) {
                            setModalState(() => tempDateRange = d);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Section 3: Media Only
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
                                Icon(Icons.videocam_outlined,
                                    color: _mint, size: 18),
                                SizedBox(width: 8),
                                Text('With Photos or Videos Only',
                                    style: TextStyle(
                                        color: _offWhite, fontSize: 13)),
                              ],
                            ),
                            Checkbox(
                              value: tempMediaOnly,
                              activeColor: _mint,
                              checkColor: _obsidian,
                              onChanged: (val) {
                                setModalState(
                                    () => tempMediaOnly = val ?? false);
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
                            _selectedDog = tempDog;
                            if (_activeCategories.length == 5) {
                              _selectedFilter = 'All Events';
                            } else if (_activeCategories.length == 1) {
                              final single = _activeCategories.first;
                              _selectedFilter = switch (single) {
                                TimelineCategory.training => 'Training',
                                TimelineCategory.health => 'Health',
                                TimelineCategory.milestone => 'Milestones',
                                TimelineCategory.competition => 'Competition',
                                TimelineCategory.goal => 'Goals',
                              };
                            } else {
                              _selectedFilter =
                                  'Filtered (${_activeCategories.length})';
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'Apply Filters ($matchingCount Events)',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
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

  Widget _buildModalCategoryChip({
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

  void _showDogSelectorSheet() {
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
                  'SELECT DOG TIMELINE',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildDogOption(
                name: 'All Dogs',
                subtitle: 'Combined Activity Timeline (142 Events)',
                avatar: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: const NetworkImage(_murphyAvatar),
                    ),
                    Transform.translate(
                      offset: const Offset(-8, 0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: const NetworkImage(_freyaAvatar),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _selectedDog = 'All Dogs';
                    _isEmptyState = false;
                  });
                  Navigator.pop(ctx);
                },
              ),
              _buildDogOption(
                name: 'Murphy',
                subtitle: 'Belgian Malinois (98 Events)',
                avatar: CircleAvatar(
                  radius: 16,
                  backgroundImage: const NetworkImage(_murphyAvatar),
                ),
                onTap: () {
                  setState(() {
                    _selectedDog = 'Murphy';
                    _isEmptyState = false;
                  });
                  Navigator.pop(ctx);
                },
              ),
              _buildDogOption(
                name: 'Freya',
                subtitle: 'German Shepherd (44 Events)',
                avatar: CircleAvatar(
                  radius: 16,
                  backgroundImage: const NetworkImage(_freyaAvatar),
                ),
                onTap: () {
                  setState(() {
                    _selectedDog = 'Freya';
                    _isEmptyState = false;
                  });
                  Navigator.pop(ctx);
                },
              ),
              _buildDogOption(
                name: 'Fenris',
                subtitle: 'Puppy (0 Events — Empty State Demo)',
                avatar: CircleAvatar(
                  radius: 16,
                  backgroundColor: _forest,
                  child: const Text('F', style: TextStyle(color: _mint)),
                ),
                onTap: () {
                  setState(() {
                    _selectedDog = 'Fenris';
                    _isEmptyState = true;
                  });
                  Navigator.pop(ctx);
                },
              ),
              const Divider(color: Color(0x14FFFFFF)),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.space_dashboard_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Dashboard',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Individual dog metrics, 6-grid stats & activity trend',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineDashboardScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _alpineBlue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.event_note_outlined,
                      color: _alpineBlue, size: 20),
                ),
                title: const Text('Open Timeline Event Details',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Detailed event telemetry, grid breakdown & media',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _alpineBlue, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineEventDetailsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tune,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Filters',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Presets, 2-column categories & active chip row',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  _openTimelineFiltersScreen();
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.search,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Search',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Pre-search toggles, saved queries & active results',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineSearchScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.calendar_month,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Calendar',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Month, Week & Day views with animated cadence chart',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineCalendarScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.insights_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Statistics',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Bento cards, curved spline activity & category donut',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineStatisticsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.file_download_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Export',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Date range, format selection, telemetry compilation',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineExportScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8920A).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.favorite,
                      color: Color(0xFFB8920A), size: 20),
                ),
                title: const Text('Open Timeline Favourites',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Saved moments, live search & category filters',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFFB8920A), size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineFavouritesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.archive_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Archive',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Archived events, multi-select & restore workflow',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineArchiveScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.settings_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Settings',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Display density, view modes & notification toggles',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineSettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lightbulb_outline,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Insights',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Automated streaks, trends & activity breakdown',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineInsightsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Memories',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Flashbacks, anniversary milestones & highlights',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineMemoriesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.map_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Activity Map',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('GPS route history, elevation profiles & hotspots',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineActivityMapScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.compare_arrows,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Timeline Compare',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Side-by-side progression & volume delta analysis',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineCompareScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome_motion,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Smart Collections',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Dynamic rule-based clustering & automated highlights',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineSmartCollectionsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.widgets_outlined,
                      color: _mint, size: 20),
                ),
                title: const Text('Open Widgets Gallery',
                    style: TextStyle(
                        color: _offWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                subtitle: const Text('Home Screen, Lock Screen & Dynamic Island previews',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: _mint, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimelineWidgetsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDogOption({
    required String name,
    required String subtitle,
    required Widget avatar,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedDog == name;
    return ListTile(
      leading: avatar,
      title: Text(
        name,
        style: TextStyle(
          color: isSelected ? _mint : _offWhite,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: _stoneGrey, fontSize: 12),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: _mint, size: 20)
          : null,
      onTap: onTap,
    );
  }

  void _showEventDetailsSheet(TimelineEventItem item) {
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(item.dogAvatarUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.dogName,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: const Color(0x14FFFFFF), width: 1),
                  ),
                  child: Text(
                    item.timeLabel,
                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (item.duration != null || item.location != null) ...[
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (item.duration != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule,
                            size: 15, color: _stoneGrey),
                        const SizedBox(width: 5),
                        Text(item.duration!,
                            style: const TextStyle(
                                color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                  if (item.location != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on,
                            size: 15, color: _stoneGrey),
                        const SizedBox(width: 5),
                        Text(item.location!,
                            style: const TextStyle(
                                color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (item.widePhotoUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.widePhotoUrl!,
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
                        side: const BorderSide(color: Color(0x24FFFFFF), width: 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TimelineEventDetailsScreen(
                              initialVariant: item.category == TimelineCategory.health
                                  ? TimelineEventVariant.health
                                  : TimelineEventVariant.training,
                              eventId: item.id,
                              initialTitle: item.title,
                              initialDog: item.dogName,
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

  void _showQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              const Text(
                'LOG NEW TIMELINE EVENT',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.fitness_center, color: _mint),
                ),
                title: const Text('Training Session',
                    style: TextStyle(
                        color: _offWhite, fontWeight: FontWeight.w600)),
                subtitle: const Text('Record workout, reps, drills, or conditioning',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RecordSessionScreen()),
                  );
                },
              ),
              const Divider(color: Color(0x14FFFFFF), height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _errorMuted.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_hospital, color: Color(0xFFFFB4AB)),
                ),
                title: const Text('Health Record',
                    style: TextStyle(
                        color: _offWhite, fontWeight: FontWeight.w600)),
                subtitle: const Text('Log vet visit, vaccination, or medication',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
              const Divider(color: Color(0x14FFFFFF), height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.emoji_events, color: _gold),
                ),
                title: const Text('Competition or Trial',
                    style: TextStyle(
                        color: _offWhite, fontWeight: FontWeight.w600)),
                subtitle: const Text('Add score, placement, trial title & title photos',
                    style: TextStyle(color: _stoneGrey, fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
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
      body: _isEmptyState
          ? _buildEmptyStateView()
          : _buildPopulatedStateView(),
      floatingActionButton: _isEmptyState
          ? null
          : FloatingActionButton(
              onPressed: _showQuickAddSheet,
              backgroundColor: _mint,
              foregroundColor: const Color(0xFF002117),
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 26),
            ),
    );
  }

  // ===========================================================================
  // STATE 1: COMPLETE POPULATED STATE VIEW (Figma Image 1)
  // ===========================================================================

  Widget _buildPopulatedStateView() {
    final filtered = _filteredEvents;

    // Group filtered events by dateGroup
    final Map<String, List<TimelineEventItem>> grouped = {};
    for (final e in filtered) {
      grouped.putIfAbsent(e.dateGroup, () => []).add(e);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Hero Banner Header with misty pine forest
        SliverToBoxAdapter(child: _buildHeroHeader(isPopulated: true)),

        // 2. Dog Selector & Global Summary
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildDogSelectorCard(isPopulated: true),
                const SizedBox(height: 16),
                _buildSummaryStatCardsStrip(),
                const SizedBox(height: 16),

                // Interactive Animated Activity Cadence Chart
                if (_showGraph) ...[
                  _buildAnimatedCadenceGraph(),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),

        // 3. Sticky Search & Filter Pills Bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyFilterHeaderDelegate(
            child: Container(
              color: _obsidian,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 10),
                  _buildFilterPillsStrip(),
                ],
              ),
            ),
          ),
        ),

        // 4. Date-Grouped Timeline Feed
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          sliver: grouped.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No timeline events matching "$_selectedFilter"',
                        style:
                            const TextStyle(color: _stoneGrey, fontSize: 14),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final groupName = grouped.keys.elementAt(index);
                      final itemsInGroup = grouped[groupName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateGroupHeader(groupName),
                          const SizedBox(height: 10),
                          ...itemsInGroup.map((item) => _buildTimelineCard(item)),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                    childCount: grouped.length,
                  ),
                ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STATE 2: COMPLETE EMPTY STATE VIEW (Figma Image 2)
  // ===========================================================================

  Widget _buildEmptyStateView() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. Same Hero Header with Pine Forest
        SliverToBoxAdapter(child: _buildHeroHeader(isPopulated: false)),

        // 2. Dog Selector Card (Single Dog)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildDogSelectorCard(isPopulated: false),
                const SizedBox(height: 50),

                // 3. Centered Compass Graphic & Onboarding Callout
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _obsidian,
                      border: Border.all(color: _mint, width: 2),
                    ),
                    child: const Icon(
                      Icons.explore_outlined,
                      color: _mint,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Your Dog's Journey Starts Here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Every training session, health record, competition, milestone and memory will automatically appear here as you use Ulvenik.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // 4. Large Call-To-Action Button (Figma Image 2)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RecordSessionScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Record Your First Activity',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Load Demo Timeline shortcut
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDog = 'All Dogs';
                        _isEmptyState = false;
                      });
                    },
                    child: const Text(
                      'Load Sample Timeline Data',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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

  // ─── Header: Misty Scandinavian Pine Forest ─────────────────────────────────

  Widget _buildHeroHeader({required bool isPopulated}) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 250 + topPadding,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_heroImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _obsidian.withValues(alpha: 0.2),
              _obsidian.withValues(alpha: 0.6),
              _obsidian,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Brand Mark / Nav & Notification Bell
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minimalist geometric logo mark
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _carbon.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0x24FFFFFF), width: 1),
                      ),
                      child: const Center(
                        child: Icon(Icons.terrain, color: _mint, size: 16),
                      ),
                    ),
                  ],
                ),
                // Actions (Search, Filter, Toggle State, More Views Menu, Notification Bell)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Action Button
                    IconButton(
                      tooltip: 'Search Timeline',
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.search, color: _mint, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TimelineSearchScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    // Filter Action Button
                    IconButton(
                      tooltip: 'Filter Timeline',
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: _hasCustomFilters ? _mint : _offWhite,
                            size: 20,
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
                      onPressed: _openTimelineFiltersScreen,
                    ),
                    const SizedBox(width: 4),
                    // Quick state flip toggle button (Populated vs Empty)
                    IconButton(
                      tooltip: _isEmptyState
                          ? 'Switch to Populated View'
                          : 'Switch to Empty View',
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        _isEmptyState
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        color: _mint,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isEmptyState = !_isEmptyState);
                      },
                    ),
                    const SizedBox(width: 4),
                    // Direct "More Views" Menu Button (3 dots) containing all timeline screens
                    PopupMenuButton<String>(
                      tooltip: 'Timeline Views',
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.more_vert, color: _mint, size: 22),
                      color: _carbon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF272B29)),
                      ),
                      onSelected: (val) {
                        if (val == 'statistics') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineStatisticsScreen(),
                            ),
                          );
                        } else if (val == 'calendar') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineCalendarScreen(),
                            ),
                          );
                        } else if (val == 'dashboard') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineDashboardScreen(),
                            ),
                          );
                        } else if (val == 'event_details') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineEventDetailsScreen(),
                            ),
                          );
                        } else if (val == 'favourites') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineFavouritesScreen(),
                            ),
                          );
                        } else if (val == 'archive') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineArchiveScreen(),
                            ),
                          );
                        } else if (val == 'settings') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineSettingsScreen(),
                            ),
                          );
                        } else if (val == 'insights') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineInsightsScreen(),
                            ),
                          );
                        } else if (val == 'memories') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineMemoriesScreen(),
                            ),
                          );
                        } else if (val == 'activity_map') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineActivityMapScreen(),
                            ),
                          );
                        } else if (val == 'compare') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineCompareScreen(),
                            ),
                          );
                        } else if (val == 'smart_collections') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineSmartCollectionsScreen(),
                            ),
                          );
                        } else if (val == 'widgets') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineWidgetsScreen(),
                            ),
                          );
                        } else if (val == 'export') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimelineExportScreen(),
                            ),
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'favourites',
                          child: Row(
                            children: [
                              Icon(Icons.favorite, color: Color(0xFFB8920A), size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Favourites',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'archive',
                          child: Row(
                            children: [
                              Icon(Icons.archive_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Archive',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Settings',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'insights',
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Insights',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'memories',
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Memories',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'activity_map',
                          child: Row(
                            children: [
                              Icon(Icons.map_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Activity Map',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'compare',
                          child: Row(
                            children: [
                              Icon(Icons.compare_arrows, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Compare',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'smart_collections',
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome_motion, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Smart Collections',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'widgets',
                          child: Row(
                            children: [
                              Icon(Icons.widgets_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Widgets',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'statistics',
                          child: Row(
                            children: [
                              Icon(Icons.insights_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Statistics',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'export',
                          child: Row(
                            children: [
                              Icon(Icons.file_download_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Export',
                                  style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'calendar',
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Calendar',
                                  style: TextStyle(color: _offWhite, fontSize: 13)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'dashboard',
                          child: Row(
                            children: [
                              Icon(Icons.space_dashboard_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Dashboard',
                                  style: TextStyle(color: _offWhite, fontSize: 13)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'event_details',
                          child: Row(
                            children: [
                              Icon(Icons.event_note_outlined, color: _mint, size: 18),
                              SizedBox(width: 10),
                              Text('Timeline Event Details',
                                  style: TextStyle(color: _offWhite, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    // Notification Bell with mint dot badge
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none,
                            color: _offWhite, size: 22),
                        Positioned(
                          top: 1,
                          right: 1,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _mint,
                              shape: BoxShape.circle,
                              border: Border.all(color: _obsidian, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Bottom Hero Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TIMELINE',
                  style: TextStyle(
                    color: _sage,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _isEmptyState = !_isEmptyState);
                  },
                  child: const Text(
                    "Your Dogs' Journey",
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Every moment, every dog, in one place',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Dog Selector Card ──────────────────────────────────────────────────────

  Widget _buildDogSelectorCard({required bool isPopulated}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _showDogSelectorSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                if (isPopulated && _selectedDog == 'All Dogs') ...[
                  // Overlapping dual avatars
                  SizedBox(
                    width: 52,
                    height: 38,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: _carbon,
                            backgroundImage:
                                const NetworkImage(_murphyAvatar),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: _carbon,
                            backgroundImage:
                                const NetworkImage(_freyaAvatar),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Single Dog Avatar
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _carbon,
                    backgroundImage: NetworkImage(
                      _selectedDog == 'Freya' ? _freyaAvatar : _murphyAvatar,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  _selectedDog,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Switch Dog',
                  style: TextStyle(
                    color: isPopulated ? _mint : _stoneGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right,
                    size: 18, color: isPopulated ? _mint : _stoneGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Global Summary Stat Cards Strip ────────────────────────────────────────

  Widget _buildSummaryStatCardsStrip() {
    final stats = [
      {'val': '142', 'lbl': 'Events', 'cat': 'All Events'},
      {'val': '86', 'lbl': 'Sessions', 'cat': 'Training'},
      {'val': '24', 'lbl': 'Health', 'cat': 'Health'},
      {'val': '18', 'lbl': 'Goals', 'cat': 'Goals'},
      {'val': '212', 'lbl': 'Photos', 'cat': 'Competition'},
      {'val': '45', 'lbl': 'Videos', 'cat': 'Training'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: stats.map((s) {
          final isSelected = _selectedFilter == s['cat'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                _selectQuickFilter(s['cat']!);
                if (s['lbl'] == 'Photos' || s['lbl'] == 'Videos') {
                  setState(() => _mediaOnlyFilter = true);
                }
              },
              child: Container(
                width: 80,
                height: 64,
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? _mint : const Color(0x14FFFFFF),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s['val']!,
                      style: TextStyle(
                        color: isSelected ? _mint : _offWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s['lbl']!,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
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

  // ─── Interactive Animated Weekly Cadence Chart ─────────────────────────────

  Widget _buildAnimatedCadenceGraph() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      padding: const EdgeInsets.all(14),
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
                    'WEEKLY EVENT CADENCE',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: _stoneGrey, size: 16),
                    tooltip: 'Hide Graph',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() => _showGraph = false);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _chartAnim,
            builder: (context, _) {
              final p = _chartAnim.value;
              final spots = [
                FlSpot(0, 3 * p),
                FlSpot(1, 6 * p),
                FlSpot(2, 4 * p),
                FlSpot(3, 8 * p),
                FlSpot(4, 5 * p),
                FlSpot(5, 9 * p),
                FlSpot(6, 7 * p),
              ];

              return SizedBox(
                height: 90,
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
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
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
                    maxY: 10,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((s) {
                            return LineTooltipItem(
                              '${s.y.toInt()} Events',
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
                              _mint.withValues(alpha: 0.25),
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

  // ─── Search Bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: _sage, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: const InputDecoration(
                hintText: 'Search events...',
                hintStyle: TextStyle(
                  color: Color(0xFF89938E),
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
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
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Icon(Icons.close, color: _stoneGrey, size: 18),
              ),
            ),
          const SizedBox(width: 4),
          // Dedicated filter tune button with direct pointer hit-testing
          Tooltip(
            message: 'Filter Timeline',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: _showFilterBottomSheet,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.tune,
                        color: _hasCustomFilters ? _mint : _sage,
                        size: 20,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Filter Pills Strip ────────────────────────────────────────────────────

  Widget _buildFilterPillsStrip() {
    const filters = [
      'All Events',
      'Training',
      'Health',
      'Competition',
      'Milestones',
      'Goals'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _selectQuickFilter(f);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0x24FFFFFF),
                    width: 1,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFAAE9D0)
                        : _stoneGrey,
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Date Group Header ─────────────────────────────────────────────────────

  Widget _buildDateGroupHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _offWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
    );
  }

  // ─── Timeline Card with Connector ──────────────────────────────────────────

  Widget _buildTimelineCard(TimelineEventItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showEventDetailsSheet(item),
        child: Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x14FFFFFF), width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Icon & Connector Column
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _surfaceContainer,
                      border: Border.all(
                          color: const Color(0x14FFFFFF), width: 1),
                    ),
                    child: Center(
                      child: Icon(item.icon, color: item.iconColor, size: 18),
                    ),
                  ),
                  if (item.smallThumbnailUrl != null ||
                      item.widePhotoUrl != null ||
                      item.tags != null)
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0x14FFFFFF),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Right Main Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dog info & Timestamp row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundImage:
                                  NetworkImage(item.dogAvatarUrl),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.dogName,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item.timeLabel,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Metadata row / Thumbnails / Tags
                    if (item.duration != null ||
                        item.location != null ||
                        item.mediaBadge != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.duration != null)
                                Row(
                                  children: [
                                    const Icon(Icons.schedule,
                                        size: 13, color: Color(0xFF89938E)),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.duration!,
                                      style: const TextStyle(
                                          color: Color(0xFF89938E),
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              if (item.location != null) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 13, color: Color(0xFF89938E)),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.location!,
                                      style: const TextStyle(
                                          color: Color(0xFF89938E),
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                              if (item.mediaBadge != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.videocam,
                                        size: 13, color: _mint),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.mediaBadge!,
                                      style: const TextStyle(
                                        color: _mint,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          if (item.smallThumbnailUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                item.smallThumbnailUrl!,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ],

                    // Tags row (e.g. Hylands Park / Milestone)
                    if (item.tags != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: item.tags!.map((t) {
                          final isMilestone = t.toLowerCase().contains('milestone');
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isMilestone
                                    ? _mint.withValues(alpha: 0.3)
                                    : const Color(0x14FFFFFF),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              t.toUpperCase(),
                              style: TextStyle(
                                color: isMilestone ? _mint : _sage,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Report attached badge
                    if (item.reportBadge != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.description_outlined,
                              size: 13, color: Color(0xFF89938E)),
                          const SizedBox(width: 4),
                          Text(
                            item.reportBadge!,
                            style: const TextStyle(
                              color: Color(0xFF89938E),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Goal badge
                    if (item.goalBadge != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _alpineBlue.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item.goalBadge!.toUpperCase(),
                          style: const TextStyle(
                            color: _alpineBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],

                    // Wide competition photo attachment
                    if (item.widePhotoUrl != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          item.widePhotoUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
}

/// Persistent Header Delegate for Sticky Filter Header
class _StickyFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 114.0,
      child: child,
    );
  }

  @override
  double get maxExtent => 114.0;

  @override
  double get minExtent => 114.0;

  @override
  bool shouldRebuild(covariant _StickyFilterHeaderDelegate oldDelegate) {
    return true;
  }
}
