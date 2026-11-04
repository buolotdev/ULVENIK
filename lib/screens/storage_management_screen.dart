import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'offline_mode_screen.dart';

class StorageManagementScreen extends StatefulWidget {
  const StorageManagementScreen({super.key});

  @override
  State<StorageManagementScreen> createState() =>
      _StorageManagementScreenState();
}

class _StorageManagementScreenState extends State<StorageManagementScreen>
    with TickerProviderStateMixin {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _bronze = Color(0xFF9B6B3D);
  static const Color _gold = Color(0xFFB8920A);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _destructive = Color(0xFF8B3A3A);
  static const Color _destructiveText = Color(0xFFA84646);

  late final AnimationController _chartController;
  late final Animation<double> _chartAnim;
  late final AnimationController _optimiseSpinController;

  // Storage buckets in MB (initial sum = 4340 MB -> 4.3 GB)
  int _photosMb = 480;
  List<(String, int, String)> _videoClips = [
    ('IGP Heelwork_4K.mp4', 840, 'Fenrir · Oct 26'),
    ('Hydro_Treadmill_Session12.mov', 690, 'Freya · Oct 22'),
    ('Recall_Field_Test_HD.mp4', 580, 'Odin · Oct 18'),
    ('Agility_Weave_Poles.mp4', 490, 'Fenrir · Oct 11'),
  ];
  final int _trainingRecordsMb = 180;
  final int _scRecordsMb = 96;
  final int _healthRecordsMb = 120;
  final int _timelineMb = 64;
  int _documentsMb = 180;
  int _cacheMb = 840;
  int _otherMb = 260;

  int _localDbMb = 124;
  final String _storedRecordsText = '4,218';
  String _lastOptimisedText = '3 days ago';
  bool _isOptimising = false;
  String? _selectedCategoryKey;

  // Baseline device available storage = 82.1 GB when 4340 MB used
  static const double _baselineAvailableGb = 82.1;
  static const int _baselineTotalMb = 4340;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _chartAnim = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutCubic,
    );
    _optimiseSpinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _chartController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    _optimiseSpinController.dispose();
    super.dispose();
  }

  int get _videosMb =>
      _videoClips.fold<int>(0, (sum, clip) => sum + clip.$2);

  int get _downloadsMb => _photosMb + _videosMb + _documentsMb;

  int get _totalStorageMb =>
      _photosMb +
      _videosMb +
      _trainingRecordsMb +
      _scRecordsMb +
      _healthRecordsMb +
      _timelineMb +
      _documentsMb +
      _cacheMb;

  String _formatSize(int mb) {
    if (mb >= 1000) {
      return '${(mb / 1000.0).toStringAsFixed(1)} GB';
    }
    return '$mb MB';
  }

  String get _availableGbLabel {
    final freedMb = _baselineTotalMb - _totalStorageMb;
    final currentAvail = _baselineAvailableGb + (freedMb / 1000.0);
    return '${currentAvail.toStringAsFixed(1)} GB';
  }

  String _percentOfTotal(int mb) {
    final total = _totalStorageMb;
    if (total <= 0 || mb <= 0) return '0% of total';
    final pct = ((mb / total) * 100).round().clamp(1, 100);
    return '$pct% of total';
  }

  void _clearCache() {
    if (_cacheMb == 0) {
      AppSnackbar.show(
        context,
        title: 'Cache Already Empty',
        message: '0 MB of temporary cache remaining.',
        type: SnackbarType.info,
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Clear Cache?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This will clear ${_formatSize(_cacheMb)} of temporary cached files. Your training records, media, and account data will not be affected.',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.45,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _cardBorder),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: _offWhite),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
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
                          final cleared = _cacheMb;
                          setState(() => _cacheMb = 0);
                          _chartController.forward(from: 0.0);
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Cache Cleared',
                            message:
                                'Removed $cleared MB of temporary cached files.',
                            type: SnackbarType.success,
                          );
                        },
                        child: const Text('Clear Cache'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _optimiseStorage() async {
    if (_isOptimising) return;
    setState(() => _isOptimising = true);
    _optimiseSpinController.repeat();

    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    _optimiseSpinController.stop();
    _optimiseSpinController.reset();

    final savedMb = _cacheMb + (_otherMb > 140 ? (_otherMb - 140) : 0) + 16;
    setState(() {
      _isOptimising = false;
      _cacheMb = 0;
      if (_otherMb > 140) _otherMb = 140;
      if (_localDbMb > 108) _localDbMb = 108;
      _lastOptimisedText = 'Just now';
    });
    _chartController.forward(from: 0.0);

    AppSnackbar.show(
      context,
      title: 'Storage Optimised',
      message: 'Reclaimed ${_formatSize(savedMb)} and compacted local database.',
      type: SnackbarType.success,
    );
  }

  void _showManageVideosSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _stoneGrey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Stored Videos · ${_formatSize(_videosMb)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_videoClips.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'All local video clips have been removed.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: _stoneGrey,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._videoClips.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final clip = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: _obsidian,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.videocam_outlined,
                                  color: _forest,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        clip.$1,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: _offWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${clip.$3} · ${clip.$2} MB',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: _stoneGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    setState(() {
                                      _videoClips = List.of(_videoClips)
                                        ..removeAt(idx);
                                    });
                                    setSheetState(() {});
                                    AppSnackbar.show(
                                      context,
                                      title: 'Clip Deleted Locally',
                                      message:
                                          'Freed ${clip.$2} MB (${clip.$1}).',
                                      type: SnackbarType.info,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: _destructiveText,
                                    size: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showManageDownloadedMediaSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Downloaded Media · ${_formatSize(_downloadsMb)}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Inspect individual video clips or adjust your offline download packages.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.videocam_outlined,
                    color: _forest,
                  ),
                  title: const Text(
                    'Inspect Individual Video Files',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                    ),
                  ),
                  subtitle: Text(
                    '${_videoClips.length} clips · ${_formatSize(_videosMb)}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: _stoneGrey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: _stoneGrey,
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    _showManageVideosSheet();
                  },
                ),
                Container(height: 1, color: _cardBorder),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.wifi_off_rounded,
                    color: _alpineBlue,
                  ),
                  title: const Text(
                    'Open Offline Mode & Downloads',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                    ),
                  ),
                  subtitle: const Text(
                    'Configure download quality & module selection',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: _stoneGrey,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: _stoneGrey,
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OfflineModeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmRemoveAllLocalDownloads() {
    if (_downloadsMb == 0) {
      AppSnackbar.show(
        context,
        title: 'No Local Downloads',
        message: 'All local media downloads have already been removed.',
        type: SnackbarType.info,
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Remove All Local Downloads?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This only removes downloaded/local copies (${_formatSize(_downloadsMb)} of photos, videos, and attachments) from this device. Your cloud data and account records will remain safe.',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.45,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _cardBorder),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: _offWhite),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _destructive,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final freed = _formatSize(_downloadsMb);
                          setState(() {
                            _photosMb = 0;
                            _videoClips = [];
                            _documentsMb = 0;
                          });
                          _chartController.forward(from: 0.0);
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Local Downloads Removed',
                            message: 'Freed $freed on this device.',
                            type: SnackbarType.success,
                          );
                        },
                        child: const Text('Remove All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('OVERVIEW'),
                    const SizedBox(height: 10),
                    _buildOverviewCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('BREAKDOWN'),
                    const SizedBox(height: 10),
                    _buildBreakdownCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('CACHE'),
                    const SizedBox(height: 10),
                    _buildCacheCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('DOWNLOADED MEDIA'),
                    const SizedBox(height: 10),
                    _buildDownloadedMediaCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('OPTIMISE'),
                    const SizedBox(height: 10),
                    _buildOptimiseCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('DATABASE'),
                    const SizedBox(height: 10),
                    _buildDatabaseCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('REMOVE'),
                    const SizedBox(height: 10),
                    _buildRemoveSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 14),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(_formatSize(_totalStorageMb)),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.chevron_left_rounded,
                color: _stoneGrey,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Storage Management',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _stoneGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    final segments = [
      ('Videos', _videosMb, _forest),
      ('Cached Files', _cacheMb, _bronze),
      ('Dog Photos', _photosMb, _alpineBlue),
      ('Training Records', _trainingRecordsMb, _mint),
      ('Documents & Attachments', _documentsMb, _sage),
      ('Health Records', _healthRecordsMb, _gold),
    ];
    final total = _totalStorageMb;

    return AnimatedBuilder(
      animation: _chartAnim,
      builder: (context, _) {
        final animatedMb = (total * _chartAnim.value).round();
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedCategoryKey != null
                    ? 'Ulvenik Storage · $_selectedCategoryKey'
                    : 'Ulvenik Storage',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  color: _stoneGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatSize(animatedMb),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _offWhite,
                  letterSpacing: -0.5,
                ),
              ),
              if (total > 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 6,
                    child: Row(
                      children: [
                        ...segments.map((seg) {
                          if (seg.$2 <= 0) return const SizedBox.shrink();
                          final dimmed = _selectedCategoryKey != null &&
                              _selectedCategoryKey != seg.$1;
                          return Expanded(
                            flex: (seg.$2 * _chartAnim.value).round().clamp(
                                  1,
                                  100000,
                                ),
                            child: Container(
                              margin: const EdgeInsets.only(right: 1.5),
                              color: dimmed
                                  ? seg.$3.withValues(alpha: 0.25)
                                  : seg.$3,
                            ),
                          );
                        }),
                        if (_chartAnim.value < 0.99)
                          Expanded(
                            flex: ((1.0 - _chartAnim.value) * total)
                                .round()
                                .clamp(1, 100000),
                            child: Container(color: _obsidian),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(height: 1, color: _cardBorder),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSubMetric('Available', _availableGbLabel),
                  ),
                  Expanded(
                    child: _buildSubMetric('Cache', _formatSize(_cacheMb)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildSubMetric(
                      'Downloads',
                      _formatSize(_downloadsMb),
                    ),
                  ),
                  Expanded(
                    child: _buildSubMetric(
                      'Other Files',
                      _formatSize(_otherMb),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: _stoneGrey,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: _offWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownCard() {
    final rows = [
      (
        'Dog Photos',
        _photosMb,
        const Icon(Icons.image_outlined, color: _stoneGrey, size: 19),
        false,
      ),
      (
        'Videos',
        _videosMb,
        const Icon(Icons.videocam_outlined, color: _stoneGrey, size: 19),
        true,
      ),
      (
        'Training Records',
        _trainingRecordsMb,
        const Icon(Icons.fitness_center_rounded, color: _stoneGrey, size: 18),
        false,
      ),
      (
        'S&C Records',
        _scRecordsMb,
        const Icon(Icons.monitor_heart_outlined, color: _stoneGrey, size: 19),
        false,
      ),
      (
        'Health Records',
        _healthRecordsMb,
        const Icon(Icons.favorite_border_rounded, color: _stoneGrey, size: 19),
        false,
      ),
      (
        'Timeline',
        _timelineMb,
        const Icon(Icons.timeline_rounded, color: _stoneGrey, size: 19),
        false,
      ),
      (
        'Documents & Attachments',
        _documentsMb,
        const Icon(Icons.description_outlined, color: _stoneGrey, size: 19),
        false,
      ),
      (
        'Cached Files',
        _cacheMb,
        const _StorageDbIcon(color: _stoneGrey),
        false,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final idx = entry.key;
          final r = entry.value;
          final isSelected = _selectedCategoryKey == r.$1;
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: _cardBorder),
              Material(
                color: isSelected
                    ? _forest.withValues(alpha: 0.12)
                    : Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (r.$4) {
                      _showManageVideosSheet();
                    } else {
                      setState(() {
                        _selectedCategoryKey = isSelected ? null : r.$1;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Center(child: r.$3),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.$1,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _offWhite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _percentOfTotal(r.$2),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: _stoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatSize(r.$2),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        if (r.$4) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _stoneGrey,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCacheCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cached Data',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: _offWhite,
                ),
              ),
              Text(
                _formatSize(_cacheMb),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: _stoneGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: _forest.withValues(alpha: 0.12),
                side: BorderSide(
                  color: _forest.withValues(alpha: 0.42),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _clearCache,
              icon: const Icon(
                Icons.cleaning_services_outlined,
                color: _forest,
                size: 17,
              ),
              label: const Text(
                'Clear Cache',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: _forest,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Removes temporary files only. Your data is never affected.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              height: 1.4,
              color: _stoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadedMediaCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _showManageDownloadedMediaSheet,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.download_rounded, color: _stoneGrey, size: 20),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Downloaded Media',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _offWhite,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'View and delete individual downloaded files',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        height: 1.35,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatSize(_downloadsMb),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  color: _stoneGrey,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: _stoneGrey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptimiseCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Removes expired cache, temporary files and duplicate cached media. Your content is never deleted.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.45,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _offWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _optimiseStorage,
              icon: RotationTransition(
                turns: _optimiseSpinController,
                child: const Icon(Icons.autorenew_rounded, size: 19),
              ),
              label: Text(
                _isOptimising ? 'Optimising Storage…' : 'Optimise Storage',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatabaseCard() {
    final rows = [
      ('Local Database Size', '$_localDbMb MB'),
      ('Stored Records', _storedRecordsText),
      ('Last Optimised', _lastOptimisedText),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final idx = entry.key;
          final r = entry.value;
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: _cardBorder),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const _StorageDbIcon(color: _stoneGrey),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        r.$1,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: _offWhite,
                        ),
                      ),
                    ),
                    Text(
                      r.$2,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRemoveSection() {
    return Column(
      children: [
        Material(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: _confirmRemoveAllLocalDownloads,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder, width: 1),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: _destructiveText,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Remove All Local Downloads',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _destructiveText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your cloud data and account information will remain safe.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: _stoneGrey,
          ),
        ),
      ],
    );
  }
}

class _StorageDbIcon extends StatelessWidget {
  final Color color;
  const _StorageDbIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 18),
      painter: _StorageDbPainter(color: color),
    );
  }
}

class _StorageDbPainter extends CustomPainter {
  final Color color;
  const _StorageDbPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawOval(const Rect.fromLTWH(2.5, 2.0, 13.0, 4.4), p);
    canvas.drawLine(const Offset(2.5, 4.2), const Offset(2.5, 13.8), p);
    canvas.drawLine(const Offset(15.5, 4.2), const Offset(15.5, 13.8), p);

    final midArc = Path()
      ..addArc(const Rect.fromLTWH(2.5, 6.8, 13.0, 4.4), 0, 3.14159);
    canvas.drawPath(midArc, p);

    final botArc = Path()
      ..addArc(const Rect.fromLTWH(2.5, 11.6, 13.0, 4.4), 0, 3.14159);
    canvas.drawPath(botArc, p);
  }

  @override
  bool shouldRepaint(covariant _StorageDbPainter oldDelegate) =>
      oldDelegate.color != color;
}
