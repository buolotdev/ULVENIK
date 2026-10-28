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

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _clientNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dogNameController = TextEditingController();
  final _breedController = TextEditingController();
  final _notesController = TextEditingController();
  String _program = 'IGP Trial Prep';
  bool _sendInvite = true;

  @override
  void dispose() {
    _clientNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dogNameController.dispose();
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveClient() {
    final name = _clientNameController.text.trim();
    final dog = _dogNameController.text.trim();

    if (name.isEmpty || dog.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both client name and dog name.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Client "$name" and dog "$dog" added successfully.'),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Client',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildFieldHeader('CLIENT HANDLER DETAILS'),
          const SizedBox(height: 6),
          _buildTextField(_clientNameController, 'Handler Full Name', Icons.person_outline),
          const SizedBox(height: 10),
          _buildTextField(_emailController, 'Email Address', Icons.email_outlined, keyboard: TextInputType.emailAddress),
          const SizedBox(height: 10),
          _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboard: TextInputType.phone),
          const SizedBox(height: 20),

          _buildFieldHeader('CANINE STUDENT DETAILS'),
          const SizedBox(height: 6),
          _buildTextField(_dogNameController, 'Dog Name', Icons.pets_outlined),
          const SizedBox(height: 10),
          _buildTextField(_breedController, 'Breed & Age (e.g. Belgian Malinois, 2 yrs)', Icons.badge_outlined),
          const SizedBox(height: 20),

          _buildFieldHeader('TRAINING PROGRAM TIER'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _program,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                style: const TextStyle(color: _offWhite, fontSize: 14),
                items: ['IGP Trial Prep', 'Puppy Foundation', 'Behavior Modification', 'Competition Agility', 'Private Working Session']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _program = val!),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildFieldHeader('INITIAL ASSESSMENT & NOTES'),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Drive state, current obedience level, bite grip assessment...',
                hintStyle: TextStyle(color: _stoneGrey, fontSize: 12),
                contentPadding: EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            value: _sendInvite,
            onChanged: (val) => setState(() => _sendInvite = val),
            activeThumbColor: _mint,
            contentPadding: EdgeInsets.zero,
            title: const Text('Send Client Portal Invite', style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
            subtitle: const Text('Sends an automated login link to view assigned homework', style: TextStyle(color: _stoneGrey, fontSize: 11)),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _saveClient,
              child: const Text('Onboard Client & Register Dog', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFieldHeader(String title) {
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: _offWhite, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: _mint, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
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
