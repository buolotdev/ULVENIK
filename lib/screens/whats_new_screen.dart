import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

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

class WhatsNewScreen extends StatefulWidget {
  const WhatsNewScreen({super.key});

  @override
  State<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends State<WhatsNewScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Accordion state
  bool _v110Expanded = false;
  bool _v101Expanded = true;
  bool _v100Expanded = false;

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

  void _showReleaseDetailsModal(String version, String date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
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
              'Release Notes — $version',
              style: const TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: _stoneGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Text(
              'This release features comprehensive performance optimizations for large video attachments, seamless offline timeline synchronization, and customizable training session templates.',
              style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
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
            // ─── Header: < What's New | Search ─────────────────────
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
                            'What\'s New',
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
                  const Icon(Icons.search, color: _offWhite, size: 20),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── LATEST RELEASE ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('LATEST RELEASE'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF162E25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'CURRENT',
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
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome_outlined, color: _mint, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Version 1.2.0',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '15 Sep 2026',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'This update introduces Training Templates, faster media loading, improved offline syncing and several performance improvements across the app.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => _showReleaseDetailsModal('Version 1.2.0', '15 Sep 2026'),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14191C),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View Details',
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.chevron_right, color: _mint, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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
                        hintText: 'Search Release Notes',
                        hintStyle: TextStyle(color: _mutedGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── PREVIOUS RELEASES ─────────────────────────────────
                  _buildSectionHeader('PREVIOUS RELEASES'),
                  const SizedBox(height: 8),

                  // Version 1.1.0 (Collapsible)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(() => _v110Expanded = !_v110Expanded),
                          child: Row(
                            children: [
                              const Text(
                                'Version 1.1.0',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '12 Aug 2026',
                                style: TextStyle(color: _stoneGrey, fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                _v110Expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: _stoneGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Introduced Health Dashboard, improved Statistics page and fixed several sync issues.',
                          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.35),
                        ),
                      ],
                    ),
                  ),

                  // Version 1.0.1 (Expanded)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(() => _v101Expanded = !_v101Expanded),
                          child: Row(
                            children: [
                              const Text(
                                'Version 1.0.1',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '3 Jul 2026',
                                style: TextStyle(color: _stoneGrey, fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                _v101Expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: _stoneGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bug fix release addressing notification and media issues.',
                          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.35),
                        ),
                        if (_v101Expanded) ...[
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0x0FFFFFFF)),
                          const SizedBox(height: 14),

                          // NEW FEATURES
                          _buildReleaseCategoryHeader(Icons.auto_awesome_outlined, 'NEW FEATURES'),
                          const SizedBox(height: 8),
                          _buildReleaseBullet('Added Training Templates'),
                          _buildReleaseBullet('Introduced Monthly Progress Summary'),

                          const SizedBox(height: 14),
                          // IMPROVEMENTS
                          _buildReleaseCategoryHeader(Icons.arrow_upward, 'IMPROVEMENTS'),
                          const SizedBox(height: 8),
                          _buildReleaseBullet('Faster Timeline loading'),
                          _buildReleaseBullet('Improved video upload performance'),
                          _buildReleaseBullet('Enhanced offline syncing'),

                          const SizedBox(height: 14),
                          // BUG FIXES
                          _buildReleaseCategoryHeader(Icons.bug_report_outlined, 'BUG FIXES'),
                          const SizedBox(height: 8),
                          _buildReleaseBullet('Fixed duplicate reminder notifications'),
                          _buildReleaseBullet('Resolved media playback issue on older devices'),
                          _buildReleaseBullet('Corrected statistics calculation errors'),

                          const SizedBox(height: 14),
                          // OTHER CHANGES
                          _buildReleaseCategoryHeader(Icons.build_outlined, 'OTHER CHANGES'),
                          const SizedBox(height: 8),
                          _buildReleaseBullet('Security improvements and maintenance updates'),
                        ],
                      ],
                    ),
                  ),

                  // Version 1.0.0 (Collapsible)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(() => _v100Expanded = !_v100Expanded),
                          child: Row(
                            children: [
                              const Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                '1 Jun 2026',
                                style: TextStyle(color: _stoneGrey, fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                _v100Expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: _stoneGrey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Initial release of Ulvenik.',
                          style: TextStyle(color: _stoneGrey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── YOUR VERSION ──────────────────────────────────────
                  _buildSectionHeader('YOUR VERSION'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Installed Version', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                            Text('1.2.0', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Latest Version', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                            Text('1.2.0', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: _syncGreen, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'You\'re using the latest version of Ulvenik.',
                              style: TextStyle(
                                color: _syncGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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

  Widget _buildReleaseCategoryHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: _stoneGrey, size: 14),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseBullet(String text) {
    if (_searchQuery.isNotEmpty && !text.toLowerCase().contains(_searchQuery)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
