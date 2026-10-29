import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';
import 'more_page_screen.dart';
import 'notifications_page_screen.dart';

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

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Push Notifications Master
  bool _enablePush = true;

  // Training
  bool _trainingReminders = true;
  bool _scheduledSessions = true;
  bool _missedTraining = true;
  bool _trainingGoalsAchieved = true;

  // Strength & Conditioning
  bool _swimmingReminders = true;
  bool _hydrotherapyReminders = true;
  bool _exerciseSchedule = true;
  bool _recoveryReminders = true;

  // Health
  bool _medicationReminders = true;
  bool _vaccinations = true;
  bool _vetAppointments = true;
  bool _weightCheckReminders = true;
  bool _supplementReminders = true;

  // Goals
  bool _goalDueSoon = true;
  bool _goalCompleted = true;
  bool _milestoneReached = true;

  // Timeline
  bool _recordingStreak = true;
  bool _noActivityRecorded = true;
  bool _timelineMemories = true;
  bool _newTimelineInsights = true;

  // Competitions (Sport Pack)
  bool _upcomingCompetition = true;
  bool _competitionReminder = true;
  bool _competitionResultsReady = true;

  // Trainer (Trainer Pack)
  bool _clientSharedTraining = true;
  bool _homeworkSubmitted = true;
  bool _clientProgressUpdates = true;

  // Email Notifications
  bool _receiveEmails = true;
  bool _productUpdates = true;
  bool _featureAnnouncements = true;
  bool _securityAlerts = true;
  bool _subscriptionReceipts = true;
  bool _accountNotifications = false;

  // Quiet Hours
  bool _enableQuietHours = true;
  String _quietStartTime = '10:00 PM';
  String _quietEndTime = '07:00 AM';

  // Reminder Timing
  String _timingTraining = '30 Minutes Before';
  String _timingHealth = '1 Hour Before';
  String _timingGoals = '1 Day Before';
  String _timingCompetitions = '2 Hours Before';

  // Sound
  String _selectedSound = 'Default';

  // Badge Count
  bool _showAppBadge = true;

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

  void _showTimingPicker(String category, String currentVal, Function(String) onSelect) {
    final options = [
      '15 Minutes Before',
      '30 Minutes Before',
      '1 Hour Before',
      '2 Hours Before',
      '1 Day Before',
      '2 Days Before',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _mutedGrey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$category Reminder Timing',
              style: const TextStyle(
                color: _offWhite,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((opt) {
              final isSel = opt == currentVal;
              return ListTile(
                title: Text(
                  opt,
                  style: TextStyle(
                    color: isSel ? _mint : _offWhite,
                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isSel ? const Icon(Icons.check, color: _mint) : null,
                onTap: () {
                  onSelect(opt);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _carbon,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Notification Settings',
          style: TextStyle(color: _offWhite, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to revert all notification preferences back to default?',
          style: TextStyle(color: _stoneGrey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _stoneGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _dangerRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _enablePush = true;
                _receiveEmails = true;
                _enableQuietHours = true;
                _selectedSound = 'Default';
                _showAppBadge = true;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings reset to default.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Reset', style: TextStyle(color: _offWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: < Notification Settings | Saved ─────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            'Notification Settings',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'Saved',
                    style: TextStyle(
                      color: _mutedGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  // ─── OVERVIEW 2x2 CARD ────────────────────────────────
                  _buildSectionHeader('OVERVIEW'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Push', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: _syncGreen)),
                                  const SizedBox(width: 6),
                                  const Text('Enabled', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text('Quiet Hours', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: _mutedGrey)),
                                  const SizedBox(width: 6),
                                  const Text('Off', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Email', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: _syncGreen)),
                                  const SizedBox(width: 6),
                                  const Text('Enabled', style: TextStyle(color: _offWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                '18 Active',
                                style: TextStyle(color: _offWhite, fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              const Text('notifications', style: TextStyle(color: _stoneGrey, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── PUSH NOTIFICATIONS ────────────────────────────────
                  _buildSectionHeader('PUSH NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          title: 'Enable Push Notifications',
                          value: _enablePush,
                          onChanged: (v) => setState(() => _enablePush = v),
                        ),
                        if (_enablePush) ...[
                          _buildSubSectionHeader('TRAINING'),
                          _buildSwitchRow(
                            icon: Icons.notifications_none,
                            title: 'Training Reminders',
                            value: _trainingReminders,
                            onChanged: (v) => setState(() => _trainingReminders = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.calendar_today_outlined,
                            title: 'Scheduled Sessions',
                            value: _scheduledSessions,
                            onChanged: (v) => setState(() => _scheduledSessions = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.access_time,
                            title: 'Missed Training',
                            value: _missedTraining,
                            onChanged: (v) => setState(() => _missedTraining = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.flag_outlined,
                            title: 'Training Goals Achieved',
                            value: _trainingGoalsAchieved,
                            onChanged: (v) => setState(() => _trainingGoalsAchieved = v),
                          ),

                          _buildSubSectionHeader('STRENGTH & CONDITIONING'),
                          _buildSwitchRow(
                            icon: Icons.pool_outlined,
                            title: 'Swimming Reminders',
                            value: _swimmingReminders,
                            onChanged: (v) => setState(() => _swimmingReminders = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.show_chart,
                            title: 'Hydrotherapy Reminders',
                            value: _hydrotherapyReminders,
                            onChanged: (v) => setState(() => _hydrotherapyReminders = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.fitness_center,
                            title: 'Exercise Schedule',
                            value: _exerciseSchedule,
                            onChanged: (v) => setState(() => _exerciseSchedule = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.nightlight_outlined,
                            title: 'Recovery Reminders',
                            value: _recoveryReminders,
                            onChanged: (v) => setState(() => _recoveryReminders = v),
                          ),

                          _buildSubSectionHeader('HEALTH'),
                          _buildSwitchRow(
                            icon: Icons.tune,
                            title: 'Medication Reminders',
                            value: _medicationReminders,
                            onChanged: (v) => setState(() => _medicationReminders = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.shield_outlined,
                            title: 'Vaccinations',
                            value: _vaccinations,
                            onChanged: (v) => setState(() => _vaccinations = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.local_hospital_outlined,
                            title: 'Vet Appointments',
                            value: _vetAppointments,
                            onChanged: (v) => setState(() => _vetAppointments = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.monitor_weight_outlined,
                            title: 'Weight Check Reminders',
                            value: _weightCheckReminders,
                            onChanged: (v) => setState(() => _weightCheckReminders = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.medical_services_outlined,
                            title: 'Supplement Reminders',
                            value: _supplementReminders,
                            onChanged: (v) => setState(() => _supplementReminders = v),
                          ),

                          _buildSubSectionHeader('GOALS'),
                          _buildSwitchRow(
                            icon: Icons.access_time,
                            title: 'Goal Due Soon',
                            value: _goalDueSoon,
                            onChanged: (v) => setState(() => _goalDueSoon = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.person_outline,
                            title: 'Goal Completed',
                            value: _goalCompleted,
                            onChanged: (v) => setState(() => _goalCompleted = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.star_border,
                            title: 'Milestone Reached',
                            value: _milestoneReached,
                            onChanged: (v) => setState(() => _milestoneReached = v),
                          ),

                          _buildSubSectionHeader('TIMELINE'),
                          _buildSwitchRow(
                            icon: Icons.local_fire_department_outlined,
                            title: 'Recording Streak',
                            value: _recordingStreak,
                            onChanged: (v) => setState(() => _recordingStreak = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.circle_outlined,
                            title: 'No Activity Recorded',
                            value: _noActivityRecorded,
                            onChanged: (v) => setState(() => _noActivityRecorded = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.access_time,
                            title: 'Timeline Memories',
                            value: _timelineMemories,
                            onChanged: (v) => setState(() => _timelineMemories = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.auto_awesome_outlined,
                            title: 'New Timeline Insights',
                            value: _newTimelineInsights,
                            onChanged: (v) => setState(() => _newTimelineInsights = v),
                          ),

                          _buildSubSectionHeaderWithBadge('COMPETITIONS', 'Sport Pack'),
                          _buildSwitchRow(
                            icon: Icons.person_outline,
                            title: 'Upcoming Competition',
                            value: _upcomingCompetition,
                            onChanged: (v) => setState(() => _upcomingCompetition = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.notifications_none,
                            title: 'Competition Reminder',
                            value: _competitionReminder,
                            onChanged: (v) => setState(() => _competitionReminder = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.description_outlined,
                            title: 'Competition Results Ready',
                            value: _competitionResultsReady,
                            onChanged: (v) => setState(() => _competitionResultsReady = v),
                          ),

                          _buildSubSectionHeaderWithBadge('TRAINER', 'Trainer Pack'),
                          _buildSwitchRow(
                            icon: Icons.group_outlined,
                            title: 'Client Shared Training',
                            value: _clientSharedTraining,
                            onChanged: (v) => setState(() => _clientSharedTraining = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.assignment_outlined,
                            title: 'Homework Submitted',
                            value: _homeworkSubmitted,
                            onChanged: (v) => setState(() => _homeworkSubmitted = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.trending_up,
                            title: 'Client Progress Updates',
                            value: _clientProgressUpdates,
                            onChanged: (v) => setState(() => _clientProgressUpdates = v),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── EMAIL NOTIFICATIONS ───────────────────────────────
                  _buildSectionHeader('EMAIL NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          title: 'Receive Emails',
                          value: _receiveEmails,
                          onChanged: (v) => setState(() => _receiveEmails = v),
                        ),
                        if (_receiveEmails) ...[
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.mail_outline,
                            title: 'Product Updates',
                            value: _productUpdates,
                            onChanged: (v) => setState(() => _productUpdates = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.campaign_outlined,
                            title: 'Feature Announcements',
                            value: _featureAnnouncements,
                            onChanged: (v) => setState(() => _featureAnnouncements = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.lock_outline,
                            title: 'Security Alerts',
                            value: _securityAlerts,
                            onChanged: (v) => setState(() => _securityAlerts = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.receipt_long_outlined,
                            title: 'Subscription Receipts',
                            value: _subscriptionReceipts,
                            onChanged: (v) => setState(() => _subscriptionReceipts = v),
                          ),
                          _buildDivider(),
                          _buildSwitchRow(
                            icon: Icons.person_outline,
                            title: 'Account Notifications',
                            value: _accountNotifications,
                            onChanged: (v) => setState(() => _accountNotifications = v),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── QUIET HOURS ───────────────────────────────────────
                  _buildSectionHeader('QUIET HOURS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchRow(
                          icon: Icons.nightlight_outlined,
                          title: 'Enable Quiet Hours',
                          value: _enableQuietHours,
                          onChanged: (v) => setState(() => _enableQuietHours = v),
                        ),
                        if (_enableQuietHours) ...[
                          _buildDivider(),
                          _buildNavRow(
                            icon: Icons.access_time,
                            title: 'Start Time',
                            value: _quietStartTime,
                            onTap: () {
                              setState(() => _quietStartTime = _quietStartTime == '10:00 PM' ? '11:00 PM' : '10:00 PM');
                            },
                          ),
                          _buildDivider(),
                          _buildNavRow(
                            icon: Icons.access_time,
                            title: 'End Time',
                            value: _quietEndTime,
                            onTap: () {
                              setState(() => _quietEndTime = _quietEndTime == '07:00 AM' ? '08:00 AM' : '07:00 AM');
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── REMINDER TIMING ───────────────────────────────────
                  _buildSectionHeader('REMINDER TIMING'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildNavRow(
                          icon: Icons.access_time,
                          title: 'Training',
                          value: _timingTraining,
                          onTap: () => _showTimingPicker('Training', _timingTraining, (v) => setState(() => _timingTraining = v)),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.access_time,
                          title: 'Health',
                          value: _timingHealth,
                          onTap: () => _showTimingPicker('Health', _timingHealth, (v) => setState(() => _timingHealth = v)),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.access_time,
                          title: 'Goals',
                          value: _timingGoals,
                          onTap: () => _showTimingPicker('Goals', _timingGoals, (v) => setState(() => _timingGoals = v)),
                        ),
                        _buildDivider(),
                        _buildNavRow(
                          icon: Icons.access_time,
                          title: 'Competitions',
                          value: _timingCompetitions,
                          onTap: () => _showTimingPicker('Competitions', _timingCompetitions, (v) => setState(() => _timingCompetitions = v)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── NOTIFICATION SOUNDS ───────────────────────────────
                  _buildSectionHeader('NOTIFICATION SOUNDS'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildRadioRow(
                          icon: Icons.volume_up_outlined,
                          title: 'Default',
                          isSelected: _selectedSound == 'Default',
                          onTap: () => setState(() => _selectedSound = 'Default'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.volume_off_outlined,
                          title: 'Silent',
                          isSelected: _selectedSound == 'Silent',
                          onTap: () => setState(() => _selectedSound = 'Silent'),
                        ),
                        _buildDivider(),
                        _buildRadioRow(
                          icon: Icons.surround_sound_outlined,
                          title: 'System Sound',
                          isSelected: _selectedSound == 'System Sound',
                          onTap: () => setState(() => _selectedSound = 'System Sound'),
                        ),
                        _buildDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.music_note_outlined, color: _stoneGrey, size: 20),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Text(
                                  'Custom Sounds',
                                  style: TextStyle(color: _stoneGrey, fontSize: 14),
                                ),
                              ),
                              Text(
                                'Coming Soon',
                                style: TextStyle(
                                  color: _mutedGrey.withValues(alpha: 0.8),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── BADGE COUNT ───────────────────────────────────────
                  _buildSectionHeader('BADGE COUNT'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _carbon,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_none, color: _offWhite, size: 20),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Show App Badge',
                                style: TextStyle(
                                  color: _offWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Display notification count on app icon',
                                style: TextStyle(
                                  color: _stoneGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _showAppBadge,
                          activeThumbColor: _forest,
                          activeTrackColor: _syncGreen.withValues(alpha: 0.6),
                          inactiveThumbColor: _stoneGrey,
                          inactiveTrackColor: _obsidian,
                          onChanged: (v) => setState(() => _showAppBadge = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── HISTORY ───────────────────────────────────────────
                  _buildSectionHeader('HISTORY'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPageScreen(),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.history, color: _offWhite, size: 20),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View Notification History',
                                  style: TextStyle(
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Chronological log of delivered notifications',
                                  style: TextStyle(
                                    color: _stoneGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── RESET ─────────────────────────────────────────────
                  _buildSectionHeader('RESET'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _resetSettings,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _carbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardBorder),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: _dangerRed, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Reset Notification Settings',
                            style: TextStyle(
                              color: _dangerRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildSubSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      color: _obsidian.withValues(alpha: 0.3),
      child: Text(
        title,
        style: const TextStyle(
          color: _stoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSubSectionHeaderWithBadge(String title, String badge) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: _obsidian.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF162E25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: _mint,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0x0FFFFFFF),
      indent: 50,
    );
  }

  Widget _buildSwitchRow({
    IconData? icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: _offWhite, size: 20),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _offWhite,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _forest,
            activeTrackColor: _syncGreen.withValues(alpha: 0.6),
            inactiveThumbColor: _stoneGrey,
            inactiveTrackColor: _obsidian,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _offWhite, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: _mint,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: _stoneGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioRow({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _offWhite, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _offWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: _syncGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
