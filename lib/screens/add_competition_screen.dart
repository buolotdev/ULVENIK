import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'sport_pack_overview_screen.dart';

class AddCompetitionScreen extends StatefulWidget {
  const AddCompetitionScreen({super.key});

  @override
  State<AddCompetitionScreen> createState() => _AddCompetitionScreenState();
}

class _AddCompetitionScreenState extends State<AddCompetitionScreen> {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _card = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _stone = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _mutedHint = Color(0xFF6E7772);
  static const Color _border = AppColors.cardBorder; // rgba(255,255,255,0.08)
  static const Color _underlineColor = Color(0x2EFFFFFF);

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _venueCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _clubCtrl = TextEditingController();
  final TextEditingController _judgesCtrl = TextEditingController();
  final TextEditingController _classDivisionCtrl = TextEditingController();
  final TextEditingController _entryNumberCtrl = TextEditingController();
  final TextEditingController _handlerCtrl = TextEditingController();
  final TextEditingController _weatherManualCtrl = TextEditingController();
  final TextEditingController _eventCategoryCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  String? _selectedSport;
  String _selectedDogName = 'Milo';
  String _selectedDogBreed = 'Belgian Malinois';
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCountry;

  bool _weatherAutoDetect = true;
  String _selectedStatus = 'Upcoming';
  bool _statusManuallyOverridden = false;

  final List<String> _linkedGoals = [];
  final List<String> _selectedEquipment = [];
  final List<String> _attachedPhotos = [];
  final List<String> _attachedVideos = [];
  final List<String> _attachedDocuments = [];

  bool _reminderEnabled = false;
  String _reminderLeadTime = '1 Day Before · 08:00';
  String? _validationError;

  static const List<(String, String)> _dogOptions = [
    ('Milo', 'Belgian Malinois'),
    ('Zeus', 'Belgian Malinois'),
    ('Freja', 'Dutch Shepherd'),
    ('Koda', 'German Shepherd'),
  ];

  static const List<String> _sportOptions = [
    'IGP',
    'Agility',
    'PSA',
    'Obedience',
    'Mondioring',
    'Tracking',
    'Nosework',
  ];

  static const List<String> _countryOptions = [
    'United Kingdom',
    'Denmark',
    'Sweden',
    'Germany',
    'Netherlands',
    'Belgium',
    'United States',
  ];

  static const List<String> _statusOptions = [
    'Upcoming',
    'Completed',
    'Withdrawn',
    'Cancelled',
  ];

  static const List<String> _goalLibrary = [
    'IGP 2 Qualification (270+ pts)',
    'Phase A Clean Corners & 3 Articles (95+ pts)',
    'Zero Faults Clear Agility Round',
    'Phase C Instant Out & Calm Guarding',
    'Top 3 Regional Podium Placement',
  ];

  static const List<String> _equipmentLibrary = [
    '10m Biothane Tracking Line',
    'FCI Regulation Tracking Articles (3x)',
    '2kg Hardwood Obedience Dumbbell',
    'Fur Saver Official Trial Collar',
    'Official Scorebook & Microchip Folder',
    'Portable Crate & Shade Aluminet',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_onFieldChanged);
    _venueCtrl.addListener(_onFieldChanged);
    _notesCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {
        if (_validationError != null && _isFormReady) {
          _validationError = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _addressCtrl.dispose();
    _clubCtrl.dispose();
    _judgesCtrl.dispose();
    _classDivisionCtrl.dispose();
    _entryNumberCtrl.dispose();
    _handlerCtrl.dispose();
    _weatherManualCtrl.dispose();
    _eventCategoryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _isFormReady =>
      _nameCtrl.text.trim().isNotEmpty &&
      _selectedSport != null &&
      _selectedDate != null;

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String get _computedAutoWeather {
    if (_selectedDate == null &&
        _venueCtrl.text.trim().isEmpty &&
        _selectedCountry == null) {
      return 'Awaiting event date & location';
    }
    if (_selectedDate == null) {
      return 'Select competition date for forecast';
    }
    final loc = _venueCtrl.text.trim().isNotEmpty
        ? _venueCtrl.text.trim()
        : (_selectedCountry ?? 'Trial Venue');
    final month = _selectedDate!.month;
    if (month >= 5 && month <= 8) {
      return '18°C · Dry & Partly Sunny · 9 km/h W ($loc)';
    } else if (month >= 9 && month <= 11) {
      return '13°C · Crisp Overcast · 14 km/h NW ($loc)';
    }
    return '8°C · Cool Field Conditions · 11 km/h E ($loc)';
  }

  void _updateStatusFromDate(DateTime picked) {
    if (_statusManuallyOverridden) return;
    final now = DateTime(2026, 9, 16);
    final dayOnly = DateTime(picked.year, picked.month, picked.day);
    if (!dayOnly.isBefore(now)) {
      _selectedStatus = 'Upcoming';
    }
    // A competition is not automatically marked as Completed purely because the date has passed.
    // Upcoming updates automatically, but Completed, Withdrawn, and Cancelled reflect user records/selections.
  }

  Future<void> _pickDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2026, 10, 18),
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _forest,
            onPrimary: _offWhite,
            surface: _card,
            onSurface: _offWhite,
          ),
        ),
        child: child!,
      ),
    );
    if (chosen != null) {
      setState(() {
        _selectedDate = chosen;
        _updateStatusFromDate(chosen);
        if (_validationError != null && _isFormReady) {
          _validationError = null;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart
        ? (_startTime ?? const TimeOfDay(hour: 8, minute: 30))
        : (_endTime ?? const TimeOfDay(hour: 15, minute: 30));
    final chosen = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _forest,
            onPrimary: _offWhite,
            surface: _card,
            onSurface: _offWhite,
          ),
        ),
        child: child!,
      ),
    );
    if (chosen != null) {
      setState(() {
        if (isStart) {
          _startTime = chosen;
        } else {
          _endTime = chosen;
        }
      });
    }
  }

  void _submitCompetition() {
    if (!_isFormReady) {
      final missing = <String>[
        if (_nameCtrl.text.trim().isEmpty) 'Competition Name',
        if (_selectedSport == null) 'Sport',
        if (_selectedDate == null) 'Date',
      ];
      setState(() {
        _validationError =
            'Required fields missing: ${missing.join(', ')}.';
      });
      AppSnackbar.show(
        context,
        title: 'Complete Required Fields',
        message: 'Please provide ${missing.join(', ')} to create this competition.',
        type: SnackbarType.warning,
      );
      return;
    }

    final storeStatus = _selectedStatus == 'Upcoming'
        ? 'Entered'
        : (_selectedStatus == 'In Progress' ? 'Entered' : _selectedStatus);
    final locationParts = <String>[
      if (_venueCtrl.text.trim().isNotEmpty) _venueCtrl.text.trim(),
      ?_selectedCountry,
    ];

    final created = SportCompetitionModel(
      id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
      title: _nameCtrl.text.trim(),
      sportTag: _selectedSport!,
      level: _classDivisionCtrl.text.trim().isNotEmpty
          ? _classDivisionCtrl.text.trim()
          : '${_selectedSport!} Open',
      date: _formatDate(_selectedDate!),
      location:
          locationParts.isEmpty ? 'Location TBC' : locationParts.join(', '),
      status: storeStatus,
      judge: _judgesCtrl.text.trim().isNotEmpty
          ? _judgesCtrl.text.trim()
          : 'Judge TBC',
      organisation: _clubCtrl.text.trim().isNotEmpty
          ? _clubCtrl.text.trim()
          : _selectedSport!,
      notes: _notesCtrl.text.trim(),
    );

    final store = SportPackStore.instance;
    store.competitions.insert(0, created);
    store.recentActivities.insert(
      0,
      SportActivityItem(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        icon: Icons.add,
        title: 'Competition added',
        sportTag: created.sportTag,
        timeAgo: 'Just now',
        detailSummary:
            '${created.title} (${created.date} · $_selectedDogName) marked as $_selectedStatus.',
      ),
    );
    store.selectDog(store.selectedDogIndex);

    AppSnackbar.show(
      context,
      title: 'Competition Created',
      message:
          '${created.title} (${created.date}) added for $_selectedDogName.',
      type: SnackbarType.success,
    );
    Navigator.of(context).maybePop(created);
  }

  @override
  Widget build(BuildContext context) {
    final ready = _isFormReady;
    final notesCount = _notesCtrl.text.length;

    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(
              color: _bg,
              border: Border(top: BorderSide(color: _border, width: 1)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitCompetition,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ready ? _forest : _forest.withValues(alpha: 0.36),
                  foregroundColor:
                      ready ? _offWhite : _stone.withValues(alpha: 0.8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Create Competition',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: ready ? FontWeight.w700 : FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          const UlvenikBottomNav(activeTab: UlvenikNavTab.dogs),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopHeader(ready),
            Container(height: 1, color: _border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_validationError != null) ...[
                      _buildValidationBanner(),
                      const SizedBox(height: 14),
                    ],
                    _buildSectionTitle('COMPETITION INFORMATION'),
                    const SizedBox(height: 10),
                    _buildCompetitionInformationCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('STATUS'),
                    const SizedBox(height: 10),
                    _buildStatusCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('COMPETITION TYPE'),
                    const SizedBox(height: 10),
                    _buildCompetitionTypeCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('GOALS'),
                    const SizedBox(height: 10),
                    _buildGoalsCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('EQUIPMENT USED'),
                    const SizedBox(height: 10),
                    _buildEquipmentCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('MEDIA'),
                    const SizedBox(height: 10),
                    _buildMediaCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('NOTES'),
                    const SizedBox(height: 10),
                    _buildNotesCard(notesCount),
                    const SizedBox(height: 22),
                    _buildSectionTitle('REMINDER'),
                    const SizedBox(height: 10),
                    _buildReminderCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool ready) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _stone,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const Text(
            'Add Competition',
            style: TextStyle(
              color: _offWhite,
              fontSize: 17.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: _submitCompetition,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Save',
                style: TextStyle(
                  color: ready
                      ? const Color(0xFF3E8E72)
                      : _forest.withValues(alpha: 0.55),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorDestructive.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE07A7A).withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
            color: Color(0xFFE07A7A),
            size: 18,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              _validationError!,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 12.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _nameCtrl.text = 'Regional Agility Trial 2026';
                _selectedSport = 'Agility';
                _selectedDate = DateTime(2026, 11, 8);
                _venueCtrl.text = 'Warwickshire Equestrian Centre';
                _selectedCountry = 'United Kingdom';
                _eventCategoryCtrl.text = 'Regional Qualification Trial';
                _validationError = null;
              });
            },
            child: const Text(
              'Quick Fill',
              style: TextStyle(
                color: _mint,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: _stone,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.15,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildCompetitionInformationCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelRow(
            icon: Icons.emoji_events_outlined,
            label: 'Competition Name',
            requiredField: true,
          ),
          _buildUnderlineTextField(
            controller: _nameCtrl,
            hint: 'e.g. Regional Agility Trial 2026',
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.sell_outlined,
            label: 'Sport',
            requiredField: true,
          ),
          _buildUnderlinePickerRow(
            valueText: _selectedSport,
            placeholder: 'Select sport',
            onTap: _openSportPicker,
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.pets_outlined,
            label: 'Dog',
            requiredField: true,
          ),
          _buildDogPickerRow(),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            requiredField: true,
          ),
          _buildUnderlinePickerRow(
            valueText:
                _selectedDate != null ? _formatDate(_selectedDate!) : null,
            placeholder: 'Select date',
            onTap: _pickDate,
          ),
          _buildRowGapDivider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelRow(
                      icon: Icons.access_time_rounded,
                      label: 'Start Time',
                      fontSize: 13.5,
                    ),
                    _buildUnderlinePickerRow(
                      valueText:
                          _startTime != null ? _formatTime(_startTime!) : null,
                      placeholder: 'Optional',
                      showChevron: false,
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelRow(
                      icon: Icons.access_time_rounded,
                      label: 'End Time',
                      fontSize: 13.5,
                    ),
                    _buildUnderlinePickerRow(
                      valueText:
                          _endTime != null ? _formatTime(_endTime!) : null,
                      placeholder: 'Optional',
                      showChevron: false,
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.location_on_outlined,
            label: 'Venue',
          ),
          _buildUnderlineTextField(
            controller: _venueCtrl,
            hint: 'Venue name',
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.home_outlined,
            label: 'Address',
          ),
          _buildUnderlineTextField(
            controller: _addressCtrl,
            hint: 'Address',
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.outlined_flag_rounded,
            label: 'Country',
          ),
          _buildUnderlinePickerRow(
            valueText: _selectedCountry,
            placeholder: 'Select country',
            onTap: _openCountryPicker,
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.groups_outlined,
            label: 'Organising Club',
          ),
          _buildUnderlineTextField(
            controller: _clubCtrl,
            hint: 'Club name',
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.view_in_ar_outlined,
            label: 'Judge(s)',
          ),
          _buildUnderlineTextField(
            controller: _judgesCtrl,
            hint: 'Judge name(s)',
          ),
          _buildRowGapDivider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelRow(
                      icon: Icons.tag_rounded,
                      label: 'Class / Division',
                      fontSize: 13.5,
                    ),
                    _buildUnderlineTextField(
                      controller: _classDivisionCtrl,
                      hint: 'e.g. Open, Novice',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelRow(
                      icon: Icons.tag_rounded,
                      label: 'Entry Number',
                      fontSize: 13.5,
                    ),
                    _buildUnderlineTextField(
                      controller: _entryNumberCtrl,
                      hint: 'Your entry number',
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildRowGapDivider(),
          _buildLabelRow(
            icon: Icons.person_outline_rounded,
            label: 'Handler',
          ),
          _buildUnderlineTextField(
            controller: _handlerCtrl,
            hint: 'Handler name',
          ),
          _buildRowGapDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabelRow(
                icon: Icons.cloud_outlined,
                label: 'Weather',
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _weatherAutoDetect = !_weatherAutoDetect;
                    if (!_weatherAutoDetect &&
                        _weatherManualCtrl.text.isEmpty &&
                        _selectedDate != null) {
                      _weatherManualCtrl.text = _computedAutoWeather;
                    }
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UlvenikIcon.fromMaterial(
                      _weatherAutoDetect
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_rounded,
                      color: _weatherAutoDetect ? _mutedHint : _mint,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _weatherAutoDetect ? 'Auto-detect' : 'Manual',
                      style: TextStyle(
                        color: _weatherAutoDetect ? _mutedHint : _mint,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_weatherAutoDetect)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 9),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _underlineColor, width: 1),
                ),
              ),
              child: Text(
                _computedAutoWeather,
                style: TextStyle(
                  color: _selectedDate != null ? _offWhite : _mutedHint,
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                ),
              ),
            )
          else
            _buildUnderlineTextField(
              controller: _weatherManualCtrl,
              hint: 'e.g. 15°C · Light Breeze · Dry Turf',
            ),
          const SizedBox(height: 8),
          const Text(
            'Captured automatically when available',
            style: TextStyle(
              color: _mutedHint,
              fontSize: 11.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelRow({
    required IconData icon,
    required String label,
    bool requiredField = false,
    double fontSize = 14.2,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UlvenikIcon.fromMaterial(icon, color: _stone, size: 15.5),
        const SizedBox(width: 8),
        Flexible(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: _offWhite,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
              children: requiredField
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Color(0xFF3E8E72),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ]
                  : const [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnderlineTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: _offWhite,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: const TextStyle(
          color: _mutedHint,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        contentPadding: const EdgeInsets.only(top: 10, bottom: 9),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _underlineColor, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _forest, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildUnderlinePickerRow({
    required String? valueText,
    required String placeholder,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 9),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _underlineColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                valueText ?? placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valueText != null ? _offWhite : _mutedHint,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (showChevron)
              const Icon(Icons.keyboard_arrow_down_rounded,
                color: _stone,
                size: 19,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDogPickerRow() {
    return InkWell(
      onTap: _openDogPicker,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 9),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: _underlineColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: _selectedDogName,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    TextSpan(
                      text: '  ($_selectedDogBreed)',
                      style: const TextStyle(
                        color: _stone,
                        fontSize: 12.8,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
              color: _stone,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowGapDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(height: 1, color: _border),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusOptions.map((st) {
                final active = _selectedStatus == st;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStatus = st;
                        _statusManuallyOverridden = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? _forest.withValues(alpha: 0.22)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active
                              ? const Color(0xFF3E8E72)
                              : _border,
                        ),
                      ),
                      child: Text(
                        st,
                        style: TextStyle(
                          color: active
                              ? const Color(0xFF5BAE8E)
                              : _stone,
                          fontSize: 12.5,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Upcoming updates automatically by date · Completed, Withdrawn and Cancelled reflect user records',
            style: TextStyle(
              color: _mutedHint,
              fontSize: 11.8,
              fontStyle: FontStyle.italic,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionTypeCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelRow(
            icon: Icons.sell_outlined,
            label: 'Event Category',
          ),
          _buildUnderlineTextField(
            controller: _eventCategoryCtrl,
            hint: 'e.g. Trial, Championship, Fun Match',
          ),
          const SizedBox(height: 10),
          const Text(
            'Enter any competition type — Trial, Championship, Club Competition, Qualification Event, etc.',
            style: TextStyle(
              color: _mutedHint,
              fontSize: 12,
              height: 1.42,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _openGoalsSheet,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const UlvenikIcon(UlvenikIcons.goals,
                    color: _stone,
                    size: 17,
                  ),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Text(
                      'Link Goals',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const UlvenikIcon(UlvenikIcons.details,
                    color: _stone,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openGoalsSheet,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: Colors.white.withValues(alpha: 0.14),
                radius: 10,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: _linkedGoals.isEmpty ? 15 : 10,
                ),
                child: _linkedGoals.isEmpty
                    ? const Center(
                        child: Text(
                          'No goals linked yet',
                          style: TextStyle(
                            color: _mutedHint,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _linkedGoals
                            .map(
                              (g) => _buildRemovableChip(
                                label: g,
                                onRemove: () =>
                                    setState(() => _linkedGoals.remove(g)),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _openEquipmentSheet,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const UlvenikIcon(UlvenikIcons.exercises,
                    color: _stone,
                    size: 16,
                  ),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Equipment',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Select from your Equipment Library',
                          style: TextStyle(
                            color: _mutedHint,
                            fontSize: 12.2,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const UlvenikIcon(UlvenikIcons.details,
                    color: _stone,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openEquipmentSheet,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: Colors.white.withValues(alpha: 0.14),
                radius: 10,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: _selectedEquipment.isEmpty ? 15 : 10,
                ),
                child: _selectedEquipment.isEmpty
                    ? const Center(
                        child: Text(
                          'No equipment selected',
                          style: TextStyle(
                            color: _mutedHint,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedEquipment
                            .map(
                              (eq) => _buildRemovableChip(
                                label: eq,
                                onRemove: () => setState(
                                  () => _selectedEquipment.remove(eq),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _buildMediaActionRow(
            icon: Icons.photo_camera_outlined,
            title: 'Add Photos',
            formats: 'JPG, PNG, HEIC',
            items: _attachedPhotos,
            onTap: () => _openMediaAttachmentSheet(
              category: 'Photo',
              presets: const [
                'Venue Field Map.jpg',
                'Tracking Terrain Layout.heic',
                'Entry Check-In Board.png',
              ],
              targetList: _attachedPhotos,
            ),
          ),
          Container(height: 1, color: _border),
          _buildMediaActionRow(
            icon: Icons.videocam_outlined,
            title: 'Add Videos',
            formats: 'MP4, MOV',
            items: _attachedVideos,
            onTap: () => _openMediaAttachmentSheet(
              category: 'Video',
              presets: const [
                'Warmup Heelwork Walk-Through.mp4',
                'Course Briefing Clip.mov',
              ],
              targetList: _attachedVideos,
            ),
          ),
          Container(height: 1, color: _border),
          _buildMediaActionRow(
            icon: Icons.description_outlined,
            title: 'Add Documents',
            formats: 'PDF, DOC, certificates',
            items: _attachedDocuments,
            onTap: () => _openMediaAttachmentSheet(
              category: 'Document',
              presets: const [
                'Entry Confirmation.pdf',
                'Running Order & Draw.pdf',
                'Vaccination & Scorebook Check.pdf',
              ],
              targetList: _attachedDocuments,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaActionRow({
    required IconData icon,
    required String title,
    required String formats,
    required List<String> items,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UlvenikIcon.fromMaterial(icon, color: _stone, size: 17),
                const SizedBox(width: 11),
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14.2,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    formats,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _mutedHint,
                      fontSize: 12.2,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (items.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${items.length}',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const UlvenikIcon(UlvenikIcons.details,
                  color: _stone,
                  size: 19,
                ),
              ],
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: items
                    .map(
                      (file) => _buildRemovableChip(
                        label: file,
                        onRemove: () => setState(() => items.remove(file)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(int notesCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _notesCtrl,
            maxLines: 4,
            maxLength: 2000,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) =>
                null,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 14,
              height: 1.45,
              fontFamily: 'Inter',
            ),
            decoration: const InputDecoration(
              hintText: 'Competition notes, comments,\nobservations...',
              hintStyle: TextStyle(
                color: _mutedHint,
                fontSize: 14,
                height: 1.45,
                fontFamily: 'Inter',
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 12),
            ),
          ),
          Container(height: 1, color: _underlineColor),
          const SizedBox(height: 8),
          Text(
            '$notesCount / 2000',
            style: const TextStyle(
              color: _mutedHint,
              fontSize: 11.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UlvenikIcon(UlvenikIcons.notifications,
                color: _stone,
                size: 18,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Competition Reminder',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Switch(
                value: _reminderEnabled,
                activeThumbColor: _offWhite,
                activeTrackColor: _forest,
                inactiveThumbColor: _stone,
                inactiveTrackColor: _bg,
                onChanged: (v) => setState(() => _reminderEnabled = v),
              ),
            ],
          ),
          if (_reminderEnabled) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '1 Day Before · 08:00',
                '3 Days Before · 18:00',
                'Morning of Trial · 06:30',
              ].map((opt) {
                final sel = _reminderLeadTime == opt;
                return GestureDetector(
                  onTap: () => setState(() => _reminderLeadTime = opt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? _forest.withValues(alpha: 0.24) : _bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: sel ? _mint.withValues(alpha: 0.65) : _border,
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        color: sel ? _mint : _stone,
                        fontSize: 11.8,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRemovableChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 6, 5),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _mint.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, color: _stone, size: 15),
          ),
        ],
      ),
    );
  }

  void _openSportPicker() {
    _openSimpleSelectionSheet(
      title: 'Select Sport',
      options: _sportOptions,
      selected: _selectedSport,
      onSelected: (val) => setState(() {
        _selectedSport = val;
        if (_validationError != null && _isFormReady) {
          _validationError = null;
        }
      }),
    );
  }

  void _openCountryPicker() {
    _openSimpleSelectionSheet(
      title: 'Select Country',
      options: _countryOptions,
      selected: _selectedCountry,
      onSelected: (val) => setState(() => _selectedCountry = val),
    );
  }

  void _openDogPicker() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Competing Dog',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                ..._dogOptions.map((pair) {
                  final sel = pair.$1 == _selectedDogName;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _selectedDogName = pair.$1;
                          _selectedDogBreed = pair.$2;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: sel ? _forest.withValues(alpha: 0.2) : _bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: sel ? _forest : _border,
                          ),
                        ),
                        child: Row(
                          children: [
                            const UlvenikIcon(UlvenikIcons.dogs,
                              color: _mint,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${pair.$1} (${pair.$2})',
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            if (sel)
                              const UlvenikIcon(UlvenikIcons.completed,
                                color: _mint,
                                size: 19,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSimpleSelectionSheet({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((opt) {
                        final sel = opt == selected;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pop(ctx);
                              onSelected(opt);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    sel ? _forest.withValues(alpha: 0.2) : _bg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: sel ? _forest : _border,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    opt,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  if (sel)
                                    const UlvenikIcon(UlvenikIcons.completed,
                                      color: _mint,
                                      size: 19,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openGoalsSheet() {
    _openMultiSelectSheet(
      title: 'Link Training & Trial Goals',
      library: _goalLibrary,
      activeList: _linkedGoals,
    );
  }

  void _openEquipmentSheet() {
    _openMultiSelectSheet(
      title: 'Select Competition Equipment',
      library: _equipmentLibrary,
      activeList: _selectedEquipment,
    );
  }

  void _openMultiSelectSheet({
    required String title,
    required List<String> library,
    required List<String> activeList,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _stone.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...library.map((item) {
                      final checked = activeList.contains(item);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setModalState(() {
                              if (checked) {
                                activeList.remove(item);
                              } else {
                                activeList.add(item);
                              }
                            });
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: checked
                                  ? _forest.withValues(alpha: 0.2)
                                  : _bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: checked ? _forest : _border,
                              ),
                            ),
                            child: Row(
                              children: [
                                UlvenikIcon.fromMaterial(
                                  checked
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  color: checked ? _mint : _stone,
                                  size: 20,
                                ),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 13.5,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openMediaAttachmentSheet({
    required String category,
    required List<String> presets,
    required List<String> targetList,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stone.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Attach Competition $category',
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 14),
                ...presets.map((file) {
                  final already = targetList.contains(file);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.pop(ctx);
                        if (!already) {
                          setState(() => targetList.add(file));
                          AppSnackbar.show(
                            context,
                            title: '$category Attached',
                            message: '$file linked to competition entry.',
                            type: SnackbarType.info,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.attach_file_rounded,
                              color: _mint,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                file,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 13.5,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            Text(
                              already ? 'Added' : 'Attach',
                              style: TextStyle(
                                color: already ? _stone : _mint,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const double dashWidth = 4.5;
    const double dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
