import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';

// ─── Design Tokens ──────────────────────────────────────────────────────────
const Color _obsidian = Color(0xFF101214);
const Color _carbon = Color(0xFF1A1F22);
const Color _cardBorder = Color(0x14FFFFFF);
const Color _forest = Color(0xFF2E6B57);
const Color _mint = Color(0xFFAAE9D0);
const Color _offWhite = Color(0xFFF5F6F2);
const Color _stoneGrey = Color(0xFFA7B0AB);
const Color _gold = Color(0xFFECC94B);
const Color _orange = Color(0xFFDD6B20);
const Color _blue = Color(0xFF5D8FAF);

class NotificationsPageScreen extends StatefulWidget {
  final bool initialEmpty;

  const NotificationsPageScreen({super.key, this.initialEmpty = false});

  @override
  State<NotificationsPageScreen> createState() =>
      _NotificationsPageScreenState();
}

class _NotificationsPageScreenState extends State<NotificationsPageScreen> {
  late bool _isEmptyState;
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Medication Due: NexGard Chewable',
      'body': 'Scheduled preventative treatment for Koda due with morning meal.',
      'time': '2h ago',
      'unread': true,
      'category': 'Health',
      'icon': Icons.medication_outlined,
      'color': _orange,
    },
    {
      'id': '2',
      'title': '14-Day Conditioning Streak Unlocked!',
      'body': 'Congratulations! Koda completed 14 consecutive training days.',
      'time': '5h ago',
      'unread': true,
      'category': 'Milestone',
      'icon': Icons.local_fire_department,
      'color': _gold,
    },
    {
      'id': '3',
      'title': 'Upcoming Drill: Trail Agility & Scent',
      'body': 'Tomorrow at 07:30 AM at Riverside Valley Course.',
      'time': 'Yesterday',
      'unread': false,
      'category': 'Training',
      'icon': Icons.fitness_center_outlined,
      'color': _mint,
    },
    {
      'id': '4',
      'title': 'Automated Cloud Backup Completed',
      'body': '428 MB of telemetry, GPS contours and logs synced to AWS S3.',
      'time': '2d ago',
      'unread': false,
      'category': 'System',
      'icon': Icons.cloud_done_outlined,
      'color': _blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _isEmptyState = widget.initialEmpty;
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['unread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: _forest,
        duration: Duration(seconds: 1),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredList {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

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
          'Notifications',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Empty State',
            icon: Icon(
              _isEmptyState ? Icons.visibility : Icons.visibility_off_outlined,
              color: _mint,
              size: 20,
            ),
            onPressed: () => setState(() => _isEmptyState = !_isEmptyState),
          ),
          if (!_isEmptyState)
            IconButton(
              tooltip: 'Mark All Read',
              icon: const Icon(Icons.done_all, color: _stoneGrey, size: 20),
              onPressed: _markAllAsRead,
            ),
        ],
      ),
      body: _isEmptyState ? _buildEmptyState() : _buildPopulatedState(list),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _carbon,
                border: Border.all(color: _cardBorder),
              ),
              child: const Icon(Icons.notifications_none, size: 38, color: _stoneGrey),
            ),
            const SizedBox(height: 24),
            const Text(
              'All Caught Up!',
              style: TextStyle(
                color: _offWhite,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have no unread notifications, drill reminders, or medical alarms at this time.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _stoneGrey, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _forest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => setState(() => _isEmptyState = false),
              child: const Text('Show Feed', style: TextStyle(color: _offWhite)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulatedState(List<Map<String, dynamic>> list) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. FILTER PILLS
        _buildFilterPills(),
        const SizedBox(height: 16),

        // 2. NOTIFICATION FEED
        ...list.map((item) => _buildNotificationTile(item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFilterPills() {
    final filters = ['All', 'Training', 'Health', 'Milestone'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _forest : _carbon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _mint : _cardBorder,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? _offWhite : _stoneGrey,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> item) {
    final bool isUnread = item['unread'] ?? false;
    final Color color = item['color'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnread ? _mint.withValues(alpha: 0.3) : _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item['icon'], color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Text(
                      item['time'],
                      style: const TextStyle(color: _stoneGrey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['body'],
                  style: const TextStyle(color: _stoneGrey, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          if (isUnread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _mint,
                shape: BoxShape.circle,
              ),
            ),
          ],
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
