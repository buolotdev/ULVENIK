import 'package:flutter/material.dart';
import '../data/trainer_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'trainer_access_screen.dart';
import 'trainer_report_screen.dart';

void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

class _Filters {
  String status = 'All current'; // All current | Active | Inactive | Archived
  bool homework = false; // outstanding homework only
  bool pinned = false;
  bool get active => status != 'All current' || homework || pinned;
  _Filters copy() => _Filters()
    ..status = status
    ..homework = homework
    ..pinned = pinned;
}

/// Trainer Clients: the clients this trainer entered. One search, staged
/// filters, one Add Client, one menu per card. Pinned clients stay on top.
class TrainerClientsScreen extends StatefulWidget {
  const TrainerClientsScreen({super.key});

  @override
  State<TrainerClientsScreen> createState() => _TrainerClientsScreenState();
}

class _TrainerClientsScreenState extends State<TrainerClientsScreen> {
  final _store = TrainerStore.instance;
  final _search = TextEditingController();
  _Filters _filters = _Filters();

  @override
  void initState() {
    super.initState();
    _store.addListener(_r);
    _search.addListener(_r);
  }

  @override
  void dispose() {
    _store.removeListener(_r);
    _search.dispose();
    super.dispose();
  }

  void _r() {
    if (mounted) setState(() {});
  }

  List<TrainerClient> _visible() {
    final q = _search.text.trim().toLowerCase();
    final f = _filters;
    final l = _store.clients().where((c) {
      switch (f.status) {
        case 'Active':
          if (c.archived || !c.active) return false;
        case 'Inactive':
          if (c.archived || c.active) return false;
        case 'Archived':
          if (!c.archived) return false;
        default:
          if (c.archived) return false;
      }
      if (f.homework && _store.outstandingCount(c.id) == 0) return false;
      if (f.pinned && !c.pinned) return false;
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.dogs.any((d) => d.toLowerCase().contains(q));
    }).toList();
    l.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return l;
  }

  Future<void> _openFilters() async {
    final draft = _filters.copy();
    final applied = await showModalBottomSheet<_Filters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Filter clients',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SectionLabel('Status'),
              ChoiceRow(
                options: const ['All current', 'Active', 'Inactive', 'Archived'],
                value: draft.status,
                onChanged: (v) => setSheet(() => draft.status = v),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primaryForestGreen,
                title: const Text('Outstanding homework', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                value: draft.homework,
                onChanged: (v) => setSheet(() => draft.homework = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primaryForestGreen,
                title: const Text('Pinned only', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                value: draft.pinned,
                onChanged: (v) => setSheet(() => draft.pinned = v),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setSheet(() {
                      draft
                        ..status = 'All current'
                        ..homework = false
                        ..pinned = false;
                    }),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryTextOffWhite,
                        side: const BorderSide(color: Colors.white24),
                        minimumSize: const Size(0, 50)),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: PrimaryButton(label: 'Apply Filters', onPressed: () => Navigator.pop(ctx, draft))),
              ]),
            ]),
          ),
        ),
      ),
    );
    if (applied != null) setState(() => _filters = applied);
  }

  void _menu(TrainerClient c) => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: const Text('Edit Client Details', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _go(context, ClientFormScreen(client: c));
                },
              ),
              ListTile(
                title: Text(c.pinned ? 'Unpin Client' : 'Pin Client', style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  c.pinned = !c.pinned;
                  _store.touchClient();
                },
              ),
              ListTile(
                title: const Text('Client Notes', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _go(context, ClientNotesScreen(clientId: c.id));
                },
              ),
              ListTile(
                title: Text(c.archived ? 'Restore Client' : 'Archive Client', style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  archiveClient(context, c);
                },
              ),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final all = _store.clients();
    final list = _visible();
    final searching = _search.text.trim().isNotEmpty || _filters.active;

    return HealthScaffold(
      title: 'Clients',
      actions: [
        IconButton(
          tooltip: 'Add Client',
          icon: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryForestGreen),
          onPressed: () => _go(context, const ClientFormScreen()),
        ),
      ],
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.groups_outlined,
                title: 'No Clients Yet',
                message: 'Add your first client to keep their dogs, homework and notes together.',
                actionLabel: 'Add Client',
                onAction: () => _go(context, const ClientFormScreen()),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                      decoration: healthDecoration('Search clients...').copyWith(
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
                    width: 48,
                    child: OutlinedButton(
                      onPressed: _openFilters,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.cardsCarbon,
                        side: BorderSide(color: _filters.active ? AppColors.primaryForestGreen : Colors.white12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Icon(Icons.tune,
                          color: _filters.active ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey),
                    ),
                  ),
                ]),
                if (_filters.active)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(spacing: 8, runSpacing: 6, children: [
                      if (_filters.status != 'All current')
                        InputChip(
                          label: Text(_filters.status),
                          onDeleted: () => setState(() => _filters.status = 'All current'),
                          backgroundColor: AppColors.cardsCarbon,
                          side: const BorderSide(color: Colors.white12),
                          labelStyle: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5),
                        ),
                      if (_filters.homework)
                        InputChip(
                          label: const Text('Outstanding homework'),
                          onDeleted: () => setState(() => _filters.homework = false),
                          backgroundColor: AppColors.cardsCarbon,
                          side: const BorderSide(color: Colors.white12),
                          labelStyle: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5),
                        ),
                      if (_filters.pinned)
                        InputChip(
                          label: const Text('Pinned'),
                          onDeleted: () => setState(() => _filters.pinned = false),
                          backgroundColor: AppColors.cardsCarbon,
                          side: const BorderSide(color: Colors.white12),
                          labelStyle: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5),
                        ),
                    ]),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('${list.length} ${list.length == 1 ? 'client' : 'clients'}',
                      style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                ),
                if (list.isEmpty && searching)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(children: [
                      const Text('No clients match',
                          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      const Text('Try another search or change your filters.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                      TextButton(
                        onPressed: () {
                          _search.clear();
                          setState(() => _filters = _Filters());
                        },
                        child: const Text('Clear search and filters',
                            style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                for (final c in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HealthCard(
                      onTap: () => _go(context, ClientDetailScreen(clientId: c.id)),
                      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Flexible(
                                child: Text(c.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                              if (c.pinned)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.push_pin_outlined, size: 16, color: AppColors.primaryForestGreen),
                                ),
                            ]),
                            if (c.dogs.isNotEmpty)
                              Text(c.dogs.join(', '),
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                            Builder(builder: (_) {
                              final n = _store.outstandingCount(c.id);
                              final bits = [
                                if (!c.active && !c.archived) 'Inactive',
                                if (c.archived) 'Archived',
                                if (n > 0) '$n outstanding homework',
                              ];
                              return bits.isEmpty
                                  ? const SizedBox.shrink()
                                  : Text(bits.join(' · '),
                                      style: const TextStyle(color: AppColors.secondarySage, fontSize: 12.5));
                            }),
                          ]),
                        ),
                        IconButton(
                          tooltip: 'Client options',
                          icon: const UlvenikIcon(UlvenikIcons.more, size: 20, color: AppColors.secondaryTextStoneGrey),
                          onPressed: () => _menu(c),
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Archive / Restore a client. Their dogs, homework and notes are kept.
Future<void> archiveClient(BuildContext context, TrainerClient c) async {
  final restoring = c.archived;
  if (!restoring) {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Archive client?',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
                '${c.name} will leave your current clients. Their dogs, homework and notes are kept, and you can restore them any time.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, height: 1.4)),
            const SizedBox(height: 18),
            PrimaryButton(label: 'Archive Client', onPressed: () => Navigator.pop(ctx, true)),
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
    if (ok != true) return;
  }
  c.archived = !restoring;
  final saved = await TrainerStore.instance.touchClient();
  if (context.mounted) {
    AppSnackbar.show(context,
        message: saved ? (restoring ? 'Client restored' : 'Client archived') : 'That change couldn’t be saved.',
        type: saved ? SnackbarType.success : SnackbarType.error);
  }
}

/// Add / Edit Client. Only the name is required.
class ClientFormScreen extends StatefulWidget {
  final TrainerClient? client;
  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  late final _name = TextEditingController(text: widget.client?.name ?? '');
  late final _email = TextEditingController(text: widget.client?.email ?? '');
  late final _phone = TextEditingController(text: widget.client?.phone ?? '');
  late final _dogInput = TextEditingController();
  late List<String> _dogs = [...?widget.client?.dogs];
  late DateTime _since = widget.client?.clientSince ?? DateTime.now();
  late bool _active = widget.client?.active ?? true;
  String? _nameError;
  String? _emailError;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _dogInput.dispose();
    super.dispose();
  }

  void _addDog() {
    final d = _dogInput.text.trim();
    if (d.isEmpty || _dogs.any((e) => e.toLowerCase() == d.toLowerCase())) {
      _dogInput.clear();
      return;
    }
    setState(() => _dogs = [..._dogs, d]);
    _dogInput.clear();
  }

  Future<void> _save() async {
    if (_saving) return;
    final email = _email.text.trim();
    setState(() {
      _nameError = _name.text.trim().isEmpty ? 'Enter the client’s name.' : null;
      _emailError = email.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
          ? 'Enter a valid email address.'
          : null;
    });
    if (_nameError != null || _emailError != null) return;
    if (_dogInput.text.trim().isNotEmpty) _addDog();
    setState(() => _saving = true);
    final store = TrainerStore.instance;
    final c = widget.client ?? TrainerClient(id: store.newId(), name: '');
    c
      ..name = _name.text.trim()
      ..email = email
      ..phone = _phone.text.trim()
      ..dogs = _dogs
      ..clientSince = _since
      ..active = _active;
    final ok = await store.saveClient(c);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      AppSnackbar.show(context,
          message: 'Your changes couldn’t be saved. They’re still here — try again.', type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: widget.client == null ? 'Add Client' : 'Edit Client Details',
      bottom: PrimaryButton(label: 'Save Changes', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Client name', required: true),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => _nameError == null ? null : setState(() => _nameError = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter the client’s name', error: _nameError),
          ),
          const FieldLabel('Email'),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => _emailError == null ? null : setState(() => _emailError = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter an email address', error: _emailError),
          ),
          const FieldLabel('Phone'),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter a phone number'),
          ),
          const FieldLabel('Dogs'),
          if (_dogs.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 6, children: [
              for (final d in _dogs)
                InputChip(
                  label: Text(d, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                  backgroundColor: AppColors.cardsCarbon,
                  side: const BorderSide(color: Colors.white12),
                  deleteIconColor: AppColors.secondaryTextStoneGrey,
                  onDeleted: () => setState(() => _dogs = [..._dogs]..remove(d)),
                ),
            ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _dogInput,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (_) => _addDog(),
                style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('Enter a dog’s name'),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: _addDog,
              child: const Text('Add dog', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
          ]),
          const FieldLabel('Client since'),
          DateField(value: _since, onChanged: (d) => setState(() => _since = d), allowFuture: false),
          const FieldLabel('Status'),
          ChoiceRow(
            options: const ['Active', 'Inactive'],
            value: _active ? 'Active' : 'Inactive',
            onChanged: (v) => setState(() => _active = v == 'Active'),
          ),
        ],
      ),
    );
  }
}

/// Client detail: identity, linked dogs, outstanding homework and the actions
/// a trainer needs. Contact details are shown only when saved.
class ClientDetailScreen extends StatelessWidget {
  final String clientId;
  const ClientDetailScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final store = TrainerStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final c = store.client(clientId);
        if (c == null) {
          return const HealthScaffold(
            title: 'Client',
            body: Center(
              child: EmptyState(icon: Icons.info_outline, title: 'Client unavailable', message: 'This client is no longer available.'),
            ),
          );
        }
        final out = store.outstandingCount(c.id);
        Widget row(String k, String v) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 120, child: Text(k, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5))),
                Expanded(child: Text(v, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5))),
              ]),
            );
        return HealthScaffold(
          title: 'Client',
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
                        title: const Text('Edit Client Details', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          _go(context, ClientFormScreen(client: c));
                        },
                      ),
                      ListTile(
                        title: Text(c.pinned ? 'Unpin Client' : 'Pin Client', style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          c.pinned = !c.pinned;
                          store.touchClient();
                        },
                      ),
                      ListTile(
                        title: Text(c.archived ? 'Restore Client' : 'Archive Client', style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          archiveClient(context, c);
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Row(children: [
                Expanded(
                  child: Text(c.name,
                      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
                ),
                if (c.pinned) const Icon(Icons.push_pin_outlined, color: AppColors.primaryForestGreen),
              ]),
              const SizedBox(height: 14),
              HealthCard(
                child: Column(children: [
                  row('Client since', fmtDate(c.clientSince)),
                  row('Status', c.archived ? 'Archived' : (c.active ? 'Active' : 'Inactive')),
                  if (c.email.isNotEmpty) row('Email', c.email),
                  if (c.phone.isNotEmpty) row('Phone', c.phone),
                  row('Client dogs', c.dogs.isEmpty ? 'No dogs added' : c.dogs.join(', ')),
                  row('Next session', 'No session scheduled'),
                ]),
              ),
              const SizedBox(height: 16),
              PrimaryButton(label: 'Assign Homework', onPressed: () => _go(context, HomeworkFormScreen(clientId: c.id))),
              const SizedBox(height: 10),
              HealthCard(
                onTap: () => _go(context, HomeworkListScreen(clientId: c.id)),
                child: Row(children: [
                  const Icon(Icons.assignment_outlined, color: AppColors.secondarySage),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Homework', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('$out outstanding', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
              const SizedBox(height: 10),
              HealthCard(
                onTap: () => _go(context, TrainerClientReportScreen(clientId: c.id)),
                child: Row(children: [
                  const Icon(Icons.summarize_outlined, color: AppColors.secondarySage),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text('Client Report', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
              const SizedBox(height: 10),
              HealthCard(
                onTap: () => _go(context, TrainerAccessScreen(clientId: c.id)),
                child: Row(children: [
                  const Icon(Icons.verified_user_outlined, color: AppColors.secondarySage),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text('Trainer Access', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
              const SizedBox(height: 10),
              HealthCard(
                onTap: () => _go(context, ClientNotesScreen(clientId: c.id)),
                child: Row(children: [
                  const Icon(Icons.sticky_note_2_outlined, color: AppColors.secondarySage),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Trainer Notes', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('${store.notes(c.id).length} private ${store.notes(c.id).length == 1 ? 'note' : 'notes'}',
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                    ]),
                  ),
                  const UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Homework for one client: progress and due timing are separate.
class HomeworkListScreen extends StatelessWidget {
  final String clientId;
  const HomeworkListScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final store = TrainerStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final list = store.homework(clientId);
        return HealthScaffold(
          title: 'Homework (${list.length})',
          bottom: list.isEmpty ? null : PrimaryButton(label: 'Add Homework', icon: UlvenikIcons.add, onPressed: () => _go(context, HomeworkFormScreen(clientId: clientId))),
          body: list.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.assignment_outlined,
                    title: 'No Homework Yet',
                    message: 'Assign a task for this client and their dog to practise.',
                    actionLabel: 'Add Homework',
                    onAction: () => _go(context, HomeworkFormScreen(clientId: clientId)),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final h in list)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: HealthCard(
                          // Opening a row shows the assignment; it never changes progress.
                          onTap: () => _go(context, HomeworkFormScreen(clientId: clientId, homework: h)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(h.title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(h.dog.isEmpty ? 'No dog selected' : h.dog,
                                style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                            const SizedBox(height: 4),
                            Text([if (!h.assigned) 'Draft', h.progress, h.timing].join(' · '),
                                style: TextStyle(
                                    color: h.timing == 'Overdue' ? const Color(0xFFE08A8A) : AppColors.secondarySage, fontSize: 12.5)),
                          ]),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

/// Assign Homework (also edits one). Title is required. This saves to the
/// trainer's journal only — nothing is sent to the client.
class HomeworkFormScreen extends StatefulWidget {
  final String clientId;
  final Homework? homework;
  const HomeworkFormScreen({super.key, required this.clientId, this.homework});

  @override
  State<HomeworkFormScreen> createState() => _HomeworkFormScreenState();
}

class _HomeworkFormScreenState extends State<HomeworkFormScreen> {
  late final _title = TextEditingController(text: widget.homework?.title ?? '');
  late final _instr = TextEditingController(text: widget.homework?.instructions ?? '');
  late String? _dog = widget.homework?.dog.isEmpty ?? true ? null : widget.homework!.dog;
  late DateTime? _due = widget.homework?.due;
  late String _progress = widget.homework?.progress ?? 'Not started';
  String? _titleError;
  String? _dogError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final dogs = TrainerStore.instance.client(widget.clientId)?.dogs ?? [];
    if (_dog == null && dogs.length == 1) _dog = dogs.first;
  }

  @override
  void dispose() {
    _title.dispose();
    _instr.dispose();
    super.dispose();
  }

  Future<void> _save({required bool assign}) async {
    if (_saving) return;
    final dogs = TrainerStore.instance.client(widget.clientId)?.dogs ?? [];
    setState(() {
      _titleError = _title.text.trim().isEmpty ? 'Enter a task title.' : null;
      _dogError = dogs.isNotEmpty && _dog == null ? 'Choose a dog.' : null;
    });
    if (_titleError != null || _dogError != null) return;
    setState(() => _saving = true);
    final store = TrainerStore.instance;
    final h = widget.homework ?? Homework(id: store.newId(), clientId: widget.clientId, dog: '', title: '');
    h
      ..title = _title.text.trim()
      ..instructions = _instr.text.trim()
      ..dog = _dog ?? ''
      ..due = _due
      ..progress = _progress
      ..assigned = assign || h.assigned;
    final ok = await store.saveHomework(h);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      AppSnackbar.show(context,
          message: 'Your changes couldn’t be saved. They’re still here — try again.', type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = TrainerStore.instance.client(widget.clientId);
    final dogs = client?.dogs ?? [];
    final editing = widget.homework != null;
    return HealthScaffold(
      title: editing ? 'Homework' : 'Assign Homework',
      actions: editing
          ? [
              IconButton(
                tooltip: 'Delete homework',
                icon: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                onPressed: () async {
                  final ok = await confirmDelete(context,
                      title: 'Delete homework?', message: 'This homework task will be permanently deleted.');
                  if (!ok || !context.mounted) return;
                  await TrainerStore.instance.deleteHomework(widget.homework!.id);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ]
          : null,
      bottom: Row(children: [
        if (!editing || !widget.homework!.assigned)
          Expanded(
            child: OutlinedButton(
              onPressed: () => _save(assign: false),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: const BorderSide(color: Colors.white24),
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Save Draft'),
            ),
          ),
        if (!editing || !widget.homework!.assigned) const SizedBox(width: 10),
        Expanded(
          child: PrimaryButton(label: editing && widget.homework!.assigned ? 'Save Changes' : 'Assign Homework', onPressed: () => _save(assign: true)),
        ),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if (client != null)
            Text('For ${client.name}', style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
          const FieldLabel('Task title', required: true),
          TextField(
            controller: _title,
            onChanged: (_) => _titleError == null ? null : setState(() => _titleError = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter a task title', error: _titleError),
          ),
          const FieldLabel('Instructions'),
          TextField(
            controller: _instr,
            minLines: 4,
            maxLines: 8,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Explain what to practise and how'),
          ),
          if (dogs.isNotEmpty) ...[
            const FieldLabel('Dog', required: true),
            ChoiceRow(options: dogs, value: _dog, onChanged: (v) => setState(() {
              _dog = v;
              _dogError = null;
            })),
            if (_dogError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(_dogError!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
              ),
          ],
          const FieldLabel('Due date'),
          Row(children: [
            Expanded(child: DateField(value: _due, hint: 'No due date', onChanged: (d) => setState(() => _due = d))),
            if (_due != null)
              TextButton(
                onPressed: () => setState(() => _due = null),
                child: const Text('No due date', style: TextStyle(color: AppColors.primaryForestGreen)),
              ),
          ]),
          if (editing) ...[
            const FieldLabel('Progress'),
            ChoiceRow(options: kHomeworkProgress, value: _progress, onChanged: (v) => setState(() => _progress = v)),
            const SizedBox(height: 8),
            Text(widget.homework!.timing, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          ],
          const SizedBox(height: 16),
          const Text('Saved to your trainer journal. It isn’t sent to the client.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4)),
        ],
      ),
    );
  }
}

/// Trainer Notes: private to the trainer. Never part of anything shown to or
/// shared with a client.
class ClientNotesScreen extends StatefulWidget {
  final String clientId;
  const ClientNotesScreen({super.key, required this.clientId});

  @override
  State<ClientNotesScreen> createState() => _ClientNotesScreenState();
}

class _ClientNotesScreenState extends State<ClientNotesScreen> {
  final _store = TrainerStore.instance;

  Future<void> _add() async {
    final ctrl = TextEditingController();
    String? error;
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 16 + MediaQuery.viewInsetsOf(ctx).bottom),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Add Note',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Private: only you can see this.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              minLines: 4,
              maxLines: 8,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Write your note', error: error),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Save Note',
              onPressed: () {
                if (ctrl.text.trim().isEmpty) {
                  setSheet(() => error = 'Enter a note.');
                } else {
                  Navigator.pop(ctx, ctrl.text.trim());
                }
              },
            ),
          ]),
        ),
      ),
    );
    ctrl.dispose();
    if (text == null) return;
    final ok = await _store.addNote(TrainerNote(id: _store.newId(), clientId: widget.clientId, text: text));
    if (!ok && mounted) {
      AppSnackbar.show(context, message: 'Your note couldn’t be saved. Please try again.', type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final notes = _store.notes(widget.clientId);
        return HealthScaffold(
          title: 'Trainer Notes',
          bottom: notes.isEmpty ? null : PrimaryButton(label: 'Add Note', icon: UlvenikIcons.add, onPressed: _add),
          body: notes.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.sticky_note_2_outlined,
                    title: 'No Notes Yet',
                    message: 'Notes are private to you and are never shown to your client.',
                    actionLabel: 'Add Note',
                    onAction: _add,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final n in notes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: HealthCard(
                          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(fmtDate(n.at), style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(n.text, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, height: 1.4)),
                              ]),
                            ),
                            IconButton(
                              tooltip: 'Delete note',
                              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.secondaryTextStoneGrey),
                              onPressed: () async {
                                final ok = await confirmDelete(context,
                                    title: 'Delete note?', message: 'This note will be permanently deleted.');
                                if (ok) _store.deleteNote(n.id);
                              },
                            ),
                          ]),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
