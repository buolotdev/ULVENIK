import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'edit_profile_screen.dart';
import 'subscription_details_screen.dart';
import 'trainer_profile_screen.dart';
import 'clients_page_screen.dart';
import 'appearance_settings_screen.dart';
import 'measurement_units_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'storage_management_screen.dart';
import 'help_centre_screen.dart';
import 'contact_support_screen.dart';
import 'feature_requests_screen.dart';
import 'about_ulvenik_screen.dart';
import 'change_photo_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);
const Color _syncGreen = Color(0xFF4ADE80);
const Color _dangerRed = Color(0xFFE53E3E);

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }
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
      case 4:
        target = const MorePageScreen();
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

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to sign out? Your offline records and cached media will remain safely stored on your device.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _dangerRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomepageScreen()),
                (route) => false,
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
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: Profile | Edit Icon ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: _offWhite, size: 20),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── User Avatar & Identity ────────────────────────────
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChangePhotoScreen()),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF263238),
                                border: Border.all(color: const Color(0xFF37474F), width: 1.5),
                              ),
                              child: const Center(
                                child: Text(
                                  'JH',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _syncGreen,
                                  border: Border.all(color: _obsidian, width: 2),
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
                            const Text(
                              'James Harlow',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Member since July 2024',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF162E25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'CORE • TRAINER PACK',
                                style: TextStyle(
                                  color: _mint,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ─── 4-Column Stat Strip ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        _buildStatCol('6', 'DOGS'),
                        _buildStatDivider(),
                        _buildStatCol('2,418', 'SESSIONS'),
                        _buildStatDivider(),
                        _buildStatCol('163', 'GOALS'),
                        _buildStatDivider(),
                        _buildStatCol('4 yrs', 'ULVENIK'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ─── Dual Action Buttons: Edit Profile & Change Photo ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_outlined, color: _offWhite, size: 16),
                              SizedBox(width: 6),
                              Text('Edit Profile', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _showChangePhotoModal,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_camera_outlined, color: _offWhite, size: 16),
                              SizedBox(width: 6),
                              Text('Change Photo', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── Current Training Streak Card ──────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF14191C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.local_fire_department_outlined, color: _mint, size: 22),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current Training Streak', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                              SizedBox(height: 2),
                              Text('18 Days', style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const Row(
                          children: [
                            Text('RECORD', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: _mint, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── MY PROFILE ────────────────────────────────────────
                  _buildSectionHeader('MY PROFILE'),
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
                          subtitle: 'Name, photo, biography, contact',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.shield_outlined,
                          title: 'Account & Security',
                          subtitle: 'Email, password, biometrics, sessions',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── MEMBERSHIP ────────────────────────────────────────
                  _buildSectionHeader('MEMBERSHIP'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('CURRENT PLAN', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF162E25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('ACTIVE', style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Core + Trainer Pack', style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        const Text('Renews 28 July 2025', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SubscriptionDetailsScreen()),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Manage Subscription', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w500)),
                              Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── TRAINER PACK ──────────────────────────────────────
                  _buildSectionHeader('TRAINER PACK'),
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
                          icon: Icons.business_center_outlined,
                          title: 'Trainer Profile',
                          subtitle: 'Business name, clients, verification',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TrainerProfileScreen()),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.group_outlined,
                          title: 'My Clients',
                          subtitle: '12 active clients',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ClientsPageScreen()),
                          ),
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
                          icon: Icons.palette_outlined,
                          title: 'Appearance',
                          subtitle: 'Dark Mode',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen()),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.straighten,
                          title: 'Units & Date Format',
                          subtitle: 'kg • km • DD/MM/YYYY',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MeasurementUnitsScreen()),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.view_quilt_outlined,
                          title: 'Display Preferences',
                          subtitle: 'Default home, calendar view',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AppearanceSettingsScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── NOTIFICATIONS ─────────────────────────────────────
                  _buildSectionHeader('NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: _buildNavRow(
                      icon: Icons.notifications_none,
                      title: 'Notification Settings',
                      subtitle: 'Push Notifications: On • Quiet Hours: Off',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── PRIVACY ───────────────────────────────────────────
                  _buildSectionHeader('PRIVACY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: _buildNavRow(
                      icon: Icons.lock_outline,
                      title: 'Privacy & Security',
                      subtitle: 'Biometrics • Data Permissions',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── STORAGE ───────────────────────────────────────────
                  _buildSectionHeader('STORAGE'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: _buildNavRow(
                      icon: Icons.cloud_outlined,
                      title: 'Storage & Sync',
                      subtitle: '1.2 GB used • Synced 4 min ago',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StorageManagementScreen()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── HELP & SUPPORT ────────────────────────────────────
                  _buildSectionHeader('HELP & SUPPORT'),
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
                            MaterialPageRoute(builder: (_) => const HelpCentreScreen()),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.chat_bubble_outline,
                          title: 'Contact Support',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.lightbulb_outline,
                          title: 'Feature Requests',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FeatureRequestsScreen()),
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
                    child: _buildNavRow(
                      icon: Icons.info_outline,
                      title: 'About Ulvenik',
                      subtitle: 'Version 1.0.0 • What\'s New • Legal',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUlvenikScreen()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Sign Out Button ───────────────────────────────────
                  InkWell(
                    onTap: _showSignOutDialog,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: _dangerRed,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Footer: ULVENIK ATHLETIC INTELLIGENCE ──────────────
                  const Center(
                    child: Text(
                      'ULVENIK ATHLETIC INTELLIGENCE • NORDIC BUILD 85',
                      style: TextStyle(
                        color: _mutedGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
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

  Widget _buildStatCol(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0x14FFFFFF),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _offWhite, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
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
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
