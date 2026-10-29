import 'package:flutter/material.dart';

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
  String _selectedSystem = 'Metric';

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Measurement units updated!'), backgroundColor: _forest),
    );
    Navigator.pop(context);
  }

  void _showUnitPicker(String title, List<String> options) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...options.map((opt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(opt, style: const TextStyle(color: _offWhite)),
                  trailing: const Icon(Icons.check, color: _mint),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMetric = _selectedSystem == 'Metric';

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Measurement Units',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: _forest, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // CURRENT SYSTEM
          const Text(
            'CURRENT SYSTEM',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.scale_outlined, color: _stoneGrey, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedSystem,
                        style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isMetric ? 'kg • km • cm • °C' : 'lb • mi • in • °F',
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242A2E),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(
                    _selectedSystem.toUpperCase(),
                    style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3 SYSTEM CARDS
          Row(
            children: [
              _buildSystemCard('Metric', 'kg • km • °C', _selectedSystem == 'Metric'),
              const SizedBox(width: 10),
              _buildSystemCard('Imperial', 'lb • mi • °F', _selectedSystem == 'Imperial'),
              const SizedBox(width: 10),
              _buildSystemCard('Custom', 'Mix & match', _selectedSystem == 'Custom'),
            ],
          ),
          const SizedBox(height: 28),

          // MEASUREMENT CATEGORIES
          const Text(
            'MEASUREMENT CATEGORIES',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubheader('BODY'),
                _buildCategoryTile(
                  icon: Icons.scale_outlined,
                  title: 'Dog Weight',
                  value: isMetric ? 'Kilograms' : 'Pounds',
                  example: isMetric ? '32.4 kg' : '71.4 lb',
                  onTap: () => _showUnitPicker('Dog Weight Unit', ['Kilograms (kg)', 'Pounds (lb)']),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildCategoryTile(
                  icon: Icons.straighten_outlined,
                  title: 'Height & Body',
                  value: isMetric ? 'Centimetres' : 'Inches',
                  example: isMetric ? '68 cm' : '26.8 in',
                  onTap: () => _showUnitPicker('Height & Body Unit', ['Centimetres (cm)', 'Inches (in)']),
                ),
                _buildSubheader('ACTIVITY'),
                _buildCategoryTile(
                  icon: Icons.route_outlined,
                  title: 'Distance',
                  value: isMetric ? 'Kilometres' : 'Miles',
                  example: isMetric ? '4.8 km' : '3.0 mi',
                  onTap: () => _showUnitPicker('Distance Unit', ['Kilometres (km)', 'Miles (mi)']),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildCategoryTile(
                  icon: Icons.near_me_outlined,
                  title: 'Short Distance',
                  value: isMetric ? 'Metres' : 'Yards',
                  example: isMetric ? '15 m' : '16 yd',
                  onTap: () => _showUnitPicker('Short Distance Unit', ['Metres (m)', 'Yards (yd)', 'Feet (ft)']),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildCategoryTile(
                  icon: Icons.access_time_outlined,
                  title: 'Duration',
                  value: 'Hours & Minutes',
                  example: '1 hr 30 min',
                  onTap: () => _showUnitPicker('Duration Unit', ['Hours & Minutes', 'Minutes Only']),
                ),
                _buildSubheader('ENVIRONMENT'),
                _buildCategoryTile(
                  icon: Icons.thermostat_outlined,
                  title: 'Temperature',
                  value: isMetric ? 'Celsius' : 'Fahrenheit',
                  example: isMetric ? '14°C' : '57°F',
                  onTap: () => _showUnitPicker('Temperature Unit', ['Celsius (°C)', 'Fahrenheit (°F)']),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildCategoryTile(
                  icon: Icons.water_drop_outlined,
                  title: 'Liquid Volume',
                  value: isMetric ? 'Millilitres / Litres' : 'Fluid Ounces',
                  example: isMetric ? '250 ml' : '8.5 fl oz',
                  onTap: () => _showUnitPicker('Liquid Volume Unit', ['Millilitres / Litres', 'Fluid Ounces / Pints']),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // PREVIEW
          const Text(
            'PREVIEW',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildPreviewItem('DOG WEIGHT', isMetric ? '32.4 kg' : '71.4 lb')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildPreviewItem('DISTANCE', isMetric ? '4.8 km' : '3.0 mi')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildPreviewItem('JUMP HEIGHT', isMetric ? '60 cm' : '24 in')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildPreviewItem('TEMPERATURE', isMetric ? '14°C' : '57°F')),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Values shown using your current unit preferences.',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SAVE BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _save,
              child: const Text('Save Measurement Units', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSystemCard(String name, String sub, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSystem = name),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? _forest : _cardBorder, width: isSelected ? 1.5 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  if (isSelected) const Icon(Icons.check, color: _mint, size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Text(sub, style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: name == 'Custom' ? FontStyle.italic : FontStyle.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubheader(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF14191C),
      child: Text(text, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
    );
  }

  Widget _buildCategoryTile({
    required IconData icon,
    required String title,
    required String value,
    required String example,
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
              child: Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(example, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF14191C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
