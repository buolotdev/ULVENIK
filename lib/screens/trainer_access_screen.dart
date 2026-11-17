import 'package:flutter/material.dart';
import '../data/app_settings.dart';
import '../data/trainer_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';

/// Trainer Access for one client: what this trainer can do with that client's
/// records. Edits are staged and saved once; leaving with changes asks first.
/// Reset discards pending edits only — it never widens access.
class TrainerAccessScreen extends StatefulWidget {
  final String clientId;
  const TrainerAccessScreen({super.key, required this.clientId});

  @override
  State<TrainerAccessScreen> createState() => _TrainerAccessScreenState();
}

class _TrainerAccessScreenState extends State<TrainerAccessScreen> {
  final _store = TrainerStore.instance;
  late Set<String> _saved = {..._store.access(widget.clientId).grants};
  late Set<String> _draft = {..._saved};
  bool _saving = false;

  bool get _dirty => !(_draft.length == _saved.length && _draft.containsAll(_saved));

  String get _preset {
    for (final e in kPresetGrants.entries) {
      if (e.value.length == _draft.length && e.value.containsAll(_draft)) return e.key;
    }
    return 'Custom';
  }

  /// Turning a switch on needs View in the same section; turning View off
  /// clears the section's other actions.
  void _toggle(String key, bool on) {
    final section = key.split('.').first;
    setState(() {
      if (on) {
        _draft.add(key);
        if (!key.endsWith('.view')) _draft.add('$section.view');
      } else {
        _draft.remove(key);
        if (key.endsWith('.view')) _draft.removeWhere((k) => k.startsWith('$section.'));
      }
    });
  }

  String _summary() {
    final added = _draft.difference(_saved).length;
    final removed = _saved.difference(_draft).length;
    return 'Access updated (${[if (added > 0) '$added added', if (removed > 0) '$removed removed'].join(', ')})';
  }

  Future<void> _save() async {
    if (_saving || !_dirty) return;
    setState(() => _saving = true);
    final g = _store.access(widget.clientId);
    final next = AccessGrant(preset: _preset, grants: {..._draft}, history: [
      AccessChange(AppSettings.instance.displayName.isEmpty ? 'You' : AppSettings.instance.displayName, _summary(), DateTime.now()),
      ...g.history,
    ]);
    final ok = await _store.saveAccess(widget.clientId, next);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      setState(() => _saved = {..._draft});
      AppSnackbar.show(context, message: 'Access saved', type: SnackbarType.success);
    } else {
      AppSnackbar.show(context,
          message: 'Your changes couldn’t be saved. They’re still here — try again.', type: SnackbarType.error);
    }
  }

  Future<bool> _confirmDiscard() async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        title: Text('Discard changes?', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
        content: Text('You have unsaved access changes.', style: TextStyle(color: AppColors.secondaryTextStoneGrey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep Editing')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard Changes')),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final client = _store.client(widget.clientId);
    final me = AppSettings.instance.displayName.isEmpty ? 'You' : AppSettings.instance.displayName;
    final history = _store.access(widget.clientId).history;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) Navigator.pop(context);
      },
      child: HealthScaffold(
        title: 'Trainer Access',
        bottom: Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _dirty ? () => setState(() => _draft = {..._saved}) : null,
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Discard Changes'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _dirty && !_saving ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.onForestGreen,
                  disabledBackgroundColor: AppColors.cardsCarbon,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ]),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            HealthCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$me → ${client?.name ?? 'Client'}',
                    style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  client == null || client.dogs.isEmpty ? 'No dogs added yet' : 'Dogs included: ${client.dogs.join(', ')}',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  'This sets what you can do with records for this client. It applies to records you create. Your client’s own records need their approval.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4),
                ),
              ]),
            ),
            const SectionLabel('Preset'),
            ChoiceRow(
              options: const ['Read Only', 'Training & Homework', 'Custom'],
              value: _preset,
              onChanged: (v) {
                if (v == 'Custom') return; // edit individual switches to reach Custom
                setState(() => _draft = {...kPresetGrants[v]!});
              },
            ),
            const SizedBox(height: 6),
            Text(
              switch (_preset) {
                'Read Only' => 'You can view records but not add or change them.',
                'Training & Homework' => 'You can view records, add and edit sessions and assign homework.',
                _ => 'Custom: your own mix of the options below.',
              },
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
            ),
            const SizedBox(height: 14),
            for (final sec in kAccessSections.entries)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: AppColors.secondaryTextStoneGrey,
                    collapsedIconColor: AppColors.secondaryTextStoneGrey,
                    title: Text(sec.key, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${sec.value.where((i) => _draft.contains(i.$1)).length} of ${sec.value.length} allowed',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12),
                    ),
                    children: [
                      for (final it in sec.value)
                        SwitchListTile(
                          activeThumbColor: AppColors.primaryForestGreen,
                          title: Text(it.$2, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
                          subtitle: it.$3 == null
                              ? null
                              : Text(it.$3!, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                          value: _draft.contains(it.$1),
                          onChanged: (v) => _toggle(it.$1, v),
                        ),
                    ],
                  ),
                ),
              ),
            for (final o in kOwnerControlled)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(o, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('No access. Health records belong to the dog’s owner, who has to approve this. You can’t grant it to yourself.',
                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4)),
                ]),
              ),
            const SectionLabel('Access history'),
            if (history.isEmpty)
              Text('No changes yet.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
            for (final h in history.take(10))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HealthCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h.summary, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5)),
                    Text('${h.actor} · ${fmtDate(h.at)} ${fmtTime(h.at)}',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
