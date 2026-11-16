import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/photo_picker.dart';
import 'training_screen.dart';

class AddExerciseScreen extends StatefulWidget {
  final String parentSkill;

  const AddExerciseScreen({super.key, required this.parentSkill});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  static const _inheritedImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDrhfrdwNLRqDNJGjuknICW_ZG9DEZQ8gftDHhjtAJskS0KuUQRZsUdhWt9JDN2qw5wVjB9-SH1FCzb9TltDALLsF47aHQK0lQ0YOGXbWuQdFAbgF1qU-0DX1zy-IDSPgNExG9mo2f56Fot7Juee_WO_boF_79Seufb5BLnYPSnhZ9OXY685-wyswoeoe_E70QNWi7RfHpTLzvSKzqN9XN5NVyxbte4y0SQPsdu4Auxvq5FCrus-v8';

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  String? _nameError;
  bool _saving = false;
  ImageProvider? _customPhoto;

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
    super.dispose();
  }


  void _handleCancel() {
    if (_nameController.text.isNotEmpty ||
        _descController.text.isNotEmpty) {
      _showDiscardSheet();
    } else {
      Navigator.pop(context);
    }
  }

  void _handleSave() {
    if (_saving) return; // no duplicate exercises from repeated taps
    final createdExercise = _nameController.text.trim();
    if (createdExercise.isEmpty) {
      setState(() => _nameError = 'Please enter an exercise name.');
      return;
    }
    _saving = true;
    TrainingSessionStore.registerCustomExercise(
      widget.parentSkill,
      createdExercise,
    );
    AppSnackbar.show(context, message: 'Exercise saved', type: SnackbarType.success);
    Navigator.pop(context, createdExercise);
  }

  void _showDiscardSheet() {
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
              Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
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
              const Text('Discard Changes?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryTextOffWhite)),
              const SizedBox(height: 8),
              const Text('You have unsaved changes to this exercise. If you leave now, your changes won’t be saved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.4)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Continue Editing',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
                      side: const BorderSide(color: Colors.white12),
                    ),
                  ),
                  child: const Text('Discard Changes',
                      style: TextStyle(color: Color(0xFFE07070), fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: Column(
        children: [
          // ── Top bar ──
          Container(
            padding: EdgeInsets.only(top: topSafe),
            decoration: const BoxDecoration(
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
                        child: const Text('Cancel',
                            style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const Text('New Exercise',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: bottomSafe + 40),
              children: [
                // Linked skill: read-only, set by where Add Exercise was opened.
                _sectionLabel('LINKED SKILL'),
                _card(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const UlvenikIcon(UlvenikIcons.skills, size: 20, color: AppColors.primaryTextOffWhite),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.parentSkill,
                                style: const TextStyle(fontSize: 15, color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('This exercise belongs to ${widget.parentSkill}.',
                                style: const TextStyle(fontSize: 12.5, color: AppColors.secondaryTextStoneGrey, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Exercise Name'),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _nameController,
                        hint: 'e.g. Recall through distractions',
                        error: _nameError,
                      ),
                      const SizedBox(height: 16),
                      _fieldLabel('Description', optional: true),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _descController,
                        hint: 'Describe how this exercise is performed...',
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _sectionLabel('EXERCISE PHOTO'),
                _card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image(
                                image: _customPhoto ?? NetworkImage(_inheritedImage),
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: Colors.white10,
                                  alignment: Alignment.center,
                                  child: const UlvenikIcon(UlvenikIcons.exercises, size: 20, color: Colors.white38),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Using ${widget.parentSkill}\u2019s photo',
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w600,
                                        color: AppColors.primaryTextOffWhite)),
                                const SizedBox(height: 2),
                                const Text('Automatically uses the skill\u2019s photo.',
                                    style: TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            final img = await pickPhoto(context);
                            if (img != null && mounted) setState(() => _customPhoto = img);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 18, color: AppColors.primaryTextOffWhite),
                                SizedBox(width: 8),
                                Text('Choose Different Photo',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primaryTextOffWhite)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save button
                Material(
                  color: AppColors.primaryForestGreen,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _handleSave,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const UlvenikIcon(UlvenikIcons.save, color: AppColors.primaryTextOffWhite, size: 20),
                          const SizedBox(width: 8),
                          const Text('Save Exercise',
                              style: TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
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

  // ── Helpers ──

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey, fontSize: 11,
                fontWeight: FontWeight.w700, letterSpacing: 0.6)),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: child,
      );

  Widget _fieldLabel(String text, {bool optional = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
        if (optional)
          const Text('Optional', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
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
      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
      decoration: InputDecoration(
        errorText: error,
        errorStyle: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF8B3A3A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB04A4A)),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
        filled: true,
        fillColor: AppColors.backgroundObsidian,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryForestGreen),
        ),
        isDense: true,
      ),
    );
  }


}
