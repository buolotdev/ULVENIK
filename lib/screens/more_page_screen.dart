import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'timeline_activity_map_screen.dart';
import 'timeline_compare_screen.dart';
import 'timeline_smart_collections_screen.dart';
import 'timeline_widgets_screen.dart';
import 'notification_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'backup_sync_screen.dart';
import 'offline_mode_screen.dart';
import 'storage_management_screen.dart';
import 'help_centre_screen.dart';
import 'contact_support_screen.dart';
import 'report_bug_screen.dart';
import 'feature_requests_screen.dart';
import 'whats_new_screen.dart';
import 'about_ulvenik_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'open_source_licences_screen.dart';
import 'app_settings_screen.dart';
import 'notifications_page_screen.dart';
import 'profile_page_screen.dart';
import 'global_calendar_screen.dart';
import 'global_search_screen.dart';
import 'media_library_screen.dart';
import 'media_collections_screen.dart';
import 'media_favourites_screen.dart';
import 'sport_pack_overview_screen.dart';
import 'trainer_dashboard_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);
const Color _blue = Color(0xFF5D8FAF);
const Color _orange = Color(0xFFDD6B20);
const Color _red = Color(0xFFE53E3E);
const Color _purple = Color(0xFF9F7AEA);

class MorePageScreen extends StatefulWidget {
  final bool initialEmpty;

  const MorePageScreen({super.key, this.initialEmpty = false});

  @override
  State<MorePageScreen> createState() => _MorePageScreenState();
}

class _MorePageScreenState extends State<MorePageScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEmptyState;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to sign out of your Ulvenik handler account? Local data will remain safely cached.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomepageScreen()),
              );
            },
            child: const Text('Sign Out', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isEmptyState ? _buildEmptyState() : _buildPopulatedHub(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'More',
        style: TextStyle(
          color: _offWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search, color: _offWhite, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
            );
          },
        ),
        IconButton(
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none, color: _offWhite, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPageScreen()),
            );
          },
        ),
        IconButton(
          tooltip: 'Toggle Empty/Populated State',
          icon: Icon(
            _isEmptyState ? Icons.visibility : Icons.visibility_off_outlined,
            color: _mint,
            size: 20,
          ),
          onPressed: () {
            setState(() => _isEmptyState = !_isEmptyState);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _carbon,
                border: Border.all(color: _cardBorder),
              ),
              child: const Center(
                child: Icon(
                  Icons.dashboard_customize_outlined,
                  size: 46,
                  color: _stoneGrey,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Hub Options Configured',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _offWhite,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your handler hub provides instant navigation to account settings, offline downloads, storage management, and advanced canine telemetry tools.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: () => setState(() => _isEmptyState = false),
                child: const Text(
                  'Load More Dashboard',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulatedHub() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. HANDLER PROFILE HEADER CARD
        _buildProfileHeaderCard(),
        const SizedBox(height: 16),

        // 2. QUICK SYSTEM TELEMETRY STRIP (Sync, Storage, Offline)
        _buildSystemTelemetryStrip(),
        const SizedBox(height: 20),

        // 3. CANINE TOOLS & ADVANCED TELEMETRY
        _buildSectionTitle('CANINE TOOLS & EXTENSIONS'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.map_outlined,
            title: 'Activity Map',
            subtitle: 'GPS route traces, elevation & heatmap contours',
            color: _blue,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineActivityMapScreen())),
          ),
          _HubItem(
            icon: Icons.compare_arrows,
            title: 'Timeline Compare',
            subtitle: 'Dog vs Dog & Year vs Year progression deltas',
            color: _mint,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineCompareScreen())),
          ),
          _HubItem(
            icon: Icons.auto_awesome_motion,
            title: 'Smart Collections',
            subtitle: 'Rule-based event clustering & highlights',
            color: _orange,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineSmartCollectionsScreen())),
          ),
          _HubItem(
            icon: Icons.calendar_month_outlined,
            title: 'Handler Calendar',
            subtitle: 'Multi-dog schedule, vet reminders & trial dates',
            color: _purple,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobalCalendarScreen())),
          ),
          _HubItem(
            icon: Icons.search,
            title: 'Global Search',
            subtitle: 'Cross-app unified search for dogs, drills & logs',
            color: _mint,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobalSearchScreen())),
          ),
          _HubItem(
            icon: Icons.widgets_outlined,
            title: 'Widgets & Live Activities',
            subtitle: 'Dynamic Island, Lock Screen & Home Screen cards',
            color: _gold,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimelineWidgetsScreen())),
          ),
        ]),
        const SizedBox(height: 20),

        // 4. MEDIA & CANINE ARCHIVE
        _buildSectionTitle('MEDIA & CANINE ARCHIVE'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.perm_media_outlined,
            title: 'Media Library',
            subtitle: '4K drill recordings, field snapshots & certificates',
            color: _mint,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaLibraryScreen())),
          ),
          _HubItem(
            icon: Icons.folder_special_outlined,
            title: 'Media Collections',
            subtitle: 'Curated drill albums & trial footage folders',
            color: _blue,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaCollectionsScreen())),
          ),
          _HubItem(
            icon: Icons.star_outline,
            title: 'Favorite Highlights',
            subtitle: 'Bookmarked 4K slow-mo clips & action shots',
            color: _gold,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaFavouritesScreen())),
          ),
        ]),
        const SizedBox(height: 20),

        // 5. WORKING DOG SPORT PACK
        _buildSectionTitle('WORKING DOG SPORT PACK'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.sports_kabaddi,
            title: 'Sport Pack Hub',
            subtitle: 'IGP, Agility, S&R trials, titles & phase analytics',
            color: _gold,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SportPackOverviewScreen())),
          ),
        ]),
        const SizedBox(height: 20),

        // 5.5 TRAINER PACK (PRO SUBSCRIPTION)
        _buildSectionTitle('TRAINER PACK (PRO SUBSCRIPTION)'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.badge_outlined,
            title: 'Trainer Hub',
            subtitle: 'Clients, homework review, lesson analytics & billing',
            color: _forest,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainerDashboardScreen())),
          ),
        ]),
        const SizedBox(height: 20),

        // 6. PREFERENCES & CONFIGURATION
        _buildSectionTitle('PREFERENCES & APP SETTINGS'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Account, units, cloud storage & hardware sensors',
            color: _offWhite,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppSettingsScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.notifications_none,
            title: 'Notification Settings',
            subtitle: 'Push notifications, drill alerts & reminders',
            color: _mint,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.palette_outlined,
            title: 'Appearance Settings',
            subtitle: 'Dark Carbon, Stealth Frost, AMOLED & accent styles',
            color: _blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.cloud_sync_outlined,
            title: 'Backup & Cloud Sync',
            subtitle: 'Multi-device cloud synchronization & exports',
            color: _forest,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BackupSyncScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.cloud_off_outlined,
            title: 'Offline Mode & Downloads',
            subtitle: 'Offline GPS maps & cached drill media',
            color: _orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OfflineModeScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.pie_chart_outline,
            title: 'Storage Management',
            subtitle: '1.2 GB used • Cache cleanup & media storage',
            color: _red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StorageManagementScreen()),
            ),
          ),
        ]),
        const SizedBox(height: 20),

        // 5. HELP & COMMUNITY SUPPORT
        _buildSectionTitle('SUPPORT & COMMUNITY'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.help_outline,
            title: 'Help Centre & Guides',
            subtitle: 'Training manuals, GPS pairing & FAQs',
            color: _mint,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpCentreScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.headset_mic_outlined,
            title: 'Contact Support',
            subtitle: 'Priority 24/7 direct handler assistance',
            color: _blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Submit diagnostic logs to engineering',
            color: _orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportBugScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.lightbulb_outline,
            title: 'Feature Requests',
            subtitle: 'Vote on upcoming handler roadmap features',
            color: _gold,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeatureRequestsScreen()),
            ),
          ),
        ]),
        const SizedBox(height: 20),

        // 6. ABOUT & LEGAL
        _buildSectionTitle('ABOUT & LEGAL'),
        const SizedBox(height: 8),
        _buildHubGroup([
          _HubItem(
            icon: Icons.new_releases_outlined,
            title: "What's New in Ulvenik",
            subtitle: 'Version 2.4.0 Release Notes',
            color: _mint,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WhatsNewScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.info_outline,
            title: 'About Ulvenik',
            subtitle: 'The Performance Canine Operating System',
            color: _blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutUlvenikScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Your canine health and GPS data ownership',
            color: _stoneGrey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'End-user service agreement',
            color: _stoneGrey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
            ),
          ),
          _HubItem(
            icon: Icons.code,
            title: 'Open Source Licences',
            subtitle: 'Flutter, FlChart, and third-party acknowledgments',
            color: _stoneGrey,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OpenSourceLicencesScreen()),
            ),
          ),
        ]),
        const SizedBox(height: 20),

        // 7. SIGN OUT BUTTON
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _red.withValues(alpha: 0.3)),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _showLogoutDialog,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: _red, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: _red,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProfileHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _forest,
              border: Border.all(color: _mint, width: 2),
            ),
            child: const Center(
              child: Text(
                'AR',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Alex Rivers',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: _mint,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  '2 Registered Dogs: Koda, Murphy',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
              ],
            ),
          ),

          // Edit icon
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _mint, size: 20),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePageScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTelemetryStrip() {
    return Row(
      children: [
        _buildStatusChip(Icons.cloud_done, 'Cloud Synced', _mint),
        const SizedBox(width: 8),
        _buildStatusChip(Icons.storage, '1.2 GB / 10 GB', _offWhite),
        const SizedBox(width: 8),
        _buildStatusChip(Icons.wifi_tethering, 'Online', _blue),
      ],
    );
  }

  Widget _buildStatusChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF131718),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildHubGroup(List<_HubItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == items.length - 1;

          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.vertical(
                    top: idx == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: isLast ? const Radius.circular(16) : Radius.zero,
                  ),
                  onTap: item.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, color: item.color, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(color: _stoneGrey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 64),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class _HubItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _HubItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
