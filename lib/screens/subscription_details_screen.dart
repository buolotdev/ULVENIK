import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'billing_history_screen.dart';
import 'restore_purchases_screen.dart';

class _AddonPackState {
  final String id;
  final String badgeLabel;
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;
  final bool twoColumnFeatures;
  final String monthlyPriceLabel;
  final String annualPriceLabel;
  bool isActive;
  bool isAnnual;
  String renewalDate;

  _AddonPackState({
    required this.id,
    required this.badgeLabel,
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
    required this.twoColumnFeatures,
    required this.monthlyPriceLabel,
    required this.annualPriceLabel,
    required this.isActive,
    required this.isAnnual,
    required this.renewalDate,
  });
}

class SubscriptionDetailsScreen extends StatefulWidget {
  final String? subscriptionPlan;
  final bool hasTrainerPack;
  final bool hasSportPack;

  const SubscriptionDetailsScreen({
    super.key,
    this.subscriptionPlan,
    this.hasTrainerPack = true,
    this.hasSportPack = true,
  });

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sage = AppColors.secondarySage;
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _destructive = AppColors.errorDestructive;

  bool _coreActive = true;
  bool _coreAnnual = true;
  String _coreRenewalDate = '18 September 2027';
  String? _redeemedPromoBanner;

  late final List<_AddonPackState> _packs = [
    _AddonPackState(
      id: 'trainer',
      badgeLabel: 'TRAINER PACK',
      title: 'Trainer Pack',
      description: 'Client management for professional trainers.',
      icon: Icons.work_outline_rounded,
      features: const [
        'Client Management',
        'Shared Dogs',
        'Homework Assignments',
        'Trainer Dashboard',
      ],
      twoColumnFeatures: true,
      monthlyPriceLabel: '£4.99',
      annualPriceLabel: '£39.99',
      isActive: widget.hasTrainerPack,
      isAnnual: false,
      renewalDate: '28 Jul 2025',
    ),
    _AddonPackState(
      id: 'sport',
      badgeLabel: 'SPORT PACK',
      title: 'Sport Pack',
      description: 'Competitions and achievements for sport handlers.',
      icon: Icons.emoji_events_outlined,
      features: const [
        'Custom Sports',
        'Sport Statistics',
        'Competition Records',
        'Achievement Tracking',
      ],
      twoColumnFeatures: true,
      monthlyPriceLabel: '£3.99',
      annualPriceLabel: '£29.99',
      isActive: widget.hasSportPack,
      isAnnual: true,
      renewalDate: '18 Sep 2027',
    ),
  ];

  String get _currentMembershipTitle {
    final override = widget.subscriptionPlan?.trim();
    if (override != null && override.isNotEmpty) return override;
    final hasTrainer =
        _packs.any((p) => p.id == 'trainer' && p.isActive);
    final hasSport =
        _packs.any((p) => p.id == 'sport' && p.isActive);
    if (hasTrainer && hasSport) return 'Complete';
    if (hasTrainer) return 'Core + Trainer';
    if (hasSport) return 'Core + Sport';
    return 'Core';
  }

  static const List<(String, String)> _coreFeaturePairs = [
    ('Unlimited Dogs', 'Strength & Conditioning'),
    ('Unlimited Skills', 'Calendar'),
    ('Unlimited Sessions', 'Statistics'),
    ('Health Records', 'Media & Documents'),
    ('Goals', 'Offline Access'),
    ('Timeline', 'Cloud Sync'),
  ];

  List<_AddonPackState> get _activePacks =>
      _packs.where((p) => p.isActive).toList();

  List<_AddonPackState> get _availablePacks =>
      _packs.where((p) => !p.isActive).toList();

  @override
  Widget build(BuildContext context) {
    final activePacks = _activePacks;
    final availablePacks = _availablePacks;

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
                    _buildCoreHeroCard(activePacks),
                    if (_redeemedPromoBanner != null) ...[
                      const SizedBox(height: 12),
                      _buildPromoBanner(_redeemedPromoBanner!),
                    ],
                    const SizedBox(height: 26),
                    _buildSectionHeader('INCLUDED WITH CORE'),
                    const SizedBox(height: 10),
                    _buildIncludedWithCoreCard(),
                    if (activePacks.isNotEmpty) ...[
                      const SizedBox(height: 26),
                      _buildSectionHeader('YOUR PACKS'),
                      const SizedBox(height: 10),
                      for (int i = 0; i < activePacks.length; i++) ...[
                        if (i > 0) const SizedBox(height: 14),
                        _buildActivePackCard(activePacks[i]),
                      ],
                    ],
                    if (availablePacks.isNotEmpty) ...[
                      const SizedBox(height: 26),
                      _buildSectionHeader('ADD TO YOUR MEMBERSHIP'),
                      const SizedBox(height: 10),
                      for (int i = 0; i < availablePacks.length; i++) ...[
                        if (i > 0) const SizedBox(height: 14),
                        _buildAvailablePackCard(availablePacks[i]),
                      ],
                    ],
                    const SizedBox(height: 26),
                    _buildSectionHeader('MANAGE'),
                    const SizedBox(height: 10),
                    _buildManageCard(),
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
              'Subscription',
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
            onTap: _openSubscriptionHelpSheet,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.help_outline_rounded,
                color: _stoneGrey,
                size: 21,
              ),
            ),
          ),
        ],
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

  Widget _buildCoreHeroCard(List<_AddonPackState> activePacks) {
    final statusColor = _coreActive ? _forest : _destructive;
    final statusLabel = _coreActive ? 'ACTIVE' : 'EXPIRING';

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 34,
                height: 22,
                child: CustomPaint(painter: _MountainCrestPainter()),
              ),
              _buildStatusPill(label: statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _currentMembershipTitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _offWhite,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _coreAnnual ? 'Annual Membership' : 'Monthly Membership',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _stoneGrey,
            ),
          ),
          if (activePacks.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final pack in activePacks)
                  GestureDetector(
                    onTap: () => _openManagePackSheet(pack),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5.5,
                      ),
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _forest.withValues(alpha: 0.36),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        pack.badgeLabel,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _forest,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(
            _coreActive
                ? 'Renews $_coreRenewalDate · Apple App Store'
                : 'Access ends $_coreRenewalDate · Auto-renew paused',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _openManageCoreSubscriptionSheet,
            behavior: HitTestBehavior.opaque,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Subscription',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _forest,
                  ),
                ),
                Icon(Icons.open_in_new_rounded,
                  color: _forest,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: _forest.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _forest.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_rounded, color: _forest, size: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: _offWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedWithCoreCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          for (int i = 0; i < _coreFeaturePairs.length; i++) ...[
            if (i > 0) const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCheckItem(
                    _coreFeaturePairs[i].$1,
                    checkColor: _forest,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFeatureCheckItem(
                    _coreFeaturePairs[i].$2,
                    checkColor: _forest,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivePackCard(_AddonPackState pack) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: UlvenikIcon.fromMaterial(pack.icon, color: _stoneGrey, size: 18),
              ),
              _buildStatusPill(label: 'ACTIVE', color: _forest),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            pack.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.5,
              fontWeight: FontWeight.w700,
              color: _offWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pack.description,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              color: _stoneGrey,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          _buildPackFeatureGrid(pack.features, checkColor: _forest),
          const SizedBox(height: 16),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${pack.isAnnual ? 'Annual' : 'Monthly'} · Renews ${pack.renewalDate}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: _stoneGrey,
                ),
              ),
              GestureDetector(
                onTap: () => _openManagePackSheet(pack),
                behavior: HitTestBehavior.opaque,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Manage',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: _sageMint,
                      ),
                    ),
                    SizedBox(width: 2),
                    UlvenikIcon(UlvenikIcons.details,
                      color: _stoneGrey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePackCard(_AddonPackState pack) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                  border: Border.all(color: _cardBorder, width: 1),
                ),
                alignment: Alignment.center,
                child: UlvenikIcon.fromMaterial(pack.icon, color: _stoneGrey, size: 19),
              ),
              const SizedBox(width: 14),
              Text(
                pack.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pack.description,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              color: _stoneGrey,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          if (pack.twoColumnFeatures)
            _buildPackFeatureGrid(pack.features, checkColor: _sage)
          else
            Column(
              children: [
                for (int i = 0; i < pack.features.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _buildFeatureCheckItem(pack.features[i], checkColor: _sage),
                ],
              ],
            ),
          const SizedBox(height: 16),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontFamily: 'Inter'),
                      children: [
                        TextSpan(
                          text: pack.monthlyPriceLabel,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        const TextSpan(
                          text: ' / month',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'or ${pack.annualPriceLabel} / year',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      color: _stoneGrey,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => _openAddPackSheet(pack),
                child: const Text(
                  'Add Pack',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackFeatureGrid(
    List<String> features, {
    required Color checkColor,
  }) {
    final rows = <Widget>[];
    for (int i = 0; i < features.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 12));
      final left = features[i];
      final right = i + 1 < features.length ? features[i + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildFeatureCheckItem(left, checkColor: checkColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: right != null
                  ? _buildFeatureCheckItem(right, checkColor: checkColor)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildFeatureCheckItem(String text, {required Color checkColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(Icons.check_rounded,
            color: checkColor,
            size: 15,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: _stoneGrey,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.38),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildManageCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildManageRow(
            icon: Icons.receipt_long_outlined,
            title: 'Billing History',
            subtitle: 'View past payments and receipts',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BillingHistoryScreen(),
                ),
              );
            },
          ),
          Container(height: 1, color: _cardBorder),
          _buildManageRow(
            icon: Icons.sync_rounded,
            title: 'Restore Purchases',
            subtitle: 'Recover a missing subscription',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RestorePurchasesScreen(),
                ),
              );
            },
          ),
          Container(height: 1, color: _cardBorder),
          _buildManageRow(
            icon: Icons.local_offer_outlined,
            title: 'Redeem Code',
            subtitle: 'Enter a promotional code',
            onTap: _openRedeemCodeSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildManageRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey.withValues(alpha: 0.65),
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openManageCoreSubscriptionSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        bool draftAnnual = _coreAnnual;
        bool confirmCancel = false;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSheetHandle(),
                    const SizedBox(height: 16),
                    Text(
                      'Manage $_currentMembershipTitle',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Switch billing cycle, compare savings, or manage Apple App Store auto-renewal.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'BILLING CYCLE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _stoneGrey,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCycleOptionCard(
                            title: 'Annual',
                            price: '£59.99 / yr',
                            badge: 'SAVE 37%',
                            selected: draftAnnual,
                            onTap: () => setSheetState(() => draftAnnual = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildCycleOptionCard(
                            title: 'Monthly',
                            price: '£7.99 / mo',
                            badge: 'FLEXIBLE',
                            selected: !draftAnnual,
                            onTap: () =>
                                setSheetState(() => draftAnnual = false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _coreAnnual = draftAnnual;
                            _coreActive = true;
                            _coreRenewalDate = draftAnnual
                                ? '18 September 2027'
                                : '28 July 2025';
                          });
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Subscription Updated',
                            message: draftAnnual
                                ? 'Ulvenik Core set to Annual Membership.'
                                : 'Ulvenik Core switched to Monthly Membership.',
                            type: SnackbarType.success,
                          );
                        },
                        child: Text(
                          _coreActive
                              ? 'Update Billing Cycle'
                              : 'Reactivate Ulvenik Core',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_coreActive && !confirmCancel)
                      Center(
                        child: TextButton(
                          onPressed: () =>
                              setSheetState(() => confirmCancel = true),
                          child: const Text(
                            'Pause Auto-Renewal / Cancel Membership',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB55454),
                            ),
                          ),
                        ),
                      ),
                    if (_coreActive && confirmCancel) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _destructive.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _destructive.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Confirm Cancellation?',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _offWhite,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You will keep full Ulvenik Core access until $_coreRenewalDate.',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                color: _stoneGrey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _destructive,
                                  foregroundColor: _offWhite,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() => _coreActive = false);
                                  Navigator.of(sheetCtx).pop();
                                  AppSnackbar.show(
                                    context,
                                    title: 'Auto-Renewal Paused',
                                    message:
                                        'Your Ulvenik Core access remains active until $_coreRenewalDate.',
                                    type: SnackbarType.warning,
                                  );
                                },
                                child: const Text(
                                  'Confirm Pause Auto-Renewal',
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
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCycleOptionCard({
    required String title,
    required String price,
    required String badge,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? _forest.withValues(alpha: 0.16) : _obsidian,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _forest : _cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _offWhite,
                  ),
                ),
                UlvenikIcon.fromMaterial(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 16,
                  color: selected ? _forest : _stoneGrey,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _offWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              badge,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: _forest,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openManagePackSheet(_AddonPackState pack) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        bool draftAnnual = pack.isAnnual;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSheetHandle(),
                    const SizedBox(height: 16),
                    Text(
                      'Manage ${pack.title}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pack.description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCycleOptionCard(
                            title: 'Monthly',
                            price: '${pack.monthlyPriceLabel} / mo',
                            badge: 'MONTHLY',
                            selected: !draftAnnual,
                            onTap: () =>
                                setSheetState(() => draftAnnual = false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildCycleOptionCard(
                            title: 'Annual',
                            price: '${pack.annualPriceLabel} / yr',
                            badge: 'SAVE 33%',
                            selected: draftAnnual,
                            onTap: () => setSheetState(() => draftAnnual = true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            pack.isAnnual = draftAnnual;
                            pack.renewalDate =
                                draftAnnual ? '18 Sep 2027' : '28 Jul 2025';
                          });
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: '${pack.title} Updated',
                            message:
                                'Billing cycle set to ${draftAnnual ? 'Annual' : 'Monthly'}.',
                            type: SnackbarType.success,
                          );
                        },
                        child: const Text(
                          'Save Pack Settings',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFB55454),
                          side: BorderSide(
                            color: _destructive.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() => pack.isActive = false);
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: '${pack.title} Removed',
                            message:
                                '${pack.title} moved to available add-on packs.',
                            type: SnackbarType.warning,
                          );
                        },
                        child: Text(
                          'Remove ${pack.title}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  void _openAddPackSheet(_AddonPackState pack) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        bool pickAnnual = false;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSheetHandle(),
                    const SizedBox(height: 16),
                    Text(
                      'Add ${pack.title}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pack.description,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCycleOptionCard(
                            title: 'Monthly',
                            price: '${pack.monthlyPriceLabel} / mo',
                            badge: 'BILLED MONTHLY',
                            selected: !pickAnnual,
                            onTap: () =>
                                setSheetState(() => pickAnnual = false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildCycleOptionCard(
                            title: 'Annual',
                            price: '${pack.annualPriceLabel} / yr',
                            badge: 'SAVE 33%',
                            selected: pickAnnual,
                            onTap: () => setSheetState(() => pickAnnual = true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            pack.isActive = true;
                            pack.isAnnual = pickAnnual;
                            pack.renewalDate =
                                pickAnnual ? '18 Sep 2027' : '28 Jul 2025';
                          });
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: '${pack.title} Activated',
                            message:
                                '${pack.title} is now active on your Ulvenik Core membership.',
                            type: SnackbarType.success,
                          );
                        },
                        child: Text(
                          'Confirm & Add ${pack.title}',
                          style: const TextStyle(
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
          },
        );
      },
    );
  }

  void _openRedeemCodeSheet() {
    final codeCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        String? errorText;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHandle(),
                  const SizedBox(height: 16),
                  const Text(
                    'Redeem Promotional Code',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _offWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Enter an Apple App Store or Ulvenik partner promo code (e.g. ULVENIK30).',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: _stoneGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: codeCtrl,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                      letterSpacing: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ENTER CODE',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        color: _stoneGrey.withValues(alpha: 0.6),
                        letterSpacing: 1.0,
                      ),
                      errorText: errorText,
                      filled: true,
                      fillColor: _obsidian,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _forest),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final raw = codeCtrl.text.trim().toUpperCase();
                        if (raw.length < 4) {
                          setSheetState(() {
                            errorText =
                                'Please enter a valid 4+ character promotional code.';
                          });
                          return;
                        }
                        setState(() {
                          _redeemedPromoBanner =
                              'Promo "$raw" applied · 30 days complimentary pack credit active';
                        });
                        Navigator.of(sheetCtx).pop();
                        AppSnackbar.show(
                          context,
                          title: 'Code Redeemed',
                          message: 'Successfully applied promotional code $raw.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Redeem Code',
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
            );
          },
        );
      },
    );
  }

  void _openSubscriptionHelpSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const _EntitlementQuotaHelpSheet(),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

class _MountainCrestPainter extends CustomPainter {
  const _MountainCrestPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = const Color(0xFF7A8F7A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(2, size.height - 3)
      ..lineTo(size.width * 0.44, 4)
      ..lineTo(size.width * 0.62, size.height * 0.56)
      ..lineTo(size.width * 0.74, size.height * 0.36)
      ..lineTo(size.width - 2, size.height - 3);

    final ridge = Path()
      ..moveTo(size.width * 0.44, 4)
      ..lineTo(size.width * 0.37, size.height * 0.45)
      ..lineTo(size.width * 0.48, size.height * 0.62);

    canvas.drawPath(path, stroke);
    canvas.drawPath(ridge, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EntitlementQuotaHelpSheet extends StatefulWidget {
  const _EntitlementQuotaHelpSheet();

  @override
  State<_EntitlementQuotaHelpSheet> createState() =>
      _EntitlementQuotaHelpSheetState();
}

class _EntitlementQuotaHelpSheetState extends State<_EntitlementQuotaHelpSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  int _selectedQuotaIdx = 0;

  static const List<(String, double, String)> _quotas = [
    ('Cloud Media Vault', 0.24, '2.4 GB of 10 GB used · Included with Core'),
    ('Client Roster Seats', 0.56, '14 of 25 active clients · Trainer Pack'),
    ('Sport Seasons', 1.0, 'Unlimited trials & titles · Sport Pack'),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Membership Entitlements & Quotas',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap any quota bar below to inspect live usage across your active packs.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.secondaryTextStoneGrey,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _animCtrl,
              builder: (context, _) {
                final t = Curves.easeOutCubic.transform(_animCtrl.value);
                return Column(
                  children: [
                    for (int i = 0; i < _quotas.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => setState(() => _selectedQuotaIdx = i),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundObsidian,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _selectedQuotaIdx == i
                                  ? AppColors.primaryForestGreen
                                  : AppColors.cardBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _quotas[i].$1,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextOffWhite,
                                    ),
                                  ),
                                  Text(
                                    '${(_quotas[i].$2 * 100).round()}%',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryForestGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: _quotas[i].$2 * t,
                                  minHeight: 6,
                                  backgroundColor: Colors.white10,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.primaryForestGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _quotas[i].$3,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: AppColors.secondaryTextStoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
