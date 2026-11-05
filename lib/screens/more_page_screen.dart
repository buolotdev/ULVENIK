import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'about_ulvenik_screen.dart';
import 'app_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'backup_sync_screen.dart';
import 'billing_history_screen.dart';
import 'contact_support_screen.dart';
import 'country_region_screen.dart';
import 'date_time_format_screen.dart';
import 'edit_profile_screen.dart';
import 'feature_requests_screen.dart';
import 'global_calendar_screen.dart';
import 'global_search_screen.dart';
import 'help_centre_screen.dart';
import 'language_settings_screen.dart';
import 'measurement_units_screen.dart';
import 'media_library_screen.dart';
import 'more_dashboard_screen.dart';
import 'notification_settings_screen.dart';
import 'notifications_page_screen.dart';
import 'offline_mode_screen.dart';
import 'open_source_licences_screen.dart';
import 'privacy_policy_screen.dart';
import 'profile_page_screen.dart';
import 'report_bug_screen.dart';
import 'rewards_management_screen.dart';
import 'sport_pack_overview_screen.dart';
import 'certificates_documents_screen.dart';
import 'storage_management_screen.dart';
import 'subscription_details_screen.dart';
import 'terms_conditions_screen.dart';
import 'timezone_settings_screen.dart';
import 'trainer_dashboard_screen.dart';
import 'trainer_reports_screen.dart';
import 'trainer_workspace_settings_screen.dart';
import 'whats_new_screen.dart';

class MorePageScreen extends StatefulWidget {
  final bool isCloudSyncAvailable;

  const MorePageScreen({
    super.key,
    this.isCloudSyncAvailable = true,
  });

  @override
  State<MorePageScreen> createState() => _MorePageScreenState();
}

class _MorePageScreenState extends State<MorePageScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _destructive = Color(0xFF8B3A3A);
  static const Color _destructiveText = Color(0xFFB55454);

  String _userName = 'Ruby Old';
  String _userEmail = 'ruby@email.com';
  String _subscriptionPlan = 'Core + Trainer';
  bool get _hasSportPack =>
      _subscriptionPlan.contains('Sport') || _subscriptionPlan == 'Complete';
  String _appearanceLabel = 'Dark Mode';
  bool _notificationsEnabled = false;
  bool _emailVerified = false;
  String _syncStatusLabel = 'Fully Synced';
  bool _biometricLock = true;

  @override
  void initState() {
    super.initState();
    UlvenikBottomNav.globalMoreScreenBuilder = (_) => const MorePageScreen();
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

  // Navigation hooks — wired progressively as Screens 7–12 are built
  void _onTapProfileCard() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MoreDashboardScreen()),
    );
  }

  void _onTapAccountSettings() {
    _showAccountSettingsSheet();
  }

  Future<void> _onTapAppearance() async {
    final res = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen()),
    );
    if (res != null && mounted) {
      setState(() => _appearanceLabel = res);
    }
  }

  Future<void> _onTapNotifications() async {
    final res = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
    );
    if (res != null && mounted) {
      setState(() => _notificationsEnabled = res);
    }
  }

  void _onTapPrivacySecurity() {
    _showPrivacySecuritySheet();
  }

  void _onTapSubscription() {
    _showSubscriptionSheet();
  }

  void _onTapStorageAndSync() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                  widget.isCloudSyncAvailable
                      ? 'Offline Storage & Cloud Sync'
                      : 'Offline Storage',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isCloudSyncAvailable
                      ? 'Status: $_syncStatusLabel · Local-first encrypted storage'
                      : 'Local-first encrypted device storage',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.isCloudSyncAvailable) ...[
                  _buildSheetActionTile(
                    icon: Icons.cloud_sync_outlined,
                    title: 'Backup & Sync',
                    subtitle:
                        'Cloud sync controls, manual sync & connected devices',
                    onTap: () async {
                      Navigator.of(sheetCtx).pop();
                      final res = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => const BackupSyncScreen(),
                        ),
                      );
                      if (res != null && mounted) {
                        setState(() => _syncStatusLabel = 'Fully Synced');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                _buildSheetActionTile(
                  icon: Icons.download_for_offline_outlined,
                  title: 'Offline Mode & Downloads',
                  subtitle: 'Select offline modules, media quality & field packs',
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OfflineModeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildSheetActionTile(
                  icon: Icons.folder_outlined,
                  title: 'Storage Management',
                  subtitle: 'Inspect breakdown, clear cache & optimise database',
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StorageManagementScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UlvenikBottomNav.globalMoreScreenBuilder = (_) => const MorePageScreen();
    final isInsideMainLayout =
        context.findAncestorWidgetOfExactType<Scaffold>() != null;

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
                padding: EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  isInsideMainLayout ? 36 : 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('ACCOUNT'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.account_circle_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Account Settings',
                          onTap: _onTapAccountSettings,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const _SwatchBookIcon(color: _stoneGrey),
                          title: 'Appearance',
                          subtitle: _appearanceLabel,
                          onTap: _onTapAppearance,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Notifications',
                          trailingBadge: _buildStatusPill(
                            label: _notificationsEnabled ? 'On' : 'Off',
                            isAlert: !_notificationsEnabled,
                          ),
                          onTap: _onTapNotifications,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const _ShieldBoltIcon(color: _stoneGrey),
                          title: 'Privacy & Security',
                          trailingBadge: _buildStatusPill(
                            label: _emailVerified
                                ? 'Verified'
                                : 'Email Not Verified',
                            isAlert: !_emailVerified,
                          ),
                          onTap: _onTapPrivacySecurity,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('SUBSCRIPTION'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.credit_card_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Subscription Management',
                          subtitle: '$_subscriptionPlan · Active',
                          onTap: _onTapSubscription,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('STORAGE'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: UlvenikIcon.fromMaterial(
                            widget.isCloudSyncAvailable
                                ? Icons.cloud_sync_outlined
                                : Icons.storage_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: widget.isCloudSyncAvailable
                              ? 'Offline Storage & Cloud Sync'
                              : 'Offline Storage',
                          trailingBadge: widget.isCloudSyncAvailable
                              ? Text(
                                  _syncStatusLabel,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _forest,
                                  ),
                                )
                              : null,
                          onTap: _onTapStorageAndSync,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('SUPPORT'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.support_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Help & Support',
                          onTap: _showHelpSupportSheet,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.chat_bubble_outline_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Feedback & Feature Requests',
                          onTap: _showFeedbackSheet,
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.info_outline_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'About Ulvenik',
                          subtitle: 'Version 1.0.0',
                          onTap: _showAboutSheet,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('WORKSPACE & PACKS'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.person_outline_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Profile',
                          subtitle: 'Handler profile, streak & packs',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfilePageScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.settings_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Settings',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AppSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Notifications Inbox',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsPageScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.search,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Global Search',
                          onTap: () => Navigator.of(
                            context,
                            rootNavigator: true,
                          ).push(
                            MaterialPageRoute(
                              builder: (_) => const GlobalSearchScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.calendar,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Calendar',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const GlobalCalendarScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.photo_library_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Media Library',
                          subtitle: 'Photos, videos, documents & collections',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MediaLibraryScreen(
                                hasSportPack: _hasSportPack,
                              ),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.emoji_events_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Sport Pack Overview',
                          subtitle: 'Sports, trials, results & qualifications',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SportPackOverviewScreen(
                                hasSportPack: _hasSportPack,
                              ),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.folder_shared_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Certificates & Documents',
                          subtitle: 'Official registrations, scorebooks & records',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CertificatesDocumentsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.badge_outlined,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Trainer Dashboard',
                          subtitle: 'Clients, homework, progress & reports',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TrainerDashboardScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.training,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Trainer Reports',
                          subtitle: 'Client PDF progress & assessment reports',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TrainerReportsScreen(
                                hasSportPack: _hasSportPack,
                                hasCompetitionRecords: _hasSportPack,
                              ),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.tune_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Trainer Workspace Settings',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TrainerWorkspaceSettingsScreen(
                                hasSportPack: _hasSportPack,
                                hasRecordedCompetitionActivity: _hasSportPack,
                              ),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.redeem_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Rewards Management',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RewardsManagementScreen(),
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
                          iconWidget: const Icon(Icons.public_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Country or Region',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CountryRegionScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.translate_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Language',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LanguageSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.straighten_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Measurement Units',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MeasurementUnitsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const UlvenikIcon(UlvenikIcons.trainingTime,
                            color: _stoneGrey,
                            size: 20,
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
                          iconWidget: const Icon(Icons.travel_explore_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Time Zone',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TimezoneSettingsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('SUPPORT & LEGAL'),
                    const SizedBox(height: 10),
                    _buildSectionCard(
                      children: [
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.help_outline_rounded,
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
                          iconWidget: const Icon(Icons.mail_outline_rounded,
                            color: _stoneGrey,
                            size: 20,
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
                          iconWidget: const Icon(Icons.bug_report_outlined,
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
                          iconWidget: const Icon(Icons.lightbulb_outline_rounded,
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
                        _buildDivider(),
                        _buildMenuRow(
                          iconWidget: const Icon(Icons.auto_awesome_outlined,
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
                          iconWidget: const Icon(Icons.shield_outlined,
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
                          iconWidget: const Icon(Icons.code_rounded,
                            color: _stoneGrey,
                            size: 20,
                          ),
                          title: 'Open Source Licences',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OpenSourceLicencesScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildProfileCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: _onTapProfileCard,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _sage,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                    letterSpacing: 0.3,
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
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
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
                        color: _forest.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _forest.withValues(alpha: 0.32),
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
              const UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: _cardBorder,
    );
  }

  Widget _buildStatusPill({required String label, required bool isAlert}) {
    final bgColor = isAlert
        ? _destructive.withValues(alpha: 0.22)
        : _forest.withValues(alpha: 0.18);
    final textColor = isAlert ? _destructiveText : _forest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildMenuRow({
    required Widget iconWidget,
    required String title,
    String? subtitle,
    Widget? trailingBadge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: subtitle != null ? 14 : 17,
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
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
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
              if (trailingBadge != null) ...[
                const SizedBox(width: 8),
                trailingBadge,
                const SizedBox(width: 8),
              ],
              const UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Interactive Bottom Sheets for Account, Community & Support ──

  void _showAccountSettingsSheet() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                'Account Settings',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Update your handler profile and primary login details.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: _stoneGrey,
                ),
              ),
              const SizedBox(height: 18),
              _buildTextField(
                label: 'FULL NAME',
                controller: nameController,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                label: 'EMAIL ADDRESS',
                controller: emailController,
              ),
              const SizedBox(height: 20),
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
                    final nextName = nameController.text.trim();
                    final nextEmail = emailController.text.trim();
                    if (nextName.isNotEmpty && nextEmail.isNotEmpty) {
                      setState(() {
                        _userName = nextName;
                        _userEmail = nextEmail;
                      });
                    }
                    Navigator.of(sheetCtx).pop();
                    AppSnackbar.show(
                      context,
                      title: 'Account Updated',
                      message: 'Saved profile details for $_userName.',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Save Account Changes',
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
  }

  void _showPrivacySecuritySheet() {
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
                      'Privacy & Security',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Row(
                        children: [
                          UlvenikIcon.fromMaterial(
                            _emailVerified
                                ? Icons.verified_rounded
                                : Icons.mark_email_unread_outlined,
                            color: _emailVerified ? _forest : _destructiveText,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _emailVerified
                                      ? 'Email Verified'
                                      : 'Email Not Verified',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _offWhite,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _userEmail,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: _stoneGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _emailVerified = !_emailVerified);
                              setSheetState(() {});
                              AppSnackbar.show(
                                context,
                                title: _emailVerified
                                    ? 'Email Verified'
                                    : 'Verification Reset',
                                message: _emailVerified
                                    ? '$_userEmail is now marked verified.'
                                    : 'Email marked unverified for testing.',
                                type: _emailVerified
                                    ? SnackbarType.success
                                    : SnackbarType.warning,
                              );
                            },
                            child: Text(
                              _emailVerified ? 'Reset' : 'Verify Now',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: _forest,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fingerprint_rounded,
                            color: _stoneGrey,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Biometric App Lock',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _offWhite,
                              ),
                            ),
                          ),
                          Switch(
                            value: _biometricLock,
                            activeThumbColor: _offWhite,
                            activeTrackColor: _forest,
                            onChanged: (val) {
                              setState(() => _biometricLock = val);
                              setSheetState(() {});
                            },
                          ),
                        ],
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

  void _showSubscriptionSheet() {
    final plans = [
      'Core + Trainer',
      'Core + Sport',
      'Complete',
      'Core',
    ];
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
                      'Subscription Management',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Active tier · Renews Nov 28, 2026',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...plans.map((plan) {
                      final selected = _subscriptionPlan == plan;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState(() => _subscriptionPlan = plan);
                            setSheetState(() {});
                            Navigator.of(sheetCtx).pop();
                            AppSnackbar.show(
                              context,
                              title: 'Plan Updated',
                              message: 'Switched active plan to $plan.',
                              type: SnackbarType.success,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _obsidian,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected ? _forest : _cardBorder,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                UlvenikIcon.fromMaterial(
                                  selected
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: selected ? _forest : _stoneGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    plan,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _offWhite,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  const Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: _forest,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: _cardBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(sheetCtx).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SubscriptionDetailsScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Subscription Details',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _offWhite,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: _cardBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(sheetCtx).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const BillingHistoryScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Billing History',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _offWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _showHelpSupportSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                  'Help & Support',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 14),
                _buildSheetActionTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Handler Knowledge Base',
                  subtitle: 'Guides on offline field sync, packs & multi-dog logs',
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HelpCentreScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildSheetActionTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Contact Ulvenik Support',
                  subtitle: 'Priority response for Trainer Pack members',
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ContactSupportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFeedbackSheet() {
    final controller = TextEditingController();
    String category = 'Feature Request';
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                    'Feedback & Feature Requests',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _offWhite,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Feature Request', 'Field UX', 'Bug Report']
                        .map((chip) {
                      final active = category == chip;
                      return ChoiceChip(
                        label: Text(chip),
                        selected: active,
                        selectedColor: _forest.withValues(alpha: 0.25),
                        backgroundColor: _obsidian,
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? _forest : _stoneGrey,
                        ),
                        onSelected: (_) =>
                            setSheetState(() => category = chip),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    label: 'YOUR FEEDBACK',
                    controller: controller,
                    maxLines: 3,
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
                        Navigator.of(sheetCtx).pop();
                        AppSnackbar.show(
                          context,
                          title: 'Feedback Sent',
                          message:
                              'Thank you! Logged under "$category" for the Ulvenik team.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Submit Feedback',
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
                        side: const BorderSide(color: _cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(sheetCtx).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Open Full Edit Profile',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: _offWhite,
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

  void _showAboutSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                  'About Ulvenik',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Version 1.0.0 (Build 100) · Precision Canine Performance & Care OS',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Text(
                    'Designed for handlers, trainers, and canine athletes operating across remote field environments with encrypted local-first sync.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      height: 1.45,
                      color: _stoneGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AboutUlvenikScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Open About Ulvenik',
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
          ),
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

  Widget _buildSheetActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _obsidian,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: _forest, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: _stoneGrey,
                    ),
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details,
              color: _stoneGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: _stoneGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: _offWhite,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _obsidian,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _forest, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwatchBookIcon extends StatelessWidget {
  final Color color;
  const _SwatchBookIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _SwatchBookPainter(color: color),
    );
  }
}

class _SwatchBookPainter extends CustomPainter {
  final Color color;
  const _SwatchBookPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final leftSwatch = RRect.fromRectAndRadius(
      const Rect.fromLTWH(2.5, 2.5, 6.5, 15),
      const Radius.circular(2.2),
    );
    canvas.drawRRect(leftSwatch, p);

    final fanPath = Path()
      ..moveTo(9.0, 5.5)
      ..lineTo(14.2, 4.0)
      ..lineTo(17.5, 9.2)
      ..lineTo(9.0, 16.8);
    canvas.drawPath(fanPath, p);

    final bottomBar = Path()
      ..moveTo(6.0, 17.5)
      ..lineTo(17.5, 17.5)
      ..lineTo(17.5, 13.0)
      ..lineTo(12.2, 13.0);
    canvas.drawPath(bottomBar, p);

    canvas.drawCircle(
      const Offset(5.75, 14.2),
      0.9,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _SwatchBookPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ShieldBoltIcon extends StatelessWidget {
  final Color color;
  const _ShieldBoltIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _ShieldBoltPainter(color: color),
    );
  }
}

class _ShieldBoltPainter extends CustomPainter {
  final Color color;
  const _ShieldBoltPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final shield = Path()
      ..moveTo(10, 2.2)
      ..lineTo(16.8, 4.8)
      ..cubicTo(16.8, 10.6, 14.2, 14.9, 10, 17.8)
      ..cubicTo(5.8, 14.9, 3.2, 10.6, 3.2, 4.8)
      ..close();
    canvas.drawPath(shield, p);

    final bolt = Path()
      ..moveTo(10.6, 6.8)
      ..lineTo(8.5, 10.2)
      ..lineTo(10.8, 10.2)
      ..lineTo(9.4, 13.5);
    canvas.drawPath(bolt, p);
  }

  @override
  bool shouldRepaint(covariant _ShieldBoltPainter oldDelegate) =>
      oldDelegate.color != color;
}
