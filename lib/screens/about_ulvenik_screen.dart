import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'contact_support_screen.dart';
import 'open_source_licences_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'whats_new_screen.dart';

class AboutUlvenikScreen extends StatefulWidget {
  const AboutUlvenikScreen({super.key});

  @override
  State<AboutUlvenikScreen> createState() => _AboutUlvenikScreenState();
}

class _AboutUlvenikScreenState extends State<AboutUlvenikScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sageCrest = Color(0xFF6B8F7E);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);

  static const List<Map<String, String>> _audienceRoles = [
    {
      'title': 'Dog Owners',
      'detail':
          'Keep vaccinations, weight trends, training sessions, and family memories organised in one lifetime journal.',
    },
    {
      'title': 'Working Dog Handlers',
      'detail':
          'Log field conditions, scent/search environments, conditioning load, and operational records offline or online.',
    },
    {
      'title': 'Professional Dog Trainers',
      'detail':
          'Structure repeatable drill templates, track skill criteria objectively, and review multi-session progress.',
    },
    {
      'title': 'Sport Competitors',
      'detail':
          'Prepare for trials across obedience, agility, scent work, IGP, or gundog work with goal milestones and statistics.',
    },
    {
      'title': 'Behaviourists',
      'detail':
          'Correlate training thresholds, environmental triggers, medication courses, and progress timelines.',
    },
    {
      'title': 'Breeders',
      'detail':
          'Maintain structured health records, dental and orthopaedic histories, and developmental records per dog.',
    },
    {
      'title': 'Dog Clubs & Training Groups',
      'detail':
          'Encourage consistent handler homework and structured session reflection between club nights.',
    },
  ];

  int? _expandedAudienceIndex;

  void _copyValue(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    AppSnackbar.show(
      context,
      title: '$label Copied',
      message: '$value copied to clipboard.',
      type: SnackbarType.success,
    );
  }

  void _openWhatsNew() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const WhatsNewScreen()),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyScreen()),
    );
  }

  void _openTermsConditions() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const TermsConditionsScreen()),
    );
  }

  void _openLicences() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OpenSourceLicencesScreen(),
      ),
    );
  }

  void _openSupportEmailAction() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: _cardBorder)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'support@ulvenik.com',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            _copyValue('Support Email', 'support@ulvenik.com');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _offWhite,
                            side: const BorderSide(color: _cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy Email'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ContactSupportScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            foregroundColor: _offWhite,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline_rounded,
                            size: 16,
                          ),
                          label: const Text('Contact Form'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const UlvenikIcon(UlvenikIcons.back,
                      color: _stoneGrey,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                  const Text(
                    'About Ulvenik',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
        children: [
          // HERO BRAND CARD
          Container(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/white_mountain_only.png',
                  width: 58,
                  height: 28,
                  fit: BoxFit.contain,
                  color: _sageCrest,
                  errorBuilder: (_, _, _) => const Icon(Icons.terrain_rounded,
                    color: _sageCrest,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ulvenik',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => _copyValue(
                    'Version',
                    'Ulvenik Version 1.0.0 (Released 1 September 2026)',
                  ),
                  child: const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The Journey Builds the Wolf.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 22),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                const SizedBox(height: 22),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ulvenik is a premium dog training journal designed to help owners, trainers and working dog handlers record every step of their dog\'s journey.',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        height: 1.58,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Whether you\'re raising a family companion, preparing for competition or working towards professional goals, Ulvenik keeps every training session, health record, milestone and achievement organised in one place.',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        height: 1.58,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Built around consistency and long-term progress, Ulvenik allows you to focus on what matters most — your dog\'s development.',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        height: 1.58,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // WHAT IS ULVENIK?
          const SizedBox(height: 24),
          _buildSectionHeader('WHAT IS ULVENIK?'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(22),
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
                    color: _offWhite,
                    fontSize: 14,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Rather than teaching you how to train your dog, Ulvenik is designed to document your journey, helping you measure progress, identify patterns and build consistency over time.',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Every session, achievement and milestone becomes part of your dog\'s permanent history.',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // WHO IS IT FOR?
          const SizedBox(height: 24),
          _buildSectionHeader('WHO IS IT FOR?'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(22),
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
                    fontSize: 13.5,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 18),
                ...List.generate(_audienceRoles.length, (i) {
                  final role = _audienceRoles[i];
                  final expanded = _expandedAudienceIndex == i;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i == _audienceRoles.length - 1 ? 0 : 14,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _expandedAudienceIndex = expanded ? null : i;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: _forest,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  role['title']!,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (expanded) ...[
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                role['detail']!,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12.5,
                                  height: 1.45,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const Text(
                  'Whether you\'re recording your very first training session or preparing for national competitions, Ulvenik grows with you.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13.5,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // OUR PHILOSOPHY
          const SizedBox(height: 24),
          _buildSectionHeader('OUR PHILOSOPHY'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress isn\'t measured in a single training session. It\'s built through hundreds of small moments.\n'
                  'Every repetition. Every success. Every setback. Every lesson learned.\n'
                  'Ulvenik exists to capture those moments, helping you stay organised, motivated and focused on the bigger picture.',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 15,
                    height: 1.75,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // OUR VISION
          const SizedBox(height: 24),
          _buildSectionHeader('OUR VISION'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(22),
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
                    color: _offWhite,
                    fontSize: 14,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'By combining thoughtful design with powerful record keeping, Ulvenik aims to give every dog owner and trainer a place where their entire journey can be documented from the day their dog arrives until every achievement that follows.',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'No matter your sport, experience or goals — your journey deserves to be remembered.',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // APP INFORMATION
          const SizedBox(height: 24),
          _buildSectionHeader('APP INFORMATION'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                InkWell(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  onTap: () => _copyValue('App Version', '1.0.0'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Version',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          '1.0.0',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                InkWell(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  onTap: () => _copyValue('Release Date', '1 September 2026'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Released',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13.5,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          '1 September 2026',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LINKS
          const SizedBox(height: 24),
          _buildSectionHeader('LINKS'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildLinkRow(
                  icon: Icons.wb_sunny_outlined,
                  label: 'What\'s New',
                  onTap: _openWhatsNew,
                  isFirst: true,
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                _buildLinkRow(
                  icon: Icons.shield_outlined,
                  label: 'Privacy Policy',
                  onTap: _openPrivacyPolicy,
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                _buildLinkRow(
                  icon: Icons.description_outlined,
                  label: 'Terms & Conditions',
                  onTap: _openTermsConditions,
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                _buildLinkRow(
                  icon: Icons.code_rounded,
                  label: 'Open Source Licences',
                  onTap: _openLicences,
                  isLast: true,
                ),
              ],
            ),
          ),

          // CONTACT
          const SizedBox(height: 24),
          _buildSectionHeader('CONTACT'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildLinkRow(
                  icon: Icons.mail_outline_rounded,
                  label: 'Support Email',
                  trailingValue: 'support@ulvenik.com',
                  onTap: _openSupportEmailAction,
                  isFirst: true,
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                _buildLinkRow(
                  icon: Icons.language_rounded,
                  label: 'Official Website',
                  trailingValue: 'ulvenik.com',
                  onTap: () =>
                      _copyValue('Official Website', 'https://ulvenik.com'),
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                _buildLinkRow(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  trailingValue: '@ulvenik',
                  onTap: () => _copyValue(
                    'Instagram Handle',
                    'https://instagram.com/ulvenik',
                  ),
                  isLast: true,
                ),
              ],
            ),
          ),

          // DESIGNED & DEVELOPED FOOTER CARD
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                const Icon(Icons.favorite_border_rounded,
                  color: _stoneGrey,
                  size: 22,
                ),
                const SizedBox(height: 14),
                const Text(
                  'DESIGNED & DEVELOPED',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Designed with a passion for dogs, training and lifelong progress. Every feature within Ulvenik has been created with one goal in mind — to provide the most complete, organised and enjoyable way to document a dog\'s life and development.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    height: 1.58,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '© Ulvenik. All rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _stoneGrey.withValues(alpha: 0.65),
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildLinkRow({
    required IconData icon,
    required String label,
    String? trailingValue,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 19),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (trailingValue != null) ...[
              Text(
                trailingValue,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 8),
            ],
            const UlvenikIcon(UlvenikIcons.details,
              color: _stoneGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
