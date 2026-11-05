import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _LinkedExerciseItem {
  final String id;
  final String title;
  String badge; // ACTIVE, READY, COMPLETED
  int completedReps;
  final int targetReps;
  String subtitle;
  bool isDone;

  _LinkedExerciseItem({
    required this.id,
    required this.title,
    required this.badge,
    required this.completedReps,
    required this.targetReps,
    required this.subtitle,
    this.isDone = false,
  });
}

class _FeedbackEntry {
  final String initials;
  final String author;
  final String role;
  final String timestamp;
  final String message;

  const _FeedbackEntry({
    required this.initials,
    required this.author,
    required this.role,
    required this.timestamp,
    required this.message,
  });
}

class _SharedNoteEntry {
  final String author;
  final String roleBadge;
  final String timestamp;
  final String body;

  const _SharedNoteEntry({
    required this.author,
    required this.roleBadge,
    required this.timestamp,
    required this.body,
  });
}

class HomeworkDetailsScreen extends StatefulWidget {
  final String homeworkId;
  final String initialTitle;
  final List<String> dogNames;
  final String initialStatus;
  final String assignedDate;
  final String dueDate;
  final bool isHighPriority;
  final double initialProgress;
  final int? initialCompletedReps;
  final int totalReps;

  const HomeworkDetailsScreen({
    super.key,
    this.homeworkId = 'hw_2',
    this.initialTitle = 'Week 4 Focus & Decoy Engagement Reps',
    this.dogNames = const ['Murphy'],
    this.initialStatus = 'IN PROGRESS',
    this.assignedDate = '14 Nov 2024',
    this.dueDate = '22 Nov 2024',
    this.isHighPriority = true,
    this.initialProgress = 8 / 12,
    this.initialCompletedReps,
    this.totalReps = 12,
  });

  @override
  State<HomeworkDetailsScreen> createState() => _HomeworkDetailsScreenState();
}

class _HomeworkDetailsScreenState extends State<HomeworkDetailsScreen> {
  static const Color _bg = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _slateBlue = Color(0xFF5D8FAF);
  static const Color _crimson = Color(0xFF8B3A3A);
  static const Color _crimsonLight = Color(0xFFD88A8A);
  static const Color _textPrimary = Color(0xFFF5F6F2);
  static const Color _textSecondary = Color(0xFFA7B0AB);

  late String _title;
  late String _description;
  late bool _isHighPriority;
  late int _completedReps;
  late final int _totalReps;
  String _lastUpdatedLabel = 'Updated 15 Nov · 14:32';
  String _lastActiveLabel = 'Today';
  String _submissionStatus = 'Reviewing';

  late final List<_LinkedExerciseItem> _exercises;
  late final List<_FeedbackEntry> _feedbackList;
  late final List<_SharedNoteEntry> _sharedNotes;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _isHighPriority = widget.isHighPriority;
    _totalReps = widget.totalReps > 0 ? widget.totalReps : 12;
    _description =
        'Maintain sustained eye contact and focused heelwork through 3 distinct decoy stationary and passing phases. Prioritize immediate disengagement from distractions before issuing secondary forward cues.';

    if (widget.initialCompletedReps != null) {
      _completedReps = widget.initialCompletedReps!.clamp(0, _totalReps);
    } else {
      _completedReps =
          (widget.initialProgress.clamp(0.0, 1.0) * _totalReps).round();
    }

    _exercises = [
      _LinkedExerciseItem(
        id: 'ex_1',
        title: 'Eye Contact Drill (15m)',
        badge: _completedReps >= 12 ? 'COMPLETED' : 'ACTIVE',
        completedReps: _completedReps >= 5 ? 5 : _completedReps,
        targetReps: 7,
        subtitle: '5 attempts logged this week',
        isDone: _completedReps >= 12,
      ),
      _LinkedExerciseItem(
        id: 'ex_2',
        title: 'Neutral Decoy Pass-by',
        badge: _completedReps >= 12 ? 'COMPLETED' : 'READY',
        completedReps: _completedReps > 5 ? (_completedReps - 5) : 0,
        targetReps: 5,
        subtitle: '3 attempts scheduled',
        isDone: _completedReps >= 12,
      ),
    ];

    _feedbackList = [
      const _FeedbackEntry(
        initials: 'SM',
        author: 'Sarah Mitchell',
        role: 'Lead Behaviorist',
        timestamp: 'Yesterday · 16:45',
        message:
            '"Murphy showed significant improvement in handler focus during the second rep. When the decoy accelerates, hold off marking until he offers completely voluntary eye contact."',
      ),
    ];

    _sharedNotes = [
      const _SharedNoteEntry(
        author: 'Emma Johnson',
        roleBadge: 'CLIENT',
        timestamp: '14 Nov · 18:42',
        body:
            'Tended to pull slightly toward the fence line when the distraction dog crossed first, but recovered immediately after the collar touch cue.',
      ),
    ];
  }

  double get _displayProgress {
    if (_totalReps <= 0) return 0.0;
    return (_completedReps / _totalReps).clamp(0.0, 1.0);
  }

  bool get _isComplete => _completedReps >= _totalReps;

  String get _currentStatusText {
    if (_isComplete) return 'COMPLETED';
    if (_completedReps == 0 && widget.initialStatus != 'OVERDUE') {
      return 'NOT STARTED';
    }
    if (widget.initialStatus == 'OVERDUE') return 'OVERDUE';
    return 'IN PROGRESS';
  }

  Map<String, dynamic> _buildReturnPayload() {
    return {
      'progress': _displayProgress,
      'completedReps': _completedReps,
      'totalReps': _totalReps,
      'completed': _isComplete,
      'isHighPriority': _isHighPriority,
      'title': _title,
    };
  }

  void _popWithResult() {
    Navigator.of(context).pop(_buildReturnPayload());
  }

  void _toggleMarkComplete() {
    setState(() {
      if (_isComplete) {
        _completedReps = (_totalReps * 2 / 3).round().clamp(1, _totalReps - 1);
        _exercises[0].isDone = false;
        _exercises[0].badge = 'ACTIVE';
        _exercises[0].subtitle = '5 attempts logged this week';
        _exercises[1].isDone = false;
        _exercises[1].badge = 'READY';
        _exercises[1].subtitle = '3 attempts scheduled';
      } else {
        _completedReps = _totalReps;
        for (final ex in _exercises) {
          ex.isDone = true;
          ex.badge = 'COMPLETED';
          ex.completedReps = ex.targetReps;
          ex.subtitle = '${ex.targetReps} / ${ex.targetReps} reps completed';
        }
      }
      _lastUpdatedLabel = 'Updated Just now';
      _lastActiveLabel = 'Just now';
    });

    final reopenedPct = (_displayProgress * 100).round();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          _isComplete
              ? 'Homework marked 100% Complete!'
              : 'Homework reopened at $reopenedPct% completion ($_completedReps/$_totalReps)',
          style: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        ),
      ),
    );
  }

  void _toggleExerciseDone(_LinkedExerciseItem ex) {
    setState(() {
      ex.isDone = !ex.isDone;
      if (ex.isDone) {
        ex.badge = 'COMPLETED';
        ex.completedReps = ex.targetReps;
        ex.subtitle = '${ex.targetReps} attempts completed';
      } else {
        ex.badge = ex.id == 'ex_1' ? 'ACTIVE' : 'READY';
        ex.completedReps = ex.id == 'ex_1' ? 5 : 3;
        ex.subtitle = ex.id == 'ex_1'
            ? '5 attempts logged this week'
            : '3 attempts scheduled';
      }

      final doneCount = _exercises.where((e) => e.isDone).length;
      if (doneCount == _exercises.length) {
        _completedReps = _totalReps;
      } else if (doneCount == 1) {
        _completedReps = 10;
      } else {
        _completedReps = 8;
      }
      _lastUpdatedLabel = 'Updated Just now';
      _lastActiveLabel = 'Just now';
    });
  }

  void _adjustReps(int delta) {
    setState(() {
      _completedReps = (_completedReps + delta).clamp(0, _totalReps);
      if (_completedReps >= _totalReps) {
        for (final ex in _exercises) {
          ex.isDone = true;
          ex.badge = 'COMPLETED';
        }
      } else {
        _exercises[0].isDone = _completedReps >= 7;
        _exercises[0].badge = _exercises[0].isDone ? 'COMPLETED' : 'ACTIVE';
        _exercises[1].isDone = false;
        _exercises[1].badge = 'READY';
      }
      _lastUpdatedLabel = 'Updated Just now';
      _lastActiveLabel = 'Just now';
    });
  }

  void _showOverflowMenu() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.edit, color: _sage),
                  title: Text(
                    'Edit Homework Instructions',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showEditHomeworkSheet();
                  },
                ),
                ListTile(
                  leading:
                      const UlvenikIcon(UlvenikIcons.recordSession, color: _sage),
                  title: Text(
                    'Add Shared Client / Trainer Note',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showAddSharedNoteSheet();
                  },
                ),
                ListTile(
                  leading: const UlvenikIcon(UlvenikIcons.history, color: _sage),
                  title: Text(
                    'Reset Rep Progress to 0 / 12',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _adjustReps(-_totalReps);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditHomeworkSheet() {
    final titleCtrl = TextEditingController(text: _title);
    final descCtrl = TextEditingController(text: _description);
    bool high = _isHighPriority;

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
                    Text(
                      'Edit Homework Details',
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      style: GoogleFonts.inter(color: _textPrimary, fontSize: 14.5),
                      decoration: _inputDecoration('Homework Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      maxLines: 4,
                      style: GoogleFonts.inter(color: _textPrimary, fontSize: 14),
                      decoration: _inputDecoration('Instructions'),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'High Priority Homework',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: high,
                      onChanged: (v) => setModalState(() => high = v),
                    ),
                    const SizedBox(height: 12),
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
                          setState(() {
                            if (titleCtrl.text.trim().isNotEmpty) {
                              _title = titleCtrl.text.trim();
                            }
                            if (descCtrl.text.trim().isNotEmpty) {
                              _description = descCtrl.text.trim();
                            }
                            _isHighPriority = high;
                            _lastUpdatedLabel = 'Updated Just now';
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          'Save Changes',
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

  void _showExerciseDetailSheet(_LinkedExerciseItem ex) {
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
                      children: [
                        Expanded(
                          child: Text(
                            ex.title,
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _buildExerciseBadge(ex.badge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ex.subtitle,
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Plan Reps',
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 13.5,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  _adjustReps(-1);
                                  setModalState(() {});
                                },
                                icon: const UlvenikIcon(UlvenikIcons.back,
                                  color: _textSecondary,
                                ),
                              ),
                              Text(
                                '$_completedReps / $_totalReps',
                                style: GoogleFonts.inter(
                                  color: _textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  _adjustReps(1);
                                  setModalState(() {});
                                },
                                icon: const UlvenikIcon(UlvenikIcons.add,
                                  color: Color(0xFF5DC49E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ex.isDone
                              ? Colors.white.withValues(alpha: 0.1)
                              : _forest,
                          foregroundColor: _textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _toggleExerciseDone(ex);
                          Navigator.of(ctx).pop();
                        },
                        icon: UlvenikIcon.fromMaterial(
                          ex.isDone ? Icons.undo : Icons.check_rounded,
                          size: 18,
                        ),
                        label: Text(
                          ex.isDone
                              ? 'Mark Drill Incomplete'
                              : 'Complete Drill & Update Progress',
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

  void _showAddFeedbackSheet() {
    final ctrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 24 + bottomInset),
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
              Text(
                'Add Trainer Feedback',
                style: GoogleFonts.inter(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Visible immediately to Emma Johnson in her Client Homework view.',
                style: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: ctrl,
                maxLines: 4,
                autofocus: true,
                style: GoogleFonts.inter(color: _textPrimary, fontSize: 14),
                decoration: _inputDecoration(
                  'Coach feedback on timing, leash handling, or reward placement...',
                ),
              ),
              const SizedBox(height: 16),
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
                    final raw = ctrl.text.trim();
                    if (raw.isEmpty) return;
                    setState(() {
                      _feedbackList.insert(
                        0,
                        _FeedbackEntry(
                          initials: 'SM',
                          author: 'Sarah Mitchell',
                          role: 'Lead Behaviorist',
                          timestamp: 'Just now',
                          message: '"$raw"',
                        ),
                      );
                      _submissionStatus = 'Approved';
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Post Trainer Feedback',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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

  void _showAddSharedNoteSheet() {
    final ctrl = TextEditingController();
    String authorRole = 'CLIENT';

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
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 24 + bottomInset),
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
                  Text(
                    'Add Shared Note',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['CLIENT', 'TRAINER'].map((role) {
                      final selected = authorRole == role;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setModalState(() => authorRole = role),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? _forest
                                    : Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Text(
                              role == 'CLIENT'
                                  ? 'Log as Client Note'
                                  : 'Log as Trainer Note',
                              style: GoogleFonts.inter(
                                color: selected
                                    ? const Color(0xFF5DC49E)
                                    : _textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: ctrl,
                    maxLines: 3,
                    style: GoogleFonts.inter(color: _textPrimary, fontSize: 14),
                    decoration: _inputDecoration(
                      'Add field observation or handler note...',
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        final raw = ctrl.text.trim();
                        if (raw.isEmpty) return;
                        setState(() {
                          _sharedNotes.insert(
                            0,
                            _SharedNoteEntry(
                              author: authorRole == 'CLIENT'
                                  ? 'Emma Johnson'
                                  : 'Sarah Mitchell',
                              roleBadge: authorRole,
                              timestamp: 'Just now',
                              body: raw,
                            ),
                          );
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        'Save Shared Note',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPreviewSheet({
    required String title,
    required String subtitle,
    required String body,
    required IconData icon,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
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
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: UlvenikIcon.fromMaterial(icon, color: _sage, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 13.5,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Done',
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
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        color: _textSecondary.withValues(alpha: 0.6),
        fontSize: 13.5,
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

  @override
  Widget build(BuildContext context) {
    return PopScope<Map<String, dynamic>>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _popWithResult();
      },
      child: Scaffold(
        backgroundColor: _bg,
        bottomNavigationBar:
            const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
                  children: [
                    _buildSectionLabel('HOMEWORK'),
                    const SizedBox(height: 10),
                    _buildHomeworkOverviewCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('PROGRESS'),
                    const SizedBox(height: 10),
                    _buildProgressCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('LINKED SKILLS'),
                    const SizedBox(height: 10),
                    _buildLinkedSkillsCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('LINKED EXERCISES'),
                    const SizedBox(height: 10),
                    ..._exercises.map(
                      (ex) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildExerciseCard(ex),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('CLIENT SUBMISSIONS (2)'),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_submissionStatus == 'Reviewing') {
                                _submissionStatus = 'Approved';
                              } else if (_submissionStatus == 'Approved') {
                                _submissionStatus = 'Needs Redo';
                              } else {
                                _submissionStatus = 'Reviewing';
                              }
                            });
                          },
                          child: Text(
                            _submissionStatus,
                            style: GoogleFonts.inter(
                              color: _sage,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildSubmissionCard(
                      isVideo: true,
                      durationLabel: '01:24',
                      title: 'Morning Decoy Pass Practice',
                      subtitle: 'Submitted Today · 09:15 AM',
                      onTap: () => _showPreviewSheet(
                        title: 'Morning Decoy Pass Practice',
                        subtitle: 'Video Clip · 01:24 · Submitted Today 09:15 AM',
                        body:
                            'Emma completed 3 neutral passes at 18m. Murphy held steady loose-leash position on passes 2 and 3 with rapid voluntary eye-contact check-ins.',
                        icon: Icons.play_circle_outline,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSubmissionCard(
                      isVideo: false,
                      title: "Emma's Quick Field Note",
                      subtitle: 'Logged 14 Nov · 18:40',
                      onTap: () => _showPreviewSheet(
                        title: "Emma's Quick Field Note",
                        subtitle: 'Client Log · 14 Nov · 18:40',
                        body:
                            'Windy conditions on north paddock. Switched from kibble to freeze-dried tripe for higher marker value during stationary decoy phase.',
                        icon: Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildSectionLabel('TRAINER FEEDBACK'),
                    const SizedBox(height: 10),
                    _buildTrainerFeedbackCard(),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('NOTES (SHARED NOTE)'),
                        GestureDetector(
                          onTap: _showAddSharedNoteSheet,
                          child: Text(
                            '+ Add Note',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF429679),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ..._sharedNotes.map(
                      (note) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildSharedNoteCard(note),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSectionLabel('ATTACHMENTS (2)'),
                    const SizedBox(height: 10),
                    _buildAttachmentsGrid(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _popWithResult,
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _textPrimary,
              size: 26,
            ),
          ),
          Expanded(
            child: Text(
              _title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
          IconButton(
            onPressed: _showOverflowMenu,
            icon: const UlvenikIcon(UlvenikIcons.overflowMenu,
              color: _textSecondary,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: const Color(0xFF367D65),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildHomeworkOverviewCard() {
    final cleanAssigned = widget.assignedDate.replaceFirst('Assigned ', '');
    final cleanDue = widget.dueDate
        .replaceFirst('Due ', '')
        .replaceFirst('Finished ', '');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatusPill(_currentStatusText),
              if (_isHighPriority) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: _crimson.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _crimson.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'HIGH',
                    style: GoogleFonts.inter(
                      color: _crimsonLight,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _title,
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _description,
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: Colors.white.withValues(alpha: 0.06),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetaItem(
                  label: 'ASSIGNED DATE',
                  value: cleanAssigned.contains('2024')
                      ? cleanAssigned
                      : '$cleanAssigned 2024',
                ),
              ),
              Expanded(
                child: _buildMetaItem(
                  label: 'DUE DATE',
                  value: cleanDue.contains('2024') || cleanDue == 'Today'
                      ? cleanDue
                      : '$cleanDue 2024',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMetaItem(
                  label: 'ASSIGNED BY',
                  value: 'Sarah Mitchell',
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSIGNED DOG',
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.dogNames.map((dog) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const UlvenikIcon(UlvenikIcons.dogs, size: 12, color: _sage),
                              const SizedBox(width: 6),
                              Text(
                                dog,
                                style: GoogleFonts.inter(
                                  color: _textPrimary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isComplete
                    ? const Color(0xFF24332E)
                    : _forest,
                foregroundColor: _textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: _isComplete
                      ? const BorderSide(color: _forest)
                      : BorderSide.none,
                ),
              ),
              onPressed: _toggleMarkComplete,
              icon: UlvenikIcon.fromMaterial(
                _isComplete ? Icons.replay_rounded : Icons.check_rounded,
                size: 18,
              ),
              label: Text(
                _isComplete ? 'Completed · Tap to Reopen' : 'Mark as Complete',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    final isOverdue = status == 'OVERDUE';
    final isComplete = status == 'COMPLETED';
    final borderColor = isOverdue
        ? _crimson.withValues(alpha: 0.65)
        : (isComplete ? _sage : _forest);
    final bgColor = isOverdue
        ? _crimson.withValues(alpha: 0.2)
        : (isComplete
            ? _sage.withValues(alpha: 0.16)
            : _forest.withValues(alpha: 0.16));
    final textColor = isOverdue
        ? _crimsonLight
        : (isComplete ? _sage : const Color(0xFF429679));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMetaItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: _textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.inter(
            color: _textPrimary,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    final remaining = (_totalReps - _completedReps).clamp(0, _totalReps);
    final targetPct = _displayProgress;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetPct),
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutCubic,
            builder: (context, val, _) {
              return Text(
                '${(val * 100).round()}%',
                style: GoogleFonts.inter(
                  color: _textPrimary,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.0,
                  height: 1.05,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            'Overall Completion',
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTapUp: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                _adjustReps(_completedReps < _totalReps ? 1 : -4);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 6,
                width: double.infinity,
                color: _bg,
                alignment: Alignment.centerLeft,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: targetPct),
                  duration: const Duration(milliseconds: 520),
                  curve: Curves.easeOutCubic,
                  builder: (context, val, _) {
                    return FractionallySizedBox(
                      widthFactor: val,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: _forest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _adjustReps(1),
                      child: Column(
                        children: [
                          Text(
                            '$_completedReps / $_totalReps',
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completed',
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _adjustReps(-1),
                      child: Column(
                        children: [
                          Text(
                            '$remaining reps',
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Remaining',
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _lastActiveLabel,
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last Active',
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
          const SizedBox(height: 12),
          Text(
            _lastUpdatedLabel,
            style: GoogleFonts.inter(
              color: _textSecondary.withValues(alpha: 0.8),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedSkillsCard() {
    final skillHomeworkProgress = _displayProgress;
    final homeworkProgressLabel =
        '$_completedReps of $_totalReps homework reps completed';
    return GestureDetector(
      onTap: () => _showPreviewSheet(
        title: 'Decoy Focus & Steady Drive',
        subtitle: 'Linked Skill',
        body:
            'Linked to this homework assignment ($homeworkProgressLabel). Completion is updated by the trainer or client based on assigned homework reps.',
        icon: Icons.psychology_outlined,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: const UlvenikIcon(UlvenikIcons.training,
                color: _sage,
                size: 20,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Decoy Focus & Steady Drive',
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    homeworkProgressLabel,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      height: 4,
                      width: double.infinity,
                      color: _bg,
                      alignment: Alignment.centerLeft,
                      child: TweenAnimationBuilder<double>(
                        tween:
                            Tween<double>(begin: 0, end: skillHomeworkProgress),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, val, _) {
                          return FractionallySizedBox(
                            widthFactor: val,
                            child: Container(
                              height: 4,
                              color: _forest,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const UlvenikIcon(UlvenikIcons.details, color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(_LinkedExerciseItem ex) {
    return GestureDetector(
      onTap: () => _showExerciseDetailSheet(ex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ex.isDone
                ? _forest.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _toggleExerciseDone(ex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: ex.isDone ? _forest : _bg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ex.isDone
                        ? _forest
                        : Colors.white.withValues(alpha: 0.22),
                    width: 1.5,
                  ),
                ),
                child: ex.isDone
                    ? const UlvenikIcon(UlvenikIcons.completed, size: 14, color: _textPrimary)
                    : null,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          ex.title,
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildExerciseBadge(ex.badge),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ex.subtitle,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details, color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseBadge(String badge) {
    Color border;
    Color fill;
    Color text;
    if (badge == 'READY') {
      border = _slateBlue.withValues(alpha: 0.55);
      fill = _slateBlue.withValues(alpha: 0.15);
      text = _slateBlue;
    } else if (badge == 'COMPLETED') {
      border = _sage.withValues(alpha: 0.6);
      fill = _sage.withValues(alpha: 0.16);
      text = _sage;
    } else {
      border = _forest.withValues(alpha: 0.65);
      fill = _forest.withValues(alpha: 0.16);
      text = const Color(0xFF429679);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: border),
      ),
      child: Text(
        badge,
        style: GoogleFonts.inter(
          color: text,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubmissionCard({
    required bool isVideo,
    String? durationLabel,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: isVideo
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const UlvenikIcon(UlvenikIcons.play,
                          color: _sage,
                          size: 20,
                        ),
                        if (durationLabel != null)
                          Text(
                            durationLabel,
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    )
                  : const UlvenikIcon(UlvenikIcons.training,
                      color: _sage,
                      size: 20,
                    ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const UlvenikIcon(UlvenikIcons.details, color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerFeedbackCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 3.5,
              child: Container(color: _forest),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _feedbackList.length; i++) ...[
                    if (i > 0) ...[
                      const SizedBox(height: 14),
                      Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      const SizedBox(height: 14),
                    ],
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _forest.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _forest.withValues(alpha: 0.65),
                            ),
                          ),
                          child: Text(
                            _feedbackList[i].initials,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF429679),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _feedbackList[i].author,
                                style: GoogleFonts.inter(
                                  color: _textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _feedbackList[i].role,
                                style: GoogleFonts.inter(
                                  color: _textSecondary,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _feedbackList[i].timestamp,
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _feedbackList[i].message,
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _showAddFeedbackSheet,
                      icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
                      label: Text(
                        'Add Feedback',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedNoteCard(_SharedNoteEntry note) {
    return GestureDetector(
      onTap: _showAddSharedNoteSheet,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  note.author,
                  style: GoogleFonts.inter(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Text(
                    note.roleBadge,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  note.timestamp,
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              note.body,
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsGrid() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showPreviewSheet(
              title: 'DecoyPass.mp4',
              subtitle: 'MP4 Video · 24.5 MB · 01:24',
              body:
                  'Reference trainer demonstration video showing threshold spacing (15m–20m), leash slack handling, and calm verbal marker timing.',
              icon: Icons.videocam_outlined,
            ),
            child: Container(
              height: 112,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const UlvenikIcon(UlvenikIcons.play,
                          color: _sage,
                          size: 17,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '01:24',
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DecoyPass.mp4',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '24.5 MB',
                        style: GoogleFonts.inter(
                          color: _textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => _showPreviewSheet(
              title: 'Protocol.pdf',
              subtitle: 'PDF Document · 1.2 MB · 3 Pages',
              body:
                  'Step-by-step Week 4 Focus & Decoy Engagement written protocol: warm-up focus cues, distance progression chart, and emergency U-turn reset rules.',
              icon: Icons.picture_as_pdf_outlined,
            ),
            child: Container(
              height: 112,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const UlvenikIcon(UlvenikIcons.training,
                      color: _sage,
                      size: 16,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protocol.pdf',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '1.2 MB',
                        style: GoogleFonts.inter(
                          color: _textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
