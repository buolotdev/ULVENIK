import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class MediaCollectionsScreen extends StatefulWidget {
  const MediaCollectionsScreen({super.key});

  @override
  State<MediaCollectionsScreen> createState() => _MediaCollectionsScreenState();
}

class _MediaCollectionsScreenState extends State<MediaCollectionsScreen> {
  final List<Map<String, dynamic>> _collections = [
    {
      'title': 'Agility Training — Summer 2026',
      'subtitle': '24 items • Updated 2 days ago',
      'hasImage': true,
      'gradient': [Color(0xFF1F2B26), Color(0xFF121A17)],
    },
    {
      'title': 'Vet Visit Records',
      'subtitle': '8 items • Updated 1 week ago',
      'hasImage': true,
      'gradient': [Color(0xFF262D24), Color(0xFF151914)],
    },
    {
      'title': 'Competition Day — Open Trial',
      'subtitle': '17 items • Updated 3 weeks ago',
      'hasImage': true,
      'gradient': [Color(0xFF252D33), Color(0xFF13181C)],
    },
    {
      'title': 'Scent & Search Trials',
      'subtitle': '31 items • Updated 1 month ago',
      'hasImage': true,
      'gradient': [Color(0xFF2A2A2E), Color(0xFF161619)],
    },
    {
      'title': 'Obedience Notes & Badges',
      'subtitle': '5 items • Updated 2 months ago',
      'hasImage': false,
      'gradient': null,
    },
  ];

  void _createCollection() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Collection', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: _offWhite),
          decoration: const InputDecoration(
            hintText: 'Collection Name (e.g. Scent Drills)',
            hintStyle: TextStyle(color: _stoneGrey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: _stoneGrey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _forest),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _collections.insert(0, {
                    'title': controller.text.trim(),
                    'subtitle': '0 items • Created just now',
                    'hasImage': false,
                    'gradient': null,
                  });
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create', style: TextStyle(color: _offWhite)),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Collections',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.view_agenda_outlined, color: _offWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite),
            onPressed: _createCollection,
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _collections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final c = _collections[i];
          final hasImage = c['hasImage'] as bool;
          final gradient = c['gradient'] as List<Color>?;

          return Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening ${c['title']}'), backgroundColor: _forest),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
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
                      child: hasImage
                          ? const Center(child: Icon(Icons.pets, color: _mint, size: 28))
                          : const Center(child: Icon(Icons.folder_outlined, color: _stoneGrey, size: 30)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['title'] as String,
                            style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c['subtitle'] as String,
                            style: const TextStyle(color: _stoneGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: _stoneGrey, size: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
