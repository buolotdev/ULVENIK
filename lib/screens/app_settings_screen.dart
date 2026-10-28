import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'appearance_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'backup_sync_screen.dart';
import 'offline_mode_screen.dart';
import 'storage_management_screen.dart';
import 'about_ulvenik_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';
import 'profile_page_screen.dart';
import 'subscription_details_screen.dart';
import 'delete_account_screen.dart';
import 'export_my_data_screen.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';
import 'country_region_screen.dart';
import 'language_settings_screen.dart';
import 'measurement_units_screen.dart';
import 'date_time_format_screen.dart';
import 'timezone_settings_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _red = Color(0xFFE53E3E);

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. ACCOUNT & PROFILE
          _buildSectionHeader('ACCOUNT & MEMBERSHIP'),
          const SizedBox(height: 8),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.person_outline,
              title: 'Handler Profile',
              subtitle: 'Alex Rivers • Pro Tier Handler',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePageScreen())),
            ),
            _buildSettingTile(
              icon: Icons.alternate_email,
              title: 'Change Email Address',
              subtitle: 'alex.rivers@k9alpine.com',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangeEmailScreen())),
            ),
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Last updated 3 months ago',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            ),
            _buildSettingTile(
              icon: Icons.workspace_premium_outlined,
              title: 'Subscription & Quota',
              subtitle: 'Ulvenik Pro • 10 GB Cloud Tier Active',
              trailingText: 'Active',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubscriptionDetailsScreen()),
              ),
            ),
            _buildSettingTile(
              icon: Icons.security_outlined,
              title: 'Security & 2FA',
              subtitle: 'Two-Factor Authentication Enabled',
              trailingText: 'Enabled',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 20),

          // 2. PREFERENCES
          _buildSectionHeader('APP PREFERENCES'),
          const SizedBox(height: 8),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: 'Dark Obsidian • Mint Accent',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen())),
            ),
            _buildSettingTile(
              icon: Icons.notifications_none,
              title: 'Notifications & Alerts',
              subtitle: 'Master Push Enabled • 15m Advance Warning',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
            ),
            _buildSettingTile(
              icon: Icons.straighten,
              title: 'Measurement Units',
              subtitle: 'Metric & Imperial custom telemetry configuration',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MeasurementUnitsScreen())),
            ),
            _buildSettingTile(
              icon: Icons.schedule,
              title: 'Date & Time Format',
              subtitle: '24-Hour / 12-Hour • DD/MM/YYYY vs ISO',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DateTimeFormatScreen())),
            ),
            _buildSettingTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English (US) • Deutsch, Norsk & Svenska',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSettingsScreen())),
            ),
            _buildSettingTile(
              icon: Icons.public,
              title: 'Country or Region',
              subtitle: 'United States',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CountryRegionScreen())),
            ),
            _buildSettingTile(
              icon: Icons.access_time,
              title: 'Time Zone',
              subtitle: 'Pacific Time (US & Canada) • UTC-08:00',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TimezoneSettingsScreen())),
            ),
          ]),
          const SizedBox(height: 20),

          // 3. STORAGE & DATA
          _buildSectionHeader('DATA, CLOUD & SENSORS'),
          const SizedBox(height: 8),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.cloud_sync_outlined,
              title: 'Backup & Cloud Sync',
              subtitle: 'Automatic Nightly Backup • AWS S3',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupSyncScreen())),
            ),
            _buildSettingTile(
              icon: Icons.cloud_off_outlined,
              title: 'Offline Mode & Maps',
              subtitle: '2 Topographic Trail Packs Downloaded',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfflineModeScreen())),
            ),
            _buildSettingTile(
              icon: Icons.storage_outlined,
              title: 'Storage Management',
              subtitle: '1.24 GB Used • Cache & 4K Media',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StorageManagementScreen())),
            ),
            _buildSettingTile(
              icon: Icons.download_for_offline_outlined,
              title: 'Export My Data',
              subtitle: 'Download complete canine database & raw GPS/media',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportMyDataScreen())),
            ),
          ]),
          const SizedBox(height: 20),

          // 4. ABOUT & LEGAL
          _buildSectionHeader('ABOUT & LEGAL'),
          const SizedBox(height: 8),
          _buildGroupContainer([
            _buildSettingTile(
              icon: Icons.info_outline,
              title: 'About Ulvenik',
              subtitle: 'Version 2.4.0 (Build 412)',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUlvenikScreen())),
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Client-side encryption & zero data sales',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
            ),
            _buildSettingTile(
              icon: Icons.gavel_outlined,
              title: 'Terms of Service',
              subtitle: 'Handler safety agreement & EULA',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen())),
            ),
          ]),
          const SizedBox(height: 20),

          // 5. DANGER ZONE: DELETE ACCOUNT & SIGN OUT
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: _red.withValues(alpha: 0.3)),
            ),
            tileColor: _carbon,
            leading: const Icon(Icons.delete_forever, color: _red, size: 20),
            title: const Text('Delete Account', style: TextStyle(color: _red, fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Permanently erase all canine data and cloud archives', style: TextStyle(color: _stoneGrey, fontSize: 11)),
            trailing: const Icon(Icons.chevron_right, color: _red, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeleteAccountScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0x14FFFFFF)),
            ),
            tileColor: _carbon,
            leading: const Icon(Icons.logout, color: _offWhite, size: 20),
            title: const Text('Sign Out', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomepageScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final idx = entry.key;
          final widget = entry.value;
          final isLast = idx == children.length - 1;

          return Column(
            children: [
              widget,
              if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _mint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: _mint, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _stoneGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText,
                  style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
            ],
          ),
        ),
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
              _buildNavItem(Icons.more_horiz, 'More', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
                );
              }),
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
