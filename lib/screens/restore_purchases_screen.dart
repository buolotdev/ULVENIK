import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'contact_support_screen.dart';

enum _RestorePhase { idle, scanning, completed }

class _EntitlementItem {
  final String title;
  final String detailAfterRestore;
  final String receiptToken;

  const _EntitlementItem({
    required this.title,
    required this.detailAfterRestore,
    required this.receiptToken,
  });
}

class RestorePurchasesScreen extends StatefulWidget {
  const RestorePurchasesScreen({super.key});

  @override
  State<RestorePurchasesScreen> createState() => _RestorePurchasesScreenState();
}

class _RestorePurchasesScreenState extends State<RestorePurchasesScreen>
    with SingleTickerProviderStateMixin {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;

  late final AnimationController _spinController;

  _RestorePhase _phase = _RestorePhase.idle;
  int _verifiedCount = 0;
  double _scanProgress = 0.0;
  String _platform = 'Apple App Store';

  static const List<_EntitlementItem> _entitlements = [
    _EntitlementItem(
      title: 'Core',
      detailAfterRestore: 'Annual · Renews 18 Sep 2027',
      receiptToken: 'APPL-CORE-9824-ULV',
    ),
    _EntitlementItem(
      title: 'Sport Pack',
      detailAfterRestore: 'Annual · Renews 18 Sep 2027',
      receiptToken: 'APPL-SPRT-7731-ULV',
    ),
    _EntitlementItem(
      title: 'Trainer Pack',
      detailAfterRestore: 'Monthly · Renews 28 Jul 2025',
      receiptToken: 'APPL-TRNR-4410-ULV',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _startRestoreScan() async {
    if (_phase == _RestorePhase.scanning) return;

    setState(() {
      _phase = _RestorePhase.scanning;
      _verifiedCount = 0;
      _scanProgress = 0.12;
    });
    _spinController.repeat();

    for (int step = 1; step <= _entitlements.length; step++) {
      await Future<void>.delayed(const Duration(milliseconds: 420));
      if (!mounted) return;
      setState(() {
        _verifiedCount = step;
        _scanProgress = step / _entitlements.length;
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    _spinController.stop();
    _spinController.reset();

    setState(() {
      _phase = _RestorePhase.completed;
      _scanProgress = 1.0;
    });

    AppSnackbar.show(
      context,
      title: 'Purchases Restored',
      message:
          '3 active entitlements verified from $_platform with zero charges.',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 36, 16, 28),
                child: Column(
                  children: [
                    _buildHeroHeader(),
                    const SizedBox(height: 30),
                    _buildInfoCard(),
                    if (_phase == _RestorePhase.completed) ...[
                      const SizedBox(height: 16),
                      _buildSupportTroubleshootPrompt(),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomActionFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 16, 16),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: UlvenikIcon(UlvenikIcons.back,
                color: _stoneGrey,
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Restore Purchases',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    String title;
    String subtitle;
    switch (_phase) {
      case _RestorePhase.idle:
        title = 'Missing a Purchase?';
        subtitle =
            'Restore an existing Ulvenik membership\nor Pack without being charged again.';
        break;
      case _RestorePhase.scanning:
        title = 'Verifying Receipts...';
        subtitle =
            'Securely checking your $_platform\npurchase history and active Pack tokens.';
        break;
      case _RestorePhase.completed:
        title = 'Purchases Restored';
        subtitle =
            'Verified 3 active entitlements linked to your\n$_platform account.';
        break;
    }

    return Column(
      children: [
        AnimatedBuilder(
          animation: _spinController,
          builder: (context, _) {
            return SizedBox(
              width: 72,
              height: 60,
              child: CustomPaint(
                painter: _CloudReceiptRestorePainter(
                  rotationAngle: _phase == _RestorePhase.scanning
                      ? _spinController.value * 2 * math.pi
                      : 0.0,
                  isCompleted: _phase == _RestorePhase.completed,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _offWhite,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _stoneGrey,
            height: 1.48,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHAT THIS DOES',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _stoneGrey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Checks your $_platform account for an existing Ulvenik membership. You will not be charged.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _stoneGrey,
              height: 1.45,
            ),
          ),
          if (_phase != _RestorePhase.idle) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: _scanProgress),
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 5,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(_forest),
                  );
                },
              ),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(height: 1, thickness: 1, color: _cardBorder),
          ),
          GestureDetector(
            onTap: _openPlatformPickerSheet,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PURCHASE PLATFORM',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _stoneGrey,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _platform,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                  ],
                ),
                if (_phase != _RestorePhase.scanning)
                  Icon(Icons.unfold_more_rounded,
                    size: 18,
                    color: _stoneGrey.withValues(alpha: 0.6),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(height: 1, thickness: 1, color: _cardBorder),
          ),
          Text(
            _phase == _RestorePhase.completed
                ? 'RESTORED ENTITLEMENTS'
                : 'ITEMS THAT CAN BE RESTORED',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _stoneGrey,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < _entitlements.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _buildEntitlementRow(i, _entitlements[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildEntitlementRow(int index, _EntitlementItem item) {
    final isVerified = index < _verifiedCount;

    return GestureDetector(
      onTap: isVerified ? () => _showEntitlementTokenSheet(item) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_rounded,
            color: isVerified ? _forest : _sageMint,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5,
                    fontWeight: isVerified ? FontWeight.w600 : FontWeight.w400,
                    color: isVerified ? _offWhite : _stoneGrey,
                  ),
                ),
                if (isVerified) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.detailAfterRestore,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: _stoneGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _forest.withValues(alpha: 0.38),
                ),
              ),
              child: const Text(
                'RESTORED',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _forest,
                  letterSpacing: 0.6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSupportTroubleshootPrompt() {
    return GestureDetector(
      onTap: _openSupportTroubleshootSheet,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: const Row(
          children: [
            Icon(Icons.support_agent_rounded, color: _sageMint, size: 19),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Still missing an add-on Pack? Troubleshoot or contact Billing Support',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _offWhite,
                ),
              ),
            ),
            UlvenikIcon(UlvenikIcons.details, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionFooter() {
    final isScanning = _phase == _RestorePhase.scanning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                disabledBackgroundColor: _forest.withValues(alpha: 0.55),
                foregroundColor: _offWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: isScanning ? null : _startRestoreScan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isScanning) ...[
                    const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    isScanning
                        ? 'Scanning $_platform...'
                        : _phase == _RestorePhase.completed
                            ? 'Scan Again'
                            : 'Restore Purchases',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openSupportTroubleshootSheet,
            behavior: HitTestBehavior.opaque,
            child: const Text(
              "You won't be charged. Expired subscriptions cannot be\nrestored.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _stoneGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPlatformPickerSheet() {
    if (_phase == _RestorePhase.scanning) return;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Purchase Platform',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 12),
                for (final p in const [
                  'Apple App Store',
                  'Google Play Store',
                  'Ulvenik Web Billing',
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      p,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                    trailing: UlvenikIcon.fromMaterial(
                      _platform == p
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: _platform == p ? _forest : _stoneGrey,
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        _platform = p;
                        _phase = _RestorePhase.idle;
                        _verifiedCount = 0;
                        _scanProgress = 0.0;
                      });
                      Navigator.of(sheetCtx).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEntitlementTokenSheet(_EntitlementItem item) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.detailAfterRestore} · $_platform',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Token: ${item.receiptToken}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _offWhite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: item.receiptToken),
                          );
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Receipt Token Copied',
                            message:
                                'Copied ${item.receiptToken} to clipboard.',
                            type: SnackbarType.info,
                          );
                        },
                        child: const Icon(Icons.copy_rounded,
                          color: _forest,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSupportTroubleshootSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Purchase Recovery Help',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Confirm you are signed into the same Apple ID used during purchase.\n'
                  '• Family Sharing add-on Packs must be restored from the primary organizer account.\n'
                  '• Expired trials or refunded packs cannot be restored automatically.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _stoneGrey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _offWhite,
                          side: const BorderSide(color: _cardBorder),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheetCtx).pop();
                          _startRestoreScan();
                        },
                        child: const Text(
                          'Retry Scan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheetCtx).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ContactSupportScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Contact Support',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CloudReceiptRestorePainter extends CustomPainter {
  final double rotationAngle;
  final bool isCompleted;

  const _CloudReceiptRestorePainter({
    required this.rotationAngle,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sageStroke = Paint()
      ..color = const Color(0xFF7A8F7A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final greenStroke = Paint()
      ..color = AppColors.primaryForestGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Cloud outline matching Figma vector
    final cloud = Path()
      ..moveTo(20, 42)
      ..lineTo(16, 42)
      ..cubicTo(9, 42, 5, 36.5, 5, 30.5)
      ..cubicTo(5, 24.5, 9.5, 20, 15.5, 19.5)
      ..cubicTo(17.5, 10.5, 25.5, 5, 35, 5)
      ..cubicTo(45, 5, 53, 12, 54.5, 21)
      ..cubicTo(61, 22, 65.5, 27, 65.5, 33.5)
      ..cubicTo(65.5, 38, 63, 41.5, 59, 43);
    canvas.drawPath(cloud, sageStroke);

    // Inner receipt document
    final doc = RRect.fromRectAndRadius(
      const Rect.fromLTWH(24, 19, 20, 26),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(doc, sageStroke);
    canvas.drawLine(const Offset(28, 25), const Offset(40, 25), sageStroke);
    canvas.drawLine(const Offset(28, 30), const Offset(38, 30), sageStroke);
    canvas.drawLine(const Offset(28, 35), const Offset(34, 35), sageStroke);

    // Bottom-right refresh badge circle
    const badgeCenter = Offset(46, 42);
    const badgeRadius = 11.0;

    final bgClear = Paint()
      ..color = AppColors.backgroundObsidian
      ..style = PaintingStyle.fill;
    canvas.drawCircle(badgeCenter, badgeRadius + 2.5, bgClear);

    if (isCompleted) {
      canvas.drawCircle(badgeCenter, badgeRadius, greenStroke);
      final check = Path()
        ..moveTo(badgeCenter.dx - 4.2, badgeCenter.dy + 0.3)
        ..lineTo(badgeCenter.dx - 1.2, badgeCenter.dy + 3.4)
        ..lineTo(badgeCenter.dx + 4.6, badgeCenter.dy - 3.2);
      canvas.drawPath(check, greenStroke);
    } else {
      canvas.save();
      canvas.translate(badgeCenter.dx, badgeCenter.dy);
      canvas.rotate(rotationAngle);
      final arcRect =
          Rect.fromCircle(center: Offset.zero, radius: badgeRadius);
      canvas.drawArc(arcRect, -math.pi * 0.65, math.pi * 1.65, false, greenStroke);
      // Arrowhead at top-left of arc
      final arrow = Path()
        ..moveTo(-5.5, -12.0)
        ..lineTo(-4.8, -7.8)
        ..lineTo(-0.8, -9.2);
      canvas.drawPath(arrow, greenStroke);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CloudReceiptRestorePainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.isCompleted != isCompleted;
  }
}
