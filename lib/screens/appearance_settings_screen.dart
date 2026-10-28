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
const Color _gold = Color(0xFFECC94B);
const Color _blue = Color(0xFF5D8FAF);
const Color _orange = Color(0xFFDD6B20);

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  String _selectedTheme = 'Dark Obsidian';
  Color _selectedAccent = _mint;
  double _fontScale = 1.0;
  bool _highContrast = false;
  bool _chartAnimations = true;
  bool _compactCards = false;

  final List<Map<String, dynamic>> _themeOptions = [
    {
      'title': 'Dark Obsidian',
      'subtitle': 'Pitch black #101214 with rich carbon cards',
      'bgColor': _obsidian,
      'cardColor': _carbon,
      'accent': _mint,
    },
    {
      'title': 'Stealth Frost',
      'subtitle': 'Deep slate graphite with muted cool tones',
      'bgColor': Color(0xFF161A1D),
      'cardColor': Color(0xFF20262B),
      'accent': _blue,
    },
    {
      'title': 'AMOLED Black',
      'subtitle': 'Pure #000000 black for outdoor battery life',
      'bgColor': Colors.black,
      'cardColor': Color(0xFF141414),
      'accent': _mint,
    },
  ];

  final List<Color> _accentColors = [
    _mint,
    _gold,
    _blue,
    _orange,
    const Color(0xFF9F7AEA), // Purple
  ];

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appearance Settings',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. THEME SELECTION TILES
          _buildSectionHeader('THEME PROFILE'),
          const SizedBox(height: 8),
          ..._themeOptions.map((opt) => _buildThemeOption(opt)),
          const SizedBox(height: 20),

          // 2. ACCENT COLOR PICKER
          _buildSectionHeader('PRIMARY ACCENT COLOR'),
          const SizedBox(height: 8),
          _buildAccentPicker(),
          const SizedBox(height: 20),

          // 3. TYPOGRAPHY SCALING & LIVE PREVIEW
          _buildSectionHeader('TYPOGRAPHY SCALING'),
          const SizedBox(height: 8),
          _buildTypographySlider(),
          const SizedBox(height: 20),

          // 4. DISPLAY & FIELD ADAPTABILITY
          _buildSectionHeader('FIELD & PERFORMANCE DISPLAY'),
          const SizedBox(height: 8),
          _buildDisplayToggles(),
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

  Widget _buildThemeOption(Map<String, dynamic> opt) {
    final isSelected = _selectedTheme == opt['title'];
    final Color bgColor = opt['bgColor'];
    final Color cardColor = opt['cardColor'];
    final Color accent = opt['accent'];

    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = opt['title']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _selectedAccent : _cardBorder,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            // Mini Theme Preview Block
            Container(
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opt['title'],
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    opt['subtitle'],
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Radio Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _selectedAccent : _stoneGrey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _selectedAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccentPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _accentColors.map((color) {
          final isSelected = _selectedAccent == color;
          return GestureDetector(
            onTap: () => setState(() => _selectedAccent = color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.black, size: 22)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypographySlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Font Scale Factor', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
              Text('${(_fontScale * 100).toInt()}%', style: TextStyle(color: _selectedAccent, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _selectedAccent,
              inactiveTrackColor: const Color(0xFF131718),
              thumbColor: _selectedAccent,
              trackHeight: 4,
            ),
            child: Slider(
              value: _fontScale,
              min: 0.85,
              max: 1.25,
              divisions: 4,
              onChanged: (val) => setState(() => _fontScale = val),
            ),
          ),
          const SizedBox(height: 10),

          // Live Text Preview Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview:',
                  style: TextStyle(color: _stoneGrey, fontSize: 10 * _fontScale, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Koda completed 45m S&C drill at Riverside Valley.',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 13 * _fontScale,
                    fontWeight: FontWeight.w600,
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

  Widget _buildDisplayToggles() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            title: 'High-Contrast Field Mode',
            subtitle: 'Enhance borders and text clarity in direct sunlight',
            value: _highContrast,
            onChanged: (val) => setState(() => _highContrast = val),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
          _buildSwitchRow(
            title: 'Chart Fluid Animations',
            subtitle: 'Smooth spline curves and telemetry entrance effects',
            value: _chartAnimations,
            onChanged: (val) => setState(() => _chartAnimations = val),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
          _buildSwitchRow(
            title: 'Compact Cards',
            subtitle: 'Reduce vertical padding to fit more timeline rows',
            value: _compactCards,
            onChanged: (val) => setState(() => _compactCards = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _selectedAccent,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF131718),
            onChanged: onChanged,
          ),
        ],
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
