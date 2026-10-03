import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagController = TextEditingController();

  final List<String> _tags = ['Foundation', 'Outdoor'];

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !_tags.contains(trimmed)) {
      setState(() => _tags.add(trimmed));
    }
    _tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
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
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Discard skill?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryTextOffWhite),
              ),
              const SizedBox(height: 8),
              const Text(
                'Any information you have entered will be lost.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.4),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF8B3A3A).withOpacity(0.15),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Discard',
                    style: TextStyle(color: Color(0xFFE07070), fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.cardsCarbon,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white12),
                    ),
                  ),
                  child: const Text(
                    'Keep Editing',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (!_canSave) return;
    AppSnackbar.show(context, message: 'Skill saved', type: SnackbarType.success);
    Navigator.pop(context);
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
          // ── Top bar ────────────────────────────────────────────────
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _handleCancel,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.primaryForestGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      'New Skill',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: _canSave ? _handleSave : null,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: _canSave
                              ? AppColors.primaryTextOffWhite
                              : AppColors.secondaryTextStoneGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Scrollable content ─────────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 24, bottom: bottomSafe + 40,
              ),
              children: [
                // Information
                _buildSection(
                  label: 'INFORMATION',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Skill Name', required: true),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _nameController,
                        hint: 'e.g. Heeling',
                      ),
                      const SizedBox(height: 16),
                      _fieldLabel('Description', optional: true),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _descController,
                        hint: 'Briefly describe the skill...',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Visual Reference
                _buildSection(
                  label: 'VISUAL REFERENCE',
                  child: Row(
                    children: [
                      // Placeholder thumbnail
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Icon(Icons.photo_camera_outlined,
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
                              onTap: () => AppSnackbar.show(context,
                                  message: 'Camera coming soon',
                                  type: SnackbarType.info),
                            ),
                            const SizedBox(height: 10),
                            _outlineBtn(
                              icon: Icons.photo_library_outlined,
                              label: 'Choose Library',
                              isPrimary: false,
                              onTap: () => AppSnackbar.show(context,
                                  message: 'Library coming soon',
                                  type: SnackbarType.info),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Organisation / Tags
                _buildSection(
                  label: 'ORGANISATION',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Tags'),
                      const SizedBox(height: 6),
                      _buildTagInput(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Private Notes
                _buildSection(
                  label: 'PRIVATE NOTES',
                  child: _textInput(
                    controller: _notesController,
                    hint: 'Add any private reminders, cues, or criteria here...',
                    maxLines: 4,
                  ),
                ),
                const SizedBox(height: 32),

                // Save button
                Material(
                  color: AppColors.primaryForestGreen,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _canSave ? _handleSave : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_outlined,
                              color: _canSave
                                  ? AppColors.primaryTextOffWhite
                                  : AppColors.secondaryTextStoneGrey,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Save Skill',
                            style: TextStyle(
                              color: _canSave
                                  ? AppColors.primaryTextOffWhite
                                  : AppColors.secondaryTextStoneGrey,
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

  Widget _buildSection({required String label, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = false, bool optional = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(text,
                style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            if (required) ...[
              const SizedBox(width: 4),
              const Text('*',
                  style: TextStyle(color: Color(0xFFFFB4AB), fontSize: 13)),
            ],
          ],
        ),
        if (optional)
          const Text('Optional',
              style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
      ],
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.primaryForestGreen,
      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
        filled: true,
        fillColor: AppColors.backgroundObsidian,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primaryForestGreen),
        ),
        isDense: true,
      ),
    );
  }

  Widget _buildTagInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundObsidian,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ..._tags.map((tag) => _tagChip(tag)),
          IntrinsicWidth(
            child: TextField(
              controller: _tagController,
              cursorColor: AppColors.primaryForestGreen,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Add tag...',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              ),
              onSubmitted: _addTag,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeTag(label),
            child: const Icon(Icons.close,
                size: 14, color: AppColors.secondaryTextStoneGrey),
          ),
        ],
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
                  ? AppColors.primaryForestGreen.withOpacity(0.5)
                  : Colors.white24,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
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
