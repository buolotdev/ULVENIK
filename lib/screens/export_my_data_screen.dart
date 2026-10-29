import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ExportMyDataScreen extends StatefulWidget {
  const ExportMyDataScreen({super.key});

  @override
  State<ExportMyDataScreen> createState() => _ExportMyDataScreenState();
}

class _ExportMyDataScreenState extends State<ExportMyDataScreen> {
  // Category expanded states
  bool _accountExpanded = true;
  bool _dogsExpanded = false;
  bool _trainingExpanded = false;
  bool _healthExpanded = false;
  bool _mediaExpanded = false;
  bool _packsExpanded = false;

  // Account checkboxes
  bool _accInfo = true;
  bool _accPreferences = true;
  bool _accCalendar = true;
  bool _accSkills = true;
  bool _accExercises = true;
  bool _accEquipment = false;
  bool _accRewards = false;

  // Other checkboxes
  bool _dogsSelected = true;
  bool _trainingSelected = true;
  bool _healthSelected = true;
  bool _mediaSelected = true;
  bool _packsSelected = true;

  // Formats
  String _exportFormat = 'ZIP Archive';
  String _mediaQuality = 'Original Quality';
  String _dateRange = 'All Data';
  bool _protectWithPassword = false;
  bool _isExporting = false;

  void _toggleSelectAll() {
    final allTrue = _accInfo && _accPreferences && _accCalendar && _accSkills && _accExercises && _accEquipment && _accRewards;
    setState(() {
      _accInfo = !allTrue;
      _accPreferences = !allTrue;
      _accCalendar = !allTrue;
      _accSkills = !allTrue;
      _accExercises = !allTrue;
      _accEquipment = !allTrue;
      _accRewards = !allTrue;
      _dogsSelected = !allTrue;
      _trainingSelected = !allTrue;
      _healthSelected = !allTrue;
      _mediaSelected = !allTrue;
      _packsSelected = !allTrue;
    });
  }

  void _generateExport() async {
    setState(() => _isExporting = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isExporting = false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Export Ready', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
        content: const Text(
          'Your export archive (ulvenik_export_2026.zip • 1.2 GB) has been generated. The download will start automatically, and a secure download link was sent to your email.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: _offWhite)),
          ),
        ],
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
          'Export My Data',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // HERO BANNER
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.cloud_download_outlined, color: _mint, size: 24),
                SizedBox(height: 12),
                Text(
                  'Export Your Data',
                  style: TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Generate a downloadable copy of your Ulvenik account information. This export is for your personal records and is prepared securely.',
                  style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SELECT DATA TO INCLUDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SELECT DATA TO INCLUDE',
                style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              InkWell(
                onTap: _toggleSelectAll,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_box_outlined, color: _stoneGrey, size: 14),
                      SizedBox(width: 6),
                      Text('Select All', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Account Accordion
          _buildAccordionCard(
            icon: Icons.person_outline,
            title: 'Account',
            subtitle: null,
            isExpanded: _accountExpanded,
            onToggle: () => setState(() => _accountExpanded = !_accountExpanded),
            children: [
              _buildCheckboxTile('Account Information', _accInfo, (v) => setState(() => _accInfo = v)),
              _buildCheckboxTile('Saved Preferences', _accPreferences, (v) => setState(() => _accPreferences = v)),
              _buildCheckboxTile('Calendar & Reminders', _accCalendar, (v) => setState(() => _accCalendar = v)),
              _buildCheckboxTile('Custom Skills', _accSkills, (v) => setState(() => _accSkills = v)),
              _buildCheckboxTile('Custom Exercises', _accExercises, (v) => setState(() => _accExercises = v)),
              _buildCheckboxTile('Equipment', _accEquipment, (v) => setState(() => _accEquipment = v)),
              _buildCheckboxTile('Rewards', _accRewards, (v) => setState(() => _accRewards = v)),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Dogs
          _buildAccordionCard(
            icon: Icons.pets_outlined,
            title: 'Dogs',
            subtitle: 'Dog Profiles',
            isExpanded: _dogsExpanded,
            onToggle: () => setState(() => _dogsExpanded = !_dogsExpanded),
            children: [
              _buildCheckboxTile('All Dog Profiles', _dogsSelected, (v) => setState(() => _dogsSelected = v)),
            ],
          ),
          const SizedBox(height: 8),

          // 3. Training
          _buildAccordionCard(
            icon: Icons.fitness_center_outlined,
            title: 'Training',
            subtitle: 'Training Records • S&C • Goals • Statistics',
            isExpanded: _trainingExpanded,
            onToggle: () => setState(() => _trainingExpanded = !_trainingExpanded),
            children: [
              _buildCheckboxTile('Include Training & Telemetry', _trainingSelected, (v) => setState(() => _trainingSelected = v)),
            ],
          ),
          const SizedBox(height: 8),

          // 4. Health
          _buildAccordionCard(
            icon: Icons.favorite_border,
            title: 'Health',
            subtitle: 'Health Records • Medications • Vaccinations',
            isExpanded: _healthExpanded,
            onToggle: () => setState(() => _healthExpanded = !_healthExpanded),
            children: [
              _buildCheckboxTile('Include Health & Veterinary Data', _healthSelected, (v) => setState(() => _healthSelected = v)),
            ],
          ),
          const SizedBox(height: 8),

          // 5. Media & Documents
          _buildAccordionCard(
            icon: Icons.image_outlined,
            title: 'Media & Documents',
            subtitle: 'Photos • Videos • Documents • Notes',
            isExpanded: _mediaExpanded,
            onToggle: () => setState(() => _mediaExpanded = !_mediaExpanded),
            children: [
              _buildCheckboxTile('Include Photos & Videos', _mediaSelected, (v) => setState(() => _mediaSelected = v)),
            ],
          ),
          const SizedBox(height: 8),

          // 6. Packs
          _buildAccordionCard(
            icon: Icons.inventory_2_outlined,
            title: 'Packs',
            subtitle: 'Competitions (Sport Pack) • Trainer Pack Data',
            isExpanded: _packsExpanded,
            onToggle: () => setState(() => _packsExpanded = !_packsExpanded),
            children: [
              _buildCheckboxTile('Include Sport & Trainer Data', _packsSelected, (v) => setState(() => _packsSelected = v)),
            ],
          ),
          const SizedBox(height: 28),

          // EXPORT FORMAT
          const Text(
            'EXPORT FORMAT',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildRadioTile(
                  icon: Icons.folder_zip_outlined,
                  title: 'ZIP Archive',
                  subtitle: 'Recommended. Everything in one compressed file.',
                  value: 'ZIP Archive',
                  groupValue: _exportFormat,
                  onChanged: (v) => setState(() => _exportFormat = v),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildRadioTile(
                  icon: Icons.description_outlined,
                  title: 'PDF Summary',
                  subtitle: 'Readable summary of your records. No raw data.',
                  value: 'PDF Summary',
                  groupValue: _exportFormat,
                  onChanged: (v) => setState(() => _exportFormat = v),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildRadioTile(
                  icon: Icons.table_chart_outlined,
                  title: 'CSV Data',
                  subtitle: 'Spreadsheet-compatible. Excludes media.',
                  value: 'CSV Data',
                  groupValue: _exportFormat,
                  onChanged: (v) => setState(() => _exportFormat = v),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildRadioTile(
                  icon: Icons.code,
                  title: 'JSON Backup',
                  subtitle: 'Advanced. Full structured data export.',
                  value: 'JSON Backup',
                  groupValue: _exportFormat,
                  onChanged: (v) => setState(() => _exportFormat = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // MEDIA QUALITY
          const Text(
            'MEDIA QUALITY',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'Original Quality',
                  subtitle: 'Full resolution. Larger file size.',
                  value: 'Original Quality',
                  groupValue: _mediaQuality,
                  onChanged: (v) => setState(() => _mediaQuality = v),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildRadioTile(
                  title: 'Optimised Quality',
                  subtitle: 'Reduced size. Suitable for most purposes.',
                  value: 'Optimised Quality',
                  groupValue: _mediaQuality,
                  onChanged: (v) => setState(() => _mediaQuality = v),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildRadioTile(
                  title: 'Exclude Media',
                  subtitle: 'Only export records and documents.',
                  value: 'Exclude Media',
                  groupValue: _mediaQuality,
                  onChanged: (v) => setState(() => _mediaQuality = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Estimated export size: 1.2 GB',
              style: TextStyle(color: _stoneGrey, fontSize: 11),
            ),
          ),
          const SizedBox(height: 28),

          // DATE RANGE
          const Text(
            'DATE RANGE',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildRadioTile(
                  title: 'All Data',
                  subtitle: 'Export everything in your account',
                  value: 'All Data',
                  groupValue: _dateRange,
                  onChanged: (v) => setState(() => _dateRange = v),
                ),
                const Divider(color: _cardBorder, height: 1),
                _buildRadioTile(
                  title: 'Custom Date Range',
                  subtitle: null,
                  value: 'Custom Date Range',
                  groupValue: _dateRange,
                  onChanged: (v) => setState(() => _dateRange = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // SECURITY
          const Text(
            'SECURITY',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: _stoneGrey, size: 20),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protect with Password',
                        style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Encrypts your export. Ulvenik does not store this password.',
                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _protectWithPassword,
                  activeThumbColor: _mint,
                  activeTrackColor: _forest,
                  onChanged: (v) => setState(() => _protectWithPassword = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // GENERATE EXPORT BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isExporting ? null : _generateExport,
              child: _isExporting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _offWhite, strokeWidth: 2))
                  : const Text('Generate Export', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Export files are prepared securely and links expire after 48 hours.',
              style: TextStyle(color: _stoneGrey, fontSize: 11),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAccordionCard({
    required IconData icon,
    required String title,
    required String? subtitle,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, color: _stoneGrey, size: 20),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                        ],
                      ],
                    ),
                  ),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _stoneGrey),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(color: _cardBorder, height: 1),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(String label, bool value, ValueChanged<bool> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: _offWhite, fontSize: 13)),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? _forest : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: value ? _forest : _stoneGrey, width: 1.5),
              ),
              child: value ? const Icon(Icons.check, color: _offWhite, size: 14) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    IconData? icon,
    required String title,
    required String? subtitle,
    required String value,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: _stoneGrey, size: 20),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 12)),
                  ],
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? _mint : _stoneGrey, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: _mint,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
