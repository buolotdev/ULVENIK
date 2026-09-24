import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Master entrance sequence
  late AnimationController _entranceController;
  // Ken Burns: slow pan + zoom on background
  late AnimationController _kenBurnsController;

  // Header: logo + skip drop in from top
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;

  // Title: rises from below
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  // Body text: rises slightly after title
  late Animation<double> _bodyOpacity;
  late Animation<Offset> _bodySlide;

  // Footer: dots + button
  late Animation<double> _footerOpacity;
  late Animation<Offset> _footerSlide;

  // Ken Burns: subtle zoom from 1.0 → 1.08
  late Animation<double> _bgScale;
  late Animation<Alignment> _bgAlignment;

  @override
  void initState() {
    super.initState();

    // ── Entrance: 1.4s ───────────────────────────────────────────────────
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Header drops in from top (0% → 40%)
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    // Title rises (20% → 60%)
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOutCubic),
      ),
    );

    // Body text (35% → 72%)
    _bodyOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.72, curve: Curves.easeOut),
      ),
    );
    _bodySlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    // Footer dots + button (55% → 90%)
    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.90, curve: Curves.easeOut),
      ),
    );
    _footerSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    // ── Ken Burns: 12s slow pan ──────────────────────────────────────────
    _kenBurnsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );

    _bgScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut),
    );

    _bgAlignment = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut),
    );

    _entranceController.forward();
    _kenBurnsController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _kenBurnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: Stack(
        children: [
          // ── Background: Ken Burns ──────────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _kenBurnsController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bgScale.value,
                  alignment: _bgAlignment.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/bg-images/onboarding_1.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // ── Gradient overlay: bottom 45% ──────────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.40, 0.65, 1.0],
                  colors: [
                    Colors.transparent,
                    AppColors.backgroundObsidian.withOpacity(0.82),
                    AppColors.backgroundObsidian,
                  ],
                ),
              ),
            ),
          ),

          // ── UI Layer ──────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  SlideTransition(
                    position: _headerSlide,
                    child: FadeTransition(
                      opacity: _headerOpacity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Logo — shifted left to compensate for transparent padding in PNG
                            Transform.translate(
                              offset: const Offset(-12, 0),
                              child: Image.asset(
                                'assets/images/white_mountain_only.png',
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Skip — white text, clearly readable over bg image
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryTextOffWhite,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                minimumSize: const Size(40, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Skip',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primaryTextOffWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Title
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleOpacity,
                      child: Text(
                        'Welcome to Ulvenik',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.primaryTextOffWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Body
                  SlideTransition(
                    position: _bodySlide,
                    child: FadeTransition(
                      opacity: _bodyOpacity,
                      child: Text(
                        'Your complete training journey for every dog. Build your own training system, record every session and watch your progress grow over time — all in one place.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryTextOffWhite.withOpacity(0.85),
                          fontSize: 17,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Footer
                  SlideTransition(
                    position: _footerSlide,
                    child: FadeTransition(
                      opacity: _footerOpacity,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Progress dots
                            Row(
                              children: [
                                // Active — wide pill
                                Container(
                                  width: 32,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryForestGreen,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Inactive dot 1
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryTextStoneGrey.withOpacity(0.50),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Inactive dot 2
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryTextStoneGrey.withOpacity(0.50),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                              ],
                            ),

                            // Continue button
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryForestGreen,
                                foregroundColor: AppColors.primaryTextOffWhite,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Continue',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.primaryTextOffWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
