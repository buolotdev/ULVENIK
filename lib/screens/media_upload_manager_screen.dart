import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum UploadQueueState { uploading, paused, waiting, failed, completed }

enum UploadMediaKind { photo, video, document }

class UploadQueueItem {
  final String id;
  final String fileName;
  final String contextSubtitle;
  final UploadMediaKind kind;
  final double sizeMb;
  UploadQueueState state;
  double progress; // 0.0 .. 1.0
  String completedTimeLabel;

  UploadQueueItem({
    required this.id,
    required this.fileName,
    required this.contextSubtitle,
    required this.kind,
    required this.sizeMb,
    required this.state,
    this.progress = 0.0,
    this.completedTimeLabel = 'Just now',
  });
}

class MediaUploadManagerScreen extends StatefulWidget {
  final bool hasSportPack;

  const MediaUploadManagerScreen({
    super.key,
    this.hasSportPack = true,
  });

  @override
  State<MediaUploadManagerScreen> createState() =>
      _MediaUploadManagerScreenState();
}

class _MediaUploadManagerScreenState extends State<MediaUploadManagerScreen>
    with SingleTickerProviderStateMixin {
  static const Color _obsidian = AppColors.backgroundObsidian; // #101214
  static const Color _carbon = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _destructive = AppColors.errorDestructive; // #8B3A3A
  static const Color _iconBoxBg = Color(0xFF0C0F0D);
  static const Color _trackBg = Color(0xFF323533);

  late final AnimationController _pulseController;
  Timer? _uploadTicker;

  bool _isEditMode = false;
  bool _wifiOnly = true;
  bool _showAllWaiting = false;
  int _archivedCompletedCount = 11; // 3 shown + 11 earlier today = 14 COMPLETED
  int _addedCounter = 1;
  final Set<String> _selectedIds = <String>{};

  late final List<UploadQueueItem> _items = [
    // UPLOADING (3)
    UploadQueueItem(
      id: 'u1',
      fileName: 'Koda_Training_Session_14.jpg',
      contextSubtitle: 'Training Session · 12 Jul 2026',
      kind: UploadMediaKind.photo,
      sizeMb: 3.2,
      state: UploadQueueState.uploading,
      progress: 0.68,
    ),
    UploadQueueItem(
      id: 'u2',
      fileName: 'Koda_Outdoor_Run.jpg',
      contextSubtitle: 'Training Session · 12 Jul 2026',
      kind: UploadMediaKind.photo,
      sizeMb: 1.9,
      state: UploadQueueState.uploading,
      progress: 0.34,
    ),
    UploadQueueItem(
      id: 'u3',
      fileName: 'Session14_Recall.mp4',
      contextSubtitle: 'Training Session · 12 Jul 2026',
      kind: UploadMediaKind.video,
      sizeMb: 47.2,
      state: UploadQueueState.uploading,
      progress: 0.12,
    ),

    // WAITING (5 total — 2 primary visible matching Figma + 3 expandable)
    if (widget.hasSportPack)
      UploadQueueItem(
        id: 'w1',
        fileName: 'Koda_Competition_Score.pdf',
        contextSubtitle: 'Competition · 10 Jul 2026',
        kind: UploadMediaKind.document,
        sizeMb: 1.8,
        state: UploadQueueState.waiting,
      ),
    UploadQueueItem(
      id: 'w2',
      fileName: 'Vet_Assessment_Jul26.pdf',
      contextSubtitle: 'Health Record · 10 Jul 2026',
      kind: UploadMediaKind.document,
      sizeMb: 2.4,
      state: UploadQueueState.waiting,
    ),
    UploadQueueItem(
      id: 'w3',
      fileName: 'Freja_Weave_Poles_Drill.mp4',
      contextSubtitle: 'Agility Session · 9 Jul 2026',
      kind: UploadMediaKind.video,
      sizeMb: 28.6,
      state: UploadQueueState.waiting,
    ),
    UploadQueueItem(
      id: 'w4',
      fileName: 'Bjorn_Ridge_Conditioning.jpg',
      contextSubtitle: 'Conditioning · 8 Jul 2026',
      kind: UploadMediaKind.photo,
      sizeMb: 4.1,
      state: UploadQueueState.waiting,
    ),
    UploadQueueItem(
      id: 'w5',
      fileName: 'EU_Pet_Passport_Scan.pdf',
      contextSubtitle: 'Health Record · 7 Jul 2026',
      kind: UploadMediaKind.document,
      sizeMb: 1.5,
      state: UploadQueueState.waiting,
    ),

    // FAILED (1)
    UploadQueueItem(
      id: 'f1',
      fileName: 'Koda_Training_Video_Recall.mp4',
      contextSubtitle: 'Training Session · 8 Jul 2026',
      kind: UploadMediaKind.video,
      sizeMb: 47.2,
      state: UploadQueueState.failed,
      progress: 0.45,
    ),

    // COMPLETED TODAY (3 visible + 11 earlier = 14)
    UploadQueueItem(
      id: 'c1',
      fileName: 'Koda_Agility_Run.jpg',
      contextSubtitle: 'Training Session',
      kind: UploadMediaKind.photo,
      sizeMb: 3.6,
      state: UploadQueueState.completed,
      progress: 1.0,
      completedTimeLabel: 'Completed 14:32',
    ),
    UploadQueueItem(
      id: 'c2',
      fileName: 'Training_Notes_Jul12.pdf',
      contextSubtitle: 'Training Session',
      kind: UploadMediaKind.document,
      sizeMb: 1.1,
      state: UploadQueueState.completed,
      progress: 1.0,
      completedTimeLabel: 'Completed 14:28',
    ),
    UploadQueueItem(
      id: 'c3',
      fileName: 'Koda_Session14_Overview.jpg',
      contextSubtitle: 'Training Session',
      kind: UploadMediaKind.photo,
      sizeMb: 4.0,
      state: UploadMediaKind.photo == UploadMediaKind.photo
          ? UploadQueueState.completed
          : UploadQueueState.completed,
      progress: 1.0,
      completedTimeLabel: 'Completed 14:21',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _startUploadTicker();
  }

  void _startUploadTicker() {
    _uploadTicker?.cancel();
    _uploadTicker = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;
      final activeItems = _items
          .where((e) => e.state == UploadQueueState.uploading)
          .toList();
      if (activeItems.isEmpty) return;

      bool changed = false;
      for (final item in activeItems) {
        final step = item.sizeMb > 20 ? 0.015 : 0.035;
        item.progress = (item.progress + step).clamp(0.0, 1.0);
        changed = true;
        if (item.progress >= 1.0) {
          final now = TimeOfDay.now();
          final hh = now.hour.toString().padLeft(2, '0');
          final mm = now.minute.toString().padLeft(2, '0');
          item.state = UploadQueueState.completed;
          item.completedTimeLabel = 'Completed $hh:$mm';
          _promoteNextWaiting();
        }
      }
      if (changed) {
        setState(() {});
      }
    });
  }

  void _promoteNextWaiting() {
    final activeCount = _items
        .where((e) => e.state == UploadQueueState.uploading)
        .length;
    if (activeCount >= 3) return;
    final nextIdx =
        _items.indexWhere((e) => e.state == UploadQueueState.waiting);
    if (nextIdx != -1) {
      _items[nextIdx].state = UploadQueueState.uploading;
      _items[nextIdx].progress = 0.04;
    }
  }

  @override
  void dispose() {
    _uploadTicker?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  List<UploadQueueItem> get _uploadingAndPaused => _items
      .where(
        (e) =>
            e.state == UploadQueueState.uploading ||
            e.state == UploadQueueState.paused,
      )
      .toList();

  List<UploadQueueItem> get _waitingItems =>
      _items.where((e) => e.state == UploadQueueState.waiting).toList();

  List<UploadQueueItem> get _failedItems =>
      _items.where((e) => e.state == UploadQueueState.failed).toList();

  List<UploadQueueItem> get _completedItems =>
      _items.where((e) => e.state == UploadQueueState.completed).toList();

  int get _uploadingCount =>
      _items.where((e) => e.state == UploadQueueState.uploading).length;

  double get _activeRemainingMb {
    double sum = 0;
    for (final item in _uploadingAndPaused) {
      if (item.state == UploadQueueState.uploading) {
        sum += item.sizeMb * (1.0 - item.progress);
      }
    }
    return sum;
  }

  String _etaLabel(UploadQueueItem item) {
    if (item.state == UploadQueueState.paused) {
      return '${(item.progress * 100).round()}% · Paused';
    }
    final pct = (item.progress * 100).round();
    final remMb = item.sizeMb * (1.0 - item.progress);
    final secs = (remMb * 11.5).round().clamp(1, 3600);
    if (secs >= 60) {
      final mins = (secs / 60).round();
      return '$pct% · $mins min remaining';
    }
    return '$pct% · $secs sec remaining';
  }

  void _retryAllFailed() {
    final failed = _failedItems;
    if (failed.isEmpty) {
      AppSnackbar.show(
        context,
        message: 'No failed uploads to retry.',
        type: SnackbarType.info,
      );
      return;
    }
    setState(() {
      for (final f in failed) {
        f.state = UploadQueueState.uploading;
      }
    });
    AppSnackbar.show(
      context,
      message: 'Retrying ${failed.length} failed upload(s)...',
      type: SnackbarType.success,
    );
  }

  void _pauseAll() {
    int count = 0;
    setState(() {
      for (final item in _items) {
        if (item.state == UploadQueueState.uploading) {
          item.state = UploadQueueState.paused;
          count++;
        }
      }
    });
    AppSnackbar.show(
      context,
      message: count > 0
          ? 'Paused $count active upload(s).'
          : 'All active uploads are already paused.',
      type: SnackbarType.info,
    );
  }

  void _resumeAll() {
    int count = 0;
    setState(() {
      for (final item in _items) {
        if (item.state == UploadQueueState.paused) {
          item.state = UploadQueueState.uploading;
          count++;
        }
      }
      if (count == 0) {
        _promoteNextWaiting();
      }
    });
    AppSnackbar.show(
      context,
      message: count > 0
          ? 'Resumed $count upload(s).'
          : 'Sync queue active.',
      type: SnackbarType.success,
    );
  }

  void _cancelAllActiveAndWaiting() {
    final targets = _items
        .where((e) => e.state != UploadQueueState.completed)
        .length;
    if (targets == 0) {
      AppSnackbar.show(
        context,
        message: 'Queue is already empty.',
        type: SnackbarType.info,
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _cardBorder),
        ),
        title: const Text(
          'Cancel All Pending Uploads?',
          style: TextStyle(
            color: _offWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        content: Text(
          'Remove all $targets active, waiting, and failed items from the upload queue?',
          style: const TextStyle(
            color: _stoneGrey,
            fontSize: 13.5,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Keep Queue',
              style: TextStyle(color: _stoneGrey, fontFamily: 'Inter'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _destructive,
              foregroundColor: _offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                _items.removeWhere(
                  (e) => e.state != UploadQueueState.completed,
                );
                _selectedIds.clear();
              });
              Navigator.pop(ctx);
              AppSnackbar.show(
                context,
                message: 'Cancelled $targets pending upload(s).',
                type: SnackbarType.warning,
              );
            },
            child: const Text(
              'Cancel All',
              style: TextStyle(fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCompleted() {
    final totalCompleted = _completedItems.length + _archivedCompletedCount;
    if (totalCompleted == 0) {
      AppSnackbar.show(
        context,
        message: 'No completed uploads to clear.',
        type: SnackbarType.info,
      );
      return;
    }
    setState(() {
      _items.removeWhere((e) => e.state == UploadQueueState.completed);
      _archivedCompletedCount = 0;
    });
    AppSnackbar.show(
      context,
      message: 'Cleared $totalCompleted completed upload(s).',
      type: SnackbarType.success,
    );
  }

  void _cancelSingleItem(UploadQueueItem item) {
    final idx = _items.indexOf(item);
    if (idx == -1) return;
    setState(() {
      _items.removeAt(idx);
      _selectedIds.remove(item.id);
      if (item.state == UploadQueueState.uploading) {
        _promoteNextWaiting();
      }
    });
    AppSnackbar.show(
      context,
      message: 'Cancelled ${item.fileName}.',
      type: SnackbarType.info,
    );
  }

  void _showAddMediaSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
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
              const Text(
                'Queue Media for Cloud Sync',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select media type to simulate adding a new file into the live upload queue.',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 12.5,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              _buildAddOptionTile(
                ctx,
                icon: Icons.photo_outlined,
                title: 'High-Res Training Photo (.jpg)',
                subtitle: '3.6 MB · Koda Tracking Session',
                kind: UploadMediaKind.photo,
                fileName: 'Koda_Field_Frame_${14 + _addedCounter}.jpg',
                sizeMb: 3.6,
              ),
              const SizedBox(height: 10),
              _buildAddOptionTile(
                ctx,
                icon: Icons.play_circle_outline_rounded,
                title: '1080p Drill Video Clip (.mp4)',
                subtitle: '34.8 MB · Heelwork Sequence',
                kind: UploadMediaKind.video,
                fileName: 'Heelwork_Clip_${14 + _addedCounter}.mp4',
                sizeMb: 34.8,
              ),
              const SizedBox(height: 10),
              _buildAddOptionTile(
                ctx,
                icon: Icons.description_outlined,
                title: widget.hasSportPack
                    ? 'Vet / Competition Document (.pdf)'
                    : 'Vet / Health Document (.pdf)',
                subtitle: widget.hasSportPack
                    ? '2.1 MB · Health & Competition Records'
                    : '2.1 MB · Health Records Archive',
                kind: UploadMediaKind.document,
                fileName: 'Clinical_Summary_${14 + _addedCounter}.pdf',
                sizeMb: 2.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOptionTile(
    BuildContext sheetContext, {
    required IconData icon,
    required String title,
    required String subtitle,
    required UploadMediaKind kind,
    required String fileName,
    required double sizeMb,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(sheetContext);
        final shouldStartImmediately = _uploadingCount < 3;
        final newItem = UploadQueueItem(
          id: 'added_${DateTime.now().millisecondsSinceEpoch}',
          fileName: fileName,
          contextSubtitle: 'Training Session · Today',
          kind: kind,
          sizeMb: sizeMb,
          state: shouldStartImmediately
              ? UploadQueueState.uploading
              : UploadQueueState.waiting,
          progress: shouldStartImmediately ? 0.05 : 0.0,
        );
        setState(() {
          _addedCounter++;
          _items.insert(0, newItem);
        });
        AppSnackbar.show(
          context,
          message: shouldStartImmediately
              ? 'Uploading $fileName now...'
              : 'Added $fileName to waiting queue.',
          type: SnackbarType.success,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _obsidian,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF95D3BB), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 11.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.add_circle_outline_rounded,
              color: _forest,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploadingList = _uploadingAndPaused;
    final waitingList = _waitingItems;
    final visibleWaiting = _showAllWaiting
        ? waitingList
        : waitingList.take(2).toList();
    final failedList = _failedItems;
    final completedList = _completedItems;

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
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('UPLOAD STATUS', _stoneGrey),
                    const SizedBox(height: 10),
                    _buildUploadStatusCard(),
                    const SizedBox(height: 16),
                    _buildMasterQueueControls(),
                    const SizedBox(height: 14),
                    _buildWifiAndAddMediaStrip(),
                    if (_isEditMode && _selectedIds.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildBatchEditBanner(),
                    ],
                    if (uploadingList.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSectionHeader('UPLOADING', _forest),
                      const SizedBox(height: 10),
                      ...uploadingList.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildUploadingOrPausedCard(item),
                        ),
                      ),
                    ],
                    if (waitingList.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('WAITING', _stoneGrey),
                          if (waitingList.length > 2)
                            GestureDetector(
                              onTap: () => setState(
                                () => _showAllWaiting = !_showAllWaiting,
                              ),
                              child: Text(
                                _showAllWaiting
                                    ? 'Show fewer'
                                    : 'Show all (${waitingList.length})',
                                style: const TextStyle(
                                  color: _forest,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...visibleWaiting.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildWaitingCard(item),
                        ),
                      ),
                    ],
                    if (failedList.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSectionHeader('FAILED', _destructive),
                      const SizedBox(height: 10),
                      ...failedList.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFailedCard(item),
                        ),
                      ),
                    ],
                    if (completedList.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSectionHeader('COMPLETED TODAY', _stoneGrey),
                      const SizedBox(height: 10),
                      ...completedList.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildCompletedCard(item),
                        ),
                      ),
                    ],
                    if (uploadingList.isEmpty &&
                        waitingList.isEmpty &&
                        failedList.isEmpty &&
                        completedList.isEmpty)
                      _buildAllClearState(),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _offWhite,
              size: 28,
            ),
          ),
          const Expanded(
            child: Text(
              'Media Uploads',
              style: TextStyle(
                color: _offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isEditMode = !_isEditMode;
                if (!_isEditMode) _selectedIds.clear();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                _isEditMode ? 'Done' : 'Edit',
                style: TextStyle(
                  color: _isEditMode ? const Color(0xFF95D3BB) : _stoneGrey,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _clearCompleted,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Clear Completed',
                style: TextStyle(
                  color: _forest,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildUploadStatusCard() {
    final uploadingCount = _uploadingCount;
    final waitingCount = _waitingItems.length;
    final failedCount = _failedItems.length;
    final completedCount = _completedItems.length + _archivedCompletedCount;
    final mbNow = _activeRemainingMb;
    final isSyncActive = uploadingCount > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn(
                value: '$uploadingCount',
                label: 'UPLOADING',
                labelColor: _forest,
              ),
              _buildMetricColumn(
                value: '$waitingCount',
                label: 'WAITING',
                labelColor: _stoneGrey,
              ),
              _buildMetricColumn(
                value: '$failedCount',
                label: 'FAILED',
                labelColor: _destructive,
              ),
              _buildMetricColumn(
                value: '$completedCount',
                label: 'COMPLETED',
                labelColor: _stoneGrey,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: _cardBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSyncActive
                    ? '${mbNow.toStringAsFixed(1)} MB uploading now'
                    : 'Queue idle · 0.0 MB active',
                style: const TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
              FadeTransition(
                opacity: isSyncActive
                    ? Tween<double>(begin: 0.55, end: 1.0)
                          .animate(_pulseController)
                    : const AlwaysStoppedAnimation(0.75),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: isSyncActive ? _forest : _stoneGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSyncActive ? 'Sync active' : 'Sync paused',
                      style: TextStyle(
                        color: isSyncActive ? _forest : _stoneGrey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
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
  }

  Widget _buildMetricColumn({
    required String value,
    required String label,
    required Color labelColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _offWhite,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildMasterQueueControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _retryAllFailed,
            child: const Text(
              'Retry All Failed',
              style: TextStyle(
                color: _destructive,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: _pauseAll,
            child: const Text(
              'Pause All',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: _resumeAll,
            child: const Text(
              'Resume All',
              style: TextStyle(
                color: _forest,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: _cancelAllActiveAndWaiting,
            child: const Text(
              'Cancel All',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWifiAndAddMediaStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Icon(
            _wifiOnly ? Icons.wifi_rounded : Icons.cell_tower_rounded,
            color: _wifiOnly ? const Color(0xFF95D3BB) : _stoneGrey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _wifiOnly = !_wifiOnly);
                AppSnackbar.show(
                  context,
                  message: _wifiOnly
                      ? 'Wi-Fi-only uploads enabled.'
                      : 'Cellular + Wi-Fi uploads allowed.',
                  type: SnackbarType.info,
                );
              },
              child: Text(
                _wifiOnly ? 'Wi-Fi Only Sync' : 'Wi-Fi & Cellular Sync',
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 26,
            child: Switch(
              value: _wifiOnly,
              activeThumbColor: _offWhite,
              activeTrackColor: _forest,
              inactiveThumbColor: _stoneGrey,
              inactiveTrackColor: _trackBg,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (val) {
                setState(() => _wifiOnly = val);
                AppSnackbar.show(
                  context,
                  message: val
                      ? 'Wi-Fi-only uploads enabled.'
                      : 'Cellular + Wi-Fi uploads allowed.',
                  type: SnackbarType.info,
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _showAddMediaSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _forest),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Color(0xFF95D3BB), size: 15),
                  SizedBox(width: 3),
                  Text(
                    'Add Media',
                    style: TextStyle(
                      color: Color(0xFF95D3BB),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchEditBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _destructive.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _destructive),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_selectedIds.length} item(s) selected',
            style: const TextStyle(
              color: _offWhite,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: () {
              final count = _selectedIds.length;
              setState(() {
                _items.removeWhere((e) => _selectedIds.contains(e.id));
                _selectedIds.clear();
                _promoteNextWaiting();
              });
              AppSnackbar.show(
                context,
                message: 'Removed $count selected item(s).',
                type: SnackbarType.warning,
              );
            },
            child: const Text(
              'Remove Selected',
              style: TextStyle(
                color: Color(0xFFFFDAD6),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaIconBox(UploadMediaKind kind, {bool isFailed = false}) {
    IconData icon;
    switch (kind) {
      case UploadMediaKind.photo:
        icon = Icons.photo_library_outlined;
        break;
      case UploadMediaKind.video:
        icon = Icons.play_circle_outline_rounded;
        break;
      case UploadMediaKind.document:
        icon = Icons.description_outlined;
        break;
    }
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: _iconBoxBg,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        icon,
        color: isFailed
            ? _destructive
            : _stoneGrey.withValues(alpha: 0.75),
        size: 21,
      ),
    );
  }

  Widget _buildSelectCheckboxIfEditing(UploadQueueItem item) {
    if (!_isEditMode) return const SizedBox.shrink();
    final checked = _selectedIds.contains(item.id);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (checked) {
              _selectedIds.remove(item.id);
            } else {
              _selectedIds.add(item.id);
            }
          });
        },
        child: Icon(
          checked ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: checked ? _forest : _stoneGrey,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildUploadingOrPausedCard(UploadQueueItem item) {
    final isPaused = item.state == UploadQueueState.paused;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectCheckboxIfEditing(item),
              _buildMediaIconBox(item.kind),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.contextSubtitle,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isPaused
                                ? const Color(0xFF3A3528)
                                : const Color(0xFF3A4E3C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isPaused ? 'PAUSED' : 'UPLOADING',
                            style: TextStyle(
                              color: isPaused
                                  ? const Color(0xFFE5C98B)
                                  : const Color(0xFFA8BEA7),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.sizeMb.toStringAsFixed(1)} MB',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        item.state = isPaused
                            ? UploadQueueState.uploading
                            : UploadQueueState.paused;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isPaused
                            ? Icons.play_arrow_outlined
                            : Icons.pause_rounded,
                        color: _stoneGrey,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _cancelSingleItem(item),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        color: _stoneGrey,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              tween: Tween<double>(begin: item.progress, end: item.progress),
              builder: (context, val, _) {
                return LinearProgressIndicator(
                  value: val,
                  minHeight: 4,
                  backgroundColor: _trackBg,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPaused ? AppColors.bronzeAccent : _forest,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 7),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _etaLabel(item),
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingCard(UploadQueueItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectCheckboxIfEditing(item),
              _buildMediaIconBox(item.kind),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.contextSubtitle,
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item.state = UploadQueueState.uploading;
                              item.progress = 0.04;
                            });
                            AppSnackbar.show(
                              context,
                              message: 'Prioritised ${item.fileName} now.',
                              type: SnackbarType.success,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF272B29),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'WAITING',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.sizeMb.toStringAsFixed(1)} MB',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _cancelSingleItem(item),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    color: _stoneGrey,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const LinearProgressIndicator(
              value: 0.0,
              minHeight: 4,
              backgroundColor: _trackBg,
              valueColor: AlwaysStoppedAnimation<Color>(_forest),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedCard(UploadQueueItem item) {
    final pct = (item.progress * 100).round();
    return GestureDetector(
      onTap: () {
        setState(() {
          item.state = UploadQueueState.uploading;
        });
        AppSnackbar.show(
          context,
          message: 'Retrying ${item.fileName} from $pct%...',
          type: SnackbarType.success,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSelectCheckboxIfEditing(item),
                _buildMediaIconBox(item.kind, isFailed: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.contextSubtitle,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF93000A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'FAILED',
                              style: TextStyle(
                                color: Color(0xFFFFDAD6),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.sizeMb.toStringAsFixed(1)} MB',
                            style: const TextStyle(
                              color: _stoneGrey,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          item.state = UploadQueueState.uploading;
                        });
                        AppSnackbar.show(
                          context,
                          message: 'Retrying ${item.fileName}...',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: _destructive,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _cancelSingleItem(item),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          color: _stoneGrey,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: item.progress,
                minHeight: 4,
                backgroundColor: _trackBg,
                valueColor: const AlwaysStoppedAnimation<Color>(_destructive),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upload interrupted — tap Retry',
                  style: TextStyle(
                    color: _destructive,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '$pct%',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 11.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(UploadQueueItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          _buildSelectCheckboxIfEditing(item),
          _buildMediaIconBox(item.kind),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _offWhite.withValues(alpha: 0.82),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.contextSubtitle} · ${item.completedTimeLabel}',
                  style: TextStyle(
                    color: _stoneGrey.withValues(alpha: 0.72),
                    fontSize: 11.5,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _forest,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAllClearState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.cloud_done_outlined,
              color: _forest.withValues(alpha: 0.8),
              size: 42,
            ),
            const SizedBox(height: 10),
            const Text(
              'All media uploads synced',
              style: TextStyle(
                color: _offWhite,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap Add Media above to queue photos, videos, or PDFs.',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
