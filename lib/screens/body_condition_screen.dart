import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_chart.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

const _bcsGuide = <int, String>{
  1: 'Emaciated — ribs, spine and hip bones clearly visible; no body fat.',
  2: 'Very thin — ribs and spine easily visible; minimal fat.',
  3: 'Thin — ribs easily felt with no fat cover; waist and abdominal tuck obvious.',
  4: 'Slightly lean — ribs easily felt with a thin fat cover; waist clearly visible.',
  5: 'Ideal — ribs felt without excess fat; waist visible from above; abdomen tucked.',
  6: 'Slightly heavy — ribs felt with slight excess fat; waist barely visible.',
  7: 'Heavy — ribs hard to feel under thick fat; waist not visible.',
  8: 'Overweight — ribs cannot be felt; fat deposits on back and tail base.',
  9: 'Obese — heavy fat deposits over chest, spine and tail base; abdomen distended.',
};

/// Body Condition Records: owner-assigned 1–9 score, educational guide,
/// dated history, 1–9 chart with the same four date filters. The app never
/// scores the dog from its weight.
class BodyConditionScreen extends StatefulWidget {
  final String dogName;
  const BodyConditionScreen({super.key, required this.dogName});

  @override
  State<BodyConditionScreen> createState() => _BodyConditionScreenState();
}

class _BodyConditionScreenState extends State<BodyConditionScreen> {
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

  Future<void> _openForm([BcsEntry? e]) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _BcsForm(dogName: widget.dogName, entry: e)),
      );

  Future<void> _delete(BcsEntry e) async {
    final ok = await confirmDelete(context,
        title: 'Delete body condition record?', message: 'This body condition record will be permanently deleted.');
    if (!ok || !mounted) return;
    _store.deleteBcs(widget.dogName, e.id);
    AppSnackbar.show(context, message: 'Body condition record deleted', type: SnackbarType.success);
  }

  void _showGuide() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.cardsCarbon,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.92,
          builder: (_, sc) => ListView(
            controller: sc,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              const Text('Body Condition Score guide',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('A score of 4–5 out of 9 is generally considered ideal. Your own assessment is what gets recorded.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4)),
              const SizedBox(height: 16),
              for (final e in _bcsGuide.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (e.key == 4 || e.key == 5)
                            ? AppColors.primaryForestGreen
                            : AppColors.backgroundObsidian,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text('${e.key}',
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13.5, height: 1.4)),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final all = _store.bcs(widget.dogName);
    final latest = all.isEmpty ? null : all.first;
    final pts = filterTrend([for (final b in all) TrendPoint(b.date, b.score.toDouble())], _filter);

    return HealthScaffold(
      title: 'Body Condition',
      actions: [
        IconButton(
          tooltip: 'Score guide',
          icon: const Icon(Icons.info_outline, color: AppColors.secondaryTextStoneGrey),
          onPressed: _showGuide,
        ),
      ],
      bottom: all.isEmpty
          ? null
          : PrimaryButton(label: 'Add Body Condition Record', icon: UlvenikIcons.add, onPressed: _openForm),
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.accessibility_new_outlined,
                title: 'No Body Condition Records Yet',
                message: 'Add your dog’s first body condition score to track changes over time.',
                actionLabel: 'Add Body Condition Record',
                onAction: _openForm,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                HealthCard(
                  onTap: _showGuide,
                  child: Row(children: [
                    const Icon(Icons.accessibility_new_outlined, color: kHealthGreen, size: 26),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Latest score',
                            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        Text('${latest!.score} / 9',
                            style: const TextStyle(
                                color: AppColors.primaryTextOffWhite, fontSize: 26, fontWeight: FontWeight.w700)),
                        Text('Recorded ${fmtDate(latest.date)} · 4–5 is generally ideal',
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
                            child: Text('No scores recorded in this period.',
                                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)))
                        : TrendChart(
                            points: pts,
                            minY: 1,
                            maxY: 9,
                            format: (v) => '${v.round()} / 9',
                          ),
                  ),
                ),
                const SizedBox(height: 22),
                const SectionLabel('History'),
                for (final b in all) ...[
                  HealthCard(
                    onTap: () => _openForm(b),
                    padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${b.score} / 9',
                              style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(fmtDate(b.date),
                              style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                          if (b.notes.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(b.notes,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                            ),
                        ]),
                      ),
                      RecordMenu(onEdit: () => _openForm(b), onDelete: () => _delete(b)),
                    ]),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
    );
  }
}

class _BcsForm extends StatefulWidget {
  final String dogName;
  final BcsEntry? entry;
  const _BcsForm({required this.dogName, this.entry});

  @override
  State<_BcsForm> createState() => _BcsFormState();
}

class _BcsFormState extends State<_BcsForm> {
  late int? _score = widget.entry?.score;
  late DateTime _date = widget.entry?.date ?? DateTime.now();
  late final _notes = TextEditingController(text: widget.entry?.notes ?? '');
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (_saving) return;
    if (_score == null) {
      setState(() => _error = 'Please choose a score from 1 to 9.');
      return;
    }
    _saving = true;
    final store = HealthStore.instance;
    store.saveBcs(
      widget.dogName,
      BcsEntry(id: widget.entry?.id ?? store.newId(), date: _date, score: _score!, notes: _notes.text.trim()),
    );
    AppSnackbar.show(context, message: 'Body condition record saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: widget.entry == null ? 'Add Body Condition Record' : 'Edit Body Condition Record',
      bottom: PrimaryButton(label: 'Save', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const FieldLabel('Score', required: true),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var i = 1; i <= 9; i++)
              GestureDetector(
                onTap: () => setState(() {
                  _score = i;
                  _error = null;
                }),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _score == i ? AppColors.primaryForestGreen : AppColors.cardsCarbon,
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text('$i',
                      style: const TextStyle(
                          color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          Text(
            _score == null ? 'Tap a number. 4–5 out of 9 is generally considered ideal.' : _bcsGuide[_score!]!,
            style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, height: 1.4),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(_error!, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
            ),
          const FieldLabel('Date', required: true),
          DateField(value: _date, onChanged: (d) => setState(() => _date = d), allowFuture: false),
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
