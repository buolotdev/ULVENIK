import 'home_widgets.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_logo.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import 'training_screen.dart';
import 'record_session_screen.dart';
import 'global_calendar_screen.dart';
import 'timeline_statistics_screen.dart';
import 'profile_page_screen.dart';

/// Rotating Home greetings (Frontend Review v07, Screen 02 — approved).
///
/// A different greeting is chosen each time the app is opened or the user
/// logs in, cycling through all 15 in shuffled order before repeating.
class HomeGreetings {
  HomeGreetings._();

  static const List<String> all = [
    'Ready to work, {Name}?',
    "Let's get to work, {Name}.",
    'Every session counts, {Name}.',
    'The work continues, {Name}.',
    'Back at it, {Name}?',
    'Progress is earned.',
    'Another day. Another session.',
    'Keep building, {Name}.',
    'Consistency builds progress.',
    'Time to put the work in.',
    'Strong foundations. Lasting progress.',
    "Let's make progress, {Name}.",
    'The journey continues, {Name}.',
    'Make today count, {Name}.',
    'Built through consistency.',
  ];

  static final Random _random = Random();
  static List<int> _queue = [];
  static int? _current;

  /// Moves to the next greeting. Call on app open and after logging in.
  static void advance() {
    if (_queue.isEmpty) {
      _queue = List<int>.generate(all.length, (i) => i)..shuffle(_random);
      // Avoid showing the same greeting twice in a row across cycles.
      if (_current != null && _queue.first == _current && _queue.length > 1) {
        _queue.add(_queue.removeAt(0));
      }
    }
    _current = _queue.removeAt(0);
  }

  /// The greeting for this app session. Uses [firstName] when available,
  /// otherwise natural name-free wording ("Ready to work?").
  static String current({String? firstName}) {
    if (_current == null) advance();
    final template = all[_current!];
    final name = firstName?.trim() ?? '';
    if (name.isNotEmpty) return template.replaceAll('{Name}', name);
    return template.replaceAll(', {Name}', '');
  }
}

enum _SessionKind { training, sc }

class _HomeSession {
  final String dog;
  final String title;
  final _SessionKind kind;
  final DateTime when;
  final Duration? duration;
  final bool completed;
  final String? photo;

  const _HomeSession({
    required this.dog,
    required this.title,
    required this.kind,
    required this.when,
    this.duration,
    this.completed = false,
    this.photo,
  });

  String get kindLabel => kind == _SessionKind.training ? 'Training' : 'S&C';
}

class _UpcomingItem {
  final String title;
  final String category; // Training / S&C / Reminder
  final String? dog;
  final DateTime when;
  const _UpcomingItem({required this.title, required this.category, required this.when, this.dog});
}

class HomepageScreen extends StatefulWidget {
  /// Sport choices only appear for users with an active Sport Pack.
  final bool hasSportPack;

  const HomepageScreen({super.key, this.hasSportPack = false});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  // Demo toggle for review (double-tap the date): empty vs populated account.
  bool _hasData = false;

  static const String _firstName = 'James';
  static const String _initials = 'JC';

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _longMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  late final DateTime _now = DateTime.now();
  DateTime get _today => DateTime(_now.year, _now.month, _now.day);

  // Sample records for the populated demo state. Figures on this screen are
  // calculated from these lists, so they stay consistent with each other.
  late final List<_HomeSession> _todaySessions = [
    _HomeSession(
      dog: 'Murphy', title: 'Recall Foundations', kind: _SessionKind.training,
      when: _today.add(const Duration(hours: 8, minutes: 30)),
      duration: const Duration(minutes: 25), completed: true,
    ),
    _HomeSession(
      dog: 'Atlas', title: 'Hill Conditioning', kind: _SessionKind.sc,
      when: _today.add(const Duration(hours: 17)),
    ),
  ];

  late final List<_HomeSession> _completedHistory = [
    _todaySessions.first.copyWithPhoto('assets/images/calendar_dog_thumb.jpg'),
    _HomeSession(
      dog: 'Atlas', title: 'Cavaletti Poles', kind: _SessionKind.sc,
      when: _today.subtract(const Duration(days: 1)).add(const Duration(hours: 18, minutes: 10)),
      duration: const Duration(minutes: 30), completed: true,
      photo: 'assets/images/photo_viewer_1.jpg',
    ),
    _HomeSession(
      dog: 'Murphy', title: 'Focused Heelwork', kind: _SessionKind.training,
      when: _today.subtract(const Duration(days: 2)).add(const Duration(hours: 7, minutes: 45)),
      duration: const Duration(minutes: 20), completed: true,
      photo: 'assets/images/calendar_dog_thumb.jpg',
    ),
    _HomeSession(
      dog: 'Atlas', title: 'Tracking Field Work', kind: _SessionKind.training,
      when: _today.subtract(const Duration(days: 9)).add(const Duration(hours: 9)),
      duration: const Duration(minutes: 40), completed: true,
      photo: 'assets/images/photo_viewer_2.jpg',
    ),
  ];

  late final List<_UpcomingItem> _upcoming = [
    _UpcomingItem(title: 'Hill Conditioning', category: 'S&C', dog: 'Atlas', when: _today.add(const Duration(hours: 17))),
    _UpcomingItem(title: 'Recall Through Distractions', category: 'Training', dog: 'Murphy',
        when: _today.add(const Duration(days: 1, hours: 9))),
    _UpcomingItem(title: 'Book annual vaccination', category: 'Reminder', dog: 'Murphy',
        when: _today.add(const Duration(days: 3, hours: 12))),
  ]..sort((a, b) => a.when.compareTo(b.when));

  // ── Helpers ─────────────────────────────────────────────────────────────
  String _two(int n) => n.toString().padLeft(2, '0');
  String _time(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';
  String _longDate(DateTime d) => '${_weekdays[d.weekday - 1]}, ${d.day} ${_longMonths[d.month - 1]}';

  String _relativeDay(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    final diff = day.difference(_today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return '${d.day} ${_months[d.month - 1]}';
  }

  String _duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  void _push(Widget screen) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  // ── Actions ─────────────────────────────────────────────────────────────
  void _openSessionChooser({required bool quickLog}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              Text(
                quickLog ? 'Quick Log' : 'Start Session',
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                quickLog
                    ? 'Record a session you have already completed. No timer needed.'
                    : 'Choose the type of session to record.',
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: UlvenikIcons.training,
                title: 'Training',
                subtitle: 'Your skills and exercises',
                onTap: () {
                  Navigator.pop(ctx);
                  openNewTrainingSession(context);
                },
              ),
              _SheetOption(
                icon: UlvenikIcons.strengthConditioning,
                title: 'Strength & Conditioning',
                subtitle: 'Your S&C activities',
                onTap: () {
                  Navigator.pop(ctx);
                  _push(const RecordSessionScreen(startWithActivity: false));
                },
              ),
              if (widget.hasSportPack)
                _SheetOption(
                  icon: UlvenikIcons.goals,
                  title: 'Sport',
                  subtitle: 'Your sports, skills and exercises',
                  onTap: () {
                    Navigator.pop(ctx);
                    openNewTrainingSession(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddToSchedule() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const Text('Add to Schedule',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('Plan a session or set a reminder.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              const SizedBox(height: 12),
              for (final opt in const [
                (UlvenikIcons.training, 'Training', 'Schedule your skills and exercises'),
                (UlvenikIcons.strengthConditioning, 'S&C', 'Schedule your S&C activities'),
                (UlvenikIcons.notifications, 'Custom Reminder', 'Anything else you want to remember'),
              ])
                _SheetOption(
                  icon: opt.$1,
                  title: opt.$2,
                  subtitle: opt.$3,
                  onTap: () {
                    Navigator.pop(ctx);
                    _push(GlobalCalendarScreen(hasSportPack: widget.hasSportPack));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    _buildGreeting(),
                    const SizedBox(height: 24),
                    _buildActions(),
                    const SizedBox(height: 32),
                    _buildToday(),
                    const SizedBox(height: 32),
                    _buildUpcoming(),
                    const SizedBox(height: 32),
                    _buildRecentActivity(),
                    const SizedBox(height: 32),
                    _buildInsights(),
                    const SizedBox(height: 24),
                    const HomeWidgetsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const UlvenikLogo.wordmark(height: 19),
          Positioned(
            right: 16,
            child: Semantics(
              button: true,
              label: 'Account',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _push(const ProfilePageScreen()),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryForestGreen.withValues(alpha: 0.25),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    _initials,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () => setState(() => _hasData = !_hasData),
          child: Text(
            _longDate(_now),
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          HomeGreetings.current(firstName: _firstName),
          style: const TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ActionCard(
              icon: UlvenikIcons.recordSession,
              title: 'Start Session',
              onTap: () => _openSessionChooser(quickLog: false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionCard(
              icon: UlvenikIcons.add,
              title: 'Quick Log',
              onTap: () => _openSessionChooser(quickLog: true),
            ),
          ),
        ],
      ),
    );
  }

  // ── Today ───────────────────────────────────────────────────────────────
  Widget _buildToday() {
    final items = _hasData ? ([..._todaySessions]..sort((a, b) => a.when.compareTo(b.when))) : <_HomeSession>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader(title: 'Today'),
        if (items.isEmpty)
          const _EmptyCard(
            icon: UlvenikIcons.calendar,
            message: 'Nothing planned for today',
            submessage: 'Your schedule is clear. Ready to get started?',
          )
        else
          for (final s in items) ...[
            _ListCard(
              onTap: s.completed
                  ? () => _push(const TrainingScreen())
                  : () => s.kind == _SessionKind.training
                      ? openNewTrainingSession(context, dogName: s.dog)
                      : _push(const RecordSessionScreen(startWithActivity: false)),
              leading: _IconBox(icon: s.kind == _SessionKind.training ? UlvenikIcons.training : UlvenikIcons.strengthConditioning),
              title: s.title,
              subtitle: '${s.dog} · ${s.kindLabel} · ${_time(s.when)}',
              trailing: s.completed
                  ? const Row(mainAxisSize: MainAxisSize.min, children: [
                      UlvenikIcon(UlvenikIcons.completed, size: 18, color: Color(0xFF6FBF8E)),
                      SizedBox(width: 6),
                      Text('Completed', style: TextStyle(color: Color(0xFF6FBF8E), fontSize: 12, fontWeight: FontWeight.w600)),
                    ])
                  : const Text('Planned', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  // ── Upcoming ────────────────────────────────────────────────────────────
  Widget _buildUpcoming() {
    final items = _hasData ? _upcoming.where((u) => u.when.isAfter(_now)).toList() : <_UpcomingItem>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'Upcoming',
          trailing: IconButton(
            tooltip: 'Add to Schedule',
            onPressed: _openAddToSchedule,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            icon: const UlvenikIcon(UlvenikIcons.add, size: 22, color: AppColors.primaryTextOffWhite),
          ),
        ),
        if (items.isEmpty)
          const _EmptyCard(icon: UlvenikIcons.calendar, message: 'Nothing coming up')
        else
          for (final u in items) ...[
            _ListCard(
              onTap: () => _push(GlobalCalendarScreen(hasSportPack: widget.hasSportPack)),
              leading: _IconBox(
                icon: switch (u.category) {
                  'Training' => UlvenikIcons.training,
                  'S&C' => UlvenikIcons.strengthConditioning,
                  _ => UlvenikIcons.notifications,
                },
              ),
              title: u.title,
              subtitle: [if (u.dog != null) u.dog!, u.category].join(' · '),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_relativeDay(u.when),
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5, fontWeight: FontWeight.w600)),
                  Text(_time(u.when), style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  // ── Recent Activity ─────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    final recent = _hasData
        ? ([..._completedHistory.where((s) => s.completed)]..sort((a, b) => b.when.compareTo(a.when))).take(3).toList()
        : <_HomeSession>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'Recent Activity',
          trailing: recent.isEmpty ? null : _TextAction(label: 'View All', onTap: () => _push(const TrainingScreen())),
        ),
        if (recent.isEmpty)
          const _EmptyCard(icon: UlvenikIcons.history, message: 'No recent activity', compact: true)
        else
          for (final s in recent) ...[
            _ListCard(
              onTap: () => _push(const TrainingScreen()),
              leading: _DogThumb(photo: s.photo, name: s.dog),
              title: s.title,
              subtitle: [
                s.dog,
                s.kindLabel,
                _relativeDay(s.when),
                if (s.duration != null) _duration(s.duration!),
              ].join(' · '),
              trailing: const UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  // ── Insights ────────────────────────────────────────────────────────────
  Widget _buildInsights() {
    // Current Monday–Sunday week.
    final weekStart = _today.subtract(Duration(days: _today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    final thisWeek = _hasData
        ? _completedHistory.where((s) => s.completed && !s.when.isBefore(weekStart) && s.when.isBefore(weekEnd)).toList()
        : <_HomeSession>[];
    final activeDays = thisWeek.map((s) => DateTime(s.when.year, s.when.month, s.when.day)).toSet().length;
    final recorded = thisWeek.where((s) => s.duration != null).toList();
    final totalTime = recorded.fold<Duration>(Duration.zero, (a, s) => a + s.duration!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          title: 'Insights',
          trailing: _TextAction(
            label: 'View Analytics',
            onTap: () => _push(TimelineStatisticsScreen(hasSportPack: widget.hasSportPack)),
          ),
        ),
        if (!_hasData)
          const _EmptyCard(
            icon: UlvenikIcons.progress,
            message: 'No sessions this week yet',
            submessage: 'Your weekly summary will appear after your first session.',
            compact: true,
          )
        else
          Row(
            children: [
              Expanded(child: _StatTile(label: 'Sessions This Week', value: '${thisWeek.length}')),
              const SizedBox(width: 8),
              Expanded(child: _StatTile(label: 'Active Days', value: '$activeDays')),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  label: 'Training Time',
                  value: recorded.isEmpty ? '—' : _duration(totalTime),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

extension on _HomeSession {
  _HomeSession copyWithPhoto(String photo) => _HomeSession(
        dog: dog, title: title, kind: kind, when: when, duration: duration, completed: completed, photo: photo,
      );
}

// ── Shared pieces ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TextAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryTextOffWhite.withValues(alpha: 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500)),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UlvenikIcon(icon, size: 28, color: AppColors.primaryTextOffWhite),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String icon;
  final String message;
  final String? submessage;
  final bool compact;
  const _EmptyCard({required this.icon, required this.message, this.submessage, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 20 : 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          UlvenikIcon(icon, size: compact ? 26 : 32, color: AppColors.secondarySage),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
          if (submessage != null) ...[
            const SizedBox(height: 4),
            Text(submessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          ],
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  const _ListCard({required this.leading, required this.title, required this.subtitle, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final String icon;
  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryForestGreen.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: UlvenikIcon(icon, size: 20, color: AppColors.primaryTextOffWhite),
    );
  }
}

class _DogThumb extends StatelessWidget {
  final String? photo;
  final String name;
  const _DogThumb({required this.photo, required this.name});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.primaryForestGreen.withValues(alpha: 0.2),
      alignment: Alignment.center,
      child: const UlvenikIcon(UlvenikIcons.dogs, size: 20, color: AppColors.secondarySage),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 44,
        height: 44,
        child: photo == null
            ? fallback
            : Image.asset(photo!, fit: BoxFit.cover, cacheWidth: 132, semanticLabel: name, errorBuilder: (_, _, _) => fallback),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12, height: 1.25)),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SheetOption({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _IconBox(icon: icon),
      title: Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
      trailing: const UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
      onTap: onTap,
    );
  }
}
