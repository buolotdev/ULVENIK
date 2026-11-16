import 'package:flutter/material.dart';
import '../data/trainer_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import 'timeline_common.dart';
import 'timeline_export_util.dart';

/// Client Report: homework counts for one client, with the denominator shown.
/// It contains only what the trainer assigned and recorded — never private
/// trainer notes — and invents no score.
class TrainerClientReportScreen extends StatefulWidget {
  final String clientId;
  const TrainerClientReportScreen({super.key, required this.clientId});

  @override
  State<TrainerClientReportScreen> createState() => _TrainerClientReportScreenState();
}

class _TrainerClientReportScreenState extends State<TrainerClientReportScreen> {
  TlPeriod _period = TlPeriod.lifetime;

  @override
  Widget build(BuildContext context) {
    final store = TrainerStore.instance;
    final c = store.client(widget.clientId);
    if (c == null) return const HealthScaffold(title: 'Client Report', body: SizedBox.shrink());
    final hw = store.homework(c.id).where((h) => h.assigned && _period.contains(h.createdAt)).toList();
    final done = hw.where((h) => h.progress == 'Completed').length;
    final progress = hw.where((h) => h.progress == 'In progress').length;
    final notStarted = hw.where((h) => h.progress == 'Not started').length;
    final overdue = hw.where((h) => h.timing == 'Overdue').length;

    final rows = <List<String>>[
      ['Measure', 'Value'],
      ['Client', c.name],
      ['Dogs', c.dogs.join('; ')],
      ['Period', _period.label],
      ['Homework assigned', '${hw.length}'],
      ['Completed', '$done'],
      ['In progress', '$progress'],
      ['Not started', '$notStarted'],
      ['Overdue (not completed)', '$overdue'],
    ];

    Widget stat(String k, String v) => Expanded(
          child: HealthCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(k, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              Text(v, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
            ]),
          ),
        );

    return HealthScaffold(
      title: 'Client Report',
      bottom: hw.isEmpty
          ? null
          : PrimaryButton(
              label: 'Export Report',
              onPressed: () async {
                final pdf = await showModalBottomSheet<bool>(
                  context: context,
                  backgroundColor: AppColors.cardsCarbon,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => SafeArea(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(title: const Text('PDF Document', style: TextStyle(color: AppColors.primaryTextOffWhite)), onTap: () => Navigator.pop(ctx, true)),
                      ListTile(title: const Text('CSV Spreadsheet', style: TextStyle(color: AppColors.primaryTextOffWhite)), onTap: () => Navigator.pop(ctx, false)),
                    ]),
                  ),
                );
                if (pdf == null || !context.mounted) return;
                await runExport(
                  context,
                  fileName: 'Ulvenik_Client_Report_${c.name.replaceAll(' ', '_')}_${exportStamp()}.${pdf ? 'pdf' : 'csv'}',
                  pdf: pdf,
                  build: () async => pdf
                      ? await tablePdf('Client Report', [c.name, _period.label, 'Homework assigned in your trainer journal. Private notes are not included.'], rows)
                      : tableCsv(rows),
                );
              },
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(c.name, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async {
              final p = await showTlPeriodSheet(context, _period);
              if (p != null) setState(() => _period = p);
            },
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: const BorderSide(color: Colors.white12),
                backgroundColor: AppColors.cardsCarbon,
                alignment: Alignment.centerLeft,
                minimumSize: const Size(double.infinity, 46)),
            child: Text('Homework assigned in: ${_period.label}'),
          ),
          const SizedBox(height: 14),
          if (hw.isEmpty)
            const EmptyState(
              icon: Icons.summarize_outlined,
              title: 'No Homework in This Period',
              message: 'Assign homework to this client to see a report here.',
            )
          else ...[
            Row(children: [stat('Assigned', '${hw.length}'), const SizedBox(width: 10), stat('Completed', '$done')]),
            const SizedBox(height: 10),
            Row(children: [stat('In progress', '$progress'), const SizedBox(width: 10), stat('Not started', '$notStarted')]),
            const SizedBox(height: 10),
            Row(children: [stat('Overdue', '$overdue'), const SizedBox(width: 10), const Spacer()]),
            const SizedBox(height: 14),
            Text('$done of ${hw.length} assigned tasks are completed. Counts are only for homework you assigned in the period above.',
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4)),
          ],
        ],
      ),
    );
  }
}
