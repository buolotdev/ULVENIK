import 'package:flutter/material.dart';
import '../data/item_library.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

String _noun(LibraryKind k) => k == LibraryKind.rewards ? 'reward' : 'equipment';
String _title(LibraryKind k) => k == LibraryKind.rewards ? 'Rewards' : 'Equipment';
String _icon(LibraryKind k) => k == LibraryKind.rewards ? UlvenikIcons.rewards : UlvenikIcons.equipment;

/// Rewards or Equipment library: fully user-defined, the same structure for
/// both, shared by every Training and S&C session form.
class ItemLibraryScreen extends StatefulWidget {
  final LibraryKind kind;
  const ItemLibraryScreen({super.key, required this.kind});

  @override
  State<ItemLibraryScreen> createState() => _ItemLibraryScreenState();
}

class _ItemLibraryScreenState extends State<ItemLibraryScreen> {
  final _store = ItemLibraryStore.instance;
  final _search = TextEditingController();
  bool _archived = false;

  LibraryKind get k => widget.kind;

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

  void _add([LibraryItem? item]) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => ItemFormScreen(kind: k, item: item)));

  void _menu() => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text(_archived ? 'Show active items' : 'Archived items',
                    style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _archived = !_archived);
                },
              ),
              ListTile(
                title: const Text('Manage types', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _manageTypes();
                },
              ),
            ]),
          ),
        ),
      );

  void _manageTypes() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => ListenableBuilder(
          listenable: _store,
          builder: (ctx, _) {
            final types = _store.types(k);
            return SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.7),
                child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                  const Text('Manage types',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  if (types.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('You haven’t added any types. Types are optional.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                    ),
                  for (final t in types)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(t, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          tooltip: 'Rename',
                          icon: const UlvenikIcon(UlvenikIcons.edit, size: 18, color: AppColors.secondaryTextStoneGrey),
                          onPressed: () async {
                            final ctrl = TextEditingController(text: t);
                            final n = await showDialog<String>(
                              context: ctx,
                              builder: (d) => AlertDialog(
                                backgroundColor: AppColors.cardsCarbon,
                                title: const Text('Rename type', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                                content: TextField(
                                    controller: ctrl,
                                    autofocus: true,
                                    style: const TextStyle(color: AppColors.primaryTextOffWhite),
                                    decoration: healthDecoration('Type name')),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(d, ctrl.text), child: const Text('Save')),
                                ],
                              ),
                            );
                            ctrl.dispose();
                            if (n != null) _store.renameType(k, t, n);
                          },
                        ),
                        IconButton(
                          tooltip: 'Remove',
                          icon: const Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                          onPressed: () => _store.removeType(k, t),
                        ),
                      ]),
                    ),
                  const Text('Removing a type keeps the items that used it.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                ]),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final all = _store.items(k, archived: _archived);
    final q = _search.text.trim().toLowerCase();
    final list = all
        .where((i) => q.isEmpty || i.name.toLowerCase().contains(q) || i.type.toLowerCase().contains(q))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final anyActive = _store.items(k).isNotEmpty;

    return HealthScaffold(
      title: _archived ? 'Archived ${_title(k).toLowerCase()}' : _title(k),
      actions: [
        if (!_archived)
          IconButton(
            tooltip: 'Add ${_noun(k)}',
            icon: const UlvenikIcon(UlvenikIcons.add, color: AppColors.primaryForestGreen),
            onPressed: _add,
          ),
        IconButton(
          tooltip: 'More',
          icon: const UlvenikIcon(UlvenikIcons.more, color: AppColors.primaryTextOffWhite),
          onPressed: _menu,
        ),
      ],
      body: all.isEmpty && !(_archived && anyActive)
          ? Center(
              child: EmptyState(
                icon: k == LibraryKind.rewards ? Icons.card_giftcard : Icons.construction,
                title: _archived ? 'No archived ${_noun(k)} items' : 'No ${_noun(k)} items yet',
                message: _archived
                    ? 'Items you archive will appear here.'
                    : 'Save ${_noun(k)} to reuse in Training and S&C sessions.',
                actionLabel: _archived ? null : 'Add ${_noun(k)}',
                onAction: _archived ? null : _add,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                TextField(
                  controller: _search,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                  decoration: healthDecoration('Search ${_title(k).toLowerCase()}...').copyWith(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: UlvenikIcon(UlvenikIcons.search, size: 20, color: AppColors.secondaryTextStoneGrey),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text('Nothing matches your search.',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                    ),
                  ),
                for (final i in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HealthCard(
                      onTap: _archived ? null : () => _add(i),
                      padding: const EdgeInsets.fromLTRB(16, 12, 6, 12),
                      child: Row(children: [
                        UlvenikIcon(_icon(k), size: 22, color: AppColors.secondarySage),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(i.name,
                                style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                            if (i.type.isNotEmpty)
                              Text(i.type, style: const TextStyle(color: AppColors.secondarySage, fontSize: 12.5)),
                            if (i.notes.isNotEmpty)
                              Text(i.notes,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                          ]),
                        ),
                        TextButton(
                          onPressed: () {
                            _store.setArchived(k, i, !_archived);
                            AppSnackbar.show(context,
                                message: _archived ? 'Item restored' : 'Item archived', type: SnackbarType.success);
                          },
                          child: Text(_archived ? 'Restore' : 'Archive',
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Add / Edit a reward or equipment item. Name is required; type and notes are
/// optional and user-defined. Types are never pre-selected.
class ItemFormScreen extends StatefulWidget {
  final LibraryKind kind;
  final LibraryItem? item;
  const ItemFormScreen({super.key, required this.kind, this.item});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _store = ItemLibraryStore.instance;
  late final _name = TextEditingController(text: widget.item?.name ?? '');
  late final _notes = TextEditingController(text: widget.item?.notes ?? '');
  final _newType = TextEditingController();
  late String _type = widget.item?.type ?? '';
  bool _addingType = false;
  String? _nameError;
  String? _typeError;
  bool _saving = false;

  LibraryKind get k => widget.kind;

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    _newType.dispose();
    super.dispose();
  }

  void _commitType() {
    final t = _newType.text.trim();
    if (t.isEmpty) {
      setState(() => _typeError = 'Enter a type name.');
      return;
    }
    final existing = _store.types(k).where((e) => e.toLowerCase() == t.toLowerCase()).firstOrNull;
    _store.addType(k, existing ?? t);
    setState(() {
      _type = existing ?? t; // an existing type is selected, never duplicated
      _addingType = false;
      _typeError = null;
      _newType.clear();
    });
  }

  void _save() {
    if (_saving) return;
    final n = _name.text.trim();
    if (n.isEmpty) {
      setState(() => _nameError = 'Enter a ${_noun(k)} name.');
      return;
    }
    _saving = true;
    final it = widget.item ?? LibraryItem(id: _store.newId(), name: n);
    it
      ..name = n
      ..type = _type
      ..notes = _notes.text.trim();
    _store.save(k, it);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final noun = _noun(k);
    final types = _store.types(k);
    return HealthScaffold(
      title: widget.item == null ? 'Add $noun' : 'Edit $noun',
      bottom: Column(mainAxisSize: MainAxisSize.min, children: [
        PrimaryButton(label: 'Save $noun', icon: UlvenikIcons.save, onPressed: _save),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text('Save ${k == LibraryKind.rewards ? 'rewards' : 'equipment'} to reuse in Training and S&C sessions.',
              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
          FieldLabel('${noun[0].toUpperCase()}${noun.substring(1)} name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => _nameError == null ? null : setState(() => _nameError = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Enter a $noun name', error: _nameError),
          ),
          const FieldLabel('Type'),
          const Text('Choose a type or add your own.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in types)
              ChoiceChip(
                label: Text(t),
                selected: _type == t,
                onSelected: (v) => setState(() => _type = v ? t : ''),
                showCheckmark: false,
                labelStyle: TextStyle(
                    color: _type == t ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey, fontSize: 13),
                backgroundColor: AppColors.cardsCarbon,
                selectedColor: AppColors.primaryForestGreen,
                side: const BorderSide(color: Colors.white12),
              ),
            ActionChip(
              label: const Text('Add type'),
              onPressed: () => setState(() => _addingType = true),
              backgroundColor: AppColors.backgroundObsidian,
              side: const BorderSide(color: Colors.white24),
              labelStyle: const TextStyle(color: AppColors.primaryForestGreen, fontSize: 13),
            ),
          ]),
          if (_addingType) ...[
            const SizedBox(height: 10),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: TextField(
                  controller: _newType,
                  autofocus: true,
                  onSubmitted: (_) => _commitType(),
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                  decoration: healthDecoration('Enter a type name', error: _typeError),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _commitType,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite, side: const BorderSide(color: Colors.white24)),
                  child: const Text('Add type'),
                ),
              ),
            ]),
          ],
          const FieldLabel('Notes'),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 5,
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add notes about this $noun'),
          ),
        ],
      ),
    );
  }
}
