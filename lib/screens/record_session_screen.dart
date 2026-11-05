import 'activity_library_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import 'session_details_screen.dart';

class RecordSessionScreen extends StatefulWidget {
  final String? initialActivityName;
  final String? initialCategory;
  final IconData? initialIcon;
  final bool startWithActivity;
  final List<CustomActivityMetric>? initialCustomMetrics;

  const RecordSessionScreen({
    super.key,
    this.initialActivityName,
    this.initialCategory,
    this.initialIcon,
    this.startWithActivity = true,
    this.initialCustomMetrics,
  });

  @override
  State<RecordSessionScreen> createState() => _RecordSessionScreenState();
}

class _RecordSessionScreenState extends State<RecordSessionScreen> {
  // Scandinavian Obsidian / Carbon Dark Theme
  static const _obsidian = Color(0xFF101214);
  static const _carbon = Color(0xFF1A1F22);
  static const _surfaceHigh = Color(0xFF272B29);
  static const _forestGreen = Color(0xFF2E6B57);
  static const _mint = Color(0xFF95D3BB);
  static const _sage = Color(0xFFB6CCB5);
  static const _stoneGrey = Color(0xFFA7B0AB);
  static const _offWhite = Color(0xFFF5F6F2);
  static const _outline = Color(0xFF89938E);
  static const _outlineVariant = Color(0xFF404944);

  static final _hairlineBorder =
      Border.all(color: Colors.white.withValues(alpha: 0.08));
  static final _hairlineSide =
      BorderSide(color: Colors.white.withValues(alpha: 0.08));

  // Activity Selection State
  late bool _hasActivity;
  String _activityName = 'Hill Work';
  String _category = 'Strength & Conditioning';
  IconData _activityIcon = Icons.terrain;

  // Date & Time State
  DateTime _selectedDate = DateTime(2026, 8, 27);
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 15);

  // Metrics State
  String _intensity = 'Med'; // 'Low', 'Med', 'High'
  List<Map<String, String>> _recordedCustomMetrics = [];

  // Rating & Notes
  int _rating = 4; // 0 to 5 stars (default 4/5 as per design)
  final TextEditingController _notesController = TextEditingController();

  // Media attachments
  final List<Map<String, dynamic>> _attachedMedia = [];

  // Library activities catalog for picker
  final List<Map<String, dynamic>> _availableActivities = const [
    {
      'name': 'Hill Work',
      'category': 'Strength & Conditioning',
      'icon': Icons.terrain,
      'customMetrics': [
        {'name': 'Distance', 'unit': 'metres', 'default': '3200'},
        {'name': 'Load', 'unit': 'kg', 'default': '15'},
      ],
    },
    {
      'name': 'Swimming Fitness',
      'category': 'Hydrotherapy & Endurance',
      'icon': Icons.pool,
      'customMetrics': [
        {'name': 'Distance', 'unit': 'metres', 'default': '1800'},
      ],
    },
    {
      'name': 'Sprint Intervals',
      'category': 'Cardio & Speed',
      'icon': Icons.directions_run,
      'customMetrics': [
        {'name': 'Speed', 'unit': 'mph', 'default': '22'},
        {'name': 'Repetitions', 'unit': 'reps', 'default': '8'},
      ],
    },
    {
      'name': 'Weighted Carries',
      'category': 'Power & Core',
      'icon': Icons.fitness_center,
      'customMetrics': [
        {'name': 'Load', 'unit': 'kg', 'default': '15'},
        {'name': 'Repetitions', 'unit': 'reps', 'default': '12'},
      ],
    },
    {
      'name': 'Treadmill Sprints',
      'category': 'Endurance Work',
      'icon': Icons.speed,
      'customMetrics': [
        {'name': 'Speed', 'unit': 'mph', 'default': '16'},
        {'name': 'Incline', 'unit': '%', 'default': '6'},
      ],
    },
    {
      'name': 'Core & Balance',
      'category': 'Stability Drill',
      'icon': Icons.shield,
      'customMetrics': [
        {'name': 'Height', 'unit': 'cm', 'default': '30'},
        {'name': 'Repetitions', 'unit': 'reps', 'default': '10'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialActivityName != null &&
        widget.initialActivityName!.isNotEmpty) {
      _hasActivity = true;
      _activityName = widget.initialActivityName!;
      _category = widget.initialCategory ?? 'Strength & Conditioning';
      _activityIcon = widget.initialIcon ?? Icons.terrain;
    } else {
      _hasActivity = widget.startWithActivity;
    }

    if (widget.initialCustomMetrics != null) {
      _recordedCustomMetrics = widget.initialCustomMetrics!
          .map((m) => {'name': m.name, 'unit': m.unit, 'value': '10'})
          .toList();
    } else if (_hasActivity) {
      final match = _availableActivities.firstWhere(
        (a) => a['name'] == _activityName,
        orElse: () => _availableActivities.first,
      );
      final list = match['customMetrics'] as List<dynamic>?;
      if (list != null) {
        _recordedCustomMetrics = list
            .map((m) => {
                  'name': m['name'].toString(),
                  'unit': m['unit'].toString(),
                  'value': m['default']?.toString() ?? '10',
                })
            .toList();
      }
    }

    _notesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _durationMinutes {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final diff = endMinutes - startMinutes;
    return diff > 0 ? diff : 45;
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  String get _formattedDate {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
    final monthStr = _months[_selectedDate.month - 1];
    final formatted = '${_selectedDate.day} $monthStr ${_selectedDate.year}';
    return isToday ? 'Today, $formatted' : formatted;
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _forestGreen,
              onPrimary: _offWhite,
              surface: _carbon,
              onSurface: _offWhite,
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
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _forestGreen,
              onPrimary: _offWhite,
              surface: _carbon,
              onSurface: _offWhite,
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
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _forestGreen,
              onPrimary: _offWhite,
              surface: _carbon,
              onSurface: _offWhite,
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
      setState(() => _endTime = picked);
    }
  }

  void _saveSession() {
    if (!_hasActivity) {
      ScaffoldMessenger.of(context).clearSnackBars();
      AppSnackbar.show(
        context,
        message: 'Please select an activity first',
        type: SnackbarType.warning,
      );
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackbar.show(
      context,
      message: 'Session saved: $_activityName ($_durationMinutes min)',
      type: SnackbarType.success,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionDetailsScreen(
          sessionTitle: _activityName,
          dateSubtitle: _formattedDate,
          shortDate:
              '${_selectedDate.day} ${_months[_selectedDate.month - 1]} ${_selectedDate.year}',
          durationText:
              '${_durationMinutes ~/ 60 > 0 ? '${_durationMinutes ~/ 60}h ' : ''}${_durationMinutes % 60}m',
          initialRating: _rating,
          intensity: _intensity,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : 'Completed session with focus on cadence and consistency.',
          customMetrics: _recordedCustomMetrics,
          attachedMedia: _attachedMedia,
        ),
      ),
    );
  }

  void _discardSession() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: _hairlineSide,
        ),
        title: const Text(
          'Discard Session?',
          style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to discard this recorded training session? Unsaved metrics will be lost.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Editing', style: TextStyle(color: _sage)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Pop screen
              ScaffoldMessenger.of(context).clearSnackBars();
              AppSnackbar.show(
                context,
                message: 'Session draft discarded',
                type: SnackbarType.info,
              );
            },
            child: const Text('Discard', style: TextStyle(color: Color(0xFFFFB4AB))),
          ),
        ],
      ),
    );
  }

  void _showActivityPickerSheet() {
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Activity',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_hasActivity)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _hasActivity = false;
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      AppSnackbar.show(
                        context,
                        message: 'Cleared selected activity',
                        type: SnackbarType.info,
                      );
                    },
                    child: const Text(
                      'Clear Selection',
                      style: TextStyle(
                        color: Color(0xFFFFB4AB),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ..._availableActivities.map((act) {
              final isSelected =
                  _hasActivity && _activityName == act['name'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasActivity = true;
                      _activityName = act['name'] as String;
                      _category = act['category'] as String;
                      _activityIcon = act['icon'] as IconData;
                      final metrics = act['customMetrics'] as List<dynamic>?;
                      if (metrics != null && metrics.isNotEmpty) {
                        _recordedCustomMetrics = metrics
                            .map((m) => {
                                  'name': m['name'].toString(),
                                  'unit': m['unit'].toString(),
                                  'value': m['default']?.toString() ?? '10',
                                })
                            .toList();
                      } else {
                        _recordedCustomMetrics = [];
                      }
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    AppSnackbar.show(
                      context,
                      message: 'Selected "${act['name']}"',
                      type: SnackbarType.success,
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? _surfaceHigh : _obsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? _forestGreen
                            : Colors.white.withValues(alpha: 0.06),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _forestGreen.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: UlvenikIcon.fromMaterial(act['icon'] as IconData,
                              color: _mint, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act['name'] as String,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                act['category'] as String,
                                style: const TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const UlvenikIcon(UlvenikIcons.completed,
                              color: _mint, size: 20),
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
  }

  void _showCustomMetricAdjuster(String title, String unit,
      String currentVal, ValueChanged<String> onSaved) {
    final ctrl = TextEditingController(text: currentVal);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: _hairlineSide,
        ),
        title: Text('Record $title ($unit)',
            style: const TextStyle(
                color: _offWhite, fontSize: 17, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: const TextStyle(color: _offWhite, fontSize: 18),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: const TextStyle(color: _stoneGrey),
            filled: true,
            fillColor: _obsidian,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: _hairlineSide,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forestGreen,
              foregroundColor: _offWhite,
            ),
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isNotEmpty) {
                onSaved(text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      // No duplicate bottom navigation bar!
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const UlvenikIcon(UlvenikIcons.back, color: _mint, size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: GestureDetector(
          onDoubleTap: () {
            setState(() {
              _hasActivity = !_hasActivity;
            });
            AppSnackbar.show(
              context,
              message: _hasActivity
                  ? 'Switched to Activity Pre-selected'
                  : 'Switched to No Activity Selected',
              type: SnackbarType.info,
            );
          },
          child: const Text(
            'RECORD S&C SESSION',
            style: TextStyle(
              color: _offWhite,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                onTap: _discardSession,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    'DISCARD',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable Body
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_hasActivity) ...[
                  // ==========================================
                  // STATE A: ACTIVITY PRE-SELECTED
                  // ==========================================
                  _buildSelectedActivityCard(),
                  const SizedBox(height: 24),

                  _buildSelectedDateTimeCard(),
                  const SizedBox(height: 24),

                  if (_recordedCustomMetrics.isNotEmpty) ...[
                    _buildSessionMetricsGrid(),
                    const SizedBox(height: 24),
                  ],

                  _buildIntensityCard(),
                  const SizedBox(height: 24),

                  _buildRatingCard(),
                  const SizedBox(height: 24),

                  _buildNotesCard(),
                  const SizedBox(height: 24),

                  _buildMediaSection(),
                ] else ...[
                  // ==========================================
                  // STATE B: NO ACTIVITY SELECTED
                  // ==========================================
                  _buildNoActivityCard(),
                  const SizedBox(height: 24),

                  _buildNoActivityDateTimeCard(),
                  const SizedBox(height: 24),

                  _buildLockedMetricsSection(),
                  const SizedBox(height: 24),

                  _buildLockedRatingSection(),
                ],
              ],
            ),
          ),

          // Pinned Bottom Action Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionArea(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGETS: ACTIVITY SELECTED STATE
  // ==========================================
  Widget _buildSelectedActivityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: _hairlineBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: _forestGreen,
                  shape: BoxShape.circle,
                ),
                child: UlvenikIcon.fromMaterial(_activityIcon, color: _offWhite, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _activityName,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _category,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: _showActivityPickerSheet,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Change',
                style: TextStyle(
                  color: _mint,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateTimeCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: _hairlineBorder,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Date Row
                InkWell(
                  onTap: _pickDate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            UlvenikIcon(UlvenikIcons.calendar,
                                color: _outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Date',
                              style: TextStyle(
                                  color: _stoneGrey, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              _formattedDate,
                              style: const TextStyle(
                                  color: _offWhite, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            const UlvenikIcon(UlvenikIcons.details,
                                color: _outline, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

                // Start Time Row
                InkWell(
                  onTap: _pickStartTime,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            UlvenikIcon(UlvenikIcons.trainingTime, color: _outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Start Time',
                              style: TextStyle(
                                  color: _stoneGrey, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              _formatTimeOfDay(_startTime),
                              style: const TextStyle(
                                  color: _offWhite, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            const UlvenikIcon(UlvenikIcons.details,
                                color: _outline, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

                // End Time Row
                InkWell(
                  onTap: _pickEndTime,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            UlvenikIcon(UlvenikIcons.history, color: _outline, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'End Time',
                              style: TextStyle(
                                  color: _stoneGrey, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              _formatTimeOfDay(_endTime),
                              style: const TextStyle(
                                  color: _offWhite, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            const UlvenikIcon(UlvenikIcons.details,
                                color: _outline, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Duration Sub-Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: _surfaceHigh,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
              border: Border(top: _hairlineSide),
            ),
            child: Text(
              'SESSION DURATION: $_durationMinutes min',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionMetricsGrid() {
    // Pair custom metrics in rows of 2
    final List<List<Map<String, String>>> metricRows = [];
    for (int i = 0; i < _recordedCustomMetrics.length; i += 2) {
      if (i + 1 < _recordedCustomMetrics.length) {
        metricRows.add(
            [_recordedCustomMetrics[i], _recordedCustomMetrics[i + 1]]);
      } else {
        metricRows.add([_recordedCustomMetrics[i]]);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'METRICS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              'Activity Custom Metrics',
              style: TextStyle(
                color: _mint,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (int r = 0; r < metricRows.length; r++) ...[
          if (r > 0) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: metricRows[r][0]['name']!,
                  value: metricRows[r][0]['value']!,
                  unit: metricRows[r][0]['unit']!,
                  onTap: () {
                    _showCustomMetricAdjuster(
                      metricRows[r][0]['name']!,
                      metricRows[r][0]['unit']!,
                      metricRows[r][0]['value']!,
                      (val) => setState(() => metricRows[r][0]['value'] = val),
                    );
                  },
                ),
              ),
              if (metricRows[r].length > 1) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    label: metricRows[r][1]['name']!,
                    value: metricRows[r][1]['value']!,
                    unit: metricRows[r][1]['unit']!,
                    onTap: () {
                      _showCustomMetricAdjuster(
                        metricRows[r][1]['name']!,
                        metricRows[r][1]['unit']!,
                        metricRows[r][1]['value']!,
                        (val) =>
                            setState(() => metricRows[r][1]['value'] = val),
                      );
                    },
                  ),
                ),
              ] else ...[
                const SizedBox(width: 8),
                const Expanded(child: SizedBox.shrink()),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildIntensityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Intensity',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _surfaceHigh,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              children: ['Low', 'Med', 'High'].map((opt) {
                final isSelected = _intensity == opt;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _intensity = opt),
                    borderRadius: BorderRadius.circular(9999),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? _forestGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: _forestGreen.withValues(alpha: 0.35),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          opt,
                          style: TextStyle(
                            color: isSelected ? _offWhite : _stoneGrey,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String unit,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(8),
          border: _hairlineBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: _hairlineBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Rate this session',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              final starNum = index + 1;
              final isFilled = _rating >= starNum;
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_rating == starNum) {
                      _rating = starNum - 1;
                    } else {
                      _rating = starNum;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: UlvenikIcon.fromMaterial(
                    isFilled ? Icons.star : Icons.star_border,
                    color: isFilled ? _mint : _outline,
                    size: 24,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    final count = _notesController.text.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(8),
        border: _hairlineBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  UlvenikIcon(UlvenikIcons.edit, size: 16, color: _stoneGrey),
                  SizedBox(width: 6),
                  Text(
                    'Notes',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                '$count/5000',
                style: const TextStyle(color: _stoneGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesController,
            maxLines: 4,
            maxLength: 5000,
            style: const TextStyle(color: _offWhite, fontSize: 14),
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'Add details about performance, mood, or conditions...',
              hintStyle: TextStyle(
                color: _outlineVariant,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.play, color: _mint),
                  title: const Text('Capture with Camera',
                      style: TextStyle(
                          color: _offWhite, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Take a photo using device camera',
                      style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedMedia.add({
                        'url':
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAA6MpFhgm_ya4naDvk30iHXXw0S4bepNDThgPkAckv3Hc-D2AuLO2x49hfQt16v2C11kr-MPg5WEDxWYAzQ65ps64CBmdg52V3AAzvO6PRetWJc4lHen01H0IHsjCVpS8zhVGDDE_0jqFyakfSuhKSaVuDNhZLSwU5r_TWezJSXfa6W0vxXHDNyOoFNYEjDDh1Q2JW3o-1lDsOMSDDel84xZtJffr0D_Z55DYrzL_6G6JB7tJgHu4',
                        'isVideo': false,
                        'source': 'Camera',
                        'caption': 'Captured session photo',
                      });
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    AppSnackbar.show(
                      context,
                      message: 'Photo captured and attached to session',
                      type: SnackbarType.success,
                    );
                  },
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.play, color: _sage),
                  title: const Text('Choose from Library',
                      style: TextStyle(
                          color: _offWhite, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Select existing photo from device library',
                      style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedMedia.add({
                        'url':
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBgTCj489HAbnhTX_kWdzYawL_TLnu7f6kRayI4YE4uuuCL0T_FkF3voiho_bcLD6WYBq_1EG2eEV8OAX1Yp27PvJIHpCc1CTeUBf8T7JymDOALuzvHyllbsnhgc2drthTedkyrqWwfXQ0R8cGNSMe9tcAihlgH_V8QL2ExBQHTrck54DLL97xb7761FyRVutjPpLn4CpyVogRFiOAIK2OrMzejEcBPhvr4g3Gb4_jboqCWfW3J720',
                        'isVideo': false,
                        'source': 'Library',
                        'caption': 'Selected library photo',
                      });
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    AppSnackbar.show(
                      context,
                      message: 'Photo selected from library and attached',
                      type: SnackbarType.success,
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

  void _showAddVideoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Add Video',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.play, color: _mint),
                  title: const Text('Record with Camera',
                      style: TextStyle(
                          color: _offWhite, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Record video clip using device camera',
                      style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedMedia.add({
                        'url':
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDtaD_VcUUqG8-da9mao4g5Tx-yY7TwHuvpIs8oTPw-couiKtMUvFiOihlnRpLeuT60Kk5YKVlj0w90w6O7nTd40bNXIW3OwJ-mrDFMCAzYadO0nStnFMO5TCElw5nKsh3xmiKlU8mZsQPeYwroA-90lrF_aFmfPQ9SQdbs7E61NgTBTPD86AJvCJp2J9SlVhfLR6rhy07LYQSkhrKSAHeJpC4guCiB3-FmRdebiz6xb4qGSZOeZdc',
                        'isVideo': true,
                        'source': 'Camera',
                        'caption': 'Recorded session video clip',
                      });
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    AppSnackbar.show(
                      context,
                      message: 'Video recorded and attached to session',
                      type: SnackbarType.success,
                    );
                  },
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.play, color: _sage),
                  title: const Text('Choose from Library',
                      style: TextStyle(
                          color: _offWhite, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Select existing video from device library',
                      style: TextStyle(color: _stoneGrey, fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _attachedMedia.add({
                        'url':
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDtaD_VcUUqG8-da9mao4g5Tx-yY7TwHuvpIs8oTPw-couiKtMUvFiOihlnRpLeuT60Kk5YKVlj0w90w6O7nTd40bNXIW3OwJ-mrDFMCAzYadO0nStnFMO5TCElw5nKsh3xmiKlU8mZsQPeYwroA-90lrF_aFmfPQ9SQdbs7E61NgTBTPD86AJvCJp2J9SlVhfLR6rhy07LYQSkhrKSAHeJpC4guCiB3-FmRdebiz6xb4qGSZOeZdc',
                        'isVideo': true,
                        'source': 'Library',
                        'caption': 'Selected library video clip',
                      });
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    AppSnackbar.show(
                      context,
                      message: 'Video selected from library and attached',
                      type: SnackbarType.success,
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

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MEDIA',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showAddPhotoSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _carbon,
                  foregroundColor: _mint,
                  elevation: 0,
                  side: _hairlineSide,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const UlvenikIcon(UlvenikIcons.recordSession, size: 18),
                label: const Text('Add Photo',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showAddVideoSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _carbon,
                  foregroundColor: _mint,
                  elevation: 0,
                  side: _hairlineSide,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const UlvenikIcon(UlvenikIcons.play, size: 18),
                label: const Text('Add Video',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3 Media Thumbnails Grid
        Row(
          children: List.generate(3, (index) {
            final hasAttachment = index < _attachedMedia.length;
            final isVid = hasAttachment && _attachedMedia[index]['isVideo'] == true;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 2 ? 8.0 : 0.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasAttachment
                          ? _forestGreen.withValues(alpha: 0.2)
                          : _surfaceHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hasAttachment
                            ? _mint.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.08),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: UlvenikIcon.fromMaterial(
                            hasAttachment
                                ? (isVid
                                    ? Icons.play_circle_outline
                                    : Icons.image)
                                : Icons.image,
                            color: hasAttachment ? _mint : _outlineVariant,
                            size: 26,
                          ),
                        ),
                        if (hasAttachment)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _attachedMedia.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const UlvenikIcon(UlvenikIcons.back,
                                    size: 14, color: _offWhite),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ==========================================
  // WIDGETS: NO ACTIVITY SELECTED STATE
  // ==========================================
  Widget _buildNoActivityCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIVITY',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showActivityPickerSheet,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _forestGreen.withValues(alpha: 0.6),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Dashed Circle with + icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _mint.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: UlvenikIcon(UlvenikIcons.add, color: _mint, size: 22),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select an Activity',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Required to save the session.',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'Browse',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    UlvenikIcon(UlvenikIcons.details, color: _mint, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoActivityDateTimeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DATE & TIME',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(8),
            border: _hairlineBorder,
          ),
          child: Column(
            children: [
              // Row 1: Today
              InkWell(
                onTap: _pickDate,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      UlvenikIcon(UlvenikIcons.calendar, color: _outline, size: 18),
                      SizedBox(width: 12),
                      Text(
                        'Today',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 18),

              // Row 2: 08:00 | 45 min
              InkWell(
                onTap: _pickStartTime,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          UlvenikIcon(UlvenikIcons.trainingTime, color: _outline, size: 18),
                          SizedBox(width: 12),
                          Text(
                            '08:00',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '45 min',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLockedMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'METRICS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              'Select activity to unlock',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: _carbon.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: _hairlineBorder,
          ),
          child: const Column(
            children: [
              UlvenikIcon(UlvenikIcons.sort, color: _outlineVariant, size: 28),
              SizedBox(height: 10),
              Text(
                'Custom Metrics Locked',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Select an activity above to load and record its custom metrics (e.g. Load, Distance, Speed).',
                textAlign: TextAlign.center,
                style: TextStyle(color: _stoneGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLockedRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RATING',
          style: TextStyle(
            color: _stoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(8),
            border: _hairlineBorder,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Performance Rating',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (_) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: UlvenikIcon(UlvenikIcons.goals, color: _outlineVariant, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PINNED BOTTOM ACTION AREA
  // ==========================================
  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: _obsidian,
        border: Border(top: _hairlineSide),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasActivity) ...[
            const Text(
              'Draft saved automatically',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forestGreen,
                  foregroundColor: _offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  shadowColor: _forestGreen.withValues(alpha: 0.35),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UlvenikIcon(UlvenikIcons.completed, size: 20, fontWeight: FontWeight.bold),
                    SizedBox(width: 8),
                    Text(
                      'Save Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    UlvenikIcon(UlvenikIcons.details, size: 20),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Disabled Save Session button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  AppSnackbar.show(
                    context,
                    message: 'Please select an activity first to save this session',
                    type: SnackbarType.warning,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forestGreen.withValues(alpha: 0.35),
                  foregroundColor: _offWhite.withValues(alpha: 0.4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Session',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
