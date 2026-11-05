import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _NoteCategory { training, behaviour, homework, health }

class _ClientNoteItem {
  final String id;
  String title;
  String body;
  _NoteCategory category;
  String dateLabel;
  String footerLabel;
  bool footerItalic;
  bool isPinned;
  bool isClientVisible;
  bool isArchived;
  int pdfCount;
  int photoCount;
  int videoCount;

  _ClientNoteItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.dateLabel,
    required this.footerLabel,
    this.footerItalic = true,
    this.isPinned = false,
    this.isClientVisible = false,
    this.isArchived = false,
    this.pdfCount = 0,
    this.photoCount = 0,
    this.videoCount = 0,
  });
}

class ClientNotesScreen extends StatefulWidget {
  const ClientNotesScreen({super.key});

  @override
  State<ClientNotesScreen> createState() => _ClientNotesScreenState();
}

class _ClientNotesScreenState extends State<ClientNotesScreen> {
  static const Color _bg = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _textPrimary = Color(0xFFF5F6F2);
  static const Color _textSecondary = Color(0xFFA7B0AB);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedChip = 'ALL';
  String _visibilityFilter = 'ALL'; // ALL, PRIVATE, CLIENT_VISIBLE
  bool _onlyWithAttachments = false;
  bool _showArchived = false;
  String? _openSwipeNoteId;

  final List<String> _chips = const [
    'ALL',
    'PINNED',
    'TRAINING',
    'BEHAVIOUR',
    'HEALTH',
    'HOMEWORK',
  ];

  late final List<_ClientNoteItem> _notes = [
    _ClientNoteItem(
      id: 'n1',
      title: 'IGP Tracking Routine & High Toy Drive',
      body:
          'Murphy shows exceptional scent drive on damp turf. Prefers early morning sessions before field traffic builds. Keep track corners crisp at 90 degrees and reward with leather tug at the final article.',
      category: _NoteCategory.training,
      dateLabel: '14 Nov · 09:32',
      footerLabel: 'Last edited 16 Nov',
      footerItalic: true,
      isPinned: true,
      isClientVisible: true,
      pdfCount: 1,
      photoCount: 2,
    ),
    _ClientNoteItem(
      id: 'n2',
      title: 'Reactivity Assessment with Decoy Handler',
      body:
          'Tested threshold at 25 metres with neutral decoy. Solid engagement and quick recovery to handler heel position within 4 seconds. Continue structured parallel passes at 20m next session.',
      category: _NoteCategory.behaviour,
      dateLabel: '12 Nov · 16:40',
      footerLabel: 'Session 4',
      footerItalic: true,
      isPinned: false,
      isClientVisible: false,
      videoCount: 1,
    ),
    _ClientNoteItem(
      id: 'n3',
      title: 'Week 4 Focus & Engagement Homework',
      body:
          'Emma to conduct 2× 5-minute eye contact reps daily prior to mealtime. No tug play in the living room until release cue is generalised cleanly on first verbal prompt.',
      category: _NoteCategory.homework,
      dateLabel: '08 Nov · 11:15',
      footerLabel: 'Last edited 09 Nov',
      footerItalic: true,
      isPinned: false,
      isClientVisible: true,
    ),
    _ClientNoteItem(
      id: 'n4',
      title: 'Right Hind Leg Stiffness Post-Agility',
      body:
          'Slight hesitation on A-frame descent. Recommended vet palpation before advancing contact obstacle height or tight weave entries next week.',
      category: _NoteCategory.health,
      dateLabel: '02 Nov · 14:20',
      footerLabel: 'Routine log',
      footerItalic: false,
      isPinned: false,
      isClientVisible: true,
    ),
  ];

  late final _ClientNoteItem _previewNote = _ClientNoteItem(
    id: 'preview_oct26',
    title: 'Marker Timing & Calm Crate Entry Baseline',
    body:
        'Baseline evaluation with Emma & Murphy. Verbal marker timing is clean; crate threshold duration reached 90 seconds with door open.',
    category: _NoteCategory.training,
    dateLabel: '26 Oct · 10:15',
    footerLabel: 'Initial consult',
    footerItalic: false,
    isPinned: false,
    isClientVisible: false,
  );

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _categoryLabel(_NoteCategory cat) {
    switch (cat) {
      case _NoteCategory.training:
        return 'TRAINING';
      case _NoteCategory.behaviour:
        return 'BEHAVIOUR';
      case _NoteCategory.homework:
        return 'HOMEWORK';
      case _NoteCategory.health:
        return 'HEALTH';
    }
  }

  IconData _categoryIcon(_NoteCategory cat) {
    switch (cat) {
      case _NoteCategory.training:
        return Icons.assignment_outlined;
      case _NoteCategory.behaviour:
        return Icons.lightbulb_outline;
      case _NoteCategory.homework:
        return Icons.check_circle_outline;
      case _NoteCategory.health:
        return Icons.favorite_border;
    }
  }

  List<_ClientNoteItem> get _filteredNotes {
    final q = _searchController.text.trim().toLowerCase();
    return _notes.where((n) {
      if (n.isArchived != _showArchived) return false;
      if (_selectedChip == 'PINNED' && !n.isPinned) return false;
      if (_selectedChip == 'TRAINING' && n.category != _NoteCategory.training) {
        return false;
      }
      if (_selectedChip == 'BEHAVIOUR' &&
          n.category != _NoteCategory.behaviour) {
        return false;
      }
      if (_selectedChip == 'HEALTH' && n.category != _NoteCategory.health) {
        return false;
      }
      if (_selectedChip == 'HOMEWORK' && n.category != _NoteCategory.homework) {
        return false;
      }
      if (_visibilityFilter == 'PRIVATE' && n.isClientVisible) return false;
      if (_visibilityFilter == 'CLIENT_VISIBLE' && !n.isClientVisible) {
        return false;
      }
      if (_onlyWithAttachments &&
          (n.pdfCount + n.photoCount + n.videoCount) == 0) {
        return false;
      }
      if (q.isNotEmpty) {
        final match = n.title.toLowerCase().contains(q) ||
            n.body.toLowerCase().contains(q) ||
            _categoryLabel(n.category).toLowerCase().contains(q) ||
            n.footerLabel.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  bool get _hasExtraFilter =>
      _visibilityFilter != 'ALL' || _onlyWithAttachments || _showArchived;

  void _togglePin(_ClientNoteItem note) {
    setState(() {
      note.isPinned = !note.isPinned;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          note.isPinned ? 'Pinned "${note.title}"' : 'Unpinned "${note.title}"',
          style: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        ),
      ),
    );
  }

  void _archiveOrRestore(_ClientNoteItem note) {
    setState(() {
      if (note.id == _previewNote.id) {
        final cloned = _ClientNoteItem(
          id: 'oct26_${DateTime.now().millisecondsSinceEpoch}',
          title: note.title,
          body: note.body,
          category: note.category,
          dateLabel: note.dateLabel,
          footerLabel: note.footerLabel,
          isArchived: true,
        );
        _notes.add(cloned);
      } else {
        note.isArchived = !note.isArchived;
      }
      _openSwipeNoteId = null;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          note.isArchived || note.id == _previewNote.id
              ? 'Note archived · Toggle Archived filter to view'
              : 'Note restored to active notes',
          style: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        ),
      ),
    );
  }

  void _showFilterSheet() {
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
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Client Notes',
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _visibilityFilter = 'ALL';
                              _onlyWithAttachments = false;
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
                    const SizedBox(height: 12),
                    Text(
                      'NOTE VISIBILITY',
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
                      children: [
                        _buildModalOptionChip(
                          label: 'All Notes',
                          selected: _visibilityFilter == 'ALL',
                          onTap: () {
                            setModalState(() => _visibilityFilter = 'ALL');
                            setState(() {});
                          },
                        ),
                        _buildModalOptionChip(
                          label: 'Trainer Private Only',
                          selected: _visibilityFilter == 'PRIVATE',
                          onTap: () {
                            setModalState(() => _visibilityFilter = 'PRIVATE');
                            setState(() {});
                          },
                        ),
                        _buildModalOptionChip(
                          label: 'Client-Visible',
                          selected: _visibilityFilter == 'CLIENT_VISIBLE',
                          onTap: () {
                            setModalState(
                                () => _visibilityFilter = 'CLIENT_VISIBLE');
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Has Attachments (PDF / Media)',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _onlyWithAttachments,
                      onChanged: (v) {
                        setModalState(() => _onlyWithAttachments = v);
                        setState(() {});
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Show Archived Notes',
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
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Apply Filters',
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

  Widget _buildModalOptionChip({
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
            color: selected ? const Color(0xFF63B497) : _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showNoteDetailSheet(_ClientNoteItem note) {
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
                        UlvenikIcon.fromMaterial(
                          _categoryIcon(note.category),
                          color: _sage,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _categoryLabel(note.category),
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              note.isClientVisible = !note.isClientVisible;
                            });
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: note.isClientVisible
                                  ? _forest.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: note.isClientVisible
                                    ? _forest
                                    : Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UlvenikIcon.fromMaterial(
                                  note.isClientVisible
                                      ? Icons.visibility_outlined
                                      : Icons.lock_outline,
                                  size: 13,
                                  color: note.isClientVisible
                                      ? const Color(0xFF63B497)
                                      : _textSecondary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  note.isClientVisible
                                      ? 'Client-Visible'
                                      : 'Trainer Private',
                                  style: GoogleFonts.inter(
                                    color: note.isClientVisible
                                        ? const Color(0xFF63B497)
                                        : _textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      note.title,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${note.dateLabel}  ·  ${note.footerLabel}',
                      style: GoogleFonts.inter(
                        color: _sage,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      note.body,
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                    if (note.pdfCount > 0 ||
                        note.photoCount > 0 ||
                        note.videoCount > 0) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (note.pdfCount > 0)
                            _buildAttachmentPill(
                              Icons.description_outlined,
                              '${note.pdfCount} PDF',
                            ),
                          if (note.photoCount > 0)
                            _buildAttachmentPill(
                              Icons.image_outlined,
                              '${note.photoCount} Photos',
                            ),
                          if (note.videoCount > 0)
                            _buildAttachmentPill(
                              Icons.videocam_outlined,
                              '${note.videoCount} Video',
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textPrimary,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _togglePin(note);
                            },
                            icon: UlvenikIcon.fromMaterial(
                              note.isPinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined,
                              size: 16,
                              color: _forest,
                            ),
                            label: Text(
                              note.isPinned ? 'Unpin' : 'Pin Note',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _forest,
                              foregroundColor: _textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _showAddOrEditNoteSheet(existing: note);
                            },
                            icon: const UlvenikIcon(UlvenikIcons.edit, size: 16),
                            label: Text(
                              'Edit Note',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
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
      },
    );
  }

  void _showAddOrEditNoteSheet({_ClientNoteItem? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final bodyCtrl = TextEditingController(text: existing?.body ?? '');
    _NoteCategory cat = existing?.category ?? _NoteCategory.training;
    bool pinned = existing?.isPinned ?? false;
    bool clientVisible = existing?.isClientVisible ?? false;
    int pdfCount = existing?.pdfCount ?? 0;
    int photoCount = existing?.photoCount ?? 0;
    int videoCount = existing?.videoCount ?? 0;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existing == null
                              ? 'New Client Note'
                              : 'Edit Client Note',
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
                    const SizedBox(height: 10),
                    Text(
                      'CATEGORY',
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
                      children: _NoteCategory.values.map((c) {
                        final selected = cat == c;
                        return _buildModalOptionChip(
                          label: _categoryLabel(c),
                          selected: selected,
                          onTap: () => setModalState(() => cat = c),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Note Title',
                        labelStyle: GoogleFonts.inter(color: _textSecondary),
                        filled: true,
                        fillColor: _bg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _forest),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyCtrl,
                      maxLines: 4,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Observation & Handler Notes',
                        alignLabelWithHint: true,
                        labelStyle: GoogleFonts.inter(color: _textSecondary),
                        filled: true,
                        fillColor: _bg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _forest),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildModalOptionChip(
                          label: pdfCount > 0 ? '$pdfCount PDF ✓' : '+ Attach PDF',
                          selected: pdfCount > 0,
                          onTap: () => setModalState(
                            () => pdfCount = pdfCount > 0 ? 0 : 1,
                          ),
                        ),
                        _buildModalOptionChip(
                          label: photoCount > 0
                              ? '$photoCount Photos ✓'
                              : '+ Attach Photo',
                          selected: photoCount > 0,
                          onTap: () => setModalState(
                            () => photoCount = photoCount > 0 ? 0 : 2,
                          ),
                        ),
                        _buildModalOptionChip(
                          label: videoCount > 0
                              ? '$videoCount Video ✓'
                              : '+ Attach Video',
                          selected: videoCount > 0,
                          onTap: () => setModalState(
                            () => videoCount = videoCount > 0 ? 0 : 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Pin to Top of Client Notes',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: pinned,
                      onChanged: (v) => setModalState(() => pinned = v),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Share Visibility with Client (Emma)',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        clientVisible
                            ? 'Visible inside client shared portal'
                            : 'Private trainer clinical/field log only',
                        style: GoogleFonts.inter(
                          color: _sage,
                          fontSize: 12,
                        ),
                      ),
                      value: clientVisible,
                      onChanged: (v) => setModalState(() => clientVisible = v),
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
                          final t = titleCtrl.text.trim();
                          final b = bodyCtrl.text.trim();
                          if (t.isEmpty) return;
                          setState(() {
                            if (existing != null &&
                                existing.id != _previewNote.id) {
                              existing.title = t;
                              existing.body =
                                  b.isEmpty ? 'Updated trainer note.' : b;
                              existing.category = cat;
                              existing.isPinned = pinned;
                              existing.isClientVisible = clientVisible;
                              existing.pdfCount = pdfCount;
                              existing.photoCount = photoCount;
                              existing.videoCount = videoCount;
                              existing.footerLabel = 'Last edited just now';
                              existing.footerItalic = true;
                            } else if (existing != null &&
                                existing.id == _previewNote.id) {
                              _previewNote.title = t;
                              _previewNote.body =
                                  b.isEmpty ? _previewNote.body : b;
                              _previewNote.category = cat;
                            } else {
                              _notes.insert(
                                0,
                                _ClientNoteItem(
                                  id: 'n_${DateTime.now().millisecondsSinceEpoch}',
                                  title: t,
                                  body: b.isEmpty
                                      ? 'Logged during Murphy session review.'
                                      : b,
                                  category: cat,
                                  dateLabel: 'Today · 14:10',
                                  footerLabel: clientVisible
                                      ? 'Shared with client'
                                      : 'Trainer private',
                                  footerItalic: true,
                                  isPinned: pinned,
                                  isClientVisible: clientVisible,
                                  pdfCount: pdfCount,
                                  photoCount: photoCount,
                                  videoCount: videoCount,
                                ),
                              );
                            }
                            _openSwipeNoteId = null;
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          existing == null ? 'Save Client Note' : 'Update Note',
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

  @override
  Widget build(BuildContext context) {
    final visible = _filteredNotes;
    final pinnedNotes = visible.where((n) => n.isPinned).toList();
    final regularNotes = visible.where((n) => !n.isPinned).toList();

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
          onPressed: () => _showAddOrEditNoteSheet(),
          child: const UlvenikIcon(UlvenikIcons.add, color: _textPrimary, size: 28),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                  if (_hasExtraFilter) ...[
                    const SizedBox(height: 12),
                    _buildActiveFilterBanner(),
                  ],
                  if (pinnedNotes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'PINNED',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3E8E72),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...pinnedNotes.map(
                      (note) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildSwipeableNoteCard(note, isPinnedStyle: true),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    _showArchived ? 'ARCHIVED NOTES' : 'NOTES',
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (regularNotes.isEmpty && pinnedNotes.isEmpty)
                    _buildEmptyResultsCard()
                  else
                    ...regularNotes.map(
                      (note) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildSwipeableNoteCard(note, isPinnedStyle: false),
                      ),
                    ),
                  const SizedBox(height: 12),
                  _buildSwipeGesturePreviewSection(),
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
              color: _sage,
              size: 26,
            ),
          ),
          const Expanded(child: SizedBox()),
          Text(
            'Client Notes',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _searchFocusNode.requestFocus(),
            icon: const UlvenikIcon(UlvenikIcons.search, color: _sage, size: 21),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _showFilterSheet,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const UlvenikIcon(UlvenikIcons.sort, color: _sage, size: 21),
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _hasExtraFilter
                          ? const Color(0xFF56C29B)
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
            onPressed: () => _showAddOrEditNoteSheet(),
            icon: const UlvenikIcon(UlvenikIcons.add, color: _sage, size: 23),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.search, color: _sage, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                border: InputBorder.none,
                hintText: 'Search notes...',
                hintStyle: GoogleFonts.inter(
                  color: _textSecondary,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
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
                fontSize: 14,
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
            onTap: () => setState(() => _selectedChip = chip),
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
                  color: isSelected ? const Color(0xFF429679) : _textSecondary,
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
    final parts = <String>[];
    if (_visibilityFilter == 'PRIVATE') parts.add('Private Only');
    if (_visibilityFilter == 'CLIENT_VISIBLE') parts.add('Client-Visible');
    if (_onlyWithAttachments) parts.add('With Media/PDF');
    if (_showArchived) parts.add('Archived');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _forest.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _forest.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.sort, size: 15, color: Color(0xFF56C29B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Active: ${parts.join(' · ')}',
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
                _visibilityFilter = 'ALL';
                _onlyWithAttachments = false;
                _showArchived = false;
              });
            },
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                color: const Color(0xFF56C29B),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableNoteCard(
    _ClientNoteItem note, {
    required bool isPinnedStyle,
  }) {
    final isSwipedOpen = _openSwipeNoteId == note.id;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final vx = details.primaryVelocity ?? 0;
        if (vx < -120) {
          setState(() => _openSwipeNoteId = note.id);
        } else if (vx > 120 && isSwipedOpen) {
          setState(() => _openSwipeNoteId = null);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF252C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildSwipeActionTile(
                    icon: Icons.visibility_outlined,
                    label: 'VIEW',
                    bg: const Color(0xFF333B39),
                    fg: _textSecondary,
                    iconColor: _sage,
                    onTap: () {
                      setState(() => _openSwipeNoteId = null);
                      _showNoteDetailSheet(note);
                    },
                  ),
                  _buildSwipeActionTile(
                    icon: Icons.edit_outlined,
                    label: 'EDIT',
                    bg: const Color(0xFF1B332B),
                    fg: _textPrimary,
                    iconColor: const Color(0xFF429679),
                    isBold: true,
                    onTap: () {
                      setState(() => _openSwipeNoteId = null);
                      _showAddOrEditNoteSheet(existing: note);
                    },
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(15),
                    ),
                    child: _buildSwipeActionTile(
                      icon: Icons.archive_outlined,
                      label: note.isArchived ? 'RESTORE' : 'ARCHIVE',
                      bg: const Color(0xFF2E3536),
                      fg: _textSecondary,
                      iconColor: _textSecondary,
                      onTap: () => _archiveOrRestore(note),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(isSwipedOpen ? -192 : 0, 0, 0),
            child: _buildNoteCardSurface(note, isPinnedStyle: isPinnedStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCardSurface(
    _ClientNoteItem note, {
    required bool isPinnedStyle,
  }) {
    return GestureDetector(
      onTap: () {
        if (_openSwipeNoteId == note.id) {
          setState(() => _openSwipeNoteId = null);
        } else {
          _showNoteDetailSheet(note);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Stack(
            children: [
              if (isPinnedStyle)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3.5,
                    color: _forest,
                  ),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isPinnedStyle ? 18 : 16,
                  15,
                  16,
                  13,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UlvenikIcon.fromMaterial(
                          _categoryIcon(note.category),
                          size: 16,
                          color: _sage,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          _categoryLabel(note.category),
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const Spacer(),
                        if (note.isPinned) ...[
                          GestureDetector(
                            onTap: () => _togglePin(note),
                            child: Transform.rotate(
                              angle: 0.55,
                              child: const UlvenikIcon(UlvenikIcons.skills,
                                size: 14,
                                color: _forest,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                        ],
                        Text(
                          note.dateLabel,
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      note.title,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Divider(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.footerLabel,
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 12,
                              fontStyle: note.footerItalic
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        ),
                        if (note.pdfCount > 0) ...[
                          _buildAttachmentPill(
                            Icons.description_outlined,
                            '${note.pdfCount} PDF',
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (note.photoCount > 0) ...[
                          _buildAttachmentPill(
                            Icons.image_outlined,
                            '${note.photoCount} Photos',
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (note.videoCount > 0) ...[
                          _buildAttachmentPill(
                            Icons.videocam_outlined,
                            '${note.videoCount} Video',
                          ),
                          const SizedBox(width: 6),
                        ],
                        const UlvenikIcon(UlvenikIcons.details,
                          size: 18,
                          color: _sage,
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

  Widget _buildAttachmentPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF23292D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UlvenikIcon.fromMaterial(icon, size: 12, color: _sage),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeGesturePreviewSection() {
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
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Swipe left on cards',
              style: GoogleFonts.inter(
                color: _sage,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showNoteDetailSheet(_previewNote),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '26 Oct',
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildSwipeActionTile(
                  icon: Icons.visibility_outlined,
                  label: 'VIEW',
                  bg: const Color(0xFF333C3A),
                  fg: _textSecondary,
                  iconColor: _sage,
                  onTap: () => _showNoteDetailSheet(_previewNote),
                ),
                _buildSwipeActionTile(
                  icon: Icons.edit_outlined,
                  label: 'EDIT',
                  bg: const Color(0xFF1A332A),
                  fg: _textPrimary,
                  iconColor: const Color(0xFF429679),
                  isBold: true,
                  onTap: () => _showAddOrEditNoteSheet(existing: _previewNote),
                ),
                _buildSwipeActionTile(
                  icon: Icons.archive_outlined,
                  label: 'ARCHIVE',
                  bg: const Color(0xFF2F3637),
                  fg: _textSecondary,
                  iconColor: _textSecondary,
                  onTap: () => _archiveOrRestore(_previewNote),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeActionTile({
    required IconData icon,
    required String label,
    required Color bg,
    required Color fg,
    required Color iconColor,
    bool isBold = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            left: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UlvenikIcon.fromMaterial(icon, size: 17, color: iconColor),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                color: fg,
                fontSize: 10,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResultsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          const UlvenikIcon(UlvenikIcons.training, color: _sage, size: 32),
          const SizedBox(height: 10),
          Text(
            'No matching client notes',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Adjust your category chip, search query, or visibility filter.',
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
}
