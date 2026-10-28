import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'manage_reward_types_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class RewardsManagementScreen extends StatefulWidget {
  const RewardsManagementScreen({super.key});

  @override
  State<RewardsManagementScreen> createState() =>
      _RewardsManagementScreenState();
}

class _RewardsManagementScreenState extends State<RewardsManagementScreen> {
  String _selectedTier = 'All';

  final List<Map<String, dynamic>> _rewards = [
    {
      'name': 'Gappay Medium Bite Ball (Rope)',
      'type': 'High Drive Toy',
      'tier': 'Jackpot High Value',
      'value': 98,
      'dog': 'Koda',
      'drills': 'Phase C Protection & Emergency Recall',
      'icon': Icons.sports_baseball,
      'color': _gold,
    },
    {
      'name': 'Redline K9 Leather Bite Tug',
      'type': 'Prey Drive Toy',
      'tier': 'Jackpot High Value',
      'value': 95,
      'dog': 'Koda',
      'drills': 'Heeling Focus & Speed Recall Out',
      'icon': Icons.sports_kabaddi,
      'color': _gold,
    },
    {
      'name': 'Freeze-Dried Beef Liver Cubes',
      'type': 'Food Treat',
      'tier': 'Medium Value',
      'value': 75,
      'dog': 'Koda & Murphy',
      'drills': 'Tracking Article Indication (Phase A)',
      'icon': Icons.lunch_dining,
      'color': _mint,
    },
    {
      'name': 'String Cheese Strips',
      'type': 'Food Treat',
      'tier': 'Medium Value',
      'value': 70,
      'dog': 'Koda',
      'drills': 'Complex Positioning / Micro-Obedience',
      'icon': Icons.restaurant,
      'color': _mint,
    },
    {
      'name': 'Verbal "Yes" Marker & Physical Stroke',
      'type': 'Social Praise',
      'tier': 'Low Maintenance',
      'value': 45,
      'dog': 'All Dogs',
      'drills': 'Routine Duration Stays & Posture Check',
      'icon': Icons.thumb_up_alt_outlined,
      'color': _stoneGrey,
    },
  ];

  List<Map<String, dynamic>> get _filteredRewards {
    if (_selectedTier == 'All') return _rewards;
    if (_selectedTier == 'High') {
      return _rewards.where((r) => r['tier'].contains('High')).toList();
    }
    if (_selectedTier == 'Medium') {
      return _rewards.where((r) => r['tier'].contains('Medium')).toList();
    }
    return _rewards.where((r) => r['tier'].contains('Low')).toList();
  }

  void _openAddRewardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddRewardBottomSheet(
        onAdd: (newReward) {
          setState(() => _rewards.insert(0, newReward));
        },
      ),
    );
  }

  void _openEditRewardSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditRewardBottomSheet(
        initialReward: _rewards[index],
        onSave: (updated) {
          setState(() => _rewards[index] = updated);
        },
        onDelete: () {
          setState(() => _rewards.removeAt(index));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredRewards;

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
          'Rewards Management',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Reward Types',
            icon: const Icon(Icons.category_outlined, color: _mint),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageRewardTypesScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Add Reward',
            icon: const Icon(Icons.add, color: _mint),
            onPressed: _openAddRewardSheet,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. REWARD DRIVE HIERARCHY SUMMARY
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reinforcement Hierarchy',
                      style: TextStyle(
                        color: _offWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Koda vom Alpenhof',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tailor drive rewards by drill complexity. High drive jackpot rewards are reserved for emergency recalls, bite hold-outs, and speed breakthroughs.',
                  style: TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTierBadge('High Jackpot', _gold),
                    const SizedBox(width: 8),
                    _buildTierBadge('Medium', _mint),
                    const SizedBox(width: 8),
                    _buildTierBadge('Low / Maintenance', _stoneGrey),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. FILTER PILLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'High', 'Medium', 'Low'].map((tier) {
                final isSel = _selectedTier == tier;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTier = tier),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isSel ? _forest : _carbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSel ? _mint : _cardBorder,
                        ),
                      ),
                      child: Text(
                        tier == 'All' ? 'All Rewards' : '$tier Value',
                        style: TextStyle(
                          color: isSel ? _offWhite : _stoneGrey,
                          fontSize: 12,
                          fontWeight:
                              isSel ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 3. REWARDS LIST
          ...list.asMap().entries.map((entry) {
            final idx = entry.key;
            final reward = entry.value;
            final Color color = reward['color'];

            return GestureDetector(
              onTap: () => _openEditRewardSheet(idx),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _carbon,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(reward['icon'], color: color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reward['name'],
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${reward['type']} • ${reward['tier']}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF131718),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${reward['value']}% Drive',
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131718),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.track_changes,
                            color: _stoneGrey,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Targeted Drills: ${reward['drills']}',
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text(
          'Add Reward',
          style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700),
        ),
        onPressed: _openAddRewardSheet,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTierBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
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
              _buildNavItem(Icons.pets, 'Dogs', true, () {
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
              _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
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

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
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

// ─── Modal 1: Add Reward Bottom Sheet (No Bottom Nav) ─────────────────────────
class _AddRewardBottomSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onAdd;

  const _AddRewardBottomSheet({required this.onAdd});

  @override
  State<_AddRewardBottomSheet> createState() => _AddRewardBottomSheetState();
}

class _AddRewardBottomSheetState extends State<_AddRewardBottomSheet> {
  final _nameController = TextEditingController();
  final _drillsController = TextEditingController();
  String _type = 'High Drive Toy';
  String _tier = 'Jackpot High Value';
  double _value = 90;

  @override
  void dispose() {
    _nameController.dispose();
    _drillsController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reward name.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    widget.onAdd({
      'name': name,
      'type': _type,
      'tier': _tier,
      'value': _value.toInt(),
      'dog': 'Koda',
      'drills': _drillsController.text.trim().isEmpty
          ? 'General Drills'
          : _drillsController.text.trim(),
      'icon': _type.contains('Toy')
          ? Icons.sports_baseball
          : (_type.contains('Treat') ? Icons.lunch_dining : Icons.thumb_up_alt_outlined),
      'color': _tier.contains('High') ? _gold : (_tier.contains('Medium') ? _mint : _stoneGrey),
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reward "$name" added to hierarchy.'),
        backgroundColor: _forest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Canine Reward',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              Icon(Icons.workspace_premium, color: _mint),
            ],
          ),
          const SizedBox(height: 16),
          _buildInput('Reward Name', _nameController, 'e.g. Chuckit Ultra Squeaker Ball'),
          const SizedBox(height: 12),
          _buildDropdown('Category', _type, ['High Drive Toy', 'Prey Drive Toy', 'Food Treat', 'Social Praise'], (val) => setState(() => _type = val!)),
          const SizedBox(height: 12),
          _buildDropdown('Reinforcement Tier', _tier, ['Jackpot High Value', 'Medium Value', 'Low Maintenance'], (val) => setState(() => _tier = val!)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Drive Value Rating', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              Text('${_value.toInt()}% Drive', style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          Slider(
            value: _value,
            min: 10,
            max: 100,
            activeColor: _mint,
            inactiveColor: const Color(0xFF131718),
            onChanged: (val) => setState(() => _value = val),
          ),
          const SizedBox(height: 6),
          _buildInput('Target Drills', _drillsController, 'e.g. Long bite out, fast recall'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submit,
              child: const Text('Save Reward to Profile', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131718),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: _offWhite, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: _stoneGrey, fontSize: 12),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF131718),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: _carbon,
              style: const TextStyle(color: _offWhite, fontSize: 13),
              icon: const Icon(Icons.keyboard_arrow_down, color: _mint),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Modal 2: Edit Reward Bottom Sheet (No Bottom Nav) ────────────────────────
class _EditRewardBottomSheet extends StatefulWidget {
  final Map<String, dynamic> initialReward;
  final ValueChanged<Map<String, dynamic>> onSave;
  final VoidCallback onDelete;

  const _EditRewardBottomSheet({
    required this.initialReward,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<_EditRewardBottomSheet> createState() => _EditRewardBottomSheetState();
}

class _EditRewardBottomSheetState extends State<_EditRewardBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _drillsController;
  late String _type;
  late String _tier;
  late double _value;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialReward['name']);
    _drillsController = TextEditingController(text: widget.initialReward['drills']);
    _type = widget.initialReward['type'];
    _tier = widget.initialReward['tier'];
    _value = (widget.initialReward['value'] as int).toDouble();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _drillsController.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave({
      ...widget.initialReward,
      'name': _nameController.text.trim(),
      'type': _type,
      'tier': _tier,
      'value': _value.toInt(),
      'drills': _drillsController.text.trim(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Reward',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {
                  widget.onDelete();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInput('Reward Name', _nameController),
          const SizedBox(height: 12),
          _buildInput('Target Drills', _drillsController),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Drive Value', style: TextStyle(color: _stoneGrey, fontSize: 12)),
              Text('${_value.toInt()}%', style: const TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          Slider(
            value: _value,
            min: 10,
            max: 100,
            activeColor: _mint,
            inactiveColor: const Color(0xFF131718),
            onChanged: (val) => setState(() => _value = val),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _save,
              child: const Text('Save Changes', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131718),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _cardBorder),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: _offWhite, fontSize: 13),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

