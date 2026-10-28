import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'contact_support_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _blue = Color(0xFF5D8FAF);
const Color _orange = Color(0xFFDD6B20);
const Color _gold = Color(0xFFECC94B);

class HelpCentreScreen extends StatefulWidget {
  const HelpCentreScreen({super.key});

  @override
  State<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends State<HelpCentreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _expandedFaqIndices = {0};

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Getting Started',
      'articles': '6 Articles',
      'icon': Icons.flag_outlined,
      'color': _mint,
    },
    {
      'title': 'GPS & Field Maps',
      'articles': '8 Articles',
      'icon': Icons.explore_outlined,
      'color': _blue,
    },
    {
      'title': 'S&C & Telemetry',
      'articles': '12 Articles',
      'icon': Icons.fitness_center_outlined,
      'color': _orange,
    },
    {
      'title': 'Cloud & Offline',
      'articles': '5 Articles',
      'icon': Icons.cloud_done_outlined,
      'color': _gold,
    },
  ];

  final List<Map<String, String>> _allFaqs = [
    {
      'q': 'How do I record training sessions without cellular service?',
      'a': 'Enable "Force Offline Field Mode" under Offline Mode & Downloads. You can pre-download topographic 1:24k contour maps and drill videos for backcountry sessions. All telemetry logs will automatically sync when you reconnect.',
    },
    {
      'q': 'How do I pair an external canine heart rate monitor?',
      'a': 'Ulvenik connects via Bluetooth BLE to standard Polar, Garmin, and equine/canine sensor straps. Turn on Bluetooth on your device, start a training drill, and tap the Heart Rate telemetry badge to initiate pairing.',
    },
    {
      'q': 'What formats can I export my timeline archives in?',
      'a': 'You can export complete records as professionally structured PDF reports (ideal for veterinary consults and competition registries) or raw CSV spreadsheets containing second-by-second GPS and biometric data.',
    },
    {
      'q': 'How are conditioning fatigue scores calculated?',
      'a': 'Fatigue indices are computed using heart rate variability (HRV), session elevation delta, continuous work duration, and environmental temperature logged during the drill.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.trim().isEmpty) return _allFaqs;
    return _allFaqs.where((f) {
      final q = f['q']!.toLowerCase();
      final a = f['a']!.toLowerCase();
      final search = _searchQuery.toLowerCase();
      return q.contains(search) || a.contains(search);
    }).toList();
  }

  void _showCategoryDetail(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Comprehensive documentation, drill diagrams, and calibration manuals for $title.',
                style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Back to Help Centre', style: TextStyle(color: _offWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

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
          'Help Centre',
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
                hintText: 'Search manuals, FAQs & telemetry guides...',
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
          const SizedBox(height: 20),

          // 2. KNOWLEDGE BASE BENTO CATEGORIES
          _buildSectionHeader('EXPLORE BY TOPIC'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTopicCard(_categories[0])),
              const SizedBox(width: 10),
              Expanded(child: _buildTopicCard(_categories[1])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTopicCard(_categories[2])),
              const SizedBox(width: 10),
              Expanded(child: _buildTopicCard(_categories[3])),
            ],
          ),
          const SizedBox(height: 24),

          // 3. FREQUENTLY ASKED QUESTIONS ACCORDION
          _buildSectionHeader('FREQUENTLY ASKED QUESTIONS'),
          const SizedBox(height: 10),
          if (faqs.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Text('No matching articles found.', style: TextStyle(color: _stoneGrey, fontSize: 13)),
            )
          else
            ...faqs.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isExpanded = _expandedFaqIndices.contains(idx);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isExpanded ? _mint.withValues(alpha: 0.3) : _cardBorder),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedFaqIndices.remove(idx);
                          } else {
                            _expandedFaqIndices.add(idx);
                          }
                        });
                      },
                      title: Text(
                        item['q']!,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: isExpanded ? _mint : _stoneGrey,
                        size: 20,
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Text(
                          item['a']!,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 20),

          // 4. STILL NEED HELP CTA CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _mint.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.headset_mic_outlined, color: _mint, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Still Need Help?',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Our canine handler support team is on standby 24/7',
                        style: TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
                    );
                  },
                  child: const Text('Contact', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w700)),
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

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    final Color color = topic['color'];
    return GestureDetector(
      onTap: () => _showCategoryDetail(topic['title']),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(topic['icon'], color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              topic['title'],
              style: const TextStyle(
                color: _offWhite,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              topic['articles'],
              style: const TextStyle(color: _stoneGrey, fontSize: 11),
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
