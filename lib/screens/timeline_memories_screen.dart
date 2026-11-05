import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'timeline_event_details_screen.dart';

class _MemoryItem {
  final String id;
  final String section; // 'today', 'month', 'milestones', 'achievements', 'year'
  final int? year;
  final String category;
  final Color categoryColor;
  final String? badgeText;
  final bool isGoldBadge;
  final bool isGreenBadge;
  final bool isMilestoneHeaderIcon;
  final String title;
  final String? dateLabel;
  final String subtitle;
  final String? imageUrl;
  final IconData? icon;
  final Color? iconColor;
  final bool extraItem;
  bool isBookmarked = false;
  String reflectionNote = '';

  _MemoryItem({
    required this.id,
    required this.section,
    this.year,
    required this.category,
    required this.categoryColor,
    this.badgeText,
    this.isGoldBadge = false,
    this.isGreenBadge = false,
    this.isMilestoneHeaderIcon = false,
    required this.title,
    this.dateLabel,
    required this.subtitle,
    this.imageUrl,
    this.icon,
    this.iconColor,
    this.extraItem = false,
  });
}

class TimelineMemoriesScreen extends StatefulWidget {
  final bool initialEmpty;
  final bool hasSportPack;

  const TimelineMemoriesScreen({
    super.key,
    this.initialEmpty = false,
    this.hasSportPack = false,
  });

  @override
  State<TimelineMemoriesScreen> createState() => _TimelineMemoriesScreenState();
}

class _TimelineMemoriesScreenState extends State<TimelineMemoriesScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _iconBoxBg = Color(0xFF0C0F0D);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sage = Color(0xFFB6CCB5);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _gold = Color(0xFFB8920A);
  static const Color _bronze = Color(0xFFB4823C);
  static const Color _healthRed = Color(0xFFA84646);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);

  // Curated decorative hero image bank (rotates per Handover rule)
  static const List<String> _heroImageBank = [
    'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=900&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=900&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&w=900&auto=format&fit=crop',
  ];

  late bool _isEmptyState;
  late bool _hasSportPack;
  int _heroImageIndex = 0;
  String _selectedCategory = 'All';
  int? _selectedYear;
  bool _expandThisMonth = false;
  bool _expand2023 = false;
  bool _expand2022 = false;

  late final List<_MemoryItem> _memories = [
    // TODAY
    _MemoryItem(
      id: 'm1',
      section: 'today',
      year: 2023,
      category: 'TRAINING',
      categoryColor: _alpineBlue,
      badgeText: '2 Years Ago',
      isGoldBadge: true,
      title: 'Scent Work Introduction — First Session',
      dateLabel: '14 Sep 2023',
      subtitle: 'Riverside Trail · 45 min · 3 skills',
      imageUrl:
          'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=300&auto=format&fit=crop',
    ),
    _MemoryItem(
      id: 'm2',
      section: 'today',
      year: 2024,
      category: 'GOALS',
      categoryColor: _gold,
      badgeText: '1 Year Ago',
      isGoldBadge: true,
      title: 'Completed Goal: Distance Down',
      dateLabel: '14 Sep 2024',
      subtitle: 'Achieved after 38 days · 22 sessions',
      icon: Icons.emoji_events_outlined,
      iconColor: _gold,
    ),
    // THIS MONTH
    _MemoryItem(
      id: 'm3',
      section: 'month',
      year: 2022,
      category: 'HEALTH',
      categoryColor: _healthRed,
      badgeText: '3 Years Ago',
      title: "Murphy's ACL Recovery — Final Clearance",
      dateLabel: '7 Sep 2022',
      subtitle: 'Recovery completed after 14 weeks rehab',
      icon: Icons.medical_services_outlined,
      iconColor: _healthRed,
    ),
    _MemoryItem(
      id: 'm4',
      section: 'month',
      year: 2023,
      category: 'S&C',
      categoryColor: _bronze,
      badgeText: '2 Years Ago',
      title: 'First Conditioning Assessment',
      dateLabel: '3 Sep 2023',
      subtitle: 'Baseline recorded — 8 exercises logged',
      imageUrl:
          'https://images.unsplash.com/photo-1551730459-92db2a308d6a?q=80&w=300&auto=format&fit=crop',
    ),
    _MemoryItem(
      id: 'm5',
      section: 'month',
      year: 2024,
      category: 'S&C',
      categoryColor: _bronze,
      badgeText: '1 Year Ago',
      title: 'Hydrotherapy Endurance Benchmark',
      dateLabel: '19 Sep 2024',
      subtitle: 'Underwater treadmill · 24 min continuous',
      icon: Icons.pool_outlined,
      iconColor: _alpineBlue,
      extraItem: true,
    ),
    _MemoryItem(
      id: 'm6',
      section: 'month',
      year: 2023,
      category: 'TRAINING',
      categoryColor: _alpineBlue,
      badgeText: '2 Years Ago',
      title: 'Long-Line Forest Tracking',
      dateLabel: '22 Sep 2023',
      subtitle: '420m aged track · 2 articles recovered',
      icon: Icons.explore_outlined,
      iconColor: _mint,
      extraItem: true,
    ),
    _MemoryItem(
      id: 'm7',
      section: 'month',
      year: 2024,
      category: 'HEALTH',
      categoryColor: _healthRed,
      badgeText: '1 Year Ago',
      title: 'Annual Wellness & Sport Screening',
      dateLabel: '28 Sep 2024',
      subtitle: 'Routine wellness check · Weight logged: 29.4 kg',
      icon: Icons.monitor_heart_outlined,
      iconColor: _healthRed,
      extraItem: true,
    ),
    // MILESTONES
    _MemoryItem(
      id: 'm8',
      section: 'milestones',
      year: 2022,
      category: 'MILESTONES',
      categoryColor: _mint,
      isMilestoneHeaderIcon: true,
      badgeText: 'First Entry',
      isGreenBadge: true,
      title: 'Murphy Joins Ulvenik',
      dateLabel: '2 Jan 2022',
      subtitle: "The beginning of Murphy's recorded journey",
      icon: Icons.outlined_flag,
      iconColor: _mint,
    ),
    _MemoryItem(
      id: 'm9',
      section: 'milestones',
      year: 2023,
      category: 'MILESTONES',
      categoryColor: _gold,
      isMilestoneHeaderIcon: true,
      badgeText: '100th Event',
      isGreenBadge: true,
      title: '100th Timeline Entry',
      dateLabel: '18 Mar 2023',
      subtitle: 'Reached 100 recorded Timeline events',
      icon: Icons.workspace_premium_outlined,
      iconColor: _gold,
    ),
    // ACHIEVEMENTS
    _MemoryItem(
      id: 'm10',
      section: 'achievements',
      year: 2025,
      category: 'TRAINING',
      categoryColor: _alpineBlue,
      badgeText: '1 Year Ago',
      isGoldBadge: true,
      title: 'Longest Recording Streak — 31 Days',
      dateLabel: 'March 2025',
      subtitle: '31 consecutive recording days logged',
      imageUrl:
          'https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&w=300&auto=format&fit=crop',
    ),
    // PREVIOUS YEARS — 2024
    _MemoryItem(
      id: 'm11',
      section: 'year',
      year: 2024,
      category: 'COMPETITION',
      categoryColor: _forest,
      title: 'Regional IGP I Tracking Trial',
      subtitle: 'Recorded result: 94/100 · Excellent',
      icon: Icons.tour_outlined,
      iconColor: _forest,
    ),
    _MemoryItem(
      id: 'm12',
      section: 'year',
      year: 2024,
      category: 'TRAINING',
      categoryColor: _alpineBlue,
      title: 'First Broad Jump Regulation Clear',
      subtitle: 'Nordic Training Grounds · Height 1.2m',
      icon: Icons.open_in_full,
      iconColor: _alpineBlue,
    ),
    // PREVIOUS YEARS — 2023
    _MemoryItem(
      id: 'm13',
      section: 'year',
      year: 2023,
      category: 'TRAINING',
      categoryColor: _alpineBlue,
      title: 'Heeling under High Distraction',
      subtitle: 'Suburban perimeter session · 40 mins',
      imageUrl:
          'https://images.unsplash.com/photo-1568572933382-74d440642117?q=80&w=300&auto=format&fit=crop',
    ),
    _MemoryItem(
      id: 'm14',
      section: 'year',
      year: 2023,
      category: 'GOALS',
      categoryColor: _gold,
      title: 'Foundation Heeling Certified',
      subtitle: 'Goal completed · 10/10 club evaluation logged',
      icon: Icons.outlined_flag,
      iconColor: _gold,
    ),
    _MemoryItem(
      id: 'm15',
      section: 'year',
      year: 2023,
      category: 'COMPETITION',
      categoryColor: _forest,
      title: 'BH-VT Companion Dog Temperament Pass',
      subtitle: 'Recorded result: Pass · Traffic & neutrality phase',
      icon: Icons.verified_outlined,
      iconColor: _mint,
      extraItem: true,
    ),
    // PREVIOUS YEARS — 2022
    _MemoryItem(
      id: 'm16',
      section: 'year',
      year: 2022,
      category: 'PUPPYHOOD',
      categoryColor: _mint,
      title: 'First Crate Night & House Manners',
      subtitle: 'Recorded note: Settled overnight in crate',
      icon: Icons.sentiment_satisfied_alt_outlined,
      iconColor: _mint,
    ),
    _MemoryItem(
      id: 'm17',
      section: 'year',
      year: 2022,
      category: 'PUPPYHOOD',
      categoryColor: _mint,
      title: 'Environmental Socialisation — Train Station',
      subtitle: 'Recorded note: 30 min platform exposure session',
      icon: Icons.train_outlined,
      iconColor: _mint,
      extraItem: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _hasSportPack = widget.hasSportPack;
    _heroImageIndex = DateTime.now().second % _heroImageBank.length;
  }

  bool _matchesActiveFilters(_MemoryItem item) {
    if (!_hasSportPack && item.category.toUpperCase() == 'COMPETITION') {
      return false;
    }
    if (_selectedCategory != 'All' &&
        item.category.toUpperCase() != _selectedCategory.toUpperCase()) {
      return false;
    }
    if (_selectedYear != null && item.year != _selectedYear) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (!_isEmptyState &&
              (_selectedCategory != 'All' || _selectedYear != null))
            _buildActiveFilterBanner(),
          Expanded(
            child: _isEmptyState ? _buildEmptyState() : _buildPopulatedState(),
          ),
          _buildBottomActionStrip(),
        ],
      ),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.timeline),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF131719),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const UlvenikIcon(UlvenikIcons.back, color: _stoneGrey, size: 26),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Timeline Memories',
        style: TextStyle(
          color: _offWhite,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Filter & Display Options',
          icon: const UlvenikIcon(UlvenikIcons.sort, color: _stoneGrey, size: 20),
          onPressed: _showFilterCategoriesSheet,
        ),
        PopupMenuButton<String>(
          icon: const UlvenikIcon(UlvenikIcons.more, color: _stoneGrey, size: 20),
          color: _carbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: _cardBorder),
          ),
          onSelected: (val) {
            if (val == 'toggle_state') {
              setState(() => _isEmptyState = !_isEmptyState);
              AppSnackbar.show(
                context,
                message: _isEmptyState
                    ? 'Switched to Empty State preview'
                    : 'Switched to Populated State',
                type: SnackbarType.info,
              );
            } else if (val == 'sport_pack') {
              setState(() {
                _hasSportPack = !_hasSportPack;
                if (!_hasSportPack && _selectedCategory == 'COMPETITION') {
                  _selectedCategory = 'All';
                }
              });
            } else if (val == 'rotate_hero') {
              setState(() {
                _heroImageIndex = (_heroImageIndex + 1) % _heroImageBank.length;
              });
            } else if (val == 'reset_filters') {
              setState(() {
                _selectedCategory = 'All';
                _selectedYear = null;
              });
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle_state',
              child: Text(
                _isEmptyState
                    ? 'Switch to Populated State'
                    : 'Switch to Empty State',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            PopupMenuItem(
              value: 'sport_pack',
              child: Text(
                _hasSportPack ? 'Disable Sport Pack' : 'Enable Sport Pack',
                style: const TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'rotate_hero',
              child: Text(
                'Cycle Anniversary Cover Photo',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
            const PopupMenuItem(
              value: 'reset_filters',
              child: Text(
                'Reset Category & Year Filters',
                style: TextStyle(color: _offWhite, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _cardBorder),
      ),
    );
  }

  Widget _buildActiveFilterBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: _carbon,
        border: Border(bottom: BorderSide(color: _cardBorder)),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.sort, color: _mint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              [
                if (_selectedCategory != 'All') 'Category: $_selectedCategory',
                if (_selectedYear != null) 'Year: $_selectedYear',
              ].join(' · '),
              style: const TextStyle(
                color: _offWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              _selectedCategory = 'All';
              _selectedYear = null;
            }),
            child: const Text(
              'Clear',
              style: TextStyle(
                color: _mint,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x14FFFFFF), width: 1),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _carbon,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x18FFFFFF)),
              ),
              child: const UlvenikIcon(UlvenikIcons.history,
                color: _sage,
                size: 32,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "As your dog's journey grows,\nmemorable moments and anniversaries\nwill appear here automatically.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.maybePop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Go to Timeline',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 8),
                  UlvenikIcon(UlvenikIcons.details, size: 17),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
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
                    const UlvenikIcon(UlvenikIcons.skills,
                        color: _sage, size: 15),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'MILESTONE ENGINE',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'STANDBY',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Memories and milestones are generated automatically from your recorded Timeline data — including dates, anniversaries, session counts, completed goals, and recorded events.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopulatedState() {
    final todayItems = _memories
        .where((m) => m.section == 'today' && _matchesActiveFilters(m))
        .toList();
    final allMonthItems = _memories
        .where((m) => m.section == 'month' && _matchesActiveFilters(m))
        .toList();
    final visibleMonthItems = _expandThisMonth
        ? allMonthItems
        : allMonthItems.where((m) => !m.extraItem).toList();
    final hiddenMonthCount = allMonthItems.length - visibleMonthItems.length;

    final milestoneItems = _memories
        .where((m) => m.section == 'milestones' && _matchesActiveFilters(m))
        .toList();
    final achievementItems = _memories
        .where((m) => m.section == 'achievements' && _matchesActiveFilters(m))
        .toList();

    final y2024 = _memories
        .where((m) =>
            m.section == 'year' && m.year == 2024 && _matchesActiveFilters(m))
        .toList();
    final all2023 = _memories
        .where((m) =>
            m.section == 'year' && m.year == 2023 && _matchesActiveFilters(m))
        .toList();
    final visible2023 =
        _expand2023 ? all2023 : all2023.where((m) => !m.extraItem).toList();

    final all2022 = _memories
        .where((m) =>
            m.section == 'year' && m.year == 2022 && _matchesActiveFilters(m))
        .toList();
    final visible2022 =
        _expand2022 ? all2022 : all2022.where((m) => !m.extraItem).toList();

    final showHero = (_selectedCategory == 'All' ||
            _selectedCategory.toUpperCase() == 'TRAINING') &&
        (_selectedYear == null || _selectedYear == 2025);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHero) ...[
            _buildHeroAnniversaryCard(),
            const SizedBox(height: 24),
          ],
          if (todayItems.isNotEmpty) ...[
            _buildSectionHeader(
                'TODAY',
                todayItems.length == 2
                    ? '2 Memories'
                    : '${todayItems.length} Memories'),
            const SizedBox(height: 10),
            ...todayItems.map(_buildMemoryCard),
            const SizedBox(height: 18),
          ],
          if (allMonthItems.isNotEmpty) ...[
            _buildSectionHeader('THIS MONTH', '${allMonthItems.length} Memories'),
            const SizedBox(height: 10),
            ...visibleMonthItems.map(_buildMemoryCard),
            if (allMonthItems.any((m) => m.extraItem))
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () =>
                        setState(() => _expandThisMonth = !_expandThisMonth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expandThisMonth
                                ? 'Show fewer this month'
                                : '+ $hiddenMonthCount more this month',
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          UlvenikIcon.fromMaterial(
                            _expandThisMonth
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: _stoneGrey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
          if (milestoneItems.isNotEmpty) ...[
            _buildSectionHeader(
                'MILESTONES',
                _selectedCategory == 'All' && _selectedYear == null
                    ? '4 Memories'
                    : '${milestoneItems.length} Memories'),
            const SizedBox(height: 10),
            ...milestoneItems.map(_buildMemoryCard),
            const SizedBox(height: 18),
          ],
          if (achievementItems.isNotEmpty) ...[
            _buildSectionHeader(
                'ACHIEVEMENTS',
                _selectedCategory == 'All' && _selectedYear == null
                    ? '3 Memories'
                    : '${achievementItems.length} Memories'),
            const SizedBox(height: 10),
            ...achievementItems.map(_buildMemoryCard),
            const SizedBox(height: 18),
          ],
          if (y2024.isNotEmpty || all2023.isNotEmpty || all2022.isNotEmpty) ...[
            const Text(
              'PREVIOUS YEARS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 12),
            if (y2024.isNotEmpty) ...[
              const Text(
                '2024',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              ...y2024.map(_buildMemoryCard),
              const SizedBox(height: 10),
            ],
            if (all2023.isNotEmpty) ...[
              const Text(
                '2023',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              ...visible2023.map(_buildMemoryCard),
              if (all2023.any((m) => m.extraItem))
                _buildExpandYearLink(
                  expanded: _expand2023,
                  year: 2023,
                  onTap: () => setState(() => _expand2023 = !_expand2023),
                ),
              const SizedBox(height: 10),
            ],
            if (all2022.isNotEmpty) ...[
              const Text(
                '2022',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              ...visible2022.map(_buildMemoryCard),
              if (all2022.any((m) => m.extraItem))
                _buildExpandYearLink(
                  expanded: _expand2022,
                  year: 2022,
                  onTap: () => setState(() => _expand2022 = !_expand2022),
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildHeroAnniversaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 225,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _heroImageBank[_heroImageIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(color: _carbon),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.12),
                        _carbon.withValues(alpha: 0.78),
                        _carbon,
                      ],
                      stops: const [0.0, 0.62, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: _gold,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'ONE YEAR AGO TODAY',
                            style: TextStyle(
                              color: _gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Murphy's First Off-Lead Recall Session",
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '14 Sep 2025 · Riverside Trail',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Session notes: Murphy completed three off-lead recalls at Riverside Trail (45 mins). Maintained recall response around bird distractions.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TimelineEventDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Open Original Event',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        UlvenikIcon(UlvenikIcons.details, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: GestureDetector(
                    onTap: _showShareMemorySheet,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UlvenikIcon(UlvenikIcons.overflowMenu, color: _mint, size: 15),
                        SizedBox(width: 6),
                        Text(
                          'Share This Memory',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildSectionHeader(String leftLabel, String rightCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftLabel,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        Text(
          rightCount,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryCard(_MemoryItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showMemoryDetailSheet(item),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (item.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: _iconBoxBg,
                          child: UlvenikIcon(UlvenikIcons.play,
                              color: item.categoryColor, size: 22),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _iconBoxBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: UlvenikIcon.fromMaterial(
                      item.icon ?? Icons.flag_outlined,
                      color: item.iconColor ?? item.categoryColor,
                      size: 22,
                    ),
                  ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (item.isMilestoneHeaderIcon)
                            const UlvenikIcon(UlvenikIcons.goals,
                                color: _stoneGrey, size: 12)
                          else ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: item.categoryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.category,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (item.badgeText != null) _buildBadge(item),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.title,
                        maxLines: item.dateLabel == null ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (item.dateLabel != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          item.dateLabel!,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                UlvenikIcon.fromMaterial(
                  item.isBookmarked ? Icons.bookmark : Icons.chevron_right,
                  color: item.isBookmarked ? _gold : _stoneGrey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(_MemoryItem item) {
    Color bg = _iconBoxBg;
    Color border = Colors.transparent;
    Color fg = _stoneGrey;

    if (item.isGoldBadge) {
      bg = _gold.withValues(alpha: 0.14);
      border = _gold.withValues(alpha: 0.55);
      fg = const Color(0xFFE0B129);
    } else if (item.isGreenBadge) {
      bg = _forest.withValues(alpha: 0.22);
      border = _forest.withValues(alpha: 0.55);
      fg = _mint;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        item.badgeText!,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildExpandYearLink({
    required bool expanded,
    required int year,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            expanded ? 'Show fewer from $year' : '+ More from $year',
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionStrip() {
    final textColor =
        _isEmptyState ? _stoneGrey.withValues(alpha: 0.55) : _stoneGrey;
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFF14181B),
        border: Border(
          top: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _isEmptyState
                  ? () => AppSnackbar.show(context,
                      message:
                          'Switch to Populated State in the top ••• menu to filter memories',
                      type: SnackbarType.info)
                  : _showFilterCategoriesSheet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UlvenikIcon(UlvenikIcons.sort, color: textColor, size: 17),
                  const SizedBox(width: 8),
                  Text(
                    _isEmptyState ? 'Filter' : 'Filter Categories',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 22, color: _cardBorder),
          Expanded(
            child: InkWell(
              onTap: _isEmptyState
                  ? () => AppSnackbar.show(context,
                      message:
                          'Switch to Populated State in the top ••• menu to browse years',
                      type: SnackbarType.info)
                  : _showBrowseYearsSheet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UlvenikIcon(UlvenikIcons.calendar,
                      color: textColor, size: 15),
                  const SizedBox(width: 8),
                  Text(
                    _selectedYear != null
                        ? 'Year: $_selectedYear'
                        : 'Browse Years',
                    style: TextStyle(
                      color: textColor,
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
    );
  }

  void _showFilterCategoriesSheet() {
    final categories = [
      'All',
      'TRAINING',
      'GOALS',
      'HEALTH',
      'S&C',
      'MILESTONES',
      if (_hasSportPack) 'COMPETITION',
      'PUPPYHOOD',
    ];
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
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
                'Filter Memory Categories',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final active = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat == 'All' ? 'All Categories' : cat),
                    selected: active,
                    selectedColor: _forest,
                    backgroundColor: _obsidian,
                    labelStyle: TextStyle(
                      color: active ? _offWhite : _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = cat;
                        _isEmptyState = false;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBrowseYearsSheet() {
    final years = [null, 2025, 2024, 2023, 2022];
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
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
                'Browse Memories by Year',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...years.map((yr) {
                final selected = _selectedYear == yr;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: UlvenikIcon(UlvenikIcons.scheduledTraining,
                    color: selected ? _mint : _stoneGrey,
                    size: 20,
                  ),
                  title: Text(
                    yr == null ? 'All Recorded Years (2022–2025)' : '$yr',
                    style: TextStyle(
                      color: selected ? _mint : _offWhite,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  trailing: selected
                      ? const UlvenikIcon(UlvenikIcons.completed, color: _mint, size: 18)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedYear = yr;
                      _isEmptyState = false;
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemoryDetailSheet(_MemoryItem item) {
    final noteCtrl = TextEditingController(text: item.reflectionNote);
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
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
              children: [
                Text(
                  item.category,
                  style: TextStyle(
                    color: item.categoryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: UlvenikIcon.fromMaterial(
                    item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: item.isBookmarked ? _gold : _stoneGrey,
                  ),
                  onPressed: () {
                    setState(() => item.isBookmarked = !item.isBookmarked);
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      message: item.isBookmarked
                          ? 'Memory pinned to keepsakes'
                          : 'Removed from keepsakes',
                      type: SnackbarType.success,
                    );
                  },
                ),
              ],
            ),
            Text(
              item.title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (item.dateLabel != null) ...[
              const SizedBox(height: 4),
              Text(item.dateLabel!,
                  style: const TextStyle(color: _stoneGrey, fontSize: 13)),
            ],
            const SizedBox(height: 8),
            Text(item.subtitle,
                style: const TextStyle(color: _stoneGrey, fontSize: 14)),
            const SizedBox(height: 16),
            TextField(
              controller: noteCtrl,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Personal reflection note',
                labelStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _stoneGrey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _forest),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(
                          () => item.reflectionNote = noteCtrl.text.trim());
                      Navigator.pop(ctx);
                      AppSnackbar.show(context,
                          message: 'Reflection saved to memory',
                          type: SnackbarType.success);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _mint,
                      side: const BorderSide(color: _forest),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Note'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TimelineEventDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Open Original Event'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShareMemorySheet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
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
              const Text(
                'Share Anniversary Memory',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const UlvenikIcon(UlvenikIcons.details, color: _mint),
                title: const Text('Copy Memory Card Link',
                    style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  AppSnackbar.show(context,
                      message: 'Memory link copied to clipboard',
                      type: SnackbarType.success);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const UlvenikIcon(UlvenikIcons.overflowMenu, color: _mint),
                title: const Text('Save Story Card to Device',
                    style: TextStyle(color: _offWhite, fontSize: 14)),
                onTap: () {
                  Navigator.pop(ctx);
                  AppSnackbar.show(context,
                      message: 'Anniversary card exported to Photos',
                      type: SnackbarType.success);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
