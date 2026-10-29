import 'package:flutter/material.dart';
import 'client_dog_profile_screen.dart';
import 'client_homework_screen.dart';

/// Screen: Client Dogs Directory (Node / frame client_dogs.png)
/// Displays the list of dogs owned by a specific client (e.g. Emma's Dogs)
/// with athletic focus badges, streak data, and shared status.
class ClientDogsScreen extends StatefulWidget {
  final String ownerName;

  const ClientDogsScreen({
    super.key,
    this.ownerName = "Emma's Dogs",
  });

  @override
  State<ClientDogsScreen> createState() => _ClientDogsScreenState();
}

class _ClientDogsScreenState extends State<ClientDogsScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);
  static const Color _flameOrange = Color(0xFFE5853C);

  void _showAddDogDialog() {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Client Dog', style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                labelText: 'Dog Name',
                labelStyle: const TextStyle(color: _stoneGrey),
                filled: true,
                fillColor: _obsidian,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: breedController,
              style: const TextStyle(color: _offWhite),
              decoration: InputDecoration(
                labelText: 'Breed',
                labelStyle: const TextStyle(color: _stoneGrey),
                filled: true,
                fillColor: _obsidian,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _cardBorder)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New canine added to client workspace'), backgroundColor: _forest),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _forest, foregroundColor: _offWhite),
            child: const Text('Add Dog'),
          ),
        ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          widget.ownerName,
          style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _offWhite),
            onPressed: _showAddDogDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _forest,
        onPressed: _showAddDogDialog,
        child: const Icon(Icons.add, color: _offWhite, size: 28),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── SUBHEADER ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '2 Dogs',
                  style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ACTIVE IN WORKSPACE',
                  style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─── DOG CARD 1: MURPHY ─────────────────────────────────────────
            _buildDogCard(
              tag: 'PRIMARY ATHLETE',
              name: 'Murphy',
              age: '3 Years',
              breed: 'Golden Retriever',
              sportPill: 'IGP',
              streak: '12 Day Streak',
              lastSession: 'Yesterday',
              goals: '2 Goals',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientDogProfileScreen(dogName: 'Murphy', breed: 'Working Malinois'),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── DOG CARD 2: BELLA ──────────────────────────────────────────
            _buildDogCard(
              tag: 'AGILITY FOCUS',
              name: 'Bella',
              age: '5 Years',
              breed: 'Border Collie',
              sportPill: null,
              streak: '15 Day Streak',
              lastSession: '2 days ago',
              goals: '1 Goal',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientDogProfileScreen(dogName: 'Bella', breed: 'Border Collie'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ─── ALERT CALLOUT STRIP ────────────────────────────────────────
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientHomeworkScreen(clientName: 'Emma Johnson'),
                ),
              ),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Homework overdue — Murphy',
                        style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      children: const [
                        Text(
                          'Check',
                          style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: _mint, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDogCard({
    required String tag,
    required String name,
    required String age,
    required String breed,
    required String? sportPill,
    required String streak,
    required String lastSession,
    required String goals,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Image Container with tag
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF141A1E),
                gradient: LinearGradient(
                  colors: [Color(0xFF222C30), Color(0xFF111618)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.pets, color: _mint.withValues(alpha: 0.15), size: 72),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _obsidian.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _obsidian,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.straighten, color: _stoneGrey, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              age,
                              style: const TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        breed,
                        style: const TextStyle(color: _stoneGrey, fontSize: 13),
                      ),
                      if (sportPill != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _obsidian,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Text(
                            sportPill,
                            style: const TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: _cardBorder, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: _flameOrange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        streak,
                        style: const TextStyle(color: _offWhite, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 10),
                      const Text('•', style: TextStyle(color: _stoneGrey)),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time, color: _stoneGrey, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        lastSession,
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      const Text('•', style: TextStyle(color: _stoneGrey)),
                      const SizedBox(width: 10),
                      const Icon(Icons.bolt, color: _stoneGrey, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        goals,
                        style: const TextStyle(color: _stoneGrey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'SHARED WITH OWNER',
                          style: TextStyle(color: _stoneGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

