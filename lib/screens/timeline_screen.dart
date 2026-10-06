import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  List<String>? _activeFilters;

  @override
  void initState() {
    super.initState();
    _activeFilters = ['Training', '2026'];
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(topPadding),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyFiltersDelegate(
              hasFilters: _activeFilters?.isNotEmpty ?? false,
              child: _buildStickyFilters(),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildTimelineContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(double topPadding) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: AppColors.backgroundObsidian,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryTextOffWhite),
        onPressed: () {}, // Can be wired up if pushed, but inside tab bar usually no-op or pops stack
      ),
      title: const Text('ULVENIK', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.primaryTextOffWhite),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.cardsCarbon),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundObsidian.withOpacity(0.8),
                    AppColors.backgroundObsidian.withOpacity(0.4),
                    AppColors.backgroundObsidian.withOpacity(0.8),
                    AppColors.backgroundObsidian,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TIMELINE', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  const Text('Arlo', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 40, fontWeight: FontWeight.bold, height: 1.0)),
                  const SizedBox(height: 8),
                  const Text('German Shepherd · 3 yrs  |  Born 14 March 2023', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 14)),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatChip(Icons.schedule, '126 Sessions', const Color(0xFF95d3bb)),
                        const SizedBox(width: 8),
                        _buildStatChip(Icons.emoji_events, '4 Goals', const Color(0xFF9B6B3D)),
                        const SizedBox(width: 8),
                        _buildStatChip(Icons.favorite, '18 Health', const Color(0xFF8B3A3A)),
                        const SizedBox(width: 8),
                        _buildStatChip(Icons.photo_camera, '94 Media', const Color(0xFF5D8FAF)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStickyFilters() {
    return Container(
      color: AppColors.cardsCarbon.withOpacity(0.95),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconTextAction(Icons.search, 'Search'),
                  const SizedBox(width: 16),
                  _buildIconTextAction(Icons.filter_list, 'Filter'),
                  const SizedBox(width: 16),
                  _buildIconTextAction(Icons.swap_vert, 'Jump To'),
                ],
              ),
              const Text('Today', style: TextStyle(color: Color(0xFF95d3bb), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          if (_activeFilters != null && _activeFilters!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: _activeFilters!.map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildActiveFilter(f, f == 'Training'),
              )).toList(),
            ),
          ],
          const Divider(color: Colors.white12, height: 16, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildIconTextAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.secondaryTextStoneGrey),
        if (label != 'Search') const SizedBox(width: 4),
        if (label != 'Search') Text(label, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActiveFilter(String label, bool isPrimary) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilters?.remove(label);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF2e6b57).withOpacity(0.2) : const Color(0xFF323533),
          border: Border.all(color: isPrimary ? const Color(0xFF95d3bb).withOpacity(0.3) : Colors.white12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(color: isPrimary ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey, fontSize: 12)),
            const SizedBox(width: 4),
            Icon(Icons.close, size: 14, color: isPrimary ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final nodeWidth = (screenWidth - 40 - 32 - 24) / 2; // screen - padding - center icon - margin

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        children: [
          _buildSeasonDivider('SUMMER 2026'),
          const SizedBox(height: 32),
          _buildTimelineNodeLeft(
            nodeWidth: nodeWidth,
            icon: Icons.fitness_center,
            iconColor: const Color(0xFF95d3bb),
            date: '14 Aug 2026 · 1hr 45min',
            title: 'Morning Obedience',
            subtitle: 'Park Field',
            tags: ['Heel Work', 'Recall'],
          ),
          const SizedBox(height: 32),
          _buildTimelineNodeRight(
            nodeWidth: nodeWidth,
            icon: Icons.favorite,
            iconColor: const Color(0xFF95d3bb),
            date: '2 Jun 2026',
            title: 'Annual Vaccination',
            subtitle: 'Rabies, DHPP booster',
          ),
          const SizedBox(height: 48),
          _buildTimelineNodeFull(
            icon: Icons.emoji_events,
            iconColor: const Color(0xFF9B6B3D),
            date: 'GOAL ACHIEVED',
            title: 'Sit Stay 5 Minutes',
            subtitle: 'Achieved after 67 days · 42 Sessions',
          ),
          const SizedBox(height: 48),
          _buildTimelineNodeLeft(
            nodeWidth: nodeWidth,
            icon: Icons.monitor_weight,
            iconColor: const Color(0xFF95d3bb),
            date: '28 May 2026',
            title: 'Weight Check',
            subtitle: '30.2 kg · ▲ 0.8 kg',
          ),
          const SizedBox(height: 48),
          _buildYearDivider('2026'),
          const SizedBox(height: 100), // padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildSeasonDivider(String text) {
    return Container(
      color: AppColors.backgroundObsidian,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2),
      ),
    );
  }

  Widget _buildYearDivider(String year) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(height: 1, width: 40, color: const Color(0xFF95d3bb).withOpacity(0.3)),
        Container(
          color: AppColors.backgroundObsidian,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(year, style: const TextStyle(color: Color(0xFF95d3bb), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
        ),
        Container(height: 1, width: 40, color: const Color(0xFF95d3bb).withOpacity(0.3)),
      ],
    );
  }

  Widget _buildTimelineNodeLeft({
    required double nodeWidth,
    required IconData icon,
    required Color iconColor,
    required String date,
    required String title,
    required String subtitle,
    String? imagePath,
    List<String>? tags,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: nodeWidth,
          margin: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (imagePath != null)
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: AppColors.cardsCarbon),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.cardsCarbon, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(date, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != 'Weight Check') const Icon(Icons.location_on, size: 12, color: AppColors.secondaryTextStoneGrey),
                          if (title != 'Weight Check') const SizedBox(width: 4),
                          Text(subtitle, style: TextStyle(color: title == 'Weight Check' ? const Color(0xFF95d3bb) : AppColors.secondaryTextStoneGrey, fontSize: 12, fontWeight: title == 'Weight Check' ? FontWeight.w500 : FontWeight.normal)),
                        ],
                      ),
                      if (tags != null) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          children: tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(border: Border.all(color: Colors.white12), borderRadius: BorderRadius.circular(4)),
                            child: Text(tag, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 10)),
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
          ),
        ),
        _buildNodeCenter(icon, iconColor),
        SizedBox(width: nodeWidth + 24), // Right side empty
      ],
    );
  }

  Widget _buildTimelineNodeRight({
    required double nodeWidth,
    required IconData icon,
    required Color iconColor,
    required String date,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: nodeWidth + 24), // Left side empty
        _buildNodeCenter(icon, iconColor),
        Container(
          width: nodeWidth,
          margin: const EdgeInsets.only(left: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineNodeFull({
    required IconData icon,
    required Color iconColor,
    required String date,
    required String title,
    required String subtitle,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            border: Border.all(color: iconColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(height: 2, color: iconColor.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(date, style: TextStyle(color: iconColor, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 12)),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              border: Border.all(color: iconColor),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ),
      ],
    );
  }

  Widget _buildNodeCenter(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: color),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

class _StickyFiltersDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool hasFilters;

  _StickyFiltersDelegate({required this.child, required this.hasFilters});

  @override
  double get minExtent => hasFilters ? 104.0 : 64.0;
  @override
  double get maxExtent => hasFilters ? 104.0 : 64.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyFiltersDelegate oldDelegate) {
    return oldDelegate.hasFilters != hasFilters;
  }
}
