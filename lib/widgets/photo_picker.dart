import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import 'custom_snackbar.dart';

/// Shared photo chooser: Take Photo / Choose from Library.
/// Returns the picked image as an [ImageProvider], or null if cancelled.
Future<ImageProvider?> pickPhoto(BuildContext context, {bool allowCamera = true}) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (allowCamera)
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: AppColors.primaryTextOffWhite),
              title: const Text('Take Photo', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: AppColors.primaryTextOffWhite),
            title: const Text('Choose from Library', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ]),
      ),
    ),
  );
  if (source == null || !context.mounted) return null;
  return pickPhotoFrom(context, source);
}

/// Picks directly from [source]. Shows a clear message if access is denied
/// or the device has no camera.
Future<ImageProvider?> pickPhotoFrom(BuildContext context, ImageSource source) async {
  try {
    final file = await ImagePicker().pickImage(source: source, maxWidth: 2048, imageQuality: 88);
    if (file == null) return null;
    return MemoryImage(await file.readAsBytes());
  } catch (_) {
    if (context.mounted) {
      AppSnackbar.show(
        context,
        message: source == ImageSource.camera
            ? 'Couldn’t open the camera. Check that camera access is allowed for Ulvenik in your device settings.'
            : 'Couldn’t open your photos. Check that photo access is allowed for Ulvenik in your device settings.',
        type: SnackbarType.error,
      );
    }
    return null;
  }
}
