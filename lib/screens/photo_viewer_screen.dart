import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class PhotoViewerScreen extends StatefulWidget {
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    this.initialIndex = 2,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late int _currentIndex;
  bool _isFavorite = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
          'Koda Training Session',
          style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: _offWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // PHOTO VIEWPORT WITH CONTROLS
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 260,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E2822), Color(0xFF101513)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.pets, color: _mint, size: 72),
                ),
              ),
              Positioned(
                left: 12,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 22),
                  onPressed: () {
                    if (_currentIndex > 0) setState(() => _currentIndex--);
                  },
                ),
              ),
              Positioned(
                right: 12,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 22),
                  onPressed: () {
                    if (_currentIndex < 11) setState(() => _currentIndex++);
                  },
                ),
              ),
              Positioned(
                bottom: 12,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentIndex + 1} of 12',
                    style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // METADATA CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tracking — Outdoor Session',
                        style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildMetaCol('DATE', '12 Jul 2026')),
                          Expanded(child: _buildMetaCol('DOG', 'Koda')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMetaCol('TIME', '10:24 AM')),
                          Expanded(child: _buildMetaCol('ACTIVITY', 'Tracking')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: _cardBorder),
                      const SizedBox(height: 8),
                      const Text(
                        '4032 × 3024 • 3.8 MB',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ACTION BUTTONS BAR
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionBtn(
                        icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: 'Favourite',
                        color: _isFavorite ? const Color(0xFFECC94B) : _stoneGrey,
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                      ),
                      _buildActionBtn(icon: Icons.share_outlined, label: 'Share', color: _stoneGrey, onTap: () {}),
                      _buildActionBtn(icon: Icons.download_outlined, label: 'Download', color: _stoneGrey, onTap: () {}),
                      _buildActionBtn(icon: Icons.open_in_new, label: 'Open Record', color: _stoneGrey, onTap: () {}),
                      _buildActionBtn(icon: Icons.delete_outline, label: 'Delete', color: _stoneGrey, onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // LINKED RECORD
                const Text(
                  'LINKED RECORD',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined, color: _stoneGrey, size: 22),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Training Session — 12 Jul 2026',
                              style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text('Tracking • 45 min • Koda', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // NOTES
                const Text(
                  'NOTES',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Text(
                    'Strong focus maintained throughout the tracking sequence. Extended search distance to 40m. Photo taken at peak engagement — Koda locked onto the scent track with no environmental distraction.',
                    style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                  ),
                ),
                const SizedBox(height: 24),

                // TAGS
                const Text(
                  'TAGS',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['Tracking', 'Outdoor', 'Distance Work', 'Competition'].map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Text(tag, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // RELATED PHOTOS
                const Text(
                  'RELATED PHOTOS',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildThumb('12 Jul', false),
                      const SizedBox(width: 8),
                      _buildThumb('10 Jul', false),
                      const SizedBox(width: 8),
                      _buildThumb('8 Jul', true),
                      const SizedBox(width: 8),
                      _buildThumb('5 Jul', false),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildThumb(String date, bool isSelected) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? _mint : _cardBorder, width: isSelected ? 2 : 1),
        gradient: const LinearGradient(
          colors: [Color(0xFF222B27), Color(0xFF131A16)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          date,
          style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
