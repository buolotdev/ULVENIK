import 'package:flutter/material.dart';
import 'billing_history_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class SubscriptionDetailsScreen extends StatefulWidget {
  const SubscriptionDetailsScreen({super.key});

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  bool _clubPackAdded = false;

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Subscription Help', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: const Text(
          'Ulvenik subscriptions and add-on packs are managed directly through your Apple App Store account. You can cancel or switch plans at any time.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: _mint, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _restorePurchases() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: _mint),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.pop(context); // close loader

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Purchases Restored', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your active Ulvenik Core, Trainer Pack, and Sport Pack memberships were verified successfully with the App Store.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  void _showRedeemCodeSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Redeem Code', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Enter your promotional or gift voucher code below.', style: TextStyle(color: _stoneGrey, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: _offWhite, letterSpacing: 2, fontWeight: FontWeight.bold),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'PROMO-XXXX-XXXX',
                hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
                filled: true,
                fillColor: const Color(0xFF14181B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Promo code applied successfully!'), backgroundColor: _forest),
                  );
                },
                child: const Text('Apply Code', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
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
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: _offWhite),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // CARD 1: ULVENIK CORE
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.landscape, color: _stoneGrey, size: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _forest.withValues(alpha: 0.5)),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Ulvenik Core',
                  style: TextStyle(color: _offWhite, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Annual Membership',
                  style: TextStyle(color: _stoneGrey, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildPillTag('TRAINER PACK'),
                    _buildPillTag('SPORT PACK'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Renews 18 September 2027 • Apple App Store',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening Apple Subscriptions settings...'), backgroundColor: _forest),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manage Subscription',
                          style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.open_in_new, color: _mint, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SECTION 2: INCLUDED WITH CORE
          const Text(
            'INCLUDED WITH CORE',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildChecklistRow('Unlimited Dogs', 'Strength & Conditioning'),
                const SizedBox(height: 12),
                _buildChecklistRow('Unlimited Skills', 'Calendar'),
                const SizedBox(height: 12),
                _buildChecklistRow('Unlimited Sessions', 'Statistics'),
                const SizedBox(height: 12),
                _buildChecklistRow('Health Records', 'Media & Documents'),
                const SizedBox(height: 12),
                _buildChecklistRow('Goals', 'Offline Access'),
                const SizedBox(height: 12),
                _buildChecklistRow('Timeline', 'Cloud Sync'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SECTION 3: YOUR PACKS
          const Text(
            'YOUR PACKS',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          // Trainer Pack Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF242A2E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.business_center_outlined, color: _stoneGrey, size: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _forest.withValues(alpha: 0.5)),
                      ),
                      child: const Text('ACTIVE', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Trainer Pack', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Client management for professional trainers.', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                _buildChecklistRow('Client Management', 'Shared Dogs'),
                const SizedBox(height: 10),
                _buildChecklistRow('Homework Assignments', 'Trainer Dashboard'),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Monthly • Renews 28 Jul 2025', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Trainer Pack settings...'), backgroundColor: _forest),
                        );
                      },
                      child: const Text('Manage >', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sport Pack Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF242A2E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events_outlined, color: _stoneGrey, size: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _forest.withValues(alpha: 0.5)),
                      ),
                      child: const Text('ACTIVE', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Sport Pack', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Competitions and achievements for sport handlers.', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                _buildChecklistRow('Custom Sports', 'Sport Statistics'),
                const SizedBox(height: 10),
                _buildChecklistRow('Competition Records', 'Achievement Tracking'),
                const SizedBox(height: 16),
                const Divider(color: _cardBorder),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Annual • Renews 18 Sep 2027', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Sport Pack settings...'), backgroundColor: _forest),
                        );
                      },
                      child: const Text('Manage >', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SECTION 4: ADD TO YOUR MEMBERSHIP
          const Text(
            'ADD TO YOUR MEMBERSHIP',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF242A2E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.groups_outlined, color: _stoneGrey, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text('Club Pack', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Multi-handler organization and club events.', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                const SizedBox(height: 14),
                _buildSingleCheck('Event Coordination'),
                const SizedBox(height: 8),
                _buildSingleCheck('Club Leaderboards'),
                const SizedBox(height: 8),
                _buildSingleCheck('Roster Management'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: '£4.99 ', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                              TextSpan(text: '/ month', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('or £39.99 / year', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _clubPackAdded ? const Color(0xFF242A2E) : _forest,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() => _clubPackAdded = !_clubPackAdded);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_clubPackAdded ? 'Club Pack added to subscription!' : 'Club Pack removed.'),
                            backgroundColor: _forest,
                          ),
                        );
                      },
                      child: Text(
                        _clubPackAdded ? 'Added ✓' : 'Add Pack',
                        style: TextStyle(color: _clubPackAdded ? _mint : _offWhite, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SECTION 5: MANAGE
          const Text(
            'MANAGE',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildManageTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Billing History',
                  subtitle: 'View past payments and receipts',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingHistoryScreen()));
                  },
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildManageTile(
                  icon: Icons.sync,
                  title: 'Restore Purchases',
                  subtitle: 'Recover a missing subscription',
                  onTap: _restorePurchases,
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildManageTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Redeem Code',
                  subtitle: 'Enter a promotional code',
                  onTap: _showRedeemCodeSheet,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPillTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF14241F),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _forest.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.6),
      ),
    );
  }

  Widget _buildChecklistRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.check, color: _mint, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(left, style: const TextStyle(color: _offWhite, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.check, color: _mint, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(right, style: const TextStyle(color: _offWhite, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleCheck(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: _mint, size: 14),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: _offWhite, fontSize: 13)),
      ],
    );
  }

  Widget _buildManageTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
