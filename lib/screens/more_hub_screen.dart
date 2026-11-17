import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../data/app_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import 'about_ulvenik_screen.dart';
import 'app_lock.dart';
import 'backup_sync_screen.dart';
import 'dog_profile_screen.dart';
import 'global_calendar_screen.dart';
import 'global_search_screen.dart';
import 'help_centre_screen.dart';
import 'more_page_screen.dart';
import 'more_settings_screens.dart';
import 'notifications_inbox_screen.dart';
import 'open_source_licences_screen.dart';
import 'privacy_policy_screen.dart';
import 'rewards_equipment_screens.dart';
import 'session_templates_new.dart';
import 'subscription_details_screen.dart';
import 'support_forms_screens.dart';
import 'terms_conditions_screen.dart';
import 'trainer_clients_screens.dart';
import 'trainer_profile_new_screens.dart';
import 'trainer_dashboard_screen.dart';
import '../data/item_library.dart';
import 'timeline_common.dart';
import 'whats_new_screen.dart';

/// More: a short navigation hub in four groups. One profile card at the top;
/// nothing is hard-coded about the user, their plan or sync state.
class MoreHubScreen extends StatefulWidget {
  const MoreHubScreen({super.key});

  @override
  State<MoreHubScreen> createState() => _MoreHubScreenState();
}

class _MoreHubScreenState extends State<MoreHubScreen> {
  final _q = TextEditingController();

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  static const _allTitles = [
    'Notifications Inbox', 'Search All Records', 'Calendar', 'Session Templates', 'Media Library', 'Rewards', 'Equipment', 'Clients',
    'Trainer Profile', 'Trainer Workspace', 'Account Settings', 'Appearance', 'Notification Settings',
    'Privacy & Security', 'App Lock', 'Subscription', 'Storage & Sync', 'Regional Preferences', 'Help & Support',
    'Feature Requests', 'About Ulvenik', 'What’s New', 'Privacy Policy', 'Terms & Conditions', 'Open Source Licences',
  ];

  /// A row that only appears when it matches the search text.
  Widget? _row({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    final q = _q.text.trim().toLowerCase();
    if (q.isNotEmpty && !title.toLowerCase().contains(q)) return null;
    return moreRow(icon: icon, title: title, subtitle: subtitle, onTap: onTap);
  }

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  /// Opens one of the existing account sheets without showing the old page.
  void _sheet(BuildContext c, String which) => Navigator.push(
        c,
        PageRouteBuilder<void>(
          opaque: false,
          barrierColor: Colors.transparent,
          pageBuilder: (_, _, _) => Offstage(child: MorePageScreen(openSheet: which)),
        ),
      );

  Future<void> _templates(BuildContext c) async {
    final dog = await showDogSheet(c, '', allowAll: false);
    if (dog == null || !c.mounted) return;
    _go(c, SessionTemplatesScreen(dogName: dog));
  }

  Future<void> _mediaLibrary(BuildContext c) async {
    final dog = await showDogSheet(c, '', allowAll: false);
    if (dog == null || !c.mounted) return;
    _go(c, DogProfileScreen(dogName: dog, initialTab: 'Media'));
  }

  Widget _group(String title, List<Widget> rows) => rows.isEmpty ? const SizedBox.shrink() : Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title,
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(children: [
              for (var i = 0; i < rows.length; i++) ...[
                rows[i],
                if (i < rows.length - 1) const Divider(height: 1, color: Colors.white10),
              ],
            ]),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final s = AppSettings.instance;
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) {
        final name = s.displayName;
        return Scaffold(
          backgroundColor: AppColors.backgroundObsidian,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundObsidian,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text('More',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
            children: [
              HealthCard(
                onTap: () => _go(context, const MyProfileScreen()),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: s.photoPath.isNotEmpty
                          ? Image.file(File(s.photoPath),
                              fit: BoxFit.cover, errorBuilder: (_, _, _) => ColoredBox(color: AppColors.backgroundObsidian))
                          : ColoredBox(
                              color: AppColors.backgroundObsidian,
                              child: Center(
                                child: Text(name.isEmpty ? '?' : name[0].toUpperCase(),
                                    style: TextStyle(color: AppColors.secondarySage, fontSize: 20, fontWeight: FontWeight.w700)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name.isEmpty ? 'Add your name' : name,
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
                      Text('My Profile', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _q,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('Search settings and tools...').copyWith(
                  prefixIcon: Icon(Icons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
                  suffixIcon: _q.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                          onPressed: _q.clear,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              _group('Your Tools', [
                ?_row(icon: Icons.notifications_none, title: 'Notifications Inbox', onTap: () => _go(context, const NotificationsInboxScreen())),
                ?_row(icon: Icons.search, title: 'Search All Records', onTap: () => _go(context, const GlobalSearchScreen())),
                ?_row(icon: Icons.calendar_month_outlined, title: 'Calendar', onTap: () => _go(context, const GlobalCalendarScreen())),
                ?_row(icon: Icons.photo_library_outlined, title: 'Media Library', onTap: () => _mediaLibrary(context)),
                ?_row(icon: Icons.copy_all_outlined, title: 'Session Templates', onTap: () => _templates(context)),
                ?_row(icon: Icons.card_giftcard, title: 'Rewards', onTap: () => _go(context, const ItemLibraryScreen(kind: LibraryKind.rewards))),
                ?_row(icon: Icons.construction, title: 'Equipment', onTap: () => _go(context, const ItemLibraryScreen(kind: LibraryKind.equipment))),
                ?_row(icon: Icons.person_outline, title: 'Clients', onTap: () => _go(context, const TrainerClientsScreen())),
                ?_row(icon: Icons.badge_outlined, title: 'Trainer Profile', onTap: () => _go(context, const TrainerProfileScreen())),
                ?_row(icon: Icons.groups_outlined, title: 'Trainer Workspace', onTap: () => _go(context, const TrainerDashboardScreen())),
              ]),
              _group('Settings', [
                ?_row(icon: Icons.manage_accounts_outlined, title: 'Account Settings', onTap: () => _sheet(context, 'account')),
                ?_row(icon: Icons.palette_outlined, title: 'Appearance', subtitle: 'Text size ${s.textSize}', onTap: () => _go(context, const AppearancePrefsScreen())),
                ?_row(icon: Icons.notifications_active_outlined, title: 'Notification Settings', subtitle: s.notify('push') ? 'On' : 'Off', onTap: () => _go(context, const NotificationPrefsScreen())),
                ?_row(icon: Icons.lock_outline, title: 'Privacy & Security', onTap: () => _sheet(context, 'privacy')),
                ?_row(icon: Icons.fingerprint, title: 'App Lock', subtitle: AppSettings.instance.appLock ? 'On' : 'Off', onTap: () => _go(context, const AppLockScreen())),
                ?_row(icon: Icons.workspace_premium_outlined, title: 'Subscription', onTap: () => _go(context, const SubscriptionDetailsScreen())),
                ?_row(icon: Icons.cloud_outlined, title: 'Storage & Sync', onTap: () => _go(context, const BackupSyncScreen())),
                ?_row(icon: Icons.language, title: 'Regional Preferences', onTap: () => _go(context, const RegionalPreferencesScreen())),
              ]),
              _group('Support', [
                ?_row(icon: Icons.help_outline, title: 'Help & Support', onTap: () => _go(context, const _HelpSupportScreen())),
                ?_row(icon: Icons.lightbulb_outline, title: 'Feature Requests', onTap: () => _go(context, const SuggestFeatureForm())),
              ]),
              _group('About & Legal', [
                ?_row(icon: Icons.info_outline, title: 'About Ulvenik', onTap: () => _go(context, const AboutUlvenikScreen())),
                ?_row(icon: Icons.new_releases_outlined, title: 'What’s New', onTap: () => _go(context, const WhatsNewScreen())),
                ?_row(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () => _go(context, const PrivacyPolicyScreen())),
                ?_row(icon: Icons.description_outlined, title: 'Terms & Conditions', onTap: () => _go(context, const TermsConditionsScreen())),
                ?_row(icon: Icons.code, title: 'Open Source Licences', onTap: () => _go(context, const OpenSourceLicencesScreen())),
              ]),
              if (_q.text.trim().isNotEmpty && !_allTitles.any((t) => t.toLowerCase().contains(_q.text.trim().toLowerCase())))
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('No settings or tools match your search.',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                  ),
                ),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snap) => snap.hasData
                    ? Center(
                        child: Text('Version ${snap.data!.version} (${snap.data!.buildNumber})',
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HelpSupportScreen extends StatelessWidget {
  const _HelpSupportScreen();

  @override
  Widget build(BuildContext context) {
    void go(Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));
    return HealthScaffold(
      title: 'Help & Support',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(children: [
              moreRow(icon: Icons.menu_book_outlined, title: 'Help Centre', onTap: () => go(const HelpCentreScreen())),
              const Divider(height: 1, color: Colors.white10),
              moreRow(icon: Icons.mail_outline, title: 'Contact Support', onTap: () => go(const ContactSupportForm())),
              const Divider(height: 1, color: Colors.white10),
              moreRow(icon: Icons.bug_report_outlined, title: 'Report a Bug', onTap: () => go(const ReportBugForm())),
            ]),
          ),
        ],
      ),
    );
  }
}

