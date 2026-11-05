import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

enum _EmailChangeStep { form, pendingVerification, verified }

class ChangeEmailScreen extends StatefulWidget {
  final String initialEmail;

  const ChangeEmailScreen({
    super.key,
    this.initialEmail = 'olivia@email.com',
  });

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _alpineBlue = AppColors.infoAlpineBlue;
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _destructive = AppColors.errorDestructive;

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  late String _currentEmail;
  String _pendingNewEmail = '';

  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _requirePasswordCheck = true;
  bool _obscurePassword = true;
  bool _isSending = false;

  _EmailChangeStep _step = _EmailChangeStep.form;
  int _resendSeconds = 0;
  Timer? _resendTimer;

  static const String _demoVerificationCode = '482910';

  @override
  void initState() {
    super.initState();
    _currentEmail = widget.initialEmail;
    _newEmailController.addListener(_onInputChanged);
    _passwordController.addListener(_onInputChanged);
    _codeController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _newEmailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String get _trimmedNewEmail => _newEmailController.text.trim();

  bool get _isSameAsCurrent =>
      _trimmedNewEmail.isNotEmpty &&
      _trimmedNewEmail.toLowerCase() == _currentEmail.toLowerCase();

  bool get _isNewEmailValid =>
      _emailRegex.hasMatch(_trimmedNewEmail) && !_isSameAsCurrent;

  bool get _isPasswordSatisfied =>
      !_requirePasswordCheck || _passwordController.text.trim().length >= 6;

  bool get _canContinue => _isNewEmailValid && _isPasswordSatisfied && !_isSending;

  String? get _emailValidationMessage {
    if (_trimmedNewEmail.isEmpty) return null;
    if (_isSameAsCurrent) {
      return 'New email must be different from your current email address.';
    }
    if (!_emailRegex.hasMatch(_trimmedNewEmail)) {
      return 'Enter a valid email format (for example, name@domain.com).';
    }
    return null;
  }

  List<String> get _domainSuggestions {
    final text = _trimmedNewEmail;
    final atIdx = text.indexOf('@');
    if (atIdx <= 0) return const [];
    final local = text.substring(0, atIdx);
    final typedDomain = text.substring(atIdx + 1).toLowerCase();
    const domains = ['gmail.com', 'icloud.com', 'outlook.com', 'ulvenik.app'];
    return domains
        .where((d) => d.startsWith(typedDomain) && d != typedDomain)
        .map((d) => '$local@$d')
        .toList();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 30);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _handleSendVerification() async {
    if (!_isNewEmailValid) {
      AppSnackbar.show(
        context,
        title: 'Check Email Address',
        message: _emailValidationMessage ??
            'Enter a valid new email address before continuing.',
        type: SnackbarType.warning,
      );
      return;
    }

    if (!_isPasswordSatisfied) {
      AppSnackbar.show(
        context,
        title: 'Password Required',
        message:
            'Enter your current password (6+ characters) or use biometric bypass.',
        type: SnackbarType.warning,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSending = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;

    setState(() {
      _isSending = false;
      _pendingNewEmail = _trimmedNewEmail;
      _codeController.clear();
      _step = _EmailChangeStep.pendingVerification;
    });
    _startResendCooldown();

    AppSnackbar.show(
      context,
      title: 'Verification Email Sent',
      message:
          'Sent a verification link & 6-digit code ($_demoVerificationCode) to $_pendingNewEmail.',
      type: SnackbarType.info,
    );
  }

  void _completeEmailVerification() {
    FocusScope.of(context).unfocus();
    _resendTimer?.cancel();
    setState(() {
      _currentEmail = _pendingNewEmail;
      _step = _EmailChangeStep.verified;
      _newEmailController.clear();
      _passwordController.clear();
      _codeController.clear();
    });

    AppSnackbar.show(
      context,
      title: 'Email Address Updated',
      message: 'Primary Ulvenik login updated to $_currentEmail.',
      type: SnackbarType.success,
    );
  }

  void _verifyEnteredCode() {
    final code = _codeController.text.trim();
    if (code.length < 6) {
      AppSnackbar.show(
        context,
        title: 'Enter 6-Digit Code',
        message:
            'Enter the 6-digit code sent to $_pendingNewEmail (demo code: $_demoVerificationCode).',
        type: SnackbarType.warning,
      );
      return;
    }
    _completeEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _obsidian,
      bottomNavigationBar: const UlvenikBottomNav(
        activeTab: UlvenikNavTab.more,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 34, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCenteredHero(),
                    const SizedBox(height: 30),
                    if (_step == _EmailChangeStep.form) ...[
                      _buildEmailFormCard(),
                      const SizedBox(height: 16),
                      _buildInfoBanner(
                        'Your current email will remain active until your new email has been verified.',
                      ),
                      const SizedBox(height: 24),
                    ] else if (_step == _EmailChangeStep.pendingVerification) ...[
                      _buildPendingVerificationCard(),
                      const SizedBox(height: 16),
                      _buildInfoBanner(
                        '$_currentEmail remains active until $_pendingNewEmail is confirmed.',
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      _buildVerifiedSuccessCard(),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomActionFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 14),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          bottom: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(_currentEmail),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _stoneGrey,
              size: 26,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Change Email Address',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: _offWhite,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredHero() {
    final isPending = _step == _EmailChangeStep.pendingVerification;
    final isVerified = _step == _EmailChangeStep.verified;

    return Column(
      children: [
        UlvenikIcon.fromMaterial(
          isVerified
              ? Icons.mark_email_read_outlined
              : (isPending
                  ? Icons.mark_email_unread_outlined
                  : Icons.mail_outline_rounded),
          size: 34,
          color: _sageMint,
        ),
        const SizedBox(height: 20),
        Text(
          isVerified
              ? 'Email Address Verified'
              : (isPending
                  ? 'Verify Your New Email'
                  : 'Update Your Email Address'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _offWhite,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            isVerified
                ? 'Your Ulvenik account, security alerts, and cloud backup receipts now use $_currentEmail.'
                : (isPending
                    ? 'We sent a verification link and 6-digit security code to $_pendingNewEmail.'
                    : "We'll send a verification email to your new address before making any changes to your account."),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.52,
              color: _stoneGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailFormCard() {
    final validationMsg = _emailValidationMessage;
    final suggestions = _domainSuggestions;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CURRENT EMAIL',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  _currentEmail,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _offWhite,
                  ),
                ),
              ),
              const Icon(Icons.lock_outline_rounded,
                size: 17,
                color: _stoneGrey,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 18),
          const Text(
            'NEW EMAIL ADDRESS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _newEmailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.5,
              color: _offWhite,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              hintText: 'Enter your new email address',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.5,
                color: _stoneGrey.withValues(alpha: 0.68),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: validationMsg != null
                      ? _destructive
                      : (_isNewEmailValid
                          ? _forest
                          : Colors.white.withValues(alpha: 0.16)),
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: validationMsg != null ? _destructive : _forest,
                  width: 1.5,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              suffixIcon: _trimmedNewEmail.isEmpty
                  ? null
                  : (_isNewEmailValid
                      ? const UlvenikIcon(UlvenikIcons.completed,
                          color: _forest,
                          size: 19,
                        )
                      : GestureDetector(
                          onTap: () => _newEmailController.clear(),
                          child: const Icon(Icons.cancel_outlined,
                            color: _stoneGrey,
                            size: 18,
                          ),
                        )),
            ),
          ),
          if (validationMsg != null) ...[
            const SizedBox(height: 8),
            Text(
              validationMsg,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFFC25E5E),
              ),
            ),
          ],
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: suggestions.map((s) {
                return GestureDetector(
                  onTap: () {
                    _newEmailController.text = s;
                    _newEmailController.selection = TextSelection.fromPosition(
                      TextPosition(offset: s.length),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _cardBorder),
                    ),
                    child: Text(
                      s,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        color: _sageMint,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (_trimmedNewEmail.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(height: 1, color: _cardBorder),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.verified_user_outlined,
                  size: 16,
                  color: _sageMint,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Verify with Current Password',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _offWhite,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _requirePasswordCheck = !_requirePasswordCheck;
                    });
                    if (!_requirePasswordCheck) {
                      AppSnackbar.show(
                        context,
                        title: 'Biometric Session Verified',
                        message:
                            'Using active Face ID / Touch ID session instead of password.',
                        type: SnackbarType.info,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _obsidian,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _requirePasswordCheck ? _cardBorder : _forest,
                      ),
                    ),
                    child: Text(
                      _requirePasswordCheck ? 'Use Face ID' : 'Face ID Active',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _requirePasswordCheck ? _stoneGrey : _sageMint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_requirePasswordCheck) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: _offWhite,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintText: 'Enter current password (min. 6 chars)',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: _stoneGrey.withValues(alpha: 0.65),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: _forest, width: 1.5),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    child: UlvenikIcon.fromMaterial(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: _stoneGrey,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPendingVerificationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _alpineBlue.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _alpineBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  'PENDING VERIFICATION',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: _alpineBlue,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() => _step = _EmailChangeStep.form);
                },
                child: const Text(
                  'Edit Email',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: _sageMint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _pendingNewEmail,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: _offWhite,
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '6-DIGIT VERIFICATION CODE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                  color: _stoneGrey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _codeController.text = _demoVerificationCode;
                },
                child: const Text(
                  'Paste Demo Code (482910)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _sageMint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 6.0,
              color: _offWhite,
            ),
            decoration: InputDecoration(
              hintText: '000000',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                letterSpacing: 6.0,
                color: _stoneGrey.withValues(alpha: 0.35),
              ),
              filled: true,
              fillColor: _obsidian,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _forest, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor:
                      _resendSeconds > 0 ? _stoneGrey : _sageMint,
                  padding: EdgeInsets.zero,
                ),
                onPressed: _resendSeconds > 0
                    ? null
                    : () {
                        _startResendCooldown();
                        AppSnackbar.show(
                          context,
                          title: 'Verification Resent',
                          message:
                              'Sent a fresh verification email to $_pendingNewEmail.',
                          type: SnackbarType.info,
                        );
                      },
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  _resendSeconds > 0
                      ? 'Resend in ${_resendSeconds}s'
                      : 'Resend Email',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: _alpineBlue,
                  padding: EdgeInsets.zero,
                ),
                onPressed: _completeEmailVerification,
                icon: const Icon(Icons.open_in_new_rounded, size: 15),
                label: const Text(
                  'Simulate Link Click',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _forest.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _forest.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded,
                  color: _sageMint,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRIMARY EMAIL ACTIVE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: _sageMint,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _currentEmail,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _offWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: _stoneGrey,
                side: const BorderSide(color: _cardBorder),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() => _step = _EmailChangeStep.form);
              },
              child: const Text(
                'Change Email Address Again',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: _alpineBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _alpineBlue.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline_rounded,
              size: 18,
              color: _alpineBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                height: 1.45,
                color: _stoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionFooter() {
    String label = 'Continue';
    bool enabled = _canContinue;
    VoidCallback onTap = _handleSendVerification;

    if (_step == _EmailChangeStep.pendingVerification) {
      label = 'Verify & Update Email';
      enabled = _codeController.text.trim().length == 6;
      onTap = _verifyEnteredCode;
    } else if (_step == _EmailChangeStep.verified) {
      label = 'Done';
      enabled = true;
      onTap = () => Navigator.of(context).maybePop(_currentEmail);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: const BoxDecoration(
        color: _obsidian,
        border: Border(
          top: BorderSide(color: _cardBorder, width: 1),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? _forest : _forest.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(14),
          ),
          child: _isSending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(_offWhite),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? _offWhite
                        : _stoneGrey.withValues(alpha: 0.65),
                  ),
                ),
        ),
      ),
    );
  }
}
