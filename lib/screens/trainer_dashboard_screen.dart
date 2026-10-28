import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'clients_page_screen.dart';
import 'add_client_screen.dart';
import 'client_homework_screen.dart';
import 'trainer_reports_screen.dart';
import 'trainer_workspace_settings_screen.dart';
import 'trainer_profile_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);
const Color _blue = Color(0xFF5D8FAF);

class TrainerDashboardScreen extends StatefulWidget {
  const TrainerDashboardScreen({super.key});

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
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
          'Trainer Hub',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Trainer Business Profile',
            icon: const Icon(Icons.badge_outlined, color: _mint),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TrainerProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Workspace Settings',
            icon: const Icon(Icons.settings_outlined, color: _offWhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TrainerWorkspaceSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. BUSINESS HERO CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _carbon,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _mint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _forest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'CERTIFIED PRO TRAINER',
                        style: TextStyle(color: _mint, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star, color: _gold, size: 14),
                        SizedBox(width: 4),
                        Text('4.9 (48 Reviews)', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Vanguard Working K9 Academy',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Head Instructor: Alex Rivers • License #USCA-TR-842',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MetricItem('28', 'Active Clients'),
                    _MetricItem('14', 'Lessons This Week'),
                    _MetricItem('96%', 'Homework Return'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. QUICK ACTIONS GRID
          Row(
            children: [
              Expanded(
                child: _buildActionTile(
                  icon: Icons.people_alt_outlined,
                  title: 'Clients Page',
                  subtitle: 'Roster & dog files',
                  color: _mint,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientsPageScreen())),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionTile(
                  icon: Icons.person_add_alt_1_outlined,
                  title: 'Add Client',
                  subtitle: 'Onboard new team',
                  color: _gold,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddClientScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionTile(
                  icon: Icons.assignment_outlined,
                  title: 'Client Homework',
                  subtitle: 'Assigned drills',
                  color: _blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientHomeworkScreen())),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionTile(
                  icon: Icons.analytics_outlined,
                  title: 'Trainer Reports',
                  subtitle: 'Retention & graphs',
                  color: _forest,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainerReportsScreen())),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. WEEKLY CLIENT LESSON VOLUME (Interactive Chart)
          _buildSectionHeader('WEEKLY LESSON ENGAGEMENT (HOURS)'),
          const SizedBox(height: 8),
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Training Hours: 26.5 hrs', style: TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('+18% vs last week', style: TextStyle(color: _gold, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 130,
                  child: BarChart(
                    BarChartData(
                      maxY: 8,
                      barGroups: [
                        _makeBar(0, 4.5, _mint),
                        _makeBar(1, 5.0, _mint),
                        _makeBar(2, 6.5, _gold),
                        _makeBar(3, 4.0, _mint),
                        _makeBar(4, 5.5, _mint),
                        _makeBar(5, 7.2, _forest),
                        _makeBar(6, 3.8, _stoneGrey),
                      ],
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (v, _) => Text('${v.toInt()}h', style: const TextStyle(color: _stoneGrey, fontSize: 9)),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Text(days[v.toInt()], style: const TextStyle(color: _stoneGrey, fontSize: 9));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => const FlLine(color: Color(0x14FFFFFF), strokeWidth: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. TODAY'S CLIENT SCHEDULE
          _buildSectionHeader('TODAY\'S LESSONS & EVALUATIONS'),
          const SizedBox(height: 8),
          _buildLessonCard(
            time: '09:00 AM',
            client: 'Sarah Jenkins • Baron (GSD)',
            drill: 'Phase B Focused Heeling & 1m Hurdle',
            status: 'Confirmed',
            statusColor: _mint,
          ),
          _buildLessonCard(
            time: '11:30 AM',
            client: 'David Miller • Luna (Dutch Shepherd)',
            drill: 'Scent Article Indication & Blind Search',
            status: 'Confirmed',
            statusColor: _mint,
          ),
          _buildLessonCard(
            time: '02:00 PM',
            client: 'Elena Rostova • Thor (Doberman)',
            drill: 'Puppy Drive Building & Rag Tug Engagement',
            status: 'Pending',
            statusColor: _gold,
          ),

          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  BarChartGroupData _makeBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        ),
      ],
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

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _carbon,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard({
    required String time,
    required String client,
    required String drill,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF131718),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(time, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client, style: const TextStyle(color: _offWhite, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(drill, style: const TextStyle(color: _stoneGrey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w800)),
          ),
        ],
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

class _MetricItem extends StatelessWidget {
  final String val;
  final String label;

  const _MetricItem(this.val, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: _stoneGrey, fontSize: 10)),
      ],
    );
  }
}
