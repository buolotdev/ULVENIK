import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  final bool initialEnabled;

  const TwoFactorSetupScreen({
    super.key,
    this.initialEnabled = false,
  });

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  late bool _is2FAEnabled;
  bool _inSetupFlow = false;
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Recovery codes reveal state
  bool _recoveryCodesRevealed = false;

  final List<String> _recoveryCodes = [
    'ABCD-1234',
    'EFGH-5678',
    'IJKL-9012',
    'MNOP-3456',
    'QRST-7890',
    'UVWX-1234',
    'YZAB-5678',
    'CDEF-9012',
    'GHIJ-3456',
    'KLMN-7890',
  ];

  final List<Map<String, String>> _trustedDevices = [
    {
      'name': 'iPhone 15 Pro',
      'location': 'Stockholm, Sweden',
      'active': 'Active now',
    },
    {
      'name': 'MacBook Pro',
      'location': 'Oslo, Norway',
      'active': 'Last active 2 days ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _is2FAEnabled = widget.initialEnabled;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSetupFlow() {
    setState(() {
      _inSetupFlow = true;
      _currentStep = 0;
    });
  }

  void _cancelSetupFlow() {
    setState(() {
      _inSetupFlow = false;
      _currentStep = 0;
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      setState(() => _currentStep++);
    } else {
      // Completed setup flow
      setState(() {
        _is2FAEnabled = true;
        _inSetupFlow = false;
        _currentStep = 0;
        _recoveryCodesRevealed = false; // Kept secure until explicitly requested
      });
      AppSnackbar.show(
        context,
        title: 'Two-Factor Enabled',
        message: 'Your account is now secured with two-factor authentication.',
        type: SnackbarType.success,
      );
    }
  }

  void _confirmDisable2FA() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: const Text(
            'Disable Two-Factor Authentication?',
            style: TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          content: const Text(
            'Disabling two-factor authentication reduces your account security. A verification code will no longer be required when signing in from unrecognised devices.',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
              height: 1.45,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Keep Enabled',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDestructive,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _is2FAEnabled = false;
                  _recoveryCodesRevealed = false;
                });
                AppSnackbar.show(
                  context,
                  title: 'Two-Factor Disabled',
                  message: 'Two-factor authentication has been turned off.',
                  type: SnackbarType.warning,
                );
              },
              child: const Text(
                'Disable 2FA',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _requestViewRecoveryCodes() {
    final passwordCtrl = TextEditingController();
    bool obscure = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardsCarbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Security Verification',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your account password to view your backup recovery codes.',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordCtrl,
                    obscureText: obscure,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter account password',
                      hintStyle: const TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundObsidian,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 20,
                        ),
                        onPressed: () {
                          setSheetState(() => obscure = !obscure);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryForestGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryForestGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (passwordCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your password.'),
                            ),
                          );
                          return;
                        }
                        Navigator.pop(ctx);
                        setState(() {
                          _recoveryCodesRevealed = true;
                        });
                        AppSnackbar.show(
                          context,
                          title: 'Codes Revealed',
                          message: 'Recovery codes are now visible.',
                          type: SnackbarType.success,
                        );
                      },
                      child: const Text(
                        'Confirm & View Codes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundObsidian,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryTextOffWhite,
            size: 18,
          ),
          onPressed: () {
            if (_inSetupFlow) {
              if (_currentStep > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                );
                setState(() => _currentStep--);
              } else {
                _cancelSetupFlow();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Two-Factor Authentication',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white.withValues(alpha: 0.06),
            height: 1.0,
          ),
        ),
      ),
      body: _inSetupFlow
          ? _buildSetupFlowBody()
          : (_is2FAEnabled ? _buildEnabledState() : _buildNotEnabledState()),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NOT ENABLED STATE (Image 3)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildNotEnabledState() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SECURITY STATUS',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.shield_outlined,
                                    color: AppColors.secondaryTextStoneGrey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Two-Factor Authentication',
                                    style: TextStyle(
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              Switch.adaptive(
                                value: false,
                                activeTrackColor: AppColors.primaryForestGreen,
                                onChanged: (val) {
                                  if (val) _startSetupFlow();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC75D5D)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NOT ENABLED',
                              style: TextStyle(
                                color: Color(0xFFE57373),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Add an extra layer of security to help protect your account if your password is ever compromised.',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 13,
                              height: 1.45,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'VERIFICATION METHOD',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            leading: const Icon(
                              Icons.phone_android_rounded,
                              color: AppColors.secondarySage,
                            ),
                            title: const Text(
                              'Authentication App',
                              style: TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryForestGreen
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.primaryForestGreen
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: const Text(
                                    'RECOMMENDED',
                                    style: TextStyle(
                                      color: AppColors.secondarySage,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.secondaryTextStoneGrey,
                                  size: 20,
                                ),
                              ],
                            ),
                            onTap: _startSetupFlow,
                          ),
                          const Divider(color: AppColors.cardBorder, height: 1),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            leading: const Icon(
                              Icons.key_rounded,
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                            title: const Text(
                              'Passkey / Security Key',
                              style: TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                            subtitle: const Text(
                              'Coming soon',
                              style: TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 12,
                                fontFamily: 'Inter',
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'SOON',
                                style: TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _startSetupFlow,
                icon: const Icon(Icons.shield_outlined, size: 20),
                label: const Text(
                  'Set Up Two-Factor Authentication',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ENABLED STATE (Image 4)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildEnabledState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Status Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryForestGreen
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primaryForestGreen
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Text(
                        'ENABLED',
                        style: TextStyle(
                          color: AppColors.secondarySage,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: true,
                      activeTrackColor: AppColors.primaryForestGreen,
                      onChanged: (val) {
                        if (!val) _confirmDisable2FA();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your account is protected with an additional layer of security. A verification code is required when signing in from an unrecognised device.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Recovery Codes Section
          const Text(
            'RECOVERY CODES',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Store these codes securely. They can be used to access your account if you lose your authentication device.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                if (!_recoveryCodesRevealed)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.primaryForestGreen),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _requestViewRecoveryCodes,
                        icon: const Icon(
                          Icons.lock_open_rounded,
                          color: AppColors.secondarySage,
                          size: 18,
                        ),
                        label: const Text(
                          'View Recovery Codes',
                          style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  )
                else ...[
                  // Grid of 10 codes
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recoveryCodes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              _recoveryCodes[index],
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 14,
                                fontFamily: 'monospace',
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.secondarySage,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            AppSnackbar.show(
                              context,
                              title: 'Codes Copied',
                              message: 'All 10 recovery codes copied to clipboard.',
                              type: SnackbarType.success,
                            );
                          },
                          icon: const Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                          label: const Text(
                            'Copy',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            AppSnackbar.show(
                              context,
                              title: 'Downloading...',
                              message: 'Saved recovery_codes.txt to device.',
                              type: SnackbarType.info,
                            );
                          },
                          icon: const Icon(
                            Icons.download_rounded,
                            size: 16,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                          label: const Text(
                            'Download',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            AppSnackbar.show(
                              context,
                              title: 'Print Codes',
                              message: 'Sent codes to printer.',
                              type: SnackbarType.info,
                            );
                          },
                          icon: const Icon(
                            Icons.print_rounded,
                            size: 16,
                            color: AppColors.secondaryTextStoneGrey,
                          ),
                          label: const Text(
                            'Print',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 13,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Trusted Devices Section
          const Text(
            'TRUSTED DEVICES',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: _trustedDevices.map((dev) {
                final isLast = _trustedDevices.indexOf(dev) ==
                    _trustedDevices.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            dev['name']!.contains('Mac')
                                ? Icons.laptop_mac_rounded
                                : Icons.phone_iphone_rounded,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dev['name']!,
                                  style: const TextStyle(
                                    color: AppColors.primaryTextOffWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dev['location']} · ${dev['active']}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _trustedDevices.remove(dev);
                              });
                              AppSnackbar.show(
                                context,
                                message: 'Removed ${dev['name']}',
                                type: SnackbarType.info,
                              );
                            },
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                color: Color(0xFFE57373),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      const Divider(color: AppColors.cardBorder, height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),

          // Danger Zone
          const Text(
            'DANGER ZONE',
            style: TextStyle(
              color: Color(0xFFE57373),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8B3A3A)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _confirmDisable2FA,
              child: const Text(
                'Disable Two-Factor Authentication',
                style: TextStyle(
                  color: Color(0xFFE57373),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SETUP FLOW (Image 2)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSetupFlowBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        _buildStepper(),
        const SizedBox(height: 20),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildScanStep(),
              _buildVerifyStep(),
              _buildCodesStep(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep(
              label: 'SCAN',
              isActive: _currentStep >= 0,
              isCurrent: _currentStep == 0),
          _buildLine(isActive: _currentStep >= 1),
          _buildStep(
              label: 'VERIFY',
              isActive: _currentStep >= 1,
              isCurrent: _currentStep == 1),
          _buildLine(isActive: _currentStep >= 2),
          _buildStep(
              label: 'CODES',
              isActive: _currentStep >= 2,
              isCurrent: _currentStep == 2),
        ],
      ),
    );
  }

  Widget _buildStep(
      {required String label,
      required bool isActive,
      required bool isCurrent}) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent
                ? AppColors.primaryForestGreen.withValues(alpha: 0.25)
                : (isActive ? AppColors.primaryForestGreen : Colors.transparent),
            border: Border.all(
              color: isActive ? AppColors.primaryForestGreen : Colors.white24,
              width: 2,
            ),
          ),
          child: isCurrent
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryForestGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : (isActive
                  ? const Icon(Icons.check,
                      size: 16, color: AppColors.primaryTextOffWhite)
                  : null),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? AppColors.primaryTextOffWhite
                : AppColors.secondaryTextStoneGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 18, left: 10, right: 10),
        height: 2,
        color: isActive
            ? AppColors.primaryForestGreen
            : Colors.white.withValues(alpha: 0.08),
      ),
    );
  }

  Widget _buildScanStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SCAN WITH YOUR APP',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                // QR Code
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 186,
                        height: 186,
                        child: CustomPaint(
                          painter: _MockQRPainter(),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundObsidian,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryTextOffWhite,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Scan this QR code using your authenticator app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.cardBorder, height: 1),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manual setup key',
                            style: TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'ABCD EFGH IJKL MNOP',
                            style: TextStyle(
                              color: AppColors.primaryTextOffWhite,
                              fontSize: 15,
                              letterSpacing: 1.8,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppSnackbar.show(
                          context,
                          title: 'Key Copied',
                          message: 'Manual setup key copied to clipboard.',
                          type: SnackbarType.success,
                        );
                      },
                      icon: const Icon(
                        Icons.copy_outlined,
                        size: 18,
                        color: AppColors.secondaryTextStoneGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'ENTER VERIFICATION CODE',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundObsidian,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryForestGreen.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '4  8  3  9  1  2',
                      style: TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 8,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 14,
                      color: AppColors.secondaryTextStoneGrey,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Code refreshes every 30 seconds.',
                      style: TextStyle(
                        color: AppColors.secondaryTextStoneGrey,
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _nextStep,
            child: const Text(
              'Verify & Continue',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: _cancelSetupFlow,
              child: const Text(
                'Cancel Setup',
                style: TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVerifyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'CONFIRM VERIFICATION',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  size: 48,
                  color: AppColors.primaryForestGreen,
                ),
                SizedBox(height: 16),
                Text(
                  'Connection Verified',
                  style: TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your authenticator app is paired successfully. Next, we will generate your emergency backup recovery codes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _nextStep,
            child: const Text(
              'Continue to Recovery Codes',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'BACKUP RECOVERY CODES',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                const Text(
                  'Store these recovery codes securely. If you lose access to your authenticator app, each code can be used once to sign in.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    height: 1.45,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recoveryCodes.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return Text(
                      _recoveryCodes[index],
                      style: const TextStyle(
                        color: AppColors.primaryTextOffWhite,
                        fontSize: 14,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cardBorder),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    AppSnackbar.show(
                      context,
                      title: 'Copied',
                      message: 'Recovery codes copied to clipboard.',
                      type: SnackbarType.success,
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text(
                    'Copy All Codes',
                    style: TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _nextStep,
            child: const Text(
              'Finish Setup & Enable 2FA',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MockQRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final double step = size.width / 21;

    _drawFinder(canvas, paint, 0, 0, step);
    _drawFinder(canvas, paint, 14 * step, 0, step);
    _drawFinder(canvas, paint, 0, 14 * step, step);

    final Random random = Random(42);
    for (int i = 0; i < 21; i++) {
      for (int j = 0; j < 21; j++) {
        if ((i < 8 && j < 8) || (i > 13 && j < 8) || (i < 8 && j > 13)) {
          continue;
        }
        if (i > 7 && i < 14 && j > 7 && j < 14) continue;

        if (random.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(i * step, j * step, step, step),
            paint,
          );
        }
      }
    }
  }

  void _drawFinder(Canvas canvas, Paint paint, double x, double y, double step) {
    canvas.drawRect(Rect.fromLTWH(x, y, 7 * step, 7 * step), paint);
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(x + step, y + step, 5 * step, 5 * step), whitePaint);
    canvas.drawRect(
        Rect.fromLTWH(x + 2 * step, y + 2 * step, 3 * step, 3 * step), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
