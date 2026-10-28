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

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _masterNotifications = true;

  // Training & Drills
  bool _sessionReminders = true;
  String _reminderTime = '15 min before';
  bool _liveActivity = true;
  bool _weeklyRecap = true;

  // Health & Care
  bool _medicationAlerts = true;
  bool _vaccinationWarnings = true;
  bool _vetReminders = true;

  // Milestones & Memories
  bool _streakMilestones = true;
  bool _memoryFlashbacks = true;

  // Delivery & Audio
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _quietHoursEnabled = true;

  void _showReminderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reminder Advance Time',
                style: TextStyle(
                  color: _offWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              ...['5 min before', '15 min before', '30 min before', '1 hour before', '1 day before'].map((option) {
                final isSelected = _reminderTime == option;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? _mint : _offWhite,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: _mint, size: 20) : null,
                  onTap: () {
                    setState(() => _reminderTime = option);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _offWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: _offWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. MASTER NOTIFICATION TOGGLE
          _buildMasterToggleCard(),
          const SizedBox(height: 20),

          if (_masterNotifications) ...[
            // 2. TRAINING & DRILL NOTIFICATIONS
            _buildSectionHeader('TRAINING & S&C DRILLS'),
            const SizedBox(height: 8),
            _buildGroupCard([
              _buildToggleRow(
                title: 'Session Reminders',
                subtitle: 'Scheduled drill advance notification',
                value: _sessionReminders,
                onChanged: (val) => setState(() => _sessionReminders = val),
              ),
              if (_sessionReminders)
                _buildActionRow(
                  title: 'Advance Warning',
                  value: _reminderTime,
                  onTap: _showReminderPicker,
                ),
              _buildToggleRow(
                title: 'Live Activities & Island',
                subtitle: 'Real-time stopwatch & GPS telemetry on Lock Screen',
                value: _liveActivity,
                onChanged: (val) => setState(() => _liveActivity = val),
              ),
              _buildToggleRow(
                title: 'Weekly Training Digest',
                subtitle: 'Sunday evening conditioning volume recap',
                value: _weeklyRecap,
                onChanged: (val) => setState(() => _weeklyRecap = val),
              ),
            ]),
            const SizedBox(height: 20),

            // 3. CANINE HEALTH & PREVENTATIVE
            _buildSectionHeader('CANINE HEALTH & CARE'),
            const SizedBox(height: 8),
            _buildGroupCard([
              _buildToggleRow(
                title: 'Medication Alarms',
                subtitle: 'Preventative doses (NexGard, Heartworm, Deworming)',
                value: _medicationAlerts,
                onChanged: (val) => setState(() => _medicationAlerts = val),
              ),
              _buildToggleRow(
                title: 'Vaccine Expiry Alerts',
                subtitle: 'Advance notice 30 days prior to booster due date',
                value: _vaccinationWarnings,
                onChanged: (val) => setState(() => _vaccinationWarnings = val),
              ),
              _buildToggleRow(
                title: 'Vet Appointments',
                subtitle: 'Check-up & rehabilitation clinic reminders',
                value: _vetReminders,
                onChanged: (val) => setState(() => _vetReminders = val),
              ),
            ]),
            const SizedBox(height: 20),

            // 4. MILESTONES & FLASHBACKS
            _buildSectionHeader('ACHIEVEMENTS & MEMORIES'),
            const SizedBox(height: 8),
            _buildGroupCard([
              _buildToggleRow(
                title: 'Training Streak Milestones',
                subtitle: 'Celebration alerts at 7, 14, 30, and 100 days',
                value: _streakMilestones,
                onChanged: (val) => setState(() => _streakMilestones = val),
              ),
              _buildToggleRow(
                title: 'Timeline Flashbacks',
                subtitle: '"1 Year Ago Today" memories and milestone anniversaries',
                value: _memoryFlashbacks,
                onChanged: (val) => setState(() => _memoryFlashbacks = val),
              ),
            ]),
            const SizedBox(height: 20),

            // 5. SOUND & DELIVERY PREFERENCES
            _buildSectionHeader('DELIVERY & SOUND CHANNELS'),
            const SizedBox(height: 8),
            _buildGroupCard([
              _buildToggleRow(
                title: 'Chime & Sound Alerts',
                subtitle: 'Ulvenik whistle tone for drill transitions',
                value: _soundEnabled,
                onChanged: (val) => setState(() => _soundEnabled = val),
              ),
              _buildToggleRow(
                title: 'Haptic Feedback',
                subtitle: 'Vibration pulses on milestone triggers',
                value: _hapticEnabled,
                onChanged: (val) => setState(() => _hapticEnabled = val),
              ),
              _buildToggleRow(
                title: 'Quiet Hours (22:00 - 07:00)',
                subtitle: 'Mute all non-critical notifications while resting',
                value: _quietHoursEnabled,
                onChanged: (val) => setState(() => _quietHoursEnabled = val),
              ),
            ]),
            const SizedBox(height: 24),
          ],
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMasterToggleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _masterNotifications ? _mint.withValues(alpha: 0.3) : _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _masterNotifications ? _forest : const Color(0xFF131718),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _masterNotifications ? Icons.notifications_active : Icons.notifications_off,
              color: _masterNotifications ? _mint : _stoneGrey,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Allow Notifications',
                  style: TextStyle(
                    color: _offWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Master switch for all device push alerts',
                  style: TextStyle(color: _stoneGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: _masterNotifications,
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF131718),
            onChanged: (val) => setState(() => _masterNotifications = val),
          ),
        ],
      ),
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

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final idx = entry.key;
          final widget = entry.value;
          final isLast = idx == children.length - 1;
          return Column(
            children: [
              widget,
              if (!isLast) const Divider(color: Color(0x0FFFFFFF), height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _stoneGrey, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _mint,
            activeTrackColor: _forest,
            inactiveTrackColor: const Color(0xFF131718),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
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
