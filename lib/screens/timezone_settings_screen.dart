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

class TimezoneSettingsScreen extends StatefulWidget {
  final String currentTimezone;

  const TimezoneSettingsScreen({
    super.key,
    this.currentTimezone = 'Pacific Time (US & Canada) • UTC-08:00',
  });

  @override
  State<TimezoneSettingsScreen> createState() => _TimezoneSettingsScreenState();
}

class _TimezoneSettingsScreenState extends State<TimezoneSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _autoDetect = true;
  late String _selectedTimezone;
  String _searchQuery = '';

  final List<Map<String, String>> _timezones = [
    {'name': 'Pacific Time (US & Canada)', 'offset': 'UTC-08:00', 'city': 'Los Angeles, Seattle', 'region': 'North America'},
    {'name': 'Mountain Time (US & Canada)', 'offset': 'UTC-07:00', 'city': 'Denver, Calgary', 'region': 'North America'},
    {'name': 'Central Time (US & Canada)', 'offset': 'UTC-06:00', 'city': 'Chicago, Dallas', 'region': 'North America'},
    {'name': 'Eastern Time (US & Canada)', 'offset': 'UTC-05:00', 'city': 'New York, Toronto', 'region': 'North America'},
    {'name': 'Greenwich Mean Time (GMT)', 'offset': 'UTC+00:00', 'city': 'London, Dublin', 'region': 'Europe'},
    {'name': 'Central European Time (CET)', 'offset': 'UTC+01:00', 'city': 'Berlin, Oslo, Vienna', 'region': 'Europe'},
    {'name': 'Eastern European Time (EET)', 'offset': 'UTC+02:00', 'city': 'Helsinki, Athens', 'region': 'Europe'},
    {'name': 'Gulf Standard Time (GST)', 'offset': 'UTC+04:00', 'city': 'Dubai', 'region': 'Middle East'},
    {'name': 'Japan Standard Time (JST)', 'offset': 'UTC+09:00', 'city': 'Tokyo', 'region': 'Asia'},
    {'name': 'Australian Eastern Time (AEST)', 'offset': 'UTC+10:00', 'city': 'Sydney, Melbourne', 'region': 'Oceania'},
    {'name': 'New Zealand Standard Time (NZST)', 'offset': 'UTC+12:00', 'city': 'Auckland, Wellington', 'region': 'Oceania'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedTimezone = widget.currentTimezone;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredTimezones {
    if (_searchQuery.trim().isEmpty) return _timezones;
    return _timezones.where((tz) {
      return tz['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tz['city']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tz['offset']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredTimezones;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context, _selectedTimezone),
        ),
        title: const Text(
          'Time Zone',
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
          // 1. AUTO DETECT TOGGLE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.my_location, color: _mint, size: 20),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Set Automatically', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text('Uses device GPS location', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: _autoDetect,
                  activeThumbColor: _mint,
                  activeTrackColor: _forest,
                  inactiveThumbColor: _stoneGrey,
                  inactiveTrackColor: const Color(0xFF131718),
                  onChanged: (val) => setState(() => _autoDetect = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. SEARCH INPUT
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              enabled: !_autoDetect,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: _autoDetect ? 'Auto-detection active via GPS' : 'Search city or time zone...',
                hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: _autoDetect ? 0.4 : 1.0), fontSize: 13),
                prefixIcon: Icon(Icons.search, color: _autoDetect ? _stoneGrey : _mint, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: _stoneGrey, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const SizedBox(height: 20),

          // 3. TIMEZONE LIST
          _buildSectionHeader('TIME ZONES'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: list.asMap().entries.map((entry) {
                final idx = entry.key;
                final tz = entry.value;
                final formatted = '${tz['name']} • ${tz['offset']}';
                final isSelected = _selectedTimezone.startsWith(tz['name']!);
                final isLast = idx == list.length - 1;

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      title: Text(
                        tz['name']!,
                        style: TextStyle(
                          color: isSelected ? _mint : _offWhite,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('${tz['city']} (${tz['offset']})', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: _mint, size: 20)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedTimezone = formatted;
                          _autoDetect = false;
                        });
                        Navigator.pop(context, _selectedTimezone);
                      },
                    ),
                    if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }).toList(),
            ),
          ),
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
