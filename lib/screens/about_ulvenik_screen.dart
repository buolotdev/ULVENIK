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

class AboutUlvenikScreen extends StatelessWidget {
  const AboutUlvenikScreen({super.key});

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
          'About Ulvenik',
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
          // 1. BRAND HERO
          Center(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _forest,
                    shape: BoxShape.circle,
                    border: Border.all(color: _mint, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _mint.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.pets, color: _mint, size: 40),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ULVENIK',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 2.4.0 (Build 412) • Production',
                  style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  'The High-Performance Canine Operating System',
                  style: TextStyle(color: _stoneGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 2. MISSION STATEMENT
          _buildSectionHeader('PURPOSE & MISSION'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Text(
              'Ulvenik is engineered from the ground up for high-drive working dogs, IGP & protection sport competitors, backcountry search & rescue units, and dedicated canine trainers worldwide.\n\nOur mission is to replace notebooks and fragmented apps with precision sub-meter GPS traces, biometric fatigue indexing, and holistic conditioning analytics.',
              style: TextStyle(
                color: _offWhite,
                fontSize: 13,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. CORE ARCHITECTURE
          _buildSectionHeader('SYSTEM ARCHITECTURE'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildSpecRow('GPS Core', 'Dual-Band L1/L5 Sub-Meter Filtering', Icons.gps_fixed),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildSpecRow('Biometrics Engine', 'Real-Time Canine HRV & Heart Rate', Icons.favorite_border),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildSpecRow('Offline Topology', 'Zero-Loss Local Backcountry Queue', Icons.cloud_off),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildSpecRow('Security', 'AES-256 Client-Side Encrypted Sync', Icons.security),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. FIELD ADVISORY BOARD
          _buildSectionHeader('FIELD ADVISORY & RESEARCH TEAM'),
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
                _buildAdvisorRow('Marcus Vance', 'IGP World Championship Competitor & Head Decoy'),
                const SizedBox(height: 10),
                _buildAdvisorRow('Dr. Helena Thorne, DVM', 'Canine Sports Medicine & Orthopedic Specialist'),
                const SizedBox(height: 10),
                _buildAdvisorRow('Søren Lindqvist', 'Nordic Wilderness Search & Avalanche Dog Unit Lead'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. SOCIAL & COMMUNITY LINKS
          _buildSectionHeader('CONNECT WITH ULVENIK'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCommunityButton('Website', Icons.public, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening ulvenik.com'), backgroundColor: _forest),
                  );
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCommunityButton('Community', Icons.forum_outlined, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connecting to Handler Community Discord'), backgroundColor: _forest),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
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

  Widget _buildSpecRow(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
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
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisorRow(String name, String role) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: _mint, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700)),
              Text(role, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityButton(String label, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: _mint, size: 18),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
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
