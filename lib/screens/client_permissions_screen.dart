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
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ClientPermissionsScreen extends StatefulWidget {
  final String clientName;

  const ClientPermissionsScreen({
    super.key,
    this.clientName = 'Sarah Jenkins',
  });

  @override
  State<ClientPermissionsScreen> createState() =>
      _ClientPermissionsScreenState();
}

class _ClientPermissionsScreenState extends State<ClientPermissionsScreen> {
  bool _viewHomework = true;
  bool _uploadVideos = true;
  bool _viewEvaluations = true;
  bool _viewPrivateNotes = false;
  bool _downloadScorebooks = true;

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
          'Permissions: ${widget.clientName}',
          style: const TextStyle(
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
          // 1. HEADER SUMMARY
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: _mint, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client Portal Security & Access',
                        style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text('Customize what ${widget.clientName} can see and interact with in their Ulvenik app.', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. PERMISSIONS SWITCHES
          _buildSectionHeader('PORTAL PRIVILEGES'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  'View Assigned Homework Drills',
                  'Permits student to see daily training assignments',
                  _viewHomework,
                  (val) => setState(() => _viewHomework = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'Upload 4K Video Homework Submissions',
                  'Allows client to upload drill clips for critique',
                  _uploadVideos,
                  (val) => setState(() => _uploadVideos = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'View Session Evaluation Reports',
                  'Shares official scoring, TSB drive ratings, and notes',
                  _viewEvaluations,
                  (val) => setState(() => _viewEvaluations = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'View Private Trainer Observations',
                  'Grants visibility into internal trainer notes (Confidential)',
                  _viewPrivateNotes,
                  (val) => setState(() => _viewPrivateNotes = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'Download Official PDF Scorebooks',
                  'Permits export and printing of trial certificates',
                  _downloadScorebooks,
                  (val) => setState(() => _downloadScorebooks = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. REVOKE ACCESS BUTTON
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.block, size: 18),
            label: const Text('Revoke Client Portal Access', style: TextStyle(fontWeight: FontWeight.w700)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Client access revoked.'), backgroundColor: Colors.redAccent),
              );
            },
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

  Widget _buildSwitchTile(String title, String desc, bool val, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: val,
      onChanged: onChanged,
      activeThumbColor: _mint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(desc, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
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
