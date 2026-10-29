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

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'General Question';
  bool _includeDiagnostics = true;
  bool _hasAttachment = true;
  String _attachmentName = 'screenshot_01.png';
  String _attachmentSize = '1.2 MB';

  final List<String> _categories = [
    'General Question',
    'Account & Sign In',
    'Training & Sessions',
    'Subscription & Billing',
    'Cloud Sync & Offline',
    'Feature Inquiries',
    'Other Issue',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
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

  void _sendSupportRequest() {
    if (_subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a subject for your request.'),
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
          'Request Received',
          style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Your support ticket (#ULV-4920) has been created. A specialist from our team will respond to user@example.com shortly.',
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
      _attachmentName = 'screenshot_01.png';
      _attachmentSize = '1.2 MB';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attachment added: screenshot_01.png'),
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
            // ─── Header: < Contact Support ─────────────────────────
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
                            'Contact Support',
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
                  // ─── NEED SOME HELP? Banner ────────────────────────────
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
                            Icon(Icons.chat_bubble_outline,
                                color: _stoneGrey, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Need some help?',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Our support team is here to help. Complete the form below and we\'ll get back to you as soon as possible.',
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
                          'Support Category',
                          style: TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            dropdownColor: _carbon,
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
                              if (val != null) {
                                setState(() => _selectedCategory = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── SUBJECT ───────────────────────────────────────────
                  _buildSectionHeader('SUBJECT'),
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
                          'Subject',
                          style: TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _subjectController,
                          maxLength: 100,
                          onChanged: (_) => setState(() {}),
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Briefly describe your issue',
                            hintStyle: const TextStyle(
                              color: _mutedGrey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            counterText:
                                '${_subjectController.text.length} / 100',
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
                          'Description',
                          style: TextStyle(color: _stoneGrey, fontSize: 12),
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
                                'Please describe your issue in as much detail as possible...',
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
                          'Screenshots, photos, recordings or documents',
                          style: TextStyle(color: _mutedGrey, fontSize: 12),
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
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.description_outlined,
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
                                      'Helps our team resolve your issue fast',
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
                          _buildDiagnosticRow('Device', 'iPhone 15 Pro'),
                          _buildDivider(),
                          _buildDiagnosticRow('OS Version', 'iOS 17.4'),
                          _buildDivider(),
                          _buildDiagnosticRow(
                              'Subscription', 'Dog Owner Plan'),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── CONTACT EMAIL ─────────────────────────────────────
                  _buildSectionHeader('CONTACT EMAIL'),
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
                        Text(
                          'Reply To',
                          style: TextStyle(color: _stoneGrey, fontSize: 11),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.mail_outline,
                                color: _stoneGrey, size: 18),
                            SizedBox(width: 10),
                            Text(
                              'user@example.com',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── SEND SUPPORT REQUEST ──────────────────────────────
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
                      onPressed: _sendSupportRequest,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_outlined,
                              color: _offWhite, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Send Support Request',
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
