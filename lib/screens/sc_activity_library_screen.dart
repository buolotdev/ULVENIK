import 'package:flutter/material.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'sc_activity_details_screen.dart';
import 'sc_activity_form_screen.dart';

String scSessionsLine(int count, DateTime? last) =>
    '$count ${count == 1 ? 'Session' : 'Sessions'} · ${last == null ? 'Not yet trained' : 'Last: ${fmtDate(last)}'}';

/// Activity Library for one dog: user-created activities only (no presets, no
/// categories, no favourites). Search + one Sort button, FAB to add, ⋮ menu
/// to Archived Activities.
class SCActivityLibraryScreen extends StatefulWidget {
  final String dogName;
  const SCActivityLibraryScreen({super.key, required this.dogName});

  @override
  State<SCActivityLibraryScreen> createState() => _SCActivityLibraryScreenState();
}

class _SCActivityLibraryScreenState extends State<SCActivityLibraryScreen> {
  static const _sortLabels = ['Recently Used', 'Alphabetical', 'Most Trained'];
  final _store = SCStore.instance;
  final _search = TextEditingController();
  int _sort = 0;

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

  void _showSort() => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sort Activities',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              for (var i = 0; i < _sortLabels.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_sortLabels[i], style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  trailing: _sort == i ? const Icon(Icons.check, color: Color(0xFF6FBF8E)) : null,
                  onTap: () {
                    setState(() => _sort = i);
                    Navigator.pop(ctx);
                  },
                ),
            ]),
          ),
        ),
      );

  void _openMenu() => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text('Archived Activities', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SCArchivedActivitiesScreen(dogName: widget.dogName)));
                },
              ),
            ]),
          ),
        ),
      );

  void _add() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => SCActivityFormScreen(dogName: widget.dogName)));

  @override
  Widget build(BuildContext context) {
    final all = _store.activities(widget.dogName);
    final q = _search.text.trim().toLowerCase();
    final list = all.where((a) => q.isEmpty || a.name.toLowerCase().contains(q)).toList();
    DateTime? last(SCActivity a) => _store.lastTrained(widget.dogName, a.id);
    switch (_sort) {
      case 1:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case 2:
        list.sort((a, b) =>
            _store.sessionCount(widget.dogName, b.id).compareTo(_store.sessionCount(widget.dogName, a.id)));
      default:
        list.sort((a, b) {
          final x = last(a), y = last(b);
          if (x == null && y == null) return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          if (x == null) return 1;
          if (y == null) return -1;
          return y.compareTo(x);
        });
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Activity Library',
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          tooltip: 'Back',
          icon: UlvenikIcon(UlvenikIcons.back, color: AppColors.secondaryTextStoneGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'More',
            icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
            onPressed: _openMenu,
          ),
        ],
      ),
      floatingActionButton: all.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _add,
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: AppColors.onForestGreen,
              elevation: 0,
              icon: const UlvenikIcon(UlvenikIcons.add, size: 20),
              label: const Text('Add Activity', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.fitness_center,
                title: 'No Activities Yet',
                message: 'Create your first strength and conditioning activity to get started.',
                actionLabel: 'Add Activity',
                onAction: _add,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                Row(children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(children: [
                        UlvenikIcon(UlvenikIcons.search, color: AppColors.secondaryTextStoneGrey, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _search,
                            cursorColor: AppColors.primaryForestGreen,
                            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search activities...',
                              hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (q.isNotEmpty)
                          GestureDetector(
                            onTap: _search.clear,
                            child: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                          ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _showSort,
                      icon: UlvenikIcon(UlvenikIcons.sort, size: 18, color: AppColors.secondaryTextStoneGrey),
                      label: const Text('Sort'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: BorderSide(color: AppColors.cardBorder),
                        backgroundColor: AppColors.cardsCarbon,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('No activities match your search.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                    ),
                  ),
                for (final a in list) ...[
                  SCActivityCard(
                    dogName: widget.dogName,
                    activity: a,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SCActivityDetailsScreen(dogName: widget.dogName, activityId: a.id)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class SCActivityCard extends StatelessWidget {
  final String dogName;
  final SCActivity activity;
  final VoidCallback onTap;
  final Widget? trailing;
  const SCActivityCard(
      {super.key, required this.dogName, required this.activity, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final store = SCStore.instance;
    return HealthCard(
      onTap: onTap,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: AppColors.primaryForestGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(11),
            child: UlvenikIcon(UlvenikIcons.strengthConditioning, color: AppColors.secondarySage),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(activity.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
            if (activity.description.trim().isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(activity.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.35)),
            ],
            const SizedBox(height: 6),
            Text(
              scSessionsLine(store.sessionCount(dogName, activity.id), store.lastTrained(dogName, activity.id)),
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
            ),
          ]),
        ),
        trailing ?? UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
      ]),
    );
  }
}

/// Archived Activities: restore from here. Back returns to the library with
/// its search and sort untouched.
class SCArchivedActivitiesScreen extends StatelessWidget {
  final String dogName;
  const SCArchivedActivitiesScreen({super.key, required this.dogName});

  @override
  Widget build(BuildContext context) {
    final store = SCStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final list = store.activities(dogName, archived: true);
        return HealthScaffold(
          title: 'Archived Activities',
          body: list.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Archived Activities',
                    message: 'Activities you archive will appear here.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final a in list) ...[
                      SCActivityCard(
                        dogName: dogName,
                        activity: a,
                        onTap: () {},
                        trailing: TextButton(
                          onPressed: () {
                            store.setArchived(dogName, a.id, false);
                            AppSnackbar.show(context, message: 'Activity restored', type: SnackbarType.success);
                          },
                          child: Text('Restore',
                              style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
