import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'homepage_screen.dart';
import 'my_dogs_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomepageScreen(key: ValueKey('home')),
    const MyDogsScreen(key: ValueKey('dogs')),
    const Center(child: Text('Training', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Timeline', style: TextStyle(color: Colors.white))),
    const Center(child: Text('More', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      // The AnimatedSwitcher gives us a sick page transition
      body: AnimatedSwitcher(
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
            child: SlideTransition(
              position: slideAnim,
              child: child,
            ),
          );
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: _buildAnimatedBottomNav(),
    );
  }

  Widget _buildAnimatedBottomNav() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF1d201f),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // 1. The Sliding Active Indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            left: _currentIndex * itemWidth,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: itemWidth,
              child: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryForestGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          
          // 2. The Icons (On top of indicator)
          Row(
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.pets_outlined, Icons.pets, 'Dogs'),
              _buildNavItem(2, Icons.fitness_center_outlined, Icons.fitness_center, 'Training'),
              _buildNavItem(3, Icons.event_note_outlined, Icons.event_note, 'Timeline'),
              _buildNavItem(4, Icons.more_horiz_outlined, Icons.more_horiz, 'More'),
            ],
          ),
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
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon changes state dynamically when active
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive ? activeIcon : inactiveIcon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            // Text color animates smoothly
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isActive ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.5,
              ),
              child: Text(label.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
