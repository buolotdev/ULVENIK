import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_chart.dart';
import '../widgets/health_ui.dart';
import '../widgets/period_sheet.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_record_session_screen.dart';
import 'sc_session_details_screen.dart';

const _green = AppColors.primaryForestGreen;
const _charcoal = Color(0xFF2A2D2C);
const _dayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _dayLong = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _monthShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _monthLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// How a group of sessions is counted: Overview counts each session once;
/// Activities counts each distinct activity once per grouping.
typedef _Count = int Function(List<SCSession> group);
int _sessionCount(List<SCSession> g) => g.length;
int _distinctActivities(List<SCSession> g) => {for (final s in g) ...s.entries.map((e) => e.activityId)}.length;

/// Dog › S&C › analytics: Overview | Activities | Progress. Everything is
/// calculated from the selected dog's saved S&C sessions; nothing is invented.
class SCAnalytics extends StatefulWidget {
  final String dogName;
  const SCAnalytics({super.key, required this.dogName});

  @override
  State<SCAnalytics> createState() => _SCAnalyticsState();
}

class _SCAnalyticsState extends State<SCAnalytics> {
  static const _tabs = ['Overview', 'Activities', 'Progress'];
  final _store = SCStore.instance;
  String _tab = 'Overview';
  String _period = 'This Year';
  late DateTime _heatMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;
  int? _selectedWeekday;
  int? _selectedBucket;

  // Progress selection
  String? _progressActivity;
  SCMeasure? _progressMeasure;
  String? _progressUnit;

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

  List<SCSession> get _all => _store.sessions(widget.dogName);

  List<SCSession> get _inPeriod {
    final from = periodStart(_period);
    return _all.where((s) => from == null || !s.at.isBefore(from)).toList();
  }

  Future<void> _pickPeriod() async {
    final p = await showPeriodSheet(context, _period);
    if (p != null) {
      setState(() {
        _period = p;
        _selectedBucket = null;
        _selectedWeekday = null;
      });
    }
  }

  Widget _periodPill() => Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _pickPeriod,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const UlvenikIcon(UlvenikIcons.calendar, size: 15, color: AppColors.secondaryTextStoneGrey),
              const SizedBox(width: 6),
              Text(_period,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
              const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.secondaryTextStoneGrey),
            ]),
          ),
        ),
      );

  Widget _stat(String label, String value) => Expanded(
        child: HealthCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 8),
            Text(value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
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
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              ?trailing,
            ]),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              ),
            const SizedBox(height: 14),
            child,
          ]),
        ),
      );

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(text, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
        ),
      );

  // ── Line chart over time ────────────────────────────────────────────────
  List<(String, String, int)> _buckets(List<SCSession> sessions, _Count count) {
    final now = DateTime.now();
    final out = <(String, String, int)>[];
    if (_period == 'This Month') {
      for (var d = 1; d <= now.day; d++) {
        final g = sessions.where((s) => s.at.year == now.year && s.at.month == now.month && s.at.day == d).toList();
        out.add(('$d', '${_monthShort[now.month - 1]} $d', count(g)));
      }
      return out;
    }
    var start = periodStart(_period) ?? (_all.isEmpty ? DateTime(now.year, now.month) : _all.last.at);
    start = DateTime(start.year, start.month);
    for (var m = start; !m.isAfter(DateTime(now.year, now.month)); m = DateTime(m.year, m.month + 1)) {
      final g = sessions.where((s) => s.at.year == m.year && s.at.month == m.month).toList();
      out.add((_monthShort[m.month - 1], '${_monthLong[m.month - 1]} ${m.year}', count(g)));
    }
    return out;
  }

  Widget _line(String title, String subtitle, _Count count, String noun) {
    final sessions = _inPeriod;
    final b = _buckets(sessions, count);
    final has = b.any((e) => e.$3 > 0);
    final sel = _selectedBucket != null && _selectedBucket! < b.length ? b[_selectedBucket!] : null;
    final maxV = b.fold<int>(0, (m, e) => e.$3 > m ? e.$3 : m);
    return _card(
      title,
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
                    getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 1),
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
                                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10))
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
                                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
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
                          LineTooltipItem('${b[s.spotIndex].$2}\n${s.y.round()} $noun',
                              const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [for (var i = 0; i < b.length; i++) FlSpot(i.toDouble(), b[i].$3.toDouble())],
                      isCurved: false,
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
                  child: Text('${sel.$2}: ${sel.$3} $noun',
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                ),
            ])
          : _empty('No sessions in this period.'),
      subtitle: subtitle,
    );
  }

  // ── One-month heatmap ───────────────────────────────────────────────────
  Color _level(int n) => n == 0
      ? _charcoal
      : n == 1
          ? const Color(0xFF3A5C4E)
          : n == 2
              ? const Color(0xFF3F7A62)
              : const Color(0xFF5FB88C);

  Widget _heatmap(String title, _Count count, String noun) {
    final first = _heatMonth;
    final days = DateTime(first.year, first.month + 1, 0).day;
    final lead = first.weekday - 1; // Monday first
    final sessions = _all;
    int on(int d) => count(sessions
        .where((s) => s.at.year == first.year && s.at.month == first.month && s.at.day == d)
        .toList());
    final cells = <Widget>[
      for (final d in _dayShort)
        Center(child: Text(d.substring(0, 1), style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11))),
      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
      for (var d = 1; d <= days; d++)
        GestureDetector(
          onTap: () => setState(() => _selectedDay = DateTime(first.year, first.month, d)),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _level(on(d)),
              borderRadius: BorderRadius.circular(6),
              border: _selectedDay == DateTime(first.year, first.month, d)
                  ? Border.all(color: AppColors.primaryTextOffWhite, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text('$d', style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 11.5)),
          ),
        ),
    ];
    final sd = _selectedDay;
    return _card(
      title,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          IconButton(
            tooltip: 'Previous month',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_left, color: AppColors.secondaryTextStoneGrey),
            onPressed: () => setState(() {
              _heatMonth = DateTime(first.year, first.month - 1);
              _selectedDay = null;
            }),
          ),
          Expanded(
            child: Text('${_monthLong[first.month - 1]} ${first.year}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          IconButton(
            tooltip: 'Next month',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
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
          children: cells,
        ),
        const SizedBox(height: 10),
        if (sd != null && sd.year == first.year && sd.month == first.month)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('${fmtDate(sd)}: ${on(sd.day)} $noun',
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
          ),
        Wrap(spacing: 12, runSpacing: 6, children: [
          for (final e in [('0', 0), ('1', 1), ('2', 2), ('3+', 3)])
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: _level(e.$2), borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 5),
              Text(e.$1, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ]),
        ]),
      ]),
    );
  }

  // ── Weekday patterns ────────────────────────────────────────────────────
  Widget _patterns(String title, _Count count, String noun) {
    final sessions = _inPeriod;
    final counts = [for (var w = 1; w <= 7; w++) count(sessions.where((s) => s.at.weekday == w).toList())];
    final maxV = counts.fold<int>(0, (m, e) => e > m ? e : m);
    final most = maxV == 0 ? null : counts.indexOf(maxV);
    return _card(
      title,
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
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10.5)),
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
                      getTooltipItem: (g, gi, r, ri) => BarTooltipItem('${_dayLong[gi]}\n${counts[gi]} $noun',
                          const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < 7; i++)
                      BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: counts[i].toDouble(),
                          width: 20,
                          borderRadius: BorderRadius.circular(5),
                          color: i == most ? const Color(0xFF5FB88C) : _green,
                        ),
                      ]),
                  ],
                )),
              ),
              if (_selectedWeekday != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('${_dayLong[_selectedWeekday!]}: ${counts[_selectedWeekday!]} $noun',
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                ),
            ]),
      trailing: most == null
          ? null
          : Text('Most Active: ${_dayLong[most]}',
              style: const TextStyle(color: AppColors.secondarySage, fontSize: 12.5, fontWeight: FontWeight.w600)),
    );
  }

  // ── Tabs ────────────────────────────────────────────────────────────────
  Widget _overview() {
    final s = _inPeriod;
    final timed = s.where((e) => e.durationMinutes != null);
    final total = timed.fold<int>(0, (a, e) => a + e.durationMinutes!);
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _stat('Total S&C Sessions', '${s.length}'),
        const SizedBox(width: 10),
        _stat('Total Duration', timed.isEmpty ? 'Not recorded' : scDuration(total)),
      ]),
      _line('S&C Activity', 'Track how frequently you’ve trained over time.', _sessionCount, 'sessions'),
      _heatmap('Training Calendar', _sessionCount, 'sessions'),
      _patterns('S&C Training Patterns', _sessionCount, 'sessions'),
    ]);
  }

  Widget _activities() {
    final s = _inPeriod;
    final per = <String, ({String name, int sessions})>{};
    for (final sess in s) {
      for (final id in {for (final e in sess.entries) e.activityId}) {
        final name = sess.entries.firstWhere((e) => e.activityId == id).activityName;
        per[id] = (name: name, sessions: (per[id]?.sessions ?? 0) + 1);
      }
    }
    final ranked = per.values.toList()..sort((a, b) => b.sessions.compareTo(a.sessions));
    final maxS = ranked.isEmpty ? 1 : ranked.first.sessions;
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _stat('Activities Trained', '${per.length}'),
        const SizedBox(width: 10),
        _stat('Most Trained Activity', ranked.isEmpty ? 'Not recorded' : ranked.first.name),
      ]),
      _line('S&C Activity', 'Distinct activities trained each month.', _distinctActivities, 'activities'),
      _heatmap('Training Calendar', _distinctActivities, 'activities'),
      _patterns('S&C Training Patterns', _distinctActivities, 'activities'),
      _card(
        'Most Trained Activities',
        ranked.isEmpty
            ? _empty('No activities in this period.')
            : Column(children: [
                for (final r in ranked.take(8))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      SizedBox(
                        width: 96,
                        child: Text(r.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: r.sessions / maxS,
                            minHeight: 12,
                            backgroundColor: _charcoal,
                            valueColor: const AlwaysStoppedAnimation(_green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${r.sessions}',
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
              ]),
        subtitle: 'Sessions per activity',
      ),
    ]);
  }

  Widget _dropdown<T>({required String label, required T? value, required List<(T, String)> items, required ValueChanged<T?> onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            dropdownColor: AppColors.cardsCarbon,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextStoneGrey),
            items: [for (final i in items) DropdownMenuItem<T>(value: i.$1, child: Text(i.$2))],
            onChanged: onChanged,
          ),
        ),
      ),
    ]);
  }

  Widget _progress() {
    final dog = widget.dogName;
    final activities = [..._store.activities(dog), ..._store.activities(dog, archived: true)];
    SCActivity? activity;
    for (final a in activities) {
      if (a.id == _progressActivity) activity = a;
    }
    activity ??= activities.isEmpty ? null : activities.first;

    Widget emptyState(String? preselect) => HealthCard(
          child: Column(children: [
            const SizedBox(height: 8),
            const Text('No Progress Data Yet',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Record your first S&C session to start tracking progress.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Record S&C Session',
              icon: UlvenikIcons.recordSession,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SCRecordSessionScreen(dogName: dog, activityId: preselect)),
              ),
            ),
          ]),
        );

    if (activity == null) return emptyState(null);

    // Every reading recorded for this activity, from saved sessions only.
    final from = periodStart(_period);
    final readings = <({SCSession session, SCMeasure measure, SCValue value})>[];
    for (final s in _all) {
      for (final e in s.entries.where((e) => e.activityId == activity!.id)) {
        e.values.forEach((m, v) => readings.add((session: s, measure: m, value: v)));
      }
    }
    final measures = [for (final m in SCMeasure.values) if (readings.any((r) => r.measure == m)) m];
    final measure = measures.contains(_progressMeasure) ? _progressMeasure : (measures.isEmpty ? null : measures.first);

    // Unlike units are never combined on one line.
    final ofMeasure = readings.where((r) => r.measure == measure).toList()
      ..sort((a, b) => a.session.at.compareTo(b.session.at));
    final units = {for (final r in ofMeasure) r.value.unit}.toList();
    final unit = units.contains(_progressUnit) ? _progressUnit : (units.isEmpty ? null : ofMeasure.last.value.unit);
    final pts = ofMeasure
        .where((r) => r.value.unit == unit && (from == null || !r.session.at.isBefore(from)))
        .toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _dropdown<String>(
        label: 'Activity',
        value: activity.id,
        items: [for (final a in activities) (a.id, a.name)],
        onChanged: (v) => setState(() {
          _progressActivity = v;
          _progressMeasure = null;
          _progressUnit = null;
        }),
      ),
      if (measures.isNotEmpty) ...[
        const SizedBox(height: 12),
        _dropdown<SCMeasure>(
          label: 'Measurement',
          value: measure,
          items: [for (final m in measures) (m, m.label)],
          onChanged: (v) => setState(() {
            _progressMeasure = v;
            _progressUnit = null;
          }),
        ),
      ],
      if (units.length > 1) ...[
        const SizedBox(height: 12),
        _dropdown<String>(
          label: 'Unit',
          value: unit,
          items: [for (final u in units) (u, u.isEmpty ? 'No unit' : u)],
          onChanged: (v) => setState(() => _progressUnit = v),
        ),
      ],
      const SizedBox(height: 14),
      if (pts.isEmpty)
        emptyState(activity.id)
      else
        HealthCard(
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
          child: SizedBox(
            height: 200,
            child: TrendChart(
              points: [for (final r in pts) TrendPoint(r.session.at, r.value.value)],
              format: (v) => scFormatValue(SCValue(double.parse(v.toStringAsFixed(1)), unit ?? '')),
              onPointTap: (i) {
                final r = pts[i];
                final a = activity!;
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: AppColors.cardsCarbon,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(scFormatValue(r.value),
                            style: const TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('${a.name} · ${r.measure.label}',
                            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                        Text(fmtDate(r.session.at),
                            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                        const SizedBox(height: 18),
                        PrimaryButton(
                          label: 'Open Session',
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SCSessionDetailsScreen(dogName: dog, sessionId: r.session.id)),
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionLabel('S&C Analytics'),
      ChoiceRow(options: _tabs, value: _tab, onChanged: (v) => setState(() => _tab = v)),
      const SizedBox(height: 12),
      _periodPill(),
      const SizedBox(height: 4),
      switch (_tab) {
        'Activities' => _activities(),
        'Progress' => Padding(padding: const EdgeInsets.only(top: 8), child: _progress()),
        _ => _overview(),
      },
    ]);
  }
}
