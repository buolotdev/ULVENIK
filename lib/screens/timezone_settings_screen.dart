import 'package:flutter/material.dart';

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
    this.currentTimezone = 'Europe/London',
  });

  @override
  State<TimezoneSettingsScreen> createState() => _TimezoneSettingsScreenState();
}

class _TimezoneSettingsScreenState extends State<TimezoneSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _useDeviceTimezone = true;
  late String _selectedTimezone;

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

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Time zone saved!'), backgroundColor: _forest),
    );
    Navigator.pop(context, _selectedTimezone);
  }

  @override
  Widget build(BuildContext context) {
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
          'Time Zone',
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
          // CURRENT TIME ZONE
          const Text(
            'CURRENT TIME ZONE',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.access_time, color: _stoneGrey, size: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242A2E),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Text('AUTOMATIC', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedTimezone,
                  style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('13:42', style: TextStyle(color: _offWhite, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('UTC +01:00', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // USE DEVICE TIME ZONE TOGGLE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, color: _stoneGrey, size: 20),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Device Time Zone',
                        style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ulvenik will follow the time zone set on this device',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _useDeviceTimezone,
                  activeThumbColor: _mint,
                  activeTrackColor: _forest,
                  onChanged: (v) => setState(() => _useDeviceTimezone = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SEARCH INPUT
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search, color: _stoneGrey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search city, country or time zone',
                      hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SUGGESTED
          const Text(
            'SUGGESTED',
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
              children: [
                _buildTimezoneTile('London', 'United Kingdom • UTC +01:00', '13:42', isSelected: true),
                const Divider(color: _cardBorder, height: 1),
                _buildTimezoneTile('London', 'Device region • Europe/London', '13:42', isSelected: false),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ALL TIME ZONES
          const Text(
            'ALL TIME ZONES',
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
                _buildRegionHeader('EUROPE'),
                _buildTimezoneTile('London', 'United Kingdom • UTC +01:00', '13:42', isSelected: true),
                const Divider(color: _cardBorder, height: 1),
                _buildTimezoneTile('Madrid', 'Spain • UTC +02:00', '14:42', isSelected: false),
                const Divider(color: _cardBorder, height: 1),
                _buildTimezoneTile('Stockholm', 'Sweden • UTC +02:00', '14:42', isSelected: false),
                _buildRegionHeader('NORTH AMERICA'),
                _buildTimezoneTile('New York', 'United States • UTC -04:00', '08:42', isSelected: false),
                const Divider(color: _cardBorder, height: 1),
                _buildTimezoneTile('Los Angeles', 'United States • UTC -07:00', '05:42', isSelected: false),
                _buildRegionHeader('ASIA'),
                _buildTimezoneTile('Dubai', 'United Arab Emirates • UTC +04:00', '17:42', isSelected: false),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TIME ZONE', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                        const SizedBox(height: 4),
                        Text(_selectedTimezone, style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('CURRENT TIME', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                        SizedBox(height: 4),
                        Text('13:42', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),
                const Text('UTC OFFSET', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                const Text('UTC +01:00 • British Summer Time', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),
                const Text(
                  'Historical records remain unchanged. Only displayed times will change.',
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
              child: const Text('Save Time Zone', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRegionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF14191C),
      child: Text(title, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
    );
  }

  Widget _buildTimezoneTile(String city, String details, String time, {required bool isSelected}) {
    return InkWell(
      onTap: () => setState(() => _selectedTimezone = city == 'London' ? 'Europe/London' : city),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(city, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(details, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            ),
            Text(time, style: const TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check, color: _mint, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
