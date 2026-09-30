import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _sequenceController;
  late AnimationController _fillController;
  late AnimationController _exitController;

  // Logo reveal
  late Animation<double> _logoBlur;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  // Bar + text entrance
  late Animation<double> _barOpacity;
  late Animation<Offset> _barSlide;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  // Bar fill progress (0.0 to 1.0)
  late Animation<double> _fillProgress;

  late Animation<double> _logoExitScale;
  late Animation<double> _logoExitOpacity;
  late Animation<double> _uiExitOpacity;
  late Animation<double> _exitBlur;

  @override
  void initState() {
    super.initState();

    // ── Sequence: 2.4 seconds ─────────────────────────────────────────────
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _logoBlur = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOut), // 0-1800ms
      ),
    );

    _logoScale = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.80, curve: Curves.elasticOut), // 0-1920ms
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn), // 0-840ms
      ),
    );

    _barOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut), // 1560-2040ms
      ),
    );
    _barSlide = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOut), // 1920-2400ms
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // 1.2s to fill
    );
    _fillProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fillController, curve: Curves.easeInOut),
    );

    // ── Exit Sequence: Zoom in ─────────────────────────────────────────────
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _logoExitScale = Tween<double>(begin: 1.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInExpo, // accelerates rapidly
      ),
    );

    _exitBlur = Tween<double>(begin: 0.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeIn, 
      ),
    );

    _logoExitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut), 
      ),
    );

    _uiExitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut), 
      ),
    );

    _sequenceController.forward();

    // Start filling when sequence completes
    _sequenceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _fillController.forward();
      }
    });

    // Trigger exit animation when fill completes
    _fillController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          _exitController.forward();
        });
      }
    });

    // Trigger navigation
    _exitController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const OnboardingScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    _fillController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: AnimatedBuilder(
        animation: Listenable.merge([_sequenceController, _exitController, _fillController]),
        builder: (context, child) {
          final currentScale = _logoScale.value * _logoExitScale.value;
          final currentOpacity = _logoOpacity.value * _logoExitOpacity.value;
          final uiOpacity = _uiExitOpacity.value;
          final currentBlur = _logoBlur.value + _exitBlur.value;

          return Stack(
            children: [
              // ── 1. Logo ───────────────────────────────────────────────────
              Center(
                child: Opacity(
                  opacity: currentOpacity,
                  child: Transform.scale(
                    scale: currentScale,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: currentBlur,
                        sigmaY: currentBlur,
                      ),
                      child: Image.asset(
                        'assets/images/white_mountain_only.png',
                        width: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // ── 2. Bar + Text ─────────────────────────────────────────────
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: uiOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bar
                      SlideTransition(
                        position: _barSlide,
                        child: FadeTransition(
                          opacity: _barOpacity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 48), // Full width with padding
                            child: Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2220),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9999),
                                child: AnimatedBuilder(
                                  animation: _fillProgress,
                                  builder: (context, _) {
                                    return FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _fillProgress.value,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF2E6B57),
                                              Color(0xFF5DBFA0),
                                              Colors.white,
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Text
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Text(
                            'Preparing your training journey...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.secondaryTextStoneGrey,
                                  fontSize: 13,
                                  letterSpacing: 0.1,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
