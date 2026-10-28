import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'video_viewer_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class HomeworkDetailsScreen extends StatefulWidget {
  final String title;
  final String due;
  final String status;
  final String desc;
  final bool hasVideo;

  const HomeworkDetailsScreen({
    super.key,
    this.title = 'Focused Heeling with 90° Right Turns',
    this.due = 'Due Tomorrow • Oct 29',
    this.status = 'Video Submitted',
    this.desc = 'Handler Sarah uploaded a 2-min drill clip recorded in club training field.',
    this.hasVideo = true,
  });

  @override
  State<HomeworkDetailsScreen> createState() => _HomeworkDetailsScreenState();
}

class _HomeworkDetailsScreenState extends State<HomeworkDetailsScreen> {
  final _critiqueController = TextEditingController(
    text: 'Great attention and upward focus on the turn! Make sure not to bend your left wrist forward as that pulls Baron slightly out of heel position.',
  );
  String _grade = 'Pass (Excellent)';

  @override
  void dispose() {
    _critiqueController.dispose();
    super.dispose();
  }

  void _submitEvaluation() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback sent to client portal.'),
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Assignment Review',
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
          // 1. HERO CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.due, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.status,
                        style: const TextStyle(color: _gold, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(widget.desc, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. VIDEO SUBMISSION VIEWPORT
          if (widget.hasVideo) ...[
            _buildSectionHeader('STUDENT DRILL FOOTAGE (02:14)'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VideoViewerScreen(
                      title: 'Sarah & Baron — Focused Heeling Drill',
                      dogName: 'Baron • German Shepherd',
                      duration: '02:14',
                    ),
                  ),
                );
              },
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF131718),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.videocam_outlined, size: 64, color: _mint),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: _forest,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, color: _offWhite, size: 30),
                    ),
                    const Positioned(
                      bottom: 12,
                      right: 14,
                      child: Text('02:14 • Tap to review', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 3. GRADE & CRITIQUE
          _buildSectionHeader('TRAINER EVALUATION & GRADE'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _grade,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                style: const TextStyle(color: _offWhite, fontSize: 14),
                items: ['Pass (Excellent)', 'Pass with Critique', 'Needs Another Submission', 'Assignment Incomplete']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _grade = val!),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _critiqueController,
              maxLines: 4,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter feedback for handler...',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 4. SUBMIT BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submitEvaluation,
              child: const Text('Send Evaluation to Client', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
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

