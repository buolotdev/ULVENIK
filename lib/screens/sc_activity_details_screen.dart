import 'package:flutter/material.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_activity_form_screen.dart';
import 'sc_record_session_screen.dart';
import 'sc_session_details_screen.dart';

/// Activity Details: name, description, tracked measurements and the sessions
/// this activity was recorded in (newest first). No Update Progress: progress
/// comes only from recorded sessions.
class SCActivityDetailsScreen extends StatelessWidget {
  final String dogName;
  final String activityId;
  const SCActivityDetailsScreen({super.key, required this.dogName, required this.activityId});

  Future<void> _archive(BuildContext context, SCActivity a) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Archive Activity?',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'This activity will be removed from your active library. Your session history, measurements and statistics will be preserved, and you can restore it at any time.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Archive Activity', onPressed: () => Navigator.pop(ctx, true)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: AppColors.cardBorder)),
                child: Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              ),
            ),
          ]),
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    SCStore.instance.setArchived(dogName, a.id, true);
    AppSnackbar.show(context, message: 'Activity archived', type: SnackbarType.success);
    Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context, SCActivity a) async {
    final ok = await confirmDelete(context,
        title: 'Delete Activity?',
        message:
            'This activity will be permanently removed from your library and can no longer be selected. Your previous S&C sessions and their recorded measurements will be kept.');
    if (!ok || !context.mounted) return;
    SCStore.instance.deleteActivity(dogName, a.id);
    AppSnackbar.show(context, message: 'Activity deleted', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final store = SCStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final a = store.activity(dogName, activityId);
        if (a == null || a.deleted) return const HealthScaffold(title: 'Activity Details', body: SizedBox.shrink());
        final sessions = store.sessionsFor(dogName, a.id);

        return HealthScaffold(
          title: 'Activity Details',
          actions: [
            IconButton(
              tooltip: 'More',
              icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: AppColors.cardsCarbon,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (ctx) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                        leading: UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
                        title: Text('Edit Activity', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SCActivityFormScreen(dogName: dogName, activity: a)),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Archive Activity', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          _archive(context, a);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                        title: const Text('Delete Activity', style: TextStyle(color: Color(0xFFFFB4AB))),
                        onTap: () {
                          Navigator.pop(ctx);
                          _delete(context, a);
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(a.name,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 26, fontWeight: FontWeight.w700)),
              if (a.description.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(a.description,
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
              ],
              if (a.measures.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final m in SCMeasure.values)
                    if (a.measures.contains(m))
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardsCarbon,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          (a.units[m] ?? '').isEmpty ? m.label : '${m.label} (${a.units[m]})',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                        ),
                      ),
                ]),
              ],
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Record S&C Session',
                icon: UlvenikIcons.recordSession,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SCRecordSessionScreen(dogName: dogName, activityId: a.id)),
                ),
              ),
              const SizedBox(height: 26),
              const SectionLabel('Recorded Sessions'),
              if (sessions.isEmpty)
                const EmptyState(
                  icon: Icons.fitness_center,
                  title: 'No Sessions Recorded Yet',
                  message: 'Record your first session to start tracking this activity.',
                )
              else
                for (final s in sessions) ...[
                  HealthCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SCSessionDetailsScreen(dogName: dogName, sessionId: s.id)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.name,
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(fmtDate(s.at),
                              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                          Builder(builder: (_) {
                            final e = s.entries.firstWhere((x) => x.activityId == a.id);
                            if (e.values.isEmpty) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                [
                                  for (final m in SCMeasure.values)
                                    if (e.values.containsKey(m)) '${m.label}: ${scFormatValue(e.values[m]!)}',
                                ].join(' · '),
                                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                              ),
                            );
                          }),
                        ]),
                      ),
                      UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                    ]),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          ),
        );
      },
    );
  }
}
