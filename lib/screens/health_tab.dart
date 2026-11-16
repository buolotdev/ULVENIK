import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_chart.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'body_condition_screen.dart';
import 'health_records_hub_screen.dart';
import 'health_reminders_list_screen.dart';
import 'weight_records_screen.dart';

/// Dog Profile › Health tab: Health Records + Health Reminders shortcuts,
/// then the approved Health Overview (two stats, weight preview, upcoming).
/// Shows only the open dog's real records; no dashboard in between.
class HealthTab extends StatelessWidget {
  final String dogName;
  const HealthTab({super.key, required this.dogName});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  Widget _shortcut({
    required Widget icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return HealthCard(
      onTap: onTap,
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: AppColors.primaryForestGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
          child: Center(child: icon),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          ]),
        ),
        trailing ?? const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
      ]),
    );
  }

  Widget _stat({
    required IconData icon,
    required String label,
    required String value,
    required String detail,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: HealthCard(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 20, color: kHealthGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ),
          ]),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 2),
          Text(detail, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = HealthStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final weights = store.weights(dogName);
        final bcs = store.bcs(dogName);
        final upcoming = store.upcoming(dogName);
        final shown = upcoming.take(3).toList();
        final count = store.recordCount(dogName);

        String weightValue = 'Not recorded';
        String weightDetail = 'No entries';
        if (weights.isNotEmpty) {
          final w = weights.first;
          weightValue = '${fmtKg(double.parse(toPrefWeight(w.kg).toStringAsFixed(1)))} ${prefWeightUnit()}';
          if (weights.length > 1) {
            final delta = toPrefWeight(w.kg) - toPrefWeight(weights[1].kg);
            final sign = delta > 0.04 ? '+' : (delta < -0.04 ? '−' : '');
            weightDetail = '$sign${fmtKg(double.parse(delta.abs().toStringAsFixed(1)))} ${prefWeightUnit()} since last entry';
          } else {
            weightDetail = 'First entry';
          }
        }

        final points = [for (final w in weights) TrendPoint(w.date, toPrefWeight(w.kg))];

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            _shortcut(
              icon: const UlvenikIcon(UlvenikIcons.health, size: 22, color: kHealthGreen),
              title: 'Health Records',
              subtitle: count == 0
                  ? 'View and manage medical history'
                  : '$count ${count == 1 ? 'record' : 'records'} · View and manage medical history',
              onTap: () => _go(context, HealthRecordsHubScreen(dogName: dogName)),
            ),
            const SizedBox(height: 10),
            _shortcut(
              icon: const UlvenikIcon(UlvenikIcons.notifications, size: 22, color: kHealthGreen),
              title: 'Health Reminders',
              subtitle: upcoming.isEmpty
                  ? 'Upcoming care and scheduled tasks'
                  : 'Next: ${upcoming.first.title} · ${fmtShort(upcoming.first.due)}',
              onTap: () => _go(context, HealthRemindersListScreen(dogName: dogName)),
              trailing: IconButton(
                tooltip: 'Add Reminder',
                icon: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryForestGreen),
                onPressed: () => _go(context, HealthReminderForm(dogName: dogName)),
              ),
            ),
            const SizedBox(height: 24),
            const SectionLabel('Health Overview'),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _stat(
                icon: Icons.monitor_weight_outlined,
                label: 'Current Weight',
                value: weightValue,
                detail: weightDetail,
                onTap: () => _go(context, WeightRecordsScreen(dogName: dogName)),
              ),
              const SizedBox(width: 10),
              _stat(
                icon: Icons.accessibility_new_outlined,
                label: 'Body Condition',
                value: bcs.isEmpty ? 'Not recorded' : '${bcs.first.score} / 9',
                detail: bcs.isEmpty ? 'No entries' : 'Latest recorded score',
                onTap: () => _go(context, BodyConditionScreen(dogName: dogName)),
              ),
            ]),
            const SizedBox(height: 10),
            HealthCard(
              onTap: () => _go(context, WeightRecordsScreen(dogName: dogName)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const UlvenikIcon(UlvenikIcons.progress, size: 18, color: kHealthGreen),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Weight History',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const Text('All entries',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: points.isEmpty
                      ? const Center(
                          child: Text('No entries',
                              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)))
                      : IgnorePointer(
                          child: TrendChart(points: points, compact: true, format: (v) => fmtKg(v)),
                        ),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            SectionLabel(
              'Upcoming Health',
              trailing: TextButton(
                onPressed: () => _go(context, HealthRemindersListScreen(dogName: dogName)),
                child: const Text('View All Reminders',
                    style: TextStyle(color: AppColors.primaryForestGreen, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            if (shown.isEmpty)
              const HealthCard(
                child: Column(children: [
                  Icon(Icons.event_available_outlined, color: kHealthGreen, size: 26),
                  SizedBox(height: 10),
                  Text('No Upcoming Health Events',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Your dog’s upcoming appointments and reminders will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
                ]),
              )
            else
              for (final r in shown)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: HealthCard(
                    onTap: () => openReminder(context, dogName, r),
                    child: Row(children: [
                      reminderIcon(r, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(r.title,
                              style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${r.type.label} · ${reminderWhen(r)}',
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        ]),
                      ),
                      const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                    ]),
                  ),
                ),
          ],
        );
      },
    );
  }
}
