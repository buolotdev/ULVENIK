import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'edit_profile_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  String _name = 'Alex Rivers';
  String _email = 'alex.rivers@k9alpine.com';
  String _location = 'Pacific Northwest, USA';
  String _title = 'Lead Working Dog Decoy & Trainer';

  void _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: _name,
          initialEmail: _email,
          initialLocation: _location,
          initialTitle: _title,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _name = result['name'] ?? _name;
        _email = result['email'] ?? _email;
        _location = result['location'] ?? _location;
        _title = result['title'] ?? _title;
      });
    }
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
          'Handler Profile',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _mint),
            onPressed: _openEditProfile,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. HANDLER HERO CARD
          _buildHeroCard(),
          const SizedBox(height: 20),

          // 2. CAREER METRICS BENTO
          _buildCareerMetrics(),
          const SizedBox(height: 20),

          // 3. REGISTERED CANINE WORKSPACES
          _buildSectionHeader('REGISTERED CANINE WORKSPACES'),
          const SizedBox(height: 8),
          _buildCanineCard('Koda', 'Belgian Malinois • 3 Years', 'IGP III • Wilderness S&R • High Drive', 'assets/images/koda_avatar.png'),
          const SizedBox(height: 10),
          _buildCanineCard('Murphy', 'German Shepherd • 18 Months', 'Foundation Tracking & S&C Periodization', 'assets/images/murphy_avatar.png'),
          const SizedBox(height: 20),

          // 4. ACTION BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _openEditProfile,
              child: const Text('Edit Handler Profile', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
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

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _forest,
              border: Border.all(color: _mint, width: 2.5),
            ),
            child: const Center(
              child: Text(
                'AR',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _name,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _forest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(_title, style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(_location, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(_email, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCareerMetrics() {
    return Row(
      children: [
        _buildMetricBlock('847', 'SESSIONS'),
        const SizedBox(width: 8),
        _buildMetricBlock('14d', 'STREAK'),
        const SizedBox(width: 8),
        _buildMetricBlock('2', 'DOGS'),
        const SizedBox(width: 8),
        _buildMetricBlock('4.8h', 'VOL / WK'),
      ],
    );
  }

  Widget _buildMetricBlock(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: _stoneGrey, fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanineCard(String name, String breed, String role, String avatar) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: const Icon(Icons.pets, color: _mint, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(breed, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(role, style: const TextStyle(color: _mint, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
        ],
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
