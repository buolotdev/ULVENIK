import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBg = Color(0xFF16191C);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);
const Color _dangerRed = Color(0xFFE53E3E);

class ManageRewardTypesScreen extends StatefulWidget {
  const ManageRewardTypesScreen({super.key});

  @override
  State<ManageRewardTypesScreen> createState() =>
      _ManageRewardTypesScreenState();
}

class _ManageRewardTypesScreenState extends State<ManageRewardTypesScreen> {
  // Reward types matching Figma manage_reward_types.png exactly
  late List<Map<String, dynamic>> _types;

  @override
  void initState() {
    super.initState();
    _types = [
      {
        'id': 'food',
        'title': 'Food',
        'count': 3,
        'icon': Icons.lunch_dining,
      },
      {
        'id': 'toy',
        'title': 'Toy',
        'count': 2,
        'icon': Icons.card_giftcard,
      },
      {
        'id': 'praise',
        'title': 'Praise',
        'count': 1,
        'icon': Icons.favorite_border,
      },
      {
        'id': 'play',
        'title': 'Play',
        'count': 1,
        'icon': Icons.bolt,
      },
      {
        'id': 'competition',
        'title': 'Competition',
        'count': 2,
        'icon': Icons.star_border,
      },
      {
        'id': 'high_drive',
        'title': 'High Drive',
        'count': 1,
        'icon': Icons.offline_bolt_outlined,
      },
    ];
  }

  void _showAddEditTypeSheet({Map<String, dynamic>? existingType, int? index}) {
    final titleController =
        TextEditingController(text: existingType?['title'] ?? '');
    IconData selectedIcon = existingType?['icon'] ?? Icons.category_outlined;

    final availableIcons = [
      Icons.lunch_dining,
      Icons.card_giftcard,
      Icons.favorite_border,
      Icons.bolt,
      Icons.star_border,
      Icons.offline_bolt_outlined,
      Icons.sports_baseball,
      Icons.military_tech_outlined,
      Icons.thumb_up_alt_outlined,
      Icons.nature_people_outlined,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _mutedGrey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    existingType == null ? 'Add Reward Type' : 'Edit Reward Type',
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TYPE NAME',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: _offWhite, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _obsidian,
                      hintText: 'e.g. Scent Distractions, Ball Drive',
                      hintStyle: const TextStyle(color: _mutedGrey, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _mint, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CHOOSE ICON',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: availableIcons.map((ic) {
                      final isSel = ic == selectedIcon;
                      return InkWell(
                        onTap: () {
                          setSheetState(() => selectedIcon = ic);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSel ? _forest : _obsidian,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSel ? _mint : _cardBorder,
                              width: isSel ? 1.5 : 1.0,
                            ),
                          ),
                          child: Icon(
                            ic,
                            color: isSel ? _mint : _offWhite,
                            size: 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: _stoneGrey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _forest,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final name = titleController.text.trim();
                            if (name.isNotEmpty) {
                              setState(() {
                                if (existingType != null && index != null) {
                                  _types[index] = {
                                    ...existingType,
                                    'title': name,
                                    'icon': selectedIcon,
                                  };
                                } else {
                                  _types.add({
                                    'id': name.toLowerCase().replaceAll(' ', '_'),
                                    'title': name,
                                    'count': 0,
                                    'icon': selectedIcon,
                                  });
                                }
                              });
                            }
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            existingType == null ? 'Add Type' : 'Save Changes',
                            style: const TextStyle(
                              color: _offWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(int index) {
    final item = _types[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Reward Type',
          style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to remove "${item['title']}"? Existing rewards with this type will become uncategorised.',
          style: const TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _dangerRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _types.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      Navigator.pop(context); // Back to Dog Profile
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header matching Figma: < Back | Reward Types | + Add Type ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 2),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'Reward Types',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showAddEditTypeSheet(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      '+ Add Type',
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 8),

                  // ─── Info Box (Figma: Create your own reward types...) ───
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13191D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1E2B34),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF5D8FAF),
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Create your own reward types to organise your rewards your way. These appear as filter options on your Rewards list.',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Section Header ──────────────────────────────────────
                  const Text(
                    'MY REWARD TYPES',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ─── Reorderable List of Reward Types ───────────────────
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _types.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _types.removeAt(oldIndex);
                        _types.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final type = _types[index];
                      final count = type['count'] as int;
                      final countText = count == 1 ? '1 reward' : '$count rewards';

                      return Container(
                        key: ValueKey(type['id']),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _cardBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Reorder Drag Handle
                            ReorderableDragStartListener(
                              index: index,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.menu,
                                  color: _mutedGrey,
                                  size: 18,
                                ),
                              ),
                            ),
                            // Type Icon
                            Icon(
                              type['icon'] as IconData,
                              color: _offWhite,
                              size: 19,
                            ),
                            const SizedBox(width: 12),
                            // Title
                            Expanded(
                              child: Text(
                                type['title'] as String,
                                style: const TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Count
                            Text(
                              countText,
                              style: const TextStyle(
                                color: _mutedGrey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Edit Action
                            InkWell(
                              onTap: () => _showAddEditTypeSheet(
                                existingType: type,
                                index: index,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: _stoneGrey,
                                  size: 17,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Delete Action
                            InkWell(
                              onTap: () => _confirmDelete(index),
                              borderRadius: BorderRadius.circular(6),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: _stoneGrey,
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // ─── Drag helper text ───────────────────────────────────
                  const Center(
                    child: Text(
                      'Drag to reorder. Types appear as filter options on your Rewards list.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _mutedGrey,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── Add New Type dashed border box ────────────────────
                  InkWell(
                    onTap: () => _showAddEditTypeSheet(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141A1C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _forest.withValues(alpha: 0.5),
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: _mint, size: 18),
                          SizedBox(width: 6),
                          Text(
                            '+ Add New Type',
                            style: TextStyle(
                              color: _mint,
                              fontSize: 14,
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
        currentIndex: 1, // Dogs tab active as per Handover rules
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
}
