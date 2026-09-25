import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late AnimationController _animController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Staggered delays: 0.1s to 0.6s
    final delays = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6];
    
    _fadeAnimations = delays.map((delay) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
        ),
      );
    }).toList();

    _slideAnimations = delays.map((delay) {
      return Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(delay, delay + 0.4, curve: Curves.easeOutCubic),
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

  Widget _buildAnimatedWidget(int index, Widget child) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      // Prevents the background from resizing when keyboard opens, keeping the watermark intact
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          // ── Background: Oversized blurred watermark ───────────────────
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.05,
                child: Transform.scale(
                  scale: 1.5,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Image.asset(
                      'assets/images/brand.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback in case brand.png doesn't exist yet
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header / Back Button ────────────────────────────────────
                _buildAnimatedWidget(
                  0,
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: AppColors.secondaryTextStoneGrey),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        
                        // ── Logo ───────────────────────────────────────────────
                        _buildAnimatedWidget(
                          1,
                          Center(
                            child: Image.asset(
                              'assets/images/brand.png',
                              width: 64,
                              height: 64,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(height: 64),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 48),

                        // ── Typography ──────────────────────────────────────────
                        _buildAnimatedWidget(
                          2,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppColors.primaryTextOffWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to continue your training journey.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),

                        // ── Form ────────────────────────────────────────────────
                        _buildAnimatedWidget(
                          3,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email Input
                              Text(
                                'Email Address',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: const TextStyle(color: AppColors.primaryTextOffWhite),
                                decoration: InputDecoration(
                                  hintText: 'athlete@ulvenik.com',
                                  hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey.withOpacity(0.5)),
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
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Password Input
                              Text(
                                'Password',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: AppColors.primaryTextOffWhite),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(color: AppColors.secondaryTextStoneGrey.withOpacity(0.5)),
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: AppColors.secondaryTextStoneGrey,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: AppColors.primaryForestGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        // ── Log In Button ───────────────────────────────────────
                        _buildAnimatedWidget(
                          4,
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
                              'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),

                        // ── Social Login ────────────────────────────────────────
                        _buildAnimatedWidget(
                          5,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Expanded(child: Divider(color: Colors.white12)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'or',
                                      style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14),
                                    ),
                                  ),
                                  const Expanded(child: Divider(color: Colors.white12)),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Apple
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: SvgPicture.asset('assets/icons/apple_logo.svg', width: 20, height: 20),
                                label: const Text('Continue with Apple'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                                icon: SvgPicture.asset('assets/icons/google_logo.svg', width: 20, height: 20),
                                label: const Text('Continue with Google'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cardsCarbon,
                                  foregroundColor: AppColors.primaryTextOffWhite,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.white12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                              
                              const SizedBox(height: 24), // Bottom padding
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
