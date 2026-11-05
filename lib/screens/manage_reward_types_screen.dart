import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'rewards_management_screen.dart';

class ManageRewardTypesScreen extends StatefulWidget {
  const ManageRewardTypesScreen({super.key});

  @override
  State<ManageRewardTypesScreen> createState() =>
      _ManageRewardTypesScreenState();
}

class _ManageRewardTypesScreenState extends State<ManageRewardTypesScreen> {
  final RewardsStore _store = RewardsStore.instance;

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _openTypeEditorSheet({RewardTypeConfig? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.68),
      builder: (_) => _RewardTypeEditorSheet(existing: existing),
    );
  }

  Future<void> _confirmDeleteType(RewardTypeConfig type) async {
    final linkedCount = _store.displayRewardCountForType(type);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: const Text(
            'Delete Reward Type?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          content: Text(
            linkedCount > 0
                ? '"${type.name}" currently has ${linkedCount == 1 ? '1 reward' : '$linkedCount rewards'}. Deleting it will remove it from your Rewards filter options.'
                : 'Remove "${type.name}" from your reward types?',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.secondaryTextStoneGrey,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (type.isActive)
              TextButton(
                onPressed: () {
                  _store.toggleRewardTypeActive(type.id);
                  Navigator.of(ctx).pop(false);
                  AppSnackbar.show(
                    context,
                    title: 'Type Archived',
                    message:
                        '"${type.name}" hidden from filter chips (tap edit to restore).',
                    type: SnackbarType.info,
                  );
                },
                child: const Text(
                  'Archive Instead',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.infoAlpineBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: AppColors.primaryTextOffWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      _store.deleteRewardType(type.id);
      AppSnackbar.show(
        context,
        title: 'Type Deleted',
        message: '"${type.name}" was removed from your reward types.',
        type: SnackbarType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = _store.types;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopHeader(),
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCallout(),
                    const SizedBox(height: 24),
                    const Text(
                      'MY REWARD TYPES',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: types.length,
                      onReorder: (oldIndex, newIndex) {
                        _store.reorderRewardTypes(oldIndex, newIndex);
                      },
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, _) {
                            return Material(
                              color: Colors.transparent,
                              elevation: 8,
                              shadowColor: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(16),
                              child: child,
                            );
                          },
                        );
                      },
                      itemBuilder: (context, index) {
                        final type = types[index];
                        return Padding(
                          key: ValueKey(type.id),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildTypeRow(type, index),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Drag to reorder. Types appear as filter options on your\nRewards list.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextStoneGrey,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDashedAddButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 12),
      child: SizedBox(
        height: 34,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UlvenikIcon(UlvenikIcons.back,
                        size: 24,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              'Reward Types',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextOffWhite,
                letterSpacing: -0.2,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _openTypeEditorSheet(),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UlvenikIcon(UlvenikIcons.add,
                        size: 18,
                        color: AppColors.primaryForestGreen,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add Type',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryForestGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCallout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.infoAlpineBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.infoAlpineBlue.withValues(alpha: 0.24),
          width: 1,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline_rounded,
              size: 18,
              color: AppColors.infoAlpineBlue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Create your own reward types to organise your rewards your way. These appear as filter options on your Rewards list.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryTextStoneGrey,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeRow(RewardTypeConfig type, int index) {
    final count = _store.displayRewardCountForType(type);
    final countText = count == 1 ? '1 reward' : '$count rewards';

    return GestureDetector(
      onTap: () => _openTypeEditorSheet(existing: type),
      child: Opacity(
        opacity: type.isActive ? 1.0 : 0.56,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SizedBox(
                    width: 18,
                    height: 14,
                    child: CustomPaint(
                      painter: _ThreeLineGripPainter(
                        color:
                            AppColors.secondarySage.withValues(alpha: 0.82),
                      ),
                    ),
                  ),
                ),
              ),
              RewardGlyphIcon(
                kind: type.iconKind,
                color: AppColors.secondarySage,
                size: 21,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        type.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextOffWhite,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    if (!type.isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ARCHIVED',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                countText,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => _openTypeEditorSheet(existing: type),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CustomPaint(
                      painter: _SquareEditIconPainter(
                        color: AppColors.secondarySage,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _confirmDeleteType(type),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline_rounded,
                    size: 19,
                    color: AppColors.secondarySage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashedAddButton() {
    return GestureDetector(
      onTap: () => _openTypeEditorSheet(),
      child: CustomPaint(
        painter: _DashedRoundedRectPainter(
          color: Colors.white.withValues(alpha: 0.16),
          radius: 14,
        ),
        child: Container(
          width: double.infinity,
          height: 54,
          alignment: Alignment.center,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UlvenikIcon(UlvenikIcons.add,
                size: 18,
                color: AppColors.primaryForestGreen,
              ),
              SizedBox(width: 8),
              Text(
                'Add New Type',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryForestGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add / Edit Reward Type Modal Sheet ───────────────────────────────────────

class _RewardTypeEditorSheet extends StatefulWidget {
  final RewardTypeConfig? existing;

  const _RewardTypeEditorSheet({this.existing});

  @override
  State<_RewardTypeEditorSheet> createState() => _RewardTypeEditorSheetState();
}

class _RewardTypeEditorSheetState extends State<_RewardTypeEditorSheet> {
  final RewardsStore _store = RewardsStore.instance;
  late final TextEditingController _nameController;
  late RewardIconKind _selectedIcon;
  late bool _isActive;
  String? _errorText;

  static const List<(RewardIconKind, String)> _iconChoices = [
    (RewardIconKind.warmFood, 'Food'),
    (RewardIconKind.giftToy, 'Toy'),
    (RewardIconKind.heartPraise, 'Praise'),
    (RewardIconKind.boltPlay, 'Play'),
    (RewardIconKind.trophyComp, 'Star'),
    (RewardIconKind.circleBolt, 'Drive'),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _selectedIcon = widget.existing?.iconKind ?? RewardIconKind.trophyComp;
    _isActive = widget.existing?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final clean = _nameController.text.trim();
    if (clean.isEmpty) {
      setState(() => _errorText = 'Please enter a reward type name.');
      return;
    }

    if (widget.existing != null) {
      _store.updateRewardType(
        widget.existing!.id,
        name: clean,
        iconKind: _selectedIcon,
        isActive: _isActive,
      );
      AppSnackbar.show(
        context,
        title: 'Type Updated',
        message: '"$clean" has been updated.',
        type: SnackbarType.success,
      );
    } else {
      _store.addRewardType(clean, iconKind: _selectedIcon);
      AppSnackbar.show(
        context,
        title: 'Type Created',
        message: '"$clean" now appears in your Rewards filter options.',
        type: SnackbarType.success,
      );
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppColors.cardBorder),
            left: BorderSide(color: AppColors.cardBorder),
            right: BorderSide(color: AppColors.cardBorder),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEditing ? 'Edit Reward Type' : 'Add Reward Type',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextOffWhite,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Icon(Icons.close_rounded,
                        size: 20,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'TYPE NAME',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _nameController,
                  autofocus: !isEditing,
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() => _errorText = null);
                    }
                  },
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextOffWhite,
                  ),
                  cursorColor: AppColors.primaryForestGreen,
                  decoration: InputDecoration(
                    hintText: 'e.g. Jackpot, Scent Pad, Social',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.secondaryTextStoneGrey
                          .withValues(alpha: 0.6),
                    ),
                    errorText: _errorText,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryForestGreen,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryForestGreen,
                        width: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'CATEGORY ICON',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _iconChoices.map((entry) {
                    final kind = entry.$1;
                    final label = entry.$2;
                    final selected = _selectedIcon == kind;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = kind),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryForestGreen
                                  .withValues(alpha: 0.16)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryForestGreen
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RewardGlyphIcon(
                              kind: kind,
                              size: 18,
                              color: selected
                                  ? AppColors.primaryForestGreen
                                  : AppColors.secondarySage,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.primaryTextOffWhite
                                    : AppColors.secondaryTextStoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Show in Rewards Filter Bar',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTextOffWhite,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Disable to archive without deleting linked rewards.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: AppColors.secondaryTextStoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _isActive,
                          activeTrackColor: AppColors.primaryForestGreen,
                          onChanged: (val) => setState(() => _isActive = val),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save Type' : 'Create Type',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.04),
                      foregroundColor: AppColors.secondaryTextStoneGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Crisp Custom Vector Painters Matching Figma 82 ───────────────────────────

class _ThreeLineGripPainter extends CustomPainter {
  final Color color;
  const _ThreeLineGripPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    for (final yFactor in [0.18, 0.50, 0.82]) {
      final y = size.height * yFactor;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ThreeLineGripPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SquareEditIconPainter extends CustomPainter {
  final Color color;
  const _SquareEditIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Rounded box open at top-right corner
    final box = Path()
      ..moveTo(w * 0.56, h * 0.16)
      ..lineTo(w * 0.22, h * 0.16)
      ..quadraticBezierTo(w * 0.12, h * 0.16, w * 0.12, h * 0.26)
      ..lineTo(w * 0.12, h * 0.78)
      ..quadraticBezierTo(w * 0.12, h * 0.88, w * 0.22, h * 0.88)
      ..lineTo(w * 0.74, h * 0.88)
      ..quadraticBezierTo(w * 0.84, h * 0.88, w * 0.84, h * 0.78)
      ..lineTo(w * 0.84, h * 0.44);
    canvas.drawPath(box, paint);

    // Diagonal edit stylus from top-right into center
    final pen = Path()
      ..moveTo(w * 0.76, h * 0.10)
      ..lineTo(w * 0.90, h * 0.24)
      ..lineTo(w * 0.50, h * 0.64)
      ..lineTo(w * 0.34, h * 0.66)
      ..lineTo(w * 0.36, h * 0.50)
      ..close();
    canvas.drawPath(pen, paint);
  }

  @override
  bool shouldRepaint(covariant _SquareEditIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const double dashWidth = 4.5;
    const double dashSpace = 3.5;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
