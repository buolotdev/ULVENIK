import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'two_factor_setup_screen.dart';
import '../widgets/custom_snackbar.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    this.email = 'olivia@email.com',
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with TickerProviderStateMixin {
  bool _isVerified = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  Timer? _resendTimer;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _countdown = 60;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _verifyEmail() {
    setState(() {
      _isVerified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _isVerified ? _buildSuccessState() : _buildWaitingState(),
        ),
      ),
    );
  }

  Widget _buildWaitingState() {
    return CustomScrollView(
      key: const ValueKey('waiting_state'),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          // Logo
          Center(
            child: Image.asset(
              'assets/images/brand.png',
              width: 72,
              height: 72,
              errorBuilder: (_, __, ___) => const SizedBox(height: 72),
            ),
          ),
          
          const Spacer(flex: 1),
          
          // Icon & Heading
          const Icon(
            Icons.mail_outline,
            size: 64,
            color: AppColors.primaryForestGreen,
          ),
          const SizedBox(height: 24),
          Text(
            'Verify Your Email',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primaryTextOffWhite,
              fontWeight: FontWeight.w600,
              fontSize: 28,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "We've sent a verification link to your email address to ensure account security.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.secondaryTextStoneGrey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AWAITING VERIFICATION',
                          style: TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    FadeTransition(
                      opacity: _pulseAnimation,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryForestGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white12, height: 1),
                ),
                Text(
                  'Verification sent to',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Check your inbox and spam folder for an email from ULVENIK. Click the link inside to verify.',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Spacer(flex: 2),
          
          // Actions
          ElevatedButton.icon(
            onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
            icon: const Icon(Icons.mark_email_unread_outlined, size: 20),
            label: const Text('Open Email App'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryForestGreen,
              foregroundColor: AppColors.primaryTextOffWhite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _verifyEmail,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryForestGreen,
              side: const BorderSide(color: AppColors.primaryForestGreen, width: 1),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "I've Verified My Email",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Bottom links
          Column(
            children: [
              if (_countdown > 0) ...[
                Text(
                  'Resend Verification Email',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Available in ${_countdown}s',
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                  ),
                ),
              ] else ...[
                TextButton.icon(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text(
                    'Resend Verification Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryTextOffWhite,
                    backgroundColor: Colors.white.withOpacity(0.06),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Text(
                  'Use a Different Email Address',
                  style: TextStyle(
                    color: AppColors.primaryForestGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return CustomScrollView(
      key: const ValueKey('success_state'),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          // Logo
          Center(
            child: Image.asset(
              'assets/images/brand.png',
              width: 72,
              height: 72,
              errorBuilder: (_, __, ___) => const SizedBox(height: 72),
            ),
          ),
          
          const Spacer(flex: 1),
          
          // Icon & Heading (with explicit animated scale in)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.primaryForestGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Email Verified',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primaryTextOffWhite,
              fontWeight: FontWeight.w600,
              fontSize: 28,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Your email address has been successfully verified.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.primaryForestGreen,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'VERIFIED',
                      style: TextStyle(
                        color: AppColors.primaryForestGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white12, height: 1),
                ),
                Text(
                  'Verified address',
                  style: TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Spacer(flex: 2),
          
          // Continue Button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => 
                      const TwoFactorSetupScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
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
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 48), // Padding equivalent to bottom content in waiting state
        ],
      ),
          ),
        ),
      ],
    );
  }
}
