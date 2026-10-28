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

class MediaUploadManagerScreen extends StatefulWidget {
  const MediaUploadManagerScreen({super.key});

  @override
  State<MediaUploadManagerScreen> createState() =>
      _MediaUploadManagerScreenState();
}

class _MediaUploadManagerScreenState extends State<MediaUploadManagerScreen> {
  bool _isUploading = true;
  final double _activeProgress = 0.78;

  final List<Map<String, dynamic>> _queue = [
    {
      'name': 'koda_bite_phase_c_4k.mp4',
      'size': '340 MB',
      'status': 'uploading',
      'progress': 0.78,
      'speed': '14.2 MB/s',
      'icon': Icons.videocam,
    },
    {
      'name': 'koda_ofa_certificate.pdf',
      'size': '4.2 MB',
      'status': 'completed',
      'progress': 1.0,
      'speed': 'Done',
      'icon': Icons.description,
    },
    {
      'name': 'murphy_tracking_gpx_trace.gpx',
      'size': '1.8 MB',
      'status': 'completed',
      'progress': 1.0,
      'speed': 'Done',
      'icon': Icons.timeline,
    },
    {
      'name': 'alpine_ridge_point.heic',
      'size': '18.4 MB',
      'status': 'queued',
      'progress': 0.0,
      'speed': 'Queued',
      'icon': Icons.image,
    },
  ];

  void _pauseOrResume() {
    setState(() => _isUploading = !_isUploading);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isUploading ? 'Resumed all uploads.' : 'Upload queue paused.'),
        backgroundColor: _forest,
        duration: const Duration(seconds: 1),
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
          'Upload Manager',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isUploading ? 'Pause Uploads' : 'Resume Uploads',
            icon: Icon(_isUploading ? Icons.pause_circle_outline : Icons.play_circle_outline, color: _mint),
            onPressed: _pauseOrResume,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. LIVE BANDWIDTH TELEMETRY CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.cloud_upload, color: _mint, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '14.2 MB/s • Wi-Fi 6 Connected',
                        style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 2),
                      Text('Uploading to AWS S3 • 1 Item Active, 1 Queued', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('ACTIVE', style: TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. ACTIVE UPLOADS LIST
          _buildSectionHeader('UPLOAD QUEUE (4 ITEMS)'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: _queue.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                final isLast = idx == _queue.length - 1;
                final isCompleted = item['status'] == 'completed';
                final isUploading = item['status'] == 'uploading';

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(item['icon'], color: isCompleted ? _mint : _stoneGrey, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (isCompleted)
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: _mint, size: 16),
                                    SizedBox(width: 4),
                                    Text('Uploaded', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700)),
                                  ],
                                )
                              else
                                Text(
                                  '${item['size']} • ${item['speed']}',
                                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                                ),
                            ],
                          ),
                          if (isUploading) ...[
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: _activeProgress,
                                backgroundColor: const Color(0xFF131718),
                                valueColor: const AlwaysStoppedAnimation(_mint),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1),
                  ],
                );
              }).toList(),
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
