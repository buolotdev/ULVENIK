import 'package:flutter/material.dart';

/// Screen: Restore In-App Purchases (Node / frame restore_purchases.png)
/// Validates active Apple App Store or Google Play Store licenses
/// for Core Membership, Trainer Pack, and Sport Pack.
class RestorePurchasesScreen extends StatefulWidget {
  const RestorePurchasesScreen({super.key});

  @override
  State<RestorePurchasesScreen> createState() => _RestorePurchasesScreenState();
}

class _RestorePurchasesScreenState extends State<RestorePurchasesScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);

  bool _isRestoring = false;

  void _handleRestore() async {
    setState(() => _isRestoring = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isRestoring = false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Purchases Restored', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your Core Membership and Trainer Pack entitlements have been successfully verified and activated.',
          style: TextStyle(color: _stoneGrey, fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: _forest, foregroundColor: _offWhite),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Restore Purchases',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ─── HERO ICON & TITLE ──────────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF162024),
                shape: BoxShape.circle,
                border: Border.all(color: _mint.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.cloud_sync_outlined, color: _mint, size: 44),
            ),
            const SizedBox(height: 20),
            const Text(
              'Missing a Purchase?',
              style: TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Restore an existing Ulvenik membership\nor Pack without being charged again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _stoneGrey, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 32),

            // ─── INFORMATION CARD ───────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // WHAT THIS DOES
                  const Text(
                    'WHAT THIS DOES',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Checks your App Store account for an existing Ulvenik membership. You will not be charged.',
                    style: TextStyle(color: _offWhite, fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: _cardBorder, height: 1),
                  const SizedBox(height: 16),

                  // PURCHASE PLATFORM
                  const Text(
                    'PURCHASE PLATFORM',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Apple App Store',
                    style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: _cardBorder, height: 1),
                  const SizedBox(height: 16),

                  // ITEMS THAT CAN BE RESTORED
                  const Text(
                    'ITEMS THAT CAN BE RESTORED',
                    style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  _buildRestorableItem('Core Membership'),
                  const SizedBox(height: 8),
                  _buildRestorableItem('Trainer Pack'),
                  const SizedBox(height: 8),
                  _buildRestorableItem('Sport Pack'),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // ─── RESTORE BUTTON ─────────────────────────────────────────────
            ElevatedButton(
              onPressed: _isRestoring ? null : _handleRestore,
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                disabledBackgroundColor: _forest.withValues(alpha: 0.5),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isRestoring
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: _offWhite, strokeWidth: 2.5),
                    )
                  : const Text(
                      'Restore Purchases',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 14),
            const Text(
              "You won't be charged. Expired subscriptions cannot be restored.",
              textAlign: TextAlign.center,
              style: TextStyle(color: _stoneGrey, fontSize: 12),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRestorableItem(String label) {
    return Row(
      children: [
        const Icon(Icons.check, color: _mint, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

