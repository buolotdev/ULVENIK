import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/change_photo_bottom_sheet.dart';
import '../widgets/custom_snackbar.dart';
import 'image_editor_screen.dart';

class ChangePhotoScreen extends StatefulWidget {
  final bool initialHasPhoto;

  const ChangePhotoScreen({
    super.key,
    this.initialHasPhoto = true,
  });

  @override
  State<ChangePhotoScreen> createState() => _ChangePhotoScreenState();
}

class _ChangePhotoScreenState extends State<ChangePhotoScreen> {
  late bool _hasPhoto;
  late bool _isInlineSheetOpen;

  String _currentAssetPath = 'assets/images/handler_profile_photo.jpg';
  int _quarterTurns = 0;
  double _zoom = 1.0;
  bool _isCircularCrop = true;

  static const List<(String, String)> _librarySamples = [
    ('assets/images/handler_profile_photo.jpg', 'Nordic Forest Portrait'),
    ('assets/images/photo_viewer_1.jpg', 'Field Session Capture'),
    ('assets/images/photo_viewer_2.jpg', 'Trail Ridge Portrait'),
  ];

  @override
  void initState() {
    super.initState();
    _hasPhoto = widget.initialHasPhoto;
    _isInlineSheetOpen = widget.initialHasPhoto;
  }

  Future<void> _launchEditor({required String assetPath, required bool fromCamera}) async {
    if (_isInlineSheetOpen) {
      setState(() => _isInlineSheetOpen = false);
    }

    final result = await Navigator.of(context, rootNavigator: true)
        .push<ImageEditorResult>(
      MaterialPageRoute(
        builder: (_) => ImageEditorScreen(
          initialAssetPath: assetPath,
          initialQuarterTurns: fromCamera ? 0 : _quarterTurns,
          initialZoom: fromCamera ? 1.0 : _zoom,
          initialCircularCrop: _isCircularCrop,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _hasPhoto = true;
      _currentAssetPath = result.assetPath;
      _quarterTurns = result.quarterTurns;
      _zoom = result.zoom;
      _isCircularCrop = result.isCircularCrop;
    });

    AppSnackbar.show(
      context,
      title: 'Profile Photo Updated',
      message: fromCamera
          ? 'Captured photo cropped and applied to your profile.'
          : 'Selected library photo cropped and saved.',
      type: SnackbarType.success,
    );
  }

  Future<void> _openModalPhotoSheet() async {
    final sheetResult = await ChangePhotoBottomSheet.show(
      context,
      currentAssetPath: _currentAssetPath,
      hasActivePhoto: _hasPhoto,
      initials: 'AK',
      quarterTurns: _quarterTurns,
      zoom: _zoom,
    );

    if (!mounted || sheetResult == null) return;

    if (sheetResult.action == ChangePhotoSheetAction.removePhoto) {
      _removeCurrentPhoto();
      return;
    }

    final edited = sheetResult.editorResult;
    if (edited != null) {
      setState(() {
        _hasPhoto = true;
        _currentAssetPath = edited.assetPath;
        _quarterTurns = edited.quarterTurns;
        _zoom = edited.zoom;
        _isCircularCrop = edited.isCircularCrop;
      });
      AppSnackbar.show(
        context,
        title: 'Profile Photo Updated',
        message: 'Your cropped profile photo is now active.',
        type: SnackbarType.success,
      );
    }
  }

  void _removeCurrentPhoto() {
    setState(() {
      _hasPhoto = false;
      _isInlineSheetOpen = false;
      _quarterTurns = 0;
      _zoom = 1.0;
    });

    AppSnackbar.show(
      context,
      title: 'Photo Removed',
      message: 'Your profile is now displaying initials.',
      type: SnackbarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Modal flow: strictly NO bottomNavigationBar
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _hasPhoto ? _buildPopulatedState() : _buildEmptyState(),
      ),
    );
  }

  Widget _buildPopulatedState() {
    final contentDim = _isInlineSheetOpen ? 0.42 : 1.0;

    return Stack(
      key: const ValueKey('populated_profile_photo'),
      children: [
        SafeArea(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: contentDim,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(
                          _currentAssetPath,
                        ),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 22,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Handler Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _openModalPhotoSheet,
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          size: 22,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: _openModalPhotoSheet,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        _isCircularCrop ? 54 : 8,
                      ),
                      border: Border.all(
                        color: _isInlineSheetOpen
                            ? Colors.transparent
                            : AppColors.primaryForestGreen,
                        width: 1.8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        _isCircularCrop ? 54 : 6,
                      ),
                      child: Transform.scale(
                        scale: _zoom,
                        child: RotatedBox(
                          quarterTurns: _quarterTurns,
                          child: Image.asset(
                            _currentAssetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Lars Viken',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'K9 Tracking Specialist • Level 4',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5,
                    color: AppColors.secondaryTextStoneGrey,
                  ),
                ),
                if (!_isInlineSheetOpen) ...[
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: _openModalPhotoSheet,
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                              size: 18,
                            ),
                            label: const Text(
                              'Change Profile Photo',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryForestGreen,
                              foregroundColor: AppColors.primaryTextOffWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: () => _launchEditor(
                              assetPath: _currentAssetPath,
                              fromCamera: false,
                            ),
                            icon: const Icon(
                              Icons.crop_rounded,
                              size: 18,
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                            label: const Text(
                              'Adjust Crop & Framing',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryTextOffWhite,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.cardBorder,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'RECENT LIBRARY PHOTOS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (int i = 0; i < _librarySamples.length; i++) ...[
                              if (i > 0) const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _launchEditor(
                                    assetPath: _librarySamples[i].$1,
                                    fromCamera: false,
                                  ),
                                  child: Container(
                                    height: 76,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _currentAssetPath ==
                                                _librarySamples[i].$1
                                            ? AppColors.primaryForestGreen
                                            : AppColors.cardBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.5),
                                      child: Image.asset(
                                        _librarySamples[i].$1,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_isInlineSheetOpen) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isInlineSheetOpen = false),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChangePhotoBottomSheet(
              currentAssetPath: _currentAssetPath,
              hasActivePhoto: true,
              quarterTurns: _quarterTurns,
              zoom: _zoom,
              onTakePhoto: () => _launchEditor(
                assetPath: 'assets/images/photo_viewer_1.jpg',
                fromCamera: true,
              ),
              onChooseFromLibrary: () => _launchEditor(
                assetPath: _currentAssetPath,
                fromCamera: false,
              ),
              onRemovePhoto: _removeCurrentPhoto,
              onCancel: () => setState(() => _isInlineSheetOpen = false),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      key: const ValueKey('empty_profile_photo'),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                            color: AppColors.primaryTextOffWhite,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.5,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryTextOffWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextOffWhite,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.22),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _openModalPhotoSheet,
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 128,
                        height: 128,
                        child: Stack(
                          children: [
                            Container(
                              width: 124,
                              height: 124,
                              decoration: BoxDecoration(
                                color: const Color(0xFF222526),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'AK',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  color: AppColors.primaryTextOffWhite,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF191C1E),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.photo_camera_outlined,
                                  size: 16,
                                  color: Color(0xFFD5D8D4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'No Profile Photo',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextOffWhite,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Add a profile photo to personalise your\naccount.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        height: 1.45,
                        color: Color(0xFFC7CCC8),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 22,
                      runSpacing: 12,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _launchEditor(
                            assetPath: 'assets/images/photo_viewer_1.jpg',
                            fromCamera: true,
                          ),
                          icon: const Icon(
                            Icons.photo_camera_outlined,
                            size: 18,
                            color: Color(0xFFC7CCC8),
                          ),
                          label: const Text(
                            'Take Photo',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextOffWhite,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(154, 46),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.45),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _launchEditor(
                            assetPath: 'assets/images/handler_profile_photo.jpg',
                            fromCamera: false,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 18,
                                  color: Color(0xFFC7CCC8),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Choose Photo',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextOffWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
