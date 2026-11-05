import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'app_settings_screen.dart';
import 'change_photo_screen.dart';
import 'edit_profile_screen.dart';
import 'image_editor_screen.dart';
import 'login_screen.dart';
import 'notifications_page_screen.dart';
import 'open_source_licences_screen.dart';
import 'trainer_dashboard_screen.dart';
import 'trainer_profile_screen.dart';
import 'two_factor_setup_screen.dart';
import 'whats_new_screen.dart';

class ProfilePageScreen extends StatefulWidget {
  final String? subscriptionPlan;
  final bool hasSportPack;
  final bool hasTrainerPack;

  const ProfilePageScreen({
    super.key,
    this.subscriptionPlan,
    this.hasSportPack = false,
    this.hasTrainerPack = true,
  });

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sageIcon = Color(0xFF7A8F7A);
  static const Color _heroBg = Color(0xFF131719);
  static const Color _streakIconBg = Color(0xFF2A2F32);
  static const Color _destructiveRed = Color(0xFF9E4747);

  String get _userSubscriptionLabel {
    final override = widget.subscriptionPlan?.trim();
    if (override != null && override.isNotEmpty) return override;
    if (widget.hasSportPack && widget.hasTrainerPack) return 'Complete';
    if (widget.hasTrainerPack) return 'Core + Trainer';
    if (widget.hasSportPack) return 'Core + Sport';
    return 'Core';
  }

  static const List<Color> _avatarPalette = [
    Color(0xFF272B29),
    Color(0xFF224237),
    Color(0xFF263B4A),
    Color(0xFF473729),
  ];

  // Live synchronized profile fields (updated via EditProfileScreen or Change Photo)
  String _firstName = 'James';
  String _lastName = 'Harlow';
  String _fullName = 'James Harlow';
  final String _memberSince = 'Member since July 2024';
  String _email = 'james@example.com';
  String _phone = '+44 7700 900412';
  String _location = 'Pakistan';
  String _language = 'English';
  String _timeZone = 'Asia/Karachi (PKT, UTC+5)';
  String _weightUnitLabel = 'Kilograms (kg)';
  String _distanceUnitLabel = 'Kilometres';
  String _bio =
      'IGP & working gundog handler focused on structured impulse control, scent discrimination, and canine athletic conditioning.';
  String _businessName = 'Harlow Working Dogs';
  int _avatarColorIndex = 0;
  bool _hasCustomPhotoBadge = false;

  // Live stats & streak
  final int _dogsCount = 6;
  int _sessionsCount = 2418;
  final int _goalsCount = 163;
  final String _yearsLabel = '4 yrs';
  int _streakDays = 18;

  // Live preference subtitles
  String _appearanceMode = 'Dark Mode';
  String _unitsAndDate = 'kg · km · DD/MM/YYYY';
  String _displayPrefs = 'Default home, calendar view';
  bool _pushOn = true;
  bool _quietHoursOn = false;
  bool _biometricsOn = true;
  bool _dataPermissionsOn = true;
  String _syncedAgo = '4 min ago';

  String get _initials {
    final parts = _fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'JH';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _formatInt(int value) {
    final raw = value.toString();
    if (raw.length <= 3) return raw;
    final buf = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) {
        buf.write(',');
      }
      buf.write(raw[i]);
    }
    return buf.toString();
  }

  void _applyProfileUpdates(Map<String, dynamic>? result) {
    if (result == null) return;
    setState(() {
      if (result['firstName'] is String &&
          (result['firstName'] as String).trim().isNotEmpty) {
        _firstName = (result['firstName'] as String).trim();
      }
      if (result['lastName'] is String &&
          (result['lastName'] as String).trim().isNotEmpty) {
        _lastName = (result['lastName'] as String).trim();
      }
      if (result['fullName'] is String &&
          (result['fullName'] as String).trim().isNotEmpty) {
        _fullName = (result['fullName'] as String).trim();
      }
      if (result['email'] is String &&
          (result['email'] as String).trim().isNotEmpty) {
        _email = (result['email'] as String).trim();
      }
      if (result['phone'] is String) {
        _phone = (result['phone'] as String).trim();
      }
      if (result['location'] is String &&
          (result['location'] as String).trim().isNotEmpty) {
        _location = (result['location'] as String).trim();
      }
      if (result['language'] is String) {
        _language = result['language'] as String;
      }
      if (result['timeZone'] is String) {
        _timeZone = result['timeZone'] as String;
      }
      if (result['weightUnit'] is String) {
        _weightUnitLabel = result['weightUnit'] as String;
      }
      if (result['distanceUnit'] is String) {
        _distanceUnitLabel = result['distanceUnit'] as String;
      }
      if (result['unitsAndDate'] is String) {
        _unitsAndDate = result['unitsAndDate'] as String;
      }
      if (result['bio'] is String) {
        _bio = (result['bio'] as String).trim();
      }
      if (result['businessName'] is String &&
          (result['businessName'] as String).trim().isNotEmpty) {
        _businessName = (result['businessName'] as String).trim();
      }
      if (result['avatarColorIndex'] is int) {
        _avatarColorIndex =
            (result['avatarColorIndex'] as int) % _avatarPalette.length;
      }
      if (result['hasCustomPhotoBadge'] is bool) {
        _hasCustomPhotoBadge = result['hasCustomPhotoBadge'] as bool;
      }
    });
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialFirstName: _firstName,
          initialLastName: _lastName,
          initialDisplayName: _fullName,
          initialEmail: _email,
          initialCountry: _location,
          initialLanguage: _language,
          initialTimeZone: _timeZone,
          initialWeightUnit: _weightUnitLabel,
          initialDistanceUnit: _distanceUnitLabel,
        ),
      ),
    );

    if (result != null && mounted) {
      _applyProfileUpdates(result);
      AppSnackbar.show(
        context,
        title: 'Profile Updated',
        message: 'Saved changes for $_fullName.',
        type: SnackbarType.success,
      );
    }
  }

  void _openChangePhotoSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetContainer(
              sheetCtx: sheetCtx,
              title: 'Change Profile Photo',
              subtitle: 'Choose camera, gallery, or handler monogram style',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < _avatarPalette.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _avatarColorIndex = i;
                                _hasCustomPhotoBadge = i > 0;
                              });
                              setModalState(() {});
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: _avatarPalette[i],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _avatarColorIndex == i
                                      ? _mint
                                      : AppColors.cardBorder,
                                  width: _avatarColorIndex == i ? 2 : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _initials,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildModalActionRow(
                    icon: Icons.photo_camera_outlined,
                    label: 'Take Photo',
                    onTap: () async {
                      Navigator.of(sheetCtx).pop();
                      final edited = await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push<ImageEditorResult>(
                        MaterialPageRoute(
                          builder: (_) => const ImageEditorScreen(
                            initialAssetPath: 'assets/images/photo_viewer_1.jpg',
                          ),
                        ),
                      );
                      if (edited != null && mounted) {
                        setState(() {
                          _avatarColorIndex = 1;
                          _hasCustomPhotoBadge = true;
                        });
                        AppSnackbar.show(
                          context,
                          title: 'Camera Portrait Applied',
                          message: 'Updated profile portrait for $_fullName.',
                          type: SnackbarType.success,
                        );
                      }
                    },
                  ),
                  _buildModalActionRow(
                    icon: Icons.photo_library_outlined,
                    label: 'Choose from Photo Library',
                    onTap: () async {
                      Navigator.of(sheetCtx).pop();
                      final edited = await Navigator.of(
                        context,
                        rootNavigator: true,
                      ).push<ImageEditorResult>(
                        MaterialPageRoute(
                          builder: (_) => const ImageEditorScreen(),
                        ),
                      );
                      if (edited != null && mounted) {
                        setState(() {
                          _avatarColorIndex = 2;
                          _hasCustomPhotoBadge = true;
                        });
                        AppSnackbar.show(
                          context,
                          title: 'Photo Selected',
                          message: 'Updated handler photo from library.',
                          type: SnackbarType.success,
                        );
                      }
                    },
                  ),
                  _buildModalActionRow(
                    icon: Icons.crop_original_rounded,
                    label: 'Profile Photo Studio',
                    onTap: () {
                      Navigator.of(sheetCtx).pop();
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => const ChangePhotoScreen(),
                        ),
                      );
                    },
                  ),
                  if (_hasCustomPhotoBadge)
                    _buildModalActionRow(
                      icon: Icons.delete_outline_rounded,
                      label: 'Reset to Default Initials',
                      color: _destructiveRed,
                      onTap: () {
                        setState(() {
                          _avatarColorIndex = 0;
                          _hasCustomPhotoBadge = false;
                        });
                        Navigator.of(sheetCtx).pop();
                        AppSnackbar.show(
                          context,
                          title: 'Photo Removed',
                          message: 'Reverted to initials avatar.',
                          type: SnackbarType.info,
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openStreakAndAnalyticsSheet({int initialSelectedDay = 13}) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _ProfileStreakChartSheet(
          streakDays: _streakDays,
          dogsCount: _dogsCount,
          sessionsCount: _sessionsCount,
          goalsCount: _goalsCount,
          initialSelectedBar: initialSelectedDay,
          onRecordQuickSession: () {
            setState(() {
              _streakDays += 1;
              _sessionsCount += 1;
            });
            Navigator.of(sheetCtx).pop();
            AppSnackbar.show(
              context,
              title: 'Streak Extended!',
              message:
                  'Current Training Streak is now $_streakDays Days (${_formatInt(_sessionsCount)} total sessions).',
              type: SnackbarType.success,
            );
          },
        );
      },
    );
  }

  void _openSubscriptionSheet() {
    bool annualBilling = true;
    bool autoRenew = true;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetContainer(
              sheetCtx: sheetCtx,
              title: _userSubscriptionLabel,
              subtitle: autoRenew
                  ? 'Active · Renews 28 July 2025'
                  : 'Active until 28 July 2025 (Auto-renew paused)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              annualBilling
                                  ? 'Annual Plan (£149 / year)'
                                  : 'Monthly Plan (£16 / month)',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: _mint,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Includes unlimited dogs, 10 GB HD video sync, client homework portals, and sport analytics.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Annual Billing Cycle (Save 22%)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: annualBilling,
                    activeTrackColor: AppColors.primaryForestGreen,
                    activeThumbColor: _mint,
                    onChanged: (v) => setModalState(() => annualBilling = v),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Auto-Renew Membership',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: autoRenew,
                    activeTrackColor: AppColors.primaryForestGreen,
                    activeThumbColor: _mint,
                    onChanged: (v) => setModalState(() => autoRenew = v),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openTrainerPackSheet({required bool showClients}) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetContainer(
          sheetCtx: sheetCtx,
          title: showClients ? 'My Clients (12 Active)' : 'Trainer Profile',
          subtitle: showClients
              ? '$_businessName · Active coaching roster'
              : '$_businessName · Verified Canine Professional',
          child: showClients
              ? Column(
                  children: [
                    for (final c in const [
                      ('Clara Lindqvist', 'Malinois · IGP Phase B', 'Active'),
                      ('Henrik Solberg', 'Labrador · Gundog Field', 'Active'),
                      ('Sophie Mercer', 'Border Collie · Agility', 'Homework Due'),
                    ])
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                              color: _sageIcon,
                              size: 19,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.$1,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    c.$2,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.secondaryTextStoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              c.$3,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: _mint,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: AppColors.primaryTextOffWhite,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheetCtx).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TrainerDashboardScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Open Trainer Dashboard',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Identity: $_businessName\nLocation: $_location\nContact: $_phone\nVerification: Accredited Working Dog Coach (#UK-4091)',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 13.5,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _bio,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: AppColors.primaryTextOffWhite,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheetCtx).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TrainerProfileScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Open Trainer Profile & Business Identity',
                          style: TextStyle(
                            fontFamily: 'Inter',
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
  }

  void _openQuickChoiceSheet({
    required String title,
    required String subtitle,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            String active = current;
            return _buildSheetContainer(
              sheetCtx: sheetCtx,
              title: title,
              subtitle: subtitle,
              child: Column(
                children: options.map((opt) {
                  final selected = opt == active;
                  return InkWell(
                    onTap: () {
                      active = opt;
                      onSelected(opt);
                      setModalState(() {});
                      Navigator.of(sheetCtx).pop();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: selected
                                    ? _mint
                                    : AppColors.primaryTextOffWhite,
                                fontSize: 14.5,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          UlvenikIcon.fromMaterial(
                            selected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: selected
                                ? _mint
                                : AppColors.secondaryTextStoneGrey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _openAboutSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetContainer(
          sheetCtx: sheetCtx,
          title: 'About Ulvenik',
          subtitle: 'Version 1.0.0',
          child: Column(
            children: [
              _buildModalActionRow(
                icon: Icons.auto_awesome_outlined,
                label: "What's New (Release Notes)",
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WhatsNewScreen()),
                  );
                },
              ),
              _buildModalActionRow(
                icon: Icons.code_rounded,
                label: 'Open Source Licences',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OpenSourceLicencesScreen(),
                    ),
                  );
                },
              ),
              _buildModalActionRow(
                icon: Icons.settings_outlined,
                label: 'Open Full App Settings',
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppSettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmSignOut() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetContainer(
          sheetCtx: sheetCtx,
          title: 'Sign Out?',
          subtitle:
              'Sign out of $_fullName ($_email)? All synced dog profiles and training logs remain backed up.',
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(sheetCtx).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.primaryTextOffWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorDestructive,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontFamily: 'Inter',
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
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundObsidian,
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: EdgeInsets.fromLTRB(canPop ? 8 : 20, 0, 10, 0),
                child: Row(
                  children: [
                    if (canPop)
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const UlvenikIcon(UlvenikIcons.back,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 26,
                        ),
                        tooltip: 'Back',
                      ),
                    const Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _openEditProfile,
                      tooltip: 'Edit Profile',
                      icon: const UlvenikIcon(UlvenikIcons.edit,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopographicHero(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStreakCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('MY PROFILE'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile',
                      subtitle: 'Name, photo, biography, contact',
                      onTap: _openEditProfile,
                    ),
                    _buildRow(
                      icon: Icons.shield_outlined,
                      title: 'Account & Security',
                      subtitle: 'Email, password, Biometric Login, sessions',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TwoFactorSetupScreen(),
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('MEMBERSHIP'),
                  const SizedBox(height: 8),
                  _buildMembershipCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('TRAINER PACK'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.work_outline_rounded,
                      title: 'Trainer Profile',
                      subtitle: 'Business name, clients, verification',
                      onTap: () => _openTrainerPackSheet(showClients: false),
                    ),
                    _buildRow(
                      icon: Icons.groups_outlined,
                      title: 'My Clients',
                      subtitle: '12 active clients',
                      onTap: () => _openTrainerPackSheet(showClients: true),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('PREFERENCES'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      subtitle: _appearanceMode,
                      onTap: () => _openQuickChoiceSheet(
                        title: 'Appearance',
                        subtitle: 'Choose theme mode for Ulvenik',
                        options: const [
                          'Dark Mode',
                          'System Default',
                          'High Contrast Dark',
                        ],
                        current: _appearanceMode,
                        onSelected: (v) => setState(() => _appearanceMode = v),
                      ),
                    ),
                    _buildRow(
                      icon: Icons.straighten_rounded,
                      title: 'Units & Date Format',
                      subtitle: _unitsAndDate,
                      onTap: () => _openQuickChoiceSheet(
                        title: 'Units & Date Format',
                        subtitle: 'Choose measurement and calendar preset',
                        options: const [
                          'kg · km · DD/MM/YYYY',
                          'lb · mi · MM/DD/YYYY',
                          'kg · km · YYYY-MM-DD',
                        ],
                        current: _unitsAndDate,
                        onSelected: (v) => setState(() => _unitsAndDate = v),
                      ),
                    ),
                    _buildRow(
                      icon: Icons.dashboard_customize_outlined,
                      title: 'Display Preferences',
                      subtitle: _displayPrefs,
                      onTap: () => _openQuickChoiceSheet(
                        title: 'Display Preferences',
                        subtitle: 'Configure landing workspace and calendar layout',
                        options: const [
                          'Default home, calendar view',
                          'Training dashboard, week view',
                          'My Dogs overview, agenda view',
                        ],
                        current: _displayPrefs,
                        onSelected: (v) => setState(() => _displayPrefs = v),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notification Settings',
                      subtitle:
                          'Push Notifications: ${_pushOn ? 'On' : 'Off'} · Quiet Hours: ${_quietHoursOn ? 'On' : 'Off'}',
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          useRootNavigator: true,
                          backgroundColor: Colors.transparent,
                          builder: (sheetCtx) {
                            return StatefulBuilder(
                              builder: (ctx, setModalState) {
                                return _buildSheetContainer(
                                  sheetCtx: sheetCtx,
                                  title: 'Notification Settings',
                                  subtitle:
                                      'Configure push alerts and open inbox',
                                  child: Column(
                                    children: [
                                      SwitchListTile.adaptive(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Push Notifications',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color:
                                                AppColors.primaryTextOffWhite,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: _pushOn,
                                        activeTrackColor:
                                            AppColors.primaryForestGreen,
                                        activeThumbColor: _mint,
                                        onChanged: (v) {
                                          setState(() => _pushOn = v);
                                          setModalState(() {});
                                        },
                                      ),
                                      SwitchListTile.adaptive(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Quiet Hours (22:00 – 07:00)',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color:
                                                AppColors.primaryTextOffWhite,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: _quietHoursOn,
                                        activeTrackColor:
                                            AppColors.primaryForestGreen,
                                        activeThumbColor: _mint,
                                        onChanged: (v) {
                                          setState(() => _quietHoursOn = v);
                                          setModalState(() {});
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(sheetCtx).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const NotificationsPageScreen(),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: AppColors
                                                  .primaryForestGreen
                                                  .withValues(alpha: 0.5),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Open Notifications Inbox',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: _mint,
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
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('PRIVACY'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Privacy & Security',
                      subtitle:
                          '${_biometricsOn ? 'Biometric Login' : 'Passcode'} · ${_dataPermissionsOn ? 'Data Permissions' : 'Restricted'}',
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          useRootNavigator: true,
                          backgroundColor: Colors.transparent,
                          builder: (sheetCtx) {
                            return StatefulBuilder(
                              builder: (ctx, setModalState) {
                                return _buildSheetContainer(
                                  sheetCtx: sheetCtx,
                                  title: 'Privacy & Security',
                                  subtitle:
                                      'Manage Biometric Login and data permissions',
                                  child: Column(
                                    children: [
                                      SwitchListTile.adaptive(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Biometric Login',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color:
                                                AppColors.primaryTextOffWhite,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: _biometricsOn,
                                        activeTrackColor:
                                            AppColors.primaryForestGreen,
                                        activeThumbColor: _mint,
                                        onChanged: (v) {
                                          setState(() => _biometricsOn = v);
                                          setModalState(() {});
                                        },
                                      ),
                                      SwitchListTile.adaptive(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Client Data Permissions',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color:
                                                AppColors.primaryTextOffWhite,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        value: _dataPermissionsOn,
                                        activeTrackColor:
                                            AppColors.primaryForestGreen,
                                        activeThumbColor: _mint,
                                        onChanged: (v) {
                                          setState(
                                              () => _dataPermissionsOn = v);
                                          setModalState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('STORAGE'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.cloud_outlined,
                      title: 'Storage & Sync',
                      subtitle: '1.2 GB used · Synced $_syncedAgo',
                      onTap: () {
                        setState(() => _syncedAgo = 'just now');
                        AppSnackbar.show(
                          context,
                          title: 'Workspace Synced',
                          message: '1.2 GB cloud archive verified up to date.',
                          type: SnackbarType.success,
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('HELP & SUPPORT'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Centre',
                      onTap: () {
                        AppSnackbar.show(
                          context,
                          title: 'Help Centre',
                          message:
                              'Trainer documentation & video guides ready.',
                          type: SnackbarType.info,
                        );
                      },
                    ),
                    _buildRow(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Contact Support',
                      onTap: () {
                        AppSnackbar.show(
                          context,
                          title: 'Priority Support',
                          message:
                              'Connected to Trainer Pack priority concierge.',
                          type: SnackbarType.info,
                        );
                      },
                    ),
                    _buildRow(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Feature Requests',
                      onTap: () {
                        AppSnackbar.show(
                          context,
                          title: 'Feature Roadmap',
                          message: '3 trainer pack requests currently open.',
                          type: SnackbarType.info,
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('ABOUT'),
                  const SizedBox(height: 8),
                  _buildGroupCard([
                    _buildRow(
                      icon: Icons.info_outline_rounded,
                      title: 'About Ulvenik',
                      subtitle: "Version 1.0.0 · What's New · Legal",
                      onTap: _openAboutSheet,
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Material(
                    color: AppColors.cardsCarbon,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: _confirmSignOut,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: _destructiveRed,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildTopographicHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _heroBg,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: CustomPaint(
        painter: _TopographicContourPainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _openChangePhotoSheet,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: _avatarPalette[_avatarColorIndex],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                              width: 1.2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFF479878),
                              shape: BoxShape.circle,
                              border: Border.all(color: _heroBg, width: 2.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullName,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _memberSince,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryForestGreen
                                .withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryForestGreen
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          child: Text(
                            _userSubscriptionLabel.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: _mint,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 4-Column Career Metrics Bar
              Material(
                color: AppColors.backgroundObsidian.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => _openStreakAndAnalyticsSheet(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          _buildHeroStatCell('$_dogsCount', 'DOGS'),
                          const VerticalDivider(
                              width: 1, color: AppColors.cardBorder),
                          _buildHeroStatCell(
                              _formatInt(_sessionsCount), 'SESSIONS'),
                          const VerticalDivider(
                              width: 1, color: AppColors.cardBorder),
                          _buildHeroStatCell('$_goalsCount', 'GOALS'),
                          const VerticalDivider(
                              width: 1, color: AppColors.cardBorder),
                          _buildHeroStatCell(_yearsLabel, 'ULVENIK'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildHeroActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: _openEditProfile,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHeroActionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Change Photo',
                      onTap: _openChangePhotoSheet,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStatCell(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.11),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UlvenikIcon.fromMaterial(icon, color: _sageIcon, size: 16),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _openStreakAndAnalyticsSheet(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _streakIconBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.local_fire_department_outlined,
                  color: _sageIcon,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Training Streak',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$_streakDays Days',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'RECORD',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: _mint,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(width: 2),
              const UlvenikIcon(UlvenikIcons.details,
                color: _mint,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CURRENT PLAN',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryForestGreen
                              .withValues(alpha: 0.45),
                        ),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _mint,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _userSubscriptionLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Renews 28 July 2025',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openSubscriptionSheet,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Manage Subscription',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UlvenikIcon(UlvenikIcons.details,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 19,
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

  Widget _buildSectionTitle(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> rows) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    String? subtitle,
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
              UlvenikIcon.fromMaterial(icon, color: _sageIcon, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const UlvenikIcon(UlvenikIcons.details,
                color: AppColors.secondaryTextStoneGrey,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetContainer({
    required BuildContext sheetCtx,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryTextStoneGrey
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                    icon: const Icon(Icons.close_rounded,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalActionRow({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: color ?? _sageIcon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: color ?? AppColors.primaryTextOffWhite,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details,
              color: AppColors.secondaryTextStoneGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopographicContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final yOffset = 28.0 + i * 48.0;
      path.moveTo(0, yOffset + 20);
      path.cubicTo(
        size.width * 0.28,
        yOffset - 22,
        size.width * 0.64,
        yOffset + 34,
        size.width,
        yOffset - 8,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProfileStreakChartSheet extends StatefulWidget {
  final int streakDays;
  final int dogsCount;
  final int sessionsCount;
  final int goalsCount;
  final int initialSelectedBar;
  final VoidCallback onRecordQuickSession;

  const _ProfileStreakChartSheet({
    required this.streakDays,
    required this.dogsCount,
    required this.sessionsCount,
    required this.goalsCount,
    required this.initialSelectedBar,
    required this.onRecordQuickSession,
  });

  @override
  State<_ProfileStreakChartSheet> createState() =>
      _ProfileStreakChartSheetState();
}

class _ProfileStreakChartSheetState extends State<_ProfileStreakChartSheet>
    with SingleTickerProviderStateMixin {
  static const Color _mint = Color(0xFF95D3BB);

  static const List<(String, int, int)> _fourteenDayHistory = [
    ('M', 2, 45),
    ('T', 3, 65),
    ('W', 1, 30),
    ('T', 4, 85),
    ('F', 2, 50),
    ('S', 5, 110),
    ('S', 3, 70),
    ('M', 2, 48),
    ('T', 3, 62),
    ('W', 4, 88),
    ('T', 2, 42),
    ('F', 3, 75),
    ('S', 5, 115),
    ('Today', 4, 92),
  ];

  late final AnimationController _controller;
  late int _selectedIdx;

  @override
  void initState() {
    super.initState();
    _selectedIdx = widget.initialSelectedBar.clamp(
      0,
      _fourteenDayHistory.length - 1,
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _fourteenDayHistory[_selectedIdx];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryTextStoneGrey
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded,
                    color: _mint,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.streakDays}-Day Training Streak',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.dogsCount} Dogs · ${widget.sessionsCount} Total Sessions · ${widget.goalsCount} Goals Achieved',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundObsidian,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Day ${_selectedIdx + 1} (${selected.$1})',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${selected.$2} sessions · ${selected.$3} min',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: _mint,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 108,
                      child: AnimatedBuilder(
                        animation: CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOutCubic,
                        ),
                        builder: (context, _) {
                          final anim = _controller.value;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int i = 0;
                                  i < _fourteenDayHistory.length;
                                  i++)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedIdx = i);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: (_fourteenDayHistory[i].$3 /
                                                  115.0) *
                                              76.0 *
                                              anim,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 2.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _selectedIdx == i
                                                ? _mint
                                                : AppColors.primaryForestGreen
                                                    .withValues(alpha: 0.65),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          i == 13
                                              ? 'Now'
                                              : _fourteenDayHistory[i].$1,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: _selectedIdx == i
                                                ? _mint
                                                : AppColors
                                                    .secondaryTextStoneGrey,
                                            fontSize: 9.5,
                                            fontWeight: _selectedIdx == i
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onRecordQuickSession,
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  label: const Text(
                    'Record Quick Session (+1 Day Streak)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
