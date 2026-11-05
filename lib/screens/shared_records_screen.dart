import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _RecordType { training, health, media, reports, goals }

enum _ShareState { active, pending, expired }

class _SharedRecordItem {
  final String id;
  final _RecordType type;
  String typeLabel;
  String title;
  String dogLabel;
  _ShareState shareState;
  String permissionLevel; // FULL ACCESS, VIEW ONLY, COMMENT, EDIT
  String dateMeta;
  String sharedBy;
  String summary;

  _SharedRecordItem({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.title,
    required this.dogLabel,
    required this.shareState,
    required this.permissionLevel,
    required this.dateMeta,
    required this.sharedBy,
    required this.summary,
  });
}

class _SharingHistoryEntry {
  final String title;
  final String subtitle;
  final String timestamp;

  const _SharingHistoryEntry({
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });
}

class SharedRecordsScreen extends StatefulWidget {
  const SharedRecordsScreen({super.key});

  @override
  State<SharedRecordsScreen> createState() => _SharedRecordsScreenState();
}

class _SharedRecordsScreenState extends State<SharedRecordsScreen> {
  static const Color _bg = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _crimson = Color(0xFF8B3A3A);
  static const Color _coralText = Color(0xFFFFB4AB);
  static const Color _textPrimary = Color(0xFFF5F6F2);
  static const Color _textSecondary = Color(0xFFA7B0AB);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedChip = 'ALL';
  String _ownerFilter = 'ALL'; // ALL, YOU, CLIENT
  bool _activeOnly = false;
  String? _openSwipeId;

  final List<String> _chips = const [
    'ALL',
    'TRAINING',
    'HEALTH',
    'GOALS',
    'REPORTS',
    'MEDIA',
  ];

  final List<String> _permOptions = const [
    'FULL ACCESS',
    'EDIT',
    'COMMENT',
    'VIEW ONLY',
  ];

  late final List<_SharedRecordItem> _records = [
    _SharedRecordItem(
      id: 'sr_1',
      type: _RecordType.training,
      typeLabel: 'TRAINING SESSION',
      title: 'Week 4 Focus & Decoy Engagement',
      dogLabel: 'Murphy',
      shareState: _ShareState.active,
      permissionLevel: 'FULL ACCESS',
      dateMeta: 'Shared 14 Nov',
      sharedBy: 'Shared by You',
      summary:
          'Structured 45-minute IGP decoy threshold session log including 3 neutral pass intervals, marker timing splits, and handler notes.',
    ),
    _SharedRecordItem(
      id: 'sr_2',
      type: _RecordType.health,
      typeLabel: 'HEALTH RECORD',
      title: 'Post-Agility Stifle Palpation & Recovery',
      dogLabel: 'Murphy',
      shareState: _ShareState.active,
      permissionLevel: 'VIEW ONLY',
      dateMeta: 'Shared 12 Nov',
      sharedBy: 'Shared by Client',
      summary:
          'Veterinary physiotherapy clearance note confirming symmetrical right hind-limb extension prior to A-frame progression.',
    ),
    _SharedRecordItem(
      id: 'sr_3',
      type: _RecordType.media,
      typeLabel: 'VIDEO ANALYSIS',
      title: 'Morning Decoy Pass & Bite Threshold',
      dogLabel: 'Murphy',
      shareState: _ShareState.active,
      permissionLevel: 'COMMENT',
      dateMeta: 'Shared 10 Nov',
      sharedBy: 'Shared by Client',
      summary:
          'Annotated 1080p field clip (01:24) with frame-accurate timestamps at 00:28 and 00:54 highlighting loose-leash recovery.',
    ),
    _SharedRecordItem(
      id: 'sr_4',
      type: _RecordType.reports,
      typeLabel: 'PROGRESS REPORT',
      title: 'Q4 IGP Tracking & Drive Assessment',
      dogLabel: 'Rex & Murphy',
      shareState: _ShareState.pending,
      permissionLevel: 'EDIT',
      dateMeta: 'Invited 08 Nov',
      sharedBy: 'Shared by You',
      summary:
          'Quarterly scent-pad accuracy, corner precision, and article indication benchmark report awaiting client co-sign.',
    ),
    _SharedRecordItem(
      id: 'sr_5',
      type: _RecordType.goals,
      typeLabel: 'GOAL TARGET',
      title: 'Complete 20 Neutral Decoy Passes Under 15m',
      dogLabel: 'Murphy',
      shareState: _ShareState.expired,
      permissionLevel: 'VIEW ONLY',
      dateMeta: 'Expired 01 Nov',
      sharedBy: 'Shared by You',
      summary:
          '30-day reactivity milestone target completed at 20/20 clean passes. Share link auto-expired on 01 Nov.',
    ),
  ];

  late final List<_SharingHistoryEntry> _history = [
    const _SharingHistoryEntry(
      title: 'Record Shared',
      subtitle: 'Sarah Mitchell shared Week 4 Training Plan',
      timestamp: '14 Nov · 09:32',
    ),
    const _SharingHistoryEntry(
      title: 'Permission Changed',
      subtitle: 'Updated Stifle Health Record to View Only',
      timestamp: '12 Nov · 14:15',
    ),
    const _SharingHistoryEntry(
      title: 'Invitation Accepted',
      subtitle: 'Emma Johnson accepted access to Decoy Video',
      timestamp: '10 Nov · 11:20',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  IconData _recordIcon(_RecordType type) {
    switch (type) {
      case _RecordType.training:
        return Icons.assignment_outlined;
      case _RecordType.health:
        return Icons.favorite_border;
      case _RecordType.media:
        return Icons.videocam_outlined;
      case _RecordType.reports:
        return Icons.description_outlined;
      case _RecordType.goals:
        return Icons.track_changes_outlined;
    }
  }

  bool get _hasExtraFilter => _ownerFilter != 'ALL' || _activeOnly;

  List<_SharedRecordItem> get _filteredRecords {
    final q = _searchController.text.trim().toLowerCase();
    return _records.where((r) {
      if (_selectedChip == 'TRAINING' && r.type != _RecordType.training) {
        return false;
      }
      if (_selectedChip == 'HEALTH' && r.type != _RecordType.health) {
        return false;
      }
      if (_selectedChip == 'GOALS' && r.type != _RecordType.goals) {
        return false;
      }
      if (_selectedChip == 'REPORTS' && r.type != _RecordType.reports) {
        return false;
      }
      if (_selectedChip == 'MEDIA' && r.type != _RecordType.media) {
        return false;
      }
      if (_activeOnly && r.shareState != _ShareState.active) {
        return false;
      }
      if (_ownerFilter == 'YOU' && r.sharedBy != 'Shared by You') {
        return false;
      }
      if (_ownerFilter == 'CLIENT' && r.sharedBy != 'Shared by Client') {
        return false;
      }
      if (q.isNotEmpty) {
        final match = r.title.toLowerCase().contains(q) ||
            r.typeLabel.toLowerCase().contains(q) ||
            (r.type == _RecordType.training &&
                'training sessions'.contains(q)) ||
            r.dogLabel.toLowerCase().contains(q) ||
            r.permissionLevel.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _toggleShareAccess(_SharedRecordItem item) {
    final wasActive = item.shareState == _ShareState.active;
    setState(() {
      if (wasActive) {
        item.shareState = _ShareState.expired;
        item.dateMeta = 'Revoked Today';
        _history.insert(
          0,
          _SharingHistoryEntry(
            title: 'Sharing Stopped',
            subtitle: 'Revoked client access to ${item.title}',
            timestamp: 'Just now',
          ),
        );
      } else {
        item.shareState = _ShareState.active;
        item.dateMeta = 'Shared Today';
        _history.insert(
          0,
          _SharingHistoryEntry(
            title: 'Access Restored',
            subtitle: 'Re-enabled ${item.permissionLevel} on ${item.title}',
            timestamp: 'Just now',
          ),
        );
      }
      _openSwipeId = null;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          wasActive
              ? 'Stopped sharing "${item.title}"'
              : 'Re-shared "${item.title}" with Emma Johnson',
          style: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        ),
      ),
    );
  }

  void _showRecordPreviewAndPermsSheet(_SharedRecordItem item) {
    setState(() => _openSwipeId = null);
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
            final isShared = item.shareState == _ShareState.active;
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
                        UlvenikIcon.fromMaterial(_recordIcon(item.type), color: _sage, size: 17),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            item.typeLabel,
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        _buildStateBadge(item.shareState),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.dogLabel}  ·  ${item.dateMeta}  ·  ${item.sharedBy}',
                      style: GoogleFonts.inter(
                        color: _sage,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      item.summary,
                      style: GoogleFonts.inter(
                        color: _textSecondary,
                        fontSize: 13.5,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'ACCESS PERMISSION LEVEL',
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
                      children: _permOptions.map((perm) {
                        final selected = item.permissionLevel == perm;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => item.permissionLevel = perm);
                            setState(() {
                              _history.insert(
                                0,
                                _SharingHistoryEntry(
                                  title: 'Permission Changed',
                                  subtitle:
                                      'Updated ${item.title} to $perm',
                                  timestamp: 'Just now',
                                ),
                              );
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? _forest
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              perm,
                              style: GoogleFonts.inter(
                                color: selected ? _mint : _textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Actively Shared with Emma Johnson',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        isShared
                            ? 'Client can currently view this record in portal'
                            : 'Access revoked or expired',
                        style: GoogleFonts.inter(
                          color: _textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      value: isShared,
                      onChanged: (_) {
                        _toggleShareAccess(item);
                        setModalState(() {});
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
      },
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Shared Records',
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _ownerFilter = 'ALL';
                              _activeOnly = false;
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: Text(
                            'Reset',
                            style: GoogleFonts.inter(
                              color: _mint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'SHARED DIRECTION',
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
                        ('ALL', 'All Shared'),
                        ('YOU', 'Shared by You'),
                        ('CLIENT', 'Shared by Client'),
                      ].map((pair) {
                        final selected = _ownerFilter == pair.$1;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => _ownerFilter = pair.$1);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? _forest
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              pair.$2,
                              style: GoogleFonts.inter(
                                color: selected ? _mint : _textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: _forest,
                      title: Text(
                        'Show Active Access Only',
                        style: GoogleFonts.inter(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: _activeOnly,
                      onChanged: (v) {
                        setModalState(() => _activeOnly = v);
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
                          'Apply Filter',
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

  void _showShareNewRecordSheet() {
    final titleCtrl = TextEditingController();
    _RecordType selectedType = _RecordType.training;
    String selectedPerm = 'VIEW ONLY';
    String selectedDog = 'Murphy';

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
                      'Share Record with Emma Johnson',
                      style: GoogleFonts.inter(
                        color: _textPrimary,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleCtrl,
                      style: GoogleFonts.inter(color: _textPrimary, fontSize: 14.5),
                      decoration: InputDecoration(
                        labelText: 'Record Title',
                        hintText: 'e.g. Week 5 Long-Line Recall Video',
                        labelStyle: GoogleFonts.inter(color: _textSecondary),
                        hintStyle: GoogleFonts.inter(
                          color: _textSecondary.withValues(alpha: 0.55),
                        ),
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
                    Text(
                      'RECORD TYPE',
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
                      children: [
                        (_RecordType.training, 'TRAINING SESSION'),
                        (_RecordType.health, 'HEALTH RECORD'),
                        (_RecordType.media, 'VIDEO ANALYSIS'),
                        (_RecordType.reports, 'PROGRESS REPORT'),
                        (_RecordType.goals, 'GOAL TARGET'),
                      ].map((pair) {
                        final selected = selectedType == pair.$1;
                        return GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedType = pair.$1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _forest.withValues(alpha: 0.22)
                                  : _bg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? _forest
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              pair.$2,
                              style: GoogleFonts.inter(
                                color: selected ? _mint : _textSecondary,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedDog,
                            dropdownColor: _cardBg,
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 13.5,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Dog',
                              labelStyle:
                                  GoogleFonts.inter(color: _textSecondary),
                              filled: true,
                              fillColor: _bg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: ['Murphy', 'Rex', 'Rex & Murphy']
                                .map(
                                  (d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setModalState(() => selectedDog = v);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedPerm,
                            dropdownColor: _cardBg,
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 13.5,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Access',
                              labelStyle:
                                  GoogleFonts.inter(color: _textSecondary),
                              filled: true,
                              fillColor: _bg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _permOptions
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setModalState(() => selectedPerm = v);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
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
                          final raw = titleCtrl.text.trim();
                          final clean = raw.isEmpty
                              ? 'Week 5 Whistle Recall Field Assessment'
                              : raw;
                          final typeMap = {
                            _RecordType.training: 'TRAINING SESSION',
                            _RecordType.health: 'HEALTH RECORD',
                            _RecordType.media: 'VIDEO ANALYSIS',
                            _RecordType.reports: 'PROGRESS REPORT',
                            _RecordType.goals: 'GOAL TARGET',
                          };
                          setState(() {
                            _records.insert(
                              0,
                              _SharedRecordItem(
                                id: 'sr_${DateTime.now().millisecondsSinceEpoch}',
                                type: selectedType,
                                typeLabel: typeMap[selectedType]!,
                                title: clean,
                                dogLabel: selectedDog,
                                shareState: _ShareState.active,
                                permissionLevel: selectedPerm,
                                dateMeta: 'Shared Today',
                                sharedBy: 'Shared by You',
                                summary:
                                    'Shared directly from Trainer Workspace with $selectedPerm client portal permissions.',
                              ),
                            );
                            _history.insert(
                              0,
                              _SharingHistoryEntry(
                                title: 'Record Shared',
                                subtitle: 'Sarah Mitchell shared $clean',
                                timestamp: 'Just now',
                              ),
                            );
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          'Share Record Now',
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

  void _showGenerateSharedReportSheet() {
    final activeShared =
        _records.where((r) => r.shareState == _ShareState.active).toList();
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
                Text(
                  'Consolidated Shared Report',
                  style: GoogleFonts.inter(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Includes ${activeShared.length} currently active shared records for Emma Johnson (${activeShared.map((e) => e.dogLabel).toSet().join(", ")}).',
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                ...activeShared.take(4).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Row(
                        children: [
                          UlvenikIcon.fromMaterial(_recordIcon(item.type), color: _sage, size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: _textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            item.permissionLevel,
                            style: GoogleFonts.inter(
                              color: _mint,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: _cardBg,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Generated PDF packet with ${activeShared.length} shared records for Emma Johnson.',
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const UlvenikIcon(UlvenikIcons.training, size: 18),
                    label: Text(
                      'Export & Send Consolidated PDF',
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

  void _showFullHistorySheet() {
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
                Text(
                  'Full Sharing Audit Log',
                  style: GoogleFonts.inter(
                    color: _textPrimary,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _history.length,
                    separatorBuilder: (_, _) => Divider(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    itemBuilder: (context, idx) {
                      final entry = _history[idx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.title,
                                    style: GoogleFonts.inter(
                                      color: _textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    entry.subtitle,
                                    style: GoogleFonts.inter(
                                      color: _textSecondary,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              entry.timestamp,
                              style: GoogleFonts.inter(
                                color: _textSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
    final visible = _filteredRecords;

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
          onPressed: _showShareNewRecordSheet,
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
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SHARED RECORDS (${visible.length})',
                        style: GoogleFonts.inter(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showFilterSheet,
                        child: Text(
                          _hasExtraFilter
                              ? 'Filter active · Tap to edit'
                              : 'Filtered by Emma Johnson',
                          style: GoogleFonts.inter(
                            color: _hasExtraFilter ? _mint : _textSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...visible.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: _buildSwipeableRecordCard(item),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSwipePreview(
                    visible.isNotEmpty ? visible.first : _records.first,
                  ),
                  const SizedBox(height: 24),
                  _buildSharingHistorySection(),
                  const SizedBox(height: 24),
                  _buildReportsCard(),
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
            'Shared Records',
            style: GoogleFonts.inter(
              color: _textPrimary,
              fontSize: 17.5,
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
                      color: _hasExtraFilter ? _mint : _forest,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _showShareNewRecordSheet,
            icon: const UlvenikIcon(UlvenikIcons.add, color: _sage, size: 23),
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
          bottom: BorderSide(color: _forest.withValues(alpha: 0.45)),
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
                  color: Colors.white.withValues(alpha: 0.25),
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
                  hintText: 'Search shared records...',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _chips[index];
          final selected = _selectedChip == chip;
          return GestureDetector(
            onTap: () => setState(() => _selectedChip = chip),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? _forest.withValues(alpha: 0.16) : _cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? _forest
                      : Colors.white.withValues(alpha: 0.06),
                  width: 1.1,
                ),
              ),
              child: Text(
                chip,
                style: GoogleFonts.inter(
                  color: selected ? _mint : _textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwipeableRecordCard(_SharedRecordItem item) {
    final isOpen = _openSwipeId == item.id;
    return GestureDetector(
      onHorizontalDragEnd: (d) {
        final vx = d.primaryVelocity ?? 0;
        if (vx < -140) {
          setState(() => _openSwipeId = item.id);
        } else if (vx > 140 && isOpen) {
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
                  _buildSwipeTile(
                    icon: Icons.visibility_outlined,
                    label: 'VIEW',
                    bgColor: const Color(0xFF282F32),
                    iconColor: _sage,
                    textColor: _textPrimary,
                    onTap: () => _showRecordPreviewAndPermsSheet(item),
                  ),
                  _buildSwipeTile(
                    icon: Icons.shield_outlined,
                    label: 'PERMS',
                    bgColor: const Color(0xFF193027),
                    iconColor: _mint,
                    textColor: _mint,
                    onTap: () => _showRecordPreviewAndPermsSheet(item),
                  ),
                  _buildSwipeTile(
                    icon: item.shareState == _ShareState.active
                        ? Icons.cancel_outlined
                        : Icons.refresh_rounded,
                    label: item.shareState == _ShareState.active
                        ? 'STOP'
                        : 'SHARE',
                    bgColor: const Color(0xFF331D1D),
                    iconColor: _coralText,
                    textColor: _coralText,
                    isRightEnd: true,
                    onTap: () => _toggleShareAccess(item),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSlide(
            duration: const Duration(milliseconds: 210),
            curve: Curves.easeOutCubic,
            offset: isOpen ? const Offset(-0.5, 0) : Offset.zero,
            child: _buildRecordCardContent(item),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCardContent(_SharedRecordItem item) {
    return GestureDetector(
      onTap: () {
        if (_openSwipeId == item.id) {
          setState(() => _openSwipeId = null);
          return;
        }
        _showRecordPreviewAndPermsSheet(item);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UlvenikIcon.fromMaterial(_recordIcon(item.type), color: _sage, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.typeLabel,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildStateBadge(item.shareState),
              ],
            ),
            const SizedBox(height: 10),
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
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.045),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UlvenikIcon(UlvenikIcons.dogs, size: 11.5, color: _sage),
                  const SizedBox(width: 6),
                  Text(
                    item.dogLabel,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
            const SizedBox(height: 11),
            Row(
              children: [
                _buildPermPill(item.permissionLevel),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${item.dateMeta}  •  ${item.sharedBy}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                const UlvenikIcon(UlvenikIcons.details, color: _sage, size: 17),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateBadge(_ShareState state) {
    switch (state) {
      case _ShareState.active:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
          decoration: BoxDecoration(
            color: _forest.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _forest.withValues(alpha: 0.85)),
          ),
          child: Text(
            'ACTIVE',
            style: GoogleFonts.inter(
              color: _mint,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
      case _ShareState.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'PENDING',
            style: GoogleFonts.inter(
              color: _textSecondary,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
      case _ShareState.expired:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
          decoration: BoxDecoration(
            color: _crimson.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'EXPIRED',
            style: GoogleFonts.inter(
              color: _coralText,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        );
    }
  }

  Widget _buildPermPill(String perm) {
    final isFull = perm == 'FULL ACCESS';
    final isEdit = perm == 'EDIT';
    final isComment = perm == 'COMMENT';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: (isFull || isEdit)
            ? _forest.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: isFull ? Border.all(color: _forest) : null,
      ),
      child: Text(
        perm,
        style: GoogleFonts.inter(
          color: (isFull || isEdit)
              ? _mint
              : (isComment ? _sage : _textSecondary),
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwipeTile({
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
        width: 58,
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
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipePreview(_SharedRecordItem target) {
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
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'Swipe left on cards',
              style: GoogleFonts.inter(
                color: _sage,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Swipe left reveals\noptions...',
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ),
              _buildSwipeTile(
                icon: Icons.visibility_outlined,
                label: 'VIEW',
                bgColor: const Color(0xFF282F32),
                iconColor: _sage,
                textColor: _textPrimary,
                onTap: () => _showRecordPreviewAndPermsSheet(target),
              ),
              _buildSwipeTile(
                icon: Icons.shield_outlined,
                label: 'PERMS',
                bgColor: const Color(0xFF193027),
                iconColor: _mint,
                textColor: _mint,
                onTap: () => _showRecordPreviewAndPermsSheet(target),
              ),
              _buildSwipeTile(
                icon: Icons.cancel_outlined,
                label: 'STOP',
                bgColor: const Color(0xFF331D1D),
                iconColor: _coralText,
                textColor: _coralText,
                isRightEnd: true,
                onTap: () => _toggleShareAccess(target),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharingHistorySection() {
    final topThree = _history.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SHARING HISTORY',
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            GestureDetector(
              onTap: _showFullHistorySheet,
              child: Text(
                'View Full History',
                style: GoogleFonts.inter(
                  color: _sage,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Positioned(
              left: 5,
              top: 14,
              bottom: 14,
              width: 1,
              child: Container(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Column(
              children: topThree.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _textSecondary.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: _cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.07),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.title,
                                      style: GoogleFonts.inter(
                                        color: _textPrimary,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      entry.subtitle,
                                      style: GoogleFonts.inter(
                                        color: _textSecondary,
                                        fontSize: 12.5,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.timestamp,
                                style: GoogleFonts.inter(
                                  color: _textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REPORTS',
          style: GoogleFonts.inter(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF232A2D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: const UlvenikIcon(UlvenikIcons.training,
                      color: _sage,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate Shared Report',
                          style: GoogleFonts.inter(
                            color: _textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Creates a consolidated report containing only records currently shared with Emma Johnson.',
                          style: GoogleFonts.inter(
                            color: _textSecondary,
                            fontSize: 12.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    foregroundColor: _textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _showGenerateSharedReportSheet,
                  child: Text(
                    'Generate Shared Report',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
