import 'package:flutter/material.dart';
import '../data/app_settings.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/photo_picker.dart';
import 'package:image_picker/image_picker.dart' show ImageSource;
import 'training_screen.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();

  String? _nameError;


  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.trim().isNotEmpty) setState(() => _nameError = null);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _notesController.dispose();
    super.dispose();
  }





  void _handleCancel() {
    if (_nameController.text.isNotEmpty ||
        _descController.text.isNotEmpty ||
        _notesController.text.isNotEmpty) {
      _showDiscardDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _showDiscardDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE07070).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFE07070),
                  size: 24,
                ),
              ),
              Text(
                'Discard Changes?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextOffWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have unsaved changes to this skill. If you leave now, your changes won’t be saved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryTextStoneGrey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.onForestGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue Editing',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.cardsCarbon,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  child: const Text(
                    'Discard Changes',
                    style: TextStyle(
                      color: Color(0xFFE07070),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _saving = false;

  ImageProvider? _photo;

  Future<void> _pick(ImageSource source) async {
    final img = await pickPhotoFrom(context, source);
    if (img != null && mounted) setState(() => _photo = img);
  }

  void _handleSave() {
    if (_saving) return; // prevent duplicate skills from repeated taps
    final createdName = _nameController.text.trim();
    if (createdName.isEmpty) {
      setState(() => _nameError = 'Please enter a skill name.');
      return;
    }
    _saving = true;
    TrainingSessionStore.registerCustomSkill(createdName);
    AppSnackbar.show(context, message: 'Skill saved', type: SnackbarType.success);
    Navigator.pop(context, createdName);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppSettings.instance.isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: AppSettings.instance.isDark ? Brightness.dark : Brightness.light,
    ));

    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: Column(
        children: [
          // ── Top bar ────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.only(top: topSafe),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: _handleCancel,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'New Skill',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable content ─────────────────────────────────────
          // Flow: Skill Name > Description > Skill Photo > Notes > Save Skill
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 24, bottom: bottomSafe + 40,
              ),
              children: [
                _buildSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Skill Name'),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _nameController,
                        hint: 'Enter skill name',
                        error: _nameError,
                      ),
                      const SizedBox(height: 16),
                      _fieldLabel('Description', optional: true),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _descController,
                        hint: 'Briefly describe the skill... (optional)',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _buildSection(
                  label: 'SKILL PHOTO',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundObsidian,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _photo != null
                                ? Image(image: _photo!, fit: BoxFit.cover)
                                : Icon(Icons.photo_camera_outlined,
                                    color: AppColors.secondaryTextStoneGrey, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                _outlineBtn(
                                  icon: Icons.photo_camera_outlined,
                                  label: 'Take Photo',
                                  isPrimary: true,
                                  onTap: () => _pick(ImageSource.camera),
                                ),
                                const SizedBox(height: 10),
                                _outlineBtn(
                                  icon: Icons.photo_library_outlined,
                                  label: 'Choose Library',
                                  isPrimary: false,
                                  onTap: () => _pick(ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Optional. You can crop, zoom and reposition before saving. If you skip this, the dog’s profile photo is used.',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _buildSection(
                  label: 'NOTES',
                  child: _textInput(
                    controller: _notesController,
                    hint: 'Add training cues, observations or reminders...',
                    maxLines: 4,
                  ),
                ),
                const SizedBox(height: 32),

                // One full-width Save Skill; validation shows on tap.
                Material(
                  color: AppColors.primaryForestGreen,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _handleSave,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UlvenikIcon(UlvenikIcons.save, color: AppColors.primaryTextOffWhite, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Save Skill',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 16,
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
          ),
        ],
      ),
    );
  }

  // ── Helper widgets ─────────────────────────────────────────────────────────

  Widget _buildSection({String? label, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label,
              style: TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {bool optional = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        if (optional)
          Text('Optional',
              style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
      ],
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? error,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.primaryForestGreen,
      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
      decoration: InputDecoration(
        errorText: error,
        errorStyle: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF8B3A3A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFB04A4A)),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
        filled: true,
        fillColor: AppColors.backgroundObsidian,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.primaryForestGreen),
        ),
        isDense: true,
      ),
    );
  }





  Widget _outlineBtn({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPrimary
                  ? AppColors.primaryForestGreen.withValues(alpha: 0.5)
                  : AppColors.cardBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UlvenikIcon.fromMaterial(icon,
                  size: 16,
                  color: isPrimary
                      ? AppColors.primaryForestGreen
                      : AppColors.primaryTextOffWhite),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isPrimary
                      ? AppColors.primaryForestGreen
                      : AppColors.primaryTextOffWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
