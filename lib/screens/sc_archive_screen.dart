import 'package:flutter/material.dart';
import 'sc_settings_screen.dart';

enum ArchiveCategory { activity, equipment, template }

class ArchivedItem {
  final String id;
  final String title;
  final ArchiveCategory category;
  final String archivedAgo;
  final String lastUsedAgo;
  final int linkedSessions;
  final IconData icon;

  const ArchivedItem({
    required this.id,
    required this.title,
    required this.category,
    required this.archivedAgo,
    required this.lastUsedAgo,
    required this.linkedSessions,
    required this.icon,
  });
}

class SCArchiveScreen extends StatefulWidget {
  final bool initialEmpty;

  const SCArchiveScreen({super.key, this.initialEmpty = false});

  @override
  State<SCArchiveScreen> createState() => _SCArchiveScreenState();
}

class _SCArchiveScreenState extends State<SCArchiveScreen>
    with SingleTickerProviderStateMixin {
  // ─── Theme Tokens (Faithful to Figma & Ulvenik Design Tokens) ───────────────
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _forest = Color(0xFF2E6B57);
  static const _mint = Color(0xFF95D3BB);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);
  static const _muted = Color(0xFFBFC9C3);
  static const _errorRed = Color(0xFFFFB4AB);

  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  // ─── Screen State ──────────────────────────────────────────────────────────
  late bool _isEmptyState;

  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Accordion Expand/Collapse State
  bool _activitiesExpanded = true;
  bool _equipmentExpanded = true;
  bool _templatesExpanded = false; // Collapsed by default as in Figma Screenshot 1

  // Chart Animation
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;
  int _touchedChartIndex = -1;

  // Archive Items Data
  late List<ArchivedItem> _items;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _resetDemoData();

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  void _resetDemoData() {
    _items = [
      // Activities
      const ArchivedItem(
        id: 'act-1',
        title: 'Treadmill Intervals',
        category: ArchiveCategory.activity,
        archivedAgo: 'Archived 12 days ago',
        lastUsedAgo: 'Last used 3 weeks ago',
        linkedSessions: 14,
        icon: Icons.directions_run,
      ),
      const ArchivedItem(
        id: 'act-2',
        title: 'Underwater Treadmill',
        category: ArchiveCategory.activity,
        archivedAgo: 'Archived 5 days ago',
        lastUsedAgo: 'Last used 1 month ago',
        linkedSessions: 6,
        icon: Icons.water,
      ),
      // Equipment
      const ArchivedItem(
        id: 'eq-1',
        title: 'Resistance Bands Set',
        category: ArchiveCategory.equipment,
        archivedAgo: 'Archived 3 weeks ago',
        lastUsedAgo: 'Last used 2 months ago',
        linkedSessions: 9,
        icon: Icons.fitness_center,
      ),
      const ArchivedItem(
        id: 'eq-2',
        title: 'Wobble Board',
        category: ArchiveCategory.equipment,
        archivedAgo: 'Archived 1 month ago',
        lastUsedAgo: 'Last used 6 weeks ago',
        linkedSessions: 4,
        icon: Icons.balance,
      ),
      // Session Templates
      const ArchivedItem(
        id: 'tmpl-1',
        title: 'Agility Ladder Warm-Up',
        category: ArchiveCategory.template,
        archivedAgo: 'Archived 2 weeks ago',
        lastUsedAgo: 'Last used 1 month ago',
        linkedSessions: 11,
        icon: Icons.view_headline,
      ),
      const ArchivedItem(
        id: 'tmpl-2',
        title: 'Hill Sprints Explosive Block',
        category: ArchiveCategory.template,
        archivedAgo: 'Archived 1 month ago',
        lastUsedAgo: 'Last used 2 months ago',
        linkedSessions: 8,
        icon: Icons.trending_up,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chartAnimController.dispose();
    super.dispose();
  }

  // ─── Filtered Lists ────────────────────────────────────────────────────────
  List<ArchivedItem> _getItemsForCategory(ArchiveCategory category) {
    return _items.where((item) {
      if (item.category != category) return false;
      if (_searchQuery.isEmpty) return true;
      return item.title.toLowerCase().contains(_searchQuery) ||
          item.archivedAgo.toLowerCase().contains(_searchQuery) ||
          item.lastUsedAgo.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // ─── Interactive Actions: Restore & Permanent Delete ───────────────────────

  void _handleRestore(ArchivedItem item) {
    setState(() {
      _items.removeWhere((i) => i.id == item.id);
      if (_items.isEmpty) {
        _isEmptyState = true;
      }
    });
  }

  void _confirmDeletePermanently(ArchivedItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: _errorRed, size: 24),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Delete Permanently?',
                style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete "${item.title}"?\n\nThis will remove historical links to ${item.linkedSessions} sessions and cannot be undone.',
          style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF690005),
              foregroundColor: _errorRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _items.removeWhere((i) => i.id == item.id);
                if (_items.isEmpty) {
                  _isEmptyState = true;
                }
              });
            },
            child: const Text('Delete Permanently', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _restoreAll() {
    if (_items.isEmpty) return;
    setState(() {
      _items.clear();
      _isEmptyState = true;
    });
  }

  void _emptyArchive() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Empty Entire Archive?',
          style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will permanently delete all archived activities, equipment, and session templates.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF690005),
              foregroundColor: _errorRed,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _items.clear();
                _isEmptyState = true;
              });
            },
            child: const Text('Empty Archive', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Build Method ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(
          bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: GestureDetector(
          onDoubleTap: () {
            setState(() => _isEmptyState = !_isEmptyState);
          },
          child: const Text(
            'Archive',
            style: TextStyle(
              color: _mint,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          // Quick Toggle Complete Empty State vs Populated State Button
          IconButton(
            tooltip: _isEmptyState
                ? 'Switch to Populated Archive'
                : 'Switch to Empty Archive',
            icon: Icon(
              _isEmptyState ? Icons.inventory_2_outlined : Icons.inventory_2,
              color: _mint,
              size: 22,
            ),
            onPressed: () {
              setState(() => _isEmptyState = !_isEmptyState);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _stoneGrey),
            tooltip: 'Options',
            color: _carbon,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'toggle') {
                setState(() => _isEmptyState = !_isEmptyState);
              } else if (val == 'restore_all') {
                _restoreAll();
              } else if (val == 'empty_all') {
                _emptyArchive();
              } else if (val == 'reset') {
                setState(() {
                  _resetDemoData();
                  _isEmptyState = false;
                  _activitiesExpanded = true;
                  _equipmentExpanded = true;
                  _templatesExpanded = false;
                  _searchController.clear();
                });
              } else if (val == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCSettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      _isEmptyState ? Icons.visibility : Icons.visibility_off,
                      color: _mint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEmptyState ? 'View Populated State' : 'View Empty State',
                      style: const TextStyle(color: _offWhite, fontSize: 13),
                    ),
                  ],
                ),
              ),
              if (!_isEmptyState && _items.isNotEmpty) ...[
                const PopupMenuItem(
                  value: 'restore_all',
                  child: Row(
                    children: [
                      Icon(Icons.unarchive_outlined, color: _mint, size: 18),
                      SizedBox(width: 10),
                      Text('Restore All Items', style: TextStyle(color: _offWhite, fontSize: 13)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'empty_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_outlined, color: _errorRed, size: 18),
                      SizedBox(width: 10),
                      Text('Empty Entire Archive', style: TextStyle(color: _errorRed, fontSize: 13)),
                    ],
                  ),
                ),
              ],
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Reset Demo Data', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('S & C Settings', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // Clean separation of full-screen states
      body: _isEmptyState
          ? _buildEmptyStateView()
          : _buildPopulatedStateView(),
    );
  }

  // ===========================================================================
  // STATE 1: COMPLETE POPULATED STATE VIEW (Screenshot 1 / Figma Frame 2)
  // ===========================================================================

  Widget _buildPopulatedStateView() {
    final activityItems = _getItemsForCategory(ArchiveCategory.activity);
    final equipmentItems = _getItemsForCategory(ArchiveCategory.equipment);
    final templateItems = _getItemsForCategory(ArchiveCategory.template);

    final totalVisible = activityItems.length + equipmentItems.length + templateItems.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Search Bar ────────────────────────────────────────────────────
          _buildSearchBar(),
          const SizedBox(height: 20),

          // ─── Optional Animated Analytics Card ──────────────────────────────
          _buildInteractiveArchiveChart(),
          const SizedBox(height: 24),

          // If search yielded no results across all sections
          if (_searchQuery.isNotEmpty && totalVisible == 0) ...[
            _buildNoSearchResults(),
          ] else ...[
            // ─── Section 1: Activities ───────────────────────────────────────
            _buildCategorySection(
              title: 'Activities',
              items: activityItems,
              isExpanded: _activitiesExpanded,
              onToggle: () {
                setState(() => _activitiesExpanded = !_activitiesExpanded);
              },
            ),
            const SizedBox(height: 20),

            // ─── Section 2: Equipment ────────────────────────────────────────
            _buildCategorySection(
              title: 'Equipment',
              items: equipmentItems,
              isExpanded: _equipmentExpanded,
              onToggle: () {
                setState(() => _equipmentExpanded = !_equipmentExpanded);
              },
            ),
            const SizedBox(height: 20),

            // ─── Section 3: Session Templates ────────────────────────────────
            _buildCategorySection(
              title: 'Session Templates',
              items: templateItems,
              badgeSuffix: 'items',
              isExpanded: _templatesExpanded,
              onToggle: () {
                setState(() => _templatesExpanded = !_templatesExpanded);
              },
            ),
          ],
        ],
      ),
    );
  }

  // ─── SEARCH BAR ────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _offWhite, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _stoneGrey, size: 18),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          hintText: 'Search archived items...',
          hintStyle: const TextStyle(color: _stoneGrey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ─── ANIMATED ARCHIVE CHART ────────────────────────────────────────────────

  Widget _buildInteractiveArchiveChart() {
    final actCount = _getItemsForCategory(ArchiveCategory.activity).length;
    final eqCount = _getItemsForCategory(ArchiveCategory.equipment).length;
    final tmplCount = _getItemsForCategory(ArchiveCategory.template).length;
    final totalCount = actCount + eqCount + tmplCount;

    if (totalCount == 0) return const SizedBox.shrink();

    final dataList = [
      {'label': 'Activities', 'count': actCount, 'color': _mint},
      {'label': 'Equipment', 'count': eqCount, 'color': _forest},
      {'label': 'Templates', 'count': tmplCount, 'color': const Color(0xFF5D8FAF)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: _mint, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'ARCHIVE RETENTION IMPACT',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Text(
                '$totalCount items preserved',
                style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Historical logs and telemetry remain linked to session graphs.',
            style: TextStyle(color: _stoneGrey, fontSize: 12),
          ),
          const SizedBox(height: 14),

          // Horizontal Animated Breakdown Bar
          AnimatedBuilder(
            animation: _chartProgress,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: dataList.map((d) {
                      final count = d['count'] as int;
                      final flex = ((count / totalCount) * 100 * _chartProgress.value).toInt();
                      if (flex <= 0) return const SizedBox.shrink();

                      return Expanded(
                        flex: flex,
                        child: Container(color: d['color'] as Color),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          // Interactive legend pills
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: dataList.asMap().entries.map((entry) {
              final idx = entry.key;
              final d = entry.value;
              final isSelected = _touchedChartIndex == idx;

              return InkWell(
                onTap: () {
                  setState(() {
                    _touchedChartIndex = isSelected ? -1 : idx;
                  });
                },
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? _forest.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(9999),
                    border: isSelected ? Border.all(color: _mint, width: 1) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: d['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${d['label']} (${d['count']})',
                        style: TextStyle(
                          color: isSelected ? _mint : _offWhite,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── ACCORDION SECTION ─────────────────────────────────────────────────────

  Widget _buildCategorySection({
    required String title,
    required List<ArchivedItem> items,
    required bool isExpanded,
    required VoidCallback onToggle,
    String? badgeSuffix,
  }) {
    final countLabel = badgeSuffix != null ? '${items.length} $badgeSuffix' : '${items.length}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row with Badge & Animated Chevron
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(9999),
                        border: _hairlineBorder,
                      ),
                      child: Text(
                        countLabel,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more,
                    color: _muted,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Animated expansion container
        AnimatedCrossFade(
          firstChild: Column(
            children: items.map((item) => _buildArchiveCard(item)).toList(),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  // ─── CARD WIDGET (Matching Figma Frame 2 exactly) ──────────────────────────

  Widget _buildArchiveCard(ArchivedItem item) {
    final catHeader = switch (item.category) {
      ArchiveCategory.activity => 'ACTIVITY',
      ArchiveCategory.equipment => 'EQUIPMENT',
      ArchiveCategory.template => 'SESSION TEMPLATE',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Circular Avatar + Metadata + Archive Box Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with circle border & mint icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2825),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _forest.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(item.icon, color: _mint, size: 20),
                ),
              ),
              const SizedBox(width: 12),

              // Title & Timestamps
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catHeader,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.08,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.archivedAgo} · ${item.lastUsedAgo} · Linked to ${item.linkedSessions} sessions',
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Archive Box Icon on right
              const Icon(
                Icons.inventory_2_outlined,
                color: _stoneGrey,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Divider
          const Divider(height: 1, color: Color(0x14FFFFFF)),
          const SizedBox(height: 12),

          // Bottom Action Row: Delete Permanently + Restore
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _confirmDeletePermanently(item),
                child: const Text(
                  'Delete Permanently',
                  style: TextStyle(
                    color: _errorRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _mint,
                  side: const BorderSide(color: _forest, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _handleRestore(item),
                child: const Text(
                  'Restore',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.search_off, color: _stoneGrey, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No archived items found',
              style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'No items matching "$_searchQuery"',
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _searchController.clear(),
              child: const Text('Clear Search', style: TextStyle(color: _mint)),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // STATE 2: COMPLETE EMPTY STATE VIEW (Screenshot 2 / Figma Frame 1)
  // ===========================================================================

  Widget _buildEmptyStateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large circular icon container with download/archive icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2825),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _forest.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.archive_outlined,
                  color: _mint,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Title
            const Text(
              'Archive is Empty',
              style: TextStyle(
                color: _offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            const SizedBox(
              width: 320,
              child: Text(
                'You don\'t have any archived Strength & Conditioning items. Archive activities, equipment or templates to store them here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // "Return to Dashboard" Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _carbon,
                foregroundColor: _offWhite,
                elevation: 0,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text(
                'Return to Dashboard',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            const SizedBox(height: 18),

            // Demo Shortcut to Populated State
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: _mint),
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text(
                'View Populated State (Demo Data)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                setState(() {
                  _resetDemoData();
                  _isEmptyState = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience alias
typedef ArchiveScreen = SCArchiveScreen;
