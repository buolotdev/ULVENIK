import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _BugAttachment {
  final String id;
  final String name;
  final String sizeLabel;
  final IconData icon;

  const _BugAttachment({
    required this.id,
    required this.name,
    required this.sizeLabel,
    this.icon = Icons.image_outlined,
  });
}

class ReportBugScreen extends StatefulWidget {
  final String? subscriptionPlan;
  final bool hasSportPack;
  final bool hasTrainerPack;

  const ReportBugScreen({
    super.key,
    this.subscriptionPlan,
    this.hasSportPack = false,
    this.hasTrainerPack = false,
  });

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _dashedFill = Color(0xFF1D201F);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _errorRed = Color(0xFF8B3A3A);

  static const List<Map<String, String>> _bugCategories = [
    {
      'title': 'Crash or App Freeze',
      'severity': 'High Priority',
    },
    {
      'title': 'Sync & Offline Queue',
      'severity': 'Data Integrity',
    },
    {
      'title': 'Training & Session Logging',
      'severity': 'Core Feature',
    },
    {
      'title': 'Strength & Conditioning',
      'severity': 'Core Feature',
    },
    {
      'title': 'Health Records & Reminders',
      'severity': 'Core Feature',
    },
    {
      'title': 'Timeline & Media Uploads',
      'severity': 'Media & Feed',
    },
    {
      'title': 'Visual or Layout Issue',
      'severity': 'UI Polish',
    },
    {
      'title': 'Account & Subscription',
      'severity': 'Account',
    },
  ];

  static const List<_BugAttachment> _sampleAttachments = [
    _BugAttachment(
      id: 'sample_screen_rec',
      name: 'repro_recording.mp4',
      sizeLabel: '6.4 MB',
      icon: Icons.videocam_outlined,
    ),
    _BugAttachment(
      id: 'sample_console_log',
      name: 'session_crash_trace.log',
      sizeLabel: '94 KB',
      icon: Icons.description_outlined,
    ),
    _BugAttachment(
      id: 'sample_ui_shot',
      name: 'timeline_layout_clip.png',
      sizeLabel: '1.8 MB',
      icon: Icons.image_outlined,
    ),
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _stepsFocus = FocusNode();

  String? _selectedCategory;
  bool _includeDiagnostics = true;
  bool _showValidationErrors = false;
  bool _isSubmitted = false;
  String _submittedBugId = '#BUG-7412';

  final List<_BugAttachment> _attachments = [
    const _BugAttachment(
      id: 'initial_bug_shot',
      name: 'bug_screenshot.png',
      sizeLabel: '2.1 MB',
      icon: Icons.image_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _titleFocus.addListener(_onFocusChange);
    _descriptionFocus.addListener(_onFocusChange);
    _stepsFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _titleFocus.removeListener(_onFocusChange);
    _descriptionFocus.removeListener(_onFocusChange);
    _stepsFocus.removeListener(_onFocusChange);
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _stepsFocus.dispose();
    super.dispose();
  }

  String _formatWithCommas(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }

  String get _userSubscriptionLabel {
    final explicit = widget.subscriptionPlan?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }
    if (widget.hasSportPack && widget.hasTrainerPack) {
      return 'Complete';
    }
    if (widget.hasSportPack) {
      return 'Core + Sport';
    }
    if (widget.hasTrainerPack) {
      return 'Core + Trainer';
    }
    return 'Core';
  }

  void _openCategoryPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: _cardBorder)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _stoneGrey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                  child: Text(
                    'Select Bug Category',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Divider(height: 1, color: _cardBorder),
                ..._bugCategories.map((item) {
                  final title = item['title']!;
                  final severity = item['severity']!;
                  final selected = _selectedCategory == title;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedCategory = title);
                      Navigator.of(ctx).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: selected ? _mint : _offWhite,
                                fontSize: 15,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _carbon,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: _cardBorder),
                            ),
                            child: Text(
                              severity,
                              style: const TextStyle(
                                color: _stoneGrey,
                                fontSize: 11,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          if (selected) ...[
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.check_rounded,
                              color: _mint,
                              size: 19,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAttachmentPicker() {
    if (_attachments.length >= 5) {
      AppSnackbar.show(
        context,
        title: 'Limit Reached',
        message: 'Up to 5 diagnostic files can be attached to a bug report.',
        type: SnackbarType.warning,
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: _cardBorder)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _stoneGrey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add Bug Attachment',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Attach screenshots, screen recordings, or crash logs',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._sampleAttachments.map((item) {
                    final exists = _attachments.any((a) => a.name == item.name);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: exists
                            ? null
                            : () {
                                setState(() {
                                  _attachments.add(
                                    _BugAttachment(
                                      id: '${item.id}_${DateTime.now().millisecondsSinceEpoch}',
                                      name: item.name,
                                      sizeLabel: item.sizeLabel,
                                      icon: item.icon,
                                    ),
                                  );
                                });
                                Navigator.of(ctx).pop();
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: _carbon,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _cardBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                color: exists ? _stoneGrey : _mint,
                                size: 19,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${item.name}  ·  ${item.sizeLabel}',
                                  style: TextStyle(
                                    color: exists ? _stoneGrey : _offWhite,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              Text(
                                exists ? 'Added' : 'Attach',
                                style: TextStyle(
                                  color: exists ? _stoneGrey : _mint,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitBugReport() {
    FocusScope.of(context).unfocus();
    final hasCategory = _selectedCategory != null;
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasDesc = _descriptionController.text.trim().isNotEmpty;

    if (!hasCategory || !hasTitle || !hasDesc) {
      setState(() => _showValidationErrors = true);
      AppSnackbar.show(
        context,
        title: 'Missing Bug Details',
        message: !hasCategory
            ? 'Please select a Bug Category first.'
            : !hasTitle
            ? 'Please enter a brief Bug Title.'
            : 'Please describe what happened so our team can investigate.',
        type: SnackbarType.error,
      );
      return;
    }

    final code = 1000 + math.Random().nextInt(8999);
    setState(() {
      _showValidationErrors = false;
      _submittedBugId = '#BUG-$code';
      _isSubmitted = true;
    });

    AppSnackbar.show(
      context,
      title: 'Bug Report Logged',
      message: 'Engineering ticket $_submittedBugId has been created.',
      type: SnackbarType.success,
    );
  }

  void _resetForm() {
    setState(() {
      _selectedCategory = null;
      _titleController.clear();
      _descriptionController.clear();
      _stepsController.clear();
      _includeDiagnostics = true;
      _showValidationErrors = false;
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryError = _showValidationErrors && _selectedCategory == null;
    final titleError =
        _showValidationErrors && _titleController.text.trim().isEmpty;
    final descError =
        _showValidationErrors && _descriptionController.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: _obsidian,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: _obsidian,
            border: Border(bottom: BorderSide(color: _cardBorder, width: 1)),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: _stoneGrey,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                  const Text(
                    'Report a Bug',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isSubmitted
          ? _buildSubmittedReceipt()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
              children: [
                _buildSectionHeader('BUG REPORT'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bug_report_outlined,
                            color: _stoneGrey,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Found something that isn\'t working?',
                              style: TextStyle(
                                color: _offWhite,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Help us improve Ulvenik by reporting the issue below. The more detail you provide, the faster we can investigate.',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13.5,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('CATEGORY'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: categoryError ? _errorRed : _cardBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: Text(
                          'Bug Category',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1, color: _cardBorder),
                      InkWell(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        onTap: _openCategoryPicker,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedCategory ?? 'Select a category',
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _stoneGrey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('TITLE'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: titleError
                          ? _errorRed
                          : _titleFocus.hasFocus
                          ? _forest
                          : _cardBorder,
                      width: _titleFocus.hasFocus ? 1.4 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bug Title',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _titleController,
                        focusNode: _titleFocus,
                        maxLength: 100,
                        onChanged: (_) => setState(() {}),
                        cursorColor: _mint,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.only(bottom: 8),
                          counterText: '',
                          hintText: 'Briefly describe the issue',
                          hintStyle: TextStyle(
                            color: _stoneGrey.withValues(alpha: 0.55),
                            fontSize: 15,
                            fontFamily: 'Inter',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _stoneGrey.withValues(alpha: 0.22),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: _forest, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_titleController.text.length} / 100',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('DESCRIPTION'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: descError
                          ? _errorRed
                          : _descriptionFocus.hasFocus
                          ? _forest
                          : _cardBorder,
                      width: _descriptionFocus.hasFocus ? 1.4 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What happened?',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocus,
                        minLines: 5,
                        maxLines: 8,
                        maxLength: 5000,
                        onChanged: (_) => setState(() {}),
                        cursorColor: _mint,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 15,
                          height: 1.45,
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.only(bottom: 8),
                          counterText: '',
                          hintText:
                              'Tell us exactly what happened. Include what you expected and what actually occurred.',
                          hintStyle: TextStyle(
                            color: _stoneGrey.withValues(alpha: 0.55),
                            fontSize: 15,
                            height: 1.45,
                            fontFamily: 'Inter',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _stoneGrey.withValues(alpha: 0.22),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: _forest, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_formatWithCommas(_descriptionController.text.length)} / 5,000',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('STEPS TO REPRODUCE'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _stepsFocus.hasFocus ? _forest : _cardBorder,
                      width: _stepsFocus.hasFocus ? 1.4 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            const TextSpan(
                              text: 'Steps to Reproduce',
                              style: TextStyle(
                                color: _offWhite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' · Optional',
                              style: TextStyle(
                                color: _stoneGrey.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _stepsController,
                        focusNode: _stepsFocus,
                        minLines: 4,
                        maxLines: 7,
                        maxLength: 2000,
                        onChanged: (_) => setState(() {}),
                        cursorColor: _mint,
                        style: const TextStyle(
                          color: _offWhite,
                          fontSize: 14,
                          height: 1.55,
                          fontFamily: 'monospace',
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.only(bottom: 8),
                          counterText: '',
                          hintText:
                              '1. Open Dog Profile\n2. Tap Training\n3. Add Session\n4. App closes',
                          hintStyle: TextStyle(
                            color: _stoneGrey.withValues(alpha: 0.5),
                            fontSize: 14,
                            height: 1.55,
                            fontFamily: 'monospace',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _stoneGrey.withValues(alpha: 0.22),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: _forest, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_formatWithCommas(_stepsController.text.length)} / 2,000',
                          style: const TextStyle(
                            color: _stoneGrey,
                            fontSize: 12,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('ATTACHMENTS'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    children: [
                      CustomPaint(
                        painter: _BugDashedBorderPainter(
                          color: _stoneGrey.withValues(alpha: 0.28),
                          radius: 12,
                        ),
                        child: Material(
                          color: _dashedFill,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _openAttachmentPicker,
                            child: const SizedBox(
                              height: 54,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.attach_file_rounded,
                                    color: _stoneGrey,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Attachment',
                                    style: TextStyle(
                                      color: _stoneGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Screenshots, recordings or documents',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (_attachments.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ...List.generate(_attachments.length, (i) {
                          final att = _attachments[i];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: i == _attachments.length - 1 ? 0 : 8,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: _obsidian.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    att.icon,
                                    color: _stoneGrey,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: att.name,
                                            style: const TextStyle(
                                              color: _offWhite,
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '   ${att.sizeLabel}',
                                            style: const TextStyle(
                                              color: _stoneGrey,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _attachments.removeAt(i);
                                    }),
                                    behavior: HitTestBehavior.opaque,
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: _stoneGrey,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('DIAGNOSTICS'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        onTap: () => setState(
                          () => _includeDiagnostics = !_includeDiagnostics,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                color: _stoneGrey,
                                size: 19,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Include Diagnostic Information',
                                      style: TextStyle(
                                        color: _offWhite,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Helps the team investigate and reproduce the issue',
                                      style: TextStyle(
                                        color: _stoneGrey,
                                        fontSize: 12,
                                        height: 1.35,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildForestSwitch(
                                value: _includeDiagnostics,
                                onChanged: (v) =>
                                    setState(() => _includeDiagnostics = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: _includeDiagnostics ? 1.0 : 0.42,
                        child: Column(
                          children: [
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow(
                              'App Version',
                              '2.4.1',
                              monospace: true,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow(
                              'Build Number',
                              '241',
                              monospace: true,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow('Device', 'iPhone 15 Pro'),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow(
                              'OS Version',
                              'iOS 17.4',
                              monospace: true,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow(
                              'Screen Resolution',
                              '2556 × 1179',
                              monospace: true,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow('Language', 'English (UK)'),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: _cardBorder,
                            ),
                            _buildDiagnosticRow(
                              'Subscription',
                              _userSubscriptionLabel,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitBugReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_outlined,
                          size: 17,
                          color: _offWhite,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Submit Bug Report',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
    );
  }

  Widget _buildSubmittedReceipt() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 36),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _carbon,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _forest.withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _forest.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bug_report_outlined,
                      color: _mint,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bug Report Submitted',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Issue $_submittedBugId · Routed to QA & Engineering',
                          style: const TextStyle(
                            color: _mint,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: _cardBorder),
              const SizedBox(height: 16),
              _buildReceiptRow('Category', _selectedCategory ?? 'General'),
              const SizedBox(height: 10),
              _buildReceiptRow('Bug Title', _titleController.text.trim()),
              const SizedBox(height: 10),
              _buildReceiptRow(
                'Attachments',
                _attachments.isEmpty
                    ? 'None'
                    : '${_attachments.length} file(s)',
              ),
              const SizedBox(height: 10),
              _buildReceiptRow(
                'Diagnostics',
                _includeDiagnostics
                    ? 'Attached (2.4.1 / Build 241 · $_userSubscriptionLabel)'
                    : 'Excluded',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _submittedBugId),
                        );
                        AppSnackbar.show(
                          context,
                          title: 'Copied',
                          message:
                              'Bug tracking ID $_submittedBugId copied.',
                          type: SnackbarType.info,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _offWhite,
                        side: const BorderSide(color: _cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Copy Bug ID'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _forest,
                        foregroundColor: _offWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Report Another'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _offWhite,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _stoneGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildDiagnosticRow(
    String label,
    String value, {
    bool monospace = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _stoneGrey,
              fontSize: 13.5,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _offWhite,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              fontFamily: monospace ? 'monospace' : 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForestSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? _forest : const Color(0xFF2B3135),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: _offWhite,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _BugDashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _BugDashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashWidth = 4.5;
    const dashSpace = 3.5;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BugDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
