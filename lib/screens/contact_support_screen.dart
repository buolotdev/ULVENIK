import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class _SupportAttachment {
  final String id;
  final String name;
  final String sizeLabel;
  final IconData icon;

  const _SupportAttachment({
    required this.id,
    required this.name,
    required this.sizeLabel,
    this.icon = Icons.description_outlined,
  });
}

class ContactSupportScreen extends StatefulWidget {
  final String? subscriptionPlan;
  final bool hasSportPack;
  final bool hasTrainerPack;

  const ContactSupportScreen({
    super.key,
    this.subscriptionPlan,
    this.hasSportPack = false,
    this.hasTrainerPack = false,
  });

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  static const Color _obsidian = Color(0xFF101214);
  static const Color _carbon = Color(0xFF1A1F22);
  static const Color _forest = Color(0xFF2E6B57);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _offWhite = Color(0xFFF5F6F2);
  static const Color _stoneGrey = Color(0xFFA7B0AB);
  static const Color _cardBorder = Color(0x14FFFFFF);
  static const Color _errorRed = Color(0xFF8B3A3A);

  static const List<String> _categories = [
    'General Question',
    'Account & Login',
    'Subscription & Billing',
    'Sync & Offline Mode',
    'Training & S&C Logs',
    'Health Records & Reminders',
    'Privacy & Data Export',
  ];

  static const List<_SupportAttachment> _sampleAttachmentPool = [
    _SupportAttachment(
      id: 'att_sync_log',
      name: 'sync_queue_status.png',
      sizeLabel: '840 KB',
      icon: Icons.image_outlined,
    ),
    _SupportAttachment(
      id: 'att_recording',
      name: 'session_screen_clip.mp4',
      sizeLabel: '4.6 MB',
      icon: Icons.videocam_outlined,
    ),
    _SupportAttachment(
      id: 'att_invoice',
      name: 'subscription_receipt.pdf',
      sizeLabel: '310 KB',
      icon: Icons.picture_as_pdf_outlined,
    ),
    _SupportAttachment(
      id: 'att_export',
      name: 'timeline_diagnostics.json',
      sizeLabel: '128 KB',
      icon: Icons.code_rounded,
    ),
  ];

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: 'user@example.com',
  );

  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  String _selectedCategory = 'General Question';
  bool _includeDiagnostics = true;
  bool _showValidationErrors = false;
  bool _isSubmitted = false;
  String _submittedTicketId = '#ULV-48219';

  final List<_SupportAttachment> _attachments = [
    const _SupportAttachment(
      id: 'att_initial_1',
      name: 'screenshot_01.png',
      sizeLabel: '1.2 MB',
      icon: Icons.description_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _subjectFocus.addListener(_onFocusChange);
    _descriptionFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _subjectFocus.removeListener(_onFocusChange);
    _descriptionFocus.removeListener(_onFocusChange);
    _emailFocus.removeListener(_onFocusChange);
    _subjectController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _subjectFocus.dispose();
    _descriptionFocus.dispose();
    _emailFocus.dispose();
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

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    return email.contains('@') && email.contains('.') && email.length >= 5;
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
                    'Select Support Category',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Divider(height: 1, color: _cardBorder),
                ...List.generate(_categories.length, (i) {
                  final cat = _categories[i];
                  final selected = cat == _selectedCategory;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      Navigator.of(ctx).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              cat,
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
                          if (selected)
                            const UlvenikIcon(UlvenikIcons.completed,
                              color: _mint,
                              size: 20,
                            ),
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
        title: 'Attachment Limit Reached',
        message: 'You can attach up to 5 files per support request.',
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
                    'Add Attachment',
                    style: TextStyle(
                      color: _offWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose a screenshot, recording, or document from your device',
                    style: TextStyle(
                      color: _stoneGrey,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._sampleAttachmentPool.map((candidate) {
                    final alreadyAdded = _attachments.any(
                      (a) => a.name == candidate.name,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: alreadyAdded
                            ? null
                            : () {
                                setState(() {
                                  _attachments.add(
                                    _SupportAttachment(
                                      id: '${candidate.id}_${DateTime.now().millisecondsSinceEpoch}',
                                      name: candidate.name,
                                      sizeLabel: candidate.sizeLabel,
                                      icon: candidate.icon,
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
                              UlvenikIcon.fromMaterial(
                                candidate.icon,
                                color: alreadyAdded
                                    ? _stoneGrey.withValues(alpha: 0.4)
                                    : _mint,
                                size: 19,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidate.name,
                                      style: TextStyle(
                                        color: alreadyAdded
                                            ? _stoneGrey
                                            : _offWhite,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    Text(
                                      candidate.sizeLabel,
                                      style: const TextStyle(
                                        color: _stoneGrey,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                alreadyAdded ? 'Added' : 'Attach',
                                style: TextStyle(
                                  color: alreadyAdded ? _stoneGrey : _mint,
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

  void _submitSupportRequest() {
    FocusScope.of(context).unfocus();
    final subjectOk = _subjectController.text.trim().isNotEmpty;
    final descOk = _descriptionController.text.trim().isNotEmpty;
    final emailOk = _isEmailValid;

    if (!subjectOk || !descOk || !emailOk) {
      setState(() => _showValidationErrors = true);
      AppSnackbar.show(
        context,
        title: 'Incomplete Request',
        message: !subjectOk
            ? 'Please enter a brief subject for your enquiry.'
            : !descOk
            ? 'Please describe your question or issue before sending.'
            : 'Please enter a valid Reply To email address.',
        type: SnackbarType.error,
      );
      return;
    }

    final randomNum = 40000 + math.Random().nextInt(59999);
    setState(() {
      _showValidationErrors = false;
      _submittedTicketId = '#ULV-$randomNum';
      _isSubmitted = true;
    });

    AppSnackbar.show(
      context,
      title: 'Support Request Sent',
      message: 'Reference $_submittedTicketId received by Ulvenik Support.',
      type: SnackbarType.success,
    );
  }

  void _resetForm() {
    setState(() {
      _subjectController.clear();
      _descriptionController.clear();
      _selectedCategory = 'General Question';
      _includeDiagnostics = true;
      _showValidationErrors = false;
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectEmptyError =
        _showValidationErrors && _subjectController.text.trim().isEmpty;
    final descEmptyError =
        _showValidationErrors && _descriptionController.text.trim().isEmpty;
    final emailError = _showValidationErrors && !_isEmailValid;

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
                    icon: const UlvenikIcon(UlvenikIcons.back,
                      color: _stoneGrey,
                      size: 26,
                    ),
                    splashRadius: 20,
                  ),
                  const Text(
                    'Contact Support',
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
          ? _buildConfirmationView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
              children: [
                // Intro Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Need some help?',
                            style: TextStyle(
                              color: _offWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Our support team is here to help. Complete the form below and we\'ll get back to you as soon as possible.',
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
                _buildSectionLabel('CATEGORY'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: Text(
                          'Support Category',
                          style: TextStyle(
                            color: _stoneGrey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
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
                                  _selectedCategory,
                                  style: const TextStyle(
                                    color: _offWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const UlvenikIcon(UlvenikIcons.sort,
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
                _buildSectionLabel('SUBJECT'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: subjectEmptyError
                          ? _errorRed
                          : _subjectFocus.hasFocus
                          ? _forest
                          : _cardBorder,
                      width: _subjectFocus.hasFocus ? 1.4 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subject',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _subjectController,
                        focusNode: _subjectFocus,
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
                          hintText: 'Briefly describe your issue',
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
                          '${_subjectController.text.length} / 100',
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
                _buildSectionLabel('DESCRIPTION'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: descEmptyError
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
                        'Description',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
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
                              'Please describe your issue in as much detail as possible...',
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
                _buildSectionLabel('ATTACHMENTS'),
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
                        painter: _DashedRectPainter(
                          color: _stoneGrey.withValues(alpha: 0.28),
                          radius: 12,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _openAttachmentPicker,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                const UlvenikIcon(UlvenikIcons.training,
                                  color: _stoneGrey,
                                  size: 19,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add Attachment',
                                        style: TextStyle(
                                          color: _offWhite.withValues(
                                            alpha: 0.78,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Screenshots, photos, recordings or documents',
                                        style: TextStyle(
                                          color: _stoneGrey,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_attachments.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ...List.generate(_attachments.length, (i) {
                          final item = _attachments[i];
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
                                color: _obsidian.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _cardBorder),
                              ),
                              child: Row(
                                children: [
                                  UlvenikIcon.fromMaterial(
                                    item.icon,
                                    color: _stoneGrey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            color: _offWhite,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.sizeLabel,
                                          style: const TextStyle(
                                            color: _stoneGrey,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _attachments.removeAt(i);
                                      });
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: UlvenikIcon(UlvenikIcons.back,
                                        color: _stoneGrey,
                                        size: 18,
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
                _buildSectionLabel('DIAGNOSTICS'),
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
                              const UlvenikIcon(UlvenikIcons.overflowMenu,
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
                                      'Helps our team resolve your issue faster',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _stoneGrey,
                                        fontSize: 12,
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
                _buildSectionLabel('CONTACT EMAIL'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    color: _carbon,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: emailError
                          ? _errorRed
                          : _emailFocus.hasFocus
                          ? _forest
                          : _cardBorder,
                      width: _emailFocus.hasFocus ? 1.4 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reply To',
                        style: TextStyle(
                          color: _stoneGrey,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const UlvenikIcon(UlvenikIcons.notifications,
                            color: _stoneGrey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) => setState(() {}),
                              cursorColor: _mint,
                              style: const TextStyle(
                                color: _offWhite,
                                fontSize: 15,
                                fontFamily: 'Inter',
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 4,
                                ),
                                hintText: 'user@example.com',
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
                                  borderSide: BorderSide(
                                    color: _forest,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitSupportRequest,
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
                        UlvenikIcon(UlvenikIcons.details,
                          size: 17,
                          color: _offWhite,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Send Support Request',
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

  Widget _buildConfirmationView() {
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
                    child: const UlvenikIcon(UlvenikIcons.completed,
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
                          'Request Received',
                          style: TextStyle(
                            color: _offWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ticket $_submittedTicketId · Typical response < 24h',
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
              _buildSummaryLine('Category', _selectedCategory),
              const SizedBox(height: 10),
              _buildSummaryLine('Subject', _subjectController.text.trim()),
              const SizedBox(height: 10),
              _buildSummaryLine('Reply To', _emailController.text.trim()),
              const SizedBox(height: 10),
              _buildSummaryLine(
                'Attachments',
                _attachments.isEmpty
                    ? 'None'
                    : '${_attachments.length} file(s)',
              ),
              const SizedBox(height: 10),
              _buildSummaryLine(
                'Diagnostics',
                _includeDiagnostics
                    ? 'Included (v2.4.1 · $_userSubscriptionLabel)'
                    : 'Not included',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _submittedTicketId),
                        );
                        AppSnackbar.show(
                          context,
                          title: 'Copied',
                          message:
                              'Ticket reference $_submittedTicketId copied.',
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
                      icon: const UlvenikIcon(UlvenikIcons.overflowMenu, size: 16),
                      label: const Text('Copy Ticket ID'),
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
                      child: const Text('New Request'),
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

  Widget _buildSummaryLine(String label, String value) {
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

  Widget _buildSectionLabel(String text) {
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

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedRectPainter({
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
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
