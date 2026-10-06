import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';
import 'training_screen.dart';
import 'timeline_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Training tab has its own navigator so pushed screens (e.g. Training
  // Session) keep the bottom nav visible with Training active.
  final GlobalKey<NavigatorState> _trainingNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _dogsNavKey = GlobalKey<NavigatorState>();

  late final List<Widget> _screens = [
    const HomepageScreen(key: ValueKey('home')),
    Navigator(
      key: _dogsNavKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const MyDogsScreen(key: ValueKey('dogs')),
      ),
    ),
    Navigator(
      key: _trainingNavKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const TrainingScreen(key: ValueKey('training')),
      ),
    ),
    const TimelineScreen(key: ValueKey('timeline')),
    const Center(child: Text('More', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    // Make status bar icons light on all screens
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Main content ──────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slideAnim = Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(animation);
              final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                opacity: fadeAnim,
                child: SlideTransition(position: slideAnim, child: child),
              );
            },
            child: _screens[_currentIndex],
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPadding + 48,
            child: IgnorePointer(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.backgroundObsidian,
                          AppColors.backgroundObsidian.withOpacity(0.8),
                          AppColors.backgroundObsidian.withOpacity(0.3),
                          AppColors.backgroundObsidian.withOpacity(0.0), // Fixes color banding
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildAnimatedBottomNav(),
    );
  }

  Widget _buildAnimatedBottomNav() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // Respect home indicator on iPhone / gesture bar on Android
      height: 64 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: const BoxDecoration(
        color: Color(0xFF0c0f0d), // surface-container-lowest
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
          _buildNavItem(1, Icons.pets_outlined, Icons.pets, 'Dogs'),
          _buildNavItem(2, Icons.fitness_center_outlined, Icons.fitness_center, 'Training'),
          _buildNavItem(3, Icons.event_note_outlined, Icons.event_note, 'Timeline'),
          _buildNavItem(4, Icons.more_horiz_outlined, Icons.more_horiz, 'More'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_currentIndex != index) {
            setState(() => _currentIndex = index);
          } else if (index == 2) {
            // Re-tapping the active Training tab returns to its root
            _trainingNavKey.currentState?.popUntil((r) => r.isFirst);
          } else if (index == 1) {
            _dogsNavKey.currentState?.popUntil((r) => r.isFirst);
          }
        },
        // Full-height container so the green bg fills the entire button
        child: Container(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryForestGreen.withOpacity(0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive
                        ? AppColors.primaryForestGreen
                        : AppColors.secondaryTextStoneGrey,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    color: isActive
                        ? AppColors.primaryForestGreen
                        : AppColors.secondaryTextStoneGrey,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                  child: Text(label.toUpperCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
