import 'package:flutter/material.dart';
import '../data/media_store.dart';
import '../theme/app_colors.dart';
import '../widgets/health_ui.dart';

/// One field of a support form.
class _F {
  final String key;
  final String label;
  final String hint;
  final bool required;
  final int lines;
  final List<String>? options; // category-style single choice
  const _F(this.key, this.label, this.hint, {this.required = false, this.lines = 1, this.options});
}

class _SupportFormScreen extends StatefulWidget {
  final String title;
  final String intro;
  final String sendLabel;
  final List<_F> fields;
  final bool attachments;
  final bool replyEmail;
  const _SupportFormScreen({
    required this.title,
    required this.intro,
    required this.sendLabel,
    required this.fields,
    this.attachments = false,
    this.replyEmail = false,
  });

  @override
  State<_SupportFormScreen> createState() => _SupportFormScreenState();
}

class _SupportFormScreenState extends State<_SupportFormScreen> {
  late final Map<String, TextEditingController> _c = {for (final f in widget.fields) f.key: TextEditingController()};
  final Map<String, String> _choice = {};
  final _email = TextEditingController();
  List<String> _files = [];
  final Set<String> _errors = {};
  String? _emailError;
  bool _sending = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    _email.dispose();
    super.dispose();
  }

  bool get _dirty => _c.values.any((c) => c.text.isNotEmpty) || _files.isNotEmpty || _choice.isNotEmpty;

  Future<void> _send() async {
    if (_sending) return;
    _errors.clear();
    for (final f in widget.fields) {
      final v = f.options != null ? (_choice[f.key] ?? '') : _c[f.key]!.text.trim();
      if (f.required && v.isEmpty) _errors.add(f.key);
    }
    String? emailErr;
    if (widget.replyEmail) {
      final e = _email.text.trim();
      if (e.isEmpty || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) emailErr = 'Enter a valid email address.';
    }
    setState(() => _emailError = emailErr);
    if (_errors.isNotEmpty || emailErr != null) {
      setState(() {});
      return;
    }
    setState(() => _sending = true);
    // This build has no connection to a support service, so nothing is sent
    // and nothing is reported as received. The entered text is kept.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _sending = false);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardsCarbon,
        title: Text('Couldn’t send', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
        content: Text(
            'This version of Ulvenik can’t send messages to support yet, so nothing was sent. What you wrote has been kept.',
            style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardsCarbon,
            title: Text('Discard changes?', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep Editing')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard Changes')),
            ],
          ),
        );
        if (discard == true && context.mounted) Navigator.pop(context);
      },
      child: HealthScaffold(
        title: widget.title,
        bottom: PrimaryButton(label: widget.sendLabel, onPressed: _send),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(widget.intro, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5, height: 1.4)),
            for (final f in widget.fields) ...[
              FieldLabel(f.label, required: f.required),
              if (f.options != null)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ChoiceRow(
                    options: f.options!,
                    value: _choice[f.key],
                    onChanged: (v) => setState(() {
                      _choice[f.key] = v;
                      _errors.remove(f.key);
                    }),
                  ),
                  if (_errors.contains(f.key))
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('Choose an option.', style: TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5)),
                    ),
                ])
              else
                TextField(
                  controller: _c[f.key],
                  minLines: f.lines,
                  maxLines: f.lines == 1 ? 1 : f.lines + 3,
                  onChanged: (_) => setState(() => _errors.remove(f.key)),
                  style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                  decoration: healthDecoration(f.hint, error: _errors.contains(f.key) ? 'This field is required.' : null),
                ),
            ],
            if (widget.attachments) ...[
              const FieldLabel('Attachments'),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final r = await pickMediaFiles();
                    if (r.isNotEmpty) setState(() => _files = {..._files, ...r.map((f) => f.name)}.toList());
                  },
                  icon: const Icon(Icons.attach_file, size: 18),
                  label: const Text('Add Attachment'),
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
            if (widget.replyEmail) ...[
              const FieldLabel('Reply email', required: true),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _emailError == null ? null : setState(() => _emailError = null),
                style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14.5),
                decoration: healthDecoration('Enter your email address', error: _emailError),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

const _supportCategories = ['Account', 'Billing and subscription', 'Training and sessions', 'Health', 'Media', 'Other'];

class ContactSupportForm extends StatelessWidget {
  const ContactSupportForm({super.key});

  @override
  Widget build(BuildContext context) => const _SupportFormScreen(
        title: 'Contact Support',
        intro: 'Tell us what you need help with.',
        sendLabel: 'Send support request',
        attachments: true,
        replyEmail: true,
        fields: [
          _F('category', 'Category', '', required: true, options: _supportCategories),
          _F('subject', 'Subject', 'Briefly describe your question or issue', required: true),
          _F('message', 'Message', 'Tell us what you need help with and include any relevant details',
              required: true, lines: 5),
        ],
      );
}

class ReportBugForm extends StatelessWidget {
  const ReportBugForm({super.key});

  @override
  Widget build(BuildContext context) => const _SupportFormScreen(
        title: 'Report a Bug',
        intro: 'Tell us what went wrong so we can investigate.',
        sendLabel: 'Send bug report',
        attachments: true,
        fields: [
          _F('category', 'Category', '', required: true, options: _supportCategories),
          _F('title', 'Title', 'Briefly describe the issue', required: true),
          _F('what', 'What happened?', 'Tell us what you expected and what actually happened', required: true, lines: 4),
          _F('steps', 'Steps to reproduce', 'List the steps that lead to the problem', lines: 3),
        ],
      );
}

class SuggestFeatureForm extends StatelessWidget {
  const SuggestFeatureForm({super.key});

  @override
  Widget build(BuildContext context) => const _SupportFormScreen(
        title: 'Suggest a feature',
        intro: 'Tell us what you’d like to see in Ulvenik and how it would help.',
        sendLabel: 'Send suggestion',
        fields: [
          _F('area', 'App area', '',
              options: ['Training', 'S&C', 'Health', 'Sport', 'Media', 'Timeline', 'Other']),
          _F('title', 'Suggestion title', 'Give your idea a short title', required: true),
          _F('idea', 'Describe your idea', 'What would you like to do, and how would this help?', required: true, lines: 5),
        ],
      );
}
