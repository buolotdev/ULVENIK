import 'package:flutter/material.dart';
import 'timeline_screen.dart';
import 'timeline_dashboard_screen.dart';
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
const Color _destructive = Color(0xFFE53E3E);

class TimelineSettingsScreen extends StatefulWidget {
  const TimelineSettingsScreen({super.key});

  @override
  State<TimelineSettingsScreen> createState() => _TimelineSettingsScreenState();
}

class _TimelineSettingsScreenState extends State<TimelineSettingsScreen> {
  // Section Expansion States (Display expanded by default as in Figma)
  final Map<String, bool> _expandedSections = {
    'Display': true,
    'Grouping': false,
    'Event Preview': false,
    'Favourites': false,
    'Archive': false,
    'Search': false,
    'Notifications': false,
    'Performance': false,
    'Privacy': false,
  };

  // Setting Values
  String _defaultView = 'Chronological Feed';
  String _defaultSortOrder = 'Newest First';
  String _eventDensity = 'Comfortable';
  String _dateFormat = 'DD/MM/YYYY';
  String _timeFormat = '24 Hour';
  bool _autoExpandToday = true;

  // Grouping
  String _groupBy = 'Date (Today, Yesterday, Month)';

  // Event Preview
  bool _showThumbnails = true;
  bool _showTelemetry = true;

  // Favourites
  bool _pinFavourites = false;

  // Archive
  String _autoArchive = 'Never';

  // Search
  bool _saveRecentSearches = true;
  String _searchScope = 'Active Feed & Archive';

  // Notifications
  bool _milestoneReminders = true;
  bool _streakAlerts = true;
  bool _weeklyDigest = true;
  String _digestTime = '20:00';

  // Performance
  bool _hardwareAcceleration = true;
  bool _preloadMedia = true;

  // Privacy
  bool _showHandlerName = true;
  bool _gpsTagging = true;
  String _encryption = 'AES-256 Enabled';

  String _statusLabel = 'All Changes Saved';

  void _triggerSaved() {
    setState(() => _statusLabel = 'Saving...');
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _statusLabel = 'All Changes Saved');
      }
    });
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !(_expandedSections[section] ?? false);
    });
  }

  void _showPickerModal({
    required String title,
    required List<String> options,
    required String currentVal,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              ...options.map((opt) {
                final bool isSelected = opt == currentVal;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? _mint : _stoneGrey,
                    size: 20,
                  ),
                  title: Text(
                    opt,
                    style: TextStyle(
                      color: isSelected ? _offWhite : _stoneGrey,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    onSelected(opt);
                    Navigator.pop(ctx);
                    _triggerSaved();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmReset() {
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
              const Icon(Icons.refresh, color: _destructive, size: 40),
              const SizedBox(height: 14),
              const Text(
                'Reset Timeline Settings?',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'All display density, view preferences, formats, and notification toggles will be restored to defaults.',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                        side: const BorderSide(color: _cardBorder),
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
                        backgroundColor: _destructive,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _defaultView = 'Chronological Feed';
                          _defaultSortOrder = 'Newest First';
                          _eventDensity = 'Comfortable';
                          _dateFormat = 'DD/MM/YYYY';
                          _timeFormat = '24 Hour';
                          _autoExpandToday = true;
                          _groupBy = 'Date (Today, Yesterday, Month)';
                          _showThumbnails = true;
                          _showTelemetry = true;
                          _pinFavourites = false;
                          _autoArchive = 'Never';
                          _saveRecentSearches = true;
                          _searchScope = 'Active Feed & Archive';
                          _milestoneReminders = true;
                          _streakAlerts = true;
                          _weeklyDigest = true;
                          _digestTime = '20:00';
                          _hardwareAcceleration = true;
                          _preloadMedia = true;
                          _showHandlerName = true;
                          _gpsTagging = true;
                          _encryption = 'AES-256 Enabled';
                        });
                        _triggerSaved();
                      },
                      child: const Text(
                        'Reset All',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
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
          'Timeline Settings',
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
          // All Changes Saved Indicator
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _statusLabel,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),

          // 1. DISPLAY (6 settings)
          _buildAccordionCard(
            title: 'Display',
            icon: Icons.visibility_outlined,
            settingCount: 6,
            isExpanded: _expandedSections['Display'] ?? false,
            onHeaderTap: () => _toggleSection('Display'),
            children: [
              _buildSettingItem(
                icon: Icons.table_rows_outlined,
                title: 'Default Timeline View',
                subtitle: 'Your preferred landing view...',
                value: '$_defaultView >',
                onTap: () => _showPickerModal(
                  title: 'Default Timeline View',
                  options: [
                    'Chronological Feed',
                    'Calendar Month View',
                    'Calendar Week View',
                    'Calendar Day View',
                    'Timeline Dashboard',
                  ],
                  currentVal: _defaultView,
                  onSelected: (val) => setState(() => _defaultView = val),
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.sort,
                title: 'Default Sort Order',
                subtitle: 'How Timeline events are ordered...',
                value: '$_defaultSortOrder >',
                onTap: () => _showPickerModal(
                  title: 'Default Sort Order',
                  options: ['Newest First', 'Oldest First'],
                  currentVal: _defaultSortOrder,
                  onSelected: (val) => setState(() => _defaultSortOrder = val),
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.density_medium,
                title: 'Event Density',
                subtitle: 'Controls spacing between...',
                value: '$_eventDensity >',
                onTap: () => _showPickerModal(
                  title: 'Event Density',
                  options: ['Compact', 'Comfortable', 'Spacious'],
                  currentVal: _eventDensity,
                  onSelected: (val) => setState(() => _eventDensity = val),
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.calendar_today_outlined,
                title: 'Date Format',
                subtitle: 'How dates appear...',
                value: '$_dateFormat >',
                onTap: () => _showPickerModal(
                  title: 'Date Format',
                  options: ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD', 'Relative (e.g. 2d ago)'],
                  currentVal: _dateFormat,
                  onSelected: (val) => setState(() => _dateFormat = val),
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.access_time,
                title: 'Time Format',
                subtitle: '12-hour or 24-hour display',
                value: '$_timeFormat >',
                onTap: () => _showPickerModal(
                  title: 'Time Format',
                  options: ['24 Hour', '12 Hour AM/PM'],
                  currentVal: _timeFormat,
                  onSelected: (val) => setState(() => _timeFormat = val),
                ),
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.wb_sunny_outlined,
                title: "Auto-Expand Today's Events",
                subtitle: "Today's section opens automatically...",
                value: _autoExpandToday,
                onChanged: (val) {
                  setState(() => _autoExpandToday = val);
                  _triggerSaved();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. GROUPING (1 setting)
          _buildAccordionCard(
            title: 'Grouping',
            icon: Icons.layers_outlined,
            settingCount: 1,
            isExpanded: _expandedSections['Grouping'] ?? false,
            onHeaderTap: () => _toggleSection('Grouping'),
            children: [
              _buildSettingItem(
                icon: Icons.category_outlined,
                title: 'Group Events By',
                subtitle: 'Visual clustering method on feed...',
                value: '$_groupBy >',
                onTap: () => _showPickerModal(
                  title: 'Group Events By',
                  options: [
                    'Date (Today, Yesterday, Month)',
                    'Canine Profile',
                    'Event Category',
                    'None (Flat Chronological)',
                  ],
                  currentVal: _groupBy,
                  onSelected: (val) => setState(() => _groupBy = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. EVENT PREVIEW (2 settings)
          _buildAccordionCard(
            title: 'Event Preview',
            icon: Icons.subtitles_outlined,
            settingCount: 2,
            isExpanded: _expandedSections['Event Preview'] ?? false,
            onHeaderTap: () => _toggleSection('Event Preview'),
            children: [
              _buildSwitchItem(
                icon: Icons.photo_outlined,
                title: 'Show Media Thumbnails',
                subtitle: 'Display photo and video preview strips inside cards',
                value: _showThumbnails,
                onChanged: (val) {
                  setState(() => _showThumbnails = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.tune,
                title: 'Show Telemetry Chips',
                subtitle: 'Display duration, metric badges, and location tags',
                value: _showTelemetry,
                onChanged: (val) {
                  setState(() => _showTelemetry = val);
                  _triggerSaved();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4. FAVOURITES (1 setting)
          _buildAccordionCard(
            title: 'Favourites',
            icon: Icons.favorite_border,
            settingCount: 1,
            isExpanded: _expandedSections['Favourites'] ?? false,
            onHeaderTap: () => _toggleSection('Favourites'),
            children: [
              _buildSwitchItem(
                icon: Icons.vertical_align_top,
                title: 'Pin Favourites to Top',
                subtitle: 'Always showcase starred events at the head of day groups',
                value: _pinFavourites,
                onChanged: (val) {
                  setState(() => _pinFavourites = val);
                  _triggerSaved();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 5. ARCHIVE (1 setting)
          _buildAccordionCard(
            title: 'Archive',
            icon: Icons.archive_outlined,
            settingCount: 1,
            isExpanded: _expandedSections['Archive'] ?? false,
            onHeaderTap: () => _toggleSection('Archive'),
            children: [
              _buildSettingItem(
                icon: Icons.schedule,
                title: 'Auto-Archive Inactive Events',
                subtitle: 'Clean active feed for older entries...',
                value: '$_autoArchive >',
                onTap: () => _showPickerModal(
                  title: 'Auto-Archive Inactive Events',
                  options: ['Never', 'After 6 Months', 'After 1 Year', 'After 2 Years'],
                  currentVal: _autoArchive,
                  onSelected: (val) => setState(() => _autoArchive = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 6. SEARCH (2 settings)
          _buildAccordionCard(
            title: 'Search',
            icon: Icons.search,
            settingCount: 2,
            isExpanded: _expandedSections['Search'] ?? false,
            onHeaderTap: () => _toggleSection('Search'),
            children: [
              _buildSwitchItem(
                icon: Icons.history,
                title: 'Save Recent Searches',
                subtitle: 'Remember past keywords for fast autocomplete',
                value: _saveRecentSearches,
                onChanged: (val) {
                  setState(() => _saveRecentSearches = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.filter_alt_outlined,
                title: 'Search Scope',
                subtitle: 'Include archived events in search queries',
                value: '$_searchScope >',
                onTap: () => _showPickerModal(
                  title: 'Search Scope',
                  options: ['Active Feed & Archive', 'Active Feed Only', 'Archive Only'],
                  currentVal: _searchScope,
                  onSelected: (val) => setState(() => _searchScope = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 7. NOTIFICATIONS (4 settings)
          _buildAccordionCard(
            title: 'Notifications',
            icon: Icons.notifications_none,
            settingCount: 4,
            isExpanded: _expandedSections['Notifications'] ?? false,
            onHeaderTap: () => _toggleSection('Notifications'),
            children: [
              _buildSwitchItem(
                icon: Icons.emoji_events_outlined,
                title: 'Milestone Reminders',
                subtitle: 'Celebrate major achievements and anniversaries',
                value: _milestoneReminders,
                onChanged: (val) {
                  setState(() => _milestoneReminders = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.local_fire_department_outlined,
                title: 'Streak Alerts',
                subtitle: 'Notifications when active training streak is at risk',
                value: _streakAlerts,
                onChanged: (val) {
                  setState(() => _streakAlerts = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.summarize_outlined,
                title: 'Weekly Volume Digest',
                subtitle: 'Summary email and push notification every Sunday',
                value: _weeklyDigest,
                onChanged: (val) {
                  setState(() => _weeklyDigest = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.alarm,
                title: 'Daily Digest Time',
                subtitle: 'Time of day for activity digests',
                value: '$_digestTime >',
                onTap: () => _showPickerModal(
                  title: 'Daily Digest Time',
                  options: ['08:00', '12:00', '18:00', '20:00', '22:00'],
                  currentVal: _digestTime,
                  onSelected: (val) => setState(() => _digestTime = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 8. PERFORMANCE (3 settings)
          _buildAccordionCard(
            title: 'Performance',
            icon: Icons.speed_outlined,
            settingCount: 3,
            isExpanded: _expandedSections['Performance'] ?? false,
            onHeaderTap: () => _toggleSection('Performance'),
            children: [
              _buildSwitchItem(
                icon: Icons.auto_graph,
                title: 'Hardware Chart Acceleration',
                subtitle: 'Render spline curves and donuts with hardware GPU',
                value: _hardwareAcceleration,
                onChanged: (val) {
                  setState(() => _hardwareAcceleration = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.cloud_download_outlined,
                title: 'Pre-load Media Assets',
                subtitle: 'Cache upcoming photos while scrolling feed',
                value: _preloadMedia,
                onChanged: (val) {
                  setState(() => _preloadMedia = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.cleaning_services_outlined,
                title: 'Clear Local Cache',
                subtitle: 'Free up local offline timeline storage',
                value: '14.2 MB >',
                onTap: () {
                  _triggerSaved();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 9. PRIVACY (3 settings)
          _buildAccordionCard(
            title: 'Privacy',
            icon: Icons.shield_outlined,
            settingCount: 3,
            isExpanded: _expandedSections['Privacy'] ?? false,
            onHeaderTap: () => _toggleSection('Privacy'),
            children: [
              _buildSwitchItem(
                icon: Icons.person_outline,
                title: 'Show Handler on Public Cards',
                subtitle: 'Include trainer/handler attribution in exported summaries',
                value: _showHandlerName,
                onChanged: (val) {
                  setState(() => _showHandlerName = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.location_on_outlined,
                title: 'GPS Location Tagging',
                subtitle: 'Record coordinates for tracking and outdoor runs',
                value: _gpsTagging,
                onChanged: (val) {
                  setState(() => _gpsTagging = val);
                  _triggerSaved();
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Export Encryption',
                subtitle: 'Security protocol for PDF and CSV bundles',
                value: '$_encryption >',
                onTap: () => _showPickerModal(
                  title: 'Export Encryption',
                  options: ['AES-256 Enabled', 'Standard ZIP Password', 'None'],
                  currentVal: _encryption,
                  onSelected: (val) => setState(() => _encryption = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 10. RESET TIMELINE SETTINGS BUTTON
          Container(
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
                onTap: _confirmReset,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: _destructive, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Reset Timeline Settings',
                        style: TextStyle(
                          color: _destructive,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAccordionCard({
    required String title,
    required IconData icon,
    required int settingCount,
    required bool isExpanded,
    required VoidCallback onHeaderTap,
    required List<Widget> children,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? _mint.withValues(alpha: 0.3) : _cardBorder,
        ),
      ),
      child: Column(
        children: [
          // Header Row
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onHeaderTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, color: isExpanded ? _mint : _offWhite, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$settingCount ${settingCount == 1 ? 'setting' : 'settings'}',
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeInOutCubic,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: _stoneGrey,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Smooth Animated Expansion Body
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(color: Color(0x14FFFFFF), height: 1),
                ...children,
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 260),
            sizeCurve: Curves.easeInOutCubic,
            firstCurve: Curves.easeInOutCubic,
            secondCurve: Curves.easeInOutCubic,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, color: _stoneGrey, size: 18),
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
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: _stoneGrey, size: 18),
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
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveThumbColor: _stoneGrey,
            inactiveTrackColor: const Color(0xFF242A2E),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0x14FFFFFF), height: 1);
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
