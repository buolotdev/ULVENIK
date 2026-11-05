import 'media_library_screen.dart';
import 'sport_pack_overview_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/ulvenik_icon.dart';
import '../theme/app_colors.dart';
import 'skills_list_screen.dart';
import 'goals_list_screen.dart';
import 'statistics_tab.dart';
import 'health_screen.dart';
import 'health_statistics_screen.dart';
import 'health_dashboard_screen.dart';
import 'strength_conditioning_dashboard_screen.dart';
import '../widgets/custom_snackbar.dart';

class DogProfileScreen extends StatefulWidget {
  const DogProfileScreen({super.key});

  @override
  State<DogProfileScreen> createState() => _DogProfileScreenState();
}

class _DogProfileScreenState extends State<DogProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _hasData = true;
  late TabController _tabController;

  static const List<String> _tabs = [
    'Overview', 'Training', 'S&C', 'Health', 'Sport', 'Media'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(innerBoxIsScrolled),
          SliverPersistentHeader(
            delegate: _StickyTabBarDelegate(
              tabBar: _buildTabBar(),
            ),
            pinned: true,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // 1. Overview
            _buildScrollableContent(
              _hasData ? _buildPopulatedContent() : _buildEmptyContent(),
            ),
            // 2. Training
            _buildTrainingTab(),
            // 3. S&C
            _buildStrengthConditioningTab(),
            // 4. Health
            _buildHealthTab(),
            // 5. Sport
            _buildSportTab(),
            // 6. Media
            _buildMediaTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.backgroundObsidian,
      leading: IconButton(
        icon: const UlvenikIcon(UlvenikIcons.back, color: AppColors.primaryTextOffWhite),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const UlvenikIcon(UlvenikIcons.overflowMenu, color: AppColors.primaryTextOffWhite),
          onPressed: () => setState(() => _hasData = !_hasData), // Toggle for testing
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _hasData 
                  ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuAoyue5jFzmfxthjXdPTLM6CUuhur9c5zgik6YNEpRzZoNQa-Lwr8y0HFqBWqmTRxpHogf6mwBqI-YSWdTL5wDKdC9RVJljRkvjG8nqf34L_qKnwyblEmp_vj5iiXeZoN8GWpxAhVV5IY1uh4oYI1Tli94t7awjHXHHycimP_eRdyJSkbEG-WNQwxnPCclemEbYEjiiSGmY0AqM78qpWcSRIjJOdpTbuJjda2XcCU3tLHSvf2R3m4s'
                  : 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?q=80&w=600&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.backgroundObsidian,
                    AppColors.backgroundObsidian.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _hasData ? 'Koda' : 'Nova',
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _hasData ? 'Belgian Malinois · 3 years' : 'German Shepherd · 1 year',
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                  if (_hasData) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildStatBadge(Icons.analytics_outlined, '128 SESSIONS'),
                        const SizedBox(width: 8),
                        _buildStatBadge(Icons.timer_outlined, '42 HRS'),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsListScreen())),
                          child: _buildClickableBadge(Icons.flag_outlined, '5 GOALS'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UlvenikIcon.fromMaterial(icon, size: 14, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2e6b57).withValues(alpha: 0.2), // primary-container / 20
        border: Border.all(color: const Color(0xFF2e6b57)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UlvenikIcon.fromMaterial(icon, size: 12, color: const Color(0xFF95d3bb)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF95d3bb),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          const SizedBox(width: 2),
          const UlvenikIcon(UlvenikIcons.details, size: 14, color: Color(0xFF95d3bb)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.cardsCarbon,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        indicatorColor: AppColors.primaryForestGreen,
        indicatorWeight: 2,
        labelColor: AppColors.primaryTextOffWhite,
        unselectedLabelColor: AppColors.secondaryTextStoneGrey,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        dividerColor: Colors.white12,
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildSkillsTile() {
    final name = _hasData ? 'Koda' : 'Nova';
    final breed = _hasData ? 'Belgian Malinois' : 'German Shepherd';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SkillsListScreen(
                dogName: name, breed: breed, hasData: _hasData),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const UlvenikIcon(UlvenikIcons.skills,
                    size: 20, color: AppColors.primaryForestGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Skills and Exercises',
                        style: TextStyle(
                            color: AppColors.primaryTextOffWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                        _hasData ? '6 skills · 21 exercises' : 'No skills yet',
                        style: const TextStyle(
                            color: AppColors.secondaryTextStoneGrey,
                            fontSize: 12)),
                  ],
                ),
              ),
              const UlvenikIcon(UlvenikIcons.details,
                  color: AppColors.secondaryTextStoneGrey),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmptyContent() {
    return [
      _buildSkillsTile(),
      const SizedBox(height: 12),
      _buildEmptyCard(
        icon: Icons.fitness_center,
        title: 'No Training Sessions Recorded',
        primaryButtonLabel: 'Record Training Session',
      ),
      const SizedBox(height: 12),
      _buildEmptyCard(
        icon: Icons.fitness_center_outlined,
        title: 'No S&C Sessions Recorded',
        primaryButtonLabel: 'Record S&C Session',
      ),
      const SizedBox(height: 12),
      _buildEmptyCard(
        icon: Icons.calendar_today_outlined,
        title: 'No Upcoming Activities',
        primaryButtonLabel: 'Create Reminder',
        secondaryButtonLabel: 'Schedule Session',
        isRowButtons: true,
      ),
    ];
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String primaryButtonLabel,
    String? secondaryButtonLabel,
    bool isRowButtons = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          UlvenikIcon.fromMaterial(icon, size: 28, color: AppColors.secondarySage),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          if (isRowButtons && secondaryButtonLabel != null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: const BorderSide(color: Colors.white12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(primaryButtonLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTextOffWhite,
                      side: const BorderSide(color: Colors.white12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(secondaryButtonLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => AppSnackbar.show(context, message: 'Coming soon', type: SnackbarType.info),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForestGreen,
                  foregroundColor: AppColors.primaryTextOffWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(primaryButtonLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPopulatedContent() {
    return [
      _buildSkillsTile(),
      const SizedBox(height: 24),
      // TODAY'S FOCUS
      const Text(
        "TODAY'S FOCUS",
        style: TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildFocusRow(Icons.medical_services_outlined, 'Metacam', '08:00 AM · Due Today', 'Log', AppColors.errorDestructive),
            const Divider(color: Colors.white12, height: 1),
            _buildFocusRow(Icons.fitness_center_outlined, 'Recall Foundation', 'Due Today · 15m Drill', 'Start', AppColors.primaryForestGreen),
            const Divider(color: Colors.white12, height: 1),
            _buildFocusRow(Icons.water_drop_outlined, 'Evening Conditioning', '06:00 PM · Due Today', 'Log', const Color(0xFF5D8FAF)),
          ],
        ),
      ),
      
      const SizedBox(height: 24),
      
      // CONTINUE
      const Text(
        "CONTINUE",
        style: TextStyle(
          color: AppColors.secondaryTextStoneGrey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryForestGreen),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DRAFT',
                          style: TextStyle(
                            color: AppColors.primaryForestGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Draft Training Session',
                        style: TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Started today at 09:42',
                    style: TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF323533), // surface-variant
                shape: BoxShape.circle,
              ),
              child: const UlvenikIcon(UlvenikIcons.play, size: 18, color: AppColors.primaryTextOffWhite),
            ),
          ],
        ),
      ),
      
      const SizedBox(height: 24),

      // UPCOMING
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "UPCOMING",
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
          Row(
            children: const [
              Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primaryForestGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              UlvenikIcon(UlvenikIcons.details, size: 14, color: AppColors.primaryForestGreen),
            ],
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildUpcomingRow('24', 'OCT', Icons.medical_services_outlined, 'Annual Booster'),
            const Divider(color: Colors.white12, height: 1),
            _buildUpcomingRow('26', 'OCT', Icons.fitness_center_outlined, 'Agility Class'),
            const Divider(color: Colors.white12, height: 1),
            _buildUpcomingRow('02', 'NOV', Icons.emoji_events_outlined, 'Regional Trial'),
          ],
        ),
      ),
      const SizedBox(height: 40),
    ];
  }

  Widget _buildFocusRow(IconData icon, String title, String subtitle, String actionLabel, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          UlvenikIcon.fromMaterial(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            actionLabel,
            style: const TextStyle(
              color: AppColors.primaryForestGreen,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingRow(String day, String month, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: AppColors.primaryTextOffWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.05,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colors.white12,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          UlvenikIcon.fromMaterial(icon, size: 16, color: AppColors.secondaryTextStoneGrey),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSkillsTile(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Training Drills', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    UlvenikIcon(UlvenikIcons.exercises, size: 20, color: AppColors.primaryForestGreen),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Logged 128 sessions · 94% criteria pass rate', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => AppSnackbar.show(context, message: 'Record Training Session coming soon', type: SnackbarType.info),
                  icon: const UlvenikIcon(UlvenikIcons.add, size: 18),
                  label: const Text('Record Training Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          StatisticsTab(hasData: _hasData),
        ],
      ),
    );
  }

  Widget _buildStrengthConditioningTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Strength & Conditioning', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    Icon(Icons.water, size: 20, color: Color(0xFF5D8FAF)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Track physical load, intensity, sprints and endurance volume.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const UlvenikIcon(UlvenikIcons.exercises, size: 18),
                        label: const Text('Open S&C Dashboard'),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StrengthConditioningDashboardScreen())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E6B57),
                          foregroundColor: AppColors.primaryTextOffWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const UlvenikIcon(UlvenikIcons.add, size: 18, color: Color(0xFF95D3BB)),
                        label: const Text('Record S&C', style: TextStyle(color: Color(0xFF95D3BB))),
                        onPressed: () => AppSnackbar.show(context, message: 'Record S&C Session coming soon', type: SnackbarType.info),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF95D3BB)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Health Overview', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    UlvenikIcon(UlvenikIcons.health, size: 22, color: Color(0xFF95D3BB)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Medical history, vaccinations, veterinary logs and reminders.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthDashboardScreen())),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E6B57), foregroundColor: AppColors.primaryTextOffWhite),
                      child: const Text('Open Health Dashboard'),
                    ),
                    OutlinedButton.icon(
                      icon: const UlvenikIcon(UlvenikIcons.health, size: 18, color: Color(0xFF95D3BB)),
                      label: const Text('Health Categories', style: TextStyle(color: Color(0xFF95D3BB))),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthScreen())),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF95D3BB))),
                    ),
                    OutlinedButton.icon(
                      icon: const UlvenikIcon(UlvenikIcons.progress, size: 18, color: Color(0xFF95D3BB)),
                      label: const Text('Health Stats', style: TextStyle(color: Color(0xFF95D3BB))),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthStatisticsScreen())),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF95D3BB))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Sport Pack · Competitions & Trials', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    Icon(Icons.emoji_events_outlined, size: 22, color: AppColors.secondarySage),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('IGP, IPO, Agility, Schutzhund trial scores and performance logs.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SportPackOverviewScreen())),
                  icon: const Icon(Icons.military_tech_outlined, size: 18),
                  label: const Text('Open Sport Pack Overview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Media & Highlights', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                    Icon(Icons.photo_library_outlined, size: 22, color: Color(0xFF95D3BB)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Photos, slow-motion clips and training session videos.', style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MediaLibraryScreen())),
                  icon: const Icon(Icons.photo_camera_back_outlined, size: 18),
                  label: const Text('Open Dog Media Library'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryForestGreen,
                    foregroundColor: AppColors.primaryTextOffWhite,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;

  const _StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
