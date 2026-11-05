import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class AddHealthRecordScreen extends StatefulWidget {
  final String? initialCategory;
  const AddHealthRecordScreen({super.key, this.initialCategory});

  @override
  State<AddHealthRecordScreen> createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _vetController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Medication specific controllers
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController(text: 'Once daily');
  final TextEditingController _instructionsController = TextEditingController();

  late String _category;
  bool _setReminder = false;
  String _reminderTiming = '1 hour before';

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _endDate;

  static const List<String> _categories = [
    'Weight',
    'Body Condition',
    'Medications',
    'Vaccinations',
    'Vet Visits',
    'Injuries',
    'Rehabilitation',
    'Supplements',
    'Documents',
    'Other Records',
  ];

  @override
  void initState() {
    super.initState();
    String raw = widget.initialCategory ?? 'Other Records';
    if (raw == 'Medication') raw = 'Medications';
    if (raw == 'Vaccine') raw = 'Vaccinations';
    if (_categories.contains(raw)) {
      _category = raw;
    } else {
      _category = 'Other Records';
    }

    if (_category == 'Medications') {
      _titleController.text = 'Metacam 1.5mg — Daily';
      _medNameController.text = 'Metacam';
      _dosageController.text = '1.5mg';
      _instructionsController.text = 'Give with food in the morning...';
      _notesController.text = 'Add any additional observations or notes here...';
    }
  }

  bool get _isFormValid => _titleController.text.isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _vetController.dispose();
    _notesController.dispose();
    _medNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _category = newValue;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, {bool isEndDate = false}) async {
    final DateTime initial = isEndDate ? (_endDate ?? DateTime.now()) : _selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2e6b57),
              onPrimary: Colors.white,
              surface: AppColors.cardsCarbon,
              onSurface: AppColors.primaryTextOffWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isEndDate) {
          _endDate = picked;
        } else {
          _selectedDate = picked;
        }
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
              surface: AppColors.cardsCarbon,
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
    final bool isMed = _category == 'Medications';

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
        title: Text(
          isMed ? 'ADD RECORD' : 'Add Health Record',
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isFormValid
                ? () {
                    final nav = Navigator.of(context);
                    AppSnackbar.show(context, message: 'Health Record Saved', type: SnackbarType.success);
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) nav.pop();
                    });
                  }
                : null,
            style: TextButton.styleFrom(
              foregroundColor: _isFormValid ? const Color(0xFF2e6b57) : AppColors.secondaryTextStoneGrey.withValues(alpha: 0.5),
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
              _buildRecordInfoSection(isMed),
              if (isMed) ...[
                const SizedBox(height: 24),
                _buildMedicationDetailsSection(),
              ],
              const SizedBox(height: 24),
              _buildNotesSection(),
              const SizedBox(height: 24),
              _buildAttachmentsSection(),
              const SizedBox(height: 24),
              _buildReminderSection(isMed),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordInfoSection(bool isMed) {
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
            hint: isMed ? 'e.g. Metacam 1.5mg — Daily' : 'e.g. Annual Checkup',
            controller: _titleController,
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 16),
          if (isMed) ...[
            // User requested: If Medication is selected before reaching this form,
            // simply show Medication as the selected record type without Vaccine and Weight chips.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2e6b57).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2e6b57)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UlvenikIcon(UlvenikIcons.health, size: 14, color: Color(0xFF95d3bb)),
                      SizedBox(width: 6),
                      Text(
                        'Medications',
                        style: TextStyle(
                          color: Color(0xFF95d3bb),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.check, size: 14, color: Color(0xFF95d3bb)),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            _buildDropdownField(
              label: 'CATEGORY',
              value: _category,
              items: _categories,
              icon: Icons.folder_outlined,
              onChanged: _onCategoryChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDatePicker(label: 'DATE *')),
                const SizedBox(width: 16),
                Expanded(child: _buildTimePicker()),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'VETERINARIAN (OPTIONAL)',
              hint: 'Clinic or Doctor Name',
              controller: _vetController,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicationDetailsSection() {
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
            'MEDICATION DETAILS',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Medication Name',
            hint: 'e.g. Metacam',
            controller: _medNameController,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Dosage',
            hint: 'e.g. 1.5mg',
            controller: _dosageController,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Frequency',
            value: _frequencyController.text.isEmpty ? 'Once daily' : _frequencyController.text,
            items: const ['Once daily', 'Twice daily', 'Three times daily', 'Every 8 hours', 'Every 12 hours', 'As needed'],
            onChanged: (val) {
              if (val != null) setState(() => _frequencyController.text = val);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDatePicker(label: 'Start Date')),
              const SizedBox(width: 16),
              Expanded(child: _buildOptionalEndDatePicker()),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Instructions',
            hint: 'e.g. Give with food in the morning...',
            controller: _instructionsController,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalEndDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'End Date (Optional)',
          style: TextStyle(
            color: AppColors.secondaryTextStoneGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, isEndDate: true),
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
                  _endDate == null
                      ? 'mm/dd/yyyy'
                      : '${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.day.toString().padLeft(2, '0')}/${_endDate!.year}',
                  style: TextStyle(
                    color: _endDate == null ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                    fontSize: 14,
                  ),
                ),
                const UlvenikIcon(UlvenikIcons.calendar, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
        ),
      ],
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
          InkWell(
            onTap: () => AppSnackbar.show(context, message: 'Upload documents or photos coming soon', type: SnackbarType.info),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file_outlined, color: AppColors.secondaryTextStoneGrey, size: 28),
                  SizedBox(height: 8),
                  Text(
                    'Add photos or documents',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildAttachmentButton(Icons.image_outlined, 'Photos')),
              const SizedBox(width: 12),
              Expanded(child: _buildAttachmentButton(Icons.videocam_outlined, 'Videos')),
              const SizedBox(width: 12),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundObsidian,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UlvenikIcon.fromMaterial(icon, color: AppColors.secondaryTextStoneGrey, size: 20),
            const SizedBox(height: 6),
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

  Widget _buildReminderSection(bool isMed) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMed ? 'Enable Reminders' : 'Set Reminder',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isMed ? 'Get notified before next dose' : 'Get notified for follow-up',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _setReminder,
                onChanged: (bool value) {
                  setState(() {
                    _setReminder = value;
                  });
                },
                activeThumbColor: const Color(0xFF95d3bb),
                activeTrackColor: const Color(0xFF2e6b57),
              ),
            ],
          ),
          if (isMed && _setReminder) ...[
            const SizedBox(height: 12),
            const Text(
              'Notify me:',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['At time of dose', '1 hour before', '1 day before'].map((opt) {
                final selected = _reminderTiming == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: selected,
                  onSelected: (val) {
                    if (val) setState(() => _reminderTiming = opt);
                  },
                  selectedColor: const Color(0xFF2e6b57),
                  backgroundColor: AppColors.backgroundObsidian,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                  ),
                  side: BorderSide(color: selected ? const Color(0xFF95d3bb) : Colors.white12),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isFormValid
            ? () {
                final nav = Navigator.of(context);
                AppSnackbar.show(context, message: 'Health Record Saved', type: SnackbarType.success);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) nav.pop();
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid ? const Color(0xFF2e6b57) : AppColors.cardsCarbon,
          foregroundColor: _isFormValid ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
          disabledBackgroundColor: AppColors.cardsCarbon,
          disabledForegroundColor: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: _isFormValid ? Colors.transparent : Colors.white12),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.save_outlined, size: 18),
        label: const Text('Save Health Record', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

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
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              dropdownColor: AppColors.cardsCarbon,
              icon: const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey),
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        UlvenikIcon.fromMaterial(icon, size: 20, color: AppColors.secondaryTextStoneGrey),
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

  Widget _buildDatePicker({required String label}) {
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
                  '${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                ),
                const UlvenikIcon(UlvenikIcons.calendar, color: AppColors.secondaryTextStoneGrey, size: 20),
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
                const UlvenikIcon(UlvenikIcons.trainingTime, color: AppColors.secondaryTextStoneGrey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
