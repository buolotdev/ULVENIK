import 'package:flutter/material.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';
import '../widgets/period_sheet.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_record_session_screen.dart';
import 'sc_session_details_screen.dart';

/// S&C Sessions History for one dog: search by session name, date range and
/// newest/oldest sorting exactly like Training. S&C sessions only.
class SCSessionsHistoryScreen extends StatefulWidget {
  final String dogName;
  const SCSessionsHistoryScreen({super.key, required this.dogName});

  @override
  State<SCSessionsHistoryScreen> createState() => _SCSessionsHistoryScreenState();
}

class _SCSessionsHistoryScreenState extends State<SCSessionsHistoryScreen> {
  final _store = SCStore.instance;
  final _search = TextEditingController();
  String _period = 'Lifetime';
  bool _newest = true;

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
    _search.addListener(_refresh);
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _record() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => SCRecordSessionScreen(dogName: widget.dogName)));

  @override
  Widget build(BuildContext context) {
    final all = _store.sessions(widget.dogName);
    final q = _search.text.trim().toLowerCase();
    final from = periodStart(_period);
    final list = all
        .where((s) => (q.isEmpty || s.name.toLowerCase().contains(q)) && (from == null || !s.at.isBefore(from)))
        .toList();
    if (!_newest) list.sort((a, b) => a.at.compareTo(b.at));

    return HealthScaffold(
      title: 'S&C Sessions',
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.fitness_center,
                title: 'No S&C Sessions Yet',
                message: 'Start recording your dog’s strength and conditioning journey.',
                actionLabel: 'Record S&C Session',
                onAction: _record,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                TextField(
                  controller: _search,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                  decoration: healthDecoration('Search sessions...').copyWith(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: UlvenikIcon(UlvenikIcons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 4, children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      final p = await showPeriodSheet(context, _period);
                      if (p != null) setState(() => _period = p);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _period == 'Lifetime' ? AppColors.cardBorder : AppColors.primaryForestGreen),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        UlvenikIcon(UlvenikIcons.calendar, size: 15, color: AppColors.secondaryTextStoneGrey),
                        const SizedBox(width: 6),
                        Text('Date Range · $_period',
                            style: TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _newest = !_newest),
                    icon: AnimatedRotation(
                      turns: _newest ? 0 : 0.5,
                      duration: const Duration(milliseconds: 250),
                      child: UlvenikIcon(UlvenikIcons.sort, size: 16, color: AppColors.secondaryTextStoneGrey),
                    ),
                    label: Text(_newest ? 'Newest First' : 'Oldest First',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  ),
                ]),
                const SizedBox(height: 8),
                if (list.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('No sessions match your search or date range.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                    ),
                  ),
                for (final s in list) ...[
                  HealthCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SCSessionDetailsScreen(dogName: widget.dogName, sessionId: s.id)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.name,
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 3),
                          Text(
                            fmtDate(s.at) + (s.durationMinutes == null ? '' : ' · ${scDuration(s.durationMinutes!)}'),
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                          ),
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
  }
}
