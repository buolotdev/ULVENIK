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
const Color _mutedGrey = Color(0xFF718096);
const Color _syncGreen = Color(0xFF4ADE80);

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _stepsController = TextEditingController();

  String? _selectedCategory;
  bool _includeDiagnostics = true;
  bool _hasAttachment = true;
  String _attachmentName = 'bug_screenshot.png';
  String _attachmentSize = '2.1 MB';

  final List<String> _categories = [
    'Training & Sessions',
    'Health & Medication',
    'Offline Sync & Storage',
    'GPS & Activity Maps',
    'User Interface & Layout',
    'Performance & Freezes',
    'Other / Unspecified',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }
    Widget target;
    switch (index) {
      case 0:
        target = const HomepageScreen();
        break;
      case 1:
        target = const MyDogsScreen();
        break;
      case 2:
        target = const TrainingScreen();
        break;
      case 3:
        target = const TimelineScreen();
        break;
      case 4:
        target = const MorePageScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  void _submitReport() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a brief bug title.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Bug Report Submitted',
          style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Thank you for reporting this issue. Our team has received your logs and telemetry and will investigate shortly.',
          style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _forest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  void _addAttachment() {
    setState(() {
      _hasAttachment = true;
      _attachmentName = 'bug_screenshot.png';
      _attachmentSize = '2.1 MB';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attachment added: bug_screenshot.png'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Report a Bug ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Report a Bug',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── BUG REPORT Banner ─────────────────────────────────
                  _buildSectionHeader('BUG REPORT'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                color: _stoneGrey, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Found something that isn\'t working?',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Help us improve Ulvenik by reporting the issue below. The more detail you provide, the faster we can investigate.',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── CATEGORY ──────────────────────────────────────────
                  _buildSectionHeader('CATEGORY'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bug Category',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            dropdownColor: _carbon,
                            hint: const Text(
                              'Select a category',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 14,
                              ),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: _stoneGrey),
                            items: _categories.map((c) {
                              return DropdownMenuItem<String>(
                                value: c,
                                child: Text(
                                  c,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── TITLE ─────────────────────────────────────────────
                  _buildSectionHeader('TITLE'),
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
                        const Text(
                          'Bug Title',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _titleController,
                          maxLength: 100,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Briefly describe the issue',
                            hintStyle: const TextStyle(
                              color: _mutedGrey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            counterText:
                                '${_titleController.text.length} / 100',
                            counterStyle: const TextStyle(
                              color: _mutedGrey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── DESCRIPTION ───────────────────────────────────────
                  _buildSectionHeader('DESCRIPTION'),
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
                        const Text(
                          'What happened?',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descController,
                          maxLines: 4,
                          maxLength: 5000,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText:
                                'Tell us exactly what happened. Include what you expected and what actually occurred.',
                            hintStyle: const TextStyle(
                              color: _mutedGrey,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            border: InputBorder.none,
                            counterText:
                                '${_descController.text.length} / 5,000',
                            counterStyle: const TextStyle(
                              color: _mutedGrey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── STEPS TO REPRODUCE ─────────────────────────────────
                  _buildSectionHeader('STEPS TO REPRODUCE'),
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
                        const Text(
                          'Steps to Reproduce • Optional',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _stepsController,
                          maxLines: 4,
                          maxLength: 2000,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(
                            color: _offWhite,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText:
                                '1. Open Dog Profile\n2. Tap Training\n3. Add Session\n4. App closes',
                            hintStyle: TextStyle(
                              color: _mutedGrey.withValues(alpha: 0.8),
                              fontFamily: 'monospace',
                              fontSize: 13,
                              height: 1.4,
                            ),
                            border: InputBorder.none,
                            counterText:
                                '${_stepsController.text.length} / 2,000',
                            counterStyle: const TextStyle(
                              color: _mutedGrey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── ATTACHMENTS ───────────────────────────────────────
                  _buildSectionHeader('ATTACHMENTS'),
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
                        // Dashed button
                        InkWell(
                          onTap: _addAttachment,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14191C),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _stoneGrey.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.attach_file,
                                    color: _stoneGrey, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Add Attachment',
                                  style: TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Screenshots, recordings or documents',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 12,
                          ),
                        ),
                        if (_hasAttachment) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14181B),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _cardBorder,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.image_outlined,
                                    color: _stoneGrey, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _attachmentName,
                                    style: const TextStyle(
                                      color: _offWhite,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  _attachmentSize,
                                  style: const TextStyle(
                                    color: _mutedGrey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() => _hasAttachment = false);
                                  },
                                  child: const Icon(Icons.close,
                                      color: _stoneGrey, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── DIAGNOSTICS ───────────────────────────────────────
                  _buildSectionHeader('DIAGNOSTICS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shield_outlined,
                                  color: _stoneGrey, size: 20),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Include Diagnostic Information',
                                      style: TextStyle(
                                        color: _offWhite,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Helps the team investigate and reproduce the issue',
                                      style: TextStyle(
                                        color: _stoneGrey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _includeDiagnostics,
                                activeThumbColor: _forest,
                                activeTrackColor:
                                    _syncGreen.withValues(alpha: 0.6),
                                inactiveThumbColor: _stoneGrey,
                                inactiveTrackColor: _obsidian,
                                onChanged: (val) {
                                  setState(() => _includeDiagnostics = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (_includeDiagnostics) ...[
                          const Divider(height: 1, color: Color(0x0FFFFFFF)),
                          _buildDiagnosticRow('App Version', '2.4.1'),
                          _buildDivider(),
                          _buildDiagnosticRow('Build Number', '241'),
                          _buildDivider(),
                          _buildDiagnosticRow('Device', 'iPhone 15 Pro'),
                          _buildDivider(),
                          _buildDiagnosticRow('OS Version', 'iOS 17.4'),
                          _buildDivider(),
                          _buildDiagnosticRow(
                              'Screen Resolution', '2556 × 1179'),
                          _buildDivider(),
                          _buildDiagnosticRow('Language', 'English (UK)'),
                          _buildDivider(),
                          _buildDiagnosticRow(
                              'Subscription', 'Dog Owner Plan'),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── SUBMIT BUTTON ─────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitReport,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_outlined,
                              color: _offWhite, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Submit Bug Report',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
        onTap: _onBottomNavTapped,
        backgroundColor: _obsidian,
        selectedItemColor: _mint,
        unselectedItemColor: _stoneGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_outlined),
            activeIcon: Icon(Icons.pets),
            label: 'Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildDiagnosticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
