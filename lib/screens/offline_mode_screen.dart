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
const Color _orange = Color(0xFFDD6B20);
const Color _blue = Color(0xFF5D8FAF);
const Color _red = Color(0xFFE53E3E);

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  bool _forceOffline = false;
  bool _autoCacheDrills = true;
  bool _cacheVideos = true;

  final List<Map<String, dynamic>> _mapPacks = [
    {
      'title': 'Riverside Valley Topographic (1:24k)',
      'region': 'Pacific Northwest • 240 MB',
      'downloaded': true,
      'progress': 1.0,
    },
    {
      'title': 'Blackwood Forest Scent Trail Grid',
      'region': 'Dense Woodland • 115 MB',
      'downloaded': true,
      'progress': 1.0,
    },
    {
      'title': 'Alpine Summit Ridge Satellite Contours',
      'region': 'High Elevation • 380 MB',
      'downloaded': false,
      'progress': 0.0,
    },
  ];

  void _downloadMap(int index) async {
    setState(() {
      _mapPacks[index]['downloading'] = true;
      _mapPacks[index]['progress'] = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 140));
      if (!mounted) return;
      setState(() => _mapPacks[index]['progress'] = i / 10.0);
    }

    if (!mounted) return;
    setState(() {
      _mapPacks[index]['downloading'] = false;
      _mapPacks[index]['downloaded'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloaded ${_mapPacks[index]['title']} for offline backcountry use.'),
        backgroundColor: _forest,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Offline Maps & Media?', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'This will delete 735 MB of offline topographic maps and cached drill videos. Your cloud telemetry remains unaffected.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                for (var map in _mapPacks) {
                  map['downloaded'] = false;
                  map['progress'] = 0.0;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offline map cache cleared.'),
                  backgroundColor: _forest,
                ),
              );
            },
            child: const Text('Clear All', style: TextStyle(color: _offWhite)),
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
          'Offline Mode & Downloads',
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
          // 1. MASTER OFFLINE MODE CARD
          _buildOfflineToggleCard(),
          const SizedBox(height: 20),

          // 2. OFFLINE MAP PACKS
          _buildSectionHeader('OFFLINE TOPOGRAPHIC MAP PACKS'),
          const SizedBox(height: 8),
          ..._mapPacks.asMap().entries.map((entry) => _buildMapPackTile(entry.key, entry.value)),
          const SizedBox(height: 20),

          // 3. DRILL MEDIA & CACHE SETTINGS
          _buildSectionHeader('DRILL MEDIA CACHING'),
          const SizedBox(height: 8),
          _buildMediaCacheCard(),
          const SizedBox(height: 20),

          // 4. STORAGE CLEAR BUTTON
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _red.withValues(alpha: 0.3)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _showClearCacheDialog,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: _red, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Clear Downloaded Maps & Media',
                      style: TextStyle(
                        color: _red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _buildOfflineToggleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _forceOffline ? _orange.withValues(alpha: 0.4) : _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _forceOffline ? const Color(0xFF261D15) : const Color(0xFF131718),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.cloud_off,
              color: _forceOffline ? _orange : _stoneGrey,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Force Offline Field Mode',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Operate entirely from local storage during remote wilderness sessions',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: _forceOffline,
            activeThumbColor: _orange,
            activeTrackColor: const Color(0xFF261D15),
            inactiveTrackColor: const Color(0xFF131718),
            onChanged: (val) => setState(() => _forceOffline = val),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPackTile(int index, Map<String, dynamic> pack) {
    final bool isDownloaded = pack['downloaded'] ?? false;
    final bool isDownloading = pack['downloading'] ?? false;
    final double progress = pack['progress'] ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDownloaded ? _mint.withValues(alpha: 0.15) : _blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isDownloaded ? Icons.check_circle_outline : Icons.map_outlined,
                  color: isDownloaded ? _mint : _blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pack['title'],
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pack['region'],
                      style: const TextStyle(color: _stoneGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (isDownloaded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131718),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Saved', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
                )
              else if (isDownloading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: _mint),
                )
              else
                IconButton(
                  icon: const Icon(Icons.download, color: _mint, size: 20),
                  onPressed: () => _downloadMap(index),
                ),
            ],
          ),
          if (isDownloading) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF131718),
                valueColor: const AlwaysStoppedAnimation(_mint),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaCacheCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            title: 'Auto-Cache Active Drills',
            subtitle: 'Preload exercises scheduled for this week',
            value: _autoCacheDrills,
            onChanged: (val) => setState(() => _autoCacheDrills = val),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
          _buildSwitchRow(
            title: 'Cache Video Demonstrations',
            subtitle: 'Keep technique videos available without cell reception',
            value: _cacheVideos,
            onChanged: (val) => setState(() => _cacheVideos = val),
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
