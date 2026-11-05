import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _TimeZoneEntry {
  final String id;
  final String city;
  final String country;
  final String regionGroup;
  final String ianaName;
  final String utcOffsetLabel;
  final int utcOffsetMinutes;
  final String fullZoneTitle;
  final bool showByDefault;

  const _TimeZoneEntry({
    required this.id,
    required this.city,
    required this.country,
    required this.regionGroup,
    required this.ianaName,
    required this.utcOffsetLabel,
    required this.utcOffsetMinutes,
    required this.fullZoneTitle,
    this.showByDefault = false,
  });
}

class TimezoneSettingsScreen extends StatefulWidget {
  const TimezoneSettingsScreen({super.key});

  @override
  State<TimezoneSettingsScreen> createState() => _TimezoneSettingsScreenState();
}

class _TimezoneSettingsScreenState extends State<TimezoneSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Reference UTC clock (12:42 UTC -> 13:42 in London UTC+01:00 per Figma)
  static const int _referenceUtcMinutes = 12 * 60 + 42;

  // Saved baseline state (defaults match Figma)
  bool _savedUseDeviceTimeZone = true;
  String _savedZoneId = 'london';

  // Active working state
  bool _useDeviceTimeZone = true;
  String _selectedZoneId = 'london';
  String _searchQuery = '';

  static const List<_TimeZoneEntry> _worldTimeZones = [
    // EUROPE (default visible in Figma)
    _TimeZoneEntry(
      id: 'london',
      city: 'London',
      country: 'United Kingdom',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/London',
      utcOffsetLabel: 'UTC +01:00',
      utcOffsetMinutes: 60,
      fullZoneTitle: 'British Summer Time',
      showByDefault: true,
    ),
    _TimeZoneEntry(
      id: 'madrid',
      city: 'Madrid',
      country: 'Spain',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Madrid',
      utcOffsetLabel: 'UTC +02:00',
      utcOffsetMinutes: 120,
      fullZoneTitle: 'Central European Summer Time',
      showByDefault: true,
    ),
    _TimeZoneEntry(
      id: 'stockholm',
      city: 'Stockholm',
      country: 'Sweden',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Stockholm',
      utcOffsetLabel: 'UTC +02:00',
      utcOffsetMinutes: 120,
      fullZoneTitle: 'Central European Summer Time',
      showByDefault: true,
    ),
    // Extended searchable Europe cities
    _TimeZoneEntry(
      id: 'berlin',
      city: 'Berlin',
      country: 'Germany',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Berlin',
      utcOffsetLabel: 'UTC +02:00',
      utcOffsetMinutes: 120,
      fullZoneTitle: 'Central European Summer Time',
    ),
    _TimeZoneEntry(
      id: 'paris',
      city: 'Paris',
      country: 'France',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Paris',
      utcOffsetLabel: 'UTC +02:00',
      utcOffsetMinutes: 120,
      fullZoneTitle: 'Central European Summer Time',
    ),
    _TimeZoneEntry(
      id: 'oslo',
      city: 'Oslo',
      country: 'Norway',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Oslo',
      utcOffsetLabel: 'UTC +02:00',
      utcOffsetMinutes: 120,
      fullZoneTitle: 'Central European Summer Time',
    ),
    _TimeZoneEntry(
      id: 'helsinki',
      city: 'Helsinki',
      country: 'Finland',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Helsinki',
      utcOffsetLabel: 'UTC +03:00',
      utcOffsetMinutes: 180,
      fullZoneTitle: 'Eastern European Summer Time',
    ),
    _TimeZoneEntry(
      id: 'zurich',
      city: 'Zurich',
      country: 'Switzerland',
      regionGroup: 'EUROPE',
      ianaName: 'Europe/Zurich',
      utcOffsetLabel: 'UTC +02:00',
      utcOffsetMinutes: 120,
      fullZoneTitle: 'Central European Summer Time',
    ),
    // NORTH AMERICA (default visible in Figma)
    _TimeZoneEntry(
      id: 'new_york',
      city: 'New York',
      country: 'United States',
      regionGroup: 'NORTH AMERICA',
      ianaName: 'America/New_York',
      utcOffsetLabel: 'UTC −04:00',
      utcOffsetMinutes: -240,
      fullZoneTitle: 'Eastern Daylight Time',
      showByDefault: true,
    ),
    _TimeZoneEntry(
      id: 'los_angeles',
      city: 'Los Angeles',
      country: 'United States',
      regionGroup: 'NORTH AMERICA',
      ianaName: 'America/Los_Angeles',
      utcOffsetLabel: 'UTC −07:00',
      utcOffsetMinutes: -420,
      fullZoneTitle: 'Pacific Daylight Time',
      showByDefault: true,
    ),
    // Extended searchable North America cities
    _TimeZoneEntry(
      id: 'chicago',
      city: 'Chicago',
      country: 'United States',
      regionGroup: 'NORTH AMERICA',
      ianaName: 'America/Chicago',
      utcOffsetLabel: 'UTC −05:00',
      utcOffsetMinutes: -300,
      fullZoneTitle: 'Central Daylight Time',
    ),
    _TimeZoneEntry(
      id: 'toronto',
      city: 'Toronto',
      country: 'Canada',
      regionGroup: 'NORTH AMERICA',
      ianaName: 'America/Toronto',
      utcOffsetLabel: 'UTC −04:00',
      utcOffsetMinutes: -240,
      fullZoneTitle: 'Eastern Daylight Time',
    ),
    _TimeZoneEntry(
      id: 'vancouver',
      city: 'Vancouver',
      country: 'Canada',
      regionGroup: 'NORTH AMERICA',
      ianaName: 'America/Vancouver',
      utcOffsetLabel: 'UTC −07:00',
      utcOffsetMinutes: -420,
      fullZoneTitle: 'Pacific Daylight Time',
    ),
    // ASIA (default visible in Figma)
    _TimeZoneEntry(
      id: 'dubai',
      city: 'Dubai',
      country: 'United Arab Emirates',
      regionGroup: 'ASIA',
      ianaName: 'Asia/Dubai',
      utcOffsetLabel: 'UTC +04:00',
      utcOffsetMinutes: 240,
      fullZoneTitle: 'Gulf Standard Time',
      showByDefault: true,
    ),
    // Extended searchable Asia & Oceania cities
    _TimeZoneEntry(
      id: 'karachi',
      city: 'Karachi',
      country: 'Pakistan',
      regionGroup: 'ASIA',
      ianaName: 'Asia/Karachi',
      utcOffsetLabel: 'UTC +05:00',
      utcOffsetMinutes: 300,
      fullZoneTitle: 'Pakistan Standard Time',
    ),
    _TimeZoneEntry(
      id: 'singapore',
      city: 'Singapore',
      country: 'Singapore',
      regionGroup: 'ASIA',
      ianaName: 'Asia/Singapore',
      utcOffsetLabel: 'UTC +08:00',
      utcOffsetMinutes: 480,
      fullZoneTitle: 'Singapore Standard Time',
    ),
    _TimeZoneEntry(
      id: 'tokyo',
      city: 'Tokyo',
      country: 'Japan',
      regionGroup: 'ASIA',
      ianaName: 'Asia/Tokyo',
      utcOffsetLabel: 'UTC +09:00',
      utcOffsetMinutes: 540,
      fullZoneTitle: 'Japan Standard Time',
    ),
    _TimeZoneEntry(
      id: 'sydney',
      city: 'Sydney',
      country: 'Australia',
      regionGroup: 'OCEANIA',
      ianaName: 'Australia/Sydney',
      utcOffsetLabel: 'UTC +10:00',
      utcOffsetMinutes: 600,
      fullZoneTitle: 'Australian Eastern Standard Time',
    ),
    _TimeZoneEntry(
      id: 'auckland',
      city: 'Auckland',
      country: 'New Zealand',
      regionGroup: 'OCEANIA',
      ianaName: 'Pacific/Auckland',
      utcOffsetLabel: 'UTC +12:00',
      utcOffsetMinutes: 720,
      fullZoneTitle: 'New Zealand Standard Time',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!mounted) return;
      if (_searchFocusNode.hasFocus && _useDeviceTimeZone) {
        setState(() {
          _useDeviceTimeZone = false;
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  _TimeZoneEntry get _selectedZone => _worldTimeZones.firstWhere(
        (z) => z.id == _selectedZoneId,
        orElse: () => _worldTimeZones.first,
      );

  _TimeZoneEntry get _deviceZone => _worldTimeZones.first; // Europe/London

  bool get _hasPendingChanges =>
      _useDeviceTimeZone != _savedUseDeviceTimeZone ||
      _selectedZoneId != _savedZoneId;

  String _formatLocalTime(_TimeZoneEntry entry) {
    int total = (_referenceUtcMinutes + entry.utcOffsetMinutes) % (24 * 60);
    if (total < 0) total += 24 * 60;
    final hh = (total ~/ 60).toString().padLeft(2, '0');
    final mm = (total % 60).toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  List<_TimeZoneEntry> get _visibleTimeZones {
    final raw = _searchQuery.trim().toLowerCase();
    if (raw.isEmpty) {
      // Keep default list matching Figma, plus ensure currently selected custom city stays visible
      return _worldTimeZones
          .where((z) => z.showByDefault || z.id == _selectedZoneId)
          .toList();
    }
    final normalized = raw.replaceAll('-', '−');
    return _worldTimeZones.where((z) {
      final offsetPlain = z.utcOffsetLabel.toLowerCase().replaceAll('−', '-');
      return z.city.toLowerCase().contains(raw) ||
          z.country.toLowerCase().contains(raw) ||
          z.ianaName.toLowerCase().contains(raw) ||
          z.fullZoneTitle.toLowerCase().contains(raw) ||
          z.utcOffsetLabel.toLowerCase().contains(normalized) ||
          offsetPlain.contains(raw);
    }).toList();
  }

  void _toggleDeviceTimeZone(bool value) {
    setState(() {
      _useDeviceTimeZone = value;
      if (value) {
        _selectedZoneId = _deviceZone.id;
        _searchFocusNode.unfocus();
      }
    });
  }

  void _selectTimeZone(String id, {bool isDeviceSuggestedRow = false}) {
    setState(() {
      _selectedZoneId = id;
      if (!isDeviceSuggestedRow) {
        _useDeviceTimeZone = false;
      }
    });
  }

  void _saveTimeZone() {
    if (!_hasPendingChanges) {
      AppSnackbar.show(
        context,
        title: 'Time Zone Active',
        message:
            '${_selectedZone.ianaName} (${_selectedZone.utcOffsetLabel}) is already active.',
        type: SnackbarType.info,
      );
      return;
    }

    setState(() {
      _savedUseDeviceTimeZone = _useDeviceTimeZone;
      _savedZoneId = _selectedZoneId;
    });

    AppSnackbar.show(
      context,
      title: 'Time Zone Saved',
      message: _savedUseDeviceTimeZone
          ? 'Following device time zone (${_selectedZone.ianaName}).'
          : 'Time zone updated to ${_selectedZone.ianaName} (${_selectedZone.utcOffsetLabel}).',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final manualDimAlpha = _useDeviceTimeZone ? 0.68 : 1.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Container(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('CURRENT TIME ZONE'),
                    const SizedBox(height: 10),
                    _buildCurrentTimeZoneCard(),
                    const SizedBox(height: 14),
                    _buildUseDeviceTimeZoneCard(),
                    const SizedBox(height: 14),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: manualDimAlpha,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(),
                          if (_searchQuery.trim().isEmpty) ...[
                            const SizedBox(height: 22),
                            _buildSectionLabel('SUGGESTED'),
                            const SizedBox(height: 10),
                            _buildSuggestedCard(),
                          ],
                          const SizedBox(height: 22),
                          _buildSectionLabel('ALL TIME ZONES'),
                          const SizedBox(height: 10),
                          _buildAllTimeZonesCard(),
                          const SizedBox(height: 22),
                          _buildSectionLabel('PREVIEW'),
                          const SizedBox(height: 10),
                          _buildPreviewCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomSaveDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final savedEntry = _worldTimeZones.firstWhere(
      (z) => z.id == _savedZoneId,
      orElse: () => _worldTimeZones.first,
    );
    final returnValue = '${savedEntry.ianaName} (${savedEntry.utcOffsetLabel})';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(returnValue),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: AppColors.secondaryTextStoneGrey,
              size: 26,
            ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Time Zone',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
          ),
          GestureDetector(
            onTap: _saveTimeZone,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _hasPendingChanges
                      ? const Color(0xFF4CA384)
                      : AppColors.primaryForestGreen.withValues(alpha: 0.48),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
          color: AppColors.secondaryTextStoneGrey,
        ),
      ),
    );
  }

  Widget _buildCurrentTimeZoneCard() {
    final active = _selectedZone;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const UlvenikIcon(UlvenikIcons.trainingTime,
                size: 21,
                color: AppColors.secondaryTextStoneGrey,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 4.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  _useDeviceTimeZone ? 'AUTOMATIC' : 'MANUAL',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.9,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            active.ianaName,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatLocalTime(active),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 23,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            active.utcOffsetLabel,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseDeviceTimeZoneCard() {
    return GestureDetector(
      onTap: () => _toggleDeviceTimeZone(!_useDeviceTimeZone),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.language_rounded,
              size: 20,
              color: AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Device Time Zone',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextOffWhite,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Ulvenik will follow the time zone set on this device',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      height: 1.35,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _UlvenikPillSwitch(
              value: _useDeviceTimeZone,
              onChanged: _toggleDeviceTimeZone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus
              ? AppColors.primaryForestGreen.withValues(alpha: 0.6)
              : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search,
            size: 19,
            color: AppColors.secondaryTextStoneGrey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (v) {
                setState(() {
                  _searchQuery = v;
                  if (v.isNotEmpty && _useDeviceTimeZone) {
                    _useDeviceTimeZone = false;
                  }
                });
              },
              cursorColor: AppColors.primaryForestGreen,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.5,
                color: AppColors.primaryTextOffWhite,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search city, country or time zone',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  color: AppColors.secondaryTextStoneGrey,
                ),
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
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close_rounded,
                  size: 17,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestedCard() {
    final london = _deviceZone;
    final isLondonSelected = _selectedZoneId == london.id;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          children: [
            _buildTimeZoneRow(
              city: london.city,
              subtitle: '${london.country} · ${london.utcOffsetLabel}',
              localTime: _formatLocalTime(london),
              isSelected: isLondonSelected,
              stackCheckmarkUnderTime: true,
              onTap: () => _selectTimeZone(london.id),
            ),
            Container(height: 1, color: AppColors.cardBorder),
            _buildTimeZoneRow(
              city: london.city,
              subtitle: 'Device region · ${london.ianaName}',
              localTime: _formatLocalTime(london),
              isSelected: false,
              stackCheckmarkUnderTime: false,
              onTap: () => _selectTimeZone(
                london.id,
                isDeviceSuggestedRow: _useDeviceTimeZone,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllTimeZonesCard() {
    final entries = _visibleTimeZones;
    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Text(
          'No time zones matching "${_searchQuery.trim()}"',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
      );
    }

    const regionOrder = ['EUROPE', 'NORTH AMERICA', 'ASIA', 'OCEANIA'];
    final groupedWidgets = <Widget>[];

    for (final region in regionOrder) {
      final groupItems =
          entries.where((e) => e.regionGroup == region).toList();
      if (groupItems.isEmpty) continue;

      groupedWidgets.add(_buildRegionSubheader(region));
      for (int i = 0; i < groupItems.length; i++) {
        if (i > 0) {
          groupedWidgets.add(Container(height: 1, color: AppColors.cardBorder));
        }
        final item = groupItems[i];
        groupedWidgets.add(
          _buildTimeZoneRow(
            city: item.city,
            subtitle: '${item.country} · ${item.utcOffsetLabel}',
            localTime: _formatLocalTime(item),
            isSelected: _selectedZoneId == item.id,
            stackCheckmarkUnderTime: false,
            onTap: () => _selectTimeZone(item.id),
          ),
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: groupedWidgets,
        ),
      ),
    );
  }

  Widget _buildRegionSubheader(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.secondaryTextStoneGrey,
        ),
      ),
    );
  }

  Widget _buildTimeZoneRow({
    required String city,
    required String subtitle,
    required String localTime,
    required bool isSelected,
    required bool stackCheckmarkUnderTime,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected
          ? AppColors.primaryForestGreen.withValues(alpha: 0.14)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3,
                color: isSelected
                    ? AppColors.primaryForestGreen
                    : Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 13.5, 16, 13.5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              city,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTextOffWhite,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (stackCheckmarkUnderTime)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localTime,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(height: 4),
                              const Icon(Icons.check_rounded,
                                size: 16,
                                color: AppColors.primaryForestGreen,
                              ),
                            ],
                          ],
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localTime,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check_rounded,
                                size: 17,
                                color: AppColors.primaryForestGreen,
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final active = _selectedZone;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TIME ZONE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.15,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      active.ianaName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CURRENT TIME',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.15,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatLocalTime(active),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'UTC OFFSET',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.15,
              color: AppColors.secondaryTextStoneGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${active.utcOffsetLabel} · ${active.fullZoneTitle}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'Historical records remain unchanged. Only displayed\ntimes will change.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                height: 1.45,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSaveDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _saveTimeZone,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasPendingChanges
                ? AppColors.primaryForestGreen
                : const Color(0xFF1A332B),
            foregroundColor: _hasPendingChanges
                ? AppColors.primaryTextOffWhite
                : AppColors.secondarySage,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save Time Zone',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _UlvenikPillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _UlvenikPillSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryForestGreen : const Color(0xFF343A3D),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value
                  ? AppColors.primaryTextOffWhite
                  : const Color(0xFFB7BFBA),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
