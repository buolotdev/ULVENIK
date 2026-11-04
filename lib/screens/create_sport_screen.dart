import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'sport_pack_overview_screen.dart';

class CreateSportScreen extends StatefulWidget {
  final SportEntryModel? initialSport;

  const CreateSportScreen({
    super.key,
    this.initialSport,
  });

  @override
  State<CreateSportScreen> createState() => _CreateSportScreenState();
}

class _CreateSportScreenState extends State<CreateSportScreen> {
  final SportPackStore _store = SportPackStore.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _organisationController;
  late final TextEditingController _levelController;
  late final TextEditingController _notesController;

  IconData? _selectedPhotoEmblem;
  String? _selectedPhotoLabel;

  static const List<(String, String, String, String)> _quickTemplates = [
    (
      'Mondioring',
      'Three-discipline ring sport combining obedience, jumps, and decoy protection.',
      'FCI / USMRA',
      'Cat 1',
    ),
    (
      'Nosework',
      'Target odour detection across interior, exterior, vehicle, and container searches.',
      'NACSW / UK Sniffer Dogs',
      'NW1',
    ),
    (
      'Obedience',
      'Precision heelwork, retrieve, distance control, and scent discrimination.',
      'The Kennel Club',
      'Novice',
    ),
    (
      'Canicross',
      'Cross-country trail running in harness building endurance and directional cues.',
      'Canicross UK',
      '5K Trail',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSport;
    _nameController = TextEditingController(text: initial?.name ?? 'IGP');
    _descriptionController = TextEditingController(
      text: initial != null
          ? 'Structured multi-phase working dog sport progression.'
          : '',
    );
    final rawOrg = initial?.organisation ?? '';
    final cleanOrg = rawOrg
        .replaceFirst('Organisation:', '')
        .replaceFirst('No organisation', '')
        .trim();
    _organisationController = TextEditingController(text: cleanOrg);
    _levelController = TextEditingController(
      text: initial?.currentLevel ?? '',
    );
    _notesController = TextEditingController(text: initial?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _organisationController.dispose();
    _levelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.initialSport != null;

  void _openPhotoPickerSheet() {
    final options = <(IconData, String)>[
      (Icons.shield_outlined, 'Working Protection Crest'),
      (Icons.pets_rounded, 'Tracking & Scent Paw'),
      (Icons.bolt_rounded, 'Speed & Agility Hurdle'),
      (Icons.emoji_events_outlined, 'Championship Rosette'),
      (Icons.photo_library_outlined, 'Choose from Gallery'),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'SPORT PHOTO / EMBLEM',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                ...options.map((opt) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        opt.$1,
                        color: const Color(0xFF95D3BB),
                        size: 19,
                      ),
                    ),
                    title: Text(
                      opt.$2,
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedPhotoEmblem = opt.$1;
                        _selectedPhotoLabel = opt.$2;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
                if (_selectedPhotoEmblem != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedPhotoEmblem = null;
                        _selectedPhotoLabel = null;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Remove Photo',
                      style: TextStyle(
                        color: Color(0xFFB55454),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
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

  void _applyTemplate((String, String, String, String) tpl) {
    setState(() {
      _nameController.text = tpl.$1;
      _descriptionController.text = tpl.$2;
      _organisationController.text = tpl.$3;
      _levelController.text = tpl.$4;
    });
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.show(
        context,
        title: 'Sport Name Required',
        message: 'Please enter a sport name before saving.',
        type: SnackbarType.error,
      );
      return;
    }

    final orgInput = _organisationController.text.trim();
    final formattedOrg =
        orgInput.isEmpty ? 'No organisation' : 'Organisation: $orgInput';
    final levelInput = _levelController.text.trim().isEmpty
        ? 'Foundation'
        : _levelController.text.trim();
    final notesInput = _notesController.text.trim().isNotEmpty
        ? _notesController.text.trim()
        : _descriptionController.text.trim();

    final shortTag = name.length <= 7
        ? name
        : name
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .join()
            .toUpperCase();

    if (_isEditing) {
      final targetId = widget.initialSport!.id;
      final idx = _store.sports.indexWhere((s) => s.id == targetId);
      if (idx != -1) {
        _store.sports[idx] = _store.sports[idx].copyWith(
          name: name,
          tag: shortTag.isEmpty ? name : shortTag,
          organisation: formattedOrg,
          currentLevel: levelInput,
          notes: notesInput,
        );
        // Trigger listeners via a no-op dog reselect on active index
        _store.selectDog(_store.selectedDogIndex);
      }
      AppSnackbar.show(
        context,
        title: 'Sport Updated',
        message: '$name settings saved.',
        type: SnackbarType.success,
      );
    } else {
      final newSport = SportEntryModel(
        id: 'sport_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        tag: shortTag.isEmpty ? name : shortTag,
        organisation: formattedOrg,
        currentLevel: levelInput,
        targetLevel: 'Next Level',
        skillsCount: 4,
        sessionsCount: 1,
        competitionsCount: 0,
        lastTrained: 'Just now',
        notes: notesInput,
      );
      _store.addSport(newSport);
      AppSnackbar.show(
        context,
        title: 'Sport Created',
        message: '$name has been added to My Sports.',
        type: SnackbarType.success,
      );
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleCancel() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrimaryIdentityCard(),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _quickTemplates.map((tpl) {
                          final selected =
                              _nameController.text.trim().toLowerCase() ==
                                  tpl.$1.toLowerCase();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => _applyTemplate(tpl),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primaryForestGreen
                                          .withValues(alpha: 0.22)
                                      : AppColors.cardsCarbon,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primaryForestGreen
                                        : AppColors.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  '+ ${tpl.$1}',
                                  style: TextStyle(
                                    color: selected
                                        ? const Color(0xFF95D3BB)
                                        : AppColors.secondaryTextStoneGrey,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildSectionLabel('SPORT INFORMATION'),
                    const SizedBox(height: 8),
                    _buildSportInformationCard(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('NOTES'),
                    const SizedBox(height: 8),
                    _buildNotesCard(),
                  ],
                ),
              ),
            ),
            _buildBottomActionFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _handleCancel,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          Text(
            _isEditing ? 'Edit Sport' : 'Create Sport',
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: _handleSave,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.15,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildPrimaryIdentityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _openPhotoPickerSheet,
              child: Column(
                children: [
                  SizedBox(
                    width: 82,
                    height: 82,
                    child: CustomPaint(
                      painter: _DashedCirclePainter(
                        color: _selectedPhotoEmblem != null
                            ? AppColors.primaryForestGreen
                            : AppColors.secondaryTextStoneGrey
                                .withValues(alpha: 0.35),
                      ),
                      child: Center(
                        child: Icon(
                          _selectedPhotoEmblem ?? Icons.camera_alt_outlined,
                          color: _selectedPhotoEmblem != null
                              ? const Color(0xFF95D3BB)
                              : AppColors.secondaryTextStoneGrey,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _selectedPhotoLabel ?? 'Add photo (optional)',
                    style: TextStyle(
                      color: _selectedPhotoLabel != null
                          ? const Color(0xFF95D3BB)
                          : AppColors.secondaryTextStoneGrey,
                      fontSize: 12.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 26),
          _buildFieldLabel('SPORT NAME *'),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
            decoration: const InputDecoration(
              hintText: 'e.g. IGP, Agility, Mondioring',
              hintStyle: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 15,
                fontFamily: 'Inter',
              ),
              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryForestGreen,
                  width: 1.2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF95D3BB),
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _buildFieldLabel('DESCRIPTION'),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            minLines: 2,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15,
              height: 1.4,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              hintText: 'What is this sport about?',
              hintStyle: TextStyle(
                color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.75),
                fontSize: 15,
                fontFamily: 'Inter',
              ),
              contentPadding: const EdgeInsets.only(top: 10, bottom: 12),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      AppColors.secondaryTextStoneGrey.withValues(alpha: 0.35),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryForestGreen,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportInformationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('ORGANISATION'),
          TextField(
            controller: _organisationController,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              hintText: 'e.g. SV, FCI, AKC',
              hintStyle: TextStyle(
                color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.72),
                fontSize: 15,
                fontFamily: 'Inter',
              ),
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      AppColors.secondaryTextStoneGrey.withValues(alpha: 0.35),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryForestGreen,
                  width: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _buildFieldLabel('CURRENT LEVEL'),
          TextField(
            controller: _levelController,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 15,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              hintText: 'e.g. IGP 1, Foundation, Beginner',
              hintStyle: TextStyle(
                color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.72),
                fontSize: 15,
                fontFamily: 'Inter',
              ),
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      AppColors.secondaryTextStoneGrey.withValues(alpha: 0.35),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryForestGreen,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 4,
        minLines: 4,
        style: const TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14.5,
          height: 1.45,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: 'Add any additional notes about this sport…',
          hintStyle: TextStyle(
            color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.72),
            fontSize: 14.5,
            height: 1.45,
            fontFamily: 'Inter',
          ),
          contentPadding: const EdgeInsets.only(bottom: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.35),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryForestGreen,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundObsidian,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(
                    color: AppColors.secondaryTextStoneGrey
                        .withValues(alpha: 0.45),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 7,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleSave,
                child: Text(
                  _isEditing ? 'Save Changes' : 'Create Sport',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  const _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final radius = (size.width / 2) - 1;
    final center = Offset(size.width / 2, size.height / 2);
    const dashCount = 32;
    const step = (2 * math.pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * step,
        step * 0.58,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
