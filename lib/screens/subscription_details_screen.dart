import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
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
  bool _isRestoring = false;

  void _restorePurchases() async {
    setState(() => _isRestoring = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isRestoring = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Purchases Restored', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Your active Ulvenik Pro Handler subscription receipt was validated successfully with the App Store / Google Play.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Subscription?', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Your Pro Handler benefits will remain active until Dec 18, 2027. After that, your cloud storage will revert to the 1.0 GB free tier.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Subscription', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription cancellation requested.'),
                  backgroundColor: _forest,
                ),
              );
            },
            child: const Text('Confirm', style: TextStyle(color: _offWhite)),
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription Details',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. ACTIVE PLAN HERO CARD
          _buildHeroPlanCard(),
          const SizedBox(height: 20),

          // 2. INCLUDED FEATURES CHECKLIST
          _buildSectionHeader('INCLUDED PRO FEATURES'),
          const SizedBox(height: 8),
          _buildFeaturesList(),
          const SizedBox(height: 20),

          // 3. BILLING & RESTORE ACTIONS
          _buildSectionHeader('BILLING MANAGEMENT'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _mint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long, color: _mint, size: 20),
                  ),
                  title: const Text('Billing History & Receipts', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('View and download monthly PDF tax invoices', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BillingHistoryScreen()),
                    );
                  },
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 60),
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _isRestoring
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: _mint),
                          )
                        : const Icon(Icons.restore, color: _mint, size: 20),
                  ),
                  title: const Text('Restore Purchases', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Synchronize App Store / Google Play subscription receipt', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                  onTap: _isRestoring ? null : _restorePurchases,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. CANCEL PLAN
          Center(
            child: TextButton(
              onPressed: _showCancelDialog,
              child: const Text('Cancel Subscription', style: TextStyle(color: Color(0xFFE53E3E), fontSize: 13, fontWeight: FontWeight.w600)),
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

  Widget _buildHeroPlanCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _mint.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _forest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('PRO HANDLER', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF131718),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: _mint, size: 12),
                    SizedBox(width: 4),
                    Text('Auto-Renewing', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '\$9.99 / month',
            style: TextStyle(
              color: _offWhite,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          const Text('Next billing cycle on Dec 18, 2027', style: TextStyle(color: _stoneGrey, fontSize: 12)),
          const SizedBox(height: 14),
          const Divider(color: Color(0x0FFFFFFF), height: 1),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cloud Quota (10 GB Tier)', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              Text('1.24 GB Used (12%)', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: 0.124,
              backgroundColor: Color(0xFF131718),
              valueColor: AlwaysStoppedAnimation(_mint),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Unlimited Dual-Band Sub-Meter GPS Traces & Contours',
      'Continuous Canine HRV & Biometric Fatigue Indexing',
      'Side-by-Side Timeline Compare & Multi-Dog Deltas',
      'Dynamic Island & Lock Screen Live Activities',
      '4K Video Recordings & Raw Telemetry Cloud Storage',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: features.map((f) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: _mint, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f,
                    style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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
