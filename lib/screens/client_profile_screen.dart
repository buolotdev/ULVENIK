import 'package:flutter/material.dart';
import 'client_dog_profile_screen.dart';
import 'edit_client_screen.dart';
import 'client_notes_screen.dart';
import 'client_homework_screen.dart';
import 'client_progress_screen.dart';
import 'client_permissions_screen.dart';
import 'trainer_reports_screen.dart';
import 'client_account_screen.dart';
import 'client_dogs_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ClientProfileScreen extends StatefulWidget {
  final String clientName;

  const ClientProfileScreen({
    super.key,
    this.clientName = 'Emma Johnson',
  });

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  bool _isFavorite = false;

  void _showClientMenu() {
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
                leading: const Icon(Icons.account_circle_outlined, color: _mint),
                title: const Text('View Client Account & Linked Dogs', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientAccountScreen(clientName: widget.clientName),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: _stoneGrey),
                title: const Text('Edit Client', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditClientScreen(initialName: widget.clientName),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: _stoneGrey),
                title: const Text('Archive Client', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client archived.'), backgroundColor: _forest),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download_outlined, color: _stoneGrey),
                title: const Text('Export Client', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client dossier exported.'), backgroundColor: _forest),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: _stoneGrey),
                title: const Text('Share Client', style: TextStyle(color: _offWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client profile link copied.'), backgroundColor: _forest),
                  );
                },
              ),
              const Divider(color: _cardBorder),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                title: const Text('Delete Client', style: TextStyle(color: Color(0xFFEF4444))),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client deleted.'), backgroundColor: Colors.redAccent),
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
          widget.clientName,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? const Color(0xFFECC94B) : _offWhite,
              size: 22,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: _offWhite, size: 24),
            onPressed: _showClientMenu,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Client Identity Hero
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF262C30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'EJ',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.clientName,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x1F34D399),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ACTIVE CLIENT',
                      style: TextStyle(
                        color: Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone_outlined, color: _stoneGrey, size: 14),
                      SizedBox(width: 4),
                      Text('07700 900123', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                      SizedBox(width: 10),
                      Text('•', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                      SizedBox(width: 10),
                      Icon(Icons.email_outlined, color: _stoneGrey, size: 14),
                      SizedBox(width: 4),
                      Text('emma@email.com', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF14171A),
                            side: const BorderSide(color: _cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.phone, color: _offWhite, size: 16),
                          label: const Text('Call', style: TextStyle(color: _offWhite, fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF14171A),
                            side: const BorderSide(color: _cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.email_outlined, color: _offWhite, size: 16),
                          label: const Text('Email', style: TextStyle(color: _offWhite, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2x3 Details Grid
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
                      _buildDetailCell('Member Since', 'Jul 2026'),
                      _buildDivider(),
                      _buildDetailCell('Total Dogs', '2'),
                      _buildDivider(),
                      _buildDetailCell('Last Active', 'Yesterday'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  Row(
                    children: [
                      _buildDetailCell('Next Session', 'Thu 10:00'),
                      _buildDivider(),
                      _buildDetailCell('Emerg. Contact', 'On File'),
                      _buildDivider(),
                      _buildDetailCell('Vet Practice', 'On File'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'QUICK ACTIONS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // 6 Quick Action Grid
            Row(
              children: [
                _buildActionCol(
                  Icons.pets,
                  'Dogs',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientDogsScreen(ownerName: "${widget.clientName}'s Dogs"),
                    ),
                  ),
                ),
                _buildActionCol(
                  Icons.assignment_outlined,
                  'Homework',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientHomeworkScreen(clientName: widget.clientName),
                    ),
                  ),
                ),
                _buildActionCol(
                  Icons.edit_note,
                  'Notes',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ClientNotesScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildActionCol(
                  Icons.trending_up,
                  'Progress',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientProgressScreen(dogName: 'Murphy'),
                    ),
                  ),
                ),
                _buildActionCol(
                  Icons.bar_chart,
                  'Reports',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainerReportsScreen()),
                  ),
                ),
                _buildActionCol(Icons.share_outlined, 'Share', () {}),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'STATISTICS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Statistics 2x3 Grid
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
                      _buildStatCol('47', 'Training Sessions'),
                      _buildDivider(),
                      _buildStatCol('14', 'Homework Assigned'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  Row(
                    children: [
                      _buildStatCol('11', 'Homework Completed'),
                      _buildDivider(),
                      _buildStatCol('5', 'Goals Achieved'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  Row(
                    children: [
                      _buildStatCol('3', 'Active Goals'),
                      _buildDivider(),
                      _buildStatCol('2', 'Reports Generated'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'DOGS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Dogs Horizontal List
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ClientDogProfileScreen(dogName: 'Murphy'),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF14241E),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                            ),
                            child: const Center(
                              child: Icon(Icons.pets, color: _mint, size: 40),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Murphy', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF262C30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('IGP', style: TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text('Golden Retr. • 3 Yrs', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Last • Yesterday', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                                    Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                        builder: (_) => const ClientDogProfileScreen(dogName: 'Bella'),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF14171A),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                            ),
                            child: const Center(
                              child: Icon(Icons.pets, color: _stoneGrey, size: 40),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Bella', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                const Text('Border Collie • 5 Yrs', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Last • 2d ago', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                                    Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
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

            // Homework List
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildHomeworkRow(
                    'Recall Foundation Practice',
                    'Murphy',
                    'Due Tomorrow',
                    'IN PROGRESS',
                    false,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildHomeworkRow(
                    'Loose Lead Consistency',
                    'Bella',
                    'Due in 3 days',
                    'IN PROGRESS',
                    false,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildHomeworkRow(
                    'Place Training',
                    'Murphy',
                    '2 days overdue',
                    'OVERDUE',
                    true,
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientHomeworkScreen(clientName: widget.clientName),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Center(
                        child: Text(
                          'View All Homework →',
                          style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'NOTES',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: _stoneGrey),
                          SizedBox(width: 6),
                          Text(
                            'Pre-lesson checklist — Thursday 10am',
                            style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text('Today', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Check harness fit before start. Discuss long line transitions and reward pacing.',
                    style: TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  const Divider(color: _cardBorder, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.lock_outline, size: 14, color: _stoneGrey),
                          SizedBox(width: 6),
                          Text(
                            'Reactivity threshold observations',
                            style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text('Yesterday', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Threshold reducing near joggers. Consider systematic desensitization drills next lesson.',
                    style: TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                  const Divider(color: _cardBorder, height: 20),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientNotesScreen()),
                    ),
                    child: const Center(
                      child: Text(
                        'View All Notes →',
                        style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.info_outline, color: _stoneGrey, size: 12),
                      SizedBox(width: 6),
                      Text(
                        'Notes are private and never visible to the client.',
                        style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'PERMISSIONS',
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
                children: [
                  _buildPermRow(Icons.check, const Color(0xFF34D399), 'Training Records'),
                  const SizedBox(height: 10),
                  _buildPermRow(Icons.check, const Color(0xFF34D399), 'Goals'),
                  const SizedBox(height: 10),
                  _buildPermRow(Icons.check, const Color(0xFF34D399), 'Media'),
                  const SizedBox(height: 10),
                  _buildPermRow(Icons.close, const Color(0xFFEF4444), 'Health Records'),
                  const Divider(color: _cardBorder, height: 24),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientPermissionsScreen(clientName: widget.clientName),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Manage Permissions',
                          style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: _mint, size: 14),
                      ],
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

  Widget _buildDetailCell(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildStatCol(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(count, style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: _cardBorder);
  }

  Widget _buildActionCol(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Icon(icon, color: _stoneGrey, size: 20),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeworkRow(
    String title,
    String dog,
    String due,
    String status,
    bool isOverdue,
  ) {
    return Padding(
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
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF262C30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(dog, style: const TextStyle(color: _stoneGrey, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      due,
                      style: TextStyle(
                        color: isOverdue ? const Color(0xFFEF4444) : _stoneGrey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• $status',
                      style: TextStyle(
                        color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF34D399),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
        ],
      ),
    );
  }

  Widget _buildPermRow(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
