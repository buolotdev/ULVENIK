import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'notification_settings_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _mutedGrey = Color(0xFF718096);
const Color _syncGreen = Color(0xFF4ADE80);
const Color _dangerRed = Color(0xFFE53E3E);

class NotificationsPageScreen extends StatefulWidget {
  final bool initialEmpty;

  const NotificationsPageScreen({super.key, this.initialEmpty = false});

  @override
  State<NotificationsPageScreen> createState() =>
      _NotificationsPageScreenState();
}

class _NotificationsPageScreenState extends State<NotificationsPageScreen> {
  // Notification unread states
  bool _notif1Unread = true;
  bool _notif2Unread = true;
  bool _notif3Unread = false;
  bool _notif4Unread = false;
  bool _notif5Unread = false;

  int get _unreadCount =>
      (_notif1Unread ? 1 : 0) +
      (_notif2Unread ? 1 : 0) +
      (_notif3Unread ? 1 : 0) +
      (_notif4Unread ? 1 : 0) +
      (_notif5Unread ? 1 : 0);

  void _markAllAsRead() {
    setState(() {
      _notif1Unread = false;
      _notif2Unread = false;
      _notif3Unread = false;
      _notif4Unread = false;
      _notif5Unread = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    if (index == 4) {
      Navigator.pop(context);
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
            // ─── Header: Notifications | Search & Filter ───────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: _offWhite, size: 22),
                          SizedBox(width: 4),
                          Text(
                            'Notifications',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, color: _offWhite, size: 20),
                  const SizedBox(width: 14),
                  const Icon(Icons.tune, color: _offWhite, size: 20),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── 4-Column Metric Strip ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        _buildMetricCol('$_unreadCount', 'UNREAD'),
                        _buildDividerCol(),
                        _buildMetricCol('5', 'TODAY'),
                        _buildDividerCol(),
                        _buildMetricCol('2', 'UPCOMING'),
                        _buildDividerCol(),
                        _buildMetricCol('1', 'OVERDUE', isOverdue: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ─── 2 Action Pills: Mark All Read & Settings ───────────
                  Row(
                    children: [
                      InkWell(
                        onTap: _markAllAsRead,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14241E),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _forest.withValues(alpha: 0.8),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.done_all, color: _mint, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Mark All Read',
                                style: TextStyle(
                                  color: _mint,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationSettingsScreen(),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _carbon,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.tune, color: _stoneGrey, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Settings',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── TODAY Section ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('TODAY'),
                      const Text(
                        '3 Events',
                        style: TextStyle(
                          color: _mutedGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        // Medication Reminder
                        _buildNotifRow(
                          icon: Icons.medical_services_outlined,
                          title: 'Medication Reminder',
                          time: '5:45 PM',
                          body: 'Carprofen is scheduled for 6:00 PM.',
                          isUnread: _notif1Unread,
                          onTap: () => setState(() => _notif1Unread = false),
                        ),
                        _buildDivider(),
                        // Veterinary Appointment
                        _buildNotifRow(
                          icon: Icons.calendar_today_outlined,
                          title: 'Veterinary Appointment',
                          time: '9:00 AM',
                          body: 'Eye examination tomorrow at 10:30 AM.',
                          isUnread: _notif2Unread,
                          onTap: () => setState(() => _notif2Unread = false),
                        ),
                        _buildDivider(),
                        // Goal Completed
                        _buildNotifRow(
                          icon: Icons.check_circle_outline,
                          title: 'Goal Completed',
                          time: '7:32 AM',
                          body: 'Complete 20 Recall Sessions has been achieved.',
                          isUnread: _notif3Unread,
                          onTap: () => setState(() => _notif3Unread = false),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── EARLIER Section ───────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('EARLIER'),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Viewing notification archive.')),
                          );
                        },
                        child: const Text(
                          'Archive',
                          style: TextStyle(
                            color: _mutedGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        // Training Reminder
                        _buildNotifRow(
                          icon: Icons.fitness_center,
                          title: 'Training Reminder',
                          time: 'Yesterday',
                          body: 'Agility session with Murphy starts in 30 minutes.',
                          isUnread: _notif4Unread,
                          onTap: () => setState(() => _notif4Unread = false),
                        ),
                        _buildDivider(),
                        // Backup Complete
                        _buildNotifRow(
                          icon: Icons.cloud_done_outlined,
                          title: 'Backup Complete',
                          time: '2d ago',
                          body: 'Your telemetry data has been backed up successfully.',
                          isUnread: _notif5Unread,
                          onTap: () => setState(() => _notif5Unread = false),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Telemetry Sync Status Strip ───────────────────────
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sensors, color: _syncGreen, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Telemetry Sync: Online',
                            style: TextStyle(
                              color: _stoneGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'GPS Collar #4',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // More tab active
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _mutedGrey,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 64,
    );
  }

  Widget _buildMetricCol(String value, String label, {bool isOverdue = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isOverdue ? _dangerRed : _offWhite,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividerCol() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0x14FFFFFF),
    );
  }

  Widget _buildNotifRow({
    required IconData icon,
    required String title,
    required String time,
    required String body,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14191C),
                    shape: BoxShape.circle,
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Center(
                    child: Icon(icon, color: _stoneGrey, size: 18),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    left: -2,
                    top: 12,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _syncGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
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
                        title,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 16),
          ],
        ),
      ),
    );
  }
}
