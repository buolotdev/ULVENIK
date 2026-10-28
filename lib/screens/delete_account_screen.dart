import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'splash_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _red = Color(0xFFE53E3E);

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _confirmController = TextEditingController();
  bool _isMatch = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(() {
      setState(() {
        _isMatch = _confirmController.text.trim() == 'DELETE MY ACCOUNT';
      });
    });
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  void _executeDeletion() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Final Deletion', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Your canine database, 847 training records, and cloud snapshots will now be permanently wiped.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false,
              );
            },
            child: const Text('Erase Everything', style: TextStyle(color: _offWhite)),
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
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. WARNING HERO CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF261616),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _red.withValues(alpha: 0.4)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: _red, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Irreversible Action',
                      style: TextStyle(color: _red, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Deleting your account permanently erases all canine records, GPS telemetry, medical history, and cloud archives. You will immediately lose access to your handler tier.',
                  style: TextStyle(color: _offWhite, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. LOSS CHECKLIST
          const Text('WHAT WILL BE ERASED', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              children: [
                _DeletionLossRow('2 Canine Workspaces', 'Profiles for Koda & Murphy will be deleted'),
                Divider(color: Color(0x0FFFFFFF), height: 16),
                _DeletionLossRow('847 Recorded Sessions', 'All agility, bite-work, and S&C logs'),
                Divider(color: Color(0x0FFFFFFF), height: 16),
                _DeletionLossRow('10 GB Cloud Storage Archive', 'AWS S3 backups & 4K video attachments'),
                Divider(color: Color(0x0FFFFFFF), height: 16),
                _DeletionLossRow('Veterinary & Health Logs', 'Vaccine, medication, and recovery curves'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. TYPE CONFIRMATION PHRASE
          const Text('CONFIRMATION REQUIRED', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 8),
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
                const Text(
                  'To confirm, please type "DELETE MY ACCOUNT" in all caps below:',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmController,
                  style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'DELETE MY ACCOUNT',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF131718),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _isMatch ? _red : _cardBorder),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. DELETE BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isMatch ? _red : const Color(0xFF261D1D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isMatch ? _executeDeletion : null,
              child: Text(
                'Permanently Delete My Account',
                style: TextStyle(
                  color: _isMatch ? _offWhite : _stoneGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
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

class _DeletionLossRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DeletionLossRow(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close, color: _red, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
