import 'package:flutter/material.dart';
import '../data/health_store.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';
import 'media_links.dart';

enum LogFieldType { text, multiline, date, time, choice, number, files, link }

class LogField {
  final String label;
  final LogFieldType type;
  final List<String> options;
  final String hint;
  final bool required;
  final String? linkArea; // for [LogFieldType.link]: area whose records can be linked
  const LogField(this.label,
      {this.type = LogFieldType.text,
      this.options = const [],
      this.hint = '',
      this.required = false,
      this.linkArea});
}

class LogSection {
  final String title;
  final bool Function(HealthLog l) test;
  final bool soonestFirst;
  const LogSection(this.title, this.test, {this.soonestFirst = false});
}

/// Describes one dated Health record category. Drives list, form and detail.
class LogConfig {
  final String area;
  final String tabTitle; // shown on the switcher when a screen has several configs
  final String noun;
  final IconData icon;
  final String emptyTitle;
  final String emptyMessage;
  final String addLabel;
  final String? nameLabel; // required name field, null → no name
  final String dateLabel; // required date
  final List<LogField> fields;
  final List<LogSection> sections;
  final String? reminderFrom; // null = no reminder option, '' = main date, else a date field label
  final ReminderType reminderType;
  final bool doses; // Given / Skipped dose history
  const LogConfig({
    required this.area,
    required this.tabTitle,
    required this.noun,
    required this.icon,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.addLabel,
    required this.dateLabel,
    required this.fields,
    this.nameLabel,
    this.sections = const [],
    this.reminderFrom,
    this.reminderType = ReminderType.other,
    this.doses = false,
  });
}

DateTime? _parse(String? s) => (s == null || s.isEmpty) ? null : DateTime.tryParse(s);
DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

bool _fieldIs(HealthLog l, String f, String v) => l.fields[f] == v;
bool _futureField(HealthLog l, String f) {
  final d = _parse(l.fields[f]);
  return d != null && !d.isBefore(_today());
}

// ── Configs (field lists follow the approved Health handover) ───────────────
final parasiteConfig = LogConfig(
  area: 'parasite',
  tabTitle: 'Parasite Prevention',
  noun: 'Treatment',
  icon: Icons.bug_report_outlined,
  emptyTitle: 'No Parasite Prevention Records Yet',
  emptyMessage: 'Add your dog’s first flea, tick or worming treatment to build their history.',
  addLabel: 'Add Treatment',
  nameLabel: 'Treatment Name',
  dateLabel: 'Date Administered',
  reminderFrom: 'Next Due Date',
  reminderType: ReminderType.parasite,
  sections: [
    LogSection('Upcoming Treatments', (l) => _futureField(l, 'Next Due Date'), soonestFirst: true),
    LogSection('Treatment History', (l) => true),
  ],
  fields: const [
    LogField('Treatment Type', type: LogFieldType.choice, options: ['Flea', 'Tick', 'Worming', 'Other']),
    LogField('Product / Brand'),
    LogField('Next Due Date', type: LogFieldType.date),
    LogField('Dosage / Amount'),
    LogField('Administration Method'),
  ],
);

final medicationConfig = LogConfig(
  area: 'medication',
  tabTitle: 'Medications',
  noun: 'Medication',
  icon: Icons.medication_outlined,
  emptyTitle: 'No Medications Yet',
  emptyMessage: 'Add your dog’s first medication to track doses and history.',
  addLabel: 'Add Medication',
  nameLabel: 'Medication Name',
  dateLabel: 'Start Date',
  reminderFrom: '',
  reminderType: ReminderType.medication,
  doses: true,
  sections: [
    LogSection('Active Medications', (l) => !_fieldIs(l, 'Status', 'Completed')),
    LogSection('Medication History', (l) => true),
  ],
  fields: const [
    LogField('Dosage', hint: 'e.g. 10 mg'),
    LogField('Frequency', hint: 'e.g. Twice daily'),
    LogField('End Date', type: LogFieldType.date),
    LogField('Administration Method'),
    LogField('Prescribed By'),
    LogField('Status', type: LogFieldType.choice, options: ['Active', 'Completed']),
  ],
);

final supplementConfig = LogConfig(
  area: 'supplement',
  tabTitle: 'Supplements',
  noun: 'Supplement',
  icon: Icons.medication_liquid_outlined,
  emptyTitle: 'No Supplements Yet',
  emptyMessage: 'Add your dog’s first supplement to track what they take.',
  addLabel: 'Add Supplement',
  nameLabel: 'Supplement Name',
  dateLabel: 'Start Date',
  reminderFrom: '',
  reminderType: ReminderType.supplement,
  sections: [
    LogSection('Active Supplements', (l) => !_fieldIs(l, 'Status', 'Discontinued')),
    LogSection('Supplement History', (l) => true),
  ],
  fields: const [
    LogField('Dosage / Amount', hint: 'e.g. 1 scoop'),
    LogField('Frequency', hint: 'e.g. Daily'),
    LogField('End Date', type: LogFieldType.date),
    LogField('Brand'),
    LogField('Purpose'),
    LogField('Status', type: LogFieldType.choice, options: ['Active', 'Discontinued']),
  ],
);

final vaccinationConfig = LogConfig(
  area: 'vaccination',
  tabTitle: 'Vaccinations',
  noun: 'Vaccination',
  icon: Icons.vaccines_outlined,
  emptyTitle: 'No Vaccination Records Yet',
  emptyMessage: 'Add your dog’s first vaccination to build their history.',
  addLabel: 'Add Vaccination',
  nameLabel: 'Vaccine Name',
  dateLabel: 'Date Administered',
  reminderFrom: 'Next Due Date',
  reminderType: ReminderType.vaccination,
  sections: [
    LogSection('Upcoming Vaccinations', (l) => _futureField(l, 'Next Due Date'), soonestFirst: true),
    LogSection('Vaccination History', (l) => true),
  ],
  fields: const [
    LogField('Next Due Date', type: LogFieldType.date),
    LogField('Veterinary Practice'),
    LogField('Batch / Lot Number'),
    LogField('Vaccination Certificate', type: LogFieldType.files),
  ],
);

final titreConfig = LogConfig(
  area: 'titre',
  tabTitle: 'Titre Tests',
  noun: 'Titre Test',
  icon: Icons.science_outlined,
  emptyTitle: 'No Titre Test Records Yet',
  emptyMessage: 'Add a titre test result exactly as supplied by the laboratory.',
  addLabel: 'Add Titre Test',
  nameLabel: 'Diseases Tested',
  dateLabel: 'Test Date',
  reminderFrom: 'Next Test Date',
  reminderType: ReminderType.vaccination,
  sections: [LogSection('Titre Test Records', (l) => true)],
  fields: const [
    LogField('Test Results', type: LogFieldType.multiline, hint: 'As supplied by the laboratory', required: true),
    LogField('Veterinary Practice / Laboratory'),
    LogField('Next Test Date', type: LogFieldType.date),
    LogField('Documents', type: LogFieldType.files),
  ],
);

final vetVisitConfig = LogConfig(
  area: 'vet',
  tabTitle: 'Vet Visits',
  noun: 'Vet Visit',
  icon: Icons.local_hospital_outlined,
  emptyTitle: 'No Vet Visits Yet',
  emptyMessage: 'Add an appointment or a past visit to build your dog’s vet history.',
  addLabel: 'Add Vet Visit',
  nameLabel: 'Reason for Visit',
  dateLabel: 'Appointment Date',
  reminderFrom: '',
  reminderType: ReminderType.vetAppointment,
  sections: [
    LogSection('Upcoming Appointments', (l) => !l.date.isBefore(_today()), soonestFirst: true),
    LogSection('Visit History', (l) => true),
  ],
  fields: const [
    LogField('Appointment Time', type: LogFieldType.time, required: true),
    LogField('Veterinary Practice'),
    LogField('Veterinarian'),
    LogField('Diagnosis / Findings', type: LogFieldType.multiline),
    LogField('Treatment / Recommendations', type: LogFieldType.multiline),
    LogField('Follow-up Date', type: LogFieldType.date),
    LogField('Documents', type: LogFieldType.files),
  ],
);

final allergyConfig = LogConfig(
  area: 'allergy',
  tabTitle: 'Allergies & Medical Conditions',
  noun: 'Record',
  icon: Icons.coronavirus_outlined,
  emptyTitle: 'No Allergies or Conditions Recorded',
  emptyMessage: 'Add an allergy, sensitivity or medical condition.',
  addLabel: 'Add Record',
  nameLabel: 'Name',
  dateLabel: 'Date Identified',
  sections: [
    LogSection('Allergies & Sensitivities', (l) => _fieldIs(l, 'Record Type', 'Allergy / Sensitivity')),
    LogSection('Medical Conditions', (l) => true),
  ],
  fields: const [
    LogField('Record Type',
        type: LogFieldType.choice, options: ['Allergy / Sensitivity', 'Medical Condition'], required: true),
    LogField('Symptoms / Reactions', type: LogFieldType.multiline),
    LogField('Severity', type: LogFieldType.choice, options: ['Mild', 'Moderate', 'Severe']),
    LogField('Veterinary Confirmation', type: LogFieldType.choice, options: ['Confirmed', 'Not confirmed']),
    LogField('Treatment / Management', type: LogFieldType.multiline),
    LogField('Status', type: LogFieldType.choice, options: ['Active', 'Resolved']),
    LogField('Documents', type: LogFieldType.files),
  ],
);

final injuryConfig = LogConfig(
  area: 'injury',
  tabTitle: 'Injuries',
  noun: 'Injury',
  icon: Icons.healing_outlined,
  emptyTitle: 'No Injuries Recorded',
  emptyMessage: 'Add an injury to track its status and any linked rehabilitation.',
  addLabel: 'Add Injury',
  nameLabel: 'Injury Name',
  dateLabel: 'Date of Injury',
  sections: [
    LogSection('Active Injuries', (l) => !_fieldIs(l, 'Status', 'Resolved')),
    LogSection('Injury History', (l) => true),
  ],
  fields: const [
    LogField('Body Area'),
    LogField('Injury Description', type: LogFieldType.multiline),
    LogField('Diagnosis'),
    LogField('Severity', type: LogFieldType.choice, options: ['Mild', 'Moderate', 'Severe']),
    LogField('Treatment / Management', type: LogFieldType.multiline),
    LogField('Veterinary Practice'),
    LogField('Status', type: LogFieldType.choice, options: ['Active', 'Recovering', 'Resolved']),
    LogField('Photos and Documents', type: LogFieldType.files),
  ],
);

final rehabConfig = LogConfig(
  area: 'rehab',
  tabTitle: 'Rehabilitation',
  noun: 'Rehabilitation',
  icon: Icons.accessibility_new_outlined,
  emptyTitle: 'No Rehabilitation Records Yet',
  emptyMessage: 'Add a rehabilitation session, optionally linked to an injury.',
  addLabel: 'Add Rehabilitation Record',
  nameLabel: 'Rehabilitation Activity',
  dateLabel: 'Session Date',
  reminderFrom: 'Next Appointment',
  reminderType: ReminderType.vetAppointment,
  sections: [
    LogSection('Active Rehabilitation Programmes', (l) => !_fieldIs(l, 'Status', 'Completed')),
    LogSection('Completed Rehabilitation', (l) => true),
  ],
  fields: const [
    LogField('Linked Injury', type: LogFieldType.link, linkArea: 'injury'),
    LogField('Duration', hint: 'e.g. 30 minutes'),
    LogField('Practitioner / Clinic'),
    LogField('Exercises / Treatment', type: LogFieldType.multiline),
    LogField('Progress Notes', type: LogFieldType.multiline),
    LogField('Status', type: LogFieldType.choice, options: ['Active', 'Completed']),
    LogField('Next Appointment', type: LogFieldType.date),
    LogField('Photos and Videos', type: LogFieldType.files),
  ],
);

final documentConfig = LogConfig(
  area: 'document',
  tabTitle: 'Documents',
  noun: 'Document',
  icon: Icons.folder_outlined,
  emptyTitle: 'No Documents Yet',
  emptyMessage: 'Upload vet reports, test results, certificates and other health documents.',
  addLabel: 'Add Document',
  nameLabel: 'Document Title',
  dateLabel: 'Original Document Date',
  sections: [LogSection('Documents', (l) => true)],
  fields: const [
    LogField('File', type: LogFieldType.files, required: true),
    LogField('Linked Health Records', hint: 'e.g. Vet visit on 3 Jun, Vaccination record'),
  ],
);

final heatCycleConfig = LogConfig(
  area: 'heat',
  tabTitle: 'Heat Cycles',
  noun: 'Heat Cycle',
  icon: Icons.event_repeat_outlined,
  emptyTitle: 'No Heat Cycles Yet',
  emptyMessage: 'Record your dog’s first heat cycle to build her reproductive history.',
  addLabel: 'Add Heat Cycle',
  dateLabel: 'Cycle Start Date',
  reminderFrom: 'Next Expected Season',
  sections: [LogSection('Heat Cycles', (l) => true)],
  fields: const [
    LogField('Cycle End Date', type: LogFieldType.date),
    LogField('Discharge / Bleeding', type: LogFieldType.multiline),
    LogField('Behavioural Changes', type: LogFieldType.multiline),
    LogField('Standing Heat Dates', hint: 'e.g. 12 Jun, 13 Jun'),
    LogField('Next Expected Season', type: LogFieldType.date),
    LogField('Photos', type: LogFieldType.files),
  ],
);

final matingConfig = LogConfig(
  area: 'mating',
  tabTitle: 'Mating Records',
  noun: 'Mating',
  icon: Icons.favorite_border,
  emptyTitle: 'No Mating Records Yet',
  emptyMessage: 'Add a mating record to keep her breeding history together.',
  addLabel: 'Add Mating Record',
  dateLabel: 'Mating Date',
  sections: [LogSection('Mating Records', (l) => true)],
  fields: const [
    LogField('Mating Time', type: LogFieldType.time),
    LogField('Mating Type', type: LogFieldType.choice, options: ['Natural', 'Artificial Insemination']),
    LogField('Other Dog Name'),
    LogField('Other Dog Breed'),
    LogField('Linked Heat Cycle', type: LogFieldType.link, linkArea: 'heat'),
    LogField('Additional Mating Dates', hint: 'e.g. 14 Jun, 15 Jun'),
    LogField('Documents', type: LogFieldType.files),
  ],
);

final pregnancyConfig = LogConfig(
  area: 'pregnancy',
  tabTitle: 'Pregnancy',
  noun: 'Pregnancy',
  icon: Icons.pregnant_woman_outlined,
  emptyTitle: 'No Pregnancy Records Yet',
  emptyMessage: 'Add a pregnancy record and update it as things progress.',
  addLabel: 'Add Pregnancy Record',
  dateLabel: 'Mating / Start Date',
  reminderFrom: 'Expected Due Date',
  sections: [LogSection('Pregnancy Records', (l) => true)],
  fields: const [
    LogField('Status', type: LogFieldType.choice, options: ['Suspected', 'Confirmed', 'Completed', 'Unsuccessful']),
    LogField('Linked Mating Record', type: LogFieldType.link, linkArea: 'mating'),
    LogField('Confirmation Date', type: LogFieldType.date),
    LogField('Confirmation Method', hint: 'e.g. Ultrasound'),
    LogField('Expected Due Date', type: LogFieldType.date),
    LogField('Veterinary Appointments', type: LogFieldType.multiline),
    LogField('Photos and Documents', type: LogFieldType.files),
  ],
);

final whelpingConfig = LogConfig(
  area: 'whelping',
  tabTitle: 'Whelping',
  noun: 'Litter',
  icon: Icons.child_friendly_outlined,
  emptyTitle: 'No Whelping Records Yet',
  emptyMessage: 'Add one record per litter.',
  addLabel: 'Add Whelping Record',
  dateLabel: 'Whelping Date',
  sections: [LogSection('Whelping Records', (l) => true)],
  fields: const [
    LogField('Total Puppies Born', type: LogFieldType.number, required: true),
    LogField('Linked Pregnancy', type: LogFieldType.link, linkArea: 'pregnancy'),
    LogField('Sire', hint: 'Name and breed'),
    LogField('Male Puppies', type: LogFieldType.number),
    LogField('Female Puppies', type: LogFieldType.number),
    LogField('Live Births', type: LogFieldType.number),
    LogField('Stillbirths', type: LogFieldType.number),
    LogField('Complications / Veterinary Assistance', type: LogFieldType.multiline),
    LogField('Photos and Documents', type: LogFieldType.files),
  ],
);

final maleConfig = LogConfig(
  area: 'male',
  tabTitle: 'Male Reproductive Records',
  noun: 'Breeding',
  icon: Icons.male,
  emptyTitle: 'No Male Reproductive Records Yet',
  emptyMessage: 'Add a breeding record to keep his breeding history together.',
  addLabel: 'Add Breeding Record',
  dateLabel: 'Breeding Date',
  sections: [LogSection('Breeding Records', (l) => true)],
  fields: const [
    LogField('Mating Type', type: LogFieldType.choice, options: ['Natural', 'Artificial Insemination']),
    LogField('Dam Name'),
    LogField('Dam Breed'),
    LogField('Semen / Fertility Test Results', type: LogFieldType.multiline),
    LogField('Pregnancy Confirmed', type: LogFieldType.choice, options: ['Yes', 'No', 'Unknown']),
    LogField('Litter Outcome', type: LogFieldType.multiline),
    LogField('Linked Mating Record', type: LogFieldType.link, linkArea: 'mating'),
    LogField('Documents', type: LogFieldType.files),
  ],
);

final spayNeuterConfig = LogConfig(
  area: 'spayneuter',
  tabTitle: 'Spaying & Neutering',
  noun: 'Procedure',
  icon: Icons.medical_services_outlined,
  emptyTitle: 'No Procedure Recorded',
  emptyMessage: 'Add the procedure details, including past ones from before you joined Ulvenik.',
  addLabel: 'Add Procedure',
  dateLabel: 'Procedure Date',
  reminderFrom: 'Follow-up Appointment',
  reminderType: ReminderType.vetAppointment,
  sections: [LogSection('Procedures', (l) => true)],
  fields: const [
    LogField('Procedure Type', type: LogFieldType.choice, options: ['Spay', 'Neuter']),
    LogField('Veterinary Practice'),
    LogField('Procedure Details', type: LogFieldType.multiline),
    LogField('Complications', type: LogFieldType.multiline),
    LogField('Recovery Notes', type: LogFieldType.multiline),
    LogField('Follow-up Appointment', type: LogFieldType.date),
    LogField('Documents', type: LogFieldType.files),
  ],
);

final otherConfig = LogConfig(
  area: 'other',
  tabTitle: 'Other Records',
  noun: 'Record',
  icon: Icons.note_alt_outlined,
  emptyTitle: 'No Other Records Yet',
  emptyMessage: 'Add anything health-related that doesn’t fit another category.',
  addLabel: 'Add Record',
  nameLabel: 'Record Title',
  dateLabel: 'Record Date',
  sections: [LogSection('Records', (l) => true)],
  fields: const [
    LogField('Description', type: LogFieldType.multiline),
    LogField('Photos, Videos and Documents', type: LogFieldType.files),
    LogField('Linked Health Record', hint: 'e.g. Vet visit on 3 Jun'),
  ],
);

/// Every Health record config, by area key.
final List<LogConfig> allHealthConfigs = [
  parasiteConfig, medicationConfig, supplementConfig, vaccinationConfig, titreConfig, vetVisitConfig,
  allergyConfig, injuryConfig, rehabConfig, documentConfig, heatCycleConfig, matingConfig,
  pregnancyConfig, whelpingConfig, maleConfig, spayNeuterConfig, otherConfig,
];

/// The saved-record details screen for a Health record (used by Media links).
Widget healthLogDetails(String dogName, LogConfig config, String logId) =>
    _LogDetail(dogName: dogName, config: config, logId: logId);

String _fileNames(String? v) => (v ?? '').split('|').where((e) => e.isNotEmpty).join(', ');

/// A list screen for one or more related record configs (e.g. Injuries and
/// Rehabilitation share one category; Vaccinations include Titre Tests).
class HealthLogScreen extends StatefulWidget {
  final String dogName;
  final String title;
  final List<LogConfig> configs;
  const HealthLogScreen({super.key, required this.dogName, required this.title, required this.configs});

  @override
  State<HealthLogScreen> createState() => _HealthLogScreenState();
}

class _HealthLogScreenState extends State<HealthLogScreen> {
  final _store = HealthStore.instance;
  int _tab = 0;

  LogConfig get _cfg => widget.configs[_tab];

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

  Future<void> _openForm() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => _LogForm(dogName: widget.dogName, config: _cfg)),
      );

  String _title(HealthLog l) => l.title.isNotEmpty ? l.title : _cfg.noun;

  Widget _tile(HealthLog l) {
    final cfg = _cfg;
    final first = cfg.fields
        .where((f) => f.type == LogFieldType.choice || f.type == LogFieldType.text)
        .map((f) => l.fields[f.label])
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HealthCard(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _LogDetail(dogName: widget.dogName, config: cfg, logId: l.id)),
        ),
        child: Row(children: [
          Icon(cfg.icon, color: kHealthGreen, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_title(l),
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(fmtDate(l.date) + (first == null ? '' : ' · $first'),
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            ]),
          ),
          UlvenikIcon(UlvenikIcons.details, color: AppColors.secondaryTextStoneGrey),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg;
    final all = _store.logs(widget.dogName, cfg.area);

    // Each record goes into the first section that accepts it.
    final buckets = <LogSection, List<HealthLog>>{for (final s in cfg.sections) s: []};
    for (final l in all) {
      for (final s in cfg.sections) {
        if (s.test(l)) {
          buckets[s]!.add(l);
          break;
        }
      }
    }

    final tabs = widget.configs.length > 1
        ? Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ChoiceRow(
              options: [for (final c in widget.configs) c.tabTitle],
              value: cfg.tabTitle,
              onChanged: (v) => setState(() => _tab = widget.configs.indexWhere((c) => c.tabTitle == v)),
            ),
          )
        : const SizedBox.shrink();

    return HealthScaffold(
      title: widget.title,
      bottom: all.isEmpty ? null : PrimaryButton(label: cfg.addLabel, icon: UlvenikIcons.add, onPressed: _openForm),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          tabs,
          if (all.isEmpty)
            EmptyState(
              icon: cfg.icon,
              title: cfg.emptyTitle,
              message: cfg.emptyMessage,
              actionLabel: cfg.addLabel,
              onAction: _openForm,
            )
          else
            for (final s in cfg.sections)
              if (buckets[s]!.isNotEmpty) ...[
                SectionLabel(s.title),
                for (final l in (s.soonestFirst ? (buckets[s]!.reversed.toList()) : buckets[s]!)) _tile(l),
                const SizedBox(height: 8),
              ],
        ],
      ),
    );
  }
}

class _LogDetail extends StatefulWidget {
  final String dogName;
  final LogConfig config;
  final String logId;
  const _LogDetail({required this.dogName, required this.config, required this.logId});

  @override
  State<_LogDetail> createState() => _LogDetailState();
}

class _LogDetailState extends State<_LogDetail> {
  final _store = HealthStore.instance;

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

  HealthLog? get _log {
    for (final l in _store.allLogs(widget.dogName)) {
      if (l.id == widget.logId) return l;
    }
    return null;
  }

  void _dose(HealthLog l, String status) {
    final entries = (l.fields['_doses'] ?? '').split(';').where((e) => e.isNotEmpty).toList()
      ..add('${DateTime.now().toIso8601String().substring(0, 16)}|$status');
    l.fields['_doses'] = entries.join(';');
    _store.saveLog(widget.dogName, l);
    AppSnackbar.show(context, message: 'Dose marked as $status', type: SnackbarType.success);
  }

  @override
  Widget build(BuildContext context) {
    final l = _log;
    final cfg = widget.config;
    if (l == null) return HealthScaffold(title: cfg.noun, body: const SizedBox.shrink());

    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(k, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
            const SizedBox(height: 3),
            Text(v, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, height: 1.4)),
          ]),
        );

    final doses = (l.fields['_doses'] ?? '').split(';').where((e) => e.isNotEmpty).toList().reversed.toList();

    return HealthScaffold(
      title: cfg.noun,
      actions: [
        RecordMenu(
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _LogForm(dogName: widget.dogName, config: cfg, entry: l)),
          ),
          onDelete: () async {
            final ok = await confirmDelete(context,
                title: 'Delete record?', message: 'This record will be permanently deleted.');
            if (!ok || !context.mounted) return;
            final rid = l.fields['_reminderId'];
            if (rid != null && rid.isNotEmpty) _store.deleteReminder(widget.dogName, rid);
            MediaStore.instance.unlinkRecord(widget.dogName, 'health:${l.id}');
            _store.deleteLog(widget.dogName, l.id);
            AppSnackbar.show(context, message: 'Record deleted', type: SnackbarType.success);
            Navigator.pop(context);
          },
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          HealthCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (l.title.isNotEmpty) row(cfg.nameLabel ?? 'Name', l.title),
              row(cfg.dateLabel, fmtDate(l.date)),
              for (final f in cfg.fields)
                if ((l.fields[f.label] ?? '').isNotEmpty)
                  row(
                    f.label,
                    switch (f.type) {
                      LogFieldType.date => fmtDate(_parse(l.fields[f.label])!),
                      LogFieldType.files => _fileNames(l.fields[f.label]),
                      _ => l.fields[f.label]!,
                    },
                  ),
              if (l.notes.isNotEmpty) row('Notes', l.notes),
            ]),
          ),
          if (cfg.doses) ...[
            const SizedBox(height: 18),
            const SectionLabel('Doses'),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _dose(l, 'Given'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: BorderSide(color: AppColors.cardBorder),
                      minimumSize: const Size(0, 46)),
                  child: const Text('Given'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _dose(l, 'Skipped'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: BorderSide(color: AppColors.cardBorder),
                      minimumSize: const Size(0, 46)),
                  child: const Text('Skipped'),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            for (final d in doses)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HealthCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        '${fmtDate(DateTime.parse(d.split('|').first))} · ${fmtTime(DateTime.parse(d.split('|').first))}',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13),
                      ),
                    ),
                    Text(d.split('|').last,
                        style: TextStyle(
                            color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _LogForm extends StatefulWidget {
  final String dogName;
  final LogConfig config;
  final HealthLog? entry;
  const _LogForm({required this.dogName, required this.config, this.entry});

  @override
  State<_LogForm> createState() => _LogFormState();
}

class _LogFormState extends State<_LogForm> {
  late final _name = TextEditingController(text: widget.entry?.title ?? '');
  late final _notes = TextEditingController(text: widget.entry?.notes ?? '');
  late DateTime? _date = widget.entry?.date ?? DateTime.now();
  late final Map<String, TextEditingController> _text = {
    for (final f in widget.config.fields)
      if (f.type == LogFieldType.text || f.type == LogFieldType.multiline || f.type == LogFieldType.number)
        f.label: TextEditingController(text: widget.entry?.fields[f.label] ?? ''),
  };
  late final Map<String, String> _other = {
    for (final f in widget.config.fields)
      if (!_text.containsKey(f.label)) f.label: widget.entry?.fields[f.label] ?? '',
  };
  late bool _remind = (widget.entry?.fields['_reminderId'] ?? '').isNotEmpty;
  final Map<String, MediaFile> _pickedFiles = {};
  String? _nameError;
  final Set<String> _errors = {};
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _value(LogField f) => _text[f.label]?.text.trim() ?? _other[f.label] ?? '';

  void _save() {
    final cfg = widget.config;
    if (_saving) return;
    _errors.clear();
    for (final f in cfg.fields) {
      if (f.required && _value(f).isEmpty) _errors.add(f.label);
    }
    final nameBad = cfg.nameLabel != null && _name.text.trim().isEmpty;
    if (nameBad || _errors.isNotEmpty) {
      setState(() => _nameError = nameBad ? 'Please enter a ${cfg.nameLabel!.toLowerCase()}.' : null);
      return;
    }
    if (_date == null) return;
    _saving = true;
    final store = HealthStore.instance;
    final fields = <String, String>{
      for (final e in _text.entries) e.key: e.value.text.trim(),
      ..._other,
    };
    // keep internal data (dose history, reminder link) when editing
    for (final k in ['_doses', '_reminderId']) {
      final v = widget.entry?.fields[k];
      if (v != null) fields[k] = v;
    }
    fields.removeWhere((k, v) => v.isEmpty);
    final title = cfg.nameLabel != null ? _name.text.trim() : '';

    // Optional reminder created from the record — no retyping.
    DateTime? due;
    if (cfg.reminderFrom != null) {
      if (cfg.reminderFrom!.isEmpty) {
        due = _date;
        final t = fields[cfg.fields.firstWhere((f) => f.type == LogFieldType.time, orElse: () => const LogField('')).label];
        if (due != null && t != null && t.contains(':')) {
          final p = t.split(':');
          due = DateTime(due.year, due.month, due.day, int.parse(p[0]), int.parse(p[1]));
        }
      } else {
        due = _parse(fields[cfg.reminderFrom]);
      }
    }
    var reminderId = widget.entry?.fields['_reminderId'] ?? '';
    if (_remind && due != null) {
      reminderId = reminderId.isEmpty ? store.newId() : reminderId;
      store.saveReminder(
        widget.dogName,
        HealthReminder(
          id: reminderId,
          title: title.isNotEmpty ? title : cfg.noun,
          due: due,
          hasTime: due.hour != 0 || due.minute != 0,
          type: cfg.reminderType,
          linkedRecord: title.isNotEmpty ? title : cfg.tabTitle,
        ),
      );
      fields['_reminderId'] = reminderId;
    } else if (reminderId.isNotEmpty) {
      store.deleteReminder(widget.dogName, reminderId);
      fields.remove('_reminderId');
    }

    final logId = widget.entry?.id ?? store.newId();
    final attached = <String>{
      for (final f in cfg.fields)
        if (f.type == LogFieldType.files) ...(fields[f.label] ?? '').split('|').where((e) => e.isNotEmpty),
    };
    MediaStore.instance.attach(
      widget.dogName,
      [for (final n in attached) if (_pickedFiles[n] != null) _pickedFiles[n]!],
      MediaLinks.health(widget.dogName, cfg, logId),
      mediaDate: _date,
    );
    store.saveLog(
      widget.dogName,
      HealthLog(
        id: logId,
        area: cfg.area,
        title: title,
        date: _date!,
        fields: fields,
        notes: _notes.text.trim(),
      ),
    );
    AppSnackbar.show(context, message: 'Record saved', type: SnackbarType.success);
    Navigator.pop(context);
  }

  Future<void> _addFiles(LogField f) async {
    final r = await pickMediaFiles();
    if (r.isEmpty) return;
    for (final x in r) {
      _pickedFiles[x.name] = x;
    }
    final names = {..._other[f.label]!.split('|').where((e) => e.isNotEmpty), ...r.map((x) => x.name)};
    setState(() {
      _other[f.label] = names.join('|');
      _errors.remove(f.label);
    });
  }

  Widget _input(LogField f) {
    final err = _errors.contains(f.label) ? 'This field is required.' : null;
    switch (f.type) {
      case LogFieldType.date:
        return DateField(
          value: _parse(_other[f.label]),
          onChanged: (d) => setState(() => _other[f.label] = d.toIso8601String().substring(0, 10)),
        );
      case LogFieldType.time:
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (t != null) {
              setState(() {
                _other[f.label] = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                _errors.remove(f.label);
              });
            }
          },
          child: InputDecorator(
            decoration: healthDecoration('Select time', error: err),
            child: Text(_other[f.label]!.isEmpty ? 'Select time' : _other[f.label]!,
                style: TextStyle(
                    color: _other[f.label]!.isEmpty ? AppColors.secondaryTextStoneGrey : AppColors.primaryTextOffWhite,
                    fontSize: 14.5)),
          ),
        );
      case LogFieldType.choice:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ChoiceRow(
            options: f.options,
            value: _other[f.label]!.isEmpty ? null : _other[f.label],
            onChanged: (v) => setState(() {
              _other[f.label] = _other[f.label] == v && !f.required ? '' : v;
              _errors.remove(f.label);
            }),
          ),
          if (err != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(err, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
            ),
        ]);
      case LogFieldType.link:
        final options = [
          for (final l in HealthStore.instance.logs(widget.dogName, f.linkArea!))
            l.title.isNotEmpty ? l.title : fmtDate(l.date),
        ];
        return options.isEmpty
            ? Text('Nothing to link yet.',
                style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13))
            : ChoiceRow(
                options: options,
                value: _other[f.label]!.isEmpty ? null : _other[f.label],
                onChanged: (v) => setState(() => _other[f.label] = _other[f.label] == v ? '' : v),
              );
      case LogFieldType.files:
        final names = _other[f.label]!.split('|').where((e) => e.isNotEmpty).toList();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OutlinedButton.icon(
            onPressed: () => _addFiles(f),
            icon: const Icon(Icons.attach_file, size: 18),
            label: const Text('Add File'),
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTextOffWhite,
                side: BorderSide(color: AppColors.cardBorder),
                minimumSize: const Size(0, 44)),
          ),
          if (names.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(spacing: 8, runSpacing: 6, children: [
                for (final n in names)
                  InputChip(
                    label: Text(n, style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 12.5)),
                    backgroundColor: AppColors.cardsCarbon,
                    side: BorderSide(color: AppColors.cardBorder),
                    deleteIconColor: AppColors.secondaryTextStoneGrey,
                    onDeleted: () => setState(() => _other[f.label] = (names..remove(n)).join('|')),
                  ),
              ]),
            ),
          if (err != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(err, style: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
            ),
        ]);
      default:
        return TextField(
          controller: _text[f.label],
          keyboardType: f.type == LogFieldType.number ? TextInputType.number : null,
          minLines: f.type == LogFieldType.multiline ? 3 : 1,
          maxLines: f.type == LogFieldType.multiline ? 5 : 1,
          onChanged: (_) => _errors.contains(f.label) ? setState(() => _errors.remove(f.label)) : null,
          style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
          decoration: healthDecoration(f.hint.isEmpty ? 'Add ${f.label.toLowerCase()}' : f.hint, error: err),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    return HealthScaffold(
      title: widget.entry == null ? cfg.addLabel : 'Edit Record',
      bottom: PrimaryButton(label: 'Save', icon: UlvenikIcons.save, onPressed: _save),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if (cfg.nameLabel != null) ...[
            FieldLabel(cfg.nameLabel!, required: true),
            TextField(
              controller: _name,
              onChanged: (_) => _nameError == null ? null : setState(() => _nameError = null),
              style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
              decoration: healthDecoration('Enter ${cfg.nameLabel!.toLowerCase()}', error: _nameError),
            ),
          ],
          FieldLabel(cfg.dateLabel, required: true),
          DateField(value: _date, onChanged: (d) => setState(() => _date = d)),
          for (final f in cfg.fields) ...[
            FieldLabel(f.label, required: f.required),
            _input(f),
          ],
          if (cfg.reminderFrom != null) ...[
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primaryForestGreen,
              title: Text('Add a reminder',
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
              subtitle: Text('Creates a Health Reminder linked to this record.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
              value: _remind,
              onChanged: (v) => setState(() => _remind = v),
            ),
          ],
          const FieldLabel('Notes'),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 5,
            style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
            decoration: healthDecoration('Add notes...'),
          ),
        ],
      ),
    );
  }
}
