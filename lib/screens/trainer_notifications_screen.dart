import 'package:flutter/material.dart';
import 'homework_details_screen.dart';
import 'client_account_screen.dart';

/// Screen: Trainer Notifications Hub (Node / frame trainer_notifications.png)
/// Live stream of trainer alerts, homework submissions awaiting review,
/// client invitation acceptances, and daily lesson reminders.
class TrainerNotificationsScreen extends StatefulWidget {
  const TrainerNotificationsScreen({super.key});

  @override
  State<TrainerNotificationsScreen> createState() => _TrainerNotificationsScreenState();
}

class _TrainerNotificationsScreenState extends State<TrainerNotificationsScreen> {
  // Brand tokens
  static const Color _obsidian = Color(0xFF101214);
  static const Color _cardBg = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _cardBorder = Color(0x1FFFFFFF);

  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Action Required', 'Read'];

  void _markAllAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All trainer notifications marked as read'), backgroundColor: _forest),
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
        title: const Text(
          'Notifications',
          style: TextStyle(color: _offWhite, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Mark All Read',
              style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TABS ROW ───────────────────────────────────────────────────
            Row(
              children: _tabs.map((tab) {
                final isSelected = _selectedTab == tab;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = tab),
                  child: Container(
                    margin: const EdgeInsets.only(right: 24),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? _mint : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSelected ? _mint : _stoneGrey,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ─── SECTION: ACTION REQUIRED ───────────────────────────────────
            if (_selectedTab == 'All' || _selectedTab == 'Action Required') ...[
              const Text(
                'ACTION REQUIRED',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: Icons.check_circle_outline,
                title: 'Homework awaiting review',
                timeText: '2 hours ago',
                desc: 'Emma completed Recall Foundation Practice · Murphy',
                dogPill: 'Murphy',
                actionText: 'Review Now →',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeworkDetailsScreen(
                      title: 'Recall Foundation Practice',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: Icons.person_add_alt_1_outlined,
                title: 'New client invitation accepted',
                timeText: '1 hour ago',
                desc: 'Sarah Mitchell has joined Ulvenik and connected her account',
                dogPill: 'Poppy',
                actionText: 'View Client →',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClientAccountScreen(
                      clientName: 'Sarah Mitchell',
                      clientEmail: 'sarah.mitchell@example.com',
                      clientSince: 'Today',
                      linkedDogsCount: 1,
                      nextLesson: 'Friday · 14:00',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ─── SECTION: TODAY ─────────────────────────────────────────────
            if (_selectedTab == 'All' || _selectedTab == 'Read') ...[
              const Text(
                'TODAY',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              _buildStandardCard(
                hasGreenDot: true,
                icon: Icons.track_changes_outlined,
                title: 'Goal completed',
                timeText: '4 hours ago',
                desc: 'Emma marked Loose Lead Walking as complete · Murphy',
                dogPill: 'Murphy',
              ),
              const SizedBox(height: 12),
              _buildStandardCard(
                hasGreenDot: true,
                icon: Icons.videocam_outlined,
                title: 'Training video uploaded',
                timeText: '5 hours ago',
                desc: 'James uploaded a session video · Bella',
                dogPill: 'Bella',
              ),
              const SizedBox(height: 12),
              _buildStandardCard(
                hasGreenDot: false,
                icon: Icons.calendar_today_outlined,
                title: 'Lesson reminder',
                timeText: 'This morning',
                desc: 'Emma Johnson · Murphy · Tomorrow 09:00 · Chelmsford',
                dogPill: null,
              ),
              const SizedBox(height: 24),
            ],

            // ─── SECTION: YESTERDAY ─────────────────────────────────────────
            if (_selectedTab == 'All' || _selectedTab == 'Read') ...[
              const Text(
                'YESTERDAY',
                style: TextStyle(color: _stoneGrey, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              _buildStandardCard(
                hasGreenDot: false,
                icon: Icons.format_list_bulleted,
                title: 'Homework completed',
                timeText: 'Yesterday 18:42',
                desc: 'James completed Place Training Basics · Bella',
                dogPill: null,
              ),
              const SizedBox(height: 12),
              _buildStandardCard(
                hasGreenDot: false,
                icon: Icons.shield_outlined,
                title: 'Permission updated',
                timeText: 'Yesterday 14:15',
                desc: 'Emma has updated health record access',
                dogPill: null,
              ),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String timeText,
    required String desc,
    required String dogPill,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: _forest,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Icon(icon, color: _mint, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          timeText,
                          style: const TextStyle(color: _stoneGrey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF263033),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            dogPill,
                            style: const TextStyle(color: _stoneGrey, fontSize: 11),
                          ),
                        ),
                        GestureDetector(
                          onTap: onAction,
                          child: Text(
                            actionText,
                            style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardCard({
    required bool hasGreenDot,
    required IconData icon,
    required String title,
    required String timeText,
    required String desc,
    required String? dogPill,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (hasGreenDot) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
              ],
              Icon(icon, color: _stoneGrey, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                timeText,
                style: const TextStyle(color: _stoneGrey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(color: _stoneGrey, fontSize: 13, height: 1.3),
          ),
          if (dogPill != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF263033),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                dogPill,
                style: const TextStyle(color: _stoneGrey, fontSize: 11),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
