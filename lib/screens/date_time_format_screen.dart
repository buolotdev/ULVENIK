import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class DateTimeFormatScreen extends StatefulWidget {
  const DateTimeFormatScreen({super.key});

  @override
  State<DateTimeFormatScreen> createState() => _DateTimeFormatScreenState();
}

class _DateTimeFormatScreenState extends State<DateTimeFormatScreen> {
  bool _useRegionalFormat = false;
  String _selectedDateFormat = '29 July 2026';
  String _selectedTimeFormat = '24-Hour';
  String _selectedFirstDay = 'Monday';

  final List<Map<String, String>> _dateFormats = [
    {'title': '29 July 2026', 'example': ''},
    {'title': 'DD/MM/YYYY', 'example': '29/07/2026'},
    {'title': 'MM/DD/YYYY', 'example': '07/29/2026'},
    {'title': 'YYYY-MM-DD', 'example': '2026-07-29'},
    {'title': '29 Jul 2026', 'example': '29 Jul 2026'},
  ];

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date & time format saved!'), backgroundColor: _forest),
    );
    Navigator.pop(context);
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
          'Date & Time Format',
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
          // CURRENT FORMAT
          const Text(
            'CURRENT FORMAT',
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
                const Icon(Icons.calendar_today_outlined, color: _stoneGrey, size: 24),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDateFormat == '29 July 2026' ? '29 July 2026' : _selectedDateFormat,
                      style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedTimeFormat == '24-Hour' ? '14:35' : '2:35 PM',
                      style: const TextStyle(color: _stoneGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Week starts $_selectedFirstDay',
                      style: const TextStyle(color: _stoneGrey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // USE REGIONAL FORMAT TOGGLE
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
                        'Use Regional Format',
                        style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Follows date and time conventions for your selected country',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _useRegionalFormat,
                  activeThumbColor: _mint,
                  activeTrackColor: _forest,
                  onChanged: (v) => setState(() => _useRegionalFormat = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // DATE FORMAT
          const Text(
            'DATE FORMAT',
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
                for (int i = 0; i < _dateFormats.length; i++) ...[
                  _buildSelectableTile(
                    title: _dateFormats[i]['title']!,
                    trailing: _dateFormats[i]['example']!,
                    isSelected: _selectedDateFormat == _dateFormats[i]['title'],
                    onTap: () => setState(() => _selectedDateFormat = _dateFormats[i]['title']!),
                  ),
                  if (i < _dateFormats.length - 1)
                    const Divider(color: _cardBorder, height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),

          // TIME FORMAT
          const Text(
            'TIME FORMAT',
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
                _buildSelectableTile(
                  title: '24-Hour',
                  trailing: '14:35',
                  isSelected: _selectedTimeFormat == '24-Hour',
                  onTap: () => setState(() => _selectedTimeFormat = '24-Hour'),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildSelectableTile(
                  title: '12-Hour',
                  trailing: '2:35 PM',
                  isSelected: _selectedTimeFormat == '12-Hour',
                  onTap: () => setState(() => _selectedTimeFormat = '12-Hour'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // FIRST DAY OF WEEK
          const Text(
            'FIRST DAY OF WEEK',
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
                _buildSelectableTile(
                  title: 'Monday',
                  trailing: 'Mon • Tue • Wed...',
                  isSelected: _selectedFirstDay == 'Monday',
                  onTap: () => setState(() => _selectedFirstDay = 'Monday'),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildSelectableTile(
                  title: 'Sunday',
                  trailing: 'Sun • Mon • Tue...',
                  isSelected: _selectedFirstDay == 'Sunday',
                  onTap: () => setState(() => _selectedFirstDay = 'Sunday'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TRAINING SESSION', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                const Text('Wednesday 29 July 2026', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  _selectedTimeFormat == '24-Hour' ? '14:35 – 15:20' : '2:35 PM – 3:20 PM',
                  style: const TextStyle(color: _stoneGrey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),
                const Text('REMINDER', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                const Text('Thursday 30 July 2026', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  _selectedTimeFormat == '24-Hour' ? '09:00' : '9:00 AM',
                  style: const TextStyle(color: _stoneGrey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),
                const Text('CALENDAR WEEK', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                Text('Week begins $_selectedFirstDay', style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  _selectedFirstDay == 'Monday'
                      ? 'Mon • Tue • Wed • Thu • Fri • Sat • Sun'
                      : 'Sun • Mon • Tue • Wed • Thu • Fri • Sat',
                  style: const TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 12),
                const Text(
                  'Historical records remain unchanged. Only how they are displayed will change.',
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
              child: const Text('Save Date & Time Format', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSelectableTile({
    required String title,
    required String trailing,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(left: BorderSide(color: _mint, width: 3))
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            if (trailing.isNotEmpty) ...[
              Text(trailing, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
              const SizedBox(width: 8),
            ],
            if (isSelected) const Icon(Icons.check, color: _mint, size: 18),
          ],
        ),
      ),
    );
  }
}
