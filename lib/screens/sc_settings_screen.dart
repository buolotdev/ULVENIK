import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Strength & Conditioning Settings Screen
/// Implements Line 162 in Ulvenik_Frontend_Handover.md (Batch 5 final screen).
/// Matches Figma Frame & Stitch design with 100% fidelity.
class SCSettingsScreen extends StatefulWidget {
  const SCSettingsScreen({super.key});

  @override
  State<SCSettingsScreen> createState() => _SCSettingsScreenState();
}

class _SCSettingsScreenState extends State<SCSettingsScreen>
    with SingleTickerProviderStateMixin {
  // ─── Design Tokens ──────────────────────────────────────────────────────────
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _checkboxBlue = Color(0xFF1A73E8);
  static const Color _errorRed = Color(0xFFCC5050);
  static const Color _errorBorder = Color(0x668B3A3A);
  static const BorderSide _hairlineSide =
      BorderSide(color: Color(0x14FFFFFF), width: 1);

  // ─── Settings State ────────────────────────────────────────────────────────
  String _defaultActivity = 'None selected';
  String _defaultSessionRating = 'Not set';
  bool _autoSaveDrafts = true;
  bool _autoAttachLocation = false;
  bool _autoRecordWeather = false;

  String _defaultSortOrder = 'Alphabetical';
  String _defaultFilter = 'All Activities';
  bool _showArchivedActivities = false;
  bool _displayFavoritesFirst = true;

  String _defaultDateRange = 'Last 30 Days';
  bool _showInsightsOnDashboard = true;
  bool _showMilestones = true;
  bool _animateCharts = true;

  // Chart Interactive Preview State
  bool _showChartPreview = true;
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgressAnim;
  int _selectedChartPoint = -1;

  // Save State
  bool _isSavedRecently = false;

  // Initial State Snapshot to detect changes
  static const Map<String, dynamic> _defaults = {
    'defaultActivity': 'None selected',
    'defaultSessionRating': 'Not set',
    'autoSaveDrafts': true,
    'autoAttachLocation': false,
    'autoRecordWeather': false,
    'defaultSortOrder': 'Alphabetical',
    'defaultFilter': 'All Activities',
    'showArchivedActivities': false,
    'displayFavoritesFirst': true,
    'defaultDateRange': 'Last 30 Days',
    'showInsightsOnDashboard': true,
    'showMilestones': true,
    'animateCharts': true,
  };

  late Map<String, dynamic> _savedSnapshot;

  bool get _hasUnsavedChanges {
    return _defaultActivity != _savedSnapshot['defaultActivity'] ||
        _defaultSessionRating != _savedSnapshot['defaultSessionRating'] ||
        _autoSaveDrafts != _savedSnapshot['autoSaveDrafts'] ||
        _autoAttachLocation != _savedSnapshot['autoAttachLocation'] ||
        _autoRecordWeather != _savedSnapshot['autoRecordWeather'] ||
        _defaultSortOrder != _savedSnapshot['defaultSortOrder'] ||
        _defaultFilter != _savedSnapshot['defaultFilter'] ||
        _showArchivedActivities != _savedSnapshot['showArchivedActivities'] ||
        _displayFavoritesFirst != _savedSnapshot['displayFavoritesFirst'] ||
        _defaultDateRange != _savedSnapshot['defaultDateRange'] ||
        _showInsightsOnDashboard != _savedSnapshot['showInsightsOnDashboard'] ||
        _showMilestones != _savedSnapshot['showMilestones'] ||
        _animateCharts != _savedSnapshot['animateCharts'];
  }

  @override
  void initState() {
    super.initState();
    _savedSnapshot = Map<String, dynamic>.from(_defaults);

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartProgressAnim = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    if (_animateCharts) {
      _chartAnimController.forward();
    } else {
      _chartAnimController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    setState(() {
      _savedSnapshot = {
        'defaultActivity': _defaultActivity,
        'defaultSessionRating': _defaultSessionRating,
        'autoSaveDrafts': _autoSaveDrafts,
        'autoAttachLocation': _autoAttachLocation,
        'autoRecordWeather': _autoRecordWeather,
        'defaultSortOrder': _defaultSortOrder,
        'defaultFilter': _defaultFilter,
        'showArchivedActivities': _showArchivedActivities,
        'displayFavoritesFirst': _displayFavoritesFirst,
        'defaultDateRange': _defaultDateRange,
        'showInsightsOnDashboard': _showInsightsOnDashboard,
        'showMilestones': _showMilestones,
        'animateCharts': _animateCharts,
      };
      _isSavedRecently = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSavedRecently = false);
      }
    });
  }

  void _resetToDefaults() {
    setState(() {
      _defaultActivity = _defaults['defaultActivity'] as String;
      _defaultSessionRating = _defaults['defaultSessionRating'] as String;
      _autoSaveDrafts = _defaults['autoSaveDrafts'] as bool;
      _autoAttachLocation = _defaults['autoAttachLocation'] as bool;
      _autoRecordWeather = _defaults['autoRecordWeather'] as bool;

      _defaultSortOrder = _defaults['defaultSortOrder'] as String;
      _defaultFilter = _defaults['defaultFilter'] as String;
      _showArchivedActivities = _defaults['showArchivedActivities'] as bool;
      _displayFavoritesFirst = _defaults['displayFavoritesFirst'] as bool;

      _defaultDateRange = _defaults['defaultDateRange'] as String;
      _showInsightsOnDashboard = _defaults['showInsightsOnDashboard'] as bool;
      _showMilestones = _defaults['showMilestones'] as bool;
      _animateCharts = _defaults['animateCharts'] as bool;

      if (_animateCharts) {
        _chartAnimController.reset();
        _chartAnimController.forward();
      }
    });
  }

  // ─── Modal Pickers ─────────────────────────────────────────────────────────

  void _pickDefaultActivity() {
    final activities = [
      'None selected',
      'Treadmill Sprint & Trot',
      'Hill Sprints (Interval)',
      'Balance Pad & Core Stability',
      'Agility Weave Poles',
      'Swim Sprint Conditioning',
      'Cavaletti Rail Footing',
      'Resistance Band Pulling',
      'Plyometric Box Jumps',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
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
                    'SELECT DEFAULT ACTIVITY',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: activities.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0x14FFFFFF), height: 1),
                    itemBuilder: (c, idx) {
                      final item = activities[idx];
                      final isSelected = item == _defaultActivity;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? _mint : _offWhite,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: _mint, size: 18)
                            : null,
                        onTap: () {
                          setState(() => _defaultActivity = item);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickDefaultRating() {
    final ratings = [
      'Not set',
      '★ 1 - Low Energy',
      '★★ 2 - Fair Response',
      '★★★ 3 - Standard Workout',
      '★★★★ 4 - High Performance',
      '★★★★★ 5 - Peak Record (PR)',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
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
                    'DEFAULT SESSION RATING',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: ratings.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0x14FFFFFF), height: 1),
                    itemBuilder: (c, idx) {
                      final item = ratings[idx];
                      final isSelected = item.startsWith(_defaultSessionRating) ||
                          item == _defaultSessionRating;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? _mint : _offWhite,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: _mint, size: 18)
                            : null,
                        onTap: () {
                          setState(() {
                            _defaultSessionRating =
                                idx == 0 ? 'Not set' : item.split(' - ')[0];
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickSortOrder() {
    final sortOptions = [
      'Alphabetical',
      'Most Recent',
      'Most Frequently Used',
      'Highest Intensity',
      'Lowest Intensity',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
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
                    'DEFAULT ACTIVITY SORT ORDER',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sortOptions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0x14FFFFFF), height: 1),
                    itemBuilder: (c, idx) {
                      final item = sortOptions[idx];
                      final isSelected = item == _defaultSortOrder;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? _mint : _offWhite,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: _mint, size: 18)
                            : null,
                        onTap: () {
                          setState(() => _defaultSortOrder = item);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickDefaultFilter() {
    final filterOptions = [
      'All Activities',
      'Strength & Conditioning',
      'Cardio & Endurance',
      'Agility & Footwork',
      'Recovery & Mobility',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
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
                    'DEFAULT FILTER',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filterOptions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0x14FFFFFF), height: 1),
                    itemBuilder: (c, idx) {
                      final item = filterOptions[idx];
                      final isSelected = item == _defaultFilter;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? _mint : _offWhite,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: _mint, size: 18)
                            : null,
                        onTap: () {
                          setState(() => _defaultFilter = item);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickDateRange() {
    final rangeOptions = [
      'Last 7 Days',
      'Last 14 Days',
      'Last 30 Days',
      'Last 90 Days',
      'This Year',
      'All Time',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
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
                    'DEFAULT STATISTICS DATE RANGE',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: rangeOptions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Color(0x14FFFFFF), height: 1),
                    itemBuilder: (c, idx) {
                      final item = rangeOptions[idx];
                      final isSelected = item == _defaultDateRange;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? _mint : _offWhite,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: _mint, size: 18)
                            : null,
                        onTap: () {
                          setState(() {
                            _defaultDateRange = item;
                            if (_animateCharts) {
                              _chartAnimController.reset();
                              _chartAnimController.forward();
                            }
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmResetDialog() {
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
                'Reset S & C Settings?',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'This will restore all Strength & Conditioning preferences to their default settings.\n\nYour sessions, activities, and templates are never affected.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _resetToDefaults();
            },
            child: const Text('Reset Settings',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Custom Figma Checkbox Widget ───────────────────────────────────────────

  Widget _buildFigmaCheckbox(bool isChecked) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isChecked ? _checkboxBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isChecked ? _checkboxBlue : const Color(0xFF89938E),
          width: 1.5,
        ),
      ),
      child: isChecked
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }

  // ─── Build Method ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final canSave = _hasUnsavedChanges;

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
          icon: const Icon(Icons.arrow_back, color: _offWhite, size: 20),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'S & C Settings',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: canSave ? _saveSettings : null,
              style: TextButton.styleFrom(
                foregroundColor: canSave ? _mint : const Color(0xFF6E7873),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isSavedRecently
                    ? const Row(
                        key: ValueKey('saved'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, size: 14, color: _mint),
                          SizedBox(width: 4),
                          Text(
                            'Saved',
                            style: TextStyle(
                              color: _mint,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Save',
                        key: const ValueKey('save'),
                        style: TextStyle(
                          color:
                              canSave ? _mint : const Color(0xFF6E7873),
                          fontSize: 13,
                          fontWeight:
                              canSave ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── SECTION 1: DEFAULT SESSION SETTINGS ───────────────────────────
            _buildSectionHeader('DEFAULT SESSION SETTINGS'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x14FFFFFF), width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Row 1: Default Activity
                  _buildNavigationRow(
                    icon: Icons.settings,
                    title: 'Default Activity',
                    value: _defaultActivity,
                    onTap: _pickDefaultActivity,
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 2: Default Session Rating
                  _buildNavigationRow(
                    icon: Icons.star_border,
                    title: 'Default Session Rating',
                    value: _defaultSessionRating,
                    onTap: _pickDefaultRating,
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 3: Auto-Save Draft Sessions
                  _buildToggleRow(
                    icon: Icons.save_outlined,
                    title: 'Auto-Save Draft Sessions',
                    subtitle: 'Drafts save automatically as you record',
                    value: _autoSaveDrafts,
                    onChanged: (val) => setState(() => _autoSaveDrafts = val),
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 4: Auto-Attach Location
                  _buildToggleRow(
                    icon: Icons.location_on_outlined,
                    title: 'Auto-Attach Location',
                    value: _autoAttachLocation,
                    onChanged: (val) =>
                        setState(() => _autoAttachLocation = val),
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 5: Auto-Record Weather
                  _buildToggleRow(
                    icon: Icons.wb_cloudy_outlined,
                    title: 'Auto-Record Weather',
                    value: _autoRecordWeather,
                    onChanged: (val) =>
                        setState(() => _autoRecordWeather = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── SECTION 2: ACTIVITY PREFERENCES ───────────────────────────────
            _buildSectionHeader('ACTIVITY PREFERENCES'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x14FFFFFF), width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Row 1: Default Activity Sort Order
                  _buildNavigationRow(
                    icon: Icons.sort,
                    title: 'Default Activity Sort Order',
                    value: _defaultSortOrder,
                    onTap: _pickSortOrder,
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 2: Default Filter
                  _buildNavigationRow(
                    icon: Icons.filter_list,
                    title: 'Default Filter',
                    value: _defaultFilter,
                    onTap: _pickDefaultFilter,
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 3: Show Archived Activities
                  _buildToggleRow(
                    icon: Icons.inventory_2_outlined,
                    title: 'Show Archived Activities',
                    value: _showArchivedActivities,
                    onChanged: (val) =>
                        setState(() => _showArchivedActivities = val),
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 4: Display Favourite Activities First
                  _buildToggleRow(
                    icon: Icons.bookmark_border,
                    title: 'Display Favourite Activities First',
                    value: _displayFavoritesFirst,
                    onChanged: (val) =>
                        setState(() => _displayFavoritesFirst = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── SECTION 3: STATISTICS & INSIGHTS ──────────────────────────────
            _buildSectionHeader('STATISTICS & INSIGHTS'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x14FFFFFF), width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Row 1: Default Statistics Date Range
                  _buildNavigationRow(
                    icon: Icons.calendar_month_outlined,
                    title: 'Default Statistics Date Range',
                    value: _defaultDateRange,
                    onTap: _pickDateRange,
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 2: Show Activity Insights on Dashboard
                  _buildToggleRow(
                    icon: Icons.bar_chart,
                    title: 'Show Activity Insights on Dashboard',
                    value: _showInsightsOnDashboard,
                    onChanged: (val) =>
                        setState(() => _showInsightsOnDashboard = val),
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 3: Show Milestones
                  _buildToggleRow(
                    icon: Icons.emoji_events_outlined,
                    title: 'Show Milestones',
                    subtitle: 'Display milestone achievements in statistics',
                    value: _showMilestones,
                    onChanged: (val) => setState(() => _showMilestones = val),
                  ),
                  const Divider(color: Color(0x14FFFFFF), height: 1),

                  // Row 4: Animate Charts
                  _buildToggleRow(
                    icon: Icons.play_arrow_outlined,
                    title: 'Animate Charts',
                    subtitle: 'Charts animate when loaded',
                    value: _animateCharts,
                    onChanged: (val) {
                      setState(() {
                        _animateCharts = val;
                        if (val) {
                          _chartAnimController.reset();
                          _chartAnimController.forward();
                        } else {
                          _chartAnimController.value = 1.0;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── INTERACTIVE ANIMATED CHART PREVIEW ───────────────────────────
            _buildChartPreviewCard(),
            const SizedBox(height: 24),

            // ─── SECTION 4: RESET BUTTON ───────────────────────────────────────
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _confirmResetDialog,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _errorBorder, width: 1),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: _errorRed, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Reset Strength & Conditioning Settings',
                      style: TextStyle(
                        color: _errorRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Resets module preferences only. Your sessions, activities and templates are never affected.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section Header Widget ─────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: _stoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ─── Row With Navigation Arrow ─────────────────────────────────────────────

  Widget _buildNavigationRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
          ],
        ),
      ),
    );
  }

  // ─── Row With Blue Square Checkbox ──────────────────────────────────────────

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: subtitle != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: subtitle != null ? 2 : 0),
              child: Icon(icon, color: _stoneGrey, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: EdgeInsets.only(top: subtitle != null ? 2 : 0),
              child: _buildFigmaCheckbox(value),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Interactive Animated Chart Preview ────────────────────────────────────

  Widget _buildChartPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.show_chart, color: _mint, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE CHART PREVIEW (${_defaultDateRange.toUpperCase()})',
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.replay, color: _stoneGrey, size: 18),
                tooltip: 'Replay Animation',
                onPressed: () {
                  _chartAnimController.reset();
                  _chartAnimController.forward();
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Preview how training volume curves render on your dashboard with current preferences.',
            style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.3),
          ),
          const SizedBox(height: 16),
          // Interactive animated line chart
          AnimatedBuilder(
            animation: _chartProgressAnim,
            builder: (context, _) {
              final progress = _animateCharts ? _chartProgressAnim.value : 1.0;
              final points = [
                FlSpot(0, 18 * progress),
                FlSpot(1, 26 * progress),
                FlSpot(2, 22 * progress),
                FlSpot(3, 35 * progress),
                FlSpot(4, 28 * progress),
                FlSpot(5, 42 * progress),
                FlSpot(6, 38 * progress),
              ];

              return SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 15,
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: Color(0x0FFFFFFF),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 15,
                          getTitlesWidget: (val, meta) => Text(
                            '${val.toInt()}k',
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, meta) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            final idx = val.toInt();
                            if (idx >= 0 && idx < days.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  days[idx],
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 10,
                                  ),
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
                    maxY: 50,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(1)} kg\nLoad Score',
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
                        spots: points,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: _mint,
                        barWidth: 2.5,
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
}
