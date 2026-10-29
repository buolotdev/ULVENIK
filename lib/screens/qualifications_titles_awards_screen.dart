import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class QualificationsTitlesAwardsScreen extends StatefulWidget {
  const QualificationsTitlesAwardsScreen({super.key});

  @override
  State<QualificationsTitlesAwardsScreen> createState() =>
      _QualificationsTitlesAwardsScreenState();
}

class _QualificationsTitlesAwardsScreenState
    extends State<QualificationsTitlesAwardsScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'title': 'IGP 1',
      'sport': 'IGP',
      'type': 'Qualification',
      'date': '15 Sep 2026',
      'icon': Icons.emoji_events_outlined,
    },
    {
      'title': 'Best Protection Work',
      'sport': 'IGP',
      'type': 'Award',
      'date': '15 Sep 2026',
      'icon': Icons.emoji_events_outlined,
    },
    {
      'title': 'IPO Champion 2025',
      'sport': 'IGP',
      'type': 'Title',
      'date': '12 Nov 2025',
      'icon': Icons.star_border,
    },
    {
      'title': 'BH',
      'sport': 'IGP',
      'type': 'Qualification',
      'date': '4 Mar 2025',
      'icon': Icons.emoji_events_outlined,
    },
    {
      'title': 'Kennel Club Foundation Certificat',
      'sport': 'AGILITY',
      'type': 'Certificate',
      'date': '18 Jan 2025',
      'icon': Icons.description_outlined,
    },
  ];

  void _addNewAchievement() {
    final titleCtrl = TextEditingController();
    String selectedType = 'Qualification';
    String selectedSport = 'IGP';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: _carbon,
          title: const Text('Add Achievement', style: TextStyle(color: _offWhite)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: _offWhite),
                decoration: const InputDecoration(
                  labelText: 'Title or Name',
                  labelStyle: TextStyle(color: _stoneGrey),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                dropdownColor: _carbon,
                items: const [
                  DropdownMenuItem(value: 'Qualification', child: Text('Qualification', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'Title', child: Text('Title', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'Award', child: Text('Award', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'Certificate', child: Text('Certificate', style: TextStyle(color: _offWhite))),
                ],
                onChanged: (val) {
                  if (val != null) setDlgState(() => selectedType = val);
                },
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: selectedSport,
                isExpanded: true,
                dropdownColor: _carbon,
                items: const [
                  DropdownMenuItem(value: 'IGP', child: Text('IGP', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'AGILITY', child: Text('AGILITY', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'PSA', child: Text('PSA', style: TextStyle(color: _offWhite))),
                  DropdownMenuItem(value: 'OBEDIENCE', child: Text('OBEDIENCE', style: TextStyle(color: _offWhite))),
                ],
                onChanged: (val) {
                  if (val != null) setDlgState(() => selectedSport = val);
                },
              ),
            ],
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
                    _items.insert(0, {
                      'title': titleCtrl.text.trim(),
                      'sport': selectedSport,
                      'type': selectedType,
                      'date': 'Today',
                      'icon': selectedType == 'Title'
                          ? Icons.star_border
                          : selectedType == 'Certificate'
                              ? Icons.description_outlined
                              : Icons.emoji_events_outlined,
                    });
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add', style: TextStyle(color: _offWhite)),
            ),
          ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Qualifications & Awards',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _addNewAchievement,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Top 4 Metrics Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMetricCard('4', 'Qualifications'),
                  const SizedBox(width: 8),
                  _buildMetricCard('1', 'Titles'),
                  const SizedBox(width: 8),
                  _buildMetricCard('3', 'Awards'),
                  const SizedBox(width: 8),
                  _buildMetricCard('15 Sep 2026', 'Latest', isTextVal: true),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'ALL ACHIEVEMENTS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Achievement Cards List
            ..._items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14171A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: _stoneGrey,
                        size: 22,
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
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A2634),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['sport'] as String,
                                  style: const TextStyle(
                                    color: Color(0xFF93C5FD),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF262C30),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['type'] as String,
                                  style: const TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item['date'] as String,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                ),
                              ),
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
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String val, String label, {bool isTextVal = false}) {
    return Container(
      width: isTextVal ? 110 : 84,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              color: _offWhite,
              fontSize: isTextVal ? 13 : 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
