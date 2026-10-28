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

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
          // 1. LAST UPDATED CHIP
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _mint.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Effective: October 2026 • v2.4',
                  style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. CORE PILLARS BENTO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildPillarRow(
                  Icons.lock_outline,
                  'Zero Data Monetization',
                  'We never sell your canine telemetry, tracking maps, or health records to advertisers or third-party brokers.',
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 16),
                _buildPillarRow(
                  Icons.shield_outlined,
                  'AES-256 Cloud Encryption',
                  'All GPS waypoints, veterinary prescriptions, and video footage are encrypted in transit and in storage.',
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 16),
                _buildPillarRow(
                  Icons.file_download_outlined,
                  'Complete Data Ownership',
                  'Export your raw telemetry in CSV / PDF or permanently wipe your account at any time.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. ARTICLES
          _buildArticle(
            '1. Information We Collect',
            'We collect data provided directly by you, including handler profile information, canine biometrics (breed, age, weight, heart rate), GPS route tracks, and training drill logs. Sensor telemetry is collected exclusively while an active session or background live activity is initiated by you.',
          ),
          _buildArticle(
            '2. How We Use Telemetry',
            'Collected biometrics and GPS coordinates are used strictly to calculate training load, conditioning fatigue indices, and display topographic activity maps. We do not correlate your location data with external commercial databases.',
          ),
          _buildArticle(
            '3. Device Sensors & Bluetooth Permissions',
            'Ulvenik requests Bluetooth BLE access exclusively to connect to compatible canine heart rate straps and GPS collar transmitters. Location permissions (including background location) are used solely to trace your running route when you record an active field session.',
          ),
          _buildArticle(
            '4. Data Retention & Deletion',
            'You have full control over your data. You may download your entire database as a standard .zip archive from the Backup & Sync page. If you choose to delete your account, all cloud snapshots and records are permanently expunged within 30 days.',
          ),
          _buildArticle(
            '5. Contact Data Privacy Officer',
            'For any inquiries regarding data protection compliance, contact our privacy officer directly at privacy@ulvenik.com.',
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildPillarRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _mint.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _mint, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(color: _stoneGrey, fontSize: 11, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticle(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              height: 1.6,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
