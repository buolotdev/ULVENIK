import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'manage_reward_types_screen.dart';
import 'add_reward_screen.dart';
import 'edit_reward_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class RewardItem {
  final String id;
  String name;
  String type;
  String? description;
  IconData icon;

  RewardItem({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.icon,
  });
}

class RewardsManagementScreen extends StatefulWidget {
  final String dogName;
  final String dogBreed;

  const RewardsManagementScreen({
    super.key,
    this.dogName = 'Rook',
    this.dogBreed = 'Belgian Malinois',
  });

  @override
  State<RewardsManagementScreen> createState() =>
      _RewardsManagementScreenState();
}

class _RewardsManagementScreenState extends State<RewardsManagementScreen> {
  String _selectedTypeFilter = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _types = [
    'All',
    'Food',
    'Toy',
    'Praise',
    'Play',
    'Competition',
    'High Drive',
  ];

  late List<RewardItem> _rewards;

  @override
  void initState() {
    super.initState();
    _rewards = [
      RewardItem(
        id: 'rew_1',
        name: 'Freeze-Dried Liver',
        type: 'FOOD',
        description: 'High value — competition only',
        icon: Icons.soup_kitchen_outlined,
      ),
      RewardItem(
        id: 'rew_2',
        name: 'Tug Toy',
        type: 'TOY',
        description: 'Ball on rope, preferred',
        icon: Icons.card_giftcard,
      ),
      RewardItem(
        id: 'rew_3',
        name: 'Verbal Praise',
        type: 'PRAISE',
        description: null,
        icon: Icons.favorite_border,
      ),
      RewardItem(
        id: 'rew_4',
        name: 'Kibble',
        type: 'FOOD',
        description: 'Low value — everyday use',
        icon: Icons.restaurant,
      ),
      RewardItem(
        id: 'rew_5',
        name: 'Tennis Ball',
        type: 'TOY',
        description: null,
        icon: Icons.card_giftcard,
      ),
      RewardItem(
        id: 'rew_6',
        name: 'Chase Game',
        type: 'PLAY',
        description: 'End of session reward',
        icon: Icons.bolt,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RewardItem> get _filteredRewards {
    return _rewards.where((r) {
      if (_selectedTypeFilter != 'All' && r.type.toUpperCase() != _selectedTypeFilter.toUpperCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty && !r.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  void _openAddRewardModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddRewardScreen(dogName: widget.dogName),
    );
    if (result != null && result['name'] != null) {
      setState(() {
        final typeStr = result['type'] as String;
        final icon = _getIconForType(typeStr);
        _rewards.insert(
          0,
          RewardItem(
            id: 'rew_${DateTime.now().millisecondsSinceEpoch}',
            name: result['name'] as String,
            type: typeStr.toUpperCase(),
            description: (result['description'] as String?)?.isNotEmpty == true
                ? result['description'] as String
                : null,
            icon: icon,
          ),
        );
      });
    }
  }

  void _openEditRewardModal(RewardItem item) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditRewardScreen(
        dogName: widget.dogName,
        initialName: item.name,
        initialType: item.type,
        initialDescription: item.description ?? '',
      ),
    );
    if (result != null) {
      if (result['deleted'] == true) {
        setState(() => _rewards.remove(item));
      } else if (result['name'] != null) {
        setState(() {
          final typeStr = result['type'] as String;
          item.name = result['name'] as String;
          item.type = typeStr.toUpperCase();
          item.description = (result['description'] as String?)?.isNotEmpty == true
              ? result['description'] as String
              : null;
          item.icon = _getIconForType(typeStr);
        });
      }
    }
  }

  IconData _getIconForType(String type) {
    switch (type.toUpperCase()) {
      case 'FOOD':
        return Icons.soup_kitchen_outlined;
      case 'TOY':
        return Icons.card_giftcard;
      case 'PRAISE':
        return Icons.favorite_border;
      case 'PLAY':
        return Icons.bolt;
      case 'COMPETITION':
        return Icons.star_border;
      default:
        return Icons.thumb_up_alt_outlined;
    }
  }

  void _deleteReward(RewardItem item) {
    final index = _rewards.indexOf(item);
    setState(() => _rewards.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _carbon,
        content: Text('Removed "${item.name}"', style: const TextStyle(color: _offWhite)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: _mint,
          onPressed: () {
            setState(() => _rewards.insert(index, item));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRewards;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          // Dog Banner (Rook • Belgian Malinois • IGP-3 SPORT)
          _buildDogBanner(),
          const SizedBox(height: 20),

          // REWARD TYPES Row with "Manage Types" link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'REWARD TYPES',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontFamily: 'Inter',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManageRewardTypesScreen()),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.tune, color: _mint, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Manage Types',
                      style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Type Chips Carousel
          _buildTypeChips(),
          const SizedBox(height: 24),

          // MY REWARDS Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MY REWARDS',
                style: TextStyle(
                  color: _stoneGrey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '${filtered.length} items',
                style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List of Reward Cards matching Figma
          ...filtered.map((r) => _buildRewardCard(r)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        foregroundColor: _offWhite,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: _openAddRewardModal,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _obsidian,
      elevation: 0,
      centerTitle: true,
      leading: TextButton.icon(
        style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 8)),
        icon: const Icon(Icons.arrow_back_ios, color: _offWhite, size: 16),
        label: const Text('Back', style: TextStyle(color: _offWhite, fontSize: 15)),
        onPressed: () => Navigator.pop(context),
      ),
      leadingWidth: 90,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: _offWhite, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Search rewards...',
                hintStyle: TextStyle(color: _stoneGrey),
                border: InputBorder.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            )
          : const Text(
              'Rewards',
              style: TextStyle(
                color: _offWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search, color: _offWhite),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _isSearching = false;
                _searchQuery = '';
                _searchController.clear();
              } else {
                _isSearching = true;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDogBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _obsidian,
              shape: BoxShape.circle,
              border: Border.all(color: _mint.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text(
                widget.dogName.substring(0, 2).toUpperCase(),
                style: const TextStyle(color: _mint, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.dogName,
                        style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                      ),
                      const TextSpan(text: '  •  ', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                      TextSpan(
                        text: widget.dogBreed,
                        style: const TextStyle(color: _stoneGrey, fontSize: 13, fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF14241E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _forest.withValues(alpha: 0.6)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_outlined, color: _mint, size: 12),
                SizedBox(width: 4),
                Text(
                  'IGP-3 SPORT',
                  style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _types.map((type) {
          final isSelected = _selectedTypeFilter.toLowerCase() == type.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTypeFilter = type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : const Color(0xFF181C1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? _mint : _cardBorder),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRewardCard(RewardItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(item.icon, color: _mint, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: _offWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22282B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.type,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: const TextStyle(color: _stoneGrey, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _stoneGrey, size: 18),
            onPressed: () => _openEditRewardModal(item),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: _stoneGrey, size: 18),
            onPressed: () => _deleteReward(item),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(top: BorderSide(color: Color(0x14FFFFFF), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomepageScreen()));
              }),
              _buildNavItem(Icons.pets, 'Dogs', true, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyDogsScreen()));
              }),
              _buildNavItem(Icons.fitness_center_outlined, 'Training', false, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TrainingScreen()));
              }),
              _buildNavItem(Icons.event_note_outlined, 'Timeline', false, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TimelineScreen()));
              }),
              _buildNavItem(Icons.more_horiz_outlined, 'More', false, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MorePageScreen()));
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
          Icon(icon, color: isSelected ? _mint : _stoneGrey, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? _mint : _stoneGrey, fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}

