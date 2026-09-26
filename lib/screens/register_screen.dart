import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

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
  }

  @override
  void dispose() {
    _animController.dispose();
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
          // ── Oversized blurred watermark ────────────────────────────
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
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
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start building your training journey.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                                style: const TextStyle(
                                  color: AppColors.primaryTextOffWhite,
                                  fontSize: 15,
                                ),
                                decoration: _inputDecoration('Full Name'),
                              ),
                              const SizedBox(height: 16),

                              // Email
                              TextFormField(
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
                              const SizedBox(height: 16),

                              // Confirm Password
                              TextFormField(
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

                        const SizedBox(height: 20),

                        // ── Terms checkbox ───────────────────────────────
                        _animated(
                          3,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _termsAccepted,
                                onChanged: (v) =>
                                    setState(() => _termsAccepted = v ?? false),
                                activeColor: AppColors.primaryForestGreen,
                                checkColor: AppColors.primaryTextOffWhite,
                                side: const BorderSide(color: Colors.white24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: AppColors.secondaryTextStoneGrey,
                                      fontSize: 13,
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            'Terms & Conditions',
                                            style: TextStyle(
                                              color: AppColors.primaryForestGreen,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              color: AppColors.primaryForestGreen,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
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

                        const SizedBox(height: 24),

                        // ── Create Account Button ────────────────────────
                        _animated(
                          3,
                          ElevatedButton(
                            onPressed: () {},
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
