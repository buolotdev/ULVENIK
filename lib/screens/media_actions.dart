import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';

/// "Add to Collection" sheet: pick one or more personal collections (or create
/// one) and add the existing items to them. No file is copied.
Future<bool> showAddToCollectionSheet(BuildContext context, String dog, List<MediaItem> items) async {
  final store = MediaStore.instance;
  final nameCtrl = TextEditingController();
  final chosen = <String>{};
  final done = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) {
        final cols = store.collections(dog);
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.8),
              child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(20, 20, 20, 16), children: [
                Text('Add to Collection',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                for (final c in cols)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryForestGreen,
                    checkColor: AppColors.primaryTextOffWhite,
                    title: Text(c.name, style: TextStyle(color: AppColors.primaryTextOffWhite)),
                    value: chosen.contains(c.id),
                    onChanged: (v) => setSheet(() => v == true ? chosen.add(c.id) : chosen.remove(c.id)),
                  ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: nameCtrl,
                      style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                      decoration: healthDecoration('New collection name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      final n = nameCtrl.text.trim();
                      if (n.isEmpty) return;
                      final c = store.createCollection(dog, n);
                      nameCtrl.clear();
                      setSheet(() => chosen.add(c.id));
                    },
                    child: Text('Create',
                        style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 14),
                PrimaryButton(label: 'Add', onPressed: () => Navigator.pop(ctx, chosen.isNotEmpty)),
              ]),
            ),
          ),
        );
      },
    ),
  );
  nameCtrl.dispose();
  if (done == true) {
    for (final id in chosen) {
      store.addToCollection(items, id);
    }
    if (context.mounted) {
      AppSnackbar.show(context, message: 'Added to collection', type: SnackbarType.success);
    }
    return true;
  }
  return false;
}

/// Saves each file to a location the user picks. The saved file is the same
/// document, byte for byte.
Future<void> downloadItems(BuildContext context, List<MediaItem> items) async {
  var saved = 0;
  for (final i in items) {
    if (i.path == null) continue;
    try {
      final bytes = await File(i.path!).readAsBytes();
      final r = await FilePicker.saveFile(fileName: i.name, bytes: bytes);
      if (r != null) saved++;
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.show(context, message: 'Couldn’t save ${i.name}.', type: SnackbarType.error);
      }
    }
  }
  if (context.mounted && saved > 0) {
    AppSnackbar.show(context,
        message: saved == 1 ? 'File saved' : '$saved files saved', type: SnackbarType.success);
  }
}

/// Delete confirmation; warns when files are attached to records.
Future<bool> confirmDeleteMedia(BuildContext context, List<MediaItem> items) {
  final linked = items.where((i) => i.links.isNotEmpty).length;
  final one = items.length == 1;
  final msg = linked > 0
      ? (one
          ? 'This file is attached to ${items.first.links.length == 1 ? 'a record' : '${items.first.links.length} records'}. Deleting it removes it from those records too. This can’t be undone.'
          : '$linked of the ${items.length} selected files are attached to records. Deleting them removes them from those records too. This can’t be undone.')
      : (one ? 'This file will be permanently deleted.' : '${items.length} files will be permanently deleted.');
  return confirmDelete(context, title: one ? 'Delete media?' : 'Delete ${items.length} files?', message: msg);
}
