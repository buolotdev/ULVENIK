import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class VideoViewerScreen extends StatefulWidget {
  final String title;
  final String dogName;
  final String duration;

  const VideoViewerScreen({
    super.key,
    this.title = 'Tracking Exercise — Session 14',
    this.dogName = 'Koda',
    this.duration = '1:34',
  });

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  bool _isPlaying = false;
  double _progress = 0.12;
  bool _isFavorite = true;
  double _speed = 1.0;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: _offWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // VIDEO VIEWPORT
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF152220), Color(0xFF0F1414)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: _offWhite,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                // Scrub bar & times
                Positioned(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      const Text('0:12', style: TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbColor: _mint,
                            activeTrackColor: _mint,
                            inactiveTrackColor: const Color(0xFF323B3E),
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: _progress,
                            onChanged: (v) => setState(() => _progress = v),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('1:34', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    ],
                  ),
                ),
                // Bottom control icons
                Positioned(
                  bottom: 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.volume_up_outlined, color: _offWhite, size: 20),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_speed == 1.0) {
                              _speed = 1.5;
                            } else if (_speed == 1.5) {
                              _speed = 2.0;
                            } else {
                              _speed = 1.0;
                            }
                          });
                        },
                        child: Text('${_speed == 1.0 ? '1' : _speed}x', style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.fullscreen, color: _offWhite, size: 22),
                    ],
                  ),
                ),
              ],
            ),
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
                      Text(
                        widget.title,
                        style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildMetaCol('DATE', '12 Jul 2026')),
                          Expanded(child: _buildMetaCol('DOG', widget.dogName)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMetaCol('DURATION', widget.duration)),
                          Expanded(child: _buildMetaCol('ACTIVITY', 'Tracking')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: _cardBorder),
                      const SizedBox(height: 8),
                      const Text(
                        '1080p • 47.2 MB',
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
                      _buildActionBtn(icon: Icons.open_in_new, label: 'Open', color: _stoneGrey, onTap: () {}),
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
                    'Koda showed strong focus today during the tracking sequence. Extended the search distance to 40m with consistent performance. No distractions from environmental stimuli.',
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
                  children: ['Tracking', 'Outdoor', 'Distance Work', 'Session'].map((tag) {
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

                // RELATED VIDEOS
                const Text(
                  'RELATED VIDEOS',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildVideoThumb('0:52', '10 Jul'),
                      const SizedBox(width: 8),
                      _buildVideoThumb('1:14', '8 Jul'),
                      const SizedBox(width: 8),
                      _buildVideoThumb('2:05', '5 Jul'),
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

  Widget _buildVideoThumb(String dur, String date) {
    return Container(
      width: 100,
      height: 72,
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder),
      ),
      padding: const EdgeInsets.all(6),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.play_arrow_outlined, color: _stoneGrey, size: 24)),
          Positioned(
            bottom: 0,
            left: 0,
            child: Text(dur, style: const TextStyle(color: _offWhite, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Text(date, style: const TextStyle(color: _stoneGrey, fontSize: 9)),
          ),
        ],
      ),
    );
  }
}
