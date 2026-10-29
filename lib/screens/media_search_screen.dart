import 'package:flutter/material.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';
import 'document_viewer_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class MediaSearchScreen extends StatefulWidget {
  const MediaSearchScreen({super.key});

  @override
  State<MediaSearchScreen> createState() => _MediaSearchScreenState();
}

class _MediaSearchScreenState extends State<MediaSearchScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'agility');
  String _viewMode = 'Results (F2)';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _searchResults = [
    {'type': 'photo', 'heart': true},
    {'type': 'video', 'duration': '0:42', 'heart': false},
    {'type': 'photo', 'heart': false},
    {'type': 'doc', 'title': 'Agility_Guide.pdf', 'heart': false},
    {'type': 'photo', 'heart': true},
    {'type': 'video', 'duration': '1:15', 'heart': false},
    {'type': 'photo', 'heart': false},
    {'type': 'photo', 'heart': false},
    {'type': 'photo', 'heart': true},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openItem(Map<String, dynamic> item) {
    if (item['type'] == 'video') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoViewerScreen()));
    } else if (item['type'] == 'photo') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoViewerScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentViewerScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH BAR HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: _stoneGrey, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: _offWhite, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Search media...',
                                hintStyle: TextStyle(color: _stoneGrey),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (v) {
                                if (v.isEmpty) {
                                  setState(() => _viewMode = 'Initial (F1)');
                                } else {
                                  setState(() => _viewMode = 'Results (F2)');
                                }
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _viewMode = 'Initial (F1)');
                              },
                              child: const Icon(Icons.close, color: _stoneGrey, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // VIEW MODE SWITCHER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  const Text('VIEW MODE', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  const SizedBox(width: 12),
                  ...['Results (F2)', 'Initial (F1)', 'No Results (F3)'].map((mode) {
                    final isSel = _viewMode == mode;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(mode),
                        selected: isSel,
                        selectedColor: _forest,
                        backgroundColor: _carbon,
                        labelStyle: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _viewMode = mode),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // CATEGORY CHIPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Photos', 'Videos', 'Training', 'Competitions'].map((cat) {
                    final isSel = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: _forest,
                        backgroundColor: _carbon,
                        labelStyle: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 12),
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // SORT & COUNT BAR
            if (_viewMode == 'Results (F2)')
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('23 results', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    Row(
                      children: const [
                        Text('Sort: Most Relevant', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.sort, color: _stoneGrey, size: 16),
                      ],
                    ),
                  ],
                ),
              ),

            // MAIN CONTENT
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewMode == 'Initial (F1)') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, color: _stoneGrey, size: 48),
            SizedBox(height: 12),
            Text('Search Media', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Find photos, videos and documents by tag, dog or date', style: TextStyle(color: _stoneGrey, fontSize: 12)),
          ],
        ),
      );
    }

    if (_viewMode == 'No Results (F3)') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_not_supported_outlined, color: _stoneGrey, size: 48),
            SizedBox(height: 12),
            Text('No Media Found', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Try searching with different keywords or clearing filters', style: TextStyle(color: _stoneGrey, fontSize: 12)),
          ],
        ),
      );
    }

    // Results (F2) Grid
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (ctx, i) {
        final item = _searchResults[i];
        final type = item['type'] as String;
        final heart = item['heart'] as bool;

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
                    ? [const Color(0xFF1F2B26), const Color(0xFF121A17)]
                    : type == 'video'
                        ? [const Color(0xFF192226), const Color(0xFF11171A)]
                        : [const Color(0xFF222629), const Color(0xFF141719)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                if (type == 'doc')
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.description_outlined, color: _stoneGrey, size: 28),
                        const SizedBox(height: 4),
                        Text(item['title'] ?? 'Document', style: const TextStyle(color: _offWhite, fontSize: 9), textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          color: const Color(0xFF242A2E),
                          child: const Text('PDF', style: TextStyle(color: _stoneGrey, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                if (type == 'video')
                  Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, color: _offWhite, size: 20),
                    ),
                  ),
                if (type == 'video')
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Text(
                      item['duration'] ?? '',
                      style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (heart)
                  const Positioned(
                    bottom: 6,
                    right: 6,
                    child: Icon(Icons.favorite, color: Color(0xFFECC94B), size: 14),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
