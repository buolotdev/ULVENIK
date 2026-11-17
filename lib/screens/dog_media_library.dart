import 'dart:io';
import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_actions.dart';
import 'media_add_screen.dart';
import 'media_viewer_screen.dart';

const _sources = ['Training', 'S&C', 'Health', 'Sport', 'Direct Upload'];
const _sorts = ['Newest', 'Oldest', 'Recently Added'];

class _Filters {
  DateTime? from;
  DateTime? to;
  Set<String> sources = {};
  String sort = 'Newest';
  String? collection; // 'p:<id>' personal or 'a:<name>' automatic
  bool favOnly = false;

  bool get active => from != null || to != null || sources.isNotEmpty || collection != null || favOnly;

  _Filters copy() => _Filters()
    ..from = from
    ..to = to
    ..sources = {...sources}
    ..sort = sort
    ..collection = collection
    ..favOnly = favOnly;
}

/// Dog Profile › Media: the open dog's library, directly. Photos, videos and
/// documents (uploaded or attached inside records) in a three-column grid,
/// with search, filters, Collections, Favourites and bulk actions.
class DogMediaLibrary extends StatefulWidget {
  final String dogName;
  const DogMediaLibrary({super.key, required this.dogName});

  @override
  State<DogMediaLibrary> createState() => _DogMediaLibraryState();
}

class _DogMediaLibraryState extends State<DogMediaLibrary> {
  static const _tabs = ['All', 'Photos', 'Videos', 'Documents', 'Collections', 'Favourites'];
  final _store = MediaStore.instance;
  final _search = TextEditingController();
  String _tab = 'All';
  _Filters _filters = _Filters();
  final Set<String> _selected = {};
  String? _openCollection; // 'p:<id>' | 'a:<name>'

  bool get _selecting => _selected.isNotEmpty;

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
    if (!mounted) return;
    // drop selections of items that no longer exist
    final ids = _store.items(widget.dogName).map((i) => i.id).toSet();
    _selected.removeWhere((id) => !ids.contains(id));
    setState(() {});
  }

  String get _dog => widget.dogName;

  Set<String> _sourcesOf(MediaItem i) => i.links.isEmpty ? {'Direct Upload'} : {for (final l in i.links) l.section};

  bool _inCollection(MediaItem i, String key) {
    if (key.startsWith('p:')) return i.collectionIds.contains(key.substring(2));
    return _store.autoCollections(_dog)[key.substring(2)]?.contains(i) ?? false;
  }

  List<MediaItem> _visible({bool ignoreSearch = false, bool ignoreFilters = false}) {
    var list = _store.items(_dog);
    switch (_tab) {
      case 'Photos':
        list = list.where((i) => i.type == MediaType.photo).toList();
      case 'Videos':
        list = list.where((i) => i.type == MediaType.video).toList();
      case 'Documents':
        list = list.where((i) => i.type == MediaType.document).toList();
      case 'Favourites':
        list = list.where((i) => i.favourite).toList();
    }
    if (_openCollection != null) list = list.where((i) => _inCollection(i, _openCollection!)).toList();
    final q = _search.text.trim().toLowerCase();
    if (!ignoreSearch && q.isNotEmpty) {
      list = list
          .where((i) =>
              i.title.toLowerCase().contains(q) ||
              i.name.toLowerCase().contains(q) ||
              i.description.toLowerCase().contains(q) ||
              i.links.any((l) => l.label().toLowerCase().contains(q)))
          .toList();
    }
    if (!ignoreFilters) {
      final f = _filters;
      if (f.from != null) list = list.where((i) => !i.mediaDate.isBefore(f.from!)).toList();
      if (f.to != null) {
        final end = DateTime(f.to!.year, f.to!.month, f.to!.day, 23, 59, 59);
        list = list.where((i) => !i.mediaDate.isAfter(end)).toList();
      }
      if (f.sources.isNotEmpty) list = list.where((i) => _sourcesOf(i).any(f.sources.contains)).toList();
      if (f.collection != null) list = list.where((i) => _inCollection(i, f.collection!)).toList();
      if (f.favOnly) list = list.where((i) => i.favourite).toList();
    }
    switch (_filters.sort) {
      case 'Oldest':
        list.sort((a, b) => a.mediaDate.compareTo(b.mediaDate));
      case 'Recently Added':
        list.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      default:
        list.sort((a, b) => b.mediaDate.compareTo(a.mediaDate));
    }
    return list;
  }

  void _add() => Navigator.push(context, MaterialPageRoute(builder: (_) => MediaAddScreen(dogName: _dog)));

  void _openViewer(List<MediaItem> list, int index) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MediaViewerScreen(dogName: _dog, items: list, initialIndex: index)),
      );

  void _toggleSelect(MediaItem i) => setState(() => _selected.contains(i.id) ? _selected.remove(i.id) : _selected.add(i.id));

  List<MediaItem> get _selectedItems => _store.items(_dog).where((i) => _selected.contains(i.id)).toList();

  Future<void> _openFilters() async {
    final f = _filters.copy();
    final cols = _store.collections(_dog);
    final autos = _store.autoCollections(_dog).keys.toList()..sort();
    final applied = await showModalBottomSheet<_Filters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          Future<DateTime?> pickDate(DateTime? initial) => showDatePicker(
                context: ctx,
                initialDate: initial ?? DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
                builder: (c, w) => Theme(
                  data: Theme.of(c).copyWith(
                      colorScheme: ColorScheme.dark(
                          primary: AppColors.primaryForestGreen, surface: AppColors.cardsCarbon)),
                  child: w!,
                ),
              );
          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.85),
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                Text('Filters',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const FieldLabelPlain('Date range'),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final d = await pickDate(f.from);
                        if (d != null) setSheet(() => f.from = d);
                      },
                      style: _outlined,
                      child: Text(f.from == null ? 'Start date' : fmtDate(f.from!)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final d = await pickDate(f.to);
                        if (d != null) setSheet(() => f.to = d);
                      },
                      style: _outlined,
                      child: Text(f.to == null ? 'End date' : fmtDate(f.to!)),
                    ),
                  ),
                ]),
                const FieldLabelPlain('Source'),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final s in _sources)
                    FilterChip(
                      label: Text(s),
                      selected: f.sources.contains(s),
                      onSelected: (v) => setSheet(() => v ? f.sources.add(s) : f.sources.remove(s)),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          color: f.sources.contains(s) ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                          fontSize: 13),
                      backgroundColor: AppColors.backgroundObsidian,
                      selectedColor: AppColors.primaryForestGreen,
                      side: BorderSide(color: AppColors.cardBorder),
                    ),
                ]),
                const FieldLabelPlain('Sort by'),
                ChoiceRow(options: _sorts, value: f.sort, onChanged: (v) => setSheet(() => f.sort = v)),
                if (cols.isNotEmpty || autos.isNotEmpty) ...[
                  const FieldLabelPlain('Collection'),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final c in cols)
                      ChoiceChip(
                        label: Text(c.name),
                        selected: f.collection == 'p:${c.id}',
                        onSelected: (v) => setSheet(() => f.collection = v ? 'p:${c.id}' : null),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                            color: f.collection == 'p:${c.id}' ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                            fontSize: 13),
                        backgroundColor: AppColors.backgroundObsidian,
                        selectedColor: AppColors.primaryForestGreen,
                        side: BorderSide(color: AppColors.cardBorder),
                      ),
                    for (final a in autos)
                      ChoiceChip(
                        label: Text(a),
                        selected: f.collection == 'a:$a',
                        onSelected: (v) => setSheet(() => f.collection = v ? 'a:$a' : null),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                            color: f.collection == 'a:$a' ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                            fontSize: 13),
                        backgroundColor: AppColors.backgroundObsidian,
                        selectedColor: AppColors.primaryForestGreen,
                        side: BorderSide(color: AppColors.cardBorder),
                      ),
                  ]),
                ],
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppColors.primaryForestGreen,
                  title: Text('Favourites only', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                  value: f.favOnly,
                  onChanged: (v) => setSheet(() => f.favOnly = v),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setSheet(() {
                        f
                          ..from = null
                          ..to = null
                          ..sources = {}
                          ..sort = 'Newest'
                          ..collection = null
                          ..favOnly = false;
                      }),
                      style: _outlined.copyWith(minimumSize: const WidgetStatePropertyAll(Size(0, 50))),
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: PrimaryButton(label: 'Apply', onPressed: () => Navigator.pop(ctx, f))),
                ]),
              ]),
            ),
          );
        },
      ),
    );
    if (applied != null) setState(() => _filters = applied);
  }

  static final _outlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primaryTextOffWhite,
    side: BorderSide(color: AppColors.cardBorder),
    minimumSize: const Size(0, 46),
  );

  void _clearAll() {
    _search.clear();
    setState(() => _filters = _Filters()..sort = _filters.sort);
  }

  // ── Pieces ──────────────────────────────────────────────────────────────
  Widget _tile(MediaItem i, List<MediaItem> list, int index) {
    final selected = _selected.contains(i.id);
    Widget face;
    switch (i.type) {
      case MediaType.photo:
        face = i.path == null
            ? ColoredBox(color: AppColors.backgroundObsidian)
            : Image.file(File(i.path!),
                fit: BoxFit.cover,
                cacheWidth: 400,
                errorBuilder: (_, _, _) => ColoredBox(
                    color: AppColors.backgroundObsidian,
                    child: Icon(Icons.broken_image_outlined, color: AppColors.secondaryTextStoneGrey)));
      case MediaType.video:
        face = Stack(fit: StackFit.expand, children: [
          const ColoredBox(color: Color(0xFF232625)),
          Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, color: Colors.white70, size: 22),
            ),
          ),
        ]);
      case MediaType.document:
        final ext = i.name.contains('.') ? i.name.split('.').last.toUpperCase() : 'FILE';
        face = ColoredBox(
          color: const Color(0xFF1F2A26),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.description_outlined, color: AppColors.secondarySage, size: 28),
            const SizedBox(height: 4),
            Text(ext,
                style: TextStyle(color: AppColors.secondarySage, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        );
    }
    return GestureDetector(
      onTap: () => _selecting ? _toggleSelect(i) : _openViewer(list, index),
      onLongPress: () => _toggleSelect(i),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(fit: StackFit.expand, children: [
          face,
          if (i.favourite)
            Positioned(
              right: 5,
              top: 5,
              child: Icon(Icons.favorite, size: 16, color: AppColors.primaryForestGreen),
            ),
          if (_selecting)
            Positioned(
              left: 5,
              top: 5,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primaryForestGreen : Colors.black45,
                  border: Border.all(color: Colors.white70, width: 1.5),
                ),
                child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ),
          if (selected) Container(color: AppColors.primaryForestGreen.withValues(alpha: 0.25)),
        ]),
      ),
    );
  }

  Widget _grid(List<MediaItem> list) => GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: [for (var n = 0; n < list.length; n++) _tile(list[n], list, n)],
      );

  Widget _collectionsView() {
    final personal = _store.collections(_dog);
    final autos = _store.autoCollections(_dog);
    final names = autos.keys.toList()..sort();
    Widget row(String name, int count, bool isPersonal, VoidCallback onTap, {VoidCallback? onMenu}) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: HealthCard(
            onTap: onTap,
            child: Row(children: [
              Icon(isPersonal ? Icons.folder_special_outlined : Icons.folder_outlined,
                  color: isPersonal ? AppColors.primaryForestGreen : AppColors.secondarySage, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('${isPersonal ? 'Personal · ' : 'Automatic · '}$count ${count == 1 ? 'file' : 'files'}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                ]),
              ),
              if (onMenu != null)
                IconButton(
                  tooltip: 'Collection options',
                  icon: UlvenikIcon(UlvenikIcons.more, color: AppColors.secondaryTextStoneGrey),
                  onPressed: onMenu,
                )
              else
                UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
            ]),
          ),
        );

    if (personal.isEmpty && names.isEmpty) {
      return EmptyState(
        icon: Icons.folder_outlined,
        title: 'No Collections Yet',
        message: 'Create a collection, or link media to a record to see automatic collections here.',
        actionLabel: 'New Collection',
        onAction: _newCollection,
      );
    }
    final items = _store.items(_dog);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: _newCollection,
          icon: UlvenikIcon(UlvenikIcons.add, size: 16, color: AppColors.primaryForestGreen),
          label: Text('New Collection',
              style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
        ),
      ),
      for (final c in personal)
        row(c.name, items.where((i) => i.collectionIds.contains(c.id)).length, true,
            () => setState(() => _openCollection = 'p:${c.id}'),
            onMenu: () => _collectionMenu(c)),
      for (final n in names) row(n, autos[n]!.length, false, () => setState(() => _openCollection = 'a:$n')),
    ]);
  }

  Future<void> _newCollection() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        title: Text('New Collection', style: TextStyle(color: AppColors.primaryTextOffWhite)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: AppColors.primaryTextOffWhite),
          decoration: healthDecoration('Collection name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Create')),
        ],
      ),
    );
    ctrl.dispose();
    if (name != null && name.isNotEmpty) _store.createCollection(_dog, name);
  }

  void _collectionMenu(MediaCollection c) => showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text('Rename Collection', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final ctrl = TextEditingController(text: c.name);
                  final n = await showDialog<String>(
                    context: context,
                    builder: (d) => AlertDialog(
                      backgroundColor: AppColors.cardsCarbon,
                      title: Text('Rename Collection', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                      content: TextField(
                          controller: ctrl,
                          autofocus: true,
                          style: TextStyle(color: AppColors.primaryTextOffWhite),
                          decoration: healthDecoration('Collection name')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(d, ctrl.text.trim()), child: const Text('Save')),
                      ],
                    ),
                  );
                  ctrl.dispose();
                  if (n != null && n.isNotEmpty) _store.renameCollection(c, n);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                title: const Text('Delete Collection', style: TextStyle(color: Color(0xFFFFB4AB))),
                subtitle: Text('The files in it are kept.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  _store.deleteCollection(_dog, c.id);
                },
              ),
            ]),
          ),
        ),
      );

  Widget _emptyFor(String tab) {
    final heading = switch (tab) {
      'Photos' => 'No Photos Yet',
      'Videos' => 'No Videos Yet',
      'Documents' => 'No Documents Yet',
      'Favourites' => 'No Favourites Yet',
      _ => 'No Media Yet',
    };
    if (tab == 'Favourites') {
      return const EmptyState(
        icon: Icons.favorite_border,
        title: 'No Favourites Yet',
        message: 'Tap the heart on a photo, video or document to keep it here.',
      );
    }
    return EmptyState(
      icon: Icons.photo_library_outlined,
      title: heading,
      message: 'Add your first photo, video or document to start building your dog’s media library.',
      actionLabel: 'Add Media',
      onAction: _add,
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _store.items(_dog);
    final list = _tab == 'Collections' && _openCollection == null ? <MediaItem>[] : _visible();
    final searching = _search.text.trim().isNotEmpty || _filters.active;

    Widget body;
    if (_tab == 'Collections' && _openCollection == null) {
      body = _collectionsView();
    } else if (list.isEmpty) {
      final hasInView = _visible(ignoreSearch: true, ignoreFilters: true).isNotEmpty;
      if (hasInView && searching) {
        body = Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(children: [
            Icon(Icons.search_off, color: AppColors.secondaryTextStoneGrey, size: 32),
            const SizedBox(height: 10),
            Text(
              _search.text.trim().isNotEmpty ? 'No results for “${_search.text.trim()}”' : 'No media matches your filters',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _clearAll,
              child: Text('Clear Search and Filters',
                  style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
          ]),
        );
      } else if (_openCollection != null) {
        body = const EmptyState(
          icon: Icons.folder_open_outlined,
          title: 'This Collection Is Empty',
          message: 'Files you add to it will appear here.',
        );
      } else {
        body = _emptyFor(_tab);
      }
    } else {
      body = _grid(list);
    }

    String? openName;
    if (_openCollection != null) {
      openName = _openCollection!.startsWith('a:')
          ? _openCollection!.substring(2)
          : _store.collections(_dog).where((c) => 'p:${c.id}' == _openCollection).map((c) => c.name).firstOrNull ?? '';
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      children: [
        if (_selecting)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryForestGreen),
            ),
            child: Row(children: [
              TextButton(
                onPressed: () => setState(_selected.clear),
                child: Text('Cancel', style: TextStyle(color: AppColors.primaryTextOffWhite)),
              ),
              Expanded(
                child: Text('${_selected.length} selected',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w600)),
              ),
              IconButton(
                tooltip: 'Add to Collection',
                icon: Icon(Icons.create_new_folder_outlined, color: AppColors.primaryTextOffWhite),
                onPressed: () async {
                  if (await showAddToCollectionSheet(context, _dog, _selectedItems)) setState(_selected.clear);
                },
              ),
              IconButton(
                tooltip: 'Download',
                icon: Icon(Icons.download_outlined, color: AppColors.primaryTextOffWhite),
                onPressed: () => downloadItems(context, _selectedItems),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB)),
                onPressed: () async {
                  final items = _selectedItems;
                  if (!await confirmDeleteMedia(context, items) || !mounted) return;
                  _store.delete(_dog, items.map((i) => i.id));
                  setState(_selected.clear);
                  AppSnackbar.show(context, message: 'Media deleted', type: SnackbarType.success);
                },
              ),
            ]),
          )
        else
          Row(children: [
            Expanded(
              child: Text('Media Library',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: _add,
                icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
                label: const Text('Add Media', style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.onForestGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
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
                        title: Text('Media Storage', style: TextStyle(color: AppColors.primaryTextOffWhite)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => MediaStorageScreen(dogName: _dog)));
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _search,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Search media...').copyWith(
                prefixIcon: Padding(
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
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ChoiceRow(
            options: _tabs,
            value: _tab,
            onChanged: (v) => setState(() {
              _tab = v;
              _openCollection = null;
              _selected.clear();
            }),
          ),
        ),
        const SizedBox(height: 14),
        if (openName != null)
          Row(children: [
            IconButton(
              tooltip: 'Back to collections',
              visualDensity: VisualDensity.compact,
              icon: UlvenikIcon(UlvenikIcons.back, size: 20, color: AppColors.secondaryTextStoneGrey),
              onPressed: () => setState(() => _openCollection = null),
            ),
            Expanded(
              child: Text(openName,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ]),
        if (all.isEmpty && _tab != 'Collections')
          _emptyFor(_tab)
        else
          body,
      ],
    );
  }
}

class FieldLabelPlain extends StatelessWidget {
  final String text;
  const FieldLabelPlain(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(text,
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, fontWeight: FontWeight.w600)),
      );
}

/// Media Storage: what this dog's library currently holds. Plans, allowances
/// and limits are not final, so none are shown.
class MediaStorageScreen extends StatelessWidget {
  final String dogName;
  const MediaStorageScreen({super.key, required this.dogName});

  static String _size(int b) {
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(0)} KB';
    if (b < 1024 * 1024 * 1024) return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(b / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final store = MediaStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.items(dogName);
        int sum(MediaType t) => items.where((i) => i.type == t).fold(0, (a, i) => a + i.size);
        int count(MediaType t) => items.where((i) => i.type == t).length;
        Widget row(String label, MediaType t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HealthCard(
                child: Row(children: [
                  Expanded(
                    child: Text(label,
                        style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  Text('${count(t)} · ${_size(sum(t))}',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                ]),
              ),
            );
        return HealthScaffold(
          title: 'Media Storage',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              HealthCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Used by this library',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                  const SizedBox(height: 6),
                  Text(_size(items.fold(0, (a, i) => a + i.size)),
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 26, fontWeight: FontWeight.w700)),
                ]),
              ),
              const SizedBox(height: 14),
              row('Photos', MediaType.photo),
              row('Videos', MediaType.video),
              row('Documents', MediaType.document),
              const SizedBox(height: 6),
              Text('Storage plans and limits will appear here once they are confirmed.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
            ],
          ),
        );
      },
    );
  }
}
