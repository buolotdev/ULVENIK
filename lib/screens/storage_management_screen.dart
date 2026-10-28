import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
const Color _orange = Color(0xFFDD6B20);
const Color _purple = Color(0xFF9F7AEA);

class StorageManagementScreen extends StatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  State<StorageManagementScreen> createState() =>
      _StorageManagementScreenState();
}

class _StorageManagementScreenState extends State<StorageManagementScreen> {
  int _cacheSizeMb = 80;
  bool _autoClean = true;
  bool _lowStorageAlert = true;

  void _clearCache() {
    setState(() => _cacheSizeMb = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporary cache cleared. 80 MB freed.'),
        backgroundColor: _forest,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _compressVideosDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Compress Old Video Recordings?', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Videos older than 30 days will be compressed from 4K to 1080p. This will save ~340 MB of local space. Original cloud archives remain full resolution.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Compressing 14 video attachments in background...'),
                  backgroundColor: _forest,
                ),
              );
            },
            child: const Text('Compress', style: TextStyle(color: _offWhite)),
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
          'Storage Management',
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
          // 1. STORAGE BREAKDOWN DONUT & METRIC CARD
          _buildStorageHeroCard(),
          const SizedBox(height: 20),

          // 2. CATEGORY BREAKDOWN LIST
          _buildSectionHeader('STORAGE BY CATEGORY'),
          const SizedBox(height: 8),
          _buildCategoryList(),
          const SizedBox(height: 20),

          // 3. STORAGE OPTIMIZATION ACTIONS
          _buildSectionHeader('OPTIMIZATION TOOLS'),
          const SizedBox(height: 8),
          _buildOptimizationTools(),
          const SizedBox(height: 20),

          // 4. AUTOMATED POLICIES
          _buildSectionHeader('AUTOMATION RULES'),
          const SizedBox(height: 8),
          _buildAutomationRules(),
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

  Widget _buildStorageHeroCard() {
    final totalMb = 680 + 355 + 125 + _cacheSizeMb;
    final totalGb = (totalMb / 1024.0).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 26,
                    sections: [
                      PieChartSectionData(value: 680, color: _purple, radius: 10, showTitle: false),
                      PieChartSectionData(value: 355, color: _blue, radius: 10, showTitle: false),
                      PieChartSectionData(value: 125, color: _mint, radius: 10, showTitle: false),
                      if (_cacheSizeMb > 0)
                        PieChartSectionData(value: _cacheSizeMb.toDouble(), color: _orange, radius: 10, showTitle: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalGb GB Used',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'of 10.0 GB Cloud Allocation',
                      style: TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: totalMb / 10240.0,
                        backgroundColor: const Color(0xFF131718),
                        valueColor: const AlwaysStoppedAnimation(_mint),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildStorageCategoryRow('4K Video Recordings', '680 MB', _purple, Icons.videocam_outlined),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
          _buildStorageCategoryRow('Topographic Offline Maps', '355 MB', _blue, Icons.map_outlined),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
          _buildStorageCategoryRow('Telemetry & GPS Logs', '125 MB', _mint, Icons.timeline),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
          _buildStorageCategoryRow('App Cache & Temp Data', '$_cacheSizeMb MB', _orange, Icons.cached),
        ],
      ),
    );
  }

  Widget _buildStorageCategoryRow(String title, String size, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            size,
            style: const TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationTools() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.cleaning_services_outlined, color: _orange, size: 20),
            ),
            title: const Text('Clear Temporary Cache', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text('Instantly reclaim $_cacheSizeMb MB of transient cache', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _cacheSizeMb > 0 ? _forest : const Color(0xFF131718),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onPressed: _cacheSizeMb > 0 ? _clearCache : null,
              child: Text(
                _cacheSizeMb > 0 ? 'Clear' : 'Clean',
                style: TextStyle(color: _cacheSizeMb > 0 ? _offWhite : _stoneGrey, fontSize: 12),
              ),
            ),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 68),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _purple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.video_settings, color: _purple, size: 20),
            ),
            title: const Text('Compress Old Video Recordings', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Save ~340 MB by transcoding videos >30 days old', style: TextStyle(color: _stoneGrey, fontSize: 11)),
            trailing: const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
            onTap: _compressVideosDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationRules() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildSwitchRow(
            title: 'Automatic Weekly Cleanup',
            subtitle: 'Purge transient rendering buffers automatically',
            value: _autoClean,
            onChanged: (val) => setState(() => _autoClean = val),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
          _buildSwitchRow(
            title: 'Low Storage Warning (1 GB threshold)',
            subtitle: 'Alert before recording long GPS or video sessions',
            value: _lowStorageAlert,
            onChanged: (val) => setState(() => _lowStorageAlert = val),
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
