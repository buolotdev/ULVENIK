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

  // Logo reveal
  late Animation<double> _logoBlur;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  // Bar + text entrance
  late Animation<double> _barOpacity;
  late Animation<Offset> _barSlide;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  // Comet in PIXELS: starts at -_cometWidth (fully off left), ends at _trackWidth (fully off right)
  late Animation<double> _cometX;

  @override
  void initState() {
    super.initState();

    // ── Sequence: 2.8 seconds ─────────────────────────────────────────────
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Logo blur: 24px → 0   (0% → 65% = 0–1820ms)  Slow & cinematic
    _logoBlur = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // Logo scale: 0.84 → 1.0  (0% → 70%)
    _logoScale = Tween<double>(begin: 0.84, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.70, curve: Curves.elasticOut),
      ),
    );

    // Logo opacity: 0 → 0.9  (0% → 30% = 0–840ms) — fades in fast, reveal lingers
    _logoOpacity = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.30, curve: Curves.easeIn),
      ),
    );

    // Bar: slides up + fades in  (55% → 72%)
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

    // Text: slides up + fades in a beat after bar  (67% → 84%)
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

    // ── Comet: exact pixel travel ─────────────────────────────────────────
    // Starts at -_cometWidth → fully hidden off the LEFT edge
    // Ends at   +_trackWidth → fully hidden off the RIGHT edge
    _cometController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _cometX = Tween<double>(
      begin: -_cometWidth,   // -120px  → completely off left
      end: _trackWidth,       // +200px  → completely off right
    ).animate(
      CurvedAnimation(parent: _cometController, curve: Curves.easeInOut),
    );

    _sequenceController.forward();
    // Navigate to onboarding once sequence is fully done
    _sequenceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => const OnboardingScreen(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        });
      }
    });
    // Start comet after bar animates in (~1540ms into sequence)
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) _cometController.repeat();
    });
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    _cometController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: Stack(
        children: [
          // ── 1. Logo ───────────────────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _sequenceController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: _logoBlur.value,
                        sigmaY: _logoBlur.value,
                      ),
                      child: child,
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/white_mountain_only.png',
                width: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // ── 2. Bar + Text ─────────────────────────────────────────────
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
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
                              // Comet — positioned in raw pixels, no fractions
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
        ],
      ),
    );
  }
}
