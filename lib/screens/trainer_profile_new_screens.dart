import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/app_settings.dart';
import '../data/trainer_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';
import '../widgets/ulvenik_icon.dart';

void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
bool _validUrl(String v) => v.isEmpty || RegExp(r'^(https?://)?[^\s/]+\.[^\s/]+(/\S*)?$').hasMatch(v);

Future<void> _persist(BuildContext context) async {
  final ok = await TrainerStore.instance.saveProfile();
  if (!ok && context.mounted) {
    AppSnackbar.show(context, message: 'Your changes couldn’t be saved. Please try again.', type: SnackbarType.error);
  }
}

Future<void> _pickImage(BuildContext context, {required bool cover}) async {
  final src = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.cardsCarbon,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined, color: AppColors.primaryTextOffWhite),
          title: const Text('Take Photo', style: TextStyle(color: AppColors.primaryTextOffWhite)),
          onTap: () => Navigator.pop(ctx, ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_outlined, color: AppColors.primaryTextOffWhite),
          title: const Text('Choose from Library', style: TextStyle(color: AppColors.primaryTextOffWhite)),
          onTap: () => Navigator.pop(ctx, ImageSource.gallery),
        ),
      ]),
    ),
  );
  if (src == null) return;
  try {
    final f = await ImagePicker().pickImage(source: src, maxWidth: 1600, imageQuality: 88);
    if (f == null) return;
    final p = TrainerStore.instance.profile;
    if (cover) {
      p.coverPath = f.path;
    } else {
      p.photoPath = f.path;
    }
    await _persist(context);
  } catch (_) {
    if (context.mounted) {
      AppSnackbar.show(context, message: 'Couldn’t open your photos. Check that access is allowed in your device settings.', type: SnackbarType.error);
    }
  }
}

/// Trainer Profile: one saved business identity. Each section has its own
/// focused form; the pencil edits the overall profile. Nothing is marked
/// verified or accredited — entered qualifications are only what you typed.
class TrainerProfileScreen extends StatelessWidget {
  const TrainerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TrainerStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([store, AppSettings.instance]),
      builder: (context, _) {
        final p = store.profile;
        final name = p.trainerName.isNotEmpty ? p.trainerName : AppSettings.instance.displayName;
        final clients = store.clients().where((c) => !c.archived && c.active).toList();
        final dogs = {for (final c in clients) ...c.dogs.map((d) => d.toLowerCase())}.length;

        Widget section(String title, String addLabel, VoidCallback onAdd, List<Widget> rows, {String? empty}) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                  TextButton(
                    onPressed: onAdd,
                    child: Text(addLabel, style: const TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
                  ),
                ]),
                if (rows.isEmpty && empty != null)
                  Text(empty, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
                ...rows,
              ]),
            );

        return HealthScaffold(
          title: 'Trainer Profile',
          actions: [
            IconButton(
              tooltip: 'Edit Trainer Profile',
              icon: const UlvenikIcon(UlvenikIcons.edit, color: AppColors.primaryTextOffWhite),
              onPressed: () => _go(context, const EditTrainerProfileScreen()),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Stack(clipBehavior: Clip.none, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: p.coverPath.isNotEmpty
                        ? Image.file(File(p.coverPath), fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.cardsCarbon))
                        : const ColoredBox(color: AppColors.cardsCarbon),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: TextButton(
                    onPressed: () => _pickImage(context, cover: true),
                    style: TextButton.styleFrom(backgroundColor: Colors.black54, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10)),
                    child: const Text('Change cover', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                GestureDetector(
                  onTap: () => _pickImage(context, cover: false),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: p.photoPath.isNotEmpty
                          ? Image.file(File(p.photoPath), fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.cardsCarbon))
                          : const ColoredBox(color: AppColors.cardsCarbon, child: Icon(Icons.add_a_photo_outlined, color: AppColors.secondarySage)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Business photo', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 12),
              Text(p.businessName.isEmpty ? 'Add your business name' : p.businessName,
                  style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 24, fontWeight: FontWeight.w700)),
              if (name.isNotEmpty)
                Text(name, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: HealthCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Active clients', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      Text('${clients.length}',
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HealthCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Client dogs', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      Text('$dogs',
                          style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 22, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 22),
              section('Bio', p.bio.isEmpty ? 'Add Bio' : 'Edit Bio', () => _go(context, const EditBioScreen()),
                  [if (p.bio.isNotEmpty) Text(p.bio, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5, height: 1.45))],
                  empty: 'No bio yet.'),
              section('Expertise', 'Edit Expertise', () => _go(context, const EditExpertiseScreen()), [
                if (p.expertise.isNotEmpty)
                  Wrap(spacing: 8, runSpacing: 6, children: [
                    for (final e in p.expertise)
                      Chip(
                        label: Text(e, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                        backgroundColor: AppColors.cardsCarbon,
                        side: const BorderSide(color: Colors.white12),
                      ),
                  ]),
              ], empty: 'No expertise added yet.'),
              section('Contact', 'Edit Contact', () => _go(context, const EditContactScreen()), [
                for (final r in [('Email', p.email), ('Instagram', p.instagram), ('Website', p.website)])
                  if (r.$2.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('${r.$1}: ${r.$2}', style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5)),
                    ),
              ], empty: 'No contact details yet.'),
              section('Qualifications', 'Add Qualification', () => _go(context, const QualificationFormScreen()), [
                for (var i = 0; i < p.qualifications.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HealthCard(
                      onTap: () => _go(context, QualificationFormScreen(index: i)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.qualifications[i]['title'] ?? '',
                            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                        if ((p.qualifications[i]['org'] ?? '').isNotEmpty)
                          Text(p.qualifications[i]['org']!, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        Text(
                          [
                            if ((p.qualifications[i]['awarded'] ?? '').isNotEmpty) 'Awarded ${p.qualifications[i]['awarded']}',
                            if (p.qualifications[i]['expires'] == 'none') 'Does not expire'
                            else if ((p.qualifications[i]['expires'] ?? '').isNotEmpty) 'Expires ${p.qualifications[i]['expires']}',
                          ].join(' · '),
                          style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5),
                        ),
                      ]),
                    ),
                  ),
              ], empty: 'No qualifications added yet.'),
              section('Services', 'Add Service', () => _go(context, const ServiceFormScreen()), [
                for (var i = 0; i < p.services.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HealthCard(
                      onTap: () => _go(context, ServiceFormScreen(index: i)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.services[i]['name'] ?? '',
                            style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 15, fontWeight: FontWeight.w600)),
                        if ((p.services[i]['description'] ?? '').isNotEmpty)
                          Text(p.services[i]['description']!, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
                        Text(
                          [
                            if ((p.services[i]['duration'] ?? '').isNotEmpty) '${p.services[i]['duration']} min',
                            if (p.services[i]['enquiry'] == 'yes') 'Price on enquiry'
                            else if ((p.services[i]['amount'] ?? '').isNotEmpty)
                              '${p.services[i]['currency'] ?? ''} ${p.services[i]['amount']}${(p.services[i]['basis'] ?? '').isEmpty ? '' : ' per ${p.services[i]['basis']}'}',
                          ].join(' · '),
                          style: const TextStyle(color: AppColors.secondarySage, fontSize: 12.5),
                        ),
                      ]),
                    ),
                  ),
              ], empty: 'No services added yet.'),
              const Text('What you add here is for you and your clients. It isn’t a public directory listing.',
                  style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5, height: 1.4)),
            ],
          ),
        );
      },
    );
  }
}

/// Generic single-purpose form shell: one Save Changes, discard prompt.
class _FormShell extends StatefulWidget {
  final String title;
  final bool Function() dirty;
  final bool Function() validate;
  final Future<void> Function() onSave;
  final Widget Function(void Function() refresh) body;
  const _FormShell({
    required this.title,
    required this.dirty,
    required this.validate,
    required this.onSave,
    required this.body,
  });

  @override
  State<_FormShell> createState() => _FormShellState();
}

class _FormShellState extends State<_FormShell> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.dirty(),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final r = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardsCarbon,
            title: const Text('Discard changes?', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep Editing')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard Changes')),
            ],
          ),
        );
        if (r == true && context.mounted) Navigator.pop(context);
      },
      child: HealthScaffold(
        title: widget.title,
        bottom: PrimaryButton(
          label: 'Save Changes',
          icon: UlvenikIcons.save,
          onPressed: () async {
            if (_saving) return;
            setState(() {});
            if (!widget.validate()) {
              setState(() {});
              return;
            }
            _saving = true;
            await widget.onSave();
            if (context.mounted) Navigator.pop(context);
          },
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [widget.body(() => setState(() {}))],
        ),
      ),
    );
  }
}

TextField _tf(TextEditingController c, String hint, {int lines = 1, String? error, TextInputType? type}) => TextField(
      controller: c,
      minLines: lines,
      maxLines: lines == 1 ? 1 : lines + 4,
      keyboardType: type,
      style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
      decoration: healthDecoration(hint, error: error),
    );

class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key});

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  final _p = TrainerStore.instance.profile;
  late final _bio = TextEditingController(text: _p.bio);

  @override
  void dispose() {
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormShell(
        title: _p.bio.isEmpty ? 'Add Bio' : 'Edit Bio',
        dirty: () => _bio.text != _p.bio,
        validate: () => true,
        onSave: () async {
          _p.bio = _bio.text.trim();
          await _persist(context);
        },
        body: (_) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const FieldLabel('Bio'),
          _tf(_bio, 'Tell clients about you and how you train', lines: 6),
        ]),
      );
}

class EditExpertiseScreen extends StatefulWidget {
  const EditExpertiseScreen({super.key});

  @override
  State<EditExpertiseScreen> createState() => _EditExpertiseScreenState();
}

class _EditExpertiseScreenState extends State<EditExpertiseScreen> {
  final _p = TrainerStore.instance.profile;
  late List<String> _tags = [..._p.expertise];
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  bool _same() => _tags.length == _p.expertise.length && _tags.every(_p.expertise.contains);

  @override
  Widget build(BuildContext context) => _FormShell(
        title: 'Edit Expertise',
        dirty: () => !_same() || _input.text.trim().isNotEmpty,
        validate: () => true,
        onSave: () async {
          final t = _input.text.trim();
          if (t.isNotEmpty && !_tags.any((e) => e.toLowerCase() == t.toLowerCase())) _tags.add(t);
          _p.expertise = _tags;
          await _persist(context);
        },
        body: (refresh) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const FieldLabel('Expertise'),
          Row(children: [
            Expanded(child: _tf(_input, 'Add an area of expertise')),
            TextButton(
              onPressed: () {
                final t = _input.text.trim();
                if (t.isEmpty) return;
                if (!_tags.any((e) => e.toLowerCase() == t.toLowerCase())) _tags = [..._tags, t];
                _input.clear();
                refresh();
              },
              child: const Text('Add', style: TextStyle(color: AppColors.primaryForestGreen, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, children: [
            for (final t in _tags)
              InputChip(
                label: Text(t, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13)),
                backgroundColor: AppColors.cardsCarbon,
                side: const BorderSide(color: Colors.white12),
                deleteIconColor: AppColors.secondaryTextStoneGrey,
                onDeleted: () {
                  _tags = [..._tags]..remove(t);
                  refresh();
                },
              ),
          ]),
        ]),
      );
}

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _p = TrainerStore.instance.profile;
  late final _email = TextEditingController(text: _p.email);
  late final _insta = TextEditingController(text: _p.instagram);
  late final _web = TextEditingController(text: _p.website);
  String? _eErr;
  String? _wErr;

  @override
  void dispose() {
    _email.dispose();
    _insta.dispose();
    _web.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormShell(
        title: 'Edit Contact',
        dirty: () => _email.text != _p.email || _insta.text != _p.instagram || _web.text != _p.website,
        validate: () {
          _eErr = _email.text.trim().isNotEmpty && !_emailRe.hasMatch(_email.text.trim()) ? 'Enter a valid email address.' : null;
          _wErr = !_validUrl(_web.text.trim()) ? 'Enter a valid website address.' : null;
          return _eErr == null && _wErr == null;
        },
        onSave: () async {
          _p.email = _email.text.trim();
          _p.instagram = _insta.text.trim();
          _p.website = _web.text.trim();
          await _persist(context);
        },
        body: (_) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const FieldLabel('Contact email'),
          _tf(_email, 'Enter a contact email', error: _eErr, type: TextInputType.emailAddress),
          const FieldLabel('Instagram'),
          _tf(_insta, 'Enter your Instagram handle'),
          const FieldLabel('Website'),
          _tf(_web, 'Enter your website address', error: _wErr, type: TextInputType.url),
        ]),
      );
}

/// Overall edit: business and trainer names plus the profile basics. Writes to
/// the same saved profile as the focused forms.
class EditTrainerProfileScreen extends StatefulWidget {
  const EditTrainerProfileScreen({super.key});

  @override
  State<EditTrainerProfileScreen> createState() => _EditTrainerProfileScreenState();
}

class _EditTrainerProfileScreenState extends State<EditTrainerProfileScreen> {
  final _p = TrainerStore.instance.profile;
  late final _biz = TextEditingController(text: _p.businessName);
  late final _name = TextEditingController(text: _p.trainerName);
  late final _bio = TextEditingController(text: _p.bio);
  late final _email = TextEditingController(text: _p.email);
  late final _insta = TextEditingController(text: _p.instagram);
  late final _web = TextEditingController(text: _p.website);
  String? _eErr;
  String? _wErr;

  @override
  void dispose() {
    for (final c in [_biz, _name, _bio, _email, _insta, _web]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormShell(
        title: 'Edit Trainer Profile',
        dirty: () =>
            _biz.text != _p.businessName ||
            _name.text != _p.trainerName ||
            _bio.text != _p.bio ||
            _email.text != _p.email ||
            _insta.text != _p.instagram ||
            _web.text != _p.website,
        validate: () {
          _eErr = _email.text.trim().isNotEmpty && !_emailRe.hasMatch(_email.text.trim()) ? 'Enter a valid email address.' : null;
          _wErr = !_validUrl(_web.text.trim()) ? 'Enter a valid website address.' : null;
          return _eErr == null && _wErr == null;
        },
        onSave: () async {
          _p
            ..businessName = _biz.text.trim()
            ..trainerName = _name.text.trim()
            ..bio = _bio.text.trim()
            ..email = _email.text.trim()
            ..instagram = _insta.text.trim()
            ..website = _web.text.trim();
          await _persist(context);
        },
        body: (_) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const FieldLabel('Business name'),
          _tf(_biz, 'Enter your business name'),
          const FieldLabel('Trainer name'),
          _tf(_name, AppSettings.instance.displayName.isEmpty ? 'Enter your professional name' : AppSettings.instance.displayName),
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Leave blank to use the name from My Profile.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12.5)),
          ),
          const FieldLabel('Bio'),
          _tf(_bio, 'Tell clients about you and how you train', lines: 4),
          const FieldLabel('Contact email'),
          _tf(_email, 'Enter a contact email', error: _eErr, type: TextInputType.emailAddress),
          const FieldLabel('Instagram'),
          _tf(_insta, 'Enter your Instagram handle'),
          const FieldLabel('Website'),
          _tf(_web, 'Enter your website address', error: _wErr, type: TextInputType.url),
        ]),
      );
}

class QualificationFormScreen extends StatefulWidget {
  final int? index;
  const QualificationFormScreen({super.key, this.index});

  @override
  State<QualificationFormScreen> createState() => _QualificationFormScreenState();
}

class _QualificationFormScreenState extends State<QualificationFormScreen> {
  final _p = TrainerStore.instance.profile;
  late final Map<String, String> _q = widget.index == null ? {} : {..._p.qualifications[widget.index!]};
  late final _title = TextEditingController(text: _q['title'] ?? '');
  late final _org = TextEditingController(text: _q['org'] ?? '');
  late DateTime? _awarded = DateTime.tryParse(_q['awarded'] ?? '');
  late DateTime? _expires = DateTime.tryParse(_q['expires'] ?? '');
  late bool _noExpiry = _q['expires'] == 'none';
  String? _err;

  @override
  void dispose() {
    _title.dispose();
    _org.dispose();
    super.dispose();
  }

  String _d(DateTime? d) => d == null ? '' : d.toIso8601String().substring(0, 10);

  @override
  Widget build(BuildContext context) => _FormShell(
        title: widget.index == null ? 'Add Qualification' : 'Edit Qualification',
        dirty: () => widget.index == null ? _title.text.trim().isNotEmpty : true,
        validate: () {
          _err = _title.text.trim().isEmpty ? 'Enter the qualification title.' : null;
          return _err == null;
        },
        onSave: () async {
          final m = {
            'title': _title.text.trim(),
            'org': _org.text.trim(),
            'awarded': _d(_awarded),
            'expires': _noExpiry ? 'none' : _d(_expires),
          };
          if (widget.index == null) {
            _p.qualifications = [..._p.qualifications, m];
          } else {
            _p.qualifications[widget.index!] = m;
          }
          await _persist(context);
        },
        body: (refresh) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const FieldLabel('Qualification title', required: true),
          _tf(_title, 'Enter the qualification title', error: _err),
          const FieldLabel('Awarding organisation'),
          _tf(_org, 'Enter the awarding organisation'),
          const FieldLabel('Date awarded'),
          DateField(value: _awarded, onChanged: (d) {
            _awarded = d;
            refresh();
          }, allowFuture: false),
          const FieldLabel('Expiry date'),
          DateField(value: _noExpiry ? null : _expires, hint: _noExpiry ? 'Does not expire' : 'Select date', onChanged: (d) {
            _expires = d;
            _noExpiry = false;
            refresh();
          }),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primaryForestGreen,
            title: const Text('Does not expire', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            value: _noExpiry,
            onChanged: (v) {
              _noExpiry = v;
              refresh();
            },
          ),
          if (widget.index != null)
            TextButton(
              onPressed: () async {
                final ok = await confirmDelete(context,
                    title: 'Remove qualification?', message: 'This qualification will be removed from your profile.');
                if (!ok || !context.mounted) return;
                _p.qualifications = [..._p.qualifications]..removeAt(widget.index!);
                await _persist(context);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Remove Qualification', style: TextStyle(color: Color(0xFFFFB4AB))),
            ),
        ]),
      );
}

class ServiceFormScreen extends StatefulWidget {
  final int? index;
  const ServiceFormScreen({super.key, this.index});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _p = TrainerStore.instance.profile;
  late final Map<String, String> _s = widget.index == null ? {} : {..._p.services[widget.index!]};
  late final _name = TextEditingController(text: _s['name'] ?? '');
  late final _desc = TextEditingController(text: _s['description'] ?? '');
  late final _dur = TextEditingController(text: _s['duration'] ?? '');
  late final _amount = TextEditingController(text: _s['amount'] ?? '');
  late final _currency = TextEditingController(text: _s['currency'] ?? '');
  late String _basis = _s['basis'] ?? '';
  late bool _enquiry = _s['enquiry'] == 'yes';
  String? _nErr;
  String? _dErr;
  String? _aErr;

  @override
  void dispose() {
    for (final c in [_name, _desc, _dur, _amount, _currency]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FormShell(
        title: widget.index == null ? 'Add Service' : 'Edit Service',
        dirty: () => widget.index == null ? _name.text.trim().isNotEmpty : true,
        validate: () {
          _nErr = _name.text.trim().isEmpty ? 'Enter the service name.' : null;
          final d = _dur.text.trim();
          _dErr = d.isNotEmpty && (int.tryParse(d) == null || int.parse(d) <= 0) ? 'Enter a positive number of minutes.' : null;
          final a = _amount.text.trim();
          _aErr = !_enquiry && a.isNotEmpty && double.tryParse(a) == null ? 'Enter a valid amount.' : null;
          return _nErr == null && _dErr == null && _aErr == null;
        },
        onSave: () async {
          final m = {
            'name': _name.text.trim(),
            'description': _desc.text.trim(),
            'duration': _dur.text.trim(),
            'amount': _enquiry ? '' : _amount.text.trim(),
            'currency': _enquiry ? '' : _currency.text.trim(),
            'basis': _enquiry ? '' : _basis,
            'enquiry': _enquiry ? 'yes' : '',
          };
          if (widget.index == null) {
            _p.services = [..._p.services, m];
          } else {
            _p.services[widget.index!] = m;
          }
          await _persist(context);
        },
        body: (refresh) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const FieldLabel('Service name', required: true),
          _tf(_name, 'Enter the service name', error: _nErr),
          const FieldLabel('Description'),
          _tf(_desc, 'Describe the service', lines: 3),
          const FieldLabel('Duration (minutes)'),
          _tf(_dur, 'Enter the duration', error: _dErr, type: TextInputType.number),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primaryForestGreen,
            title: const Text('Price on enquiry', style: TextStyle(color: AppColors.primaryTextOffWhite)),
            value: _enquiry,
            onChanged: (v) {
              _enquiry = v;
              refresh();
            },
          ),
          if (!_enquiry) ...[
            const FieldLabel('Price'),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 2, child: _tf(_amount, 'Amount', error: _aErr, type: const TextInputType.numberWithOptions(decimal: true))),
              const SizedBox(width: 8),
              Expanded(child: _tf(_currency, 'Currency')),
            ]),
            const SizedBox(height: 10),
            ChoiceRow(
              options: const ['session', 'hour', 'day'],
              value: _basis.isEmpty ? null : _basis,
              onChanged: (v) {
                _basis = _basis == v ? '' : v;
                refresh();
              },
            ),
          ],
          if (widget.index != null)
            TextButton(
              onPressed: () async {
                final ok = await confirmDelete(context, title: 'Remove service?', message: 'This service will be removed from your profile.');
                if (!ok || !context.mounted) return;
                _p.services = [..._p.services]..removeAt(widget.index!);
                await _persist(context);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Remove Service', style: TextStyle(color: Color(0xFFFFB4AB))),
            ),
        ]),
      );
}
