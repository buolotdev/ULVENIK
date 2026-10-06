import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  String _selectedCategory = 'Training';
  bool _isAutomaticTracking = true;
  int _targetCount = 20;
  String _selectedPriority = 'Medium';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Goal',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AppSnackbar.show(context, message: 'Goal saved', type: SnackbarType.success);
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildCategorySection(),
            const SizedBox(height: 24),
            _buildTrackingModeSection(),
            const SizedBox(height: 24),
            _buildTargetSection(),
            const SizedBox(height: 24),
            _buildLinkRecordButton(),
            const SizedBox(height: 24),
            _buildPrioritySection(),
            const SizedBox(height: 24),
            _buildSettingsList(),
            const SizedBox(height: 24),
            _buildNotesSection(),
            const SizedBox(height: 100), // padding for bottom button
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              AppSnackbar.show(context, message: 'Goal created!', type: SnackbarType.success);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e6b57), // primary container
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text(
              'Save Goal',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GOAL TITLE', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'e.g. Complete 20 Recall Sessions',
              hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
          const Divider(color: Colors.white12, height: 16),
          const SizedBox(height: 8),
          const Text('DESCRIPTION', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Add details...',
              hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CATEGORY', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip('Training', _selectedCategory == 'Training', (val) => setState(() => _selectedCategory = 'Training')),
              _buildChoiceChip('S&C', _selectedCategory == 'S&C', (val) => setState(() => _selectedCategory = 'S&C')),
              _buildChoiceChip('Health', _selectedCategory == 'Health', (val) => setState(() => _selectedCategory = 'Health')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, ValueChanged<bool> onSelected) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2e6b57) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF2e6b57) : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingModeSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isAutomaticTracking = true),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Color(0xFF95d3bb), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Automatic', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
                        Text('Track based on logged sessions', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(
                    _isAutomaticTracking ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: _isAutomaticTracking ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isAutomaticTracking = false),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.pan_tool_outlined, color: AppColors.secondaryTextStoneGrey, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Manual', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
                        Text('Manually update progress', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(
                    !_isAutomaticTracking ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: !_isAutomaticTracking ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TARGET', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Training Sessions', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
                Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Count', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_targetCount > 0) setState(() => _targetCount--);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundObsidian,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.remove, color: AppColors.secondaryTextStoneGrey, size: 18),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '$_targetCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _targetCount++),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundObsidian,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.add, color: AppColors.secondaryTextStoneGrey, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRecordButton() {
    return GestureDetector(
      onTap: () {
        AppSnackbar.show(context, message: 'Link record coming soon', type: SnackbarType.info);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Color(0xFF2e6b57), size: 18),
            SizedBox(width: 8),
            Text('Link a Record', style: TextStyle(color: Color(0xFF2e6b57), fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRIORITY', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip('High', _selectedPriority == 'High', (val) => setState(() => _selectedPriority = 'High')),
              _buildChoiceChip('Medium', _selectedPriority == 'Medium', (val) => setState(() => _selectedPriority = 'Medium')),
              _buildChoiceChip('Low', _selectedPriority == 'Low', (val) => setState(() => _selectedPriority = 'Low')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSettingsTile(icon: Icons.calendar_today, label: 'Due Date', value: 'Optional'),
          const Divider(color: Colors.white12, height: 1),
          _buildSettingsTile(icon: Icons.notifications_none, label: 'Reminder', value: 'None'),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String label, required String value}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 20),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
              ],
            ),
            Row(
              children: [
                Text(value, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NOTES', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
          const SizedBox(height: 4),
          TextField(
            controller: _notesController,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Additional details...',
              hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
