import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'competition_details_screen.dart';
import 'add_competition_screen.dart';

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

class CompetitionsOverviewScreen extends StatefulWidget {
  const CompetitionsOverviewScreen({super.key});

  @override
  State<CompetitionsOverviewScreen> createState() =>
      _CompetitionsOverviewScreenState();
}

class _CompetitionsOverviewScreenState extends State<CompetitionsOverviewScreen> {
  int _selectedTab = 0; // 0 = Upcoming, 1 = Past

  final List<Map<String, dynamic>> _upcoming = [
    {
      'title': 'Pacific Northwest IGP Championship',
      'date': 'Nov 14, 2026 • 08:00 AM',
      'location': 'Highland Park Grounds, WA',
      'level': 'IGP III Trial',
      'dog': 'Koda vom Alpenhof',
      'status': 'Confirmed',
      'color': _mint,
    },
    {
      'title': 'National Tracking Invitational (FH2)',
      'date': 'Dec 05, 2026 • 07:30 AM',
      'location': 'Cascade Mountain Forest Grid',
      'level': 'FH2 1800-Pace Track',
      'dog': 'Koda',
      'status': 'Registered',
      'color': _blue,
    },
  ];

  final List<Map<String, dynamic>> _past = [
    {
      'title': 'National Fall Working Dog Trial',
      'date': 'Oct 12, 2026',
      'location': 'Silver Creek Canine Club',
      'level': 'IGP II Trial',
      'dog': 'Koda',
      'score': '284 / 300 pts (V)',
      'placement': '1st Place • Gold',
      'color': _gold,
    },
    {
      'title': 'Spring Regional Championship',
      'date': 'May 18, 2026',
      'location': 'Olympia Sports Fields',
      'level': 'IGP I Trial',
      'dog': 'Koda',
      'score': '276 / 300 pts (SG)',
      'placement': '2nd Place • Silver',
      'color': _mint,
    },
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
          'Competitions & Trials',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _mint),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCompetitionScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. TAB SELECTOR
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
                    onTap: () => setState(() => _selectedTab = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? _forest : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Upcoming Trials (${_upcoming.length})',
                          style: TextStyle(
                            color: _selectedTab == 0 ? _offWhite : _stoneGrey,
                            fontSize: 13,
                            fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? _forest : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Past Trials (${_past.length})',
                          style: TextStyle(
                            color: _selectedTab == 1 ? _offWhite : _stoneGrey,
                            fontSize: 13,
                            fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 2. TRIAL CARDS LIST
          if (_selectedTab == 0)
            ..._upcoming.map((t) => _buildUpcomingCard(t))
          else
            ..._past.map((t) => _buildPastCard(t)),

          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text('Add Trial', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCompetitionScreen()),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildUpcomingCard(Map<String, dynamic> trial) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(trial['level'], style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
                Text(trial['status'], style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              trial['title'],
              style: const TextStyle(
                color: _offWhite,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_month, color: _stoneGrey, size: 13),
                const SizedBox(width: 4),
                Text(trial['date'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: _stoneGrey, size: 13),
                const SizedBox(width: 4),
                Text(trial['location'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastCard(Map<String, dynamic> trial) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompetitionDetailsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _gold.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: _gold, size: 18),
                    const SizedBox(width: 6),
                    Text(trial['placement'], style: const TextStyle(color: _gold, fontSize: 12, fontWeight: FontWeight.w800)),
                  ],
                ),
                Text(trial['score'], style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              trial['title'],
              style: const TextStyle(
                color: _offWhite,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text('${trial['level']} • ${trial['date']} • ${trial['location']}', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
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
