import 'package:flutter/material.dart';
import 'record_session_screen.dart';
import 'client_permissions_screen.dart';
import 'video_viewer_screen.dart';
import 'goal_details_screen.dart';
import 'health_records_screen.dart';
import 'trainer_reports_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ClientDogProfileScreen extends StatefulWidget {
  final String dogName;
  final String breed;
  final String handlerName;

  const ClientDogProfileScreen({
    super.key,
    this.dogName = 'Murphy',
    this.breed = 'Golden Retriever • 3 Years • Male (Intact)',
    this.handlerName = 'Emma Johnson',
  });

  @override
  State<ClientDogProfileScreen> createState() => _ClientDogProfileScreenState();
}

class _ClientDogProfileScreenState extends State<ClientDogProfileScreen> {
  void _showDogMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _stoneGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: _stoneGrey),
                title: const Text('Edit Dog Profile', style: TextStyle(color: _offWhite)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: _stoneGrey),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Dog Profile opened.'), backgroundColor: _forest),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: _stoneGrey),
                title: const Text('Share Progress Report', style: TextStyle(color: _offWhite)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: _stoneGrey),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progress report shared.'), backgroundColor: _forest),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download_outlined, color: _stoneGrey),
                title: const Text('Export Dog Records', style: TextStyle(color: _offWhite)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: _stoneGrey),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Records exported.'), backgroundColor: _forest),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline, color: _stoneGrey),
                title: const Text('Archive Dog (Owner Permission Required)', style: TextStyle(color: _stoneGrey)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Archive requires owner approval.'), backgroundColor: Colors.redAccent),
                  );
                },
              ),
            ],
          ),
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
        title: Text(
          widget.dogName,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: _offWhite, size: 24),
            onPressed: _showDogMenu,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Dog Hero Card with Forest Photo Background
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E2E24), Color(0xFF111A15)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.pets, size: 56, color: _mint),
                          SizedBox(height: 6),
                          Text(
                            'Murphy',
                            style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.dogName,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0x1F34D399),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0x4D34D399)),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.lock_open, size: 11, color: Color(0xFF34D399)),
                                  SizedBox(width: 4),
                                  Text(
                                    'EDITABLE',
                                    style: TextStyle(
                                      color: Color(0xFF34D399),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.breed,
                          style: const TextStyle(color: _stoneGrey, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Owner: ${widget.handlerName}',
                          style: const TextStyle(color: _stoneGrey, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: ['IGP 1', 'OBEDIENCE', 'TRACKING'].map((chip) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF14171A),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: Text(
                                chip,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // 2 Primary Action Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _forest,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RecordSessionScreen()),
                            ),
                            icon: const Icon(Icons.play_arrow, color: _offWhite, size: 20),
                            label: const Text(
                              'Start Training Session',
                              style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF14171A),
                              side: const BorderSide(color: _cardBorder),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RecordSessionScreen()),
                            ),
                            icon: const Icon(Icons.fitness_center_outlined, color: _offWhite, size: 18),
                            label: const Text(
                              'Start S&C Session',
                              style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'OVERVIEW',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'TRAINER VIEW',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Overview 2-col info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildInfoCol('Date of Birth', '14 May 2023'),
                      _buildInfoCol('Current Weight', '32.4 kg'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 20),
                  Row(
                    children: [
                      _buildInfoCol('Active Sports', 'IGP, Tracking'),
                      _buildInfoCol('Current Goals', '3 Active'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 20),
                  Row(
                    children: [
                      _buildInfoCol('Last Session', 'Yesterday 10:30'),
                      _buildInfoCol('Last Health Update', '3 days ago'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Text('Training Streak', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                      ),
                      Text(
                        '12 Days Active 🔥',
                        style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'QUICK STATS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Quick Stats 3-card Row
            Row(
              children: [
                _buildQuickStat('47', 'TOTAL SESSIONS', Icons.assignment_outlined),
                const SizedBox(width: 10),
                _buildQuickStat('18', 'S&C SESSIONS', Icons.grid_view_outlined),
                const SizedBox(width: 10),
                _buildQuickStat('38.5h', 'HOURS TRAINED', Icons.schedule_outlined),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'ACTIONS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // 8 Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildActionIcon(Icons.assignment_outlined, 'Training', () {}),
                _buildActionIcon(Icons.fitness_center_outlined, 'S&C', () {}),
                _buildActionIcon(Icons.timeline, 'Timeline', () {}),
                _buildActionIcon(
                  Icons.favorite_border,
                  'Health',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HealthRecordsScreen()),
                  ),
                ),
                _buildActionIcon(Icons.flag_outlined, 'Goals', () {}),
                _buildActionIcon(Icons.bar_chart, 'Statistics', () {}),
                _buildActionIcon(Icons.videocam_outlined, 'Videos', () {}),
                _buildActionIcon(
                  Icons.description_outlined,
                  'Reports',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainerReportsScreen()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'ACTIVE GOALS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Active Goals Card
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildGoalItem('Recall Under High Distraction', 0.68, '68% complete', 'Due 14 Nov'),
                  const Divider(color: _cardBorder, height: 1),
                  _buildGoalItem('IGP 1 Scent Pad Tracking', 0.45, '45% complete', 'Due 28 Nov'),
                  const Divider(color: _cardBorder, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'View All Goals →',
                        style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'RECENT VIDEOS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Recent Videos Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoViewerScreen(title: 'Recall Drill'),
                      ),
                    ),
                    child: _buildVideoCard('Recall Drill', '01:45', 'Yesterday'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoViewerScreen(title: 'Heelwork Focus'),
                      ),
                    ),
                    child: _buildVideoCard('Heelwork Focus', '03:12', '3 days ago'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'HEALTH SUMMARY',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Health Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildHealthRow(Icons.straighten, 'Current Weight', '32.4 kg', false),
                  const Divider(color: _cardBorder, height: 20),
                  _buildHealthRow(Icons.medication_outlined, 'Medications', 'None active', false),
                  const Divider(color: _cardBorder, height: 20),
                  _buildHealthRow(Icons.verified_outlined, 'Vaccinations', 'Up to date', true),
                  const Divider(color: _cardBorder, height: 20),
                  _buildHealthRow(Icons.healing_outlined, 'Injury Status', 'No active injuries', false),
                  const Divider(color: _cardBorder, height: 20),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HealthRecordsScreen()),
                    ),
                    child: Center(
                      child: Text(
                        'View Health Records →',
                        style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'PERMISSIONS (TRAINER ACCESS)',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Permissions Card
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
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: _stoneGrey),
                          SizedBox(width: 6),
                          Text('Access Level', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text('Granted by Emma', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildAccessPill('VIEW ONLY', false),
                      _buildAccessPill('ADD RECORDS', false),
                      _buildAccessPill('EDITABLE', true),
                      _buildAccessPill('FULL ACCESS', false),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Editing is enabled by the dog owner. Changes to permissions must be configured from the owner's account.",
                    style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14191E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: _mint, size: 14),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You have permission to log training sessions, create homework, and view health milestones.',
                            style: TextStyle(color: _stoneGrey, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientPermissionsScreen()),
                    ),
                    child: Center(
                      child: Text(
                        'View Detailed Permissions →',
                        style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String val) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String count, String label, IconData icon) {
    return Expanded(
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
            Icon(icon, color: _stoneGrey, size: 16),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, double progress, String sub, String due) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GoalDetailsScreen()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF262C30),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sub, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                Text(due, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(String title, String duration, String date) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFF14171A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.play_circle_outline, color: _offWhite, size: 36),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(duration, style: const TextStyle(color: _offWhite, fontSize: 9)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(color: _stoneGrey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRow(IconData icon, String label, String val, bool isMint) {
    return Row(
      children: [
        Icon(icon, color: _stoneGrey, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 13))),
        Text(
          val,
          style: TextStyle(
            color: isMint ? _mint : _offWhite,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAccessPill(String text, bool isSel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSel ? const Color(0x1F34D399) : const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSel ? const Color(0xFF34D399) : _stoneGrey,
          fontSize: 10,
          fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
    );
  }
}
