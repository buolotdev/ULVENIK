import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'rewards_management_screen.dart';

/// Opens the Add Reward modal bottom sheet above any bottom navigation bar.
Future<RewardItemModel?> showAddRewardSheet(BuildContext context) {
  return showModalBottomSheet<RewardItemModel>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.68),
    builder: (_) => const AddRewardSheet(),
  );
}

/// Standalone screen wrapper for Screen 80 (Add Reward) — NO bottom nav bar.
class AddRewardScreen extends StatelessWidget {
  final String? initialName;
  final String? initialTypeId;
  final String? initialDescription;

  const AddRewardScreen({
    super.key,
    this.initialName,
    this.initialTypeId,
    this.initialDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AddRewardSheet(
            initialName: initialName,
            initialTypeId: initialTypeId,
            initialDescription: initialDescription,
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet modal content matching `Ulvenik - Add Reward.svg` 1:1.
class AddRewardSheet extends StatefulWidget {
  final String? initialName;
  final String? initialTypeId;
  final String? initialDescription;

  const AddRewardSheet({
    super.key,
    this.initialName,
    this.initialTypeId,
    this.initialDescription,
  });

  @override
  State<AddRewardSheet> createState() => _AddRewardSheetState();
}

class _AddRewardSheetState extends State<AddRewardSheet> {
  final RewardsStore _store = RewardsStore.instance;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  final TextEditingController _newTypeController = TextEditingController();

  late String _selectedTypeId;
  bool _creatingNewType = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descController =
        TextEditingController(text: widget.initialDescription ?? '');
    final activeTypes = _store.activeTypes;
    _selectedTypeId = widget.initialTypeId ??
        (activeTypes.isNotEmpty ? activeTypes.first.id : 'food');
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _nameController.dispose();
    _descController.dispose();
    _newTypeController.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  void _handleCreateNewType() {
    final name = _newTypeController.text.trim();
    if (name.isEmpty) return;

    _store.addRewardType(name, iconKind: RewardIconKind.starCustom);
    final created = _store.types.last;
    setState(() {
      _selectedTypeId = created.id;
      _creatingNewType = false;
      _newTypeController.clear();
    });
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Please enter a reward name.';
      });
      return;
    }

    final iconKind = _store.defaultIconForType(_selectedTypeId);
    final newItem = RewardItemModel(
      id: 'reward_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      typeId: _selectedTypeId,
      notes: _descController.text.trim(),
      iconKind: iconKind,
    );

    _store.addReward(newItem);
    AppSnackbar.show(
      context,
      title: 'Reward Saved',
      message: '"$name" added to ${_store.selectedDog.name}\'s rewards.',
      type: SnackbarType.success,
    );
    Navigator.of(context).maybePop(newItem);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final dogName = _store.selectedDog.name;
    final activeTypes = _store.activeTypes;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppColors.cardBorder, width: 1),
            left: BorderSide(color: AppColors.cardBorder, width: 1),
            right: BorderSide(color: AppColors.cardBorder, width: 1),
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
                // Drag Handle
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

                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        'Add Reward',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTextOffWhite,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: UlvenikIcon(UlvenikIcons.back,
                          size: 20,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rewards are personal to $dogName.',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 26),

                // REWARD NAME
                const Text(
                  'REWARD NAME',
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
                  onChanged: (_) {
                    if (_nameError != null) {
                      setState(() => _nameError = null);
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
                    hintText: 'e.g. Freeze-Dried Liver',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextStoneGrey
                          .withValues(alpha: 0.52),
                    ),
                    errorText: _nameError,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.1,
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
                const SizedBox(height: 26),

                // REWARD TYPE
                const Text(
                  'REWARD TYPE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Select from your types or create a new one.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...activeTypes.map((type) {
                      final isSelected = _selectedTypeId == type.id;
                      return _RewardTypePill(
                        label: type.name,
                        icon: _chipIconForType(type),
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedTypeId = type.id;
                          });
                        },
                      );
                    }),
                    _DashedNewTypePill(
                      onTap: () {
                        setState(() {
                          _creatingNewType = !_creatingNewType;
                        });
                      },
                    ),
                  ],
                ),

                if (_creatingNewType) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newTypeController,
                            autofocus: true,
                            onSubmitted: (_) => _handleCreateNewType(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.primaryTextOffWhite,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'New type name (e.g. Scent Pad)',
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.secondaryTextStoneGrey,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _handleCreateNewType,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryForestGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextOffWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 26),

                // DESCRIPTION
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Optional. Enter your own notes about this reward.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  minLines: 2,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5,
                    color: AppColors.primaryTextOffWhite,
                  ),
                  cursorColor: AppColors.primaryForestGreen,
                  decoration: InputDecoration(
                    hintText: 'Add any personal notes about this reward (optional)...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextStoneGrey
                          .withValues(alpha: 0.58),
                    ),
                    contentPadding: const EdgeInsets.only(top: 10, bottom: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.10),
                        width: 1,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryForestGreen,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Save Reward Button
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
                    child: const Text(
                      'Save Reward',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Cancel Button
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
                        fontWeight: FontWeight.w500,
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

  IconData _chipIconForType(RewardTypeConfig type) {
    final lower = type.name.toLowerCase();
    if (lower == 'food') return Icons.inventory_2_outlined;
    if (lower == 'toy') return Icons.card_giftcard_rounded;
    if (lower == 'praise') return Icons.favorite_border_rounded;
    if (lower == 'play' || lower == 'high drive') return Icons.bolt_outlined;
    if (lower == 'competition') return Icons.star_border_rounded;
    switch (type.iconKind) {
      case RewardIconKind.warmFood:
      case RewardIconKind.kibbleFork:
        return Icons.inventory_2_outlined;
      case RewardIconKind.giftToy:
        return Icons.card_giftcard_rounded;
      case RewardIconKind.heartPraise:
        return Icons.favorite_border_rounded;
      case RewardIconKind.boltPlay:
      case RewardIconKind.circleBolt:
        return Icons.bolt_outlined;
      case RewardIconKind.trophyComp:
      case RewardIconKind.starCustom:
        return Icons.star_border_rounded;
    }
  }
}

class _RewardTypePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RewardTypePill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryForestGreen.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryForestGreen
                : Colors.white.withValues(alpha: 0.10),
            width: 1.1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UlvenikIcon.fromMaterial(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.primaryForestGreen
                  : AppColors.secondaryTextStoneGrey,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryTextOffWhite
                    : AppColors.secondaryTextStoneGrey,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 7),
              const UlvenikIcon(UlvenikIcons.completed,
                size: 15,
                color: AppColors.primaryForestGreen,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashedNewTypePill extends StatelessWidget {
  final VoidCallback onTap;

  const _DashedNewTypePill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedStadiumPainter(
          color: AppColors.primaryForestGreen.withValues(alpha: 0.85),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9.5),
          child: Text(
            '+ New Type',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryForestGreen,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedStadiumPainter extends CustomPainter {
  final Color color;
  const _DashedStadiumPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.height / 2),
    );
    final path = Path()..addRRect(rrect);

    const double dashWidth = 4.0;
    const double dashSpace = 3.2;

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
  bool shouldRepaint(covariant _DashedStadiumPainter oldDelegate) =>
      oldDelegate.color != color;
}
