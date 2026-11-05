import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';
import 'export_my_data_screen.dart';
import 'login_screen.dart';
import 'subscription_details_screen.dart';

class _DeletedCategoryItem {
  final String label;
  final String summaryCount;
  final String impactDetail;

  const _DeletedCategoryItem({
    required this.label,
    required this.summaryCount,
    required this.impactDetail,
  });
}

class _RetainedRecordItem {
  final String label;
  final String retentionWindow;
  final String legalBasis;

  const _RetainedRecordItem({
    required this.label,
    required this.retentionWindow,
    required this.legalBasis,
  });
}

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _destructive = Color(0xFF8B3A3A);
  static const Color _destructiveBright = Color(0xFFC25E5E);

  static const List<_DeletedCategoryItem> _leftDeletedItems = [
    _DeletedCategoryItem(
      label: 'Account & Profile',
      summaryCount: '1 Handler Profile',
      impactDetail:
          'Erases handler identity, bio, credentials, and workspace login.',
    ),
    _DeletedCategoryItem(
      label: 'Dog Profiles',
      summaryCount: '6 Active Dogs',
      impactDetail:
          'Permanently deletes pedigrees, microchip IDs, and working profiles.',
    ),
    _DeletedCategoryItem(
      label: 'Training Sessions',
      summaryCount: '2,418 Logged Sessions',
      impactDetail:
          'Removes every session log, split timer, drill score, and field note.',
    ),
    _DeletedCategoryItem(
      label: 'S&C Records',
      summaryCount: '312 Conditioning Logs',
      impactDetail:
          'Deletes strength blocks, hydro/physio load metrics, and progression.',
    ),
    _DeletedCategoryItem(
      label: 'Goals',
      summaryCount: '163 Milestones & Goals',
      impactDetail:
          'Purges active targets, completed milestones, and target deadlines.',
    ),
    _DeletedCategoryItem(
      label: 'Statistics',
      summaryCount: '4 Years of Analytics',
      impactDetail:
          'Removes trend charts, consistency streaks, and workload distributions.',
    ),
    _DeletedCategoryItem(
      label: 'Timeline',
      summaryCount: '3,190 Timeline Entries',
      impactDetail:
          'Deletes memories, smart collections, activity map pins, and favourites.',
    ),
    _DeletedCategoryItem(
      label: 'Health Records',
      summaryCount: '94 Clinical Entries',
      impactDetail:
          'Removes vaccination history, weight logs, vet visits, and medications.',
    ),
  ];

  static const List<_DeletedCategoryItem> _rightDeletedItems = [
    _DeletedCategoryItem(
      label: 'Photos & Videos',
      summaryCount: '1.84 GB Media Vault',
      impactDetail:
          'Permanently purges original training videos, photos, and thumbnails.',
    ),
    _DeletedCategoryItem(
      label: 'Documents & Notes',
      summaryCount: '48 Certificates & PDFs',
      impactDetail:
          'Erases scorebooks, trial certificates, lab reports, and handler notes.',
    ),
    _DeletedCategoryItem(
      label: 'Custom Skills',
      summaryCount: '29 Custom Skills',
      impactDetail:
          'Deletes custom criteria definitions, shaping steps, and cue libraries.',
    ),
    _DeletedCategoryItem(
      label: 'Custom Exercises',
      summaryCount: '34 Custom Exercises',
      impactDetail:
          'Removes bespoke conditioning routines, rep schemes, and equipment tags.',
    ),
    _DeletedCategoryItem(
      label: 'Trainer Pack Data',
      summaryCount: '14 Client Workspaces',
      impactDetail:
          'Revokes shared client records, homework plans, and lesson notes.',
    ),
    _DeletedCategoryItem(
      label: 'Sport Pack Data',
      summaryCount: '3 Active Sports',
      impactDetail:
          'Deletes IGP, Gundog, and Agility trial logs, points, and titles.',
    ),
    _DeletedCategoryItem(
      label: 'Saved Preferences',
      summaryCount: 'Device & Unit Settings',
      impactDetail:
          'Clears custom notification schedules, unit formats, and workspace layouts.',
    ),
  ];

  static const List<_RetainedRecordItem> _retainedItems = [
    _RetainedRecordItem(
      label: 'Purchase Records',
      retentionWindow: '6 years from transaction',
      legalBasis:
          'Required under UK & EU tax and consumer accounting regulations.',
    ),
    _RetainedRecordItem(
      label: 'Subscription Invoices',
      retentionWindow: '6 years from billing date',
      legalBasis:
          'Anonymised VAT invoice numbers retained for statutory audit compliance.',
    ),
    _RetainedRecordItem(
      label: 'Payment History',
      retentionWindow: '6 years (tokenised)',
      legalBasis:
          'App Store & processor settlement references for chargeback resolution.',
    ),
    _RetainedRecordItem(
      label: 'Security Logs',
      retentionWindow: '90 days rolling purge',
      legalBasis:
          'Authentication & deletion audit trail to protect against unauthorised wipe.',
    ),
    _RetainedRecordItem(
      label: 'Legal Compliance Records',
      retentionWindow: 'Statutory minimum',
      legalBasis:
          'Proof of GDPR/UK-GDPR erasure request fulfilment and timestamp.',
    ),
  ];

  static const List<String> _deletionReasons = [
    'Prefer not to say',
    'Taking a break from dog sport / training',
    'Consolidating into another Ulvenik account',
    'Subscription cost or pack pricing',
    'Missing a feature I need',
    'Privacy or data minimisation preference',
  ];

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _biometricVerified = false;
  bool _isScanningBiometrics = false;
  bool _acknowledgePermanent = false;
  bool _acknowledgeBackupWipe = false;
  String _selectedReason = _deletionReasons.first;
  bool _accountScheduledForDeletion = false;

  bool get _isIdentityVerified =>
      _biometricVerified || _passwordController.text.trim().length >= 6;

  bool get _canProceedToDelete =>
      _isIdentityVerified && _acknowledgePermanent && _acknowledgeBackupWipe;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (mounted) setState(() {});
    });
    _passwordFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleBiometricVerify() async {
    if (_isScanningBiometrics) return;
    if (_biometricVerified) {
      setState(() => _biometricVerified = false);
      AppSnackbar.show(
        context,
        title: 'Biometric Verification Cleared',
        message: 'Re-authenticate with Face ID / Touch ID or enter password.',
        type: SnackbarType.info,
      );
      return;
    }

    setState(() => _isScanningBiometrics = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      _isScanningBiometrics = false;
      _biometricVerified = true;
    });

    AppSnackbar.show(
      context,
      title: 'Identity Verified',
      message: 'Face ID / Touch ID confirmed handler identity.',
      type: SnackbarType.success,
    );
  }

  void _openCategoryImpactSheet(_DeletedCategoryItem item) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _destructive.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _destructive.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const UlvenikIcon(UlvenikIcons.back,
                        color: _destructiveBright,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: _offWhite,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Current workspace volume: ${item.summaryCount}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _destructiveBright,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  item.impactDetail,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    height: 1.5,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _offWhite,
                          side: const BorderSide(color: _cardBorder),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheetCtx).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ExportMyDataScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Export This Data First',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _forest,
                          foregroundColor: _offWhite,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        child: const Text(
                          'Got It',
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
              ],
            ),
          ),
        );
      },
    );
  }

  void _openRetainedDetailSheet(_RetainedRecordItem item) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 16),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _obsidian,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _cardBorder),
                  ),
                  child: Text(
                    'Retention window: ${item.retentionWindow}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: _sageMint,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.legalBasis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    height: 1.5,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _offWhite,
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                    child: const Text(
                      'Close',
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
          ),
        );
      },
    );
  }

  void _openReasonSelectorSheet() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 16),
                const Text(
                  'Reason for Deleting Account',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Optional feedback helps us improve Ulvenik for working dog handlers.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 14),
                ..._deletionReasons.map((reason) {
                  final selected = reason == _selectedReason;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() => _selectedReason = reason);
                        Navigator.of(sheetCtx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _obsidian,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? _forest : _cardBorder,
                            width: selected ? 1.4 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            UlvenikIcon.fromMaterial(
                              selected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 18,
                              color: selected ? _forest : _stoneGrey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                reason,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.5,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _offWhite,
                                ),
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
        );
      },
    );
  }

  void _openSignOutInsteadModal() {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 16),
                const Text(
                  'Sign Out Instead?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Signing out keeps all 6 dog profiles, training sessions, health records, and encrypted cloud backups safely intact for whenever you return.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    height: 1.48,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Sign Out Safely',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _stoneGrey,
                      side: const BorderSide(color: _cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                    child: const Text(
                      'Stay on This Page',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTapDeleteAccountButton() {
    if (!_isIdentityVerified) {
      AppSnackbar.show(
        context,
        title: 'Identity Verification Required',
        message:
            'Confirm with Face ID / Touch ID or enter your current password (6+ characters).',
        type: SnackbarType.warning,
      );
      return;
    }

    if (!_acknowledgePermanent || !_acknowledgeBackupWipe) {
      AppSnackbar.show(
        context,
        title: 'Acknowledgement Required',
        message:
            'Please tick both permanent deletion acknowledgements before continuing.',
        type: SnackbarType.warning,
      );
      return;
    }

    _openFinalDeleteConfirmationModal();
  }

  void _openFinalDeleteConfirmationModal() {
    final confirmController = TextEditingController();
    bool isDeleting = false;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: _carbon,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final typedDeleteMatch =
                confirmController.text.trim().toUpperCase() == 'DELETE';

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHandle(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _destructive.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _destructive.withValues(alpha: 0.55),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UlvenikIcon(UlvenikIcons.notifications,
                          color: _destructiveBright,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Final Permanent Deletion Check',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: _offWhite,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'All 15 data categories—including 6 dog profiles, 2,418 sessions, and 1.84 GB of media—will be irreversibly destroyed.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.5,
                                  height: 1.45,
                                  color: _stoneGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TYPE "DELETE" TO CONFIRM',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: _stoneGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: _offWhite,
                    ),
                    onChanged: (_) => setModalState(() {}),
                    decoration: InputDecoration(
                      hintText: 'DELETE',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: _stoneGrey.withValues(alpha: 0.45),
                      ),
                      filled: true,
                      fillColor: _obsidian,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: typedDeleteMatch ? _destructive : _cardBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: _destructive,
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: typedDeleteMatch
                          ? const UlvenikIcon(UlvenikIcons.completed,
                              color: _destructiveBright,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: typedDeleteMatch
                            ? _destructive
                            : _destructive.withValues(alpha: 0.28),
                        foregroundColor: typedDeleteMatch
                            ? _offWhite
                            : _offWhite.withValues(alpha: 0.4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed: (!typedDeleteMatch || isDeleting)
                          ? null
                          : () async {
                              setModalState(() => isDeleting = true);
                              await Future<void>.delayed(
                                const Duration(milliseconds: 850),
                              );
                              if (!mounted) return;
                              if (sheetCtx.mounted) {
                                Navigator.of(sheetCtx).pop();
                              }
                              setState(() {
                                _accountScheduledForDeletion = true;
                              });
                              AppSnackbar.show(
                                context,
                                title: 'Account Deletion Queued',
                                message:
                                    'Permanent erasure initiated. Confirmation receipt sent to your email.',
                                type: SnackbarType.error,
                              );
                            },
                      child: isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _offWhite,
                                ),
                              ),
                            )
                          : const Text(
                              'Permanently Delete My Account',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: isDeleting
                          ? null
                          : () => Navigator.of(sheetCtx).pop(),
                      child: const Text(
                        'Cancel & Keep My Account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: _stoneGrey,
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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_accountScheduledForDeletion) ...[
                      _buildDeletionScheduledBanner(),
                      const SizedBox(height: 18),
                    ],
                    _buildHeroWarningCard(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('WHAT WILL BE PERMANENTLY DELETED'),
                    const SizedBox(height: 10),
                    _buildPermanentlyDeletedCard(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('WHAT MAY BE RETAINED'),
                    const SizedBox(height: 10),
                    _buildRetainedRecordsCard(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('BEFORE YOU DELETE'),
                    const SizedBox(height: 10),
                    _buildBeforeYouDeleteCard(),
                    const SizedBox(height: 24),
                    _buildSectionLabel('VERIFY YOUR IDENTITY'),
                    const SizedBox(height: 10),
                    _buildVerifyIdentityCard(),
                    const SizedBox(height: 16),
                    _buildReasonSelectorCard(),
                    const SizedBox(height: 20),
                    _buildAcknowledgementCheckboxes(),
                    const SizedBox(height: 20),
                    _buildDeleteAccountButton(),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: TextButton.styleFrom(
                          foregroundColor: _stoneGrey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _stoneGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const UlvenikIcon(UlvenikIcons.back,
              color: _offWhite,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 2),
          const Expanded(
            child: Text(
              'Delete Account',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
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

  Widget _buildDeletionScheduledBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _destructive.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _destructive.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              UlvenikIcon(UlvenikIcons.trainingTime,
                color: _destructiveBright,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Deletion Request Active',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _offWhite,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Reason logged: $_selectedReason. Your Ulvenik workspace is queued for permanent wipe. You can abort right now before sign-out.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              height: 1.45,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _offWhite,
                    side: const BorderSide(color: _cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() => _accountScheduledForDeletion = false);
                    AppSnackbar.show(
                      context,
                      title: 'Deletion Cancelled',
                      message:
                          'Your Ulvenik account and all dog data remain active.',
                      type: SnackbarType.success,
                    );
                  },
                  child: const Text(
                    'Abort Deletion',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _destructive,
                    foregroundColor: _offWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Finish & Exit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroWarningCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _destructive.withValues(alpha: 0.42),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3.5,
              color: _destructive,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        UlvenikIcon(UlvenikIcons.notifications,
                          color: _destructive,
                          size: 21,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Delete Your Ulvenik Account',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _offWhite,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Deleting your account is permanent. Once completed, your account and all associated data cannot be recovered.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: _stoneGrey,
        ),
      ),
    );
  }

  Widget _buildPermanentlyDeletedCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _leftDeletedItems.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildDeletedGridCell(_leftDeletedItems[i]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: i < _rightDeletedItems.length
                      ? _buildDeletedGridCell(_rightDeletedItems[i])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeletedGridCell(_DeletedCategoryItem item) {
    return GestureDetector(
      onTap: () => _openCategoryImpactSheet(item),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _destructive,
                width: 1.2,
              ),
            ),
            child: const Center(
              child: UlvenikIcon(UlvenikIcons.back,
                size: 10.5,
                color: _destructive,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: _offWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetainedRecordsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < _retainedItems.length; i++) ...[
            if (i > 0) const SizedBox(height: 13),
            GestureDetector(
              onTap: () => _openRetainedDetailSheet(_retainedItems[i]),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const UlvenikIcon(UlvenikIcons.notifications,
                    size: 16,
                    color: _stoneGrey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _retainedItems[i].label,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: _offWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 14),
          const Text(
            'These records are retained only where required by law and are not used as part of your Ulvenik account after deletion.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5,
              height: 1.45,
              color: _stoneGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeforeYouDeleteCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consider these options first',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: _offWhite,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you only want to stop using Ulvenik, consider cancelling your subscription or signing out instead.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              height: 1.48,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 16),
          _buildAlternativeOptionButton(
            label: 'Manage Subscription',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SubscriptionDetailsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildAlternativeOptionButton(
            label: 'Sign Out Instead',
            onTap: _openSignOutInsteadModal,
          ),
          const SizedBox(height: 10),
          _buildAlternativeOptionButton(
            label: 'Export My Data First',
            icon: Icons.download_rounded,
            accentText: _sageMint,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ExportMyDataScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeOptionButton({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    Color? accentText,
  }) {
    final textColor = accentText ?? _stoneGrey;
    return Material(
      color: _obsidian.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                UlvenikIcon.fromMaterial(icon, size: 17, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyIdentityCard() {
    return Container(
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _handleBiometricVerify,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
              child: Row(
                children: [
                  _isScanningBiometrics
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _sageMint,
                            ),
                          ),
                        )
                      : UlvenikIcon.fromMaterial(
                          _biometricVerified
                              ? Icons.verified_user_rounded
                              : Icons.lock_outline_rounded,
                          size: 20,
                          color: _biometricVerified ? _forest : _sageMint,
                        ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _biometricVerified
                              ? 'Confirmed with Face ID / Touch ID'
                              : 'Confirm with Face ID / Touch ID',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: _offWhite,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _biometricVerified
                              ? 'Biometric identity verified · Tap to reset'
                              : 'Or enter your password below',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5,
                            color: _biometricVerified ? _sageMint : _stoneGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  UlvenikIcon.fromMaterial(
                    _biometricVerified
                        ? Icons.check_circle_rounded
                        : Icons.chevron_right_rounded,
                    color: _biometricVerified ? _forest : _stoneGrey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(height: 1, color: _cardBorder),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: _offWhite,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: _stoneGrey.withValues(alpha: 0.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _forest,
                        width: 1.5,
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: UlvenikIcon.fromMaterial(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _stoneGrey,
                        size: 19,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSelectorCard() {
    return Material(
      color: _carbon,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _openReasonSelectorSheet,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _cardBorder),
          ),
          child: Row(
            children: [
              const UlvenikIcon(UlvenikIcons.notifications,
                size: 18,
                color: _stoneGrey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'REASON FOR LEAVING (OPTIONAL)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: _stoneGrey,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _selectedReason,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: _offWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const UlvenikIcon(UlvenikIcons.sort,
                size: 19,
                color: _stoneGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcknowledgementCheckboxes() {
    return Column(
      children: [
        _buildSingleCheckboxRow(
          value: _acknowledgePermanent,
          label:
              'I understand that deleting my account is permanent and cannot be undone.',
          onChanged: (next) {
            setState(() => _acknowledgePermanent = next);
          },
        ),
        const SizedBox(height: 12),
        _buildSingleCheckboxRow(
          value: _acknowledgeBackupWipe,
          label:
              'I understand all dog workspaces, media vault files, and cloud backups will be erased.',
          onChanged: (next) {
            setState(() => _acknowledgeBackupWipe = next);
          },
        ),
      ],
    );
  }

  Widget _buildSingleCheckboxRow({
    required bool value,
    required String label,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: value ? _destructive : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value
                    ? _destructive
                    : Colors.white.withValues(alpha: 0.24),
                width: 1.3,
              ),
            ),
            child: value
                ? const UlvenikIcon(UlvenikIcons.completed,
                    size: 15,
                    color: _offWhite,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                height: 1.45,
                color: value ? _offWhite : _stoneGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    final enabled = _canProceedToDelete;
    return GestureDetector(
      onTap: _onTapDeleteAccountButton,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled
              ? _destructive
              : _destructive.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled
                ? _destructiveBright.withValues(alpha: 0.45)
                : _destructive.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          'Delete My Account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: enabled
                ? _offWhite
                : _offWhite.withValues(alpha: 0.38),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
