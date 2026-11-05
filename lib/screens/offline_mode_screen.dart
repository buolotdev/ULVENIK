import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen>
    with SingleTickerProviderStateMixin {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _selectedRowBg = Color(0xFF242B2F);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _bronze = Color(0xFF9B6B3D);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _switchOffTrack = Color(0xFF2B3135);
  static const Color _destructive = Color(0xFF8B3A3A);
  static const Color _destructiveText = Color(0xFFA84646);

  late final AnimationController _entranceController;
  late final Animation<double> _barAnim;

  bool _offlineEnabled = true;
  String _selectedQuality = 'Balanced';
  bool _justSaved = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _lastUpdatedLabel = 'Today · 08:14';
  String? _selectedStorageCategory;

  // Base free space when 3.2 GB (3200 MB) is downloaded = 12.4 GB -> capacity pool 15.6 GB
  static const double _devicePoolGb = 15.6;

  late Map<String, bool> _availableOffline;
  late Map<String, int> _storageMb;

  @override
  void initState() {
    super.initState();
    _availableOffline = {
      'Dog Profiles': true,
      'Training Records': true,
      'S&C Records': true,
      'Health Records': true,
      'Goals': true,
      'Timeline': true,
      'Statistics': true,
      'Videos': true,
      'Photos': true,
      'Documents & Attachments': false,
    };
    _storageMb = {
      'Videos': 2400,
      'Photos': 480,
      'Training Records': 180,
      'Health Records': 96,
      'Documents': 64,
    };

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _barAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  int get _totalUsedMb =>
      _storageMb.values.fold<int>(0, (sum, item) => sum + item);

  double get _totalUsedGb => _totalUsedMb / 1006.25; // 3220 MB -> 3.2 GB exact

  String _formatStorageSize(int mb) {
    if (mb >= 1000) {
      final gb = mb / 1000.0;
      return '${gb.toStringAsFixed(1)} GB';
    }
    return '$mb MB';
  }

  String get _formattedTotalUsed {
    if (_totalUsedMb == 0) return '0 MB';
    if (_totalUsedMb >= 1000) {
      return '${_totalUsedGb.toStringAsFixed(1)} GB';
    }
    return '$_totalUsedMb MB';
  }

  String get _formattedFreeStorage {
    final free = (_devicePoolGb - _totalUsedGb).clamp(0.0, _devicePoolGb);
    return '${free.toStringAsFixed(1)} GB free';
  }

  void _markSaved() {
    setState(() => _justSaved = true);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _justSaved = false);
    });
  }

  Future<void> _downloadLatestData() async {
    if (_isDownloading) return;
    if (!_offlineEnabled) {
      AppSnackbar.show(
        context,
        title: 'Offline Mode Disabled',
        message: 'Enable Offline Mode above to download local packages.',
        type: SnackbarType.warning,
      );
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.1;
    });

    for (final p in [0.35, 0.65, 0.9, 1.0]) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      setState(() => _downloadProgress = p);
    }

    final qualityMult = _selectedQuality == 'High Quality'
        ? 1.25
        : (_selectedQuality == 'Data Saver' ? 0.65 : 1.0);

    final now = TimeOfDay.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');

    setState(() {
      _isDownloading = false;
      _lastUpdatedLabel = 'Today · $hh:$mm';
      _storageMb = {
        'Videos': (_availableOffline['Videos'] ?? false)
            ? (2400 * qualityMult).round()
            : 0,
        'Photos': (_availableOffline['Photos'] ?? false)
            ? (480 * qualityMult).round()
            : 0,
        'Training Records': (_availableOffline['Training Records'] ?? false)
            ? 180
            : 0,
        'Health Records': (_availableOffline['Health Records'] ?? false)
            ? 96
            : 0,
        'Documents': (_availableOffline['Documents & Attachments'] ?? false)
            ? 92
            : 64,
      };
    });
    _entranceController.forward(from: 0.0);
    _markSaved();

    AppSnackbar.show(
      context,
      title: 'Offline Data Updated',
      message:
          'Downloaded $_formattedTotalUsed ($_selectedQuality) for offline field use.',
      type: SnackbarType.success,
    );
  }

  void _confirmRemoveAll() {
    if (_totalUsedMb == 0) {
      AppSnackbar.show(
        context,
        title: 'Nothing to Remove',
        message: 'Local offline cache is already empty.',
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
                  'Remove Downloaded Content?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This only removes downloaded/local copies ($_formattedTotalUsed) from this device. Your cloud data and account records will remain safe.',
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
                          final freed = _formattedTotalUsed;
                          setState(() {
                            _storageMb = {
                              'Videos': 0,
                              'Photos': 0,
                              'Training Records': 0,
                              'Health Records': 0,
                              'Documents': 0,
                            };
                            _selectedStorageCategory = null;
                          });
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Offline Content Removed',
                            message: 'Freed $freed of local device storage.',
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
                    _buildSectionHeader('OFFLINE MODE'),
                    const SizedBox(height: 10),
                    _buildOfflineMasterCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('AVAILABLE OFFLINE'),
                    const SizedBox(height: 10),
                    _buildAvailableOfflineCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('DOWNLOAD QUALITY'),
                    const SizedBox(height: 10),
                    _buildDownloadQualityCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('DOWNLOAD'),
                    const SizedBox(height: 10),
                    _buildDownloadActionCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('STORAGE'),
                    const SizedBox(height: 10),
                    _buildStorageBreakdownCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('REMOVE'),
                    const SizedBox(height: 10),
                    _buildRemoveCard(),
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
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: UlvenikIcon(UlvenikIcons.back,
                color: _stoneGrey,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Offline Mode & Downloads',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: _justSaved ? _forest : _stoneGrey,
            ),
            child: const Text('Saved'),
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
    return AnimatedBuilder(
      animation: _barAnim,
      builder: (context, _) {
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: _offlineEnabled ? _forest : _stoneGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _offlineEnabled ? 'Enabled' : 'Disabled',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: _offWhite,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Offline Mode',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formattedTotalUsed,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Downloaded',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lastUpdatedLabel,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Last Updated',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formattedFreeStorage,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Device Storage',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
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

  Widget _buildOfflineMasterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.overflowMenu, color: _stoneGrey, size: 20),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Offline Mode',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _offWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Store essential content locally for access without an internet connection',
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
          const SizedBox(width: 12),
          _OfflineSwitch(
            value: _offlineEnabled,
            onChanged: (v) {
              setState(() => _offlineEnabled = v);
              _markSaved();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableOfflineCard() {
    final rows = [
      (Icons.person_outline_rounded, 'Dog Profiles'),
      (Icons.fitness_center_rounded, 'Training Records'),
      (Icons.monitor_heart_outlined, 'S&C Records'),
      (Icons.favorite_border_rounded, 'Health Records'),
      (Icons.track_changes_rounded, 'Goals'),
      (Icons.timeline_rounded, 'Timeline'),
      (Icons.bar_chart_rounded, 'Statistics'),
      (Icons.videocam_outlined, 'Videos'),
      (Icons.image_outlined, 'Photos'),
      (Icons.description_outlined, 'Documents & Attachments'),
    ];

    return Opacity(
      opacity: _offlineEnabled ? 1.0 : 0.45,
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: rows.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final enabled =
                _offlineEnabled && (_availableOffline[item.$2] ?? false);
            return Column(
              children: [
                if (idx > 0) Container(height: 1, color: _cardBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      UlvenikIcon.fromMaterial(item.$1, color: _stoneGrey, size: 19),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.$2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: _offWhite,
                          ),
                        ),
                      ),
                      _OfflineSwitch(
                        value: enabled,
                        onChanged: (v) {
                          setState(() {
                            if (!_offlineEnabled) _offlineEnabled = true;
                            _availableOffline[item.$2] = v;
                          });
                          _markSaved();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDownloadQualityCard() {
    const qualities = [
      ('High Quality', 'Larger files, best detail'),
      ('Balanced', 'Recommended for most users'),
      ('Data Saver', 'Smaller files, reduced quality'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...qualities.asMap().entries.map((entry) {
            final idx = entry.key;
            final q = entry.value;
            final selected = _selectedQuality == q.$1;
            return Column(
              children: [
                if (idx > 0) Container(height: 1, color: _cardBorder),
                Material(
                  color: selected ? _selectedRowBg : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedQuality = q.$1);
                      _markSaved();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q.$1,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: _offWhite,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  q.$2,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.5,
                                    color: _stoneGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            const UlvenikIcon(UlvenikIcons.completed,
                              color: _forest,
                              size: 19,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          Container(height: 1, color: _cardBorder),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Applies to newly downloaded media only. Previously downloaded files are unchanged.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.4,
                color: _stoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadActionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        children: [
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
              onPressed: _downloadLatestData,
              icon: const UlvenikIcon(UlvenikIcons.overflowMenu, size: 19),
              label: Text(
                _isDownloading
                    ? 'Downloading (${(_downloadProgress * 100).round()}%)…'
                    : 'Download Latest Data',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (_isDownloading) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _downloadProgress,
                minHeight: 4,
                backgroundColor: _obsidian,
                valueColor: const AlwaysStoppedAnimation<Color>(_mint),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Downloads all selected content to your device',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: _stoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageBreakdownCard() {
    final items = [
      ('Videos', Icons.videocam_outlined, _forest),
      ('Photos', Icons.image_outlined, _alpineBlue),
      ('Training Records', Icons.fitness_center_rounded, _mint),
      ('Health Records', Icons.favorite_border_rounded, _bronze),
      ('Documents', Icons.description_outlined, _sage),
    ];

    final totalMb = _totalUsedMb;

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final it = entry.value;
            final mb = _storageMb[it.$1] ?? 0;
            final isSelected = _selectedStorageCategory == it.$1;
            return Column(
              children: [
                if (idx > 0) Container(height: 1, color: _cardBorder),
                Material(
                  color: isSelected
                      ? it.$3.withValues(alpha: 0.10)
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedStorageCategory = isSelected ? null : it.$1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          UlvenikIcon.fromMaterial(
                            it.$2,
                            color: isSelected ? it.$3 : _stoneGrey,
                            size: 19,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              it.$1,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: _offWhite,
                              ),
                            ),
                          ),
                          Text(
                            _formatStorageSize(mb),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _stoneGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          Container(height: 1, color: _cardBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (totalMb > 0) ...[
                  AnimatedBuilder(
                    animation: _barAnim,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 6,
                          child: Row(
                            children: [
                              ...items.map((it) {
                                final mb = _storageMb[it.$1] ?? 0;
                                if (mb <= 0) return const SizedBox.shrink();
                                final dimmed =
                                    _selectedStorageCategory != null &&
                                        _selectedStorageCategory != it.$1;
                                return Expanded(
                                  flex: (mb * _barAnim.value).round().clamp(
                                        1,
                                        100000,
                                      ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 1.5),
                                    color: dimmed
                                        ? it.$3.withValues(alpha: 0.28)
                                        : it.$3,
                                  ),
                                );
                              }),
                              if (_barAnim.value < 0.99)
                                Expanded(
                                  flex: ((1.0 - _barAnim.value) * totalMb)
                                      .round()
                                      .clamp(1, 100000),
                                  child: Container(color: _obsidian),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedStorageCategory != null
                          ? '$_selectedStorageCategory Selected'
                          : 'Total Offline Storage Used',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: _stoneGrey,
                      ),
                    ),
                    Text(
                      _selectedStorageCategory != null
                          ? _formatStorageSize(
                              _storageMb[_selectedStorageCategory] ?? 0,
                            )
                          : _formattedTotalUsed,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _confirmRemoveAll,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: const Row(
            children: [
              UlvenikIcon(UlvenikIcons.back,
                color: _destructiveText,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Remove Downloaded Content',
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
    );
  }
}

class _OfflineSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OfflineSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 190),
        curve: Curves.easeOutCubic,
        width: 46,
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: value
              ? _OfflineModeScreenState._forest
              : _OfflineModeScreenState._switchOffTrack,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 190),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: _OfflineModeScreenState._offWhite,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
