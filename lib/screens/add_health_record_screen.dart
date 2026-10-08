import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class AddHealthRecordScreen extends StatefulWidget {
  const AddHealthRecordScreen({super.key});

  @override
  State<AddHealthRecordScreen> createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _vetController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Medication specific controllers
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();

  String _category = 'General Health';
  String _status = 'Completed';
  bool _setReminder = false;
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  bool get _isFormValid => _titleController.text.isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _vetController.dispose();
    _notesController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _category = newValue;
      });
    }
  }

  void _onStatusChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _status = newValue;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2e6b57),
              onPrimary: Colors.white,
              surface: AppColors.surfaceCarbon,
              onSurface: AppColors.primaryTextOffWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2e6b57),
              onPrimary: Colors.white,
              surface: AppColors.surfaceCarbon,
              onSurface: AppColors.primaryTextOffWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.secondaryTextStoneGrey),
          child: const Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        title: const Text(
          'Add Health Record',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isFormValid ? () {
              AppSnackbar.show(context, message: 'Health Record Saved', type: SnackbarType.success);
              Future.delayed(const Duration(seconds: 1), () => Navigator.of(context).pop());
            } : null,
            style: TextButton.styleFrom(
              foregroundColor: _isFormValid ? const Color(0xFF2e6b57) : AppColors.secondaryTextStoneGrey.withOpacity(0.5),
            ),
            child: const Text('Save', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRecordInfoSection(),
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 24),
              _buildAttachmentsSection(),
              const SizedBox(height: 24),
              _buildReminderSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'RECORD TITLE *',
            hint: 'e.g. Annual Checkup',
            controller: _titleController,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'CATEGORY',
            value: _category,
            items: ['General Health', 'Vaccination', 'Injury/Illness', 'Medication'],
            icon: Icons.favorite_border,
            onChanged: _onCategoryChanged,
          ),
          
          // Inject Medication specific fields if Medication is selected
          if (_category == 'Medication') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'DOSAGE',
                    hint: 'e.g. 1.5mg',
                    controller: _dosageController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'FREQUENCY',
                    hint: 'e.g. Daily',
                    controller: _frequencyController,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimePicker(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'STATUS',
            value: _status,
            items: ['Completed', 'Scheduled', 'Pending Results'],
            onChanged: _onStatusChanged,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'VETERINARIAN',
            hint: 'Clinic or Doctor Name',
            controller: _vetController,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOTES',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 4,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Add any details, observations, or instructions...',
              hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
              filled: true,
              fillColor: AppColors.backgroundObsidian,
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2e6b57)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATTACHMENTS',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildAttachmentButton(Icons.image_outlined, 'Photos')),
              const SizedBox(width: 16),
              Expanded(child: _buildAttachmentButton(Icons.videocam_outlined, 'Videos')),
              const SizedBox(width: 16),
              Expanded(child: _buildAttachmentButton(Icons.description_outlined, 'Docs')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label) {
    return InkWell(
      onTap: () => AppSnackbar.show(context, message: 'Select $label functionality coming soon', type: SnackbarType.info),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.backgroundObsidian,
          border: Border.all(color: Colors.white12, style: BorderStyle.solid), // Dashed border not natively supported easily without custom painter, using solid for now
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondaryTextStoneGrey, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Reminder',
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Get notified for follow-up',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          CupertinoSwitch(
            value: _setReminder,
            activeColor: const Color(0xFF2e6b57),
            trackColor: AppColors.backgroundObsidian,
            onChanged: (val) {
              setState(() {
                _setReminder = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormValid ? () {
          AppSnackbar.show(context, message: 'Health Record Saved', type: SnackbarType.success);
          Future.delayed(const Duration(seconds: 1), () => Navigator.of(context).pop());
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? const Color(0xFF2e6b57) : AppColors.surfaceCarbon,
          foregroundColor: _isFormValid ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
          disabledBackgroundColor: AppColors.surfaceCarbon,
          disabledForegroundColor: AppColors.secondaryTextStoneGrey.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _isFormValid ? Colors.transparent : Colors.white12),
          ),
          elevation: 0,
        ),
        child: const Text('Save Health Record', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

  // Helper widgets for form fields

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.secondaryTextStoneGrey),
            filled: true,
            fillColor: AppColors.backgroundObsidian,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2e6b57)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    IconData? icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.backgroundObsidian,
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surfaceCarbon,
              icon: const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 20, color: AppColors.secondaryTextStoneGrey),
                        const SizedBox(width: 8),
                      ],
                      Text(item),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DATE *',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.year}",
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                ),
                const Icon(Icons.calendar_month_outlined, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TIME',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.backgroundObsidian,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                ),
                const Icon(Icons.schedule_outlined, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
