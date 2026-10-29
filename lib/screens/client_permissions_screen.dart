import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ClientPermissionsScreen extends StatefulWidget {
  final String clientName;

  const ClientPermissionsScreen({
    super.key,
    this.clientName = 'Take the Lead Essex',
  });

  @override
  State<ClientPermissionsScreen> createState() =>
      _ClientPermissionsScreenState();
}

class _ClientPermissionsScreenState extends State<ClientPermissionsScreen> {
  bool _viewDogProfile = true;
  bool _editDogInfo = false;

  bool _viewTraining = true;
  bool _createTraining = true;
  bool _editSharedSessions = false;

  bool _viewHealth = false;
  bool _addHealth = false;

  bool _viewGoals = true;
  bool _createEditGoals = true;
  bool _assignHomework = true;

  bool _viewMedia = true;
  bool _uploadMedia = true;

  void _savePermissions() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permissions updated successfully.'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Permissions',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _savePermissions,
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Hero Connection Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF14241E),
                      border: Border.all(color: const Color(0x3334D399)),
                    ),
                    child: const Icon(Icons.person, color: _mint, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.clientName,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x1F34D399),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'TRAINER PACK',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Liv Old • Professional Trainer',
                          style: TextStyle(color: _stoneGrey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.circle, color: Color(0xFF34D399), size: 6),
                            SizedBox(width: 6),
                            Text(
                              'Connected • Active since July 2026',
                              style: TextStyle(color: _stoneGrey, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Info Callout
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF14191E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: Row(
                children: const [
                  Icon(Icons.history_outlined, color: Color(0xFF5D8FAF), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You can change these settings at any time. Changes take effect immediately.',
                      style: TextStyle(color: _stoneGrey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'DOG PROFILE',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    'View Dog Profile',
                    "Allow trainer to view your dog's details",
                    _viewDogProfile,
                    (v) => setState(() => _viewDogProfile = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Edit Dog Information',
                    'Allow trainer to update basic profile details',
                    _editDogInfo,
                    (v) => setState(() => _editDogInfo = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'TRAINING',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    'View Training Sessions',
                    'See sessions recorded by you',
                    _viewTraining,
                    (v) => setState(() => _viewTraining = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Create Training Sessions',
                    "Record sessions on your dog's behalf",
                    _createTraining,
                    (v) => setState(() => _createTraining = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Edit Shared Sessions',
                    'Make changes to existing records',
                    _editSharedSessions,
                    (v) => setState(() => _editSharedSessions = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'HEALTH RECORDS',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Private by default',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    'View Health Records',
                    'See vet visits, medications, injuries',
                    _viewHealth,
                    (v) => setState(() => _viewHealth = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Add Health Records',
                    'Record health updates',
                    _addHealth,
                    (v) => setState(() => _addHealth = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'GOALS & HOMEWORK',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    'View Goals',
                    'See active and completed goals',
                    _viewGoals,
                    (v) => setState(() => _viewGoals = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Create & Edit Goals',
                    'Assign new goals to your dog',
                    _createEditGoals,
                    (v) => setState(() => _createEditGoals = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Assign Homework',
                    'Set practice assignments',
                    _assignHomework,
                    (v) => setState(() => _assignHomework = v),
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

            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    'View Photos & Videos',
                    'Allow trainer to view uploaded training media',
                    _viewMedia,
                    (v) => setState(() => _viewMedia = v),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildToggleRow(
                    'Upload Media',
                    'Add photos and videos to sessions',
                    _uploadMedia,
                    (v) => setState(() => _uploadMedia = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'CONNECTION',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing paused.'), backgroundColor: _forest),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Pause Sharing', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text("Temporarily hide your dog's records from this trainer", style: TextStyle(color: _stoneGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trainer disconnected.'), backgroundColor: Colors.redAccent),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Disconnect Trainer', style: TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text('Remove all access. Existing records are preserved.', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _offWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _stoneGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
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
