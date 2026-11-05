import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final bool hasSportPack;
  final bool hasTrainerPack;

  const NotificationSettingsScreen({
    super.key,
    this.hasSportPack = true,
    this.hasTrainerPack = true,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _subHeaderBg = Color(0xFF161B1D);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _switchOffTrack = Color(0xFF2B3135);
  static const Color _destructive = Color(0xFF8B3A3A);
  static const Color _destructiveText = Color(0xFFA84646);

  bool _pushMaster = true;
  bool _emailMaster = true;
  bool _quietHoursEnabled = true;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);
  bool _quietPreviewActive = false;

  String _trainingTiming = '30 Minutes Before';
  String _healthTiming = '1 Hour Before';
  String _goalsTiming = '1 Day Before';
  String _competitionsTiming = '2 Hours Before';

  String _selectedSound = 'Default';
  bool _showAppBadge = true;
  bool _justSaved = false;

  late Map<String, bool> _pushToggles;
  late Map<String, bool> _emailToggles;

  List<(String, String, String)> _historyLogs = [
    (
      'Training',
      'Scheduled Session · Recall & Impulse Control',
      'Today, 08:30 AM',
    ),
    (
      'Health',
      'Supplement Reminder · Omega-3 Joint Support',
      'Today, 07:30 AM',
    ),
    (
      'Trainer',
      'Homework Submitted · Maja Lindqvist (Fenrir)',
      'Yesterday, 06:14 PM',
    ),
    (
      'Timeline',
      'Timeline Memories · 1 Year Ago Today unlocked',
      'Yesterday, 09:00 AM',
    ),
    (
      'Goals',
      'Milestone Reached · 80% Distance Stay consistency',
      '2 days ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initDefaultToggles();
  }

  void _initDefaultToggles() {
    _pushMaster = true;
    _emailMaster = true;
    _quietHoursEnabled = true;
    _quietStart = const TimeOfDay(hour: 22, minute: 0);
    _quietEnd = const TimeOfDay(hour: 7, minute: 0);
    _quietPreviewActive = false;
    _trainingTiming = '30 Minutes Before';
    _healthTiming = '1 Hour Before';
    _goalsTiming = '1 Day Before';
    _competitionsTiming = '2 Hours Before';
    _selectedSound = 'Default';
    _showAppBadge = true;

    _pushToggles = {
      'Training Reminders': true,
      'Scheduled Sessions': true,
      'Missed Training': true,
      'Training Goals Achieved': true,
      'Swimming Reminders': true,
      'Hydrotherapy Reminders': true,
      'Exercise Schedule': true,
      'Medication Reminders': true,
      'Vaccinations': true,
      'Vet Appointments': true,
      'Weight Check Reminders': true,
      'Supplement Reminders': true,
      'Goal Due Soon': true,
      'Goal Completed': true,
      'Milestone Reached': true,
      'Recording Streak': true,
      'No Activity Recorded': true,
      'Timeline Memories': true,
      'New Timeline Insights': true,
      if (widget.hasSportPack) ...{
        'Upcoming Competition': true,
        'Competition Reminder': true,
        'Competition Results Ready': true,
      },
      if (widget.hasTrainerPack) ...{
        'Client Shared Training': true,
        'Homework Submitted': true,
        'Client Progress Updates': true,
      },
    };

    _emailToggles = {
      'Product Updates': true,
      'Feature Announcements': true,
      'Security Alerts': true,
      'Subscription Receipts': true,
      'Account Notifications': false,
    };
  }

  void _markSaved() {
    setState(() => _justSaved = true);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _justSaved = false);
    });
  }

  int get _activeCount {
    // Baseline 18 active notifications when all default toggles are at factory state,
    // scaling dynamically as the user enables/disables individual or master switches.
    final enabledPush = _pushMaster
        ? _pushToggles.values.where((v) => v).length
        : 0;
    final enabledEmail = _emailMaster
        ? _emailToggles.values.where((v) => v).length
        : 0;
    if (!_pushMaster && !_emailMaster) return 0;
    final initialTotal = _pushToggles.length + 4;
    final delta = (enabledPush + enabledEmail) - initialTotal;
    final computed = 18 + delta;
    if (computed < 0) return enabledPush + enabledEmail;
    return computed;
  }

  String _formatTime(TimeOfDay t) {
    final hour12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final hStr = hour12.toString().padLeft(2, '0');
    final mStr = t.minute.toString().padLeft(2, '0');
    final suffix = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hStr:$mStr $suffix';
  }

  Future<void> _pickTime({required bool isStart}) async {
    if (!_quietHoursEnabled) {
      AppSnackbar.show(
        context,
        title: 'Quiet Hours Disabled',
        message: 'Enable Quiet Hours first to adjust schedule times.',
        type: SnackbarType.info,
      );
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietStart : _quietEnd,
      builder: (ctx, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _forest,
              surface: _carbon,
              onSurface: _offWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart) {
          _quietStart = picked;
        } else {
          _quietEnd = picked;
        }
        _quietPreviewActive = true;
      });
      _markSaved();
      AppSnackbar.show(
        context,
        title: 'Quiet Hours Updated',
        message:
            'Scheduled ${_formatTime(_quietStart)} – ${_formatTime(_quietEnd)}.',
        type: SnackbarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('OVERVIEW'),
                    const SizedBox(height: 10),
                    _buildOverviewCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('PUSH NOTIFICATIONS'),
                    const SizedBox(height: 10),
                    _buildPushNotificationsCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('EMAIL NOTIFICATIONS'),
                    const SizedBox(height: 10),
                    _buildEmailNotificationsCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('QUIET HOURS'),
                    const SizedBox(height: 10),
                    _buildQuietHoursCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('REMINDER TIMING'),
                    const SizedBox(height: 10),
                    _buildReminderTimingCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('NOTIFICATION SOUNDS'),
                    const SizedBox(height: 10),
                    _buildSoundsCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('BADGE COUNT'),
                    const SizedBox(height: 10),
                    _buildBadgeCountCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('HISTORY'),
                    const SizedBox(height: 10),
                    _buildHistoryCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('RESET'),
                    const SizedBox(height: 10),
                    _buildResetCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 14),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(_pushMaster),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: UlvenikIcon(UlvenikIcons.back,
                color: _stoneGrey,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Notification Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: _justSaved ? _forest : _stoneGrey,
            ),
            child: const Text('Saved'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _stoneGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    final quietActive = _quietHoursEnabled && _quietPreviewActive;
    final quietLabel = !_quietHoursEnabled
        ? 'Disabled'
        : (quietActive ? 'Scheduled' : 'Off');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildOverviewStatusItem(
                  label: 'Push',
                  value: _pushMaster ? 'Enabled' : 'Disabled',
                  dotColor: _pushMaster ? _forest : _stoneGrey,
                ),
              ),
              Expanded(
                child: _buildOverviewStatusItem(
                  label: 'Email',
                  value: _emailMaster ? 'Enabled' : 'Disabled',
                  dotColor: _emailMaster ? _forest : _stoneGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_quietHoursEnabled) {
                      setState(
                        () => _quietPreviewActive = !_quietPreviewActive,
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: _buildOverviewStatusItem(
                    label: 'Quiet Hours',
                    value: quietLabel,
                    dotColor: quietActive ? _forest : _stoneGrey,
                  ),
                ),
              ),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _activeCount.toDouble()),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  builder: (context, val, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${val.round()} Active',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'notifications',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _stoneGrey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStatusItem({
    required String label,
    required String value,
    required Color dotColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: _stoneGrey,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: _offWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPushNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildMasterToggleRow(
            title: 'Enable Push Notifications',
            value: _pushMaster,
            onChanged: (v) {
              setState(() => _pushMaster = v);
              _markSaved();
            },
          ),
          _buildCategoryStrip('TRAINING'),
          _buildPushRow(Icons.notifications_none_rounded, 'Training Reminders'),
          _buildDivider(),
          _buildPushRow(Icons.calendar_today_outlined, 'Scheduled Sessions'),
          _buildDivider(),
          _buildPushRow(Icons.schedule_rounded, 'Missed Training'),
          _buildDivider(),
          _buildPushRow(Icons.outlined_flag_rounded, 'Training Goals Achieved'),
          _buildCategoryStrip('STRENGTH & CONDITIONING'),
          _buildPushRow(Icons.waves_rounded, 'Swimming Reminders'),
          _buildDivider(),
          _buildPushRow(
            Icons.monitor_heart_outlined,
            'Hydrotherapy Reminders',
          ),
          _buildDivider(),
          _buildPushRow(Icons.fitness_center_rounded, 'Exercise Schedule'),
          _buildCategoryStrip('HEALTH'),
          _buildPushRow(Icons.tune_rounded, 'Medication Reminders'),
          _buildDivider(),
          _buildPushRow(Icons.verified_user_outlined, 'Vaccinations'),
          _buildDivider(),
          _buildPushRow(Icons.apartment_rounded, 'Vet Appointments'),
          _buildDivider(),
          _buildPushRow(
            Icons.monitor_weight_outlined,
            'Weight Check Reminders',
          ),
          _buildDivider(),
          _buildPushRow(Icons.medication_outlined, 'Supplement Reminders'),
          _buildCategoryStrip('GOALS'),
          _buildPushRow(Icons.schedule_rounded, 'Goal Due Soon'),
          _buildDivider(),
          _buildPushRow(Icons.emoji_events_outlined, 'Goal Completed'),
          _buildDivider(),
          _buildPushRow(Icons.star_border_rounded, 'Milestone Reached'),
          _buildCategoryStrip('TIMELINE'),
          _buildPushRow(
            Icons.local_fire_department_outlined,
            'Recording Streak',
          ),
          _buildDivider(),
          _buildPushRow(Icons.adjust_rounded, 'No Activity Recorded'),
          _buildDivider(),
          _buildPushRow(Icons.history_rounded, 'Timeline Memories'),
          _buildDivider(),
          _buildPushRow(Icons.auto_awesome_outlined, 'New Timeline Insights'),
          if (widget.hasSportPack) ...[
            _buildCategoryStrip('COMPETITIONS', packBadge: 'Sport Pack'),
            _buildPushRow(
              Icons.emoji_events_outlined,
              'Upcoming Competition',
            ),
            _buildDivider(),
            _buildPushRow(
              Icons.notifications_none_rounded,
              'Competition Reminder',
            ),
            _buildDivider(),
            _buildPushRow(
              Icons.description_outlined,
              'Competition Results Ready',
            ),
          ],
          if (widget.hasTrainerPack) ...[
            _buildCategoryStrip('TRAINER', packBadge: 'Trainer Pack'),
            _buildPushRow(
              Icons.supervisor_account_outlined,
              'Client Shared Training',
            ),
            _buildDivider(),
            _buildPushRow(Icons.assignment_outlined, 'Homework Submitted'),
            _buildDivider(),
            _buildPushRow(
              Icons.trending_up_rounded,
              'Client Progress Updates',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildMasterToggleRow(
            title: 'Receive Emails',
            value: _emailMaster,
            onChanged: (v) {
              setState(() => _emailMaster = v);
              _markSaved();
            },
          ),
          _buildDivider(),
          _buildEmailRow(Icons.mail_outline_rounded, 'Product Updates'),
          _buildDivider(),
          _buildEmailRow(Icons.campaign_outlined, 'Feature Announcements'),
          _buildDivider(),
          _buildEmailRow(Icons.lock_outline_rounded, 'Security Alerts'),
          _buildDivider(),
          _buildEmailRow(Icons.credit_card_outlined, 'Subscription Receipts'),
          _buildDivider(),
          _buildEmailRow(Icons.person_outline_rounded, 'Account Notifications'),
        ],
      ),
    );
  }

  Widget _buildQuietHoursCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.nightlight_outlined,
                  color: _stoneGrey,
                  size: 19,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Enable Quiet Hours',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: _offWhite,
                    ),
                  ),
                ),
                _UlvenikSwitch(
                  value: _quietHoursEnabled,
                  onChanged: (v) {
                    setState(() => _quietHoursEnabled = v);
                    _markSaved();
                  },
                ),
              ],
            ),
          ),
          _buildDivider(),
          _buildActionValueRow(
            icon: Icons.schedule_rounded,
            title: 'Start Time',
            value: _formatTime(_quietStart),
            valueColor: _quietHoursEnabled ? _forest : _stoneGrey,
            onTap: () => _pickTime(isStart: true),
          ),
          _buildDivider(),
          _buildActionValueRow(
            icon: Icons.schedule_rounded,
            title: 'End Time',
            value: _formatTime(_quietEnd),
            valueColor: _quietHoursEnabled ? _forest : _stoneGrey,
            onTap: () => _pickTime(isStart: false),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTimingCard() {
    const options = [
      'At Time of Event',
      '15 Minutes Before',
      '30 Minutes Before',
      '1 Hour Before',
      '2 Hours Before',
      '1 Day Before',
    ];
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildActionValueRow(
            icon: Icons.schedule_rounded,
            title: 'Training',
            value: _trainingTiming,
            valueColor: _stoneGrey,
            onTap: () => _showTimingPicker(
              category: 'Training',
              current: _trainingTiming,
              options: options,
              onSelect: (v) => setState(() => _trainingTiming = v),
            ),
          ),
          _buildDivider(),
          _buildActionValueRow(
            icon: Icons.schedule_rounded,
            title: 'Health',
            value: _healthTiming,
            valueColor: _stoneGrey,
            onTap: () => _showTimingPicker(
              category: 'Health',
              current: _healthTiming,
              options: options,
              onSelect: (v) => setState(() => _healthTiming = v),
            ),
          ),
          _buildDivider(),
          _buildActionValueRow(
            icon: Icons.schedule_rounded,
            title: 'Goals',
            value: _goalsTiming,
            valueColor: _stoneGrey,
            onTap: () => _showTimingPicker(
              category: 'Goals',
              current: _goalsTiming,
              options: options,
              onSelect: (v) => setState(() => _goalsTiming = v),
            ),
          ),
          if (widget.hasSportPack) ...[
            _buildDivider(),
            _buildActionValueRow(
              icon: Icons.schedule_rounded,
              title: 'Competitions',
              value: _competitionsTiming,
              valueColor: _stoneGrey,
              onTap: () => _showTimingPicker(
                category: 'Competitions',
                current: _competitionsTiming,
                options: options,
                onSelect: (v) => setState(() => _competitionsTiming = v),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoundsCard() {
    final sounds = [
      ('Default', Icons.volume_up_outlined),
      ('Silent', Icons.volume_off_outlined),
      ('System Sound', Icons.volume_up_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ...sounds.asMap().entries.map((entry) {
            final idx = entry.key;
            final s = entry.value;
            final selected = _selectedSound == s.$1;
            return Column(
              children: [
                if (idx > 0) _buildDivider(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedSound = s.$1);
                      _markSaved();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          UlvenikIcon.fromMaterial(s.$2, color: _stoneGrey, size: 19),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              s.$1,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: _offWhite,
                              ),
                            ),
                          ),
                          if (selected)
                            const Icon(Icons.check_rounded,
                              color: _forest,
                              size: 19,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          _buildDivider(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                AppSnackbar.show(
                  context,
                  title: 'Custom Sounds Coming Soon',
                  message:
                      'Custom whistle & clicker alert tones will arrive in a future update.',
                  type: SnackbarType.info,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Icon(Icons.music_note_outlined,
                      color: _stoneGrey.withValues(alpha: 0.55),
                      size: 19,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Custom Sounds',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: _stoneGrey.withValues(alpha: 0.65),
                        ),
                      ),
                    ),
                    Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: _stoneGrey.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCountCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          const UlvenikIcon(UlvenikIcons.notifications,
            color: _stoneGrey,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Show App Badge',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: _offWhite,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Display notification count on app icon',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: _stoneGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _UlvenikSwitch(
            value: _showAppBadge,
            onChanged: (v) {
              setState(() => _showAppBadge = v);
              _markSaved();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _showHistorySheet,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: const Row(
            children: [
              UlvenikIcon(UlvenikIcons.trainingTime, color: _stoneGrey, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View Notification History',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Chronological log of delivered notifications',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              UlvenikIcon(UlvenikIcons.details, color: _stoneGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResetCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _showResetConfirmationSheet,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder, width: 1),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sync_rounded, color: _destructiveText, size: 18),
              SizedBox(width: 8),
              Text(
                'Reset Notification Settings',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: _destructiveText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Row Builders ──────────────────────────────────────────────────────────

  Widget _buildMasterToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: _offWhite,
              ),
            ),
          ),
          _UlvenikSwitch(value: value, isLarge: true, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildCategoryStrip(String label, {String? packBadge}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: const BoxDecoration(
        color: _subHeaderBg,
        border: Border.symmetric(
          horizontal: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _stoneGrey,
              letterSpacing: 0.9,
            ),
          ),
          if (packBadge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: _forest.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _forest.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
              child: Text(
                packBadge,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: _mint,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPushRow(IconData icon, String keyName) {
    final rawVal = _pushToggles[keyName] ?? true;
    final effectiveVal = _pushMaster && rawVal;
    return Opacity(
      opacity: _pushMaster ? 1.0 : 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(
              icon,
              color: _stoneGrey,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                keyName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _offWhite,
                ),
              ),
            ),
            _UlvenikSwitch(
              value: effectiveVal,
              onChanged: (v) {
                if (!_pushMaster) {
                  setState(() {
                    _pushMaster = true;
                    _pushToggles[keyName] = true;
                  });
                } else {
                  setState(() => _pushToggles[keyName] = v);
                }
                _markSaved();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailRow(IconData icon, String keyName) {
    final rawVal = _emailToggles[keyName] ?? false;
    final effectiveVal = _emailMaster && rawVal;
    return Opacity(
      opacity: _emailMaster ? 1.0 : 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                keyName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _offWhite,
                ),
              ),
            ),
            _UlvenikSwitch(
              value: effectiveVal,
              onChanged: (v) {
                if (!_emailMaster) {
                  setState(() {
                    _emailMaster = true;
                    _emailToggles[keyName] = true;
                  });
                } else {
                  setState(() => _emailToggles[keyName] = v);
                }
                _markSaved();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionValueRow({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              UlvenikIcon.fromMaterial(icon, color: _stoneGrey, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _offWhite,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 6),
              const UlvenikIcon(UlvenikIcons.details,
                color: _stoneGrey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: _cardBorder);
  }

  // ── Bottom Sheets ─────────────────────────────────────────────────────────

  void _showTimingPicker({
    required String category,
    required String current,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$category Reminder Timing',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 10),
                ...options.map((opt) {
                  final active = opt == current;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      opt,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: active ? _forest : _offWhite,
                      ),
                    ),
                    trailing: active
                        ? const Icon(Icons.check_rounded, color: _forest)
                        : null,
                    onTap: () {
                      onSelect(opt);
                      _markSaved();
                      Navigator.of(sheetCtx).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHistorySheet() {
    String selectedFilter = 'All';
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filtered = selectedFilter == 'All'
                ? _historyLogs
                : _historyLogs
                    .where((item) => item.$1 == selectedFilter)
                    .toList();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _stoneGrey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Notification History',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _offWhite,
                          ),
                        ),
                        if (_historyLogs.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() => _historyLogs = []);
                              setSheetState(() {});
                            },
                            child: const Text(
                              'Clear Log',
                              style: TextStyle(
                                color: _destructiveText,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['All', 'Training', 'Health', 'Trainer']
                          .map((cat) {
                        final active = selectedFilter == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: active,
                          selectedColor: _forest.withValues(alpha: 0.25),
                          backgroundColor: _obsidian,
                          labelStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: active ? _mint : _stoneGrey,
                          ),
                          onSelected: (_) =>
                              setSheetState(() => selectedFilter = cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No delivered notifications in this category.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: _stoneGrey,
                            ),
                          ),
                        ),
                      )
                    else
                      ...filtered.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: _obsidian,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.$2,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _offWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${entry.$1} · ${entry.$3}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.5,
                                          color: _stoneGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showResetConfirmationSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reset Notification Settings?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This restores all Push, Email, Quiet Hours, Reminder Timing, and Sound preferences to Ulvenik defaults.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    height: 1.45,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _cardBorder),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: _offWhite),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _destructive,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(_initDefaultToggles);
                          _markSaved();
                          Navigator.of(sheetCtx).pop();
                          AppSnackbar.show(
                            context,
                            title: 'Defaults Restored',
                            message:
                                'All notification settings reset to factory defaults.',
                            type: SnackbarType.success,
                          );
                        },
                        child: const Text('Reset All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UlvenikSwitch extends StatelessWidget {
  final bool value;
  final bool isLarge;
  final ValueChanged<bool> onChanged;

  const _UlvenikSwitch({
    required this.value,
    this.isLarge = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = isLarge ? 48.0 : 44.0;
    final height = isLarge ? 27.0 : 24.0;
    final thumb = isLarge ? 21.0 : 18.0;

    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 190),
        curve: Curves.easeOutCubic,
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: value
              ? _NotificationSettingsScreenState._forest
              : _NotificationSettingsScreenState._switchOffTrack,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 190),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumb,
            height: thumb,
            decoration: BoxDecoration(
              color: value
                  ? _NotificationSettingsScreenState._offWhite
                  : _NotificationSettingsScreenState._stoneGrey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
