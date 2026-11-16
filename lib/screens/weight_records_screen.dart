import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_chart.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

/// Weight Records for one dog: latest weight, filtered chart, newest-first
/// history, add / edit / delete. Past dates and either unit are allowed.
class WeightRecordsScreen extends StatefulWidget {
  final String dogName;
  const WeightRecordsScreen({super.key, required this.dogName});

  @override
  State<WeightRecordsScreen> createState() => _WeightRecordsScreenState();
}

class _WeightRecordsScreenState extends State<WeightRecordsScreen> {
  final _store = HealthStore.instance;
  String _filter = 'Lifetime';

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _openForm([WeightEntry? e]) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _WeightForm(dogName: widget.dogName, entry: e)),
      );

  Future<void> _delete(WeightEntry e) async {
    final ok = await confirmDelete(context,
        title: 'Delete weight record?', message: 'This weight record will be permanently deleted.');
    if (!ok || !mounted) return;
    _store.deleteWeight(widget.dogName, e.id);
    AppSnackbar.show(context, message: 'Weight record deleted', type: SnackbarType.success);
  }

  @override
  Widget build(BuildContext context) {
    final all = _store.weights(widget.dogName);
    final latest = all.isEmpty ? null : all.first;
    final pts = filterTrend([for (final w in all) TrendPoint(w.date, toPrefWeight(w.kg))], _filter);

    return HealthScaffold(
      title: 'Weight',
      bottom: all.isEmpty ? null : PrimaryButton(label: 'Add Weight Record', icon: UlvenikIcons.add, onPressed: _openForm),
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.monitor_weight_outlined,
                title: 'No Weight Records Yet',
                message: 'Add your dog’s first weight to begin tracking changes over time.',
                actionLabel: 'Add Weight Record',
                onAction: _openForm,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                HealthCard(
                  child: Row(children: [
                    const Icon(Icons.monitor_weight_outlined, color: kHealthGreen, size: 26),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Current Weight',
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        Text('${fmtKg(double.parse(toPrefWeight(latest!.kg).toStringAsFixed(1)))} ${prefWeightUnit()}',
                            style: const TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 26, fontWeight: FontWeight.w700)),
                        Text('Recorded ${fmtDate(latest.date)}',
                            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 18),
                TrendFilterBar(value: _filter, onChanged: (v) => setState(() => _filter = v)),
                const SizedBox(height: 12),
                HealthCard(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                  child: SizedBox(
                    height: 200,
                    child: pts.isEmpty
                        ? const Center(
                            child: Text('No weights recorded in this period.',
                                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)))
                        : TrendChart(points: pts, format: (v) => '${fmtKg(double.parse(v.toStringAsFixed(1)))} ${prefWeightUnit()}'),
                  ),
                ),
                const SizedBox(height: 22),
                const SectionLabel('History'),
                for (final w in all) ...[
                  HealthCard(
                    onTap: () => _openForm(w),
                    padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${fmtKg(double.parse(toPrefWeight(w.kg).toStringAsFixed(1)))} ${prefWeightUnit()}',
                              style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(fmtDate(w.date) + (w.time == null ? '' : ' · ${w.time}'),
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                          if (w.notes.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(w.notes,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                            ),
                        ]),
                      ),
                      RecordMenu(onEdit: () => _openForm(w), onDelete: () => _delete(w)),
                    ]),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}

class _WeightForm extends StatefulWidget {
  final String dogName;
  final WeightEntry? entry;
  const _WeightForm({required this.dogName, this.entry});

  @override
  State<_WeightForm> createState() => _WeightFormState();
}

class _WeightFormState extends State<_WeightForm> {
  late final _weight = TextEditingController(text: widget.entry == null ? '' : fmtKg(widget.entry!.value));
  late final _notes = TextEditingController(text: widget.entry?.notes ?? '');
  late String _unit = widget.entry?.unit ?? 'kg';
  late DateTime _date = widget.entry?.date ?? DateTime.now();
  late String? _time = widget.entry?.time;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _weight.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null) setState(() => _time = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
  }

  void _save() {
    if (_saving) return;
    final v = double.tryParse(_weight.text.trim().replaceAll(',', '.'));
    if (v == null || v <= 0) {
      setState(() => _error = 'Please enter a weight.');
      return;
    }
    _saving = true;
    final store = HealthStore.instance;
    store.saveWeight(
      widget.dogName,
      WeightEntry(
        id: widget.entry?.id ?? store.newId(),
        date: _date,
        value: v,
        unit: _unit,
        time: _time,
        notes: _notes.text.trim(),
      ),
    );
    AppSnackbar.show(context, message: 'Weight record saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: widget.entry == null ? 'Add Weight Record' : 'Edit Weight Record',
      bottom: PrimaryButton(label: 'Save', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const FieldLabel('Weight', required: true),
          TextField(
            controller: _weight,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _error == null ? null : setState(() => _error = null),
            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. 28.5', error: _error, suffix: _unit),
          ),
          const SizedBox(height: 10),
          ChoiceRow(options: const ['kg', 'lb'], value: _unit, onChanged: (v) => setState(() => _unit = v)),
          const FieldLabel('Date', required: true),
          DateField(value: _date, onChanged: (d) => setState(() => _date = d), allowFuture: false),
          const FieldLabel('Time'),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _pickTime,
            child: InputDecorator(
              decoration: healthDecoration('Select time'),
              child: Row(children: [
                Expanded(
                  child: Text(_time ?? 'Select time',
                      style: TextStyle(
                          color: _time == null ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                          fontSize: 14.5)),
                ),
                if (_time != null)
                  GestureDetector(
                    onTap: () => setState(() => _time = null),
                    child: const Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                  ),
              ]),
            ),
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
