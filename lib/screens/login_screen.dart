import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/ulvenik_logo.dart';
import '../widgets/ulvenik_icon.dart';
import '../widgets/custom_snackbar.dart';
import '../theme/app_colors.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'main_layout.dart';
import 'homepage_screen.dart' show HomeGreetings;

/// Sign-in (client review 13 Nov 2026).
///
/// Logo, "Welcome back" / "Sign in to your Ulvenik account.", persistent
/// field labels, full-width Sign in, "or", equal-size Apple / Google
/// buttons and a "New to Ulvenik? Create an account" link.
///
/// Authentication itself is not connected yet (no backend); valid input
/// continues into the app so the rest of the build can be reviewed.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  static final _emailRegex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return; // prevent duplicate requests
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    String? emailError;
    String? passwordError;
    if (email.isEmpty) {
      emailError = 'Enter your email address';
    } else if (!_emailRegex.hasMatch(email)) {
      emailError = 'Enter a valid email address';
    }
    if (password.isEmpty) passwordError = 'Enter your password';

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (emailError != null || passwordError != null) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    // Placeholder until authentication is connected: keeps the loading
    // state visible briefly, then continues into the app. On a real failure
    // the entered email is kept and an inline error is shown.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    HomeGreetings.advance(); // a new greeting on every log-in
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const MainLayout(),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
      (route) => false,
    );
  }

  void _providerUnavailable(String provider) {
    AppSnackbar.show(
      context,
      message: '$provider sign-in isn\'t available in this build yet.',
      type: SnackbarType.info,
    );
  }

  void _push(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => screen,
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  InputDecoration _decoration({required String hint, String? error, Widget? suffix}) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey.withValues(alpha: 0.55)),
      errorText: error,
      errorStyle: const TextStyle(color: Color(0xFFE08A8A), fontSize: 12.5),
      filled: true,
      fillColor: AppColors.cardsCarbon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      suffixIcon: suffix,
      enabledBorder: border(Colors.white12),
      focusedBorder: border(AppColors.primaryForestGreen),
      errorBorder: border(const Color(0xFF8B3A3A)),
      focusedErrorBorder: border(const Color(0xFFB04A4A)),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: UlvenikIcon(UlvenikIcons.back, color: AppColors.secondaryTextStoneGrey, size: 22),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: UlvenikLogo.full(width: 150)),
                      const SizedBox(height: 28),
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to your Ulvenik account.',
                        style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 15.5),
                      ),
                      const SizedBox(height: 28),

                      _label('Email address'),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        style: TextStyle(color: AppColors.primaryTextOffWhite),
                        onChanged: (_) {
                          if (_emailError != null) setState(() => _emailError = null);
                        },
                        onSubmitted: (_) => _passwordFocus.requestFocus(),
                        decoration: _decoration(hint: 'Enter your email address', error: _emailError),
                      ),
                      const SizedBox(height: 18),

                      _label('Password'),
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        style: TextStyle(color: AppColors.primaryTextOffWhite),
                        onChanged: (_) {
                          if (_passwordError != null) setState(() => _passwordError = null);
                        },
                        onSubmitted: (_) => _handleSignIn(),
                        decoration: _decoration(
                          hint: 'Enter your password',
                          error: _passwordError,
                          suffix: IconButton(
                            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.secondaryTextStoneGrey,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _push(const ForgotPasswordScreen()),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryTextOffWhite.withValues(alpha: 0.85),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                          ),
                          child: const Text('Forgot password?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryForestGreen,
                            foregroundColor: AppColors.onForestGreen,
                            disabledBackgroundColor: AppColors.primaryForestGreen.withValues(alpha: 0.7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primaryTextOffWhite),
                                )
                              : const Text('Sign in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.08))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Text('or', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                          ),
                          Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.08))),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _ProviderButton(
                        asset: 'assets/icons/apple_logo.svg',
                        label: 'Continue with Apple',
                        tintWhite: true,
                        onTap: () => _providerUnavailable('Apple'),
                      ),
                      const SizedBox(height: 12),
                      _ProviderButton(
                        asset: 'assets/icons/google_logo.svg',
                        label: 'Continue with Google',
                        onTap: () => _providerUnavailable('Google'),
                      ),
                      const SizedBox(height: 28),

                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('New to Ulvenik?', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14.5)),
                          TextButton(
                            onPressed: () => _push(const RegisterScreen()),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryTextOffWhite,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                            ),
                            child: const Text(
                              'Create an account',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  final String asset;
  final String label;
  final bool tintWhite;
  final VoidCallback onTap;

  const _ProviderButton({required this.asset, required this.label, required this.onTap, this.tintWhite = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryTextOffWhite,
          backgroundColor: AppColors.cardsCarbon,
          side: BorderSide(color: AppColors.cardBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              asset,
              width: 20,
              height: 20,
              colorFilter: tintWhite ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
