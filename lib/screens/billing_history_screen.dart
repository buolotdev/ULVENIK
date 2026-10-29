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
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _allTransactions = [
    {
      'title': 'Core Annual Renewal',
      'date': '28 Jun 2025 • Apple App Store',
      'amount': '£9.99',
      'badge': 'RENEWED',
      'badgeColor': const Color(0xFF2E6B57),
      'icon': Icons.sync,
    },
    {
      'title': 'Trainer Pack Monthly',
      'date': '01 Jun 2025 • Apple App Store',
      'amount': '£4.99',
      'badge': 'PAID',
      'badgeColor': const Color(0xFF2E6B57),
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Refund — Sport Pack',
      'date': '15 May 2025 • Apple App Store',
      'amount': '-£3.99',
      'badge': 'REFUNDED',
      'badgeColor': const Color(0xFF334B5C),
      'icon': Icons.undo,
    },
    {
      'title': 'Promotional Trial',
      'date': '01 May 2025 • Apple App Store',
      'amount': '£0.00',
      'badge': 'TRIAL',
      'badgeColor': const Color(0xFF2D353A),
      'icon': Icons.access_time,
    },
  ];

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Transactions',
                style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: ['All', 'Renewals', 'Packs', 'Refunds', 'Trials'].map((filter) {
                  final isSel = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSel,
                    selectedColor: _forest,
                    backgroundColor: const Color(0xFF14181B),
                    labelStyle: TextStyle(color: isSel ? _offWhite : _stoneGrey),
                    onSelected: (val) {
                      setState(() => _selectedFilter = filter);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['title'] as String, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item['badgeColor'] as Color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['badge'] as String,
                      style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(item['date'] as String, style: const TextStyle(color: _stoneGrey, fontSize: 13)),
              const SizedBox(height: 16),
              const Divider(color: _cardBorder),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount Billed', style: TextStyle(color: _stoneGrey, fontSize: 14)),
                  Text(item['amount'] as String, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading App Store invoice PDF...'), backgroundColor: _forest),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.download, color: _offWhite),
                  label: const Text('Download Receipt', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
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
          'Billing History',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ACCOUNT SUMMARY
          const Text(
            'ACCOUNT SUMMARY',
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
                _buildSummaryRow('CURRENT PLAN', 'Core + Trainer Pack'),
                const Divider(color: _cardBorder, height: 1),
                _buildSummaryRow('BILLING PLATFORM', 'Apple App Store'),
                const Divider(color: _cardBorder, height: 1),
                _buildSummaryRow('LAST PAYMENT', '28 Jun 2025 • £9.99'),
                const Divider(color: _cardBorder, height: 1),
                _buildSummaryRow('NEXT RENEWAL', '28 Jul 2025'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // TRANSACTIONS
          const Text(
            'TRANSACTIONS',
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
                for (int i = 0; i < _allTransactions.length; i++) ...[
                  _buildTransactionTile(_allTransactions[i]),
                  if (i < _allTransactions.length - 1)
                    const Divider(color: _cardBorder, height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => _showTransactionDetails(item),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF242A2E),
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'] as IconData, color: _stoneGrey, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['date'] as String,
                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['amount'] as String,
                  style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (item['badgeColor'] as Color).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: item['badgeColor'] as Color, width: 0.8),
                  ),
                  child: Text(
                    item['badge'] as String,
                    style: TextStyle(
                      color: item['badge'] == 'REFUNDED' ? const Color(0xFF8BB5D6) : _mint,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: _cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_outlined, 'Home', false, () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomepageScreen()));
          }),
          _navItem(Icons.pets_outlined, 'Dogs', false, () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyDogsScreen()));
          }),
          _navItem(Icons.fitness_center_outlined, 'Training', false, () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TrainingScreen()));
          }),
          _navItem(Icons.history_toggle_off_outlined, 'Timeline', false, () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TimelineScreen()));
          }),
          _navItem(Icons.menu, 'More', true, () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MorePageScreen()));
          }),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? _mint : _stoneGrey, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? _mint : _stoneGrey,
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
