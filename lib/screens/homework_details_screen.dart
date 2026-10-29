import 'package:flutter/material.dart';
import 'video_viewer_screen.dart';
import 'document_viewer_screen.dart';
import 'skill_details_screen.dart';
import 'exercise_details_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class HomeworkDetailsScreen extends StatefulWidget {
  final String title;

  const HomeworkDetailsScreen({
    super.key,
    this.title = 'Week 4 Focus & Decoy Engagement Reps',
  });

  @override
  State<HomeworkDetailsScreen> createState() => _HomeworkDetailsScreenState();
}

class _HomeworkDetailsScreenState extends State<HomeworkDetailsScreen> {
  bool _isCompleted = false;
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> _feedbacks = [
    '"Murphy showed significant improvement in handler focus during the second rep. When the decoy accelerates, hold off marking until he offers completely voluntary eye contact."',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _addFeedbackDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Add Trainer Feedback', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            hintText: 'Enter coaching observations and cue timing...',
            hintStyle: TextStyle(color: _stoneGrey),
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
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  _feedbacks.add('"${ctrl.text.trim()}"');
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Post', style: TextStyle(color: _offWhite)),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: _offWhite, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // HOMEWORK SECTION
            const Text(
              'HOMEWORK',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Hero Card
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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _isCompleted ? const Color(0x1F34D399) : const Color(0x1F34D399),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x33EF4444),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'HIGH',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Maintain sustained eye contact and focused heelwork through 3 distinct decoy stationary and passing phases. Prioritize immediate disengagement from distractions before issuing secondary forward cues.',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  Row(
                    children: [
                      _buildMetaCol('ASSIGNED DATE', '14 Nov 2024'),
                      _buildMetaCol('DUE DATE', '22 Nov 2024'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetaCol('ASSIGNED BY', 'Sarah Mitchell'),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ASSIGNED DOG', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Icon(Icons.pets, size: 12, color: _mint),
                                SizedBox(width: 4),
                                Text('Murphy', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCompleted ? const Color(0xFF14241E) : _forest,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() => _isCompleted = !_isCompleted);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isCompleted ? 'Homework marked as completed!' : 'Status reset to In Progress.'),
                            backgroundColor: _forest,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check, color: _offWhite, size: 18),
                      label: Text(
                        _isCompleted ? 'Completed' : 'Mark as Complete',
                        style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'PROGRESS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Progress Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  const Text('68%', style: TextStyle(color: _offWhite, fontSize: 36, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  const Text('Overall Completion', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.68,
                      backgroundColor: Color(0xFF262C30),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _buildProgStat('8 / 12', 'Completed'),
                      Container(width: 1, height: 28, color: _cardBorder),
                      _buildProgStat('4 reps', 'Remaining'),
                      Container(width: 1, height: 28, color: _cardBorder),
                      _buildProgStat('Today', 'Last Active'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  const Text('Updated 15 Nov • 14:32', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'LINKED SKILLS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Linked Skills
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SkillDetailsScreen(skillName: 'Decoy Focus & Steady Drive'),
                ),
              ),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14171A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description_outlined, color: _stoneGrey, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Decoy Focus & Steady Drive', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          const Text('3 sessions completed', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const LinearProgressIndicator(
                              value: 0.7,
                              backgroundColor: Color(0xFF262C30),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'LINKED EXERCISES',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Linked Exercises Card
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildExerciseRow('Eye Contact Drill (15m)', 'ACTIVE', '5 attempts logged this week'),
                  const Divider(color: _cardBorder, height: 1),
                  _buildExerciseRow('Neutral Decoy Pass-by', 'READY', '3 attempts scheduled'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'CLIENT SUBMISSIONS (2)',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text('Reviewing', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),

            // Submissions List
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoViewerScreen(title: 'Morning Decoy Pass Practice'),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.play_arrow, color: _mint, size: 24),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Morning Decoy Pass Practice', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text('Submitted Today • 09:15 AM', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DocumentViewerScreen(title: "Emma's Quick Field Note.pdf"),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.description_outlined, color: _stoneGrey, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Emma's Quick Field Note", style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text('Logged 14 Nov • 18:40', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'TRAINER FEEDBACK',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Trainer Feedback Card
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
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF14241E),
                        ),
                        alignment: Alignment.center,
                        child: const Text('SM', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Sarah Mitchell', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                            Text('Lead Behaviorist', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                          ],
                        ),
                      ),
                      const Text('Yesterday • 16:45', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._feedbacks.map((fb) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        fb,
                        style: const TextStyle(color: _offWhite, fontSize: 13, height: 1.45),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF14241E),
                        side: const BorderSide(color: Color(0x3334D399)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _addFeedbackDialog,
                      icon: const Icon(Icons.add, color: _mint, size: 16),
                      label: const Text('Add Feedback', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'NOTES (SHARED NOTE)',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Notes Card
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
                    children: [
                      const Text('Emma Johnson', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF262C30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('CLIENT', style: TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w800)),
                      ),
                      const Spacer(),
                      const Text('14 Nov • 18:42', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tended to pull slightly toward the fence line when the distraction dog crossed first, but recovered immediately after the collar touch cue.',
                    style: TextStyle(color: _offWhite, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'ATTACHMENTS (2)',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Attachments Grid
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoViewerScreen(title: 'DecoyPass.mp4'),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.play_arrow, color: _mint, size: 20),
                              Text('01:24', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('DecoyPass.mp4', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          const Text('24.5 MB', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DocumentViewerScreen(title: 'Protocol.pdf'),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.description_outlined, color: _stoneGrey, size: 20),
                          const SizedBox(height: 16),
                          const Text('Protocol.pdf', style: TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          const Text('1.2 MB', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaCol(String label, String val) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildProgStat(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(String title, String badge, String subtitle) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExerciseDetailsScreen()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badge == 'ACTIVE' ? const Color(0x1F34D399) : const Color(0xFF1E2B3A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: badge == 'ACTIVE' ? const Color(0xFF34D399) : const Color(0xFF93C5FD),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
          ],
        ),
      ),
    );
  }
}
