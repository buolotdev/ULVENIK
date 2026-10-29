import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_dashboard_screen.dart';
import 'profile_page_screen.dart';
import 'appearance_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'subscription_details_screen.dart';
import 'offline_mode_screen.dart';
import 'rewards_management_screen.dart';
import 'help_centre_screen.dart';
import 'feature_requests_screen.dart';
import 'about_ulvenik_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);
const Color _badgeRedBg = Color(0xFF331D1D);
const Color _badgeRedText = Color(0xFFE57373);
const Color _badgeGreenBg = Color(0xFF162B21);
const Color _badgeGreenText = Color(0xFF4ADE80);

class MorePageScreen extends StatefulWidget {
  final bool initialEmpty;

  const MorePageScreen({super.key, this.initialEmpty = false});

  @override
  State<MorePageScreen> createState() => _MorePageScreenState();
}

class _MorePageScreenState extends State<MorePageScreen> {
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
                  // ─── User Profile Card ─────────────────────────────────
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MoreDashboardScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Row(
                        children: [
                          // Avatar "RO"
                          Container(
                            width: 52,
                            height: 52,
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
                          const Icon(
                            Icons.chevron_right,
                            color: _stoneGrey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
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
                          icon: Icons.account_circle_outlined,
                          title: 'Account Settings',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePageScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.contrast,
                          title: 'Appearance',
                          subtitle: 'Dark Mode',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppearanceSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          trailingBadge: _buildBadge(
                            text: 'Off',
                            bg: _badgeRedBg,
                            textCol: _badgeRedText,
                          ),
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
                          icon: Icons.shield_outlined,
                          title: 'Privacy & Security',
                          trailingBadge: _buildBadge(
                            text: 'Email Not Verified',
                            bg: _badgeRedBg,
                            textCol: _badgeRedText,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen(),
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
                    child: _buildNavRow(
                      icon: Icons.credit_card_outlined,
                      title: 'Subscription Management',
                      subtitle: 'Core + Trainer Pack • Active',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SubscriptionDetailsScreen(),
                        ),
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
                      title: 'Offline Storage & Cloud Sync',
                      trailingBadge: _buildBadge(
                        text: 'Fully Synced',
                        bg: _badgeGreenBg,
                        textCol: _badgeGreenText,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OfflineModeScreen(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── COMMUNITY ─────────────────────────────────────────
                  _buildSectionHeader('COMMUNITY'),
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
                          icon: Icons.card_giftcard,
                          title: 'Ulvenik Rewards',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RewardsManagementScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.person_add_outlined,
                          title: 'Refer a Friend',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Referral link copied to clipboard!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.language,
                          title: 'Community',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Connecting to Ulvenik Community Forum...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── SUPPORT ───────────────────────────────────────────
                  _buildSectionHeader('SUPPORT'),
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
                          icon: Icons.support_agent_outlined,
                          title: 'Help & Support',
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
                          title: 'Feedback & Feature Requests',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FeatureRequestsScreen(),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.pie_chart_outline,
                          title: 'About Ulvenik',
                          subtitle: 'Version 1.0.0',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutUlvenikScreen(),
                            ),
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

  Widget _buildBadge({
    required String text,
    required Color bg,
    required Color textCol,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textCol,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailingBadge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
            if (trailingBadge != null) ...[
              trailingBadge,
              const SizedBox(width: 8),
            ],
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
