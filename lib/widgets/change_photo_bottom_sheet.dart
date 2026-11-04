import 'package:flutter/material.dart';
import '../screens/image_editor_screen.dart';
import '../theme/app_colors.dart';

enum ChangePhotoSheetAction {
  takePhoto,
  chooseFromLibrary,
  removePhoto,
  cancel,
}

class ChangePhotoSheetResult {
  final ChangePhotoSheetAction action;
  final ImageEditorResult? editorResult;

  const ChangePhotoSheetResult({
    required this.action,
    this.editorResult,
  });
}

class ChangePhotoBottomSheet extends StatelessWidget {
  final String currentAssetPath;
  final bool hasActivePhoto;
  final String initials;
  final int quarterTurns;
  final double zoom;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromLibrary;
  final VoidCallback? onRemovePhoto;
  final VoidCallback onCancel;

  const ChangePhotoBottomSheet({
    super.key,
    this.currentAssetPath = 'assets/images/handler_profile_photo.jpg',
    this.hasActivePhoto = true,
    this.initials = 'AK',
    this.quarterTurns = 0,
    this.zoom = 1.0,
    required this.onTakePhoto,
    required this.onChooseFromLibrary,
    this.onRemovePhoto,
    required this.onCancel,
  });

  /// Shows the modal Change Photo bottom sheet on the root navigator and
  /// returns the selected [ChangePhotoSheetResult] (including any cropped
  /// [ImageEditorResult] returned from [ImageEditorScreen]).
  static Future<ChangePhotoSheetResult?> show(
    BuildContext context, {
    String currentAssetPath = 'assets/images/handler_profile_photo.jpg',
    bool hasActivePhoto = true,
    String initials = 'AK',
    int quarterTurns = 0,
    double zoom = 1.0,
  }) async {
    final rootNav = Navigator.of(context, rootNavigator: true);

    final pickedAction = await showModalBottomSheet<ChangePhotoSheetAction>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.64),
      builder: (sheetCtx) {
        return ChangePhotoBottomSheet(
          currentAssetPath: currentAssetPath,
          hasActivePhoto: hasActivePhoto,
          initials: initials,
          quarterTurns: quarterTurns,
          zoom: zoom,
          onTakePhoto: () =>
              Navigator.of(sheetCtx).pop(ChangePhotoSheetAction.takePhoto),
          onChooseFromLibrary: () => Navigator.of(sheetCtx).pop(
            ChangePhotoSheetAction.chooseFromLibrary,
          ),
          onRemovePhoto: hasActivePhoto
              ? () => Navigator.of(sheetCtx).pop(
                    ChangePhotoSheetAction.removePhoto,
                  )
              : null,
          onCancel: () =>
              Navigator.of(sheetCtx).pop(ChangePhotoSheetAction.cancel),
        );
      },
    );

    if (pickedAction == null || pickedAction == ChangePhotoSheetAction.cancel) {
      return const ChangePhotoSheetResult(
        action: ChangePhotoSheetAction.cancel,
      );
    }

    if (pickedAction == ChangePhotoSheetAction.removePhoto) {
      return const ChangePhotoSheetResult(
        action: ChangePhotoSheetAction.removePhoto,
      );
    }

    final targetAsset = pickedAction == ChangePhotoSheetAction.takePhoto
        ? 'assets/images/photo_viewer_1.jpg'
        : (hasActivePhoto
            ? currentAssetPath
            : 'assets/images/handler_profile_photo.jpg');

    final edited = await rootNav.push<ImageEditorResult>(
      MaterialPageRoute(
        builder: (_) => ImageEditorScreen(
          initialAssetPath: targetAsset,
          initialQuarterTurns:
              pickedAction == ChangePhotoSheetAction.takePhoto
                  ? 0
                  : quarterTurns,
          initialZoom:
              pickedAction == ChangePhotoSheetAction.takePhoto ? 1.0 : zoom,
        ),
      ),
    );

    if (edited == null) {
      return const ChangePhotoSheetResult(
        action: ChangePhotoSheetAction.cancel,
      );
    }

    return ChangePhotoSheetResult(
      action: pickedAction,
      editorResult: edited,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondaryTextStoneGrey.withValues(
                    alpha: 0.32,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Profile Photo',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTextOffWhite,
                ),
              ),
              const SizedBox(height: 18),
              _buildAvatarPreview(),
              const SizedBox(height: 12),
              Text(
                hasActivePhoto ? 'CURRENT ACTIVE' : 'NO PHOTO SET',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.secondaryTextStoneGrey,
                ),
              ),
              const SizedBox(height: 20),
              _buildActionRow(
                icon: Icons.photo_camera_outlined,
                iconColor: AppColors.secondarySage,
                label: 'Take Photo',
                labelColor: AppColors.primaryTextOffWhite,
                onTap: onTakePhoto,
              ),
              Container(height: 1, color: AppColors.cardBorder),
              _buildActionRow(
                icon: Icons.collections_outlined,
                iconColor: AppColors.secondarySage,
                label: 'Choose from Photo Library',
                labelColor: AppColors.primaryTextOffWhite,
                onTap: onChooseFromLibrary,
              ),
              if (hasActivePhoto && onRemovePhoto != null) ...[
                Container(height: 1, color: AppColors.cardBorder),
                _buildActionRow(
                  icon: Icons.delete_outline_rounded,
                  iconColor: const Color(0xFF9E4747),
                  label: 'Remove Current Photo',
                  labelColor: const Color(0xFF9E4747),
                  onTap: onRemovePhoto!,
                ),
              ],
              Container(height: 1, color: AppColors.cardBorder),
              _buildActionRow(
                icon: Icons.close_rounded,
                iconColor: AppColors.secondaryTextStoneGrey,
                label: 'Cancel',
                labelColor: AppColors.secondaryTextStoneGrey,
                onTap: onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF222526),
              border: Border.all(
                color: hasActivePhoto
                    ? AppColors.primaryForestGreen
                    : AppColors.cardBorder,
                width: 2.2,
              ),
            ),
            child: ClipOval(
              child: hasActivePhoto
                  ? Transform.scale(
                      scale: zoom,
                      child: RotatedBox(
                        quarterTurns: quarterTurns,
                        child: Image.asset(
                          currentAssetPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTextOffWhite,
                        ),
                      ),
                    ),
            ),
          ),
          if (hasActivePhoto)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primaryForestGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardsCarbon,
                    width: 2.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
