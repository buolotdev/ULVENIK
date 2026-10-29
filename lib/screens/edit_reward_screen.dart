import 'package:flutter/material.dart';

/// Screen / Bottom Sheet: Edit Reward (Node / frame edit_reward.png)
/// Edit existing reward attributes or permanently delete the reward.
class EditRewardScreen extends StatefulWidget {
  final String dogName;
  final String initialName;
  final String initialType;
  final String initialDescription;

  const EditRewardScreen({
    super.key,
    this.dogName = 'Rook',
    this.initialName = 'Freeze-Dried Liver',
    this.initialType = 'Food',
    this.initialDescription = 'High value — competition only',
  });

  @override
  State<EditRewardScreen> createState() => _EditRewardScreenState();
}

class _EditRewardScreenState extends State<EditRewardScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);
  static const Color _errorRed = Color(0xFFE5484D);

  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late String _selectedType;

  final List<String> _types = [
    'Food',
    'Toy',
    'Praise',
    'Play',
    'Competition',
    'High Drive',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDescription);
    _selectedType = widget.initialType;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Reward?', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${widget.initialName}"? This action cannot be undone.',
          style: const TextStyle(color: _stoneGrey, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, {'deleted': true});
            },
            style: ElevatedButton.styleFrom(backgroundColor: _errorRed, foregroundColor: _offWhite),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (_nameController.text.trim().isEmpty) return;
    Navigator.pop(context, {
      'name': _nameController.text.trim(),
      'type': _selectedType,
      'description': _descController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag bar indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _stoneGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Reward',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _stoneGrey),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
              Text(
                'Rewards are personal to ${widget.dogName}.',
                style: const TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 28),

              // ─── REWARD NAME ──────────────────────────────────────────────
              const Text(
                'REWARD NAME',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: _offWhite, fontSize: 16, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _forest, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _mint, width: 2),
                  ),
                  hintText: 'e.g. Freeze-Dried Liver',
                  hintStyle: TextStyle(color: _stoneGrey),
                ),
              ),
              const SizedBox(height: 28),

              // ─── REWARD TYPE ──────────────────────────────────────────────
              const Text(
                'REWARD TYPE',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select from your types or create a new one.',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  ..._types.map((typeName) {
                    final isSel = _selectedType == typeName;
                    return InkWell(
                      onTap: () => setState(() => _selectedType = typeName),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? _forest.withValues(alpha: 0.25) : _cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel ? _mint : _cardBorder,
                            width: isSel ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          isSel ? '$typeName ✓' : typeName,
                          style: TextStyle(
                            color: isSel ? _mint : _offWhite,
                            fontSize: 13,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                  // + New Type Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _mint.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      '+ New Type',
                      style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ─── DESCRIPTION ──────────────────────────────────────────────
              const Text(
                'DESCRIPTION',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
              const SizedBox(height: 4),
              const Text(
                'Optional. Enter your own notes about this reward.',
                style: TextStyle(color: _stoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: _offWhite, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'High value — competition only',
                  hintStyle: TextStyle(color: _stoneGrey, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x22FFFFFF)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _mint),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ─── BUTTONS ──────────────────────────────────────────────────
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _forest,
                  foregroundColor: _offWhite,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.maybePop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cardBg,
                  foregroundColor: _offWhite,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),

              // ─── DELETE REWARD BUTTON ─────────────────────────────────────
              Center(
                child: TextButton.icon(
                  onPressed: _confirmDelete,
                  icon: const Icon(Icons.delete_outline, color: _errorRed, size: 18),
                  label: const Text(
                    'Delete Reward',
                    style: TextStyle(color: _errorRed, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

