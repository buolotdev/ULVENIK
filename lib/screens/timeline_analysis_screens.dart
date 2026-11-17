import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../data/sample_data.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'health_records_hub_screen.dart';
import 'sc_record_session_screen.dart';
import 'sport_competition_screens.dart';
import 'timeline_common.dart';
import 'timeline_export_util.dart';
import 'timeline_milestone_screens.dart';
import 'training_screen.dart' show openNewTrainingSession;

const _monthShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const _monthLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];
const _dayLong = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

Widget _selector(String value, VoidCallback onTap) => OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryTextOffWhite,
        side: BorderSide(color: AppColors.cardBorder),
        backgroundColor: AppColors.cardsCarbon,
        alignment: Alignment.centerLeft,
        minimumSize: const Size(double.infinity, 46),
      ),
      child: Row(children: [
        Expanded(child: Text(value)),
        Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryTextStoneGrey),
      ]),
    );

Future<void> _exportChoice(
  BuildContext context, {
  required String baseName,
  required String heading,
  required List<String> lines,
  required List<List<String>> rows,
}) async {
  final pdf = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            title: Text('PDF Document', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            subtitle: Text('A formatted summary for reading, printing and sharing',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            onTap: () => Navigator.pop(ctx, true),
          ),
          ListTile(
            title: Text('CSV Spreadsheet', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            subtitle: Text('Figures for Excel or Google Sheets',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            onTap: () => Navigator.pop(ctx, false),
          ),
        ]),
      ),
    ),
  );
  if (pdf == null || !context.mounted) return;
  await runExport(
    context,
    fileName: '${baseName}_${exportStamp()}.${pdf ? 'pdf' : 'csv'}',
    pdf: pdf,
    build: () async => pdf ? await tablePdf(heading, lines, rows) : tableCsv(rows),
  );
}

// ═══ Statistics ═════════════════════════════════════════════════════════════

/// Timeline Statistics: what was recorded, not a measure of progress. One
/// total, a category list that adds up to it, and a bar chart over time.
class TimelineStatisticsScreen extends StatefulWidget {
  final String initialDog;
  const TimelineStatisticsScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineStatisticsScreen> createState() => _TimelineStatisticsScreenState();
}

class _TimelineStatisticsScreenState extends State<TimelineStatisticsScreen> {
  final _store = TimelineStore.instance;
  late String _dog = widget.initialDog;
  TlPeriod _period = TlPeriod.lifetime;
  int? _selected;

  List<(String, String, int)> _buckets(List<TimelineEvent> ev) {
    final now = DateTime.now();
    final first = ev.isEmpty ? now : ev.map((e) => e.at).reduce((a, b) => a.isBefore(b) ? a : b);
    final start = _day(_period.start ?? first);
    final end = _period.end == null ? _day(now) : _day(_period.end!);
    final days = end.difference(start).inDays + 1;
    final out = <(String, String, int)>[];
    if (days <= 31) {
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        out.add(('${d.day}', fmtDate(d), ev.where((e) => _day(e.at) == d).length));
      }
    } else if (days <= 366) {
      for (var m = DateTime(start.year, start.month); !m.isAfter(end); m = DateTime(m.year, m.month + 1)) {
        final cur = m.year == now.year && m.month == now.month;
        out.add((_monthShort[m.month - 1], '${_monthLong[m.month - 1]} ${m.year}${cur ? ' (so far)' : ''}',
            ev.where((e) => e.at.year == m.year && e.at.month == m.month).length));
      }
    } else {
      for (var y = start.year; y <= end.year; y++) {
        out.add(('$y', y == now.year ? '$y (so far)' : '$y', ev.where((e) => e.at.year == y).length));
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final everything = _store.events(dog: dogScope(_dog));
    final ev = everything.where((e) => _period.contains(e.at)).toList();
    final cats = {for (final c in kTimelineCategories) c: ev.where((e) => e.category == c).length};
    final b = _buckets(ev);
    final maxV = b.fold<int>(0, (m, e) => e.$3 > m ? e.$3 : m);

    Widget body;
    if (everything.isEmpty) {
      body = EmptyState(
        icon: Icons.bar_chart,
        title: 'No Statistics Yet',
        message: 'Record your dog’s activity to see a summary of your Timeline records.',
        actionLabel: 'Add Record',
        onAction: () => Navigator.pop(context),
      );
    } else if (ev.isEmpty) {
      body = EmptyState(
        icon: Icons.bar_chart,
        title: 'No Records in This Period',
        message: 'Choose a different time period to see your recorded activity.',
        actionLabel: 'Change Time Period',
        onAction: () async {
          final p = await showTlPeriodSheet(context, _period);
          if (p != null) setState(() => _period = p);
        },
      );
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        HealthCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Total Recorded Events', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 6),
            Text('${ev.length}',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 30, fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(height: 18),
        const SectionLabel('Records by Category'),
        for (final c in kTimelineCategories)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: HealthCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(children: [
                Icon(timelineCategoryIcon(c), size: 20, color: AppColors.secondarySage),
                const SizedBox(width: 12),
                Expanded(child: Text(c, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15))),
                Text('${cats[c]}', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        const SizedBox(height: 14),
        const SectionLabel('Recorded Events Over Time'),
        HealthCard(
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 170,
              child: BarChart(BarChartData(
                minY: 0,
                maxY: (maxV + 1).toDouble(),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: maxV > 6 ? (maxV / 4).ceilToDouble() : 1,
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
                          ? Text('${v.round()}', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10))
                          : const SizedBox.shrink(),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: b.length > 10 ? (b.length / 6).ceilToDouble() : 1,
                      getTitlesWidget: (v, m) {
                        final i = v.round();
                        if (i < 0 || i >= b.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(b[i].$1, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchCallback: (event, resp) {
                    if (event is FlTapUpEvent && resp?.spot != null) {
                      setState(() => _selected = resp!.spot!.touchedBarGroupIndex);
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.backgroundObsidian,
                    getTooltipItem: (g, gi, r, ri) => BarTooltipItem('${b[gi].$2}\n${b[gi].$3}',
                        TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < b.length; i++)
                    BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                          toY: b[i].$3.toDouble(),
                          width: b.length > 20 ? 6 : 14,
                          borderRadius: BorderRadius.circular(3),
                          color: AppColors.primaryForestGreen),
                    ]),
                ],
              )),
            ),
            if (_selected != null && _selected! < b.length)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text('${b[_selected!].$2}: ${b[_selected!].$3} ${b[_selected!].$3 == 1 ? 'event' : 'events'}',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
              ),
          ]),
        ),
      ]);
    }

    return HealthScaffold(
      title: 'Statistics',
      bottom: ev.isEmpty
          ? Text(everything.isEmpty ? '' : 'No records to export.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5))
          : PrimaryButton(
              label: 'Export Statistics',
              onPressed: () => _exportChoice(
                context,
                baseName: 'Ulvenik_Statistics_${_dog == kAllDogs ? 'All_Dogs' : _dog}',
                heading: 'Timeline Statistics',
                lines: [_dog == kAllDogs ? 'All Dogs' : _dog, _period.label, 'This shows what you recorded, not a measure of training progress.'],
                rows: [
                  ['Measure', 'Value'],
                  ['Total Recorded Events', '${ev.length}'],
                  for (final c in kTimelineCategories) [c, '${cats[c]}'],
                  ['', ''],
                  ['Period', 'Events'],
                  for (final x in b) [x.$2, '${x.$3}'],
                ],
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog);
              if (d != null) setState(() => _dog = d);
            },
          ),
          const SizedBox(height: 10),
          Text('This shows what you recorded, not a measure of training progress.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
          const SizedBox(height: 12),
          _selector(_period.label, () async {
            final p = await showTlPeriodSheet(context, _period);
            if (p != null) setState(() {
              _period = p;
              _selected = null;
            });
          }),
          const SizedBox(height: 16),
          body,
        ],
      ),
    );
  }
}

// ═══ Compare ════════════════════════════════════════════════════════════════

/// Compare what was recorded in two inclusive date ranges for one dog.
/// Difference is first range minus second, shown signed and neutral.
class TimelineCompareScreen extends StatefulWidget {
  final String initialDog;
  const TimelineCompareScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineCompareScreen> createState() => _TimelineCompareScreenState();
}

class _TimelineCompareScreenState extends State<TimelineCompareScreen> {
  final _store = TimelineStore.instance;
  late String _dog = widget.initialDog;
  String _category = kAllCategories;
  late (DateTime, DateTime) _a;
  late (DateTime, DateTime) _b;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    // last two complete calendar months
    _a = (DateTime(n.year, n.month - 1), DateTime(n.year, n.month, 0));
    _b = (DateTime(n.year, n.month - 2), DateTime(n.year, n.month - 1, 0));
  }

  int _days((DateTime, DateTime) r) => r.$2.difference(r.$1).inDays + 1;

  List<TimelineEvent> _in((DateTime, DateTime) r) {
    final end = DateTime(r.$2.year, r.$2.month, r.$2.day, 23, 59, 59);
    return _store
        .events(dog: dogScope(_dog))
        .where((e) => !e.at.isBefore(r.$1) && !e.at.isAfter(end) && (_category == kAllCategories || e.category == _category))
        .toList();
  }

  Future<void> _changeDates() async {
    var a = _a, b = _b;
    String? error;
    final n = DateTime.now();
    final res = await showModalBottomSheet<((DateTime, DateTime), (DateTime, DateTime))>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          Widget range(String label, (DateTime, DateTime) r, void Function((DateTime, DateTime)) set) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldLabel(label, required: true),
                  Row(children: [
                    Expanded(child: DateField(value: r.$1, allowFuture: false, onChanged: (d) => setSheet(() => set((d, r.$2))))),
                    const SizedBox(width: 8),
                    Expanded(child: DateField(value: r.$2, allowFuture: false, onChanged: (d) => setSheet(() => set((r.$1, d))))),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('${_days(r)} days', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                  ),
                ],
              );
          final overlap = !a.$1.isAfter(b.$2) && !b.$1.isAfter(a.$2);
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Compare Dates',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ActionChip(
                    label: const Text('Last Month vs Previous Month'),
                    onPressed: () => setSheet(() {
                      a = (DateTime(n.year, n.month - 1), DateTime(n.year, n.month, 0));
                      b = (DateTime(n.year, n.month - 2), DateTime(n.year, n.month - 1, 0));
                    }),
                    backgroundColor: AppColors.backgroundObsidian,
                    side: BorderSide(color: AppColors.cardBorder),
                    labelStyle: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5),
                  ),
                  ActionChip(
                    label: const Text('Last Week vs Previous Week'),
                    onPressed: () => setSheet(() {
                      final monday = _day(n).subtract(Duration(days: n.weekday - 1));
                      a = (monday.subtract(const Duration(days: 7)), monday.subtract(const Duration(days: 1)));
                      b = (monday.subtract(const Duration(days: 14)), monday.subtract(const Duration(days: 8)));
                    }),
                    backgroundColor: AppColors.backgroundObsidian,
                    side: BorderSide(color: AppColors.cardBorder),
                    labelStyle: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5),
                  ),
                ]),
                range('First Date Range', a, (r) => a = r),
                range('Second Date Range', b, (r) => b = r),
                if (overlap)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('These ranges overlap.', style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5)),
                  ),
                if (_days(a) != _days(b))
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('The ranges are different lengths.', style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5)),
                  ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
                  ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryTextOffWhite,
                          side: BorderSide(color: AppColors.cardBorder),
                          minimumSize: const Size(0, 50)),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Apply Dates',
                      onPressed: () {
                        if (a.$2.isBefore(a.$1) || b.$2.isBefore(b.$1)) {
                          setSheet(() => error = 'Each end date must be on or after its start date.');
                        } else {
                          Navigator.pop(ctx, (a, b));
                        }
                      },
                    ),
                  ),
                ]),
              ]),
            ),
          );
        },
      ),
    );
    if (res != null) setState(() {
      _a = res.$1;
      _b = res.$2;
    });
  }

  String _range((DateTime, DateTime) r) => '${fmtDate(r.$1)} – ${fmtDate(r.$2)}';

  @override
  Widget build(BuildContext context) {
    final all = _store.events(dog: dogScope(_dog));
    final ea = _in(_a), eb = _in(_b);
    int cnt(List<TimelineEvent> l, String c) => l.where((e) => e.category == c).length;
    final rows = <(String, int, int)>[
      ('Total Recorded Events', ea.length, eb.length),
      for (final c in kTimelineCategories) (c, cnt(ea, c), cnt(eb, c)),
    ];
    String diff(int x) => x > 0 ? '+$x' : '$x';
    final exportRows = <List<String>>[
      ['Measure', _range(_a), _range(_b), 'Difference'],
      for (final r in rows) [r.$1, '${r.$2}', '${r.$3}', diff(r.$2 - r.$3)],
    ];

    Widget rangeCard(String label, (DateTime, DateTime) r) => Expanded(
          child: HealthCard(
            onTap: _changeDates,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(_range(r), style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
              Text('${_days(r)} days', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              const SizedBox(height: 6),
              Text('Change dates', style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ]),
          ),
        );

    Widget body;
    if (all.isEmpty) {
      body = EmptyState(
        icon: Icons.compare_arrows,
        title: 'No Records Yet',
        message: 'Record an event to start comparing your dog’s recorded activity.',
        actionLabel: 'Go to Timeline',
        onAction: () => Navigator.pop(context),
      );
    } else if (ea.isEmpty && eb.isEmpty && _category != kAllCategories && _in2All(_a, _b)) {
      body = EmptyState(
        icon: Icons.compare_arrows,
        title: 'No Matching Records',
        message: 'There are no $_category records in these date ranges.',
        actionLabel: 'Clear Category',
        onAction: () => setState(() => _category = kAllCategories),
      );
    } else if (ea.isEmpty && eb.isEmpty) {
      body = EmptyState(
        icon: Icons.compare_arrows,
        title: 'No Records in These Date Ranges',
        message: 'Choose different dates or record an event to start comparing your dog’s recorded activity.',
        actionLabel: 'Change Dates',
        onAction: _changeDates,
      );
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionLabel('Recorded Events'),
        HealthCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Table(
            columnWidths: const {0: FlexColumnWidth(2.2), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1.2)},
            children: [
              TableRow(children: [
                const SizedBox.shrink(),
                for (final h in [fmtShort(_a.$1), fmtShort(_b.$1), 'Difference'])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(h,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11.5)),
                  ),
              ]),
              for (final r in rows)
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Text(r.$1, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5)),
                  ),
                  for (final v in ['${r.$2}', '${r.$3}', diff(r.$2 - r.$3)])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Text(v,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, fontWeight: FontWeight.w600)),
                    ),
                ]),
            ],
          ),
        ),
      ]);
    }

    return HealthScaffold(
      title: 'Compare',
      bottom: (ea.isEmpty && eb.isEmpty)
          ? null
          : PrimaryButton(
              label: 'Export Comparison',
              onPressed: () => _exportChoice(
                context,
                baseName: 'Ulvenik_Comparison_${_dog == kAllDogs ? 'All_Dogs' : _dog}',
                heading: 'Recorded Activity Comparison',
                lines: [
                  _dog == kAllDogs ? 'All Dogs' : _dog,
                  _category,
                  '${_range(_a)} (${_days(_a)} days) vs ${_range(_b)} (${_days(_b)} days)',
                ],
                rows: exportRows,
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog);
              if (d != null) setState(() => _dog = d);
            },
          ),
          const SizedBox(height: 14),
          Text('Recorded Activity Comparison',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          Text('Compare what you recorded in two periods.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            rangeCard('First range', _a),
            const SizedBox(width: 10),
            rangeCard('Second range', _b),
          ]),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => setState(() {
                final t = _a;
                _a = _b;
                _b = t;
              }),
              child: Text('Swap Dates', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
          ),
          _selector(_category, () async {
            final c = await showCategorySheet(context, _category);
            if (c != null) setState(() => _category = c);
          }),
          const SizedBox(height: 14),
          body,
        ],
      ),
    );
  }

  /// True when the dog has records in the ranges ignoring the category.
  bool _in2All((DateTime, DateTime) a, (DateTime, DateTime) b) {
    final keep = _category;
    _category = kAllCategories;
    final any = _in(a).isNotEmpty || _in(b).isNotEmpty;
    _category = keep;
    return any;
  }
}

// ═══ Memories ═══════════════════════════════════════════════════════════════

/// Memories: saved records from the same day (or month) in earlier years.
class TimelineMemoriesScreen extends StatefulWidget {
  final String initialDog;
  const TimelineMemoriesScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineMemoriesScreen> createState() => _TimelineMemoriesScreenState();
}

class _TimelineMemoriesScreenState extends State<TimelineMemoriesScreen> {
  final _store = TimelineStore.instance;
  late String _dog = widget.initialDog;
  String _category = kAllCategories;
  int? _year; // null = All Years

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final earlier = _store.events(dog: dogScope(_dog)).where((e) => e.at.year < now.year && e.at.month == now.month).toList();
    final years = {for (final e in earlier) e.at.year}.toList()..sort((a, b) => b.compareTo(a));
    final shown = earlier
        .where((e) => (_category == kAllCategories || e.category == _category) && (_year == null || e.at.year == _year))
        .toList();
    final today = shown.where((e) => e.at.day == now.day).toList()..sort((a, b) => b.at.compareTo(a.at));
    final month = shown.where((e) => e.at.day != now.day).toList()..sort((a, b) => b.at.compareTo(a.at));

    Widget card(TimelineEvent e) {
      final ago = now.year - e.at.year;
      return TimelineEventCard(
        event: e,
        showDog: _dog == kAllDogs,
        extraLine: ago == 1 ? '1 year ago' : '$ago years ago',
        onTap: () => openEvent(context, e),
        trailing: IconButton(
          tooltip: 'Share This Memory',
          icon: Icon(Icons.ios_share, size: 20, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => showMemoryCard(context, e, ago),
        ),
      );
    }

    Widget body;
    if (earlier.isEmpty) {
      body = EmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'No Memories Yet',
        message:
            'Memories from previous years will appear here around their anniversaries as your dog’s Timeline grows.',
        actionLabel: 'Go to Timeline',
        onAction: () => Navigator.pop(context),
      );
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final c = await showCategorySheet(context, _category);
                if (c != null) setState(() => _category = c);
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  backgroundColor: AppColors.cardsCarbon,
                  minimumSize: const Size(0, 46)),
              child: Text(_category, overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final y = await showModalBottomSheet<int>(
                  context: context,
                  backgroundColor: AppColors.cardsCarbon,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Browse Memories by Year',
                            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('All Years', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                          trailing: _year == null ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                          onTap: () => Navigator.pop(ctx, 0),
                        ),
                        for (final y in years)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('$y', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                            trailing: _year == y ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                            onTap: () => Navigator.pop(ctx, y),
                          ),
                      ]),
                    ),
                  ),
                );
                if (y != null) setState(() => _year = y == 0 ? null : y);
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  backgroundColor: AppColors.cardsCarbon,
                  minimumSize: const Size(0, 46)),
              child: Text(_year == null ? 'All Years' : '$_year'),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        if (shown.isEmpty)
          EmptyState(
            icon: Icons.auto_awesome_outlined,
            title: 'No Matching Memories',
            message: 'Try a different category or year to see more memories.',
            actionLabel: 'Clear Filters',
            onAction: () => setState(() {
              _category = kAllCategories;
              _year = null;
            }),
          )
        else ...[
          if (today.isNotEmpty) ...[const SectionLabel('On This Day'), for (final e in today) card(e)],
          if (month.isNotEmpty) ...[const SizedBox(height: 8), const SectionLabel('This Month'), for (final e in month) card(e)],
        ],
      ]);
    }

    return HealthScaffold(
      title: 'Memories',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog);
              if (d != null) setState(() => _dog = d);
            },
          ),
          const SizedBox(height: 14),
          body,
        ],
      ),
    );
  }
}

// ═══ Calendar ═══════════════════════════════════════════════════════════════

/// Calendar: browse saved records by original date for one dog. It is not a
/// training schedule.
class TimelineCalendarScreen extends StatefulWidget {
  final String initialDog;
  const TimelineCalendarScreen({super.key, this.initialDog = kAllDogs});

  @override
  State<TimelineCalendarScreen> createState() => _TimelineCalendarScreenState();
}

class _TimelineCalendarScreenState extends State<TimelineCalendarScreen> {
  final _store = TimelineStore.instance;
  late String _dog = widget.initialDog == kAllDogs ? SampleData.myDogs.first.name : widget.initialDog;
  String _category = kAllCategories;
  String _view = 'Month';
  DateTime _selected = _day(DateTime.now());

  List<TimelineEvent> _on(DateTime d) {
    final l = _store
        .events(dog: _dog)
        .where((e) => _day(e.at) == d && (_category == kAllCategories || e.category == _category))
        .toList();
    l.sort((a, b) {
      if (a.hasTime != b.hasTime) return a.hasTime ? -1 : 1; // untimed follow timed
      return a.at.compareTo(b.at);
    });
    return l;
  }

  void _shift(int dir) => setState(() {
        switch (_view) {
          case 'Month':
            _selected = DateTime(_selected.year, _selected.month + dir, 1);
          case 'Week':
            _selected = _selected.add(Duration(days: 7 * dir));
          default:
            _selected = _selected.add(Duration(days: dir));
        }
      });

  Future<void> _add() async {
    final type = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add Record',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            for (final t in ['Training Session', 'S&C Session', 'Health Record', 'Milestone', 'Competition'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () => Navigator.pop(ctx, t),
              ),
          ]),
        ),
      ),
    );
    if (type == null || !mounted) return;
    void go(Widget w) => Navigator.push(context, MaterialPageRoute(builder: (_) => w));
    switch (type) {
      case 'Training Session':
        openNewTrainingSession(context, dogName: _dog);
      case 'S&C Session':
        go(SCRecordSessionScreen(dogName: _dog));
      case 'Health Record':
        go(HealthRecordsHubScreen(dogName: _dog));
      case 'Milestone':
        go(MilestoneFormScreen(dogName: _dog, date: _selected));
      default:
        go(CompetitionFormScreen(dogName: _dog));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = _day(now);
    final monday = _selected.subtract(Duration(days: _selected.weekday - 1));
    final dayEvents = _on(_selected);

    Widget dayCell(DateTime d, {bool compact = false}) {
      final n = _on(d).length;
      final sel = d == _selected;
      return GestureDetector(
        onTap: () => setState(() => _selected = d),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: sel ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(8),
            border: d == today && !sel ? Border.all(color: AppColors.primaryTextOffWhite, width: 1) : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${d.day}', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5)),
              Text(n == 0 ? ' ' : '$n', style: TextStyle(color: AppColors.secondarySage, fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      );
    }

    final first = DateTime(_selected.year, _selected.month, 1);
    final daysInMonth = DateTime(_selected.year, _selected.month + 1, 0).day;
    final heading = switch (_view) {
      'Month' => '${_monthLong[_selected.month - 1]} ${_selected.year}',
      'Week' => '${fmtShort(monday)} – ${fmtDate(monday.add(const Duration(days: 6)))}',
      _ => '${_dayLong[_selected.weekday - 1]}, ${fmtDate(_selected)}',
    };

    return HealthScaffold(
      title: 'Calendar',
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: UlvenikIcon(UlvenikIcons.search, color: AppColors.primaryTextOffWhite),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TimelineCalendarSearchScreen(dog: _dog, category: _category)),
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          TimelineDogHeader(
            dog: _dog,
            onSwitch: () async {
              final d = await showDogSheet(context, _dog, allowAll: false);
              if (d != null) setState(() => _dog = d);
            },
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _selector(_category, () async {
                final c = await showCategorySheet(context, _category);
                if (c != null) setState(() => _category = c);
              }),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () => setState(() => _selected = today),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 46)),
              child: const Text('Today'),
            ),
          ]),
          const SizedBox(height: 10),
          ChoiceRow(options: const ['Month', 'Week', 'Day'], value: _view, onChanged: (v) => setState(() => _view = v)),
          const SizedBox(height: 10),
          Row(children: [
            IconButton(
              tooltip: 'Previous',
              icon: Icon(Icons.chevron_left, color: AppColors.secondaryTextStoneGrey),
              onPressed: () => _shift(-1),
            ),
            Expanded(
              child: Text(heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            IconButton(
              tooltip: 'Next',
              icon: Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
              onPressed: () => _shift(1),
            ),
          ]),
          if (_view == 'Month')
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: [
                for (final d in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                  Center(child: Text(d, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11))),
                for (var i = 0; i < first.weekday - 1; i++) const SizedBox.shrink(),
                for (var d = 1; d <= daysInMonth; d++) dayCell(DateTime(_selected.year, _selected.month, d)),
              ],
            ),
          if (_view == 'Week')
            Row(children: [
              for (var i = 0; i < 7; i++) Expanded(child: dayCell(monday.add(Duration(days: i)))),
            ]),
          const SizedBox(height: 14),
          SectionLabel('${fmtDate(_selected)} · ${dayEvents.length} ${dayEvents.length == 1 ? 'record' : 'records'}'),
          if (_view == 'Week')
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _view = 'Day'),
                child: Text('View Day', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
              ),
            ),
          if (dayEvents.isEmpty)
            EmptyState(
              icon: Icons.event_busy_outlined,
              title: _category == kAllCategories ? 'No Records on This Date' : 'No Matching Records on This Date',
              message: _category == kAllCategories ? 'Choose another date or add a record.' : 'Try another date or clear the category filter.',
              actionLabel: _category == kAllCategories ? 'Add Record' : 'Clear Category Filter',
              onAction: _category == kAllCategories ? _add : () => setState(() => _category = kAllCategories),
            )
          else
            for (final e in dayEvents)
              TimelineEventCard(
                event: e,
                showDog: false,
                extraLine: e.hasTime ? null : 'Time not recorded',
                onTap: () => openEvent(context, e),
              ),
        ],
      ),
    );
  }
}

/// Calendar Search: all dates for the dog and a search-only category.
class TimelineCalendarSearchScreen extends StatefulWidget {
  final String dog;
  final String category;
  const TimelineCalendarSearchScreen({super.key, required this.dog, required this.category});

  static final Map<String, List<String>> _recents = {};

  @override
  State<TimelineCalendarSearchScreen> createState() => _TimelineCalendarSearchScreenState();
}

class _TimelineCalendarSearchScreenState extends State<TimelineCalendarSearchScreen> {
  final _ctrl = TextEditingController();
  late String _category = widget.category;

  List<String> get _recents => TimelineCalendarSearchScreen._recents.putIfAbsent(widget.dog, () => []);

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit(String q) {
    final t = q.trim();
    if (t.isEmpty) return;
    _recents.removeWhere((r) => r.toLowerCase() == t.toLowerCase());
    _recents.insert(0, t);
    if (_recents.length > 5) _recents.removeLast();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final q = _ctrl.text.trim().toLowerCase();
    final store = TimelineStore.instance;
    final results = q.isEmpty
        ? <TimelineEvent>[]
        : (store.events(dog: widget.dog).where((e) {
            if (_category != kAllCategories && e.category != _category) return false;
            return eventMatches(e, q) || attachmentNames(e).any((n) => n.toLowerCase().contains(q));
          }).toList()
          ..sort((a, b) => b.at.compareTo(a.at)));

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: _submit,
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15),
          decoration: healthDecoration('Search records...').copyWith(
            suffixIcon: _ctrl.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                    onPressed: _ctrl.clear,
                  ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          _selector('All dates / $_category', () async {
            final c = await showCategorySheet(context, _category);
            if (c != null) setState(() => _category = c);
          }),
          const SizedBox(height: 14),
          if (q.isEmpty) ...[
            Text('Search your dog’s records by title, notes or attachment name.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
            if (_recents.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: Text('Recent',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () => setState(_recents.clear),
                  child: Text('Clear All', style: TextStyle(color: AppColors.primaryForestGreen)),
                ),
              ]),
              for (final r in _recents)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(r, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  trailing: IconButton(
                    tooltip: 'Remove',
                    icon: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                    onPressed: () => setState(() => _recents.remove(r)),
                  ),
                  onTap: () => _ctrl.text = r,
                ),
            ],
          ] else if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(children: [
                Text('No Matching Records',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Try another search term, or change the query or scope.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                if (_category != kAllCategories)
                  TextButton(
                    onPressed: () => setState(() => _category = kAllCategories),
                    child: Text('Clear Category Filter',
                        style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                  ),
              ]),
            )
          else
            for (final e in results)
              TimelineEventCard(
                event: e,
                showDog: false,
                onTap: () {
                  _submit(_ctrl.text);
                  openEvent(context, e);
                },
              ),
        ],
      ),
    );
  }
}


/// Share This Memory: shows a preview card first, then saves it as an image
/// only when you choose to. Cancelling saves nothing.
Future<void> showMemoryCard(BuildContext context, TimelineEvent e, int yearsAgo) async {
  final key = GlobalKey();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Save Memory Card',
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          RepaintBoundary(
            key: key,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.backgroundObsidian,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryForestGreen),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(yearsAgo == 1 ? '1 year ago' : '$yearsAgo years ago',
                    style: TextStyle(color: AppColors.secondarySage, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Text(e.title,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('${e.dog} · ${fmtDate(e.at)}',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                if (e.notes.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(e.notes.trim(),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, height: 1.4)),
                ],
                const SizedBox(height: 18),
                Text('Ulvenik',
                    style: TextStyle(color: AppColors.secondarySage, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Save Image',
            onPressed: () async {
              try {
                final b = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
                final img = await b.toImage(pixelRatio: 3);
                final data = await img.toByteData(format: ui.ImageByteFormat.png);
                if (data == null) throw StateError('no image');
                final r = await FilePicker.saveFile(
                    fileName: 'Ulvenik_Memory_${exportStamp()}.png', bytes: data.buffer.asUint8List());
                if (r != null && ctx.mounted) {
                  AppSnackbar.show(ctx, message: 'Image saved', type: SnackbarType.success);
                  Navigator.pop(ctx);
                }
              } catch (_) {
                if (ctx.mounted) {
                  AppSnackbar.show(ctx, message: 'Couldn’t save the image. Please try again.', type: SnackbarType.error);
                }
              }
            },
          ),
          const SizedBox(height: 8),
          Center(child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel'))),
        ]),
      ),
    ),
  );
}
