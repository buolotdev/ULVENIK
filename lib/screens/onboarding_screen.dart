import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OnboardingData {
  final String title;
  final String body;
  final String bgImage;

  const OnboardingData({
    required this.title,
    required this.body,
    required this.bgImage,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final List<OnboardingData> _pages = const [
    OnboardingData(
      title: 'Welcome to Ulvenik',
      body:
          'Your complete training journey for every dog. Build your own training system, record every session and watch your progress grow over time — all in one place.',
      bgImage: 'assets/bg-images/onboarding_1.png',
    ),
    OnboardingData(
      title: 'Train Your Way',
      body:
          'Every dog is different. Every handler is different. That\'s why Ulvenik never forces predefined Skills, Exercises, Sports, Rewards or Equipment. Instead, you build your own training system, allowing Ulvenik to adapt to the way you already train.',
      bgImage: 'assets/bg-images/onboarding_2.png',
    ),
    OnboardingData(
      title: 'Every Session Builds Your Journey',
      body: 'Record your Training, Strength & Conditioning and Competitions alongside videos, notes, rewards, equipment and progress. Ulvenik automatically connects everything together, building a complete history of your journey over time.',
      bgImage: 'assets/bg-images/onboarding_3.png',
    ),
  ];

  late PageController _pageController;
  double _currentPageValue = 0.0;

  // Master entrance sequence
  late AnimationController _entranceController;
  // Ken Burns: slow pan + zoom on background
  late AnimationController _kenBurnsController;

  // Header: logo + skip drop in from top
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;

  // PageView (Title + Body): rises from below
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  // Footer: dots + button
  late Animation<double> _footerOpacity;
  late Animation<Offset> _footerSlide;

  // Ken Burns: subtle zoom from 1.0 → 1.08
  late Animation<double> _bgScale;
  late Animation<Alignment> _bgAlignment;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _currentPageValue = _pageController.page ?? 0.0;
        });
      });

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

    // Content rises (20% → 60%)
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOut),
      ),
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.60, curve: Curves.easeOutCubic),
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
    _pageController.dispose();
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
          // ── Background: Crossfading Images with Ken Burns ────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _kenBurnsController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bgScale.value,
                  alignment: _bgAlignment.value,
                  child: Stack(
                    fit: StackFit.expand,
                    children: List.generate(_pages.length, (index) {
                      // Calculate opacity based on scroll position
                      // e.g. if _currentPageValue is 1.2, index 1 opacity is 0.8, index 2 opacity is 0.2
                      double diff = (_currentPageValue - index).abs();
                      double opacity = 1.0 - diff.clamp(0.0, 1.0);

                      return opacity > 0.0
                          ? Opacity(
                              opacity: opacity,
                              child: Image.asset(
                                _pages[index].bgImage,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                // Error builder prevents crash if image doesn't exist yet
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: AppColors.backgroundObsidian),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                  ),
                );
              },
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
                            // Skip
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

                  // Expandable PageView for text content
                  Expanded(
                    child: SlideTransition(
                      position: _contentSlide,
                      child: FadeTransition(
                        opacity: _contentOpacity,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 60), // Push down to bottom area
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _pages[index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: AppColors.primaryTextOffWhite,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32,
                                          height: 1.25,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _pages[index].body,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppColors.primaryTextOffWhite
                                              .withOpacity(0.85),
                                          fontSize: 17,
                                          height: 1.7,
                                        ),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

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
                            // Animated Progress dots
                            Row(
                              children: List.generate(
                                _pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.only(right: 8),
                                  width: _currentPageValue.round() == index
                                      ? 32
                                      : 6,
                                  height: _currentPageValue.round() == index
                                      ? 8
                                      : 6,
                                  decoration: BoxDecoration(
                                    color: _currentPageValue.round() == index
                                        ? AppColors.primaryForestGreen
                                        : AppColors.secondaryTextStoneGrey
                                            .withOpacity(0.50),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                              ),
                            ),

                            // Continue button
                            ElevatedButton(
                              onPressed: () {
                                int currentPage = _currentPageValue.round();
                                if (currentPage < _pages.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeOutCubic,
                                  );
                                } else {
                                  // Finish onboarding
                                }
                              },
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
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
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
