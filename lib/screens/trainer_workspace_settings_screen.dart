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

class TrainerWorkspaceSettingsScreen extends StatefulWidget {
  const TrainerWorkspaceSettingsScreen({super.key});

  @override
  State<TrainerWorkspaceSettingsScreen> createState() =>
      _TrainerWorkspaceSettingsScreenState();
}

class _TrainerWorkspaceSettingsScreenState
    extends State<TrainerWorkspaceSettingsScreen> {
  bool _autoInvite = true;
  bool _videoFeedback = true;
  bool _notifySubmissions = true;
  bool _clientAccessRecords = true;
  String _cadence = 'Weekly (7 Days)';

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
          'Workspace Settings',
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
          // 1. WORKSPACE PROFILE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.business_outlined, color: _mint, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vanguard Working K9 Academy',
                        style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 2),
                      Text('Pro Trainer Workspace • 28 Active Canine Seats', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. CLIENT AUTOMATION
          _buildSectionHeader('CLIENT ONBOARDING & SHARING'),
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
                  'Auto-Invite Clients via Email',
                  'Send secure app link immediately after adding client',
                  _autoInvite,
                  (val) => setState(() => _autoInvite = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'Enable 4K Video Homework Review',
                  'Allow clients to upload drill clips for critique',
                  _videoFeedback,
                  (val) => setState(() => _videoFeedback = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'Instant Video Submission Alerts',
                  'Push notification when student submits assignment',
                  _notifySubmissions,
                  (val) => setState(() => _notifySubmissions = val),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
                _buildSwitchTile(
                  'Allow Client Scorebook Access',
                  'Share official session evaluations and phase scores',
                  _clientAccessRecords,
                  (val) => setState(() => _clientAccessRecords = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. HOMEWORK DEFAULTS
          _buildSectionHeader('DEFAULT HOMEWORK CADENCE'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _cadence,
                isExpanded: true,
                dropdownColor: _carbon,
                style: const TextStyle(color: _offWhite, fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                items: ['3 Days (Intensive)', 'Weekly (7 Days)', 'Bi-Weekly (14 Days)']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _cadence = val!),
              ),
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
