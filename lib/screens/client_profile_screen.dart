import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'client_dog_profile_screen.dart';
import 'edit_client_screen.dart';
import 'client_notes_screen.dart';
import 'client_homework_screen.dart';
import 'client_progress_screen.dart';
import 'client_permissions_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);

class ClientProfileScreen extends StatelessWidget {
  final String clientName;
  final String dogName;
  final String breed;

  const ClientProfileScreen({
    super.key,
    this.clientName = 'Sarah Jenkins',
    this.dogName = 'Baron',
    this.breed = 'German Shepherd (2 yrs)',
  });

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
          'Client Profile',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _mint),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditClientScreen(
                    initialName: clientName,
                    initialDog: dogName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. HANDLER HERO CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _forest,
                  child: Text(
                    clientName.split(' ').map((n) => n[0]).join(),
                    style: const TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text('sarah.jenkins@gmail.com • +1 (206) 555-0142', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _forest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('PRO CLIENT', style: TextStyle(color: _mint, fontSize: 9, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 8),
                          const Text('Enrolled Aug 2026', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. ASSIGNED CANINE CARD
          _buildSectionHeader('ASSIGNED CANINE STUDENT'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientDogProfileScreen(
                    dogName: dogName,
                    breed: breed,
                    handlerName: clientName,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
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
                      color: _mint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pets, color: _mint, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dogName,
                          style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(breed, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
                        const SizedBox(height: 2),
                        const Text('Goal: IGP 1 Title Candidate • 14 Lessons Logged', style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. WORKFLOW MODULES
          _buildSectionHeader('CLIENT TRAINING TOOLS'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                _buildActionRow(
                  icon: Icons.edit_note,
                  title: 'Trainer Notes & Session Log',
                  subtitle: 'Private trainer observations & drill critiques',
                  color: _mint,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientNotesScreen(clientName: clientName))),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildActionRow(
                  icon: Icons.assignment_outlined,
                  title: 'Assigned Homework',
                  subtitle: 'Review drill videos and mark assignments',
                  color: _gold,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientHomeworkScreen(clientName: clientName))),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildActionRow(
                  icon: Icons.insights_outlined,
                  title: 'Client Progress & Telemetry',
                  subtitle: 'Heeling accuracy, bite grip consistency graphs',
                  color: _forest,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientProgressScreen(dogName: dogName))),
                ),
                const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 56),
                _buildActionRow(
                  icon: Icons.security_outlined,
                  title: 'Shared Records & Permissions',
                  subtitle: 'Manage client portal access & visible drill logs',
                  color: _stoneGrey,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientPermissionsScreen(clientName: clientName))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
      onTap: onTap,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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

