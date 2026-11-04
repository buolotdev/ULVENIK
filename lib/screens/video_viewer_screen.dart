import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class RelatedVideoClip {
  final String id;
  final String title;
  final String dateLabel;
  final String fullDate;
  final String dogName;
  final String activity;
  final int durationSeconds;
  final String resolutionAndSize;
  final String notes;
  final List<String> tags;

  const RelatedVideoClip({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.fullDate,
    required this.dogName,
    required this.activity,
    required this.durationSeconds,
    required this.resolutionAndSize,
    required this.notes,
    required this.tags,
  });

  String get formattedDuration {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class VideoViewerScreen extends StatefulWidget {
  final String title;
  final String fullDate;
  final String dogName;
  final String activity;
  final int durationSeconds;
  final String resolutionAndSize;
  final bool initialFavourite;
  final bool hasSportPack;

  const VideoViewerScreen({
    super.key,
    this.title = 'Tracking Exercise — Session 14',
    this.fullDate = '12 Jul 2026',
    this.dogName = 'Koda',
    this.activity = 'Tracking',
    this.durationSeconds = 94, // 1:34
    this.resolutionAndSize = '1080p · 47.2 MB',
    this.initialFavourite = true,
    this.hasSportPack = true,
  });

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  static const Color _black = AppColors.mediaViewerBackground; // #000000
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _favGold = AppColors.favouriteGold;

  static const List<double> _speeds = [0.5, 1.0, 2.0];

  late String _title;
  late String _fullDate;
  late String _dogName;
  late String _activity;
  late int _totalSeconds;
  late String _resolutionAndSize;
  late bool _isFavourite;
  late String _notes;
  late List<String> _tags;

  double _currentSeconds = 12.0; // Matches 0:12 in Figma
  int _frameOffset = 0; // Sub-second frame step counter (0..29 fps)
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showChrome = true;
  bool _isDownloaded = false;
  int _speedIndex = 1; // 1.0x
  String? _selectedTag;
  Timer? _playbackTimer;

  final List<RelatedVideoClip> _relatedClips = const [
    RelatedVideoClip(
      id: 'rv1',
      title: 'Scent Article Indication — Session 13',
      dateLabel: '10 Jul',
      fullDate: '10 Jul 2026',
      dogName: 'Koda',
      activity: 'Tracking',
      durationSeconds: 52,
      resolutionAndSize: '1080p · 28.4 MB',
      notes:
          'Practised passive down indication on a leather scent article in damp bracken across two 90-degree corners.',
      tags: ['Tracking', 'Scent Article', 'Corners', 'Session 13'],
    ),
    RelatedVideoClip(
      id: 'rv2',
      title: 'Woodland Line Handling — Session 12',
      dateLabel: '8 Jul',
      fullDate: '8 Jul 2026',
      dogName: 'Koda',
      activity: 'Tracking',
      durationSeconds: 74,
      resolutionAndSize: '1080p · 38.9 MB',
      notes:
          'Worked with a 10m tracking line through dense pine cover and practised pace transitions over fallen timber.',
      tags: ['Tracking', 'Woodland', 'Line Tension', 'Session 12'],
    ),
    RelatedVideoClip(
      id: 'rv3',
      title: 'Cross-Track Distraction Proofing — Session 11',
      dateLabel: '4 Jul',
      fullDate: '4 Jul 2026',
      dogName: 'Koda',
      activity: 'Tracking',
      durationSeconds: 125,
      resolutionAndSize: '4K · 96.1 MB',
      notes:
          'Laid track across a woodland path at the 25m mark; Koda paused briefly at the crossing then stayed on the main track.',
      tags: ['Tracking', 'Proofing', 'Outdoor', 'Session 11'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _fullDate = widget.fullDate;
    _dogName = widget.dogName;
    _activity = widget.activity;
    _totalSeconds = widget.durationSeconds > 0 ? widget.durationSeconds : 94;
    if (_currentSeconds > _totalSeconds) {
      _currentSeconds = (_totalSeconds * 0.2).clamp(0.0, _totalSeconds.toDouble());
    }
    _resolutionAndSize = widget.resolutionAndSize;
    _isFavourite = widget.initialFavourite;
    _notes =
        'Extended our woodland track distance to 40m today. Placed three leather articles along the line — Koda worked steadily through the turn and indicated all three.';
    _tags = ['Tracking', 'Outdoor', 'Distance Work', 'Session 14'];
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  double get _currentSpeed => _speeds[_speedIndex];

  String get _speedLabel {
    final s = _currentSpeed;
    if (s == 1.0) return '1×';
    if (s == 2.0) return '2×';
    return '0.5×';
  }

  String _formatSeconds(int sec) {
    final clamped = sec.clamp(0, _totalSeconds);
    final m = clamped ~/ 60;
    final s = clamped % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying && _currentSeconds >= _totalSeconds) {
        _currentSeconds = 0;
        _frameOffset = 0;
      }
    });
    _syncTimer();
  }

  void _syncTimer() {
    _playbackTimer?.cancel();
    if (!_isPlaying) return;
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      setState(() {
        final next = _currentSeconds + 0.25 * _currentSpeed;
        if (next >= _totalSeconds) {
          _currentSeconds = _totalSeconds.toDouble();
          _isPlaying = false;
          _playbackTimer?.cancel();
        } else {
          _currentSeconds = next;
        }
      });
    });
  }

  void _cycleSpeed() {
    setState(() {
      _speedIndex = (_speedIndex + 1) % _speeds.length;
    });
    if (_isPlaying) {
      _syncTimer();
    }
    AppSnackbar.show(
      context,
      title: 'Playback Speed: $_speedLabel',
      message: 'Video playback adjusted to $_speedLabel.',
      type: SnackbarType.info,
      duration: const Duration(seconds: 2),
    );
  }

  void _stepFrame(int deltaFrames) {
    _playbackTimer?.cancel();
    setState(() {
      _isPlaying = false;
      int totalFrames = (_currentSeconds * 30).round() + _frameOffset + deltaFrames;
      final maxFrames = _totalSeconds * 30;
      totalFrames = totalFrames.clamp(0, maxFrames);
      _currentSeconds = totalFrames / 30.0;
      _frameOffset = 0;
    });
  }

  void _loadRelatedClip(RelatedVideoClip clip) {
    _playbackTimer?.cancel();
    setState(() {
      _title = clip.title;
      _fullDate = clip.fullDate;
      _dogName = clip.dogName;
      _activity = clip.activity;
      _totalSeconds = clip.durationSeconds;
      _resolutionAndSize = clip.resolutionAndSize;
      _notes = clip.notes;
      _tags = List<String>.from(clip.tags);
      _currentSeconds = 0;
      _frameOffset = 0;
      _isPlaying = true;
      _showChrome = true;
    });
    _syncTimer();
  }

  void _openFullscreenOverlay() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (ctx) {
          bool fsChrome = true;
          return StatefulBuilder(
            builder: (ctx, setFsState) {
              return Scaffold(
                backgroundColor: _black,
                body: SafeArea(
                  child: GestureDetector(
                    onTap: () => setFsState(() => fsChrome = !fsChrome),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Image.asset(
                              'assets/images/video_viewer_thumb.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (fsChrome) ...[
                          Positioned(
                            top: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  icon: const Icon(
                                    Icons.fullscreen_exit_rounded,
                                    color: _offWhite,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: _offWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildFrameStepButton(
                                  label: '-1f',
                                  onTap: () {
                                    _stepFrame(-1);
                                    setFsState(() {});
                                  },
                                ),
                                const SizedBox(width: 18),
                                GestureDetector(
                                  onTap: () {
                                    _togglePlayPause();
                                    setFsState(() {});
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.55),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _offWhite.withValues(alpha: 0.65),
                                      ),
                                    ),
                                    child: Icon(
                                      _isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_outlined,
                                      color: _offWhite,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                _buildFrameStepButton(
                                  label: '+1f',
                                  onTap: () {
                                    _stepFrame(1);
                                    setFsState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditNotesSheet() {
    final controller = TextEditingController(text: _notes);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Video Notes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: _offWhite,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _offWhite,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() => _notes = controller.text.trim());
                    Navigator.pop(ctx);
                    AppSnackbar.show(
                      context,
                      title: 'Notes Saved',
                      message: 'Session video notes updated.',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Save Notes',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOverflowMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _stoneGrey.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.edit_note_rounded, color: _offWhite),
                  title: const Text(
                    'Edit Session Notes',
                    style: TextStyle(fontFamily: 'Inter', color: _offWhite),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _showEditNotesSheet();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.speed_rounded, color: _offWhite),
                  title: Text(
                    'Cycle Playback Speed ($_speedLabel)',
                    style: const TextStyle(fontFamily: 'Inter', color: _offWhite),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _cycleSpeed();
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _showChrome
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _offWhite,
                  ),
                  title: Text(
                    _showChrome ? 'Hide Video Controls' : 'Show Video Controls',
                    style: const TextStyle(fontFamily: 'Inter', color: _offWhite),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _showChrome = !_showChrome);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLinkedRecordSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training Session — $_fullDate',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_activity · 45 min · $_dogName · Pine Ridge Sector B',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MiniStat(label: 'DISTANCE', value: '40 m'),
                      _MiniStat(label: 'ARTICLES', value: '3 / 3'),
                      _MiniStat(label: 'DURATION', value: '45 min'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Video?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: _offWhite,
          ),
        ),
        content: Text(
          'Remove "$_title" from your Media Library? Linked session logs will remain intact.',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            color: _stoneGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Inter', color: _stoneGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).maybePop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: AppColors.errorDestructive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pure #000000 black background, NO bottom navigation bar!
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVideoCanvas(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetadataCard(),
                          const SizedBox(height: 12),
                          _buildActionStripCard(),
                          const SizedBox(height: 22),
                          _buildSectionLabel('LINKED RECORD'),
                          const SizedBox(height: 10),
                          _buildLinkedRecordCard(),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSectionLabel('NOTES'),
                              GestureDetector(
                                onTap: _showEditNotesSheet,
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _forest,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildNotesCard(),
                          const SizedBox(height: 22),
                          _buildSectionLabel('TAGS'),
                          const SizedBox(height: 10),
                          _buildTagsRow(),
                          const SizedBox(height: 22),
                          _buildSectionLabel('RELATED VIDEOS'),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    _buildRelatedVideosStrip(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      color: _black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _stoneGrey,
              size: 26,
            ),
            tooltip: 'Back',
          ),
          IconButton(
            onPressed: _showOverflowMenu,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: _stoneGrey,
              size: 20,
            ),
            tooltip: 'More Options',
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCanvas() {
    final progress = (_currentSeconds / _totalSeconds).clamp(0.0, 1.0);
    return GestureDetector(
      onTap: () => setState(() => _showChrome = !_showChrome),
      child: SizedBox(
        width: double.infinity,
        height: 232,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: _isPlaying ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 600),
              child: Image.asset(
                'assets/images/video_viewer_thumb.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.78),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            if (_showChrome) ...[
              // Center Play/Pause + Frame Step controls
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFrameStepButton(
                      label: '-1f',
                      onTap: () => _stepFrame(-1),
                    ),
                    const SizedBox(width: 18),
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.46),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _offWhite.withValues(alpha: 0.65),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_outlined,
                          color: _offWhite,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    _buildFrameStepButton(
                      label: '+1f',
                      onTap: () => _stepFrame(1),
                    ),
                  ],
                ),
              ),
              // Scrubber + transport row at bottom
              Positioned(
                left: 14,
                right: 14,
                bottom: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatSeconds(_currentSeconds.round()),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: _offWhite,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3.5,
                              activeTrackColor: _forest,
                              inactiveTrackColor:
                                  _offWhite.withValues(alpha: 0.28),
                              thumbColor: _forest,
                              overlayColor: _forest.withValues(alpha: 0.22),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.5,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                            ),
                            child: Slider(
                              value: progress,
                              onChanged: (v) {
                                setState(() {
                                  _currentSeconds = v * _totalSeconds;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatSeconds(_totalSeconds),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: _offWhite,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _isMuted = !_isMuted),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Icon(
                              _isMuted
                                  ? Icons.volume_off_outlined
                                  : Icons.volume_up_outlined,
                              color: _offWhite.withValues(alpha: 0.9),
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _cycleSpeed,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              _speedLabel,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: _offWhite,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _openFullscreenOverlay,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            child: Icon(
                              Icons.crop_free_rounded,
                              color: _offWhite.withValues(alpha: 0.9),
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFrameStepButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.48),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _offWhite.withValues(alpha: 0.25)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _offWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    return Container(
      width: double.infinity,
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
            _title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 17.5,
              fontWeight: FontWeight.w700,
              color: _offWhite,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetaField('DATE', _fullDate)),
              Expanded(child: _buildMetaField('DOG', _dogName)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetaField(
                  'DURATION',
                  _formatSeconds(_totalSeconds),
                ),
              ),
              Expanded(child: _buildMetaField('ACTIVITY', _activity)),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 12),
          Text(
            _resolutionAndSize,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: _stoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: _stoneGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: _offWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildActionStripCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(
            icon: _isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: _isFavourite ? _favGold : _stoneGrey,
            label: 'Favourite',
            onTap: () {
              setState(() => _isFavourite = !_isFavourite);
              AppSnackbar.show(
                context,
                title: _isFavourite
                    ? 'Added to Favourites'
                    : 'Removed from Favourites',
                message: _title,
                type: _isFavourite ? SnackbarType.success : SnackbarType.info,
              );
            },
          ),
          _buildActionItem(
            icon: Icons.ios_share_rounded,
            iconColor: _stoneGrey,
            label: 'Share',
            onTap: () {
              AppSnackbar.show(
                context,
                title: 'Share Clip',
                message: 'Prepared shareable link for $_title.',
                type: SnackbarType.info,
              );
            },
          ),
          _buildActionItem(
            icon: _isDownloaded
                ? Icons.download_done_rounded
                : Icons.download_rounded,
            iconColor: _isDownloaded ? _forest : _stoneGrey,
            label: _isDownloaded ? 'Saved' : 'Download',
            onTap: () {
              setState(() => _isDownloaded = true);
              AppSnackbar.show(
                context,
                title: 'Saved Offline',
                message: '$_title ($_resolutionAndSize) stored on device.',
                type: SnackbarType.success,
              );
            },
          ),
          _buildActionItem(
            icon: Icons.open_in_new_rounded,
            iconColor: _stoneGrey,
            label: 'Open Record',
            onTap: _showLinkedRecordSheet,
          ),
          _buildActionItem(
            icon: Icons.delete_outline_rounded,
            iconColor: _stoneGrey,
            label: 'Delete',
            onTap: _confirmDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 21),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _stoneGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: _stoneGrey,
      ),
    );
  }

  Widget _buildLinkedRecordCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _showLinkedRecordSheet,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _cardBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: _stoneGrey,
                size: 21,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Training Session — $_fullDate',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$_activity · 45 min · $_dogName',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _stoneGrey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Text(
        _notes,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.5,
          height: 1.5,
          color: _stoneGrey,
        ),
      ),
    );
  }

  Widget _buildTagsRow() {
    final visibleTags = _tags
        .where(
          (tag) =>
              widget.hasSportPack ||
              !tag.toLowerCase().contains('competition'),
        )
        .toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: visibleTags.map((tag) {
          final selected = _selectedTag == tag;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTag = selected ? null : tag;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: selected ? _forest.withValues(alpha: 0.22) : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? _forest : _cardBorder,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: selected ? _offWhite : _stoneGrey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRelatedVideosStrip() {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _relatedClips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final clip = _relatedClips[index];
          final isCurrent = _title == clip.title;
          return GestureDetector(
            onTap: () => _loadRelatedClip(clip),
            child: Container(
              width: 138,
              decoration: BoxDecoration(
                color: const Color(0xFF15191C),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCurrent ? _forest : _cardBorder,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.play_arrow_outlined,
                      color: _stoneGrey.withValues(alpha: 0.55),
                      size: 30,
                    ),
                  ),
                  Positioned(
                    left: 7,
                    bottom: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        clip.formattedDuration,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: _offWhite,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Text(
                      clip.dateLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextOffWhite,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: AppColors.secondaryTextStoneGrey,
          ),
        ),
      ],
    );
  }
}
