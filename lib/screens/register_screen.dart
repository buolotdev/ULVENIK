import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/password_strength_indicator.dart';
import 'login_screen.dart';
import 'email_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  String _passwordValue = '';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animController;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final delays = [0.05, 0.15, 0.25, 0.35, 0.45, 0.55];

    _fadeAnims = delays.map((d) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(d, d + 0.4, curve: Curves.easeOut),
        ),
      );
    }).toList();

    _slideAnims = delays.map((d) {
      return Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(d, d + 0.4, curve: Curves.easeOutCubic),
        ),
      );
    }).toList();

    _animController.forward();

    _passwordController.addListener(() {
      setState(() => _passwordValue = _passwordController.text);
    });
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      AppSnackbar.show(context,
          title: 'Name Required',
          message: 'Please enter your full name to create your account.',
          type: SnackbarType.error);
      return;
    }

    if (email.isEmpty) {
      AppSnackbar.show(context,
          title: 'Email Required',
          message: 'Please enter your email address.',
          type: SnackbarType.error);
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      AppSnackbar.show(context,
          title: 'Invalid Email',
          message: 'Please enter a valid email address (e.g. you@example.com).',
          type: SnackbarType.error);
      return;
    }

    if (password.isEmpty) {
      AppSnackbar.show(context,
          title: 'Password Required',
          message: 'Please create a password for your account.',
          type: SnackbarType.error);
      return;
    }

    if (password.length < 8) {
      AppSnackbar.show(context,
          title: 'Password Too Short',
          message: 'Your password must be at least 8 characters long.',
          type: SnackbarType.error);
      return;
    }

    final strength = PasswordStrengthIndicator.evaluate(password);
    if (strength == PasswordStrength.weak || strength == PasswordStrength.fair) {
      AppSnackbar.show(context,
          title: 'Password Too Simple',
          message: 'Use uppercase letters, numbers, and symbols to make it stronger.',
          type: SnackbarType.warning);
      return;
    }

    if (confirmPassword != password) {
      AppSnackbar.show(context,
          title: 'Passwords Do Not Match',
          message: 'Double-check that both password fields are identical.',
          type: SnackbarType.error);
      return;
    }

    if (!_termsAccepted) {
      AppSnackbar.show(context,
          title: 'Terms Required',
          message: 'You must agree to the Terms & Conditions to continue.',
          type: SnackbarType.warning);
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EmailVerificationScreen(email: email),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) {
    return SlideTransition(
      position: _slideAnims[index],
      child: FadeTransition(
        opacity: _fadeAnims[index],
        child: child,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.secondaryTextStoneGrey.withOpacity(0.5),
        fontSize: 15,
      ),
      filled: true,
      fillColor: AppColors.cardsCarbon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryForestGreen),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Blurred watermark ──────────────────────────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Transform.scale(
                scale: 1.5,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Image.asset(
                    'assets/images/brand.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Back Button ────────────────────────────────────────
                _animated(
                  0,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E2328),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.secondaryTextStoneGrey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Scrollable body ────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),

                        // ── Logo ─────────────────────────────────────────
                        _animated(
                          0,
                          Center(
                            child: Image.asset(
                              'assets/images/brand.png',
                              width: 72,
                              height: 72,
                              errorBuilder: (_, __, ___) => const SizedBox(height: 72),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Heading ──────────────────────────────────────
                        _animated(
                          1,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Create Your Account',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppColors.primaryTextOffWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 28,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start building your training journey.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Form Fields ──────────────────────────────────
                        _animated(
                          2,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Full Name
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                ),
                                decoration: _inputDecoration('Full Name'),
                              ),
                              const SizedBox(height: 16),

                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                ),
                                decoration: _inputDecoration('Email Address'),
                              ),
                              const SizedBox(height: 16),

                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                ),
                                decoration: _inputDecoration('Password').copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                              ),
                              // ── Strength indicator ──────────────────────
                              PasswordStrengthIndicator(password: _passwordValue),
                              const SizedBox(height: 12),

                              // Confirm Password
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                ),
                                decoration: _inputDecoration('Confirm Password').copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Terms checkbox ───────────────────────────────
                        _animated(
                          3,
                          GestureDetector(
                            onTap: () => setState(() => _termsAccepted = !_termsAccepted),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 1, right: 12),
                                  decoration: BoxDecoration(
                                    color: _termsAccepted
                                        ? AppColors.primaryForestGreen
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _termsAccepted
                                          ? AppColors.primaryForestGreen
                                          : Colors.white24,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: _termsAccepted
                                      ? const Icon(Icons.check,
                                          size: 14, color: Colors.white)
                                      : null,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        color: AppColors.secondaryTextStoneGrey,
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                      children: [
                                        TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: TextStyle(
                                            color: AppColors.primaryForestGreen,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: AppColors.primaryForestGreen,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Create Account Button ────────────────────────
                        _animated(
                          3,
                          ElevatedButton(
                            onPressed: _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryForestGreen,
                              foregroundColor: AppColors.primaryTextOffWhite,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Divider ──────────────────────────────────────
                        _animated(
                          4,
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Colors.white12)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'or',
                                  style: TextStyle(
                                    color: AppColors.secondaryTextStoneGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(color: Colors.white12)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Social Buttons ───────────────────────────────
                        _animated(
                          5,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Apple
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  'assets/icons/apple_logo.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                                label: const Text('Continue with Apple'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.white12),
                                  ),
                                  elevation: 0,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Google
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  'assets/icons/google_logo.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                label: const Text('Continue with Google'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cardsCarbon,
                                  foregroundColor: AppColors.primaryTextOffWhite,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.white12),
                                  ),
                                  elevation: 0,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Log In link
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        color: AppColors.secondaryTextStoneGrey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Text(
                                        'Log In',
                                        style: TextStyle(
                                          color: AppColors.primaryForestGreen,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
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
}
