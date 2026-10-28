import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'client_profile_screen.dart';
import 'add_client_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class ClientsPageScreen extends StatefulWidget {
  const ClientsPageScreen({super.key});

  @override
  State<ClientsPageScreen> createState() => _ClientsPageScreenState();
}

class _ClientsPageScreenState extends State<ClientsPageScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'All';

  final List<Map<String, dynamic>> _clients = [
    {
      'name': 'Sarah Jenkins',
      'email': 'sarah.j@gmail.com',
      'dog': 'Baron',
      'breed': 'German Shepherd (2 yrs)',
      'tier': 'Trial Prep',
      'status': 'Active',
      'lastSession': 'Yesterday',
      'homework': 'Video Submitted',
      'avatar': 'SJ',
    },
    {
      'name': 'David Miller',
      'email': 'david.miller@outlook.com',
      'dog': 'Luna',
      'breed': 'Dutch Shepherd (1 yr)',
      'tier': 'Active',
      'status': 'Active',
      'lastSession': '3 days ago',
      'homework': 'On Track',
      'avatar': 'DM',
    },
    {
      'name': 'Elena Rostova',
      'email': 'elena.rostova@icloud.com',
      'dog': 'Thor',
      'breed': 'Doberman Pinscher (6 mos)',
      'tier': 'Puppy Foundation',
      'status': 'Active',
      'lastSession': '5 days ago',
      'homework': 'Pending Assignment',
      'avatar': 'ER',
    },
    {
      'name': 'Marcus Vance',
      'email': 'm.vance@yahoo.com',
      'dog': 'Ares',
      'breed': 'Belgian Malinois (3 yrs)',
      'tier': 'Trial Prep',
      'status': 'Active',
      'lastSession': '1 week ago',
      'homework': 'Reviewed',
      'avatar': 'MV',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredClients {
    return _clients.where((c) {
      final matchesQuery = _query.isEmpty ||
          c['name'].toLowerCase().contains(_query.toLowerCase()) ||
          c['dog'].toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == 'All' || c['tier'] == _filter;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredClients;

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
          'Client Roster',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: _mint),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddClientScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. SEARCH BAR
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: _offWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search client handler or canine...',
                hintStyle: const TextStyle(color: _stoneGrey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: _mint, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: _stoneGrey, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
          ),
          const SizedBox(height: 14),

          // 2. FILTER PILLS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Trial Prep', 'Active', 'Puppy Foundation'].map((f) {
                final isSel = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSel ? _forest : _carbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSel ? _mint : _cardBorder),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isSel ? _offWhite : _stoneGrey,
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // 3. CLIENT LIST
          Text(
            'ACTIVE HANDLERS (${list.length})',
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          ...list.map((c) => _buildClientCard(c)),

          const SizedBox(height: 70),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _forest,
        icon: const Icon(Icons.add, color: _offWhite),
        label: const Text('Add Client', style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClientScreen()),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildClientCard(Map<String, dynamic> c) {
    final hasVideo = c['homework'] == 'Video Submitted';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClientProfileScreen(
              clientName: c['name'],
              dogName: c['dog'],
              breed: c['breed'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _forest,
                  child: Text(
                    c['avatar'],
                    style: const TextStyle(color: _offWhite, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c['name'],
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: hasVideo ? _gold.withValues(alpha: 0.15) : _forest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              c['homework'],
                              style: TextStyle(
                                color: hasVideo ? _gold : _mint,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dog: ${c['dog']} • ${c['breed']}',
                        style: const TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Last Session: ${c['lastSession']}',
                        style: const TextStyle(color: _stoneGrey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

