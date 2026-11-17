import 'package:flutter/material.dart';
import '../data/sc_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

/// Add / Edit Activity: name (required), description, and optional
/// measurements with user-selected units. No categories, icons or favourites.
/// Editing only changes the activity setup; saved session values are untouched.
class SCActivityFormScreen extends StatefulWidget {
  final String dogName;
  final SCActivity? activity;
  const SCActivityFormScreen({super.key, required this.dogName, this.activity});

  @override
  State<SCActivityFormScreen> createState() => _SCActivityFormScreenState();
}

class _SCActivityFormScreenState extends State<SCActivityFormScreen> {
  late final _name = TextEditingController(text: widget.activity?.name ?? '');
  late final _desc = TextEditingController(text: widget.activity?.description ?? '');
  late final Set<SCMeasure> _measures = {...?widget.activity?.measures};
  late final Map<SCMeasure, String> _units = {...?widget.activity?.units};
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Please enter an activity name.');
      return;
    }
    _saving = true;
    final store = SCStore.instance;
    final a = widget.activity ?? SCActivity(id: store.newId(), name: '');
    a.name = _name.text.trim();
    a.description = _desc.text.trim();
    a.measures = {..._measures};
    a.units = {for (final m in _measures) if (_units[m] != null) m: _units[m]!};
    store.saveActivity(widget.dogName, a);
    AppSnackbar.show(context, message: 'Activity saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.activity != null;
    return HealthScaffold(
      title: editing ? 'Edit Activity' : 'Add Activity',
      bottom: PrimaryButton(label: 'Save Activity', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Activity Name', required: true),
          TextField(
            controller: _name,
            onChanged: (_) => _error == null ? null : setState(() => _error = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. Cavaletti', error: _error),
          ),
          const FieldLabel('Description'),
          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: 5,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Describe this activity...'),
          ),
          const FieldLabel('Measurements'),
          Text('Choose what you want to record for this activity. All are optional.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
          const SizedBox(height: 10),
          for (final m in SCMeasure.values) ...[
            HealthCard(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryForestGreen,
                  checkColor: AppColors.primaryTextOffWhite,
                  title: Text(m.label, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15)),
                  value: _measures.contains(m),
                  onChanged: (v) => setState(() => v == true ? _measures.add(m) : _measures.remove(m)),
                ),
                if (_measures.contains(m) && m.units.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Unit',
                          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      const SizedBox(height: 6),
                      ChoiceRow(
                        options: m.units,
                        value: _units[m],
                        onChanged: (u) => setState(() => _units[m] = u),
                      ),
                    ]),
                  ),
              ]),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
