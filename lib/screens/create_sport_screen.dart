import 'package:flutter/material.dart';

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
  final TextEditingController _nameController = TextEditingController(text: 'IGP');
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _orgController.dispose();
    _levelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a sport name.'), backgroundColor: Color(0xFFE5484D)),
      );
      return;
    }
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sport "$name" created successfully!'), backgroundColor: _forest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: _stoneGrey, fontSize: 14)),
        ),
        title: const Text(
          'Create Sport',
          style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: _forest, fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // CARD 1: PHOTO & BASIC INFO
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242A2E),
                          shape: BoxShape.circle,
                          border: Border.all(color: _cardBorder, style: BorderStyle.solid),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: _stoneGrey, size: 28),
                      ),
                      const SizedBox(height: 8),
                      const Text('Add photo (optional)', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'SPORT NAME *',
                    style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'e.g. IGP, Agility',
                    hintStyle: TextStyle(color: _stoneGrey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _forest, width: 1.5)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _mint, width: 2)),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'DESCRIPTION',
                    style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                  ),
                ),
                TextField(
                  controller: _descController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'What is this sport about?',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SPORT INFORMATION
          const Text(
            'SPORT INFORMATION',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORGANISATION',
                  style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                TextField(
                  controller: _orgController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. SV, FCI, AKC',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CURRENT LEVEL',
                  style: TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                TextField(
                  controller: _levelController,
                  style: const TextStyle(color: _offWhite, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'e.g. IGP 1, Foundation, Beginner',
                    hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _cardBorder)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _mint)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // NOTES
          const Text(
            'NOTES',
            style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 4,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Add equipment lists, training objectives, rule changes or personal reminders...',
                hintStyle: TextStyle(color: _stoneGrey.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // BOTTOM ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _forest,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _save,
                  child: const Text('Create Sport', style: TextStyle(color: _offWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
