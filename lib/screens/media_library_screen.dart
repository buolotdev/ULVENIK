import 'package:flutter/material.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';
import 'document_viewer_screen.dart';
import 'media_search_screen.dart';
import 'media_upload_manager_screen.dart';
import 'media_collections_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class MediaLibraryScreen extends StatefulWidget {
  final bool initialEmpty;

  const MediaLibraryScreen({super.key, this.initialEmpty = false});

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  String _selectedTab = 'All';

  final List<Map<String, dynamic>> _items = [
    {'type': 'photo', 'date': '14 Jul', 'heart': true},
    {'type': 'video', 'duration': '0:45', 'date': '13 Jul', 'heart': false},
    {'type': 'photo', 'date': '12 Jul', 'heart': false},
    {'type': 'photo', 'date': '11 Jul', 'heart': false},
    {'type': 'doc', 'title': 'Vet Report', 'date': '10 Jul', 'heart': false},
    {'type': 'video', 'duration': '1:20', 'date': '9 Jul', 'heart': true},
    {'type': 'photo', 'date': '8 Jul', 'heart': false},
    {'type': 'photo', 'date': '6 Jul', 'heart': false},
    {'type': 'video', 'duration': '0:24', 'date': '5 Jul', 'heart': false},
    {'type': 'photo', 'date': '4 Jul', 'heart': false},
    {'type': 'photo', 'date': '2 Jul', 'heart': false},
    {'type': 'photo', 'date': '28 Jun', 'heart': false},
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedTab == 'All') return _items;
    if (_selectedTab == 'Photos') return _items.where((i) => i['type'] == 'photo').toList();
    if (_selectedTab == 'Videos') return _items.where((i) => i['type'] == 'video').toList();
    return _items.where((i) => i['type'] == 'doc').toList();
  }

  void _openItem(Map<String, dynamic> item) {
    if (item['type'] == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const VideoViewerScreen(),
        ),
      );
    } else if (item['type'] == 'photo') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PhotoViewerScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DocumentViewerScreen(),
        ),
      );
    }
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort & Filter Media', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.collections_bookmark_outlined, color: _mint),
              title: const Text('Open Collections', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaCollectionsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined, color: _mint),
              title: const Text('Upload Manager', style: TextStyle(color: _offWhite)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaUploadManagerScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

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
          'Media Library',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaSearchScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite),
            onPressed: _showSortSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: _offWhite),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // 4-COLUMN METRIC STRIP
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  _buildMetricCol('147', 'PHOTOS'),
                  _buildDivider(),
                  _buildMetricCol('34', 'VIDEOS'),
                  _buildDivider(),
                  _buildMetricCol('12', 'DOCS'),
                  _buildDivider(),
                  _buildMetricCol('2.4 GB', 'STORAGE'),
                ],
              ),
            ),
          ),

          // TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Photos', 'Videos', 'Documents'].map((tab) {
                final isSel = _selectedTab == tab;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = tab),
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSel ? _mint : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSel ? _offWhite : _stoneGrey,
                        fontSize: 14,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // 3-COLUMN MEDIA GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final item = filtered[i];
                return _buildMediaTile(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      color: _cardBorder,
    );
  }

  Widget _buildMediaTile(Map<String, dynamic> item) {
    final type = item['type'] as String;
    final heart = item['heart'] as bool? ?? false;

    return InkWell(
      onTap: () => _openItem(item),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _cardBorder),
          gradient: LinearGradient(
            colors: type == 'photo'
                ? [const Color(0xFF1B2421), const Color(0xFF121715)]
                : type == 'video'
                    ? [const Color(0xFF192226), const Color(0xFF11171A)]
                    : [const Color(0xFF222629), const Color(0xFF141719)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            // Center illustration if document
            if (type == 'doc')
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.description_outlined, color: _stoneGrey, size: 26),
                    const SizedBox(height: 2),
                    const Text('PDF', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item['title'] ?? 'Document', style: const TextStyle(color: _offWhite, fontSize: 10)),
                  ],
                ),
              ),

            // Top-left heart badge
            if (heart)
              const Positioned(
                top: 0,
                left: 0,
                child: Icon(Icons.favorite, color: Color(0xFFECC94B), size: 14),
              ),

            // Top-right icon
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                type == 'photo'
                    ? Icons.image_outlined
                    : type == 'video'
                        ? Icons.play_circle_outline
                        : Icons.description_outlined,
                color: _stoneGrey,
                size: 16,
              ),
            ),

            // Bottom-left duration or date
            if (type == 'video') ...[
              Positioned(
                bottom: 0,
                left: 0,
                child: Text(
                  item['duration'] ?? '',
                  style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  item['date'] ?? '',
                  style: const TextStyle(color: _stoneGrey, fontSize: 10),
                ),
              ),
            ] else if (type == 'photo') ...[
              Positioned(
                bottom: 0,
                left: 0,
                child: Text(
                  item['date'] ?? '',
                  style: const TextStyle(color: _stoneGrey, fontSize: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
