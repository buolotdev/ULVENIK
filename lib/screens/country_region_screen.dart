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

class CountryRegionScreen extends StatefulWidget {
  final String currentCountry;

  const CountryRegionScreen({
    super.key,
    this.currentCountry = 'United States',
  });

  @override
  State<CountryRegionScreen> createState() => _CountryRegionScreenState();
}

class _CountryRegionScreenState extends State<CountryRegionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCountry;
  String _searchQuery = '';

  final List<Map<String, String>> _countries = [
    {'name': 'United States', 'code': 'US', 'region': 'North America'},
    {'name': 'Germany', 'code': 'DE', 'region': 'Europe'},
    {'name': 'Norway', 'code': 'NO', 'region': 'Europe'},
    {'name': 'Sweden', 'code': 'SE', 'region': 'Europe'},
    {'name': 'Canada', 'code': 'CA', 'region': 'North America'},
    {'name': 'United Kingdom', 'code': 'GB', 'region': 'Europe'},
    {'name': 'France', 'code': 'FR', 'region': 'Europe'},
    {'name': 'Switzerland', 'code': 'CH', 'region': 'Europe'},
    {'name': 'Austria', 'code': 'AT', 'region': 'Europe'},
    {'name': 'Australia', 'code': 'AU', 'region': 'Oceania'},
    {'name': 'New Zealand', 'code': 'NZ', 'region': 'Oceania'},
    {'name': 'Japan', 'code': 'JP', 'region': 'Asia'},
    {'name': 'South Africa', 'code': 'ZA', 'region': 'Africa'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.currentCountry;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredCountries {
    if (_searchQuery.trim().isEmpty) return _countries;
    return _countries
        .where((c) =>
            c['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c['code']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredCountries;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context, _selectedCountry),
        ),
        title: const Text(
          'Country or Region',
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
          // 1. SEARCH INPUT
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search country or region...',
                hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: _mint, size: 20),
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
          const SizedBox(height: 18),

          // 2. CURRENT SELECTION BANNER
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _forest.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.public, color: _mint, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ACTIVE OPERATING REGION', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                      const SizedBox(height: 2),
                      Text(_selectedCountry, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: _mint, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. COUNTRIES LIST
          _buildSectionHeader('ALL COUNTRIES & REGIONS'),
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
                final country = entry.value;
                final isSelected = country['name'] == _selectedCountry;
                final isLast = idx == list.length - 1;

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF131718),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            country['code']!,
                            style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      title: Text(
                        country['name']!,
                        style: TextStyle(
                          color: isSelected ? _mint : _offWhite,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(country['region']!, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: _mint, size: 20)
                          : null,
                      onTap: () {
                        setState(() => _selectedCountry = country['name']!);
                        Navigator.pop(context, _selectedCountry);
                      },
                    ),
                    if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 64),
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
