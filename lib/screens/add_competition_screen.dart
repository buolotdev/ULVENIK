import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class AddCompetitionScreen extends StatefulWidget {
  const AddCompetitionScreen({super.key});

  @override
  State<AddCompetitionScreen> createState() => _AddCompetitionScreenState();
}

class _AddCompetitionScreenState extends State<AddCompetitionScreen> {
  final _nameController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _venueController = TextEditingController();
  final _addressController = TextEditingController();
  final _clubController = TextEditingController();
  final _judgeController = TextEditingController();
  final _classController = TextEditingController();
  final _entryNumberController = TextEditingController();
  final _handlerController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSport = 'Select sport';
  String _selectedDog = 'Milo (Belgian Malinois)';
  String _selectedDate = 'Select date';
  String _selectedCountry = 'Select country';
  String _status = 'Upcoming';
  bool _competitionReminder = false;

  final List<String> _linkedGoals = [];
  final List<String> _linkedEquipment = [];

  @override
  void dispose() {
    _nameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _venueController.dispose();
    _addressController.dispose();
    _clubController.dispose();
    _judgeController.dispose();
    _classController.dispose();
    _entryNumberController.dispose();
    _handlerController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveCompetition() {
    final name = _nameController.text.trim();
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          name.isNotEmpty
              ? 'Competition "$name" scheduled.'
              : 'Competition created successfully.',
        ),
        backgroundColor: _forest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const statuses = ['Upcoming', 'In Progress', 'Completed', 'Cancelled'];

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        title: const Text(
          'Add Competition',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveCompetition,
            child: const Text(
              'Save',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COMPETITION INFORMATION
              const Text(
                'COMPETITION INFORMATION',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Competition Name
                    Row(
                      children: const [
                        Icon(Icons.emoji_events_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text(
                          'Competition Name *',
                          style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: _offWhite, fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Regional Agility Trial 2026',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Sport
                    Row(
                      children: const [
                        Icon(Icons.local_offer_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Sport *', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSport,
                        isExpanded: true,
                        dropdownColor: _carbon,
                        icon: const Icon(Icons.keyboard_arrow_down, color: _stoneGrey),
                        style: TextStyle(
                          color: _selectedSport == 'Select sport' ? _stoneGrey : _offWhite,
                          fontSize: 15,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Select sport', child: Text('Select sport')),
                          DropdownMenuItem(value: 'IGP / Schutzhund', child: Text('IGP / Schutzhund')),
                          DropdownMenuItem(value: 'Agility', child: Text('Agility')),
                          DropdownMenuItem(value: 'PSA', child: Text('PSA')),
                          DropdownMenuItem(value: 'Mondioring', child: Text('Mondioring')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSport = val);
                        },
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    const SizedBox(height: 18),

                    // Dog
                    Row(
                      children: const [
                        Icon(Icons.pets, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Dog *', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDog,
                        isExpanded: true,
                        dropdownColor: _carbon,
                        icon: const Icon(Icons.keyboard_arrow_down, color: _stoneGrey),
                        style: const TextStyle(color: _offWhite, fontSize: 15),
                        items: const [
                          DropdownMenuItem(value: 'Milo (Belgian Malinois)', child: Text('Milo (Belgian Malinois)')),
                          DropdownMenuItem(value: 'Murphy (German Shepherd)', child: Text('Murphy (German Shepherd)')),
                          DropdownMenuItem(value: 'Freya (Dutch Shepherd)', child: Text('Freya (Dutch Shepherd)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedDog = val);
                        },
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    const SizedBox(height: 18),

                    // Date
                    Row(
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Date *', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = '${picked.day} ${_getMonth(picked.month)} ${picked.year}';
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate,
                              style: TextStyle(
                                color: _selectedDate == 'Select date' ? _stoneGrey : _offWhite,
                                fontSize: 15,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: _stoneGrey),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    const SizedBox(height: 18),

                    // Start Time & End Time
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.schedule, size: 15, color: _stoneGrey),
                                  SizedBox(width: 6),
                                  Text('Start Time', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _startTimeController,
                                style: const TextStyle(color: _offWhite, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Optional',
                                  hintStyle: TextStyle(color: _stoneGrey),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.schedule, size: 15, color: _stoneGrey),
                                  SizedBox(width: 6),
                                  Text('End Time', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _endTimeController,
                                style: const TextStyle(color: _offWhite, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Optional',
                                  hintStyle: TextStyle(color: _stoneGrey),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Venue
                    Row(
                      children: const [
                        Icon(Icons.place_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Venue', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _venueController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Venue name',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Address
                    Row(
                      children: const [
                        Icon(Icons.home_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Address', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _addressController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Address',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Country
                    Row(
                      children: const [
                        Icon(Icons.flag_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Country', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountry,
                        isExpanded: true,
                        dropdownColor: _carbon,
                        icon: const Icon(Icons.keyboard_arrow_down, color: _stoneGrey),
                        style: TextStyle(
                          color: _selectedCountry == 'Select country' ? _stoneGrey : _offWhite,
                          fontSize: 15,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Select country', child: Text('Select country')),
                          DropdownMenuItem(value: 'United Kingdom', child: Text('United Kingdom')),
                          DropdownMenuItem(value: 'Germany', child: Text('Germany')),
                          DropdownMenuItem(value: 'United States', child: Text('United States')),
                          DropdownMenuItem(value: 'Canada', child: Text('Canada')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCountry = val);
                        },
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    const SizedBox(height: 18),

                    // Organising Club
                    Row(
                      children: const [
                        Icon(Icons.groups_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Organising Club', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _clubController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Club name',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Judge(s)
                    Row(
                      children: const [
                        Icon(Icons.account_balance_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Judge(s)', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _judgeController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Judge name(s)',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Class / Division & Entry Number
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '# Class / Division',
                                style: TextStyle(color: _stoneGrey, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _classController,
                                style: const TextStyle(color: _offWhite, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'e.g. Open, Novice',
                                  hintStyle: TextStyle(color: _stoneGrey),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '# Entry Number',
                                style: TextStyle(color: _stoneGrey, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _entryNumberController,
                                style: const TextStyle(color: _offWhite, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Your entry number',
                                  hintStyle: TextStyle(color: _stoneGrey),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Handler
                    Row(
                      children: const [
                        Icon(Icons.person_outline, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Handler', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _handlerController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Handler name',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Weather
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.cloud_outlined, size: 16, color: _stoneGrey),
                            SizedBox(width: 8),
                            Text('Weather', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.lock_outline, size: 14, color: _stoneGrey),
                            SizedBox(width: 4),
                            Text('Auto-detect', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Awaiting event date & location',
                      style: TextStyle(color: _stoneGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Captured automatically when available',
                      style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'STATUS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Status Chips
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: statuses.map((st) {
                        final isSel = _status == st;
                        return InkWell(
                          onTap: () => setState(() => _status = st),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSel ? const Color(0xFF34D399) : _cardBorder,
                              ),
                            ),
                            child: Text(
                              st,
                              style: TextStyle(
                                color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Status updates automatically based on competition date',
                      style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'COMPETITION TYPE',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Event Category
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.local_offer_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Event Category', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _categoryController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Trial, Championship, Fun Match',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter any competition type — Trial, Championship, Club Competition, Qualification Event, etc.',
                      style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'GOALS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Link Goals Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _linkedGoals.add('Pass IGP 1 Qualification');
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.gps_fixed, size: 16, color: _mint),
                              SizedBox(width: 8),
                              Text(
                                'Link Goals',
                                style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14171A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardBorder, style: BorderStyle.solid),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _linkedGoals.isEmpty
                            ? 'No goals linked yet'
                            : _linkedGoals.join(', '),
                        style: TextStyle(
                          color: _linkedGoals.isEmpty ? _stoneGrey : _mint,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'EQUIPMENT USED',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Equipment Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _linkedEquipment.add('Leather Tracking Harness');
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center_outlined, size: 16, color: _mint),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Add Equipment', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                Text('Select from your Equipment Library', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14171A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _cardBorder),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _linkedEquipment.isEmpty
                            ? 'No equipment selected'
                            : _linkedEquipment.join(', '),
                        style: TextStyle(
                          color: _linkedEquipment.isEmpty ? _stoneGrey : _mint,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'MEDIA',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Media Card
              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    _buildMediaRow(Icons.photo_camera_outlined, 'Add Photos', 'JPG, PNG, HEIC'),
                    const Divider(color: _cardBorder, height: 1),
                    _buildMediaRow(Icons.videocam_outlined, 'Add Videos', 'MP4, MOV'),
                    const Divider(color: _cardBorder, height: 1),
                    _buildMediaRow(Icons.description_outlined, 'Add Documents', 'PDF, DOC, certificates'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'NOTES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Notes Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Competition notes, comments, observations...',
                        hintStyle: TextStyle(color: _stoneGrey),
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(color: _cardBorder, height: 16),
                    Text(
                      '${_notesController.text.length} / 2000',
                      style: const TextStyle(color: _stoneGrey, fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'REMINDER',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Reminder Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_none, color: _stoneGrey, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Competition Reminder',
                        style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Switch(
                      value: _competitionReminder,
                      activeThumbColor: _mint,
                      activeTrackColor: _forest,
                      inactiveThumbColor: _stoneGrey,
                      inactiveTrackColor: const Color(0xFF262C30),
                      onChanged: (val) => setState(() => _competitionReminder = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Create Competition Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveCompetition,
                  child: const Text(
                    'Create Competition',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaRow(IconData icon, String title, String formats) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title picker opened'), backgroundColor: _forest),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Text(formats, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return m[month - 1];
  }
}
