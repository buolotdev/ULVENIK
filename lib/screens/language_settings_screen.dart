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
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class LanguageSettingsScreen extends StatefulWidget {
  final String currentLanguage;

  const LanguageSettingsScreen({
    super.key,
    this.currentLanguage = 'English (US)',
  });

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedLanguage;
  String _searchQuery = '';

  final List<Map<String, String>> _suggestedLanguages = [
    {'name': 'English (US)', 'native': 'English (United States)'},
    {'name': 'Deutsch', 'native': 'Deutsch (IGP & Prüfungsordnung)'},
    {'name': 'Norsk', 'native': 'Norsk (Bokmål)'},
    {'name': 'Svenska', 'native': 'Svenska'},
  ];

  final List<Map<String, String>> _otherLanguages = [
    {'name': 'English (UK)', 'native': 'English (United Kingdom)'},
    {'name': 'Français', 'native': 'Français'},
    {'name': 'Español', 'native': 'Español'},
    {'name': 'Italiano', 'native': 'Italiano'},
    {'name': 'Nederlands', 'native': 'Nederlands'},
    {'name': 'Suomi', 'native': 'Suomi'},
    {'name': 'Dansk', 'native': 'Dansk'},
    {'name': 'Polski', 'native': 'Polski'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _filterList(List<Map<String, String>> list) {
    if (_searchQuery.trim().isEmpty) return list;
    return list
        .where((l) =>
            l['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            l['native']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final suggested = _filterList(_suggestedLanguages);
    final other = _filterList(_otherLanguages);

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context, _selectedLanguage),
        ),
        title: const Text(
          'Language',
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
                hintText: 'Search language...',
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

          // 2. SUGGESTED LANGUAGES
          if (suggested.isNotEmpty) ...[
            _buildSectionHeader('SUGGESTED FOR CANINE HANDLERS'),
            const SizedBox(height: 8),
            _buildLanguageCard(suggested),
            const SizedBox(height: 20),
          ],

          // 3. OTHER LANGUAGES
          if (other.isNotEmpty) ...[
            _buildSectionHeader('ALL LANGUAGES'),
            const SizedBox(height: 8),
            _buildLanguageCard(other),
            const SizedBox(height: 24),
          ],
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

  Widget _buildLanguageCard(List<Map<String, String>> list) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: list.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isSelected = item['name'] == _selectedLanguage;
          final isLast = idx == list.length - 1;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                title: Text(
                  item['name']!,
                  style: TextStyle(
                    color: isSelected ? _mint : _offWhite,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                subtitle: Text(item['native']!, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                trailing: isSelected
                    ? const Icon(Icons.check, color: _mint, size: 20)
                    : null,
                onTap: () {
                  setState(() => _selectedLanguage = item['name']!);
                  Navigator.pop(context, _selectedLanguage);
                },
              ),
              if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
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
