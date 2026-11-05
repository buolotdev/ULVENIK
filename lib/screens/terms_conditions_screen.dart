import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'contact_support_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final TapGestureRecognizer _terminationEmailRecognizer;

  final GlobalKey _sec1Key = GlobalKey();
  final GlobalKey _sec2Key = GlobalKey();
  final GlobalKey _sec3Key = GlobalKey();
  final GlobalKey _sec4Key = GlobalKey();
  final GlobalKey _sec5Key = GlobalKey();
  final GlobalKey _questionsKey = GlobalKey();

  bool _tocExpanded = true;
  bool _searchVisible = false;
  String _searchQuery = '';
  double _readingProgress = 0.13;

  static const Map<String, Map<String, String>> _supplementaryClauses = {
    '5. Acceptable Use': {
      'title': 'Acceptable Use Policy',
      'body':
          'Handlers agree to use Ulvenik solely for lawful canine welfare, sport, conditioning, and record-keeping purposes. Automated scraping, unauthorized API probing, uploading malicious files, or interfering with cloud synchronization infrastructure is strictly prohibited.',
    },
    '6. Intellectual Property': {
      'title': 'Intellectual Property',
      'body':
          'All Ulvenik trademarks, visual interfaces, calculation engines, icons, and software architecture remain the exclusive property of Ulvenik. You retain 100% ownership of all photos, videos, health records, and training logs you create for your dogs.',
    },
    '7. Limitation of Liability': {
      'title': 'Limitation of Liability',
      'body':
          'Ulvenik is a record-keeping and analytics journal and does not provide veterinary diagnosis or medical advice. Always consult a qualified veterinarian or certified canine rehabilitation professional before modifying conditioning loads or clinical treatments.',
    },
    '9. Changes to Terms': {
      'title': 'Changes to Terms',
      'body':
          'When material updates are made to these Terms & Conditions, Ulvenik increments the document revision number and notifies active account holders in-app and via registered email prior to the effective date.',
    },
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _terminationEmailRecognizer = TapGestureRecognizer()
      ..onTap = _openSupportActionSheet;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;
    final ratio = (_scrollController.offset / maxExtent).clamp(0.10, 1.0);
    if ((ratio - _readingProgress).abs() > 0.01) {
      setState(() => _readingProgress = ratio);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _terminationEmailRecognizer.dispose();
    super.dispose();
  }

  bool _matchesSearch(List<String> haystacks) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return true;
    return haystacks.any((h) => h.toLowerCase().contains(q));
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
        alignment: 0.04,
      );
    }
  }

  void _openSupplementaryClauseSheet(String tocLabel) {
    final clause = _supplementaryClauses[tocLabel];
    if (clause == null) return;
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _stoneGrey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'REV 4.2',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const UlvenikIcon(UlvenikIcons.back,
                          color: _stoneGrey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    clause['title']!,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    clause['body']!,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14.5,
                      height: 1.6,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openRevisionSheet() {
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _stoneGrey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Document Revision · REV 4.2',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Last Updated 15 September 2026 · Clarified offline data archive ownership, app store billing cancellation rights, and multi-canine team tiers.',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13.5,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        const copyText =
                            'Ulvenik Terms & Conditions (REV 4.2 — 15 September 2026)\n'
                            '1. Acceptance of Terms\n'
                            '2. Use of the Platform\n'
                            '3. User Accounts\n'
                            '4. Subscription & Billing\n'
                            '5. Termination — Contact: support@ulvenik.com';
                        Clipboard.setData(const ClipboardData(text: copyText));
                        AppSnackbar.show(
                          context,
                          title: 'Terms Summary Copied',
                          message: 'REV 4.2 summary copied to clipboard.',
                          type: SnackbarType.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const UlvenikIcon(UlvenikIcons.overflowMenu, size: 17),
                      label: const Text('Copy Terms Summary (REV 4.2)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openSupportActionSheet() {
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
                    'Legal & Account Support',
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

  void _handleTocTap(String label) {
    switch (label) {
      case '1. Acceptance of Terms':
        _scrollToKey(_sec1Key);
        break;
      case '2. Use of the Platform':
        _scrollToKey(_sec2Key);
        break;
      case '3. User Accounts':
        _scrollToKey(_sec3Key);
        break;
      case '4. Subscription & Billing':
        _scrollToKey(_sec4Key);
        break;
      case '8. Termination':
        _scrollToKey(_sec5Key);
        break;
      case '10. Contact Us':
        _scrollToKey(_questionsKey);
        break;
      default:
        _openSupplementaryClauseSheet(label);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const tocItems = [
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

    final show1 = _matchesSearch([
      '1. Acceptance of Terms',
      'binding agreement',
      'training',
      'record-keeping',
    ]);
    final show2 = _matchesSearch([
      '2. Use of the Platform',
      'dog training',
      '18 years or older',
      'confidentiality',
      'reverse-engineer',
    ]);
    final show3 = _matchesSearch([
      '3. User Accounts',
      'sole authority',
      'recorded dog training',
      'connected devices',
    ]);
    final show4 = _matchesSearch([
      '4. Subscription & Billing',
      'monthly or annual',
      'cancel your subscription',
      'refunds',
      'storage allocations',
    ]);
    final show5 = _matchesSearch([
      '5. Termination',
      'suspend or terminate',
      'data archive',
      'account erasure',
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
                          'Terms & Conditions',
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
                        tooltip: 'Search Terms & Conditions',
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
                  hintText: 'Search terms (e.g. billing, refunds, erasure)...',
                  hintStyle: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],

          // LAST UPDATED + REV 4.2 Badge
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
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '15 September 2026',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              GestureDetector(
                onTap: _openRevisionSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _forest.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'REV 4.2',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      fontFamily: 'Inter',
                    ),
                  ),
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

          // Table of Contents Card (Expanded by default per Figma SVG)
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(14),
                    bottom: _tocExpanded
                        ? Radius.zero
                        : const Radius.circular(14),
                  ),
                  onTap: () => setState(() => _tocExpanded = !_tocExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
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
                              fontWeight: FontWeight.w700,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: tocItems.map((label) {
                        return InkWell(
                          onTap: () => _handleTocTap(label),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                const UlvenikIcon(UlvenikIcons.details,
                                  color: _stoneGrey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 1. Acceptance of Terms
          if (show1) ...[
            const SizedBox(height: 28),
            Text(
              '1. Acceptance of Terms',
              key: _sec1Key,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'By accessing or using the Ulvenik application, website, and related services, you enter into a binding agreement and acknowledge full adherence to these Terms & Conditions. These terms govern your access to our dog training, strength & conditioning, health, goal-tracking, and Timeline record-keeping tools.',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
          ],

          // 2. Use of the Platform
          if (show2) ...[
            const SizedBox(height: 30),
            Text(
              '2. Use of the Platform',
              key: _sec2Key,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ulvenik provides dog owners, handlers, and trainers with structured tools for recording training sessions, strength & conditioning activities, health history, goals, and Timeline records. When using Ulvenik, you accept direct responsibility for adhering to the following standards:',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildBullet(
              'You must be 18 years or older or have verified parental or guardian consent to use Ulvenik.',
            ),
            const SizedBox(height: 12),
            _buildBullet(
              'You are responsible for maintaining the confidentiality and security of your account credentials.',
            ),
            const SizedBox(height: 12),
            _buildBullet(
              'You agree not to misuse the platform, attempt to reverse-engineer the application, or interfere with Ulvenik services.',
            ),
            const SizedBox(height: 12),
            _buildBullet(
              'You agree to provide accurate account and dog profile information when creating and managing your account.',
            ),
          ],

          // 3. User Accounts
          if (show3) ...[
            const SizedBox(height: 30),
            Text(
              '3. User Accounts',
              key: _sec3Key,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Account holders maintain sole authority over their recorded dog profiles, training sessions, and health logs. Users are responsible for all activity carried out under their account across connected devices.',
              style: TextStyle(
                color: _offWhite,
                fontSize: 14.5,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
          ],

          // 4. Subscription & Billing
          if (show4) ...[
            const SizedBox(height: 30),
            Text(
              '4. Subscription & Billing',
              key: _sec4Key,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ulvenik offers Core memberships and optional add-on packs (including Sport Pack, Trainer Pack, and Complete). All recurring subscriptions are governed by the following terms:',
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
              'Subscriptions are billed on a recurring monthly or annual basis depending on your selected tier.',
            ),
            const SizedBox(height: 12),
            _buildNumberedItem(
              2,
              'You may cancel your subscription at any time directly through app store subscription settings.',
            ),
            const SizedBox(height: 12),
            _buildNumberedItem(
              3,
              'Refunds are subject to our comprehensive customer protection and refund policies.',
            ),
            const SizedBox(height: 12),
            _buildNumberedItem(
              4,
              'Tier pricing and storage allocations may change with reasonable prior written notice.',
            ),
          ],

          // 5. Termination
          if (show5) ...[
            const SizedBox(height: 30),
            Text(
              '5. Termination',
              key: _sec5Key,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18.5,
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
                        'Ulvenik reserves the right to suspend or terminate accounts that breach platform safety or acceptable use rules. Handlers may close accounts at any time by exporting their canine data archive and initiating account erasure via settings, or by contacting us directly: ',
                  ),
                  const TextSpan(
                    text: 'contact us at ',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: 'support@ulvenik.com',
                    recognizer: _terminationEmailRecognizer,
                    style: const TextStyle(
                      color: _mint,
                      decoration: TextDecoration.underline,
                      decorationColor: _mint,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ],

          if (!show1 && !show2 && !show3 && !show4 && !show5) ...[
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: const Text(
                'No terms matched your search query. Clear the search bar above to view all clauses.',
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
                  'Questions about these Terms & Conditions?',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'If you have any questions regarding the use of Ulvenik or these Terms & Conditions, please contact our support team.',
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
                  onTap: _openSupportActionSheet,
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
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Text(
                          'support@ulvenik.com',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: _mint,
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
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        Text(
                          'ulvenik.com',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: _mint,
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

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 7),
          child: UlvenikIcon(UlvenikIcons.completed, size: 5.5, color: _stoneGrey),
        ),
        const SizedBox(width: 12),
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
    );
  }

  Widget _buildNumberedItem(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 26,
          child: Text(
            '$number.',
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13.5,
              height: 1.6,
              fontFamily: 'monospace',
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
    );
  }
}
