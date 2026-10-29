import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class AchievementsTitlesScreen extends StatefulWidget {
  const AchievementsTitlesScreen({super.key});

  @override
  State<AchievementsTitlesScreen> createState() =>
      _AchievementsTitlesScreenState();
}

class _AchievementsTitlesScreenState extends State<AchievementsTitlesScreen> {
  bool _titlesExpanded = true;
  bool _qualificationsExpanded = false;
  bool _awardsExpanded = false;
  bool _personalBestsExpanded = false;
  bool _milestonesExpanded = false;

  final List<Map<String, dynamic>> _titlesList = [
    {
      'title': 'IGP3',
      'subtitle': 'National IGP Championship 2024',
      'date': '14 Sep 2024',
      'cert': true,
    },
    {
      'title': 'IGP2',
      'subtitle': 'Regional Qualifier 2023',
      'date': '22 Jun 2023',
      'cert': false,
    },
    {
      'title': 'IGP1',
      'subtitle': 'Club Trial 2022',
      'date': '05 Mar 2022',
      'cert': true,
    },
  ];

  void _addCustomAchievement() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Add Custom Achievement', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            labelText: 'Achievement Title',
            labelStyle: TextStyle(color: _stoneGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _forest),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _titlesList.insert(0, {
                    'title': titleCtrl.text.trim(),
                    'subtitle': 'Custom Title Entry',
                    'date': 'Today',
                    'cert': false,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating official canine achievement report PDF...'),
        backgroundColor: _forest,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Achievements & Titles',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: _offWhite, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // 2x3 Bento Grid Summary Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildBentoCell('4', 'TITLES'),
                      _buildBentoDivider(),
                      _buildBentoCell('12', 'QUALIFICATIONS'),
                      _buildBentoDivider(),
                      _buildBentoCell('7', 'AWARDS'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 28),
                  Row(
                    children: [
                      _buildBentoCell('9', 'PERSONAL\nBESTS'),
                      _buildBentoDivider(),
                      _buildBentoCell('3', 'WINS'),
                      _buildBentoDivider(),
                      _buildBentoCell('IGP3', 'HIGHEST'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Titles Accordion
            _buildAccordionHeader(
              icon: Icons.emoji_events_outlined,
              title: 'Titles',
              count: 4,
              isExpanded: _titlesExpanded,
              onTap: () => setState(() => _titlesExpanded = !_titlesExpanded),
            ),
            if (_titlesExpanded)
              Container(
                margin: const EdgeInsets.only(top: 2, bottom: 12),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: _titlesList.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isLast = entry.key == _titlesList.length - 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF14241E),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0x3334D399)),
                                ),
                                child: const Icon(
                                  Icons.emoji_events_outlined,
                                  color: _mint,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        color: _offWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['subtitle'] as String,
                                      style: const TextStyle(
                                        color: _stoneGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          item['date'] as String,
                                          style: const TextStyle(
                                            color: _stoneGrey,
                                            fontSize: 11,
                                          ),
                                        ),
                                        if (item['cert'] == true) ...[
                                          const SizedBox(width: 8),
                                          const Text(
                                            '•',
                                            style: TextStyle(color: _stoneGrey),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.description_outlined,
                                            size: 13,
                                            color: _mint,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            'Certificate',
                                            style: TextStyle(
                                              color: _mint,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: _stoneGrey,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) const Divider(color: _cardBorder, height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),

            // Qualifications Accordion
            const SizedBox(height: 10),
            _buildAccordionHeader(
              icon: Icons.flag_outlined,
              title: 'Qualifications',
              count: 12,
              isExpanded: _qualificationsExpanded,
              onTap: () =>
                  setState(() => _qualificationsExpanded = !_qualificationsExpanded),
            ),
            if (_qualificationsExpanded)
              _buildSimpleList(['BH-VT • 2022', 'IGP 1 Tracking • 2023', 'IGP 2 Protection • 2024']),

            // Awards Accordion
            const SizedBox(height: 10),
            _buildAccordionHeader(
              icon: Icons.military_tech_outlined,
              title: 'Awards',
              count: 7,
              isExpanded: _awardsExpanded,
              onTap: () => setState(() => _awardsExpanded = !_awardsExpanded),
            ),
            if (_awardsExpanded)
              _buildSimpleList(['High in Trial 2024', 'Best Helper Award 2023']),

            // Personal Bests Accordion
            const SizedBox(height: 10),
            _buildAccordionHeader(
              icon: Icons.star_border,
              title: 'Personal Bests',
              count: 9,
              isExpanded: _personalBestsExpanded,
              onTap: () =>
                  setState(() => _personalBestsExpanded = !_personalBestsExpanded),
            ),
            if (_personalBestsExpanded)
              _buildSimpleList(['Max Protection Score: 98/100', 'Top Agility Time: 34.2s']),

            // Milestones Accordion
            const SizedBox(height: 10),
            _buildAccordionHeader(
              icon: Icons.calendar_today_outlined,
              title: 'Milestones',
              count: 3,
              isExpanded: _milestonesExpanded,
              onTap: () => setState(() => _milestonesExpanded = !_milestonesExpanded),
            ),
            if (_milestonesExpanded)
              _buildSimpleList(['First Official Trial Registered', 'Kennel Club Verified Status']),

            const SizedBox(height: 24),

            // Add Custom Achievement Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF141F1A),
                side: const BorderSide(color: Color(0x3334D399)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addCustomAchievement,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: _mint, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Add Custom Achievement',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Generate Achievement Report Button
            InkWell(
              onTap: _generateReport,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.file_upload_outlined, color: _stoneGrey, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Generate Achievement Report',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCell(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoDivider() {
    return Container(
      width: 1,
      height: 36,
      color: _cardBorder,
    );
  }

  Widget _buildAccordionHeader({
    required IconData icon,
    required String title,
    required int count,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: isExpanded
              ? const BorderRadius.vertical(top: Radius.circular(16))
              : BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF262C30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: _stoneGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleList(List<String> items) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: items.map((t) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: _mint, size: 16),
                const SizedBox(width: 8),
                Text(t, style: const TextStyle(color: _offWhite, fontSize: 13)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
