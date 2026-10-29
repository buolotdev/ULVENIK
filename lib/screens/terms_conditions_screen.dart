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

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _tocExpanded = false;

  final List<String> _tocItems = [
    '1. Acceptance of Terms',
    '2. Use of the Platform',
    '3. User Accounts',
    '4. Subscription & Billing',
    '5. Acceptable Use',
    '6. Intellectual Property',
    '7. Limitation of Liability',
    '8. Termination',
    '9. Changes to Terms',
    '10. Contact Us',
  ];

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
            // ─── Header: < Terms & Conditions | Search ─────────────
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
                            'Terms & Conditions',
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
                  // ─── LAST UPDATED & REV BADGE ──────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LAST UPDATED  15 September 2026',
                        style: TextStyle(
                          color: _mutedGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF162E25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'REV 4.2',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
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
                          ..._tocItems.map((item) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            color: _stoneGrey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right, color: _mutedGrey, size: 16),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: Color(0x08FFFFFF), indent: 16),
                                ],
                              )),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── 1. Acceptance of Terms ────────────────────────────
                  const Text(
                    '1. Acceptance of Terms',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'By accessing or using the Ulvenik application, website, and related telemetry services, you enter into a binding agreement and acknowledge full adherence to these Terms & Conditions. These terms govern your access to our sports performance tracking tools and training log infrastructure.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),

                  const SizedBox(height: 24),

                  // ─── 2. Use of the Platform ────────────────────────────
                  const Text(
                    '2. Use of the Platform',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ulvenik provides competitive canine sport handlers with precision tracking tools, trail GPS logging, and physiological load analytics. As a handler operating within the ecosystem, you accept direct responsibility for adhering to the following behavioral standards:',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildBullet('You must be 18 years or older or have verified handler parental consent to use Ulvenik.'),
                  _buildBullet('You are responsible for maintaining the confidentiality and security of your account credentials.'),
                  _buildBullet('You agree not to misuse the platform, reverse-engineer biometric telemetry, or tamper with synchronization services.'),
                  _buildBullet('You agree to provide accurate and truthful canine profile and performance data when creating an account.'),

                  const SizedBox(height: 24),

                  // ─── 3. User Accounts ──────────────────────────────────
                  const Text(
                    '3. User Accounts',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Account holders maintain sole authority over their recorded dog training metrics. Handlers are responsible for all activities executed under their verified profile, ensuring security across connected mobile and field devices.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),

                  const SizedBox(height: 24),

                  // ─── 4. Subscription & Billing ─────────────────────────
                  const Text(
                    '4. Subscription & Billing',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ulvenik offers individual handler tiers and multi-canine team configurations. All recurring commercial transactions are handled under systematic terms:',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  _buildNumberedItem(1, 'Subscriptions are billed on a recurring monthly or annual basis depending on your selected tier.'),
                  _buildNumberedItem(2, 'You may cancel your subscription at any time directly through app store subscription settings.'),
                  _buildNumberedItem(3, 'Refunds are subject to our comprehensive customer protection and refund policies.'),
                  _buildNumberedItem(4, 'Tier pricing and storage allocations may change with reasonable prior written notice.'),

                  const SizedBox(height: 24),

                  // ─── 5. Termination ────────────────────────────────────
                  const Text(
                    '5. Termination',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ulvenik reserves the right to suspend or terminate accounts that breach platform safety or acceptable use rules. Handlers may close accounts at any time by exporting their canine data archive and initiating account erasure via settings, or by contacting us directly: contact us at support@ulvenik.com.',
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
                          'Questions about these Terms & Conditions?',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'If you have any questions regarding the use of Ulvenik or these Terms & Conditions, please contact our support team.',
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

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
            child: Text(
              text,
              style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedItem(int num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
              style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
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
