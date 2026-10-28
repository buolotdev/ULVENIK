import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _pureBlack = Color(0xFF000000);
const Color _carbon = Color(0xFF1A1F22);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class VideoViewerScreen extends StatefulWidget {
  final String title;
  final String dogName;
  final String duration;

  const VideoViewerScreen({
    super.key,
    this.title = 'Bite Phase C — Escape & Full Grip (4K 60fps)',
    this.dogName = 'Koda • Belgian Malinois',
    this.duration = '03:45',
  });

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  bool _isPlaying = false;
  double _position = 0.38; // 38% played
  double _playbackSpeed = 1.0;
  bool _showControls = true;
  bool _isBookmarked = true;

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _skip(double delta) {
    setState(() {
      _position = (_position + delta).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSeconds = (_position * 225).toInt();
    final mins = currentSeconds ~/ 60;
    final secs = (currentSeconds % 60).toString().padLeft(2, '0');
    final formattedTime = '0$mins:$secs';

    return Scaffold(
      backgroundColor: _pureBlack,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => setState(() => _showControls = !_showControls),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. VIDEO VIEWPORT CANVAS
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF131718),
                      border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Icon(
                            Icons.videocam_outlined,
                            size: 80,
                            color: _mint.withValues(alpha: 0.25),
                          ),
                        ),
                        // Real-time telemetry HUD overlay on video
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: _mint.withValues(alpha: 0.4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.favorite, color: Colors.redAccent, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  '168 BPM • 24.2 KM/H',
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. OVERLAY CONTROLS (Fades in/out on tap)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showControls ? 1.0 : 0.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top App Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: _offWhite),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Text(
                                  widget.dogName,
                                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: _isBookmarked ? _mint : _offWhite,
                            ),
                            onPressed: () => setState(() => _isBookmarked = !_isBookmarked),
                          ),
                        ],
                      ),
                    ),

                    // Center Play / Pause & Skip Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10, color: _offWhite, size: 36),
                          onPressed: () => _skip(-0.05),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _forest,
                              border: Border.all(color: _mint, width: 2),
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: _offWhite,
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          icon: const Icon(Icons.forward_10, color: _offWhite, size: 36),
                          onPressed: () => _skip(0.05),
                        ),
                      ],
                    ),

                    // Bottom Scrubber & Toolbar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.95),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Scrubber Bar
                          Row(
                            children: [
                              Text(formattedTime, style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
                              Expanded(
                                child: Slider(
                                  value: _position,
                                  activeColor: _mint,
                                  inactiveColor: const Color(0xFF2E3236),
                                  onChanged: (val) => setState(() => _position = val),
                                ),
                              ),
                              Text(widget.duration, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Speed multipliers & actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [0.25, 0.5, 1.0, 1.5].map((speed) {
                                  final isSel = _playbackSpeed == speed;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () => setState(() => _playbackSpeed = speed),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isSel ? _forest : _carbon,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: isSel ? _mint : Colors.transparent),
                                        ),
                                        child: Text(
                                          '${speed}x',
                                          style: TextStyle(
                                            color: isSel ? _offWhite : _stoneGrey,
                                            fontSize: 11,
                                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share_outlined, color: _offWhite, size: 20),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Video link shared via system sheet.'), backgroundColor: _forest),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.fullscreen, color: _offWhite, size: 22),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
