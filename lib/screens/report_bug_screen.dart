import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _orange = Color(0xFFDD6B20);
const Color _red = Color(0xFFE53E3E);

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final _stepsController = TextEditingController();
  final _expectedController = TextEditingController();
  String _selectedSeverity = 'Medium — Visual or Non-blocking Glitch';
  String _selectedArea = 'Activity Map & GPS Contours';
  bool _includeDiagnostics = true;
  bool _hasAttachedScreenshot = false;

  final List<String> _severities = [
    'Critical — App Crash or Data Loss',
    'High — Session or Drill Failed to Record',
    'Medium — Visual or Non-blocking Glitch',
    'Low — Typo or Cosmetic Inconsistency',
  ];

  final List<String> _areas = [
    'Activity Map & GPS Contours',
    'Timeline & Smart Collections',
    'Training Session Live Telemetry',
    'Health Records & Medication',
    'Widgets & Live Activities',
    'Cloud Sync & Offline Mode',
  ];

  void _submitBug() {
    if (_stepsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the steps to reproduce the bug.'),
          backgroundColor: _red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Bug Report Submitted', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        content: const Text(
          'Issue #BUG-3091 registered with Ulvenik Core Engineering. Diagnostic stack trace and device telemetry have been safely packaged for inspection.',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Close', style: TextStyle(color: _offWhite)),
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report a Bug',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. CLASSIFICATION CARD
          _buildSectionHeader('BUG CLASSIFICATION'),
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
                const Text('Severity Level', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _buildDropdown(_selectedSeverity, _severities, (val) {
                  if (val != null) setState(() => _selectedSeverity = val);
                }),
                const SizedBox(height: 14),

                const Text('Feature Module Affected', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _buildDropdown(_selectedArea, _areas, (val) {
                  if (val != null) setState(() => _selectedArea = val);
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. REPRODUCTION STEPS & DETAILS
          _buildSectionHeader('REPRODUCTION DETAILS'),
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
                const Text('Steps to Reproduce', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _stepsController,
                  maxLines: 3,
                  style: const TextStyle(color: _offWhite, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '1. Started Scent Tracking session\n2. Tapped zoom button on map\n3. Observed screen freeze...',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF131718),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _cardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                const Text('Expected vs Observed Result', style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _expectedController,
                  maxLines: 2,
                  style: const TextStyle(color: _offWhite, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Expected map to recenter smoothly without memory stutter.',
                    hintStyle: const TextStyle(color: _stoneGrey, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF131718),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _cardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Screenshot Attachment Container
                GestureDetector(
                  onTap: () {
                    setState(() => _hasAttachedScreenshot = !_hasAttachedScreenshot);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131718),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _hasAttachedScreenshot ? _mint : Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasAttachedScreenshot ? Icons.check_circle : Icons.add_photo_alternate_outlined,
                          color: _hasAttachedScreenshot ? _mint : _stoneGrey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _hasAttachedScreenshot ? 'Screenshot Attached (bug_capture.png)' : 'Attach Screenshot or Video Clip',
                          style: TextStyle(
                            color: _hasAttachedScreenshot ? _mint : _offWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. SYSTEM TELEMETRY ENVELOPE
          _buildSectionHeader('DIAGNOSTIC ENVELOPE (AUTO-COLLECTED)'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildDiagRow('App Build', 'v2.4.0 (Build 412) • Production'),
                _buildDiagRow('Device Hardware', 'Garmin / Apple Watch Dual Sensor Active'),
                _buildDiagRow('Memory & Storage', '412 MB RAM • 8.2 GB Free'),
                const Divider(color: Color(0x0FFFFFFF), height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _includeDiagnostics,
                        activeColor: _mint,
                        checkColor: Colors.black,
                        onChanged: (val) => setState(() => _includeDiagnostics = val ?? true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Include diagnostic logs & stack trace with report',
                        style: TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. SUBMIT BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submitBug,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bug_report, color: _offWhite, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Submit Bug Report',
                    style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131718),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: _carbon,
        underline: const SizedBox.shrink(),
        isExpanded: true,
        items: items.map((i) {
          return DropdownMenuItem(
            value: i,
            child: Text(i, style: const TextStyle(color: _offWhite, fontSize: 13)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDiagRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          Text(value, style: const TextStyle(color: _offWhite, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomepageScreen()),
                );
              }),
              _buildNavItem(Icons.pets_outlined, 'Dogs', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyDogsScreen()),
                );
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingScreen()),
                );
              }),
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TimelineScreen()),
                );
              }),
              _buildNavItem(Icons.more_horiz, 'More', true, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MorePageScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? _mint : _stoneGrey,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? _mint : _stoneGrey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
