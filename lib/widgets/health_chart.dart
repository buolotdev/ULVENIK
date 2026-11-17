import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'health_ui.dart';

class TrendPoint {
  final DateTime date;
  final double value;
  const TrendPoint(this.date, this.value);
}

const kTrendFilters = ['Lifetime', 'This Year', 'Last 6 Months', 'This Month'];

List<TrendPoint> filterTrend(List<TrendPoint> pts, String filter) {
  final now = DateTime.now();
  DateTime? from;
  switch (filter) {
    case 'This Year':
      from = DateTime(now.year);
    case 'Last 6 Months':
      from = DateTime(now.year, now.month - 6, now.day);
    case 'This Month':
      from = DateTime(now.year, now.month);
    default:
      from = null;
  }
  final l = pts.where((p) => from == null || !p.date.isBefore(from)).toList();
  l.sort((a, b) => a.date.compareTo(b.date));
  return l;
}

/// Line chart over dated points. Tap a point to see its exact value and date.
/// With [compact] it is a small non-interactive preview.
class TrendChart extends StatelessWidget {
  final List<TrendPoint> points;
  final bool compact;
  final double? minY;
  final double? maxY;
  final String Function(double) format;
  final ValueChanged<int>? onPointTap; // index into the (date-sorted) points
  const TrendChart({
    super.key,
    required this.points,
    required this.format,
    this.compact = false,
    this.minY,
    this.maxY,
    this.onPointTap,
  });

  @override
  Widget build(BuildContext context) {
    final pts = [...points]..sort((a, b) => a.date.compareTo(b.date));
    if (pts.isEmpty) return const SizedBox.shrink();
    final t0 = pts.first.date.millisecondsSinceEpoch.toDouble();
    final t1 = pts.last.date.millisecondsSinceEpoch.toDouble();
    final span = (t1 - t0) <= 0 ? 1.0 : (t1 - t0);
    final spots = [
      for (final p in pts) FlSpot(pts.length == 1 ? 0.5 : (p.date.millisecondsSinceEpoch - t0) / span, p.value),
    ];
    final vals = pts.map((p) => p.value);
    final lo = minY ?? (vals.reduce((a, b) => a < b ? a : b) - 1);
    final hi = maxY ?? (vals.reduce((a, b) => a > b ? a : b) + 1);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 1,
        minY: lo,
        maxY: hi,
        gridData: FlGridData(
          show: !compact,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.cardBorder, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: !compact,
              reservedSize: 36,
              getTitlesWidget: (v, m) => v == m.min || v == m.max
                  ? const SizedBox.shrink()
                  : Text(format(v),
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: !compact,
              reservedSize: 24,
              interval: 0.5,
              getTitlesWidget: (v, m) {
                if (pts.length == 1) {
                  return v == 0.5
                      ? Text(fmtShort(pts.first.date),
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10))
                      : const SizedBox.shrink();
                }
                final d = DateTime.fromMillisecondsSinceEpoch((t0 + span * v).round());
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(fmtShort(d),
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: !compact,
          touchCallback: onPointTap == null
              ? null
              : (event, response) {
                  final spots = response?.lineBarSpots;
                  if (event is FlTapUpEvent && spots != null && spots.isNotEmpty) {
                    onPointTap!(spots.first.spotIndex);
                  }
                },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.cardsCarbon,
            getTooltipItems: (spots) => [
              for (final s in spots)
                LineTooltipItem(
                  '${format(s.y)}\n${fmtDate(pts[s.spotIndex].date)}',
                  TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: !compact && pts.length > 2,
            color: AppColors.primaryForestGreen,
            barWidth: compact ? 2 : 2.5,
            dotData: FlDotData(
              show: !compact || pts.length == 1,
              getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                  radius: compact ? 2.5 : 4,
                  color: AppColors.secondarySage,
                  strokeWidth: 0),
            ),
            belowBarData: BarAreaData(show: true, color: AppColors.primaryForestGreen.withValues(alpha: 0.12)),
          ),
        ],
      ),
    );
  }
}

class TrendFilterBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const TrendFilterBar({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ChoiceRow(options: kTrendFilters, value: value, onChanged: onChanged),
    );
  }
}
