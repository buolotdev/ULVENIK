import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'trainer_dashboard_screen.dart';

enum ClientStatusOption {
  active('ACTIVE', 'Client appears in your main Client List.'),
  inactive('INACTIVE', 'Client is paused and hidden from active day-to-day lists.'),
  archived('ARCHIVED', 'Client records are archived and stored for historical records.');

  final String label;
  final String description;
  const ClientStatusOption(this.label, this.description);
}

enum PermissionPreset {
  viewOnly('VIEW ONLY'),
  standardTrainer('STANDARD TRAINER'),
  fullAccess('FULL ACCESS'),
  custom('CUSTOM');

  final String label;
  const PermissionPreset(this.label);
}

class EditClientScreen extends StatefulWidget {
  final String? clientId;

  const EditClientScreen({
    super.key,
    this.clientId,
  });

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  // Form controllers
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _preferredNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _altNumberCtrl;
  late final TextEditingController _addr1Ctrl;
  late final TextEditingController _addr2Ctrl;
  late final TextEditingController _townCtrl;
  late final TextEditingController _postcodeCtrl;
  late final TextEditingController _notesCtrl;

  String _selectedCountry = 'Norway';
  ClientStatusOption _status = ClientStatusOption.active;
  PermissionPreset _selectedPreset = PermissionPreset.standardTrainer;

  // Individual permissions matching Figma defaults (Standard Trainer)
  bool _permViewTraining = true;
  bool _permAddTraining = true;
  bool _permEditTraining = true;
  bool _permViewHealth = true;
  bool _permEditHealth = false;
  bool _permCreateGoals = true;
  bool _permUploadVideos = false;
  bool _permViewReports = true;
  bool _permExportReports = false;

  bool _isSaving = false;

  final List<String> _countries = [
    'Norway',
    'Sweden',
    'Denmark',
    'Germany',
    'United Kingdom',
    'United States',
    'Finland',
    'Austria',
    'Switzerland',
  ];

  static const Map<String, ({String mobile, String alt, String addr1, String town, String postcode})>
      _countryExamples = {
    'Norway': (
      mobile: '+47 912 34 567',
      alt: '+47 480 12 345',
      addr1: 'Holmenkollveien 42',
      town: 'Oslo',
      postcode: '0784',
    ),
    'Sweden': (
      mobile: '+46 70 123 45 67',
      alt: '+46 73 987 65 43',
      addr1: 'Strandvägen 18',
      town: 'Stockholm',
      postcode: '114 56',
    ),
    'Denmark': (
      mobile: '+45 20 12 34 56',
      alt: '+45 40 98 76 54',
      addr1: 'Østerbrogade 24',
      town: 'Copenhagen',
      postcode: '2100',
    ),
    'Germany': (
      mobile: '+49 151 23456789',
      alt: '+49 170 9876543',
      addr1: 'Lindenstraße 12',
      town: 'Munich',
      postcode: '80331',
    ),
    'United Kingdom': (
      mobile: '+44 7712 448910',
      alt: '+44 7700 900455',
      addr1: '14 High Street',
      town: 'Chelmsford',
      postcode: 'CM1 1BE',
    ),
    'United States': (
      mobile: '+1 555 234 5678',
      alt: '+1 555 876 5432',
      addr1: '742 Evergreen Terrace',
      town: 'Portland',
      postcode: '97201',
    ),
    'Finland': (
      mobile: '+358 40 123 4567',
      alt: '+358 50 987 6543',
      addr1: 'Mannerheimintie 10',
      town: 'Helsinki',
      postcode: '00100',
    ),
    'Austria': (
      mobile: '+43 664 1234567',
      alt: '+43 676 9876543',
      addr1: 'Hauptstraße 9',
      town: 'Salzburg',
      postcode: '5020',
    ),
    'Switzerland': (
      mobile: '+41 79 123 45 67',
      alt: '+41 78 987 65 43',
      addr1: 'Bahnhofstrasse 22',
      town: 'Zurich',
      postcode: '8001',
    ),
  };

  static String _inferCountry(TrainerClient client) {
    final loc = client.location.toLowerCase();
    final ph = client.phone.trim();
    if (loc.contains('norway') || loc.contains('oslo') || ph.startsWith('+47')) {
      return 'Norway';
    }
    if (loc.contains('sweden') || ph.startsWith('+46')) return 'Sweden';
    if (loc.contains('denmark') || ph.startsWith('+45')) return 'Denmark';
    if (loc.contains('germany') || ph.startsWith('+49')) return 'Germany';
    if (loc.contains('united states') || ph.startsWith('+1')) {
      return 'United States';
    }
    if (loc.contains('finland') || ph.startsWith('+358')) return 'Finland';
    if (loc.contains('austria') || ph.startsWith('+43')) return 'Austria';
    if (loc.contains('switzerland') || ph.startsWith('+41')) {
      return 'Switzerland';
    }
    return 'United Kingdom';
  }

  void _syncContactsWithSelectedCountry(String previousCountry, String nextCountry) {
    final prevEx = _countryExamples[previousCountry];
    final nextEx = _countryExamples[nextCountry] ?? _countryExamples['Norway']!;
    final knownMobiles = _countryExamples.values.map((e) => e.mobile).toSet();
    final knownAlts = _countryExamples.values.map((e) => e.alt).toSet();
    final knownAddr1 = _countryExamples.values.map((e) => e.addr1).toSet();
    final knownTowns = _countryExamples.values.map((e) => e.town).toSet();
    final knownPostcodes = _countryExamples.values.map((e) => e.postcode).toSet();

    if (_mobileCtrl.text.trim().isEmpty ||
        knownMobiles.contains(_mobileCtrl.text.trim()) ||
        (prevEx != null &&
            _mobileCtrl.text.trim().startsWith(prevEx.mobile.split(' ').first))) {
      _mobileCtrl.text = nextEx.mobile;
    }
    if (_altNumberCtrl.text.trim().isEmpty ||
        knownAlts.contains(_altNumberCtrl.text.trim())) {
      _altNumberCtrl.text = nextEx.alt;
    }
    if (knownAddr1.contains(_addr1Ctrl.text.trim())) {
      _addr1Ctrl.text = nextEx.addr1;
    }
    if (knownTowns.contains(_townCtrl.text.trim())) {
      _townCtrl.text = nextEx.town;
    }
    if (knownPostcodes.contains(_postcodeCtrl.text.trim())) {
      _postcodeCtrl.text = nextEx.postcode;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.clientId != null) {
      final client = TrainerPackStore.findClient(widget.clientId);
      final parts = client.fullName.trim().split(RegExp(r'\s+'));
      final first = parts.isNotEmpty ? parts.first : 'Emma';
      final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      final country = _inferCountry(client);
      final ex = _countryExamples[country] ?? _countryExamples['Norway']!;
      final locTown = client.location.split(',').first.trim();

      _selectedCountry = country;
      _status = switch (client.status) {
        'Archived' => ClientStatusOption.archived,
        'Paused' || 'Inactive' => ClientStatusOption.inactive,
        _ => ClientStatusOption.active,
      };
      _permViewHealth = client.canViewHealthRecords;
      _checkCustomPreset();

      _firstNameCtrl = TextEditingController(text: first);
      _lastNameCtrl = TextEditingController(text: last);
      _preferredNameCtrl = TextEditingController(
        text: first == 'Emma' ? 'Em' : '',
      );
      _emailCtrl = TextEditingController(text: client.email);
      _mobileCtrl = TextEditingController(
        text: client.phone.trim().isNotEmpty ? client.phone.trim() : ex.mobile,
      );
      _altNumberCtrl = TextEditingController(text: ex.alt);
      _addr1Ctrl = TextEditingController(text: ex.addr1);
      _addr2Ctrl = TextEditingController(text: '');
      _townCtrl = TextEditingController(
        text: locTown.isNotEmpty && locTown != country ? locTown : ex.town,
      );
      _postcodeCtrl = TextEditingController(text: ex.postcode);
      _notesCtrl = TextEditingController(text: client.internalNotes);
    } else {
      _firstNameCtrl = TextEditingController(text: 'Emma');
      _lastNameCtrl = TextEditingController(text: 'Johnson');
      _preferredNameCtrl = TextEditingController(text: 'Em');
      _emailCtrl = TextEditingController(text: 'emma.johnson@example.com');
      _mobileCtrl = TextEditingController(text: '+47 912 34 567');
      _altNumberCtrl = TextEditingController(text: '+47 480 12 345');
      _addr1Ctrl = TextEditingController(text: 'Holmenkollveien 42');
      _addr2Ctrl = TextEditingController(text: 'Apartment 3B');
      _townCtrl = TextEditingController(text: 'Oslo');
      _postcodeCtrl = TextEditingController(text: '0784');
      _notesCtrl = TextEditingController(
        text:
            'Prefers morning sessions before 10:00. Responds best to structured IGP obedience homework. Murphy has high toy drive.',
      );
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _preferredNameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _altNumberCtrl.dispose();
    _addr1Ctrl.dispose();
    _addr2Ctrl.dispose();
    _townCtrl.dispose();
    _postcodeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String get _clientFullName {
    final first = _firstNameCtrl.text.trim();
    final last = _lastNameCtrl.text.trim();
    if (first.isEmpty && last.isEmpty) return 'Client Profile';
    return '$first $last'.trim();
  }

  String get _clientInitials {
    final first = _firstNameCtrl.text.trim();
    final last = _lastNameCtrl.text.trim();
    final f = first.isNotEmpty ? first[0].toUpperCase() : '';
    final l = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '$f$l'.isEmpty ? 'CL' : '$f$l';
  }

  void _applyPermissionPreset(PermissionPreset preset) {
    setState(() {
      _selectedPreset = preset;
      switch (preset) {
        case PermissionPreset.viewOnly:
          _permViewTraining = true;
          _permAddTraining = false;
          _permEditTraining = false;
          _permViewHealth = true;
          _permEditHealth = false;
          _permCreateGoals = false;
          _permUploadVideos = false;
          _permViewReports = true;
          _permExportReports = false;
          break;
        case PermissionPreset.standardTrainer:
          _permViewTraining = true;
          _permAddTraining = true;
          _permEditTraining = true;
          _permViewHealth = true;
          _permEditHealth = false;
          _permCreateGoals = true;
          _permUploadVideos = false;
          _permViewReports = true;
          _permExportReports = false;
          break;
        case PermissionPreset.fullAccess:
          _permViewTraining = true;
          _permAddTraining = true;
          _permEditTraining = true;
          _permViewHealth = true;
          _permEditHealth = true;
          _permCreateGoals = true;
          _permUploadVideos = true;
          _permViewReports = true;
          _permExportReports = true;
          break;
        case PermissionPreset.custom:
          break;
      }
    });
  }

  void _checkCustomPreset() {
    // If the switches no longer match standard presets, set to custom
    if (_permViewTraining &&
        _permAddTraining &&
        _permEditTraining &&
        _permViewHealth &&
        !_permEditHealth &&
        _permCreateGoals &&
        !_permUploadVideos &&
        _permViewReports &&
        !_permExportReports) {
      _selectedPreset = PermissionPreset.standardTrainer;
    } else if (_permViewTraining &&
        !_permAddTraining &&
        !_permEditTraining &&
        _permViewHealth &&
        !_permEditHealth &&
        !_permCreateGoals &&
        !_permUploadVideos &&
        _permViewReports &&
        !_permExportReports) {
      _selectedPreset = PermissionPreset.viewOnly;
    } else if (_permViewTraining &&
        _permAddTraining &&
        _permEditTraining &&
        _permViewHealth &&
        _permEditHealth &&
        _permCreateGoals &&
        _permUploadVideos &&
        _permViewReports &&
        _permExportReports) {
      _selectedPreset = PermissionPreset.fullAccess;
    } else {
      _selectedPreset = PermissionPreset.custom;
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Country',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _countries.length,
                    separatorBuilder: (_, index) =>
                        const Divider(color: AppColors.cardBorder, height: 1),
                    itemBuilder: (context, i) {
                      final country = _countries[i];
                      final isSelected = country == _selectedCountry;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          country,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primaryForestGreen
                                : AppColors.primaryTextOffWhite,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primaryForestGreen,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            final prev = _selectedCountry;
                            _selectedCountry = country;
                            _syncContactsWithSelectedCountry(prev, country);
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Change Client Photo',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primaryForestGreen,
                  ),
                  title: const Text(
                    'Take Photo',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera opened.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.infoAlpineBlue,
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gallery opened.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: AppColors.errorDestructive,
                  ),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(
                      color: AppColors.errorDestructive,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reset to client initials.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSavePressed() {
    if (_firstNameCtrl.text.trim().isEmpty || _lastNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.errorDestructive,
          content: Text('Please enter first and last name.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    if (widget.clientId != null) {
      final existing = TrainerPackStore.findClient(widget.clientId);
      final town = _townCtrl.text.trim();
      final nextLocation =
          town.isEmpty ? _selectedCountry : '$town, $_selectedCountry';
      final nextStatus = switch (_status) {
        ClientStatusOption.archived => 'Archived',
        ClientStatusOption.inactive => 'Paused',
        ClientStatusOption.active => 'Active',
      };
      TrainerPackStore.updateClient(
        existing.copyWith(
          fullName: _clientFullName,
          email: _emailCtrl.text.trim(),
          phone: _mobileCtrl.text.trim(),
          location: nextLocation,
          status: nextStatus,
          internalNotes: _notesCtrl.text.trim(),
          shareSessionSummaries: _permViewTraining,
          shareHomeworkTasks: _permCreateGoals,
          canViewHealthRecords: _permViewHealth,
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.cardsCarbon,
          content: Text(
            'Client profile for "$_clientFullName" updated successfully.',
            style: const TextStyle(color: AppColors.primaryTextOffWhite),
          ),
        ),
      );
      Navigator.maybePop(context);
    });
  }

  void _onCancelPressed() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Discard Changes?',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          content: const Text(
            'Any unsaved modifications to this client profile will be lost.',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Keep Editing',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.maybePop(context);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: TextButton(
          onPressed: _onCancelPressed,
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
        title: const Text(
          'Edit Client',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _onSavePressed,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryForestGreen,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primaryForestGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Avatar & Name Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E2824),
                          border: Border.all(
                            color: AppColors.primaryForestGreen,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _clientInitials,
                            style: const TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _showChangePhotoSheet,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.cardsCarbon,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.cardBorder,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.secondaryTextStoneGrey,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _clientFullName,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryForestGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryForestGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_status.label} CLIENT',
                          style: const TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 1: PERSONAL INFORMATION
            _buildSectionHeader('PERSONAL INFORMATION'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildInputField(
                    label: 'First Name *',
                    controller: _firstNameCtrl,
                    icon: Icons.person_outline_rounded,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  _buildInputField(
                    label: 'Last Name *',
                    controller: _lastNameCtrl,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  _buildInputField(
                    label: 'Preferred Name (optional)',
                    controller: _preferredNameCtrl,
                    helperText: 'Used informally within Trainer Pack',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: CONTACT INFORMATION
            _buildSectionHeader('CONTACT INFORMATION'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildInputField(
                    label: 'Email Address',
                    controller: _emailCtrl,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  _buildInputField(
                    label: 'Mobile Number',
                    controller: _mobileCtrl,
                    hintText: (_countryExamples[_selectedCountry] ??
                            _countryExamples['Norway']!)
                        .mobile,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  _buildInputField(
                    label: 'Alternative Number (optional)',
                    controller: _altNumberCtrl,
                    hintText: (_countryExamples[_selectedCountry] ??
                            _countryExamples['Norway']!)
                        .alt,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 3: ADDRESS
            _buildSectionHeader(
              'ADDRESS',
              subtitle: 'For trainer records only — not shared with the client',
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildInputField(
                    label: 'Address Line 1',
                    controller: _addr1Ctrl,
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  _buildInputField(
                    label: 'Address Line 2 (optional)',
                    controller: _addr2Ctrl,
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Town / City',
                          controller: _townCtrl,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildInputField(
                          label: 'Postcode / ZIP',
                          controller: _postcodeCtrl,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),
                  InkWell(
                    onTap: _showCountryPicker,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Country',
                                style: TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedCountry,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 4: TRAINER NOTES
            _buildSectionHeaderWithBadge(
              'TRAINER NOTES',
              'Private to you only',
              Icons.lock_outline_rounded,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 4,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 14,
                      height: 1.45,
                      fontFamily: 'Inter',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'These notes are only visible to you. The client cannot see them.',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundObsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.infoAlpineBlue,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Trainer notes are private and never shared with clients.',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 5: TRAINER PERMISSIONS
            _buildSectionHeader(
              'TRAINER PERMISSIONS',
              subtitle: 'What you can do on this client\'s account',
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PermissionPreset.viewOnly,
                      PermissionPreset.standardTrainer,
                      PermissionPreset.fullAccess,
                    ].map((preset) {
                      final isSel = _selectedPreset == preset;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => _applyPermissionPreset(preset),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.primaryForestGreen
                                        .withValues(alpha: 0.25)
                                    : AppColors.backgroundObsidian,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.primaryForestGreen
                                      : AppColors.cardBorder,
                                ),
                              ),
                              child: Text(
                                preset.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSel
                                      ? AppColors.primaryTextOffWhite
                                      : AppColors.secondaryTextStoneGrey,
                                  fontSize: 11,
                                  fontWeight: isSel
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  letterSpacing: 0.3,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Changes take effect immediately after saving.',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 6: INDIVIDUAL PERMISSIONS
            _buildSectionHeader(
              'INDIVIDUAL PERMISSIONS',
              subtitle: 'Customise access beyond the preset',
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildToggleRow(
                    title: 'View Training Sessions',
                    value: _permViewTraining,
                    icon: Icons.book_outlined,
                    onChanged: (val) {
                      setState(() {
                        _permViewTraining = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'Add Training Sessions',
                    value: _permAddTraining,
                    icon: Icons.note_add_outlined,
                    onChanged: (val) {
                      setState(() {
                        _permAddTraining = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'Edit Training Sessions',
                    subtitle: 'Allows modifying existing session records',
                    value: _permEditTraining,
                    icon: Icons.edit_outlined,
                    onChanged: (val) {
                      setState(() {
                        _permEditTraining = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'View Health',
                    value: _permViewHealth,
                    icon: Icons.favorite_border_rounded,
                    onChanged: (val) {
                      setState(() {
                        _permViewHealth = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'Edit Health',
                    subtitle: 'Allows editing health records',
                    value: _permEditHealth,
                    icon: Icons.edit_outlined,
                    onChanged: (val) {
                      setState(() {
                        _permEditHealth = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'Create Goals',
                    value: _permCreateGoals,
                    icon: Icons.track_changes_rounded,
                    onChanged: (val) {
                      setState(() {
                        _permCreateGoals = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'Upload Videos',
                    value: _permUploadVideos,
                    icon: Icons.play_circle_outline_rounded,
                    onChanged: (val) {
                      setState(() {
                        _permUploadVideos = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'View Reports',
                    value: _permViewReports,
                    icon: Icons.description_outlined,
                    onChanged: (val) {
                      setState(() {
                        _permViewReports = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  _buildToggleRow(
                    title: 'Export Reports',
                    value: _permExportReports,
                    icon: Icons.upload_file_rounded,
                    onChanged: (val) {
                      setState(() {
                        _permExportReports = val;
                        _checkCustomPreset();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 7: CLIENT STATUS
            _buildSectionHeader('CLIENT STATUS'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardsCarbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: ClientStatusOption.values.map((opt) {
                      final isSel = _status == opt;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _status = opt;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.primaryForestGreen
                                        .withValues(alpha: 0.25)
                                    : AppColors.backgroundObsidian,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.primaryForestGreen
                                      : AppColors.cardBorder,
                                ),
                              ),
                              child: Text(
                                opt.label,
                                style: TextStyle(
                                  color: isSel
                                      ? AppColors.primaryTextOffWhite
                                      : AppColors.secondaryTextStoneGrey,
                                  fontSize: 12,
                                  fontWeight: isSel
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  letterSpacing: 0.4,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _status.description,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Primary Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                onPressed: _isSaving ? null : _onSavePressed,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: _onCancelPressed,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryForestGreen,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeaderWithBadge(
      String title, String badgeText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryForestGreen,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 4),
              Text(
                badgeText,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    String? hintText,
    String? helperText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.55),
              fontSize: 15,
              fontFamily: 'Inter',
            ),
            helperText: helperText,
            helperStyle: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.secondaryTextStoneGrey),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.primaryForestGreen,
            activeTrackColor:
                AppColors.primaryForestGreen.withValues(alpha: 0.4),
            inactiveThumbColor: AppColors.secondaryTextStoneGrey,
            inactiveTrackColor: AppColors.backgroundObsidian,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
