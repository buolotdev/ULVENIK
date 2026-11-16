import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'ulvenik_icon.dart';
import '../data/item_library.dart';

enum SessionItemKind { rewards, equipment }

/// User-created Rewards and Equipment libraries shared by Training and S&C
/// recording (Training Remaining Screens v34, Bottom Nav Training p6).
/// In-memory for now; replace with saved data.
class SessionItemLibrary {
  SessionItemLibrary._();

  static LibraryKind _k(SessionItemKind k) =>
      k == SessionItemKind.rewards ? LibraryKind.rewards : LibraryKind.equipment;

  /// The user's saved, active items (nothing is preloaded).
  static List<String> of(SessionItemKind k) => ItemLibraryStore.instance.names(_k(k));

  static String add(SessionItemKind k, String name) => ItemLibraryStore.instance.addByName(_k(k), name).name;
}

extension SessionItemKindX on SessionItemKind {
  String get title => this == SessionItemKind.rewards ? 'Rewards' : 'Equipment';
  String get icon => this == SessionItemKind.rewards ? UlvenikIcons.rewards : UlvenikIcons.equipment;
  String get usedTitle => this == SessionItemKind.rewards ? 'Rewards Used' : 'Equipment Used';
}

/// Opens the bottom sheet: select several saved items and add a new item
/// in the same sheet. Returns the new selection, or null if dismissed.
Future<List<String>?> showSessionItemsPicker(
  BuildContext context, {
  required SessionItemKind kind,
  required List<String> selected,
}) {
  final draft = [...selected];
  final addCtrl = TextEditingController();
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSheet) {
        final library = SessionItemLibrary.of(kind);
        void addItem() {
          final name = addCtrl.text.trim();
          if (name.isEmpty) return;
          setSheet(() {
            final item = SessionItemLibrary.add(kind, name);
            if (!draft.contains(item)) draft.add(item);
            addCtrl.clear();
          });
        }

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.8),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  Row(children: [
                    UlvenikIcon(kind.icon, size: 22, color: AppColors.secondarySage),
                    const SizedBox(width: 10),
                    Text(kind.title,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 4),
                  const Text('Optional. Choose any that apply to the whole session.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                  const SizedBox(height: 12),
                  for (final item in library)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primaryForestGreen,
                      value: draft.contains(item),
                      title: Text(item, style: const TextStyle(color: AppColors.primaryTextOffWhite)),
                      onChanged: (v) => setSheet(() => v == true ? draft.add(item) : draft.remove(item)),
                    ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: addCtrl,
                        onSubmitted: (_) => addItem(),
                        style: const TextStyle(color: AppColors.primaryTextOffWhite),
                        decoration: InputDecoration(
                          hintText: kind == SessionItemKind.rewards ? 'Add a reward' : 'Add equipment',
                          filled: true,
                          fillColor: AppColors.backgroundObsidian,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: addItem,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryTextOffWhite,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, draft),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: AppColors.primaryTextOffWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(draft.isEmpty ? 'Done' : 'Done (${draft.length})'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  ).whenComplete(addCtrl.dispose);
}

/// Form row used in Record Session / Record S&C Session.
class SessionItemsField extends StatelessWidget {
  final SessionItemKind kind;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const SessionItemsField({super.key, required this.kind, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardsCarbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final r = await showSessionItemsPicker(context, kind: kind, selected: selected);
          if (r != null) onChanged(r);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)),
          child: Row(children: [
            UlvenikIcon(kind.icon, size: 22, color: AppColors.secondarySage),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${kind.title} (optional)',
                    style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                const SizedBox(height: 3),
                Text(selected.isEmpty ? 'None selected' : selected.join(', '),
                    style: TextStyle(
                      color: selected.isEmpty ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                      fontSize: 14.5,
                    )),
              ]),
            ),
            const Icon(Icons.chevron_right, color: AppColors.secondaryTextStoneGrey),
          ]),
        ),
      ),
    );
  }
}
