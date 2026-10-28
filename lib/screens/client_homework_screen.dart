import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'homework_details_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class ClientHomeworkScreen extends StatefulWidget {
  final String clientName;

  const ClientHomeworkScreen({
    super.key,
    this.clientName = 'Sarah Jenkins',
  });

  @override
  State<ClientHomeworkScreen> createState() => _ClientHomeworkScreenState();
}

class _ClientHomeworkScreenState extends State<ClientHomeworkScreen> {
  String _tab = 'All';

  final List<Map<String, dynamic>> _homeworkList = [
    {
      'title': 'Focused Heeling with 90° Right Turns',
      'due': 'Due Tomorrow • Oct 29',
      'status': 'Video Submitted',
      'desc': 'Handler Sarah uploaded a 2-min drill clip recorded in club training field.',
      'hasVideo': true,
      'statusColor': _gold,
    },
    {
      'title': 'Down on the Move (Platz aus der Bewegung)',
      'due': 'Due in 4 days • Nov 02',
      'status': 'In Progress',
      'desc': '3 sessions daily: 10 repetitions per session. Deliver ball reward backwards.',
      'hasVideo': false,
      'statusColor': _mint,
    },
    {
      'title': 'Wooden Article Indication Stays',
      'due': 'Due in 7 days • Nov 05',
      'status': 'Assigned',
      'desc': '20 seconds nose-down stay on article without paw scratching or mouthing.',
      'hasVideo': false,
      'statusColor': _stoneGrey,
    },
    {
      'title': 'Food Luring Engagement & Auto-Sit',
      'due': 'Completed Oct 22',
      'status': 'Reviewed & Passed',
      'desc': 'Critique given: Excellent footwork and calm delivery. Grade: 95% Excellent.',
      'hasVideo': false,
      'statusColor': _mint,
    },
  ];

  void _showAddAssignmentDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Assign New Homework', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Assignment Title (e.g. Hurdle Jump)',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Instructions & Repetition Target',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  _homeworkList.insert(0, {
                    'title': titleController.text.trim(),
                    'due': 'Due in 7 days',
                    'status': 'Assigned',
                    'desc': descController.text.trim().isEmpty ? 'Complete daily drill practice.' : descController.text.trim(),
                    'hasVideo': false,
                    'statusColor': _stoneGrey,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Assign', style: TextStyle(color: _offWhite)),
          ),
        ],
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
        title: Text(
          'Homework: ${widget.clientName}',
          style: const TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _mint),
            onPressed: _showAddAssignmentDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. FILTER TABS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Needs Review', 'In Progress', 'Completed'].map((tab) {
                final isSel = _tab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _tab = tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSel ? _forest : _carbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSel ? _mint : _cardBorder),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSel ? _offWhite : _stoneGrey,
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 2. ASSIGNMENTS LIST
          ..._homeworkList.map((hw) => _buildHomeworkCard(hw)),

          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text('Assign Homework', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: _showAddAssignmentDialog,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeworkCard(Map<String, dynamic> hw) {
    final Color color = hw['statusColor'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeworkDetailsScreen(
              title: hw['title'],
              due: hw['due'],
              status: hw['status'],
              desc: hw['desc'],
              hasVideo: hw['hasVideo'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: hw['hasVideo'] ? _gold.withValues(alpha: 0.3) : _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hw['due'], style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    hw['status'],
                    style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hw['title'],
              style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(hw['desc'], style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4)),
            if (hw['hasVideo']) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF131718),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_outline, color: _gold, size: 16),
                    SizedBox(width: 6),
                    Text('1 Student Video Ready for Review', style: TextStyle(color: _gold, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
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

