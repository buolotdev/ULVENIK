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
const Color _blue = Color(0xFF5D8FAF);

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  State<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends State<BackupSyncScreen> {
  bool _autoSync = true;
  bool _wifiOnly = true;
  bool _includeVideos = false;
  bool _isSyncing = false;
  double _syncProgress = 0.0;
  String _lastSyncText = 'Synced 2 minutes ago';

  void _triggerManualSync() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
      _syncProgress = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() => _syncProgress = i / 10.0);
    }

    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _lastSyncText = 'Just now';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cloud sync complete. All local records are backed up.'),
        backgroundColor: _forest,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showRestoreDialog(String name, String date, String size) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Restore Cloud Backup?', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to restore from "$name" ($date • $size)? Your device will synchronize to this exact snapshot.',
          style: const TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _triggerManualSync();
            },
            child: const Text('Restore', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

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
          'Backup & Cloud Sync',
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
          // 1. CLOUD STATUS HERO CARD
          _buildCloudStatusCard(),
          const SizedBox(height: 20),

          // 2. AUTOMATION & NETWORK SETTINGS
          _buildSectionHeader('SYNC PARAMETERS'),
          const SizedBox(height: 8),
          _buildSyncOptions(),
          const SizedBox(height: 20),

          // 3. BACKUP SNAPSHOTS HISTORY
          _buildSectionHeader('HISTORICAL CLOUD SNAPSHOTS'),
          const SizedBox(height: 8),
          _buildBackupHistory(),
          const SizedBox(height: 20),

          // 4. MANUAL EXPORT CARD
          _buildExportCard(),
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

  Widget _buildCloudStatusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _mint.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _forest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.cloud_done, color: _mint, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ulvenik Cloud Storage',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _lastSyncText,
                      style: const TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSyncing ? const Color(0xFF131718) : _forest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: _isSyncing ? null : _triggerManualSync,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isSyncing)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: _mint),
                      )
                    else
                      const Icon(Icons.sync, color: _mint, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _isSyncing ? 'Syncing...' : 'Sync Now',
                      style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isSyncing) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _syncProgress,
                backgroundColor: const Color(0xFF131718),
                valueColor: const AlwaysStoppedAnimation(_mint),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSyncOptions() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            title: 'Automatic Daily Backup',
            subtitle: 'Upload updated logs, telemetry & GPS tracks nightly',
            value: _autoSync,
            onChanged: (val) => setState(() => _autoSync = val),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
          _buildSwitchRow(
            title: 'Sync Over Wi-Fi Only',
            subtitle: 'Prevent cloud synchronization over mobile cellular data',
            value: _wifiOnly,
            onChanged: (val) => setState(() => _wifiOnly = val),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
          _buildSwitchRow(
            title: 'Include High-Res Videos',
            subtitle: 'Backup raw 4K training session footage to cloud',
            value: _includeVideos,
            onChanged: (val) => setState(() => _includeVideos = val),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupHistory() {
    final snapshots = [
      {'name': 'Automated Nightly Backup', 'date': 'Today • 02:00 AM', 'size': '428 MB'},
      {'name': 'Manual Snapshot: Field Agility', 'date': 'Oct 25 • 06:14 PM', 'size': '412 MB'},
      {'name': 'System Milestone v2.4.0', 'date': 'Oct 21 • 11:30 AM', 'size': '390 MB'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: snapshots.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isLast = idx == snapshots.length - 1;

          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.history, color: _blue, size: 20),
                ),
                title: Text(
                  item['name']!,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                subtitle: Text(
                  '${item['date']} • ${item['size']}',
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
                trailing: TextButton(
                  onPressed: () => _showRestoreDialog(item['name']!, item['date']!, item['size']!),
                  child: const Text('Restore', style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 68),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExportCard() {
    return Container(
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
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.download_for_offline, color: _mint, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Local Archive (.zip)',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Save complete handler database to external drive',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Archive created: ulvenik_backup_20261028.zip'),
                  backgroundColor: _forest,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Switch(
            value: value,
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF131718),
            onChanged: onChanged,
          ),
        ],
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
