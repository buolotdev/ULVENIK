import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen({super.key});

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Emergency Recall');
  final TextEditingController _notesController = TextEditingController(
      text: 'Use whistle pattern: 3 short bursts. Always reward with highest value treat (liver) and dynamic play. Do not overuse this cue in daily life to maintain its emergency impact.');
  final TextEditingController _tagController = TextEditingController();

  String _parentSkill = 'Recall Foundations';
  final List<String> _availableSkills = ['Basic Obedience', 'Recall Foundations', 'Agility'];
  final List<String> _tags = ['Safety', 'High Value Reward'];
  bool _hasCustomImage = true;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Exercise',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white12,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel('EXERCISE NAME'),
            const SizedBox(height: 8),
            _buildTextField(_nameController, 'e.g., Target Touch'),
            
            const SizedBox(height: 24),
            _buildLabel('PARENT SKILL'),
            const SizedBox(height: 8),
            _buildDropdown(),

            const SizedBox(height: 24),
            _buildLabel('EXERCISE IMAGE'),
            const SizedBox(height: 8),
            _buildImageSection(),

            const SizedBox(height: 24),
            _buildLabel('TAGS (OPTIONAL)'),
            const SizedBox(height: 8),
            _buildTagsSection(),

            const SizedBox(height: 24),
            _buildLabel('TRAINING NOTES'),
            const SizedBox(height: 8),
            _buildTextField(_notesController, 'Add notes...', maxLines: 4),

            const SizedBox(height: 40),
            _buildSaveButton(),
            const SizedBox(height: 16),
            _buildCancelButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.secondaryTextStoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.05,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _showSkillPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Parent Skill',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              for (final skill in _availableSkills)
                ListTile(
                  title: Text(skill, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                  trailing: _parentSkill == skill ? const Icon(Icons.check, color: AppColors.primaryForestGreen) : null,
                  onTap: () {
                    setState(() => _parentSkill = skill);
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown() {
    return GestureDetector(
      onTap: _showSkillPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _parentSkill,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
              color: AppColors.backgroundObsidian,
              image: _hasCustomImage
                  ? const DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAqfED1yR4MNlwfxQjsX1NiOvzwKl-PnfDSH0HN0-ky-NB4uHMPVILmbDnEvKiZrGMlc5lUMBbltsFeHWEg7-hK9ZtW1gxGFCMUTGvstXsIiacR3rAxLDmbyfu9ZQC2rMm8QoGweIvNu4JhsgrKndNsVV-_-NY6mEDGYS2eF-E_RvUdJPNlCGOxi0ai19mVF4PmvdgaPjZT2I8k_3t8FeeKmBJbL3gdCEgFwRHRCNt7PdySOkplDSc'),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !_hasCustomImage
                ? const Icon(Icons.image_outlined, color: AppColors.secondaryTextStoneGrey)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    AppSnackbar.show(context, message: 'Image picker coming soon', type: SnackbarType.info);
                    setState(() => _hasCustomImage = true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryForestGreen.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Replace Image',
                      style: TextStyle(
                        color: AppColors.primaryForestGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    setState(() => _hasCustomImage = false);
                  },
                  child: const Text(
                    'Remove Custom Image',
                    style: TextStyle(
                      color: Color(0xFFffb4ab), // Light red / error color
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTagsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: [
                for (final tag in _tags)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: const TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => _removeTag(tag),
                          child: const Icon(Icons.close, size: 14, color: AppColors.secondaryTextStoneGrey),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          if (_tags.isNotEmpty) const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            child: TextField(
              controller: _tagController,
              onSubmitted: _addTag,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Add tag...',
                hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        AppSnackbar.show(context, message: 'Changes saved successfully', type: SnackbarType.success);
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2e6b57), // primary-container
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Save Changes',
        style: TextStyle(
          color: Colors.white, // Changed to white as requested
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.white12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: AppColors.primaryTextOffWhite,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
