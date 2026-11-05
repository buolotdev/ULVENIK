import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'about_ulvenik_screen.dart';
import 'appearance_settings_screen.dart';
import 'backup_sync_screen.dart';
import 'billing_history_screen.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';
import 'change_photo_screen.dart';
import 'contact_support_screen.dart';
import 'country_region_screen.dart';
import 'date_time_format_screen.dart';
import 'delete_account_screen.dart';
import 'edit_profile_screen.dart';
import 'export_my_data_screen.dart';
import 'feature_requests_screen.dart';
import 'goals_list_screen.dart';
import 'help_centre_screen.dart';
import 'language_settings_screen.dart';
import 'measurement_units_screen.dart';
import 'my_dogs_screen.dart';
import 'notification_settings_screen.dart';
import 'offline_mode_screen.dart';
import 'open_source_licences_screen.dart';
import 'privacy_policy_screen.dart';
import 'profile_page_screen.dart';
import 'report_bug_screen.dart';
import 'restore_purchases_screen.dart';
import 'storage_management_screen.dart';
import 'subscription_details_screen.dart';
import 'terms_conditions_screen.dart';
import 'timezone_settings_screen.dart';
import 'whats_new_screen.dart';

class MoreDashboardScreen extends StatefulWidget {
  const MoreDashboardScreen({super.key});

  @override
  State<MoreDashboardScreen> createState() => _MoreDashboardScreenState();
}

class _MoreDashboardScreenState extends State<MoreDashboardScreen>
    with SingleTickerProviderStateMixin {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _destructiveText = Color(0xFFA84646);

  late final AnimationController _kpiAnimController;
  late final Animation<double> _kpiAnim;

  String _userName = 'Ruby Old';
  String _userEmail = 'ruby@email.com';
  final String _subscriptionPlan = 'Core + Trainer';
  final Color _avatarBgColor = _sage;

  final int _dogsCount = 3;
  final int _activeGoalsCount = 5;
  List<(String, String)> _activeDevices = [
    ('iPhone 16 Pro', 'This device · Active now'),
    ('iPad Air M2', 'Field tablet · Last seen 14m ago'),
  ];
  bool _isSyncing = false;
  String _lastSyncedSubtitle = 'Last synced 2 minutes ago';

  // Preferences state
  int _enabledNotificationsCount = 12;
  String _appearanceMode = 'Dark Mode';
  String _language = 'English';
  String _country = 'United Kingdom';
  String _timeZone = 'GMT+0';
  final String _measurementUnits = 'Metric';
  String _storageUsedLabel = '2.4 GB used';

  @override
  void initState() {
    super.initState();
    _kpiAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _kpiAnim = CurvedAnimation(
      parent: _kpiAnimController,
      curve: Curves.easeOutCubic,
    );
    _kpiAnimController.forward();
  }

  @override
  void dispose() {
    _kpiAnimController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _userName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'RO';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // Navigation hooks — wired progressively as Screens 8–12 are built
  Future<void> _openNotifications() async {
    final res = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
    );
    if (res != null && mounted) {
      setState(() => _enabledNotificationsCount = res ? 12 : 0);
    }
  }

  Future<void> _openAppearance() async {
    final res = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen()),
    );
    if (res != null && mounted) {
      setState(() => _appearanceMode = res);
    }
  }

  Future<void> _openBackupSync() async {
    final res = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BackupSyncScreen()),
    );
    if (res != null && mounted) {
      setState(() => _lastSyncedSubtitle = 'Last synced $res');
    }
  }

  void _openOfflineDownloads() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OfflineModeScreen()),
    );
  }

  Future<void> _openStorageManagement() async {
    final res = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const StorageManagementScreen()),
    );
    if (res != null && mounted) {
      setState(() => _storageUsedLabel = '$res used');
    }
  }

  Future<void> _triggerQuickCloudSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _lastSyncedSubtitle = 'Last synced just now';
    });
    AppSnackbar.show(
      context,
      title: 'Cloud Sync Complete',
      message: 'All 3 dog workspaces and 5 active goals are up to date.',
      type: SnackbarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroProfileCard(),
                    const SizedBox(height: 14),
                    _buildKpiGrid(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ACCOUNT'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Edit Profile',
                          onTap: _openEditProfile,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.play,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Change Profile Photo',
                          onTap: _openChangePhoto,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Change Email Address',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ChangeEmailScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Change Password',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Export My Data',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ExportMyDataScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.back,
                            color: _destructiveText,
                            size: 20,
                          ),
                          title: 'Delete Account',
                          titleColor: _destructiveText,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DeleteAccountScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('SUBSCRIPTION'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Subscription Details',
                          subtitle: '$_subscriptionPlan · Active',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionDetailsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.training,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Billing History',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BillingHistoryScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.history,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Restore Purchases',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RestorePurchasesScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('PREFERENCES'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Notifications',
                          subtitle: '$_enabledNotificationsCount enabled',
                          onTap: _openNotifications,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.edit,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Appearance',
                          subtitle: _appearanceMode,
                          onTap: _openAppearance,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Language',
                          subtitle: _language,
                          onTap: () async {
                            final res = await Navigator.of(context).push<String>(
                              MaterialPageRoute(
                                builder: (_) => const LanguageSettingsScreen(),
                              ),
                            );
                            if (res != null && mounted) {
                              setState(() => _language = res);
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.timeline,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Country',
                          subtitle: _country,
                          onTap: () async {
                            final res = await Navigator.of(context).push<String>(
                              MaterialPageRoute(
                                builder: (_) => const CountryRegionScreen(),
                              ),
                            );
                            if (res != null && mounted) {
                              setState(() => _country = res);
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.trainingTime,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Time Zone',
                          subtitle: _timeZone,
                          onTap: () async {
                            final res = await Navigator.of(context).push<String>(
                              MaterialPageRoute(
                                builder: (_) => const TimezoneSettingsScreen(),
                              ),
                            );
                            if (res != null && mounted) {
                              setState(() => _timeZone = res);
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.calendar,
                            color: _stoneGrey,
                            size: 19,
                          ),
                          title: 'Date & Time Format',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const DateTimeFormatScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: Transform.rotate(
                            angle: -math.pi / 4,
                            child: const UlvenikIcon(UlvenikIcons.exercises,
                              color: _stoneGrey,
                              size: 20,
                            ),
                          ),
                          title: 'Measurement Units',
                          subtitle: _measurementUnits,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MeasurementUnitsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('DATA & STORAGE'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Backup & Sync',
                          subtitle: _lastSyncedSubtitle,
                          onTap: _openBackupSync,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.details,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Offline Downloads',
                          onTap: _openOfflineDownloads,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Storage Management',
                          subtitle: _storageUsedLabel,
                          onTap: _openStorageManagement,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('HELP'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Help Centre',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HelpCentreScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 19,
                          ),
                          title: 'Contact Support',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ContactSupportScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Report a Bug',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReportBugScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Feature Requests',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FeatureRequestsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ABOUT'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'About Ulvenik',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AboutUlvenikScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.skills,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: "What's New",
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WhatsNewScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.overflowMenu,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Privacy Policy',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.training,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Terms & Conditions',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TermsConditionsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.training,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Licences',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OpenSourceLicencesScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Ulvenik v1.0.0',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _stoneGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '© Ulvenik',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: _stoneGrey.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (Navigator.of(context).canPop())
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: UlvenikIcon(UlvenikIcons.back,
                    color: _offWhite,
                    size: 26,
                  ),
                ),
              ),
            ),
          const Text(
            'More',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _offWhite,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _openChangePhoto,
                child: Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _offWhite.withValues(alpha: 0.12),
                      width: 1.5,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _avatarBgColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProfilePageScreen(),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _offWhite,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: _stoneGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _forest.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _forest.withValues(alpha: 0.38),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _subscriptionPlan,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: _obsidian.withValues(alpha: 0.55),
                side: BorderSide(
                  color: _forest.withValues(alpha: 0.65),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _openEditProfile,
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _forest,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid() {
    return AnimatedBuilder(
      animation: _kpiAnim,
      builder: (context, _) {
        final dogsVal = (_dogsCount * _kpiAnim.value).round();
        final goalsVal = (_activeGoalsCount * _kpiAnim.value).round();
        final devicesVal = (_activeDevices.length * _kpiAnim.value).round();

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    icon: Icons.pets_outlined,
                    valueText: '$dogsVal',
                    label: 'Dogs',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MyDogsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    icon: Icons.track_changes_rounded,
                    valueText: '$goalsVal',
                    label: 'Active Goals',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const GoalsListScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    icon: Icons.smartphone_rounded,
                    valueText: '$devicesVal',
                    label: 'Active Devices',
                    onTap: _showActiveDevicesSheet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    icon: Icons.cloud_done_outlined,
                    valueText: _isSyncing ? 'Syncing…' : 'Synced',
                    valueColor: _forest,
                    label: 'Cloud Sync',
                    onTap: _triggerQuickCloudSync,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String valueText,
    Color valueColor = _offWhite,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UlvenikIcon.fromMaterial(icon, color: _sage, size: 18),
              const SizedBox(height: 8),
              Text(
                valueText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _stoneGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
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

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: _cardBorder);
  }

  Widget _buildMenuRow({
    required Widget iconWidget,
    required String title,
    Color titleColor = _offWhite,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: subtitle != null ? 13 : 16,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(child: iconWidget),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: _stoneGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Interactive Bottom Sheets ──────────────────────────────────────────────

  Future<void> _openEditProfile() async {
    final nameParts = _userName.trim().split(RegExp(r'\s+'));
    final first = nameParts.isNotEmpty ? nameParts.first : 'Ruby';
    final last =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Old';

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialFirstName: first,
          initialLastName: last,
          initialDisplayName: _userName,
          initialEmail: _userEmail,
          initialCountry: _country,
          initialLanguage: _language,
          initialTimeZone: _timeZone,
        ),
      ),
    );
    if (res != null && mounted) {
      setState(() {
        if (res['fullName'] is String &&
            (res['fullName'] as String).trim().isNotEmpty) {
          _userName = (res['fullName'] as String).trim();
        }
        if (res['email'] is String &&
            (res['email'] as String).trim().isNotEmpty) {
          _userEmail = (res['email'] as String).trim();
        }
        if (res['country'] is String &&
            (res['country'] as String).trim().isNotEmpty) {
          _country = (res['country'] as String).trim();
        }
        if (res['language'] is String &&
            (res['language'] as String).trim().isNotEmpty) {
          _language = (res['language'] as String).trim();
        }
        if (res['timeZone'] is String &&
            (res['timeZone'] as String).trim().isNotEmpty) {
          _timeZone = (res['timeZone'] as String).trim();
        }
      });
    }
  }

  void _openChangePhoto() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const ChangePhotoScreen(),
      ),
    );
  }

  void _showActiveDevicesSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                    const Text(
                      'Active Devices',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._activeDevices.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final dev = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _obsidian,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Row(
                            children: [
                              const UlvenikIcon(UlvenikIcons.overflowMenu,
                                color: _sage,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dev.$1,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _offWhite,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dev.$2,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: _stoneGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (idx > 0)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _activeDevices =
                                          List.of(_activeDevices)..removeAt(idx);
                                    });
                                    setSheetState(() {});
                                    AppSnackbar.show(
                                      context,
                                      title: 'Device Signed Out',
                                      message: 'Revoked session for ${dev.$1}.',
                                      type: SnackbarType.info,
                                    );
                                  },
                                  child: const Text(
                                    'Revoke',
                                    style: TextStyle(
                                      color: _destructiveText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 38,
        height: 4,
        decoration: BoxDecoration(
          color: _stoneGrey.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
