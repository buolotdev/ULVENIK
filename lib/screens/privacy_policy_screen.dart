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
const Color _mutedGrey = Color(0xFF718096);

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _tocExpanded = false;

  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }
    Widget target;
    switch (index) {
      case 0:
        target = const HomepageScreen();
        break;
      case 1:
        target = const MyDogsScreen();
        break;
      case 2:
        target = const TrainingScreen();
        break;
      case 3:
        target = const TimelineScreen();
        break;
      case 4:
        target = const MorePageScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Privacy Policy | Search ─────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: _offWhite, size: 20),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── LAST UPDATED ──────────────────────────────────────
                  const Text(
                    'LAST UPDATED • 1 September 2026',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── CONTENTS (Table of Contents) ──────────────────────
                  _buildSectionHeader('CONTENTS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => setState(() => _tocExpanded = !_tocExpanded),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(Icons.list, color: _stoneGrey, size: 20),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Table of Contents',
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _tocExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: _stoneGrey,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_tocExpanded) ...[
                          const Divider(height: 1, color: Color(0x0FFFFFFF)),
                          _buildTocItem('Introduction'),
                          _buildTocItem('Information We Collect'),
                          _buildTocItem('How We Use Your Information'),
                          _buildTocItem('Data Storage & Security'),
                          _buildTocItem('Your Rights'),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── 1. Introduction ───────────────────────────────────
                  const Text(
                    'Introduction',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome to Ulvenik. We are committed to protecting your privacy and ensuring the integrity and confidentiality of your personal information, as well as the specialized tracking records you log for your dogs.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This Privacy Policy outlines the specific types of data collected through the Ulvenik mobile application, how your records are securely processed, and the measures we maintain to protect your sovereignty over your training journey.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),

                  const SizedBox(height: 24),

                  // ─── 2. Information We Collect ─────────────────────────
                  const Text(
                    'Information We Collect',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'To provide an accurate, high-fidelity sports tracking and veterinary management environment, Ulvenik gathers specific categories of user-provided information:',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildBullet(
                    'Account information: ',
                    'Full name, verified email address, authentication credentials, and account settings.',
                  ),
                  _buildBullet(
                    'Dog profile information: ',
                    'Registered names, breed classifications, birth dates, target weights, and visual portraits.',
                  ),
                  _buildBullet(
                    'Training records and session data: ',
                    'Exercise repetitions, timestamps, duration, field conditions, and handler evaluations.',
                  ),
                  _buildBullet(
                    'Health and medication records: ',
                    'Veterinary checkups, vaccination cycles, clinical therapies, and dosage schedules.',
                  ),
                  _buildBullet(
                    'Device information and usage data: ',
                    'Operating system telemetry, local storage allocations, and app performance metrics.',
                  ),

                  const SizedBox(height: 24),

                  // ─── 3. How We Use Your Information ────────────────────
                  const Text(
                    'How We Use Your Information',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'We utilize the collected telemetry strictly to serve your training system and deliver private, data-dense insights:',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildNumberItem(1, 'To provide, operate, and maintain the Ulvenik training platform and data synchronization services.'),
                  _buildNumberItem(2, 'To personalise your handler experience, calculation rings, and longitudinal conditioning models.'),
                  _buildNumberItem(3, 'To improve our platform, refine offline performance, and expand native export features.'),
                  _buildNumberItem(4, 'To send critical account notifications, security alerts, and system backup verifications.'),

                  const SizedBox(height: 24),

                  // ─── 4. Data Storage & Security ────────────────────────
                  const Text(
                    'Data Storage & Security',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'All local database records are encrypted on-device. When cloud synchronization is enabled, records are transmitted via TLS 1.3 encryption and stored in compliant, hardened data centers. We never sell, monetize, or lease your training logs or veterinary archives to third-party data brokers.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Offline-first architecture ensures that your data remains fully accessible even in remote field or forest locations without network availability.',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── 5. Your Rights ────────────────────────────────────
                  const Text(
                    'Your Rights',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You maintain full ownership of your data. You may export your entire dog journal, request complete account erasure, or update your information at any time directly through the app settings, or by contacting our data protection officer at support@ulvenik.com.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),

                  const SizedBox(height: 28),

                  // ─── QUESTIONS? ────────────────────────────────────────
                  _buildSectionHeader('QUESTIONS?'),
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
                          'Questions about this Privacy Policy?',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'If you have any questions regarding how Ulvenik collects or processes your information, please contact our support team.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 12),
                        _buildContactRow(Icons.mail_outline, 'Support Email', 'support@ulvenik.com'),
                        const SizedBox(height: 10),
                        _buildContactRow(Icons.language, 'Official Website', 'ulvenik.com'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
        onTap: _onBottomNavTapped,
        backgroundColor: _obsidian,
        selectedItemColor: _mint,
        unselectedItemColor: _stoneGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildTocItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
            ),
          ),
          const Icon(Icons.chevron_right, color: _mutedGrey, size: 16),
        ],
      ),
    );
  }

  Widget _buildBullet(String boldPrefix, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                children: [
                  TextSpan(
                    text: boldPrefix,
                    style: const TextStyle(color: _offWhite, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberItem(int num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$num. ',
            style: const TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: _stoneGrey, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _offWhite, fontSize: 14),
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: _mint, fontSize: 13),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
      ],
    );
  }
}
