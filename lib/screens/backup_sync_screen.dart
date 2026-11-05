import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class BackupSyncScreen extends StatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  State<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends State<BackupSyncScreen>
    with TickerProviderStateMixin {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _alpineBlue = Color(0xFF5D8FAF);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _switchOffTrack = Color(0xFF2B3135);
  static const Color _destructive = Color(0xFF8B3A3A);

  late final AnimationController _entranceController;
  late final Animation<double> _storageBarAnim;
  late final AnimationController _syncSpinController;

  bool _autoCloudSync = true;
  bool _syncMobileData = true;
  bool _isSyncingNow = false;
  double _syncProgress = 0.0;

  String _lastSyncLabel = 'Today · 14:37';
  int _backupSizeMb = 842;
  final double _cloudUsedGb = 1.2;
  final double _cloudTotalGb = 5.0;
  int _selectedBreakdownSegment = 0;

  List<(String, String, IconData, bool)> _connectedDevices = [
    ('iPhone 16 Pro', 'Last Active: Just Now', Icons.smartphone_rounded, true),
    ('MacBook Pro', 'Last Active: 2 hours ago', Icons.laptop_mac_rounded, false),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _storageBarAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _syncSpinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _syncSpinController.dispose();
    super.dispose();
  }

  Future<void> _runManualSync() async {
    if (_isSyncingNow) return;
    setState(() {
      _isSyncingNow = true;
      _syncProgress = 0.08;
    });
    _syncSpinController.repeat();

    for (final step in [0.34, 0.68, 0.92, 1.0]) {
      await Future<void>.delayed(const Duration(milliseconds: 260));
      if (!mounted) return;
      setState(() => _syncProgress = step);
    }

    _syncSpinController.stop();
    _syncSpinController.reset();

    final now = TimeOfDay.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');

    setState(() {
      _isSyncingNow = false;
      _lastSyncLabel = 'Today · $hh:$mm';
      _backupSizeMb = 844;
    });

    AppSnackbar.show(
      context,
      title: 'Cloud Sync Complete',
      message: 'All training sessions, health records & media backed up ($hh:$mm).',
      type: SnackbarType.success,
    );
  }

  void _confirmRemoveDevice(int index) {
    final dev = _connectedDevices[index];
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
                  'Disconnect ${dev.$1}?',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${dev.$1} will stop receiving background cloud sync updates until you sign back in.',
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
                          setState(() {
                            _connectedDevices = List.of(_connectedDevices)
                              ..removeAt(index);
                          });
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Device Disconnected',
                            message: 'Removed ${dev.$1} from Cloud Sync.',
                            type: SnackbarType.info,
                          );
                        },
                        child: const Text('Disconnect'),
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

  void _showCloudBreakdownSheet() {
    const segments = [
      ('Training Media & Videos', 0.62, _forest, '620 MB · 48 clips'),
      ('Health & Vet Scans', 0.31, _alpineBlue, '310 MB · 19 documents'),
      ('Sessions, Goals & Records', 0.27, _sage, '270 MB · 3 dog workspaces'),
    ];
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
                      'Cloud Storage · ${_cloudUsedGb.toStringAsFixed(1)} GB of ${_cloudTotalGb.toStringAsFixed(0)} GB',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 10,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 62,
                              child: Container(color: _forest),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: 31,
                              child: Container(color: _alpineBlue),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: 27,
                              child: Container(color: _sage),
                            ),
                            Expanded(
                              flex: 380,
                              child: Container(color: _obsidian),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...segments.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final seg = entry.value;
                      final selected = _selectedBreakdownSegment == idx;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() => _selectedBreakdownSegment = idx);
                            setSheetState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: _obsidian,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected ? seg.$3 : _cardBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: seg.$3,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    seg.$1,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: _offWhite,
                                    ),
                                  ),
                                ),
                                Text(
                                  seg.$4,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: _stoneGrey,
                                  ),
                                ),
                              ],
                            ),
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

  @override
  Widget build(BuildContext context) {
    final statusWord = _isSyncingNow
        ? 'Syncing…'
        : (_autoCloudSync ? 'Synced' : 'Paused');
    final statusDotColor = _isSyncingNow
        ? _mint
        : (_autoCloudSync ? _forest : _stoneGrey);

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
                    _buildSectionHeader('SYNC STATUS'),
                    const SizedBox(height: 10),
                    _buildSyncStatusCard(statusWord, statusDotColor),
                    const SizedBox(height: 24),
                    _buildSectionHeader('AUTOMATIC SYNC'),
                    const SizedBox(height: 10),
                    _buildAutoSyncCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('MOBILE DATA'),
                    const SizedBox(height: 10),
                    _buildMobileDataCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('MANUAL SYNC'),
                    const SizedBox(height: 10),
                    _buildManualSyncCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('CONNECTED DEVICES'),
                    const SizedBox(height: 10),
                    _buildConnectedDevicesCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('BACKUP INFORMATION'),
                    const SizedBox(height: 10),
                    _buildBackupInfoCard(),
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
            onTap: () => Navigator.of(context).pop(_lastSyncLabel),
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
              'Backup & Sync',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _isSyncingNow ? _mint : _forest,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _isSyncingNow ? 'SYNCING' : 'SAVED',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _stoneGrey,
                  letterSpacing: 0.8,
                ),
              ),
            ],
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

  Widget _buildSyncStatusCard(String statusWord, Color statusDotColor) {
    final usedRatio = (_cloudUsedGb / _cloudTotalGb).clamp(0.0, 1.0);

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
                flex: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: statusDotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            statusWord,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: _offWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Status',
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
                flex: 42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lastSyncLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Last Sync',
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
                flex: 28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_connectedDevices.length} Active',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Devices',
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
          const SizedBox(height: 16),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _showCloudBreakdownSheet,
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.cloud_outlined,
                      color: _stoneGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cloud Storage: ${_cloudUsedGb.toStringAsFixed(1)} GB used',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _stoneGrey,
                        ),
                      ),
                    ),
                    Text(
                      'of ${_cloudTotalGb.toStringAsFixed(0)} GB',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AnimatedBuilder(
                  animation: _storageBarAnim,
                  builder: (context, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: usedRatio * _storageBarAnim.value,
                        minHeight: 5,
                        backgroundColor: _obsidian,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(_forest),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSyncCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_sync_outlined, color: _stoneGrey, size: 20),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Cloud Sync',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: _offWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Training, health and media sync in the background',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.35,
                    color: _stoneGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _SyncPillSwitch(
            value: _autoCloudSync,
            onChanged: (v) => setState(() => _autoCloudSync = v),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDataCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.signal_cellular_4_bar_rounded,
            color: _stoneGrey,
            size: 19,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sync Using Mobile Data',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: _offWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'When off, Ulvenik only syncs on Wi-Fi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.35,
                    color: _stoneGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _SyncPillSwitch(
            value: _syncMobileData,
            onChanged: (v) => setState(() => _syncMobileData = v),
          ),
        ],
      ),
    );
  }

  Widget _buildManualSyncCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _runManualSync,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  RotationTransition(
                    turns: _syncSpinController,
                    child: const Icon(Icons.sync_rounded,
                      color: _forest,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSyncingNow
                              ? 'Syncing (${(_syncProgress * 100).round()}%)…'
                              : 'Sync Now',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: _forest,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Immediately sync all outstanding data',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isSyncingNow) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _syncProgress,
                    minHeight: 4,
                    backgroundColor: _obsidian,
                    valueColor: const AlwaysStoppedAnimation<Color>(_forest),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectedDevicesCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ..._connectedDevices.asMap().entries.map((entry) {
            final idx = entry.key;
            final dev = entry.value;
            return Column(
              children: [
                if (idx > 0) Container(height: 1, color: _cardBorder),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      UlvenikIcon.fromMaterial(dev.$3, color: _stoneGrey, size: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dev.$1,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: _offWhite,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              dev.$2,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5,
                                color: _stoneGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (dev.$4)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _forest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'THIS DEVICE',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _offWhite,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      else
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _confirmRemoveDevice(idx),
                          icon: const Icon(Icons.delete_outline_rounded,
                            color: _stoneGrey,
                            size: 19,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }),
          if (_connectedDevices.length < 2) ...[
            Container(height: 1, color: _cardBorder),
            InkWell(
              onTap: () {
                setState(() {
                  _connectedDevices = [
                    ..._connectedDevices,
                    (
                      'MacBook Pro',
                      'Last Active: Just paired',
                      Icons.laptop_mac_rounded,
                      false,
                    ),
                  ];
                });
                AppSnackbar.show(
                  context,
                  title: 'Companion Device Linked',
                  message: 'MacBook Pro reconnected to Cloud Sync.',
                  type: SnackbarType.success,
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UlvenikIcon(UlvenikIcons.add, color: _forest, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Link Companion Device',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _forest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBackupInfoCard() {
    final rows = [
      ('Last Backup', _lastSyncLabel),
      ('Backup Size', '$_backupSizeMb MB'),
      (
        'Cloud Storage Used',
        '${_cloudUsedGb.toStringAsFixed(1)} GB of ${_cloudTotalGb.toStringAsFixed(0)} GB',
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
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: _cardBorder),
              InkWell(
                onTap: _showCloudBreakdownSheet,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const _DatabaseStackIcon(color: _stoneGrey),
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
                          fontWeight: FontWeight.w400,
                          color: _stoneGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DatabaseStackIcon extends StatelessWidget {
  final Color color;
  const _DatabaseStackIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 18),
      painter: _DatabaseStackPainter(color: color),
    );
  }
}

class _DatabaseStackPainter extends CustomPainter {
  final Color color;
  const _DatabaseStackPainter({required this.color});

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
  bool shouldRepaint(covariant _DatabaseStackPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SyncPillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SyncPillSwitch({
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
              ? _BackupSyncScreenState._forest
              : _BackupSyncScreenState._switchOffTrack,
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
              color: _BackupSyncScreenState._offWhite,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
