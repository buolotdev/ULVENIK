import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'trainer_dashboard_screen.dart';

class _PermissionItem {
  final String key;
  final String title;
  final String subtitle;
  final bool isViewOnlySafe;
  final bool standardDefault;

  const _PermissionItem({
    required this.key,
    required this.title,
    required this.subtitle,
    this.isViewOnlySafe = false,
    required this.standardDefault,
  });
}

class _PermissionSection {
  final String title;
  final IconData icon;
  final List<_PermissionItem> items;

  const _PermissionSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class _PermHistoryItem {
  final String timestamp;
  final String action;
  final String changedBy;

  const _PermHistoryItem({
    required this.timestamp,
    required this.action,
    required this.changedBy,
  });
}

class ClientPermissionsScreen extends StatefulWidget {
  final String? clientId;

  const ClientPermissionsScreen({
    super.key,
    this.clientId,
  });

  @override
  State<ClientPermissionsScreen> createState() =>
      _ClientPermissionsScreenState();
}

class _ClientPermissionsScreenState extends State<ClientPermissionsScreen> {
  static const Color _bg = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _sage = Color(0xFF7A8F7A);
  static const Color _infoBlue = Color(0xFF5D8FAF);
  static const Color _textPrimary = Color(0xFFF5F6F2);
  static const Color _textSecondary = Color(0xFFA7B0AB);

  static const List<_PermissionSection> _sections = [
    _PermissionSection(
      title: 'Dog Profile',
      icon: Icons.pets_outlined,
      items: [
        _PermissionItem(
          key: 'dog_view',
          title: 'View Dog Profile',
          subtitle: "Can access dog's vitals, microchip and pedigree",
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'dog_edit',
          title: 'Edit Dog Information',
          subtitle: 'Update registered name, breed and weight targets',
          standardDefault: false,
        ),
        _PermissionItem(
          key: 'dog_photo',
          title: 'Change Dog Photo',
          subtitle: 'Upload or replace the primary profile avatar',
          standardDefault: false,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Training',
      icon: Icons.bolt_outlined,
      items: [
        _PermissionItem(
          key: 'train_view',
          title: 'View Training Sessions',
          subtitle: 'Read access to session summaries and records',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'train_add',
          title: 'Add Training Sessions',
          subtitle: 'Record new field sessions and duration logs',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'train_edit',
          title: 'Edit Training Sessions',
          subtitle: 'Modify drills, notes and environmental variables',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'train_delete',
          title: 'Delete Trainer Sessions',
          subtitle: 'Permanently remove trainer-created logs',
          standardDefault: false,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Strength & Conditioning',
      icon: Icons.fitness_center_outlined,
      items: [
        _PermissionItem(
          key: 'sc_view',
          title: 'View S&C Sessions',
          subtitle: 'See conditioning logs, swimming and hill work',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'sc_add',
          title: 'Add Sessions',
          subtitle: 'Log reps, resistance protocols and sets',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'sc_edit',
          title: 'Edit Sessions',
          subtitle: 'Correct completed workload parameters',
          standardDefault: false,
        ),
        _PermissionItem(
          key: 'sc_delete',
          title: 'Delete Sessions',
          subtitle: 'Remove conditioning records from journal',
          standardDefault: false,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Health',
      icon: Icons.favorite_border,
      items: [
        _PermissionItem(
          key: 'health_view',
          title: 'View Health Records',
          subtitle: 'Access owner-shared health summary and safety notes',
          isViewOnlySafe: false,
          standardDefault: false,
        ),
        _PermissionItem(
          key: 'health_add',
          title: 'Add Health Records',
          subtitle: 'Record rehabilitation and palpation notes',
          standardDefault: false,
        ),
        _PermissionItem(
          key: 'health_edit',
          title: 'Edit Health Records',
          subtitle: 'Modify trainer observations on recovery status',
          standardDefault: false,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Goals',
      icon: Icons.flag_outlined,
      items: [
        _PermissionItem(
          key: 'goals_view',
          title: 'View Goals',
          subtitle: 'Inspect client targets and milestone progress',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'goals_create',
          title: 'Create Goals',
          subtitle: 'Set new behavioral and sport targets',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'goals_edit',
          title: 'Edit Goals',
          subtitle: 'Adjust target dates and completion metrics',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'goals_complete',
          title: 'Complete Goals',
          subtitle: 'Mark goals achieved and sign off criteria',
          standardDefault: true,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Homework',
      icon: Icons.format_list_bulleted,
      items: [
        _PermissionItem(
          key: 'hw_view',
          title: 'View Homework',
          subtitle: 'Read assigned drills and student submissions',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'hw_create',
          title: 'Create Homework',
          subtitle: 'Assign weekly plans and linked skill drills',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'hw_edit',
          title: 'Edit Homework',
          subtitle: 'Update instructions and assigned deadlines',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'hw_archive',
          title: 'Archive Homework',
          subtitle: 'Move completed assignments into client archive',
          standardDefault: false,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Media',
      icon: Icons.photo_camera_outlined,
      items: [
        _PermissionItem(
          key: 'media_photo_view',
          title: 'View Photos',
          subtitle: 'Inspect high-resolution training captures',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'media_photo_upload',
          title: 'Upload Photos',
          subtitle: 'Add photos to training and health records',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'media_photo_delete',
          title: 'Delete Photos',
          subtitle: 'Remove photos uploaded by you',
          standardDefault: false,
        ),
        _PermissionItem(
          key: 'media_video_view',
          title: 'View Videos',
          subtitle: 'Watch decoys, trials and training submissions',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'media_video_upload',
          title: 'Upload Videos',
          subtitle: 'Add video clips to drills and reviews',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'media_video_delete',
          title: 'Delete Videos',
          subtitle: 'Remove uploaded video clips',
          standardDefault: false,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Reports',
      icon: Icons.description_outlined,
      items: [
        _PermissionItem(
          key: 'rep_view',
          title: 'View Reports',
          subtitle: 'Read consolidated progress evaluations',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'rep_generate',
          title: 'Generate Reports',
          subtitle: 'Compile client data into structured reviews',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'rep_export',
          title: 'Export Reports',
          subtitle: 'Download PDF briefings for owners',
          standardDefault: true,
        ),
      ],
    ),
    _PermissionSection(
      title: 'Notes',
      icon: Icons.edit_note_outlined,
      items: [
        _PermissionItem(
          key: 'notes_view',
          title: 'View Shared Notes',
          subtitle: 'Read shared handler observations',
          isViewOnlySafe: true,
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'notes_create',
          title: 'Create Shared Notes',
          subtitle: 'Write notes visible to both trainer and client',
          standardDefault: true,
        ),
        _PermissionItem(
          key: 'notes_edit',
          title: 'Edit Shared Notes',
          subtitle: 'Update previously authored shared notes',
          standardDefault: false,
        ),
      ],
    ),
  ];

  late final Map<String, bool> _values = {};
  late final Map<String, bool> _savedSnapshot = {};
  String _selectedPreset = 'Standard Trainer';
  String _updatedAgoLabel = 'Updated 3 days\nago';

  late final List<_PermHistoryItem> _history = [
    const _PermHistoryItem(
      timestamp: '14 Sep 2026 · 09:42',
      action: 'Emily Johnson enabled Add Training Sessions',
      changedBy: 'Changed by: You',
    ),
    const _PermHistoryItem(
      timestamp: '11 Sep 2026 · 16:15',
      action: 'Changed preset to Standard Trainer',
      changedBy: 'Changed by: You',
    ),
    const _PermHistoryItem(
      timestamp: '08 Sep 2026 · 11:30',
      action: 'Initial client connection approved',
      changedBy: 'Changed by: Emily Johnson',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final client = TrainerPackStore.findClient(widget.clientId);
    for (final sec in _sections) {
      for (final item in sec.items) {
        final initialVal = item.key == 'health_view'
            ? client.canViewHealthRecords
            : item.standardDefault;
        _values[item.key] = initialVal;
        _savedSnapshot[item.key] = initialVal;
      }
    }
  }

  List<_PermissionItem> get _allItems =>
      _sections.expand((s) => s.items).toList();

  bool get _hasUnsavedChanges {
    for (final entry in _values.entries) {
      if (_savedSnapshot[entry.key] != entry.value) return true;
    }
    return false;
  }

  int get _enabledCount => _values.values.where((v) => v).length;

  void _applyPreset(String preset) {
    setState(() {
      _selectedPreset = preset;
      if (preset == 'View Only') {
        for (final item in _allItems) {
          _values[item.key] = item.isViewOnlySafe;
        }
      } else if (preset == 'Standard Trainer') {
        for (final item in _allItems) {
          _values[item.key] = item.standardDefault;
        }
      } else if (preset == 'Full Access') {
        for (final item in _allItems) {
          _values[item.key] = true;
        }
      }
    });
  }

  String _detectMatchingPreset() {
    final allViewOnly =
        _allItems.every((i) => _values[i.key] == i.isViewOnlySafe);
    if (allViewOnly) return 'View Only';

    final allStandard =
        _allItems.every((i) => _values[i.key] == i.standardDefault);
    if (allStandard) return 'Standard Trainer';

    final allFull = _allItems.every((i) => _values[i.key] == true);
    if (allFull) return 'Full Access';

    return 'Custom';
  }

  void _toggleSinglePermission(_PermissionItem item) {
    setState(() {
      _values[item.key] = !(_values[item.key] ?? false);
      _selectedPreset = _detectMatchingPreset();
    });
  }

  void _resetToStandard() {
    _applyPreset('Standard Trainer');
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Reset switches to Standard Trainer preset',
          style: GoogleFonts.inter(color: _textPrimary, fontSize: 13),
        ),
      ),
    );
  }

  void _showSaveConfirmationSheet() {
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: _forest),
                      ),
                      child: const Icon(
                        Icons.verified_user_outlined,
                        color: Color(0xFF429679),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Client Permissions',
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Client: Emily Johnson · 2 dogs connected',
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
                const SizedBox(height: 16),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACTIVE ROLE PRESET',
                            style: GoogleFonts.inter(
                              color: _textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedPreset,
                            style: GoogleFonts.inter(
                              color: _textPrimary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$_enabledCount / ${_allItems.length} Enabled',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF429679),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _textSecondary,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
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
                          final targetClient =
                              TrainerPackStore.findClient(widget.clientId);
                          TrainerPackStore.updateClient(
                            targetClient.copyWith(
                              canViewHealthRecords:
                                  _values['health_view'] ?? false,
                            ),
                          );
                          setState(() {
                            _savedSnapshot
                              ..clear()
                              ..addAll(_values);
                            _updatedAgoLabel = 'Updated just\nnow';
                            _history.insert(
                              0,
                              _PermHistoryItem(
                                timestamp: 'Just now',
                                action:
                                    'Saved $_selectedPreset permissions ($_enabledCount/${_allItems.length} active)',
                                changedBy: 'Changed by: You',
                              ),
                            );
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: _cardBg,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Saved $_selectedPreset permissions for Emily Johnson',
                                style: GoogleFonts.inter(
                                  color: _textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Confirm & Save',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
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
  }

  @override
  Widget build(BuildContext context) {
    final dirty = _hasUnsavedChanges;

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(dirty),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
                children: [
                  _buildClientHeaderCard(),
                  const SizedBox(height: 22),
                  Text(
                    'PERMISSION PRESETS',
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPresetsGrid(),
                  const SizedBox(height: 20),
                  ..._sections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCategoryCard(section),
                    ),
                  ),
                  _buildPrivateNotesCallout(),
                  const SizedBox(height: 24),
                  _buildPermissionHistorySection(),
                  const SizedBox(height: 22),
                  _buildBottomButtons(dirty),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool dirty) {
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
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.chevron_left,
                    color: _textSecondary,
                    size: 23,
                  ),
                  Text(
                    'Back',
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Client Permissions',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
          GestureDetector(
            onTap: _resetToStandard,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                'Reset',
                style: GoogleFonts.inter(
                  color: dirty ? _textSecondary : const Color(0xFF6B7280),
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: _showSaveConfirmationSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                'Save',
                style: GoogleFonts.inter(
                  color: dirty ? const Color(0xFF429679) : _forest,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: _sage,
                size: 21,
              ),
              const SizedBox(height: 36),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emily Johnson',
                  style: GoogleFonts.inter(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2 dogs\nconnected',
                  style: GoogleFonts.inter(
                    color: _textSecondary,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _updatedAgoLabel,
                  style: GoogleFonts.inter(
                    color: _textSecondary.withValues(alpha: 0.72),
                    fontSize: 11.5,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _forest.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _forest),
            ),
            child: Text(
              _selectedPreset.toUpperCase(),
              style: GoogleFonts.inter(
                color: const Color(0xFF3E8E72),
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPresetTile(
                title: 'View Only',
                subtitle: 'View records only. No editing permitted.',
                icon: Icons.verified_user_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPresetTile(
                title: 'Standard Trainer',
                subtitle: 'Add sessions, notes, goals and homework.',
                icon: Icons.file_copy_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPresetTile(
                title: 'Full Access',
                subtitle: 'Create, edit and manage all trainer records.',
                icon: Icons.lock_open_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPresetTile(
                title: 'Custom',
                subtitle: 'Configure every permission individually.',
                icon: Icons.tune_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _selectedPreset == title;
    return GestureDetector(
      onTap: () => _applyPreset(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 122,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF152520) : _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? _forest
                : Colors.white.withValues(alpha: 0.07),
            width: selected ? 1.2 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected ? const Color(0xFF429679) : _textSecondary,
                ),
                if (selected)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3E8E72),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.inter(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: _textSecondary,
                fontSize: 11.5,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(_PermissionSection section) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Icon(section.icon, color: _sage, size: 18),
                const SizedBox(width: 10),
                Text(
                  section.title,
                  style: GoogleFonts.inter(
                    color: _textPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < section.items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: Colors.white.withValues(alpha: 0.055),
              ),
            _buildPermissionSwitchRow(section.items[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionSwitchRow(_PermissionItem item) {
    final enabled = _values[item.key] ?? false;
    return InkWell(
      onTap: () => _toggleSinglePermission(item),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.inter(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.inter(
                      color: _textSecondary,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 46,
              height: 26,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: enabled ? _forest : const Color(0xFF2B3135),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: _textPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivateNotesCallout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _infoBlue.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _infoBlue.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.privacy_tip_outlined,
              color: _infoBlue,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Trainer-only notes are always private and never visible to clients.',
              style: GoogleFonts.inter(
                color: _infoBlue,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERMISSION HISTORY',
          style: GoogleFonts.inter(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
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
          child: Stack(
            children: [
              Positioned(
                left: 4,
                top: 8,
                bottom: 8,
                width: 1,
                child: Container(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Column(
                children: List.generate(_history.length, (idx) {
                  final entry = _history[idx];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: idx < _history.length - 1 ? 18 : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: _textSecondary.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.timestamp,
                                style: GoogleFonts.inter(
                                  color: _textSecondary,
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.action,
                                style: GoogleFonts.inter(
                                  color: _textPrimary,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.changedBy,
                                style: GoogleFonts.inter(
                                  color: _textSecondary.withValues(alpha: 0.8),
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(bool dirty) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: _cardBg,
              foregroundColor: _textPrimary,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _resetToStandard,
            child: Text(
              'Reset to Standard Trainer',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  dirty ? _forest : const Color(0xFF192D26),
              foregroundColor: dirty
                  ? _textPrimary
                  : _textSecondary.withValues(alpha: 0.8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _showSaveConfirmationSheet,
            child: Text(
              'Save Permissions',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
