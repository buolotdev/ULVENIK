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

class CreateSportScreen extends StatefulWidget {
  const CreateSportScreen({super.key});

  @override
  State<CreateSportScreen> createState() => _CreateSportScreenState();
}

class _CreateSportScreenState extends State<CreateSportScreen> {
  final _nameController = TextEditingController();
  final _orgController = TextEditingController();
  final _maxScoreController = TextEditingController(text: '300');
  final _passingScoreController = TextEditingController(text: '210');
  String _selectedDog = 'Koda';
  int _numPhases = 3;

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _maxScoreController.dispose();
    _passingScoreController.dispose();
    super.dispose();
  }

  void _saveSport() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a sport name.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Discipline "$name" created successfully.'),
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
          'Create Sport',
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
          _buildFieldHeader('SPORT / DISCIPLINE NAME'),
          const SizedBox(height: 6),
          _buildTextField(_nameController, 'e.g. French Ring Sport', Icons.sports_kabaddi),
          const SizedBox(height: 16),

          _buildFieldHeader('GOVERNING RULEBOOK OR ORGANIZATION'),
          const SizedBox(height: 6),
          _buildTextField(_orgController, 'e.g. USMRA / FCI Commission', Icons.gavel_outlined),
          const SizedBox(height: 16),

          _buildFieldHeader('ASSIGNED CANINE CANDIDATE'),
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
                value: _selectedDog,
                dropdownColor: _carbon,
                icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
                style: const TextStyle(color: _offWhite, fontSize: 14),
                items: ['Koda (Belgian Malinois)', 'Murphy (German Shepherd)', 'All Dogs']
                    .map((d) => DropdownMenuItem(value: d.split(' ')[0], child: Text(d)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedDog = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildFieldHeader('NUMBER OF PHASES / STAGES'),
          const SizedBox(height: 6),
          Row(
            children: [1, 2, 3, 4].map((count) {
              final isSel = _numPhases == count;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ChoiceChip(
                    label: Center(child: Text('$count Phase${count > 1 ? 's' : ''}', style: TextStyle(color: isSel ? _offWhite : _stoneGrey, fontSize: 12))),
                    selected: isSel,
                    selectedColor: _forest,
                    backgroundColor: _carbon,
                    onSelected: (_) => setState(() => _numPhases = count),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader('MAX POINTS'),
                    const SizedBox(height: 6),
                    _buildTextField(_maxScoreController, '300', Icons.numbers, isNum: true),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader('PASSING THRESHOLD'),
                    const SizedBox(height: 6),
                    _buildTextField(_passingScoreController, '210', Icons.check_circle_outline, isNum: true),
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
              onPressed: _saveSport,
              child: const Text('Create & Register Sport', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w700)),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNum = false}) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
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
