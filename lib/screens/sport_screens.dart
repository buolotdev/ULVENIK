import 'package:flutter/material.dart';
import '../data/sport_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'sport_competition_screens.dart';
import 'sport_items_screens.dart';
import 'sport_progress_screen.dart';
import 'sport_session_screens.dart';

Widget _iconBox(String icon) => Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
          color: AppColors.primaryForestGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
      child: Padding(padding: const EdgeInsets.all(11), child: UlvenikIcon(icon, color: AppColors.secondarySage)),
    );

Widget _chevron() => const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey);

void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

/// Dog Profile › Sport tab: My Sports, Sport Sessions (with Record Sport
/// Session) and Competitions & Trials, directly — no dashboard.
class SportTab extends StatelessWidget {
  final String dogName;
  const SportTab({super.key, required this.dogName});

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final sports = store.sports(dogName).length;
        final sessions = store.sessions(dogName).length;
        final comps = store.competitions(dogName).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            HealthCard(
              onTap: () => _go(context, MySportsScreen(dogName: dogName)),
              child: Row(children: [
                _iconBox(UlvenikIcons.goals),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('My Sports',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('$sports ${sports == 1 ? 'sport' : 'sports'}',
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  ]),
                ),
                _chevron(),
              ]),
            ),
            const SizedBox(height: 10),
            HealthCard(
              onTap: () => _go(context, SportSessionsHistoryScreen(dogName: dogName)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  _iconBox(UlvenikIcons.recordSession),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Sport Sessions',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('$sessions ${sessions == 1 ? 'session' : 'sessions'} recorded',
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  _chevron(),
                ]),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: 'Record Sport Session',
                  icon: UlvenikIcons.recordSession,
                  onPressed: () => _go(context, SportRecordSessionScreen(dogName: dogName)),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            HealthCard(
              onTap: () => _go(context, CompetitionsScreen(dogName: dogName)),
              child: Row(children: [
                _iconBox(UlvenikIcons.completed),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Competitions & Trials',
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('$comps ${comps == 1 ? 'competition' : 'competitions'}',
                        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  ]),
                ),
                _chevron(),
              ]),
            ),
          ],
        );
      },
    );
  }
}

/// My Sports: this dog's user-created sports. + adds a sport, ⋮ opens
/// Archived Sports. Search and sort live here and survive a visit to Archived.
class MySportsScreen extends StatefulWidget {
  final String dogName;
  const MySportsScreen({super.key, required this.dogName});

  @override
  State<MySportsScreen> createState() => _MySportsScreenState();
}

class _MySportsScreenState extends State<MySportsScreen> {
  static const _sortLabels = ['Most Sessions', 'Most Skills', 'Most Competitions', 'Alphabetical'];
  final _store = SportStore.instance;
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

  void _add() => _go(context, SportFormScreen(dogName: widget.dogName));

  void _showSort() => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Sort Sports',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              for (var i = 0; i < _sortLabels.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_sortLabels[i], style: const TextStyle(color: AppColors.primaryTextOffWhite)),
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
                title: const Text('Archived Sports', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _go(context, ArchivedSportsScreen(dogName: widget.dogName));
                },
              ),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final dog = widget.dogName;
    final all = _store.sports(dog);
    final q = _search.text.trim().toLowerCase();
    final list = all.where((s) => q.isEmpty || s.name.toLowerCase().contains(q)).toList();
    int sessions(Sport s) => _store.sessions(dog, sportId: s.id).length;
    int skills(Sport s) => _store.items(dog, s.id, kind: SportItemKind.skill).length;
    int comps(Sport s) => _store.competitions(dog, sportId: s.id).length;
    switch (_sort) {
      case 1:
        list.sort((a, b) => skills(b).compareTo(skills(a)));
      case 2:
        list.sort((a, b) => comps(b).compareTo(comps(a)));
      case 3:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      default:
        list.sort((a, b) => sessions(b).compareTo(sessions(a)));
    }

    return HealthScaffold(
      title: 'My Sports',
      actions: [
        IconButton(
          tooltip: 'Add Sport',
          icon: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryForestGreen),
          onPressed: _add,
        ),
        IconButton(
          tooltip: 'More',
          icon: const UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
          onPressed: _openMenu,
        ),
      ],
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.emoji_events_outlined,
                title: 'No Sports Yet',
                message: 'Add your first sport to start organising your dog’s sport training.',
                actionLabel: 'Add Sport',
                onAction: _add,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                      decoration: healthDecoration('Search sports...').copyWith(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: UlvenikIcon(UlvenikIcons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _showSort,
                      icon: const UlvenikIcon(UlvenikIcons.sort, size: 18, color: AppColors.secondaryTextStoneGrey),
                      label: const Text('Sort'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: const BorderSide(color: Colors.white12),
                        backgroundColor: AppColors.cardsCarbon,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('No sports match your search.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                    ),
                  ),
                for (final s in list) ...[
                  SportCard(
                    dogName: dog,
                    sport: s,
                    onTap: () => _go(context, SportDetailScreen(dogName: dog, sportId: s.id)),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class SportCard extends StatelessWidget {
  final String dogName;
  final Sport sport;
  final VoidCallback onTap;
  final Widget? trailing;
  const SportCard({super.key, required this.dogName, required this.sport, required this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    final skills = store.items(dogName, sport.id, kind: SportItemKind.skill).length;
    final exercises = store.items(dogName, sport.id, kind: SportItemKind.exercise).length;
    final sessions = store.sessions(dogName, sportId: sport.id).length;
    return HealthCard(
      onTap: onTap,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _iconBox(UlvenikIcons.goals),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sport.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
            if (sport.description.trim().isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(sport.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.35)),
            ],
            const SizedBox(height: 6),
            Text(
              '$skills ${skills == 1 ? 'Skill' : 'Skills'} · $exercises ${exercises == 1 ? 'Exercise' : 'Exercises'} · $sessions ${sessions == 1 ? 'Session' : 'Sessions'}',
              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
            ),
          ]),
        ),
        trailing ?? _chevron(),
      ]),
    );
  }
}

class ArchivedSportsScreen extends StatelessWidget {
  final String dogName;
  const ArchivedSportsScreen({super.key, required this.dogName});

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final list = store.sports(dogName, archived: true);
        return HealthScaffold(
          title: 'Archived Sports',
          body: list.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Archived Sports',
                    message: 'Sports you archive will appear here.',
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final s in list) ...[
                      SportCard(
                        dogName: dogName,
                        sport: s,
                        onTap: () {},
                        trailing: TextButton(
                          onPressed: () {
                            store.setSportArchived(dogName, s.id, false);
                            AppSnackbar.show(context, message: 'Sport restored', type: SnackbarType.success);
                          },
                          child: const Text('Restore Sport',
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

/// Add / Edit Sport: name required; description and notes optional.
class SportFormScreen extends StatefulWidget {
  final String dogName;
  final Sport? sport;
  const SportFormScreen({super.key, required this.dogName, this.sport});

  @override
  State<SportFormScreen> createState() => _SportFormScreenState();
}

class _SportFormScreenState extends State<SportFormScreen> {
  late final _name = TextEditingController(text: widget.sport?.name ?? '');
  late final _desc = TextEditingController(text: widget.sport?.description ?? '');
  late final _notes = TextEditingController(text: widget.sport?.notes ?? '');
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Please enter a sport name.');
      return;
    }
    _saving = true;
    final store = SportStore.instance;
    final s = widget.sport ?? Sport(id: store.newId(), name: '');
    s
      ..name = _name.text.trim()
      ..description = _desc.text.trim()
      ..notes = _notes.text.trim();
    store.saveSport(widget.dogName, s);
    AppSnackbar.show(context, message: 'Sport saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: widget.sport == null ? 'Add Sport' : 'Edit Sport',
      bottom: PrimaryButton(label: 'Save Sport', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Sport Name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => _error == null ? null : setState(() => _error = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter sport name', error: _error),
          ),
          const FieldLabel('Description'),
          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: 5,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Describe this sport...'),
          ),
          const FieldLabel('Notes'),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 5,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add notes...'),
          ),
        ],
      ),
    );
  }
}

/// Individual sport: Sport Skills & Exercises, Sport Sessions, Sport Progress
/// (and Competitions & Trials filtered to this sport).
class SportDetailScreen extends StatelessWidget {
  final String dogName;
  final String sportId;
  const SportDetailScreen({super.key, required this.dogName, required this.sportId});

  Future<void> _archive(BuildContext context, Sport s) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Archive Sport?',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'This sport will be hidden from My Sports. Its skills, exercises, sessions, competitions and attachments are kept, and you can restore it at any time.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Archive Sport', onPressed: () => Navigator.pop(ctx, true)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: Colors.white12)),
                child: const Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              ),
            ),
          ]),
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    SportStore.instance.setSportArchived(dogName, s.id, true);
    AppSnackbar.show(context, message: 'Sport archived', type: SnackbarType.success);
    Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context, Sport s) async {
    final ok = await confirmDelete(context,
        title: 'Delete Sport?',
        message:
            'This sport will be removed from My Sports. Your previous sport sessions and competitions will be kept and will still show this sport’s name. Other sports are not affected.');
    if (!ok || !context.mounted) return;
    SportStore.instance.deleteSport(dogName, s.id);
    AppSnackbar.show(context, message: 'Sport deleted', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final store = SportStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final s = store.sport(dogName, sportId);
        if (s == null || s.deleted) return const HealthScaffold(title: 'Sport', body: SizedBox.shrink());
        final skills = store.items(dogName, s.id, kind: SportItemKind.skill).length;
        final exercises = store.items(dogName, s.id, kind: SportItemKind.exercise).length;
        final sessions = store.sessions(dogName, sportId: s.id).length;
        final comps = store.competitions(dogName, sportId: s.id).length;

        Widget card(String icon, String title, String subtitle, String action, VoidCallback onTap) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HealthCard(
                onTap: onTap,
                child: Row(children: [
                  _iconBox(icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title,
                          style: const TextStyle(
                              color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      const SizedBox(height: 6),
                      Text(action,
                          style: const TextStyle(
                              color: AppColors.primaryForestGreen, fontSize: 13, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  _chevron(),
                ]),
              ),
            );

        return HealthScaffold(
          title: s.name,
          actions: [
            IconButton(
              tooltip: 'More',
              icon: const UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: AppColors.cardsCarbon,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (ctx) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                        leading: const UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
                        title: const Text('Edit Sport', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          _go(context, SportFormScreen(dogName: dogName, sport: s));
                        },
                      ),
                      ListTile(
                        title: const Text('Archive Sport', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          _archive(context, s);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                        title: const Text('Delete Sport', style: TextStyle(color: Color(0xFFFFB4AB))),
                        onTap: () {
                          Navigator.pop(ctx);
                          _delete(context, s);
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
              if (s.description.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(s.description,
                      style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.45)),
                ),
              card(UlvenikIcons.skills, 'Sport Skills & Exercises',
                  '$skills ${skills == 1 ? 'skill' : 'skills'} · $exercises ${exercises == 1 ? 'exercise' : 'exercises'}',
                  'View Skills & Exercises', () => _go(context, SportItemsScreen(dogName: dogName, sportId: s.id))),
              card(UlvenikIcons.recordSession, 'Sport Sessions', '$sessions ${sessions == 1 ? 'session' : 'sessions'} recorded',
                  'View Sport Sessions', () => _go(context, SportSessionsHistoryScreen(dogName: dogName, sportId: s.id))),
              card(UlvenikIcons.progress, 'Sport Progress', 'Training in ${s.name}', 'View Progress',
                  () => _go(context, SportProgressScreen(dogName: dogName, sportId: s.id))),
              card(UlvenikIcons.completed, 'Competitions & Trials',
                  '$comps ${comps == 1 ? 'competition' : 'competitions'}', 'View Competitions',
                  () => _go(context, CompetitionsScreen(dogName: dogName, sportId: s.id))),
              if (s.notes.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                const SectionLabel('Notes'),
                Text(s.notes,
                    style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, height: 1.45)),
              ],
            ],
          ),
        );
      },
    );
  }
}
