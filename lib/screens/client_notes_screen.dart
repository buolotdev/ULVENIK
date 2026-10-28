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

class ClientNotesScreen extends StatefulWidget {
  final String clientName;

  const ClientNotesScreen({
    super.key,
    this.clientName = 'Sarah Jenkins',
  });

  @override
  State<ClientNotesScreen> createState() => _ClientNotesScreenState();
}

class _ClientNotesScreenState extends State<ClientNotesScreen> {
  final _newNoteController = TextEditingController();

  final List<Map<String, String>> _notes = [
    {
      'date': 'Oct 27, 2026 • Private Session #14',
      'title': 'Phase B Heeling & Bite Sleeve Out',
      'content': 'Baron showed high focus in focused heeling through left and right turns. Grip on sleeve is full caliper and steady. Handler Sarah needs to relax shoulder tension during send-out and deliver verbal "Aus" marker with decisive calm authority.',
      'author': 'Alex Rivers, Head Trainer',
    },
    {
      'date': 'Oct 20, 2026 • Private Session #13',
      'title': '1-Meter Hurdle Dumbbell Retrieve',
      'content': 'Cleared the 1m wooden hurdle clean on approach without touching bar. Slow return trot; recommended switching reward to high-value Chuckit ball toss over handler head to create explosive return speed.',
      'author': 'Alex Rivers, Head Trainer',
    },
    {
      'date': 'Oct 14, 2026 • Evaluation Intake',
      'title': 'Canine Drive & Working Baseline',
      'content': 'Initial evaluation: High food drive, strong prey drive with leather tug. Handler is dedicated and follows mechanics well. Focus on building drive threshold before adding obedience criteria.',
      'author': 'Alex Rivers, Head Trainer',
    },
  ];

  @override
  void dispose() {
    _newNoteController.dispose();
    super.dispose();
  }

  void _addNote() {
    final text = _newNoteController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _notes.insert(0, {
        'date': 'Today • Session Observation',
        'title': 'Quick Field Note',
        'content': text,
        'author': 'Alex Rivers, Head Trainer',
      });
      _newNoteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note added to client record.'), backgroundColor: _forest),
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
          'Notes: ${widget.clientName}',
          style: const TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. NOTES LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                ..._notes.map((note) => _buildNoteCard(note)),
              ],
            ),
          ),

          // 2. QUICK ADD NOTE BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: _carbon,
              border: Border(top: BorderSide(color: _cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF131718),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: TextField(
                        controller: _newNoteController,
                        style: const TextStyle(color: _offWhite, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Add private session observation...',
                          hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _addNote,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.send, color: _offWhite, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildNoteCard(Map<String, String> note) {
    return Container(
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
              Text(note['date']!, style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
              const Icon(Icons.lock_outline, color: _stoneGrey, size: 14),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            note['title']!,
            style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            note['content']!,
            style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.45),
          ),
          const SizedBox(height: 8),
          Text(
            '— ${note['author']!}',
            style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
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

