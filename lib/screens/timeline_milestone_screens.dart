import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

/// Add / Edit Milestone: a manual original. Title and date are required; time,
/// notes and attachments are optional. No streaks, counts or ratings.
class MilestoneFormScreen extends StatefulWidget {
  final String dogName;
  final DateTime? date; // carried from Calendar
  final Milestone? milestone;
  const MilestoneFormScreen({super.key, required this.dogName, this.date, this.milestone});

  @override
  State<MilestoneFormScreen> createState() => _MilestoneFormScreenState();
}

class _MilestoneFormScreenState extends State<MilestoneFormScreen> {
  late final _title = TextEditingController(text: widget.milestone?.title ?? '');
  late final _notes = TextEditingController(text: widget.milestone?.notes ?? '');
  late DateTime _date = widget.milestone?.date ?? widget.date ?? DateTime.now();
  late String? _time = widget.milestone?.time;
  late List<String> _files = [...?widget.milestone?.attachments];
  final Map<String, MediaFile> _picked = {};
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _addFiles() async {
    final r = await pickMediaFiles();
    if (r.isEmpty) return;
    setState(() {
      for (final f in r) {
        _picked[f.name] = f;
      }
      _files = {..._files, ...r.map((f) => f.name)}.toList();
    });
  }

  void _save() {
    if (_saving) return;
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Enter a milestone title.');
      return;
    }
    _saving = true;
    final store = TimelineStore.instance;
    final m = widget.milestone ?? Milestone(id: store.newId(), dog: widget.dogName, title: '', date: _date);
    m
      ..title = _title.text.trim()
      ..date = _date
      ..time = _time
      ..notes = _notes.text.trim()
      ..attachments = _files;
    store.saveMilestone(m);
    final files = [for (final n in _files) if (_picked[n] != null) _picked[n]!];
    if (files.isNotEmpty) {
      MediaStore.instance.attach(
        widget.dogName,
        files,
        MediaLink(
          key: 'milestone:${m.id}',
          section: 'Training',
          label: () => store.milestone(m.id)?.title ?? 'Milestone',
          collections: () => const [],
          open: (_) => MilestoneDetailsScreen(milestoneId: m.id),
        ),
        mediaDate: _date,
      );
    }
    AppSnackbar.show(context, message: 'Milestone saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return HealthScaffold(
      title: widget.milestone == null ? 'Add Milestone' : 'Edit Milestone',
      bottom: PrimaryButton(label: 'Save Milestone', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          const FieldLabel('Dog'),
          HealthCard(child: Text(widget.dogName, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15))),
          const FieldLabel('Milestone Title', required: true),
          TextField(
            controller: _title,
            onChanged: (_) => _error == null ? null : setState(() => _error = null),
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('e.g. First off-lead forest walk', error: _error),
          ),
          const FieldLabel('Date', required: true),
          DateField(value: _date, onChanged: (d) => setState(() => _date = d), allowFuture: false),
          const FieldLabel('Time'),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
              if (t != null) setState(() => _time = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}');
            },
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
                    child: Icon(Icons.close, size: 18, color: AppColors.secondaryTextStoneGrey),
                  ),
              ]),
            ),
          ),
          const FieldLabel('Notes'),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 6,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add notes...'),
          ),
          const FieldLabel('Attachments'),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _addFiles,
              icon: const Icon(Icons.attach_file, size: 18),
              label: const Text('Add Attachments'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTextOffWhite,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size(0, 44)),
            ),
          ),
          if (_files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 8, runSpacing: 6, children: [
                for (final n in _files)
                  InputChip(
                    label: Text(n, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.cardsCarbon,
                    side: BorderSide(color: AppColors.cardBorder),
                    deleteIconColor: AppColors.secondaryTextStoneGrey,
                    onDeleted: () => setState(() => _files = [..._files]..remove(n)),
                  ),
              ]),
            ),
        ],
      ),
    );
  }
}

/// Milestone details: this exact original, with Edit / Delete.
class MilestoneDetailsScreen extends StatelessWidget {
  final String milestoneId;
  const MilestoneDetailsScreen({super.key, required this.milestoneId});

  @override
  Widget build(BuildContext context) {
    final store = TimelineStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final m = store.milestone(milestoneId);
        if (m == null) {
          return HealthScaffold(
            title: 'Milestone',
            body: const Center(
              child: EmptyState(
                icon: Icons.info_outline,
                title: 'Record Unavailable',
                message: 'This milestone is no longer available.',
              ),
            ),
          );
        }
        return HealthScaffold(
          title: 'Milestone',
          actions: [
            RecordMenu(
              onEdit: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MilestoneFormScreen(dogName: m.dog, milestone: m))),
              onDelete: () async {
                final ok = await confirmDelete(context,
                    title: 'Delete milestone?', message: 'This milestone will be permanently deleted.');
                if (!ok || !context.mounted) return;
                MediaStore.instance.unlinkRecord(m.dog, 'milestone:${m.id}');
                store.deleteMilestone(m.id);
                Navigator.pop(context);
              },
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(m.title,
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('${m.dog} · ${fmtDate(m.date)}${m.time == null ? '' : ' · ${m.time}'}',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              if (m.notes.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(m.notes, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, height: 1.45)),
              ],
              if (m.attachments.isNotEmpty) ...[
                const SizedBox(height: 18),
                const SectionLabel('Attachments'),
                Text(m.attachments.join(', '),
                    style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
              ],
            ],
          ),
        );
      },
    );
  }
}
