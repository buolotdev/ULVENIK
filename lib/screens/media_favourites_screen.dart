import 'package:flutter/material.dart';
import 'photo_viewer_screen.dart';
import 'video_viewer_screen.dart';
import 'document_viewer_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class MediaFavouritesScreen extends StatefulWidget {
  final bool initialEmpty;

  const MediaFavouritesScreen({super.key, this.initialEmpty = false});

  @override
  State<MediaFavouritesScreen> createState() => _MediaFavouritesScreenState();
}

class _MediaFavouritesScreenState extends State<MediaFavouritesScreen> {
  String _screenMode = 'All';
  String _selectedTab = 'All';

  final List<Map<String, dynamic>> _favourites = [
    {
      'title': 'Agility Finals — Örebro',
      'tag': 'Photo',
      'dog': 'Zeus',
      'date': 'Added 1 day ago',
      'icon': Icons.image_outlined,
      'hasImage': true,
      'gradient': [Color(0xFF1F2B26), Color(0xFF121A17)],
    },
    {
      'title': 'Weave Pole Session #12',
      'tag': 'Video',
      'dog': 'Zeus',
      'date': 'Added 3 days ago',
      'icon': Icons.play_arrow,
      'hasImage': true,
      'gradient': [Color(0xFF192226), Color(0xFF11171A)],
    },
    {
      'title': 'Advanced Agility — Week 3',
      'tag': 'Training Session',
      'dog': 'Zeus',
      'date': 'Added 5 days ago',
      'icon': Icons.fitness_center_outlined,
      'hasImage': false,
      'gradient': null,
    },
    {
      'title': 'Morning Run — Pine Trail',
      'tag': 'Photo',
      'dog': 'Luna',
      'date': 'Added 1 week ago',
      'icon': Icons.image_outlined,
      'hasImage': true,
      'gradient': [Color(0xFF252D33), Color(0xFF13181C)],
    },
    {
      'title': 'Achieve Off-Lead Recall',
      'tag': 'Goal',
      'dog': 'Zeus',
      'date': 'Added 2 weeks ago',
      'icon': Icons.adjust_outlined,
      'hasImage': false,
      'gradient': null,
    },
    {
      'title': 'Vet Report — July 2026',
      'tag': 'Document',
      'dog': 'Luna',
      'date': 'Added 3 weeks ago',
      'icon': Icons.description_outlined,
      'hasImage': false,
      'gradient': null,
    },
  ];

  List<Map<String, dynamic>> get _displayList {
    if (_screenMode == 'Empty') return [];
    if (_screenMode == 'Photos' || _selectedTab == 'Photos') {
      return _favourites.where((f) => f['tag'] == 'Photo').toList();
    }
    if (_selectedTab == 'Videos') {
      return _favourites.where((f) => f['tag'] == 'Video').toList();
    }
    if (_selectedTab == 'Documents') {
      return _favourites.where((f) => f['tag'] == 'Document').toList();
    }
    if (_selectedTab == 'Training') {
      return _favourites.where((f) => f['tag'] == 'Training Session').toList();
    }
    return _favourites;
  }

  void _openItem(Map<String, dynamic> item) {
    final tag = item['tag'] as String;
    if (tag == 'Video') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoViewerScreen()));
    } else if (tag == 'Photo') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoViewerScreen()));
    } else if (tag == 'Document') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentViewerScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening ${item['title']}'), backgroundColor: _forest),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _displayList;

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
          'Favourites',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // SCREEN MODE SWITCHER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('SCREEN MODE', style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(width: 14),
                ...['All', 'Photos', 'Empty'].map((m) {
                  final isSel = _screenMode == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(m),
                      selected: isSel,
                      selectedColor: _forest,
                      backgroundColor: _carbon,
                      labelStyle: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 12, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _screenMode = m),
                    ),
                  );
                }),
              ],
            ),
          ),

          // TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Photos', 'Videos', 'Documents', 'Training', 'S&C'].map((tab) {
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
          ),
          const SizedBox(height: 8),

          // LIST OR EMPTY STATE
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.favorite_border, color: _stoneGrey, size: 48),
                        SizedBox(height: 12),
                        Text('No Favourites Yet', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Tap the heart icon on any photo, video, or session to save it here', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final item = list[i];
                      final hasImage = item['hasImage'] as bool;
                      final gradient = item['gradient'] as List<Color>?;

                      return Container(
                        decoration: BoxDecoration(
                          color: _carbon,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: InkWell(
                          onTap: () => _openItem(item),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF242A2E),
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: gradient != null
                                            ? LinearGradient(
                                                colors: gradient,
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : null,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          item['icon'] as IconData,
                                          color: hasImage ? _offWhite : _stoneGrey,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Icon(Icons.favorite, color: Color(0xFFECC94B), size: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF242A2E),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item['tag'] as String,
                                              style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '•  ${item['dog']}  •  ${item['date']}',
                                            style: const TextStyle(color: _stoneGrey, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
