import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  late AnimationController _animController;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final delays = [0.0, 0.1, 0.2, 0.3];

    _fadeAnims = delays.map((d) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(d, d + 0.5, curve: Curves.easeOut),
        ),
      );
    }).toList();

    _slideAnims = delays.map((d) {
      return Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(d, d + 0.5, curve: Curves.easeOutCubic),
        ),
      );
    }).toList();

    _animController.forward();
  }

  void _handleSendReset() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AppSnackbar.show(context,
          title: 'Email Required',
          message: 'Please enter your email address to receive a reset link.',
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

    // TODO: Call password reset service
    AppSnackbar.show(context,
        title: 'Reset Link Sent',
        message: 'Check your inbox — a reset link has been sent to $email.',
        type: SnackbarType.success);
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
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
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    
                    // ── Circular Logo ─────────────────────────────────
                    _animated(
                      0,
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white12, width: 1),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/brand.png',
                            color: Colors.white70,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // ── Headings ──────────────────────────────────────
                    _animated(
                      1,
                      Column(
                        children: [
                          Text(
                            'Forgot Your Password?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppColors.primaryTextOffWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Enter the email address linked to your Ulvenik account and we'll send you a secure password reset link.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.secondaryTextStoneGrey,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // ── Form Container ─────────────────────────────────
                    _animated(
                      2,
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.cardsCarbon,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Email Address',
                              style: TextStyle(
                                color: AppColors.secondaryTextStoneGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: AppColors.primaryTextOffWhite,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your email address',
                                hintStyle: TextStyle(
                                  color: AppColors.secondaryTextStoneGrey.withOpacity(0.5),
                                  fontSize: 15,
                                ),
                                filled: true,
                                fillColor: AppColors.backgroundObsidian,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppColors.primaryForestGreen),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            ElevatedButton(
                              onPressed: _handleSendReset,
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
                                'Send Reset Link',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
