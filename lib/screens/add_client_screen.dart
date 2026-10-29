import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _nicknameController = TextEditingController();

  final _emailController = TextEditingController();
  final _mobileController = TextEditingController(text: '+47 912 34 567');
  final _altPhoneController = TextEditingController(text: '+47 480 12 345');

  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final String _selectedCountry = 'Norway';

  final _notesController = TextEditingController();
  final _personalMessageController = TextEditingController();

  String _trainerPermission = 'STANDARD TRAINER';

  bool _permViewTraining = true;
  bool _permViewHealth = true;
  bool _permViewGoals = true;
  bool _permViewReports = false;
  bool _permUploadVideos = false;
  bool _permAddNotes = false;
  bool _permEditExisting = false;

  bool _sendInvitation = true;
  bool _addDogNow = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _altPhoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _notesController.dispose();
    _personalMessageController.dispose();
    super.dispose();
  }

  void _createClient() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final name = first.isEmpty ? 'New Client' : '$first $last';

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Client "$name" created successfully.'),
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
          'Add Client',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createClient,
            child: const Text('Save', style: TextStyle(color: _stoneGrey, fontSize: 15)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BASIC INFORMATION
              _buildSectionHeader('BASIC INFORMATION'),
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
                        hintText: 'e.g. Emma',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Last Name *', style: TextStyle(color: _stoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                    TextField(
                      controller: _lastNameController,
                      style: const TextStyle(color: _offWhite, fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Johnson',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
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
                        hintText: 'e.g. K9 Sports Club',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Icon(Icons.local_offer_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Text('Nickname (optional)', style: TextStyle(color: _stoneGrey, fontSize: 13)),
                      ],
                    ),
                    TextField(
                      controller: _nicknameController,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Em',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Used internally by the trainer only',
                      style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
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
                        hintText: 'e.g. emma.johnson@example.com',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('Used to send the client invitation', style: TextStyle(color: _stoneGrey, fontSize: 11)),
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
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.place_outlined, size: 16, color: _stoneGrey),
                        SizedBox(width: 8),
                        Expanded(child: Text('Add Address (optional)', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600))),
                        Icon(Icons.keyboard_arrow_down, color: _stoneGrey),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _addressLine1Controller,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Address Line 1',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressLine2Controller,
                      style: const TextStyle(color: _offWhite, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Address Line 2 (optional)',
                        hintStyle: TextStyle(color: _stoneGrey),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            style: const TextStyle(color: _offWhite, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Town / City',
                              hintStyle: TextStyle(color: _stoneGrey),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _postcodeController,
                            style: const TextStyle(color: _offWhite, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Postcode / ZIP',
                              hintStyle: TextStyle(color: _stoneGrey),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
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
                      decoration: const InputDecoration(
                        hintText: 'Add private notes about this client — preferred contact times, observations, reminders...',
                        hintStyle: TextStyle(color: _stoneGrey),
                        border: InputBorder.none,
                      ),
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
              const Text('What you can do once the client accepts', style: TextStyle(color: _stoneGrey, fontSize: 12)),
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
                    const Text('Permissions can be adjusted at any time from the client profile.', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // CLIENT ACCESS
              _buildSectionHeader('CLIENT ACCESS'),
              const Text('What the client can see and do', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  children: [
                    _buildSwitchTile(Icons.assignment_outlined, 'View Training Records', _permViewTraining, (v) => setState(() => _permViewTraining = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchTile(Icons.favorite_border, 'View Health Records', _permViewHealth, (v) => setState(() => _permViewHealth = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchTile(Icons.gps_fixed, 'View Goals', _permViewGoals, (v) => setState(() => _permViewGoals = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchTile(Icons.description_outlined, 'View Reports', _permViewReports, (v) => setState(() => _permViewReports = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchTile(Icons.videocam_outlined, 'Upload Videos', _permUploadVideos, (v) => setState(() => _permUploadVideos = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchTile(Icons.chat_bubble_outline, 'Add Notes', _permAddNotes, (v) => setState(() => _permAddNotes = v)),
                    const Divider(color: _cardBorder, height: 1),
                    _buildSwitchTile(
                      Icons.edit_outlined,
                      'Edit Existing Records',
                      _permEditExisting,
                      (v) => setState(() => _permEditExisting = v),
                      subtitle: 'Allows the client to modify shared records',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // INVITE CLIENT
              _buildSectionHeader('INVITE CLIENT'),
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
                      children: [
                        const Icon(Icons.email_outlined, color: _stoneGrey, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Send Invitation', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('The client will receive an email invitation after saving.', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _sendInvitation,
                          activeThumbColor: _mint,
                          activeTrackColor: _forest,
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: const Color(0xFF262C30),
                          onChanged: (v) => setState(() => _sendInvitation = v),
                        ),
                      ],
                    ),
                    const Divider(color: _cardBorder, height: 24),
                    const Text('Personal Message (optional)', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _personalMessageController,
                      maxLines: 3,
                      style: const TextStyle(color: _offWhite, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: "e.g. Welcome to Ulvenik. I'm looking forward to working with you and your dog.",
                        hintStyle: TextStyle(color: _stoneGrey),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_personalMessageController.text.length} / 500',
                        style: const TextStyle(color: _stoneGrey, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // AFTER SAVING
              _buildSectionHeader('AFTER SAVING'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pets, color: _stoneGrey, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Add Dog Now', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                          Text("You'll be taken to the Client Profile after saving.", style: TextStyle(color: _stoneGrey, fontSize: 11)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _addDogNow,
                      activeThumbColor: _mint,
                      activeTrackColor: _forest,
                      inactiveThumbColor: _stoneGrey,
                      inactiveTrackColor: const Color(0xFF262C30),
                      onChanged: (v) => setState(() => _addDogNow = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Create Client Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _createClient,
                  child: const Text('Create Client', style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w700)),
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

  Widget _buildSwitchTile(
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
