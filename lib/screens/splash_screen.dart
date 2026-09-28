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
  // Bar track width in px — fixed
  static const double _trackWidth = 200.0;
  // Comet width in px
  static const double _cometWidth = 120.0;

  late AnimationController _sequenceController;
  late AnimationController _cometController;
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

  // Comet in PIXELS
  late Animation<double> _cometX;

  // Exit animations (Zoom in effect)
  late Animation<double> _logoExitScale;
  late Animation<double> _logoExitOpacity;
  late Animation<double> _uiExitOpacity;

  @override
  void initState() {
    super.initState();

    // ── Sequence: 2.8 seconds ─────────────────────────────────────────────
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _logoBlur = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _logoScale = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.70, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.30, curve: Curves.easeIn),
      ),
    );

    _barOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.55, 0.72, curve: Curves.easeOut),
      ),
    );
    _barSlide = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.55, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.67, 0.84, curve: Curves.easeOut),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.67, 0.84, curve: Curves.easeOutCubic),
      ),
    );

    _cometController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _cometX = Tween<double>(
      begin: -_cometWidth,
      end: _trackWidth,
    ).animate(
      CurvedAnimation(parent: _cometController, curve: Curves.easeInOut),
    );

    // ── Exit Sequence: Zoom in ─────────────────────────────────────────────
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _logoExitScale = Tween<double>(begin: 1.0, end: 50.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInExpo, // accelerates rapidly
      ),
    );

    _logoExitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut), 
      ),
    );

    _uiExitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut), 
      ),
    );

    _sequenceController.forward();

    // Trigger exit animation
    _sequenceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Future.delayed(const Duration(milliseconds: 600), () {
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

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) _cometController.repeat();
    });
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    _cometController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: AnimatedBuilder(
        animation: Listenable.merge([_sequenceController, _exitController]),
        builder: (context, child) {
          final currentScale = _logoScale.value * _logoExitScale.value;
          final currentOpacity = _logoOpacity.value * _logoExitOpacity.value;
          final uiOpacity = _uiExitOpacity.value;

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
                        sigmaX: _logoBlur.value,
                        sigmaY: _logoBlur.value,
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
                          child: Center(
                            child: SizedBox(
                              width: _trackWidth,
                              height: 4,
                              child: ClipRect(
                                child: Stack(
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    // Track background
                                    Container(
                                      width: _trackWidth,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1C2220),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                    ),
                                    // Comet
                                    AnimatedBuilder(
                                      animation: _cometX,
                                      builder: (context, _) {
                                        return Transform.translate(
                                          offset: Offset(_cometX.value, 0),
                                          child: Container(
                                            width: _cometWidth,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Color(0xFF1A3D31),
                                                  Color(0xFF2E6B57),
                                                  Color(0xFF5DBFA0),
                                                  Color(0xFFD4F5E9),
                                                  Colors.white,
                                                ],
                                                stops: [0.0, 0.15, 0.45, 0.75, 0.90, 1.0],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
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
