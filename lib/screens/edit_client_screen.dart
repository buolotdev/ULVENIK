import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class EditClientScreen extends StatefulWidget {
  final String initialName;
  final String initialDog;

  const EditClientScreen({
    super.key,
    this.initialName = 'Emma Johnson',
    this.initialDog = 'Murphy',
  });

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _prefNameController;
  late final TextEditingController _companyController;

  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _altPhoneController;

  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _postcodeController;
  final String _selectedCountry = 'Norway';

  late final TextEditingController _notesController;

  String _trainerPermission = 'STANDARD TRAINER';
  String _clientStatus = 'ACTIVE';

  bool _permViewTraining = true;
  bool _permAddTraining = true;
  bool _permEditTraining = true;
  bool _permViewHealth = true;
  bool _permEditHealth = false;
  bool _permCreateGoals = true;
  bool _permUploadVideos = false;
  bool _permViewReports = true;
  bool _permExportReports = false;

  @override
  void initState() {
    super.initState();
    final parts = widget.initialName.split(' ');
    _firstNameController = TextEditingController(text: parts.isNotEmpty ? parts.first : 'Emma');
    _lastNameController = TextEditingController(text: parts.length > 1 ? parts.sublist(1).join(' ') : 'Johnson');
    _prefNameController = TextEditingController(text: 'Em');
    _companyController = TextEditingController(text: 'K9 Sports Club Norway');

    _emailController = TextEditingController(text: 'emma.johnson@example.com');
    _mobileController = TextEditingController(text: '+47 912 34 567');
    _altPhoneController = TextEditingController(text: '+47 480 12 345');

    _addressLine1Controller = TextEditingController(text: 'Holmenkollveien 42');
    _addressLine2Controller = TextEditingController(text: 'Apartment 3B');
    _cityController = TextEditingController(text: 'Oslo');
    _postcodeController = TextEditingController(text: '0784');

    _notesController = TextEditingController(
      text:
          'Prefers morning sessions before 10:00. Responds best to structured IGP obedience homework. Murphy has high toy drive,',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _prefNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _altPhoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Client profile updated successfully.'),
        backgroundColor: _forest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: _stoneGrey, fontSize: 15)),
        ),
        title: const Text(
          'Edit Client',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF34D399),
                fontSize: 15,
                fontWeight: FontWeight.w700,
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
              // Client Avatar with Photo Edit Badge
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF262C30),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'EJ',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: _carbon,
                              shape: BoxShape.circle,
                              border: Border.all(color: _cardBorder),
                            ),
                            child: const Icon(Icons.camera_alt_outlined, color: _stoneGrey, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_firstNameController.text} ${_lastNameController.text}',
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0x1F34D399),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.circle, color: Color(0xFF34D399), size: 6),
                          SizedBox(width: 5),
                          Text(
                            'ACTIVE CLIENT',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // PERSONAL INFORMATION
              _buildSectionHeader('PERSONAL INFORMATION'),
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
                        Icon(Icons.person_outline, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('First Name *', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    TextField(
                      controller: _firstNameController,
                      style: const TextStyle(color: _offWhite, fontSize: 15),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
                    const Text('Last Name *', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                    TextField(
                      controller: _lastNameController,
                      style: const TextStyle(color: _offWhite, fontSize: 15),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 18),
                    const Text('Preferred Name (optional)', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                    TextField(
                      controller: _prefNameController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Used informally within Trainer Pack',
                      style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Icon(Icons.business_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Company (optional)', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _companyController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // CONTACT INFORMATION
              _buildSectionHeader('CONTACT INFORMATION'),
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
                        Icon(Icons.email_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Email Address', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Icon(Icons.phone_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Mobile Number', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _mobileController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Icon(Icons.phone_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Alternative Number (optional)', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _altPhoneController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // ADDRESS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('ADDRESS', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                  Text('For trainer records only — not shared with the client', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                ],
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
                    const Text('Address Line 1', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    TextField(
                      controller: _addressLine1Controller,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Address Line 2 (optional)', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    TextField(
                      controller: _addressLine2Controller,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Town / City', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              TextField(
                                controller: _cityController,
                                style: const TextStyle(color: _offWhite, fontSize: 14),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Postcode / ZIP', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              TextField(
                                controller: _postcodeController,
                                style: const TextStyle(color: _offWhite, fontSize: 14),
                                decoration: const InputDecoration(
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
                    const SizedBox(height: 14),
                    const Text('Country', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedCountry, style: const TextStyle(color: _offWhite, fontSize: 14)),
                        const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 13),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // TRAINER NOTES
              _buildSectionHeader('TRAINER NOTES'),
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
                        Icon(Icons.lock_outline, size: 14, color: _stoneGrey),
                        SizedBox(width: 6),
                        Text('Private to you only', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                    const Divider(color: _cardBorder, height: 16),
                    const Text('These notes are only visible to you. The client cannot see them.', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14191E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: _mint, size: 14),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Trainer notes are private and never shared with clients.',
                              style: TextStyle(color: _stoneGrey, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // TRAINER PERMISSIONS
              _buildSectionHeader('TRAINER PERMISSIONS'),
              const Text("What you can do on this client's account", style: TextStyle(color: _stoneGrey, fontSize: 12)),
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
                    Wrap(
                      spacing: 8,
                      children: ['VIEW ONLY', 'STANDARD TRAINER', 'FULL ACCESS'].map((tp) {
                        final isSel = _trainerPermission == tp;
                        return InkWell(
                          onTap: () => setState(() => _trainerPermission = tp),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0x1F34D399) : const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
                            ),
                            child: Text(
                              tp,
                              style: TextStyle(
                                color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text('Changes take effect immediately after saving.', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // INDIVIDUAL PERMISSIONS
              _buildSectionHeader('INDIVIDUAL PERMISSIONS'),
              const Text('Customise access beyond the preset', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(Icons.assignment_outlined, 'View Training', _permViewTraining, (v) => setState(() => _permViewTraining = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(Icons.add_task, 'Add Training Sessions', _permAddTraining, (v) => setState(() => _permAddTraining = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(
                      Icons.edit_outlined,
                      'Edit Training Sessions',
                      _permEditTraining,
                      (v) => setState(() => _permEditTraining = v),
                      subtitle: 'Allows modifying existing session records',
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(Icons.favorite_border, 'View Health', _permViewHealth, (v) => setState(() => _permViewHealth = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(
                      Icons.edit_outlined,
                      'Edit Health',
                      _permEditHealth,
                      (v) => setState(() => _permEditHealth = v),
                      subtitle: 'Allows editing health records',
                    ),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(Icons.gps_fixed, 'Create Goals', _permCreateGoals, (v) => setState(() => _permCreateGoals = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(Icons.videocam_outlined, 'Upload Videos', _permUploadVideos, (v) => setState(() => _permUploadVideos = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(Icons.description_outlined, 'View Reports', _permViewReports, (v) => setState(() => _permViewReports = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchRow(Icons.file_upload_outlined, 'Export Reports', _permExportReports, (v) => setState(() => _permExportReports = v)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // CLIENT STATUS
              _buildSectionHeader('CLIENT STATUS'),
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
                      children: ['ACTIVE', 'INACTIVE', 'ARCHIVED'].map((st) {
                        final isSel = _clientStatus == st;
                        return InkWell(
                          onTap: () => setState(() => _clientStatus = st),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0x1F34D399) : const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
                            ),
                            child: Text(
                              st,
                              style: TextStyle(
                                color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text('Client appears in your main Client List.', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _saveChanges,
                  child: const Text('Save Changes', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: _stoneGrey, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: _stoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    IconData icon,
    String title,
    bool val,
    ValueChanged<bool> onChanged, {
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: _stoneGrey, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: _offWhite, fontSize: 14)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                ],
              ],
            ),
          ),
          Switch(
            value: val,
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveThumbColor: _stoneGrey,
            inactiveTrackColor: const Color(0xFF262C30),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
