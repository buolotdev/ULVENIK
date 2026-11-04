import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/ulvenik_bottom_nav.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  static const Color _obsidian = AppColors.backgroundObsidian;
  static const Color _carbon = AppColors.cardsCarbon;
  static const Color _forest = AppColors.primaryForestGreen;
  static const Color _sageMint = Color(0xFFB6CCB5);
  static const Color _alpineBlue = AppColors.infoAlpineBlue;
  static const Color _weakRed = Color(0xFFB85C5C);
  static const Color _goodAmber = Color(0xFFC88A4B);
  static const Color _strongSageGreen = Color(0xFF5E8F79);
  static const Color _offWhite = AppColors.primaryTextOffWhite;
  static const Color _stoneGrey = AppColors.secondaryTextStoneGrey;
  static const Color _cardBorder = AppColors.cardBorder;
  static const Color _inactiveBar = Color(0xFF404944);
  static const Color _destructive = AppColors.errorDestructive;

  static const List<String> _suggestedPassphrases = [
    'VardøNord2024!',
    'FjordK9#Bergen88',
    r'Ulvenik$Trail2026',
    'IGP3*Tracking94!',
  ];

  final TextEditingController _currentPasswordController =
      TextEditingController();
  late final TextEditingController _newPasswordController;
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = false; // Matches Figma initial preview of VardøNord2024!
  bool _obscureConfirm = true;
  bool _signOutOtherDevices = false;
  bool _isUpdating = false;
  bool _passwordUpdatedSuccess = false;
  int _suggestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController(text: 'VardøNord2024!');
    _currentPasswordController.addListener(_onChanged);
    _newPasswordController.addListener(_onChanged);
    _confirmPasswordController.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) {
      setState(() {
        if (_passwordUpdatedSuccess) {
          _passwordUpdatedSuccess = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _newPass => _newPasswordController.text;
  String get _confirmPass => _confirmPasswordController.text;
  String get _currentPass => _currentPasswordController.text;

  bool get _hasMinLength => _newPass.length >= 8;
  bool get _hasUppercase => RegExp(r'[A-ZÆØÅÄÖÜ]').hasMatch(_newPass);
  bool get _hasLowercase => RegExp(r'[a-zæøåäöü]').hasMatch(_newPass);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_newPass);
  bool get _hasSpecial =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(_newPass);

  int get _metRequirementsCount {
    int count = 0;
    if (_hasMinLength) count++;
    if (_hasUppercase) count++;
    if (_hasLowercase) count++;
    if (_hasNumber) count++;
    if (_hasSpecial) count++;
    return count;
  }

  // Matches Figma 5-bar scale (4/5 for strong 14-char password, 5/5 for 16+ chars with all 5 rules)
  int get _strengthSegments {
    if (_newPass.isEmpty) return 0;
    final met = _metRequirementsCount;
    if (met <= 1) return 1;
    if (met == 2) return 2;
    if (met == 3) return 3;
    if (met == 4) return 4;
    return _newPass.length >= 16 ? 5 : 4;
  }

  String get _strengthLabel {
    final seg = _strengthSegments;
    if (seg == 0) return 'Enter password';
    if (seg <= 2) return 'Weak';
    if (seg == 3) return 'Good';
    return 'Strong';
  }

  Color get _strengthColor {
    final seg = _strengthSegments;
    if (seg == 0) return _stoneGrey;
    if (seg <= 2) return _weakRed;
    if (seg == 3) return _goodAmber;
    return _strongSageGreen;
  }

  bool get _isSameAsCurrent =>
      _currentPass.isNotEmpty &&
      _newPass.isNotEmpty &&
      _currentPass == _newPass;

  bool get _passwordsMatch =>
      _confirmPass.isNotEmpty && _confirmPass == _newPass;

  bool get _canSubmit =>
      _currentPass.trim().isNotEmpty &&
      _metRequirementsCount == 5 &&
      !_isSameAsCurrent &&
      _passwordsMatch &&
      !_isUpdating;

  void _cycleSuggestedPassword() {
    _suggestionIndex = (_suggestionIndex + 1) % _suggestedPassphrases.length;
    final next = _suggestedPassphrases[_suggestionIndex];
    setState(() {
      _newPasswordController.text = next;
      _confirmPasswordController.text = next;
      _obscureNew = false;
    });
  }

  Future<void> _handleUpdatePassword() async {
    if (_currentPass.trim().isEmpty) {
      AppSnackbar.show(
        context,
        title: 'Current Password Required',
        message: 'Enter your current password to verify your identity.',
        type: SnackbarType.warning,
      );
      return;
    }

    if (_isSameAsCurrent) {
      AppSnackbar.show(
        context,
        title: 'Choose a Different Password',
        message: 'Your new password must be different from your current one.',
        type: SnackbarType.warning,
      );
      return;
    }

    if (_metRequirementsCount < 5) {
      AppSnackbar.show(
        context,
        title: 'Password Requirements Incomplete',
        message:
            'Satisfy all 5 password strength requirements before saving.',
        type: SnackbarType.warning,
      );
      return;
    }

    if (!_passwordsMatch) {
      AppSnackbar.show(
        context,
        title: 'Passwords Do Not Match',
        message: 'Re-enter the exact same new password to confirm.',
        type: SnackbarType.warning,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isUpdating = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final revokedOthers = _signOutOtherDevices;
    setState(() {
      _isUpdating = false;
      _passwordUpdatedSuccess = true;
      _currentPasswordController.clear();
      _confirmPasswordController.clear();
      _obscureNew = true;
    });

    if (!mounted) return;
    _showPasswordUpdatedSheet(revokedOthers: revokedOthers);
  }

  void _showPasswordUpdatedSheet({required bool revokedOthers}) {
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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _forest.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: _sageMint,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Updated',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _offWhite,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Security credentials rotated just now',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              color: _sageMint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  revokedOthers
                      ? 'Your new password is active and 2 other signed-in devices have been signed out. All dog workspaces, training logs, and subscriptions remain untouched.'
                      : 'Your new password is now active across your Ulvenik account. All dog workspaces, training logs, and subscriptions remain untouched.',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    height: 1.48,
                    color: _stoneGrey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _forest,
                      foregroundColor: _offWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      Navigator.of(context).maybePop(true);
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5,
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
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCenteredHero(),
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        'CHANGE PASSWORD',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: _stoneGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordFormCard(),
                    const SizedBox(height: 16),
                    _buildInfoBanner(),
                    const SizedBox(height: 24),
                    _buildUpdateButton(),
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
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: _stoneGrey,
              size: 26,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Change Password',
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
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _carbon,
            shape: BoxShape.circle,
            border: Border.all(color: _cardBorder),
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: _stoneGrey,
            size: 22,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Keep Your Account Secure',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _offWhite,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Choose a strong password that you don't use anywhere else.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.5,
              color: _stoneGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFormCard() {
    final segments = _strengthSegments;
    final barColor = _strengthColor;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: _carbon,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Current Password
          const Text(
            'Current Password',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _stoneGrey,
            ),
          ),
          const SizedBox(height: 4),
          _buildUnderlinePasswordField(
            controller: _currentPasswordController,
            hint: 'Enter your current password',
            obscure: _obscureCurrent,
            onToggleObscure: () {
              setState(() => _obscureCurrent = !_obscureCurrent);
            },
          ),
          const SizedBox(height: 22),

          // 2. New Password + Suggest Strong pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _stoneGrey,
                ),
              ),
              GestureDetector(
                onTap: _cycleSuggestedPassword,
                behavior: HitTestBehavior.opaque,
                child: const Text(
                  'Suggest Strong',
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
          const SizedBox(height: 4),
          _buildUnderlinePasswordField(
            controller: _newPasswordController,
            hint: 'Enter your new password',
            obscure: _obscureNew,
            hasError: _isSameAsCurrent,
            onToggleObscure: () {
              setState(() => _obscureNew = !_obscureNew);
            },
          ),
          if (_isSameAsCurrent) ...[
            const SizedBox(height: 6),
            const Text(
              'New password must be different from your current password.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: Color(0xFFC25E5E),
              ),
            ),
          ],
          const SizedBox(height: 12),

          // 5-segment strength bar
          Row(
            children: [
              for (int i = 0; i < 5; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 3.5,
                    decoration: BoxDecoration(
                      color: i < segments ? barColor : _inactiveBar,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _strengthLabel,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: barColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 5 real-time requirement checkmarks
          _buildRequirementItem('Minimum 8 characters', _hasMinLength),
          const SizedBox(height: 10),
          _buildRequirementItem('At least one uppercase letter', _hasUppercase),
          const SizedBox(height: 10),
          _buildRequirementItem('At least one lowercase letter', _hasLowercase),
          const SizedBox(height: 10),
          _buildRequirementItem('At least one number', _hasNumber),
          const SizedBox(height: 10),
          _buildRequirementItem(
            'At least one special character',
            _hasSpecial,
          ),
          const SizedBox(height: 24),

          // 3. Confirm New Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _stoneGrey,
                ),
              ),
              if (_confirmPass.isNotEmpty)
                Text(
                  _passwordsMatch ? 'Matches' : 'Does not match',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _passwordsMatch ? _forest : const Color(0xFFC25E5E),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          _buildUnderlinePasswordField(
            controller: _confirmPasswordController,
            hint: 'Re-enter your new password',
            obscure: _obscureConfirm,
            hasError: _confirmPass.isNotEmpty && !_passwordsMatch,
            onToggleObscure: () {
              setState(() => _obscureConfirm = !_obscureConfirm);
            },
          ),
          const SizedBox(height: 22),
          Container(height: 1, color: _cardBorder),
          const SizedBox(height: 18),

          // 4. Sign out of all other devices
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.smartphone_rounded,
                color: _stoneGrey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign out of all other devices',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _offWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _signOutOtherDevices
                          ? '2 other active sessions (iPad Air M2, Web) will be signed out.'
                          : "You'll need to sign in again on your other devices.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5,
                        height: 1.4,
                        color: _signOutOtherDevices ? _sageMint : _stoneGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Switch(
                value: _signOutOtherDevices,
                activeThumbColor: _offWhite,
                activeTrackColor: _forest,
                inactiveThumbColor: _offWhite,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.16),
                onChanged: (val) {
                  setState(() => _signOutOtherDevices = val);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnderlinePasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggleObscure,
    bool hasError = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.5,
        color: _offWhite,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.5,
          color: _stoneGrey.withValues(alpha: 0.65),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hasError
                ? _destructive
                : Colors.white.withValues(alpha: 0.16),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hasError ? _destructive : _forest,
            width: 1.5,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggleObscure,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: _stoneGrey,
            size: 19,
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool met) {
    final activeGreen = const Color(0xFF3E8E72);
    final itemColor = met ? activeGreen : _stoneGrey;

    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: itemColor,
              width: 1.15,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.check_rounded,
              size: 10,
              color: itemColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: itemColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: _alpineBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _alpineBlue.withValues(alpha: 0.28),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: _alpineBlue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Changing your password does not affect your dogs, training records or subscriptions.',
              style: TextStyle(
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

  Widget _buildUpdateButton() {
    final enabled = _canSubmit;
    return GestureDetector(
      onTap: _handleUpdatePassword,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? _forest : _forest.withValues(alpha: 0.32),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled
                ? _sageMint.withValues(alpha: 0.35)
                : _forest.withValues(alpha: 0.2),
          ),
        ),
        child: _isUpdating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(_offWhite),
                ),
              )
            : Text(
                'Update Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: enabled
                      ? _offWhite
                      : _offWhite.withValues(alpha: 0.85),
                ),
              ),
      ),
    );
  }
}
