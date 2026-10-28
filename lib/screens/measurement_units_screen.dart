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

class MeasurementUnitsScreen extends StatefulWidget {
  const MeasurementUnitsScreen({super.key});

  @override
  State<MeasurementUnitsScreen> createState() => _MeasurementUnitsScreenState();
}

class _MeasurementUnitsScreenState extends State<MeasurementUnitsScreen> {
  String _distanceUnit = 'Kilometers (km)';
  String _weightUnit = 'Kilograms (kg)';
  String _tempUnit = 'Celsius (°C)';
  String _elevationUnit = 'Meters (m)';
  String _speedUnit = 'km/h';

  bool get _isMetricPreset =>
      _distanceUnit == 'Kilometers (km)' &&
      _weightUnit == 'Kilograms (kg)' &&
      _tempUnit == 'Celsius (°C)';

  void _applyMetricPreset() {
    setState(() {
      _distanceUnit = 'Kilometers (km)';
      _weightUnit = 'Kilograms (kg)';
      _tempUnit = 'Celsius (°C)';
      _elevationUnit = 'Meters (m)';
      _speedUnit = 'km/h';
    });
  }

  void _applyImperialPreset() {
    setState(() {
      _distanceUnit = 'Miles (mi)';
      _weightUnit = 'Pounds (lbs)';
      _tempUnit = 'Fahrenheit (°F)';
      _elevationUnit = 'Feet (ft)';
      _speedUnit = 'mph';
    });
  }

  void _showUnitPickerModal(
    String title,
    List<String> options,
    String current,
    ValueChanged<String> onSelected,
  ) {
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
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              ...options.map((opt) {
                final isSelected = opt == current;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    opt,
                    style: TextStyle(
                      color: isSelected ? _mint : _offWhite,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: _mint, size: 20) : null,
                  onTap: () {
                    onSelected(opt);
                    Navigator.pop(ctx);
                  },
                );
              }),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Measurement Units',
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
          // 1. SYSTEM PRESET SWITCHER
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _applyMetricPreset,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isMetricPreset ? _forest : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Metric (km, kg, °C)',
                          style: TextStyle(
                            color: _isMetricPreset ? _offWhite : _stoneGrey,
                            fontSize: 13,
                            fontWeight: _isMetricPreset ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _applyImperialPreset,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_isMetricPreset ? _forest : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Imperial (mi, lbs, °F)',
                          style: TextStyle(
                            color: !_isMetricPreset ? _offWhite : _stoneGrey,
                            fontSize: 13,
                            fontWeight: !_isMetricPreset ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. LIVE TELEMETRY PREVIEW CARD
          _buildSectionHeader('LIVE TELEMETRY PREVIEW'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Koda • Alpine Scent Run', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('Active Session', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPreviewStat('Weight', _weightUnit == 'Kilograms (kg)' ? '32.4 kg' : '71.4 lbs'),
                    _buildPreviewStat('Distance', _distanceUnit == 'Kilometers (km)' ? '8.4 km' : '5.2 mi'),
                    _buildPreviewStat('Peak Speed', _speedUnit == 'km/h' ? '28.5 km/h' : '17.7 mph'),
                    _buildPreviewStat('Ambient Temp', _tempUnit == 'Celsius (°C)' ? '18°C' : '64°F'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. INDIVIDUAL UNIT PREFERENCES
          _buildSectionHeader('GRANULAR CONFIGURATION'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildUnitRow(
                  icon: Icons.straighten,
                  title: 'Distance & Tracking',
                  value: _distanceUnit,
                  onTap: () => _showUnitPickerModal(
                    'Distance Unit',
                    ['Kilometers (km)', 'Miles (mi)', 'Meters (m)'],
                    _distanceUnit,
                    (val) => setState(() => _distanceUnit = val),
                  ),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildUnitRow(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Canine Body Weight',
                  value: _weightUnit,
                  onTap: () => _showUnitPickerModal(
                    'Weight Unit',
                    ['Kilograms (kg)', 'Pounds (lbs)'],
                    _weightUnit,
                    (val) => setState(() => _weightUnit = val),
                  ),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildUnitRow(
                  icon: Icons.thermostat_outlined,
                  title: 'Track Temperature',
                  value: _tempUnit,
                  onTap: () => _showUnitPickerModal(
                    'Temperature Unit',
                    ['Celsius (°C)', 'Fahrenheit (°F)'],
                    _tempUnit,
                    (val) => setState(() => _tempUnit = val),
                  ),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildUnitRow(
                  icon: Icons.terrain_outlined,
                  title: 'Elevation Contours',
                  value: _elevationUnit,
                  onTap: () => _showUnitPickerModal(
                    'Elevation Unit',
                    ['Meters (m)', 'Feet (ft)'],
                    _elevationUnit,
                    (val) => setState(() => _elevationUnit = val),
                  ),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildUnitRow(
                  icon: Icons.speed,
                  title: 'Canine Sprint Speed',
                  value: _speedUnit,
                  onTap: () => _showUnitPickerModal(
                    'Speed Unit',
                    ['km/h', 'mph', 'm/s'],
                    _speedUnit,
                    (val) => setState(() => _speedUnit = val),
                  ),
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

  Widget _buildPreviewStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10)),
      ],
    );
  }

  Widget _buildUnitRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _mint.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: _mint, size: 18),
      ),
      title: Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
        ],
      ),
      onTap: onTap,
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
