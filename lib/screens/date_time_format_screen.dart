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

class DateTimeFormatScreen extends StatefulWidget {
  const DateTimeFormatScreen({super.key});

  @override
  State<DateTimeFormatScreen> createState() => _DateTimeFormatScreenState();
}

class _DateTimeFormatScreenState extends State<DateTimeFormatScreen> {
  bool _use24Hour = true;
  String _dateFormat = 'DD/MM/YYYY (28/10/2026)';
  String _startOfWeek = 'Monday';

  String get _sampleTime => _use24Hour ? '14:30:00' : '2:30:00 PM';

  String get _sampleDate {
    if (_dateFormat.startsWith('DD')) return '28/10/2026';
    if (_dateFormat.startsWith('MM')) return '10/28/2026';
    return '2026-10-28';
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Date & Time Format',
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
          // 1. LIVE FORMAT PREVIEW
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVE FORMAT PREVIEW',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sampleTime,
                          style: const TextStyle(
                            color: _offWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Session Telemetry Timestamp', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _sampleDate,
                          style: const TextStyle(
                            color: _mint,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Training Calendar Date', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. TIME NOTATION SELECTION
          _buildSectionHeader('TIME NOTATION'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildRadioTile(
                  title: '24-Hour Time (14:30)',
                  subtitle: 'Recommended for IGP trials, tracking lines & GPS logs',
                  selected: _use24Hour,
                  onTap: () => setState(() => _use24Hour = true),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildRadioTile(
                  title: '12-Hour Time (2:30 PM)',
                  subtitle: 'Standard civilian 12-hour format with AM/PM indicators',
                  selected: !_use24Hour,
                  onTap: () => setState(() => _use24Hour = false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. DATE NOTATION SELECTION
          _buildSectionHeader('DATE ORDER NOTATION'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'DD/MM/YYYY (28/10/2026)',
                  subtitle: 'Day / Month / Year • European & International standard',
                  selected: _dateFormat.startsWith('DD'),
                  onTap: () => setState(() => _dateFormat = 'DD/MM/YYYY (28/10/2026)'),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildRadioTile(
                  title: 'MM/DD/YYYY (10/28/2026)',
                  subtitle: 'Month / Day / Year • US standard',
                  selected: _dateFormat.startsWith('MM'),
                  onTap: () => setState(() => _dateFormat = 'MM/DD/YYYY (10/28/2026)'),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildRadioTile(
                  title: 'YYYY-MM-DD (2026-10-28)',
                  subtitle: 'Year-Month-Day • ISO 8601 database export format',
                  selected: _dateFormat.startsWith('YYYY'),
                  onTap: () => setState(() => _dateFormat = 'YYYY-MM-DD (2026-10-28)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. WEEK START DAY
          _buildSectionHeader('FIRST DAY OF THE WEEK'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'Monday',
                  subtitle: 'Starts handler training cycle on Monday morning',
                  selected: _startOfWeek == 'Monday',
                  onTap: () => setState(() => _startOfWeek = 'Monday'),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildRadioTile(
                  title: 'Sunday',
                  subtitle: 'Starts calendar cycle on Sunday',
                  selected: _startOfWeek == 'Sunday',
                  onTap: () => setState(() => _startOfWeek = 'Sunday'),
                ),
              ],
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

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _mint : _stoneGrey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: _mint,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? _mint : _offWhite,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
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
