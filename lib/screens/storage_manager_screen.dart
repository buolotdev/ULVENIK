import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'media_upload_manager_screen.dart';

class CleanupMediaCandidate {
  final String id;
  final String title;
  final String subtitle;
  final String categoryKey; // photos, videos, documents, offline
  final double sizeMb;

  const CleanupMediaCandidate({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryKey,
    required this.sizeMb,
  });
}

class StorageManagerScreen extends StatefulWidget {
  const StorageManagerScreen({super.key});

  @override
  State<StorageManagerScreen> createState() => _StorageManagerScreenState();
}

class _StorageManagerScreenState extends State<StorageManagerScreen>
    with SingleTickerProviderStateMixin {
  static const Color _obsidian = AppColors.backgroundObsidian; // #101214
  static const Color _carbon = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _destructive = AppColors.errorDestructive; // #8B3A3A
  static const Color _alpineBlue = AppColors.infoAlpineBlue;

  late final AnimationController _barAnimController;
  late final Animation<double> _barAnim;

  String? _highlightedCategory; // photos, videos, documents, cache, offline
  bool _optimiseDeviceStorage = false;
  int _selectedQualityIndex = 1; // 1 = High Quality (default in Figma)
  String _lastSyncText = '2 minutes ago';

  // Live storage figures in MB (matching Figma initial values!)
  double _photosMb = 1228.8; // 1.2 GB (1200 MB display)
  int _photosCount = 847;

  double _videosMb = 890.0; // 890 MB
  int _videosCount = 63;

  double _documentsMb = 48.0; // 48 MB
  int _documentsCount = 124;

  double _offlineMb = 340.0; // 340 MB
  int _offlineCount = 312;

  // Cache sub-buckets = 64 + 48 + 16 = 128 MB matching Figma!
  double _imageCacheMb = 64.0;
  double _videoCacheMb = 48.0;
  double _docCacheMb = 16.0;

  late final List<CleanupMediaCandidate> _cleanupItems = [
    const CleanupMediaCandidate(
      id: 'cl_1',
      title: 'Koda_Full_Field_Track_4K.mp4',
      subtitle: 'Koda · 18 May 2026 · Backed up to Cloud',
      categoryKey: 'videos',
      sizeMb: 184.0,
    ),
    const CleanupMediaCandidate(
      id: 'cl_2',
      title: 'Freja_Agility_Seminar_Raw.mp4',
      subtitle: 'Freja · 2 May 2026 · Backed up to Cloud',
      categoryKey: 'videos',
      sizeMb: 142.0,
    ),
    const CleanupMediaCandidate(
      id: 'cl_3',
      title: 'Burst_Sequence_Recall_38x.zip',
      subtitle: 'Kodi · 29 May 2026 · 38 RAW Burst Photos',
      categoryKey: 'photos',
      sizeMb: 156.0,
    ),
    const CleanupMediaCandidate(
      id: 'cl_4',
      title: 'Fjord_Ridge_HighRes_Set',
      subtitle: 'Bjørn · 11 Jun 2026 · 24 Photos',
      categoryKey: 'photos',
      sizeMb: 94.0,
    ),
    const CleanupMediaCandidate(
      id: 'cl_5',
      title: 'DICOM_Radiograph_Export.pdf',
      subtitle: 'Bjørn · 14 Jun 2026 · High-DPI Radiology',
      categoryKey: 'documents',
      sizeMb: 14.0,
    ),
    const CleanupMediaCandidate(
      id: 'cl_6',
      title: '2025_Winter_Season_Offline_Pack',
      subtitle: 'Archived Training Logs · 96 Offline Records',
      categoryKey: 'offline',
      sizeMb: 110.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _barAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _barAnim = CurvedAnimation(
      parent: _barAnimController,
      curve: Curves.easeOutCubic,
    );
    _barAnimController.forward();
  }

  @override
  void dispose() {
    _barAnimController.dispose();
    super.dispose();
  }

  double get _totalCacheMb => _imageCacheMb + _videoCacheMb + _docCacheMb;

  double get _freedFromInitialMb {
    final initialSum = 1228.8 + 890.0 + 48.0 + 340.0 + 128.0;
    final currentSum =
        _photosMb + _videosMb + _documentsMb + _offlineMb + _totalCacheMb;
    final optimiseBonus = _optimiseDeviceStorage ? 320.0 : 0.0;
    return (initialSum - currentSum + optimiseBonus).clamp(0.0, 2500.0);
  }

  String get _cloudStorageDisplay {
    final totalCloudMb = _photosMb + _videosMb + _documentsMb + 290.0;
    return '${(totalCloudMb / 1024.0).toStringAsFixed(1)} GB';
  }

  String get _deviceStorageDisplay {
    final baseDeviceMb = (1126.4 - _freedFromInitialMb).clamp(180.0, 2000.0);
    if (baseDeviceMb >= 1000) {
      return '${(baseDeviceMb / 1024.0).toStringAsFixed(1)} GB';
    }
    return '${baseDeviceMb.round()} MB';
  }

  String get _availableOnDeviceDisplay {
    final availGb = 14.2 + (_freedFromInitialMb / 1024.0);
    return '${availGb.toStringAsFixed(1)} GB';
  }

  String _formatMbOrGb(double mb, {bool preferGbOver1000 = true}) {
    if (preferGbOver1000 && mb >= 1000.0) {
      return '${(mb / 1024.0).toStringAsFixed(1)} GB';
    }
    return '${mb.round()} MB';
  }

  void _clearCacheBucket(String bucket) {
    double cleared = 0;
    setState(() {
      if (bucket == 'image' && _imageCacheMb > 0) {
        cleared = _imageCacheMb;
        _imageCacheMb = 0;
      } else if (bucket == 'video' && _videoCacheMb > 0) {
        cleared = _videoCacheMb;
        _videoCacheMb = 0;
      } else if (bucket == 'doc' && _docCacheMb > 0) {
        cleared = _docCacheMb;
        _docCacheMb = 0;
      } else if (bucket == 'all' && _totalCacheMb > 0) {
        cleared = _totalCacheMb;
        _imageCacheMb = 0;
        _videoCacheMb = 0;
        _docCacheMb = 0;
      }
    });

    if (cleared <= 0) {
      AppSnackbar.show(
        context,
        message: 'Cache is already at 0 MB.',
        type: SnackbarType.info,
      );
      return;
    }

    AppSnackbar.show(
      context,
      message: 'Cleared ${cleared.round()} MB of temporary cache.',
      type: SnackbarType.success,
    );
  }

  void _openCategoryCleanupSheet({
    required String categoryKey,
    required String categoryTitle,
  }) {
    setState(() => _highlightedCategory = categoryKey);
    final candidates = _cleanupItems
        .where((c) => c.categoryKey == categoryKey)
        .toList();
    final selectedIds = <String>{
      if (candidates.isNotEmpty) candidates.first.id,
    };

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final currentCandidates = _cleanupItems
              .where((c) => c.categoryKey == categoryKey)
              .toList();
          double selectedMb = 0;
          for (final item in currentCandidates) {
            if (selectedIds.contains(item.id)) {
              selectedMb += item.sizeMb;
            }
          }

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
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage $categoryTitle Storage',
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select large local downloads to remove from this device. Originals stay safe in Ulvenik Cloud.',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 12.5,
                      height: 1.4,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (currentCandidates.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _obsidian,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        children: [
                          UlvenikIcon(UlvenikIcons.completed,
                            color: _forest,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'All large local files in this category have already been optimised!',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...currentCandidates.map((item) {
                      final checked = selectedIds.contains(item.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (checked) {
                                selectedIds.remove(item.id);
                              } else {
                                selectedIds.add(item.id);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _obsidian,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: checked ? _forest : _cardBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                UlvenikIcon.fromMaterial(
                                  checked
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked,
                                  color: checked ? _forest : _stoneGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: _offWhite,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          color: _stoneGrey,
                                          fontSize: 11.5,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${item.sizeMb.round()} MB',
                                  style: const TextStyle(
                                    color: Color(0xFF95D3BB),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentCandidates.isEmpty
                            ? _obsidian
                            : _forest,
                        foregroundColor: _offWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: currentCandidates.isEmpty
                          ? () => Navigator.pop(ctx)
                          : (selectedIds.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      _cleanupItems.removeWhere(
                                        (e) => selectedIds.contains(e.id),
                                      );
                                      if (categoryKey == 'photos') {
                                        _photosMb = (_photosMb - selectedMb)
                                            .clamp(200.0, 2000.0);
                                        _photosCount =
                                            (_photosCount -
                                                    selectedIds.length * 24)
                                                .clamp(100, 999);
                                      } else if (categoryKey == 'videos') {
                                        _videosMb = (_videosMb - selectedMb)
                                            .clamp(120.0, 2000.0);
                                        _videosCount =
                                            (_videosCount - selectedIds.length)
                                                .clamp(1, 999);
                                      } else if (categoryKey == 'documents') {
                                        _documentsMb =
                                            (_documentsMb - selectedMb).clamp(
                                              8.0,
                                              500.0,
                                            );
                                        _documentsCount =
                                            (_documentsCount -
                                                    selectedIds.length)
                                                .clamp(1, 999);
                                      } else if (categoryKey == 'offline') {
                                        _offlineMb = (_offlineMb - selectedMb)
                                            .clamp(40.0, 1000.0);
                                        _offlineCount =
                                            (_offlineCount -
                                                    selectedIds.length * 48)
                                                .clamp(20, 999);
                                      }
                                    });
                                    Navigator.pop(ctx);
                                    AppSnackbar.show(
                                      context,
                                      message:
                                          'Freed ${selectedMb.round()} MB on device.',
                                      type: SnackbarType.success,
                                    );
                                  }),
                      child: Text(
                        currentCandidates.isEmpty
                            ? 'Close'
                            : 'Free ${selectedMb.round()} MB Selected',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
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
            _buildTopHeader(),
            const Divider(color: _cardBorder, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStorageSummaryHeroCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('STORAGE BREAKDOWN'),
                    const SizedBox(height: 10),
                    _buildBreakdownCards(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('OPTIMISATION'),
                    const SizedBox(height: 10),
                    _buildOptimisationCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('UPLOAD QUALITY'),
                    const SizedBox(height: 10),
                    _buildUploadQualityCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('CLOUD SYNC'),
                    const SizedBox(height: 10),
                    _buildCloudSyncCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('CACHE'),
                    const SizedBox(height: 10),
                    _buildCacheActionsCard(),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _offWhite,
              size: 28,
            ),
          ),
          const Text(
            'Storage Manager',
            style: TextStyle(
              color: _offWhite,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildStorageSummaryHeroCard() {
    final segments = [
      ('photos', _photosMb, _forest, 'Photos'),
      ('videos', _videosMb, _alpineBlue, 'Videos'),
      ('offline', _offlineMb, AppColors.secondarySage, 'Offline'),
      ('cache', _totalCacheMb, AppColors.bronzeAccent, 'Cache'),
      ('documents', _documentsMb, const Color(0xFF95D3BB), 'Docs'),
    ];
    final totalSegMb = segments.fold<double>(
      1.0,
      (prev, s) => prev + s.$2,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildHeroMetricQuadrant(
                    icon: Icons.cloud_outlined,
                    value: _cloudStorageDisplay,
                    label: 'Cloud Storage',
                  ),
                ),
                Container(width: 1, color: _cardBorder),
                const SizedBox(width: 18),
                Expanded(
                  child: _buildHeroMetricQuadrant(
                    icon: Icons.dns_outlined,
                    value: _deviceStorageDisplay,
                    label: 'Device Storage',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: _cardBorder, height: 1),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildHeroMetricQuadrant(
                    icon: Icons.download_rounded,
                    value: _formatMbOrGb(_offlineMb, preferGbOver1000: false),
                    label: 'Offline Files',
                  ),
                ),
                Container(width: 1, color: _cardBorder),
                const SizedBox(width: 18),
                Expanded(
                  child: _buildHeroMetricQuadrant(
                    icon: Icons.auto_awesome_outlined,
                    value: _formatMbOrGb(
                      _totalCacheMb,
                      preferGbOver1000: false,
                    ),
                    label: 'Cache',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Interactive Animated Multi-Segment Storage Bar
          AnimatedBuilder(
            animation: _barAnim,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: segments.where((s) => s.$2 > 0).map((seg) {
                      final isSelected = _highlightedCategory == seg.$1;
                      final flex = ((seg.$2 / totalSegMb) * 1000 * _barAnim.value)
                          .round()
                          .clamp(12, 1000);
                      return Expanded(
                        flex: flex,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _highlightedCategory =
                                  isSelected ? null : seg.$1;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 2),
                            color: _highlightedCategory == null || isSelected
                                ? seg.$3
                                : seg.$3.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available on Device',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                _availableOnDeviceDisplay,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetricQuadrant({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 22),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 12.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownCards() {
    return Column(
      children: [
        _buildSingleBreakdownTile(
          categoryKey: 'photos',
          icon: Icons.photo_outlined,
          title: 'Photos',
          subtitle: '$_photosCount files',
          sizeText: _formatMbOrGb(_photosMb),
          actionLabel: 'Manage',
          onAction: () => _openCategoryCleanupSheet(
            categoryKey: 'photos',
            categoryTitle: 'Photos',
          ),
        ),
        const SizedBox(height: 10),
        _buildSingleBreakdownTile(
          categoryKey: 'videos',
          icon: Icons.videocam_outlined,
          title: 'Videos',
          subtitle: '$_videosCount files',
          sizeText: _formatMbOrGb(_videosMb, preferGbOver1000: false),
          actionLabel: 'Manage',
          onAction: () => _openCategoryCleanupSheet(
            categoryKey: 'videos',
            categoryTitle: 'Videos',
          ),
        ),
        const SizedBox(height: 10),
        _buildSingleBreakdownTile(
          categoryKey: 'documents',
          icon: Icons.insert_drive_file_outlined,
          title: 'Documents',
          subtitle: '$_documentsCount files',
          sizeText: _formatMbOrGb(_documentsMb, preferGbOver1000: false),
          actionLabel: 'Manage',
          onAction: () => _openCategoryCleanupSheet(
            categoryKey: 'documents',
            categoryTitle: 'Documents',
          ),
        ),
        const SizedBox(height: 10),
        _buildSingleBreakdownTile(
          categoryKey: 'cache',
          icon: Icons.auto_awesome_outlined,
          title: 'Cache',
          subtitle: 'Temporary files',
          sizeText: _formatMbOrGb(_totalCacheMb, preferGbOver1000: false),
          actionLabel: 'Clear',
          onAction: () => _clearCacheBucket('all'),
        ),
        const SizedBox(height: 10),
        _buildSingleBreakdownTile(
          categoryKey: 'offline',
          icon: Icons.download_rounded,
          title: 'Offline Records',
          subtitle: '$_offlineCount records',
          sizeText: _formatMbOrGb(_offlineMb, preferGbOver1000: false),
          actionLabel: 'Manage',
          onAction: () => _openCategoryCleanupSheet(
            categoryKey: 'offline',
            categoryTitle: 'Offline Records',
          ),
        ),
      ],
    );
  }

  Widget _buildSingleBreakdownTile({
    required String categoryKey,
    required IconData icon,
    required String title,
    required String subtitle,
    required String sizeText,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final highlighted = _highlightedCategory == categoryKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _highlightedCategory = highlighted ? null : categoryKey;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlighted ? _forest : _cardBorder,
            width: highlighted ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  sizeText,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      color: _forest,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimisationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Optimise Device Storage',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Switch(
                value: _optimiseDeviceStorage,
                activeThumbColor: _offWhite,
                activeTrackColor: _forest,
                inactiveThumbColor: const Color(0xFFB5BDB8),
                inactiveTrackColor: const Color(0xFF393E41),
                onChanged: (val) {
                  setState(() => _optimiseDeviceStorage = val);
                  AppSnackbar.show(
                    context,
                    message: val
                        ? 'Smart device storage optimisation enabled.'
                        : 'Device storage optimisation disabled.',
                    type: SnackbarType.info,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Frequently viewed media stays downloaded. Older files are removed from your device but remain available in the cloud.',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 12.8,
              height: 1.45,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              UlvenikIcon.fromMaterial(
                _optimiseDeviceStorage
                    ? Icons.check_circle_outline_rounded
                    : Icons.schedule_rounded,
                size: 16,
                color: _optimiseDeviceStorage ? _forest : _stoneGrey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _optimiseDeviceStorage
                      ? 'Optimisation active — saving ~320 MB locally'
                      : 'Optimisation is currently disabled',
                  style: TextStyle(
                    color: _optimiseDeviceStorage
                        ? const Color(0xFF95D3BB)
                        : _stoneGrey,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadQualityCard() {
    const options = [
      ('Original Quality', 'Largest file size, maximum detail'),
      ('High Quality', 'Slightly compressed, recommended'),
      ('Balanced', 'Reduced size, good quality'),
      ('Data Saver', 'Smallest file size'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: List.generate(options.length, (idx) {
            final selected = _selectedQualityIndex == idx;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedQualityIndex = idx);
                    AppSnackbar.show(
                      context,
                      message: 'Upload quality set to ${options[idx].$1}.',
                      type: SnackbarType.info,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? _forest.withValues(alpha: 0.14)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: selected ? _forest : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                options[idx].$1,
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 14.5,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                options[idx].$2,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        selected
                            ? const Icon(Icons.check_rounded,
                                color: _forest,
                                size: 20,
                              )
                            : Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _stoneGrey.withValues(alpha: 0.6),
                                    width: 1.3,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                if (idx < options.length - 1)
                  const Divider(color: _cardBorder, height: 1),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCloudSyncCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _lastSyncText = 'Just now');
              AppSnackbar.show(
                context,
                message: 'Cloud storage metadata synchronised.',
                type: SnackbarType.success,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: _buildSyncRow(
              label: 'Last Synchronised',
              value: _lastSyncText,
              valueColor: _offWhite,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: _cardBorder, height: 1),
          ),
          _buildSyncRow(
            label: 'Pending Uploads',
            value: '0',
            valueColor: _offWhite,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: _cardBorder, height: 1),
          ),
          _buildSyncRow(
            label: 'Failed Uploads',
            value: '0',
            valueColor: _offWhite,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: _cardBorder, height: 1),
          ),
          _buildSyncRow(
            label: 'Cloud Status',
            value: 'Connected',
            valueColor: _forest,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MediaUploadManagerScreen(),
                  ),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Open Upload Manager',
                    style: TextStyle(
                      color: _forest,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 4),
                  UlvenikIcon(UlvenikIcons.details,
                    color: _forest,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncRow({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildCacheActionsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          _buildCacheButton(
            label: _imageCacheMb > 0
                ? 'Clear Image Cache'
                : 'Image Cache Cleared (0 MB)',
            isDestructive: false,
            onTap: () => _clearCacheBucket('image'),
          ),
          const SizedBox(height: 10),
          _buildCacheButton(
            label: _videoCacheMb > 0
                ? 'Clear Video Cache'
                : 'Video Cache Cleared (0 MB)',
            isDestructive: false,
            onTap: () => _clearCacheBucket('video'),
          ),
          const SizedBox(height: 10),
          _buildCacheButton(
            label: _docCacheMb > 0
                ? 'Clear Document Cache'
                : 'Document Cache Cleared (0 MB)',
            isDestructive: false,
            onTap: () => _clearCacheBucket('doc'),
          ),
          const SizedBox(height: 10),
          _buildCacheButton(
            label: 'Clear All Cache',
            isDestructive: true,
            onTap: () => _clearCacheBucket('all'),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheButton({
    required String label,
    required bool isDestructive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF15191C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? _destructive.withValues(alpha: 0.45)
                : _cardBorder,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isDestructive ? _destructive : _offWhite,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
