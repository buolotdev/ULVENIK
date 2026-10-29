import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'edit_profile_screen.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';
import 'export_my_data_screen.dart';
import 'delete_account_screen.dart';
import 'subscription_details_screen.dart';
import 'billing_history_screen.dart';
import 'notification_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'language_settings_screen.dart';
import 'country_region_screen.dart';
import 'timezone_settings_screen.dart';
import 'date_time_format_screen.dart';
import 'measurement_units_screen.dart';
import 'backup_sync_screen.dart';
import 'offline_mode_screen.dart';
import 'storage_management_screen.dart';
import 'help_centre_screen.dart';
import 'contact_support_screen.dart';
import 'report_bug_screen.dart';
import 'feature_requests_screen.dart';
import 'about_ulvenik_screen.dart';
import 'whats_new_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'open_source_licences_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);
const Color _syncGreen = Color(0xFF4ADE80);
const Color _dangerRed = Color(0xFFE53E3E);

class MoreDashboardScreen extends StatefulWidget {
  const MoreDashboardScreen({super.key});

  @override
  State<MoreDashboardScreen> createState() => _MoreDashboardScreenState();
}

class _MoreDashboardScreenState extends State<MoreDashboardScreen> {
  void _onBottomNavTapped(int index) {
    if (index == 4) return;
    Widget target;
    switch (index) {
      case 0:
        target = const HomepageScreen();
        break;
      case 1:
        target = const MyDogsScreen();
        break;
      case 2:
        target = const TrainingScreen();
        break;
      case 3:
        target = const TimelineScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  void _showChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _mutedGrey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Change Profile Photo',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: _mint),
              title: const Text('Take Photo', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera opened.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: _mint),
              title: const Text('Choose from Library', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery opened.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: _dangerRed),
              title: const Text('Remove Current Photo', style: TextStyle(color: _dangerRed)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo removed.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: More ──────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 18, bottom: 14),
              child: Center(
                child: Text(
                  'More',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── Profile Card with Edit Profile CTA ─────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar "RO"
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF637C72),
                                border: Border.all(
                                  color: const Color(0xFF86A397),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'RO',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ruby Old',
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'ruby@email.com',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF162E25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Core + Trainer Pack',
                                      style: TextStyle(
                                        color: _mint,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Edit Profile Button
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141C1A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _forest.withValues(alpha: 0.6),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: _mint,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ─── 2x2 Metric Grid ───────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.pets_outlined,
                          value: '3',
                          label: 'Dogs',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyDogsScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.track_changes,
                          value: '5',
                          label: 'Active Goals',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TrainingScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.phone_iphone,
                          value: '2',
                          label: 'Active Devices',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.cloud_outlined,
                          value: 'Synced',
                          label: 'Cloud Sync',
                          valueColor: _syncGreen,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BackupSyncScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── ACCOUNT ───────────────────────────────────────────
                  _buildSectionHeader('ACCOUNT'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.camera_alt_outlined,
                          title: 'Change Profile Photo',
                          onTap: _showChangePhotoModal,
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.email_outlined,
                          title: 'Change Email Address',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangeEmailScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.file_download_outlined,
                          title: 'Export My Data',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExportMyDataScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                          isDanger: true,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeleteAccountScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── SUBSCRIPTION ──────────────────────────────────────
                  _buildSectionHeader('SUBSCRIPTION'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.credit_card_outlined,
                          title: 'Subscription Details',
                          subtitle: 'Core + Trainer Pack • Active',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SubscriptionDetailsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.receipt_long_outlined,
                          title: 'Billing History',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BillingHistoryScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.restore,
                          title: 'Restore Purchases',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Purchases successfully restored.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── PREFERENCES ───────────────────────────────────────
                  _buildSectionHeader('PREFERENCES'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          subtitle: '12 enabled',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const NotificationSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.palette_outlined,
                          title: 'Appearance',
                          subtitle: 'Dark Mode',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AppearanceSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.location_on_outlined,
                          title: 'Country',
                          subtitle: 'United Kingdom',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CountryRegionScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.access_time,
                          title: 'Time Zone',
                          subtitle: 'GMT+0',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimezoneSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.calendar_today_outlined,
                          title: 'Date & Time Format',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DateTimeFormatScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.straighten,
                          title: 'Measurement Units',
                          subtitle: 'Metric',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MeasurementUnitsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── DATA & STORAGE ────────────────────────────────────
                  _buildSectionHeader('DATA & STORAGE'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.cloud_sync_outlined,
                          title: 'Backup & Sync',
                          subtitle: 'Last synced 2 minutes ago',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BackupSyncScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.download_for_offline_outlined,
                          title: 'Offline Downloads',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OfflineModeScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.folder_outlined,
                          title: 'Storage Management',
                          subtitle: '2.4 GB used',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const StorageManagementScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── HELP ──────────────────────────────────────────────
                  _buildSectionHeader('HELP'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.help_outline,
                          title: 'Help Centre',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpCentreScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.chat_bubble_outline,
                          title: 'Contact Support',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContactSupportScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.bug_report_outlined,
                          title: 'Report a Bug',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReportBugScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.lightbulb_outline,
                          title: 'Feature Requests',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const FeatureRequestsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── ABOUT ─────────────────────────────────────────────
                  _buildSectionHeader('ABOUT'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.info_outline,
                          title: 'About Ulvenik',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutUlvenikScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.auto_awesome_outlined,
                          title: 'What\'s New',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WhatsNewScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.shield_outlined,
                          title: 'Privacy Policy',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsConditionsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.article_outlined,
                          title: 'Licences',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const OpenSourceLicencesScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Footer: Ulvenik v1.0.0 © Ulvenik ──────────────────
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Ulvenik v1.0.0',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '© Ulvenik',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
        onTap: _onBottomNavTapped,
        backgroundColor: _obsidian,
        selectedItemColor: _mint,
        unselectedItemColor: _stoneGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? _offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 52,
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDanger ? _dangerRed : _offWhite,
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
                      color: isDanger ? _dangerRed : _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: _stoneGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
