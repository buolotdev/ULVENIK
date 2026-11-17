import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_edit_screen.dart';

/// Add Media: pick several photos, videos and documents together for the open
/// dog. Only the files are required. The media date can be in the past and is
/// kept separate from the upload time.
class MediaAddScreen extends StatefulWidget {
  final String dogName;
  const MediaAddScreen({super.key, required this.dogName});

  @override
  State<MediaAddScreen> createState() => _MediaAddScreenState();
}

class _MediaAddScreenState extends State<MediaAddScreen> {
  final _store = MediaStore.instance;
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _newCollection = TextEditingController();
  List<MediaFile> _files = [];
  DateTime _date = DateTime.now();
  final Set<String> _collections = {};
  final List<MediaLink> _links = [];
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _newCollection.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final picked = await pickMediaFiles();
    if (picked.isEmpty) return;
    setState(() {
      final have = {for (final f in _files) '${f.path}|${f.name}'};
      _files = [..._files, ...picked.where((f) => !have.contains('${f.path}|${f.name}'))];
      _error = null;
    });
  }

  void _save() {
    if (_saving) return;
    if (_files.isEmpty) {
      setState(() => _error = 'Choose at least one file.');
      return;
    }
    setState(() => _saving = true);
    try {
      // Re-saving after a failure reuses files already added (no copies).
      _store.addFiles(
        widget.dogName,
        _files,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        mediaDate: _date,
        collectionIds: _collections,
        links: _links,
      );
      AppSnackbar.show(context,
          message: _files.length == 1 ? 'Media added' : '${_files.length} files added', type: SnackbarType.success);
      Navigator.pop(context);
    } catch (_) {
      setState(() => _saving = false);
      AppSnackbar.show(context,
          message: 'Couldn’t add your media. Your files and details are still here — try again.',
          type: SnackbarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cols = _store.collections(widget.dogName);
    return HealthScaffold(
      title: 'Add Media',
      bottom: PrimaryButton(label: 'Add Media', icon: UlvenikIcons.add, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Files', required: true),
          OutlinedButton.icon(
            onPressed: _pick,
            icon: const Icon(Icons.attach_file, size: 18),
            label: Text(_files.isEmpty ? 'Choose Files' : 'Add More Files'),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: BorderSide(color: AppColors.cardBorder),
                minimumSize: const Size(0, 48)),
          ),
          if (_files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(spacing: 8, runSpacing: 6, children: [
                for (final f in _files)
                  InputChip(
                    avatar: Icon(
                      switch (mediaTypeFor(f.name)) {
                        MediaType.photo => Icons.image_outlined,
                        MediaType.video => Icons.videocam_outlined,
                        MediaType.document => Icons.description_outlined,
                      },
                      size: 16,
                      color: AppColors.secondarySage,
                    ),
                    label: Text(f.name, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.cardsCarbon,
                    side: BorderSide(color: AppColors.cardBorder),
                    deleteIconColor: AppColors.secondaryTextStoneGrey,
                    onDeleted: () => setState(() => _files = [..._files]..remove(f)),
                  ),
              ]),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(_error!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
            ),
          if (_files.length == 1) ...[
            const FieldLabel('Title'),
            TextField(
              controller: _title,
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Add a title'),
            ),
          ],
          const FieldLabel('Media Date'),
          DateField(value: _date, onChanged: (d) => setState(() => _date = d), allowFuture: false),
          const FieldLabel('Description / Notes'),
          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: 6,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add a description...'),
          ),
          const FieldLabel('Collections'),
          if (cols.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in cols)
                FilterChip(
                  label: Text(c.name),
                  selected: _collections.contains(c.id),
                  onSelected: (v) => setState(() => v ? _collections.add(c.id) : _collections.remove(c.id)),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                      color: _collections.contains(c.id) ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
                      fontSize: 13),
                  backgroundColor: AppColors.cardsCarbon,
                  selectedColor: AppColors.primaryForestGreen,
                  side: BorderSide(color: AppColors.cardBorder),
                ),
            ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _newCollection,
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('New collection name'),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                final n = _newCollection.text.trim();
                if (n.isEmpty) return;
                final c = _store.createCollection(widget.dogName, n);
                setState(() => _collections.add(c.id));
                _newCollection.clear();
              },
              child: Text('Create',
                  style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
          ]),
          const FieldLabel('Link to Records'),
          if (_links.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 6, children: [
              for (final l in _links)
                InputChip(
                  label: Text('${l.section} · ${l.label()}',
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                  backgroundColor: AppColors.cardsCarbon,
                  side: BorderSide(color: AppColors.cardBorder),
                  deleteIconColor: AppColors.secondaryTextStoneGrey,
                  onDeleted: () => setState(() => _links.remove(l)),
                ),
            ]),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () async {
                final r = await pickRecordLinks(context, widget.dogName, exclude: {for (final l in _links) l.key});
                if (r != null) setState(() => _links.addAll(r));
              },
              icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
              label: const Text('Link to Record'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 44)),
            ),
          ),
        ],
      ),
    );
  }
}
