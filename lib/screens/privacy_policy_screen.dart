import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'contact_support_screen.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _forestLink = Color(0xFF3E8E72);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final TapGestureRecognizer _dpoEmailTapRecognizer;

  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _collectKey = GlobalKey();
  final GlobalKey _useKey = GlobalKey();
  final GlobalKey _securityKey = GlobalKey();
  final GlobalKey _rightsKey = GlobalKey();
  final GlobalKey _questionsKey = GlobalKey();

  bool _tocExpanded = false;
  bool _searchVisible = false;
  String _searchQuery = '';
  double _readingProgress = 0.36;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
    _dpoEmailTapRecognizer = TapGestureRecognizer()
      ..onTap = _handleSupportEmailTap;
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    final ratio = (_scrollController.offset / maxScroll).clamp(0.08, 1.0);
    if ((ratio - _readingProgress).abs() > 0.01) {
      setState(() => _readingProgress = ratio);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    _searchController.dispose();
    _dpoEmailTapRecognizer.dispose();
    super.dispose();
  }

  void _jumpToSection(GlobalKey key) {
    setState(() => _tocExpanded = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
          alignment: 0.04,
        );
      }
    });
  }

  bool _clauseMatches(List<String> texts) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return true;
    return texts.any((t) => t.toLowerCase().contains(q));
  }

  void _handleSupportEmailTap() {
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
                    'Data Protection & Privacy Enquiries',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'support@ulvenik.com',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 14,
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
                            Clipboard.setData(
                              const ClipboardData(text: 'support@ulvenik.com'),
                            );
                            AppSnackbar.show(
                              context,
                              title: 'Email Copied',
                              message:
                                  'support@ulvenik.com copied to clipboard.',
                              type: SnackbarType.success,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _offWhite,
                            side: const BorderSide(color: _cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const UlvenikIcon(UlvenikIcons.overflowMenu, size: 16),
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
                          icon: const UlvenikIcon(UlvenikIcons.notifications,
                            size: 16,
                          ),
                          label: const Text('Contact Team'),
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

  void _copyFullPolicySummary() {
    const summary = '''Ulvenik Privacy Policy (Last Updated: 1 September 2026)
1. Introduction — Committed to protecting personal information and dog tracking records.
2. Information We Collect — Account info, Dog profiles, Training records, Health records, Device telemetry.
3. How We Use Your Information — Operate & sync platform, personalise experience, refine offline/export features, send security alerts.
4. Data Storage & Security — On-device encryption, TLS 1.3 sync, never sold or monetized to data brokers.
5. Your Rights — Full ownership, export, update, or complete erasure via settings or support@ulvenik.com.''';
    Clipboard.setData(const ClipboardData(text: summary));
    AppSnackbar.show(
      context,
      title: 'Privacy Policy Copied',
      message: 'A structured copy of the Privacy Policy is on your clipboard.',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showIntro = _clauseMatches([
      'Introduction',
      'Welcome to Ulvenik. We are committed to protecting your privacy',
      'sovereignty over your training journey',
    ]);
    final showCollect = _clauseMatches([
      'Information We Collect',
      'Account information',
      'Dog profile information',
      'Training records and session data',
      'Health and medication records',
      'Device information and usage data',
    ]);
    final showUse = _clauseMatches([
      'How We Use Your Information',
      'synchronization services',
      'personalise your handler experience',
      'offline performance',
      'security alerts',
    ]);
    final showSecurity = _clauseMatches([
      'Data Storage & Security',
      'encrypted on-device',
      'TLS 1.3 encryption',
      'Offline-first architecture',
      'data brokers',
    ]);
    final showRights = _clauseMatches([
      'Your Rights',
      'ownership of your data',
      'export your entire dog journal',
      'account erasure',
      'data protection officer',
      'support@ulvenik.com',
    ]);

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Container(
          color: _obsidian,
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 55,
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
                      const Expanded(
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Search Privacy Policy',
                        onPressed: () {
                          setState(() {
                            _searchVisible = !_searchVisible;
                            if (!_searchVisible) {
                              _searchController.clear();
                              _searchQuery = '';
                            }
                          });
                        },
                        icon: UlvenikIcon.fromMaterial(
                          _searchVisible ? Icons.close_rounded : Icons.search,
                          color: _searchVisible ? _mint : _stoneGrey,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: _readingProgress,
                    backgroundColor: _cardBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(_forest),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        children: [
          if (_searchVisible) ...[
            Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _forest.withValues(alpha: 0.65)),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (v) => setState(() => _searchQuery = v),
                cursorColor: _mint,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                  prefixIcon: UlvenikIcon(UlvenikIcons.search, color: _mint, size: 18),
                  hintText: 'Search clauses (e.g. encryption, erasure, TLS)...',
                  hintStyle: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],

          // LAST UPDATED
          Row(
            children: [
              const Text(
                'LAST UPDATED',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  fontFamily: 'Inter',
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '•',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
              ),
              const Expanded(
                child: Text(
                  '1 September 2026',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              GestureDetector(
                onTap: _copyFullPolicySummary,
                child: const UlvenikIcon(UlvenikIcons.overflowMenu,
                  color: _stoneGrey,
                  size: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Text(
            'CONTENTS',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),

          // Table of Contents Dropdown Card
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _tocExpanded = !_tocExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        const UlvenikIcon(UlvenikIcons.training,
                          color: _stoneGrey,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Table of Contents',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        UlvenikIcon.fromMaterial(
                          _tocExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: _stoneGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_tocExpanded) ...[
                  const Divider(height: 1, thickness: 1, color: _cardBorder),
                  _buildTocItem('1. Introduction', _introKey),
                  _buildTocItem('2. Information We Collect', _collectKey),
                  _buildTocItem('3. How We Use Your Information', _useKey),
                  _buildTocItem('4. Data Storage & Security', _securityKey),
                  _buildTocItem('5. Your Rights', _rightsKey),
                  _buildTocItem('6. Questions & Contact', _questionsKey),
                ],
              ],
            ),
          ),

          // 1. Introduction
          if (showIntro) ...[
            const SizedBox(height: 28),
            Text(
              'Introduction',
              key: _introKey,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Welcome to Ulvenik. We are committed to protecting your privacy and ensuring the integrity and confidentiality of your personal information, as well as the specialized tracking records you log for your dogs.',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This Privacy Policy outlines the specific types of data collected through the Ulvenik mobile application, how your records are securely processed, and the measures we maintain to protect your sovereignty over your training journey.',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
          ],

          // 2. Information We Collect
          if (showCollect) ...[
            const SizedBox(height: 32),
            Text(
              'Information We Collect',
              key: _collectKey,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'To provide an accurate, high-fidelity sports tracking and veterinary management environment, Ulvenik gathers specific categories of user-provided information:',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildBoldBullet(
              'Account information: Full name, verified email address, authentication credentials, and account settings.',
            ),
            const SizedBox(height: 14),
            _buildBoldBullet(
              'Dog profile information: Registered names, breed classifications, birth dates, target weights, and visual portraits.',
            ),
            const SizedBox(height: 14),
            _buildBoldBullet(
              'Training records and session data: Exercise repetitions, timestamps, duration, field conditions, and handler evaluations.',
            ),
            const SizedBox(height: 14),
            _buildBoldBullet(
              'Health and medication records: Veterinary checkups, vaccination cycles, clinical therapies, and dosage schedules.',
            ),
            const SizedBox(height: 14),
            _buildBoldBullet(
              'Device information and usage data: Operating system telemetry, local storage allocations, and app performance metrics.',
            ),
          ],

          // 3. How We Use Your Information
          if (showUse) ...[
            const SizedBox(height: 32),
            Text(
              'How We Use Your Information',
              key: _useKey,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We utilize the collected telemetry strictly to serve your training system and deliver private, data-dense insights:',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildNumberedItem(
              1,
              'To provide, operate, and maintain the Ulvenik training platform and data synchronization services.',
            ),
            const SizedBox(height: 14),
            _buildNumberedItem(
              2,
              'To personalise your handler experience, calculation rings, and longitudinal conditioning models.',
            ),
            const SizedBox(height: 14),
            _buildNumberedItem(
              3,
              'To improve our platform, refine offline performance, and expand native export features.',
            ),
            const SizedBox(height: 14),
            _buildNumberedItem(
              4,
              'To send critical account notifications, security alerts, and system backup verifications.',
            ),
          ],

          // 4. Data Storage & Security
          if (showSecurity) ...[
            const SizedBox(height: 32),
            Text(
              'Data Storage & Security',
              key: _securityKey,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'All local database records are encrypted on-device. When cloud synchronization is enabled, records are transmitted via TLS 1.3 encryption and stored in compliant, hardened data centers. We never sell, monetize, or lease your training logs or veterinary archives to third-party data brokers.',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Offline-first architecture ensures that your data remains fully accessible even in remote field or forest locations without network availability.',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.58,
                fontFamily: 'Inter',
              ),
            ),
          ],

          // 5. Your Rights
          if (showRights) ...[
            const SizedBox(height: 32),
            Text(
              'Your Rights',
              key: _rightsKey,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14.5,
                  height: 1.6,
                  fontFamily: 'Inter',
                ),
                children: [
                  const TextSpan(
                    text:
                        'You maintain full ownership of your data. You may export your entire dog journal, request complete account erasure, or update your information at any time directly through the app settings, or by contacting our data protection officer at ',
                  ),
                  TextSpan(
                    text: 'support@ulvenik.com',
                    recognizer: _dpoEmailTapRecognizer,
                    style: const TextStyle(
                      color: _forestLink,
                      decoration: TextDecoration.underline,
                      decorationColor: _forestLink,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ],

          if (!showIntro &&
              !showCollect &&
              !showUse &&
              !showSecurity &&
              !showRights) ...[
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: const Text(
                'No clauses matched your search term. Clear the search bar above to view all sections.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13.5,
                  height: 1.45,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],

          // QUESTIONS?
          const SizedBox(height: 34),
          Text(
            'QUESTIONS?',
            key: _questionsKey,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'If you have any questions regarding how Ulvenik collects or processes your information, please contact our support team.',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13.5,
                    height: 1.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                InkWell(
                  onTap: _handleSupportEmailTap,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        UlvenikIcon(UlvenikIcons.notifications,
                          color: _stoneGrey,
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Support Email',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Text(
                          'support@ulvenik.com',
                          style: TextStyle(
                            color: _forestLink,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: _forestLink,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 6),
                        UlvenikIcon(UlvenikIcons.details,
                          color: _stoneGrey,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: _cardBorder),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      const ClipboardData(text: 'https://ulvenik.com'),
                    );
                    AppSnackbar.show(
                      context,
                      title: 'Official Website Copied',
                      message: 'https://ulvenik.com copied to clipboard.',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 14, bottom: 2),
                    child: Row(
                      children: [
                        UlvenikIcon(UlvenikIcons.overflowMenu,
                          color: _stoneGrey,
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Official Website',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Text(
                          'ulvenik.com',
                          style: TextStyle(
                            color: _forestLink,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: _forestLink,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 6),
                        UlvenikIcon(UlvenikIcons.details,
                          color: _stoneGrey,
                          size: 17,
                        ),
                      ],
                    ),
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

  Widget _buildTocItem(String label, GlobalKey targetKey) {
    return InkWell(
      onTap: () => _jumpToSection(targetKey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const UlvenikIcon(UlvenikIcons.sort,
              color: _mint,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoldBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: UlvenikIcon(UlvenikIcons.completed, size: 5, color: _stoneGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.55,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$number.',
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.55,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.55,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
