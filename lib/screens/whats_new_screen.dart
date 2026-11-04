import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _ReleaseCategoryBlock {
  final String title;
  final IconData icon;
  final List<String> items;

  const _ReleaseCategoryBlock({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class _ReleaseEntry {
  final String version;
  final String date;
  final String summary;
  final bool isLatest;
  final List<_ReleaseCategoryBlock> sections;

  const _ReleaseEntry({
    required this.version,
    required this.date,
    required this.summary,
    this.isLatest = false,
    required this.sections,
  });
}

class WhatsNewScreen extends StatefulWidget {
  const WhatsNewScreen({super.key});

  @override
  State<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends State<WhatsNewScreen> {
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _statusGreen = Color(0xFF479878);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _selectedCategoryFilter = 'All';
  bool _showFilterBar = false;
  bool _isCheckingUpdates = false;
  String _lastCheckedLabel = "You're using the latest version of Ulvenik.";

  // Version 1.0.1 is expanded by default per Figma design.
  final Set<String> _expandedVersions = {'1.0.1'};
  final Map<String, String> _reactionsByVersion = {};
  final Set<String> _acknowledgedVersions = {'1.2.0'};

  static const List<String> _categoryFilters = [
    'All',
    'New Features',
    'Improvements',
    'Bug Fixes',
    'Other Changes',
  ];

  static const _ReleaseEntry _latestRelease = _ReleaseEntry(
    version: '1.2.0',
    date: '15 Sep 2026',
    isLatest: true,
    summary:
        'This update introduces Training Templates, faster media loading, improved offline syncing and several performance improvements across the app.',
    sections: [
      _ReleaseCategoryBlock(
        title: 'NEW FEATURES',
        icon: Icons.auto_awesome_outlined,
        items: [
          'Reusable Training Templates for structured weekly sessions',
          'Quick-apply warmup and cooldown blocks across multiple dogs',
          'Smart offline queue indicator for rural field training',
        ],
      ),
      _ReleaseCategoryBlock(
        title: 'IMPROVEMENTS',
        icon: Icons.arrow_upward_rounded,
        items: [
          'Up to 40% faster high-resolution video thumbnail rendering',
          'Improved background delta sync when reconnecting to Wi-Fi',
          'Refined Timeline Insights and filter responsiveness',
        ],
      ),
      _ReleaseCategoryBlock(
        title: 'BUG FIXES',
        icon: Icons.bug_report_outlined,
        items: [
          'Resolved occasional delay when switching dog workspaces',
          'Fixed session timer drift during long outdoor tracking logs',
        ],
      ),
    ],
  );

  static const List<_ReleaseEntry> _previousReleases = [
    _ReleaseEntry(
      version: '1.1.0',
      date: '12 Aug 2026',
      summary:
          'Introduced Health Dashboard, improved Statistics page and fixed several sync issues.',
      sections: [
        _ReleaseCategoryBlock(
          title: 'NEW FEATURES',
          icon: Icons.auto_awesome_outlined,
          items: [
            'Comprehensive Health Dashboard with vaccination & weight tracking',
            'Interactive multi-week training volume comparisons in Statistics',
          ],
        ),
        _ReleaseCategoryBlock(
          title: 'IMPROVEMENTS',
          icon: Icons.arrow_upward_rounded,
          items: [
            'Streamlined session logging flow with fewer taps',
            'Clearer milestone badges across Dog Profiles',
          ],
        ),
        _ReleaseCategoryBlock(
          title: 'BUG FIXES',
          icon: Icons.bug_report_outlined,
          items: [
            'Fixed cloud sync conflict resolution for edited health records',
            'Resolved calendar week boundary alignment for Monday-start locales',
          ],
        ),
      ],
    ),
    _ReleaseEntry(
      version: '1.0.1',
      date: '3 Jul 2026',
      summary: 'Bug fix release addressing notification and media issues.',
      sections: [
        _ReleaseCategoryBlock(
          title: 'NEW FEATURES',
          icon: Icons.auto_awesome_outlined,
          items: [
            'Added Custom Reminder Schedules',
            'Introduced Monthly Progress Summary',
          ],
        ),
        _ReleaseCategoryBlock(
          title: 'IMPROVEMENTS',
          icon: Icons.arrow_upward_rounded,
          items: [
            'Faster Timeline loading',
            'Improved video upload performance',
            'Enhanced offline syncing',
          ],
        ),
        _ReleaseCategoryBlock(
          title: 'BUG FIXES',
          icon: Icons.bug_report_outlined,
          items: [
            'Fixed duplicate reminder notifications',
            'Resolved media playback issue on older devices',
            'Corrected statistics calculation errors',
          ],
        ),
        _ReleaseCategoryBlock(
          title: 'OTHER CHANGES',
          icon: Icons.build_outlined,
          items: [
            'Security improvements and maintenance updates',
          ],
        ),
      ],
    ),
    _ReleaseEntry(
      version: '1.0.0',
      date: '1 Jun 2026',
      summary: 'Initial release of Ulvenik.',
      sections: [
        _ReleaseCategoryBlock(
          title: 'NEW FEATURES',
          icon: Icons.auto_awesome_outlined,
          items: [
            'Multi-dog workspace profiles for handlers and trainers',
            'Structured Training Logs, Skills Library, and Goal Tracking',
            'Unified Dog Timeline with media attachments and milestones',
          ],
        ),
        _ReleaseCategoryBlock(
          title: 'OTHER CHANGES',
          icon: Icons.build_outlined,
          items: [
            'Foundation security architecture and encrypted cloud backup',
          ],
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool _matchesRelease(_ReleaseEntry entry) {
    final q = _searchQuery.trim().toLowerCase();
    final filterCat = _selectedCategoryFilter.toUpperCase();

    final hasCategory = _selectedCategoryFilter == 'All' ||
        entry.sections.any((s) => s.title == filterCat);
    if (!hasCategory) return false;

    if (q.isEmpty) return true;
    if (entry.version.toLowerCase().contains(q) ||
        entry.date.toLowerCase().contains(q) ||
        entry.summary.toLowerCase().contains(q)) {
      return true;
    }
    for (final sec in entry.sections) {
      if (sec.title.toLowerCase().contains(q)) return true;
      for (final item in sec.items) {
        if (item.toLowerCase().contains(q)) return true;
      }
    }
    return false;
  }

  List<_ReleaseCategoryBlock> _filteredSectionsFor(_ReleaseEntry entry) {
    final q = _searchQuery.trim().toLowerCase();
    final filterCat = _selectedCategoryFilter.toUpperCase();

    return entry.sections.where((sec) {
      if (_selectedCategoryFilter != 'All' && sec.title != filterCat) {
        return false;
      }
      if (q.isEmpty) return true;
      if (entry.version.toLowerCase().contains(q) ||
          entry.summary.toLowerCase().contains(q) ||
          sec.title.toLowerCase().contains(q)) {
        return true;
      }
      return sec.items.any((item) => item.toLowerCase().contains(q));
    }).toList();
  }

  void _toggleExpanded(String version) {
    setState(() {
      if (_expandedVersions.contains(version)) {
        _expandedVersions.remove(version);
      } else {
        _expandedVersions.add(version);
      }
    });
  }

  void _toggleReaction(String version, String label) {
    setState(() {
      if (_reactionsByVersion[version] == label) {
        _reactionsByVersion.remove(version);
      } else {
        _reactionsByVersion[version] = label;
      }
    });
    AppSnackbar.show(
      context,
      title: 'Feedback Recorded',
      message: _reactionsByVersion[version] != null
          ? 'Marked Version $version as "$label".'
          : 'Removed reaction for Version $version.',
      type: SnackbarType.success,
    );
  }

  Future<void> _checkForUpdates() async {
    if (_isCheckingUpdates) return;
    setState(() {
      _isCheckingUpdates = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      _isCheckingUpdates = false;
      _lastCheckedLabel = "You're using the latest version of Ulvenik.";
    });
    AppSnackbar.show(
      context,
      title: 'Up to Date',
      message: 'Ulvenik 1.2.0 (Build 1204) is the latest release.',
      type: SnackbarType.info,
    );
  }

  void _openReleaseDetailsSheet(_ReleaseEntry release) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final currentReaction = _reactionsByVersion[release.version];
            final isAck = _acknowledgedVersions.contains(release.version);

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.84,
              ),
              decoration: const BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTextStoneGrey
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_outlined,
                            color: _mint,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Version ${release.version}',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: AppColors.primaryTextOffWhite,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (release.isLatest) ...[
                                      const SizedBox(width: 8),
                                      _buildCurrentBadge(),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Released ${release.date}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final buffer = StringBuffer()
                                ..writeln(
                                    'Ulvenik Version ${release.version} (${release.date})')
                                ..writeln(release.summary);
                              for (final s in release.sections) {
                                buffer.writeln('\n${s.title}:');
                                for (final item in s.items) {
                                  buffer.writeln('- $item');
                                }
                              }
                              Clipboard.setData(
                                ClipboardData(text: buffer.toString()),
                              );
                              AppSnackbar.show(
                                context,
                                title: 'Copied',
                                message:
                                    'Version ${release.version} notes copied to clipboard.',
                                type: SnackbarType.success,
                              );
                            },
                            tooltip: 'Copy release notes',
                            icon: const Icon(
                              Icons.copy_rounded,
                              color: AppColors.secondaryTextStoneGrey,
                              size: 19,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(sheetCtx).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.secondaryTextStoneGrey,
                              size: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              release.summary,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ...release.sections.map(_buildCategorySection),
                            const SizedBox(height: 8),
                            const Divider(
                              height: 24,
                              color: AppColors.cardBorder,
                            ),
                            const Text(
                              'FEEDBACK & ACKNOWLEDGEMENT',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.7,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final option in const [
                                  'Helpful',
                                  'Great Update',
                                  'Performance Boost',
                                ])
                                  _buildReactionChip(
                                    label: option,
                                    selected: currentReaction == option,
                                    onTap: () {
                                      _toggleReaction(release.version, option);
                                      setModalState(() {});
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    if (isAck) {
                                      _acknowledgedVersions
                                          .remove(release.version);
                                    } else {
                                      _acknowledgedVersions
                                          .add(release.version);
                                    }
                                  });
                                  setModalState(() {});
                                },
                                icon: Icon(
                                  isAck
                                      ? Icons.check_circle_rounded
                                      : Icons.check_circle_outline_rounded,
                                  size: 18,
                                  color: _mint,
                                ),
                                label: Text(
                                  isAck
                                      ? 'Release Notes Acknowledged'
                                      : 'Acknowledge Release Notes',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: _mint,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.primaryForestGreen
                                      .withValues(alpha: 0.2),
                                  side: BorderSide(
                                    color: AppColors.primaryForestGreen
                                        .withValues(alpha: 0.5),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReactionChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryForestGreen.withValues(alpha: 0.25)
              : AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _mint.withValues(alpha: 0.55)
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons.thumb_up_alt_rounded
                  : Icons.thumb_up_off_alt_outlined,
              size: 14,
              color: selected ? _mint : AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                color: selected ? _mint : AppColors.secondaryTextStoneGrey,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryForestGreen.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryForestGreen.withValues(alpha: 0.45),
        ),
      ),
      child: const Text(
        'CURRENT',
        style: TextStyle(
          fontFamily: 'Inter',
          color: _mint,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFiltering =
        _searchQuery.trim().isNotEmpty || _selectedCategoryFilter != 'All';
    final bool showLatest = _matchesRelease(_latestRelease);
    final List<_ReleaseEntry> visiblePrevious =
        _previousReleases.where(_matchesRelease).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundObsidian,
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 26,
                      ),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 2),
                    const Expanded(
                      child: Text(
                        "What's New",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showFilterBar = !_showFilterBar;
                        });
                        if (_showFilterBar) {
                          _searchFocusNode.requestFocus();
                        } else {
                          _searchFocusNode.unfocus();
                        }
                      },
                      tooltip: 'Search & Filter Releases',
                      icon: Icon(
                        Icons.search,
                        color: (_showFilterBar || isFiltering)
                            ? _mint
                            : AppColors.secondaryTextStoneGrey,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLatest) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LATEST RELEASE',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  _buildCurrentBadge(),
                ],
              ),
              const SizedBox(height: 10),
              _buildLatestReleaseCard(),
              const SizedBox(height: 16),
            ],
            _buildSearchBox(),
            if (_showFilterBar || _selectedCategoryFilter != 'All') ...[
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categoryFilters.map((cat) {
                    final selected = _selectedCategoryFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryFilter = cat;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryForestGreen
                                    .withValues(alpha: 0.24)
                                : AppColors.cardsCarbon,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? _mint.withValues(alpha: 0.5)
                                  : AppColors.cardBorder,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: selected
                                  ? _mint
                                  : AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PREVIOUS RELEASES',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                if (isFiltering)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _selectedCategoryFilter = 'All';
                      });
                    },
                    child: const Text(
                      'Reset filter',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (visiblePrevious.isEmpty && !showLatest)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.manage_search_rounded,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 30,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No matching release notes found',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Try searching a different version number or feature keyword.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...visiblePrevious.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildPreviousReleaseCard(entry, isFiltering),
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'YOUR VERSION',
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            _buildYourVersionCard(),
          ],
        ),
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildLatestReleaseCard() {
    final reaction = _reactionsByVersion[_latestRelease.version];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome_outlined,
                color: _mint,
                size: 19,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Version ${_latestRelease.version}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Text(
                _latestRelease.date,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _latestRelease.summary,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (reaction != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Your feedback: $reaction',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: _mint,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _openReleaseDetailsSheet(_latestRelease),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.45),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: _mint,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: _mint,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.secondaryTextStoneGrey,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.primaryTextOffWhite,
                fontSize: 14,
              ),
              cursorColor: _mint,
              decoration: const InputDecoration(
                hintText: 'Search Release Notes',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.secondaryTextStoneGrey,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviousReleaseCard(_ReleaseEntry entry, bool forceExpanded) {
    final bool isExpanded =
        forceExpanded || _expandedVersions.contains(entry.version);
    final sections = _filteredSectionsFor(entry);
    final reaction = _reactionsByVersion[entry.version];

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _toggleExpanded(entry.version),
            onLongPress: () => _openReleaseDetailsSheet(entry),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Version ${entry.version}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Text(
                        entry.date,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.summary,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                  if (isExpanded && sections.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const SizedBox(height: 16),
                    ...sections.map(_buildCategorySection),
                    if (reaction != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Feedback: $reaction',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: _mint,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(_ReleaseCategoryBlock section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                section.icon,
                color: AppColors.secondaryTextStoneGrey,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                section.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...section.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: SizedBox(
                      width: 4,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTextStoneGrey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        height: 1.42,
                      ),
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

  Widget _buildYourVersionCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Installed Version',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '1.2.0',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Latest Version',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '1.2.0',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          InkWell(
            onTap: _checkForUpdates,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              color: AppColors.primaryForestGreen.withValues(alpha: 0.13),
              child: Row(
                children: [
                  if (_isCheckingUpdates)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_statusGreen),
                      ),
                    )
                  else
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: _statusGreen,
                      size: 18,
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isCheckingUpdates
                          ? 'Checking for updates...'
                          : _lastCheckedLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: _statusGreen,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
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
}
