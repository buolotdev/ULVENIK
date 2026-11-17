import 'package:flutter/material.dart';
import '../data/sport_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'sport_session_screens.dart';
import 'skills_list_screen.dart' show coreSkillNames;

/// Sport Skills & Exercises for one sport: user-created only.
class SportItemsScreen extends StatelessWidget {
  final String dogName;
  final String sportId;
  final bool archived;
  const SportItemsScreen({super.key, required this.dogName, required this.sportId, this.archived = false});

  /// Links an existing Core Training skill to this sport. It is one skill:
  /// nothing is duplicated in Training.
  Future<void> _linkCore(BuildContext context) async {
    final store = SportStore.instance;
    final have = store.items(dogName, sportId).followedBy(store.items(dogName, sportId, archived: true)).where((i) => i.linked).map((i) => i.name.toLowerCase()).toSet();
    final options = coreSkillNames().where((n) => !have.contains(n.toLowerCase())).toList();
    if (options.isEmpty) {
      AppSnackbar.show(context, message: 'Every Training skill is already linked to this sport.', type: SnackbarType.info);
      return;
    }
    final chosen = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final draft = <String>{};
        return StatefulBuilder(
          builder: (ctx, setSheet) => SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                Text('Link Training skills',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final n in options)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryForestGreen,
                    checkColor: AppColors.primaryTextOffWhite,
                    title: Text(n, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                    value: draft.contains(n),
                    onChanged: (v) => setSheet(() => v == true ? draft.add(n) : draft.remove(n)),
                  ),
                const SizedBox(height: 8),
                PrimaryButton(label: 'Link', onPressed: () => Navigator.pop(ctx, draft)),
              ]),
            ),
          ),
        );
      },
    );
    if (chosen == null || chosen.isEmpty) return;
    for (final n in chosen) {
      store.saveItem(dogName, SportItem(id: store.newId(), sportId: sportId, kind: SportItemKind.skill, name: n, linked: true));
    }
    if (context.mounted) AppSnackbar.show(context, message: 'Skills linked', type: SnackbarType.success);
  }

  void _add(BuildContext context, SportItemKind kind) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SportItemFormScreen(dogName: dogName, sportId: sportId, kind: kind)),
      );

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final skills = store.items(dogName, sportId, kind: SportItemKind.skill, archived: archived);
        final exercises = store.items(dogName, sportId, kind: SportItemKind.exercise, archived: archived);
        final empty = skills.isEmpty && exercises.isEmpty;

        Widget tile(SportItem i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HealthCard(
                onTap: archived
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SportItemDetailsScreen(dogName: dogName, itemId: i.id)),
                        ),
                child: Row(children: [
                  UlvenikIcon(i.kind == SportItemKind.skill ? UlvenikIcons.skills : UlvenikIcons.exercises,
                      size: 22, color: AppColors.secondarySage),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(i.name,
                          style: TextStyle(
                              color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      if (i.linked)
                        Text('Linked from Training', style: TextStyle(color: AppColors.secondarySage, fontSize: 12.5)),
                      if (i.description.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(i.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        ),
                    ]),
                  ),
                  if (archived)
                    TextButton(
                      onPressed: () {
                        store.setItemArchived(dogName, i.id, false);
                        AppSnackbar.show(context, message: '${i.kindLabel} restored', type: SnackbarType.success);
                      },
                      child: Text('Restore',
                          style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                    )
                  else
                    UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
            );

        return HealthScaffold(
          title: archived ? 'Archived Skills & Exercises' : 'Skills & Exercises',
          actions: archived
              ? null
              : [
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
                              title: Text('Link a Training skill', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                              onTap: () {
                                Navigator.pop(ctx);
                                _linkCore(context);
                              },
                            ),
                            ListTile(
                              title: Text('Archived Skills & Exercises',
                                  style: TextStyle(color: AppColors.primaryTextOffWhite)),
                              onTap: () {
                                Navigator.pop(ctx);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SportItemsScreen(dogName: dogName, sportId: sportId, archived: true)),
                                );
                              },
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
          bottom: archived
              ? null
              : Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _add(context, SportItemKind.exercise),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: BorderSide(color: AppColors.cardBorder),
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add Exercise'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _add(context, SportItemKind.skill),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: AppColors.onForestGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Add Skill', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ]),
          body: empty
              ? Center(
                  child: EmptyState(
                    icon: Icons.fitness_center,
                    title: archived ? 'No Archived Skills or Exercises' : 'No Skills or Exercises Yet',
                    message: archived
                        ? 'Skills and exercises you archive will appear here.'
                        : 'Add your first skill or exercise for this sport.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    if (skills.isNotEmpty) ...[const SectionLabel('Skills'), for (final i in skills) tile(i)],
                    if (exercises.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const SectionLabel('Exercises'),
                      for (final i in exercises) tile(i),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

class SportItemFormScreen extends StatefulWidget {
  final String dogName;
  final String sportId;
  final SportItemKind kind;
  final SportItem? item;
  const SportItemFormScreen({super.key, required this.dogName, required this.sportId, required this.kind, this.item});

  @override
  State<SportItemFormScreen> createState() => _SportItemFormScreenState();
}

class _SportItemFormScreenState extends State<SportItemFormScreen> {
  late final _name = TextEditingController(text: widget.item?.name ?? '');
  late final _desc = TextEditingController(text: widget.item?.description ?? '');
  String? _error;
  bool _saving = false;

  String get _noun => widget.kind == SportItemKind.skill ? 'Skill' : 'Exercise';

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Please enter a ${_noun.toLowerCase()} name.');
      return;
    }
    _saving = true;
    final store = SportStore.instance;
    final i = widget.item ??
        SportItem(id: store.newId(), sportId: widget.sportId, kind: widget.kind, name: '');
    i
      ..name = _name.text.trim()
      ..description = _desc.text.trim();
    store.saveItem(widget.dogName, i);
    AppSnackbar.show(context, message: '$_noun saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sport = SportStore.instance.sport(widget.dogName, widget.sportId);
    return HealthScaffold(
      title: widget.item == null ? 'Add $_noun' : 'Edit $_noun',
      bottom: PrimaryButton(label: 'Save $_noun', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Sport'),
          HealthCard(
            child: Text(sport?.name ?? 'Sport',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
          ),
          FieldLabel('$_noun Name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => _error == null ? null : setState(() => _error = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter ${_noun.toLowerCase()} name', error: _error),
          ),
          const FieldLabel('Description'),
          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: 5,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Describe this ${_noun.toLowerCase()}...'),
          ),
        ],
      ),
    );
  }
}

/// Skill / Exercise details for a sport item: its description and the sport
/// sessions it appears in. ⋮ Edit / Archive / Delete.
class SportItemDetailsScreen extends StatelessWidget {
  final String dogName;
  final String itemId;
  const SportItemDetailsScreen({super.key, required this.dogName, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final i = store.item(dogName, itemId);
        if (i == null || i.deleted) return const HealthScaffold(title: 'Details', body: SizedBox.shrink());
        final sessions = store.sessions(dogName).where((s) => s.entries.any((e) => e.itemIds.contains(i.id))).toList();

        return HealthScaffold(
          title: '${i.kindLabel} Details',
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
                        title: Text('Edit ${i.kindLabel}', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SportItemFormScreen(
                                    dogName: dogName, sportId: i.sportId, kind: i.kind, item: i)),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Archive ${i.kindLabel}', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          store.setItemArchived(dogName, i.id, true);
                          AppSnackbar.show(context, message: '${i.kindLabel} archived', type: SnackbarType.success);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                        title: Text('Delete ${i.kindLabel}', style: const TextStyle(color: Color(0xFFFFB4AB))),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final ok = await confirmDelete(context,
                              title: 'Delete ${i.kindLabel}?',
                              message:
                                  'This ${i.kindLabel.toLowerCase()} will be removed from the sport. Your previous sport sessions will be kept.');
                          if (!ok || !context.mounted) return;
                          store.deleteItem(dogName, i.id);
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
              Text(i.name,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 26, fontWeight: FontWeight.w700)),
              if (i.description.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(i.description,
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
              ],
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Record Sport Session',
                icon: UlvenikIcons.recordSession,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SportRecordSessionScreen(dogName: dogName, sportId: i.sportId)),
                ),
              ),
              const SizedBox(height: 26),
              const SectionLabel('Recorded Sessions'),
              if (sessions.isEmpty)
                const EmptyState(
                  icon: Icons.fitness_center,
                  title: 'No Sessions Recorded Yet',
                  message: 'Record your first session to start tracking this.',
                )
              else
                for (final s in sessions) ...[
                  HealthCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SportSessionDetailsScreen(dogName: dogName, sessionId: s.id)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s.name,
                              style: TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                          Text(fmtDate(s.at),
                              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
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
