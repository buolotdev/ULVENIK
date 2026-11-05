import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _BillingStatus { renewed, paid, refunded, trial }

class _BillingTransaction {
  final String id;
  final String invoiceCode;
  final String title;
  final String dateLabel;
  final int year;
  final String platform;
  final String amountLabel;
  final double netAmount;
  final _BillingStatus status;
  final IconData icon;
  final String paymentMethod;
  final String orderReference;

  const _BillingTransaction({
    required this.id,
    required this.invoiceCode,
    required this.title,
    required this.dateLabel,
    required this.year,
    required this.platform,
    required this.amountLabel,
    required this.netAmount,
    required this.status,
    required this.icon,
    required this.paymentMethod,
    required this.orderReference,
  });
}

class BillingHistoryScreen extends StatefulWidget {
  final String? subscriptionPlan;
  final bool hasSportPack;
  final bool hasTrainerPack;

  const BillingHistoryScreen({
    super.key,
    this.subscriptionPlan,
    this.hasSportPack = false,
    this.hasTrainerPack = true,
  });

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sage = AppColors.secondarySage;
  static const Color _alpineBlue = AppColors.infoAlpineBlue;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;

  String get _userSubscriptionLabel {
    final override = widget.subscriptionPlan?.trim();
    if (override != null && override.isNotEmpty) return override;
    if (widget.hasSportPack && widget.hasTrainerPack) return 'Complete';
    if (widget.hasTrainerPack) return 'Core + Trainer';
    if (widget.hasSportPack) return 'Core + Sport';
    return 'Core';
  }

  bool _showFilters = false;
  String _selectedYear = '2025';
  String _selectedStatus = 'All';
  final Set<String> _downloadedIds = <String>{};

  static const List<_BillingTransaction> _allTransactions = [
    _BillingTransaction(
      id: 'tx_2025_06_28',
      invoiceCode: 'INV-2025-0628-ULV',
      title: 'Core Annual Renewal',
      dateLabel: '28 Jun 2025',
      year: 2025,
      platform: 'Apple App Store',
      amountLabel: '£9.99',
      netAmount: 9.99,
      status: _BillingStatus.renewed,
      icon: Icons.sync_rounded,
      paymentMethod: 'Apple Pay ·••• 4821',
      orderReference: 'MK9X482910',
    ),
    _BillingTransaction(
      id: 'tx_2025_06_01',
      invoiceCode: 'INV-2025-0601-ULV',
      title: 'Trainer Pack Monthly',
      dateLabel: '01 Jun 2025',
      year: 2025,
      platform: 'Apple App Store',
      amountLabel: '£4.99',
      netAmount: 4.99,
      status: _BillingStatus.paid,
      icon: Icons.inventory_2_outlined,
      paymentMethod: 'Apple Pay ·••• 4821',
      orderReference: 'MK9X440182',
    ),
    _BillingTransaction(
      id: 'tx_2025_05_15',
      invoiceCode: 'CRN-2025-0515-ULV',
      title: 'Refund — Sport Pack',
      dateLabel: '15 May 2025',
      year: 2025,
      platform: 'Apple App Store',
      amountLabel: '–£3.99',
      netAmount: -3.99,
      status: _BillingStatus.refunded,
      icon: Icons.undo_rounded,
      paymentMethod: 'Apple Pay ·••• 4821',
      orderReference: 'MK9X398104',
    ),
    _BillingTransaction(
      id: 'tx_2025_05_01',
      invoiceCode: 'TRL-2025-0501-ULV',
      title: 'Promotional Trial',
      dateLabel: '01 May 2025',
      year: 2025,
      platform: 'Apple App Store',
      amountLabel: '£0.00',
      netAmount: 0.0,
      status: _BillingStatus.trial,
      icon: Icons.access_time_rounded,
      paymentMethod: 'Apple ID Entitlement',
      orderReference: 'MK9X371009',
    ),
    _BillingTransaction(
      id: 'tx_2024_11_28',
      invoiceCode: 'INV-2024-1128-ULV',
      title: 'Core Annual Plan',
      dateLabel: '28 Nov 2024',
      year: 2024,
      platform: 'Apple App Store',
      amountLabel: '£9.99',
      netAmount: 9.99,
      status: _BillingStatus.paid,
      icon: Icons.inventory_2_outlined,
      paymentMethod: 'Apple Pay ·••• 4821',
      orderReference: 'MK8P912044',
    ),
    _BillingTransaction(
      id: 'tx_2024_07_14',
      invoiceCode: 'INV-2024-0714-ULV',
      title: 'Trainer Pack Add-on',
      dateLabel: '14 Jul 2024',
      year: 2024,
      platform: 'Apple App Store',
      amountLabel: '£4.99',
      netAmount: 4.99,
      status: _BillingStatus.paid,
      icon: Icons.inventory_2_outlined,
      paymentMethod: 'Apple Pay ·••• 4821',
      orderReference: 'MK8L220891',
    ),
  ];

  bool get _hasNonDefaultFilter =>
      _selectedYear != '2025' || _selectedStatus != 'All';

  List<_BillingTransaction> get _filteredTransactions {
    return _allTransactions.where((tx) {
      final matchesYear = _selectedYear == 'All Years' ||
          tx.year.toString() == _selectedYear;
      if (!matchesYear) return false;

      if (_selectedStatus == 'All') return true;
      return _statusLabel(tx.status).toLowerCase() ==
          _selectedStatus.toLowerCase();
    }).toList();
  }

  String _statusLabel(_BillingStatus status) {
    switch (status) {
      case _BillingStatus.renewed:
        return 'RENEWED';
      case _BillingStatus.paid:
        return 'PAID';
      case _BillingStatus.refunded:
        return 'REFUNDED';
      case _BillingStatus.trial:
        return 'TRIAL';
    }
  }

  Color _statusColor(_BillingStatus status) {
    switch (status) {
      case _BillingStatus.renewed:
      case _BillingStatus.paid:
        return _forest;
      case _BillingStatus.refunded:
        return _alpineBlue;
      case _BillingStatus.trial:
        return _stoneGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _filteredTransactions;

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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterDrawer(),
                    _buildSectionHeader('ACCOUNT SUMMARY'),
                    const SizedBox(height: 10),
                    _buildAccountSummaryCard(),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('TRANSACTIONS'),
                        if (_hasNonDefaultFilter)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedYear = '2025';
                                _selectedStatus = 'All';
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              '${transactions.length} SHOWN · RESET',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _alpineBlue,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (transactions.isEmpty)
                      _buildEmptyFilterState()
                    else
                      _buildTransactionsCard(transactions),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 16),
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
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Billing History',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showFilters = !_showFilters),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _showFilters
                        ? _forest.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tune_rounded,
                    color: _showFilters ? _offWhite : _stoneGrey,
                    size: 20,
                  ),
                ),
                if (_hasNonDefaultFilter)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _forest,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDrawer() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !_showFilters
          ? const SizedBox(width: double.infinity, height: 0)
          : Container(
              margin: const EdgeInsets.only(bottom: 22),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'FILTER TRANSACTIONS',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _stoneGrey,
                          letterSpacing: 1.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedYear = '2025';
                            _selectedStatus = 'All';
                          });
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Billing Year',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _stoneGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final yr in const ['2025', '2024', 'All Years'])
                        _buildFilterChip(
                          label: yr,
                          selected: _selectedYear == yr,
                          onTap: () => setState(() => _selectedYear = yr),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Payment Status',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _stoneGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final st in const [
                        'All',
                        'Renewed',
                        'Paid',
                        'Refunded',
                        'Trial',
                      ])
                        _buildFilterChip(
                          label: st,
                          selected: _selectedStatus == st,
                          onTap: () => setState(() => _selectedStatus = st),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? _forest.withValues(alpha: 0.22)
              : _obsidian.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _forest : _cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? _offWhite : _stoneGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _stoneGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAccountSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            label: 'CURRENT PLAN',
            value: _userSubscriptionLabel,
            onTap: _openAnnualSpendSheet,
          ),
          _buildDivider(),
          _buildSummaryRow(
            label: 'BILLING PLATFORM',
            value: 'Apple App Store',
            onTap: _openAnnualSpendSheet,
          ),
          _buildDivider(),
          _buildSummaryRow(
            label: 'LAST PAYMENT',
            value: '28 Jun 2025 · £9.99',
            onTap: _openAnnualSpendSheet,
          ),
          _buildDivider(),
          _buildSummaryRow(
            label: 'NEXT RENEWAL',
            value: '28 Jul 2025',
            onTap: _openAnnualSpendSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _stoneGrey,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _offWhite,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsCard(List<_BillingTransaction> transactions) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < transactions.length; i++) ...[
            if (i > 0) _buildDivider(),
            _buildTransactionRow(transactions[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionRow(_BillingTransaction tx) {
    final badgeColor = _statusColor(tx.status);
    final isDownloaded = _downloadedIds.contains(tx.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openInvoiceReceiptSheet(tx),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                  border: Border.all(color: _cardBorder, width: 1),
                ),
                alignment: Alignment.center,
                child: UlvenikIcon.fromMaterial(
                  tx.icon,
                  color: _sage,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            tx.title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: _offWhite,
                              height: 1.25,
                            ),
                          ),
                        ),
                        if (isDownloaded) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.download_done_rounded,
                            color: _forest,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${tx.dateLabel} · ${tx.platform}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _stoneGrey,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tx.amountLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.36),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _statusLabel(tx.status),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey.withValues(alpha: 0.55),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        children: [
          const UlvenikIcon(UlvenikIcons.training,
            color: _stoneGrey,
            size: 32,
          ),
          const SizedBox(height: 12),
          const Text(
            'No matching transactions',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _offWhite,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No $_selectedStatus invoices found for $_selectedYear.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedYear = '2025';
                _selectedStatus = 'All';
              });
            },
            child: const Text(
              'Reset Filters',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _forest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: _cardBorder,
    );
  }

  void _openInvoiceReceiptSheet(_BillingTransaction tx) {
    final badgeColor = _statusColor(tx.status);
    final absVal = tx.netAmount.abs();
    final vat = absVal * (0.20 / 1.20);
    final subtotal = absVal - vat;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        bool isGeneratingPdf = false;
        bool downloadedInSheet = _downloadedIds.contains(tx.id);

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
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
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _obsidian,
                            shape: BoxShape.circle,
                            border: Border.all(color: _cardBorder),
                          ),
                          child: UlvenikIcon.fromMaterial(tx.icon, color: _sage, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: _offWhite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Receipt · ${tx.invoiceCode}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.5,
                                  color: _stoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: badgeColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            _statusLabel(tx.status),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Column(
                        children: [
                          _buildReceiptLine('Transaction Date', tx.dateLabel),
                          const SizedBox(height: 10),
                          _buildReceiptLine('Billing Platform', tx.platform),
                          const SizedBox(height: 10),
                          _buildReceiptLine(
                            'Payment Method',
                            tx.paymentMethod,
                          ),
                          const SizedBox(height: 10),
                          _buildReceiptLine(
                            'Store Order ID',
                            tx.orderReference,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: _buildDivider(),
                          ),
                          _buildReceiptLine(
                            'Net Subtotal',
                            '£${subtotal.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _buildReceiptLine(
                            'UK VAT (20%)',
                            '£${vat.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _offWhite,
                                ),
                              ),
                              Text(
                                tx.amountLabel,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _offWhite,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isGeneratingPdf
                            ? null
                            : () async {
                                setSheetState(() => isGeneratingPdf = true);
                                await Future<void>.delayed(
                                  const Duration(milliseconds: 650),
                                );
                                if (!mounted) return;
                                setState(() => _downloadedIds.add(tx.id));
                                setSheetState(() {
                                  isGeneratingPdf = false;
                                  downloadedInSheet = true;
                                });
                                if (!sheetCtx.mounted) return;
                                Navigator.of(sheetCtx).pop();
                                AppSnackbar.show(
                                  context,
                                  title: 'PDF Receipt Downloaded',
                                  message:
                                      'Saved ${tx.invoiceCode}.pdf (${tx.amountLabel}) to device files.',
                                  type: SnackbarType.success,
                                );
                              },
                        icon: isGeneratingPdf
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _offWhite,
                                ),
                              )
                            : UlvenikIcon.fromMaterial(
                                downloadedInSheet
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.picture_as_pdf_outlined,
                                size: 18,
                              ),
                        label: Text(
                          isGeneratingPdf
                              ? 'Preparing PDF Receipt...'
                              : downloadedInSheet
                                  ? 'Download PDF Receipt Again'
                                  : 'Download PDF Receipt',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _offWhite,
                              side: const BorderSide(color: _cardBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: tx.invoiceCode),
                              );
                              Navigator.of(sheetCtx).pop();
                              AppSnackbar.show(
                                context,
                                title: 'Invoice ID Copied',
                                message:
                                    'Copied ${tx.invoiceCode} to clipboard.',
                                type: SnackbarType.info,
                              );
                            },
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text(
                              'Copy ID',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _offWhite,
                              side: const BorderSide(color: _cardBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(sheetCtx).pop();
                              AppSnackbar.show(
                                context,
                                title: 'Receipt Emailed',
                                message:
                                    'Sent a copy of ${tx.invoiceCode} to ruby@email.com.',
                                type: SnackbarType.success,
                              );
                            },
                            icon: const Icon(Icons.mail_outline_rounded, size: 16),
                            label: const Text(
                              'Email Copy',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
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
      },
    );
  }

  Widget _buildReceiptLine(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: _stoneGrey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _offWhite,
          ),
        ),
      ],
    );
  }

  void _openAnnualSpendSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return _AnnualSpendSheetContent(
          onExportStatement: () {
            Navigator.of(sheetCtx).pop();
            AppSnackbar.show(
              context,
              title: 'Billing Statement Exported',
              message:
                  'Exported 2024–2025 Apple App Store billing statement (CSV).',
              type: SnackbarType.success,
            );
          },
        );
      },
    );
  }
}

class _AnnualSpendSheetContent extends StatefulWidget {
  final VoidCallback onExportStatement;

  const _AnnualSpendSheetContent({required this.onExportStatement});

  @override
  State<_AnnualSpendSheetContent> createState() =>
      _AnnualSpendSheetContentState();
}

class _AnnualSpendSheetContentState extends State<_AnnualSpendSheetContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  int _selectedBarIndex = 3;

  static const List<(String, double, String)> _months = [
    ('Mar', 0.0, '£0.00 · No charges'),
    ('Apr', 0.0, '£0.00 · No charges'),
    ('May', 0.0, '£0.00 net · Trial + £3.99 refunded'),
    ('Jun', 14.98, '£14.98 · Core + Trainer'),
    ('Jul', 4.99, '£4.99 scheduled · Next renewal 28 Jul'),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeMonth = _months[_selectedBarIndex];

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
            const SizedBox(height: 18),
            const Text(
              'Account Billing Overview',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${activeMonth.$1} 2025: ${activeMonth.$3}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: AnimatedBuilder(
                animation: _animCtrl,
                builder: (context, _) {
                  final t = Curves.easeOutCubic.transform(_animCtrl.value);
                  return SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (int i = 0; i < _months.length; i++)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedBarIndex = i),
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '£${_months[i].$2.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10.5,
                                      fontWeight: _selectedBarIndex == i
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: _selectedBarIndex == i
                                          ? AppColors.primaryTextOffWhite
                                          : AppColors.secondaryTextStoneGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 28,
                                    height: (12 + (_months[i].$2 / 15.0) * 68) * t,
                                    decoration: BoxDecoration(
                                      color: _selectedBarIndex == i
                                          ? AppColors.primaryForestGreen
                                          : AppColors.secondarySage
                                              .withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _months[i].$1,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11.5,
                                      fontWeight: _selectedBarIndex == i
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: _selectedBarIndex == i
                                          ? AppColors.primaryTextOffWhite
                                          : AppColors.secondaryTextStoneGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: widget.onExportStatement,
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text(
                  'Export Annual Statement (CSV)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
