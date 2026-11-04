import 'package:flutter/material.dart';
import '../screens/homepage_screen.dart';
import '../screens/main_layout.dart';
import '../screens/more_page_screen.dart';
import '../screens/my_dogs_screen.dart';
import '../screens/timeline_screen.dart';
import '../screens/training_screen.dart';

enum UlvenikNavTab { home, dogs, training, timeline, more }

/// Canonical bottom navigation bar for post-Timeline-Insights screens.
/// Automatically hides itself if already hosted inside [MainLayout] so two
/// bottom navigation bars never stack on top of each other.
class UlvenikBottomNav extends StatelessWidget {
  final UlvenikNavTab activeTab;
  final WidgetBuilder? moreScreenBuilder;

  const UlvenikBottomNav({
    super.key,
    required this.activeTab,
    this.moreScreenBuilder,
  });

  static WidgetBuilder? globalMoreScreenBuilder;

  static const Color _bg = Color(0xFF101214);
  static const Color _border = Color(0x14FFFFFF);
  static const Color _mint = Color(0xFF95D3BB);
  static const Color _stoneGrey = Color(0xFFA7B0AB);

  @override
  Widget build(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<MainLayout>() != null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(
          top: BorderSide(color: _border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(
                context,
                tab: UlvenikNavTab.home,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                onTap: () => _navigateToTab(context, UlvenikNavTab.home),
              ),
              _buildItem(
                context,
                tab: UlvenikNavTab.dogs,
                icon: Icons.pets_outlined,
                activeIcon: Icons.pets,
                label: 'Dogs',
                onTap: () => _navigateToTab(context, UlvenikNavTab.dogs),
              ),
              _buildItem(
                context,
                tab: UlvenikNavTab.training,
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center,
                label: 'Training',
                onTap: () => _navigateToTab(context, UlvenikNavTab.training),
              ),
              _buildItem(
                context,
                tab: UlvenikNavTab.timeline,
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: 'Timeline',
                onTap: () => _navigateToTab(context, UlvenikNavTab.timeline),
              ),
              _buildItem(
                context,
                tab: UlvenikNavTab.more,
                icon: Icons.menu,
                activeIcon: Icons.menu,
                label: 'More',
                onTap: () => _navigateToTab(context, UlvenikNavTab.more),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTab(BuildContext context, UlvenikNavTab target) {
    final nav = Navigator.of(context);
    if (target == activeTab && nav.canPop()) {
      nav.popUntil((route) => route.isFirst);
      return;
    }

    Widget destination;
    switch (target) {
      case UlvenikNavTab.home:
        if (nav.canPop()) {
          nav.popUntil((route) => route.isFirst);
          return;
        }
        destination = const HomepageScreen();
        break;
      case UlvenikNavTab.dogs:
        destination = const MyDogsScreen();
        break;
      case UlvenikNavTab.training:
        destination = const TrainingScreen();
        break;
      case UlvenikNavTab.timeline:
        destination = const TimelineScreen();
        break;
      case UlvenikNavTab.more:
        final builder = moreScreenBuilder ?? globalMoreScreenBuilder;
        destination = builder != null ? builder(context) : const MorePageScreen();
        break;
    }

    nav.pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  Widget _buildItem(
    BuildContext context, {
    required UlvenikNavTab tab,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = activeTab == tab;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? _mint : _stoneGrey,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _mint : _stoneGrey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

