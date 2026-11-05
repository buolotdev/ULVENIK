import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'client_dog_profile_screen.dart';
import 'client_profile_screen.dart';
import 'trainer_dashboard_screen.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  static const Color _bg = AppColors.backgroundObsidian; // #101214
  static const Color _cardBg = AppColors.cardsCarbon; // #1A1F22
  static const Color _forest = AppColors.primaryForestGreen; // #2E6B57
  static const Color _greenHeader = Color(0xFF3E8C6F);
  static const Color _sage = AppColors.secondarySage; // #7A8F7A
  static const Color _alpineBlue = AppColors.infoAlpineBlue; // #5D8FAF
  static const Color _hintGrey = Color(0xFF6B7280);
  static const Color _textPrimary = AppColors.primaryTextOffWhite; // #F5F6F2
  static const Color _textSecondary = AppColors.secondaryTextStoneGrey; // #A7B0AB
  static const Color _border = AppColors.cardBorder;

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _nicknameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _altPhoneCtrl = TextEditingController();
  final TextEditingController _addr1Ctrl = TextEditingController();
  final TextEditingController _addr2Ctrl = TextEditingController();
  final TextEditingController _townCtrl = TextEditingController();
  final TextEditingController _postcodeCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();
  final TextEditingController _inviteMsgCtrl = TextEditingController();
  final TextEditingController _initialDogNameCtrl = TextEditingController();
  final TextEditingController _initialDogBreedCtrl = TextEditingController();

  bool _addressExpanded = true;
  String _selectedCountry = 'Norway';
  String _trainerPermission = 'STANDARD TRAINER';

  bool _viewTrainingSessions = true;
  bool _viewHealthRecords = true;
  bool _viewGoals = true;
  bool _viewReports = false;
  bool _uploadVideos = false;
  bool _addNotes = false;
  bool _editExistingRecords = false;

  bool _sendInvitation = true;
  bool _addDogNow = false;

  static const List<String> _countries = [
    'Norway',
    'United Kingdom',
    'Sweden',
    'Denmark',
    'Germany',
    'United States',
  ];

  static const Map<String, (String, String)> _countryPhoneExamples = {
    'Norway': ('+47 912 34 567', '+47 480 12 345'),
    'United Kingdom': ('+44 7700 900418', '+44 7700 900512'),
    'Sweden': ('+46 70 123 45 67', '+46 73 987 65 43'),
    'Denmark': ('+45 20 12 34 56', '+45 40 98 76 54'),
    'Germany': ('+49 151 23456789', '+49 170 9876543'),
    'United States': ('+1 555 234 5678', '+1 555 876 5432'),
  };

  String get _mobileHint =>
      (_countryPhoneExamples[_selectedCountry] ??
              _countryPhoneExamples['Norway']!)
          .$1;

  String get _altPhoneHint =>
      (_countryPhoneExamples[_selectedCountry] ??
              _countryPhoneExamples['Norway']!)
          .$2;

  static const List<String> _permissionTiers = [
    'VIEW ONLY',
    'STANDARD TRAINER',
    'FULL ACCESS',
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _nicknameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _altPhoneCtrl.dispose();
    _addr1Ctrl.dispose();
    _addr2Ctrl.dispose();
    _townCtrl.dispose();
    _postcodeCtrl.dispose();
    _notesCtrl.dispose();
    _inviteMsgCtrl.dispose();
    _initialDogNameCtrl.dispose();
    _initialDogBreedCtrl.dispose();
    super.dispose();
  }

  void _pickCountry() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Country',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                ..._countries.map((country) {
                  final selected = country == _selectedCountry;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      setState(() => _selectedCountry = country);
                      Navigator.pop(ctx);
                    },
                    title: Text(
                      country,
                      style: TextStyle(
                        color: selected ? _greenHeader : _textPrimary,
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_rounded,
                            color: _greenHeader, size: 20)
                        : null,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitCreateClient() {
    final first = _firstNameCtrl.text.trim();
    final last = _lastNameCtrl.text.trim();

    if (first.isEmpty || last.isEmpty) {
      AppSnackbar.show(
        context,
        title: 'Missing Required Fields',
        message: 'Please enter both First Name and Last Name.',
        type: SnackbarType.error,
      );
      return;
    }

    final fullName = '$first $last';
    final email = _emailCtrl.text.trim().isEmpty
        ? '${first.toLowerCase()}.${last.toLowerCase()}@example.com'
        : _emailCtrl.text.trim();
    final phone = _mobileCtrl.text.trim().isEmpty
        ? _mobileHint
        : _mobileCtrl.text.trim();

    final town = _townCtrl.text.trim();
    final location =
        town.isEmpty ? _selectedCountry : '$town, $_selectedCountry';

    final dogName = _initialDogNameCtrl.text.trim().isEmpty
        ? 'Koda'
        : _initialDogNameCtrl.text.trim();
    final dogBreed = _initialDogBreedCtrl.text.trim().isEmpty
        ? 'Working Retriever'
        : _initialDogBreedCtrl.text.trim();

    final dogs = _addDogNow
        ? [
            TrainerClientDog(
              id: 'dog_${DateTime.now().millisecondsSinceEpoch}',
              name: dogName,
              breed: dogBreed,
              ageLabel: '1 Yr',
            ),
          ]
        : <TrainerClientDog>[];

    final newClient = TrainerClient(
      id: 'client_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phone: phone,
      location: location,
      status: 'Active',
      programme: '1-to-1 Obedience & Foundations',
      joinedLabel: 'Joined Today',
      nextSessionLabel: 'Pending booking',
      lastActivityLabel: 'Just now',
      internalNotes: _notesCtrl.text.trim().isEmpty
          ? 'Created with $_trainerPermission access.'
          : _notesCtrl.text.trim(),
      portalConnected: _sendInvitation,
      shareSessionSummaries: _viewTrainingSessions,
      shareHomeworkTasks: _viewGoals,
      canViewHealthRecords: _viewHealthRecords,
      lessonsCompleted: 0,
      lessonsRemaining: 6,
      dogs: dogs,
    );

    TrainerPackStore.addClient(newClient);

    AppSnackbar.show(
      context,
      title: _sendInvitation ? 'Client Created & Invited' : 'Client Created',
      message: _sendInvitation
          ? 'Added $fullName and sent portal invite to $email.'
          : 'Added $fullName to your Trainer Pack.',
      type: SnackbarType.success,
    );

    if (_addDogNow && newClient.dogs.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClientDogProfileScreen(
            clientId: newClient.id,
            dogId: newClient.dogs.first.id,
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClientProfileScreen(clientId: newClient.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar:
          const UlvenikBottomNav(activeTab: UlvenikNavTab.more),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('BASIC INFORMATION'),
                    const SizedBox(height: 10),
                    _buildBasicInfoCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('CONTACT INFORMATION'),
                    const SizedBox(height: 10),
                    _buildContactInfoCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('ADDRESS'),
                    const SizedBox(height: 3),
                    const Text(
                      'For trainer records only — not shared with the client',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildAddressCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('TRAINER NOTES'),
                    const SizedBox(height: 10),
                    _buildTrainerNotesCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('TRAINER PERMISSIONS'),
                    const SizedBox(height: 3),
                    const Text(
                      'What you can do once the client accepts',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTrainerPermissionsCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('CLIENT ACCESS'),
                    const SizedBox(height: 3),
                    const Text(
                      'What the client can see and do',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildClientAccessCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('INVITE CLIENT'),
                    const SizedBox(height: 10),
                    _buildInviteClientCard(),
                    const SizedBox(height: 22),
                    _buildSectionTitle('AFTER SAVING'),
                    const SizedBox(height: 10),
                    _buildAfterSavingCard(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitCreateClient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create Client',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(
          bottom: BorderSide(color: _border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const Text(
            'Add Client',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              fontFamily: 'Inter',
            ),
          ),
          GestureDetector(
            onTap: _submitCreateClient,
            behavior: HitTestBehavior.opaque,
            child: const Text(
              'Save',
              style: TextStyle(
                color: _greenHeader,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _greenHeader,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.05,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledUnderlineInput(
            icon: Icons.person_outline_rounded,
            label: 'First Name',
            isRequired: true,
            hint: 'e.g. Emma',
            controller: _firstNameCtrl,
          ),
          const SizedBox(height: 18),
          _buildLabeledUnderlineInput(
            label: 'Last Name',
            indentWithoutIcon: true,
            isRequired: true,
            hint: 'e.g. Johnson',
            controller: _lastNameCtrl,
          ),
          const SizedBox(height: 18),
          _buildLabeledUnderlineInput(
            icon: Icons.local_offer_outlined,
            label: 'Nickname',
            isOptional: true,
            hint: 'e.g. Em',
            controller: _nicknameCtrl,
            helperText: 'Used internally by the trainer only',
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledUnderlineInput(
            icon: Icons.mail_outline_rounded,
            label: 'Email Address',
            hint: 'e.g. emma.johnson@example.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            helperText: 'Used to send the client invitation',
          ),
          const SizedBox(height: 18),
          _buildLabeledUnderlineInput(
            icon: Icons.phone_outlined,
            label: 'Mobile Number',
            hint: _mobileHint,
            controller: _mobileCtrl,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 18),
          _buildLabeledUnderlineInput(
            icon: Icons.phone_outlined,
            label: 'Alternative Number',
            isOptional: true,
            hint: _altPhoneHint,
            controller: _altPhoneCtrl,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _addressExpanded = !_addressExpanded),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: _sage, size: 17),
                const SizedBox(width: 8),
                const Text(
                  'Add Address',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '(optional)',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12.5,
                    fontFamily: 'Inter',
                  ),
                ),
                const Spacer(),
                UlvenikIcon.fromMaterial(
                  _addressExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: _textSecondary,
                  size: 19,
                ),
              ],
            ),
          ),
          if (_addressExpanded) ...[
            const SizedBox(height: 14),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 12),
            _buildPlainUnderlineField(
              hint: 'Address Line 1',
              controller: _addr1Ctrl,
            ),
            const SizedBox(height: 14),
            _buildPlainUnderlineField(
              hint: 'Address Line 2 (optional)',
              controller: _addr2Ctrl,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildPlainUnderlineField(
                    hint: 'Town / City',
                    controller: _townCtrl,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildPlainUnderlineField(
                    hint: 'Postcode / ZIP',
                    controller: _postcodeCtrl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickCountry,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCountry,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const UlvenikIcon(UlvenikIcons.details,
                      color: _textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrainerNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lock_outline_rounded, color: _sage, size: 15),
              SizedBox(width: 7),
              Text(
                'Private to you only',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesCtrl,
            maxLines: 3,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13.5,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 10),
              hintText:
                  'Add private notes about this client — preferred contact times, observations, reminders...',
              hintStyle: const TextStyle(
                color: _hintGrey,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.45,
                fontFamily: 'Inter',
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _forest),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'These notes are only visible to you. The client cannot see them.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 11.5,
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF151C20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _alpineBlue.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline_rounded, color: _alpineBlue, size: 15),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Trainer notes are private and never shared with clients.',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      height: 1.4,
                      fontFamily: 'Inter',
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

  Widget _buildTrainerPermissionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _permissionTiers.map((tier) {
              final selected = _trainerPermission == tier;
              return GestureDetector(
                onTap: () => setState(() => _trainerPermission = tier),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? _forest.withValues(alpha: 0.18)
                        : const Color(0xFF23282B),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: selected ? _forest : _border,
                    ),
                  ),
                  child: Text(
                    tier,
                    style: TextStyle(
                      color: selected ? _greenHeader : _textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Text(
            'Permissions can be adjusted at any time from the client profile.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
              height: 1.45,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientAccessCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _buildAccessToggleRow(
            icon: Icons.assignment_outlined,
            title: 'View Training Sessions',
            value: _viewTrainingSessions,
            onChanged: (v) => setState(() => _viewTrainingSessions = v),
          ),
          const Divider(color: _border, height: 1),
          _buildAccessToggleRow(
            icon: Icons.favorite_border_rounded,
            title: 'View Health Records',
            value: _viewHealthRecords,
            onChanged: (v) => setState(() => _viewHealthRecords = v),
          ),
          const Divider(color: _border, height: 1),
          _buildAccessToggleRow(
            icon: Icons.track_changes_rounded,
            title: 'View Goals',
            value: _viewGoals,
            onChanged: (v) => setState(() => _viewGoals = v),
          ),
          const Divider(color: _border, height: 1),
          _buildAccessToggleRow(
            icon: Icons.description_outlined,
            title: 'View Reports',
            value: _viewReports,
            onChanged: (v) => setState(() => _viewReports = v),
          ),
          const Divider(color: _border, height: 1),
          _buildAccessToggleRow(
            icon: Icons.videocam_outlined,
            title: 'Upload Videos',
            value: _uploadVideos,
            onChanged: (v) => setState(() => _uploadVideos = v),
          ),
          const Divider(color: _border, height: 1),
          _buildAccessToggleRow(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Add Notes',
            value: _addNotes,
            onChanged: (v) => setState(() => _addNotes = v),
          ),
          const Divider(color: _border, height: 1),
          _buildAccessToggleRow(
            icon: Icons.edit_square,
            title: 'Edit Existing Records',
            subtitle: 'Allows the client to modify shared records',
            value: _editExistingRecords,
            onChanged: (v) => setState(() => _editExistingRecords = v),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessToggleRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          UlvenikIcon.fromMaterial(icon, color: _sage, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 11.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: _forest,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInviteClientCard() {
    final charCount = _inviteMsgCtrl.text.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.mail_outline_rounded, color: _sage, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Invitation',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'The client will receive an email invitation after saving.',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        height: 1.4,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _sendInvitation,
                activeTrackColor: _forest,
                onChanged: (v) => setState(() => _sendInvitation = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: _border, height: 1),
          const SizedBox(height: 14),
          Row(
            children: const [
              Text(
                'Personal Message',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(width: 5),
              Text(
                '(optional)',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12.5,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _inviteMsgCtrl,
            maxLength: 500,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13.5,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              counterText: '',
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 10),
              hintText:
                  'e.g. Welcome to Ulvenik. I\'m looking forward to working with you and your dog.',
              hintStyle: const TextStyle(
                color: _hintGrey,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.45,
                fontFamily: 'Inter',
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: _forest),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$charCount / 500',
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 11.5,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterSavingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: _sage, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Dog Now',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _addDogNow
                          ? 'Enter initial dog details below to open Dog Profile after saving.'
                          : 'You\'ll be taken to the Client Profile after saving.',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _addDogNow,
                activeTrackColor: _forest,
                onChanged: (v) => setState(() => _addDogNow = v),
              ),
            ],
          ),
          if (_addDogNow) ...[
            const SizedBox(height: 14),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPlainUnderlineField(
                    hint: 'Dog Name (e.g. Koda)',
                    controller: _initialDogNameCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPlainUnderlineField(
                    hint: 'Breed (e.g. Malinois)',
                    controller: _initialDogBreedCtrl,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabeledUnderlineInput({
    IconData? icon,
    bool indentWithoutIcon = false,
    required String label,
    bool isRequired = false,
    bool isOptional = false,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              UlvenikIcon.fromMaterial(icon, color: _sage, size: 16),
              const SizedBox(width: 8),
            ] else if (indentWithoutIcon) ...[
              const SizedBox(width: 24),
            ],
            Text(
              label,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: _greenHeader,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (isOptional)
              const Text(
                ' (optional)',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 12.5,
                  fontFamily: 'Inter',
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _buildPlainUnderlineField(
          hint: hint,
          controller: controller,
          keyboardType: keyboardType,
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 11.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlainUnderlineField({
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 10, top: 2),
        hintText: hint,
        hintStyle: const TextStyle(
          color: _hintGrey,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.14),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _forest),
        ),
      ),
    );
  }
}
