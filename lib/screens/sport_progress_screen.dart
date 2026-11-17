import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/sport_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import '../widgets/period_sheet.dart';
import '../widgets/ulvenik_icon.dart';
import 'sport_items_screens.dart';
import 'sport_session_screens.dart';

Color get _green => AppColors.primaryForestGreen;
const _charcoal = Color(0xFF2A2D2C);
const _dayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _dayLong = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _monthShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _monthLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Sport Progress for one sport: only sessions involving that sport, counted
/// once each, plotted on their real session dates. Nothing is invented.
class SportProgressScreen extends StatefulWidget {
  final String dogName;
  final String sportId;
  const SportProgressScreen({super.key, required this.dogName, required this.sportId});

  @override
  State<SportProgressScreen> createState() => _SportProgressScreenState();
}

class _SportProgressScreenState extends State<SportProgressScreen> {
  final _store = SportStore.instance;
  String _period = 'This Year';
  late DateTime _heatMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;
  int? _selectedWeekday;
  int? _selectedBucket;

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<SportSession> get _all => _store.sessions(widget.dogName, sportId: widget.sportId);

  List<SportSession> get _inPeriod {
    final from = periodStart(_period);
    return _all.where((s) => from == null || !s.at.isBefore(from)).toList();
  }

  Widget _stat(String label, String value) => Expanded(
        child: HealthCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 8),
            Text(value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
          ]),
        ),
      );

  Widget _card(String title, Widget child, {Widget? trailing, String? subtitle}) => Padding(
        padding: const EdgeInsets.only(top: 18),
        child: HealthCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(title,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              ?trailing,
            ]),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ),
            const SizedBox(height: 14),
            child,
          ]),
        ),
      );

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(child: Text(text, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5))),
      );

  Color _level(int n) => n == 0
      ? _charcoal
      : n == 1
          ? const Color(0xFF3A5C4E)
          : n == 2
              ? const Color(0xFF3F7A62)
              : const Color(0xFF5FB88C);

  List<(String, String, int)> _buckets(List<SportSession> sessions) {
    final now = DateTime.now();
    final out = <(String, String, int)>[];
    if (_period == 'This Month') {
      for (var d = 1; d <= now.day; d++) {
        final n = sessions.where((s) => s.at.year == now.year && s.at.month == now.month && s.at.day == d).length;
        out.add(('$d', '${_monthShort[now.month - 1]} $d', n));
      }
      return out;
    }
    var start = periodStart(_period) ?? (_all.isEmpty ? DateTime(now.year, now.month) : _all.last.at);
    start = DateTime(start.year, start.month);
    for (var m = start; !m.isAfter(DateTime(now.year, now.month)); m = DateTime(m.year, m.month + 1)) {
      final n = sessions.where((s) => s.at.year == m.year && s.at.month == m.month).length;
      out.add((_monthShort[m.month - 1], '${_monthLong[m.month - 1]} ${m.year}', n));
    }
    return out;
  }

  Widget _line() {
    final b = _buckets(_inPeriod);
    final has = b.any((e) => e.$3 > 0);
    final maxV = b.fold<int>(0, (m, e) => e.$3 > m ? e.$3 : m);
    final sel = _selectedBucket != null && _selectedBucket! < b.length ? b[_selectedBucket!] : null;
    return _card(
      'Training Activity',
      has
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 160,
                child: LineChart(LineChartData(
                  minY: 0,
                  maxY: (maxV + 1).toDouble(),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (_) => FlLine(color: AppColors.cardBorder, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: maxV > 6 ? (maxV / 4).ceilToDouble() : 1,
                        getTitlesWidget: (v, m) => v == v.roundToDouble()
                            ? Text('${v.round()}',
                                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10))
                            : const SizedBox.shrink(),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: b.length > 8 ? (b.length / 6).ceilToDouble() : 1,
                        getTitlesWidget: (v, m) {
                          final i = v.round();
                          if (i < 0 || i >= b.length || v != v.roundToDouble()) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(b[i].$1,
                                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchCallback: (event, resp) {
                      final spots = resp?.lineBarSpots;
                      if (event is FlTapUpEvent && spots != null && spots.isNotEmpty) {
                        setState(() => _selectedBucket = spots.first.spotIndex);
                      }
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => AppColors.backgroundObsidian,
                      getTooltipItems: (spots) => [
                        for (final s in spots)
                          LineTooltipItem('${b[s.spotIndex].$2}\n${s.y.round()} sessions',
                              TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [for (var i = 0; i < b.length; i++) FlSpot(i.toDouble(), b[i].$3.toDouble())],
                      color: _green,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        getDotPainter: (a, p, bar, i) => FlDotCirclePainter(
                            radius: i == _selectedBucket ? 5 : 3.5, color: AppColors.secondarySage, strokeWidth: 0),
                      ),
                      belowBarData: BarAreaData(show: true, color: _green.withValues(alpha: 0.12)),
                    ),
                  ],
                )),
              ),
              if (sel != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('${sel.$2}: ${sel.$3} sessions',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                ),
            ])
          : _empty('No sessions in this period.'),
      subtitle: 'Track how frequently you’ve trained over time.',
    );
  }

  Widget _heatmap() {
    final first = _heatMonth;
    final days = DateTime(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1;
    int on(int d) =>
        _all.where((s) => s.at.year == first.year && s.at.month == first.month && s.at.day == d).length;
    final sd = _selectedDay;
    return _card(
      'Training Calendar',
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          IconButton(
            tooltip: 'Previous month',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.chevron_left, color: AppColors.secondaryTextStoneGrey),
            onPressed: () => setState(() {
              _heatMonth = DateTime(first.year, first.month - 1);
              _selectedDay = null;
            }),
          ),
          Expanded(
            child: Text('${_monthLong[first.month - 1]} ${first.year}',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          IconButton(
            tooltip: 'Next month',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
            onPressed: () => setState(() {
              _heatMonth = DateTime(first.year, first.month + 1);
              _selectedDay = null;
            }),
          ),
        ]),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          children: [
            for (final d in _dayShort)
              Center(child: Text(d.substring(0, 1), style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11))),
            for (var i = 0; i < lead; i++) const SizedBox.shrink(),
            for (var d = 1; d <= days; d++)
              GestureDetector(
                onTap: () => setState(() => _selectedDay = DateTime(first.year, first.month, d)),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _level(on(d)),
                    borderRadius: BorderRadius.circular(6),
                    border: sd == DateTime(first.year, first.month, d)
                        ? Border.all(color: AppColors.primaryTextOffWhite, width: 1.5)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text('$d', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 11.5)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (sd != null && sd.year == first.year && sd.month == first.month)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('${fmtDate(sd)}: ${on(sd.day)} sessions',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
          ),
        Wrap(spacing: 12, runSpacing: 6, children: [
          for (final e in [('0', 0), ('1', 1), ('2', 2), ('3+', 3)])
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: _level(e.$2), borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 5),
              Text(e.$1, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ]),
        ]),
      ]),
    );
  }

  Widget _patterns() {
    final sessions = _inPeriod;
    final counts = [for (var w = 1; w <= 7; w++) sessions.where((s) => s.at.weekday == w).length];
    final maxV = counts.fold<int>(0, (m, e) => e > m ? e : m);
    // ties: name every weekday sharing the highest count
    final top = maxV == 0 ? <String>[] : [for (var i = 0; i < 7; i++) if (counts[i] == maxV) _dayLong[i]];
    return _card(
      'Training Patterns',
      maxV == 0
          ? _empty('No sessions in this period.')
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 150,
                child: BarChart(BarChartData(
                  maxY: (maxV + 1).toDouble(),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (v, m) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(_dayShort[v.round()],
                              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10.5)),
                        ),
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchCallback: (event, resp) {
                      if (event is FlTapUpEvent && resp?.spot != null) {
                        setState(() => _selectedWeekday = resp!.spot!.touchedBarGroupIndex);
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.backgroundObsidian,
                      getTooltipItem: (g, gi, r, ri) => BarTooltipItem('${_dayLong[gi]}\n${counts[gi]} sessions',
                          TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < 7; i++)
                      BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: counts[i].toDouble(),
                          width: 20,
                          borderRadius: BorderRadius.circular(5),
                          color: counts[i] == maxV ? const Color(0xFF5FB88C) : _green,
                        ),
                      ]),
                  ],
                )),
              ),
              if (_selectedWeekday != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('${_dayLong[_selectedWeekday!]}: ${counts[_selectedWeekday!]} sessions',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                ),
            ]),
      trailing: top.isEmpty
          ? null
          : Flexible(
              child: Text('Most Active: ${top.join(', ')}',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ),
    );
  }

  Widget _skillsAndExercises() {
    final s = _inPeriod;
    // count each item once per saved session
    final perItem = <String, ({String name, SportItemKind? kind, int sessions})>{};
    for (final sess in s) {
      for (final e in sess.entries.where((e) => e.sportId == widget.sportId)) {
        for (final id in e.itemIds.toSet()) {
          final item = _store.item(widget.dogName, id);
          final idx = e.itemIds.indexOf(id);
          perItem[id] = (
            name: item?.name ?? (idx < e.itemNames.length ? e.itemNames[idx] : ''),
            kind: item?.kind,
            sessions: (perItem[id]?.sessions ?? 0) + 1,
          );
        }
      }
    }
    final skills = perItem.values.where((e) => e.kind == SportItemKind.skill).length;
    final exercises = perItem.values.where((e) => e.kind == SportItemKind.exercise).length;
    final ranked = perItem.entries.toList()..sort((a, b) => b.value.sessions.compareTo(a.value.sessions));
    final maxS = ranked.isEmpty ? 1 : ranked.first.value.sessions;
    return Column(children: [
      const SizedBox(height: 0),
      Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _stat('Skills Trained', '$skills'),
          const SizedBox(width: 10),
          _stat('Exercises Completed', '$exercises'),
        ]),
      ),
      _card(
        'Most Trained Skills & Exercises',
        ranked.isEmpty
            ? _empty('No skills or exercises in this period.')
            : Column(children: [
                for (final r in ranked.take(8))
                  InkWell(
                    onTap: _store.item(widget.dogName, r.key) == null
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SportItemDetailsScreen(dogName: widget.dogName, itemId: r.key)),
                            ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        SizedBox(
                          width: 96,
                          child: Text(r.value.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: r.value.sessions / maxS,
                              minHeight: 12,
                              backgroundColor: _charcoal,
                              valueColor: AlwaysStoppedAnimation(_green),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${r.value.sessions}',
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      ]),
                    ),
                  ),
              ]),
        subtitle: 'Sessions per skill or exercise',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final sport = _store.sport(widget.dogName, widget.sportId);
    final all = _all;
    final s = _inPeriod;
    final timed = s.map((e) => e.minutesFor(widget.sportId)).whereType<int>().toList();
    final total = timed.fold<int>(0, (a, b) => a + b);

    return HealthScaffold(
      title: 'Sport Progress',
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.show_chart,
                title: 'No Sport Progress Yet',
                message: 'Record your first session to start tracking progress in this sport.',
                actionLabel: 'Record Sport Session',
                onAction: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SportRecordSessionScreen(dogName: widget.dogName, sportId: widget.sportId)),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                Row(children: [
                  Expanded(
                    child: Text(sport?.name ?? '',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      final p = await showPeriodSheet(context, _period);
                      if (p != null) {
                        setState(() {
                          _period = p;
                          _selectedBucket = null;
                          _selectedWeekday = null;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        UlvenikIcon(UlvenikIcons.calendar, size: 15, color: AppColors.secondaryTextStoneGrey),
                        const SizedBox(width: 6),
                        Text(_period,
                            style: TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.secondaryTextStoneGrey),
                      ]),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _stat('Total Sport Sessions', '${s.length}'),
                  const SizedBox(width: 10),
                  _stat('Total Training Duration', timed.isEmpty ? 'Not recorded' : sportDuration(total)),
                ]),
                _line(),
                _heatmap(),
                _skillsAndExercises(),
                _patterns(),
              ],
            ),
    );
  }
}
