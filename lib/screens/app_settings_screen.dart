import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'login_screen.dart';
import 'open_source_licences_screen.dart';
import 'profile_page_screen.dart';
import 'two_factor_setup_screen.dart';
import 'whats_new_screen.dart';

class _SessionDevice {
  final String name;
  final String details;
  final bool isCurrent;

  const _SessionDevice({
    required this.name,
    required this.details,
    this.isCurrent = false,
  });
}

class AppSettingsScreen extends StatefulWidget {
  final String? subscriptionPlan;
  final bool hasSportPack;
  final bool hasTrainerPack;

  const AppSettingsScreen({
    super.key,
    this.subscriptionPlan,
    this.hasSportPack = false,
    this.hasTrainerPack = true,
  });

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sageIcon = Color(0xFFB6CCB5);
  static const Color _avatarBg = Color(0xFF272B29);
  static const Color _destructiveRed = Color(0xFF9E4747);

  String get _userSubscriptionLabel {
    final override = widget.subscriptionPlan?.trim();
    if (override != null && override.isNotEmpty) return override;
    if (widget.hasSportPack && widget.hasTrainerPack) return 'Complete';
    if (widget.hasTrainerPack) return 'Core + Trainer';
    if (widget.hasSportPack) return 'Core + Sport';
    return 'Core';
  }

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSearch = false;
  String _searchQuery = '';

  // Account identity
  String _userName = 'James Harlow';
  String _userEmail = 'james@example.com';

  // Appearance
  String _appearanceMode = 'Dark Mode';
  bool _reduceMotion = false;

  // Preferences
  String _weightUnit = 'kg';
  String _distanceUnit = 'km';
  String _dateFormat = 'DD/MM/YYYY';
  String _timeFormat = '24-hour';
  String _startOfWeek = 'Monday';
  String _language = 'English';

  // Privacy & Security
  bool _biometricsEnabled = true;
  bool _sessionLockEnabled = true;
  bool _hideSensitivePreviews = false;

  List<_SessionDevice> _activeDevices = const [
    _SessionDevice(
      name: 'iPhone 16 Pro',
      details: 'London, UK · This device',
      isCurrent: true,
    ),
    _SessionDevice(
      name: 'iPad Pro 13"',
      details: 'Surrey, UK · Active 14 min ago',
    ),
  ];

  // Storage & Sync
  double _storageUsedGb = 1.2;
  String _lastSyncedText = '4 min ago';
  bool _wifiOnlySync = true;
  bool _cacheCleared = false;

  // Notifications
  bool _pushNotifications = true;
  bool _quietHours = false;
  bool _trainingReminders = true;
  bool _healthReminders = true;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _userName
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'JH';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get _unitsSubtitle => '$_weightUnit · $_distanceUnit';
  String get _dateTimeSubtitle => '$_dateFormat · $_timeFormat';
  String get _privacySubtitle {
    final parts = <String>[];
    if (_biometricsEnabled) parts.add('Biometric Login');
    if (_sessionLockEnabled) parts.add('Session Management');
    if (parts.isEmpty) return 'Standard Protection';
    return parts.join(' · ');
  }

  String get _sessionsSubtitle => _activeDevices.length == 1
      ? '1 device signed in'
      : '${_activeDevices.length} devices signed in';

  String get _storageSubtitle =>
      '${_storageUsedGb.toStringAsFixed(1)} GB used · Last synced $_lastSyncedText';

  String get _notificationsSubtitle =>
      'Push Notifications: ${_pushNotifications ? 'On' : 'Off'} · Quiet Hours: ${_quietHours ? 'On' : 'Off'}';

  bool _matchesQuery(List<String> terms) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return true;
    return terms.any((t) => t.toLowerCase().contains(q));
  }

  void _openAccountSheet() {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: _buildSheetShell(
            sheetCtx: sheetCtx,
            title: 'Account & Plan',
            subtitle: '$_userSubscriptionLabel · Active Subscription',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetTextField(label: 'Display Name', controller: nameCtrl),
                const SizedBox(height: 12),
                _buildSheetTextField(
                    label: 'Account Email', controller: emailCtrl),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final nextName = nameCtrl.text.trim();
                      final nextEmail = emailCtrl.text.trim();
                      if (nextName.isEmpty || !nextEmail.contains('@')) {
                        AppSnackbar.show(
                          context,
                          title: 'Invalid Details',
                          message:
                              'Please enter a valid display name and email address.',
                          type: SnackbarType.error,
                        );
                        return;
                      }
                      setState(() {
                        _userName = nextName;
                        _userEmail = nextEmail;
                      });
                      Navigator.of(sheetCtx).pop();
                      AppSnackbar.show(
                        context,
                        title: 'Account Updated',
                        message: 'Updated trainer identity for $_userName.',
                        type: SnackbarType.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Account Details',
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
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfilePageScreen(),
                        ),
                      );
                    },
                    icon: const UlvenikIcon(UlvenikIcons.overflowMenu,
                      size: 17,
                      color: _mint,
                    ),
                    label: const Text(
                      'Open Full Profile Page',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: _mint,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.45),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
  }

  void _openAppearanceSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Appearance',
              subtitle: 'Choose theme mode and motion preferences',
              child: Column(
                children: [
                  for (final mode in const [
                    'Dark Mode',
                    'System Default',
                    'High Contrast Dark',
                  ])
                    _buildOptionRadioTile(
                      label: mode,
                      selected: _appearanceMode == mode,
                      onTap: () {
                        setState(() => _appearanceMode = mode);
                        setModalState(() {});
                      },
                    ),
                  const Divider(height: 20, color: AppColors.cardBorder),
                  _buildSwitchTile(
                    label: 'Reduce Motion',
                    subtitle: 'Minimise non-essential UI transitions',
                    value: _reduceMotion,
                    onChanged: (val) {
                      setState(() => _reduceMotion = val);
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
  }

  void _openUnitsSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Units & Measurements',
              subtitle: 'Used across dog weights, GPS tracks, and weather logs',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSegmentedRow(
                    title: 'Weight',
                    options: const ['kg', 'lb'],
                    current: _weightUnit,
                    onSelect: (v) {
                      setState(() => _weightUnit = v);
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildSegmentedRow(
                    title: 'Distance',
                    options: const ['km', 'mi'],
                    current: _distanceUnit,
                    onSelect: (v) {
                      setState(() => _distanceUnit = v);
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
  }

  void _openDateTimeSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Date & Time',
              subtitle: 'Configure calendar and session timestamp formatting',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSegmentedRow(
                    title: 'Date Format',
                    options: const ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'],
                    current: _dateFormat,
                    onSelect: (v) {
                      setState(() => _dateFormat = v);
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildSegmentedRow(
                    title: 'Time Format',
                    options: const ['24-hour', '12-hour'],
                    current: _timeFormat,
                    onSelect: (v) {
                      setState(() => _timeFormat = v);
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildSegmentedRow(
                    title: 'First Day of Week',
                    options: const ['Monday', 'Sunday'],
                    current: _startOfWeek,
                    onSelect: (v) {
                      setState(() => _startOfWeek = v);
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
  }

  void _openLanguageSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Language',
              subtitle: 'Select display language for Ulvenik',
              child: Column(
                children: [
                  for (final lang in const [
                    'English',
                    'English (United Kingdom)',
                    'Deutsch',
                    'Dansk',
                    'Norsk',
                    'Svenska',
                  ])
                    _buildOptionRadioTile(
                      label: lang,
                      selected: _language == lang,
                      onTap: () {
                        setState(() => _language = lang);
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
  }

  void _openPrivacySheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Privacy & Security',
              subtitle: 'Protect workspace records and handler credentials',
              child: Column(
                children: [
                  _buildSwitchTile(
                    label: 'Biometric Login',
                    subtitle: 'Require Face ID or fingerprint on launch',
                    value: _biometricsEnabled,
                    onChanged: (v) {
                      setState(() => _biometricsEnabled = v);
                      setModalState(() {});
                    },
                  ),
                  _buildSwitchTile(
                    label: 'Session Management Lock',
                    subtitle: 'Auto-lock idle sessions after 15 minutes',
                    value: _sessionLockEnabled,
                    onChanged: (v) {
                      setState(() => _sessionLockEnabled = v);
                      setModalState(() {});
                    },
                  ),
                  _buildSwitchTile(
                    label: 'Hide Sensitive Previews',
                    subtitle: 'Mask vet notes in lock-screen notifications',
                    value: _hideSensitivePreviews,
                    onChanged: (v) {
                      setState(() => _hideSensitivePreviews = v);
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(sheetCtx).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TwoFactorSetupScreen(),
                          ),
                        );
                      },
                      icon: const UlvenikIcon(UlvenikIcons.overflowMenu,
                        size: 17,
                        color: _mint,
                      ),
                      label: const Text(
                        'Configure Two-Factor Authentication',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: _mint,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen
                            .withValues(alpha: 0.18),
                        side: BorderSide(
                          color: AppColors.primaryForestGreen
                              .withValues(alpha: 0.45),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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

  void _openActiveSessionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Active Sessions',
              subtitle: _sessionsSubtitle,
              child: Column(
                children: [
                  for (final device in _activeDevices)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundObsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          UlvenikIcon.fromMaterial(
                            device.isCurrent
                                ? Icons.phone_iphone_rounded
                                : Icons.tablet_mac_rounded,
                            color: _sageIcon,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  device.details,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (device.isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryForestGreen
                                    .withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _mint,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          else
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _activeDevices = _activeDevices
                                      .where((d) => d != device)
                                      .toList();
                                });
                                setModalState(() {});
                                AppSnackbar.show(
                                  context,
                                  title: 'Session Revoked',
                                  message: 'Signed out ${device.name}.',
                                  type: SnackbarType.info,
                                );
                              },
                              child: const Text(
                                'Revoke',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: _destructiveRed,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
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

  void _openStorageSyncSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _StorageSyncSheetBody(
          usedGb: _storageUsedGb,
          lastSyncedText: _lastSyncedText,
          subscriptionLabel: _userSubscriptionLabel,
          wifiOnly: _wifiOnlySync,
          onWifiOnlyChanged: (val) {
            setState(() => _wifiOnlySync = val);
          },
          onSyncNow: () {
            setState(() => _lastSyncedText = 'just now');
            AppSnackbar.show(
              context,
              title: 'Cloud Sync Complete',
              message: 'All training sessions and health records are synced.',
              type: SnackbarType.success,
            );
          },
        );
      },
    );
  }

  void _openNotificationsSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return _buildSheetShell(
              sheetCtx: sheetCtx,
              title: 'Notifications',
              subtitle: 'Manage push alerts and quiet hours schedule',
              child: Column(
                children: [
                  _buildSwitchTile(
                    label: 'Push Notifications',
                    subtitle: 'Deliver instant alerts to this device',
                    value: _pushNotifications,
                    onChanged: (v) {
                      setState(() => _pushNotifications = v);
                      setModalState(() {});
                    },
                  ),
                  _buildSwitchTile(
                    label: 'Quiet Hours (22:00 – 07:00)',
                    subtitle: 'Mute non-urgent notifications overnight',
                    value: _quietHours,
                    onChanged: (v) {
                      setState(() => _quietHours = v);
                      setModalState(() {});
                    },
                  ),
                  _buildSwitchTile(
                    label: 'Training & Plan Reminders',
                    subtitle: 'Scheduled sessions and client homework updates',
                    value: _trainingReminders,
                    onChanged: (v) {
                      setState(() => _trainingReminders = v);
                      setModalState(() {});
                    },
                  ),
                  _buildSwitchTile(
                    label: 'Health & Vaccination Alerts',
                    subtitle: 'Upcoming boosters, medications, and vet visits',
                    value: _healthReminders,
                    onChanged: (v) {
                      setState(() => _healthReminders = v);
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
  }

  void _openSupportActionSheet({
    required String title,
    required String subtitle,
    required String hint,
    required String buttonLabel,
  }) {
    final msgCtrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: _buildSheetShell(
            sheetCtx: sheetCtx,
            title: title,
            subtitle: subtitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: msgCtrl,
                  maxLines: 4,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13.5,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundObsidian,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _mint.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (msgCtrl.text.trim().isEmpty) {
                        AppSnackbar.show(
                          context,
                          title: 'Message Required',
                          message: 'Please enter details before submitting.',
                          type: SnackbarType.warning,
                        );
                        return;
                      }
                      Navigator.of(sheetCtx).pop();
                      AppSnackbar.show(
                        context,
                        title: 'Submitted',
                        message:
                            'Your $title submission has been sent to the Ulvenik team.',
                        type: SnackbarType.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.primaryTextOffWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
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
  }

  void _openAboutOrLegalSheet({required bool isLegal}) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetShell(
          sheetCtx: sheetCtx,
          title: isLegal ? 'Legal' : 'About Ulvenik',
          subtitle: isLegal
              ? 'Privacy Policy · Terms & Conditions · Attribution'
              : 'Version 1.0.0 (Build 42) · Precision Dog Training Platform',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLegal
                    ? 'Your training logs, dog health records, and client workspace data remain encrypted in transit and at rest. Ulvenik never sells personal or canine telemetry data.'
                    : 'Ulvenik is crafted for handlers, sport dog competitors, and professional trainers to track training progression, canine conditioning, and health history.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OpenSourceLicencesScreen(),
                      ),
                    );
                  },
                  icon: const UlvenikIcon(UlvenikIcons.overflowMenu, size: 17, color: _mint),
                  label: const Text(
                    'View Open Source Licences',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: _mint,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryForestGreen.withValues(alpha: 0.18),
                    side: BorderSide(
                      color:
                          AppColors.primaryForestGreen.withValues(alpha: 0.45),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  void _confirmResetPreferences() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetShell(
          sheetCtx: sheetCtx,
          title: 'Reset Preferences?',
          subtitle:
              'This restores default appearance, units (kg · km · °C), date format, and notification toggles. Your dog records will not be affected.',
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
                    setState(() {
                      _appearanceMode = 'Dark Mode';
                      _reduceMotion = false;
                      _weightUnit = 'kg';
                      _distanceUnit = 'km';
                      _dateFormat = 'DD/MM/YYYY';
                      _timeFormat = '24-hour';
                      _startOfWeek = 'Monday';
                      _language = 'English';
                      _pushNotifications = true;
                      _quietHours = false;
                    });
                    Navigator.of(sheetCtx).pop();
                    AppSnackbar.show(
                      context,
                      title: 'Preferences Reset',
                      message:
                          'Default appearance and display settings restored.',
                      type: SnackbarType.success,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reset Defaults',
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

  void _confirmClearCache() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetShell(
          sheetCtx: sheetCtx,
          title: 'Clear Cached Data?',
          subtitle: _cacheCleared
              ? 'Temporary cache is already clean (0 MB).'
              : 'Frees ~200 MB of temporary media thumbnails. All training sessions, videos, and health records stay safe.',
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
                    setState(() {
                      _cacheCleared = true;
                      _storageUsedGb = 1.0;
                    });
                    Navigator.of(sheetCtx).pop();
                    AppSnackbar.show(
                      context,
                      title: 'Cache Cleared',
                      message:
                          'Temporary files removed. Storage reduced to 1.0 GB.',
                      type: SnackbarType.success,
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
                    'Clear Cache',
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

  void _confirmSignOut() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return _buildSheetShell(
          sheetCtx: sheetCtx,
          title: 'Sign Out of Ulvenik?',
          subtitle:
              'Your synced records remain safe in the cloud. You can sign back in as $_userEmail anytime.',
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
                    'Stay Signed In',
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
    final showAppearance =
        _matchesQuery(['Appearance', _appearanceMode, 'Dark Mode', 'Theme']);
    final showPreferences = _matchesQuery([
      'Preferences',
      'Units & Measurements',
      _unitsSubtitle,
      'Date & Time',
      _dateTimeSubtitle,
      'Language',
      _language,
    ]);
    final showPrivacy = _matchesQuery([
      'Privacy & Security',
      _privacySubtitle,
      'Active Sessions',
      _sessionsSubtitle,
      'Biometric Login',
    ]);
    final showStorage =
        _matchesQuery(['Storage & Sync', _storageSubtitle, 'Cloud']);
    final showNotifications =
        _matchesQuery(['Notifications', _notificationsSubtitle, 'Quiet Hours']);
    final showSupport = _matchesQuery([
      'Support',
      'Help Centre',
      'Contact Support',
      'Report a Bug',
      'Feature Requests',
    ]);
    final showAbout = _matchesQuery([
      'About Ulvenik',
      "What's New",
      'Legal',
      'Privacy Policy',
      'Terms & Conditions',
    ]);
    final showAdvanced = _matchesQuery([
      'Advanced',
      'Reset Preferences',
      'Clear Cached Data',
      'Sign Out',
    ]);

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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const UlvenikIcon(UlvenikIcons.back,
                        color: AppColors.secondaryTextStoneGrey,
                        size: 26,
                      ),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Settings',
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
                      onPressed: () {
                        setState(() {
                          _showSearch = !_showSearch;
                          if (!_showSearch) {
                            _searchController.clear();
                            _searchQuery = '';
                          }
                        });
                        if (_showSearch) {
                          _searchFocusNode.requestFocus();
                        }
                      },
                      tooltip: 'Search Settings',
                      icon: UlvenikIcon(UlvenikIcons.search,
                        color: _showSearch
                            ? _mint
                            : AppColors.secondaryTextStoneGrey,
                        size: 22,
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
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showSearch) ...[
              Container(
                height: 46,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const UlvenikIcon(UlvenikIcons.search,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 14,
                        ),
                        cursorColor: _mint,
                        decoration: const InputDecoration(
                          hintText: 'Search Settings...',
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        child: const UlvenikIcon(UlvenikIcons.back,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            _buildAccountCard(),
            if (showAppearance) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('APPEARANCE'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: _appearanceMode,
                  onTap: _openAppearanceSheet,
                ),
              ]),
            ],
            if (showPreferences) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('PREFERENCES'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.straighten_rounded,
                  title: 'Units & Measurements',
                  subtitle: _unitsSubtitle,
                  onTap: _openUnitsSheet,
                ),
                _buildSettingsRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'Date & Time',
                  subtitle: _dateTimeSubtitle,
                  onTap: _openDateTimeSheet,
                ),
                _buildSettingsRow(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: _language,
                  onTap: _openLanguageSheet,
                ),
              ]),
            ],
            if (showPrivacy) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('PRIVACY & SECURITY'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Security',
                  subtitle: _privacySubtitle,
                  onTap: _openPrivacySheet,
                ),
                _buildSettingsRow(
                  icon: Icons.devices_rounded,
                  title: 'Active Sessions',
                  subtitle: _sessionsSubtitle,
                  onTap: _openActiveSessionsSheet,
                ),
              ]),
            ],
            if (showStorage) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('STORAGE'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.cloud_outlined,
                  title: 'Storage & Sync',
                  subtitle: _storageSubtitle,
                  onTap: _openStorageSyncSheet,
                ),
              ]),
            ],
            if (showNotifications) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('NOTIFICATIONS'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: _notificationsSubtitle,
                  onTap: _openNotificationsSheet,
                ),
              ]),
            ],
            if (showSupport) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('SUPPORT'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Centre',
                  onTap: () => _openSupportActionSheet(
                    title: 'Help Centre',
                    subtitle:
                        'Search guides on multi-dog workspaces, offline field mode, and training analytics.',
                    hint: 'Ask a question or describe what you need help with...',
                    buttonLabel: 'Send Help Inquiry',
                  ),
                ),
                _buildSettingsRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Contact Support',
                  onTap: () => _openSupportActionSheet(
                    title: 'Contact Support',
                    subtitle:
                        '$_userSubscriptionLabel support · Typical response within 24 hours.',
                    hint: 'How can our support team assist you today?',
                    buttonLabel: 'Send Message',
                  ),
                ),
                _buildSettingsRow(
                  icon: Icons.warning_amber_rounded,
                  title: 'Report a Bug',
                  onTap: () => _openSupportActionSheet(
                    title: 'Report a Bug',
                    subtitle:
                        'Include steps to reproduce so our engineering team can investigate.',
                    hint: 'Describe what happened and what you expected...',
                    buttonLabel: 'Submit Bug Report',
                  ),
                ),
                _buildSettingsRow(
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Feature Requests',
                  onTap: () => _openSupportActionSheet(
                    title: 'Feature Requests',
                    subtitle:
                        'Suggest sport modules, analytics metrics, or trainer workflow tools.',
                    hint: 'Share your feature idea for Ulvenik...',
                    buttonLabel: 'Submit Feature Idea',
                  ),
                ),
              ]),
            ],
            if (showAbout) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('ABOUT'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.info_outline_rounded,
                  title: 'About Ulvenik',
                  subtitle: 'Version 1.0.0 (Build 42)',
                  onTap: () => _openAboutOrLegalSheet(isLegal: false),
                ),
                _buildSettingsRow(
                  icon: Icons.auto_awesome_outlined,
                  title: "What's New",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const WhatsNewScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsRow(
                  icon: Icons.description_outlined,
                  title: 'Legal',
                  subtitle: 'Privacy Policy · Terms & Conditions',
                  onTap: () => _openAboutOrLegalSheet(isLegal: true),
                ),
              ]),
            ],
            if (showAdvanced) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('ADVANCED'),
              const SizedBox(height: 8),
              _buildGroupCard([
                _buildSettingsRow(
                  icon: Icons.refresh_rounded,
                  title: 'Reset Preferences',
                  subtitle: 'Restore default appearance and display settings',
                  onTap: _confirmResetPreferences,
                ),
                _buildSettingsRow(
                  icon: Icons.delete_outline_rounded,
                  iconColor: _destructiveRed,
                  title: 'Clear Cached Data',
                  titleColor: _destructiveRed,
                  subtitle: _cacheCleared
                      ? 'Cache cleared (0 MB temporary files).'
                      : 'Removes temporary files. Your records stay safe.',
                  onTap: _confirmClearCache,
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
            const SizedBox(height: 28),
            Center(
              child: Text(
                'Ulvenik · v1.0.0 · © 2025 Ulvenik Ltd',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
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

  Widget _buildAccountCard() {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _openAccountSheet,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(6),
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
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const UlvenikIcon(UlvenikIcons.details,
                color: AppColors.secondaryTextStoneGrey,
                size: 20,
              ),
            ],
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
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.4,
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

  Widget _buildSettingsRow({
    required IconData icon,
    Color? iconColor,
    required String title,
    Color? titleColor,
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
              UlvenikIcon.fromMaterial(
                icon,
                color: iconColor ?? _sageIcon,
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: titleColor ?? AppColors.primaryTextOffWhite,
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
                          fontSize: 13,
                          height: 1.35,
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

  Widget _buildSheetShell({
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
                    icon: const UlvenikIcon(UlvenikIcons.back,
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
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.primaryTextOffWhite,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundObsidian,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _mint.withValues(alpha: 0.6)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionRadioTile({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: selected ? _mint : AppColors.primaryTextOffWhite,
                  fontSize: 14.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            UlvenikIcon.fromMaterial(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? _mint : AppColors.secondaryTextStoneGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primaryForestGreen,
            activeThumbColor: _mint,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedRow({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            final isSelected = opt == current;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: opt == options.last ? 0 : 8,
                ),
                child: GestureDetector(
                  onTap: () => onSelect(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryForestGreen.withValues(alpha: 0.25)
                          : AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? _mint.withValues(alpha: 0.55)
                            : AppColors.cardBorder,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: isSelected
                            ? _mint
                            : AppColors.secondaryTextStoneGrey,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StorageSyncSheetBody extends StatefulWidget {
  final double usedGb;
  final String lastSyncedText;
  final String subscriptionLabel;
  final bool wifiOnly;
  final ValueChanged<bool> onWifiOnlyChanged;
  final VoidCallback onSyncNow;

  const _StorageSyncSheetBody({
    required this.usedGb,
    required this.lastSyncedText,
    required this.subscriptionLabel,
    required this.wifiOnly,
    required this.onWifiOnlyChanged,
    required this.onSyncNow,
  });

  @override
  State<_StorageSyncSheetBody> createState() => _StorageSyncSheetBodyState();
}

class _StorageSyncSheetBodyState extends State<_StorageSyncSheetBody>
    with SingleTickerProviderStateMixin {
  static const Color _mint = Color(0xFF95D3BB);

  late final AnimationController _animController;
  late bool _wifiOnly;
  late String _syncedLabel;
  bool _syncing = false;
  int _selectedSegment = -1;

  @override
  void initState() {
    super.initState();
    _wifiOnly = widget.wifiOnly;
    _syncedLabel = widget.lastSyncedText;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segments = [
      ('Training Videos', 0.68, AppColors.primaryForestGreen),
      ('Session Photos', 0.32, AppColors.infoAlpineBlue),
      ('Health & Offline Docs', 0.20, AppColors.secondarySage),
    ];

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
                  const Expanded(
                    child: Text(
                      'Storage & Sync',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const UlvenikIcon(UlvenikIcons.back,
                      color: AppColors.secondaryTextStoneGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.usedGb.toStringAsFixed(1)} GB of 10 GB ${widget.subscriptionLabel} Cloud · Last synced $_syncedLabel',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              AnimatedBuilder(
                animation: CurvedAnimation(
                  parent: _animController,
                  curve: Curves.easeOutCubic,
                ),
                builder: (context, _) {
                  final progress = _animController.value;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 14,
                      color: AppColors.backgroundObsidian,
                      child: Row(
                        children: [
                          for (int i = 0; i < segments.length; i++)
                            Flexible(
                              flex: ((segments[i].$2 * 100 * progress).round())
                                  .clamp(1, 100),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSegment =
                                        _selectedSegment == i ? -1 : i;
                                  });
                                },
                                child: Container(
                                  height: 14,
                                  margin: const EdgeInsets.only(right: 2),
                                  color: _selectedSegment == i
                                      ? _mint
                                      : segments[i].$3,
                                ),
                              ),
                            ),
                          const Spacer(flex: 65),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  for (int i = 0; i < segments.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSegment = _selectedSegment == i ? -1 : i;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _selectedSegment == i
                                  ? _mint
                                  : segments[i].$3,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${segments[i].$1} (${segments[i].$2.toStringAsFixed(2)} GB)',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _selectedSegment == i
                                  ? AppColors.primaryTextOffWhite
                                  : AppColors.secondaryTextStoneGrey,
                              fontSize: 11.5,
                              fontWeight: _selectedSegment == i
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sync Large Videos on Wi-Fi Only',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pause HD video uploads on mobile data',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _wifiOnly,
                    activeTrackColor: AppColors.primaryForestGreen,
                    activeThumbColor: _mint,
                    onChanged: (v) {
                      setState(() => _wifiOnly = v);
                      widget.onWifiOnlyChanged(v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _syncing
                      ? null
                      : () async {
                          setState(() => _syncing = true);
                          await Future<void>.delayed(
                              const Duration(milliseconds: 600));
                          if (!mounted) return;
                          setState(() {
                            _syncing = false;
                            _syncedLabel = 'just now';
                          });
                          widget.onSyncNow();
                        },
                  icon: _syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryTextOffWhite,
                          ),
                        )
                      : const UlvenikIcon(UlvenikIcons.history, size: 18),
                  label: Text(
                    _syncing ? 'Syncing Workspace...' : 'Sync Now',
                    style: const TextStyle(
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
