import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialFirstName;
  final String initialLastName;
  final String initialDisplayName;
  final String initialEmail;
  final String initialCountry;
  final String initialLanguage;
  final String initialTimeZone;
  final String initialWeightUnit;
  final String initialDistanceUnit;

  const EditProfileScreen({
    super.key,
    this.initialFirstName = 'James',
    this.initialLastName = 'Harlow',
    this.initialDisplayName = 'James Harlow',
    this.initialEmail = 'james@example.com',
    this.initialCountry = 'Pakistan',
    this.initialLanguage = 'English',
    this.initialTimeZone = 'Asia/Karachi (PKT, UTC+5)',
    this.initialWeightUnit = 'Kilograms (kg)',
    this.initialDistanceUnit = 'Kilometres',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _saveDimGreen = Color(0xFF3E836B);
  static const Color _destructiveRed = Color(0xFFD96B6B);

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _displayNameController;

  late String _savedFirstName;
  late String _savedLastName;
  late String _savedDisplayName;
  late String _savedEmail;
  late String _savedCountry;
  late String _savedLanguage;
  late String _savedTimeZone;
  late String _savedWeight;
  late String _savedDistance;

  late String _email;
  late String _country;
  late String _language;
  late String _timeZone;
  late String _weightUnit;
  late String _distanceUnit;
  String _passwordSubtitle = 'Last changed 3 months ago';

  String? _firstNameError;
  String? _lastNameError;
  String? _displayNameError;

  @override
  void initState() {
    super.initState();
    _savedFirstName = widget.initialFirstName;
    _savedLastName = widget.initialLastName;
    _savedDisplayName = widget.initialDisplayName;
    _savedEmail = widget.initialEmail;
    _savedCountry = widget.initialCountry;
    _savedLanguage = widget.initialLanguage;
    _savedTimeZone = widget.initialTimeZone;
    _savedWeight = widget.initialWeightUnit;
    _savedDistance = widget.initialDistanceUnit;

    _email = _savedEmail;
    _country = _savedCountry;
    _language = _savedLanguage;
    _timeZone = _savedTimeZone;
    _weightUnit = _savedWeight;
    _distanceUnit = _savedDistance;

    _firstNameController = TextEditingController(text: _savedFirstName)
      ..addListener(_onTextEdited);
    _lastNameController = TextEditingController(text: _savedLastName)
      ..addListener(_onTextEdited);
    _displayNameController = TextEditingController(text: _savedDisplayName)
      ..addListener(_onTextEdited);
  }

  void _onTextEdited() {
    setState(() {
      if (_firstNameController.text.trim().isNotEmpty) {
        _firstNameError = null;
      }
      if (_lastNameController.text.trim().isNotEmpty) {
        _lastNameError = null;
      }
      if (_displayNameController.text.trim().isNotEmpty) {
        _displayNameError = null;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  bool get _hasUnsavedChanges {
    return _firstNameController.text.trim() != _savedFirstName ||
        _lastNameController.text.trim() != _savedLastName ||
        _displayNameController.text.trim() != _savedDisplayName ||
        _email != _savedEmail ||
        _country != _savedCountry ||
        _language != _savedLanguage ||
        _timeZone != _savedTimeZone ||
        _weightUnit != _savedWeight ||
        _distanceUnit != _savedDistance;
  }

  String get _maskedEmail {
    final idx = _email.indexOf('@');
    if (idx <= 1) return _email;
    return '${_email[0]}***${_email.substring(idx)}';
  }

  Future<bool> _showDiscardConfirmationSheet() async {
    final shouldDiscard = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTextStoneGrey
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Discard Unsaved Changes?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You have unsaved edits to your profile or regional preferences. Leaving now will discard these changes.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(sheetCtx).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Keep Editing',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.primaryTextOffWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(sheetCtx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorDestructive,
                            foregroundColor: AppColors.primaryTextOffWhite,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Discard Changes',
                            style: TextStyle(
                              fontFamily: 'Inter',
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
          ),
        );
      },
    );
    return shouldDiscard ?? false;
  }

  Future<void> _handleBackAttempt() async {
    if (_hasUnsavedChanges) {
      final discard = await _showDiscardConfirmationSheet();
      if (!discard || !mounted) return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _saveChanges() {
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final display = _displayNameController.text.trim();

    setState(() {
      _firstNameError = first.isEmpty ? 'First name is required' : null;
      _lastNameError = last.isEmpty ? 'Last name is required' : null;
      _displayNameError = display.isEmpty ? 'Display name is required' : null;
    });

    if (_firstNameError != null ||
        _lastNameError != null ||
        _displayNameError != null) {
      AppSnackbar.show(
        context,
        title: 'Check Required Fields',
        message: 'First name, last name, and display name cannot be empty.',
        type: SnackbarType.error,
      );
      return;
    }

    final shortWeight = _weightUnit.contains('lb') ? 'lb' : 'kg';
    final shortDist = _distanceUnit == 'Miles' ? 'mi' : 'km';

    final payload = <String, dynamic>{
      'firstName': first,
      'lastName': last,
      'displayName': display,
      'fullName': display,
      'email': _email,
      'country': _country,
      'location': _country,
      'language': _language,
      'timeZone': _timeZone,
      'weightUnit': _weightUnit,
      'distanceUnit': _distanceUnit,
      'unitsAndDate': '$shortWeight · $shortDist · DD/MM/YYYY',
    };

    setState(() {
      _savedFirstName = first;
      _savedLastName = last;
      _savedDisplayName = display;
      _savedEmail = _email;
      _savedCountry = _country;
      _savedLanguage = _language;
      _savedTimeZone = _timeZone;
      _savedWeight = _weightUnit;
      _savedDistance = _distanceUnit;
    });

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(payload);
    } else {
      AppSnackbar.show(
        context,
        title: 'Profile Saved',
        message: 'Updated profile preferences for $display.',
        type: SnackbarType.success,
      );
    }
  }

  void _openSelectorSheet({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryTextStoneGrey
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetCtx).pop(),
                        icon: const UlvenikIcon(UlvenikIcons.back,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final option in options)
                    InkWell(
                      onTap: () {
                        onSelected(option);
                        Navigator.of(sheetCtx).pop();
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: option == current
                                      ? _mint
                                      : AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                  fontWeight: option == current
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            UlvenikIcon.fromMaterial(
                              option == current
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: option == current
                                  ? _mint
                                  : AppColors.secondaryTextStoneGrey,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openChangeEmailSheet() {
    final ctrl = TextEditingController(text: _email);
    String? errorText;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  border: Border(
                    top: BorderSide(color: AppColors.cardBorder, width: 1),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Change Email Address',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Used for Trainer Pack sign-in, security alerts, and billing receipts.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: ctrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14.5,
                          ),
                          decoration: InputDecoration(
                            labelText: 'New Email Address',
                            errorText: errorText,
                            labelStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundObsidian,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cardBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cardBorder),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final next = ctrl.text.trim();
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(next)) {
                                setModalState(() {
                                  errorText =
                                      'Enter a valid email address (e.g. name@domain.com)';
                                });
                                return;
                              }
                              setState(() => _email = next);
                              Navigator.of(sheetCtx).pop();
                              AppSnackbar.show(
                                context,
                                title: 'Email Updated',
                                message:
                                    'Account email staged as $next. Tap Save Changes to apply.',
                                type: SnackbarType.info,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryForestGreen,
                              foregroundColor: AppColors.primaryTextOffWhite,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Update Email',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openChangePasswordSheet() {
    final currentCtrl = TextEditingController();
    final nextCtrl = TextEditingController();
    String? errorMsg;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.cardsCarbon,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  border: Border(
                    top: BorderSide(color: AppColors.cardBorder, width: 1),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Update Password',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Choose a strong password of at least 8 characters.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: currentCtrl,
                          obscureText: true,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Current password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundObsidian,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cardBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cardBorder),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: nextCtrl,
                          obscureText: true,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                          ),
                          decoration: InputDecoration(
                            hintText: 'New password (min 8 characters)',
                            errorText: errorMsg,
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.secondaryTextStoneGrey,
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundObsidian,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cardBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cardBorder),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentCtrl.text.isEmpty ||
                                  nextCtrl.text.length < 8) {
                                setModalState(() {
                                  errorMsg =
                                      'Enter current password and at least 8 characters for new password';
                                });
                                return;
                              }
                              setState(() {
                                _passwordSubtitle = 'Last changed just now';
                              });
                              Navigator.of(sheetCtx).pop();
                              AppSnackbar.show(
                                context,
                                title: 'Password Updated',
                                message:
                                    'Your account password has been updated.',
                                type: SnackbarType.success,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryForestGreen,
                              foregroundColor: AppColors.primaryTextOffWhite,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Update Password',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dirty = _hasUnsavedChanges;

    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await _showDiscardConfirmationSheet();
        if (discard && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundObsidian,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundObsidian,
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _handleBackAttempt,
                        icon: const UlvenikIcon(UlvenikIcons.back,
                          color: AppColors.secondaryTextStoneGrey,
                          size: 26,
                        ),
                        tooltip: 'Back',
                      ),
                      const SizedBox(width: 2),
                      const Expanded(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _saveChanges,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: dirty ? _mint : _saveDimGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('PERSONAL INFORMATION'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEditableFieldBlock(
                            label: 'FIRST NAME',
                            controller: _firstNameController,
                            errorText: _firstNameError,
                            defaultGreenUnderline: true,
                          ),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          _buildEditableFieldBlock(
                            label: 'LAST NAME',
                            controller: _lastNameController,
                            errorText: _lastNameError,
                          ),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          _buildEditableFieldBlock(
                            label: 'DISPLAY NAME',
                            controller: _displayNameController,
                            errorText: _displayNameError,
                            helperText:
                                'Shown in Trainer Pack, shared reports and future public profiles.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    _buildSectionTitle('REGIONAL SETTINGS'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          _buildDropdownBlock(
                            label: 'COUNTRY',
                            value: _country,
                            onTap: () => _openSelectorSheet(
                              title: 'Country or Region',
                              options: const [
                                'Pakistan',
                                'United Kingdom',
                                'Norway',
                                'Denmark',
                                'Sweden',
                                'Germany',
                                'United States',
                              ],
                              current: _country,
                              onSelected: (v) {
                                setState(() {
                                  _country = v;
                                  if (v == 'United Kingdom') {
                                    _timeZone = 'Europe/London (GMT, UTC+0)';
                                  } else if (v == 'Pakistan') {
                                    _timeZone = 'Asia/Karachi (PKT, UTC+5)';
                                  } else if (v == 'Norway' ||
                                      v == 'Denmark' ||
                                      v == 'Sweden' ||
                                      v == 'Germany') {
                                    _timeZone = 'Europe/Oslo (CET, UTC+1)';
                                  }
                                });
                              },
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          _buildDropdownBlock(
                            label: 'LANGUAGE',
                            value: _language,
                            onTap: () => _openSelectorSheet(
                              title: 'Language',
                              options: const [
                                'English',
                                'English (UK)',
                                'Deutsch',
                                'Dansk',
                                'Norsk',
                                'Svenska',
                              ],
                              current: _language,
                              onSelected: (v) => setState(() => _language = v),
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          _buildDropdownBlock(
                            label: 'TIME ZONE',
                            value: _timeZone,
                            helperText:
                                'Auto-detected from device. Changes update reminders and calendar.',
                            onTap: () => _openSelectorSheet(
                              title: 'Time Zone',
                              options: const [
                                'Asia/Karachi (PKT, UTC+5)',
                                'Europe/London (GMT, UTC+0)',
                                'Europe/Oslo (CET, UTC+1)',
                                'Europe/Berlin (CET, UTC+1)',
                                'America/New_York (EST, UTC-5)',
                              ],
                              current: _timeZone,
                              onSelected: (v) => setState(() => _timeZone = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    _buildSectionTitle('MEASUREMENT PREFERENCES'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          _buildDropdownBlock(
                            label: 'WEIGHT',
                            value: _weightUnit,
                            onTap: () => _openSelectorSheet(
                              title: 'Weight Unit',
                              options: const ['Kilograms (kg)', 'Pounds (lb)'],
                              current: _weightUnit,
                              onSelected: (v) =>
                                  setState(() => _weightUnit = v),
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          _buildDropdownBlock(
                            label: 'DISTANCE',
                            value: _distanceUnit,
                            onTap: () => _openSelectorSheet(
                              title: 'Distance Unit',
                              options: const ['Kilometres', 'Miles'],
                              current: _distanceUnit,
                              onSelected: (v) =>
                                  setState(() => _distanceUnit = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'Changing units only affects how values are displayed. Stored data is never modified.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                          height: 1.42,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _buildSectionTitle('ACCOUNT'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.cardsCarbon,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _openChangeEmailSheet,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const UlvenikIcon(UlvenikIcons.notifications,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Email Address',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: AppColors
                                                      .primaryTextOffWhite,
                                                  fontSize: 15.5,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .primaryForestGreen
                                                      .withValues(alpha: 0.24),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: const Text(
                                                  'VERIFIED',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: _mint,
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _maskedEmail,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: AppColors
                                                  .secondaryTextStoneGrey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const UlvenikIcon(UlvenikIcons.details,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 19,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.cardBorder),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _openChangePasswordSheet,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const UlvenikIcon(UlvenikIcons.overflowMenu,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Password',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color:
                                                  AppColors.primaryTextOffWhite,
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _passwordSubtitle,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: AppColors
                                                  .secondaryTextStoneGrey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const UlvenikIcon(UlvenikIcons.details,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 19,
                                    ),
                                  ],
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.backgroundObsidian,
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const UlvenikBottomNav(
          activeTab: UlvenikNavTab.more,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildEditableFieldBlock({
    required String label,
    required TextEditingController controller,
    String? errorText,
    String? helperText,
    bool defaultGreenUnderline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.primaryTextOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            cursorColor: _mint,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 8, top: 2),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: errorText != null
                      ? _destructiveRed
                      : (defaultGreenUnderline
                          ? AppColors.primaryForestGreen
                          : Colors.white.withValues(alpha: 0.12)),
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: errorText != null ? _destructiveRed : _mint,
                  width: 1.4,
                ),
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(
              errorText,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: _destructiveRed,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (helperText != null) ...[
            const SizedBox(height: 10),
            Text(
              helperText,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdownBlock({
    required String label,
    required String value,
    String? helperText,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const UlvenikIcon(UlvenikIcons.sort,
                    color: AppColors.secondaryTextStoneGrey,
                    size: 22,
                  ),
                ],
              ),
              if (helperText != null) ...[
                const SizedBox(height: 10),
                Text(
                  helperText,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
