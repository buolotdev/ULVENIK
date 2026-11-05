import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'homework_details_screen.dart';

enum _HomeworkStatus { overdue, inProgress, notStarted, completed }

class _HomeworkAssignment {
  final String id;
  String title;
  List<String> dogs;
  bool isHighPriority;
  int completedTasks;
  int totalTasks;
  bool isCompleted;
  String assignedLabel;
  String dueDateText;
  String? finishedLabel;
  DateTime dueDate;
  String instructions;
  bool isArchived = false;

  _HomeworkAssignment({
    required this.id,
    required this.title,
    required this.dogs,
    this.isHighPriority = false,
    required this.completedTasks,
    required this.totalTasks,
    this.isCompleted = false,
    required this.assignedLabel,
    required this.dueDateText,
    this.finishedLabel,
    required this.dueDate,
    required this.instructions,
  });

  double get progress =>
      totalTasks > 0 ? (completedTasks / totalTasks).clamp(0.0, 1.0) : 0.0;

  _HomeworkStatus effectiveStatus(DateTime todayDateOnly) {
    if (isCompleted || (totalTasks > 0 && completedTasks >= totalTasks)) {
      return _HomeworkStatus.completed;
    }
    final dueOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
    if (dueOnly.isBefore(todayDateOnly)) {
      return _HomeworkStatus.overdue;
    }
    if (completedTasks > 0) {
      return _HomeworkStatus.inProgress;
    }
    return _HomeworkStatus.notStarted;
  }

  String get dueLabel {
    if (isCompleted || (totalTasks > 0 && completedTasks >= totalTasks)) {
      return finishedLabel ?? 'Finished Today';
    }
    return 'Due $dueDateText';
  }
}

class ClientHomeworkScreen extends StatefulWidget {
  const ClientHomeworkScreen({super.key});

  @override
  State<ClientHomeworkScreen> createState() => _ClientHomeworkScreenState();
}

class _ClientHomeworkScreenState extends State<ClientHomeworkScreen> {
  static const Color _bg = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _crimson = Color(0xFF8B3A3A);
  static const Color _crimsonText = Color(0xFFB45A5A);
  static const Color _textPrimary = Color(0xFFF5F6F2);
  static const Color _textSecondary = Color(0xFFA7B0AB);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedChip = 'ACTIVE';
  String _selectedDogFilter = 'ALL';
  String _sortMode = 'Earliest Due';
  bool _showArchived = false;
  String? _openSwipeId;

  final List<String> _chips = const [
    'ACTIVE',
    'COMPLETED',
    'OVERDUE',
    'HIGH PRIORITY',
    'IN PROGRESS',
    'NOT STARTED',
  ];

  final List<String> _sortModes = const [
    'Earliest Due',
    'Highest Priority',
    'Progress %',
    'Recently Assigned',
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  DateTime get _todayDateOnly {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  _HomeworkStatus _statusOf(_HomeworkAssignment item) =>
      item.effectiveStatus(_todayDateOnly);

  String _formatDayMonth(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_shortMonths[d.month - 1]}';

  late final List<_HomeworkAssignment> _assignments = [
    _HomeworkAssignment(
      id: 'hw_1',
      title: 'IGP Scent Pad Precision & Food Steps',
      dogs: ['Murphy', 'Rex'],
      isHighPriority: true,
      completedTasks: 7,
      totalTasks: 20,
      assignedLabel: 'Assigned 12 Nov',
      dueDateText: '17 Nov',
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      instructions:
          'Lay 10×10m scent pad in short damp grass each morning. Reward calm nose-down duration in every footprint before stepping forward.',
    ),
    _HomeworkAssignment(
      id: 'hw_2',
      title: 'Week 4 Focus & Decoy Engagement Reps',
      dogs: ['Murphy'],
      isHighPriority: false,
      completedTasks: 8,
      totalTasks: 12,
      assignedLabel: 'Assigned 14 Nov',
      dueDateText: '22 Nov',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      instructions:
          'Conduct 2× 5-minute neutral pass-bys at 20m threshold. Reward instant check-in eye contact with leather tug release.',
    ),
    _HomeworkAssignment(
      id: 'hw_3',
      title: 'Emergency Recall Signal Calibration (2× Daily)',
      dogs: ['Murphy'],
      isHighPriority: false,
      completedTasks: 0,
      totalTasks: 10,
      assignedLabel: 'Assigned 16 Nov',
      dueDateText: '25 Nov',
      dueDate: DateTime.now().add(const Duration(days: 8)),
      instructions:
          'Pair two-pip Acme whistle blast with high-value jackpot reward indoors first, then on 10m long-line in quiet paddock.',
    ),
    _HomeworkAssignment(
      id: 'hw_4',
      title: 'Baseline A-Frame Descent Pause Work',
      dogs: ['Murphy'],
      isHighPriority: false,
      completedTasks: 10,
      totalTasks: 10,
      isCompleted: true,
      assignedLabel: 'Assigned 05 Nov',
      dueDateText: '11 Nov',
      finishedLabel: 'Finished 11 Nov',
      dueDate: DateTime.now().add(const Duration(days: 12)),
      instructions:
          'Two-on two-off contact target mat rehearsals on flat plank before low A-frame elevation.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _statusBadgeText(_HomeworkStatus status) {
    switch (status) {
      case _HomeworkStatus.overdue:
        return 'OVERDUE';
      case _HomeworkStatus.inProgress:
        return 'IN PROGRESS';
      case _HomeworkStatus.notStarted:
        return 'NOT STARTED';
      case _HomeworkStatus.completed:
        return 'COMPLETED';
    }
  }

  bool get _hasModalFilter => _selectedDogFilter != 'ALL' || _showArchived;

  List<_HomeworkAssignment> get _filteredAssignments {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _assignments.where((item) {
      if (item.isArchived != _showArchived) return false;
      final status = _statusOf(item);

      if (_selectedChip == 'COMPLETED' &&
          status != _HomeworkStatus.completed) {
        return false;
      }
      if (_selectedChip == 'OVERDUE' && status != _HomeworkStatus.overdue) {
        return false;
      }
      if (_selectedChip == 'HIGH PRIORITY' && !item.isHighPriority) {
        return false;
      }
      if (_selectedChip == 'IN PROGRESS' &&
          status != _HomeworkStatus.inProgress) {
        return false;
      }
      if (_selectedChip == 'NOT STARTED' &&
          status != _HomeworkStatus.notStarted) {
        return false;
      }

      if (_selectedDogFilter != 'ALL' &&
          !item.dogs.contains(_selectedDogFilter)) {
        return false;
      }

      if (query.isNotEmpty) {
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesDog =
            item.dogs.any((d) => d.toLowerCase().contains(query));
        final matchesStatus =
            _statusBadgeText(status).toLowerCase().contains(query);
        if (!matchesTitle && !matchesDog && !matchesStatus) {
          return false;
        }
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortMode) {
        case 'Highest Priority':
          if (a.isHighPriority != b.isHighPriority) {
            return a.isHighPriority ? -1 : 1;
          }
          return a.dueDate.compareTo(b.dueDate);
        case 'Progress %':
          return b.progress.compareTo(a.progress);
        case 'Recently Assigned':
          return b.id.compareTo(a.id);
        case 'Earliest Due':
        default:
          return a.dueDate.compareTo(b.dueDate);
      }
    });

    return filtered;
  }

  Future<void> _openHomeworkDetails(_HomeworkAssignment item) async {
    setState(() => _openSwipeId = null);
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => HomeworkDetailsScreen(
          homeworkId: item.id,
          initialTitle: item.title,
          dogNames: List<String>.from(item.dogs),
          initialStatus: _statusBadgeText(_statusOf(item)),
          assignedDate: item.assignedLabel,
          dueDate: item.dueLabel,
          isHighPriority: item.isHighPriority,
          initialProgress: item.progress,
          initialCompletedReps: item.completedTasks,
          totalReps: item.totalTasks,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        final updatedTotal = result['totalReps'];
        if (updatedTotal is int && updatedTotal > 0) {
          item.totalTasks = updatedTotal;
        }
        final updatedCompleted = result['completedReps'];
        if (updatedCompleted is int) {
          item.completedTasks = updatedCompleted.clamp(0, item.totalTasks);
        } else {
          final updatedProgress = result['progress'];
          if (updatedProgress is double) {
            item.completedTasks =
                (updatedProgress.clamp(0.0, 1.0) * item.totalTasks).round();
          }
        }
        final completedFlag = result['completed'];
        if (completedFlag is bool) {
          item.isCompleted = completedFlag;
          if (completedFlag) {
            item.completedTasks = item.totalTasks;
            item.finishedLabel ??= 'Finished Today';
          }
        } else if (item.completedTasks >= item.totalTasks) {
          item.isCompleted = true;
          item.finishedLabel ??= 'Finished Today';
        } else {
          item.isCompleted = false;
        }
        final updatedPriority = result['isHighPriority'];
        if (updatedPriority is bool) {
          item.isHighPriority = updatedPriority;
        }
        final updatedTitle = result['title'];
        if (updatedTitle is String && updatedTitle.trim().isNotEmpty) {
          item.title = updatedTitle.trim();
        }
      });
    }
  }

  Future<void> _archiveOrRestore(_HomeworkAssignment item) async {
    final wasArchived = item.isArchived;
    if (!wasArchived) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: _cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          title: Text(
            'Archive Homework?',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to archive "${item.title}"? You can restore it at any time from Archived Homework.',
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                foregroundColor: _textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              child: Text(
                'Archive',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) {
        if (mounted) {
          setState(() => _openSwipeId = null);
        }
        return;
      }
    }

    setState(() {
      item.isArchived = !item.isArchived;
      _openSwipeId = null;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          wasArchived
              ? 'Restored "${item.title}" to active homework'
              : 'Archived "${item.title}"',
          style: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF5CC09B),
          onPressed: () {
            setState(() {
              item.isArchived = wasArchived;
            });
          },
        ),
      ),
    );
  }

  void _cycleSortMode() {
    final idx = _sortModes.indexOf(_sortMode);
    setState(() {
      _sortMode = _sortModes[(idx + 1) % _sortModes.length];
    });
  }

  void _showFilterAndSortSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter & Sort Homework',
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedChip = 'ACTIVE';
                              _selectedDogFilter = 'ALL';
                              _sortMode = 'Earliest Due';
                              _showArchived = false;
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: Text(
                            'Reset',
                            style: GoogleFonts.inter(
                              color: _forest,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'ASSIGNED DOG',
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['ALL', 'Murphy', 'Rex'].map((dog) {
                        final selected = _selectedDogFilter == dog;
                        return _buildModalChip(
                          label: dog == 'ALL' ? 'All Dogs' : dog,
                          selected: selected,
                          onTap: () {
                            setModalState(() => _selectedDogFilter = dog);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'SORT ORDER',
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortModes.map((mode) {
                        final selected = _sortMode == mode;
                        return _buildModalChip(
                          label: mode,
                          selected: selected,
                          onTap: () {
                            setModalState(() => _sortMode = mode);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Show Archived Homework',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _showArchived,
                      onChanged: (v) {
                        setModalState(() => _showArchived = v);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Apply View',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAssignOrEditHomeworkSheet({_HomeworkAssignment? existing}) {
    final defaultFutureDue = _todayDateOnly.add(const Duration(days: 7));
    DateTime selectedDueDate = existing?.dueDate ?? defaultFutureDue;
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final dueCtrl = TextEditingController(
      text: existing != null
          ? existing.dueDateText
          : _formatDayMonth(defaultFutureDue),
    );
    final instructionsCtrl = TextEditingController(
      text: existing?.instructions ?? '',
    );
    final Set<String> selectedDogs = existing != null
        ? Set<String>.from(existing.dogs)
        : <String>{'Murphy'};
    bool highPriority = existing?.isHighPriority ?? false;
    final int totalTasks = existing?.totalTasks ?? 10;
    int completedTasks = existing?.completedTasks ?? 0;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            final modalProgress = totalTasks > 0
                ? (completedTasks / totalTasks).clamp(0.0, 1.0)
                : 0.0;
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 24 + bottomInset),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existing == null
                              ? 'Assign New Homework'
                              : 'Edit Homework Plan',
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const UlvenikIcon(UlvenikIcons.back, color: _textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _sheetInputDecoration(
                        label: 'Homework Title',
                        hint: 'e.g. Heelwork Automatic Sit Transitions',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'ASSIGN TO DOG(S)',
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Murphy', 'Rex'].map((dog) {
                        final isSelected = selectedDogs.contains(dog);
                        return _buildModalChip(
                          label: dog,
                          selected: isSelected,
                          onTap: () {
                            setModalState(() {
                              if (isSelected && selectedDogs.length > 1) {
                                selectedDogs.remove(dog);
                              } else {
                                selectedDogs.add(dog);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: dueCtrl,
                            readOnly: true,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDueDate,
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  selectedDueDate = picked;
                                  dueCtrl.text = _formatDayMonth(picked);
                                });
                              }
                            },
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 14,
                            ),
                            decoration: _sheetInputDecoration(
                              label: 'Target Due Date',
                              hint: 'e.g. 30 Nov',
                            ).copyWith(
                              suffixIcon: const UlvenikIcon(UlvenikIcons.calendar,
                                size: 16,
                                color: _sage,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() => highPriority = !highPriority);
                            },
                            child: Container(
                              height: 54,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: highPriority
                                    ? _crimson.withValues(alpha: 0.22)
                                    : _bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: highPriority
                                      ? _crimsonText
                                      : Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  UlvenikIcon(UlvenikIcons.notifications,
                                    size: 17,
                                    color: highPriority
                                        ? _crimsonText
                                        : _textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'High Priority',
                                    style: GoogleFonts.inter(
                                      color: highPriority
                                          ? _crimsonText
                                          : _textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (existing != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'HOMEWORK COMPLETION PROGRESS',
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            '$completedTasks / $totalTasks (${(modalProgress * 100).round()}%)',
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Updated by trainer or client based on completed homework tasks — Overdue is set automatically from the due date.',
                        style: GoogleFonts.inter(
                          color: _textSecondary.withValues(alpha: 0.8),
                          fontSize: 11.5,
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: _forest,
                          inactiveTrackColor:
                              Colors.white.withValues(alpha: 0.1),
                          thumbColor: const Color(0xFF5DC49E),
                        ),
                        child: Slider(
                          value: completedTasks.toDouble(),
                          min: 0,
                          max: totalTasks.toDouble(),
                          divisions: totalTasks,
                          onChanged: (v) {
                            setModalState(() {
                              completedTasks = v.round();
                            });
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: instructionsCtrl,
                      maxLines: 3,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 14,
                      ),
                      decoration: _sheetInputDecoration(
                        label: 'Trainer Instructions & Criteria',
                        hint: 'Repetition count, reward marker, threshold...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final rawTitle = titleCtrl.text.trim();
                          final cleanTitle = rawTitle.isEmpty
                              ? 'Structured Impulse & Heelwork Reps'
                              : rawTitle;
                          final cleanDue = dueCtrl.text.trim().isEmpty
                              ? _formatDayMonth(selectedDueDate)
                              : dueCtrl.text.trim();

                          setState(() {
                            if (existing != null) {
                              existing.title = cleanTitle;
                              existing.dogs = selectedDogs.toList();
                              existing.isHighPriority = highPriority;
                              existing.completedTasks = completedTasks;
                              existing.isCompleted =
                                  completedTasks >= existing.totalTasks;
                              if (existing.isCompleted) {
                                existing.finishedLabel ??= 'Finished Today';
                              } else {
                                existing.finishedLabel = null;
                              }
                              existing.dueDate = selectedDueDate;
                              existing.dueDateText = cleanDue;
                              existing.instructions =
                                  instructionsCtrl.text.trim();
                            } else {
                              _assignments.insert(
                                0,
                                _HomeworkAssignment(
                                  id: 'hw_${DateTime.now().millisecondsSinceEpoch}',
                                  title: cleanTitle,
                                  dogs: selectedDogs.toList(),
                                  isHighPriority: highPriority,
                                  completedTasks: 0,
                                  totalTasks: totalTasks,
                                  assignedLabel: 'Assigned Today',
                                  dueDateText: cleanDue,
                                  dueDate: selectedDueDate,
                                  instructions:
                                      instructionsCtrl.text.trim().isEmpty
                                          ? 'Complete daily short sessions and upload 1 clip for review.'
                                          : instructionsCtrl.text.trim(),
                                ),
                              );
                              _selectedChip = 'ACTIVE';
                            }
                            _openSwipeId = null;
                          });

                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: _cardBg,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                existing == null
                                    ? 'Assigned "$cleanTitle" to ${selectedDogs.join(" & ")}'
                                    : 'Updated "$cleanTitle"',
                                style: GoogleFonts.inter(
                                  color: _textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          existing == null
                              ? 'Assign Homework to Client'
                              : 'Save Homework Changes',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _sheetInputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.inter(color: _textSecondary, fontSize: 13),
      hintStyle: GoogleFonts.inter(
        color: _textSecondary.withValues(alpha: 0.55),
        fontSize: 13,
      ),
      filled: true,
      fillColor: _bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _forest),
      ),
    );
  }

  Widget _buildModalChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? _forest.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _forest : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? const Color(0xFF5DC49E) : _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filteredAssignments;

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: _forest,
          elevation: 6,
          shape: const CircleBorder(),
          onPressed: () => _showAssignOrEditHomeworkSheet(),
          child: const UlvenikIcon(UlvenikIcons.add, color: _textPrimary, size: 28),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                  if (_hasModalFilter) ...[
                    const SizedBox(height: 12),
                    _buildActiveFilterBanner(),
                  ],
                  const SizedBox(height: 20),
                  _buildSectionHeader(visible.length),
                  const SizedBox(height: 12),
                  if (visible.isEmpty)
                    _buildEmptyState()
                  else
                    ...visible.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildSwipeableHomeworkCard(item),
                      ),
                    ),
                  const SizedBox(height: 10),
                  _buildSwipeGesturePreview(
                    visible.isNotEmpty ? visible.first : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _textPrimary,
              size: 25,
            ),
          ),
          const Expanded(child: SizedBox()),
          Text(
            'Homework',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _searchFocusNode.requestFocus(),
            icon: const UlvenikIcon(UlvenikIcons.search, color: _sage, size: 22),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _showFilterAndSortSheet,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const UlvenikIcon(UlvenikIcons.sort, color: _sage, size: 22),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _hasModalFilter
                          ? const Color(0xFF5CC09B)
                          : _forest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _showAssignOrEditHomeworkSheet(),
            icon: const UlvenikIcon(UlvenikIcons.add, color: _sage, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search, color: _sage, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.26),
                  width: 0.9,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(
                  color: _textPrimary,
                  fontSize: 14.5,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: 'Search homework...',
                  hintStyle: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 14.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              _searchFocusNode.unfocus();
              setState(() {});
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _chips[index];
          final isSelected = _selectedChip == chip;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedChip == chip && chip != 'ACTIVE') {
                  _selectedChip = 'ACTIVE';
                } else {
                  _selectedChip = chip;
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? _forest.withValues(alpha: 0.16)
                    : _cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? _forest
                      : Colors.white.withValues(alpha: 0.06),
                  width: 1.1,
                ),
              ),
              child: Text(
                chip,
                style: GoogleFonts.inter(
                  color: isSelected ? const Color(0xFF3E8E72) : _textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveFilterBanner() {
    final labels = <String>[];
    if (_selectedDogFilter != 'ALL') labels.add('Dog: $_selectedDogFilter');
    if (_showArchived) labels.add('Archived');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _forest.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _forest.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.sort, color: _sage, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Active view: ${labels.join(' · ')}',
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedDogFilter = 'ALL';
                _showArchived = false;
              });
            },
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                color: const Color(0xFF5CC09B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    final label = _showArchived ? 'ARCHIVED ($count)' : 'HOMEWORK ($count)';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: _textSecondary,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        GestureDetector(
          onTap: _cycleSortMode,
          child: Text(
            'Sort: $_sortMode',
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          const UlvenikIcon(UlvenikIcons.exercises,
              color: _sage, size: 32),
          const SizedBox(height: 10),
          Text(
            'No matching homework items',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Adjust your status pill or search query, or assign a new training plan.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableHomeworkCard(_HomeworkAssignment item) {
    final isSwipedOpen = _openSwipeId == item.id;
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final vx = details.primaryVelocity ?? 0;
        if (vx < -140) {
          setState(() => _openSwipeId = item.id);
        } else if (vx > 140 && isSwipedOpen) {
          setState(() => _openSwipeId = null);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF15191C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildQuickSwipeButton(
                    icon: Icons.visibility_outlined,
                    label: 'VIEW',
                    bgColor: const Color(0xFF282F32),
                    iconColor: _sage,
                    textColor: _textPrimary,
                    onTap: () => _openHomeworkDetails(item),
                  ),
                  _buildQuickSwipeButton(
                    icon: Icons.edit_outlined,
                    label: 'EDIT',
                    bgColor: const Color(0xFF192B24),
                    iconColor: const Color(0xFF3E8E72),
                    textColor: _textPrimary,
                    onTap: () {
                      setState(() => _openSwipeId = null);
                      _showAssignOrEditHomeworkSheet(existing: item);
                    },
                  ),
                  _buildQuickSwipeButton(
                    icon: Icons.inventory_2_outlined,
                    label: item.isArchived ? 'RESTORE' : 'ARCHIVE',
                    bgColor: const Color(0xFF252A2D),
                    iconColor: _textSecondary,
                    textColor: _textSecondary,
                    isRightEnd: true,
                    onTap: () => _archiveOrRestore(item),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSlide(
            duration: const Duration(milliseconds: 210),
            curve: Curves.easeOutCubic,
            offset: isSwipedOpen ? const Offset(-0.52, 0) : Offset.zero,
            child: _buildHomeworkCardContent(item),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCardContent(_HomeworkAssignment item) {
    final status = _statusOf(item);
    final isOverdue = status == _HomeworkStatus.overdue;
    final isCompleted = status == _HomeworkStatus.completed;
    final isNotStarted = status == _HomeworkStatus.notStarted;
    final pct = (item.progress * 100).round();

    Color barColor = _forest;
    if (isCompleted) {
      barColor = _sage;
    }

    Color pctTextColor = _textPrimary;
    if (isCompleted) {
      pctTextColor = _sage;
    } else if (isNotStarted) {
      pctTextColor = _textSecondary;
    }

    Color dueTextColor = _textSecondary;
    if (isOverdue) {
      dueTextColor = _crimsonText;
    } else if (isCompleted) {
      dueTextColor = _sage;
    }

    return GestureDetector(
      onTap: () {
        if (_openSwipeId == item.id) {
          setState(() => _openSwipeId = null);
          return;
        }
        _openHomeworkDetails(item);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              if (isOverdue)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 3.5,
                  child: Container(color: _crimson),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusBadge(status),
                        if (item.isHighPriority) _buildHighPriorityBadge(),
                      ],
                    ),
                    const SizedBox(height: 11),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: item.dogs.map(_buildDogTagPill).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '$pct%',
                          style: GoogleFonts.inter(
                            color: pctTextColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                        height: 4,
                        width: double.infinity,
                        color: Colors.white.withValues(alpha: 0.07),
                        alignment: Alignment.centerLeft,
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey('${item.id}_${_selectedChip}_$_sortMode'),
                          tween: Tween<double>(
                            begin: 0,
                            end: item.progress.clamp(0.0, 1.0),
                          ),
                          duration: const Duration(milliseconds: 520),
                          curve: Curves.easeOutCubic,
                          builder: (context, animVal, _) {
                            return FractionallySizedBox(
                              widthFactor: animVal,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: barColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        Text(
                          item.assignedLabel,
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            '·',
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.dueLabel,
                            style: GoogleFonts.inter(
                              color: dueTextColor,
                              fontSize: 12.5,
                              fontWeight: isOverdue
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        const UlvenikIcon(UlvenikIcons.details,
                          color: _sage,
                          size: 18,
                        ),
                      ],
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

  Widget _buildStatusBadge(_HomeworkStatus status) {
    switch (status) {
      case _HomeworkStatus.overdue:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _crimson.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'OVERDUE',
            style: GoogleFonts.inter(
              color: _crimsonText,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
      case _HomeworkStatus.inProgress:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _forest.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _forest.withValues(alpha: 0.85),
              width: 1,
            ),
          ),
          child: Text(
            'IN PROGRESS',
            style: GoogleFonts.inter(
              color: const Color(0xFF3E8E72),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
      case _HomeworkStatus.notStarted:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'NOT STARTED',
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
      case _HomeworkStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _sage.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'COMPLETED',
            style: GoogleFonts.inter(
              color: _sage,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
    }
  }

  Widget _buildHighPriorityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: _crimson.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'HIGH',
        style: GoogleFonts.inter(
          color: _crimsonText,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDogTagPill(String dogName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const UlvenikIcon(UlvenikIcons.skills,
            size: 12,
            color: _sage,
          ),
          const SizedBox(width: 5),
          Text(
            dogName,
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSwipeButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
    bool isRightEnd = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: isRightEnd
              ? const BorderRadius.horizontal(right: Radius.circular(15))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UlvenikIcon.fromMaterial(icon, color: iconColor, size: 17),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeGesturePreview(_HomeworkAssignment? targetItem) {
    final fallback = _assignments.first;
    final activeTarget = targetItem ?? fallback;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SWIPE GESTURE PREVIEW',
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'swipe left on cards',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Hold & swipe item...',
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 13.5,
                  ),
                ),
              ),
              _buildQuickSwipeButton(
                icon: Icons.visibility_outlined,
                label: 'VIEW',
                bgColor: const Color(0xFF282F32),
                iconColor: _sage,
                textColor: _textPrimary,
                onTap: () => _openHomeworkDetails(activeTarget),
              ),
              _buildQuickSwipeButton(
                icon: Icons.edit_outlined,
                label: 'EDIT',
                bgColor: const Color(0xFF192B24),
                iconColor: const Color(0xFF3E8E72),
                textColor: _textPrimary,
                onTap: () =>
                    _showAssignOrEditHomeworkSheet(existing: activeTarget),
              ),
              _buildQuickSwipeButton(
                icon: Icons.inventory_2_outlined,
                label: activeTarget.isArchived ? 'RESTORE' : 'ARCHIVE',
                bgColor: const Color(0xFF252A2D),
                iconColor: _textSecondary,
                textColor: _textSecondary,
                isRightEnd: true,
                onTap: () => _archiveOrRestore(activeTarget),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
