import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'offline_mode_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);
const Color _dangerRed = Color(0xFFE53E3E);

class StorageManagementScreen extends StatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  State<StorageManagementScreen> createState() =>
      _StorageManagementScreenState();
}

class _StorageManagementScreenState extends State<StorageManagementScreen> {
  int _cacheMb = 840;
  bool _isOptimising = false;

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

  void _clearCache() {
    setState(() => _cacheMb = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporary cache cleared. 840 MB freed.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _optimiseStorage() async {
    setState(() => _isOptimising = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() {
      _isOptimising = false;
      _cacheMb = 120;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Storage optimisation complete. 720 MB recovered.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmRemoveDownloads() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove All Local Downloads', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to remove all 3.2 GB of downloaded media? Your cloud backups and records will remain completely safe.',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All local downloads removed.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Remove All', style: TextStyle(color: _offWhite)),
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
            // ─── Header: < Storage Management ─────────────────────────
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
                            'Storage Management',
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
                  // ─── OVERVIEW ──────────────────────────────────────────
                  _buildSectionHeader('OVERVIEW'),
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
                        const Text(
                          'Ulvenik Storage',
                          style: TextStyle(color: _stoneGrey, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '4.3 GB',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Available', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  const Text('82.1 GB', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 14),
                                  const Text('Downloads', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  const Text('3.2 GB', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cache', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text('$_cacheMb MB', style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 14),
                                  const Text('Other', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  const Text('260 MB', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── BREAKDOWN ─────────────────────────────────────────
                  _buildSectionHeader('BREAKDOWN'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildBreakdownRow(
                          icon: Icons.photo_outlined,
                          title: 'Dog Photos',
                          subtitle: '11% of total',
                          size: '480 MB',
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.videocam_outlined,
                          title: 'Videos',
                          subtitle: '60% of total',
                          size: '2.6 GB',
                          showChevron: true,
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.view_timeline_outlined,
                          title: 'Training Records',
                          subtitle: '4% of total',
                          size: '180 MB',
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.show_chart,
                          title: 'S&C Records',
                          subtitle: '2% of total',
                          size: '96 MB',
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.favorite_border,
                          title: 'Health Records',
                          subtitle: '3% of total',
                          size: '120 MB',
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.timeline,
                          title: 'Timeline',
                          subtitle: '1% of total',
                          size: '64 MB',
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.description_outlined,
                          title: 'Documents & Attachments',
                          subtitle: '4% of total',
                          size: '180 MB',
                        ),
                        _buildDivider(),
                        _buildBreakdownRow(
                          icon: Icons.storage_outlined,
                          title: 'Cached Files',
                          subtitle: '19% of total',
                          size: '$_cacheMb MB',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── CACHE ─────────────────────────────────────────────
                  _buildSectionHeader('CACHE'),
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
                            const Text(
                              'Cached Data',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$_cacheMb MB',
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: _clearCache,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14191C),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _forest.withValues(alpha: 0.6),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cleaning_services_outlined,
                                    color: _mint, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Clear Cache',
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            'Removes temporary files only. Your data is never affected.',
                            style: TextStyle(
                              color: _mutedGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── DOWNLOADED MEDIA ──────────────────────────────────
                  _buildSectionHeader('DOWNLOADED MEDIA'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OfflineModeScreen(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.file_download_outlined,
                              color: _stoneGrey, size: 22),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manage Downloaded Media',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'View and delete individual downloaded files',
                                  style: TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '3.2 GB',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── OPTIMISE ──────────────────────────────────────────
                  _buildSectionHeader('OPTIMISE'),
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
                        const Text(
                          'Removes expired cache, temporary files and duplicate cached media. Your content is never deleted.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _forest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _isOptimising ? null : _optimiseStorage,
                            child: _isOptimising
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: _offWhite,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh,
                                          color: _offWhite, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Optimise Storage',
                                        style: TextStyle(
                                          color: _offWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── DATABASE ──────────────────────────────────────────
                  _buildSectionHeader('DATABASE'),
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
                        _buildDatabaseRow('Local Database Size', '124 MB'),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 14),
                        _buildDatabaseRow('Stored Records', '4,218'),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 14),
                        _buildDatabaseRow('Last Optimised', '3 days ago'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── REMOVE ────────────────────────────────────────────
                  _buildSectionHeader('REMOVE'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _confirmRemoveDownloads,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline,
                              color: _dangerRed, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Remove All Local Downloads',
                            style: TextStyle(
                              color: _dangerRed,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Your cloud data and account information will remain safe.',
                      style: TextStyle(
                        color: _mutedGrey,
                        fontSize: 12,
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
      indent: 50,
    );
  }

  Widget _buildBreakdownRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String size,
    bool showChevron = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: _stoneGrey, size: 20),
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
          Text(
            size,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildDatabaseRow(String label, String value) {
    return Row(
      children: [
        const Icon(Icons.storage_outlined, color: _stoneGrey, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
