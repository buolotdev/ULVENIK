import 'package:flutter/material.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_activity_library_screen.dart';
import 'sc_analytics.dart';
import 'sc_record_session_screen.dart';
import 'sc_sessions_history_screen.dart';
import 'session_templates_new.dart';

/// Dog Profile > S&C tab: Activity Library card, S&C Sessions card with the
/// Record S&C Session button, then S&C Analytics. Uses the selected dog only.
class SCTab extends StatelessWidget {
  final String dogName;
  const SCTab({super.key, required this.dogName});

  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  Widget _iconBox(String icon) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: AppColors.primaryForestGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
        child: Padding(padding: const EdgeInsets.all(11), child: UlvenikIcon(icon, color: AppColors.secondarySage)),
      );

  @override
  Widget build(BuildContext context) {
    final store = SCStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final activities = store.activities(dogName).length;
        final sessions = store.sessions(dogName).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            HealthCard(
              onTap: () => _go(context, SCActivityLibraryScreen(dogName: dogName)),
              child: Row(children: [
                _iconBox(UlvenikIcons.strengthConditioning),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Activity Library',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('$activities ${activities == 1 ? 'activity' : 'activities'}',
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  ]),
                ),
                const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
              ]),
            ),
            const SizedBox(height: 10),
            HealthCard(
              onTap: () => _go(context, SCSessionsHistoryScreen(dogName: dogName)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  _iconBox(UlvenikIcons.recordSession),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('S&C Sessions',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('$sessions ${sessions == 1 ? 'session' : 'sessions'} recorded',
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: 'Record S&C Session',
                  icon: UlvenikIcons.recordSession,
                  onPressed: () => _go(context, SCRecordSessionScreen(dogName: dogName)),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            HealthCard(
              onTap: () => _go(context, SessionTemplatesScreen(dogName: dogName)),
              child: Row(children: [
                _iconBox(UlvenikIcons.strengthConditioning),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text('Session Templates',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
              ]),
            ),
            const SizedBox(height: 24),
            SCAnalytics(dogName: dogName),
          ],
        );
      },
    );
  }
}
