import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/session_items_picker.dart';
import '../widgets/session_rating.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_record_session_screen.dart';
import 'session_templates_new.dart';

String scFormatValue(SCValue v) {
  final n = v.value == v.value.roundToDouble() ? v.value.toStringAsFixed(0) : v.value.toString();
  return v.unit.isEmpty ? n : '$n ${v.unit}';
}

String scDuration(int minutes) {
  final h = minutes ~/ 60, m = minutes % 60;
  if (h == 0) return '${m}m';
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}

/// S&C Session Details. ⋮ → Edit Session | Delete Session (no Archive).
class SCSessionDetailsScreen extends StatelessWidget {
  final String dogName;
  final String sessionId;
  const SCSessionDetailsScreen({super.key, required this.dogName, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final store = SCStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final s = store.session(dogName, sessionId);
        if (s == null) return const HealthScaffold(title: 'Session Details', body: SizedBox.shrink());

        Widget section(String title, Widget child) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SectionLabel(title),
                child,
              ]),
            );

        return HealthScaffold(
          title: 'Session Details',
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
                        title: Text('Edit Session', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SCRecordSessionScreen(dogName: dogName, session: s)),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Save as Template', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TemplateFormScreen(
                                dogName: dogName,
                                presetName: s.name,
                                presetActivityIds: [for (final e in s.entries) e.activityId],
                                presetRewards: s.rewards,
                                presetEquipment: s.equipment,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                        title: const Text('Delete Session', style: TextStyle(color: Color(0xFFFFB4AB))),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ok = await confirmDelete(context,
                              title: 'Delete session?',
                              message:
                                  'This session will be permanently deleted and removed from your statistics.');
                          if (!ok || !context.mounted) return;
                          MediaStore.instance.unlinkRecord(dogName, 'sc:${s.id}');
                          store.deleteSession(dogName, s.id);
                          AppSnackbar.show(context, message: 'Session deleted', type: SnackbarType.success);
                          Navigator.pop(context);
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
              Text(s.name,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('${fmtDate(s.at)} · ${fmtTime(s.at)}',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              if (s.durationMinutes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text('Duration: ${scDuration(s.durationMinutes!)}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                ),
              const SizedBox(height: 22),
              section(
                'Activities',
                Column(children: [
                  for (final e in s.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: HealthCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.activityName,
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                          if (e.values.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text('No measurements recorded',
                                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                            ),
                          for (final m in SCMeasure.values)
                            if (e.values.containsKey(m))
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(children: [
                                  Expanded(
                                    child: Text(m.label,
                                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                                  ),
                                  Text(scFormatValue(e.values[m]!),
                                      style: TextStyle(
                                          color: AppColors.primaryTextOffWhite, fontSize: 14.5, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                        ]),
                      ),
                    ),
                ]),
              ),
              if (s.rewards.isNotEmpty)
                section(SessionItemKind.rewards.usedTitle, Text(s.rewards.join(', '), style: _body)),
              if (s.equipment.isNotEmpty)
                section(SessionItemKind.equipment.usedTitle, Text(s.equipment.join(', '), style: _body)),
              if (s.notes.isNotEmpty) section('Notes', Text(s.notes, style: _body)),
              if (s.media.isNotEmpty) section('Photos and Videos', Text(s.media.join(', '), style: _body)),
              if (s.rating != null)
                section('Session Rating', SessionRatingBadge(rating: s.rating)),
            ],
          ),
        );
      },
    );
  }

  static TextStyle get _body => TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, height: 1.45);
}
