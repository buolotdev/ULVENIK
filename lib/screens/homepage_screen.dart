import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import 'my_dogs_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  // Toggle this to test Empty vs Populated states!
  bool _hasData = false;
  
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundObsidian,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  
                  _hasData ? _buildPopulatedQuickActions() : _buildEmptyQuickActions(),
                  const SizedBox(height: 32),
                  
                  if (_hasData) ...[
                    _buildTodaySection(),
                    const SizedBox(height: 32),
                    _buildInsightsSection(),
                    const SizedBox(height: 32),
                    _buildUpcomingSection(),
                    const SizedBox(height: 32),
                    _buildRecentActivitySection(),
                    const SizedBox(height: 48), // Bottom padding for nav
                  ] else ...[
                    _buildEmptyCardSection(
                      title: 'Today',
                      icon: Icons.calendar_today,
                      message: 'Nothing planned for today',
                      submessage: 'Rest days are essential for performance.',
                    ),
                    const SizedBox(height: 32),
                    _buildEmptyCardSection(
                      title: 'Upcoming',
                      icon: Icons.calendar_month_outlined,
                      message: 'Nothing coming up',
                      actionIcon: Icons.add,
                    ),
                    const SizedBox(height: 32),
                    _buildEmptyCardSection(
                      title: 'Recent Activity',
                      icon: Icons.schedule,
                      message: 'No recent activity',
                    ),
                    const SizedBox(height: 32),
                    _buildEmptyCardSection(
                      title: 'Insights',
                      icon: Icons.bar_chart,
                      message: 'No insights yet',
                    ),
                    const SizedBox(height: 48),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    if (_hasData) {
      return SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDNtNABLaSeR2qYP4zwtAeqqo4tGmNRGsQJ556uoL5C5GNDLp5hmSZnapC-Ni_WhJeEWIwxajKjv4yj52D7bNx3mHeu7ifDPvuzdpsInQ5YMlDcpdIOgQznNND3vx_-hbn0YrwsbiGh8WXNydzq-Jb1LjFS5uCltfjpnXpLJz8D1C3QUJgoTD9Gy85cUdoBWxkwaPhvikcOBGe3nyAvI44PHs7tR7yKsa9Z8UK8CL-UjYFHOceYcgc',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.cardsCarbon),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    AppColors.backgroundObsidian.withOpacity(0.7),
                    AppColors.backgroundObsidian,
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: _buildTopNavRow(),
              ),
            ),
          ],
        ),
      );
    } else {
      // Empty state header has no background image
      return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: _buildTopNavRow(),
        ),
      );
    }
  }

  Widget _buildTopNavRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'K9 PERFORMANCE',
          style: TextStyle(
            color: AppColors.primaryTextOffWhite,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
            image: const DecorationImage(
              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuD4XSejQUHf1-s3MYW2YqYXrjFCx2LYekQ4vFR8MRGbSF3am8MU2uIBF7ohnNi6JarHsuoY-QMmC65_BE2MTBpXriJdA7NkIFF2oaoqFyrRc8waL4kGu3tbT7bmHb2sBEvhFmx5_zw2GxEHA9wxiDXwIsbcVroQjJT3hH0L0rV3xJqwZ29HL3VEdqzXNc5Tosf1801n3IOEvUCamy_Zs2eOZKernmL8lmVPlrQhHhxwEuBid0iVbtY'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  // ── Welcome Text ────────────────────────────────────────────────────────
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () => setState(() => _hasData = !_hasData),
          child: Text(
            _hasData ? 'THE JOURNEY BUILDS THE WOLF.' : 'Tuesday, Oct 24',
            style: TextStyle(
              color: _hasData ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: _hasData ? 1.5 : 0.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _hasData ? 'Welcome back, James.' : 'Ready to work.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.primaryTextOffWhite,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        if (_hasData) ...[
          const SizedBox(height: 4),
          const Text(
            'Every session builds the journey.',
            style: TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 14,
            ),
          ),
        ]
      ],
    );
  }

  // ── Quick Actions ───────────────────────────────────────────────────────
  Widget _buildPopulatedQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildPopulatedActionCard(
            title: 'Start Training',
            subtitle: 'Log field work',
            icon: Icons.fitness_center,
            iconColor: AppColors.primaryForestGreen,
            onTap: () {
              AppSnackbar.show(context, message: 'Start Training coming soon', type: SnackbarType.info);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPopulatedActionCard(
            title: 'Start S&C',
            subtitle: 'Log conditioning',
            icon: Icons.water,
            iconColor: const Color(0xFF5D8FAF), // Alpine blue
            onTap: () {
              AppSnackbar.show(context, message: 'Start S&C coming soon', type: SnackbarType.info);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopulatedActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withOpacity(0.3)),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
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
    );
  }

  Widget _buildEmptyQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildEmptyActionCard(
            title: 'Start Session',
            icon: Icons.play_arrow_outlined,
            onTap: () {
              AppSnackbar.show(context, message: 'Start Session coming soon', type: SnackbarType.info);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildEmptyActionCard(
            title: 'Log Activity',
            icon: Icons.add,
            onTap: () {
              AppSnackbar.show(context, message: 'Log Activity coming soon', type: SnackbarType.info);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardsCarbon,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryForestGreen, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryTextOffWhite,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty Card Section Builder ──────────────────────────────────────────
  Widget _buildEmptyCardSection({
    required String title,
    required IconData icon,
    required String message,
    String? submessage,
    IconData? actionIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(title, actionIcon: actionIcon),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardsCarbon,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.secondarySage, size: 32),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (submessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  submessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, {String? actionLabel, IconData? actionIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryTextOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (actionLabel != null)
            Text(
              actionLabel,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          if (actionIcon != null)
            Icon(
              actionIcon,
              color: AppColors.primaryForestGreen,
              size: 20,
            ),
        ],
      ),
    );
  }

  // ── Today Section ───────────────────────────────────────────────────────
  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Today'),
        _buildTodayCard(
          title: 'Heartworm Preventative',
          time: '08:00 AM',
          dog: 'Murphy',
          note: 'Administer with morning meal.',
          icon: Icons.medication,
          color: const Color(0xFFffb4ab), // Error red
        ),
        const SizedBox(height: 8),
        _buildTodayCard(
          title: 'Annual Checkup',
          time: '02:30 PM',
          dog: 'Atlas',
          note: 'Dr. Stevens - Bring vaccination records.',
          icon: Icons.local_hospital,
          color: const Color(0xFF5D8FAF), // Alpine Blue
        ),
        const SizedBox(height: 8),
        _buildTodayCard(
          title: 'Agility Trial Prep',
          time: '06:00 PM',
          dog: 'Murphy',
          note: 'Focus on weave poles and A-frame contact.',
          icon: Icons.emoji_events,
          color: AppColors.primaryForestGreen, // Primary
        ),
      ],
    );
  }

  Widget _buildTodayCard({
    required String title,
    required String time,
    required String dog,
    required String note,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Border Line
            Container(width: 2, color: color),
            const SizedBox(width: 14),
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.primaryTextOffWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.secondaryTextStoneGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dog,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite, // on-surface-variant
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: const TextStyle(
                      color: AppColors.secondaryTextStoneGrey,
                      fontSize: 11,
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

  // ── Insights Section ────────────────────────────────────────────────────
  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Insights', actionLabel: 'FULL STATS'),
        
        // Pill Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              _buildPillTab('Core', isActive: true),
              const SizedBox(width: 8),
              _buildPillTab('Sport', isActive: false),
              const SizedBox(width: 8),
              _buildPillTab('Trainer', isActive: false),
            ],
          ),
        ),
        
        // Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.8,
          children: [
            _buildStatCard('This Week', '12', suffix: 'sessions'),
            _buildStatCard('Streak', '18', suffix: 'days'),
            _buildStatCard('Most Trained', 'Murphy', isText: true),
            _buildStatCard('Total Hours', '146'),
          ],
        ),
      ],
    );
  }

  Widget _buildPillTab(String label, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryForestGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.primaryForestGreen : Colors.white12,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primaryTextOffWhite : AppColors.secondaryTextStoneGrey,
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, {String? suffix, bool isText = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryTextStoneGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: isText ? 15 : 24,
                  fontWeight: isText ? FontWeight.w600 : FontWeight.w700,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 4),
                Text(
                  suffix,
                  style: const TextStyle(
                    color: AppColors.secondaryTextStoneGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ── Upcoming Section ────────────────────────────────────────────────────
  Widget _buildUpcomingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Upcoming', actionLabel: 'VIEW ALL'),
        _buildUpcomingRow('Regional Championship', 'Competition • Atlas', 'Tomorrow', isPrimary: true),
        const SizedBox(height: 8),
        _buildUpcomingRow('Follow-up Exam', 'Vet • Murphy', 'In 2 Days'),
        const SizedBox(height: 8),
        _buildUpcomingRow('Advanced Tracking', 'Lesson • Atlas', 'In 4 Days'),
      ],
    );
  }

  Widget _buildUpcomingRow(String title, String subtitle, String dateStr, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardsCarbon,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryTextOffWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.secondaryTextStoneGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            dateStr,
            style: TextStyle(
              color: isPrimary ? AppColors.primaryForestGreen : AppColors.secondaryTextStoneGrey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Recent Activity Section ─────────────────────────────────────────────
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Recent Activity', actionLabel: 'VIEW TIMELINE'),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.white12)),
            ),
            padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
            child: Column(
              children: [
                _buildTimelineItem(
                  title: 'Obedience Field Work',
                  subtitle: 'Murphy • 45m • Excellent Focus',
                  time: '2h ago',
                  icon: Icons.fitness_center,
                  iconColor: AppColors.primaryForestGreen,
                ),
                const SizedBox(height: 32),
                _buildTimelineItem(
                  title: 'Lake Conditioning',
                  subtitle: 'Atlas • 30m • Intervals',
                  time: 'Yesterday',
                  icon: Icons.water,
                  iconColor: const Color(0xFF5D8FAF), // Alpine blue
                ),
                const SizedBox(height: 32),
                _buildTimelineItem(
                  title: 'Weekly Target Hit',
                  subtitle: '10 hours active time reached.',
                  time: '2 days ago',
                  icon: Icons.check_circle,
                  iconColor: const Color(0xFFb6ccb5), // Secondary green
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -32.5,
          top: -2,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.cardsCarbon,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12),
            ),
            child: Icon(icon, size: 12, color: iconColor),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primaryTextOffWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
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
              time,
              style: const TextStyle(
                color: AppColors.secondaryTextStoneGrey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
