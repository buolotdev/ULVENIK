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
const Color _mutedGrey = Color(0xFF718096);
const Color _syncGreen = Color(0xFF4ADE80);
const Color _dangerRed = Color(0xFFE53E3E);

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  String _selectedTheme = 'Dark';
  String _selectedTextSize = 'Default';
  String _selectedDensity = 'Comfortable';
  bool _reduceMotion = false;
  bool _hapticFeedback = true;

  // Interactive preview state
  bool _previewToggle = true;

  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }
    Widget target;
    switch (index) {
      case 0:
        target = const HomepageScreen();
        break;
      case 1:
        target = const MyDogsScreen();
        break;
      case 2:
        target = const TrainingScreen();
        break;
      case 3:
        target = const TimelineScreen();
        break;
      case 4:
        target = const MorePageScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  void _resetAppearance() {
    setState(() {
      _selectedTheme = 'Dark';
      _selectedTextSize = 'Default';
      _selectedDensity = 'Comfortable';
      _reduceMotion = false;
      _hapticFeedback = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appearance settings reset to default.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Appearance | Saved ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Appearance',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'Saved',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── PREVIEW CARD ──────────────────────────────────────
                  _buildSectionHeader('PREVIEW'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        // Inner preview frame
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _obsidian,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x1AFFFFFF)),
                          ),
                          child: Column(
                            children: [
                              // Preview row 1: Pill & Radio
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181C1E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: _offWhite.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: _mutedGrey, width: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Preview row 2: Double line & Checkbox
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181C1E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: _offWhite.withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: 50,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _stoneGrey.withValues(alpha: 0.5),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: _mutedGrey.withValues(alpha: 0.3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Preview row 3: Slider & Switch
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181C1E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: _offWhite.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => setState(() => _previewToggle = !_previewToggle),
                                      child: Container(
                                        width: 32,
                                        height: 18,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(9),
                                          color: _previewToggle ? _forest : _carbon,
                                        ),
                                        alignment: _previewToggle ? Alignment.centerRight : Alignment.centerLeft,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _offWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Preview row 4: Dot pagination
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF181C1E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildPreviewDot(false),
                                    _buildPreviewDot(false),
                                    _buildPreviewDot(false),
                                    _buildPreviewDot(false),
                                    _buildPreviewDot(true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Updates instantly as you change settings',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── THEME ─────────────────────────────────────────────
                  _buildSectionHeader('THEME'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // System
                      Expanded(
                        child: _buildThemeTile(
                          id: 'System',
                          label: 'System',
                          sublabel: 'Default',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomPaint(
                              painter: _DiagonalSplitPainter(),
                              child: const SizedBox(height: 60, width: double.infinity),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Dark
                      Expanded(
                        child: _buildThemeTile(
                          id: 'Dark',
                          label: 'Dark',
                          sublabel: null,
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14191C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: _mutedGrey,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 44,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _stoneGrey,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ],
                                ),
                                const Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(Icons.check_circle, color: _syncGreen, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Light
                      Expanded(
                        child: _buildThemeTile(
                          id: 'Light',
                          label: 'Light',
                          sublabel: null,
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF888888),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 44,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCCCCCC),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── TEXT SIZE ─────────────────────────────────────────
                  _buildSectionHeader('TEXT SIZE'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildRadioRow(
                          icon: Icons.title,
                          title: 'Small',
                          isSelected: _selectedTextSize == 'Small',
                          onTap: () => setState(() => _selectedTextSize = 'Small'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.title,
                          title: 'Default',
                          subtitle: 'Recommended',
                          isSelected: _selectedTextSize == 'Default',
                          onTap: () => setState(() => _selectedTextSize = 'Default'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.title,
                          title: 'Large',
                          isSelected: _selectedTextSize == 'Large',
                          onTap: () => setState(() => _selectedTextSize = 'Large'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.title,
                          title: 'Extra Large',
                          isSelected: _selectedTextSize == 'Extra Large',
                          onTap: () => setState(() => _selectedTextSize = 'Extra Large'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── DISPLAY DENSITY ───────────────────────────────────
                  _buildSectionHeader('DISPLAY DENSITY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildRadioRow(
                          icon: Icons.dashboard_outlined,
                          title: 'Comfortable',
                          subtitle: 'Recommended',
                          isSelected: _selectedDensity == 'Comfortable',
                          onTap: () => setState(() => _selectedDensity = 'Comfortable'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.view_headline_outlined,
                          title: 'Compact',
                          subtitle: 'More content on screen',
                          isSelected: _selectedDensity == 'Compact',
                          onTap: () => setState(() => _selectedDensity = 'Compact'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.view_agenda_outlined,
                          title: 'Spacious',
                          subtitle: 'More breathing room',
                          isSelected: _selectedDensity == 'Spacious',
                          onTap: () => setState(() => _selectedDensity = 'Spacious'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── REDUCE MOTION ─────────────────────────────────────
                  _buildSectionHeader('REDUCE MOTION'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_border, color: _stoneGrey, size: 20),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reduce Motion',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Simplifies transitions and animations',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _reduceMotion,
                          activeThumbColor: _forest,
                          activeTrackColor: _syncGreen.withValues(alpha: 0.6),
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: _obsidian,
                          onChanged: (v) => setState(() => _reduceMotion = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── HAPTIC FEEDBACK ───────────────────────────────────
                  _buildSectionHeader('HAPTIC FEEDBACK'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.pan_tool_outlined, color: _stoneGrey, size: 20),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Haptic Feedback',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Vibration response on interactions',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _hapticFeedback,
                          activeThumbColor: _forest,
                          activeTrackColor: _syncGreen.withValues(alpha: 0.6),
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: _obsidian,
                          onChanged: (v) => setState(() => _hapticFeedback = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── RESET ─────────────────────────────────────────────
                  _buildSectionHeader('RESET'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _resetAppearance,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: _dangerRed, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Reset Appearance Settings',
                            style: TextStyle(
                              color: _dangerRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
        onTap: _onBottomNavTapped,
        backgroundColor: _obsidian,
        selectedItemColor: _mint,
        unselectedItemColor: _stoneGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewDot(bool isActive) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? _syncGreen : _mutedGrey.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildThemeTile({
    required String id,
    required String label,
    String? sublabel,
    required Widget child,
  }) {
    final isSelected = _selectedTheme == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = id),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _syncGreen : _cardBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: child,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _offWhite : _stoneGrey,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: const TextStyle(
                color: _mutedGrey,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 50,
    );
  }

  Widget _buildRadioRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: _syncGreen, size: 20),
          ],
        ),
      ),
    );
  }
}

class _DiagonalSplitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()..color = const Color(0xFF14191C);
    final lightPaint = Paint()..color = const Color(0xFFF7F7F4);

    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, darkPaint);

    final path2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, lightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
