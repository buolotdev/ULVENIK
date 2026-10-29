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

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  State<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends State<BackupSyncScreen> {
  bool _autoSync = true;
  bool _syncMobileData = true;
  bool _isSyncing = false;
  String _lastSyncTime = 'Today • 14:37';

  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'iPhone 16 Pro',
      'lastActive': 'Last Active: Just Now',
      'isCurrent': true,
      'icon': Icons.phone_iphone,
    },
    {
      'name': 'MacBook Pro',
      'lastActive': 'Last Active: 2 hours ago',
      'isCurrent': false,
      'icon': Icons.laptop_mac,
    },
  ];

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

  void _triggerManualSync() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _isSyncing = false;
      _lastSyncTime = 'Today • $hour:$minute';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All data successfully synchronized with Ulvenik Cloud.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeDevice(int index) {
    final dev = _devices[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Unlink Device', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to unlink ${dev['name']}? It will no longer synchronize background telemetry.',
          style: const TextStyle(color: _stoneGrey, fontSize: 13),
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
              setState(() => _devices.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text('Unlink', style: TextStyle(color: _offWhite)),
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
            // ─── Header: < Backup & Sync | • SAVED ───────────────────
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
                            'Backup & Sync',
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
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _syncGreen,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'SAVED',
                        style: TextStyle(
                          color: _mutedGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── SYNC STATUS ───────────────────────────────────────
                  _buildSectionHeader('SYNC STATUS'),
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
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _syncGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Synced',
                                        style: TextStyle(
                                          color: _offWhite,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Status',
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
                                    _lastSyncTime,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Last Sync',
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
                                    '${_devices.length} Active',
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Devices',
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
                            Icon(Icons.cloud_outlined, color: _stoneGrey, size: 18),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Cloud Storage: 1.2 GB used',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              'of 5 GB',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── AUTOMATIC SYNC ────────────────────────────────────
                  _buildSectionHeader('AUTOMATIC SYNC'),
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
                        const Icon(Icons.sync, color: _stoneGrey, size: 22),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Automatic Cloud Sync',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Training, health and media sync in the background',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _autoSync,
                          activeThumbColor: _forest,
                          activeTrackColor: _syncGreen.withValues(alpha: 0.6),
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: _obsidian,
                          onChanged: (v) => setState(() => _autoSync = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── MOBILE DATA ───────────────────────────────────────
                  _buildSectionHeader('MOBILE DATA'),
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
                        const Icon(Icons.signal_cellular_alt, color: _stoneGrey, size: 22),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sync Using Mobile Data',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'When off, Ulvenik only syncs on Wi-Fi',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _syncMobileData,
                          activeThumbColor: _forest,
                          activeTrackColor: _syncGreen.withValues(alpha: 0.6),
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: _obsidian,
                          onChanged: (v) => setState(() => _syncMobileData = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── MANUAL SYNC ───────────────────────────────────────
                  _buildSectionHeader('MANUAL SYNC'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _isSyncing ? null : _triggerManualSync,
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
                          _isSyncing
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _mint,
                                  ),
                                )
                              : const Icon(Icons.sync, color: _mint, size: 22),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sync Now',
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Immediately sync all outstanding data',
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── CONNECTED DEVICES ─────────────────────────────────
                  _buildSectionHeader('CONNECTED DEVICES'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: _devices.asMap().entries.map((entry) {
                        final index = entry.key;
                        final dev = entry.value;
                        final isLast = index == _devices.length - 1;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Icon(dev['icon'] as IconData,
                                      color: _stoneGrey, size: 22),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dev['name'] as String,
                                          style: const TextStyle(
                                            color: _offWhite,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          dev['lastActive'] as String,
                                          style: const TextStyle(
                                            color: _stoneGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (dev['isCurrent'] == true) ...[
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
                                        'THIS DEVICE',
                                        style: TextStyle(
                                          color: _mint,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: _stoneGrey, size: 20),
                                      onPressed: () => _removeDevice(index),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                color: Color(0x0FFFFFFF),
                                indent: 52,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── BACKUP INFORMATION ────────────────────────────────
                  _buildSectionHeader('BACKUP INFORMATION'),
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
                        _buildInfoRow('Last Backup', _lastSyncTime),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 14),
                        _buildInfoRow('Backup Size', '842 MB'),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x0FFFFFFF)),
                        const SizedBox(height: 14),
                        _buildInfoRow('Cloud Storage Used', '1.2 GB of 5 GB'),
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

  Widget _buildInfoRow(String label, String value) {
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
