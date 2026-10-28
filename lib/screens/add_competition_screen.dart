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

class AddCompetitionScreen extends StatefulWidget {
  const AddCompetitionScreen({super.key});

  @override
  State<AddCompetitionScreen> createState() => _AddCompetitionScreenState();
}

class _AddCompetitionScreenState extends State<AddCompetitionScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _judgeController = TextEditingController();
  final _decoyController = TextEditingController();
  String _level = 'IGP III';
  String _dog = 'Koda vom Alpenhof';

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _judgeController.dispose();
    _decoyController.dispose();
    super.dispose();
  }

  void _saveTrial() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a competition name.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trial "$name" scheduled successfully.'),
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
          'Add Competition',
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
          _buildFieldHeader('TRIAL / EVENT NAME'),
          const SizedBox(height: 6),
          _buildTextField(_nameController, 'e.g. Pacific Northwest Championship', Icons.emoji_events_outlined),
          const SizedBox(height: 16),

          _buildFieldHeader('DISCIPLINE TIER / LEVEL'),
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
                value: _level,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                style: const TextStyle(color: _offWhite, fontSize: 14),
                items: ['IGP III', 'IGP II', 'IGP I', 'BH / VT', 'FH 1 (Tracking)', 'FH 2 (Advanced)']
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (val) => setState(() => _level = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildFieldHeader('PARTICIPATING CANINE'),
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
                value: _dog,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                style: const TextStyle(color: _offWhite, fontSize: 14),
                items: ['Koda vom Alpenhof', 'Murphy']
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) => setState(() => _dog = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildFieldHeader('LOCATION & VENUE'),
          const SizedBox(height: 6),
          _buildTextField(_locationController, 'e.g. Highland Park Working Grounds', Icons.location_on_outlined),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader('JUDGE'),
                    const SizedBox(height: 6),
                    _buildTextField(_judgeController, 'e.g. D. Müller', Icons.gavel),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader('HEAD DECOY'),
                    const SizedBox(height: 6),
                    _buildTextField(_decoyController, 'e.g. M. Vance', Icons.sports_kabaddi),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _saveTrial,
              child: const Text('Add Trial to Calendar', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: TextField(
        controller: controller,
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
