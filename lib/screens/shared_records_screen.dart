import 'package:flutter/material.dart';
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

class SharedRecordItem {
  String type; // 'TRAINING SESSION', 'HEALTH RECORD', 'VIDEO ANALYSIS', 'PROGRESS REPORT', 'GOAL TARGET'
  String status; // 'ACTIVE', 'PENDING', 'EXPIRED'
  String title;
  List<String> dogs;
  String permLevel; // 'FULL ACCESS', 'VIEW ONLY', 'COMMENT', 'EDIT'
  String meta;
  String fileType; // 'doc', 'video'

  SharedRecordItem({
    required this.type,
    required this.status,
    required this.title,
    required this.dogs,
    required this.permLevel,
    required this.meta,
    required this.fileType,
  });
}

class SharedRecordsScreen extends StatefulWidget {
  const SharedRecordsScreen({super.key});

  @override
  State<SharedRecordsScreen> createState() => _SharedRecordsScreenState();
}

class _SharedRecordsScreenState extends State<SharedRecordsScreen> {
  String _activeFilter = 'ALL';
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  final List<SharedRecordItem> _records = [
    SharedRecordItem(
      type: 'TRAINING SESSION',
      status: 'ACTIVE',
      title: 'Week 4 Focus & Decoy Engagement',
      dogs: ['Murphy'],
      permLevel: 'FULL ACCESS',
      meta: 'Shared 14 Nov • Shared by You',
      fileType: 'doc',
    ),
    SharedRecordItem(
      type: 'HEALTH RECORD',
      status: 'ACTIVE',
      title: 'Post-Agility Stifle Palpation & Recover',
      dogs: ['Murphy'],
      permLevel: 'VIEW ONLY',
      meta: 'Shared 12 Nov • Shared by Client',
      fileType: 'doc',
    ),
    SharedRecordItem(
      type: 'VIDEO ANALYSIS',
      status: 'ACTIVE',
      title: 'Morning Decoy Pass & Bite Threshol',
      dogs: ['Murphy'],
      permLevel: 'COMMENT',
      meta: 'Shared 10 Nov • Shared by Client',
      fileType: 'video',
    ),
    SharedRecordItem(
      type: 'PROGRESS REPORT',
      status: 'PENDING',
      title: 'Q4 IGP Tracking & Drive Assessment',
      dogs: ['Rex & Murphy'],
      permLevel: 'EDIT',
      meta: 'Invited 08 Nov • Shared by You',
      fileType: 'doc',
    ),
    SharedRecordItem(
      type: 'GOAL TARGET',
      status: 'EXPIRED',
      title: 'Complete 20 Neutral Decoy Passes L',
      dogs: ['Murphy'],
      permLevel: 'VIEW ONLY',
      meta: 'Expired 01 Nov • Shared by You',
      fileType: 'doc',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _shareNewRecord() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        title: const Text('Share Record', style: TextStyle(color: _offWhite)),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            labelText: 'Record Title',
            labelStyle: TextStyle(color: _stoneGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _forest),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _records.insert(
                    0,
                    SharedRecordItem(
                      type: 'TRAINING SESSION',
                      status: 'ACTIVE',
                      title: titleCtrl.text.trim(),
                      dogs: ['Murphy'],
                      permLevel: 'FULL ACCESS',
                      meta: 'Shared Today • Shared by You',
                      fileType: 'doc',
                    ),
                  );
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Share', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _records.where((r) {
      if (_activeFilter == 'TRAINING' && !r.type.contains('TRAINING')) return false;
      if (_activeFilter == 'HEALTH' && !r.type.contains('HEALTH')) return false;
      if (_activeFilter == 'GOALS' && !r.type.contains('GOAL')) return false;
      if (_activeFilter == 'REPORTS' && !r.type.contains('REPORT')) return false;
      if (_searchController.text.trim().isNotEmpty) {
        return r.title.toLowerCase().contains(_searchController.text.toLowerCase());
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shared Records',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite, size: 22),
            onPressed: () => setState(() => _showSearch = !_showSearch),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite, size: 24),
            onPressed: _shareNewRecord,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _shareNewRecord,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            if (_showSearch) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search shared records...',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: _stoneGrey, size: 20),
                    suffixIcon: TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _showSearch = false);
                      },
                      child: const Text('Cancel', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],

            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ALL', 'TRAINING', 'HEALTH', 'GOALS', 'REPORTS'].map((f) {
                  final isSel = _activeFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _activeFilter = f),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SHARED RECORDS (${filtered.length})',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  'Filtered by Emma Johnson',
                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Records List
            ...filtered.map((item) {
              return InkWell(
                onTap: () {
                  if (item.fileType == 'video') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoViewerScreen(title: item.title),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DocumentViewerScreen(title: item.title),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
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
                      Row(
                        children: [
                          Icon(
                            item.fileType == 'video'
                                ? Icons.videocam_outlined
                                : Icons.description_outlined,
                            size: 16,
                            color: _stoneGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.type,
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const Spacer(),
                          _buildStatusBadge(item.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: item.dogs.map((d) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.pets, size: 10, color: _stoneGrey),
                                const SizedBox(width: 4),
                                Text(d, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const Divider(color: _cardBorder, height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14241E),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0x3334D399)),
                            ),
                            child: Text(
                              item.permLevel,
                              style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.meta,
                              style: const TextStyle(color: _stoneGrey, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'SWIPE GESTURE PREVIEW',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text('Swipe left on cards', style: TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 8),

            // Swipe Preview
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Swipe left reveals options...', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    color: const Color(0xFF1E2B2A),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.visibility_outlined, color: _mint, size: 18),
                        SizedBox(height: 2),
                        Text('VIEW', style: TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    color: const Color(0xFF183329),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.shield_outlined, color: Color(0xFF34D399), size: 18),
                        SizedBox(height: 2),
                        Text('PERMS', style: TextStyle(color: Color(0xFF34D399), fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF342323),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 18),
                        SizedBox(height: 2),
                        Text('STOP', style: TextStyle(color: Color(0xFFEF4444), fontSize: 9, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SHARING HISTORY',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text('View Full History', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Sharing History Timeline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildHistoryRow('Record Shared', 'Sarah Mitchell shared Week 4 Training Plan', '14 Nov • 09:32'),
                  const Divider(color: _cardBorder, height: 20),
                  _buildHistoryRow('Permission Changed', 'Updated Stifle Health Record to View Only', '12 Nov • 14:15'),
                  const Divider(color: _cardBorder, height: 20),
                  _buildHistoryRow('Invitation Accepted', 'Emma Johnson accepted access to Decoy Video', '10 Nov • 11:20'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'REPORTS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Generate Shared Report Card
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.description_outlined, color: _stoneGrey, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Generate Shared Report',
                              style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Creates a consolidated report containing only records currently shared with Emma Johnson.',
                              style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Consolidated report generated.'), backgroundColor: _forest),
                        );
                      },
                      child: const Text(
                        'Generate Shared Report',
                        style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFF262C30);
    Color fg = _stoneGrey;

    if (status == 'ACTIVE') {
      bg = const Color(0x1F34D399);
      fg = const Color(0xFF34D399);
    } else if (status == 'PENDING') {
      bg = const Color(0xFF2A2E33);
      fg = const Color(0xFFECC94B);
    } else if (status == 'EXPIRED') {
      bg = const Color(0x33EF4444);
      fg = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildHistoryRow(String title, String desc, String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF34D399),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
            ],
          ),
        ),
        Text(date, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
      ],
    );
  }
}
