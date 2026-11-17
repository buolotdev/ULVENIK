import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/photo_picker.dart';
import '../theme/app_colors.dart';
import 'skills_list_screen.dart';
import 'goals_list_screen.dart';
import 'statistics_tab.dart';
import 'training_screen.dart';
import 'training_session_screen.dart';
import 'record_session_screen.dart';
import 'global_calendar_screen.dart';
import 'health_tab.dart';
import 'sc_tab.dart';
import 'dog_media_library.dart';
import 'sport_screens.dart';
import 'cover_photo_editor_screen.dart';

enum _FocusKind { training, sc, health }

enum _FocusState { scheduled, completed, given, notGiven }

class _FocusItem {
  final _FocusKind kind;
  final String title;
  final TimeOfDay? time;
  final String? details; // prescribed details for health items
  _FocusState state;
  _FocusItem(this.kind, this.title, {this.time, this.details, this.state = _FocusState.scheduled});
}

class _Draft {
  final String title;
  final String type; // Training / S&C / Sport
  final DateTime savedAt;
  const _Draft(this.title, this.type, this.savedAt);
}

class _UpcomingItem {
  String title;
  final String category; // Training / S&C / Health
  DateTime when;
  _UpcomingItem(this.title, this.category, this.when);
}

/// Individual dog profile (Individual Dog Overview handover).
///
/// Full-width cover photo with name, breed, age and sex over a gradient and a
/// discreet Edit pencil; three equal stat cards below the cover (Sessions,
/// Total Time, Active Goals); tabs Overview | Training | S&C | Sport (Sport
/// Pack only) | Health | Media. Overview: Today's Focus, Continue (hidden
/// with no drafts) and Upcoming.
class DogProfileScreen extends StatefulWidget {
  final String? dogName;
  final bool hasSportPack;

  /// Tab to open first, e.g. 'S&C' from the Training Sessions shortcut.
  final String initialTab;

  const DogProfileScreen({super.key, this.dogName, this.hasSportPack = true, this.initialTab = 'Overview'});

  @override
  State<DogProfileScreen> createState() => _DogProfileScreenState();
}

class _DogProfileScreenState extends State<DogProfileScreen> with SingleTickerProviderStateMixin {
  late final DogInfo _dog = SampleData.dogNamed(widget.dogName ?? SampleData.myDogs.first.name);
  late final TabController _tabController;
  late final List<String> _tabs = [
    'Overview', 'Training', 'S&C', if (widget.hasSportPack) 'Sport', 'Health', 'Media',
  ];

  bool _hasData = true; // demo toggle: double-tap the dog's name
  CoverCrop get _coverCrop => CoverCrop(scale: _dog.coverCrop.scale, dx: _dog.coverCrop.dx, dy: _dog.coverCrop.dy);

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  late final DateTime _today = DateUtils.dateOnly(DateTime.now());

  late final List<_FocusItem> _focus = [
    _FocusItem(_FocusKind.health, 'Metacam', time: const TimeOfDay(hour: 8, minute: 0), details: '1.5 ml with breakfast'),
    _FocusItem(_FocusKind.training, 'Recall Foundations',
        time: const TimeOfDay(hour: 10, minute: 0), state: _FocusState.completed),
    _FocusItem(_FocusKind.sc, 'Hill Conditioning', time: const TimeOfDay(hour: 17, minute: 0)),
    _FocusItem(_FocusKind.training, 'Heelwork Practice'),
  ];

  late final List<_Draft> _drafts = [
    _Draft('Morning Obedience', 'Training', DateTime.now().subtract(const Duration(hours: 2))),
    _Draft('Cavaletti Poles', 'S&C', DateTime.now().subtract(const Duration(days: 1, hours: 3))),
    _Draft('Retrieve Work', 'Training', DateTime.now().subtract(const Duration(days: 3))),
    _Draft('Recall in the Woods', 'Training', DateTime.now().subtract(const Duration(days: 6))),
  ]..sort((a, b) => b.savedAt.compareTo(a.savedAt));

  late final List<_UpcomingItem> _upcoming = [
    _UpcomingItem('Annual Booster', 'Health', _today.add(const Duration(days: 4, hours: 9, minutes: 30))),
    _UpcomingItem('Recall Through Distractions', 'Training', _today.add(const Duration(days: 1, hours: 9))),
    _UpcomingItem('Swimming', 'S&C', _today.add(const Duration(days: 2, hours: 18))),
    _UpcomingItem('Focused Heelwork', 'Training', _today.add(const Duration(days: 8, hours: 10))),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _tabs.indexOf(widget.initialTab).clamp(0, _tabs.length - 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  String _two(int n) => n.toString().padLeft(2, '0');
  String _hm(TimeOfDay t) => '${_two(t.hour)}:${_two(t.minute)}';
  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
  String _savedAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return 'Saved ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'Saved ${diff.inHours} h ago';
    if (diff.inDays == 1) return 'Saved yesterday';
    return 'Saved ${d.day} ${_months[d.month - 1]}';
  }

  String _iconFor(String category) => switch (category) {
        'Training' => UlvenikIcons.training,
        'S&C' => UlvenikIcons.strengthConditioning,
        'Health' => UlvenikIcons.health,
        _ => UlvenikIcons.calendar,
      };

  int get _activeGoals => SampleData.goalsFor(_dog.name).where((g) => g.status == GoalStatus.active).length;

  String get _totalTime {
    final m = _hasData ? _dog.totalMinutes : 0;
    if (m == 0) return '0h';
    final h = m ~/ 60;
    final r = m % 60;
    return r == 0 ? '${h}h' : '${h}h ${r}m';
  }

  void _push(Widget w) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => w));
    if (mounted) setState(() {}); // refresh counts (goals, etc.) changed on the pushed screen
  }

  void _goToTab(String name) {
    final i = _tabs.indexOf(name);
    if (i >= 0) _tabController.animateTo(i);
  }

  // ── Header actions ──────────────────────────────────────────────────────
  Future<void> _editCover() async {
    if (_dog.photoProvider == null) {
      final path = await pickPhotoPath(context);
      if (path == null || !mounted) return;
      DogsStore.instance.setPhoto(_dog, path);
      setState(() {});
    }
    final source = _dog.photoProvider!;
    final result = await Navigator.push<CoverCrop>(
      context,
      MaterialPageRoute(
        builder: (_) => CoverPhotoEditorScreen(
          image: source,
          dogName: _dog.name,
          initial: _coverCrop,
        ),
      ),
    );
    if (result != null && mounted) {
      DogsStore.instance.setCoverCrop(_dog, DogCoverCrop(scale: result.scale, dx: result.dx, dy: result.dy));
      setState(() {});
      AppSnackbar.show(context, message: 'Cover photo updated', type: SnackbarType.success);
    }
  }

  void _openProfileMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: UlvenikIcon(UlvenikIcons.edit, size: 22, color: AppColors.primaryTextOffWhite),
              title: Text('Edit Profile', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              subtitle: Text('Dog details and profile photograph',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              onTap: () {
                Navigator.pop(ctx);
                _editCover();
              },
            ),
            ListTile(
              leading: const SizedBox(width: 22),
              title: Text('Archive Dog', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              onTap: () {
                Navigator.pop(ctx);
                _confirm(
                  title: 'Archive ${_dog.name}?',
                  message: '${_dog.name} will be hidden from your active dogs. All records are kept.',
                  action: 'Archive Dog',
                  destructive: false,
                  onConfirm: () {
                    DogsStore.instance.setArchived(_dog, true);
                    Navigator.pop(context);
                  },
                );
              },
            ),
            ListTile(
              leading: const SizedBox(width: 22),
              title: const Text('Delete Dog', style: TextStyle(color: Color(0xFFE08A8A))),
              onTap: () {
                Navigator.pop(ctx);
                _confirm(
                  title: 'Delete ${_dog.name}?',
                  message: 'This permanently deletes ${_dog.name}\'s profile. This cannot be undone.',
                  action: 'Delete Dog',
                  destructive: true,
                  onConfirm: () {
                    DogsStore.instance.delete(_dog.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ]),
        ),
      ),
    );
  }

  void _confirm({
    required String title,
    required String message,
    required String action,
    required bool destructive,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: destructive ? const Color(0xD98B3A3A) : AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(action, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildCover(),
          SliverToBoxAdapter(child: _buildStatCards()),
          SliverPersistentHeader(pinned: true, delegate: _StickyTabBarDelegate(tabBar: _buildTabBar())),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            for (final t in _tabs)
              switch (t) {
                'Overview' => _buildOverview(),
                'Training' => _buildTrainingTab(),
                'S&C' => _buildStrengthConditioningTab(),
                'Sport' => _buildSportTab(),
                'Health' => _buildHealthTab(),
                _ => _buildMediaTab(),
              },
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    final placeholder = Container(
      color: const Color(0xFF1E2522),
      alignment: Alignment.center,
      child: UlvenikIcon(UlvenikIcons.dogs, size: 56, color: AppColors.secondarySage),
    );
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.backgroundObsidian,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        tooltip: 'Back',
        icon: UlvenikIcon(UlvenikIcons.back, color: AppColors.primaryTextOffWhite),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        IconButton(
          tooltip: 'Profile options',
          icon: UlvenikIcon(UlvenikIcons.overflowMenu, color: AppColors.primaryTextOffWhite),
          onPressed: _openProfileMenu,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(fit: StackFit.expand, children: [
          CroppedCover(
            image: _dog.photoProvider,
            crop: _coverCrop,
            placeholder: placeholder,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.6, 1.0],
                colors: [Color(0x66121212), Colors.transparent, Color(0x80121212), AppColors.backgroundObsidian],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 64,
            bottom: 16,
            child: GestureDetector(
              onDoubleTap: () => setState(() => _hasData = !_hasData),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(_dog.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.primaryTextOffWhite, fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                const SizedBox(height: 2),
                Text(_dog.details, style: const TextStyle(color: Color(0xFFD5DAD7), fontSize: 14)),
              ]),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Material(
              color: const Color(0x99121212),
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Edit cover photo',
                onPressed: _editCover,
                icon: UlvenikIcon(UlvenikIcons.edit, size: 18, color: AppColors.primaryTextOffWhite),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildStatCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: _StatCard(
              icon: UlvenikIcons.recordSession,
              value: '${_hasData ? _dog.sessionCount : 0}',
              label: 'Sessions',
              onTap: () => _push(const TrainingScreen()),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: UlvenikIcons.trainingTime,
              value: _totalTime,
              label: 'Total Time',
              onTap: () => _goToTab('Training'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              icon: UlvenikIcons.goals,
              value: '${_hasData ? _activeGoals : 0}',
              label: 'Active Goals',
              onTap: () => _push(GoalsListScreen(dogName: _dog.name, initialFilter: GoalStatus.active)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.backgroundObsidian,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        indicatorColor: AppColors.primaryForestGreen,
        indicatorWeight: 2.5,
        labelColor: AppColors.primaryTextOffWhite,
        unselectedLabelColor: AppColors.secondaryTextStoneGrey,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        dividerColor: Colors.white12,
        tabs: [for (final t in _tabs) Tab(text: t)],
      ),
    );
  }

  // ── Overview ────────────────────────────────────────────────────────────
  Widget _buildOverview() {
    final focus = _hasData ? _focus : <_FocusItem>[];
    final drafts = _hasData ? _drafts : <_Draft>[];
    final upcoming = _hasData
        ? ([..._upcoming.where((u) => u.when.isAfter(DateTime.now()))]..sort((a, b) => a.when.compareTo(b.when)))
        : <_UpcomingItem>[];
    focus.sort((a, b) {
      if (a.time == null && b.time == null) return 0;
      if (a.time == null) return 1;
      if (b.time == null) return -1;
      return (a.time!.hour * 60 + a.time!.minute).compareTo(b.time!.hour * 60 + b.time!.minute);
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        const _SectionTitle("Today's Focus"),
        if (focus.isEmpty)
          const _EmptyBox(icon: UlvenikIcons.calendar, message: 'Nothing scheduled for today')
        else
          _Group(children: [for (final f in focus) _buildFocusRow(f)]),

        if (drafts.isNotEmpty) ...[
          const SizedBox(height: 28),
          _SectionTitle('Continue',
              trailing: drafts.length > 3 ? _LinkButton(label: 'View All', onTap: () => _showAllDrafts(drafts)) : null),
          for (final d in drafts.take(3)) ...[
            _buildDraftCard(d),
            const SizedBox(height: 10),
          ],
        ],

        const SizedBox(height: 28),
        _SectionTitle('Upcoming',
            trailing: _LinkButton(label: 'View All', onTap: () => _push(const GlobalCalendarScreen(hasSportPack: false)))),
        if (upcoming.isEmpty)
          const _EmptyBox(icon: UlvenikIcons.calendar, message: 'No upcoming activities')
        else
          _Group(children: [for (final u in upcoming.take(3)) _buildUpcomingRow(u)]),
      ],
    );
  }

  Widget _buildFocusRow(_FocusItem f) {
    final category = switch (f.kind) {
      _FocusKind.training => 'Training',
      _FocusKind.sc => 'S&C',
      _FocusKind.health => 'Health',
    };
    final when = f.kind == _FocusKind.health
        ? (f.time == null ? 'Due Today' : 'Due ${_hm(f.time!)}')
        : (f.time == null ? 'Scheduled Today' : 'Scheduled ${_hm(f.time!)}');

    Widget trailing;
    switch (f.state) {
      case _FocusState.completed:
      case _FocusState.given:
        trailing = Row(mainAxisSize: MainAxisSize.min, children: [
          Text(f.state == _FocusState.given ? 'Given' : 'Completed',
              style: const TextStyle(color: Color(0xFF6FBF8E), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          const UlvenikIcon(UlvenikIcons.completed, size: 18, color: Color(0xFF6FBF8E)),
        ]);
      case _FocusState.notGiven:
        trailing = Text('Not Given', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13));
      case _FocusState.scheduled:
        trailing = _SmallButton(
          label: f.kind == _FocusKind.health ? 'Log' : 'Start',
          onTap: () => _actOnFocus(f),
        );
    }

    return InkWell(
      onTap: () => _actOnFocus(f),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          _IconTile(icon: _iconFor(category)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('$category · $when', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ]),
          ),
          const SizedBox(width: 8),
          trailing,
        ]),
      ),
    );
  }

  void _actOnFocus(_FocusItem f) {
    switch (f.kind) {
      case _FocusKind.health:
        _openHealthLog(f);
      case _FocusKind.training:
        if (f.state == _FocusState.completed) {
          _push(const TrainingScreen());
        } else {
          openNewTrainingSession(context, dogName: _dog.name);
        }
      case _FocusKind.sc:
        _push(RecordSessionScreen(initialActivityName: f.title));
    }
  }

  void _openHealthLog(_FocusItem f) {
    var given = f.state != _FocusState.notGiven;
    var time = TimeOfDay.now();
    final notes = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(f.title,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  [_dog.name, if (f.details != null) f.details!, if (f.time != null) 'Due ${_hm(f.time!)}'].join(' · '),
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Row(children: [
                  Expanded(child: _Toggle(label: 'Given', selected: given, onTap: () => setSheet(() => given = true))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _Toggle(label: 'Skipped / Not Given', selected: !given, onTap: () => setSheet(() => given = false))),
                ]),
                const SizedBox(height: 14),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final t = await showTimePicker(context: ctx, initialTime: time);
                    if (t != null) setSheet(() => time = t);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.backgroundObsidian, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Expanded(child: Text('Actual time', style: TextStyle(color: AppColors.secondaryTextStoneGrey))),
                      Text(_hm(time), style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notes,
                  maxLines: 3,
                  minLines: 2,
                  style: TextStyle(color: AppColors.primaryTextOffWhite),
                  decoration: InputDecoration(
                    hintText: given ? 'Notes (optional)' : 'Reason or notes (optional)',
                    filled: true,
                    fillColor: AppColors.backgroundObsidian,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => f.state = given ? _FocusState.given : _FocusState.notGiven);
                      Navigator.pop(ctx);
                      AppSnackbar.show(context,
                          message: given ? 'Logged as given' : 'Logged as not given', type: SnackbarType.success);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryForestGreen,
                      foregroundColor: AppColors.onForestGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    ).whenComplete(notes.dispose);
  }

  Widget _buildDraftCard(_Draft d) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text('${d.type} · ${_savedAgo(d.savedAt)}',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          ]),
        ),
        TextButton.icon(
          onPressed: () => _resume(d),
          icon: UlvenikIcon(UlvenikIcons.play, size: 20, color: AppColors.primaryTextOffWhite),
          label: Text('Resume', style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
          style: TextButton.styleFrom(minimumSize: const Size(48, 44)),
        ),
      ]),
    );
  }

  void _resume(_Draft d) {
    if (d.type == 'S&C') {
      _push(RecordSessionScreen(initialActivityName: d.title));
      return;
    }
    _push(TrainingSessionScreen(
      session: TrainingSession(
        id: 'draft_${d.savedAt.millisecondsSinceEpoch}',
        dogName: _dog.name,
        dogInitial: _dog.name[0],
        dogCategory: _dog.isClient ? 'Client Dogs' : 'My Dogs',
        title: d.title,
        dateLabel: _savedAgo(d.savedAt),
        date: d.savedAt,
        startTime: TimeOfDay.fromDateTime(d.savedAt),
        status: SessionStatus.draft,
        recordedSkills: const [],
        notes: '',
        dogColor: AppColors.secondarySage,
      ),
    ));
  }

  void _showAllDrafts(List<_Draft> drafts) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundObsidian,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              Text('All Drafts',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              for (final d in drafts) ...[_buildDraftCard(d), const SizedBox(height: 10)],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingRow(_UpcomingItem u) {
    return InkWell(
      onTap: () => _openUpcoming(u),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          SizedBox(
            width: 40,
            child: Column(children: [
              Text('${u.when.day}',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
              Text(_months[u.when.month - 1],
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ]),
          ),
          Container(width: 1, height: 34, color: Colors.white12, margin: const EdgeInsets.symmetric(horizontal: 12)),
          UlvenikIcon(_iconFor(u.category), size: 18, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u.title, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w500)),
              Text('${u.category} · ${_hm(TimeOfDay.fromDateTime(u.when))}',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ]),
          ),
          UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
        ]),
      ),
    );
  }

  void _openUpcoming(_UpcomingItem u) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(
                child: Text(u.title,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              PopupMenuButton<String>(
                tooltip: 'More actions',
                color: AppColors.backgroundObsidian,
                icon: UlvenikIcon(UlvenikIcons.overflowMenu, color: AppColors.primaryTextOffWhite),
                onSelected: (v) {
                  Navigator.pop(ctx);
                  switch (v) {
                    case 'edit':
                      _editUpcoming(u);
                    case 'reschedule':
                      _rescheduleUpcoming(u);
                    case 'cancel':
                      _cancelUpcoming(u);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(color: AppColors.primaryTextOffWhite))),
                  PopupMenuItem(
                      value: 'reschedule', child: Text('Reschedule', style: TextStyle(color: AppColors.primaryTextOffWhite))),
                  PopupMenuItem(value: 'cancel', child: Text('Cancel', style: TextStyle(color: Color(0xFFE08A8A)))),
                ],
              ),
            ]),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                _detailRow('Dog', _dog.name),
                _detailRow('Category', u.category),
                _detailRow('Date', _date(u.when)),
                _detailRow('Time', _hm(TimeOfDay.fromDateTime(u.when))),
                if (u.category != 'Health') ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        u.category == 'Training'
                            ? openNewTrainingSession(context, dogName: _dog.name)
                            : _push(RecordSessionScreen(initialActivityName: u.title));
                      },
                      icon: const UlvenikIcon(UlvenikIcons.recordSession, size: 20),
                      label: const Text('Start Session', style: TextStyle(fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.onForestGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(width: 90, child: Text(label, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14))),
          Expanded(child: Text(value, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14))),
        ]),
      );

  void _editUpcoming(_UpcomingItem u) {
    final ctrl = TextEditingController(text: u.title);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        title: Text('Edit', style: TextStyle(color: AppColors.primaryTextOffWhite)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: AppColors.primaryTextOffWhite),
          decoration: const InputDecoration(labelText: 'Activity name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) setState(() => u.title = ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).whenComplete(ctrl.dispose);
  }

  Future<void> _rescheduleUpcoming(_UpcomingItem u) async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: u.when.isBefore(now) ? now : u.when,
      firstDate: DateUtils.dateOnly(now),
      lastDate: DateTime(now.year + 5),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(u.when));
    if (t == null || !mounted) return;
    setState(() => u.when = DateTime(d.year, d.month, d.day, t.hour, t.minute));
    AppSnackbar.show(context, message: 'Rescheduled to ${_date(u.when)}, ${_hm(t)}', type: SnackbarType.success);
  }

  void _cancelUpcoming(_UpcomingItem u) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        title: Text('Cancel this activity?', style: TextStyle(color: AppColors.primaryTextOffWhite)),
        content: Text('"${u.title}" will be removed from your schedule. Completed records are not affected.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep')),
          TextButton(
            onPressed: () {
              setState(() => _upcoming.remove(u));
              Navigator.pop(ctx);
            },
            child: const Text('Cancel Activity', style: TextStyle(color: Color(0xFFE08A8A))),
          ),
        ],
      ),
    );
  }

  // ── Other tabs (reviewed in their own sections) ─────────────────────────
  Widget _card({required String title, required String subtitle, required String icon, required List<Widget> actions}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: Text(title,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          UlvenikIcon(icon, size: 20, color: AppColors.secondarySage),
        ]),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
        const SizedBox(height: 16),
        ...actions,
      ]),
    );
  }

  ButtonStyle get _primaryStyle => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryForestGreen,
        foregroundColor: AppColors.onForestGreen,
        minimumSize: const Size(double.infinity, 46),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  Widget _buildSkillsTile() {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _push(SkillsListScreen(dogName: _dog.name, breed: _dog.breed, hasData: _hasData)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: AppColors.cardBorder), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: UlvenikIcon(UlvenikIcons.skills, size: 20, color: AppColors.primaryTextOffWhite),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Skills & Exercises',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(_hasData ? '6 skills · 21 exercises' : 'No skills yet',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ]),
            ),
            UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
          ]),
        ),
      ),
    );
  }

  Widget _buildTrainingTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      children: [
        _buildSkillsTile(),
        const SizedBox(height: 16),
        _card(
          title: 'Training Sessions',
          subtitle: '${_hasData ? _dog.sessionCount : 0} sessions recorded',
          icon: UlvenikIcons.training,
          actions: [
            ElevatedButton.icon(
              onPressed: () => openNewTrainingSession(context, dogName: _dog.name),
              icon: const UlvenikIcon(UlvenikIcons.recordSession, size: 18),
              label: const Text('Record Session'),
              style: _primaryStyle,
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatisticsTab(hasData: _hasData, dogName: _dog.name),
      ],
    );
  }

  Widget _buildStrengthConditioningTab() => SCTab(dogName: _dog.name);

  Widget _buildHealthTab() => HealthTab(dogName: _dog.name);

  Widget _buildSportTab() => SportTab(dogName: _dog.name);

  Widget _buildMediaTab() => DogMediaLibrary(dogName: _dog.name);
}

// ── Pieces ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final VoidCallback onTap;
  const _StatCard({required this.icon, required this.value, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label: $value',
      child: Material(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              UlvenikIcon(icon, size: 22, color: AppColors.secondarySage),
              const SizedBox(height: 8),
              Text(value,
                  maxLines: 1,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const _SectionTitle(this.text, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 40,
        child: Row(children: [
          Expanded(
            child: Text(text,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          ?trailing,
        ]),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite.withValues(alpha: 0.85)),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      );
}

class _Group extends StatelessWidget {
  final List<Widget> children;
  const _Group({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(color: AppColors.cardBorder, height: 1),
            children[i],
          ],
        ]),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String icon;
  final String message;
  const _EmptyBox({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          UlvenikIcon(icon, size: 26, color: AppColors.secondarySage),
          const SizedBox(height: 10),
          Text(message, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
        ]),
      );
}

class _IconTile extends StatelessWidget {
  final String icon;
  const _IconTile({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryForestGreen.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: UlvenikIcon(icon, size: 19, color: AppColors.primaryTextOffWhite),
      );
}

class _SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SmallButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 36,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryTextOffWhite,
            side: BorderSide(color: AppColors.primaryForestGreen),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(64, 36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      );
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Toggle({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryForestGreen : AppColors.backgroundObsidian,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primaryForestGreen : Colors.white12),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              )),
        ),
      );
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;
  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => tabBar;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => oldDelegate.tabBar != tabBar;
}
