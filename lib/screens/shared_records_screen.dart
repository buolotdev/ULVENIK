import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'document_viewer_screen.dart';
import 'video_viewer_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class SharedRecordsScreen extends StatefulWidget {
  const SharedRecordsScreen({super.key});

  @override
  State<SharedRecordsScreen> createState() => _SharedRecordsScreenState();
}

class _SharedRecordsScreenState extends State<SharedRecordsScreen> {
  final List<Map<String, dynamic>> _records = [
    {
      'title': 'Baron — Official IGP 1 Evaluation Report.pdf',
      'client': 'Sarah Jenkins (Baron)',
      'date': 'Oct 26, 2026',
      'type': 'doc',
      'size': '2.4 MB',
      'status': 'Viewed by Client',
    },
    {
      'title': 'Focused Heeling Video Critique & Marks.mp4',
      'client': 'Sarah Jenkins (Baron)',
      'date': 'Oct 24, 2026',
      'type': 'video',
      'size': '184 MB',
      'status': 'Viewed by Client',
    },
    {
      'title': 'Luna — Scent Grid Progression Chart.pdf',
      'client': 'David Miller (Luna)',
      'date': 'Oct 20, 2026',
      'type': 'doc',
      'size': '1.8 MB',
      'status': 'Sent • Unopened',
    },
    {
      'title': 'Working Dog Hydration & S&C Guide.pdf',
      'client': 'All Enrolled Clients (Broadcast)',
      'date': 'Oct 15, 2026',
      'type': 'doc',
      'size': '4.1 MB',
      'status': '24 Clients Accessed',
    },
  ];

  void _openRecord(Map<String, dynamic> record) {
    if (record['type'] == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoViewerScreen(
            title: record['title'],
            dogName: record['client'],
            duration: '02:14',
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentViewerScreen(
            title: record['title'],
            documentType: 'Client Shared Record',
          ),
        ),
      );
    }
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
          'Shared Records',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. INFO HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.folder_shared_outlined, color: _mint, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Secure Client Records Vault',
                        style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 2),
                      Text('Official evaluations, scorebooks and drill critiques shared with clients', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 2. RECORDS LIST
          ..._records.map((rec) => _buildRecordCard(rec)),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> rec) {
    final isVideo = rec['type'] == 'video';

    return GestureDetector(
      onTap: () => _openRecord(rec),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
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
              child: Icon(
                isVideo ? Icons.videocam : Icons.description,
                color: _mint,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rec['title'],
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('${rec['client']} • ${rec['size']}', style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rec['status'], style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w700)),
                      Text(rec['date'], style: const TextStyle(color: _stoneGrey, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

