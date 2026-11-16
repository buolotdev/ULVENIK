import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/photo_picker.dart';

/// Edit Exercise (Training Tab v47): name, optional description, a read-only
/// Linked Skill card, Exercise Photo (replace / use the skill's photo),
/// Notes, and one full-width Save Changes. No tags and no bottom Cancel;
/// the back arrow leaves without applying edits.
class EditExerciseScreen extends StatefulWidget {
  final String exerciseName;
  final String skillName;
  final String description;
  final String notes;

  const EditExerciseScreen({
    super.key,
    this.exerciseName = 'Emergency Recall',
    this.skillName = 'Recall',
    this.description = '',
    this.notes =
        'Use whistle pattern: 3 short bursts. Always reward with highest value treat (liver) and dynamic play. Do not overuse this cue in daily life to maintain its emergency impact.',
  });

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  late final TextEditingController _name = TextEditingController(text: widget.exerciseName);
  late final TextEditingController _description = TextEditingController(text: widget.description);
  late final TextEditingController _notes = TextEditingController(text: widget.notes);
  bool _hasCustomImage = true;
  bool _saving = false;
  ImageProvider? _picked;
  String? _nameError;

  static const _customImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAqfED1yR4MNlwfxQjsX1NiOvzwKl-PnfDSH0HN0-ky-NB4uHMPVILmbDnEvKiZrGMlc5lUMBbltsFeHWEg7-hK9ZtW1gxGFCMUTGvstXsIiacR3rAxLDmbyfu9ZQC2rMm8QoGweIvNu4JhsgrKndNsVV-_-NY6mEDGYS2eF-E_RvUdJPNlCGOxi0ai19mVF4PmvdgaPjZT2I8k_3t8FeeKmBJbL3gdCEgFwRHRCNt7PdySOkplDSc';

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = 'Please enter an exercise name.');
      return;
    }
    _saving = true;
    AppSnackbar.show(context, message: 'Changes saved', type: SnackbarType.success);
    Navigator.pop(context, _name.text.trim());
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, fontWeight: FontWeight.w600));

  Widget _field(TextEditingController c, String hint, {int maxLines = 1, String? error}) => TextField(
        controller: c,
        minLines: 1,
        maxLines: maxLines,
        onChanged: (_) {
          if (_nameError != null) setState(() => _nameError = null);
        },
        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
          errorText: error,
          errorStyle: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5),
          filled: true,
          fillColor: AppColors.cardsCarbon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryForestGreen)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF8B3A3A))),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFB04A4A))),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit Exercise',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          tooltip: 'Back',
          icon: const UlvenikIcon(UlvenikIcons.back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          _label('Exercise Name'),
          const SizedBox(height: 8),
          _field(_name, 'e.g. Recall through distractions', error: _nameError),
          const SizedBox(height: 22),
          _label('Description (optional)'),
          const SizedBox(height: 8),
          _field(_description, 'Describe how this exercise is performed...', maxLines: 4),
          const SizedBox(height: 22),
          _label('Linked Skill'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(children: [
              const UlvenikIcon(UlvenikIcons.skills, size: 20, color: AppColors.secondarySage),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.skillName,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('This exercise belongs to ${widget.skillName}.',
                      style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 22),
          _label('Exercise Photo'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: _hasCustomImage
                      ? Image(
                          image: _picked ?? const NetworkImage(_customImage),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.backgroundObsidian))
                      : const ColoredBox(
                          color: AppColors.backgroundObsidian,
                          child: Icon(Icons.image_outlined, color: AppColors.secondaryTextStoneGrey)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_hasCustomImage ? 'Custom photo' : 'Using ${widget.skillName}’s photo',
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(spacing: 8, runSpacing: 4, children: [
                    OutlinedButton(
                      onPressed: () async {
                        final img = await pickPhoto(context);
                        if (img != null && mounted) {
                          setState(() {
                            _picked = img;
                            _hasCustomImage = true;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: const BorderSide(color: Colors.white24),
                        minimumSize: const Size(0, 36),
                      ),
                      child: const Text('Choose Different Photo', style: TextStyle(fontSize: 12.5)),
                    ),
                    if (_hasCustomImage)
                      TextButton(
                        onPressed: () => setState(() {
                          _hasCustomImage = false;
                          _picked = null;
                        }),
                        style: TextButton.styleFrom(foregroundColor: AppColors.secondaryTextStoneGrey, minimumSize: const Size(0, 36)),
                        child: const Text('Use Skill Photo', style: TextStyle(fontSize: 12.5)),
                      ),
                  ]),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 22),
          _label('Notes'),
          const SizedBox(height: 8),
          _field(_notes, 'Add notes...', maxLines: 5),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const UlvenikIcon(UlvenikIcons.save, size: 20),
              label: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryForestGreen,
                foregroundColor: AppColors.primaryTextOffWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
