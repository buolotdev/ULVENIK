import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'contact_support_screen.dart';
import 'report_bug_screen.dart';
import 'feature_requests_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);

class HelpCentreScreen extends StatefulWidget {
  const HelpCentreScreen({super.key});

  @override
  State<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends State<HelpCentreScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _openArticle(String title) {
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
            Text(
              title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Detailed step-by-step guidance and best practices for this topic. All data is backed up automatically and securely encrypted on your device.',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _cardBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close', style: TextStyle(color: _offWhite)),
              ),
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
            // ─── Header: < Help Centre ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
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
                            'Help Centre',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── Search Bar ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: _stoneGrey, size: 20),
                        hintText: 'Search Help Articles',
                        hintStyle: TextStyle(color: _mutedGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── QUICK ACTIONS (2x2 Grid) ──────────────────────────
                  _buildSectionHeader('QUICK ACTIONS'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.chat_bubble_outline,
                          title: 'Contact Support',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ContactSupportScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.bug_report_outlined,
                          title: 'Report a Bug',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReportBugScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.lightbulb_outline,
                          title: 'Feature Requests',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FeatureRequestsScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.menu_book_outlined,
                          title: 'FAQs',
                          onTap: () => _openArticle('Frequently Asked Questions'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── POPULAR ───────────────────────────────────────────
                  _buildSectionHeader('POPULAR'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildPopularRow('Recording Your First Training Session'),
                        _buildDivider(),
                        _buildPopularRow('Sync Problems'),
                        _buildDivider(),
                        _buildPopularRow('Subscription Management'),
                        _buildDivider(),
                        _buildPopularRow('Offline Mode'),
                        _buildDivider(),
                        _buildPopularRow('Adding Your First Dog'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── GETTING STARTED ───────────────────────────────────
                  _buildSectionHeader('GETTING STARTED'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Creating an Account',
                          subtitle: 'Set up your Ulvenik profile',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Adding Your First Dog',
                          subtitle: 'Add and configure your dog\'s profile',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Recording Your First Training Session',
                          subtitle: 'Log your first session step by step',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Strength & Conditioning',
                          subtitle: 'Get started with S&C tracking',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Managing Health Records',
                          subtitle: 'Add and organise health data',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Using Goals',
                          subtitle: 'Set and track training goals',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.school_outlined,
                          title: 'Using Timeline',
                          subtitle: 'Understand the Timeline feature',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── ACCOUNT & SUBSCRIPTION ────────────────────────────
                  _buildSectionHeader('ACCOUNT & SUBSCRIPTION'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildArticleRow(
                          icon: Icons.person_outline,
                          title: 'Managing Your Account',
                          subtitle: 'Update your profile and preferences',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.person_outline,
                          title: 'Changing Email Address',
                          subtitle: 'How to update your login email',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.person_outline,
                          title: 'Password Assistance',
                          subtitle: 'Reset or change your password',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.person_outline,
                          title: 'Subscription Management',
                          subtitle: 'Upgrade, downgrade or cancel',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.person_outline,
                          title: 'Billing Questions',
                          subtitle: 'Invoices, charges and payment methods',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.person_outline,
                          title: 'Restoring Purchases',
                          subtitle: 'Restore a previous subscription',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── TRAINING & HEALTH ─────────────────────────────────
                  _buildSectionHeader('TRAINING & HEALTH'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Training Sessions',
                          subtitle: 'Logging and reviewing sessions',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Health Records',
                          subtitle: 'Recording and organising health data',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Strength & Conditioning',
                          subtitle: 'S&C tracking and session types',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Statistics',
                          subtitle: 'Understanding your progress data',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Videos & Photos',
                          subtitle: 'Uploading and managing media',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Equipment',
                          subtitle: 'Managing your equipment library',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.open_in_full,
                          title: 'Timeline',
                          subtitle: 'Recording and browsing Timeline events',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── TROUBLESHOOTING ───────────────────────────────────
                  _buildSectionHeader('TROUBLESHOOTING'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildArticleRow(
                          icon: Icons.sync,
                          title: 'Sync Problems',
                          subtitle: 'Fix issues with data not syncing',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.sync,
                          title: 'Offline Mode',
                          subtitle: 'Using Ulvenik without an internet connection',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.sync,
                          title: 'Backup & Restore',
                          subtitle: 'Back up and restore your data',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.sync,
                          title: 'Storage Issues',
                          subtitle: 'Free up space on your device',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.sync,
                          title: 'Login Problems',
                          subtitle: 'Can\'t sign in? Start here',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.sync,
                          title: 'Notifications',
                          subtitle: 'Fix missing or unwanted notifications',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── PRIVACY & SECURITY ────────────────────────────────
                  _buildSectionHeader('PRIVACY & SECURITY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildArticleRow(
                          icon: Icons.shield_outlined,
                          title: 'Privacy',
                          subtitle: 'How Ulvenik handles your data',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.shield_outlined,
                          title: 'Security',
                          subtitle: 'Keeping your account secure',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.shield_outlined,
                          title: 'Data Protection',
                          subtitle: 'Your rights and our obligations',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.shield_outlined,
                          title: 'Exporting Data',
                          subtitle: 'Download a copy of your data',
                        ),
                        _buildDivider(),
                        _buildArticleRow(
                          icon: Icons.shield_outlined,
                          title: 'Deleting Your Account',
                          subtitle: 'Permanently remove your account',
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

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
              title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularRow(String title) {
    if (_searchQuery.isNotEmpty && !title.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: () => _openArticle(title),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.trending_up, color: _stoneGrey, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF162E25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'POPULAR',
                style: TextStyle(
                  color: _mint,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    if (_searchQuery.isNotEmpty &&
        !title.toLowerCase().contains(_searchQuery) &&
        !subtitle.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: () => _openArticle(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 18),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
          ],
        ),
      ),
    );
  }
}
