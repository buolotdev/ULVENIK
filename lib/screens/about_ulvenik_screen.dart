import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'whats_new_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'open_source_licences_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);

class AboutUlvenikScreen extends StatelessWidget {
  const AboutUlvenikScreen({super.key});

  void _onBottomNavTapped(BuildContext context, int index) {
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
            // ─── Header: < About Ulvenik ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
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
                            'About Ulvenik',
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
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── Hero Card with Mountain Peak ──────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.landscape_outlined,
                          color: _stoneGrey,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Ulvenik',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'The Journey Builds the Wolf.',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 16),
                        const Text(
                          'Ulvenik is a premium dog training journal designed to help owners, trainers and working dog handlers record every step of their dog\'s journey.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Whether you\'re raising a family companion, preparing for competition or working towards professional goals, Ulvenik keeps every training session, health record, milestone and achievement organised in one place.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Built around consistency and long-term progress, Ulvenik allows you to focus on what matters most — your dog\'s development.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── WHAT IS ULVENIK? ──────────────────────────────────
                  _buildSectionHeader('WHAT IS ULVENIK?'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ulvenik is a complete dog management platform that brings together training, strength and conditioning, health, goals, statistics and lifetime records into one organised system.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Rather than teaching you how to train your dog, Ulvenik is designed to document your journey, helping you measure progress, identify patterns and build consistency over time.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Every session, achievement and milestone becomes part of your dog\'s permanent history.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── WHO IS IT FOR? ────────────────────────────────────
                  _buildSectionHeader('WHO IS IT FOR?'),
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
                          'Ulvenik is designed for anyone passionate about developing their dog, including:',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('Pet Dog Owners'),
                        _buildBulletPoint('Puppy Owners'),
                        _buildBulletPoint('Professional Dog Trainers'),
                        _buildBulletPoint('Working Dog Handlers'),
                        _buildBulletPoint('Sport Competitors'),
                        _buildBulletPoint('Behaviourists'),
                        _buildBulletPoint('Breeders'),
                        _buildBulletPoint('Dog Clubs & Training Groups'),
                        const SizedBox(height: 12),
                        const Text(
                          'Whether you\'re recording your very first training session or preparing for national competitions, Ulvenik grows with you.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── OUR PHILOSOPHY ────────────────────────────────────
                  _buildSectionHeader('OUR PHILOSOPHY'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress isn\'t measured in a single training session. It\'s built through hundreds of small moments.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Every repetition. Every success. Every setback. Every lesson learned.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Ulvenik exists to capture those moments, helping you stay organised, motivated and focused on the bigger picture.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Because progress isn\'t accidental —',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'The Journey Builds the Wolf.',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── OUR VISION ────────────────────────────────────────
                  _buildSectionHeader('OUR VISION'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Our vision is to become the world\'s leading dog training journal and management platform.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'By combining thoughtful design with powerful record keeping, Ulvenik aims to give every dog owner and trainer a place where their entire journey can be documented from the day their dog arrives until every achievement that follows.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No matter your discipline, experience or goals — your journey deserves to be remembered.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── APP INFORMATION ───────────────────────────────────
                  _buildSectionHeader('APP INFORMATION'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Version',
                              style: TextStyle(color: _stoneGrey, fontSize: 13),
                            ),
                            Text(
                              '1.0.0',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Divider(height: 1, color: Color(0x0FFFFFFF)),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Released',
                              style: TextStyle(color: _stoneGrey, fontSize: 13),
                            ),
                            Text(
                              '1 September 2026',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── LINKS ─────────────────────────────────────────────
                  _buildSectionHeader('LINKS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          context,
                          icon: Icons.auto_awesome_outlined,
                          title: 'What\'s New',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WhatsNewScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          context,
                          icon: Icons.shield_outlined,
                          title: 'Privacy Policy',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          context,
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsConditionsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          context,
                          icon: Icons.code,
                          title: 'Open Source Licences',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const OpenSourceLicencesScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── CONTACT ───────────────────────────────────────────
                  _buildSectionHeader('CONTACT'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildContactRow(
                          icon: Icons.mail_outline,
                          label: 'Support Email',
                          value: 'support@ulvenik.com',
                        ),
                        _buildDivider(),
                        _buildContactRow(
                          icon: Icons.language,
                          label: 'Official Website',
                          value: 'ulvenik.com',
                        ),
                        _buildDivider(),
                        _buildContactRow(
                          icon: Icons.camera_alt_outlined,
                          label: 'Instagram',
                          value: '@ulvenik',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── DESIGNED & DEVELOPED FOOTER ───────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.favorite_border,
                            color: _stoneGrey, size: 22),
                        SizedBox(height: 10),
                        Text(
                          'DESIGNED & DEVELOPED',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Designed with a passion for dogs, training and lifelong progress. Every feature within Ulvenik has been created with one goal in mind — to provide the most complete, organised and enjoyable way to document a dog\'s life and development.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          '© Ulvenik. All rights reserved.',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 11,
                          ),
                        ),
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
        onTap: (i) => _onBottomNavTapped(context, i),
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

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 52,
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _mint,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _offWhite, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: _offWhite, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
        ],
      ),
    );
  }
}
