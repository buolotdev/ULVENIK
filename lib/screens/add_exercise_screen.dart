import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class AddExerciseScreen extends StatefulWidget {
  final String parentSkill;

  const AddExerciseScreen({super.key, required this.parentSkill});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  static const _inheritedImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDrhfrdwNLRqDNJGjuknICW_ZG9DEZQ8gftDHhjtAJskS0KuUQRZsUdhWt9JDN2qw5wVjB9-SH1FCzb9TltDALLsF47aHQK0lQ0YOGXbWuQdFAbgF1qU-0DX1zy-IDSPgNExG9mo2f56Fot7Juee_WO_boF_79Seufb5BLnYPSnhZ9OXY685-wyswoeoe_E70QNWi7RfHpTLzvSKzqN9XN5NVyxbte4y0SQPsdu4Auxvq5FCrus-v8';

  static const _noBorder = InputBorder.none;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _tagController = TextEditingController();

  final List<String> _inheritedTags = ['Obedience'];
  final List<String> _tags = [];

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
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final t = tag.trim();
    if (t.isNotEmpty && !_tags.contains(t) && !_inheritedTags.contains(t)) {
      setState(() => _tags.add(t));
    }
    _tagController.clear();
  }

  void _handleCancel() {
    if (_nameController.text.isNotEmpty ||
        _descController.text.isNotEmpty ||
        _tags.isNotEmpty) {
      _showDiscardSheet();
    } else {
      Navigator.pop(context);
    }
  }

  void _handleSave() {
    if (!_canSave) return;
    AppSnackbar.show(context, message: 'Exercise saved', type: SnackbarType.success);
    Navigator.pop(context);
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
              const Text('Discard exercise?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryTextOffWhite)),
              const SizedBox(height: 8),
              const Text('Any information you have entered will be lost.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.secondaryTextStoneGrey, height: 1.4)),
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
                  child: const Text('Discard',
                      style: TextStyle(color: Color(0xFFE07070), fontSize: 15, fontWeight: FontWeight.w600)),
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
                  child: const Text('Keep Editing',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w500)),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _canSave ? _handleSave : null,
                        child: Text('Save',
                            style: TextStyle(
                              color: _canSave ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
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
                // Parent skill (locked)
                _sectionLabel('PARENT SKILL'),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_outlined, size: 18, color: AppColors.secondaryTextStoneGrey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(widget.parentSkill,
                                style: const TextStyle(fontSize: 15, color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w500)),
                          ),
                          const Icon(Icons.lock_outline, size: 18, color: Colors.white30),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'This exercise will belong to ${widget.parentSkill} and inherit its core training tags.',
                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextStoneGrey, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Information
                _sectionLabel('INFORMATION'),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Exercise Name', required: true),
                      const SizedBox(height: 6),
                      _textInput(controller: _nameController, hint: 'e.g. Hidden subject recall'),
                      const SizedBox(height: 16),
                      _fieldLabel('Description', optional: true),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _descController,
                        hint: 'Describe the setup, criteria, and environment for this exercise...',
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Visual identification
                _sectionLabel('VISUAL IDENTIFICATION'),
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
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.matrix(<double>[
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0.2126, 0.7152, 0.0722, 0, 0,
                                  0, 0, 0, 0.85, 0,
                                ]),
                                child: Image.network(_inheritedImage, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('INHERITED FROM ${widget.parentSkill.toUpperCase()}',
                                    style: const TextStyle(
                                        fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6,
                                        color: AppColors.secondaryTextStoneGrey)),
                                const SizedBox(height: 2),
                                const Text('Default visual asset',
                                    style: TextStyle(fontSize: 12, color: Colors.white38)),
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
                          onTap: () => AppSnackbar.show(context,
                              message: 'Custom image coming soon', type: SnackbarType.info),
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
                                Text('Use Custom Image',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primaryTextOffWhite)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Organisation
                _sectionLabel('ORGANISATION (OPTIONAL)'),
                _card(child: _buildTagInput()),
                const SizedBox(height: 32),

                // Save button
                Material(
                  color: _canSave
                      ? AppColors.primaryForestGreen
                      : AppColors.primaryForestGreen.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _canSave ? _handleSave : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text('Save Exercise',
                          style: TextStyle(
                            color: _canSave ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
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

  Widget _fieldLabel(String text, {bool required = false, bool optional = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Text(text,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
          if (required) ...[
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Color(0xFFFFB4AB), fontSize: 13)),
          ],
        ]),
        if (optional)
          const Text('Optional', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
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

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width tag input — no underline
        Container(
          height: 44,
          padding: const EdgeInsets.only(left: 12, right: 4),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              const Icon(Icons.sell_outlined, size: 16, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _tagController,
                  cursorColor: AppColors.primaryForestGreen,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Add tag...',
                    hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                    border: _noBorder,
                    enabledBorder: _noBorder,
                    focusedBorder: _noBorder,
                    disabledBorder: _noBorder,
                    errorBorder: _noBorder,
                    focusedErrorBorder: _noBorder,
                    filled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: _addTag,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primaryForestGreen, size: 20),
                onPressed: () => _addTag(_tagController.text),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._inheritedTags.map((t) => _chip(t, inherited: true)),
            ..._tags.map((t) => _chip(t)),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, {bool inherited = false}) {
    return Opacity(
      opacity: inherited ? 0.7 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.backgroundObsidian,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(inherited ? Icons.lock_outline : Icons.sell_outlined,
                size: 13, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: inherited ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite)),
            if (!inherited) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => setState(() => _tags.remove(label)),
                child: const Icon(Icons.close, size: 14, color: AppColors.secondaryTextStoneGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
