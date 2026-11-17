import 'package:flutter/material.dart';
import '../widgets/ulvenik_logo.dart';
import '../theme/app_colors.dart';
import 'welcome_screen.dart';

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

/// Three-step introduction (client review 13 Nov 2026).
///
/// One consistent layout: photo on top with a strong dark gradient, a stable
/// lower content area (heading and paragraph always start at the same
/// height), a full-width primary action, then centred step indicators.
/// Skip (steps 1-2) and Get started (step 3) both lead to account entry.
///
/// The background photographs are still the original placeholders; the
/// client is supplying approved dog/training photography.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const List<OnboardingData> pages = [
    OnboardingData(
      title: 'Welcome to Ulvenik',
      body: "Keep your dog's training, records and progress together in one place.",
      bgImage: 'assets/bg-images/onboarding_1.png',
    ),
    OnboardingData(
      title: 'Train your way',
      body: 'Create your own skills, exercises, rewards and equipment to suit you and your dog.',
      bgImage: 'assets/bg-images/onboarding_2.png',
    ),
    OnboardingData(
      title: 'Record the work. See the progress.',
      body:
          "Bring sessions, health records, notes and media together to review your dog's progress over time.",
      bgImage: 'assets/bg-images/onboarding_3.png',
    ),
  ];

  final PageController _pageController = PageController();
  double _pageValue = 0.0;
  late final AnimationController _fadeIn;

  int get _page => _pageValue.round();
  bool get _isLast => _page == pages.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _pageValue = _pageController.page ?? 0.0);
    });
    _fadeIn = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeIn.dispose();
    super.dispose();
  }

  void _goToAccountEntry() {
    // push (not replace) so Back returns to the step the user was on.
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _onPrimary() {
    if (_isLast) {
      _goToAccountEntry();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Stack(
          children: [
            // Background photos cross-fade with the swipe; fixed crop, no panning.
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  for (var i = 0; i < pages.length; i++)
                    if ((_pageValue - i).abs() < 1)
                      Opacity(
                        opacity: 1 - (_pageValue - i).abs().clamp(0.0, 1.0),
                        child: Image.asset(
                          pages[i].bgImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, _, _) =>
                              ColoredBox(color: const Color(0xFF121212)),
                        ),
                      ),
                ],
              ),
            ),

            // Strong dark bottom gradient for reliable text contrast.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.18, 0.38, 0.55, 0.70, 1.0],
                    colors: [
                      Color(0x99121212),
                      Color(0x1A121212),
                      Color(0x33121212),
                      Color(0xD9121212),
                      Color(0xFA121212),
                      const Color(0xFF121212),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header: logo + Skip (Skip hidden on the last step).
                    SizedBox(
                      height: 56,
                      child: Row(
                        children: [
                          const UlvenikLogo.full(width: 96, forceLight: true),
                          const Spacer(),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _isLast ? 0 : 1,
                            child: IgnorePointer(
                              ignoring: _isLast,
                              child: TextButton(
                                onPressed: _goToAccountEntry,
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFF5F6F2),
                                  minimumSize: const Size(48, 44),
                                ),
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Stable lower content area: heading/paragraph positions
                    // match across steps; shorter copy leaves more space.
                    SizedBox(
                      height: _contentHeight(context),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: pages.length,
                        itemBuilder: (context, i) => SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pages[i].title,
                                style: TextStyle(
                                  color: const Color(0xFFF5F6F2),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                pages[i].body,
                                style: TextStyle(
                                  color: const Color(0xFFF5F6F2).withValues(alpha: 0.85),
                                  fontSize: 16,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Full-width primary action.
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _onPrimary,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryForestGreen,
                          foregroundColor: const Color(0xFFF5F6F2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          _isLast ? 'Get started' : 'Continue',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Centred step indicators beneath the action.
                    Semantics(
                      label: 'Step ${_page + 1} of ${pages.length}',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < pages.length; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _page == i ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _page == i
                                    ? AppColors.primaryForestGreen
                                    : const Color(0xFFA7B0AB).withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fixed text area height so content doesn't jump between steps; grows
  /// with the user's text scale and stays scrollable on short screens.
  double _contentHeight(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final screenH = MediaQuery.sizeOf(context).height;
    return (190 * scale).clamp(150.0, screenH * 0.42);
  }
}
