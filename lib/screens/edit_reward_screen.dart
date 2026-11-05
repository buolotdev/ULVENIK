import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'rewards_management_screen.dart';

/// Opens the Edit Reward modal bottom sheet above any bottom navigation bar.
Future<void> showEditRewardSheet(
  BuildContext context,
  RewardItemModel reward,
) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.68),
    builder: (_) => EditRewardSheet(reward: reward),
  );
}

/// Standalone screen wrapper for Screen 81 (Edit Reward) — NO bottom nav bar.
class EditRewardScreen extends StatelessWidget {
  final RewardItemModel? reward;

  const EditRewardScreen({
    super.key,
    this.reward,
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
          child: EditRewardSheet(reward: reward),
        ),
      ),
    );
  }
}

/// Bottom sheet modal content matching `Ulvenik - Edit Reward.svg` 1:1.
class EditRewardSheet extends StatefulWidget {
  final RewardItemModel? reward;

  const EditRewardSheet({
    super.key,
    this.reward,
  });

  @override
  State<EditRewardSheet> createState() => _EditRewardSheetState();
}

class _EditRewardSheetState extends State<EditRewardSheet> {
  final RewardsStore _store = RewardsStore.instance;
  late final RewardItemModel _targetReward;
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  final TextEditingController _newTypeController = TextEditingController();

  late String _selectedTypeId;
  bool _creatingNewType = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _targetReward = widget.reward ??
        (_store.rewards.isNotEmpty
            ? _store.rewards.first
            : RewardItemModel(
                id: 'r1',
                name: 'Freeze-Dried Liver',
                typeId: 'food',
                notes: 'High value — competition only',
                iconKind: RewardIconKind.warmFood,
              ));

    _nameController = TextEditingController(text: _targetReward.name);
    _descController = TextEditingController(text: _targetReward.notes);
    _selectedTypeId = _targetReward.typeId;
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

  void _handleSaveChanges() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Reward name cannot be empty.';
      });
      return;
    }

    final updatedIcon = _selectedTypeId == _targetReward.typeId
        ? _targetReward.iconKind
        : _store.defaultIconForType(_selectedTypeId);

    final updated = _targetReward.copyWith(
      name: name,
      typeId: _selectedTypeId,
      notes: _descController.text.trim(),
      iconKind: updatedIcon,
    );

    _store.updateReward(updated);
    AppSnackbar.show(
      context,
      title: 'Changes Saved',
      message: '"$name" has been updated.',
      type: SnackbarType.success,
    );
    Navigator.of(context).maybePop();
  }

  Future<void> _handleDeleteReward() async {
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
            'Delete Reward?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextOffWhite,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${_targetReward.name}"? This action cannot be undone.',
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
                'Delete Reward',
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
      _store.deleteReward(_targetReward.id);
      AppSnackbar.show(
        context,
        title: 'Reward Deleted',
        message: '"${_targetReward.name}" was removed.',
        type: SnackbarType.info,
      );
      Navigator.of(context).maybePop();
    }
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
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
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
                        'Edit Reward',
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
                        child: Icon(
                          Icons.close_rounded,
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
                const SizedBox(height: 24),

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
                    hintText: 'Enter reward name',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppColors.secondaryTextStoneGrey
                          .withValues(alpha: 0.6),
                    ),
                    errorText: _nameError,
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
                const SizedBox(height: 24),

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
                  spacing: 9,
                  runSpacing: 10,
                  children: [
                    ...activeTypes.map((type) {
                      final isSelected = _selectedTypeId == type.id;
                      return _EditRewardTypePill(
                        label: type.name,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedTypeId = type.id;
                          });
                        },
                      );
                    }),
                    _EditDashedNewTypePill(
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
                              hintText: 'New type name...',
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

                const SizedBox(height: 24),

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
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryTextOffWhite,
                  ),
                  cursorColor: AppColors.primaryForestGreen,
                  decoration: InputDecoration(
                    hintText: 'Add any personal notes about this reward (optional)...',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
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

                const SizedBox(height: 26),

                // Save Changes Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleSaveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
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
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Destructive Delete Reward Action
                Center(
                  child: GestureDetector(
                    onTap: _handleDeleteReward,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: AppColors.errorDestructive,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Delete Reward',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.errorDestructive,
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
        ),
      ),
    );
  }
}

class _EditRewardTypePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _EditRewardTypePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryForestGreen.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20),
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
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryForestGreen
                    : AppColors.secondaryTextStoneGrey,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_rounded,
                size: 14,
                color: AppColors.primaryForestGreen,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EditDashedNewTypePill extends StatelessWidget {
  final VoidCallback onTap;

  const _EditDashedNewTypePill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _EditDashedBorderPainter(
          color: Colors.white.withValues(alpha: 0.18),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UlvenikIcon(UlvenikIcons.add,
                size: 15,
                color: AppColors.primaryForestGreen,
              ),
              SizedBox(width: 4),
              Text(
                'New Type',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
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

class _EditDashedBorderPainter extends CustomPainter {
  final Color color;
  const _EditDashedBorderPainter({required this.color});

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
  bool shouldRepaint(covariant _EditDashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
