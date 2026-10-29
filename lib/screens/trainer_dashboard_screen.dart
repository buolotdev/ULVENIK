import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'clients_page_screen.dart';
import 'add_client_screen.dart';
import 'client_homework_screen.dart';
import 'trainer_reports_screen.dart';
import 'trainer_workspace_settings_screen.dart';
import 'trainer_profile_screen.dart';
import 'global_calendar_screen.dart';
import 'record_session_screen.dart';
import 'create_goal_screen.dart';
import 'trainer_notifications_screen.dart';
import 'homework_training_plans_screen.dart';
import 'trainer_notes_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);

class TrainerDashboardScreen extends StatefulWidget {
  const TrainerDashboardScreen({super.key});

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAnalytics() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _obsidian,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _buildAnalyticsSheet(scrollController),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trainer Dashboard',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights, color: _mint, size: 22),
            onPressed: _openAnalytics,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: _offWhite, size: 22),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: _offWhite, size: 22),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainerNotificationsScreen()),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Hero Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TrainerProfileScreen()),
                        ),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF14241E),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0x3334D399)),
                          ),
                          child: const Icon(Icons.person_outline, color: _mint, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Take the Lead Essex',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Liv Old',
                              style: TextStyle(
                                color: _stoneGrey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0x1A34D399),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0x4D34D399)),
                              ),
                              child: const Text(
                                'TRAINER PACK',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: _stoneGrey, size: 20),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TrainerWorkspaceSettingsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Good morning, Liv',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2x2 Bento inside Hero
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14171A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildHeroStat('4', 'LESSONS TODAY'),
                            Container(width: 1, height: 36, color: _cardBorder),
                            _buildHeroStat('12', 'ACTIVE CLIENTS'),
                          ],
                        ),
                        const Divider(color: _cardBorder, height: 20),
                        Row(
                          children: [
                            _buildHeroStat('21', 'CLIENT DOGS'),
                            Container(width: 1, height: 36, color: _cardBorder),
                            _buildHeroStat('3', 'REVIEWS PENDING'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

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
                decoration: const InputDecoration(
                  hintText: 'Search clients, dogs, records...',
                  hintStyle: TextStyle(color: _stoneGrey, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: _stoneGrey, size: 20),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'ATTENTION REQUIRED',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Attention Required Card
            Container(
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildAttentionRow(
                    icon: Icons.assignment_outlined,
                    title: '3 Homework Assignments Pending',
                    subtitle: 'Murphy • Emma Johnson',
                    time: '2 hours ago',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeworkTrainingPlansScreen(),
                      ),
                    ),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildAttentionRow(
                    icon: Icons.person_outline,
                    title: 'Incomplete client profile',
                    subtitle: 'James Harlow',
                    time: 'Yesterday',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientsPageScreen()),
                    ),
                  ),
                  const Divider(color: _cardBorder, height: 1),
                  _buildAttentionRow(
                    icon: Icons.check_circle_outline,
                    title: 'New client invitation accepted',
                    subtitle: 'Sarah & Bella',
                    time: '1 hour ago',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientsPageScreen()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "TODAY'S SCHEDULE",
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Today's Schedule Card
            Container(
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
                      const Text(
                        '09:00',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Emma • Murphy',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Obedience Session',
                              style: TextStyle(color: _stoneGrey, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.place_outlined, color: _stoneGrey, size: 13),
                                SizedBox(width: 4),
                                Text(
                                  'Chelmsford Training Ground',
                                  style: TextStyle(color: _stoneGrey, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x1F34D399),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0x4D34D399)),
                        ),
                        child: const Text(
                          'CONFIRMED',
                          style: TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '11:30',
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'James • Bella',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Recall Lesson',
                              style: TextStyle(color: _stoneGrey, fontSize: 13),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Private Session',
                              style: TextStyle(color: _stoneGrey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF262C30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'UPCOMING',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 28),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GlobalCalendarScreen()),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'View Full Calendar',
                          style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: _mint, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'QUICK ACTIONS',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // 6 Quick Action Grid Tiles
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.05,
              children: [
                _buildActionTile(
                  icon: Icons.person_add_outlined,
                  label: 'Add Client',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddClientScreen()),
                  ),
                ),
                _buildActionTile(
                  icon: Icons.play_circle_outline,
                  label: 'Start Lesson',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecordSessionScreen()),
                  ),
                ),
                _buildActionTile(
                  icon: Icons.assignment_outlined,
                  label: 'Assign Task',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ClientHomeworkScreen(clientName: 'Emma Johnson'),
                    ),
                  ),
                ),
                _buildActionTile(
                  icon: Icons.note_alt_outlined,
                  label: 'Trainer\nNotes',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrainerNotesScreen()),
                  ),
                ),
                _buildActionTile(
                  icon: Icons.flag_outlined,
                  label: 'Create Goal',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
                  ),
                ),
                _buildActionTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Open\nCalendar',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GlobalCalendarScreen()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'RECENT ACTIVITY',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Recent Activity Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _carbon,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cardBorder),
              ),
              child: Column(
                children: [
                  _buildActivityItem('Emma completed Recall Homework', 'Murphy', '1h ago'),
                  const Divider(color: _cardBorder, height: 20),
                  _buildActivityItem('James uploaded a training video', 'Bella', '3h ago'),
                  const Divider(color: _cardBorder, height: 20),
                  _buildActivityItem(
                    'Murphy achieved a Personal Best',
                    'Murphy',
                    'Yesterday',
                    hasStar: true,
                  ),
                  const Divider(color: _cardBorder, height: 20),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TrainerReportsScreen()),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'View All Activity',
                          style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: _mint, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'BUSINESS SNAPSHOT',
              style: TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Business Snapshot Card
            Container(
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
                      _buildSnapCol('12', 'Active Clients'),
                      _buildSnapCol('21', 'Client Dogs'),
                      _buildSnapCol('8', 'Lessons Week'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  Row(
                    children: [
                      _buildSnapCol('14', 'HW Assigned'),
                      _buildSnapCol('31', 'Active Goals'),
                      _buildSnapCol('47', 'Recorded'),
                    ],
                  ),
                  const Divider(color: _cardBorder, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Weekly Lesson Volume',
                        style: TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Current Week: 8',
                        style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Lesson volume bar row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDayBar('M', 16, false),
                      _buildDayBar('T', 28, false),
                      _buildDayBar('W', 18, false),
                      _buildDayBar('T', 40, true),
                      _buildDayBar('F', 32, false),
                      _buildDayBar('S', 12, false),
                      _buildDayBar('S', 6, false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.circle, color: Color(0xFF34D399), size: 8),
            const SizedBox(width: 10),
            Icon(icon, color: _stoneGrey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _offWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _stoneGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(color: _stoneGrey, fontSize: 11),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, color: _stoneGrey, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _offWhite, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _stoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String action,
    String dog,
    String time, {
    bool hasStar = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            action,
            style: const TextStyle(color: _offWhite, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF262C30),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            dog,
            style: const TextStyle(color: _stoneGrey, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        if (hasStar) ...[
          const SizedBox(width: 6),
          const Icon(Icons.star_border, color: Color(0xFFECC94B), size: 14),
        ],
        const SizedBox(width: 8),
        Text(time, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
      ],
    );
  }

  Widget _buildSnapCol(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar(String day, double height, bool isPeak) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 48,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: const Color(0xFF14171A),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            width: 32,
            height: height,
            decoration: BoxDecoration(
              color: isPeak ? const Color(0xFF5D8FAF) : const Color(0xFF2A3A44),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            color: isPeak ? _offWhite : _stoneGrey,
            fontSize: 11,
            fontWeight: isPeak ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSheet(ScrollController scrollController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        controller: scrollController,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: _stoneGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Analytics',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Icon(Icons.tune, color: _stoneGrey, size: 20),
            ],
          ),
          const SizedBox(height: 14),

          // Timeframe Pills
          Row(
            children: [
              _buildFilterPill('THIS WEEK', true),
              const SizedBox(width: 8),
              _buildFilterPill('THIS MONTH', false),
              const SizedBox(width: 8),
              _buildFilterPill('LAST 90 DAYS', false),
            ],
          ),
          const SizedBox(height: 16),

          // 6-metric card
          Container(
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
                    _buildHeroStat('12', 'ACTIVE CLIENTS'),
                    Container(width: 1, height: 36, color: _cardBorder),
                    _buildHeroStat('21', 'CLIENT DOGS'),
                  ],
                ),
                const Divider(color: _cardBorder, height: 24),
                Row(
                  children: [
                    _buildHeroStat('8', 'LESSONS THIS WEEK'),
                    Container(width: 1, height: 36, color: _cardBorder),
                    _buildHeroStat('31', 'ACTIVE GOALS'),
                  ],
                ),
                const Divider(color: _cardBorder, height: 24),
                Row(
                  children: [
                    _buildHeroStat('82%', 'HOMEWORK COMPLETION'),
                    Container(width: 1, height: 36, color: _cardBorder),
                    _buildHeroStat('14', 'SESSIONS RECORDED'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'LESSON ACTIVITY',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Interactive fl_chart BarChart for Lesson Activity
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '32 Lessons',
                      style: TextStyle(color: _offWhite, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '↑ +12% vs last mo',
                      style: TextStyle(color: _mint, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Text('THIS MONTH', style: TextStyle(color: _stoneGrey, fontSize: 10)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 10,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, m) {
                              const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                              if (v.toInt() >= 0 && v.toInt() < 7) {
                                return Text(
                                  days[v.toInt()],
                                  style: TextStyle(
                                    color: v.toInt() == 2 ? _mint : _stoneGrey,
                                    fontSize: 10,
                                    fontWeight: v.toInt() == 2 ? FontWeight.w800 : FontWeight.w400,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 3,
                        getDrawingHorizontalLine: (v) => const FlLine(color: Color(0x1AFFFFFF), strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        _buildGroup(0, 3, false),
                        _buildGroup(1, 4.5, false),
                        _buildGroup(2, 8, true),
                        _buildGroup(3, 5.5, false),
                        _buildGroup(4, 7, false),
                        _buildGroup(5, 3, false),
                        _buildGroup(6, 2, false),
                      ],
                    ),
                  ),
                ),
                const Divider(color: _cardBorder, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Average 1.6 lessons/day', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF262C30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PEAK: WED',
                        style: TextStyle(color: _offWhite, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Homework Completion Rate
          const Text(
            'HOMEWORK',
            style: TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Completion Rate', style: TextStyle(color: _offWhite, fontSize: 15, fontWeight: FontWeight.w700)),
                    Text('82%', style: TextStyle(color: _mint, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.82,
                    backgroundColor: const Color(0xFF262C30),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    Icon(Icons.circle, color: Color(0xFF34D399), size: 8),
                    SizedBox(width: 6),
                    Text('11 completed', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    Spacer(),
                    Icon(Icons.circle, color: Color(0xFF5D8FAF), size: 8),
                    SizedBox(width: 6),
                    Text('2 awaiting review', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.circle, color: Color(0xFFEF4444), size: 8),
                    SizedBox(width: 6),
                    Text('1 overdue', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                    Spacer(),
                    Icon(Icons.circle, color: _stoneGrey, size: 8),
                    SizedBox(width: 6),
                    Text('14 total assigned', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                  ],
                ),
                const Divider(color: _cardBorder, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Avg completion pace', style: TextStyle(color: _stoneGrey, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14241E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.timer_outlined, color: _mint, size: 12),
                          SizedBox(width: 4),
                          Text(
                            '4.2 days',
                            style: TextStyle(color: _mint, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, bool isSel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSel ? const Color(0xFF14241E) : _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSel ? const Color(0xFF34D399) : _cardBorder),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSel ? const Color(0xFF34D399) : _stoneGrey,
          fontSize: 11,
          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  BarChartGroupData _buildGroup(int x, double y, bool isHighlight) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isHighlight ? _mint : const Color(0xFF34D399).withValues(alpha: 0.6),
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
