import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class CreateGoalScreen extends StatefulWidget {
  final String? initialDogName;
  final bool initialIsClientDog;
  final bool hasSportPack;
  final bool hasTrainerPack;

  const CreateGoalScreen({
    super.key,
    this.initialDogName,
    this.initialIsClientDog = false,
    this.hasSportPack = true,
    this.hasTrainerPack = true,
  });

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  late String _selectedDog;
  late bool _isClientDog;
  late bool _hasSportPack;
  late bool _hasTrainerPack;

  String _selectedCategory = 'Training';
  bool _isAutomaticTracking = true;
  int _targetCount = 20;
  String _selectedPriority = 'Medium';

  final List<Map<String, dynamic>> _availableDogs = [
    {'name': 'Arlo', 'breed': 'German Shepherd', 'isClient': false},
    {'name': 'Nova', 'breed': 'Belgian Malinois', 'isClient': false},
    {'name': 'Murphy', 'breed': 'Golden Retriever', 'isClient': true},
    {'name': 'Bella', 'breed': 'Dutch Shepherd', 'isClient': true},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDog = widget.initialDogName ?? 'Arlo';
    _isClientDog = widget.initialIsClientDog;
    _hasSportPack = widget.hasSportPack;
    _hasTrainerPack = widget.hasTrainerPack;
  }

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
          icon: const UlvenikIcon(UlvenikIcons.back, size: 20, color: AppColors.primaryTextOffWhite),
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
            _buildDogSelector(),
            const SizedBox(height: 24),
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

  void _showDogPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text('Select Dog for Goal',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Trainer Pack allows managing goals for both your own dogs and client dogs.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              const SizedBox(height: 16),
              const Text('MY DOGS', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              ..._availableDogs.where((d) => !(d['isClient'] as bool)).map((d) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(d['name'] as String, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w500)),
                    subtitle: Text(d['breed'] as String, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                    trailing: _selectedDog == d['name'] ? const Icon(Icons.check, color: AppColors.primaryForestGreen) : null,
                    onTap: () {
                      setState(() {
                        _selectedDog = d['name'] as String;
                        _isClientDog = false;
                      });
                      Navigator.pop(ctx);
                    },
                  )),
              if (_hasTrainerPack) ...[
                const SizedBox(height: 12),
                const Text('CLIENT DOGS (TRAINER PACK)', style: TextStyle(color: Color(0xFFD99B4B), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                ..._availableDogs.where((d) => d['isClient'] as bool).map((d) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(d['name'] as String, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w500)),
                      subtitle: Text('${d['breed']} • Client Dog', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      trailing: _selectedDog == d['name'] ? const Icon(Icons.check, color: Color(0xFFD99B4B)) : null,
                      onTap: () {
                        setState(() {
                          _selectedDog = d['name'] as String;
                          _isClientDog = true;
                        });
                        Navigator.pop(ctx);
                      },
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDogSelector() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('DOG', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.05)),
              if (_hasTrainerPack)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySage.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('TRAINER PACK', style: TextStyle(color: AppColors.secondarySage, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _showDogPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _isClientDog ? const Color(0xFFD99B4B).withValues(alpha: 0.2) : AppColors.primaryForestGreen.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _selectedDog.isNotEmpty ? _selectedDog[0] : '?',
                        style: TextStyle(
                          color: _isClientDog ? const Color(0xFFD99B4B) : AppColors.primaryForestGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedDog, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(_isClientDog ? 'Client Dog · Trainer Pack' : 'My Dog · Core', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 20),
                ],
              ),
            ),
          ),
        ],
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
              if (_hasSportPack)
                _buildChoiceChip('Sport', _selectedCategory == 'Sport', (val) => setState(() => _selectedCategory = 'Sport')),
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
                        Text('Track based on recorded sessions', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                        SizedBox(height: 2),
                        Text('Calculates objective progress from your recorded sessions only, never automated judging.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                  UlvenikIcon.fromMaterial(
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
                  UlvenikIcon.fromMaterial(
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
                UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
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
                      child: const UlvenikIcon(UlvenikIcons.add, color: AppColors.secondaryTextStoneGrey, size: 18),
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
            UlvenikIcon(UlvenikIcons.add, color: Color(0xFF2e6b57), size: 18),
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
                UlvenikIcon.fromMaterial(icon, color: AppColors.secondaryTextStoneGrey, size: 20),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14)),
              ],
            ),
            Row(
              children: [
                Text(value, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                const SizedBox(width: 4),
                const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey, size: 20),
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
