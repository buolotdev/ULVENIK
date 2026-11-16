import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_links.dart';

/// Pick records of this dog to link media to. Returns the chosen links.
Future<List<MediaLink>?> pickRecordLinks(BuildContext context, String dog, {Set<String> exclude = const {}}) {
  final options = MediaLinks.available(dog).where((l) => !exclude.contains(l.key)).toList();
  final chosen = <String>{};
  return showModalBottomSheet<List<MediaLink>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.8),
          child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
            const Text('Link to Records',
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('There are no records to link to yet.',
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              ),
            for (final l in options)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primaryForestGreen,
                checkColor: AppColors.primaryTextOffWhite,
                title: Text(l.label(), style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                subtitle: Text(l.section, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                value: chosen.contains(l.key),
                onChanged: (v) => setSheet(() => v == true ? chosen.add(l.key) : chosen.remove(l.key)),
              ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.pop(ctx, [for (final l in options) if (chosen.contains(l.key)) l]),
            ),
          ]),
        ),
      ),
    ),
  );
}

/// Edit Details: title, description, media date and linked records. Changes
/// apply to the one underlying item everywhere it is shown.
class MediaEditScreen extends StatefulWidget {
  final String dogName;
  final MediaItem item;
  const MediaEditScreen({super.key, required this.dogName, required this.item});

  @override
  State<MediaEditScreen> createState() => _MediaEditScreenState();
}

class _MediaEditScreenState extends State<MediaEditScreen> {
  late final _title = TextEditingController(text: widget.item.title);
  late final _desc = TextEditingController(text: widget.item.description);
  late DateTime _date = widget.item.mediaDate;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    _saving = true;
    MediaStore.instance.update(widget.item,
        title: _title.text.trim(), description: _desc.text.trim(), mediaDate: _date);
    AppSnackbar.show(context, message: 'Details saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final store = MediaStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => HealthScaffold(
        title: 'Edit Details',
        bottom: PrimaryButton(label: 'Save', icon: UlvenikIcons.save, onPressed: _save),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const FieldLabel('Title'),
            TextField(
              controller: _title,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration(widget.item.name),
            ),
            const FieldLabel('Media Date'),
            DateField(value: _date, onChanged: (d) => setState(() => _date = d), allowFuture: false),
            const FieldLabel('Description'),
            TextField(
              controller: _desc,
              minLines: 3,
              maxLines: 6,
              style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Add a description...'),
            ),
            const SizedBox(height: 22),
            const SectionLabel('Linked Records'),
            if (widget.item.links.isEmpty)
              const Text('Not linked to any record.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
            for (final l in widget.item.links)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HealthCard(
                  padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l.label(),
                            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
                        Text(l.section,
                            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      ]),
                    ),
                    TextButton(
                      onPressed: () => store.unlink(widget.item, l.key),
                      child: const Text('Unlink', style: TextStyle(color: Color(0xFFFFB4AB))),
                    ),
                  ]),
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final r = await pickRecordLinks(context, widget.dogName,
                      exclude: {for (final l in widget.item.links) l.key});
                  if (r == null) return;
                  for (final l in r) {
                    store.link(widget.item, l);
                  }
                },
                icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
                label: const Text('Link to Record'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite,
                    side: const BorderSide(color: Colors.white24),
                    minimumSize: const Size(0, 44)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
