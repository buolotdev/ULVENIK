import 'package:flutter/material.dart';
import 'client_profile_screen.dart';
import 'add_client_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class ClientItem {
  final String name;
  final String dogs;
  final String nextLesson;
  final String lastActive;
  final String status; // 'ACTIVE CLIENT', 'INVITATION PENDING'
  final int activeGoals;

  ClientItem({
    required this.name,
    required this.dogs,
    required this.nextLesson,
    required this.lastActive,
    required this.status,
    required this.activeGoals,
  });
}

class ClientsPageScreen extends StatefulWidget {
  const ClientsPageScreen({super.key});

  @override
  State<ClientsPageScreen> createState() => _ClientsPageScreenState();
}

class _ClientsPageScreenState extends State<ClientsPageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'ACTIVE';

  final List<ClientItem> _clients = [
    ClientItem(
      name: 'Emma Johnson',
      dogs: '2 Dogs (Murphy, Luna)',
      nextLesson: 'Next Lesson • Thursday 10:00',
      lastActive: 'Last Active • Yesterday',
      status: 'ACTIVE CLIENT',
      activeGoals: 3,
    ),
    ClientItem(
      name: 'James Harlow',
      dogs: '1 Dog (Bella)',
      nextLesson: 'Next Lesson • Friday 14:00',
      lastActive: 'Last Active • 2 days ago',
      status: 'ACTIVE CLIENT',
      activeGoals: 2,
    ),
    ClientItem(
      name: 'Sarah Mitchell',
      dogs: '0 Dogs',
      nextLesson: 'No upcoming lesson',
      lastActive: 'Last Active • 1 week ago',
      status: 'INVITATION PENDING',
      activeGoals: 0,
    ),
    ClientItem(
      name: 'Marcus Vance',
      dogs: '1 Dog (Thor)',
      nextLesson: 'Next Lesson • Monday 09:30',
      lastActive: 'Last Active • Today',
      status: 'ACTIVE CLIENT',
      activeGoals: 4,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredClients = _clients.where((c) {
      if (_activeFilter == 'ACTIVE' && c.status != 'ACTIVE CLIENT') return false;
      if (_activeFilter == 'UPCOMING LESSONS' && c.nextLesson.contains('No upcoming')) return false;
      if (_activeFilter == 'PENDING REVIEWS' && c.status != 'INVITATION PENDING') return false;
      if (_searchController.text.trim().isNotEmpty) {
        final q = _searchController.text.toLowerCase();
        return c.name.toLowerCase().contains(q) ||
            c.dogs.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: AppBar(
        backgroundColor: _obsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Clients',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_vert, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: _offWhite, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClientScreen()),
          );
          if (res == true) {
            setState(() {
              _clients.insert(
                0,
                ClientItem(
                  name: 'New Client',
                  dogs: '1 Dog (Ranger)',
                  nextLesson: 'Next Lesson • Saturday 11:00',
                  lastActive: 'Just now',
                  status: 'ACTIVE CLIENT',
                  activeGoals: 1,
                ),
              );
            });
          }
        },
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: _offWhite, fontSize: 14),
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search clients, dogs, notes...',
                  hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: _stoneGrey, size: 20),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ACTIVE', hasClose: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('UPCOMING LESSONS'),
                  const SizedBox(width: 8),
                  _buildFilterChip('PENDING REVIEWS'),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Count & Sort row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_clients.length + 8} Clients',
                  style: const TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Sorted by: Recently Active',
                  style: TextStyle(
                    color: _stoneGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Client Cards List
            ...filteredClients.map((client) {
              final isPending = client.status == 'INVITATION PENDING';
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientProfileScreen(clientName: client.name),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF14171A),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: const Icon(Icons.person, color: _stoneGrey, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client.name,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (client.dogs != '0 Dogs') ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.pets, color: _stoneGrey, size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        client.dogs,
                                        style: const TextStyle(color: _stoneGrey, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_outlined, color: _stoneGrey, size: 13),
                                    const SizedBox(width: 6),
                                    Text(
                                      client.nextLesson,
                                      style: const TextStyle(color: _stoneGrey, fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, color: _stoneGrey, size: 13),
                                    const SizedBox(width: 6),
                                    Text(
                                      client.lastActive,
                                      style: const TextStyle(color: _stoneGrey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                        ],
                      ),
                      const Divider(color: _cardBorder, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPending ? const Color(0xFF172535) : const Color(0x1F34D399),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              client.status,
                              style: TextStyle(
                                color: isPending ? const Color(0xFF93C5FD) : const Color(0xFF34D399),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          Text(
                            '${client.activeGoals} Active Goals',
                            style: const TextStyle(
                              color: _offWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool hasClose = false}) {
    final isSel = _activeFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          if (isSel && hasClose) {
            _activeFilter = 'ALL';
          } else {
            _activeFilter = label;
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF14241E) : const Color(0xFF14171A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSel ? const Color(0xFF34D399) : _cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSel ? const Color(0xFF34D399) : _stoneGrey,
                fontSize: 11,
                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.6,
              ),
            ),
            if (hasClose && isSel) ...[
              const SizedBox(width: 6),
              const Icon(Icons.close, color: Color(0xFF34D399), size: 14),
            ],
          ],
        ),
      ),
    );
  }
}
