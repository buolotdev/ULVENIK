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
const Color _dangerRed = Color(0xFFE53E3E);

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  bool _offlineEnabled = true;
  String _selectedQuality = 'Balanced';
  bool _isDownloading = false;

  // Available offline toggles matching Figma
  final Map<String, bool> _offlineItems = {
    'Dog Profiles': true,
    'Training Records': true,
    'S&C Records': true,
    'Health Records': true,
    'Goals': true,
    'Timeline': true,
    'Statistics': true,
    'Videos': true,
    'Photos': true,
    'Documents & Attachments': false,
  };

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

  void _triggerDownload() async {
    setState(() => _isDownloading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isDownloading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offline data successfully updated and verified.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmRemoveContent() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Downloaded Content',
          style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will free up 3.2 GB of device storage by removing cached media and offline copies. Cloud data remains safe.',
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
                  content: Text('Downloaded content removed.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: _offWhite)),
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
            // ─── Header: < Offline Mode & Downloads | Saved ───────────
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
                            'Offline Mode & Downloads',
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
                  const Text(
                    'Saved',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 13,
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
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _offlineEnabled
                                              ? _syncGreen
                                              : _mutedGrey,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _offlineEnabled ? 'Enabled' : 'Disabled',
                                        style: const TextStyle(
                                          color: _offWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Offline Mode',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '3.2 GB',
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Downloaded',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today • 08:14',
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Last Updated',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '12.4 GB free',
                                    style: TextStyle(
                                      color: _offWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Device Storage',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── OFFLINE MODE ──────────────────────────────────────
                  _buildSectionHeader('OFFLINE MODE'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off_outlined,
                          color: _stoneGrey,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enable Offline Mode',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Store essential content locally for access without an internet connection',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: _offlineEnabled,
                          activeThumbColor: _forest,
                          activeTrackColor: _syncGreen.withValues(alpha: 0.6),
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: _obsidian,
                          onChanged: (val) {
                            setState(() => _offlineEnabled = val);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── AVAILABLE OFFLINE ─────────────────────────────────
                  _buildSectionHeader('AVAILABLE OFFLINE'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          icon: Icons.person_outline,
                          title: 'Dog Profiles',
                          keyName: 'Dog Profiles',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.view_timeline_outlined,
                          title: 'Training Records',
                          keyName: 'Training Records',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.show_chart,
                          title: 'S&C Records',
                          keyName: 'S&C Records',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.favorite_border,
                          title: 'Health Records',
                          keyName: 'Health Records',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.track_changes,
                          title: 'Goals',
                          keyName: 'Goals',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.timeline,
                          title: 'Timeline',
                          keyName: 'Timeline',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.bar_chart,
                          title: 'Statistics',
                          keyName: 'Statistics',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.videocam_outlined,
                          title: 'Videos',
                          keyName: 'Videos',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.photo_outlined,
                          title: 'Photos',
                          keyName: 'Photos',
                        ),
                        _buildDivider(),
                        _buildSwitchRow(
                          icon: Icons.description_outlined,
                          title: 'Documents & Attachments',
                          keyName: 'Documents & Attachments',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── DOWNLOAD QUALITY ──────────────────────────────────
                  _buildSectionHeader('DOWNLOAD QUALITY'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildQualityRow(
                          title: 'High Quality',
                          subtitle: 'Larger files, best detail',
                        ),
                        _buildDivider(),
                        _buildQualityRow(
                          title: 'Balanced',
                          subtitle: 'Recommended for most users',
                        ),
                        _buildDivider(),
                        _buildQualityRow(
                          title: 'Data Saver',
                          subtitle: 'Smaller files, reduced quality',
                        ),
                        _buildDivider(),
                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text(
                            'Applies to newly downloaded media only. Previously downloaded files are unchanged.',
                            style: TextStyle(
                              color: _mutedGrey,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── DOWNLOAD CTA BUTTON ───────────────────────────────
                  _buildSectionHeader('DOWNLOAD'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isDownloading ? null : _triggerDownload,
                      child: _isDownloading
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
                                Icon(Icons.file_download_outlined,
                                    color: _offWhite, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Download Latest Data',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Downloads all selected content to your device',
                      style: TextStyle(
                        color: _mutedGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── STORAGE BREAKDOWN ─────────────────────────────────
                  _buildSectionHeader('STORAGE'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildStorageRow(
                          icon: Icons.videocam_outlined,
                          title: 'Videos',
                          size: '2.4 GB',
                        ),
                        const SizedBox(height: 12),
                        _buildStorageRow(
                          icon: Icons.photo_outlined,
                          title: 'Photos',
                          size: '480 MB',
                        ),
                        const SizedBox(height: 12),
                        _buildStorageRow(
                          icon: Icons.view_timeline_outlined,
                          title: 'Training Data',
                          size: '180 MB',
                        ),
                        const SizedBox(height: 12),
                        _buildStorageRow(
                          icon: Icons.favorite_border,
                          title: 'Health Data',
                          size: '96 MB',
                        ),
                        const SizedBox(height: 12),
                        _buildStorageRow(
                          icon: Icons.description_outlined,
                          title: 'Documents',
                          size: '64 MB',
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 14),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Offline Storage Used',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '3.2 GB',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── REMOVE ────────────────────────────────────────────
                  _buildSectionHeader('REMOVE'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _confirmRemoveContent,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline, color: _dangerRed, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Remove Downloaded Content',
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

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String keyName,
  }) {
    final isChecked = _offlineItems[keyName] ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: _offWhite, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: isChecked,
            activeThumbColor: _forest,
            activeTrackColor: _syncGreen.withValues(alpha: 0.6),
            inactiveThumbColor: _stoneGrey,
            inactiveTrackColor: _obsidian,
            onChanged: (val) {
              setState(() => _offlineItems[keyName] = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQualityRow({
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedQuality == title;
    return InkWell(
      onTap: () => setState(() => _selectedQuality = title),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
            if (isSelected)
              const Icon(
                Icons.check,
                color: _syncGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageRow({
    required IconData icon,
    required String title,
    required String size,
  }) {
    return Row(
      children: [
        Icon(icon, color: _stoneGrey, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          size,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
