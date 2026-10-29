import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);

class EditProfileScreen extends StatefulWidget {
  final String initialFirstName;
  final String initialLastName;

  const EditProfileScreen({
    super.key,
    this.initialFirstName = 'James',
    this.initialLastName = 'Harlow',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _displayNameController;

  String _country = 'United Kingdom';
  String _language = 'English';
  String _timeZone = 'GMT+0';
  String _weightUnit = 'Kilograms (kg)';
  String _distanceUnit = 'Kilometres';
  String _tempUnit = 'Celsius (°C)';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _displayNameController = TextEditingController(
      text: '${widget.initialFirstName} ${widget.initialLastName}',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
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

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile changes successfully saved.'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Edit Profile | Save ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Edit Profile',
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
                  TextButton(
                    onPressed: _saveProfile,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                  // ─── PERSONAL INFORMATION ──────────────────────────────
                  _buildSectionHeader('PERSONAL INFORMATION'),
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
                        const Text('FIRST NAME', style: TextStyle(color: _mutedGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _firstNameController,
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: 8),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x1AFFFFFF))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('LAST NAME', style: TextStyle(color: _mutedGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _lastNameController,
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: 8),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x1AFFFFFF))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('DISPLAY NAME', style: TextStyle(color: _mutedGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _displayNameController,
                          style: const TextStyle(color: _offWhite, fontSize: 14),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: 8),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x1AFFFFFF))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Shown in Trainer Pack, shared reports and future public profiles.',
                          style: TextStyle(color: _mutedGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── REGIONAL SETTINGS ─────────────────────────────────
                  _buildSectionHeader('REGIONAL SETTINGS'),
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
                        _buildDropdownField(
                          label: 'COUNTRY',
                          value: _country,
                          items: ['United Kingdom', 'United States', 'Germany', 'Norway', 'Sweden', 'Pakistan'],
                          onChanged: (v) => setState(() => _country = v!),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'LANGUAGE',
                          value: _language,
                          items: ['English', 'Deutsch', 'Norsk', 'Svenska'],
                          onChanged: (v) => setState(() => _language = v!),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'TIME ZONE',
                          value: _timeZone,
                          items: ['GMT+0', 'CET (UTC+1)', 'EST (UTC-5)', 'PST (UTC-8)', 'Asia/Karachi (PKT, UTC+5)'],
                          onChanged: (v) => setState(() => _timeZone = v!),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Auto-detected from device. Changes update reminders and calendar.',
                          style: TextStyle(color: _mutedGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── MEASUREMENT PREFERENCES ───────────────────────────
                  _buildSectionHeader('MEASUREMENT PREFERENCES'),
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
                        _buildDropdownField(
                          label: 'WEIGHT',
                          value: _weightUnit,
                          items: ['Kilograms (kg)', 'Pounds (lbs)'],
                          onChanged: (v) => setState(() => _weightUnit = v!),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'DISTANCE',
                          value: _distanceUnit,
                          items: ['Kilometres', 'Miles'],
                          onChanged: (v) => setState(() => _distanceUnit = v!),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'TEMPERATURE',
                          value: _tempUnit,
                          items: ['Celsius (°C)', 'Fahrenheit (°F)'],
                          onChanged: (v) => setState(() => _tempUnit = v!),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Changing units only affects how values are displayed. Stored data is never modified.',
                          style: TextStyle(color: _mutedGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── ACCOUNT ───────────────────────────────────────────
                  _buildSectionHeader('ACCOUNT'),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChangeEmailScreen()),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.mail_outline, color: _stoneGrey, size: 20),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Email Address',
                                            style: TextStyle(
                                              color: _offWhite,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF162E25),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'VERIFIED',
                                              style: TextStyle(
                                                color: _mint,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'j***@example.com',
                                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Color(0x0FFFFFFF), indent: 50),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline, color: _stoneGrey, size: 20),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Password',
                                        style: TextStyle(
                                          color: _offWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Last changed 3 months ago',
                                        style: TextStyle(color: _stoneGrey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── SAVE CHANGES BUTTON ───────────────────────────────
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
                      onPressed: _saveProfile,
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _mutedGrey,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: _carbon,
            icon: const Icon(Icons.keyboard_arrow_down, color: _stoneGrey),
            items: items.map((it) {
              return DropdownMenuItem<String>(
                value: it,
                child: Text(
                  it,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
