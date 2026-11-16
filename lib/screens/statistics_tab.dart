import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import 'training_screen.dart' show openNewTrainingSession;

/// A training session record used to calculate the analytics below.
/// Demo data, generated per dog; replace with saved sessions.
class _Sess {
  final int id;
  final DateTime at;
  final int? minutes; // only when the user recorded a duration
  final List<String> skills;
  final List<String> exercises;
  final String? location; // optional, user-entered
  const _Sess(this.id, this.at, this.minutes, this.skills, this.exercises, this.location);
}

class _Bucket {
  final String label;
  final String fullLabel;
  final DateTime start;
  final DateTime end; // exclusive
  const _Bucket(this.label, this.fullLabel, this.start, this.end);
}

/// Dog › Training › analytics (Training Remaining Screens v34).
///
/// Overview | Skills | Exercises | Locations share one layout: four
/// statistics, a Training Activity line chart, a single-month heatmap and
/// Training Patterns. Every figure is calculated from the selected dog's
/// sessions and the chosen period; a session counts once, and skills /
/// exercises / locations count once per grouping. The heatmap has its own
/// month arrows and ignores the period.
class StatisticsTab extends StatefulWidget {
  final bool hasData;
  final String dogName;
  const StatisticsTab({super.key, required this.hasData, this.dogName = 'Arlo'});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  static const _categories = ['Overview', 'Skills', 'Exercises', 'Locations'];
  static const _periods = ['Lifetime', 'This Year', 'Last 6 Months', 'This Month'];
  static const _monthShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _monthLong = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _dayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _dayLong = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  static const _green = AppColors.primaryForestGreen;
  static const _mint = Color(0xFF95D3BB);
  static const _charcoal = Color(0xFF2A2D2C); // zero: no green tint

  String _category = 'Overview';
  String _period = 'This Year';
  int? _selectedBucket;
  int? _selectedWeekday;
  DateTime? _selectedDay;
  late DateTime _heatMonth;
  late List<_Sess> _all;

  @override
  void initState() {
    super.initState();
    _all = _generate(widget.dogName);
    final now = DateTime.now();
    _heatMonth = DateTime(now.year, now.month);
  }

  @override
  void didUpdateWidget(StatisticsTab old) {
    super.didUpdateWidget(old);
    if (old.dogName != widget.dogName) _all = _generate(widget.dogName);
  }

  // ── Demo data ─────────────────────────────────────────────────────────────
  static List<_Sess> _generate(String dog) {
    var x = dog.codeUnits.fold<int>(7, (a, b) => a * 31 + b) & 0x7fffffff;
    if (x == 0) x = 1;
    int next(int n) {
      x = (x * 1103515245 + 12345) & 0x7fffffff;
      return (x >> 8) % n;
    }

    const skills = <String, List<String>>{
      'Recall': ['Emergency Recall', 'Recall Through Distractions', 'Whistle Recall'],
      'Heelwork': ['Focused Heelwork', 'Left Turns', 'Halt to Sit'],
      'Retrieve': ['Dumbbell Retrieve', 'Clean Pick-up'],
      'Tracking': ['Cold Start Track', 'Article Indication'],
      'Stay': ['Two-minute Sit Stay', 'Out-of-sight Down'],
      'Impulse Control': ['Wait at Start Line', 'Leave It on Recall Path'],
      'Position Changes': ['Sit to Down', 'Down to Stand'],
      'Hold & Delivery': ['Calm Hold', 'Front Delivery'],
      'Distance Control': ['Sit-Down-Stand at 4m', 'Distance Stand to Down'],
      'Protection': ['Blind Search', 'Hold and Bark'],
    };
    const locations = ['Woodland', 'Training Field', 'Park', 'Training Centre'];
    final names = skills.keys.toList();
    final now = DateTime.now();
    final out = <_Sess>[];
    var id = 0;
    for (var d = 0; d < 430; d++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      if (next(100) >= 30) continue;
      final n = next(100) < 20 ? 2 : 1;
      for (var k = 0; k < n; k++) {
        final at = DateTime(day.year, day.month, day.day, 7 + next(12), next(4) * 15);
        if (at.isAfter(now)) continue;
        final chosen = <String>{};
        final count = 1 + next(2);
        while (chosen.length < count) {
          chosen.add(names[next(names.length)]);
        }
        final ex = <String>{};
        for (final s in chosen) {
          final list = skills[s]!;
          ex.add(list[next(list.length)]);
          if (next(100) < 40) ex.add(list[next(list.length)]);
        }
        out.add(_Sess(
          id++,
          at,
          next(100) < 12 ? null : 15 + next(8) * 5,
          chosen.toList(),
          ex.toList(),
          next(100) < 20 ? null : locations[next(locations.length)],
        ));
      }
    }
    return out;
  }

  // ── Calculations ──────────────────────────────────────────────────────────
  DateTime get _now => DateTime.now();

  DateTime get _periodStart {
    final n = _now;
    switch (_period) {
      case 'This Year':
        return DateTime(n.year);
      case 'Last 6 Months':
        return DateTime(n.year, n.month - 5);
      case 'This Month':
        return DateTime(n.year, n.month);
      default:
        if (_all.isEmpty) return DateTime(n.year, n.month);
        final first = _all.map((s) => s.at).reduce((a, b) => a.isBefore(b) ? a : b);
        return DateTime(first.year, first.month);
    }
  }

  List<_Sess> get _inPeriod {
    final start = _periodStart;
    return _all.where((s) => !s.at.isBefore(start) && !s.at.isAfter(_now)).toList();
  }

  Set<String> _items(_Sess s) => switch (_category) {
        'Skills' => s.skills.toSet(),
        'Exercises' => s.exercises.toSet(),
        'Locations' => {if (s.location != null) s.location!},
        _ => {'#${s.id}'}, // Overview counts each session once
      };

  int _distinct(Iterable<_Sess> sessions) => sessions.expand(_items).toSet().length;

  String _noun(int n) {
    final base = switch (_category) {
      'Skills' => 'skill',
      'Exercises' => 'exercise',
      'Locations' => 'location',
      _ => 'session',
    };
    return n == 1 ? base : '${base}s';
  }

  String _fmtMinutes(num m) {
    final mins = m.round();
    if (mins < 60) return '${mins}m';
    final h = mins ~/ 60;
    final r = mins % 60;
    return r == 0 ? '${h}h' : '${h}h ${r}m';
  }

  List<_Bucket> get _buckets {
    final n = _now;
    if (_period == 'This Month') {
      return [
        for (var d = 1; d <= n.day; d++)
          _Bucket('$d', '$d ${_monthLong[n.month - 1]}', DateTime(n.year, n.month, d), DateTime(n.year, n.month, d + 1)),
      ];
    }
    final start = _periodStart;
    final out = <_Bucket>[];
    var cur = DateTime(start.year, start.month);
    final spansYears = start.year != n.year;
    while (!cur.isAfter(DateTime(n.year, n.month))) {
      final short = _monthShort[cur.month - 1];
      out.add(_Bucket(
        spansYears && cur.month == 1 || (spansYears && out.isEmpty) ? "$short '${cur.year % 100}" : short,
        '${_monthLong[cur.month - 1]} ${cur.year}',
        cur,
        DateTime(cur.year, cur.month + 1),
      ));
      cur = DateTime(cur.year, cur.month + 1);
    }
    return out;
  }

  /// Items-per-session ranking: how many sessions include each item.
  List<MapEntry<String, int>> _ranking(List<_Sess> sessions) {
    final counts = <String, int>{};
    for (final s in sessions) {
      for (final i in _items(s)) {
        counts[i] = (counts[i] ?? 0) + 1;
      }
    }
    final list = counts.entries.toList()
      ..sort((a, b) => b.value != a.value ? b.value.compareTo(a.value) : a.key.compareTo(b.key));
    return list;
  }

  List<int> _weekdayCounts(List<_Sess> sessions) {
    return List.generate(7, (i) => _distinct(sessions.where((s) => s.at.weekday == i + 1)));
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!widget.hasData) return _buildEmptyState();
    final sessions = _inPeriod;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilters(),
        const SizedBox(height: 20),
        if (sessions.isEmpty)
          _card(
            Column(children: [
              const UlvenikIcon(UlvenikIcons.progress, size: 28, color: AppColors.secondarySage),
              const SizedBox(height: 12),
              const Text('No Statistics Yet',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('No sessions recorded for ${_period.toLowerCase()}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
            ]),
          )
        else ...[
          _buildStatCards(sessions),
          const SizedBox(height: 16),
          _buildActivityChart(sessions),
          const SizedBox(height: 16),
          _buildHeatmap(),
          const SizedBox(height: 16),
          _buildPatterns(sessions),
          if (_category != 'Overview') ...[
            const SizedBox(height: 16),
            _buildRankingChart(sessions),
          ],
        ],
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _card(Widget child) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );

  Widget _title(String t, {String? sub, Widget? trailing}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              if (sub != null) ...[
                const SizedBox(height: 3),
                Text(sub, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
              ],
            ]),
          ),
          ?trailing,
        ]),
      );

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(children: [
        const UlvenikIcon(UlvenikIcons.progress, color: _mint, size: 32),
        const SizedBox(height: 16),
        const Text('No Statistics Yet',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text('Record your first training session to start building ${widget.dogName}’s statistics.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.5)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => openNewTrainingSession(context, dogName: widget.dogName),
          icon: const UlvenikIcon(UlvenikIcons.recordSession, size: 18),
          label: const Text('Record Session'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            foregroundColor: AppColors.primaryTextOffWhite,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  // ── Filters ───────────────────────────────────────────────────────────────
  Widget _buildFilters() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Scrolls sideways on narrow screens instead of squeezing the labels.
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            for (final c in _categories) _pill(c),
          ]),
        ),
      ),
      const SizedBox(height: 10),
      Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _openPeriodSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const UlvenikIcon(UlvenikIcons.calendar, size: 16, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 8),
              Text(_period, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5)),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more, color: AppColors.secondaryTextStoneGrey, size: 18),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _pill(String label) {
    final selected = _category == label;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() {
          _category = label;
          _selectedBucket = null;
          _selectedWeekday = null;
          _selectedDay = null;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF323533) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              style: TextStyle(
                color: selected ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }

  void _openPeriodSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Select Time Period',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final p in _periods)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(p, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
                trailing: _period == p ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                onTap: () {
                  setState(() {
                    _period = p;
                    _selectedBucket = null;
                    _selectedWeekday = null;
                  });
                  Navigator.pop(ctx);
                },
              ),
          ]),
        ),
      ),
    );
  }

  // ── Statistics ────────────────────────────────────────────────────────────
  Widget _buildStatCards(List<_Sess> sessions) {
    final List<(String, String)> stats;
    if (_category == 'Overview') {
      final timed = sessions.where((s) => s.minutes != null).toList();
      final avg = timed.isEmpty ? '—' : _fmtMinutes(timed.fold<int>(0, (a, s) => a + s.minutes!) / timed.length);
      final start = _periodStart;
      final days = _now.difference(start).inDays + 1;
      final perWeek = sessions.length / (days / 7 < 1 ? 1 : days / 7);
      final wd = _weekdayCounts(sessions);
      final best = wd.reduce((a, b) => a > b ? a : b);
      stats = [
        ('Avg. Duration', avg),
        ('Sessions / Week', perWeek.toStringAsFixed(1)),
        ('Total Sessions', '${sessions.length}'),
        ('Most Active Day', best == 0 ? '—' : _dayShort[wd.indexOf(best)]),
      ];
    } else {
      final rank = _ranking(sessions);
      final top = rank.isEmpty ? '—' : rank.first.key;
      final label = switch (_category) {
        'Skills' => ('Skills Trained', 'Most Trained Skill'),
        'Exercises' => ('Exercises Trained', 'Most Trained Exercise'),
        _ => ('Locations Trained', 'Most Used Location'),
      };
      stats = [(label.$1, '${rank.length}'), (label.$2, top)];
    }
    return _card(Wrap(spacing: 0, runSpacing: 16, children: [
      for (final s in stats)
        FractionallySizedBox(
          widthFactor: 0.5,
          child: LayoutBuilder(builder: (_, _) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.$1, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              const SizedBox(height: 4),
              Text(s.$2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: s.$2.length > 8 ? 17 : 24,
                    fontWeight: FontWeight.w600,
                  )),
            ]),
          )),
        ),
    ]));
  }

  // ── Training Activity (line chart) ────────────────────────────────────────
  Widget _buildActivityChart(List<_Sess> sessions) {
    final buckets = _buckets;
    final values = [
      for (final b in buckets) _distinct(sessions.where((s) => !s.at.isBefore(b.start) && s.at.isBefore(b.end))),
    ];
    final maxV = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
    final sel = _selectedBucket != null && _selectedBucket! < buckets.length ? _selectedBucket! : null;
    final sub = switch (_category) {
      'Skills' => 'Distinct skills you trained each month.',
      'Exercises' => 'Distinct exercises you trained each month.',
      'Locations' => 'Distinct locations you trained at each month.',
      _ => "Track how frequently you've trained over time.",
    };
    final interval = (buckets.length / 6).ceil().clamp(1, 99).toDouble();

    return _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title('Training Activity', sub: sub),
      Text(
        sel == null ? 'Tap a point for details' : '${buckets[sel].fullLabel} · ${values[sel]} ${_noun(values[sel])}',
        style: const TextStyle(color: _mint, fontSize: 12.5, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (buckets.length - 1).clamp(1, 9999).toDouble(),
            minY: 0,
            maxY: (maxV + 1).toDouble(),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: interval,
                  getTitlesWidget: (v, meta) {
                    final i = v.toInt();
                    if (i < 0 || i >= buckets.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(buckets[i].label,
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchCallback: (event, resp) {
                final spots = resp?.lineBarSpots;
                if (spots != null && spots.isNotEmpty && event.isInterestedForInteractions) {
                  setState(() => _selectedBucket = spots.first.x.toInt());
                }
              },
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem('${s.y.toInt()}',
                        const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i].toDouble())],
                isCurved: values.length > 2,
                curveSmoothness: 0.2,
                preventCurveOverShooting: true,
                color: _green,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  checkToShowDot: (spot, _) => values.length <= 14 || spot.x.toInt() == sel,
                  getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                    radius: spot.x.toInt() == sel ? 5 : 3,
                    color: spot.x.toInt() == sel ? _mint : AppColors.backgroundObsidian,
                    strokeWidth: 2,
                    strokeColor: _green,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [_green.withValues(alpha: 0.3), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }

  // ── Heatmap (one month, own arrows) ───────────────────────────────────────
  Color _heatColor(int n) {
    if (n <= 0) return _charcoal;
    if (n == 1) return _green.withValues(alpha: 0.45);
    if (n == 2) return _green.withValues(alpha: 0.8);
    return const Color(0xFF4E9A82);
  }

  Widget _buildHeatmap() {
    final first = _heatMonth;
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1; // Monday-first grid
    final rows = ((lead + daysInMonth) / 7).ceil();
    final now = _now;
    final isCurrent = first.year == now.year && first.month == now.month;
    final unitCaps = switch (_category) {
      'Skills' => 'SKILLS PER DAY',
      'Exercises' => 'EXERCISES PER DAY',
      'Locations' => 'LOCATIONS PER DAY',
      _ => 'SESSIONS PER DAY',
    };

    int countOn(DateTime day) => _distinct(_all.where((s) =>
        s.at.year == day.year && s.at.month == day.month && s.at.day == day.day && !s.at.isAfter(now)));

    final selected = _selectedDay != null && _selectedDay!.year == first.year && _selectedDay!.month == first.month
        ? _selectedDay
        : null;

    return _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title('Training Activity Heatmap', sub: 'See your training consistency throughout the month.'),
      Row(children: [
        IconButton(
          tooltip: 'Previous month',
          onPressed: () => setState(() {
            _heatMonth = DateTime(first.year, first.month - 1);
            _selectedDay = null;
          }),
          icon: const Icon(Icons.chevron_left, color: AppColors.primaryTextOffWhite),
        ),
        Expanded(
          child: Text('${_monthLong[first.month - 1]} ${first.year}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
        ),
        IconButton(
          tooltip: 'Next month',
          onPressed: isCurrent
              ? null
              : () => setState(() {
                    _heatMonth = DateTime(first.year, first.month + 1);
                    _selectedDay = null;
                  }),
          icon: Icon(Icons.chevron_right,
              color: isCurrent ? Colors.white24 : AppColors.primaryTextOffWhite),
        ),
      ]),
      const SizedBox(height: 6),
      Row(children: [
        for (final d in _dayShort)
          Expanded(
            child: Center(
              child: Text(d.substring(0, 1),
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
      ]),
      const SizedBox(height: 6),
      for (var r = 0; r < rows; r++)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(children: [
            for (var c = 0; c < 7; c++)
              Expanded(
                child: Builder(builder: (_) {
                  final dayNum = r * 7 + c - lead + 1;
                  if (dayNum < 1 || dayNum > daysInMonth) return const SizedBox(height: 38);
                  final day = DateTime(first.year, first.month, dayNum);
                  final future = day.isAfter(DateTime(now.year, now.month, now.day));
                  final n = future ? 0 : countOn(day);
                  final isSel = selected != null && selected.day == dayNum;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: future ? null : () => setState(() => _selectedDay = day),
                      child: Container(
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _heatColor(n),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSel ? _mint : Colors.transparent, width: 1.5),
                        ),
                        child: Text('$dayNum',
                            style: TextStyle(
                              color: future ? Colors.white30 : AppColors.primaryTextOffWhite,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  );
                }),
              ),
          ]),
        ),
      const SizedBox(height: 6),
      Text(
        selected == null
            ? 'Tap a day for details'
            : '${selected.day} ${_monthLong[selected.month - 1]} ${selected.year} · ${countOn(selected)} ${_noun(countOn(selected))}',
        style: const TextStyle(color: _mint, fontSize: 12.5, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 12),
      Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 8, children: [
        Text(unitCaps,
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
        Row(mainAxisSize: MainAxisSize.min, children: [
          for (final k in const [(0, '0'), (1, '1'), (2, '2'), (3, '3+')]) ...[
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: _heatColor(k.$1), borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: 4),
            Text(k.$2, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11.5)),
            const SizedBox(width: 10),
          ],
        ]),
      ]),
    ]));
  }

  // ── Training Patterns (weekday bars) ──────────────────────────────────────
  Widget _buildPatterns(List<_Sess> sessions) {
    final counts = _weekdayCounts(sessions);
    final best = counts.reduce((a, b) => a > b ? a : b);
    final bestIdx = best == 0 ? -1 : counts.indexOf(best);
    final sel = _selectedWeekday;

    return _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title(
        'Training Patterns',
        trailing: Text(
          bestIdx < 0 ? 'Most Active: —' : 'Most Active: ${_dayLong[bestIdx]}',
          style: const TextStyle(color: _mint, fontSize: 12.5, fontWeight: FontWeight.w500),
        ),
      ),
      SizedBox(
        height: 180,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Semantics(
                button: true,
                label: '${_dayLong[i]}: ${counts[i]} ${_noun(counts[i])}',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedWeekday = i),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text('${counts[i]}',
                        style: TextStyle(
                          color: i == bestIdx || i == sel ? _mint : AppColors.secondaryTextStoneGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 6),
                    Expanded(
                      child: FractionallySizedBox(
                        heightFactor: best == 0 ? 0.02 : (counts[i] / best).clamp(0.02, 1.0),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: i == bestIdx || i == sel ? _green : const Color(0xFF323533),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            border: i == sel ? Border.all(color: _mint.withValues(alpha: 0.6)) : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_dayShort[i],
                        style: TextStyle(
                          color: i == bestIdx || i == sel ? _mint : AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
                ),
              ),
            ),
        ]),
      ),
      const SizedBox(height: 10),
      Text(
        sel == null ? 'Tap a bar for details' : '${_dayLong[sel]} · ${counts[sel]} ${_noun(counts[sel])}',
        style: const TextStyle(color: _mint, fontSize: 12.5, fontWeight: FontWeight.w500),
      ),
    ]));
  }

  // ── Most Trained Skills / Exercises, Most Used Locations ─────────────────
  Widget _buildRankingChart(List<_Sess> sessions) {
    final rank = _ranking(sessions).take(5).toList();
    final title = switch (_category) {
      'Skills' => 'Most Trained Skills',
      'Exercises' => 'Most Trained Exercises',
      _ => 'Most Used Locations',
    };
    final top = rank.isEmpty ? 1 : rank.first.value;
    return _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title(title),
      if (rank.isEmpty)
        const Text('Nothing recorded for this period.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13))
      else
        for (final e in rank)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(e.key,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w500)),
                ),
                Text('${e.value} ${e.value == 1 ? 'session' : 'sessions'}',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: e.value / top,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF323533),
                  color: _green,
                ),
              ),
            ]),
          ),
    ]));
  }
}
