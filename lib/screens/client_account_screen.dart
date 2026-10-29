import 'package:flutter/material.dart';
import 'client_dogs_screen.dart';
import 'client_dog_profile_screen.dart';
import 'client_homework_screen.dart';
import 'client_permissions_screen.dart';
import 'lesson_records_screen.dart';
import 'trainer_notes_screen.dart';

/// Screen: Client Account View (Node / frame client_account.png)
/// Displays Emma Johnson's client account with linked dogs, quick actions,
/// permissions summary, recent activity, and private trainer notes.
class ClientAccountScreen extends StatefulWidget {
  final String clientName;
  final String clientEmail;
  final String clientSince;
  final int linkedDogsCount;
  final String nextLesson;

  const ClientAccountScreen({
    super.key,
    this.clientName = 'Emma Johnson',
    this.clientEmail = 'emma.johnson@example.com',
    this.clientSince = 'July 2026',
    this.linkedDogsCount = 2,
    this.nextLesson = 'Thursday · 10:00',
  });

  @override
  State<ClientAccountScreen> createState() => _ClientAccountScreenState();
}

class _ClientAccountScreenState extends State<ClientAccountScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _cardBg = Color(0xFF1E2327);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);
  static const Color _flameOrange = Color(0xFFE5853C);
  static const Color _errorRed = Color(0xFFE5484D);

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.manage_accounts, color: _mint),
                title: const Text('Manage Permissions', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientPermissionsScreen(clientName: widget.clientName),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.note_alt_outlined, color: _mint),
                title: const Text('View All Trainer Notes', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainerNotesScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: _stoneGrey),
                title: const Text('Archive Client Account', style: TextStyle(color: _stoneGrey)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client account archived'), backgroundColor: _forest),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Private Trainer Note', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          style: const TextStyle(color: _offWhite),
          decoration: InputDecoration(
            hintText: 'Enter confidential trainer observations...',
            hintStyle: const TextStyle(color: _stoneGrey),
            filled: true,
            fillColor: _obsidian,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Private trainer note saved'), backgroundColor: _forest),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _forest, foregroundColor: _offWhite),
            child: const Text('Save Note'),
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
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          widget.clientName,
          style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: _offWhite),
            onPressed: _showMoreMenu,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 1. HERO IDENTITY CARD ──────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF263033),
                          shape: BoxShape.circle,
                          border: Border.all(color: _mint.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: const Icon(Icons.person_outline, color: _mint, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.clientName,
                              style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Connected to Ulvenik',
                                  style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Client since ${widget.clientSince}',
                              style: const TextStyle(color: _stoneGrey, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.pets, color: _stoneGrey, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.linkedDogsCount} Linked Dogs',
                                  style: const TextStyle(color: _stoneGrey, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: _stoneGrey, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Next Lesson · ${widget.nextLesson}',
                              style: const TextStyle(color: _stoneGrey, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _forest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _forest),
                          ),
                          child: const Text(
                            'ACTIVE CLIENT',
                            style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── 2. 2x2 BENTO STATS GRID ────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildBentoCard(
                    number: '${widget.linkedDogsCount}',
                    label: 'LINKED DOGS',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientDogsScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildBentoCard(
                    number: '3',
                    label: 'ACTIVE GOALS',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Active goals viewed'), backgroundColor: _forest),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBentoCard(
                    number: '2',
                    label: 'HOMEWORK DUE',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientHomeworkScreen(clientName: widget.clientName),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildBentoCard(
                    number: '8',
                    label: 'LESSONS TOTAL',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LessonRecordsScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── 3. QUICK ACTIONS ───────────────────────────────────────────
            const Text(
              'QUICK ACTIONS',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add,
                    label: 'Record Lesson',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LessonRecordsScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.assignment_outlined,
                    label: 'Assign HW',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientHomeworkScreen(clientName: widget.clientName),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.flag_outlined,
                    label: 'Create Goal',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Create goal opened'), backgroundColor: _forest),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit_note_outlined,
                    label: 'Add Note',
                    onTap: _showAddNoteDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── 4. LINKED DOGS ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LINKED DOGS',
                  style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ClientDogsScreen()),
                  ),
                  child: const Text(
                    'View All >',
                    style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLinkedDogCard(
                    name: 'Murphy',
                    breed: 'Working Malinois',
                    streak: '12 Day Streak',
                    lastSession: 'Last Session · Yesterday',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientDogProfileScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLinkedDogCard(
                    name: 'Luna',
                    breed: 'Golden Retriever',
                    streak: '5 Day Streak',
                    lastSession: 'Last Session · 2 days ago',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientDogProfileScreen(dogName: 'Luna', breed: 'Golden Retriever')),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── 5. PERMISSIONS ─────────────────────────────────────────────
            const Text(
              'PERMISSIONS',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPermissionRow(Icons.check, _mint, 'Training Records', 'Read / Write', _stoneGrey),
                  const Divider(color: _cardBorder, height: 20),
                  _buildPermissionRow(Icons.check, _mint, 'Goals', 'Read / Write', _stoneGrey),
                  const Divider(color: _cardBorder, height: 20),
                  _buildPermissionRow(Icons.check, _mint, 'Statistics', 'View Only', _stoneGrey),
                  const Divider(color: _cardBorder, height: 20),
                  _buildPermissionRow(Icons.check, _mint, 'Media', 'View & Upload', _stoneGrey),
                  const Divider(color: _cardBorder, height: 20),
                  _buildPermissionRow(Icons.close, _errorRed, 'Health Records', 'Restricted', _errorRed),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClientPermissionsScreen(clientName: widget.clientName),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Manage Permissions', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: _mint, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── 6. RECENT ACTIVITY ─────────────────────────────────────────
            const Text(
              'RECENT ACTIVITY',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActivityRow(Icons.check_circle_outline, _mint, 'Complete', 'MURPHY', '1h ago'),
                  const Divider(color: _cardBorder, height: 20),
                  _buildActivityRow(Icons.videocam_outlined, _mint, 'Uploaded', 'MURPHY', '3h ago'),
                  const Divider(color: _cardBorder, height: 20),
                  _buildActivityRow(Icons.star_outline, _flameOrange, 'Achieved', 'BELLA ✓', 'Yesterday'),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening full activity log...'), backgroundColor: _forest),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('View All Activity', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: _mint, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── 7. TRAINER NOTES ───────────────────────────────────────────
            const Text(
              'TRAINER NOTES',
              style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lock_outline, color: _stoneGrey, size: 16),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Pre-lesson: check harness fit, discuss long line',
                          style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Text(
                        'Yesterday',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showAddNoteDialog,
                    child: const Text(
                      'Add Note +',
                      style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.privacy_tip_outlined, color: _mint, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'PRIVATE — Not visible to client',
                          style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({required String number, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(color: _offWhite, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _mint, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedDogCard({
    required String name,
    required String breed,
    required String streak,
    required String lastSession,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF162024),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                gradient: const LinearGradient(
                  colors: [Color(0xFF233036), Color(0xFF131A1D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Icon(Icons.pets, color: _mint.withValues(alpha: 0.4), size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    breed,
                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: _flameOrange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        streak,
                        style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastSession,
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRow(IconData icon, Color iconColor, String title, String status, Color statusColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          status,
          style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActivityRow(IconData icon, Color iconColor, String action, String dogBadge, String timeAgo) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _obsidian,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          action,
          style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF263033),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            dogBadge,
            style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        Text(
          timeAgo,
          style: const TextStyle(color: _stoneGrey, fontSize: 12),
        ),
      ],
    );
  }
}

