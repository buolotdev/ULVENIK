import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sc_settings_screen.dart';

/// Item representing a previously generated export file in Export History.
class ExportHistoryItem {
  final String id;
  final String fileName;
  final String dateLabel;
  final String format; // 'PDF', 'CSV', 'JSON'
  final String fileSize;
  final int sessionCount;
  final String dogName;

  const ExportHistoryItem({
    required this.id,
    required this.fileName,
    required this.dateLabel,
    required this.format,
    required this.fileSize,
    required this.sessionCount,
    this.dogName = 'Murphy',
  });
}

/// Preview data point for the interactive animated training volume chart.
class ExportChartPoint {
  final String label;
  final double sessionCount;
  final double loadPoints;
  final String detail;

  const ExportChartPoint({
    required this.label,
    required this.sessionCount,
    required this.loadPoints,
    required this.detail,
  });
}

class ExportScreen extends StatefulWidget {
  final bool initialEmpty;
  final String dogName;

  const ExportScreen({
    super.key,
    this.initialEmpty = false,
    this.dogName = 'Murphy',
  });

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen>
    with SingleTickerProviderStateMixin {
  // ─── Theme Colors (Faithful to Figma & Ulvenik Design Tokens) ───────────────
  static const _obsidian = Color(0xFF101214);
  static const _surface = Color(0xFF111412);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _forest = Color(0xFF2E6B57);
  static const _mint = Color(0xFF95D3BB);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _stoneGrey = Color(0xFFA7B0AB);
  static const _errorRed = Color(0xFFFFB4AB);

  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));

  // ─── Dual Screen State: Empty State vs Configured State ────────────────────
  late bool _isEmptyState;
  late String _currentDog;

  // ─── STATE 1: Configured Populated State Variables (Screenshot 1) ──────────
  String _scopeType = 'range'; // 'all' or 'range'
  String _selectedDateRange = 'Last 30 Days';
  DateTimeRange? _customRange;

  final List<String> _dateRangePresets = const [
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'This Year',
    'All Time',
    'Custom',
  ];

  late Map<String, bool> _includeDataConfigured;
  String _exportFormatConfigured = 'PDF';
  late TextEditingController _fileNameConfiguredController;
  bool _isCustomFileName = false;
  late List<ExportHistoryItem> _history;

  // ─── STATE 2: Empty History State Variables (Screenshot 2) ─────────────────
  String _emptyScopeOption = 'All Dogs'; // Unselected or selected on tap
  bool _emptyScopeSelected = false;

  final List<String> _emptyScopeOptions = const [
    'All Dogs',
    'Selected Dogs Only',
    'Training Sessions Only',
    'Competitions Only',
    'Health Metrics Only',
  ];

  late Map<String, bool> _includeDataEmpty;
  String? _exportFormatEmpty; // None selected by default in Screenshot 2
  late TextEditingController _fileNameEmptyController;

  // Chart Animation & Interactive Tooltip State
  late AnimationController _chartAnimController;
  late Animation<double> _chartProgress;
  int _touchedBarIndex = -1;

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
    _currentDog = widget.dogName;

    // Configured state defaults (Screenshot 1)
    _includeDataConfigured = {
      'Session Details': true,
      'Notes': true,
      'Statistics': true,
      'Goals': true,
      'Equipment': true,
      'Tags': true,
      'Photos': true,
      'Videos': true,
      'Activity Insights': false,
      'Location': false,
      'Weather': false,
    };

    _fileNameConfiguredController = TextEditingController(
      text: '${_currentDog}_Strength_Conditioning_July_2027.pdf',
    );

    _history = [
      ExportHistoryItem(
        id: 'exp-1',
        fileName: '${_currentDog}_Strength_Conditioning_July_2027.pdf',
        dateLabel: '15 Jul 2027 · PDF',
        format: 'PDF',
        fileSize: '2.4 MB',
        sessionCount: 28,
        dogName: _currentDog,
      ),
      ExportHistoryItem(
        id: 'exp-2',
        fileName: '${_currentDog}_SC_June_2027_Training.csv',
        dateLabel: '2 Jun 2027 · CSV',
        format: 'CSV',
        fileSize: '640 KB',
        sessionCount: 24,
        dogName: _currentDog,
      ),
      ExportHistoryItem(
        id: 'exp-3',
        fileName: '${_currentDog}_Spring_Endurance_Telemetry.json',
        dateLabel: '18 May 2027 · JSON',
        format: 'JSON',
        fileSize: '1.1 MB',
        sessionCount: 19,
        dogName: _currentDog,
      ),
    ];

    // Empty state defaults (Screenshot 2 - all unchecked)
    _includeDataEmpty = {
      'Session Notes': false,
      'Environmental Conditions': false,
      'Handler Notes': false,
      'Video References': false,
      'GPS Coordinates': false,
      'Heart Rate Data': false,
      'Recovery Scores': false,
      'Injury Logs': false,
      'Nutrition Logs': false,
      'Weight History': false,
      'Custom Tags': false,
    };

    _fileNameEmptyController = TextEditingController();

    _chartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _chartProgress = CurvedAnimation(
      parent: _chartAnimController,
      curve: Curves.easeOutCubic,
    );
    _chartAnimController.forward();
  }

  @override
  void dispose() {
    _chartAnimController.dispose();
    _fileNameConfiguredController.dispose();
    _fileNameEmptyController.dispose();
    super.dispose();
  }

  // ─── Helper: Update File Name dynamically unless manually edited ───────────
  void _updateDefaultFileName() {
    if (_isCustomFileName) return;
    final ext = _exportFormatConfigured.toLowerCase();
    final rangeStr = _selectedDateRange.replaceAll(' ', '_');
    setState(() {
      _fileNameConfiguredController.text =
          '${_currentDog}_Strength_Conditioning_${rangeStr}_2027.$ext';
    });
  }

  // ─── Chart Data Based on Selected Date Range ───────────────────────────────
  List<ExportChartPoint> get _chartPoints {
    switch (_selectedDateRange) {
      case 'Last 7 Days':
        return const [
          ExportChartPoint(label: 'Mon', sessionCount: 2, loadPoints: 120, detail: '2 Sessions · 50 min'),
          ExportChartPoint(label: 'Tue', sessionCount: 1, loadPoints: 90, detail: '1 Session · 30 min'),
          ExportChartPoint(label: 'Wed', sessionCount: 3, loadPoints: 180, detail: '3 Sessions · 75 min'),
          ExportChartPoint(label: 'Thu', sessionCount: 1, loadPoints: 60, detail: '1 Session · 20 min'),
          ExportChartPoint(label: 'Fri', sessionCount: 2, loadPoints: 150, detail: '2 Sessions · 60 min'),
          ExportChartPoint(label: 'Sat', sessionCount: 3, loadPoints: 210, detail: '3 Sessions · 90 min'),
          ExportChartPoint(label: 'Sun', sessionCount: 1, loadPoints: 40, detail: '1 Recovery Walk'),
        ];
      case 'Last 90 Days':
        return const [
          ExportChartPoint(label: 'May W1', sessionCount: 7, loadPoints: 520, detail: '7 Sessions'),
          ExportChartPoint(label: 'May W3', sessionCount: 9, loadPoints: 680, detail: '9 Sessions'),
          ExportChartPoint(label: 'Jun W1', sessionCount: 6, loadPoints: 490, detail: '6 Sessions'),
          ExportChartPoint(label: 'Jun W3', sessionCount: 8, loadPoints: 610, detail: '8 Sessions'),
          ExportChartPoint(label: 'Jul W1', sessionCount: 10, loadPoints: 740, detail: '10 Sessions'),
          ExportChartPoint(label: 'Jul W3', sessionCount: 8, loadPoints: 630, detail: '8 Sessions'),
        ];
      case 'This Year':
      case 'All Time':
        return const [
          ExportChartPoint(label: 'Jan', sessionCount: 18, loadPoints: 1400, detail: '18 Sessions'),
          ExportChartPoint(label: 'Feb', sessionCount: 22, loadPoints: 1720, detail: '22 Sessions'),
          ExportChartPoint(label: 'Mar', sessionCount: 25, loadPoints: 1950, detail: '25 Sessions'),
          ExportChartPoint(label: 'Apr', sessionCount: 20, loadPoints: 1560, detail: '20 Sessions'),
          ExportChartPoint(label: 'May', sessionCount: 26, loadPoints: 2040, detail: '26 Sessions'),
          ExportChartPoint(label: 'Jun', sessionCount: 24, loadPoints: 1880, detail: '24 Sessions'),
          ExportChartPoint(label: 'Jul', sessionCount: 28, loadPoints: 2190, detail: '28 Sessions'),
        ];
      case 'Last 30 Days':
      default:
        return const [
          ExportChartPoint(label: 'W1', sessionCount: 6, loadPoints: 480, detail: '6 Sessions · Treadmill & Hills'),
          ExportChartPoint(label: 'W2', sessionCount: 8, loadPoints: 640, detail: '8 Sessions · Agility & Carries'),
          ExportChartPoint(label: 'W3', sessionCount: 5, loadPoints: 390, detail: '5 Sessions · Swimming Intervals'),
          ExportChartPoint(label: 'W4', sessionCount: 9, loadPoints: 720, detail: '9 Sessions · Peak Conditioning'),
        ];
    }
  }

  int get _totalSessionsToExport {
    int sum = 0;
    for (final p in _chartPoints) {
      sum += p.sessionCount.toInt();
    }
    return sum > 0 ? sum : 28;
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  void _toggleAllIncludeDataConfigured(bool selectAll) {
    setState(() {
      for (final key in _includeDataConfigured.keys) {
        _includeDataConfigured[key] = selectAll;
      }
    });
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _customRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _forest,
              onPrimary: _offWhite,
              surface: _carbon,
              onSurface: _offWhite,
              secondary: _mint,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: _carbon,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (!mounted) return;
      setState(() {
        _customRange = picked;
        _selectedDateRange = 'Custom';
        _chartAnimController.reset();
        _chartAnimController.forward();
      });
      _updateDefaultFileName();
    }
  }

  void _triggerExportGeneration() {
    final activeData = _isEmptyState ? _includeDataEmpty : _includeDataConfigured;
    final selectedCount = activeData.values.where((v) => v).length;

    if (selectedCount == 0 && _isEmptyState) {
      return;
    }

    final format = _isEmptyState
        ? (_exportFormatEmpty ?? 'PDF')
        : _exportFormatConfigured;

    final rawName = _isEmptyState
        ? _fileNameEmptyController.text.trim()
        : _fileNameConfiguredController.text.trim();

    final filename = rawName.isEmpty
        ? '${_currentDog}_Strength_Conditioning_Export.${format.toLowerCase().replaceAll(" summary", "")}'
        : rawName;

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _ExportProgressModal(
        fileName: filename,
        format: format,
        sessionCount: _totalSessionsToExport,
        onFinished: () {
          Navigator.pop(ctx);
          final newItem = ExportHistoryItem(
            id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
            fileName: filename,
            dateLabel: 'Just now · $format',
            format: format.contains('PDF') ? 'PDF' : (format.contains('CSV') ? 'CSV' : 'JSON'),
            fileSize: '1.8 MB',
            sessionCount: _totalSessionsToExport,
            dogName: _currentDog,
          );

          setState(() {
            _history.insert(0, newItem);
            _isEmptyState = false; // Transition to populated configured state with new item visible!
          });
        },
      ),
    );
  }

  void _handleReDownload(ExportHistoryItem item) {}

  void _showItemOptions(ExportHistoryItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              item.fileName,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.dateLabel} · ${item.fileSize} · ${item.sessionCount} Sessions',
              style: const TextStyle(color: _stoneGrey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.share_outlined, color: _mint),
              title: const Text('Share File', style: TextStyle(color: _offWhite)),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined, color: _offWhite),
              title: const Text('Save to Local Storage', style: TextStyle(color: _offWhite)),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(ctx);
                _handleReDownload(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: _errorRed),
              title: const Text('Delete from History', style: TextStyle(color: _errorRed)),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  _history.removeWhere((h) => h.id == item.id);
                  if (_history.isEmpty) _isEmptyState = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build Method ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(
          bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: GestureDetector(
          onDoubleTap: () {
            setState(() => _isEmptyState = !_isEmptyState);
          },
          child: const Text(
            'Export',
            style: TextStyle(
              color: _offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          // Quick Toggle Complete Empty State vs Configured State Button
          IconButton(
            tooltip: _isEmptyState
                ? 'Switch to Configured State'
                : 'Switch to Empty State',
            icon: Icon(
              _isEmptyState ? Icons.inventory_2_outlined : Icons.inventory_2,
              color: _mint,
              size: 22,
            ),
            onPressed: () {
              setState(() => _isEmptyState = !_isEmptyState);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: _stoneGrey),
            tooltip: 'Options',
            color: _carbon,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'toggle') {
                setState(() => _isEmptyState = !_isEmptyState);
              } else if (val == 'reset') {
                setState(() {
                  _scopeType = 'range';
                  _selectedDateRange = 'Last 30 Days';
                  _exportFormatConfigured = 'PDF';
                  _isCustomFileName = false;
                  for (final k in _includeDataConfigured.keys) {
                    _includeDataConfigured[k] = true;
                  }
                  _emptyScopeSelected = false;
                  for (final k in _includeDataEmpty.keys) {
                    _includeDataEmpty[k] = false;
                  }
                  _exportFormatEmpty = null;
                  _fileNameEmptyController.clear();
                  _updateDefaultFileName();
                });
              } else if (val == 'clear') {
                setState(() {
                  _history.clear();
                  _isEmptyState = true;
                });
              } else if (val == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SCSettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                      _isEmptyState ? Icons.visibility : Icons.visibility_off,
                      color: _mint,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isEmptyState
                          ? 'View Configured State'
                          : 'View Empty State',
                      style: const TextStyle(color: _offWhite, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: _offWhite, size: 18),
                    SizedBox(width: 10),
                    Text('Reset Configuration', style: TextStyle(color: _offWhite, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined, color: _errorRed, size: 18),
                    SizedBox(width: 10),
                    Text('Clear Export History', style: TextStyle(color: _errorRed, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: _mint, size: 18),
                    SizedBox(width: 10),
                    Text('S & C Settings', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // Clean separation of states: Complete Empty State view vs Complete Configured State view
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        physics: const BouncingScrollPhysics(),
        child: _isEmptyState
            ? _buildEmptyStateView()
            : _buildConfiguredStateView(),
      ),
    );
  }

  // ===========================================================================
  // STATE 1: COMPLETE CONFIGURED STATE VIEW (Screenshot 1 / Figma Frame 2)
  // ===========================================================================

  Widget _buildConfiguredStateView() {
    final areAllSelected = _includeDataConfigured.values.every((v) => v);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Section 1: EXPORT SCOPE ─────────────────────────────────────────
        _buildSectionHeader('EXPORT SCOPE'),
        const SizedBox(height: 12),
        _buildExportScopeCardConfigured(),
        const SizedBox(height: 24),

        // ─── Section 2: DATE RANGE ───────────────────────────────────────────
        _buildSectionHeader('DATE RANGE'),
        const SizedBox(height: 12),
        _buildDateRangeSelector(),
        const SizedBox(height: 24),

        // ─── Section 3: INCLUDE DATA ─────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('INCLUDE DATA'),
            TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              ),
              onPressed: () => _toggleAllIncludeDataConfigured(!areAllSelected),
              child: Text(
                areAllSelected ? 'Deselect All' : 'Select All',
                style: const TextStyle(
                  color: _mint,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildIncludeDataGridConfigured(),
        const SizedBox(height: 24),

        // ─── Section 4: DATA PREVIEW (INTERACTIVE GRAPH) ─────────────────────
        _buildInteractiveChartPreview(),
        const SizedBox(height: 24),

        // ─── Section 5: EXPORT FORMAT ────────────────────────────────────────
        _buildSectionHeader('EXPORT FORMAT'),
        const SizedBox(height: 12),
        _buildFormatSelectorConfigured(),
        const SizedBox(height: 24),

        // ─── Section 6: FILE NAME ────────────────────────────────────────────
        _buildSectionHeader('FILE NAME'),
        const SizedBox(height: 12),
        _buildFileNameInputConfigured(),
        const SizedBox(height: 6),
        const Text(
          'Tap to rename before exporting',
          style: TextStyle(color: _stoneGrey, fontSize: 12),
        ),
        const SizedBox(height: 20),

        // ─── Section 7: GENERATE BUTTON ──────────────────────────────────────
        _buildGenerateButtonConfigured(),
        const SizedBox(height: 28),

        // ─── Section 8: EXPORT HISTORY ───────────────────────────────────────
        _buildSectionHeader('EXPORT HISTORY'),
        const SizedBox(height: 12),
        _buildPopulatedHistoryList(),
      ],
    );
  }

  // ─── CONFIGURED SUB-WIDGETS ────────────────────────────────────────────────

  Widget _buildExportScopeCardConfigured() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(10),
        border: _hairlineBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Option 1: All Time Data
          InkWell(
            onTap: () {
              setState(() {
                _scopeType = 'all';
                _selectedDateRange = 'All Time';
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
              _updateDefaultFileName();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _scopeType == 'all'
                    ? _forest.withValues(alpha: 0.12)
                    : Colors.transparent,
                border: const Border(
                  bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Time Data',
                    style: TextStyle(
                      color: _scopeType == 'all' ? _mint : _offWhite,
                      fontSize: 13,
                      fontWeight:
                          _scopeType == 'all' ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  _scopeType == 'all'
                      ? const Icon(Icons.check_circle, color: _mint, size: 20)
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 1.5),
                          ),
                        ),
                ],
              ),
            ),
          ),

          // Option 2: Selected Date Range
          InkWell(
            onTap: () {
              setState(() {
                _scopeType = 'range';
                _selectedDateRange = 'Last 30 Days';
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
              _updateDefaultFileName();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: _scopeType == 'range'
                  ? _forest.withValues(alpha: 0.12)
                  : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Date Range',
                    style: TextStyle(
                      color: _scopeType == 'range' ? _mint : _offWhite,
                      fontSize: 13,
                      fontWeight:
                          _scopeType == 'range' ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  _scopeType == 'range'
                      ? const Icon(Icons.check_circle, color: _mint, size: 20)
                      : Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 1.5),
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

  Widget _buildDateRangeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: _dateRangePresets.map((preset) {
        final isSelected = _selectedDateRange == preset;
        final isCustom = preset == 'Custom';

        return InkWell(
          onTap: () {
            if (isCustom) {
              _pickCustomDateRange();
            } else {
              setState(() {
                _selectedDateRange = preset;
                _scopeType = preset == 'All Time' ? 'all' : 'range';
                _chartAnimController.reset();
                _chartAnimController.forward();
              });
              _updateDefaultFileName();
            }
          },
          borderRadius: BorderRadius.circular(9999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _forest : _carbon,
              borderRadius: BorderRadius.circular(9999),
              border: isSelected
                  ? Border.all(color: _mint, width: 1)
                  : _hairlineBorder,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  preset,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _offWhite.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (isCustom) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new,
                    size: 14,
                    color: isSelected ? _offWhite : _stoneGrey,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIncludeDataGridConfigured() {
    final keys = _includeDataConfigured.keys.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final colWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: keys.map((key) {
            final isChecked = _includeDataConfigured[key] ?? false;

            return InkWell(
              onTap: () {
                setState(() {
                  _includeDataConfigured[key] = !isChecked;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: colWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(8),
                  border: isChecked
                      ? Border.all(color: _forest, width: 1)
                      : _hairlineBorder,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isChecked ? _forest : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: isChecked
                            ? Border.all(color: _mint, width: 1)
                            : Border.all(color: Colors.white24, width: 1),
                      ),
                      child: isChecked
                          ? const Icon(Icons.check, size: 14, color: _offWhite)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        key,
                        style: TextStyle(
                          color: isChecked ? _offWhite : _stoneGrey,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildInteractiveChartPreview() {
    final points = _chartPoints;
    final maxPoints = points.map((p) => p.sessionCount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.insights, color: _mint, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'EXPORT DATA PREVIEW',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: _mint.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '$_totalSessionsToExport Sessions',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Interactive telemetry over $_selectedDateRange. Tap any bar to view details.',
            style: const TextStyle(color: _stoneGrey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Bar Chart with FL Chart
          SizedBox(
            height: 140,
            child: AnimatedBuilder(
              animation: _chartProgress,
              builder: (context, _) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (maxPoints * 1.25).clamp(5, 50),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => _surfaceHigh,
                        tooltipBorder: const BorderSide(color: Colors.white12),
                        tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final point = points[group.x.toInt()];
                          return BarTooltipItem(
                            '${point.label}: ${point.sessionCount.toInt()} Sessions\n${point.detail}',
                            const TextStyle(
                              color: _mint,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        if (response != null && response.spot != null) {
                          setState(() {
                            _touchedBarIndex = response.spot!.touchedBarGroupIndex;
                          });
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            if (idx >= 0 && idx < points.length) {
                              final isSelected = _touchedBarIndex == idx;
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  points[idx].label,
                                  style: TextStyle(
                                    color: isSelected ? _mint : _stoneGrey,
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: points.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final point = entry.value;
                      final isSelected = _touchedBarIndex == idx;

                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: point.sessionCount * _chartProgress.value,
                            color: isSelected ? _mint : _forest,
                            width: 18,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: (maxPoints * 1.25).clamp(5, 50),
                              color: Colors.white.withValues(alpha: 0.03),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated payload size: ~${_exportFormatConfigured == "PDF" ? "2.4 MB" : (_exportFormatConfigured == "CSV" ? "540 KB" : "1.2 MB")}',
                style: const TextStyle(color: _stoneGrey, fontSize: 11),
              ),
              const Row(
                children: [
                  Icon(Icons.lock_outline, size: 12, color: _mint),
                  SizedBox(width: 4),
                  Text(
                    'AES-256 Encrypted Export',
                    style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelectorConfigured() {
    final formats = [
      {
        'format': 'PDF',
        'title': 'PDF',
        'desc': 'Professional document, ideal for coaches and vets',
      },
      {
        'format': 'CSV',
        'title': 'CSV',
        'desc': 'Raw data format for spreadsheet analysis',
      },
      {
        'format': 'JSON',
        'title': 'JSON',
        'desc': 'Structured data for developers and APIs',
      },
    ];

    return Column(
      children: formats.map((item) {
        final fmt = item['format'] as String;
        final isSelected = _exportFormatConfigured == fmt;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _exportFormatConfigured = fmt;
              });
              _updateDefaultFileName();
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? _forest.withValues(alpha: 0.12)
                    : _carbon,
                borderRadius: BorderRadius.circular(10),
                border: isSelected
                    ? Border.all(color: _forest, width: 1.5)
                    : _hairlineBorder,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? _forest : Colors.transparent,
                        border: isSelected
                            ? Border.all(color: _mint, width: 1.5)
                            : Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: _mint,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['desc'] as String,
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
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
      }).toList(),
    );
  }

  Widget _buildFileNameInputConfigured() {
    return Container(
      decoration: BoxDecoration(
        color: _obsidian,
        borderRadius: BorderRadius.circular(10),
        border: _hairlineBorder,
      ),
      child: TextField(
        controller: _fileNameConfiguredController,
        style: const TextStyle(
          color: _offWhite,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (val) {
          _isCustomFileName = true;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: 'Enter a file name...',
          hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.edit_outlined, color: _stoneGrey, size: 20),
            tooltip: 'Rename',
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateButtonConfigured() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _forest,
          foregroundColor: _offWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _triggerExportGeneration,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ios_share, size: 20, color: _offWhite),
            SizedBox(width: 8),
            Text(
              'Generate Export',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20, color: _offWhite),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulatedHistoryList() {
    return Column(
      children: _history.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          child: Row(
            children: [
              // Icon Badge
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _mint.withValues(alpha: 0.2)),
                ),
                child: Center(
                  child: Icon(
                    item.format == 'PDF'
                        ? Icons.picture_as_pdf
                        : (item.format == 'CSV' ? Icons.table_chart : Icons.data_object),
                    color: _mint,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // File Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fileName,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.dateLabel} · ${item.fileSize}',
                      style: const TextStyle(
                        color: _stoneGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Action: Re-download / Options
              IconButton(
                icon: const Icon(Icons.refresh, color: _stoneGrey),
                tooltip: 'Re-export',
                onPressed: () => _handleReDownload(item),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: _stoneGrey, size: 18),
                tooltip: 'More actions',
                onPressed: () => _showItemOptions(item),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // STATE 2: COMPLETE EMPTY STATE VIEW (Screenshot 2 / Figma Frame 1)
  // ===========================================================================

  Widget _buildEmptyStateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Section 1: EXPORT SCOPE (Figma Frame 1) ─────────────────────────
        _buildSectionHeader('EXPORT SCOPE'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: _emptyScopeOptions.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              final isSelected = _emptyScopeSelected && _emptyScopeOption == opt;
              final isLast = idx == _emptyScopeOptions.length - 1;

              return InkWell(
                onTap: () {
                  setState(() {
                    _emptyScopeOption = opt;
                    _emptyScopeSelected = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _forest.withValues(alpha: 0.12)
                        : Colors.transparent,
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opt,
                        style: TextStyle(
                          color: isSelected ? _mint : _offWhite,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      isSelected
                          ? const Icon(Icons.check_circle, color: _mint, size: 20)
                          : Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24, width: 1.5),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        // ─── Section 2: INCLUDE DATA (Figma Frame 1 - 11 Unchecked Checkboxes) ─
        _buildSectionHeader('INCLUDE DATA'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: _includeDataEmpty.keys.toList().asMap().entries.map((entry) {
              final idx = entry.key;
              final key = entry.value;
              final isChecked = _includeDataEmpty[key] ?? false;
              final isLast = idx == _includeDataEmpty.length - 1;

              return InkWell(
                onTap: () {
                  setState(() {
                    _includeDataEmpty[key] = !isChecked;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? _forest.withValues(alpha: 0.12)
                        : Colors.transparent,
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
                          ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isChecked ? _forest : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: isChecked
                              ? Border.all(color: _mint, width: 1)
                              : Border.all(color: Colors.white24, width: 1),
                        ),
                        child: isChecked
                            ? const Icon(Icons.check, size: 14, color: _offWhite)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          key,
                          style: TextStyle(
                            color: isChecked ? _offWhite : _offWhite.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontWeight: isChecked ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        // ─── Section 3: EXPORT FORMAT (Figma Frame 1 - CSV, JSON, PDF Summary) ─
        _buildSectionHeader('EXPORT FORMAT'),
        const SizedBox(height: 12),
        Column(
          children: ['CSV', 'JSON', 'PDF Summary'].map((fmt) {
            final isSelected = _exportFormatEmpty == fmt;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _exportFormatEmpty = fmt;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _forest.withValues(alpha: 0.12)
                        : _carbon,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: _mint, width: 1.5)
                        : _hairlineBorder,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? _forest : Colors.transparent,
                          border: isSelected
                              ? Border.all(color: _mint, width: 1.5)
                              : Border.all(color: Colors.white24, width: 1.5),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: _mint,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        fmt,
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // ─── Section 4: FILE NAME (Figma Frame 1 - Placeholder: Enter a file name...)
        _buildSectionHeader('FILE NAME'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF191C1F),
            borderRadius: BorderRadius.circular(10),
            border: _hairlineBorder,
          ),
          child: TextField(
            controller: _fileNameEmptyController,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: 'Enter a file name...',
              hintStyle: TextStyle(
                color: _stoneGrey.withValues(alpha: 0.6),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ─── Section 5: GENERATE BUTTON (Figma Frame 1 - Dimmed/Disabled) ─────
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B2A24), // Dimmed dark forest
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: InkWell(
              onTap: () {
                // If user tapped generate in empty state, guide them or generate!
                _triggerExportGeneration();
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_download_outlined,
                    size: 18,
                    color: _mint.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Generate Export',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _mint.withValues(alpha: 0.6),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // ─── Section 6: EXPORT HISTORY (Figma Frame 1 - No Exports Yet Card) ──
        _buildSectionHeader('EXPORT HISTORY'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(12),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2825),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _forest.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: _mint,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'No Exports Yet',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You haven\'t generated any exports yet.\nSelect options above to create your first data file.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _mint,
                  side: const BorderSide(color: _mint),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Switch to Configured State', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                onPressed: () {
                  setState(() => _isEmptyState = false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── SECTION HEADER HELPER ─────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.05,
      ),
    );
  }
}

// ─── REALISTIC EXPORT PROGRESS MODAL ─────────────────────────────────────────

class _ExportProgressModal extends StatefulWidget {
  final String fileName;
  final String format;
  final int sessionCount;
  final VoidCallback onFinished;

  const _ExportProgressModal({
    required this.fileName,
    required this.format,
    required this.sessionCount,
    required this.onFinished,
  });

  @override
  State<_ExportProgressModal> createState() => _ExportProgressModalState();
}

class _ExportProgressModalState extends State<_ExportProgressModal> {
  double _progress = 0.15;
  String _currentStep = 'Collecting training logs & telemetry...';

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _progress = 0.45;
      _currentStep = 'Formatting ${widget.format} layout & charts...';
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _progress = 0.80;
      _currentStep = 'Encrypting package with AES-256...';
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() {
      _progress = 1.0;
      _currentStep = 'Export package generated!';
    });

    await Future.delayed(const Duration(milliseconds: 250));
    if (mounted) {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              color: Color(0xFF95D3BB),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Exporting ${widget.format} Bundle',
            style: const TextStyle(
              color: Color(0xFFF5F6F2),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.fileName,
            style: const TextStyle(color: Color(0xFFA7B0AB), fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: const Color(0xFF272B29),
              color: const Color(0xFF2E6B57),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currentStep,
            style: const TextStyle(
              color: Color(0xFF95D3BB),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
