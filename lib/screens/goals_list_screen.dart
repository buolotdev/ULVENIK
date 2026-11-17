import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/animated_progress_bar.dart';
import '../theme/app_colors.dart';
import 'create_goal_screen.dart';
import 'goal_details_screen.dart';

/// Goals (Dogs & Goals handover, section 05).
///
/// Back arrow (never a hamburger), dog selector, three clickable summary
/// cards that filter the list (Active / Completed / Overdue), "View All"
/// beside the list heading to clear the filter, search, and a floating +
/// that opens Create Goal for the selected dog.
class GoalsListScreen extends StatefulWidget {
  final bool initialHasData;
  final String dogName;

  /// Preselects a status filter, e.g. Active when opened from the dog
  /// profile's Active Goals card.
  final GoalStatus? initialFilter;

  const GoalsListScreen({
    super.key,
    this.initialHasData = true,
    this.dogName = 'Murphy',
    this.initialFilter,
  });

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  late bool _hasData = widget.initialHasData;
  late String _dogName = widget.dogName;
  late GoalStatus? _filter = widget.initialFilter;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    GoalsStore.instance.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  void dispose() {
    GoalsStore.instance.removeListener(_onStoreChanged);
    _searchController.dispose();
    super.dispose();
  }

  DogInfo get _dog => SampleData.dogNamed(_dogName);
  List<GoalInfo> get _dogGoals => _hasData ? SampleData.goalsFor(_dogName) : const [];

  int _count(GoalStatus s) => _dogGoals.where((g) => g.status == s).length;

  List<GoalInfo> get _visibleGoals {
    final q = _query.trim().toLowerCase();
    return _dogGoals
        .where((g) => _filter == null || g.status == _filter)
        .where((g) => q.isEmpty || g.title.toLowerCase().contains(q) || g.category.toLowerCase().contains(q))
        .toList();
  }

  String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  String get _listHeading => switch (_filter) {
        null => 'All Goals',
        GoalStatus.active => 'Active Goals',
        GoalStatus.completed => 'Completed Goals',
        GoalStatus.overdue => 'Overdue Goals',
      };

  void _openCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateGoalScreen(initialDogName: _dogName, initialIsClientDog: _dog.isClient),
      ),
    );
  }

  void _openGoal(GoalInfo g) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => GoalDetailsScreen.fromGoal(g)));
  }

  void _pickDog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DogPickerSheet(
        selected: _dogName,
        onSelected: (d) {
          Navigator.pop(ctx);
          setState(() {
            _dogName = d.name;
            _filter = widget.initialFilter;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: UlvenikIcon(UlvenikIcons.back, size: 22, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: GestureDetector(
          onDoubleTap: () => setState(() => _hasData = !_hasData), // demo toggle
          child: Text('Goals',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120), // room for the + button
        children: [
          _DogSelectorCard(dog: _dog, onTap: _pickDog),
          const SizedBox(height: 16),
          if (_dogGoals.isEmpty) ..._buildEmpty() else ..._buildPopulated(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Goal',
        backgroundColor: AppColors.primaryForestGreen,
        onPressed: _openCreate,
        child: UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryTextOffWhite),
      ),
    );
  }

  List<Widget> _buildPopulated() {
    final goals = _visibleGoals;
    return [
      IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final s in const [GoalStatus.active, GoalStatus.completed, GoalStatus.overdue]) ...[
          Expanded(
            child: _SummaryCard(
              count: _count(s),
              label: switch (s) {
                GoalStatus.active => 'Active Goals',
                GoalStatus.completed => 'Completed',
                GoalStatus.overdue => 'Overdue',
              },
              selected: _filter == s,
              onTap: () => setState(() => _filter = _filter == s ? null : s),
            ),
          ),
          if (s != GoalStatus.overdue) const SizedBox(width: 8),
        ],
      ])),
      const SizedBox(height: 20),
      SizedBox(
        height: 46,
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search goals',
            hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
            filled: true,
            fillColor: AppColors.cardsCarbon,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: UlvenikIcon(UlvenikIcons.search, color: AppColors.secondaryTextStoneGrey, size: 20),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primaryForestGreen)),
          ),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 40,
        child: Row(children: [
          Expanded(
            child: Text(_listHeading,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          if (_filter != null)
            TextButton(
              onPressed: () => setState(() => _filter = null),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryTextOffWhite.withValues(alpha: 0.85)),
              child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
        ]),
      ),
      const SizedBox(height: 8),
      if (goals.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text('No goals match.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
        )
      else
        for (final g in goals) ...[
          _GoalCard(goal: g, dateLabel: g.dueDate == null ? null : _date(g.dueDate!), onTap: () => _openGoal(g)),
          const SizedBox(height: 10),
        ],
    ];
  }

  List<Widget> _buildEmpty() {
    return [
      const SizedBox(height: 40),
      Center(
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardsCarbon,
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: UlvenikIcon(UlvenikIcons.goals, color: AppColors.secondarySage, size: 32),
        ),
      ),
      const SizedBox(height: 20),
      Text('Set your first goal',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      Text(
        'Create goals for training, S&C and health, and track your progress over time.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4),
      ),
      const SizedBox(height: 28),
      SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: _openCreate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryForestGreen,
            foregroundColor: AppColors.onForestGreen,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Create Goal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
    ];
  }
}

// ── Shared dog selector pieces (also used by Create Goal) ─────────────────

class DogSquarePhoto extends StatelessWidget {
  final DogInfo dog;
  final double size;
  const DogSquarePhoto({super.key, required this.dog, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: const Color(0xFF26302C),
      alignment: Alignment.center,
      child: UlvenikIcon(UlvenikIcons.dogs, size: size * 0.45, color: AppColors.secondarySage),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: SizedBox(
        width: size,
        height: size,
        child: dog.photoProvider == null
            ? placeholder
            : Image(image: dog.photoProvider!, fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder),
      ),
    );
  }
}

class _DogSelectorCard extends StatelessWidget {
  final DogInfo dog;
  final VoidCallback onTap;
  const _DogSelectorCard({required this.dog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(children: [
            DogSquarePhoto(dog: dog),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(dog.name,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                Text(dog.breed, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ]),
            ),
            Text('Switch Dog',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 20),
          ]),
        ),
      ),
    );
  }
}

/// Bottom sheet listing My Dogs and Client Dogs with square photos.
class DogPickerSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<DogInfo> onSelected;
  final bool hasTrainerPack;
  const DogPickerSheet({super.key, required this.selected, required this.onSelected, this.hasTrainerPack = true});

  @override
  Widget build(BuildContext context) {
    Widget tile(DogInfo d) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: DogSquarePhoto(dog: d, size: 40),
          title: Text(d.name, style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
          subtitle: Text('${d.breed} · ${d.isClient ? 'Client Dog' : 'My Dog'}',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          trailing: d.name == selected ? Icon(Icons.check, color: AppColors.primaryForestGreen) : null,
          onTap: () => onSelected(d),
        );
    Widget label(String t) => Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(t, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w600)),
        );
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Select Dog',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            label('My Dogs'),
            for (final d in SampleData.myDogs) tile(d),
            if (hasTrainerPack && SampleData.clientDogs.isNotEmpty) ...[
              label('Client Dogs'),
              for (final d in SampleData.clientDogs) tile(d),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int count;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SummaryCard({required this.count, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.primaryForestGreen.withValues(alpha: 0.22) : AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? AppColors.primaryForestGreen : AppColors.cardBorder, width: selected ? 1.5 : 1),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('$count',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
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

class _GoalCard extends StatelessWidget {
  final GoalInfo goal;
  final String? dateLabel;
  final VoidCallback onTap;
  const _GoalCard({required this.goal, required this.onTap, this.dateLabel});

  String _fmt(num v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final overdue = goal.status == GoalStatus.overdue;
    final completed = goal.status == GoalStatus.completed;
    final meta = [
      goal.category,
      if (completed) 'Completed' else if (overdue) 'Overdue' else if (dateLabel != null) 'Due $dateLabel',
    ].join(' · ');
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: overdue ? const Color(0x668B3A3A) : AppColors.cardBorder),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(goal.title,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(meta,
                      style: TextStyle(
                        color: overdue ? const Color(0xFFE08A8A) : AppColors.secondaryTextStoneGrey,
                        fontSize: 12.5,
                      )),
                ]),
              ),
              if (completed)
                const UlvenikIcon(UlvenikIcons.completed, size: 20, color: Color(0xFF6FBF8E))
              else
                UlvenikIcon(UlvenikIcons.details, size: 18, color: AppColors.secondaryTextStoneGrey),
            ]),
            if (goal.isMeasurable) ...[
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: Text('${_fmt(goal.current)} / ${_fmt(goal.targetValue!)} ${goal.targetUnit}',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                ),
                Text('${(goal.progress! * 100).round()}%',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ]),
              const SizedBox(height: 8),
              AnimatedProgressBar(
                value: goal.progress!,
                height: 5,
                backgroundColor: const Color(0xFF2C302E),
                color: AppColors.primaryForestGreen,
              ),
            ] else if (!completed) ...[
              const SizedBox(height: 10),
              Text('Open-ended goal · no numerical target',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ],
          ]),
        ),
      ),
    );
  }
}
